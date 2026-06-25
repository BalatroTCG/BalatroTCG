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
-- 0.5 damage?
-- 3 dollars earned
-- 1 dollars of defence
]]

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


BalatroTCG = SMODS.current_mod

BalatroTCG.VersionText = SMODS.Mods["tcgb"].version .. "-TCG"

function splitlines(inputstr, sep)
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
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
BalatroTCG.load_dir("src/Backs")
BalatroTCG.load_dir("src/Jokers")
BalatroTCG.load_dir("src/Spectrals")
BalatroTCG.load_dir("src/Tarots")
BalatroTCG.load_dir("src/Vouchers")
BalatroTCG.load_dir("src/Rulesets")

SMODS.Atlas({
	key = "sticker_hidden",
	path = "sticker_hidden.png",
	px = 71,
	py = 95,
})
SMODS.Atlas({
	key = "sticker_visible",
	path = "sticker_visible.png",
	px = 71,
	py = 95,
})
SMODS.Atlas({
    key = 'logo',
    path = 'logo.png',
    px = 390,
    py = 320,
})

SMODS.Sticker{
    key = "sticker_hidden",
    atlas = "sticker_hidden",
    badge_colour = HEX '4c4ec7',
	default_compat = false,
	needs_enable_flag = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.tcgb_health_amount or 0, card.ability.tcgb_max_health or (BalatroTCG.GameActive and BalatroTCG.Status_Current.params.joker_health or 15)}}
    end,
}
SMODS.Sticker{
    key = "sticker_visible",
    atlas = "sticker_visible",
    badge_colour = HEX 'ef4864',
	default_compat = false,
	needs_enable_flag = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.tcgb_health_amount or 0, card.ability.tcgb_max_health or (BalatroTCG.GameActive and BalatroTCG.Status_Current.params.joker_health or 15)}}
    end,
}

BalatroTCG.config_tab = function()

	-- MP.PREVIEW.text = SMODS.Mods["tcgb"].config.preview.text or ""
	-- MP.PREVIEW.button = SMODS.Mods["tcgb"].config.preview.button or ""
	local ret = {
		n = G.UIT.ROOT,
		config = {
			r = 0.1,
			minw = 5,
			align = "cm",
			padding = 0.2,
			colour = G.C.BLACK,
		},
		nodes = {
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm",
					on_demand_tooltip = {
						text = {
							localize("k_tcg_balance_desc"),
						},
					},
				},
				nodes = {
					create_toggle({
						id = "balance_option",
						label = localize("b_opts_tcg_balanced"),
						ref_table = BalatroTCG.config,
						ref_value = "Balance",
					}),
				},
			},
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm",
					on_demand_tooltip = {
						text = {
							localize("k_opponent_mirror_desc"),
						},
					},
				},
				nodes = {
					create_toggle({
						id = "flip_opponent_option",
						label = localize("b_opts_tcg_flip"),
						ref_table = BalatroTCG.config,
						ref_value = "FlipOpponent",
					}),
				},
			},
		},
	}
	return ret
end

SMODS.Atlas({
	key = "player_blinds",
	path = "player_blinds.png",
	atlas_table = "ANIMATION_ATLAS",
	frames = 21,
	px = 34,
	py = 34,
})


local _start_up = Game.start_up
function Game:start_up()
    _start_up(self)
    reset_tcg_settings()
end

function reset_tcg_settings()
    BalatroTCG.Settings = {
        Unbalance = not BalatroTCG.config.Balance,
        StartingMoney = 100,
        DefaultHands = 2,
        DefaultDiscards = 2,
        JokerHealth = 20,
        MoneyLeak = true,
        MoneyLeakStart = 10,
        MoneyLeakIncrease = 2,
        EndingRound = true,
        DamageCalc = "Linear",
        RoundEnd = 15,
        WinCondition = "Highest Money",
        DeckLimitations = {
            Money = true,
            Size = true,
            Jokers = true,
            Consumeables = true,
            BackCounts = true
        }
    }
end

reset_tcg_settings()

