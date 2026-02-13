BalatroTCG.Ruleset({
	key = "standard",
	standard = true,
	banned_jokers = {},
	banned_consumables = {},
	banned_vouchers = {},
	banned_enhancements = {},
	create_info_menu = function()
		return BalatroTCG.CreateRulesetInfoMenu({
			forced_lobby_options = false,
			description_key = "k_tcg_standard_description",
		})
	end,
	forced_gamemode = "tcggamemode_tcgb_classic",
	forced_lobby_options = true,
	is_disabled = function(self)
		return false
	end,
	force_lobby_options = function(self)
		return false
	end,
}):inject()
