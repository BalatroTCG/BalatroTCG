--[[
Overview:

Balatro TCG is a mod that turns Balatro into a trading card game.
On most decks, you get one hand and two discard.
Your deck must contain 60 cards.
With some exceptions, you are limited to 10 jokers, 10 tarot cards, 6 planets, 4 spectrals, and no repeats.
Your health pool is your wallet.  Every player starts with 25 dollars.  There is no interest in most cases.
Once all your hands are used, your score is used to calculate your damage done to your opponent.  Your damage dealt is caculated by how many "E"s your score has.
-- 300 would be considered two points of damage, as it's 3.0e2, 10,000 is 4 points.
Limited to 2 rares or one legendary, and 3 uncommons
Any card used, sold, or destroyed is returned to the deck unless otherwise stated.
]]

--[[
Rebalancing Numbers:
-- 50 Chips
-- 5 Mult
-- 1.1x on trigger
-- 0.5x growth
-- 1 damage
-- 3 dollars earned
-- 1 dollars of defence
]]

-- 1.1x  = 0.04 damage
-- 1.25x = 0.10 damage
-- 1.5x  = 0.18 damage
-- 2x    = 0.30 damage
-- 3x    = 0.48 damage
-- 4x    = 0.60 damage

-- Average bloodstone = 1.5 ^ 2.5 = 0.44 points of damage
-- with sock = 1.5 ^ 5 = 0.88
-- with sock and dice = 1.5 ^ 10 = 1.76

-- Reworked bloodstone = 1.5 ^ 1.5 = 0.26 points of damage
-- with sock = 1.5 ^ 3.5 = 0.62
-- with sock and dice = 1.5 ^ 6.5 = 1.14

-- Reworked bloodstone = 1.25 ^ 2.5 = 0.24 points of damage
-- with sock = 1.25 ^ 5 = 0.48
-- with sock and dice = 1.25 ^ 10 = 0.97


--[[
Modifications:

Checkered deck allows only one red and one black suit, but one duplicate of each. (so clubs and diamonds are allowed)

Gold cards only give $2 at the end of your turn.

Golden ticket gives $2 per gold card played.
Burgler gives two hands, cannot be copied by bp/bs.
Card sharp counts the previous hand played that game regardless of which round.
Trading card works on any card, not just playing cards.  Discarded card is removed from the deck.
Credit card lets you live an extra $10 while held.  If sold while in the negative, you automatically lose.
Showman allows one extra card to bypass every limit excluding the deck size and Joker rarity limit.
Banner is +45 chips
Marble turns one random playing card in hand to stone
8 ball allows pulling one tarot card you choose from your deck when discard contains an 8.
Dusk retriggers all hands when under $10
Chaos -- 
DNA -- 
6th sense lets you pick one spectral card from the deck when you play one lone six.  Removes the 6 from the deck.
Constellation gives .2x.
Square gains chips on discards too.
Acrobat gains .1x mult for every round played.
Certificate puts a random stamp on a playing card held in hand.
Mr. Bones removes 10% of the damage done to you for each.
Riff-raff lets you pick one Joker from your deck and replace it with Riff-raff.
Vagabond lets you pick one tarot from your deck when under $4.
Golden Joker protects against $2 of damage.

Invisible is removed from the deck when sold.

Death works on tarots and planets.  Removes itself from the deck.
Emperor lets you pull out one tarot from your deck.
Priestess lets you pull out one planet from your deck.
Hermit is limited to $5.
Temperance is halved and limited to $25.
Sigil and Ouija effect jokers that are suit or rank exclusive.

]]

-- TODO:
-- 

BalatroTCG = SMODS.current_mod

local function init()
    local maxVal = 0

    for k, v in pairs(G.STATES) do
        maxVal = math.max(maxVal, v + 1)
    end
    
end

function BalatroTCG.load_file(file)
	local chunk, err = SMODS.load_file(file, "tcgb")
	if chunk then
		local ok, func = pcall(chunk)
		if ok then
			return func
		else
			sendWarnMessage("Failed to process file: " .. func, "BalatroTCG")
		end
	else
        error(err)
	end
	return nil
