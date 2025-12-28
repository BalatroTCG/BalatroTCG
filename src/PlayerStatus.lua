
--Class
TCG_PlayerStatus = Object:extend()

function TCG_PlayerStatus:init(deck, player)

    self.is_player = player

    local back = Back(get_deck_from_name(deck.back))
    G.GAME.selected_back_key = deck.back

    if deck.back == 'Green Deck' then
        back.calculate_deck = function(context)
            if context.end_of_round and G.GAME.current_round.discards_left > 0 then
                ease_dollars(G.GAME.current_round.discards_left * 2)
            end
        end
    elseif deck.back == 'Plasma Deck' then
        back.calculate_deck = function(context)
            if context.damaging then
                local hurt = math.floor(context.damage / 4) * 1
                if hurt > 0 then context.status:damage(hurt) end
            end
        end
    elseif deck.back == 'Anaglyph Deck' then
        back.calculate_deck = function(context)
            if context.start_of_round and math.fmod(context.status.status.round, 3) == 0 then
                ease_hands_played(1)
                ease_discard(1)
            end
        end
    end

    local params = get_TCG_params(deck.back)
    
    self.back = back
    self.back_key = deck.back
    self.params = params

    local CAI = {
        discard_W = G.CARD_W,
        discard_H = G.CARD_H,
        deck_W = G.CARD_W*1.1,
        deck_H = 0.95*G.CARD_H,
        hand_W = 6*G.CARD_W,
        hand_H = 0.95*G.CARD_H,
        play_W = 5.3*G.CARD_W,
        play_H = 0.95*G.CARD_H,
        joker_W = 4.9*G.CARD_W,
        joker_H = 0.95*G.CARD_H,
        consumeable_W = 2.3*G.CARD_W,
        consumeable_H = 0.95*G.CARD_H
    }

    self.consumeables = CardArea(
        0, 0,
        CAI.consumeable_W,
        CAI.consumeable_H, 
        {card_limit = params.consumable_slots, type = 'joker', highlight_limit = 1})

    self.jokers = CardArea(
        0, 0,
        CAI.joker_W,
        CAI.joker_H, 
        {card_limit = params.joker_slots, type = 'joker', highlight_limit = 1})

    self.discard = CardArea(
        0, 0,
        CAI.discard_W,CAI.discard_H,
        {card_limit = 500, type = 'discard'})
    self.deck = CardArea(
        0, 0,
        CAI.deck_W,CAI.deck_H, 
        {card_limit = 60, type = 'deck'})
    self.hand = CardArea(
        0, 0,
        CAI.hand_W,CAI.hand_H, 
        {card_limit = params.hand_size, type = 'hand'})
    self.play = CardArea(
        0, 0,
        CAI.play_W,CAI.play_H, 
        {card_limit = 5, type = 'play'})
    self.graveyard = CardArea(
        0, 0,
        CAI.deck_W, CAI.deck_H, 
        {card_limit = 750, type = 'discard'})
    self.opponentJokers = CardArea(
        0, 0,
        CAI.joker_W,
        CAI.joker_H,
        {card_limit = 2, type = 'opponent', highlight_limit = 1})

    
    self.seed = {}
    self.seed.hashed_seed = pseudohash(G.GAME.pseudorandom.seed)
    
    self.playing_cards = {}
    
    G.GAME.viewed_back = back
    
    for k, v in ipairs(deck.cards) do
        G.playing_card = (G.playing_card and G.playing_card + 1) or 1

        local _card = deck:card_from_control_ex(self.deck, { is_player = self.is_player }, v)
        self.deck:emplace(_card)
        table.insert(self.playing_cards, _card)
        if _card.ability.set == 'Joker' then
            _card:set_tcg_max_health(self.params.joker_health)
        end
        
    end
    
    self.starting_deck_size = #self.playing_cards
    
    table.sort(self.playing_cards, function (a, b) return a.playing_card > b.playing_card end )
    
    self.deck:hard_set_T()
    self.deck:align_cards()
    self.deck:hard_set_cards()
    
    self.temp_safety = {}

    self.status = {}

    self.status.dollars = params.dollars
    self.status.round = 1
    self.status.opponent_jokers = 0
    self.status.opponent_joker_cost = 0
    self.status.opponent_health = 50
    self.status.bankrupt_at = 0
    self.status.unused_discards = 0
    self.status.last_tarot_planet = nil
    self.status.hand_upgrades = copy_table(G.GAME.hands)
    self.status.probabilities = copy_table(G.GAME.probabilities)
    self.status.consumeable_usage = copy_table(G.GAME.consumeable_usage)

    self.attacks = {}
