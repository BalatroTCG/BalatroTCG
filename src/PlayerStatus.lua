
--Class
TCG_PlayerStatus = Object:extend()

function TCG_PlayerStatus:init(deck, player)

    self.is_player = player

    local backs = {}
    
    for k, v in ipairs(deck.backs) do
       backs[#backs + 1] = Back(G.P_CENTERS[v]) 
    end
    G.GAME.selected_back_key = deck.backs[1]

    local params = get_TCG_params(deck.backs)
    
    
    self.backs = backs
    self.back_key = deck.backs[1]
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
        {card_limit = 5, type = 'opponent', highlight_limit = 0})
    self.opponentConsumeables = CardArea(
        0, 0,
        CAI.consumeable_W,
        CAI.consumeable_H, 
        {card_limit = 2, type = 'opponent', highlight_limit = 0})
    self.opponentHand = CardArea(
        0, 0,
        CAI.joker_W,
        CAI.joker_H,
        {card_limit = 8, type = 'opponent', highlight_limit = 0})
    self.opponentPlay = CardArea(
        0, 0,
        CAI.joker_W,
        CAI.joker_H,
        {card_limit = 5, type = 'opponent', highlight_limit = 0})
    self.opponentDiscard = CardArea(
        0, 0,
        CAI.joker_W,
        CAI.joker_H,
        {card_limit = 1e308, type = 'opponent', highlight_limit = 0})
    self.vouchers = CardArea(
        0, 0,
        CAI.consumeable_W,
        CAI.consumeable_H,
        { type = "hand", card_limit = 2, highlight_limit = 0 }
    )
    
    if player then
        self.deck.T.x = G.TILE_W + 4
        self.deck.T.y = G.TILE_H + 4
    else
        self.deck.T.x = self.hand.T.x - 10
        self.deck.T.y = self.hand.T.y + 0.5
    end
    
    self.seed = {}
    self.seed.hashed_seed = pseudohash(G.GAME.pseudorandom.seed)
    
    self.playing_cards = {}
    
    G.GAME.viewed_back = back
    
    for k, v in ipairs(deck.cards) do
        G.playing_card = (G.playing_card and G.playing_card + 1) or 1

        local _card = deck:card_from_control_ex(self.deck, self.back_key, v)
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

    self.play_stats = {
        rounds = {},
        total_damage_given = 0,
        total_damage_taken = 0,
        total_healing = 0,
        total_purchase = 0,
        total_joker_damage = 0,
    }

    self.can_reroll = true
    
    self.visual_delay = 0
    self.highlight_delay = 0
    self.visual_transfer = {
        index = '',
    }

    self.status = {}

    self.status.max_budget = params.max_budget
    self.status.hands_left = 0
    self.status.discards_left = 0
    self.status.dollars = params.dollars
    self.status.used_vouchers = {}
    self.status.round = 1
    self.status.opponent_joker_cost = 0
    self.status.opponent_health = 0
    self.status.bankrupt_at = 0
    self.status.unused_discards = 0
    self.status.seed_reduction = 0
    self.status.last_tarot_planet = nil
    self.status.hand_upgrades = copy_table(G.GAME.hands)
    self.status.probabilities = copy_table(G.GAME.probabilities)
    self.status.consumeable_usage = copy_table(G.GAME.consumeable_usage)
    self.status.modifiers = {}
    self.status.idol_card = {}
    self.status.mail_card = {}
    self.status.castle_card = {}
    self.status.ancient_card = {}

    self.attacks = {}

    self:set_card_areas()

    BalatroTCG.Status_Current = self
    
    for k, v in ipairs(params.starting_vouchers) do
        local voucher = Card(-100, -100, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[v])
        voucher:apply_to_run()
        self.status.used_vouchers[v] = true
    end
    
    -- This is to fix a bug where the screen goes black.  Someone explain this to me please
    G.consumeables = nil
    G.jokers = nil
    G.discard = nil
    G.deck = nil
    G.hand = nil
    G.play = nil
    G.vouchers = nil
    G.graveyard = nil
