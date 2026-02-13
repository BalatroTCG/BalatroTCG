
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

function create_tcg_builder(type, callback)
	BalatroTCG.BuildingDeck = BalatroTCG.BuildingDeck or BalatroTCG.TabDecks[BalatroTCG.DeckIndex]

	reset_tcg_settings()

    BalatroTCG.UseTCG_UI = true
    G.GAME = G:init_game_object()

	local deck_tables = {}
	local buildDeck = {}
	
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
			{n=G.UIT.C, config={align = "cm", padding = 1.5}, nodes={}},
			{n=G.UIT.C, config={align = "cm"}, nodes = {
                UIBox_button({
                    label = { localize("b_tcg_copydeck") },
                    colour = G.C.PURPLE,
                    button = "tcg_copy_deck",
                    scale = 0.4,
                    minw = 3,
                    minh = 0.6,
                }),
				{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={}},
                UIBox_button({
                    label = { localize("b_tcg_pastedeck") },
                    colour = G.C.RED,
                    button = "tcg_paste_deck",
                    scale = 0.4,
                    minw = 3,
                    minh = 0.6,
                })
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


local function get_from_clipboard()
	if G.F_LOCAL_CLIPBOARD then
		return G.F_LOCAL_CLIPBOARD
	else
		return love.system.getClipboardText()
	end
end
local function copy_to_clipboard(text)
	if G.F_LOCAL_CLIPBOARD then
		G.CLIPBOARD = text
	else
		love.system.setClipboardText(text)
	end
end

G.FUNCS.tcg_copy_deck = function(e)
    copy_to_clipboard(BalatroTCG.BuildingDeck:serialize(true))
end
G.FUNCS.tcg_paste_deck = function(e)
    local deck = get_from_clipboard()
    
    if pcall(function() BalatroTCG.Deck.deserialize(deck, BalatroTCG.BuildingDeck) end) then
        refresh_builder_page()
    else
        print('Unable to copy deck')
    end

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

local Controller_update_cursor_ref = Controller.update_cursor

function Controller:update_cursor(hard_set_T)

	Controller_update_cursor_ref(self, hard_set_T)
    if self.focused.target then 
		
	end
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
