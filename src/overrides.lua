
local play_cards_from_highlighted_ref = G.FUNCS.play_cards_from_highlighted

G.FUNCS.play_cards_from_highlighted = function(e)
    if BalatroTCG.GameActive and G.GAME.current_round.hands_left <= 1 then
        for _, joker in ipairs(G.jokers.cards) do
            joker:highlight(false)
            joker.states.drag.can = false
        end
        for _, joker in ipairs(BalatroTCG.Status_Current.opponentJokers.cards) do
            joker.states.drag.can = false
        end
    end
    play_cards_from_highlighted_ref(e)
end

local can_highlight_ref = CardArea.can_highlight
function CardArea:can_highlight(card)
	if card.tcg_deck_type then return true end
	return can_highlight_ref(self, card)
end

local Card_highlight_ref = Card.highlight
function Card:highlight(is_higlighted)


    if self.area and (self.area.config.type == 'tcgdeck_buy' or self.area.config.type == 'tcgdeck_remove') then
        self.highlighted = is_higlighted

        if is_higlighted then

            for j = 1, #G.your_collection do
                for i = #G.your_collection[j].cards,1, -1 do
                    local c = G.your_collection[j].cards[i]
                    if c ~= self then
                        c:highlight(false)
                    end
                end
            end
            for j = 1, #G.your_tcg_deck do
                for i = #G.your_tcg_deck[j].cards,1, -1 do
                    local c = G.your_tcg_deck[j].cards[i]
                    if c ~= self then
                        c:highlight(false)
                    end
                end
            end



            self.children.use_button = UIBox{
                definition = self.area.config.type == 'tcgdeck_buy' and G.UIDEF.tcg_add_to_deck(self) or G.UIDEF.tcg_remove_from_deck(self),
                config = {align= "bmi", offset = {x=0,y=0.85},parent =self}
            }
        elseif self.children.use_button then
            self.children.use_button:remove()
            self.children.use_button = nil
        end
    else
        Card_highlight_ref(self, is_higlighted)

        if BalatroTCG.GameActive and is_higlighted and self.area and (self.area == BalatroTCG.Player.opponentJokers or self.area == BalatroTCG.Player.opponentConsumeables) then
            
            for k, c in ipairs(BalatroTCG.Player.opponentJokers.cards) do
                if c ~= self then
                    c:highlight(false)
                end
            end
            for k, c in ipairs(BalatroTCG.Player.opponentConsumeables.cards) do
                if c ~= self then
                    c:highlight(false)
                end
            end
        end
    end

	if self.tcg_deck_type then
        if self.highlighted then
            for k, v in ipairs(BalatroTCG.BuildingDeck.backs) do
                if self.tcg_deck_type == v then goto skip end
            end
            table.insert(BalatroTCG.BuildingDeck.backs, self.tcg_deck_type)
            ::skip::
        else
            for k, v in ipairs(BalatroTCG.BuildingDeck.backs) do
                if self.tcg_deck_type == v then
                    table.remove(BalatroTCG.BuildingDeck.backs, k)
                    break
                end
            end
        end
	end

    if BalatroTCG.GameActive and BalatroTCG.Status_Current then
        BalatroTCG.Status_Current:send_status()
    end
end

local SMODS_scoring_calculation_function_ref = G.FUNCS.SMODS_scoring_calculation_function
G.FUNCS.SMODS_scoring_calculation_function = function(e)
    if BalatroTCG.GameActive then return end
    return SMODS_scoring_calculation_function_ref(e)
end

local ease_hands_played_ref = ease_hands_played

function ease_hands_played(mod, instant)
    if BalatroTCG.PlayerActive then
        ease_hands_played_ref(mod, instant)
    else
        G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + mod
    end

    if BalatroTCG.GameActive then
        BalatroTCG.Status_Current.status.hands_left = math.max(BalatroTCG.Status_Current.status.hands_left + mod, 0)
    end
end
local ease_discard_ref = ease_discard

function ease_discard(mod, instant)
    if BalatroTCG.PlayerActive then
        ease_discard_ref(mod, instant)
    else
        G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + mod
    end

    if BalatroTCG.GameActive then
        BalatroTCG.Status_Current.status.discards_left = math.max(BalatroTCG.Status_Current.status.discards_left + mod, 0)
    end
end

local hover_ref = Card.hover
function Card:hover()
	if self.tcg_deck_type then
		self.ability_UIBox_table = self:generate_UIBox_ability_table()
		self.config.h_popup = G.UIDEF.card_h_popup(self)
		self.config.h_popup_config = self:align_h_popup()
		Node.hover(self)
	end
    hover_ref(self)
end

local Card_add_to_deck_ref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
    local obj = self.config.center

    if not self.added_to_deck and BalatroTCG.GameActive and obj and obj.tcg_add_to_deck and type(obj.tcg_add_to_deck) == 'function' then
        self.added_to_deck = true

        obj.tcg_add_to_deck(self, from_debuff)
        return
    else
        Card_add_to_deck_ref(self, from_debuff)
    end
end
local Card_remove_from_deck_ref = Card.remove_from_deck
function Card:remove_from_deck(from_debuff)
    local obj = self.config.center
    if self.added_to_deck and BalatroTCG.GameActive and obj and obj.tcg_remove_from_deck and type(obj.tcg_remove_from_deck) == 'function' then
        self.added_to_deck = false
        obj.tcg_remove_from_deck(self, from_debuff)
        return
    else
        Card_remove_from_deck_ref(self, from_debuff)
    end
end