end

function TCG_PlayerStatus:pass_over()
    self.params.hands = G.GAME.round_resets.hands
    self.params.discards = G.GAME.round_resets.discards
    self.status.modifiers = G.GAME.modifiers
    
    self.status.bankrupt_at = G.GAME.bankrupt_at
    self.status.unused_discards = G.GAME.unused_discards
    self.status.last_tarot_planet = G.GAME.last_tarot_planet
    self.probabilities = G.GAME.probabilities
    self.status.hand_upgrades = G.GAME.hands
    self.status.consumeable_usage = G.GAME.consumeable_usage
    self.status.used_vouchers = G.GAME.used_vouchers

    self.status.idol_card = G.GAME.current_round.idol_card
    self.status.mail_card = G.GAME.current_round.mail_card
    self.status.ancient_card = G.GAME.current_round.ancient_card
    self.status.castle_card = G.GAME.current_round.castle_card

    self.opponentJokers.config.highlighted_limit = 0

    self.visual_transfer = {
        index = '',
    }
end

function TCG_PlayerStatus:apply()

    BalatroTCG.CurrentPlayer = self

    for k, v in ipairs(self.opponentDiscard.cards) do
        v.area:remove_card(v)
        v:remove()
    end
    
    
    G.GAME.round_resets.hands = self.params.hands
    G.GAME.round_resets.discards = self.params.discards
    G.GAME.starting_deck_size = self.starting_deck_size
    G.GAME.dollars = self.status.dollars
    G.GAME.bankrupt_at = self.status.bankrupt_at

    self:set_card_areas()
    
    G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands))
    G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards)
    G.GAME.current_round.hands_played = 0
    G.GAME.current_round.discards_used = 0
    G.GAME.current_round.any_hand_drawn = nil
    
    self.status.hands_left = G.GAME.current_round.hands_left
    self.status.discards_left = G.GAME.current_round.discards_left
    
    G.GAME.selected_back_key = self.back_key
    G.GAME.selected_back:change_to(G.P_CENTERS[self.back_key])
    if G.GAME.viewed_back then
        G.GAME.viewed_back:change_to(G.P_CENTERS[self.back_key])
    else
        G.GAME.viewed_back = Back(G.P_CENTERS[self.back_key])
    end

    G.GAME.discount_percent = self.params.discount
    
    for k, v in pairs(G.GAME.hands) do 
        v.played_this_round = 0
    end

    G.GAME.round_bonus.next_hands = 0
    G.GAME.round_bonus.discards = 0

    G.GAME.pseudorandom = self.seed
    

    self.opponentJokers.config.highlighted_limit = 1
    
    G.deck:shuffle('nr' .. self.status.round)
    SMODS.calculate_context({ setting_blind = true, status = self, full_deck = self.deck, blind = G.GAME.round_resets.blind })

    for k, voucher in ipairs(self.vouchers.cards) do
        if voucher.ability.name == 'Planet Merchant' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            
            local card = pick_from_areas(function (c) return c.ability.set == 'Planet' end, {G.deck, G.discard, G.graveyard})
            if card then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                card.area:remove_card(card)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    card:start_materialize()
                    G.consumeables:emplace(card)

                    for _, c in ipairs(G.playing_cards) do
                        if c == card then
                            goto skip
                        end
                    end
                    G.GAME.consumeable_buffer = 0
                    table.insert(G.playing_cards, card)
                    ::skip::
                    play_sound('timpani')
                    voucher:juice_up(0.3, 0.4)
                    return true
                end
                }))
            end
        elseif voucher.ability.name == 'Tarot Merchant' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then

            local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
            if card then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                card.area:remove_card(card)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    card:start_materialize()
                    G.consumeables:emplace(card)

                    for _, c in ipairs(G.playing_cards) do
                        if c == card then
                            goto skip
                        end
                    end
                    table.insert(G.playing_cards, card)
                    ::skip::
                    G.GAME.consumeable_buffer = 0
                    play_sound('timpani')
                    voucher:juice_up(0.3, 0.4)
                    return true
                end
                }))
            end
        elseif voucher.ability.name == 'Omen Globe' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then

            local card = pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard})
            if card then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                card.area:remove_card(card)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    card:start_materialize()
                    G.consumeables:emplace(card)

                    for _, c in ipairs(G.playing_cards) do
                        if c == card then
                            goto skip
                        end
                    end
                    table.insert(G.playing_cards, card)
                    ::skip::
                    G.GAME.consumeable_buffer = 0
                    play_sound('timpani')
                    return true
                end
                }))
            end
        elseif voucher.ability.name == 'Telescope' then
            local _planet, _hand, _tally = nil, nil, 0
            for k, v in ipairs(G.handlist) do
                if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                    _hand = v
                    _tally = G.GAME.hands[v].played
                end
            end
            if _hand then
                for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                    if v.config.hand_type == _hand then
                        _planet = v.key
                    end
                end
                local center = G.P_CENTERS[_planet]
                for k, card in ipairs(G.deck.cards) do
                    if card.ability.name == center.name then
                        G.deck.cards[k] = G.deck.cards[#G.deck.cards]
                        G.deck.cards[#G.deck.cards] = card
                        break
                    end
                end
            end
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

function TCG_PlayerStatus:remove()
    self.jokers:remove()
    self.consumeables:remove()
    self.discard:remove()
    self.deck:remove()
    self.hand:remove()
    self.play:remove()
    self.graveyard:remove()
    self.opponentJokers:remove()
    self.vouchers:remove()
    
    self.jokers = nil
    self.consumeables = nil
    self.discard = nil
    self.deck = nil
    self.hand = nil
    self.play = nil
    self.graveyard = nil
    self.opponentJokers = nil
    self.vouchers = nil
end

function TCG_PlayerStatus:set_card_areas()
    G.playing_cards = self.playing_cards
    G.consumeables = self.consumeables
    G.jokers = self.jokers
    G.discard = self.discard
    G.deck = self.deck
    G.hand = self.hand
    G.play = self.play
    G.vouchers = self.vouchers
    G.graveyard = self.graveyard

    G.GAME.used_vouchers = self.status.used_vouchers
    G.GAME.modifiers = self.status.modifiers
    
    G.GAME.current_round.idol_card = self.status.idol_card
    G.GAME.current_round.mail_card = self.status.mail_card
    G.GAME.current_round.ancient_card = self.status.ancient_card
    G.GAME.current_round.castle_card = self.status.castle_card
    G.GAME.last_tarot_planet = self.status.last_tarot_planet
    G.GAME.probabilities = self.status.probabilities
    G.GAME.consumeable_usage = self.status.consumeable_usage
    G.GAME.hands = self.status.hand_upgrades
end
    
function TCG_PlayerStatus:receive_message(message)
    
    if message.type == 'back' then
        self.Other.back_key = message.back
        
    elseif message.type == 'startTurn' or message.type == 'attack' then
        
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
    elseif message.type == 'opponent_play' then

    elseif message.type == 'opponent_status' and self.is_player then
        self.status.opponent_joker_cost = tonumber(message.joker_cost)

        local highlighted_cards = {}

        for str in string.gmatch(message.highlighted, "(%d+),") do
            highlighted_cards[#self.opponentHand.cards - tonumber(str) + 1] = true
        end

        for i, card in ipairs(self.opponentHand.cards) do
            card.highlighted = false
            if highlighted_cards[i] then
                card.highlighted = true
            end
        end

        highlighted_cards = {}

        for str in string.gmatch(message.play_highlighted, "(%d+),") do
            highlighted_cards[tonumber(str)] = true
        end

        for i, card in ipairs(self.opponentPlay.cards) do
            card.highlighted = false
            if highlighted_cards[i] then
                card.highlighted = true
            end
        end

    elseif message.type == 'opponent_hand' and self.is_player then

        
        if message.from ~= message.to then
            local from = self:string_to_fake_area(message.from)
            local to = self:string_to_fake_area(message.to)

            to = to or self.opponentDiscard

            local indices = splitlines(message.index, ',')
            local bases = splitlines(message.card_base, ',')
            local sets = splitlines(message.card_set, ',')

            for i = 1, #indices do
                G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.05, func = function() 

                    if from and #from.cards >= 1 then
                        local index = indices[i]
                        local card_base = bases[i]
                        local card_set = sets[i]

                        local card = from.cards[#from.cards - math.min(tonumber(index), #from.cards) + 1]
                        
                        if not card_base or card_base == 'back' then
                            if card.facing ~= 'back' then
                                card:flip()
                            end
                        else
                            
                            card.ability.set = card_set
                            if card.ability.set == 'Default' then
                                card:set_base(G.P_CARDS[card_base])
                            else

                                if card.ability.set == 'Tarot' then
                                    card:set_ability(G.P_CENTERS['c_hermit'])
                                elseif card.ability.set == 'Spectral' then
                                    card:set_ability(G.P_CENTERS['c_deja_vu'])
                                elseif card.ability.set == 'Planet' then
                                    card:set_ability(G.P_CENTERS['c_mercury'])
                                -- TARGET: Default display
                                else
                                    card:set_ability(G.P_CENTERS['j_joker'])
                                end
                                card.config.center = copy_table(card.config.center)

                                card.bypass_discovery_center  = false
                                card.config.center.discovered = false

                                card:set_sprites(card.config.center, nil)
                                card.children.front:remove()
                                card.children.front = nil
                            end
                            
                            if card.facing == 'back' then
                                card:flip()
                            end
                        end

                        from:remove_card(card)
                        to:emplace(card, nil, true)
                    else
                        local card = Card(to.T.x, to.T.y, G.CARD_W, G.CARD_H, G.P_CARDS['S_A'], G.P_CENTERS['c_base'], {playing_card = G.playing_card, tcg_back = self.Other.back_key})
                        card:flip()
                        card.states.drag.can = false
                        to:emplace(card, nil, true)
                        to:align_cards()
                    end

                    return true
                end
                }))

            end
        end

        -- local count = tonumber(message.joker_count)
        -- if #self.opponentJokers.cards ~= count then
            
        --     while #self.opponentJokers.cards > count do
        --         self.opponentJokers.cards[1]:start_dissolve()
        --         self.opponentJokers:remove_card(self.opponentJokers.cards[1])
        --     end

        --     while #self.opponentJokers.cards < count do
                
        --         local card = Card(self.opponentJokers.T.x, self.opponentJokers.T.y, G.CARD_W, G.CARD_H, G.P_CARDS['S_A'], G.P_CENTERS['c_base'], {playing_card = G.playing_card, tcg_back = self.Other.back_key})
        --         card:flip()
        --         card.states.drag.can = false
        --         self.opponentJokers:emplace(card, nil, true)
        --     end

        --     if #self.opponentJokers.cards > 1 then 
        --         G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
        --             G.E_MANAGER:add_event(Event({ func = function() self.opponentJokers:shuffle('aajk'); return true end })) 
        --             delay(0.05)
        --             G.E_MANAGER:add_event(Event({ func = function() self.opponentJokers:shuffle('aajk'); return true end })) 
        --             delay(0.05)
        --             G.E_MANAGER:add_event(Event({ func = function() self.opponentJokers:shuffle('aajk'); return true end })) 
        --             delay(0.05)
        --         return true end })) 
        --     end

        --     self.opponentJokers:align_cards()
        -- end
        
        -- count = tonumber(message.hand_size)
        -- if #self.opponentHand.cards ~= count then
            
        --     while #self.opponentHand.cards > count do
        --         self.opponentHand.cards[1]:start_dissolve()
        --         self.opponentHand:remove_card(self.opponentHand.cards[1])
        --     end

        --     while #self.opponentHand.cards < count do
                
        --         local card = Card(self.opponentHand.T.x, self.opponentHand.T.y, G.CARD_W, G.CARD_H, G.P_CARDS['S_A'], G.P_CENTERS['c_base'], {playing_card = G.playing_card, tcg_back = self.Other.back_key})
        --         card:flip()
        --         card.states.drag.can = false
        --         self.opponentHand:emplace(card, nil, true)
        --     end

        --     -- add shuffle

        --     self.opponentHand:align_cards()
        -- end

        -- count = tonumber(message.consumeables)
        -- if #self.opponentConsumeables.cards ~= count then
            
        --     while #self.opponentConsumeables.cards > count do
        --         self.opponentConsumeables.cards[1]:start_dissolve()
        --         self.opponentConsumeables:remove_card(self.opponentConsumeables.cards[1])
        --     end

        --     while #self.opponentConsumeables.cards < count do
                
        --         local card = Card(self.opponentConsumeables.T.x, self.opponentConsumeables.T.y, G.CARD_W, G.CARD_H, G.P_CARDS['S_A'], G.P_CENTERS['c_base'], {playing_card = G.playing_card, tcg_back = self.Other.back_key})
        --         card:flip()
        --         card.states.drag.can = false
        --         self.opponentConsumeables:emplace(card, nil, true)
        --     end

        --     -- add shuffle

        --     self.opponentConsumeables:align_cards()
        -- end
        

    end
