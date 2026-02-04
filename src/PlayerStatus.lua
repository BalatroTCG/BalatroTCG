
--Class
TCG_PlayerStatus = Moveable:extend()

function TCG_PlayerStatus:init(deck, player)
    Moveable.init(self, -10, -20, 2, 1)

    self.children = {}
    self.config = {}
    self.tilt_var = {mx = 0, my = 0, amt = 0}
    self.ambient_tilt = 0.3
    --self.zoom = true
    self.states.collide.can = true
    self.shadow_height = 0
    
    self.is_player = player

    self:set_backs(deck.backs)
    
    local params = get_TCG_params(deck.backs)
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

    self.adjusting_display = false
    self.opponent_joker_display = ''
    self.opponent_consumeable_display = ''

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
    self.status.consumeable_usage_total = copy_table(G.GAME.consumeable_usage_total)
    self.status.modifiers = {}
    self.status.idol_card = {}
    self.status.mail_card = {}
    self.status.castle_card = {}
    self.status.ancient_card = {}

    self.attacks = {}

    self:set_card_areas()

    BalatroTCG.Status_Current = self
    
    
    -- This is to fix a bug where the screen goes black.  Someone explain this to me please
    G.consumeables = nil
    G.jokers = nil
    G.discard = nil
    G.deck = nil
    G.hand = nil
    G.play = nil
    G.vouchers = nil
    G.graveyard = nil
    
    self.status.discount = G.GAME.discount_percent
    
end

function TCG_PlayerStatus:send_backs()
    local backs = ''
    for k, v in pairs(self.backs) do
        for k2, v2 in pairs(G.P_CENTERS) do
            if v2.name == v.name then
                backs = backs .. k2 .. ';'
            end
        end
    end
    self:send_message({ type = 'backs', backs = backs })
end

