BalatroTCG.DeckData {
    key_override = 'b_mp_indigo',
    icon_pos = {x = 0, y = 18},
    background = {
        main = HEX("FFFFFF"),
        special = HEX("6749a4"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("6749a4"),
        secondary = HEX("3b234d"),
    },
    get_limits = function(self, default_limits)
        default_limits.deck_size = 70
        default_limits.tarot_copies = 1
        default_limits.planet_copies = 1
        default_limits.spectral_copies = 1
        default_limits.joker_copies = 1
        default_limits.voucher_copies = 1
    end,
}