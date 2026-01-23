
local ref_override_main_menu_play_button = G.UIDEF.override_main_menu_play_button

local create_UIBox_main_menu_buttonsRef = create_UIBox_main_menu_buttons
---@diagnostic disable-next-line: lowercase-global
function create_UIBox_main_menu_buttons()
	local menu = create_UIBox_main_menu_buttonsRef()
	menu.nodes[1].nodes[1].nodes[1].nodes[1].config.button = "play_options"
	return menu
end

function G.FUNCS.play_options(e)
	G.SETTINGS.paused = true
	
    BalatroTCG.UseTCG_UI = false
	
	reset_tcg_centers()

	G.FUNCS.overlay_menu({
		definition = G.UIDEF.override_main_menu_play_button(),
	})
end

function G.FUNCS.start_campaign(e)
	G.SETTINGS.paused = true
	reset_tcg_settings()

	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_tcg_deck_selection(e.config.id),
	})
	if (e.config.id == 'from_game_over' or e.config.id == 'from_game_won') then G.OVERLAY_MENU.config.no_esc = true end
end

G.FUNCS.change_selected_tcg_deck = function(args)

	BalatroTCG.DeckIndex = args.to_key
	BalatroTCG.SelectedDeck = BalatroTCG.TabDecks[args.to_key]

	if BalatroTCG.TabDecks[args.to_key] == 'new' then
		BalatroTCG.SelectedBack:change_to(G.P_CENTERS.b_red)
	else
		BalatroTCG.SelectedBack:change_to(G.P_CENTERS[BalatroTCG.TabDecks[args.to_key].backs[1]])
	end

end
G.FUNCS.change_viewed_tcg_deck = function(args)
	
	BalatroTCG.DeckIndex = args.to_key

	if BalatroTCG.TabDecks[args.to_key] == 'new' then
		BalatroTCG.SelectedBack:change_to(G.P_CENTERS.b_red)
	else
		BalatroTCG.SelectedBack:change_to(G.P_CENTERS[BalatroTCG.TabDecks[args.to_key].backs[1]])
	end

end

G.FUNCS.RUN_SETUP_check_tcg_back = function(e)
	if BalatroTCG.DeckIndex ~= e.config.id then 
		--removes the UI from the previously selected back and adds the new one

		for k, v in ipairs(BalatroTCG.DeckArea.cards) do
			v:set_sprites({})
		end
		e.config.object:remove() 
		e.config.object = UIBox{
		definition = BalatroTCG.SelectedBack:generate_tcg_UI(),
		config = {offset = {x=0,y=0}, align = 'cm', parent = e}
		}
		e.config.id = BalatroTCG.DeckIndex
	end
end

G.FUNCS.RUN_SETUP_check_tcgdeck_name = function(e)
  if e.config.object and BalatroTCG.DeckIndex ~= e.config.id then 
    --removes the UI from the previously selected back and adds the new one

	local deck = BalatroTCG.TabDecks[BalatroTCG.DeckIndex]

	local deckname, backname

	if not deck or deck == 'new' then
		deckname, backname = 'New Deck', '???'
	else
		deckname, backname = deck.name, Back(G.P_CENTERS[BalatroTCG.TabDecks[BalatroTCG.DeckIndex].backs[1]]):get_name()
	end
	
    e.config.object:remove() 
    e.config.object = UIBox{
		definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
			{n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, func = 'RUN_SETUP_check_tcgdeck_name'}, nodes={
				{n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR }, nodes={
					{n=G.UIT.O, config={id = BalatroTCG.DeckIndex, object = DynaText({string = deckname,maxw = 4, colours = {G.C.WHITE}, shadow = true, bump = true, scale = 0.45, pop_in = 0, silent = true})}},
				}},
				{n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR }, nodes={
					{n=G.UIT.O, config={id = BalatroTCG.DeckIndex, object = DynaText({string = '(' .. backname .. ')',maxw = 4, colours = {G.C.WHITE}, shadow = true, bump = true, scale = 0.3, pop_in = 0, silent = true})}},
				}},
			}},
		}},
		config = {offset = {x=0,y=0}, align = 'cm', parent = e}
    }
    e.config.id = BalatroTCG.DeckIndex
  end
end

function Back:generate_tcg_UI(other, ui_scale, min_dims)


    min_dims = min_dims or 0.7
    ui_scale = ui_scale or 0.9
    local back_config = other or self.effect.center
    local name_to_check = other and other.key or back_config.key
    local effect_config = get_TCG_params(name_to_check)
	local default = get_TCG_params(nil)

    local loc_args, loc_nodes = {}, {}

	local key_override
	
	if BalatroTCG.TabDecks[BalatroTCG.DeckIndex] == 'new' then
		key_override = 'null'
	end

	localize{type = 'descriptions', key = key_override or (back_config.key), set = 'Back', nodes = loc_nodes, vars = loc_args}
    
	
    return 
    {n=G.UIT.ROOT, config={align = "cm", minw = min_dims*5, minh = min_dims*2.5, id = self.name, colour = G.C.CLEAR}, nodes={
        desc_from_rows(loc_nodes, true, min_dims*5)
    }}
end

local localize_ref = localize

function localize(args, misc_cat)
    if not args or not (type(args) == 'table') then
        return localize_ref(args, misc_cat)
    end

    if args and BalatroTCG.UseTCG_UI and args.set == 'Back' and G.P_CENTERS[args.key] then
		local loc_args = nil


		local back_name = args.key

		if G.P_CENTERS[back_name] and G.P_CENTERS[back_name].tcg_loc_vars and type(G.P_CENTERS[back_name].tcg_loc_vars) == 'function' then
			local res = G.P_CENTERS[back_name]:tcg_loc_vars() or {}
			loc_args = res.vars
		elseif back_name == 'b_blue' then loc_args = { 1 }
		elseif back_name == 'b_red' then loc_args = { 1 }
		elseif back_name == 'b_yellow' then loc_args = { 25 }
		elseif back_name == 'b_green' then loc_args = { 2 }
		elseif back_name == 'b_black' then loc_args = { 1, 1 }
		elseif back_name == 'b_magic' then  loc_args = { localize{type = 'name_text', key = 'v_crystal_ball', set = 'Voucher'} }
		elseif back_name == 'b_nebula' then loc_args = { localize{type = 'name_text', key = 'v_telescope', set = 'Voucher'} }
		elseif back_name == 'b_ghost' then loc_args = { }
		elseif back_name == 'b_abandoned' then 
		elseif back_name == 'b_checkered' then
		elseif back_name == 'b_zodiac' then loc_args = { localize{type = 'name_text', key = 'v_tarot_merchant', set = 'Voucher'}, localize{type = 'name_text', key = 'v_planet_merchant', set = 'Voucher'} }
		elseif back_name == 'b_painted' then loc_args = { 2, -1 }
		elseif back_name == 'b_anaglyph' then loc_args = {1, 3}
		elseif back_name == 'b_plasma' then loc_args = { 50 }
		elseif back_name == 'b_erratic' then loc_args = { 5 }
		elseif back_name == 'b_challenge' then loc_args = { 30 }
		
		elseif back_name == 'b_mp_cocktail' then loc_args = { 2, 1 }
		elseif back_name == 'b_mp_gradient' then loc_args = { }
		elseif back_name == 'b_mp_heidelberg' then loc_args = { 2 }
		elseif back_name == 'b_mp_indigo' then loc_args = { 70, 1 }
		elseif back_name == 'b_mp_oracle' then loc_args = { localize{type = 'name_text', key = 'v_clearance_sale', set = 'Voucher'}, 90 }
		elseif back_name == 'b_mp_orange' then loc_args = { 2 }
		elseif back_name == 'b_mp_violet' then loc_args = { 4 }
		end
		
        args.key = args.key .. '_tcg'
		args.vars = loc_args or args.vars
    end
    return localize_ref(args, misc_cat)
end

