BalatroTCG.Ruleset({
	key = "ranked",
	standard = true,
	banned_jokers = {},
	banned_consumables = {},
	banned_vouchers = {},
	banned_enhancements = {},
	create_info_menu = function()
		return BalatroTCG.CreateRulesetInfoMenu({
			forced_lobby_options = true,
			description_key = "k_tcg_ranked_description",
		})
	end,
	forced_gamemode = "tcggamemode_tcgb_classic",
	forced_lobby_options = true,
	is_disabled = function(self)
		return false
	end,
	force_lobby_options = function(self)
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

		return true
	end,
}):inject()