function TCG_PlayerStatus:set_backs(backs)
    
    for k, v in ipairs(self.children) do
        v:remove()
    end
    self.children = {}

    self.backs = {}
    self.back_key = backs[1]
    
    self.states.collide.can = true
    self.states.drag.can = true

    --G.GAME.selected_back_key = backs[1]

    for k, v in ipairs(backs) do
        local backCenter = G.P_CENTERS[v]
        local data = BalatroTCG.DeckData.get(v)

        if not backCenter then goto continue end

        self.backs[#self.backs + 1] = Back(backCenter)
        if data.calculate_context then
            self.backs[#self.backs].calculate_deck = data.calculate_context
        end

        ::continue::

        if not player then

            local sprite = AnimatedSprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ANIMATION_ATLAS[data.icon_atlas], data.icon_pos)
            
            sprite.states = self.states
            sprite.states.visible = true
            
            if k == 1 then
                sprite.states.drag.can = true
            end

            self.children[k] = sprite
        end

    end
end

function TCG_PlayerStatus:draw()

    self.tilt_var = self.tilt_var or {}
    self.tilt_var.mx, self.tilt_var.my =G.CONTROLLER.cursor_position.x,G.CONTROLLER.cursor_position.y

    for k, v in pairs(self.children) do
        if k == 1 then
            v.role.draw_major = self
            v.VT.scale = 0.8
            v:draw_shader('dissolve', 0.1)
            v:draw_shader('dissolve')
        else
            v.VT.scale = 0.3
            v:draw()
        end
    end

    add_to_drawhash(self)
end

function TCG_PlayerStatus:align()
    
    local x, y, r = 0, 0, 0

    for k, v in pairs(self.children) do
        if k == 1 then
            if not v.states.drag.is then
                v.T.r = 0.02*math.sin(2*G.TIMERS.REAL+self.T.x)

                v.T.y = self.T.y + 0.03*math.sin(0.666*G.TIMERS.REAL+self.T.x) - 0.4

                self.shadow_height = 0.1 - (0.04 + 0.03*math.sin(0.666*G.TIMERS.REAL+self.T.x))

                v.T.x = self.T.x + 0.03*math.sin(0.436*G.TIMERS.REAL+self.T.x) - 0.1
                
            end
            x, y, r = v.T.x, v.T.y, v.T.r
        else
            local angle = (k - 1.5) * 6.262 / (#self.children - 1) - r
            --angle = lerp(angle, 3.1415, 0.3)
            v.T.x = x - math.sin(angle)
            v.T.y = y + math.cos(angle)
            v.T.r = r
        end
    end
end

function TCG_PlayerStatus:move(dt)
    Moveable.move(self, dt)
    self:align()
end

function TCG_PlayerStatus:hover()
    if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
        if not self.hovering  and self.states.visible and self.children[1].states.visible then
            self.hovering = true
            self.hover_tilt = 2
            self.children[1]:juice_up(0.05, 0.02)
            play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
            Node.hover(self)
        end
    end
end

function Card:add_attack_button()
    -- using the price to render behind the card
    if self.children.price then
        self.children.price:remove()
    end

    self.children.price = UIBox{
        definition = G.UIDEF.tcg_attack_button(self),
        config = {align= "bmi", offset = {x=0,y=0.65}, parent = self}
    }
end

G.FUNCS.select_attacking_card = function(e)

    local card = e.config.ref_table

    for _, joker in ipairs(BalatroTCG.Status_Current.opponentJokers.cards) do
        joker:highlight(false)
        joker:add_attack_button()
    end
    for _, joker in ipairs(BalatroTCG.Status_Current.opponentConsumeables.cards) do
        joker:highlight(false)
        joker:add_attack_button()
    end
    
    card:highlight(true)
    local eval = function(card) return card.highlighted end
    juice_card_until(card, eval, true)

    if card.children.use_button then
        card.children.use_button:remove()
        card.children.use_button = nil
    end

    card.children.price:remove()

    card.children.price = UIBox{
        definition = G.UIDEF.tcg_attack_cancel_button(card),
        config = {align= "bmi", offset = {x=0,y=0.65}, parent = card}
    }

end

G.FUNCS.deselect_attacking_card = function(e)

    local card = e.config.ref_table

    for _, joker in ipairs(BalatroTCG.Status_Current.opponentJokers.cards) do
        joker:highlight(false)
        joker:add_attack_button()
    end
    for _, joker in ipairs(BalatroTCG.Status_Current.opponentConsumeables.cards) do
        joker:highlight(false)
        joker:add_attack_button()
    end

end

function G.UIDEF.tcg_attack_button(e)
    local use = nil
    use = {n=G.UIT.C, config={align = "cr"}, nodes={
        {n=G.UIT.C, config={ref_table = e, align = "bm",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 1.5, hover = true, shadow = true, colour = G.C.RED, button = 'select_attacking_card'}, nodes={
        {n=G.UIT.T, config={text = localize('b_tcg_attack_button'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
      }}
    }}

    local t = {
        n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
            {n=G.UIT.R, config={align = 'cl'}, nodes={
                use
            }},
        }},
    }}
    return t
end
function G.UIDEF.tcg_attack_cancel_button(e)
    local use = nil
    use = {n=G.UIT.C, config={align = "cr"}, nodes={
        {n=G.UIT.C, config={ref_table = e, align = "bm",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 1.5, hover = true, shadow = true, colour = G.C.GREEN, button = 'deselect_attacking_card'}, nodes={
        {n=G.UIT.T, config={text = localize('b_tcg_attack_cancel_button'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
      }}
    }}

    local t = {
        n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
            {n=G.UIT.R, config={align = 'cl'}, nodes={
                use
            }},
        }},
    }}
    return t
end

function TCG_PlayerStatus:stop_hover()
    self.hovering = false
    self.hover_tilt = 0
    Node.stop_hover(self)
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
    self.params.consumeable_usage_total = G.GAME.consumeable_usage_total
    self.status.used_vouchers = G.GAME.used_vouchers

    self.status.idol_card = G.GAME.current_round.idol_card
    self.status.mail_card = G.GAME.current_round.mail_card
    self.status.ancient_card = G.GAME.current_round.ancient_card
    self.status.castle_card = G.GAME.current_round.castle_card

    self.opponentJokers.config.highlighted_limit = 0
    self.opponentConsumeables.config.highlighted_limit = 0
    self.status.discount = G.GAME.discount_percent
    
    self.status.idol_history = {}

    self.visual_transfer = {
        index = '',
    }
    
    for k, v in ipairs(self.bg_sparkles) do
        v:fade(1)
    end
    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 1,blocking = false, blockable = false,
    func = function()
        for k, v in ipairs(self.bg_sparkles) do
            v:remove()
        end
        self.bg_sparkles = {}
        return true
    end}))
