
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

local Card_highlight_ref = Card.highlight
function Card:highlight(is_higlighted)
    self.highlighted = is_higlighted
    
    if self.area and (self.area.config.type == 'tcgdeck_buy' or self.area.config.type == 'tcgdeck_remove') then
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
                definition = self.area.config.type == 'tcgdeck_buy' and G.UIDEF.tcg_add_to_deck(self) or G.UIDEF.tcg_remove_to_deck(self), 
                config = {align= "bmi", offset = {x=0,y=0.85},parent =self}
            }
        elseif self.children.use_button then
            self.children.use_button:remove()
            self.children.use_button = nil
        end
    else
        Card_highlight_ref(self, is_higlighted)
    end
end

local Card_add_to_deck_ref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
    local obj = self.config.center

    if BalatroTCG.GameActive and obj and obj.tcg_add_to_deck and type(obj.tcg_add_to_deck) == 'function' then
        obj.tcg_add_to_deck(self, from_debuff)
        return
    else
        Card_add_to_deck_ref(self, from_debuff)
    end
end
local Card_remove_from_deck_ref = Card.remove_from_deck
function Card:remove_from_deck(from_debuff)
    local obj = self.config.center

    if BalatroTCG.GameActive and obj and obj.tcg_remove_from_deck and type(obj.tcg_remove_from_deck) == 'function' then
        obj.tcg_remove_from_deck(self, from_debuff)
        return
    else
        Card_remove_from_deck_ref(self, from_debuff)
    end
end

local Game_save_settings_ref = Game.save_settings
function Game:save_settings()
    
    local temp = G.SETTINGS.GAMESPEED
    G.SETTINGS.GAMESPEED = BalatroTCG.SavedSpeed

    Game_save_settings_ref(self)

    G.SETTINGS.GAMESPEED = temp
end