local Game_save_settings_ref = Game.save_settings
function Game:save_settings()

    --local temp = G.SETTINGS.GAMESPEED
    --G.SETTINGS.GAMESPEED = BalatroTCG.SavedSpeed

    Game_save_settings_ref(self)

    --G.SETTINGS.GAMESPEED = temp
end

local init_game_object_ref = Game.init_game_object
function Game:init_game_object(...)
    local output = init_game_object_ref(self, ...)

    if BalatroTCG.UseTCG_UI then
        output.hands = {
            ["Flush Five"] =        {order = 1, mult = 16,  chips = 160, s_mult = 16,  s_chips = 160, level = 1, l_mult = 2,  l_chips = 50, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'S_A', true},{'S_A', true},{'S_A', true},{'S_A', true},{'S_A', true}}},
            ["Flush House"] =       {order = 2, mult = 14,  chips = 140, s_mult = 14,  s_chips = 140, level = 1, l_mult = 3,  l_chips = 40, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'D_7', true},{'D_7', true},{'D_7', true},{'D_4', true},{'D_4', true}}},
            ["Five of a Kind"] =    {order = 3, mult = 12,  chips = 120, s_mult = 12,  s_chips = 120, level = 1, l_mult = 4,  l_chips = 25, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'S_A', true},{'H_A', true},{'H_A', true},{'C_A', true},{'D_A', true}}},
            ["Straight Flush"] =    {order = 4, mult = 8,   chips = 100, s_mult = 8,   s_chips = 100, level = 1, l_mult = 10, l_chips = 80, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'S_Q', true},{'S_J', true},{'S_T', true},{'S_9', true},{'S_8', true}}},
            ["Four of a Kind"] =    {order = 5, mult = 7,   chips = 60,  s_mult = 7,   s_chips = 60,  level = 1, l_mult = 4,  l_chips = 50, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'S_J', true},{'H_J', true},{'C_J', true},{'D_J', true},{'C_3', false}}},
            ["Full House"] =        {order = 6, mult = 4,   chips = 40,  s_mult = 4,   s_chips = 40,  level = 1, l_mult = 3,  l_chips = 35, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'H_K', true},{'C_K', true},{'D_K', true},{'S_2', true},{'D_2', true}}},
            ["Flush"] =             {order = 7, mult = 4,   chips = 35,  s_mult = 4,   s_chips = 35,  level = 1, l_mult = 2,  l_chips = 25, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'H_A', true},{'H_K', true},{'H_T', true},{'H_5', true},{'H_4', true}}},
            ["Straight"] =          {order = 8, mult = 4,   chips = 30,  s_mult = 4,   s_chips = 30,  level = 1, l_mult = 6,  l_chips = 50, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'D_J', true},{'C_T', true},{'C_9', true},{'S_8', true},{'H_7', true}}},
            ["Three of a Kind"] =   {order = 9, mult = 3,   chips = 30,  s_mult = 3,   s_chips = 30,  level = 1, l_mult = 4,  l_chips = 25, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'S_T', true},{'C_T', true},{'D_T', true},{'H_6', false},{'D_5', false}}},
            ["Two Pair"] =          {order = 10,mult = 2,   chips = 20,  s_mult = 2,   s_chips = 20,  level = 1, l_mult = 1,  l_chips = 50, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'H_A', true},{'D_A', true},{'C_Q', false},{'H_4', true},{'C_4', true}}},
            ["Pair"] =              {order = 11,mult = 2,   chips = 10,  s_mult = 2,   s_chips = 10,  level = 1, l_mult = 0,  l_chips = 30, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'S_K', false},{'S_9', true},{'D_9', true},{'H_6', false},{'D_3', false}}},
            ["High Card"] =         {order = 12,mult = 1,   chips = 5,   s_mult = 1,   s_chips = 5,   level = 1, l_mult = 2,  l_chips = 00, played = 0, played_this_round = 0, played_this_ante = 0, example = {{'S_A', true},{'D_Q', false},{'D_9', false},{'C_4', false},{'D_3', false}}},
        }
    end

    return output
end

local Card_calculate_seal = Card.calculate_seal
function Card:calculate_seal(context)

    if BalatroTCG.GameActive and context.discard and context.other_card == self then
        local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
        local status = BalatroTCG.Status_Current


        if card and self.seal == 'Purple' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            card.area:remove_card(card)

            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    card:start_materialize()
                    status.consumeables:emplace(card)

                    for _, c in ipairs(G.playing_cards) do
                        if c == card then
                            goto skip
                        end
                    end
                    table.insert(status.playing_cards, card)
                    ::skip::
                    G.GAME.consumeable_buffer = 0
                    return true
                end)}))
            card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
            return nil, true
        end
    end
    return Card_calculate_seal(self, context)
end

local get_end_of_round_effect_ref = Card.get_end_of_round_effect
function Card:get_end_of_round_effect(context)
    if BalatroTCG.GameActive and self.seal == 'Blue' then
        
        local card = pick_from_areas(function (c) return c.ability.set == 'Planet' and c.ability.hand_type == G.GAME.last_hand_played end, {G.deck, G.discard, G.graveyard, G.hand})
        

        local status = BalatroTCG.Status_Current

        if card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and not self.ability.extra_enhancement then

            card.area:remove_card(card)

            local ret = {}

            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    
                    card:start_materialize()
                    status.consumeables:emplace(card)
        
                    for _, c in ipairs(G.playing_cards) do
                        if c == card then
                            goto skip
                        end
                    end
                    table.insert(status.playing_cards, card)
                    ::skip::

                    G.GAME.consumeable_buffer = 0

                    return true
                end)}))

            card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})

            ret.effect = true

            return ret
        end
        
        return
    end
    return get_end_of_round_effect_ref(self, context)
    