end

function TCG_PlayerStatus:apply()


    self.bg_sparkles = {}
    local data = BalatroTCG.DeckData.get(self.back_key)

    if data.bg_particles then
        for k, v in ipairs(data.bg_particles) do
            local copy = copy_table(v)
            copy.initialize = true
            copy.attach = G.ROOM_ATTACH

            local particles = Particles(1, 1, 0,0, copy)
            particles.fade_alpha = 1
            particles:fade(1, 0)
            self.bg_sparkles[#self.bg_sparkles + 1] = particles
        end
    end

    BalatroTCG.CurrentPlayer = self

    for k, v in ipairs(self.opponentDiscard.cards) do
        v.area:remove_card(v)
        v:remove()
    end
    for k, v in ipairs(self.opponentPlay.cards) do
        v.area:remove_card(v)
        v:remove()
    end
    
    
    G.GAME.round_resets.hands = self.params.hands
    G.GAME.round_resets.discards = self.params.discards
    G.GAME.starting_deck_size = self.starting_deck_size
    G.GAME.dollars = self.status.dollars
    G.GAME.bankrupt_at = self.status.bankrupt_at

    self:set_card_areas()

    G.GAME.modifiers.extra_discard_cost = G.GAME.modifiers.extra_discard
    
    if self.status.round == 1 then
        for k, v in ipairs(self.params.starting_vouchers) do
            local voucher = Card(-100, -100, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[v])
            voucher:apply_to_run()
            self.status.used_vouchers[v] = true
        end
    end
    
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

    G.GAME.discount_percent = self.status.discount
    
    for k, v in pairs(G.GAME.hands) do 
        v.played_this_round = 0
    end

    G.GAME.round_bonus.next_hands = 0
    G.GAME.round_bonus.discards = 0

    G.GAME.pseudorandom = self.seed
    
    local shuffle = true
    
    G.deck:shuffle('nr' .. self.status.round)
    
    SMODS.calculate_context({ setting_blind = true, status = self, full_deck = self.deck, blind = G.GAME.round_resets.blind })

    
    for k, v in ipairs(self.playing_cards) do 
        v:set_cost()
    end
    for k, v in ipairs(self.graveyard) do
        v:set_cost()
    end
    
    for _, joker in ipairs(self.jokers.cards) do
        joker.states.drag.can = true
        joker.states.collide.can = true
        joker.states.click.can = true
        if joker.facing == 'back' then joker:flip() end
    end
    for _, joker in ipairs(self.consumeables.cards) do
        joker.states.drag.can = true
        joker.states.collide.can = true
        joker.states.click.can = true
        if joker.facing == 'back' then joker:flip() end
    end
    for _, joker in ipairs(self.opponentJokers.cards) do
        joker:add_attack_button()
    end
    for _, joker in ipairs(self.opponentConsumeables.cards) do
        joker:add_attack_button()
    end
    
    
    reset_idol_card()
    reset_mail_rank()
    reset_ancient_card()
    reset_castle_card()
end

function TCG_PlayerStatus:remove()
    if self.jokers then
        self.jokers:remove()
        self.consumeables:remove()
        self.discard:remove()
        self.deck:remove()
        self.hand:remove()
        self.play:remove()
        self.graveyard:remove()
        self.opponentJokers:remove()
        self.vouchers:remove()
    end
    
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
    G.GAME.consumeable_usage_total = self.params.consumeable_usage_total
    G.GAME.hands = self.status.hand_upgrades
end

function Card:set_opponent_display(card_set, card_base, visible)
    
    if not visible then
        card_set = 'Default'
        card_base = 'S_A'
    end

    self.ability.set = card_set
    if self.ability.set == 'Default' then
        self:set_base(G.P_CARDS[card_base])
    else
        local center = G.P_CENTERS[card_base]
        
        if center then
            self:set_ability(center)
        else
            if self.ability.set == 'Tarot' then
                self:set_ability(G.P_CENTERS['c_hermit'])
            elseif self.ability.set == 'Spectral' then
                self:set_ability(G.P_CENTERS['c_deja_vu'])
            elseif self.ability.set == 'Planet' then
                self:set_ability(G.P_CENTERS['c_mercury'])
            elseif self.ability.set == 'Voucher' then
                self:set_ability(G.P_CENTERS['v_grabber'])
            -- TARGET: Default display
            else
                self:set_ability(G.P_CENTERS['j_joker'])
            end
            self.config.center = copy_center(self.config.center)

            self.bypass_discovery_center  = false
            self.config.center.discovered = false
        end

        self:set_sprites(self.config.center, nil)
        if self.children.front then
            self.children.front:remove()
            self.children.front = nil
        end
    end
    
    if (self.facing == 'front') ~= visible then
        self:flip()
    end
    
    self.states.hover.can = false
end

function TCG_PlayerStatus:receive_message(message)
    
    if message.type == 'back' then
        
        self.Other:set_backs({ message.back })

    elseif message.type == 'backs' then

        local backs = splitlines(message.backs, ';')
        self.Other:set_backs(backs)
        
    elseif message.type == 'startTurn' or message.type == 'attack' then
        
        if message.type == 'startTurn' then

        end

        self.attacks[#self.attacks + 1] = {
            damage = tonumber(message.damage),
            index = tonumber(message.index),
            trampleIndex = 0,
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
    elseif message.type == 'opponent_status' and self.is_player then
        self.status.opponent_joker_cost = tonumber(message.joker_cost)

        local highlighted_cards = {}

        for str in string.gmatch(message.highlighted, "(%d+),") do
            if BalatroTCG.config.FlipOpponent then
                highlighted_cards[tonumber(str)] = true
            else
                highlighted_cards[#self.opponentHand.cards - tonumber(str) + 1] = true
            end
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

    elseif message.type == 'opponent_display' then
        
        self.opponent_joker_display = message.joker_display
        self.opponent_consumeable_display = message.consumeable_display

    elseif message.type == 'opponent_hand' and self.is_player then

        self.opponent_joker_display = message.joker_display or self.opponent_joker_display
        self.opponent_consumeable_display = message.consumeable_display or self.opponent_consumeable_display
        
        if message.from ~= message.to then
            local from = self:string_to_fake_area(message.from)
            local to = self:string_to_fake_area(message.to)

            to = to or self.opponentDiscard

            local indices = splitlines(message.index, ',')
            local bases = splitlines(message.card_base, ',')
            local sets = splitlines(message.card_set, ',')

            -- There's never a situation where some cards are removed from play
            if from == self.opponentPlay then
                indices = {}

                for i, c in ipairs(self.opponentPlay.cards) do
                    indices[i] = i
                end
            end

            for i = 1, #indices do
                G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.05, func = function() 

                    if from and #from.cards >= 1 then
                        local index = indices[i]
                        local card_base = bases[i]
                        local card_set = sets[i]

                        local card = from.cards[#from.cards - math.min(tonumber(index), #from.cards) + 1]
                        
                        card:set_opponent_display(card_set, card_base, card_base ~= 'back')
                        
                        from:remove_card(card)
                        to:emplace(card, nil, true)
                    else
                        local card = Card(to.T.x, to.T.y, G.CARD_W, G.CARD_H, G.P_CARDS['S_A'], G.P_CENTERS['c_base'], {playing_card = G.playing_card, tcg_back = self.Other.back_key})
                        card.sprite_facing = 'back'
		                card.facing = 'back'
                        
                        --card:set_opponent_display(card_set, card_base, card_base ~= 'back')
                        
                        card.states.drag.can = false
                        to:emplace(card, nil, true)
                        to:align_cards()
                    end

                    return true
                end
                }))

            end
        end
        

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
            
            if (transfer.to ~= 'hand' and transfer.to ~= 'discard') and not next(SMODS.find_card('j_chaos')) then
                if card:is_playing_card() then
                    transfer.card_set = 'Default'
                    transfer.card_base = card.config.card_key
                else
                    transfer.card_set = card.ability.set
                    transfer.card_base = card.config.center_key
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

function Card:tcg_get_visual()
    if self.ability.tcgb_sticker_hidden or self.facing == 'back' then
        if self.ability.eternal then
            return 'e'
        else
            return 'x'
        end
    else
        
        if self:is_playing_card() then
            return 'Default,' .. self.config.card_key
        else
            return self.ability.set .. ',' .. self.config.center_key .. ',' .. (self.ability.eternal and 'e' or 'x')
        end
    end
end

function CardArea:tcg_display_string(from_self)
    local ret = ''
    
    if BalatroTCG.config.FlipOpponent or from_self then
        for i, card in ipairs(self.cards) do
            ret = ret .. card:tcg_get_visual() .. ';'
        end
    else
        for i = #self.cards, 1, -1 do
            local card = self.cards[i]
            ret = ret .. card:tcg_get_visual() .. ';'
        end
    end

    return ret
end
function tcg_get_opponent_table(table, i)

    if BalatroTCG.config.FlipOpponent then
        return table[i]
    else
        return table[#table - i + 1]
    end
end
function tcg_set_opponent_table(table, i, value)

    if BalatroTCG.config.FlipOpponent then
        table[i] = value
    else
        table[#table - i + 1] = value
    end
end

function TCG_PlayerStatus:check_visuals()

    local current_joker_display, current_consumeable_display = self.opponentJokers:tcg_display_string(), self.opponentConsumeables:tcg_display_string()

    if (not self.adjusting_display) and 
        (
            (self.opponent_joker_display ~= current_joker_display) or
            (self.opponent_consumeable_display ~= current_consumeable_display)
        ) then
        self.adjusting_display = true

        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.3, func = function()

            local current_joker_display, current_consumeable_display = self.opponentJokers:tcg_display_string(), self.opponentConsumeables:tcg_display_string()

            
            function adjust_jokers()
                local split = splitlines(self.opponent_joker_display, ';')
                local count = #split
                
                if #self.opponentJokers.cards ~= count then
                    
                    while #self.opponentJokers.cards > count do
                        self.opponentJokers.cards[1]:start_dissolve()
                        self.opponentJokers:remove_card(self.opponentJokers.cards[1])
                    end

                    while #self.opponentJokers.cards < count do
                        
                        local card = Card(self.opponentJokers.T.x, self.opponentJokers.T.y, G.CARD_W, G.CARD_H, G.P_CARDS['S_A'], G.P_CENTERS['c_base'], {playing_card = G.playing_card, tcg_back = self.Other.back_key})
                        
                        card.states.drag.can = false
                        self.opponentJokers:emplace(card, nil, true)
                    end

                    self.opponentJokers:align_cards()
                end

                for i = 1, #self.opponentJokers.cards do
                for j = i, #self.opponentJokers.cards do
                    local current = tcg_get_opponent_table(self.opponentJokers.cards, j):tcg_get_visual()
                    if current == split[i] then
                        if i ~= j then
                            local temp = tcg_get_opponent_table(self.opponentJokers.cards, i)
                            tcg_set_opponent_table(self.opponentJokers.cards, i, tcg_get_opponent_table(self.opponentJokers.cards, j))
                            tcg_set_opponent_table(self.opponentJokers.cards, j, temp)
                        end
                    else
                        if split[i] == 'x' then
                            tcg_get_opponent_table(self.opponentJokers.cards, i):set_opponent_display(nil, nil, false)
                        else
                            local cardsplit = splitlines(split[i], ',')
                            tcg_get_opponent_table(self.opponentJokers.cards, i):set_opponent_display(cardsplit[1], cardsplit[2], true)
                        end
                    end

                end
                end
            end
            
            function adjust_consumeables()
                local split = splitlines(self.opponent_consumeable_display, ';')
                local count = #split
                
                if #self.opponentConsumeables.cards ~= count then
                    
                    while #self.opponentConsumeables.cards > count do
                        self.opponentConsumeables.cards[1]:start_dissolve()
                        self.opponentConsumeables:remove_card(self.opponentConsumeables.cards[1])
                    end

                    while #self.opponentConsumeables.cards < count do
                        
                        local card = Card(self.opponentConsumeables.T.x, self.opponentConsumeables.T.y, G.CARD_W, G.CARD_H, G.P_CARDS['S_A'], G.P_CENTERS['c_base'], {playing_card = G.playing_card, tcg_back = self.Other.back_key})
                        
                        card.states.drag.can = false
                        self.opponentConsumeables:emplace(card, nil, true)
                    end

                    self.opponentConsumeables:align_cards()
                end

                for i = 1, #self.opponentConsumeables.cards do
                for j = i, #self.opponentConsumeables.cards do
                    local current = tcg_get_opponent_table(self.opponentConsumeables.cards, j):tcg_get_visual()
                    if current == split[i] then
                        if i ~= j then
                            local temp = tcg_get_opponent_table(self.opponentConsumeables.cards, i)
                            tcg_set_opponent_table(self.opponentConsumeables.cards, i, tcg_get_opponent_table(self.opponentConsumeables.cards, j))
                            tcg_set_opponent_table(self.opponentConsumeables.cards, j, temp)
                        end
                    else
                        if split[i] == 'x' then
                            tcg_get_opponent_table(self.opponentConsumeables.cards, i):set_opponent_display(nil, nil, false)
                        else
                            local cardsplit = splitlines(split[i], ',')
                            tcg_get_opponent_table(self.opponentConsumeables.cards, i):set_opponent_display(cardsplit[1], cardsplit[2], true)
                        end
                    end

                end
                end
            end

            if self.is_player then

                if self.opponent_joker_display ~= current_joker_display then
                    
                    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
                        G.E_MANAGER:add_event(Event({ func = function() self.opponentJokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
                        delay(0.15)
                        G.E_MANAGER:add_event(Event({ func = function() self.opponentJokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
                        delay(0.15)
                        G.E_MANAGER:add_event(Event({ func = function() 
                            
                            adjust_jokers()
    
                            play_sound('cardSlide1', 1)
                            return true end })) 
                        delay(0.5)
                        G.E_MANAGER:add_event(Event({ func = function() self.adjusting_display = false; return true end })) 
                        return true end })) 
                elseif self.opponent_consumeable_display ~= current_consumeable_display then
    
                    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 

                        G.E_MANAGER:add_event(Event({ func = function() self.opponentConsumeables:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
                        delay(0.15)
                        G.E_MANAGER:add_event(Event({ func = function() self.opponentConsumeables:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
                        delay(0.15)
                        G.E_MANAGER:add_event(Event({ func = function() 
                            
                            adjust_consumeables()
    
                            play_sound('cardSlide1', 1)
                            return true end })) 
                        delay(0.5)
                        G.E_MANAGER:add_event(Event({ func = function() self.adjusting_display = false; return true end })) 
                        return true end }))
                else
                    self.adjusting_display = false
                end
            else
                self.adjusting_display = false
            end
            
            return true
        end
        }))
    end

    -- local current_joker_display, current_consumeable_display = self.jokers:tcg_display_string(true), self.consumeables:tcg_display_string(true)

    -- if self.sent_joker_display ~= current_joker_display or self.sent_consumeable_display ~= current_consumeable_display then
        
    --     self:send_message({
    --         type = 'opponent_display',
    --         joker_display = current_joker_display,
    --         consumeable_display = current_consumeable_display
    --     })

    --     self.sent_joker_display = current_joker_display
    --     self.sent_consumeable_display = current_consumeable_display
    -- end
    

    if self.highlight_delay > 0 then
        self.highlight_delay = self.highlight_delay + 1
        if self.highlight_delay > 15 then
            self.highlight_delay = 0
            
            self:send_message(self.highlight_message)
        end
    end

    if not self.visual_transfer.from then return end

    self.visual_delay = self.visual_delay + 1

    if self.visual_delay > 10 or not BalatroTCG.MP_Lobby then
        self:send_visuals()
    end
end
function TCG_PlayerStatus:send_visuals()
    self.visual_delay = 0
    
    self.visual_transfer.type = 'opponent_hand'

    self.visual_transfer.joker_display = self.jokers:tcg_display_string(true)
    self.visual_transfer.consumeable_display = self.consumeables:tcg_display_string(true)
    
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

function TCG_PlayerStatus:can_do_things()

    return (not BalatroTCG.Settings.EndingRound or self.status.round <= BalatroTCG.Settings.RoundEnd) and
        (#self.attacks <= 0)
end

function TCG_PlayerStatus:add_protection(protect)
    self.temp_safety[#self.temp_safety + 1] = protect
end

function TCG_PlayerStatus:take_attacks()
    
    if not self.has_rerolled and G.GAME.chips_damage_text == '0' and G.GAME.chips_damage <= 0 then
        self.can_reroll = true
    end

    if #self.attacks <= 0 then
        if BalatroTCG.Settings.EndingRound and self.status.round > BalatroTCG.Settings.RoundEnd then
            
            local self_wins = false
            if BalatroTCG.Settings.WinCondition == 'Lowest Money' then
                self_wins = self.status.dollars < self.status.opponent_health
            elseif BalatroTCG.Settings.WinCondition == 'Highest Money' then
                self_wins = self.status.dollars > self.status.opponent_health
            -- TARGET: New TCG win conditions
            end

            end_tcg_game(self.is_player == self_wins)
        end
    end

    for k, att in pairs(self.attacks) do
        
        table.remove(self.attacks, k)
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
                        local value = joker:calculate_joker({tcg_take_damage = true, damage = att.damage, trampleIndex = att.trampleIndex })
                        if value then
                            value.activator = joker
                            return_table[#return_table + 1] = value
                        end
                    end
                end
                att.index = att.index or 0
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
                        for _, j in ipairs(self.consumeables.cards) do
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
                        
                        G.GAME.chips_damage = 0
                    else

                        local attacked = math.min(joker.ability.tcgb_health_amount or 0, G.GAME.chips_damage)
                        
                        G.GAME.chips_damage = G.GAME.chips_damage - attacked
                        
                        self:add_play_stats('joker_damage', attacked, self.status.round)

                        if G.GAME.chips_damage > 0 then
                            self.attacks[#self.attacks + 1] = {
                                damage = G.GAME.chips_damage,
                                index = 0,
                                trampleIndex = att.trampleIndex + 1
                            }
                        end

                        joker:remove_tcg_health(attacked)
                        if self.is_player then
                            play_sound('glass'..math.random(1, 6), math.random()*0.2 + 0.9,0.5)
                        end
                        joker:juice_up(0.3, 0.5)
                        
                    end

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

        self.consumeables.T.x = self.jokers.T.x + self.jokers.T.w + 0.2
        self.consumeables.T.y = self.jokers.T.y
        
        self.deck.T.x = G.TILE_W - self.deck.T.w - 0.5
        self.deck.T.y = G.TILE_H - self.deck.T.h - 0.25
        
        self.discard.T.x = self.jokers.T.x + self.jokers.T.w/2 + 0.3 + 15
        self.discard.T.y = 4.2
        
        self.vouchers.T.x = self.deck.T.x - 1
        self.vouchers.T.y = G.TILE_H + 0.25
        
        if BalatroTCG.config.FlipOpponent then
            self.opponentJokers.T.x = self.jokers.T.x
            self.opponentJokers.T.y = self.jokers.T.y - 3.25

            self.opponentConsumeables.T.x = self.opponentJokers.T.x + self.opponentJokers.T.w + 0.2
            self.opponentConsumeables.T.y = self.opponentJokers.T.y
        else
            self.opponentConsumeables.T.x = self.jokers.T.x
            self.opponentConsumeables.T.y = self.jokers.T.y

            self.opponentJokers.T.x = self.opponentConsumeables.T.x + self.opponentConsumeables.T.w+ 0.2
            self.opponentJokers.T.y = self.opponentConsumeables.T.y

        end

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
        
        -- if not _RELEASE_MODE then
        --     self.opponentJokers.T.x = 0
        --     self.opponentJokers.T.y = 0
        -- end

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