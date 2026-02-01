BalatroTCG.DeckData {
    key_override = 'b_blue',
    icon_pos = {x = 0, y = 2},
    background = {
        main = HEX("FFFFFF"),
        special = HEX("009cfd"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("009cfd"),
        secondary = HEX("111540"),
    },
    get_cost = function(full_list) return 5; end,
    get_params = function(self, default_params, full_list)
        default_params.hands = default_params.hands + 1
    end,
}