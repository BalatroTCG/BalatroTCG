
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

	G.FUNCS.overlay_menu({
		definition = G.UIDEF.override_main_menu_play_button(),
	})
end

function G.FUNCS.start_campaign(e)
	G.SETTINGS.paused = true

	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_tcg_deck_selection((e.config.id == 'from_game_over' or e.config.id == 'from_game_won') and e.config.id),
	})
	if (e.config.id == 'from_game_over' or e.config.id == 'from_game_won') then G.OVERLAY_MENU.config.no_esc = true end
end

G.FUNCS.change_viewed_tcg_deck = function(args)

	BalatroTCG.SelectedDeck = args.to_key

	local deck = get_tcg_deck(BalatroTCG.SelectedDeck)
	
	G.GAME.viewed_back:change_to(get_deck_from_name(deck.back))
end

G.FUNCS.change_viewed_tcg_build_deck = function(args)
	
	BalatroTCG.SelectedDeck = args.to_key
	if _RELEASE_MODE then
		BalatroTCG.SelectedDeck = BalatroTCG.SelectedDeck + #BalatroTCG.DefaultDecks
	end

	local deck = get_tcg_deck(BalatroTCG.SelectedDeck, true)
	
	G.GAME.viewed_back:change_to(get_deck_from_name(deck.back))
end

G.FUNCS.RUN_SETUP_check_tcg_back = function(e)
  if G.GAME.viewed_back.name ~= e.config.id then 
    --removes the UI from the previously selected back and adds the new one

    e.config.object:remove() 
    e.config.object = UIBox{
      definition = G.GAME.viewed_back:generate_tcg_UI(),
      config = {offset = {x=0,y=0}, align = 'cm', parent = e}
    }
    e.config.id = G.GAME.viewed_back.name
  end
end

G.FUNCS.RUN_SETUP_check_tcgdeck_name = function(e)
  if e.config.object and G.GAME.viewed_back and BalatroTCG.SelectedDeck ~= e.config.id then 
    --removes the UI from the previously selected back and adds the new one
	local max = #BalatroTCG.DefaultDecks + #BalatroTCG.CustomDecks
	local deck = get_tcg_deck(BalatroTCG.SelectedDeck)

	local deckname, backname = nil, nil
	if BalatroTCG.SelectedDeck > max then
		deckname, backname = 'New Deck', '???'
	else
		deckname, backname = deck.name, G.GAME.viewed_back:get_name()
	end
	
    e.config.object:remove() 
    e.config.object = UIBox{
		definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
			{n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, func = 'RUN_SETUP_check_tcgdeck_name'}, nodes={
				{n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR }, nodes={
					{n=G.UIT.O, config={id = BalatroTCG.SelectedDeck, object = DynaText({string = deckname,maxw = 4, colours = {G.C.WHITE}, shadow = true, bump = true, scale = 0.45, pop_in = 0, silent = true})}},
				}},
				{n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR }, nodes={
					{n=G.UIT.O, config={id = BalatroTCG.SelectedDeck, object = DynaText({string = '(' .. backname .. ')',maxw = 4, colours = {G.C.WHITE}, shadow = true, bump = true, scale = 0.3, pop_in = 0, silent = true})}},
				}},
			}},
		}},
		config = {offset = {x=0,y=0}, align = 'cm', parent = e}
    }
    e.config.id = BalatroTCG.SelectedDeck
  end
end