end

function BalatroTCG.load_dir(directory)
	local files = NFS.getDirectoryItems(BalatroTCG.path .. "/" .. directory)
	local regular_files = {}

	for _, filename in ipairs(files) do
		local file_path = directory .. "/" .. filename
		if file_path:match(".lua$") then
			if filename:match("^_") then
				BalatroTCG.load_file(file_path)
			else
				table.insert(regular_files, file_path)
			end
		end
	end

	for _, file_path in ipairs(regular_files) do
		BalatroTCG.load_file(file_path)
	end
end

BalatroTCG.load_dir("ui")
BalatroTCG.load_dir("src")

G.C.OPPONENT = HEX("AC3232")

function tableMerge(table1, table2)
	local result = {}
	for _, v in ipairs(table1) do
		table.insert(result, v)
	end
	for _, v in ipairs(table2) do
		table.insert(result, v)
	end
	return result
end

G.FUNCS.tcg_start_single = function(e)

    G.SETTINGS.paused = true

    G.E_MANAGER:clear_queue()
    G.FUNCS.wipe_on()
    G.E_MANAGER:add_event(Event({
        no_delete = true,
        func = function()
        G:delete_run()
        return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        no_delete = true,
        func = function()
        G:start_tcg_game({ starting = true })
        return true
        end
    }))
    G.FUNCS.wipe_off()
end

G.FUNCS.tcg_start_multi = function(e)

    G.SETTINGS.paused = true
    G.E_MANAGER:clear_queue()
    G.FUNCS.wipe_on()
    G.E_MANAGER:add_event(Event({
        no_delete = true,
        func = function()
        G:delete_run()
        return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        no_delete = true,
        func = function()
        G:start_tcg_game({ online = true, seed = e.seed, starting = e.starting == "true" })
        return true
        end
    }))
    G.FUNCS.wipe_off()
end


SMODS.Suit {
    key = 'Joker',
    card_key = 'Jk',
    pos = { y = 20 },
    ui_pos = { x = 20, y = 20 },
    hc_colour = HEX '000000',
    lc_colour = HEX '000000',
    max_nominal = {
        value = 1000,
    },
    
    in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        else
            return true
        end
    end
}
SMODS.Suit {
    key = 'Planet',
    card_key = 'Pl',
    pos = { y = 20 },
    ui_pos = { x = 20, y = 20 },
    hc_colour = HEX '000000',
    lc_colour = HEX '000000',
    max_nominal = {
        value = 1000,
    },
    
    in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        else
            return true
        end
    end
}
SMODS.Suit {
    key = 'Tarot',
    card_key = 'Tr',
    pos = { y = 20 },
    ui_pos = { x = 20, y = 20 },
    hc_colour = HEX '000000',
    lc_colour = HEX '000000',
    max_nominal = {
        value = 1000,
    },
    
    in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        else
            return true
        end
    end
}
SMODS.Suit {
    key = 'Spectral',
    card_key = 'Sp',
    pos = { y = 20 },
    ui_pos = { x = 20, y = 20 },
    hc_colour = HEX '000000',
    lc_colour = HEX '000000',
    max_nominal = {
        value = 1000,
    },
    
    in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        else
            return true
        end
    end
}