end


function G.UIDEF.tcg_add_to_deck(e)
    local use = nil
    use = {n=G.UIT.C, config={align = "cr"}, nodes={
        e.tcg_broken and 
        {n=G.UIT.C, config={ref_table = e, align = "bm",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 1.5, hover = true, shadow = true, colour = G.C.RED}, nodes={
            {n=G.UIT.T, config={text = 'Not Ready',colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
        }}
        or 
        {n=G.UIT.C, config={ref_table = e, align = "bm",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 1.5, hover = true, shadow = true, colour = G.C.GOLD, button = 'add_tcg_card'}, nodes={
            {n=G.UIT.T, config={text = (localize('$') .. tostring(G.tcg_tab == 'Backs' and (deck_back_cost(e.original_id)) or e.cost)),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
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
function G.UIDEF.tcg_remove_from_deck(e)
    local use = nil
    use = {n=G.UIT.C, config={align = "cr"}, nodes={
        {n=G.UIT.C, config={ref_table = e, align = "bm",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 1.5, hover = true, shadow = true, colour = G.C.RED, button = 'remove_tcg_card'}, nodes={

        {n=G.UIT.T, config={text = localize('b_tcg_remove'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
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

G.FUNCS.add_tcg_card = function(e)
    local card = e.config.ref_table

    for j = 1, #G.your_collection do
        for i = #G.your_collection[j].cards,1, -1 do
            local c = G.your_collection[j].cards[i]
            if c == card then
                if G.tcg_tab == 'Backs' then
                    if c.original_id == 'b_mp_cocktail' then

                        if BalatroTCG.BuildingDeck.backs[1] ~= 'b_mp_cocktail' then
                            BalatroTCG.BuildingDeck.backs = { c.original_id, BalatroTCG.BuildingDeck.backs[1] }
                        end

                        BalatroTCG.BuildingDeck:sort()
                        BalatroTCG.BuildingDeck:set_cost()

                        BalatroTCG.DeckCost = 110 - BalatroTCG.BuildingDeck.cost

                        save_decks()

                        if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
                        args = {}
                        args.config = {
                            align = "cm",
                            offset = {x=0,y=0},
                            major = G.ROOM_ATTACH,
                            bond = 'Weak',
                            no_esc = false
                        }
                        G.OVERLAY_MENU = UIBox {
                            definition = G.FUNCS.create_tcg_builder_cocktail(),
                            config = args.config
                        }
                        return
                    else
                        BalatroTCG.BuildingDeck.backs = { c.original_id }
                    end
                else
                    if c.ability.set == 'Joker' then
                        table.insert(BalatroTCG.BuildingDeck.cards, { type = 'j', c = c.original_id })
                    elseif c.ability.set == 'Default' then
                        table.insert(BalatroTCG.BuildingDeck.cards, { type = 'p', r = SMODS.Ranks[c.base.value].card_key, s = SMODS.Suits[c.base.suit].card_key })
                    elseif c.ability.set == 'Spectral' or c.ability.set == 'Tarot' or c.ability.set == 'Planet' or c.ability.set == 'Voucher' then
                        table.insert(BalatroTCG.BuildingDeck.cards, { type = 'c', c = c.original_id })
                    end
                end
            end
        end
    end


    refresh_builder_page()
end
G.FUNCS.remove_tcg_card = function(e)
    if #BalatroTCG.BuildingDeck.cards <= 1 then return end

    local card = e.config.ref_table
    local index = -1

    local c1 = e.config.ref_table

    for j = 1, #G.your_tcg_deck do
        for i = #G.your_tcg_deck[j].cards,1, -1 do
            local c = G.your_tcg_deck[j].cards[i]
            if c == card then
                index = (G.tcg_deck_page - 1) * 12 + (j - 1) * 6 + i
                table.remove(BalatroTCG.BuildingDeck.cards, index)
            end
        end
    end

    refresh_builder_page()
end

local cardarea_move = CardArea.move
function CardArea:move(dt)
    if BalatroTCG.GameActive then
        local finalPos = nil
        if self == BalatroTCG.Player.jokers or self == BalatroTCG.Player.consumeables then
            finalPos = 0.5
        elseif self == BalatroTCG.Player.opponentJokers or self == BalatroTCG.Player.opponentConsumeables then
            finalPos = -2.5
        elseif self == BalatroTCG.Player.opponentHand then
            finalPos = -7
        elseif self == BalatroTCG.Player.opponentPlay then
            finalPos = -4
        end

        if finalPos then

            if not BalatroTCG.PlayerActive then
                finalPos = finalPos + 5
            end

            self.T.y = 15*G.real_dt*finalPos + (1-15*G.real_dt)*self.T.y
            
            if math.abs(finalPos - self.T.y) < 0.01 then self.T.y = finalPos end

        end
    end
    return cardarea_move(self, dt)
end

function refresh_builder_page()
    BalatroTCG.BuildingDeck:sort()
    BalatroTCG.BuildingDeck:set_cost()
    save_decks()

    if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
    args = {}
    args.config = {
        align = "cm",
        offset = {x=0,y=0},
        major = G.ROOM_ATTACH,
        bond = 'Weak',
        no_esc = false
    }
    G.OVERLAY_MENU = UIBox {
        definition = G.FUNCS.create_tcg_builder_menu(),
        config = args.config
    }
end

local card_init_ref = Card.init
function Card:init(X, Y, W, H, card, center, params)
    card_init_ref(self, X, Y, W, H, card, center, params)
    self.tcg_extra = {}
end

function Card:is_playing_card()
    return self.ability.set == 'Default' or self.ability.set == 'Enhanced'
end

local G_FUNCS_lobby_start_game_ref = G.FUNCS.lobby_start_game
function G.FUNCS.lobby_start_game(e)
    if BalatroTCG.MP_Lobby then
        Client.send({
            action = "startTcgBetting",
        })
    else
        G_FUNCS_lobby_start_game_ref(e)
    end
end

local can_use_consumeable_ref = Card.can_use_consumeable
function Card:can_use_consumeable(any_state, skip_check)
    local value = can_use_consumeable_ref(self, any_state, skip_check)

    if self.ability.name == 'Wraith' then return true end

    if not BalatroTCG.GameActive then
        return value
    end


    if value then
        if self.ability.name == 'The Fool' and G.GAME.last_tarot_planet == 'c_hermit' then
            if BalatroTCG.Settings.Unbalance then return true end
            return false

        elseif self.ability.name == 'Cryptid' then
            if BalatroTCG.Settings.Unbalance then return true end

            if not G.hand.highlighted[1]:is_playing_card() then return false end
        elseif self.ability.name == 'Death' then
            if BalatroTCG.Settings.Unbalance then return true end

            local left = G.hand.highlighted[1]
            local right = G.hand.highlighted[2]
            if left.T.x > right.T.x then
                local temp = left
                left = right
                right = temp
            end
            if not right:is_playing_card() then
                return false
            end

        elseif self.ability.name == 'Strength' then
            for k, v in ipairs(G.hand.highlighted) do
                if not v:is_playing_card() then return false end
            end

        elseif self.ability.effect == 'Suit Conversion' then
            if BalatroTCG.Settings.Unbalance then return true end

            for k, v in ipairs(G.hand.highlighted) do
                if not v:is_playing_card() then return false end
            end

        elseif self.ability.effect == 'Enhance' or
            self.ability.name == 'Talisman' or
            self.ability.name == 'Deja Vu' or
            self.ability.name == 'Trance' or
            self.ability.name == 'Medium'
            then
            for k, v in ipairs(G.hand.highlighted) do
                if not v:is_playing_card() then return false end
            end
        elseif self.ability.name == 'Aura' then
            if not (G.hand.highlighted[1]:is_playing_card() or G.hand.highlighted[1].ability.set == 'Joker') then return false end
        --TARGET: Modify Consumables
        end

        return true
    else
        return false
    end
end


G_UIDEF_deck_info_ref = G.UIDEF.deck_info
function G.UIDEF.deck_info(_show_remaining)
    BalatroTCG.GraveyardView = false
    return G_UIDEF_deck_info_ref(_show_remaining)
end

-- local temp = G.playing_cards
-- G.playing_cards = G.graveyard.cards or {}
-- G.playing_cards = temp
local G_UIDEF_view_deck_ref = G.UIDEF.view_deck
function G.UIDEF.view_deck(args)

    if args == 'graveyard' then
        BalatroTCG.GraveyardView = true
        args = false
    else
        BalatroTCG.GraveyardView = false
    end

    return G_UIDEF_view_deck_ref(args)
end

local ref_Card_get_id = Card.get_id
function Card:get_id()
    if self.ability and not self:is_playing_card() then
        return -math.random(100, 1000000)
    end
    return ref_Card_get_id(self)
end

local ref_Card_is_suit = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    if self.ability and not self:is_playing_card() then
        return false
    end
    return ref_Card_is_suit(self, suit, bypass_debuff, flush_calc)
end

function play_button_type(h)

	if G.GAME.current_round.hands_left <= 0 or #h < 1 then
        return 'NULL'
    end


    return 'SAFE'
end


local calculate_card_areas_ref = SMODS.calculate_card_areas
function SMODS.calculate_card_areas(_type, context, return_table, args)
    local flags = {}

    if BalatroTCG.Status_Current then
        for k, object in ipairs(BalatroTCG.Status_Current.backs) do
            if not object.calculate_deck then goto continue end

            if return_table then
                SMODS.current_evaluated_object = object
                return_table[#return_table+1] = object.calculate_deck(context)
            else
                SMODS.current_evaluated_object = object
                local effects = { object.calculate_deck(context) }
                local f = SMODS.trigger_effects(effects, card)
                for k,v in pairs(f) do flags[k] = v end
                SMODS.update_context_flags(context, flags)
            end

            ::continue::
        end

        SMODS.current_evaluated_object = nil
        return flags
    end

    return calculate_card_areas_ref(_type, context, return_table, args)

end

local Back_trigger_effect_ref = Back.trigger_effect
function Back:trigger_effect(args)


    if BalatroTCG.GameActive then
        if not args then return end

        for k, object in ipairs(BalatroTCG.Status_Current.backs) do
            if not object.calculate_deck then goto continue end -- Find a better system for this

            SMODS.current_evaluated_object = object
            local effects = object.calculate_deck(args)
            
            if effects then
                for k, v in pairs(effects) do
                    args[k] = v
                end
            end

            ::continue::

        end

        SMODS.current_evaluated_object = nil

        if args.context == 'final_scoring_step' then
            return args.chips, args.mult
        end

        return
    else
        return Back_trigger_effect_ref(self, args)
    end
end

G.FUNCS.playing_card_to_consumables = function(e)
    local c1 = e.config.ref_table
    if c1 and c1:is(Card) then
        if not G.FUNCS.check_for_buy_space(c1) then
            e.disable_button = nil
            return false
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                c1.from_area = c1.area
                c1.area:remove_card(c1)
                c1:add_to_deck()
                if c1.children.price then c1.children.price:remove() end
                c1.children.price = nil
                if c1.children.buy_button then c1.children.buy_button:remove() end
                c1.children.buy_button = nil
                remove_nils(c1.children)

                G.consumeables:emplace(c1)
                --Tallies for unlocks
                G.GAME.round_scores.cards_purchased.amt = G.GAME.round_scores.cards_purchased.amt + 1

                SMODS.calculate_context({buying_card = true, card = c1})

                if G.GAME.modifiers.inflation then
                    G.GAME.inflation = G.GAME.inflation + 1
                    G.E_MANAGER:add_event(Event({func = function()
                        for k, v in pairs(G.I.CARD) do
                            if v.set_cost then v:set_cost() end
                        end
                    return true end }))
                end

                play_sound('card1')
                inc_career_stat('c_shop_dollars_spent', c1.cost)

                if c1.cost ~= 0 then
                    ease_dollars(-c1.cost)
                    if BalatroTCG.GameActive then
                        BalatroTCG.Status_Current:add_play_stats('purchase', c1.cost, BalatroTCG.Status_Current.status.round)
                    end
                end
                G.CONTROLLER:save_cardarea_focus('jokers')
                G.CONTROLLER:recall_cardarea_focus('jokers')

                return true
            end
        }))
    end
end
G.FUNCS.playing_card_to_hand = function(e)
    local c1 = e.config.ref_table
    if c1 and c1:is(Card) then

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                c1.from_area = c1.area
                c1.area:remove_card(c1)
                c1:add_to_deck()
                if c1.children.price then c1.children.price:remove() end
                c1.children.price = nil
                if c1.children.buy_button then c1.children.buy_button:remove() end
                c1.children.buy_button = nil
                remove_nils(c1.children)

                G.hand:emplace(c1)

                play_sound('card1')

                G.CONTROLLER:save_cardarea_focus('jokers')
                G.CONTROLLER:recall_cardarea_focus('jokers')

                return true
            end
        }))
    end
end

G.FUNCS.can_buy_tcg = function(e)

    if not BalatroTCG.Status_Current:can_do_things() then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        return
    end

    local v = e.config.ref_table

    local ignore = false

    if v.config.center.requires then
        ignore = true
        for kk, vv in pairs(v.config.center.requires) do
            if G.GAME.used_vouchers[vv] then
                ignore = false
            end
        end
    end

    if v.ability.set == 'Voucher' and G.GAME.used_vouchers[v.config.center_key] then
        ignore = true
    end

    if ignore or (
        (v.config.center.no_pool_flag and G.GAME.pool_flags[v.config.center.no_pool_flag]) or
        (v.config.center.yes_pool_flag and not G.GAME.pool_flags[v.config.center.yes_pool_flag]) or
        ((e.config.ref_table.cost >= G.GAME.dollars - G.GAME.bankrupt_at) and (e.config.ref_table.cost > 0))) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.ORANGE
        if v.ability.set == 'Voucher' then
            e.config.button = 'use_card'
        elseif v:is_playing_card() then
            e.config.button = 'playing_card_to_consumables'
        else
            e.config.button = 'buy_from_shop'
        end
    end
    if e.config.ref_parent and e.config.ref_parent.children.buy_and_use then
      if e.config.ref_parent.children.buy_and_use.states.visible then
        e.UIBox.alignment.offset.y = -0.6
      else
        e.UIBox.alignment.offset.y = 0
      end
    end
end

local check_for_buy_space_ref = G.FUNCS.check_for_buy_space

G.FUNCS.check_for_buy_space = function(card)
    if BalatroTCG.GameActive then
        local location = (card.ability.consumeable or card.ability.set == 'Enhanced' or card.ability.set == 'Default') and G.consumeables or G.jokers
        local alt_location = nil

        if G.GAME.modifiers.consumeable_in_jokers and (location == G.consumeables) then 
            alt_location = G.jokers
        elseif G.GAME.modifiers.joker_in_consumeables and (location ~= G.consumeables) then 
            alt_location = G.consumeables
        end
        --TARGET: Tcg item locations

        if #location.cards < location.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0) then

        elseif alt_location and #alt_location.cards < alt_location.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0) then

        else
            alert_no_space(card, location)
            return false
        end
        return true
    else
        return check_for_buy_space_ref(card)
    end
end

local ref_CardArea_parse_highlighted = CardArea.parse_highlighted

function CardArea:parse_highlighted()
    if not BalatroTCG.GameActive then return ref_CardArea_parse_highlighted(self) end

    local value = play_button_type(self.highlighted)

    if play_button_type(self.highlighted) ~= 'SAFE' then
        update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
        return
    end

    ref_CardArea_parse_highlighted(self)

end


local update_new_round_ref = Game.update_new_round
function Game:update_new_round(dt)

    if BalatroTCG.GameActive then
        if not G.STATE_COMPLETE then
            G.STATE_COMPLETE = true
        end
    end
    update_new_round_ref(self, dt)
end

local gameupdate_ref = Game.update
function Game:update(dt)
    gameupdate_ref(self, dt)
    if BalatroTCG.GameStarted then
        BalatroTCG.Status_Current:check_visuals()
    end
end

local update_selecting_hand_ref = Game.update_selecting_hand
function Game:update_selecting_hand(dt)

    if BalatroTCG.GameActive then
        if G.hand and not BalatroTCG.PlayerActive and G.buttons then
            if BalatroTCG.AI then
                BalatroTCG.AI:run()
            else

            end
        end
    end
    update_selecting_hand_ref(self, dt)
end


function CardArea:chance(check_func, pulls, need)
    need = need or 1
    pulls = pulls or 5

    if need > pulls then return 0 end

    local total = #self.cards
    local has = 0

    for k, v in ipairs(self.cards) do
        if check_func(v) then
            has = has + 1
        end
    end

    return get_chance(need, pulls, has, total)
end

function CardArea:chance_rank(rank, pulls, need)
    return self:chance(
        (function(c)
            return c:is_playing_card() and c:get_id() == rank
        end),
        pulls, need
    )
end

function CardArea:chance_suit(suit, pulls, need)
    return self:chance(
        (function(c)
            return c:is_playing_card() and c.base.suit == suit
        end),
        pulls, need
    )
end

function CardArea:chance_card(rank, suit, pulls, need)
    return self:chance(
        (function(c)
            return c:is_playing_card() and c:get_id() == rank and c.base.suit == suit
        end),
        pulls, need
    )
end

--
function get_chance(need, pulls, has, total)
    if has < need then
        return 0
    end


    -- N = total
    -- n = pulls
    -- K = has
    -- k = need

    local Nn = binomial(total, pulls)


    local function exact_chance(amount)
        return binomial(has, amount) * binomial(total - has, pulls - amount) / Nn
    end

    local chance = 1

    for i = need, pulls do
        chance = chance * (1 - exact_chance(i))
    end

    return 1 - chance
end

-- assume n >= k
function binomial(n, k)
    if n <= k then return 1 end

    local a, b, c = 1, 1, 1

    local function fact(i)
        a = a * i

        if i == k then b = a end
        if i == (n - k) then c = a end
        if i == n then return a / (b * c) end

        return fact(i + 1)
    end

    local value = fact(1)

    return value
end

local Card_get_chip_mult_ref = Card.get_chip_mult
function Card:get_chip_mult(context)
    context = context or { }

    if not context.tcg_predict then return Card_get_chip_mult_ref(self, context) end

    local effect = self.ability.effect

    if self.ability.set == 'Joker' then return 0 end
    local ret = (not self.ability.extra_enhancement and self.ability.perma_mult) or 0
    if self.ability.effect == "Lucky Card" then
        if SMODS.pseudorandom_probability(self, 'lucky_mult', 1, 5) then
            self.lucky_trigger = true
            ret = ret + self.ability.mult
        end
    else
        ret = ret + self.ability.mult
    end
    -- TARGET: get_chip_mult
    return ret
end

local Card_get_chip_bonus_ref = Card.get_chip_bonus
function Card:get_chip_bonus(context)
    context = context or { }

    if self.ability.set == 'Joker' and G.GAME.used_vouchers['v_hone'] then return 50 end

    return Card_get_chip_bonus_ref(self, context)
end

local Card_get_chip_x_mult_ref = Card.get_chip_x_mult
function Card:get_chip_x_mult(context)
    context = context or { }
    
    if self.ability.set == 'Joker' and G.GAME.used_vouchers['v_glow_up'] then return 1.5 end

    return Card_get_chip_x_mult_ref(self, context)
end


local ref_check_and_set_high_score = check_and_set_high_score
function check_and_set_high_score(score, amt)
    if BalatroTCG.GameActive then
        return
    end
    ref_check_and_set_high_score(score, amt)
end


local ref_draw_from_play_to_discard = G.FUNCS.draw_from_play_to_discard
G.FUNCS.draw_from_play_to_discard = function(e)

    local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
    if BalatroTCG.GameActive then BalatroTCG.Status_Current.status.last_hand = text end
    ref_draw_from_play_to_discard(e)

end

local ref_draw_from_deck_to_hand = G.FUNCS.draw_from_deck_to_hand
G.FUNCS.draw_from_deck_to_hand = function(e)
    if not G.hand then return false end
    local val = ref_draw_from_deck_to_hand(e)
    

    return val
end

local draw_card_ref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    draw_card_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

local play_sound_ref = play_sound
function play_sound(sound_code, per, vol)
    if BalatroTCG.MuteAudio and not G.SETTINGS.paused then return end
    play_sound_ref(sound_code, per, vol)
end

local reset_mail_rank_ref = reset_mail_rank
function reset_mail_rank()
    if not BalatroTCG.GameActive then return reset_mail_rank_ref() end

    G.GAME.current_round.mail_card.rank = 'Ace'
    local valid_mail_cards = {}
    local valid_mail_ranks = {}
    for k, v in ipairs(G.playing_cards) do
        if v.ability.effect ~= 'Stone Card' and not SMODS.has_no_rank(v) then
            valid_mail_cards[#valid_mail_cards+1] = v

            local canplace = true
            for i = 1, #valid_mail_ranks do
                if valid_mail_ranks[i].base.value == v.base.value then
                    canplace = false
                    break
                end
            end
            if canplace then
                valid_mail_ranks[#valid_mail_ranks+1] = v
            end
        end
    end

    if true then
        if valid_mail_cards[1] then
            local mail_card = pseudorandom_element(valid_mail_cards, pseudoseed('mail'..G.GAME.round_resets.ante))
            G.GAME.current_round.mail_card.rank = mail_card.base.value
            G.GAME.current_round.mail_card.id = mail_card.base.id
        end
    else
        if valid_mail_ranks[1] then
            local mail_card = pseudorandom_element(valid_mail_ranks, pseudoseed('mail'..G.GAME.round_resets.ante))
            G.GAME.current_round.mail_card.rank = mail_card.base.value
            G.GAME.current_round.mail_card.id = mail_card.base.id
        end
    end
end


local reset_castle_card_ref = reset_castle_card
function reset_castle_card()
    if not BalatroTCG.GameActive then return reset_castle_card_ref() end

    G.GAME.current_round.castle_card.suit = 'Spades'
    local valid_castle_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if v.ability.effect ~= 'Stone Card' and v:is_playing_card() then
            if not SMODS.has_no_suit(v) then
                valid_castle_cards[#valid_castle_cards+1] = v
            end
        end
    end
    if valid_castle_cards[1] then
        local castle_card = pseudorandom_element(valid_castle_cards, pseudoseed('cas'..G.GAME.round_resets.ante))
        G.GAME.current_round.castle_card.suit = castle_card.base.suit
    end
end

local game_delete_run_ref = Game.delete_run
function Game:delete_run(args)

    BalatroTCG.GameActive = false
    BalatroTCG.GameStarted = false


    BalatroTCG.GraveyardView = false
    BalatroTCG.MuteAudio = false
    BalatroTCG.PlayerActive = false
    BalatroTCG.UseTCG_UI = false
    BalatroTCG.SavedSpeed = nil
    BalatroTCG.Status_Current = nil
    BalatroTCG.Status_Other = nil


    game_delete_run_ref(self, args)

    -- Another "why does this fix a bug that shouldn't be happening?"
    G.jokers = nil

    if BalatroTCG.Player then
        BalatroTCG.Player:remove()
        BalatroTCG.Opponent:remove()
    end
    BalatroTCG.Player = nil
    BalatroTCG.Opponent = nil


    -- Not sure why I need to do this but oh well
    -- Shouldn't break anything?
    SMODS.cards_to_draw = 0
end


local save_run_ref = save_run
function save_run()
    if not BalatroTCG.GameActive then
        save_run_ref()
    end
end

local Blind_debuff_hand_ref = Blind.debuff_hand
function Blind:debuff_hand(cards, hand, handname, check)

    for k, v in ipairs(cards) do
        if v:is_playing_card() then
            return Blind_debuff_hand_ref(self, cards, hand, handname, check)
        end
    end
    return false
end

local ease_dollars_ref = ease_dollars
function ease_dollars(mod, instant)

    if not BalatroTCG.GameActive then return ease_dollars_ref(mod, instant) end

    mod = math.min(BalatroTCG.Status_Current.status.max_budget, BalatroTCG.Status_Current.status.dollars + mod) - BalatroTCG.Status_Current.status.dollars

    if BalatroTCG.PlayerActive then
        if mod > 0 then
            BalatroTCG.Player:add_play_stats('healing', mod, BalatroTCG.Player.status.round)
        end
        ease_dollars_ref(mod, instant)
    else
        G.GAME.dollars = G.GAME.dollars + mod
        BalatroTCG.Opponent.status.dollars = G.GAME.dollars
    end
end

local create_UIBox_options_ref = create_UIBox_options
function create_UIBox_options()
    --G.SETTINGS.GAMESPEED = BalatroTCG.SavedSpeed or G.SETTINGS.GAMESPEED
    return create_UIBox_options_ref()
end

-- I'm scared this will break something
local emplace_Index = 0

local CardArea_emplace_ref = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
    emplace_Index = emplace_Index + 1
    
    if emplace_Index == 1 and #self.cards >= self.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0) then
    
        if self == G.consumeables and G.GAME.modifiers.consumeable_in_jokers then
            G.jokers:emplace(card, 0, stay_flipped)
            emplace_Index = emplace_Index - 1
            return
        elseif self == G.jokers and G.GAME.modifiers.joker_in_consumeables then
            G.consumeables:emplace(card, 0, stay_flipped)
            emplace_Index = emplace_Index - 1
            return
        end

    end

    if BalatroTCG.GameActive and BalatroTCG.Status_Current then
        if BalatroTCG.GameStarted and not BalatroTCG.MP_Lobby or BalatroTCG.PlayerActive then
            BalatroTCG.Status_Current:setup_visuals(card, self)
        end

        if self == G.jokers or self == G.consumeables then
            card:set_tcg_health(BalatroTCG.Status_Current.params.joker_health)
        end
        if self == G.deck or self == G.graveyard then
            card:disable_tcg_health()
            if card.ability.set == 'Joker' then
                card:set_edition(nil, false)
                card:set_perishable(false)
                card:set_rental(false)
            end
        end

        if card.ability.set == 'Planet' and (self == G.consumeables or self == G.jokers) then
            if G.GAME.used_vouchers.v_planet_tycoon then
                self.config.card_limit = self.config.card_limit + 1
                card.ability.queue_negative_removal = true
            end
        elseif card.ability.set == 'Tarot' and (self == G.consumeables or self == G.jokers) then
            if G.GAME.used_vouchers.v_tarot_tycoon then
                self.config.card_limit = self.config.card_limit + 1
                card.ability.queue_negative_removal = true
            end
        end
    end
    card.last_area = self

    local ret = CardArea_emplace_ref(self, card, location, stay_flipped)

    if BalatroTCG.GameStarted and BalatroTCG.Opponent.hard_set then BalatroTCG.Opponent:hard_set() end

    emplace_Index = emplace_Index - 1

    return ret
end

local create_UIBox_detailed_tooltip_ref = create_UIBox_detailed_tooltip
function create_UIBox_detailed_tooltip(_center)
    
    if BalatroTCG.UseTCG_UI then
        _center = create_tcg_center(_center)
    end

    return create_UIBox_detailed_tooltip_ref(_center)
end

local start_dissolve_ref = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)


    if self.tcg_todeck and not (self.tcg_extra and self.tcg_extra.virtual) then
        

        if self.ability.queue_negative_removal then
            if self.area then
                self.area.config.card_limit = self.area.config.card_limit - 1
            end
        end

        if self.area then self.area:remove_card(self) end
        self:remove_from_deck()

        self:set_ability(G.P_CENTERS[self.config.center.key])

        G.discard:emplace(self)
        self:start_materialize(nil, true, 0.01)
        self.tcg_todeck = nil
    else
        start_dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
    end
end

local start_setup_run_ref = G.FUNCS.start_setup_run
G.FUNCS.start_setup_run = function(e)
    BalatroTCG.GameActive = false

    return start_setup_run_ref(e)
end

local G_FUNCS_can_play_ref = G.FUNCS.can_play
G.FUNCS.can_play = function(e)
    if BalatroTCG.GameActive and not BalatroTCG.Status_Current:can_do_things() then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        return
    end
    G_FUNCS_can_play_ref(e)
end

local G_FUNCS_can_discard_ref = G.FUNCS.can_discard
G.FUNCS.can_discard = function(e)
    if BalatroTCG.GameActive and not BalatroTCG.Status_Current:can_do_things() then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        return
    end
    G_FUNCS_can_discard_ref(e)

    if G.deck and G.deck.cards[1] and G.GAME.modifiers.extra_discard and (G.GAME.modifiers.extra_discard < G.GAME.dollars - G.GAME.bankrupt_at) then
        e.config.colour = G.C.RED
        e.config.button = 'discard_cards_from_highlighted'
    end

end

-- local generate_card_ui_ref = generate_card_ui
-- function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
--     if BalatroTCG.GameStarted and not BalatroTCG.PlayerActive then
--         BalatroTCG.Player:set_card_areas()
--     end

--     -- if card and card.tcg_extra.has_health and not card.ability.eternal then
--     --     print("")
--     --     print(card.tcg_extra.health_amount)
--     --     specific_vars = specific_vars or {}
--     --     specific_vars.health_amount = card.tcg_extra.health_amount
--     --     badges[#badges + 1] = 'tcg_health'
--     -- end
    
--     local value = generate_card_ui_ref(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)

--     if BalatroTCG.GameStarted and not BalatroTCG.PlayerActive then
--         BalatroTCG.Status_Current:set_card_areas()
--     end
--     return value
-- end

local EventManager_add_event_ref = EventManager.add_event
function EventManager:add_event(event, queue, front)
    if self.instant_events then
        local results = G.ARGS.event_manager_update
        results.blocking, results.completed, results.time_done, results.pause_skip = false, false, false, false

        -- this is a really bad idea I can feel it
        while not results.completed do
            event:handle(results)
        end
    else
        return EventManager_add_event_ref(self, event, queue, front)
    end
end

local generate_card_ui_ref = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
	if card and card.tcg_deck_type then
		_c = G.P_CENTERS[card.tcg_deck_type]
		local ret = generate_card_ui_ref(
			_c,
			full_UI_table,
			specific_vars,
			"Back",
			badges,
			hide_desc,
			main_start,
			main_end,
			card
		)
        localize({ type = "descriptions", key = _c.key, set = _c.set, nodes = ret.main, vars = specific_vars })
		return ret
	end
	return generate_card_ui_ref(
		_c,
		full_UI_table,
		specific_vars,
		card_type,
		badges,
		hide_desc,
		main_start,
		main_end,
		card
	)
end

function pick_from_areas(check, areas, seed)
    seed = seed or ''
    local cards = {}
    for i = 1, #areas do

        for _, c in ipairs(areas[i].cards) do
            if check(c) then
                if BalatroTCG.Settings.Unbalance or areas[i] ~= G.graveyard or c.ability.name ~= 'The Hermit' then
                    cards[#cards + 1] = c
                end
            end
        end
    end

    if #cards > 0 then
        local card = pseudorandom_element(cards, pseudoseed(seed..G.GAME.round_resets.ante))

        return card
    end
    return false
end

function draw_from_graveyard_to_area(card, area)
    card.area:remove_card(card)
    card:start_materialize()
    G.consumeables:emplace(card)
end

local is_face_ref = Card.is_face
function Card:is_face(from_boss)
    if BalatroTCG.GameActive then
        if not self:is_playing_card() then return false end
        if is_face_ref(self, from_boss) then return true end
        return self:is_rank_joker({11, 12, 13})
    end
    return is_face_ref(self, from_boss)
end

local click_ref = Card.click
function Card:click()
    if BalatroTCG.GameActive and self.area and self.area.config.type == 'deck' and self.area.cards[1] == self then
        if not BalatroTCG.PlayerActive then
            G.SETTINGS.paused = true
            if G.deck_preview then
                G.deck_preview:remove()
                G.deck_preview = nil
            end
            G.FUNCS.overlay_menu{
                definition = G.UIDEF.deck_info(false),
            }
            return
        end

        return G.FUNCS.deck_info()
    end
    return click_ref(self)
end

local old_uidef_run_info = G.UIDEF.run_info
function G.UIDEF.run_info(...)
    if BalatroTCG.GameActive then
        return create_UIBox_generic_options({contents = {
            {n=G.UIT.O, config={object = UIBox{definition = create_UIBox_current_hands(), config = {offset = {x=0,y=0}}}}},
        }})

    else
        return old_uidef_run_info(...)
    end
end

load_custom_decks()