end

function TCG_PlayerStatus:area_to_string(area)
    if area == self.play then
        return 'play'
    elseif area == self.jokers then
        return 'jokers'
    elseif area == self.graveyard then
        return 'graveyard'
    elseif area == self.discard then
        return 'discard'
    elseif area == self.hand then
        return 'hand'
    elseif area == self.consumeables then
        return 'consumeables'
    end

    return 'unknown'
end

function TCG_PlayerStatus:string_to_fake_area(string)
    if string == 'play' then
        return self.opponentPlay
    elseif string == 'jokers' then
        return self.opponentJokers
    elseif string == 'discard' then
        return self.opponentDiscard
    elseif string == 'hand' then
        return self.opponentHand
    elseif string == 'consumeables' then
        return self.opponentConsumeables
    end

    return nil
end

function TCG_PlayerStatus:setup_visuals(card, area, start_area)
    if not area or
        (area == self.play or
        area == self.jokers or
        area == self.graveyard or
        area == self.discard or
        area == self.hand or
        area == self.consumeables) then

        if card then
            local transfer = {
                from = 'unknown',
                to = 'unknown',
            }
            transfer.from = self:area_to_string(start_area or card.last_area)
            transfer.index = 1

            if card.area then
                for i, c in ipairs(card.area.cards) do
                    if card == c then
                        transfer.index = i
                        break
                    end
                end
            end

            
            transfer.to = self:area_to_string(area)
            
            if transfer.from == 'hand' and transfer.to == 'play' then
                
                if card:is_playing_card() then
                    transfer.card_set = 'Default'
                    transfer.card_base = card.config.card_key
                else
                    transfer.card_set = card.ability.set
                    transfer.card_base = 'item'
                end
            else
                transfer.card_set = 'x'
                transfer.card_base = 'back'
            end


            if self.visual_transfer.from and (not BalatroTCG.MP_Lobby or transfer.from ~= self.visual_transfer.from or transfer.to ~= self.visual_transfer.to) then
                self:send_visuals()
            end

            self.visual_transfer.from = self.visual_transfer.from or transfer.from
            self.visual_transfer.to = self.visual_transfer.to or transfer.to
            
            self.visual_transfer.index = (self.visual_transfer.index or '') .. tostring(transfer.index) .. ','
            self.visual_transfer.card_set = (self.visual_transfer.card_set or '') .. tostring(transfer.card_set) .. ','
            self.visual_transfer.card_base = (self.visual_transfer.card_base or '') .. tostring(transfer.card_base) .. ','

            self.visual_delay = 0
            
        end
    end

    self:send_status()