function Game:start_tcg_game(args)
    args = args or {}

    G.SAVED_GAME = nil
    G.hand = nil

    BalatroTCG.GameActive = true
    BalatroTCG.UseTCG_UI = true

    self:prep_stage(G.STAGES.RUN, G.STATES.NEW_ROUND)
    
    G.STAGE = G.STAGES.RUN
    
    G.STATE_COMPLETE = false
    G.RESET_BLIND_STATES = true

    ease_background_colour_blind(G.STATE, 'Small Blind')
    
    self.GAME.pseudorandom.seed = args.seed or generate_starting_seed()
    --self.GAME.pseudorandom.seed = "QX9I13Q8"
    self.GAME.subhash = ''
    self.GAME.pseudorandom.hashed_seed = pseudohash(self.GAME.pseudorandom.seed)

    print(self.GAME.pseudorandom.seed)
    BalatroTCG.SavedSpeed = G.SETTINGS.GAMESPEED

    local playerDeck = get_tcg_deck(BalatroTCG.SelectedDeck)
    local opponentDeck = get_tcg_deck(pseudorandom(generate_starting_seed(), 1, #BalatroTCG.DefaultDecks))

    if args.online then
        opponentDeck = BalatroTCG.Deck('empty', 'empty', {})
    end

    G.GAME.player_back = Back(get_deck_from_name(playerDeck.back))
    G.GAME.opponent_back = Back(get_deck_from_name(opponentDeck.back))
    
    BalatroTCG.Player = TCG_PlayerStatus(playerDeck, true)
    BalatroTCG.Opponent = TCG_PlayerStatus(opponentDeck, false)
    BalatroTCG.Status_Current = nil
    BalatroTCG.Status_Other = nil
    
    BalatroTCG.Player:apply()

    BalatroTCG.Player.Other = BalatroTCG.Opponent
    BalatroTCG.Opponent.Other = BalatroTCG.Player
    
    BalatroTCG.Player:set_screen_positions(true)
    BalatroTCG.Opponent:set_screen_positions(false)

    if args.online then
        BalatroTCG.AI = nil
    else
        BalatroTCG.AI = TCG_AI()
    end

    self.GAME = self:init_game_object()
    self.GAME.modifiers = {}
    self.GAME.stake = 1
    self.GAME.STOP_USE = 0
    self.GAME.selected_back = Back(G.P_CENTERS.b_red)

    G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
    G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]

    G.GAME.chips_text = ''

    G:save_settings()

    if SMODS.Scoring_Calculations then
        self.GAME.current_scoring_calculation = SMODS.Scoring_Calculations['multiply']:new()
    end

    if not self.GAME.round_resets.blind_tags then
        self.GAME.round_resets.blind_tags = {}
    end

    G.CONTROLLER.locks.load = true
    G.E_MANAGER:add_event(Event({
        no_delete = true,
        trigger = 'after',
        blocking = false,blockable = false,
        delay = 3.5,
        timer = 'TOTAL',
        func = function()
            G.CONTROLLER.locks.load = nil
          return true
        end
      }))


    G.SPLASH_BACK = Sprite(-30, -6, G.ROOM.T.w+60, G.ROOM.T.h+12, G.ASSET_ATLAS["ui_1"], {x = 2, y = 0})
    G.SPLASH_BACK:set_alignment({
        major = G.play,
        type = 'cm',
        bond = 'Strong',
        offset = {x=0,y=0}
    })

    G.ARGS.spin = {
        amount = 0,
        real = 0,
        eased = 0
    }

    G.SPLASH_BACK:define_draw_steps({{
        shader = 'background',
        send = {
            {name = 'time', ref_table = G.TIMERS, ref_value = 'REAL_SHADER'},
            {name = 'spin_time', ref_table = G.TIMERS, ref_value = 'BACKGROUND'},
            {name = 'colour_1', ref_table = G.C.BACKGROUND, ref_value = 'C'},
            {name = 'colour_2', ref_table = G.C.BACKGROUND, ref_value = 'L'},
            {name = 'colour_3', ref_table = G.C.BACKGROUND, ref_value = 'D'},
            {name = 'contrast', ref_table = G.C.BACKGROUND, ref_value = 'contrast'},
            {name = 'spin_amount', ref_table = G.ARGS.spin, ref_value = 'amount'}
        }}})
    
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        blocking = false,
        blockable = false,
        func = (function() 
            local _dt = G.ARGS.spin.amount > G.ARGS.spin.eased and G.real_dt*2. or 0.3*G.real_dt
            local delta = G.ARGS.spin.real - G.ARGS.spin.eased
            if math.abs(delta) > _dt then delta = delta*_dt/math.abs(delta) end
            G.ARGS.spin.eased = G.ARGS.spin.eased + delta
            G.ARGS.spin.amount = _dt*(G.ARGS.spin.eased) + (1 - _dt)*G.ARGS.spin.amount
            G.TIMERS.BACKGROUND = G.TIMERS.BACKGROUND - 60*(G.ARGS.spin.eased - G.ARGS.spin.amount)*_dt
        end)
    }))

    --delay(0.25)

    G.GAME.current_round.discards_left = G.GAME.round_resets.discards
    G.GAME.current_round.hands_left = G.GAME.round_resets.hands
    G.GAME.round = 1
    
    
    self.HUD = UIBox{
        definition = TCG_create_UIBox_HUD(),
        config = {align=('cli'), offset = {x=-0.7,y=-0.25},major = G.ROOM_ATTACH}
    }
    self.HUD_blind = UIBox{
        definition = TCG_create_UIBox_HUD_blind(),
        config = {major = G.HUD:get_UIE_by_ID('row_blind'), align = 'cm', offset = {x=0,y=-10}, bond = 'Weak'}
    }
    self.HUD_tags = {}
    
    G.playing_cards = {}
    G.jokers = {}
    G.jokers.cards = {}
    

    G.GAME.blind = Blind(0, 0, 2, 1)
    G.GAME.blind:set_blind(G.P_BLINDS['bl_small'], nil, true)
    G.GAME.blind.chips = 1000000000000000000000000000000

    G.hand_text_area = {
        chips = self.HUD:get_UIE_by_ID('hand_chips'),
        mult = self.HUD:get_UIE_by_ID('hand_mult'),
        ante = self.HUD:get_UIE_by_ID('ante_UI_count'),
        round = self.HUD:get_UIE_by_ID('round_UI_count'),
        chip_total = self.HUD:get_UIE_by_ID('hand_chip_total'),
        handname = self.HUD:get_UIE_by_ID('hand_name'),
        hand_level = self.HUD:get_UIE_by_ID('hand_level'),
        game_chips = self.HUD:get_UIE_by_ID('chip_UI_count'),
        blind_chips = self.HUD_blind:get_UIE_by_ID('HUD_blind_count'),
        blind_spacer = self.HUD:get_UIE_by_ID('blind_spacer')
    }
    
    BalatroTCG.PlayerActive = false
    --switch_player(args.starting)
    
    if G.SETTINGS.FN then
        G.SETTINGS.FN.preview_score = false
        G.SETTINGS.FN.preview_dollars = false
        G.SETTINGS.FN.hide_face_down = true
        G.SETTINGS.FN.show_min_max = true
    end

    if true then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                G.STATE = G.STATES.DRAW_TO_HAND
                G.STATE_COMPLETE = false
                return true
            end
        }))
    end

    self.HUD:recalculate()
    
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.starting_betting(),
	})
	G.OVERLAY_MENU.config.no_esc = true