end

function TCG_PlayerStatus:pass_over()
    self.status.bankrupt_at = G.GAME.bankrupt_at
    self.status.unused_discards = G.GAME.unused_discards
    self.status.last_tarot_planet = G.GAME.last_tarot_planet
    self.probabilities = G.GAME.probabilities
    self.status.hand_upgrades = G.GAME.hands
    self.status.consumeable_usage = G.GAME.consumeable_usage
end

function TCG_PlayerStatus:apply()

    BalatroTCG.CurrentPlayer = self
    
    G.GAME.hands = self.status.hand_upgrades
    
    G.GAME.round_resets.hands = self.params.hands
    G.GAME.round_resets.discards = self.params.discards
    G.GAME.starting_deck_size = self.starting_deck_size
    G.GAME.last_tarot_planet = self.status.last_tarot_planet
    G.GAME.probabilities = self.status.probabilities
    G.GAME.consumeable_usage = self.status.consumeable_usage
    G.GAME.dollars = self.status.dollars
    G.GAME.bankrupt_at = self.status.bankrupt_at
    
    G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands))
    G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards)
    G.GAME.current_round.hands_played = 0
    G.GAME.current_round.discards_used = 0
    G.GAME.current_round.any_hand_drawn = nil

    G.GAME.discount_percent = self.params.discount
    
    for k, v in pairs(G.GAME.hands) do 
        v.played_this_round = 0
    end

    G.GAME.round_bonus.next_hands = 0
    G.GAME.round_bonus.discards = 0

    G.GAME.pseudorandom = self.seed
    
    G.playing_cards = self.playing_cards

    G.consumeables = self.consumeables
    G.jokers = self.jokers
    G.discard = self.discard
    G.deck = self.deck
    G.hand = self.hand
    G.play = self.play
    G.graveyard = self.graveyard
    G.opponentJokers = self.opponentJokers
    
    G.deck:shuffle('nr' .. self.status.round)
    SMODS.calculate_context({setting_blind = true, blind = G.GAME.round_resets.blind})

    if self.back.calculate_deck then
        self.back.calculate_deck({ start_of_round = true, status = self, full_deck = self.deck})
    end
    
    for k, joker in ipairs(self.jokers.cards) do
        if joker.ability.d_size > 0 then
            ease_discard(joker.ability.d_size)
        end
    end
    

    for k, v in ipairs(self.playing_cards) do 
        v:set_cost()
    end
    for k, v in ipairs(self.graveyard) do 
        v:set_cost()
    end
    
    for _, joker in ipairs(self.jokers.cards) do
        joker.states.drag.can = true
        joker.states.collide.can = true
        if joker.facing == 'back' then joker:flip() end
    end
    for _, joker in ipairs(self.opponentJokers.cards) do
        joker.states.collide.can = true
    end
    
    
    reset_idol_card()
    reset_mail_rank()
    reset_ancient_card()
    reset_castle_card()
end


function TCG_PlayerStatus:receive_message(message)
    
    if message.type == 'back' then
        self.Other.back = Back(get_deck_from_name(message.back))
        
    elseif message.type == 'ready' then
		G.SETTINGS.paused = false
		G.FUNCS.exit_overlay_menu()

        message.damage = tonumber(message.damage)
        self:receive_message({type = 'attack', damage = message.damage})
        switch_player(message.starting == 'true')
        
    elseif message.type == 'attack' then
        self.attacks[#self.attacks + 1] = {
            damage = tonumber(message.damage),
            index = tonumber(message.index),
        }
        
    elseif message.type == 'win_game' then
        end_tcg_game(true)
    elseif message.type == 'lose_game' then
        end_tcg_game(false)
    elseif message.type == 'healthEcho' then
        self.status.opponent_health = message.health
    elseif message.type == 'health' then
        self.status.opponent_health = message.health
        self:send_message({ type = "healthEcho", health = self.status.dollars })
    elseif message.type == 'joker_cost' then
        self.status.opponent_joker_cost = tonumber(message.amount)
    elseif message.type == 'jokers' then
        self.status.opponent_jokers = tonumber(message.jokers)

        if #self.opponentJokers.cards ~= self.status.opponent_jokers then
            
            while #self.opponentJokers.cards > self.status.opponent_jokers do
                self.opponentJokers.cards[1]:start_dissolve()
                self.opponentJokers:remove_card(self.opponentJokers.cards[1])
            end
            local bypass_back = Back(get_deck_from_name(self.Other.back_key)).pos

            while #self.opponentJokers.cards < self.status.opponent_jokers do
                
                local card = Card(self.opponentJokers.T.x, self.opponentJokers.T.y, G.CARD_W, G.CARD_H, G.P_CARDS['S_A'], G.P_CENTERS['c_base'], {playing_card = G.playing_card, bypass_back = self.Other.back.pos})
                card:flip()
                card.states.drag.can = false

                self.opponentJokers:emplace(card, nil, true)
            end

            self.opponentJokers:align_cards()
        end
    end
