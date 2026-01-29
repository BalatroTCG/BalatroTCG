BalatroTCG.DeckData {
    key_override = 'b_yellow',
    icon_pos = {x = 0, y = 3},
    background = {
        main = HEX("FFFFFF"),
        special = HEX("fda200"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("fda200"),
        secondary = HEX("402c09"),
    },
    get_cost = function(self) return 5; end,
    get_params = function(self, default_params, full_list)
        default_params.dollars = default_params.dollars + 25
    end,
}