function set_tcg_mp_settings()
    BalatroTCG.Settings = {
        Unbalance = not MP.LOBBY.config.tcg_balanced,
        StartingMoney = MP.LOBBY.config.health_pool,
        DefaultHands = MP.LOBBY.config.default_hands,
        DefaultDiscards = MP.LOBBY.config.default_discards,
        JokerHealth = MP.LOBBY.config.joker_health,
        MoneyLeak = MP.LOBBY.config.money_leak,
        MoneyLeakStart = MP.LOBBY.config.money_leak_start,
        MoneyLeakIncrease = MP.LOBBY.config.money_leak_increase,
        EndingRound = MP.LOBBY.config.game_round_limit,
        RoundEnd = MP.LOBBY.config.round_limit,
        DamageCalc = "Linear",
        WinCondition = MP.LOBBY.config.winner_type,
        DeckLimitations = {
            Money = MP.LOBBY.config.deck_money_limit,
            Size = MP.LOBBY.config.deck_size_limits,
            Jokers = MP.LOBBY.config.deck_joker_limits,
            Consumeables = MP.LOBBY.config.deck_consumeable_limits,
            BackCounts = MP.LOBBY.config.deck_back_limits,
        },
    }

    if not BalatroTCG.SelectedDeck or type(BalatroTCG.SelectedDeck) ~= 'table' or BalatroTCG.SelectedDeck:is_legal() ~= 'Legal' then
        BalatroTCG.SelectedDeck = BalatroTCG.DefaultDecks[1]
        MP.ACTIONS.unready_lobby()
    end
end

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
    reset_tcg_settings()
    G.E_MANAGER:clear_queue()
    G.FUNCS.wipe_on()
    ease_background_colour_blind(G.STATE, 'Small Blind')

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
    ease_background_colour_blind(G.STATE, 'Small Blind')

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
        G:start_tcg_game({ online = true, seed = e.seed })
        return true
        end
    }))
    G.FUNCS.wipe_off()
end


if MP then
    -- Add 
    local game_main_menu_ref = Game.main_menu
    ---@diagnostic disable-next-line: duplicate-set-field
    function Game:main_menu(change_context)
        local ret = game_main_menu_ref(self, change_context)

        -- Add version to main menu
        UIBox({
            definition = {
                n = G.UIT.ROOT,
                config = {
                    align = "cm",
                    colour = G.C.UI.TRANSPARENT_DARK,
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            scale = 0.3,
                            text = BalatroTCG.VersionText,
                            colour = G.C.UI.TEXT_LIGHT,
                        },
                    },
                },
            },
            config = {
                align = "tri",
                bond = "Weak",
                offset = {
                    x = 0,
                    y = 1.2,
                },
                major = G.ROOM_ATTACH,
            },
        })

        return ret
    end
end