function Back:generate_tcg_UI(other, ui_scale, min_dims)


    min_dims = min_dims or 0.7
    ui_scale = ui_scale or 0.9
    local back_config = other or self.effect.center
    local name_to_check = other and other.name or self.name
    local effect_config = get_TCG_params(name_to_check)
	local default = get_TCG_params(nil)

    local loc_args, loc_nodes = nil, {}

	local key_override
	if back_config.tcg_loc_vars and type(back_config.tcg_loc_vars) == 'function' then
		local res = back_config:tcg_loc_vars() or {}
		loc_args = res.vars or {}
		key_override = res.key
	elseif name_to_check == 'Blue Deck' then loc_args = {effect_config.hands - default.hands}
	elseif name_to_check == 'Red Deck' then loc_args = {effect_config.discards - default.discards}
	elseif name_to_check == 'Yellow Deck' then loc_args = {effect_config.dollars - default.dollars}
	elseif name_to_check == 'Green Deck' then loc_args = { 3 }
	elseif name_to_check == 'Black Deck' then loc_args = { 1, 1}
	elseif name_to_check == 'Magic Deck' then  loc_args = { 3 }
	elseif name_to_check == 'Nebula Deck' then loc_args = { 5, -1 }
	elseif name_to_check == 'Ghost Deck' then loc_args = { 2 }
	elseif name_to_check == 'Abandoned Deck' then 
	elseif name_to_check == 'Checkered Deck' then
	elseif name_to_check == 'Zodiac Deck' then loc_args = { 1, effect_config.discount }
	elseif name_to_check == 'Painted Deck' then loc_args = { 2, -1 }
	elseif name_to_check == 'Anaglyph Deck' then loc_args = {1, 3}
	elseif name_to_check == 'Plasma Deck' then loc_args = { 2, 10 }
	elseif name_to_check == 'Erratic Deck' then loc_args = { 5 }
	elseif name_to_check == 'Challenge Deck' then loc_args = { 4 }
	end
	if BalatroTCG.SelectedDeck > #BalatroTCG.DefaultDecks + #BalatroTCG.CustomDecks then
		key_override = 'null'
	end
	localize{type = 'descriptions', key = key_override or (back_config.key .. '_tcg'), set = 'Back', nodes = loc_nodes, vars = loc_args}
    

    return 
    {n=G.UIT.ROOT, config={align = "cm", minw = min_dims*5, minh = min_dims*2.5, id = self.name, colour = G.C.CLEAR}, nodes={
        desc_from_rows(loc_nodes, true, min_dims*5)
    }}
end

