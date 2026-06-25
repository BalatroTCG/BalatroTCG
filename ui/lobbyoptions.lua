local function create_main_lobby_options_title(info_area_id)
	local title_colour = mix_colours(G.C.RED, G.C.BLACK, 0.6)
	local title = "ERROR"

	if info_area_id == "ruleset_area" then
		title_colour = mix_colours(G.C.BLUE, G.C.BLACK, 0.6)
		title = localize("k_rulesets")
	end

	if info_area_id == "gamemode_area" then
		title_colour = mix_colours(G.C.ORANGE, G.C.BLACK, 0.6)
		title = localize("k_gamemodes")
	end

	if title == "ERROR" then return nil end

	return {
		n = G.UIT.R,
		config = { id = "ruleset_name", align = "cm", padding = 0.07 },
		nodes = {
			{
				n = G.UIT.R,
				config = {
					align = "cm",
					r = 0.1,
					outline = 1,
					outline_colour = title_colour,
					colour = darken(title_colour, 0.3),
					minw = 2.9,
					emboss = 0.1,
					padding = 0.07,
					line_emboss = 1,
				},
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = DynaText({
								string = title,
								colours = { G.C.WHITE },
								shadow = true,
								float = true,
								y_offset = -4,
								scale = 0.45,
								maxw = 2.8,
							}),
						},
					},
				},
			},
		},
	}
end

function BalatroTCG.Main_Lobby_Options(info_area_id, default_info_area, button_func, buttons_data)
	local categories = {
		create_main_lobby_options_title(info_area_id),
	}
	for cat_idx, category in ipairs(buttons_data) do
		local buttons = {}
		for btn_idx, data in ipairs(category.buttons) do
			local col = data.button_col or G.C.RED

			local button = UIBox_button({
				id = data.button_id,
				col = true,
				chosen = (cat_idx == 1 and btn_idx == 1 and "vert" or false),
				label = { localize(data.button_localize_key) },
				button = button_func,
				colour = col,
				minw = 4,
				scale = 0.4,
				minh = 0.6,
			})
			buttons[#buttons + 1] = { n = G.UIT.R, config = { align = "cm", padding = 0.05 }, nodes = { button } }
		end
		categories[#categories + 1] = MP.UI.BackgroundGrouping(localize(category.name), buttons)
	end

	return create_UIBox_generic_options({
		back_func = "play_options",
		contents = {
			{ n = G.UIT.C, config = { align = "tm", minh = 8, minw = 4, padding = 0.1 }, nodes = categories },
			{
				n = G.UIT.C,
				config = { align = "cm", minh = 8, maxh = 8, minw = 11 },
				nodes = {
					{ n = G.UIT.O, config = { id = info_area_id, object = default_info_area } },
				},
			},
		},
	})
end

function G.UIDEF.tcg_selection_options()

	MP.LOBBY.config.gamemode = "gamemode_mp_tcg_classic"
	MP.LOBBY.config.ruleset = 'tcgruleset_tcgb_ranked'
	

	local default_ruleset_area = UIBox({
		definition = G.UIDEF.tcgruleset_info("ranked"),
		config = { align = "cm" },
	})

	local ruleset_buttons_data = {
		{
			name = "k_competitive",
			buttons = {
				{ button_id = "ranked_ruleset_button", button_localize_key = "k_tcg_ranked" },
				{ button_id = "majorleague_ruleset_button", button_localize_key = "k_tcg_majorleague" },
			},
		},
		{
			name = "k_standard",
			buttons = {
				{ button_id = "standard_ruleset_button", button_localize_key = "k_tcg_standard" },
			},
		},
	}

	return BalatroTCG.Main_Lobby_Options(
		"ruleset_area",
		default_ruleset_area,
		"change_tcgruleset_selection",
		ruleset_buttons_data
	)
end

function G.FUNCS.change_tcgruleset_selection(e)
    
	MP.UI.Change_Main_Lobby_Options(
		e,
		"ruleset_area",
		G.UIDEF.tcgruleset_info,
		"ranked_ruleset_button",
		function(ruleset_name)
			MP.LOBBY.config.ruleset = "tcgruleset_tcgb_" .. ruleset_name
		end
	)

	MP.LOBBY.ruleset_preview = false
end

function BalatroTCG.Change_Main_Lobby_Options(e, info_area_id, info_area_func, default_button_id, update_lobby_config_func)
	if not G.OVERLAY_MENU then return end

	local info_area = G.OVERLAY_MENU:get_UIE_by_ID(info_area_id)
	if not info_area then return end

	-- Switch 'chosen' status from the previously-chosen button to this one:
	if info_area.config.prev_chosen then
		info_area.config.prev_chosen.config.chosen = nil
	else -- The previously-chosen button should be the default one here:
		local default_button = G.OVERLAY_MENU:get_UIE_by_ID(default_button_id)
		if default_button then default_button.config.chosen = nil end
	end
	e.config.chosen = "vert" -- Special setting to show 'chosen' indicator on the side

	local info_obj_name = string.match(e.config.id, "([^_]+)")

	update_lobby_config_func(info_obj_name)

	if info_area.config.object then info_area.config.object:remove() end
	info_area.config.object = UIBox({
		definition = info_area_func(info_obj_name),
		config = { align = "cm", parent = info_area },
	})

	info_area.config.object:recalculate()

	info_area.config.prev_chosen = e
end

function G.FUNCS.create_tcg_lobby(e)
	
	G.SETTINGS.paused = true

	G.FUNCS.overlay_menu({
		definition = G.UIDEF.tcg_selection_options(),
	})
end

function G.UIDEF.tcgruleset_info(ruleset_name)

	local ruleset = BalatroTCG.Rulesets["tcgruleset_tcgb_" .. ruleset_name]

	local ruleset_info_banned_rework_tabs = UIBox({
		definition = G.UIDEF.tcgruleset_tabs(ruleset),
		config = { align = "cm" },
	})

	local ruleset_disabled = ruleset.is_disabled()

	return {
		n = G.UIT.ROOT,
		config = { align = "tm", minh = 8, maxh = 8, minw = 11, maxw = 11, colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "tm", padding = 0.2, r = 0.1, colour = G.C.BLACK },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{ n = G.UIT.O, config = { object = ruleset_info_banned_rework_tabs } },
						},
					},
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							MP.UI.Disableable_Button({
								id = "select_gamemode_button",
								button = "start_tcg_lobby",
								align = "cm",
								padding = 0.05,
								r = 0.1,
								minw = 8,
								minh = 0.8,
								colour = G.C.BLUE,
								hover = true,
								shadow = true,
								label = { localize("b_create_lobby") },
								scale = 0.5,
								enabled_ref_table = { val = not ruleset_disabled },
								enabled_ref_value = "val",
								disabled_text = { ruleset_disabled },
							}),
						},
					},
				},
			},
		},
	}