end

function TCG_GetDamage()

    local value = G.GAME.chips

    if value > 0 then
        value = math.floor(math.log10(value))
        value = value * value
        return value
    else
        return 0
    end
end

G.FUNCS.chip_UI_damage = function(e)
    
    local value = TCG_GetDamage()
    if not BalatroTCG.PlayerActive then
        value = 0
    end
    local new_chips_text = number_format(value)

    if G.GAME.chips_damage ~= new_chips_text then
        e.config.scale = math.min(0.8, scale_number(value, 1.1))
        G.GAME.chips_damage = new_chips_text
    end
end

function end_tcg_round()
    
    BalatroTCG.Switching = true

    BalatroTCG.Player:send_message({ type = 'deck', deck = BalatroTCG.Player.back_key })

    local damage = TCG_GetDamage()


    if BalatroTCG.PlayerActive then
        delay(0.2)
        ease_round(1)
    else
        BalatroTCG.Opponent.status.round = BalatroTCG.Opponent.status.round + 1
    end
    
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            
    
        G.E_MANAGER:add_event(Event({
            trigger = 'ease',
            blocking = false,
            ref_table = G.GAME,
            ref_value = 'chips',
            ease_to = 0,
            delay =  0.5,
            func = (function(t) return math.floor(t) end)
        }))

        if BalatroTCG.PlayerActive then
            delay(0.5)
        end

        SMODS.calculate_context({end_of_round = true, game_over = false })

        for _,v in ipairs(SMODS.get_card_areas('playing_cards', 'end_of_round')) do
            SMODS.calculate_end_of_round_effects({ cardarea = v, end_of_round = true })
        end
        delay(0.3)
        if BalatroTCG.Status_Current.back.calculate_deck then
            BalatroTCG.Status_Current.back.calculate_deck({ end_of_round = true, status = BalatroTCG.Status_Current, full_deck = BalatroTCG.Status_Current.deck})
        end
        
        BalatroTCG.Status_Current.status.unused_discards = (BalatroTCG.Status_Current.status.unused_discards or 0) + G.GAME.current_round.discards_left

        G.FUNCS.draw_from_hand_to_discard()
        G.FUNCS.draw_from_discard_to_deck()
        
        if G.GAME.round_resets.temp_handsize then G.hand:change_size(-G.GAME.round_resets.temp_handsize); G.GAME.round_resets.temp_handsize = nil end
        
        for k, v in ipairs(G.playing_cards) do
            v.ability.discarded = nil
            v.ability.forced_selection = nil
        end

        if damage > 0 then
            local index = 0
            table.sort(BalatroTCG.Status_Current.opponentJokers.cards, function(a,b) return a.T.x < b.T.x end)
            for i, joker in ipairs(BalatroTCG.Status_Current.opponentJokers.cards) do
                if joker.highlighted then
                    index = i
                end
            end
            BalatroTCG.Status_Current:send_message({ type = 'attack', damage = damage, index = index })
            if BalatroTCG.Status_Current.back.calculate_deck then
                BalatroTCG.Status_Current.back.calculate_deck({ damaging = true, status = BalatroTCG.Status_Current, damage = damage})
            end
        end
        BalatroTCG.Status_Current:send_message({ type = 'jokers', jokers = #BalatroTCG.Status_Current.jokers.cards })
        BalatroTCG.Status_Current:send_message({ type = "health", health = BalatroTCG.Status_Current.status.dollars })
        
        local cost = 0
        for _, joker in ipairs(G.jokers.cards) do
            joker:set_cost()
            cost = joker.sell_cost
        end
        BalatroTCG.Status_Current:send_message({ type = 'joker_cost', amount = cost })
        
        for _, joker in ipairs(BalatroTCG.Status_Current.opponentJokers.cards) do
            joker:highlight(false)
        end
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1.5,
            func = function()
                if MP and MP.LOBBY and MP.LOBBY.code then
                    Client.send({action = "tcgEndTurn" })
                end
                switch_player(not BalatroTCG.PlayerActive)
                return true
            end
        }))
        
        return true
    end
    }))
