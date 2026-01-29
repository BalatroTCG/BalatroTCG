BalatroTCG.DeckData {
    key_override = 'b_mp_heidelberg',
    icon_pos = {x = 0, y = 22},
    background = {
        main = HEX("c6dfdd"),
        special = HEX("88beb0"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("88beb0"),
        secondary = HEX("2c484a"),
    },
    get_limits = function(self, default_limits)
        default_limits.max_rares = 2
        default_limits.max_uncommons = 0
    end,
}