end

function G.UIDEF.tcgruleset_tabs(ruleset)
	local default_tabs = UIBox({
		definition = G.UIDEF.lobby_setup_tcgtabs_definition(ruleset, "info", 1, true),
		config = { align = "cm", tab_type = "info", chosen_tab = 1 },
	})

	return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.L_BLACK, r = 0.1 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "tm", colour = G.C.GREY, r = 0.1 },
						nodes = {
							{ n = G.UIT.O, config = { object = default_tabs } },
						},
					},
					{
						n = G.UIT.R,
						config = { align = "bm", padding = 0.05 },
						nodes = {
							create_option_cycle({
								options = { localize("k_info") },
								current_option = 1,
								opt_callback = "tcgruleset_switch_tabs",
								opt_args = { ui = default_tabs, ruleset = ruleset },
								w = 5,
								colour = G.C.RED,
								cycle_shoulders = false,
							}),
						},
					},
				},
			},
		},
	}
end

function G.FUNCS.tcgruleset_switch_tabs(args)
	if not args or not args.cycle_config then return end
	local callback_args = args.cycle_config.opt_args

	local tabs_object = callback_args.ui
	local tabs_wrap = tabs_object.parent

	local active_tab = tabs_wrap.UIBox:get_UIE_by_ID("ruleset_active_tab")
	local active_tab_idx = active_tab and active_tab.config.tab_idx or 1

	local tab_type = (args.to_key == 2 and "banned") or (args.to_key == 3 and "rework") or "info"
	local def = nil

	if tab_type == "banned" then
		def = G.UIDEF.lobby_setup_tcgtabs_definition(callback_args.ruleset, "banned", active_tab_idx, true)
		tabs_object.config.tab_type = "banned"
		MP.LOBBY.config.ruleset = callback_args.ruleset.key
		MP.LOBBY.ruleset_preview = false
	elseif tab_type == "rework" then
		def = G.UIDEF.lobby_setup_tcgtabs_definition(callback_args.ruleset, "rework", active_tab_idx, true)
		tabs_object.config.tab_type = "rework"
		MP.LOBBY.config.ruleset = callback_args.ruleset.key
		MP.LOBBY.ruleset_preview = true
	else
		def = G.UIDEF.lobby_setup_tcgtabs_definition(callback_args.ruleset, "info", active_tab_idx, true)
		tabs_object.config.tab_type = "info"
		MP.LOBBY.config.ruleset = callback_args.ruleset.key
		MP.LOBBY.ruleset_preview = false
	end

	tabs_wrap.config.object:remove()
	tabs_wrap.config.object = UIBox({
		definition = def,
		config = { align = "cm", parent = tabs_wrap },
	})

	tabs_wrap.UIBox:recalculate()