end



function switch_player(playerActive)
    
    if BalatroTCG.Status_Current then
        SMODS.calculate_context({ switching_players = true, old_player = BalatroTCG.Status_Current, new_player = BalatroTCG.Status_Other })
    end
    
    BalatroTCG.PlayerActive = playerActive
    if BalatroTCG.PlayerActive then
        G.SETTINGS.GAMESPEED = BalatroTCG.SavedSpeed or G.SETTINGS.GAMESPEED
        G.SETTINGS.GAMESPEED = 4

        BalatroTCG.Status_Current = BalatroTCG.Player
        BalatroTCG.Status_Other = BalatroTCG.Opponent
        BalatroTCG.Player:apply()
    else
        
        BalatroTCG.SavedSpeed = G.SETTINGS.GAMESPEED
        if _RELEASE_MODE then
            G.SETTINGS.GAMESPEED = 1000
        end

        BalatroTCG.Status_Current = BalatroTCG.Opponent
        BalatroTCG.Status_Other = BalatroTCG.Player
        BalatroTCG.Opponent:apply()
    end
    
    G.RESET_JIGGLES = nil
    BalatroTCG.Switching = false

    --print("Setting state: " .. tostring(BalatroTCG.PlayerActive))
    
end

if MP then
    local generate_hashlocal = MP.generate_hash
    function MP:generate_hash()
        generate_hashlocal(self)
    end

    local should_use_the_order_local = MP.should_use_the_order
    function MP.should_use_the_order()
        if BalatroTCG.GameActive then
            return false
        end
        return should_use_the_order_local()
    end