function Game:start_tcg_game(args)
    args = args or {}

    BalatroTCG.GameStarted = false

    G.SAVED_GAME = nil
    G.hand = nil
    G.jokers = nil

    BalatroTCG.GameActive = true
    BalatroTCG.UseTCG_UI = true

    self:prep_stage(G.STAGES.RUN, G.STATES.NEW_ROUND)
    
    G.STAGE = G.STAGES.RUN
    
    G.STATE_COMPLETE = false
    G.RESET_BLIND_STATES = true

    ease_background_colour_blind(G.STATES.SHOP)
    
    self.GAME = self:init_game_object()
    self.GAME.modifiers = {}
    self.GAME.stake = 1
    self.GAME.STOP_USE = 0
    self.GAME.selected_back = Back(G.P_CENTERS.b_red)
    
    self.GAME.pseudorandom.seed = args.seed or generate_starting_seed()
    --self.GAME.pseudorandom.seed = "QX9I13Q8"
    self.GAME.subhash = ''
    self.GAME.pseudorandom.hashed_seed = pseudohash(self.GAME.pseudorandom.seed)
    self.GAME.round_resets.pvp_blind_choices = {}
    
    G.GAME.facing_blind = true

    

    --print(self.GAME.pseudorandom.seed)
    --BalatroTCG.SavedSpeed = G.SETTINGS.GAMESPEED

    BalatroTCG.SelectedDeck = BalatroTCG.SelectedDeck or BalatroTCG.DefaultDecks[1]
    local playerDeck = BalatroTCG.SelectedDeck
    if playerDeck == 'random' then playerDeck = BalatroTCG.TabDecks[pseudorandom('asdf', 1, #BalatroTCG.TabDecks)] end

    playerDeck:sort()
    
    self.GAME.hands["High Card"].visible = true
    
    for k, v in ipairs(playerDeck.cards) do
        if v.type == 'c' and G.P_CENTERS[v.c].set == 'Planet' then
            self.GAME.hands[G.P_CENTERS[v.c].config.hand_type].visible = true
        end
    end

    local opponentDeck

    if args.online then
        opponentDeck = BalatroTCG.Deck('b_red', 'Custom_Deck', {
            { type = 'p', r = 'A', s = 'S' },
            { type = 'p', r = 'K', s = 'S' },
            { type = 'p', r = 'Q', s = 'S' },
            { type = 'p', r = 'J', s = 'S' },
            { type = 'p', r = 'T', s = 'S' },
            { type = 'p', r = '9', s = 'S' },
            { type = 'p', r = '8', s = 'S' },
            { type = 'p', r = '7', s = 'S' },
            { type = 'p', r = '6', s = 'S' },
            { type = 'p', r = '5', s = 'S' },
            { type = 'p', r = '4', s = 'S' },
            { type = 'p', r = '3', s = 'S' },
            { type = 'p', r = '2', s = 'S' },

            { type = 'p', r = 'A', s = 'H' },
            { type = 'p', r = 'K', s = 'H' },
            { type = 'p', r = 'Q', s = 'H' },
            { type = 'p', r = 'J', s = 'H' },
            { type = 'p', r = 'T', s = 'H' },
            { type = 'p', r = '9', s = 'H' },
            { type = 'p', r = '8', s = 'H' },
            { type = 'p', r = '7', s = 'H' },
            { type = 'p', r = '6', s = 'H' },
            { type = 'p', r = '5', s = 'H' },
            { type = 'p', r = '4', s = 'H' },
            { type = 'p', r = '3', s = 'H' },
            { type = 'p', r = '2', s = 'H' },
            
            { type = 'p', r = 'A', s = 'C' },
            { type = 'p', r = 'K', s = 'C' },
            { type = 'p', r = 'Q', s = 'C' },
            { type = 'p', r = 'J', s = 'C' },
            { type = 'p', r = 'T', s = 'C' },
            { type = 'p', r = '9', s = 'C' },
            { type = 'p', r = '8', s = 'C' },
            { type = 'p', r = '7', s = 'C' },
            { type = 'p', r = '6', s = 'C' },
            { type = 'p', r = '5', s = 'C' },
            { type = 'p', r = '4', s = 'C' },
            { type = 'p', r = '3', s = 'C' },
            { type = 'p', r = '2', s = 'C' },
            
            { type = 'p', r = 'A', s = 'D' },
            { type = 'p', r = 'K', s = 'D' },
            { type = 'p', r = 'Q', s = 'D' },
            { type = 'p', r = 'J', s = 'D' },
            { type = 'p', r = 'T', s = 'D' },
            { type = 'p', r = '9', s = 'D' },
            { type = 'p', r = '8', s = 'D' },
            { type = 'p', r = '7', s = 'D' },
            { type = 'p', r = '6', s = 'D' },
            { type = 'p', r = '5', s = 'D' },
            { type = 'p', r = '4', s = 'D' },
            { type = 'p', r = '3', s = 'D' },
            { type = 'p', r = '2', s = 'D' },
            
            { type = 'j', c = 'j_cavendish' },
            { type = 'j', c = 'j_joker' },
            { type = 'j', c = 'j_gros_michel' },
            
            { type = 'j', c = 'j_blueprint' },
            
            { type = 'c', c = 'c_fool' },
            { type = 'c', c = 'c_hermit' },
            { type = 'c', c = 'c_immolate' },
            { type = 'c', c = 'c_ectoplasm' },
        })
    else
        local validDecks = {}
        for k, v in ipairs(BalatroTCG.AIDecks) do
            if v:has_content() then
                validDecks[#validDecks + 1] = v
            end
        end
        opponentDeck = validDecks[pseudorandom('asdf', 1, #validDecks)]
        --opponentDeck = BalatroTCG.DefaultDecks[1]
        opponentDeck:sort()
    end


    G.GAME.player_back = Back(G.P_CENTERS[playerDeck.backs[1]])
    
    BalatroTCG.Player = TCG_PlayerStatus(playerDeck, true)
    BalatroTCG.Opponent = TCG_PlayerStatus(opponentDeck, false)
    BalatroTCG.Status_Current = nil
    BalatroTCG.Status_Other = nil
    


    BalatroTCG.Player.Other = BalatroTCG.Opponent
    BalatroTCG.Opponent.Other = BalatroTCG.Player
    
    BalatroTCG.Player:set_screen_positions()
    BalatroTCG.Opponent:set_screen_positions()
    

    if args.online then
        BalatroTCG.AI = nil
    else
        BalatroTCG.AI = TCG_AI()
        BalatroTCG.Player.opponent_back = Back(G.P_CENTERS[opponentDeck.backs[1]])
    end

    G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
    G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]

    G.GAME.chips_text = ''
    G.GAME.chips_damage = 0
    G.GAME.chips_damage_text = ''

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

function TCG_GetDamage(value)
    
    if value > 0 then
        value = math.log10(value)

        -- What score equates to 1 damage?
        local start = math.log10(100) - 1

        value = value - start

        if BalatroTCG.Settings.DamageCalc == "Quadratic" then
            value = value * value
        elseif BalatroTCG.Settings.DamageCalc == "Exponential" then
            value = math.pow(2, value - 1)
        -- TARGET: custom damage types
        else
            local scale = 4
            value = (value * scale) - (scale - 1)
        end
            
        local value = math.max(math.floor(value), 0)

        for k, v in ipairs(BalatroTCG.Status_Current.backs) do
            if v.name == 'Plasma Deck' then value = value * .75 end
        end
        
        value = math.floor(value)
        
        return value
    else
        return 0
    end
end

G.FUNCS.chip_UI_damage = function(e)

    local new_chips_text = number_format(G.GAME.chips_damage)

    if G.GAME.chips_damage_text ~= new_chips_text then
        e.config.scale = math.min(0.7, scale_number(value, 1.1))
        G.GAME.chips_damage_text = new_chips_text
    end
end

function end_tcg_round()

    BalatroTCG.Switching = true
    
    local damage = TCG_GetDamage(G.GAME.chips) + G.GAME.chips_damage
    local index = 0
    
    if damage > 0 then
        table.sort(BalatroTCG.Status_Current.opponentJokers.cards, function(a,b) return a.T.x < b.T.x end)
        if BalatroTCG.config.FlipOpponent then
            for i, joker in ipairs(BalatroTCG.Status_Current.opponentJokers.cards) do
                if joker.highlighted then
                    index = i
                end
            end
            for i, joker in ipairs(BalatroTCG.Status_Current.opponentConsumeables.cards) do
                if joker.highlighted then
                    index = i + #BalatroTCG.Status_Current.opponentJokers.cards
                end
            end
        else
            for i, joker in ipairs(BalatroTCG.Status_Current.opponentJokers.cards) do
                if joker.highlighted then
                    index = (#BalatroTCG.Status_Current.opponentJokers.cards - i) + 1
                end
            end
            for i, joker in ipairs(BalatroTCG.Status_Current.opponentConsumeables.cards) do
                if joker.highlighted then
                    index = (#BalatroTCG.Status_Current.opponentConsumeables.cards - i) + 1 + #BalatroTCG.Status_Current.opponentJokers.cards
                end
            end
        end
    end
    BalatroTCG.Status_Current.last_attack = damage
    BalatroTCG.Status_Current.last_target = index
    

    if BalatroTCG.MP_Lobby then

        Client.send({action = "tcgEndTurn", damage = damage, index = index })
    else

        BalatroTCG.Status_Current:send_message({type = 'attack', damage = damage, index = index, key = BalatroTCG.Status_Current.status.round })
    end

    BalatroTCG.Status_Current:add_play_stats('damage_given', damage, BalatroTCG.Status_Current.status.round)


    if BalatroTCG.Settings.MoneyLeak and BalatroTCG.Status_Current.status.round >= BalatroTCG.Settings.MoneyLeakStart then
        if BalatroTCG.Settings.MoneyLeakIncrease <= 0 then
            BalatroTCG.Status_Current:damage(1)
        else
            BalatroTCG.Status_Current:damage((BalatroTCG.Status_Current.status.round - BalatroTCG.Settings.MoneyLeakStart + 1) * BalatroTCG.Settings.MoneyLeakIncrease)
        end
    end

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
            
    

        if BalatroTCG.PlayerActive then
            delay(0.5)

            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blocking = false,
                ref_table = G.GAME,
                ref_value = 'chips_damage',
                ease_to = damage,
                delay = 0.5,
                func = (function(t) return math.floor(t) end)
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blocking = false,
                ref_table = G.GAME,
                ref_value = 'chips',
                ease_to = 0,
                delay =  0.5,
                func = (function(t) return math.floor(t) end)
            }))
        else
            G.GAME.chips = 0
            G.GAME.chips_damage = 0
        end

        SMODS.calculate_context({ end_of_round = true, game_over = false, status = BalatroTCG.Status_Current, full_deck = BalatroTCG.Status_Current.deck })

        for _,v in ipairs(SMODS.get_card_areas('playing_cards', 'end_of_round')) do
            SMODS.calculate_end_of_round_effects({ cardarea = v, end_of_round = true, status = BalatroTCG.Status_Current, full_deck = BalatroTCG.Status_Current.deck })
        end
        
        delay(0.3)
        
        BalatroTCG.Status_Current.status.unused_discards = (BalatroTCG.Status_Current.status.unused_discards or 0) + G.GAME.current_round.discards_left

        G.FUNCS.draw_from_hand_to_discard()
        G.FUNCS.draw_from_discard_to_deck()
        
        if G.GAME.round_resets.temp_handsize then G.hand:change_size(-G.GAME.round_resets.temp_handsize); G.GAME.round_resets.temp_handsize = nil end
        
        for k, v in ipairs(G.playing_cards) do
            v.ability.discarded = nil
            v.ability.forced_selection = nil
        end

        
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1.5,
            func = function()
                
                if damage > 0 then
                    SMODS.calculate_context({ damaging = true, status = BalatroTCG.Status_Current, damage = damage})
                end
                BalatroTCG.Status_Current:send_message({ type = 'jokers', jokers = #BalatroTCG.Status_Current.jokers.cards })
                BalatroTCG.Status_Current:send_message({ type = "health", health = BalatroTCG.Status_Current.status.dollars })
                
                for _, joker in ipairs(BalatroTCG.Status_Current.opponentJokers.cards) do
                    joker:highlight(false)
                    if joker.children.price then
                        joker.children.price:remove()
                        joker.children.price = nil
                    end
                end
                for _, joker in ipairs(BalatroTCG.Status_Current.opponentConsumeables.cards) do
                    joker:highlight(false)
                    if joker.children.price then
                        joker.children.price:remove()
                        joker.children.price = nil
                    end
                end
                
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blocking = false,
                    ref_table = G.GAME,
                    ref_value = 'chips_damage',
                    ease_to = 0,
                    delay = 0.5,
                    func = (function(t) return math.floor(t) end)
                }))
                
                switch_player(not BalatroTCG.PlayerActive)
                return true
            end
        }))
        
        return true
    end
    }))