end

function TCG_PlayerStatus:check_visuals()
    if self.highlight_delay > 0 then
        self.highlight_delay = self.highlight_delay + 1
        if self.highlight_delay > 5 then
            self.highlight_delay = 0
            
            self:send_message(self.highlight_message)
        end
    end

    if not self.visual_transfer.from then return end

    self.visual_delay = self.visual_delay + 1

    if self.visual_delay > 5 then
        self:send_visuals()
    end
end
function TCG_PlayerStatus:send_visuals()
    self.visual_delay = 0
    
    self.visual_transfer.type = 'opponent_hand'
    self:send_message(self.visual_transfer)

    self.visual_transfer = {
        index = '',
    }
end
function TCG_PlayerStatus:send_status()

    if not BalatroTCG.GameStarted or not self.jokers then
        return
    end
    local cost = 0
    for _, joker in ipairs(self.jokers.cards) do
        joker:set_cost()
        cost = joker.sell_cost
    end
    local highlighted = ''
    for i, card in ipairs(self.hand.cards) do
        if card.highlighted then
            highlighted = highlighted .. i .. ','
        end
    end
    local play_highlighted = ''
    for i, card in ipairs(self.play.cards) do
        if card.highlighted then
            play_highlighted = play_highlighted .. i .. ','
        end
    end
    
    if BalatroTCG.MP_Lobby then
        self.highlight_delay = 1

        self.highlight_message = {
            type = 'opponent_status',
            joker_cost = cost,
            highlighted = highlighted,
            play_highlighted = play_highlighted,
        }
    else
        self:send_message({
            type = 'opponent_status',
            joker_cost = cost,
            highlighted = highlighted,
            play_highlighted = play_highlighted,
        })
    end