function select_tcg_deck(tab_type)

	local area = CardArea(
		G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
		G.CARD_W,
		G.CARD_H, 
		{card_limit = 5, type = 'deck', highlight_limit = 0, deck_height = 0.75, thin_draw = 1})

	local callback = 'change_viewed_tcg_deck'
	local deck_selection = tableMerge(BalatroTCG.DefaultDecks, BalatroTCG.CustomDecks)
	BalatroTCG.SelectedDeck = BalatroTCG.SelectedDeck or 1
	local selected = BalatroTCG.SelectedDeck
	
	if tab_type == 'build' then
		callback = 'change_viewed_tcg_build_deck'
		if _RELEASE_MODE then
			BalatroTCG.SelectedDeck = math.max(BalatroTCG.SelectedDeck, #BalatroTCG.DefaultDecks + 1)
			deck_selection = tableMerge({}, BalatroTCG.CustomDecks)
			selected = BalatroTCG.SelectedDeck - #BalatroTCG.DefaultDecks
		else

		end
		deck_selection[#deck_selection + 1] = 'new'
	elseif tab_type == 'legal' then
		BalatroTCG.SelectedDeck = math.min(BalatroTCG.SelectedDeck, #BalatroTCG.DefaultDecks + #BalatroTCG.CustomDecks)
		selected = BalatroTCG.SelectedDeck
	end
	
	local deck = get_tcg_deck(BalatroTCG.SelectedDeck)
	G.GAME.viewed_back = Back(get_deck_from_name(deck.back))
	
	for i = 1, 10 do
		local card = Card(G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h, G.CARD_W, G.CARD_H, pseudorandom_element(G.P_CARDS), G.P_CENTERS.c_base, {playing_card = i, viewed_back = true})
		card.sprite_facing = 'back'
		card.facing = 'back'
		area:emplace(card)
	end

	return { n = G.UIT.R, config = { align = 'cm', minh = 1, minw = 1, colour = G.C.CLEAR, }, nodes = {
		create_option_cycle({options = deck_selection, opt_callback = callback, current_option = selected, colour = G.C.RED, w = 3.5, mid = 
			{ n=G.UIT.R, config = {align = 'cm', minh=3.3, minw = 5 }, nodes = {
				{n=G.UIT.C, config={align = "cm", colour = G.C.BLACK, emboss = 0.05, padding = 0.15, r = 0.1}, nodes={
					{n=G.UIT.C, config={align = "cm"}, nodes={
						{n=G.UIT.R, config={align = "cm", shadow = false}, nodes={
							{n=G.UIT.O, config={object = area}}
						}},
					}},
					{n=G.UIT.C, config={align = "cm", minh = 1.7, r = 0.1, colour = G.C.L_BLACK, padding = 0.1}, nodes={
						{n=G.UIT.R, config={align = "cm", r = 0.1, minw = 4, maxw = 4, minh = 0.8}, nodes={
							{n=G.UIT.O, config={id = nil, func = 'RUN_SETUP_check_tcgdeck_name', object = Moveable()}},
						}},
						{n=G.UIT.R, config={align = "cm", colour = G.C.WHITE, minh = 1.7, r = 0.1}, nodes={
							{n=G.UIT.O, config={id = G.GAME.viewed_back.name, func = 'RUN_SETUP_check_tcg_back', object = UIBox{definition = G.GAME.viewed_back:generate_tcg_UI(), config = {offset = {x=0,y=0}}}}}
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
	
	local tabs = {
				-- Single Match Tab
				{ label = localize("b_tcgtab_single"), chosen = true, tab_definition_function = function()
					
					return { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.2, colour = G.C.CLEAR, }, nodes = {
						select_tcg_deck('legal'),
						UIBox_button({
							label = { localize("b_play_cap") },
							colour = G.C.BLUE,
							button = "tcg_start_single",
							minw = 5,
						})
					}}
				end},
				-- Build Deck Tab
				{ label = localize("b_tcgtab_deck"), chosen = false, tab_definition_function = function()
					
					return { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.2, colour = G.C.CLEAR, }, nodes = {
						select_tcg_deck('build'),
						
						{n = G.UIT.R, config = { padding = 0, align = "cm", colour = G.C.CLEAR }, nodes = {
							{n = G.UIT.C, config = { padding = 0.2, align = "cm", colour = G.C.CLEAR }, nodes = {
								UIBox_button({
									n = G.UIT.R,
									label = { localize("b_tcg_build") },
									colour = G.C.GREEN,
									button = "tcg_start_build",
									minw = 3,
								}),
							}},
							{n = G.UIT.C, config = { padding = 0.2, align = "cm", colour = G.C.CLEAR }, nodes = {
								UIBox_button({
									n = G.UIT.R,
									label = { localize("b_tcg_delete") },
									colour = G.C.RED,
									func = "tcg_delete_check",
									button = "tcg_delete_deck",
									minw = 3,
								})
							}}
						}}
					}}
				end},
			}
	if MP and BalatroTCG.MultiCompat then
		tabs[#tabs + 1] = 
			{ label = localize("b_tcgtab_online"), chosen = false, tab_definition_function = function()
				
				return { n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'tm', padding = 0.2, colour = G.C.CLEAR, }, nodes = {
					UIBox_button({
						label = { localize("b_tcgtab_online_start") },
						colour = G.C.BLUE,
						button = "start_tcg_lobby",
						minw = 5,
					})
				}}
			end}
	end
	return (
		create_UIBox_generic_options({
			no_back = from_game_over, no_esc = from_game_over,
			back_func = from_game_over and nil or "play_options",
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
	
	local deck = get_tcg_deck(BalatroTCG.SelectedDeck)
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
				}}
			},
		})
	
end


function G.FUNCS.set_bet_amount(e)
	BalatroTCG.BetAmount = e.cycle_config.current_option - 1
end

function G.FUNCS.set_betting(e)

	if MP and MP.LOBBY and MP.LOBBY.code then
		Client.send({action = "tcgBet", amount = BalatroTCG.BetAmount })
		G.FUNCS.overlay_menu({
			definition = G.UIDEF.waiting_for_opponent(),
		})
	else

		local ai_bet = pseudorandom(generate_starting_seed(), BalatroTCG.AI.bet_min, BalatroTCG.AI.bet_max)
		local player_goes = false

		print(ai_bet)

		if ai_bet <= BalatroTCG.BetAmount then
			player_goes = true
		else

		end

		switch_player(player_goes)
		if player_goes then
			ease_dollars(-BalatroTCG.BetAmount)
		else
			BalatroTCG.Player:send_message({ type = 'attack', damage = ai_bet, index = 0 })
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
				{n=G.UIT.T, config={text = localize('k_tcg_waiting'), scale = 0.85, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
			},
		})
	
end

function G.FUNCS.tcg_delete_check(e)
    if BalatroTCG.SelectedDeck <= #BalatroTCG.DefaultDecks or BalatroTCG.SelectedDeck > (#BalatroTCG.DefaultDecks + #BalatroTCG.CustomDecks) then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = 'tcg_delete_deck'
    end
end

function G.FUNCS.lobby_choose_tcg_deck()

	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu{
		definition = 
		create_UIBox_generic_options({ padding = 0, bg_colour = G.C.CLEAR, contents = {
			{ n = G.UIT.ROOT, config = { minh = 1, minw = 1, align = 'cm', padding = 0.5, colour = G.C.CLEAR, }, nodes = {
				select_tcg_deck('legal'),
			}}
		}})
	}
end

function clear_collection()
	for j = 1, #areas do
		areas[j]:remove()
	end
end

function create_tcg_builder(type, callback)
	BalatroTCG.BuildingDeck = BalatroTCG.BuildingDeck or load_building_deck(BalatroTCG.SelectedDeck)

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
			if not v.omit and #G.CARD_POOL < 15 then -- todo: Figure out how to display modded backs
				v.original_id = v.name
				G.CARD_POOL[#G.CARD_POOL + 1] = v
			end
		end
		for i = 1, math.ceil(#G.CARD_POOL/(5*#G.your_collection)) do
			table.insert(joker_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#G.CARD_POOL/(5*#G.your_collection))))
		end
		
	else
		G.CARD_POOL = {}
		for k, v in pairs(G.P_CENTER_POOLS[type]) do
			if not v.omit and not (string.sub(v.key, 1, 4) == 'j_mp'
			-- and string.find(v.key, '_sandbox') -- TODO: add multiplayer joker functionality
		) then
				v.original_id = v.key
				G.CARD_POOL[#G.CARD_POOL + 1] = v
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
				local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.S_A, G.P_CENTERS.c_base, { bypass_back = center.pos })
				--card.children.back.atlas = get_deck_from_name(center.name).atlas
				card.sprite_facing = 'back'
				card.facing = 'back'
				card.original_id = center.original_id
				G.your_collection[j]:emplace(card, nil, true)
			end
		end
	elseif type == 'Cards' then
		for i = 1, 4 do
			for j = 1, #G.your_collection do
				local center = G.CARD_POOL[i+(j-1)*4 + (G.tcg_addition_page - 1) * 8]
				if not center then break end
				local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, center, G.P_CENTERS.c_base)
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
				G.your_collection[j]:emplace(card)
			end
		end
	end
	local back = Back(G.P_CENTERS.b_red)

	for i = 1, 6 do
		for j = 1, #G.your_tcg_deck do
			local control = BalatroTCG.BuildingDeck.cards[i+(j-1)*6 + (G.tcg_deck_page - 1) * 12]
			if not control then break end
			
			local card = BalatroTCG.BuildingDeck:card_from_control_ex(G.your_tcg_deck[j], back, control)
			G.your_tcg_deck[j]:emplace(card)
		end
	end

	local legal_status = BalatroTCG.BuildingDeck:is_legal()
    local loc_nodes = nil, {}
	local loc_args = { type = 'text', key = "tcg_err_unknown", nodes = loc_nodes, vars = {}, default_col = G.C.WHITE, scale = 1.5 }

	if legal_status == 'Legal' then
		loc_args.key = 'tcg_err_none'
	else
		for k, v in pairs(legal_status) do
			loc_args.key = k
			loc_args.vars = v
			break
		end
	end

	local t =  {
		{n=G.UIT.R, config={align = "cm", padding = 0.0}, nodes={
			{n=G.UIT.C, nodes = {
				{n=G.UIT.R, config={align = "cm",minh = 1.2, padding = 0.2}, nodes={{n=G.UIT.R, config={align = "cm"}, nodes=localize(loc_args) },}},
				{n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
				{n=G.UIT.R, config={align = "cm"}, nodes={
					create_option_cycle({options = joker_options, w = 4.5, cycle_shoulders = true, opt_callback = callback, current_option = G.tcg_addition_page, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
				}}
			}},
			{n=G.UIT.C, config={align = "cm", padding = 0.2}, nodes={}},
			{n=G.UIT.C, nodes = {
				
				{n=G.UIT.R, config={align = "cm",minh = 1.2, padding = 0.2}, nodes={{n=G.UIT.R, config={align = "cm"}, nodes={
					
					{n=G.UIT.O, config={object = DynaText({string = {{prefix = localize('$'), ref_table = BalatroTCG.BuildingDeck, ref_value = 'cost'}}, font = G.LANGUAGES['en-us'].font, colours = {G.C.MONEY},shadow = true, rotate = true, scale = 0.45})}},
					
					{n=G.UIT.C, config={align = "cm",minh = 1, padding = 0.1}, nodes={{n=G.UIT.R, config={align = "cm"}, nodes={
						
						create_text_input({
						w = 4, max_length = 24, prompt_text = localize('k_enter_name'),
						ref_table = BalatroTCG.BuildingDeck, ref_value = 'name',extended_corpus = true, keyboard_offset = 1,
						callback = function()
							save_decks()
						end
						}),

					} },}},
				}},}},
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

	BalatroTCG.BuildingDeck = load_building_deck(BalatroTCG.SelectedDeck)
	
	G.FUNCS.overlay_menu{
		definition = G.FUNCS.create_tcg_builder_menu()
	}
end


G.FUNCS.tcg_delete_deck = function(e)
	G.SETTINGS.paused = true

	table.remove(BalatroTCG.CustomDecks, BalatroTCG.SelectedDeck - #BalatroTCG.DefaultDecks)

	save_decks()

	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_tcg_deck_selection((e.config.id == 'from_game_over' or e.config.id == 'from_game_won') and e.config.id),
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
		back_func = from_game_over and nil or "play_options",
		contents = 
			{{n = G.UIT.R, config = { padding = 0, align = "cm" }, nodes = {
				create_tabs({snap_to_nav = true, colour = G.C.RED, tabs = tabs})
			}}},
	})
end

G.FUNCS.your_collection_tcg_consumeables_page = function(args)
	G.tcg_addition_page = args.cycle_config.current_option

	if not args or not args.cycle_config then return end
	for j = 1, #G.your_collection do
		for i = #G.your_collection[j].cards,1, -1 do
			local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
			c:remove()
			c = nil
		end
	end
	for i = 1, 5 do
		for j = 1, #G.your_collection do
			local center = G.CARD_POOL[i+(j-1)*5 + (5*#G.your_collection*(args.cycle_config.current_option - 1))]
			if not center then break end
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
			card.original_id = center.original_id
			G.your_collection[j]:emplace(card)
		end
	end
end

G.FUNCS.your_collection_tcg_cards_page = function(args)
	G.tcg_addition_page = args.cycle_config.current_option

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
			G.your_collection[j]:emplace(card)
		end
	end
end

G.FUNCS.your_collection_tcg_backs_page = function(args)
	G.tcg_addition_page = args.cycle_config.current_option

	if not args or not args.cycle_config then return end
	for j = 1, #G.your_collection do
		for i = #G.your_collection[j].cards,1, -1 do
			local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
			c:remove()
			c = nil
		end
	end
	for i = 1, 5 do
		for j = 1, #G.your_collection do
			local center = G.CARD_POOL[i+(j-1)*5 + (G.tcg_addition_page - 1) * 10]
			if not center then break end
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.S_A, G.P_CENTERS.c_base, { bypass_back = center.pos })
			--card.children.back.atlas = get_deck_from_name(center.name).atlas
			card.sprite_facing = 'back'
			card.facing = 'back'
			card.original_id = center.original_id
			G.your_collection[j]:emplace(card, nil, true)
		end
	end
end

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
	local back = Back(get_deck_from_name(BalatroTCG.BuildingDeck.back))
	for i = 1, 6 do
		for j = 1, #G.your_tcg_deck do
			local control = BalatroTCG.BuildingDeck.cards[i+(j-1)*6 + (6*#G.your_tcg_deck*(args.cycle_config.current_option - 1))]
			if not control then break end
			local card = BalatroTCG.BuildingDeck:card_from_control_ex(G.your_tcg_deck[j], back, control)
			G.your_tcg_deck[j]:emplace(card)
		end
	end
	INIT_COLLECTION_CARD_ALERTS()
end


local mainmenu_ref = G.UIDEF.override_main_menu_play_button
function G.UIDEF.override_main_menu_play_button()
    
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


		for i = 2, #content do
			local temp = content[i]
			content[i] = set
			set = temp
		end
		content[#content + 1] = set
		
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
		{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
			{n=G.UIT.C, config={align = "cm", minw = 1.3}, nodes={
				{n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.3}, nodes={
				{n=G.UIT.T, config={text = localize('b_tcg_attack'), scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
				}},
			}},
			{n=G.UIT.C, config={align = "cm", minw = 3.3, minh = 0.7, r = 0.1, colour = G.C.DYN_UI.BOSS_DARK}, nodes={
			{n=G.UIT.B, config={w=0.1,h=0.1}},
			{n=G.UIT.T, config={ref_table = G.GAME, ref_value = 'chips_damage', lang = G.LANGUAGES['en-us'], scale = 0.85, colour = G.C.WHITE, id = 'damage_UI_count', func = 'chip_UI_damage', shadow = true}}
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

	
    return {n=G.UIT.ROOT, config = {align = "cm", padding = 0.03, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
      {n=G.UIT.R, config = {align = "cm", padding= 0.05, colour = G.C.DYN_UI.MAIN, r=0.1}, nodes={
        {n=G.UIT.R, config={align = "cm", colour = G.C.DYN_UI.BOSS_DARK, r=0.1, minh = 30, padding = 0.08}, nodes={
          {n=G.UIT.R, config={align = "cm", minh = 0.3}, nodes={}},
          {n=G.UIT.R, config={align = "cm", id = 'row_blind', minw = 1, minh = 3.75}, nodes={}},
          contents.dollars_chips,
          contents.hand,
          {n=G.UIT.R, config={align = "cm", id = 'row_round'}, nodes={
            {n=G.UIT.C, config={align = "cm"}, nodes=contents.buttons},
            {n=G.UIT.C, config={align = "cm"}, nodes=contents.round}
          }},
        }}
      }}
    }}

	--]]

    --return {n=G.UIT.ROOT, config = {align = "cm", padding = 0.03, colour = G.C.UI.TRANSPARENT_DARK}, nodes={}}
end

function TCG_create_UIBox_HUD_blind()
	local scale = 0.4


	local blinds = { 
		chip_text = 'aaa',
		loc_name = 'Opponent'
	}


	return {n=G.UIT.ROOT, config={align = "cm", minw = 4.5, r = 0.1, colour = G.C.BLACK, emboss = 0.05, padding = 0.05, id = 'HUD_blind'}, nodes={
		{n=G.UIT.R, config={align = "cm", minh = 0, r = 0.0, emboss = 0, colour = G.C.UI.TRANSPARENT}, nodes={
			{n=G.UIT.R, config={align = "cm", minw = 3}, nodes={
				{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'dollars_to_be_earned'}}, colours = {G.C.MONEY}, rotate = true, bump = true, silent = true, scale = 0}),id = 'dollars_to_be_earned'}},
				{n=G.UIT.T, config={ref_table = blinds, ref_value = 'chip_text', scale = 0.0, colour = G.C.RED, id = 'HUD_blind_count' }},

				{n=G.UIT.R, config={align = "cm", id = 'HUD_blind_debuff'}, nodes={
					{n=G.UIT.O, config={object = DynaText({string = {{ref_table = blinds, ref_value = 'loc_name'}}, shadow = true, rotate = true, silent = true, float = true, scale = 1.6*scale, y_offset = -4}),id = 'HUD_blind_name'}},
				}},
				{n=G.UIT.R, config={align = "cm", id = 'HUD_blind_debuff'}, nodes={
					{n=G.UIT.O, config={object = DynaText({string = {{ref_table = BalatroTCG.Player.status, ref_value = 'opponent_health', prefix = localize('$')}}, maxw = 1.35, colours = {G.C.MONEY}, font = G.LANGUAGES['en-us'].font, shadow = true,spacing = 2, bump = true, scale = 2.2*scale}), id = 'dollar_text_opponent'}}
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

	MP.reset_lobby_config(true)

	-- Check if the current gamemode is valid. If it's not, default to attrition.
	MP.LOBBY.config.gamemode = "gamemode_mp_tcg"
	MP.LOBBY.config.the_order = false
	MP.LOBBY.config.preview_disabled = true
	MP.LOBBY.config.timer = false
	MP.LOBBY.config.disable_live_and_timer_hud = true

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
		t.nodes[1].nodes[2].nodes[2].nodes[3] = MP.UI.create_tcg_mp_button(0.45)
	end

	
	return t
end

function MP.UI.create_tcg_mp_button(text_scale)

	return UIBox_button({
		id = "lobby_choose_tcg_deck",
		button = "lobby_choose_tcg_deck",
		colour = G.C.PURPLE,
		minw = 2.15,
		minh = 1.35,
		label = { localize("b_tcgtab_select")},
		scale = text_scale * 1.2,
		col = true,
	})

end