end

G.FUNCS.tcg_add_attack = function(e)
    G.GAME.chips_damage = G.GAME.chips_damage + G.GAME.modifiers.tcg_attack
    BalatroTCG.Status_Current.can_reroll = false
    BalatroTCG.Status_Current.has_rerolled = true
    BalatroTCG.Status_Current:damage(G.GAME.modifiers.tcg_attack_cost)
end

G.FUNCS.tcg_can_add_attack = function(e)
    if BalatroTCG.PlayerActive and G.GAME.modifiers.tcg_attack and BalatroTCG.Player.can_reroll then
        e.config.colour = G.C.RED
        e.config.button = 'tcg_add_attack'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

function switch_player(playerActive)
    
    
    BalatroTCG.GameStarted = true
    if BalatroTCG.Status_Current then
        SMODS.calculate_context({ switching_players = true, old_player = BalatroTCG.Status_Current, new_player = BalatroTCG.Status_Other })
    end
    
    BalatroTCG.PlayerActive = playerActive

    if BalatroTCG.PlayerActive then

        if BalatroTCG.Status_Current then BalatroTCG.Opponent:pass_over() end
        
        BalatroTCG.Status_Current = BalatroTCG.Player
        BalatroTCG.Status_Other = BalatroTCG.Opponent
        
        BalatroTCG.Player:apply()
    else
        
        if BalatroTCG.Status_Current then BalatroTCG.Player:pass_over() end

        BalatroTCG.Status_Current = BalatroTCG.Opponent
        BalatroTCG.Status_Other = BalatroTCG.Player
        BalatroTCG.Opponent:apply()
    end
    
    G.RESET_JIGGLES = nil
    BalatroTCG.Switching = false
    
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
    if not BalatroTCG.GameStarted then return end

    BalatroTCG.GameStarted = false
    
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