end

function TCG_PlayerStatus:add_protection(protect)
    self.temp_safety[#self.temp_safety + 1] = protect
end

function TCG_PlayerStatus:take_attacks()
    
    if not self.has_rerolled and G.GAME.chips_damage_text == '0' and G.GAME.chips_damage <= 0 then
        self.can_reroll = true
    end

    for k, att in pairs(self.attacks) do
        
        if att.triggering then goto continue end

        att.triggering = true
        attacks = true
        
        G.E_MANAGER:add_event(Event({
            
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

                local at_player = att.index == 0 and att.damage or 0
        
                for k, v in ipairs(return_table) do
                    if v.percent then
                        
                        if att.damage > 0 then
                            att.damage = math.floor(att.damage * (1 - v.percent))
                            G.E_MANAGER:add_event(Event({
                                
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

                if att.damage > 0 and (G.GAME.modifiers.damage_reduction or 0) > 0 then
                    att.damage = math.max(att.damage - G.GAME.modifiers.damage_reduction, 0)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                        play_sound('tarot1')
                        G.GAME.chips_damage = math.max(G.GAME.chips_damage - G.GAME.modifiers.damage_reduction, 0)
                        return true
                    end
                    }))
                    delay(0.3)
                end
                
                
                G.E_MANAGER:add_event(Event({
                    
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

                    if at_player then
                        local reduced = at_player - att.damage

                        if reduced > 0 then
                            self:add_play_stats('damage_saved', G.GAME.chips_damage, self.status.round)
                        end
                    end
            
                    if joker and joker.ability.eternal then
                        joker = nil
                    end
            
                    self.has_rerolled = false
                    if joker == nil then 
                        local damage = G.GAME.chips_damage

                        self:damage(damage)
                    else
                        
                        self:add_play_stats('joker_damage', G.GAME.chips_damage, self.status.round)

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

        ::continue::
    end

end

function TCG_PlayerStatus:send_message(message)
    if MP and MP.LOBBY and MP.LOBBY.code then
        message.action = "tcgPlayerStatus"
        Client.send(message)
    else
        self.Other:receive_message(message)
    end
end

function TCG_PlayerStatus:add_play_stats(stat, amount, round)
    self.play_stats.rounds[round] = self.play_stats.rounds[round] or {
        damage_given = 0,
        damage_taken = 0,
        healing = 0,
        purchase = 0,
        joker_damage = 0,
    }

    self.play_stats['total_' .. stat] = (self.play_stats['total_' .. stat] or 0) + amount
    self.play_stats.rounds[self.status.round][stat] = (self.play_stats.rounds[self.status.round][stat] or 0) + amount
end

function TCG_PlayerStatus:damage(amount)
    if amount <= 0 then return end

    self.status.dollars = self.status.dollars - amount
    G.GAME.dollars = self.status.dollars

    self:add_play_stats('damage_taken', amount, self.status.round)


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

        self.vouchers.T.x = self.deck.T.x - 1
        self.vouchers.T.y = self.deck.T.y + 2.75

        self.opponentConsumeables.T.x = self.opponentJokers.T.x + self.opponentJokers.T.w + 0.2
        self.opponentConsumeables.T.y = self.opponentJokers.T.y - 5

        self.opponentHand.T.x = self.opponentJokers.T.x
        self.opponentHand.T.y = self.opponentJokers.T.y - 5

        self.opponentPlay.T.x = self.opponentJokers.T.x
        self.opponentPlay.T.y = self.opponentJokers.T.y - 4

        self.opponentDiscard.T.x = -10
        self.opponentDiscard.T.y = -2

    else
        self.hand.T.x = 0
        self.hand.T.y = -50

        self.opponentJokers.T.x = 0
        self.opponentJokers.T.y = -100
        
        -- if not _RELEASE_MODE then
        --     self.hand.T.x = G.TILE_W - self.hand.T.w - 2.85
        --     self.hand.T.y = G.TILE_H - self.hand.T.h
        --     self.hand.T.y = self.hand.T.y - 5.5
        -- end
        
        if not _RELEASE_MODE then
            self.opponentJokers.T.x = 0
            self.opponentJokers.T.y = 0
        end

        self.opponentConsumeables.T.x = self.opponentJokers.T.x + self.opponentJokers.T.w + 0.2
        self.opponentConsumeables.T.y = self.opponentJokers.T.y

        self.opponentHand.T.x = self.opponentJokers.T.x
        self.opponentHand.T.y = self.opponentJokers.T.y + 2

        self.opponentPlay.T.x = self.opponentHand.T.x
        self.opponentPlay.T.y = self.opponentHand.T.y + 0.5
            
        self.opponentDiscard.T.x = -10
        self.opponentDiscard.T.y = 5


        self.play.T.x = self.hand.T.x
        self.play.T.y = self.hand.T.y

        self.jokers.T.x = self.hand.T.x
        self.jokers.T.y = self.hand.T.y - 1.5

        self.consumeables.T.x = self.hand.T.x + 10
        self.consumeables.T.y = self.hand.T.y

        self.deck.T.x = self.hand.T.x - 10
        self.deck.T.y = self.hand.T.y + 0.5

        self.discard.T.x = self.hand.T.x - 10
        self.discard.T.y = self.hand.T.y

        self.vouchers.T.x = self.discard.T.x
        self.vouchers.T.y = self.discard.T.y

    end

    self.graveyard.T.x = self.discard.T.x
    self.graveyard.T.y = self.discard.T.y - 3.5
    

    self.hand:hard_set_VT()
    self.play:hard_set_VT()
    self.jokers:hard_set_VT()
    self.consumeables:hard_set_VT()
    self.deck:hard_set_VT()
    self.discard:hard_set_VT()
    self.graveyard:hard_set_VT()
    self.vouchers:hard_set_VT()
    
end