function G.UIDEF.tcg_add_to_deck(e)
    local use = nil
    use = {n=G.UIT.C, config={align = "cr"}, nodes={
      {n=G.UIT.C, config={ref_table = e, align = "bm",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 1.5, hover = true, shadow = true, colour = G.C.GOLD, button = 'add_tcg_card'}, nodes={
        
        {n=G.UIT.T, config={text = G.tcg_tab == 'Backs' and localize('b_tcg_apply') or (localize('$') .. tostring(e.cost)),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
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
function G.UIDEF.tcg_remove_to_deck(e)
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
                    BalatroTCG.BuildingDeck.back = c.original_id
                else
                    if c.ability.set == 'Joker' then
                        table.insert(BalatroTCG.BuildingDeck.cards, { type = 'j', c = c.original_id })
                    elseif c.ability.set == 'Default' then
                        table.insert(BalatroTCG.BuildingDeck.cards, { type = 'p', r = SMODS.Ranks[c.base.value].card_key, s = SMODS.Suits[c.base.suit].card_key })
                    elseif c.ability.set == 'Spectral' or c.ability.set == 'Tarot' or c.ability.set == 'Planet' then
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
    self.ability.tcg_extra = {}
end

function Card:is_playing_card()
    return self.ability.set == 'Default' or self.ability.set == 'Enhanced'
end

function Card:override_rank(rank)
    self.ability.tcg_extra.rank = G.P_CARDS['H_' .. rank].value
end

function Card:override_suit(suit)
    self.ability.tcg_extra.suit = G.P_CARDS[suit .. '_2'].suit
end

local can_use_consumeable_ref = Card.can_use_consumeable
function Card:can_use_consumeable(any_state, skip_check)
    local value = can_use_consumeable_ref(self, any_state, skip_check)

    if not BalatroTCG.GameActive then
        return value
    end
    
    if value then
        if self.ability.name == 'Death' then
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
            
        elseif self.ability.effect == 'Enhance' or
            self.ability.effect == 'Suit Conversion' or
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


function get_TCG_params(back)
    local ret = {
        dollars = 75,
        hand_size = 8,
        discards = 2,
        hands = 1,
        joker_slots = 5,
        consumable_slots = 2,
        discount = 0,
        joker_health = 25,
        destroy_planets = false,
        destroy_tarots = true,
        destroy_spectrals = true,
    }

    local deck

    if back then
        deck = Back(get_deck_from_name(back))
    end
    
    if deck and deck.tcg_apply then
        deck:tcg_apply(params)
    else
        if back == 'Red Deck' then
            ret.discards = ret.discards + 1
        elseif back == 'Blue Deck' then
            ret.hands = ret.hands + 1
        elseif back == 'Yellow Deck' then
            ret.dollars = ret.dollars + 25
        elseif back == 'Green Deck' then
            -- Green
        elseif back == 'Black Deck' then
            ret.joker_slots = ret.joker_slots + 1
            ret.hand_size = ret.hand_size - 1
        elseif back == 'Magic Deck' then
            --ret.consumable_slots = ret.consumable_slots + 1
            
        elseif back == 'Nebula Deck' then
        elseif back == 'Ghost Deck' then
            
        elseif back == 'Abandonded Deck' then

        elseif back == 'Checkered Deck' then
            
        elseif back == 'Zodiac Deck' then
            ret.discount = 20
        elseif back == 'Painted Deck' then
            ret.hand_size = ret.hand_size + 2
            ret.joker_slots = ret.joker_slots - 1
        elseif back == 'Anaglyph Deck' then
            
        elseif back == 'Plasma Deck' then
            
        elseif back == 'Erratic Deck' then
        elseif back == 'Challenge Deck' then
            ret.destroy_tarots = false
            ret.destroy_spectrals = false
            ret.joker_slots = 0
        end
    end

    return ret
end

local SMODS_inject_p_card_ref = SMODS.inject_p_card
SMODS.inject_p_card = function(suit, rank)
    if suit.card_key == 'tcgb_Jk' or suit.card_key == 'tcgb_Pl' or suit.card_key == 'tcgb_Sp' or suit.card_key == 'tcgb_Tr' then return end
    SMODS_inject_p_card_ref(suit, rank)
end

local pseudorandom_element_ref = pseudorandom_element
function pseudorandom_element(_t, seed, args)

    local newTable = {}
    for k, v in pairs(_t) do
        if type(v) == "table" then
            if k == 'tcgb_Jk' or k == 'tcgb_Pl' or k == 'tcgb_Sp' or k == 'tcgb_Tr' then

            else
                newTable[k] = v
            end
        else
            newTable[k] = v
        end
    end

    return pseudorandom_element_ref(newTable, seed, args)
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

G.FUNCS.can_buy_tcg = function(e)
    local v = e.config.ref_table

    if (v.config.center.no_pool_flag and G.GAME.pool_flags[v.config.center.no_pool_flag]) or
        (v.config.center.yes_pool_flag and not G.GAME.pool_flags[v.config.center.yes_pool_flag]) or
        ((e.config.ref_table.cost >= G.GAME.dollars - G.GAME.bankrupt_at) and (e.config.ref_table.cost > 0)) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.ORANGE
        e.config.button = 'buy_from_shop'
    end
    if e.config.ref_parent and e.config.ref_parent.children.buy_and_use then
      if e.config.ref_parent.children.buy_and_use.states.visible then
        e.UIBox.alignment.offset.y = -0.6
      else
        e.UIBox.alignment.offset.y = 0
      end
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
    return ref_draw_from_deck_to_hand(e)
end

local play_sound_ref = play_sound
function play_sound(sound_code, per, vol)
    if BalatroTCG.MuteAudio and not G.SETTINGS.paused then return end
    --if not (MP and MP.LOBBY and MP.LOBBY.code) and BalatroTCG.GameActive and not BalatroTCG.PlayerActive then return end
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
    
    game_delete_run_ref(self, args)
    
    
    BalatroTCG.GameActive = false
    BalatroTCG.GameStarted = false
    BalatroTCG.MuteAudio = false
    BalatroTCG.PlayerActive = false
    BalatroTCG.UseTCG_UI = false
    BalatroTCG.SavedSpeed = nil
    BalatroTCG.Player = nil
    BalatroTCG.Opponent = nil
    BalatroTCG.Status_Current = nil
    BalatroTCG.Status_Other = nil
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
    G.SETTINGS.GAMESPEED = BalatroTCG.SavedSpeed or G.SETTINGS.GAMESPEED
    return create_UIBox_options_ref()
end

local CardArea_emplace_ref = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
    local ret = CardArea_emplace_ref(self, card, location, stay_flipped)

    if BalatroTCG.Opponent and BalatroTCG.Opponent.hard_set then BalatroTCG.Opponent:hard_set() end

    return ret
end

local start_dissolve_ref = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)

    if self.tcg_todeck then
        if self.area then self.area:remove_card(self) end
        self:remove_from_deck()
        if self.ability.queue_negative_removal then 
            if self.ability.consumeable then
                G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
            else
                G.jokers.config.card_limit = G.jokers.config.card_limit - 1
            end 
        end
        
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
    BalatroTCG.UseTCG_UI = false
    
    return start_setup_run_ref(e)
end


function pick_from_areas(check, areas, toplace, seed)
    seed = seed or ''
    for i = 1, #areas do
        local cards = {}
        
        for _, c in ipairs(areas[i].cards) do
            if check(c) then
                cards[#cards + 1] = c
            end
        end

        if #cards > 0 then
            local card = pseudorandom_element(cards, pseudoseed(seed..G.GAME.round_resets.ante))
            
            card.area:remove_card(card)
            card:start_materialize()
            toplace:emplace(card)
            
            for _, c in ipairs(G.playing_cards) do
                if c == card then
                    return true
                end
            end
            table.insert(G.playing_cards, card)

            return true
        end
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
    if BalatroTCG.GameActive and not self:is_playing_card() then return false end
    return is_face_ref(self, from_boss)
end

local click_ref = Card.click
function Card:click()
    if not BalatroTCG.GameActive or BalatroTCG.PlayerActive then
        return click_ref(self)
    end
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