function create_UIBox_tcg_stats_row(score, text_colour)
  local label = localize('ph_tcg_score_'..score)
  local score_tab = {}
  local label_w, score_w, h = ({damage=true,attack=true})[score] and 3.5 or 2.9, ({damage=true,attack=true})[score] and 3.5 or 1, 0.5

  if score == 'spent' then
    --label_w = 1.9
    label = 'Money Spent'

    score_tab = {
      {n=G.UIT.O, config={object = DynaText({string = {number_format(BalatroTCG.Player.play_stats.total_purchase)}, colours = {text_colour or G.C.FILTER},shadow = true, float = true, scale = 0.45})}},
      {n=G.UIT.B, config={w=0.05,h=0.1}},
      {n=G.UIT.T, config={text = " ("..number_format((BalatroTCG.Player.play_stats.total_purchase / (#BalatroTCG.Player.play_stats.rounds - 1)))..")", scale = 0.35, colour = G.C.JOKER_GREY}}
      --{n=G.UIT.O, config={object = DynaText({string = {}, colours = {text_colour or G.C.FILTER},shadow = true, float = true, scale = 0.45})}},
    }
  end
  if score == 'damage' then
    --label_w = 1.9
    label = 'Damage Taken'

    score_tab = {
      {n=G.UIT.O, config={object = DynaText({string = {number_format(BalatroTCG.Player.play_stats.total_damage_taken)}, colours = {text_colour or G.C.FILTER},shadow = true, float = true, scale = 0.45})}},
      {n=G.UIT.B, config={w=0.15,h=0.1}},
      {n=G.UIT.T, config={text = " ("..number_format((BalatroTCG.Player.play_stats.total_damage_taken / (#BalatroTCG.Player.play_stats.rounds - 1)))..")", scale = 0.35, colour = G.C.JOKER_GREY}}
    }
  end
  if score == 'attack' then
    --label_w = 1.9
    label = 'Damage Given'

    score_tab = {
      {n=G.UIT.O, config={object = DynaText({string = {number_format(BalatroTCG.Player.play_stats.total_damage_given)}, colours = {text_colour or G.C.FILTER},shadow = true, float = true, scale = 0.45})}},
      {n=G.UIT.B, config={w=0.15,h=0.1}},
      {n=G.UIT.T, config={text = " ("..number_format((BalatroTCG.Player.play_stats.total_damage_given / (#BalatroTCG.Player.play_stats.rounds - 1)))..")", scale = 0.35, colour = G.C.JOKER_GREY}}
    }
  end
  if score == 'jokers' then
    --label_w = 1.9
    label = 'Joker Damage'

    score_tab = {
      {n=G.UIT.O, config={object = DynaText({string = {number_format(BalatroTCG.Player.play_stats.total_joker_damage)}, colours = {text_colour or G.C.FILTER},shadow = true, float = true, scale = 0.45})}},
      {n=G.UIT.B, config={w=0.05,h=0.1}},
      {n=G.UIT.T, config={text = " ("..number_format((BalatroTCG.Player.play_stats.total_joker_damage / (#BalatroTCG.Player.play_stats.rounds - 1)))..")", scale = 0.35, colour = G.C.JOKER_GREY}}
    }
  end

  local label_scale = 0.5

  return {n=G.UIT.R, config={align = "cm", padding = 0.05, r = 0.1, colour = darken(G.C.JOKER_GREY, 0.1), emboss = 0.05, func = nil, id = score}, nodes={
    {n=G.UIT.C, config={align = "cm", padding = 0.02, minw = label_w, maxw = label_w}, nodes={
        {n=G.UIT.T, config={text = label, scale = label_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
    }},
    {n=G.UIT.C, config={align = "cr"}, nodes={
      {n=G.UIT.C, config={align = "cm", minh = h, r = 0.1, minw = score_w, colour = G.C.BLACK, emboss = 0.05}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.05, r = 0.1, minw = score_w}, nodes=score_tab},
      }}
    }},
  }}
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
                    create_UIBox_tcg_stats_row('damage'),
                    create_UIBox_tcg_stats_row('attack'),
                }},
                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.C, config={align = "cm", padding = 0.08}, nodes={
                        create_UIBox_round_scores_row('cards_played', G.C.BLUE),
                        create_UIBox_round_scores_row('cards_discarded', G.C.RED),
                        create_UIBox_tcg_stats_row('jokers'),
                        create_UIBox_tcg_stats_row('spent'),
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
