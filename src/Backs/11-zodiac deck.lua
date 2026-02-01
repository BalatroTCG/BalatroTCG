BalatroTCG.DeckData {
    key_override = 'b_zodiac',
    icon_pos = {x = 0, y = 11},
    background = {
        main = HEX("dec651"),
        special = HEX("534e79"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("534e79"),
        secondary = HEX("402c09"),
    },
    get_params = function(self, default_params, full_list)
        default_params.starting_vouchers = {
            "v_planet_merchant",
            "v_tarot_merchant",
        }
    end,
}