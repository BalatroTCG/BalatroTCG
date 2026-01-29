BalatroTCG.DeckData {
    key_override = 'b_mp_violet',
    icon_pos = {x = 0, y = 17},
    background = {
        main = HEX("FFFFFF"),
        special = HEX("a763d8"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("a763d8"),
        secondary = HEX("3b234d"),
    },
    get_limits = function(self, default_limits)
        default_limits.max_vouchers = default_limits.max_vouchers + 4
    end,
}