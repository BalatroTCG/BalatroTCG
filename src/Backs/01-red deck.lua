BalatroTCG.DeckData {
    key_override = 'b_red',
    icon_pos = {x = 0, y = 1},
    background = {
        main = HEX("FFFFFF"),
        tertiary = HEX("000000"),
        special = HEX("fe5f55"),

        contrast = 2,
    },
    ui = {
        main = HEX("fe5f55"),
        secondary = HEX("400d0f"),
    },
    get_params = function(self, default_params, full_list)
        default_params.discards = default_params.discards + 1
    end,
}