end

function G.UIDEF.lobby_setup_tcgtabs_definition(ruleset_or_gamemode, tab_type, chosen_tab_idx, is_ruleset)
	-- if tab_type == "banned" or tab_type == "rework" then
	-- 	return create_bans_and_reworks_tabs(ruleset_or_gamemode, tab_type == "banned", chosen_tab_idx)
	-- end

	local tab_id = ruleset_or_gamemode.key:find("ruleset") and "ruleset_active_tab" or "gamemode_active_tab"

	return {
		n = G.UIT.ROOT,
		config = { id = tab_id, align = "cm", colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "tm", padding = 0.2, r = 0.1, minw = 10.7, maxw = 10.7, minh = 5.75, maxh = 5.75 },
				nodes = ruleset_or_gamemode.create_info_menu(),
			},
		},
	}
end

function BalatroTCG.CreateRulesetInfoMenu(config)
	local forces_lobby = config.forced_lobby_options and "k_yes" or "k_no"
	local forces_lobby_color = config.forced_lobby_options and G.C.GREEN or G.C.RED

	return {
		{
			n = G.UIT.R,
			config = {
				align = "tm",
			},
			nodes = {
				MP.UI.BackgroundGrouping(localize("k_forces_lobby_options"), {
					{
						n = G.UIT.T,
						config = {
							text = localize(forces_lobby),
							scale = 0.8,
							colour = forces_lobby_color,
						},
					},
				}, { col = true, text_scale = 0.6 }),
			},
		},
		{
			n = G.UIT.R,
			config = {
				minw = 0.05,
				minh = 0.05,
			},
		},
		{
			n = G.UIT.R,
			config = {
				align = "cl",
				padding = 0.1,
			},
			nodes = {
				{
					n = G.UIT.T,
					config = {
						text = localize(config.description_key),
						scale = 0.6,
						colour = G.C.UI.TEXT_LIGHT,
					},
				},
			},
		},
	}
end

function G.FUNCS.start_tcg_lobby(e)
	
	G.SETTINGS.paused = false
	
	MP.reset_lobby_config(true)

	
	
	-- Check if the current gamemode is valid. If it's not, default to attrition.
	local gamemode_check = false
	for k, _ in pairs(MP.Gamemodes) do
		if k == MP.LOBBY.config.gamemode then gamemode_check = true end
	end
	MP.LOBBY.config.gamemode = gamemode_check and MP.LOBBY.config.gamemode or "gamemode_mp_attrition"

	local ruleset_check = false
	for k, _ in pairs(BalatroTCG.Rulesets) do
		if k == MP.LOBBY.config.ruleset then ruleset_check = true end
	end
	
	MP.LOBBY.config.ruleset = ruleset_check and MP.LOBBY.config.ruleset or "tcgruleset_tcgb_classic"

	MP.LOBBY.config.preview_disabled = true
	MP.LOBBY.config.the_order = false
	MP.LOBBY.config.timer = false
	MP.LOBBY.config.disable_live_and_timer_hud = true

	MP.LOBBY.config.forced_config = BalatroTCG.Rulesets[MP.LOBBY.config.ruleset].force_lobby_options()
    

	reset_tcg_settings()
	

	MP.ACTIONS.create_lobby(string.sub(MP.LOBBY.config.gamemode, 13))
	G.FUNCS.exit_overlay_menu()
end