G.P_CENTER_POOLS.TCG_Ruleset = {}
BalatroTCG.Rulesets = {}
BalatroTCG.Ruleset = SMODS.GameObject:extend({
	obj_table = {},
	obj_buffer = {},
	required_params = {
		"key",
		"banned_jokers",
		"banned_consumables",
		"banned_vouchers",
		"banned_enhancements",
		"create_info_menu",
	},
	class_prefix = "tcgruleset",
	inject = function(self)
		BalatroTCG.Rulesets[self.key] = self
		if not G.P_CENTER_POOLS.TCG_Ruleset then G.P_CENTER_POOLS.TCG_Ruleset = {} end
		table.insert(G.P_CENTER_POOLS.TCG_Ruleset, self)
	end,
	process_loc_text = function(self)
		SMODS.process_loc_text(G.localization.descriptions["TCG_Ruleset"], self.key, self.loc_txt)
	end,
	is_disabled = function(self)
		return false
	end,
	force_lobby_options = function(self)
		return false
	end,
})