BalatroTCG.DeckData {
    key_override = 'b_painted',
    icon_pos = {x = 0, y = 12},
    background = {
        main = HEX("8c2922"),
        special = HEX("4a1a54"),
        tertiary = HEX("ffd62b"),

        contrast = 2,
    },
    ui = {
        main = HEX("e290f2"),
        secondary = HEX("114831"),
    },
    get_params = function(self, default_params, full_list)
        default_params.hand_size = default_params.hand_size + 2
        default_params.joker_slots = default_params.joker_slots - 1
    end,
}