function select_tcg_deck_ui(tab_type)

    BalatroTCG.UseTCG_UI = true

	BalatroTCG.DeckArea = CardArea(
		G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
		G.CARD_W,
		G.CARD_H, 
		{card_limit = 5, type = 'deck', highlight_limit = 0, deck_height = 0.75, thin_draw = 1})

	local callback = 'change_selected_tcg_deck'
	local full_decks = tableMerge(BalatroTCG.DefaultDecks, BalatroTCG.CustomDecks)
	BalatroTCG.SelectedDeck = BalatroTCG.SelectedDeck or BalatroTCG.DefaultDecks[1]

	BalatroTCG.TabDecks = {}
	
	if tab_type == 'build' or tab_type == 'build_multi' then
		for k, v in ipairs(BalatroTCG.DefaultDecks) do
			if v:has_content() then
				table.insert(BalatroTCG.TabDecks, v)
			end
		end
		for k, v in ipairs(BalatroTCG.CustomDecks) do
			if v:has_content() then
				table.insert(BalatroTCG.TabDecks, v)
			end
		end
		if #BalatroTCG.TabDecks < 1 then
			BalatroTCG.TabDecks[1] = get_new_tcg_deck()
		end
		BalatroTCG.TabDecks[#BalatroTCG.TabDecks + 1] = 'new'

		if tab_type == 'build_multi' then 
			callback = 'change_viewed_tcg_deck'
		end
	elseif tab_type == 'multiplayer' then
		
		callback = 'change_viewed_tcg_deck'
		local legal_only = true

		for k, v in ipairs(BalatroTCG.DefaultDecks) do
			if v:has_content() and (v:is_legal() == 'Legal' or not legal_only) then
				table.insert(BalatroTCG.TabDecks, v)
			end
		end
		for k, v in ipairs(BalatroTCG.CustomDecks) do
			if v:has_content() and (v:is_legal() == 'Legal' or not legal_only)  then
				table.insert(BalatroTCG.TabDecks, v)
			end
		end

	elseif tab_type == 'legal' then

		local legal_only = _RELEASE_MODE
		
		for k, v in ipairs(BalatroTCG.DefaultDecks) do
			if v:has_content() and (v:is_legal() == 'Legal' or not legal_only) then
				table.insert(BalatroTCG.TabDecks, v)
			end
		end
		for k, v in ipairs(BalatroTCG.CustomDecks) do
			if v:has_content() and (v:is_legal() == 'Legal' or not legal_only)  then
				table.insert(BalatroTCG.TabDecks, v)
			end
		end
	else
		for k, v in ipairs(BalatroTCG.DefaultDecks) do
			if v:has_content() then
				table.insert(BalatroTCG.TabDecks, v)
			end
		end
		for k, v in ipairs(BalatroTCG.CustomDecks) do
			if v:has_content() then
				table.insert(BalatroTCG.TabDecks, v)
			end
		end
	end

	if #BalatroTCG.TabDecks < 1 then
		BalatroTCG.TabDecks[1] = BalatroTCG.DefaultDecks[1]
	end

	local index = 1

	for k, v in ipairs(full_decks) do
		for k2, v2 in ipairs(BalatroTCG.TabDecks) do
			if v == v2 then
				index = k2
				break
			end
		end
		if v == BalatroTCG.SelectedDeck then
			break
		end
	end

	
	BalatroTCG.DeckIndex = index
	
	if tab_type ~= 'multiplayer' and tab_type ~= 'build_multi' then
		BalatroTCG.SelectedDeck = BalatroTCG.TabDecks[index]
	end
	
	if BalatroTCG.TabDecks[BalatroTCG.DeckIndex] == 'new' then
		BalatroTCG.SelectedBack = nil
	else
		BalatroTCG.SelectedBack = Back(G.P_CENTERS[BalatroTCG.TabDecks[BalatroTCG.DeckIndex].backs[1]])
	end
	
	for i = 1, 10 do
		local card = Card(G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h, G.CARD_W, G.CARD_H, pseudorandom_element(G.P_CARDS), G.P_CENTERS.c_base, {playing_card = i, tcg_back = '#selection'})
		card.sprite_facing = 'back'
		card.facing = 'back'
		BalatroTCG.DeckArea:emplace(card)
	end
	
	
	return { n = G.UIT.R, config = { align = 'cm', minh = 1, minw = 1, colour = G.C.CLEAR, }, nodes = {
		create_option_cycle({options = BalatroTCG.TabDecks, opt_callback = callback, current_option = index, colour = G.C.RED, w = 3.5, mid = 
			{ n=G.UIT.R, config = {align = 'cm', minh=3.3, minw = 5 }, nodes = {
				{n=G.UIT.C, config={align = "cm", colour = G.C.BLACK, emboss = 0.05, padding = 0.15, r = 0.1}, nodes={
					{n=G.UIT.C, config={align = "cm"}, nodes={
						{n=G.UIT.R, config={align = "cm", shadow = false}, nodes={
							{n=G.UIT.O, config={object = BalatroTCG.DeckArea }}
						}},
					}},
					{n=G.UIT.C, config={align = "cm", minh = 1.7, r = 0.1, colour = G.C.L_BLACK, padding = 0.1}, nodes={
						{n=G.UIT.R, config={align = "cm", r = 0.1, minw = 4, maxw = 4, minh = 0.8}, nodes={
							{n=G.UIT.O, config={id = nil, func = 'RUN_SETUP_check_tcgdeck_name', object = Moveable()}},
						}},
						{n=G.UIT.R, config={align = "cm", colour = G.C.WHITE, minh = 1.7, r = 0.1}, nodes={
							{n=G.UIT.O, config={id = -20, func = 'RUN_SETUP_check_tcg_back', object = UIBox{definition = (BalatroTCG.SelectedBack and BalatroTCG.SelectedBack:generate_tcg_UI() or nil), config = {offset = {x=0,y=0}}}}}
						}}       
					}},
				}}
			}}
		})
	}}
end

function G.UIDEF.create_tcg_deck_selection(from_game_over)
	G.tcg_deck_page = 1
	G.tcg_addition_page = 1

	local values = {
		build_tab = true,
		can_exit = true,
		return_to = 'play_options'
	}

	if not from_game_over then

	elseif from_game_over == 'multiplayer' then
		values.build_tab = true
		values.can_exit = true
		values.return_to = 'exit_overlay_menu'

	elseif from_game_over == 'restart_button' then
		values.build_tab = false
		values.can_exit = true
		values.return_to = 'options'
	else
		values.build_tab = false
		values.can_exit = false
		values.return_to = nil
	end
	
	local tabs = {
				-- Single Match Tab
				{ label = localize("b_tcgtab_single"), chosen = true, tab_definition_function = function()
					
					return { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.2, colour = G.C.CLEAR, }, nodes = 
					MP and MP.LOBBY and MP.LOBBY.code and 
					{
						select_tcg_deck_ui('multiplayer'),
						UIBox_button({
							label = { localize("b_tcgtab_select") },
							colour = G.C.BLUE,
							button = "select_tcg_deck_mp",
							minw = 5,
						})
					}
					or
					{
						select_tcg_deck_ui('legal'),
						UIBox_button({
							label = { localize("b_play_cap") },
							colour = G.C.BLUE,
							button = "tcg_start_single",
							minw = 5,
						})
					}
				}
				end},
				-- Build Deck Tab
				(values.build_tab) and
				{ label = localize("b_tcgtab_deck"), chosen = false, tab_definition_function = function()
					
					local t = { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.2, colour = G.C.CLEAR, }, nodes = {
						
						select_tcg_deck_ui(MP and MP.LOBBY and MP.LOBBY.code and 'build_multi' or 'build'),
						
						{n = G.UIT.R, config = { padding = 0, align = "cm", colour = G.C.CLEAR }, nodes = {
							{n = G.UIT.C, config = { padding = 0.2, align = "cm", colour = G.C.CLEAR }, nodes = {
								UIBox_button({
									n = G.UIT.R,
									label = { localize("b_tcg_build") },
									colour = G.C.GREEN,
									func = "tcg_build_check",
									button = "tcg_start_build",
									minw = 2.5,
								}),
							}},
							{n = G.UIT.C, config = { padding = 0.2, align = "cm", colour = G.C.CLEAR }, nodes = {
								UIBox_button({
									n = G.UIT.R,
									label = { localize("b_tcg_copy") },
									colour = G.C.BLUE,
									button = "tcg_copy_build",
									minw = 2.5,
								}),
							}},
							{n = G.UIT.C, config = { padding = 0.2, align = "cm", colour = G.C.CLEAR }, nodes = {
								UIBox_button({
									n = G.UIT.R,
									label = { localize("b_tcg_delete") },
									colour = G.C.RED,
									func = "tcg_delete_check",
									button = "tcg_delete_deck",
									minw = 2.5,
								})
							}}
						}}
					}}
					-- There has to be a better way to go about this
					local text = t.nodes[2].nodes[1].nodes[1].nodes[1].nodes[1].nodes[1]
					text.config.ref_table = BalatroTCG
					text.config.ref_value = "BuildText"
					text.config.text = nil
					BalatroTCG.BuildText = localize('b_tcg_build')
					return t
				end} or nil,
			}

	return (
		create_UIBox_generic_options({
			no_back = not values.can_exit, no_esc = not values.can_exit,
			back_func = values.return_to,
			contents = 
				{{n = G.UIT.R, config = { padding = 0, align = "cm" }, nodes = {
					create_tabs({snap_to_nav = true, colour = G.C.RED, tabs = tabs})
				}}},
		})
	)
end

