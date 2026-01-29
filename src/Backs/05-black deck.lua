BalatroTCG.DeckData {
    key_override = 'b_black',
    icon_pos = {x = 0, y = 5},
    background = {
        main = HEX("bee9ee"),
        special = HEX("4f6367"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("4f6367"),
        secondary = HEX("221c2e"),
    },
    get_params = function(self, default_params, full_list)
        default_params.joker_slots = default_params.joker_slots + 1
        default_params.hand_size = default_params.hand_size - 1
    end,
}