end

function TCG_PlayerStatus:add_protection(protect)
    self.temp_safety[#self.temp_safety + 1] = protect
end

function TCG_PlayerStatus:take_attacks()
    
    for k, att in ipairs(self.attacks) do
        
        G.E_MANAGER:add_event(Event({
            no_delete = true,
            trigger = 'immediate',
            func = function()
            

            if self.is_player then
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blocking = true,
                    ref_table = G.GAME,
                    ref_value = 'chips_damage',
                    ease_to = att.damage,
                    delay = 0.2,
                    func = (function(t) return math.floor(t) end)
                }))
                
                delay(0.5)
            else
                G.GAME.chips_damage = att.damage
            end

            G.E_MANAGER:add_event(Event({
                no_delete = true,
                trigger = 'immediate',
                func = function()
                local return_table = {}
                if self.jokers then
                    table.sort(self.jokers.cards, function(a,b) return a.T.x < b.T.x end)
                    for _, joker in ipairs(self.jokers.cards) do
                        local value = joker:calculate_joker({tcg_take_damage = true, damage = att.damage })
                        if value then
                            value.activator = joker
                            return_table[#return_table + 1] = value
                        end
                    end
                end
                return_table = tableMerge(return_table, self.temp_safety)
                self.temp_safety = {}
        
                local joker = nil
        
                for k, v in ipairs(return_table) do
                    if v.percent then
                        
                        if att.damage > 0 then
                            att.damage = math.floor(att.damage * (1 - v.percent))
                            G.E_MANAGER:add_event(Event({
                                no_delete = true,
                                trigger = 'after',
                                func = function()
                                play_sound('tarot1')
                                if v.activator then v.activator:juice_up(0.3, 0.5) end
                                G.GAME.chips_damage = math.floor(G.GAME.chips_damage * (1 - v.percent))
                                return true
                            end
                            }))
                            delay(0.3)
                        end
                    elseif v.reduce then
        
                        if att.damage > 0 then
                            att.damage = math.max(att.damage - v.reduce, 0)
                            G.E_MANAGER:add_event(Event({
                                no_delete = true,
                                trigger = 'after',
                                func = function()
                                play_sound('tarot1')
                                if v.activator then v.activator:juice_up(0.3, 0.5) end
                                G.GAME.chips_damage = math.max(G.GAME.chips_damage - v.reduce, 0)
                                return true
                            end
                            }))
                            delay(0.3)
                        end
                    elseif v.redirect then

                        joker = v.redirect
                        att.index = 0
        
                        G.E_MANAGER:add_event(Event({
                            no_delete = true,
                            trigger = 'after',
                            func = function()
                            play_sound('tarot1')
                            if v.activator then v.activator:juice_up(0.3, 0.5) end
                            return true
                        end
                        }))
                        delay(0.3)
                    end
                end
                delay(0.5)
                
                G.E_MANAGER:add_event(Event({
                    no_delete = true,
                    trigger = 'after',
                    func = function()
                    if self.jokers then
                        for _, j in ipairs(self.jokers.cards) do
                            att.index = att.index - 1
                            if att.index == 0 then
                                joker = j
                            end
                        end
                    end
            
                    if joker and joker.ability.eternal then
                        joker = nil
                    end
            
                    if joker == nil then 
                        local damage = G.GAME.chips_damage

                        self:damage(damage)
                    else
                        joker:remove_tcg_health(G.GAME.chips_damage)
                        if self.is_player then
                            play_sound('glass'..math.random(1, 6), math.random()*0.2 + 0.9,0.5)
                        end
                        joker:juice_up(0.3, 0.5)
                    end

                    G.GAME.chips_damage = 0
                    return true
                end
                }))
                return true
            end
            }))

            return true
        end
        }))
    end

    self.attacks = {}