function G.UIDEF.starting_betting(e)
	
	local money_amount = {}

	G.SETTINGS.paused = true

	BalatroTCG.BetAmount = 0
	
	local deck = BalatroTCG.SelectedDeck
	local params = get_TCG_params(deck.back_key)

	for i = 0, (params.dollars - 1) do
		table.insert(money_amount, localize('$')..tostring(i))
	end
	return
		create_UIBox_generic_options({
			no_back = true,
			contents = {
				{n = G.UIT.R, config = { padding = 0, align = "cm" }, nodes = {
					{n=G.UIT.T, config={text = localize('k_tcg_bet'), scale = 0.85, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
				}},
				{n = G.UIT.R, config = { padding = 0, align = "cm" }, nodes = {
					create_option_cycle({options = money_amount, w = 4.5, cycle_shoulders = true, opt_callback = "set_bet_amount", current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
				}},
				{n = G.UIT.R, config = { padding = 0, align = "cm" }, nodes = {
					UIBox_button({
						label = { localize("b_tcg_bet") },
						colour = G.C.GREEN,
						button = "set_betting",
						minw = 5,
					})
				}},
				{n = G.UIT.R, config = { padding = 0, align = "cm" }, nodes = {
					BalatroTCG.MP_Lobby and 
					UIBox_button({
						label = { localize("b_return_lobby") },
						colour = G.C.ORANGE,
						button = "mp_return_to_lobby",
						minw = 5,
					})
					or 
					UIBox_button({
						label = { localize("b_main_menu") },
						colour = G.C.ORANGE,
						button = "go_to_menu",
						minw = 5,
					})
				}}
			},
		})
	
end


function G.FUNCS.set_bet_amount(e)
	BalatroTCG.BetAmount = e.cycle_config.current_option - 1
end

function G.FUNCS.set_betting(e)
	
	
	BalatroTCG.Player:send_backs()
	
	if MP and MP.LOBBY and MP.LOBBY.code then
		Client.send({action = "tcgBet", bet = BalatroTCG.BetAmount })
		G.FUNCS.overlay_menu({
			definition = G.UIDEF.waiting_for_opponent(),
		})
	else

		local ai_bet = pseudorandom(generate_starting_seed(), BalatroTCG.AI.bet_min, BalatroTCG.AI.bet_max)
		local player_goes = false

		if ai_bet <= BalatroTCG.BetAmount then
			player_goes = true
		else

		end

		switch_player(player_goes)
		if player_goes then
			if (BalatroTCG.BetAmount > 0) then ease_dollars(-BalatroTCG.BetAmount) end
		else
			BalatroTCG.Player:send_message({ type = 'attack', damage = ai_bet, index = 0, key = 'start' })
		end
		
		G.SETTINGS.paused = false
		G.FUNCS.exit_overlay_menu()
	end
end

function G.UIDEF.waiting_for_opponent(e)
	
	G.SETTINGS.paused = true

	return
		create_UIBox_generic_options({
			no_back = true,
			contents = {
				{n=G.UIT.R, config={align = "cm", padding = 1}, nodes={
					{n=G.UIT.T, config={text = localize('k_tcg_waiting'), scale = 0.85, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
				}},
				{n=G.UIT.R, config={align = "cm", padding = 1}, nodes={
					UIBox_button({
						label = { localize("b_return_lobby") },
						colour = G.C.ORANGE,
						button = "mp_return_to_lobby",
						minw = 5,
					})
				}}
			},
		})
	
end

function G.FUNCS.tcg_delete_check(e)
	local active = true

	if BalatroTCG.DeckIndex >= #BalatroTCG.TabDecks or BalatroTCG.TabDecks[BalatroTCG.DeckIndex].is_vanilla then
		active = false
	end

    if active then 
        e.config.colour = G.C.RED
        e.config.button = 'tcg_delete_deck'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

function G.FUNCS.tcg_build_check(e)
	local active = true

	if not _RELEASE_MODE or BalatroTCG.DeckIndex >= #BalatroTCG.TabDecks or not BalatroTCG.TabDecks[BalatroTCG.DeckIndex].is_vanilla then
        e.config.colour = G.C.GREEN
        e.config.button = 'tcg_start_build'
		BalatroTCG.BuildText = localize('b_tcg_build')
	else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

function G.FUNCS.lobby_choose_tcg_deck()

	G.SETTINGS.paused = true
	
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_tcg_deck_selection('multiplayer'),
	})
end

function clear_collection()
	for j = 1, #areas do
		areas[j]:remove()
	end
end

G.FUNCS.select_tcg_deck_mp = function(e)
	BalatroTCG.SelectedDeck = BalatroTCG.TabDecks[BalatroTCG.DeckIndex]

	MP.ACTIONS.update_player_usernames()
	
end

function create_tcg_builder(type, callback)
	BalatroTCG.BuildingDeck = BalatroTCG.BuildingDeck or BalatroTCG.TabDecks[BalatroTCG.DeckIndex]

	reset_tcg_settings()

    BalatroTCG.UseTCG_UI = true

	local deck_tables = {}
	local buildDeck = {}

	-- table.insert(deck_tables, {n=G.UIT.R, config={align = "cm", padding = 1}, nodes={}})
	-- table.insert(buildDeck, {n=G.UIT.R, config={align = "cm", padding = 1}, nodes={}})

	G.your_collection = {}
	G.your_tcg_deck = {}
	for i = 1, 2 do
		G.your_collection[i] = CardArea(
			G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
			4.5*G.CARD_W,
			0.95*G.CARD_H,
			{card_limit = 3, type = 'tcgdeck_buy', highlight_limit = 1})
		table.insert(deck_tables, 
			{n=G.UIT.R, config={align = "cm", padding = 0.1, no_fill = true}, nodes={
				{n=G.UIT.O, config={object = G.your_collection[i]}}
			}}
		)
		G.your_tcg_deck[i] = CardArea(
			G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
			5.5*G.CARD_W,
			0.95*G.CARD_H,
			{card_limit = 3, type = 'tcgdeck_remove', highlight_limit = 1})
		table.insert(buildDeck, 
			{n=G.UIT.R, config={align = "cm", padding = 0.1, no_fill = true}, nodes={
				{n=G.UIT.O, config={object = G.your_tcg_deck[i]}}
			}}
		)
	end

	local joker_options = {}
	local deck_display = {}

	if type == 'Cards' then
		G.CARD_POOL = {}
		local ranks = {}
		for k, v in pairs(SMODS.Ranks) do
			ranks[#ranks + 1] = v
		end
		table.sort(ranks, function (a, b) return (a.nominal + (a.face_nominal or 0)) > (b.nominal + (b.face_nominal or 0)) end)
		for _, r in pairs(ranks) do
			for _, s in pairs(SMODS.Suits) do
				G.CARD_POOL[#G.CARD_POOL + 1] = G.P_CARDS[s.card_key .. '_' .. r.card_key]
			end
		end
		for i = 1, math.ceil(#G.CARD_POOL/(4*#G.your_collection)) do
			table.insert(joker_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#G.CARD_POOL/(4*#G.your_collection))))
		end
	elseif type == 'Back' then
		G.CARD_POOL = {}
		for k, v in pairs(G.P_CENTER_POOLS[type]) do
			v.original_id = v.key
			G.CARD_POOL[#G.CARD_POOL + 1] = v
			if #G.CARD_POOL == 15 then
				G.CARD_POOL[#G.CARD_POOL + 1] = G.P_CENTERS.b_challenge
				G.CARD_POOL[#G.CARD_POOL].original_id = 'b_challenge'
			end
		end

		for i = 1, math.ceil(#G.CARD_POOL/(5*#G.your_collection)) do
			table.insert(joker_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#G.CARD_POOL/(5*#G.your_collection))))
		end
	else
		G.CARD_POOL = {}
		for k, v in pairs(G.P_CENTER_POOLS[type]) do
			if not (string.sub(v.key, 1, 4) == 'j_mp' or 
			string.sub(v.key, 1, 4) == 'c_mp'
			-- and string.find(v.key, '_sandbox') -- TODO: add multiplayer joker functionality
		) then
				v.original_id = v.key
				G.CARD_POOL[#G.CARD_POOL + 1] = v
				if v.key == 'v_overstock_norm' or v.key == 'v_overstock_plus' then
					--v.tcg_broken = true
				end
			end
		end
		for i = 1, math.ceil(#G.CARD_POOL/(5*#G.your_collection)) do
			table.insert(joker_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#G.CARD_POOL/(5*#G.your_collection))))
		end
		
	end

	for i = 1, math.ceil(#BalatroTCG.BuildingDeck.cards/(6*#G.your_tcg_deck)) do
		table.insert(deck_display, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#BalatroTCG.BuildingDeck.cards/(6*#G.your_tcg_deck))))
	end
	
	G.tcg_deck_page = math.min(G.tcg_deck_page, #deck_display) or 1
	G.tcg_addition_page = math.min(G.tcg_addition_page, #joker_options) or 1

	if type == 'Back' then
		for i = 1, 5 do
			for j = 1, #G.your_collection do
				local center = G.CARD_POOL[i+(j-1)*5 + (G.tcg_addition_page - 1) * 10]
				if not center then break end
				local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.S_A, G.P_CENTERS.c_base, { tcg_back = center.original_id })
				for k, v in ipairs(BalatroTCG.BuildingDeck.backs) do 
					if v == center.original_id then card.tcgb_deck_selected = true end
				end
				card.sprite_facing = 'back'
				card.facing = 'back'
				card.original_id = center.original_id
				card.tcg_deck_type = center.original_id
				card.tcg_broken = center.tcg_broken
				G.your_collection[j]:emplace(card, nil, true)
			end
		end
	elseif type == 'Cards' then
		for i = 1, 4 do
			for j = 1, #G.your_collection do
				local center = G.CARD_POOL[i+(j-1)*4 + (G.tcg_addition_page - 1) * 8]
				if not center then break end
				local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, center, G.P_CENTERS.c_base)
				card.cost = 0
				card.tcg_broken = center.tcg_broken
				G.your_collection[j]:emplace(card)
			end
		end
	elseif type == 'Voucher' then
		for i = 1, 4 do
			for j = 1, #G.your_collection do
				local center = G.CARD_POOL[i+(j-1)*4 + (G.tcg_addition_page - 1) * 8]
				if not center then break end
				local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, nil, center)
				card.original_id = center.original_id
				card.tcg_broken = center.tcg_broken
				G.your_collection[j]:emplace(card)
			end
		end
	else
		for i = 1, 5 do
			for j = 1, #G.your_collection do
				local center = G.CARD_POOL[i+(j-1)*5 + (G.tcg_addition_page - 1) * 10]
				if not center then break end
				local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, nil, center)
				card.original_id = center.original_id
				card.tcg_broken = center.tcg_broken
				G.your_collection[j]:emplace(card)
			end
		end
	end

	for i = 1, 6 do
		for j = 1, #G.your_tcg_deck do
			local control = BalatroTCG.BuildingDeck.cards[i+(j-1)*6 + (G.tcg_deck_page - 1) * 12]
			if not control then break end
			
			local card = BalatroTCG.BuildingDeck:card_from_control_ex(G.your_tcg_deck[j], 'b_red', control)
			G.your_tcg_deck[j]:emplace(card)
		end
	end

	local legal_status = BalatroTCG.BuildingDeck:is_legal()
	local color = G.C.UI.TEXT_LIGHT
	local error_text = {}

	if legal_status == 'Legal' then
		error_text = { {n=G.UIT.R, config={}, nodes = localize{ type = 'text', key = 'tcg_err_none', vars = {}, shadow = true, default_col = G.C.UI.TEXT_LIGHT, scale = 1.5 } } }
	else
		local count = 0
		for k, v in pairs(legal_status) do
			count = count + 1
		end
		local scale = math.min(1.5, 4 / math.min(count, 4))

		count = 0
		for k, v in pairs(legal_status) do
			table.insert(error_text, {n=G.UIT.R, config={}, nodes = localize{ type = 'text', key = k, vars = v, shadow = true, default_col = G.C.RED, scale = scale } } )
			
			count = count + 1
			if count >= 4 then
				break
			end
		end
	end

	local t =  {
		{n=G.UIT.R, config={align = "cm", w = 20, padding = 0.0}, nodes={
			{n=G.UIT.C, config={align = "cm"}, nodes = {
				{n=G.UIT.R, config={align = "cm",minh = 1.2, padding = 0.2}, nodes=error_text},
			}},
			{n=G.UIT.C, config={align = "cm", padding = 1.5}, nodes={}},
			{n=G.UIT.C, config={align = "cm"}, nodes = {
				{n=G.UIT.R, config={align = "cm"}, nodes = {
					create_text_input({
					w = 4, max_length = 24, prompt_text = localize('k_enter_name'),
					ref_table = BalatroTCG.BuildingDeck, ref_value = 'name', keyboard_offset = 1,
					callback = function()
						BalatroTCG.BuildingDeck:sanitize()
						save_decks()
					end
					}),
				}},
				{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={}},
				{n=G.UIT.R, config={align = "cm"}, nodes = {
					{n=G.UIT.C, nodes = {
						{n=G.UIT.O, config={align = "cm", object = DynaText({string = {{prefix = localize('$'), ref_table = BalatroTCG, ref_value = 'DeckCost'}}, font = G.LANGUAGES['en-us'].font, colours = { BalatroTCG.DeckCost >= 0 and G.C.MONEY or G.C.RED },shadow = true, rotate = true, scale = 0.5})}},
					}},
					{n=G.UIT.C, config={align = "cm", padding = 0.2}, nodes={}},
					{n=G.UIT.C, nodes = {
						{n=G.UIT.O, config={align = "cm", object = DynaText({string = {{prefix = '(' .. localize('$'), suffix = ')', ref_table = BalatroTCG.BuildingDeck, ref_value = 'cost'}}, font = G.LANGUAGES['en-us'].font, colours = { BalatroTCG.DeckCost >= 0 and G.C.MONEY or G.C.RED },shadow = true, rotate = true, scale = 0.35})}},
					}},
				}},
			}},
		}},
		
		{n=G.UIT.R, config={align = "cm", padding = 0.0}, nodes={
			{n=G.UIT.C, nodes = {
				{n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
				{n=G.UIT.R, config={align = "cm"}, nodes={
					create_option_cycle({options = joker_options, w = 4.5, cycle_shoulders = true, opt_callback = callback, current_option = G.tcg_addition_page, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
				}}
			}},
			{n=G.UIT.C, config={align = "cm", padding = 0.2}, nodes={}},
			{n=G.UIT.C, nodes = {
				
				{n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=buildDeck}, 
				{n=G.UIT.R, config={align = "cm"}, nodes={
					create_option_cycle({options = deck_display, w = 4.5, cycle_shoulders = true, opt_callback = "your_collection_tcg_deck_page", current_option = G.tcg_deck_page, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
				}}
			}}
		}}
	}
	return t
end

G.FUNCS.tcg_start_build = function(e)
	G.SETTINGS.paused = true

	BalatroTCG.BuildingDeck = BalatroTCG.TabDecks[BalatroTCG.DeckIndex]
	
	if BalatroTCG.BuildingDeck == 'new' then
		BalatroTCG.BuildingDeck = get_new_tcg_deck()
	end

	save_decks()


	G.FUNCS.overlay_menu{
		definition = G.FUNCS.create_tcg_builder_menu()
	}
end

G.FUNCS.tcg_copy_build = function(e)
	G.SETTINGS.paused = true

	local to_copy = BalatroTCG.TabDecks[BalatroTCG.DeckIndex]

	if to_copy == 'new' then
		BalatroTCG.BuildingDeck = get_new_tcg_deck()
	else
		BalatroTCG.BuildingDeck = BalatroTCG.Deck(copy_table(to_copy.backs), to_copy.name .. ' Copy', copy_table(to_copy.cards))
		BalatroTCG.CustomDecks[#BalatroTCG.CustomDecks + 1] = BalatroTCG.BuildingDeck
		BalatroTCG.DeckIndex = #BalatroTCG.TabDecks
	end


	save_decks()

	G.FUNCS.overlay_menu{
		definition = G.FUNCS.create_tcg_builder_menu()
	}
end


G.FUNCS.tcg_delete_deck = function(e)
	G.SETTINGS.paused = true

	for k, v in ipairs(BalatroTCG.CustomDecks) do
		if v == BalatroTCG.SelectedDeck then
			table.remove(BalatroTCG.CustomDecks, k)
			break
		end
	end

	save_decks()

	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_tcg_deck_selection(e.config.id),
	})
end

G.FUNCS.create_tcg_builder_menu = function(e)
	G.tcg_tab = G.tcg_tab or "Jokers"
	local tabs = {
		{ label = "Jokers", chosen = G.tcg_tab == "Jokers", tab_definition_function = function()
			if G.tcg_tab ~= "Jokers" then G.tcg_addition_page = 1 end
			G.tcg_tab = "Jokers"
			return { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.1, colour = G.C.CLEAR, }, nodes = create_tcg_builder('Joker', 'your_collection_tcg_consumeables_page'), }
		end},
		{ label = "Tarots", chosen = G.tcg_tab == "Tarots", tab_definition_function = function()
			if G.tcg_tab ~= "Tarots" then G.tcg_addition_page = 1 end
			G.tcg_tab = "Tarots"
			return { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.1, colour = G.C.CLEAR, }, nodes = create_tcg_builder('Tarot', 'your_collection_tcg_consumeables_page'), }
		end},
		{ label = "Spectrals", chosen = G.tcg_tab == "Spectrals", tab_definition_function = function()
			if G.tcg_tab ~= "Spectrals" then G.tcg_addition_page = 1 end
			G.tcg_tab = "Spectrals"
			return { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.1, colour = G.C.CLEAR, }, nodes = create_tcg_builder('Spectral', 'your_collection_tcg_consumeables_page'), }
		end},
		{ label = "Planets", chosen = G.tcg_tab == "Planets", tab_definition_function = function()
			if G.tcg_tab ~= "Planets" then G.tcg_addition_page = 1 end
			G.tcg_tab = "Planets"
			return { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.1, colour = G.C.CLEAR, }, nodes = create_tcg_builder('Planet', 'your_collection_tcg_consumeables_page'), }
		end},
		{ label = "Vouchers", chosen = G.tcg_tab == "Vouchers", tab_definition_function = function()
			if G.tcg_tab ~= "Vouchers" then G.tcg_addition_page = 1 end
			G.tcg_tab = "Vouchers"
			return { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.1, colour = G.C.CLEAR, }, nodes = create_tcg_builder('Voucher', 'your_collection_tcg_vouchers_page'), }
		end},
		{ label = "Cards", chosen = G.tcg_tab == "Cards", tab_definition_function = function()
			if G.tcg_tab ~= "Cards" then G.tcg_addition_page = 1 end
			G.tcg_tab = "Cards"
			return { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.1, colour = G.C.CLEAR, }, nodes = create_tcg_builder('Cards', 'your_collection_tcg_cards_page'), }
		end},
		{ label = "Backs", chosen = G.tcg_tab == "Backs", tab_definition_function = function()
			if G.tcg_tab ~= "Backs" then G.tcg_addition_page = 1 end
			G.tcg_tab = "Backs"
			return { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.1, colour = G.C.CLEAR, }, nodes = create_tcg_builder('Back', 'your_collection_tcg_backs_page'), }
		end},
	}

	return create_UIBox_generic_options({
		no_back = from_game_over, no_esc = from_game_over,
		back_func = (MP and MP.LOBBY and MP.LOBBY.code) and 'exit_overlay_menu' or "play_options",
		contents = 
			{{n = G.UIT.R, config = { padding = 0, align = "cm" }, nodes = {
				create_tabs({snap_to_nav = true, colour = G.C.RED, tabs = tabs})
			}}},
	})
end

G.FUNCS.create_tcg_builder_cocktail = function(e)
	
	-- boilerplate robbed from cryptid's decaying corpse
	if G.cocktail_tcg_select then
		for i = 1, #G.cocktail_tcg_select do
			G.cocktail_tcg_select[i]:remove()
			G.cocktail_tcg_select[i] = nil
		end
	end
	G.cocktail_tcg_select = {}
	for i = 1, 2 do
		G.cocktail_tcg_select[i] = CardArea(
			G.ROOM.T.x + 0.2 * G.ROOM.T.w / 1.5,
			G.ROOM.T.h,
			5.3 * G.CARD_W,
			1.03 * G.CARD_H,
			{ card_limit = 5, type = "title", highlight_limit = 999, collection = true }
		)
	end
	local decks = MP.get_cocktail_decks()
	table.insert(decks, 16, "b_challenge")

	local cfg = SMODS.Mods["Multiplayer"].config
	for i, v in ipairs(decks) do
		local row = math.floor((((i - 1) / #decks) * 2) + 1)
		
		local card = Card(
			G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
			G.ROOM.T.h,
			G.CARD_W,
			G.CARD_H,
			pseudorandom_element(G.P_CARDS),
			G.P_CENTERS.c_base,
			{ playing_card = i, tcg_back = v }
		)
		G.cocktail_tcg_select[row]:emplace(card)
		card.sprite_facing = "back"
		card.facing = "back"
		card.tcg_deck_type = v
		
		for k, vv in ipairs(BalatroTCG.BuildingDeck.backs) do
			if v == vv then
				card:highlight(true)
			end
		end
	end
	--G.GAME.viewed_back = G.P_CENTERS["b_mp_cocktail"]
	MP.show_cocktail_decks = MP.cocktail_cfg_readpos("show") ~= "H" and true or false
	deck_tables = {}
	for i = 1, #G.cocktail_tcg_select do
		deck_tables[i] = {
			n = G.UIT.R,
			config = { align = "cm", padding = 0, no_fill = true },
			nodes = {
				{ n = G.UIT.O, config = { object = G.cocktail_tcg_select[i] } },
			},
		}
	end
	local t = create_UIBox_generic_options({
		back_func = "tcg_start_build",
		snap_back = true,
		contents = {
			{
				n = G.UIT.R,
				config = { align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05 },
				nodes = deck_tables,
			},
			{
				n = G.UIT.R,
				config = { align = "cl", padding = 0 },
				nodes = {
					{
						n = G.UIT.T,
						config = { text = localize("k_cocktail_select"), scale = 0.48, colour = G.C.WHITE },
					},
				},
			},
		},
	})
	
	return t
end

-- Just stealing a ton of stuff from multiplayer (sorry)
local r_cursor_press_ref = Controller.queue_R_cursor_press
function Controller:queue_R_cursor_press(x, y)
	local ret = r_cursor_press_ref(self, x, y)
	if G.cocktail_tcg_select and G.cocktail_tcg_select[1].cards then -- bruh
		local highlight = false

		for i = 1, #G.cocktail_tcg_select do
			for j = 1, #G.cocktail_tcg_select[i].cards do
				G.cocktail_tcg_select[i].cards[j].highlighted = highlight
				G.cocktail_tcg_select[i].cards[j].mp_cocktail_forced = false
			end
		end

		play_sound("cardSlide2", nil, 0.3)
		BalatroTCG.BuildingDeck.backs = { 'b_mp_cocktail' }
		
	end
	return ret
end

G.FUNCS.your_collection_tcg_consumeables_page = function(args)
	G.tcg_addition_page = args.cycle_config.current_option

	G.in_delete_run = true
	if not args or not args.cycle_config then return end
	for j = 1, #G.your_collection do
		for i = #G.your_collection[j].cards,1, -1 do
			local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
			c:remove()
		end
	end
	for i = 1, 5 do
		for j = 1, #G.your_collection do
			local center = G.CARD_POOL[i+(j-1)*5 + (5*#G.your_collection*(args.cycle_config.current_option - 1))]
			if not center then break end
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
			card.original_id = center.original_id
			card.tcg_broken = center.tcg_broken
			G.your_collection[j]:emplace(card)
		end
	end
	G.in_delete_run = false
end

G.FUNCS.your_collection_tcg_vouchers_page = function(args)
	G.tcg_addition_page = args.cycle_config.current_option

	G.in_delete_run = true
	if not args or not args.cycle_config then return end
	for j = 1, #G.your_collection do
		for i = #G.your_collection[j].cards,1, -1 do
			local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
			c:remove()
		end
	end
	for i = 1, 4 do
		for j = 1, #G.your_collection do
			local center = G.CARD_POOL[i+(j-1)*4 + (4*#G.your_collection*(args.cycle_config.current_option - 1))]
			if not center then break end
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
			card.original_id = center.original_id
			card.tcg_broken = center.tcg_broken
			G.your_collection[j]:emplace(card)
		end
	end
	G.in_delete_run = false
end

G.FUNCS.your_collection_tcg_cards_page = function(args)
	G.tcg_addition_page = args.cycle_config.current_option

	G.in_delete_run = true
	if not args or not args.cycle_config then return end
	for j = 1, #G.your_collection do
		for i = #G.your_collection[j].cards,1, -1 do
			local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
			c:remove()
			c = nil
		end
	end
	for i = 1, 4 do
		for j = 1, #G.your_collection do
			local center = G.CARD_POOL[i+(j-1)*4 + (4*#G.your_collection*(args.cycle_config.current_option - 1))]
			if not center then break end
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, center, G.P_CENTERS['c_base'])
			card.cost = 0
			card.tcg_broken = center.tcg_broken
			G.your_collection[j]:emplace(card)
		end
	end
	G.in_delete_run = false
end

G.FUNCS.your_collection_tcg_backs_page = function(args)
	G.tcg_addition_page = args.cycle_config.current_option

	--G.in_delete_run = true
	if not args or not args.cycle_config then return end
	for j = 1, #G.your_collection do
		for i = #G.your_collection[j].cards,1, -1 do
			local c = G.your_collection[j].cards[i]
			c.area:remove_card(c)
			c:remove()
			c = nil
		end
	end

	for i = 1, 5 do
		for j = 1, #G.your_collection do
			local center = G.CARD_POOL[i+(j-1)*5 + (G.tcg_addition_page - 1) * 10]
			if not center then break end
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.S_A, G.P_CENTERS.c_base, { tcg_back = center.original_id })
			
			for k, v in pairs(BalatroTCG.BuildingDeck.backs) do
				if v == center.original_id then card.tcgb_deck_selected = true end
			end
			card.sprite_facing = 'back'
			card.facing = 'back'
			card.original_id = center.original_id
			card.tcg_deck_type = center.original_id
			card.tcg_broken = center.tcg_broken
			G.your_collection[j]:emplace(card, nil, true)
		end
	end
	
	--G.in_delete_run = false
end

SMODS.DrawStep({
	key = "tcgb_deck_selected",
	order = 5,
	func = function(self)
		if self.tcgb_deck_selected then self.children.back:draw_shader("foil", nil, self.ARGS.send_to_shader) end
	end,
	conditions = { vortex = false, facing = "back" },
})

G.FUNCS.your_collection_tcg_deck_page = function(args)
	G.tcg_deck_page = args.cycle_config.current_option

	if not args or not args.cycle_config then return end
	for j = 1, #G.your_tcg_deck do
		for i = #G.your_tcg_deck[j].cards,1, -1 do
			local c = G.your_tcg_deck[j]:remove_card(G.your_tcg_deck[j].cards[i])
			c:remove()
			c = nil
		end
	end

	for i = 1, 6 do
		for j = 1, #G.your_tcg_deck do
			local control = BalatroTCG.BuildingDeck.cards[i+(j-1)*6 + (6*#G.your_tcg_deck*(args.cycle_config.current_option - 1))]
			if not control then break end
			local card = BalatroTCG.BuildingDeck:card_from_control_ex(G.your_tcg_deck[j], 'b_red', control)
			G.your_tcg_deck[j]:emplace(card)
		end
	end
	INIT_COLLECTION_CARD_ALERTS()
end


local mainmenu_ref = G.UIDEF.override_main_menu_play_button
function G.UIDEF.override_main_menu_play_button()
    
    BalatroTCG.UseTCG_UI = false

	local set = UIBox_button({
			label = { localize("b_tcg_tcg") },
			colour = G.C.GREEN,
			button = "start_campaign",
			minw = 5,
		})

    if MP then
		local value = mainmenu_ref()
		
		
		local content = 
		value.nodes[1]
			.nodes[1]
			.nodes[1]
			.nodes

		for i = #content, 2, -1 do
			content[i + 1] = content[i]
		end
		content[2] = set
		
		
		if BalatroTCG.MultiCompat then
			for i = #content, 2, -1 do
				content[i + 1] = content[i]
			end
			content[3] = UIBox_button({
				label = { localize("b_tcg_tcg_lobby") },
				colour = G.C.GREEN,
				button = "start_tcg_lobby",
				minw = 5,
			})
		end
		
		return value
    else
        return (
            create_UIBox_generic_options({
                contents = {
                    UIBox_button({
                        label = { localize("b_tcg_vanilla") },
                        colour = G.C.BLUE,
                        button = "setup_run",
                        minw = 5,
                    }), 
					set,
                },
            })
        )
    end
end

function TCG_create_UIBox_HUD()
	local content = create_UIBox_HUD()
	
    local scale = 0.4

    local contents = {}

    local spacing = 0.13
    local temp_col = G.C.DYN_UI.BOSS_MAIN
    local temp_col2 = G.C.DYN_UI.BOSS_DARK

	contents.round = {
			{n=G.UIT.R, config={align = "cm"}, nodes={
			{n=G.UIT.C, config={id = 'hud_hands',align = "cm", padding = 0.05, minw = 1.45, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
				{n=G.UIT.R, config={align = "cm", minh = 0.33, maxw = 1.35}, nodes={
				{n=G.UIT.T, config={text = localize('k_hud_hands'), scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
				}},
				{n=G.UIT.R, config={align = "cm", r = 0.1, minw = 1.2, colour = temp_col2}, nodes={
				{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'hands_left'}}, font = G.LANGUAGES['en-us'].font, colours = {G.C.BLUE},shadow = true, rotate = true, scale = 2*scale}),id = 'hand_UI_count'}},
				}}
			}},
			{n=G.UIT.C, config={minw = spacing},nodes={}},
			{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 1.45, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
				{n=G.UIT.R, config={align = "cm", minh = 0.33, maxw = 1.35}, nodes={
				{n=G.UIT.T, config={text = localize('k_hud_discards'), scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
				}},
				{n=G.UIT.R, config={align = "cm"}, nodes={
				{n=G.UIT.R, config={align = "cm", r = 0.1, minw = 1.2, colour = temp_col2}, nodes={
					{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'discards_left'}}, font = G.LANGUAGES['en-us'].font, colours = {G.C.RED},shadow = true, rotate = true, scale = 2*scale}),id = 'discard_UI_count'}},
				}}
				}},
			}},
			}},
			{n=G.UIT.R, config={minh = spacing},nodes={}},
			{n=G.UIT.R, config={align = "cm"}, nodes={
			{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 1.45*2 + spacing, minh = 1.15, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
				{n=G.UIT.R, config={align = "cm"}, nodes={
				{n=G.UIT.C, config={align = "cm", r = 0.1, minw = 1.28*2+spacing, minh = 1, colour = temp_col2}, nodes={
					{n=G.UIT.O, config={object = DynaText({string = {{ref_table = BalatroTCG.Player.status, ref_value = 'dollars', prefix = localize('$')}},
						scale_function = function ()
							return scale_number(G.GAME.dollars, 2.2 * scale, 99999, 1000000)
						end, maxw = 1.35, colours = {G.C.MONEY}, font = G.LANGUAGES['en-us'].font, shadow = true,spacing = 2, bump = true, scale = 2.2*scale}), id = 'dollar_text_UI'}}
				}},
				}},
			}},
		}},
		{n=G.UIT.R, config={minh = spacing},nodes={}},
		{n=G.UIT.R, config={align = "cm"}, nodes={
			{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 1.45 * 2 + spacing, minh = 1, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
			{n=G.UIT.R, config={align = "cm", maxw = 1.35}, nodes={
				{n=G.UIT.T, config={text = localize('k_round'), minh = 0.33, scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
			}},
			{n=G.UIT.R, config={align = "cm", r = 0.1, minw = 1.2 * 2 + spacing, colour = temp_col2, id = 'row_round_text'}, nodes={
				{n=G.UIT.O, config={object = DynaText({string = {{ref_table = BalatroTCG.Player.status, ref_value = 'round'}}, colours = {G.C.IMPORTANT},shadow = true, scale = 2*scale}),id = 'round_UI_count'}},
			}},
			}},
		}}
    }

    contents.hand =
        {n=G.UIT.R, config={align = "cm", id = 'hand_text_area', colour = darken(G.C.BLACK, 0.1), r = 0.1, emboss = 0.05, padding = 0.03}, nodes={
            {n=G.UIT.C, config={align = "cm"}, nodes={
              {n=G.UIT.R, config={align = "cm", minh = 1.1}, nodes={
                {n=G.UIT.O, config={id = 'hand_name', func = 'hand_text_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "handname_text"}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, float = true, scale = scale*1.4})}},
                {n=G.UIT.O, config={id = 'hand_chip_total', func = 'hand_chip_total_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "chip_total_text"}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, float = true, scale = scale*1.4})}},
                {n=G.UIT.T, config={ref_table = G.GAME.current_round.current_hand, ref_value='hand_level', scale = scale, colour = G.C.UI.TEXT_LIGHT, id = 'hand_level', shadow = true}}
              }},
              {n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
                {n=G.UIT.C, config={align = "cr", minw = 2, minh =1, r = 0.1,colour = G.C.UI_CHIPS, id = 'hand_chip_area', emboss = 0.05}, nodes={
                    {n=G.UIT.O, config={func = 'flame_handler', no_role = true, id = 'flame_chips', object = Moveable(0,0,0,0), w = 0, h = 0}},
                    {n=G.UIT.O, config={id = 'hand_chips', func = 'hand_chip_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "chip_text"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = scale*2.3})}},
                    {n=G.UIT.B, config={w=0.1,h=0.1}},
                }},
                {n=G.UIT.C, config={align = "cm"}, nodes={
                  {n=G.UIT.T, config={text = "X", lang = G.LANGUAGES['en-us'], scale = scale*2, colour = G.C.UI_MULT, shadow = true}},
                }},
                {n=G.UIT.C, config={align = "cl", minw = 2, minh=1, r = 0.1,colour = G.C.UI_MULT, id = 'hand_mult_area', emboss = 0.05}, nodes={
                  {n=G.UIT.O, config={func = 'flame_handler', no_role = true, id = 'flame_mult', object = Moveable(0,0,0,0), w = 0, h = 0}},
                  {n=G.UIT.B, config={w=0.1,h=0.1}},
                  {n=G.UIT.O, config={id = 'hand_mult', func = 'hand_mult_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "mult_text"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = scale*2.3})}},
                }}
              }}
            }}
		}}

    contents.dollars_chips = 

	{n=G.UIT.R, config={align = "cm",r=0.1, padding = 0,colour = G.C.DYN_UI.BOSS_MAIN, emboss = 0.05, id = 'row_dollars_chips'}, nodes={
		{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
			{n=G.UIT.C, config={align = "cm", minw = 1.3}, nodes={
			{n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.3}, nodes={
			{n=G.UIT.T, config={text = localize('k_round'), scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
			}},
			{n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.3}, nodes={
			{n=G.UIT.T, config={text =localize('k_lower_score'), scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
			}}
			}},
			{n=G.UIT.C, config={align = "cm", minw = 3.3, minh = 0.7, r = 0.1, colour = G.C.DYN_UI.BOSS_DARK}, nodes={
			{n=G.UIT.B, config={w=0.1,h=0.1}},
			{n=G.UIT.T, config={ref_table = G.GAME, ref_value = 'chips_text', lang = G.LANGUAGES['en-us'], scale = 0.85, colour = G.C.WHITE, id = 'chip_UI_count', func = 'chip_UI_set', shadow = true}}
			}}
		}},
	}}
	
    contents.attack =
	
	{n=G.UIT.R, config={align = "cm",r=0.1, padding = 0,colour = G.C.DYN_UI.BOSS_MAIN, emboss = 0.05, id = 'row_attack'}, nodes={
		{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
			{n=G.UIT.C, config={align = "cm", minw = 1.3}, nodes={
				{n=G.UIT.T, config={text = localize('b_tcg_attack'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
			}},
			{n=G.UIT.C, config={align = "cm", minw = 1.75, minh = 0.65, r = 0.1, colour = G.C.DYN_UI.BOSS_DARK}, nodes={
				{n=G.UIT.T, config={ref_table = G.GAME, ref_value = 'chips_damage_text', lang = G.LANGUAGES['en-us'], scale = 0.4, colour = G.C.WHITE, id = 'damage_UI_count', func = 'chip_UI_damage', shadow = true}}
			}},
			{n=G.UIT.C, config={align = "cm", minw = 1.0, minh = 0.65, r = 0.1}, nodes={
				UIBox_button({
					id = "add_attack",
					func = "tcg_can_add_attack",
					button = "tcg_add_attack",
					colour = G.C.PURPLE,
					minw = 1.2,
					minh = 0.6,
					label = { '+' },
					scale = 0.8,
					col = true,
				})
			}}
		}}
	}}

    contents.buttons = {
      {n=G.UIT.C, config={align = "cm", r=0.1, colour = G.C.CLEAR, shadow = true, id = 'button_area', padding = 0.2}, nodes={
          {n=G.UIT.R, config={id = 'run_info_button', align = "cm", minh = 1.75, minw = 1.5,padding = 0.05, r = 0.1, hover = true, colour = G.C.RED, button = "run_info", shadow = true}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.4}, nodes={
              {n=G.UIT.T, config={text = localize('b_run_info_1'), scale = 1.2*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.4}, nodes={
              {n=G.UIT.T, config={text = localize('b_run_info_2'), scale = 1*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = G.F_GUIDE and 'guide' or 'back', orientation = 'bm'}, func = 'set_button_pip'}}
            }}
          }},
          {n=G.UIT.R, config={align = "cm", minh = 1.75, minw = 1.5,padding = 0.05, r = 0.1, hover = true, colour = G.C.ORANGE, button = "options", shadow = true}, nodes={
            {n=G.UIT.C, config={align = "cm", maxw = 1.4, focus_args = {button = 'start', orientation = 'bm'}, func = 'set_button_pip'}, nodes={
              {n=G.UIT.T, config={text = localize('b_options'), scale = scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
            }},
          }}
        }}
    }

	
    -- return {n=G.UIT.ROOT, config = {align = "cm", padding = 0.03, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
    --   {n=G.UIT.R, config = {align = "cm", padding= 0.05, colour = G.C.DYN_UI.MAIN, r=0.1}, nodes={
    --     {n=G.UIT.R, config={align = "cm", colour = G.C.DYN_UI.BOSS_DARK, r=0.1, minh = 30, padding = 0.08}, nodes={
    --       {n=G.UIT.R, config={align = "cm", minh = 0.3}, nodes={}},
    --       {n=G.UIT.R, config={align = "cm", id = 'row_blind', minw = 1, minh = 3.0}, nodes={}},
    --       contents.attack,
    --       contents.dollars_chips,
    --       contents.hand,
    --       {n=G.UIT.R, config={align = "cm", id = 'row_round'}, nodes={
    --         {n=G.UIT.C, config={align = "cm"}, nodes=contents.buttons},
    --         {n=G.UIT.C, config={align = "cm"}, nodes=contents.round}
    --       }},
    --     }}
    --   }}
    -- }}

	local area = content.nodes[1].nodes[1]

	for k, v in ipairs(content.nodes[1].nodes[1].nodes[4].nodes[1].nodes) do
		
	end
	-- if #content.nodes[1].nodes[1].nodes[4].nodes[1].nodes >= 3 then
	-- 	table.remove(content.nodes[1].nodes[1].nodes[4].nodes[1].nodes, 3)
	-- end
	area.nodes[1].config.minh = 0
	area.nodes[2].config.minh = 0

	area.nodes[6] = area.nodes[5]
	area.nodes[5] = area.nodes[4]
	area.nodes[4] = area.nodes[3]
	area.nodes[3] = contents.attack

	--area.nodes[4].
	area.nodes[6].nodes[2].nodes[1].nodes[1].nodes[2].nodes[1] = {n=G.UIT.O, config={object = DynaText({string = {{ref_table = BalatroTCG.Player.status, ref_value = 'hands_left'}}, font = G.LANGUAGES['en-us'].font, colours = {G.C.BLUE},shadow = true, rotate = true, scale = 2*scale}),id = 'hand_UI_count'}}
	area.nodes[6].nodes[2].nodes[1].nodes[3].nodes[2].nodes[1].nodes[1] = {n=G.UIT.O, config={object = DynaText({string = {{ref_table = BalatroTCG.Player.status, ref_value = 'discards_left'}}, font = G.LANGUAGES['en-us'].font, colours = {G.C.RED},shadow = true, rotate = true, scale = 2*scale}),id = 'discard_UI_count'}}
	area.nodes[6].nodes[2].nodes[5].nodes[3].nodes[2].nodes[1] = {n=G.UIT.O, config={object = DynaText({string = {{ref_table = BalatroTCG.Player.status, ref_value = 'round'}}, colours = {G.C.IMPORTANT},shadow = true, scale = 2*scale}),id = 'round_UI_count'}}

	area.nodes[6].nodes[2].nodes[3].nodes[1].nodes[1].nodes[1].nodes[1] = 
		{n=G.UIT.O, config={object = DynaText({string = {{ref_table = BalatroTCG.Player.status, ref_value = 'dollars', prefix = localize('$')}},
			scale_function = function ()
				return scale_number(G.GAME.dollars, 2.2 * scale, 99999, 1000000)
			end, maxw = 1.35, colours = {G.C.MONEY}, font = G.LANGUAGES['en-us'].font, shadow = true,spacing = 2, bump = true, scale = 2.2*scale}), id = 'dollar_text_UI'
		}}

	return content

	--]]

    --return {n=G.UIT.ROOT, config = {align = "cm", padding = 0.03, colour = G.C.UI.TRANSPARENT_DARK}, nodes={}}
end

function TCG_create_UIBox_HUD_blind()
	local scale = 0.4


	--{n=G.UIT.T, config={text = localize('k_round'), scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
	return {n=G.UIT.ROOT, config={align = "cm", minw = 1, r = 0.1, colour = G.C.BLACK, emboss = 0.05, padding = 0.05, id = 'HUD_blind'}, nodes={
		{n=G.UIT.R, config={minw = 1},nodes={}},
		{n=G.UIT.R, config={align = "cm", minw = 4.5, minh = 0, r = 0.0, emboss = 0, colour = G.C.DYN_UI.MAIN}, nodes={
			{n=G.UIT.R, config={align = "cm", id = 'HUD_blind_debuff', padding = 0.15}, nodes={
				{n=G.UIT.O, config={object = DynaText({string = localize('b_tcg_opponent'), shadow = true, rotate = true, silent = true, colours = {G.C.UI.TEXT_LIGHT}, float = true, scale = 0.8, y_offset = -4}),id = 'HUD_blind_name'}},
			}},
			
		}},
		{n=G.UIT.R, config={align = "cm", minw = 3, minh = 1.75, r = 0.0, emboss = 0, colour = G.C.DYN_UI.DARK}, nodes={
          	--{n=G.UIT.O, config={object = G.GAME.blind, draw_layer = 1}},
			{n=G.UIT.O, config={object = BalatroTCG.Opponent, draw_layer = 1}},
			{n=G.UIT.C, config={align = "cm", minw = 2,r = 0.1, padding = 0.05, emboss = 0.05, colour = G.C.BLACK}, nodes={
				--Required or game crashes

				{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'dollars_to_be_earned'}}, colours = {G.C.RED}, rotate = true, bump = true, silent = true, scale = 0}), id = 'dollars_to_be_earned'}},
				
				{n=G.UIT.R, config={align = "cm", id = 'HUD_blind_debuff', padding = 0.01}, nodes={
					{n=G.UIT.T, config={text=localize('b_tcg_healthopponent'), scale = 0.35, colour = G.C.UI.TEXT_LIGHT, id = 'HUD_blind_count' }},
				}},

				{n=G.UIT.R, config={align = "cm", id = 'HUD_blind_debuff', padding = 0.01}, nodes={
					{n=G.UIT.O, config={object = DynaText({string = {{ref_table = BalatroTCG.Player.status, ref_value = 'opponent_health', prefix = localize('$')}}, maxw = 1.35, colours = {G.C.MONEY}, font = G.LANGUAGES['en-us'].font, shadow = true,spacing = 2, bump = true, scale = 0.75}), id = 'dollar_text_opponent'}}
				}},
				
			}},
		}},
	}}
	--]]
end

local lobby_leave_ref = G.FUNCS.lobby_leave
function G.FUNCS.lobby_leave(e)
	BalatroTCG.MP_Lobby = false
	lobby_leave_ref(e)
end

function G.FUNCS.start_tcg_lobby(e)
	
	G.SETTINGS.paused = false

	MP.LOBBY.config.gamemode = "gamemode_mp_tcg"
	MP.LOBBY.config.ruleset = 'ruleset_mp_vanilla'

	MP.reset_lobby_config(true)

	reset_tcg_settings()
	

	MP.ACTIONS.create_lobby(string.sub(MP.LOBBY.config.gamemode, 13))
	G.FUNCS.exit_overlay_menu()
end

local start_lobby_ref = G.FUNCS.start_lobby
function G.FUNCS.start_lobby(e)

	if BalatroTCG.MP_Lobby then
		G.FUNCS.start_tcg_lobby(e)
	else
		start_lobby_ref(e)
	end
end

local create_UIBox_lobby_menu_ref = G.UIDEF.create_UIBox_lobby_menu
function G.UIDEF.create_UIBox_lobby_menu()

	local t = create_UIBox_lobby_menu_ref()
	if BalatroTCG.MP_Lobby then
		-- for i = #t.nodes[1].nodes[2].nodes[2].nodes, 3, -1 do
		-- 	t.nodes[1].nodes[2].nodes[2].nodes[i + 1] = t.nodes[1].nodes[2].nodes[2].nodes[i]
		-- end
		t.nodes[1].nodes[2].nodes[2].nodes[1].nodes[1].config.button = 'tcg_lobby_options'
			
		t.nodes[1].nodes[2].nodes[2].nodes[3] = {
			n=G.UIT.C,
			config = {padding = 0.1},
			nodes = {
				MP.UI.create_tcg_mp_button(0.45)
			}
		}
	end

	
	return t
end

function MP.UI.create_tcg_mp_button(text_scale)

	BalatroTCG.SelectedDeck = type(BalatroTCG.SelectedDeck) == 'table' and BalatroTCG.SelectedDeck or BalatroTCG.DefaultDecks[1]

	return UIBox_button({
		id = "lobby_choose_tcg_deck",
		button = "lobby_choose_tcg_deck",
		colour = G.C.PURPLE,
		minw = 2.15,
		minh = 1.35,
		label = { localize("b_tcgtab_select"), '(' .. (BalatroTCG.SelectedDeck.name) .. ')'},
		scale = text_scale * 1.2,
		col = true,
	})

end

function MP.UI.create_tcg_mpoptions_button(text_scale)

	return UIBox_button({
		id = "tcg_lobby_options",
		button = "tcg_lobby_options",
		colour = G.C.PURPLE,
		minw = 2.15,
		minh = 1.35,
		label = { localize("b_tcgtab_select") },
		scale = text_scale * 1.2,
		col = true,
	})

end



function G.FUNCS.tcg_lobby_options(e)
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_tcg_lobby_options(),
	})
end


local MP_reset_lobby_config_ref = MP.reset_lobby_config
function MP.reset_lobby_config(persist_ruleset_and_gamemode)
	
	MP_reset_lobby_config_ref(persist_ruleset_and_gamemode)

	if MP.LOBBY.config.gamemode == "gamemode_mp_tcg" then
		MP.LOBBY.config.preview_disabled = true
		MP.LOBBY.config.the_order = false
		MP.LOBBY.config.timer = false
		MP.LOBBY.config.disable_live_and_timer_hud = true
		
		MP.LOBBY.config.tcg_balanced = true
		MP.LOBBY.config.health_pool = 100
		MP.LOBBY.config.joker_health = 20
		MP.LOBBY.config.default_hands = 2
		MP.LOBBY.config.default_discards = 2

		MP.LOBBY.config.money_leak = true
		MP.LOBBY.config.money_leak_start = 10
		MP.LOBBY.config.money_leak_increase = 2

		MP.LOBBY.config.game_round_limit = true
		MP.LOBBY.config.round_limit = 15
		MP.LOBBY.config.winner_type = "Highest Money"

		MP.LOBBY.config.deck_money_limit = true
		MP.LOBBY.config.deck_joker_limits = true
		MP.LOBBY.config.deck_size_limits = true
		MP.LOBBY.config.deck_back_limits = true
		MP.LOBBY.config.deck_consumeable_limits = true
	else

	end
end

function MP.UI.create_tcg_lobby_options_tab()
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			minh = 4,
			r = 0.1,
			minw = 10,
			align = "tm",
			padding = 0.2,
			colour = G.C.BLACK,
		},
		nodes = {
			{
				n = G.UIT.R,
				nodes = {
					{
						n = G.UIT.C,
						nodes = {
							create_lobby_option_cycle(
								"money_pool_option",
								"b_opts_tcg_health",
								0.85,
								{ 50, 60, 75, 100, 125, 150, 200, 300 },
								MP.UTILS.get_array_index_by_value(
									{ 50, 60, 75, 100, 125, 150, 200, 300 },
									MP.LOBBY.config.health_pool
								),
								"change_health_pool"
							),
							create_lobby_option_cycle(
								"joker_health_option",
								"b_opts_tcg_joker_health",
								0.85,
								{ 5, 10, 20, 25, 30, 40, 50 },
								MP.UTILS.get_array_index_by_value(
									{ 5, 10, 15, 20, 25, 30, 40, 50 },
									MP.LOBBY.config.joker_health
								),
								"change_joker_health"
							),
						}
					},
					{
						n = G.UIT.C,
						nodes = {
							create_lobby_option_cycle(
								"hands_option",
								"b_opts_tcg_hands",
								0.85,
								{ 1, 2, 3, 4, 5 },
								MP.UTILS.get_array_index_by_value(
								{ 1, 2, 3, 4, 5 },
									MP.LOBBY.config.default_hands
								),
								"change_tcg_hands"
							),
							create_lobby_option_cycle(
								"discards_option",
								"b_opts_tcg_discards",
								0.85,
								{ 0, 1, 2, 3, 4, 5 },
								MP.UTILS.get_array_index_by_value(
								{ 0, 1, 2, 3, 4, 5 },
									MP.LOBBY.config.default_discards
								),
								"change_tcg_discards"
							),
						}
					},
				}
			},
			{
				n = G.UIT.R,
				nodes = {
					create_lobby_option_toggle("tcg_balanced", "b_opts_tcg_balanced", "tcg_balanced"),
				}
			}
		},
	}
end
function MP.UI.create_tcg_deck_options_tab()
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			minh = 4,
			r = 0.1,
			minw = 10,
			align = "tm",
			padding = 0.2,
			colour = G.C.BLACK,
		},
		nodes = {
			{
				n = G.UIT.C,
				nodes = {
					{
						n = G.UIT.R,
						config = { padding = 0, align = "cm", on_demand_tooltip = { text = { localize("b_opts_tcg_deck_money_limit_desc") } } },
						nodes = { create_lobby_option_toggle("deck_money_limit", "b_opts_tcg_deck_money_limit", "deck_money_limit") }
					},
					{
						n = G.UIT.R,
						config = { padding = 0, align = "cm", on_demand_tooltip = { text = { localize("b_opts_tcg_deck_size_limits_desc") } } },
						nodes = { create_lobby_option_toggle("deck_size_limits", "b_opts_tcg_deck_size_limits", "deck_size_limits") }
					},
					{
						n = G.UIT.R,
						config = { padding = 0, align = "cm", on_demand_tooltip = { text = { localize("b_opts_tcg_deck_back_limits_desc") } } },
						nodes = { create_lobby_option_toggle("deck_back_limits", "b_opts_tcg_deck_back_limits", "deck_back_limits") }
					},
				}
			},
			{
				n = G.UIT.C,
				nodes = {
					{
						n = G.UIT.R,
						config = { padding = 0, align = "cm", on_demand_tooltip = { text = { localize("b_opts_tcg_deck_joker_limits_desc") } } },
						nodes = { create_lobby_option_toggle("deck_joker_limits", "b_opts_tcg_deck_joker_limits", "deck_joker_limits") }
					},
					{
						n = G.UIT.R,
						config = { padding = 0, align = "cm", on_demand_tooltip = { text = { localize("b_opts_tcg_deck_consumeable_limits_desc") } } },
						nodes = { create_lobby_option_toggle("deck_consumeable_limits", "b_opts_tcg_deck_consumeable_limits", "deck_consumeable_limits") }
					},
				}
			}
		},
	}
end
function MP.UI.create_tcg_ending_options_tab()
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			minh = 4,
			r = 0.1,
			minw = 10,
			align = "tm",
			padding = 0.2,
			colour = G.C.BLACK,
		},
		nodes = {
			{
				n = G.UIT.C,
				nodes = {
					{
						n = G.UIT.R,
						config = { padding = 0, align = "cm", on_demand_tooltip = { text = { localize("b_opts_tcg_money_leak_desc") } } },
						nodes = { create_lobby_option_toggle("money_leak_enabled", "b_opts_tcg_money_leak", "money_leak") }
					},
					create_lobby_option_cycle(
						"money_leak_start",
						"b_opts_tcg_money_leak_start",
						0.85,
						{ 1, 2, 4, 6, 8, 10, 15, 20 },
						MP.UTILS.get_array_index_by_value(
							{ 1, 2, 4, 6, 8, 10, 15, 20 },
							MP.LOBBY.config.money_leak_start
						),
						"change_money_leak_start"
					),
					create_lobby_option_cycle(
						"money_leak_increase",
						"b_opts_tcg_money_leak_increase",
						0.85,
						{ 0, 1, 2, 3, 4, 5 },
						MP.UTILS.get_array_index_by_value(
							{ 0, 1, 2, 3, 4, 5 },
							MP.LOBBY.config.money_leak_increase
						),
						"change_money_leak_increase"
					),
				}
			},
			{
				n = G.UIT.C,
				nodes = {
					{
						n = G.UIT.R,
						config = { padding = 0, align = "cm", on_demand_tooltip = { text = { localize("b_opts_tcg_game_round_limit_desc") } } },
						nodes = { create_lobby_option_toggle("game_round_limit_enabled", "b_opts_tcg_game_round_limit", "game_round_limit"), }
					},
					
					create_lobby_option_cycle(
						"round_limit",
						"b_opts_tcg_round_limit",
						0.85,
						{ 1, 5, 8, 10, 12, 15, 20, 25, 30 },
						MP.UTILS.get_array_index_by_value(
							{ 1, 5, 8, 10, 12, 15, 20, 25, 30 },
							MP.LOBBY.config.round_limit
						),
						"change_round_limit"
					),
					create_lobby_option_cycle(
						"winner_type",
						"b_opts_tcg_winner_type",
						0.85,
						{ "Lowest Money", "Highest Money" },
						MP.UTILS.get_array_index_by_value(
							{ "Lowest Money", "Highest Money" },
							MP.LOBBY.config.winner_type
						),
						"change_winner_type"
					),
				}
			}
		},
	}
end

G.FUNCS.change_tcg_hands = function(args)
	MP.LOBBY.config.default_hands = args.to_val
	MP.ACTIONS.lobby_options()
end
G.FUNCS.change_tcg_discards = function(args)
	MP.LOBBY.config.default_discards = args.to_val
	MP.ACTIONS.lobby_options()
end
G.FUNCS.change_health_pool = function(args)
	MP.LOBBY.config.health_pool = args.to_val
	MP.ACTIONS.lobby_options()
end
G.FUNCS.change_joker_health = function(args)
	MP.LOBBY.config.joker_health = args.to_val
	MP.ACTIONS.lobby_options()
end
G.FUNCS.change_money_leak_start = function(args)
	MP.LOBBY.config.money_leak_start = args.to_val
	MP.ACTIONS.lobby_options()
end
G.FUNCS.change_money_leak_increase = function(args)
	MP.LOBBY.config.money_leak_increase = args.to_val
	MP.ACTIONS.lobby_options()
end

G.FUNCS.change_round_limit = function(args)
	MP.LOBBY.config.round_limit = args.to_val
	MP.ACTIONS.lobby_options()
end
G.FUNCS.change_winner_type = function(args)
	MP.LOBBY.config.winner_type = args.to_val
	MP.ACTIONS.lobby_options()
end

local lobby_options_ref = MP.ACTIONS.lobby_options
function MP.ACTIONS.lobby_options()
	lobby_options_ref()
	set_tcg_mp_settings()
end

function G.UIDEF.create_UIBox_tcg_lobby_options()
	return create_UIBox_generic_options({
		contents = {
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm",
				},
				nodes = {
					not MP.LOBBY.is_host and {
						n = G.UIT.R,
						config = {
							padding = 0.3,
							align = "cm",
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									scale = 0.6,
									shadow = true,
									text = localize("k_opts_only_host"),
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						},
					} or nil,
					create_tabs({
						snap_to_nav = true,
						colour = G.C.BOOSTER,
						tabs = {
							{
								label = localize("k_lobby_general"),
								chosen = true,
								tab_definition_function = function()
									return MP.UI.create_tcg_lobby_options_tab()
								end,
							},
							{
								label = localize("k_lobby_gameplay"),
								tab_definition_function = function()
									return MP.UI.create_tcg_ending_options_tab()
								end,
							},
							{
								label = localize("k_lobby_deck"),
								tab_definition_function = function()
									return MP.UI.create_tcg_deck_options_tab()
								end,
							},
							-- {
							-- 	label = localize("k_lobby_modifiers"),
							-- 	tab_definition_function = function()
							-- 		return MP.UI.create_gamemode_modifiers_tab()
							-- 	end,
							-- },
							-- {
							-- 	label = localize("k_lobby_advanced"),
							-- 	tab_definition_function = function()
							-- 		return MP.UI.create_advanced_options_tab()
							-- 	end,
							-- },
						},
					}),
				},
			},
		},
	})
end