end

function end_tcg_game(win)
    
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            for k, v in pairs(G.I.CARD) do
                v.sticker_run = nil
            end
            
            if win then
                play_sound('win')
            else
                play_sound('negative', 0.5, 0.7)
                play_sound('whoosh2', 0.9, 0.7)
            end
            G.SETTINGS.paused = true

            if not win and (MP and MP.LOBBY and MP.LOBBY.code) then
                BalatroTCG.Opponent:send_message({ type = 'win_game' })
            end

            G.FUNCS.overlay_menu{
                definition = create_tcg_end_box(win),
                config = {no_esc = true}
            }
            
            return true
        end)
    }))
end

function create_tcg_end_box(win)
  local show_lose_cta = false
  local eased_green = copy_table(win and G.C.GREEN or G.C.RED)
  eased_green[4] = 0
  ease_value(eased_green, 4, 0.5, nil, nil, true)
  local t = create_UIBox_generic_options({ padding = 0, bg_colour = eased_green , colour = G.C.BLACK, outline_colour = G.C.EDITION, no_back = true, no_esc = true, contents = {
    {n=G.UIT.R, config={align = "cm"}, nodes={
      win and {n=G.UIT.O, config={object = DynaText({string = {localize('ph_you_win')}, colours = {G.C.EDITION},shadow = true, float = true, spacing = 10, rotate = true, scale = 1.5, pop_in = 0.4, maxw = 6.5})}}
      or      {n=G.UIT.O, config={object = DynaText({string = {localize('ph_game_over')}, colours = {G.C.RED},shadow = true, float = true, spacing = 10, scale = 1.5, pop_in = 0.4, maxw = 6.5})}},
    }},
    {n=G.UIT.R, config={align = "cm", padding = 0.15}, nodes={
      {n=G.UIT.C, config={align = "cm"}, nodes={
    {n=G.UIT.R, config={align = "cm", padding = 0.08}, nodes={
      create_UIBox_round_scores_row('hand'),
      create_UIBox_round_scores_row('poker_hand'),
    }},
    {n=G.UIT.R, config={align = "cm"}, nodes={
      {n=G.UIT.C, config={align = "cm", padding = 0.08}, nodes={
        create_UIBox_round_scores_row('cards_played', G.C.BLUE),
        create_UIBox_round_scores_row('cards_discarded', G.C.RED),
        create_UIBox_round_scores_row('cards_purchased', G.C.MONEY),
      }},
      BalatroTCG.MP_Lobby and 
      {n=G.UIT.C, config={align = "tr", padding = 0.08}, nodes={
        UIBox_button({id = 'from_game_won', button = 'mp_return_to_lobby', label = {localize('b_return_lobby')}, minw = 2.5, maxw = 2.5, minh = 1, focus_args = {nav = 'wide', snap_to = true}}),
        UIBox_button({button = 'go_to_menu', label = {localize('b_main_menu')}, minw = 2.5, maxw = 2.5, minh = 1, focus_args = {nav = 'wide'}}),
      }}
      or 
      {n=G.UIT.C, config={align = "tr", padding = 0.08}, nodes={
        UIBox_button({id = 'from_game_won', button = 'start_campaign', label = {localize('b_start_new_run')}, minw = 2.5, maxw = 2.5, minh = 1, focus_args = {nav = 'wide', snap_to = true}}),
        UIBox_button({button = 'go_to_menu', label = {localize('b_main_menu')}, minw = 2.5, maxw = 2.5, minh = 1, focus_args = {nav = 'wide'}}),
      }}
    }}
  }}
  }}
  }}) 
  t.nodes[1] = {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
      {n=G.UIT.C, config={align = "cm", padding = 2}, nodes={
        {n=G.UIT.O, config={padding = 0, id = 'jimbo_spot', object = Moveable(0,0,G.CARD_W*1.1, G.CARD_H*1.1)}},
      }},
      {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={t.nodes[1]}
    }}
  }
  --t.nodes[1].config.mid = true
  t.config.id = 'you_win_UI'
  return t
end

init()