end

function TCG_PlayerStatus:send_message(message)
    if MP and MP.LOBBY and MP.LOBBY.code then
        message.action = "tcgPlayerStatus"
        Client.send(message)
    else
        self.Other:receive_message(message)
    end
end

function TCG_PlayerStatus:damage(amount)
    if amount <= 0 then return end

    self.status.dollars = self.status.dollars - amount
    G.GAME.dollars = self.status.dollars

    self:send_message({ type = "health", health = self.status.dollars })
    
    if self.is_player then
        local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI')
        amount = amount or 0
        local text = '+'..localize('$')
        local col = G.C.MONEY
        if amount > 0 then
            text = '-'..localize('$')
            col = G.C.RED
        end
        
        --Ease from current chips to the new number of chips
        
        
        dollar_UI.config.object:update()
        --Popup text next to the chips in UI showing number of chips gained/lost
        attention_text({
            text = text..tostring(math.abs(amount)),
            scale = 0.8, 
            hold = 0.7,
            cover = dollar_UI.parent,
            cover_colour = col,
            align = 'cm',
        })
        --Play a chip sound
        play_sound('coin1')
    end
    
    if G.GAME.dollars <= G.GAME.bankrupt_at then
        end_tcg_game(not self.is_player)
    end
    
    
    G.HUD:recalculate()
    
end

function TCG_PlayerStatus:hard_set()
    
    self.hand:hard_set_cards()
    self.play:hard_set_cards()
    self.jokers:hard_set_cards()
    self.consumeables:hard_set_cards()
    self.deck:hard_set_cards()
    self.discard:hard_set_cards()
    self.graveyard:hard_set_cards()
end

function TCG_PlayerStatus:set_screen_positions()
    
    if self.is_player then
        self.hand.T.x = G.TILE_W - self.hand.T.w - 2.85
        self.hand.T.y = G.TILE_H - self.hand.T.h

        self.play.T.x = self.hand.T.x + (self.hand.T.w - self.play.T.w)/2
        self.play.T.y = self.hand.T.y - 3.6

        self.jokers.T.x = self.hand.T.x - 0.1
        self.jokers.T.y = 0.5

        self.opponentJokers.T.x = self.jokers.T.x
        self.opponentJokers.T.y = self.jokers.T.y - 3.25
        
        self.consumeables.T.x = self.jokers.T.x + self.jokers.T.w + 0.2
        self.consumeables.T.y = self.jokers.T.y

        self.deck.T.x = G.TILE_W - self.deck.T.w - 0.5
        self.deck.T.y = G.TILE_H - self.deck.T.h

        self.discard.T.x = self.jokers.T.x + self.jokers.T.w/2 + 0.3 + 15
        self.discard.T.y = 4.2

        self.graveyard.T.x = self.discard.T.x
        self.graveyard.T.y = self.discard.T.y - 3.5
    else
        self.hand.T.x = 0
        self.hand.T.y = -50

        self.opponentJokers.T.x = 0
        self.opponentJokers.T.y = -100
        
        if not _RELEASE_MODE then
            self.hand.T.x = G.TILE_W - self.hand.T.w - 2.85
            self.hand.T.y = G.TILE_H - self.hand.T.h
            self.hand.T.y = self.hand.T.y - 5.5
        end

        self.play.T.x = self.hand.T.x
        self.play.T.y = self.hand.T.y

        self.jokers.T.x = self.hand.T.x
        self.jokers.T.y = self.hand.T.y - 1.5

        self.consumeables.T.x = self.hand.T.x + 10
        self.consumeables.T.y = self.hand.T.y

        self.deck.T.x = self.hand.T.x - 10
        self.deck.T.y = self.hand.T.y

        self.discard.T.x = self.hand.T.x - 10
        self.discard.T.y = self.hand.T.y

        self.graveyard.T.x = self.hand.T.x - 10
        self.graveyard.T.y = self.hand.T.y

    end

    self.hand:hard_set_VT()
    self.play:hard_set_VT()
    self.jokers:hard_set_VT()
    self.consumeables:hard_set_VT()
    self.deck:hard_set_VT()
    self.discard:hard_set_VT()
    self.graveyard:hard_set_VT()
    
end