BalatroTCG.DeckData {
    key_override = 'b_abandoned',
    icon_pos = {x = 0, y = 9},
    background = {
        main = HEX("faf0dc"),
        special = HEX("da9a81"),
        tertiary = HEX("322019"),

        contrast = 2,
    },
    ui = {
        main = HEX("da9a81"),
        secondary = HEX("322019"),
    },
    get_cost = function(self) return 5; end,
    get_limits = function(self, default_limits)
        default_limits.no_faces = true
        default_limits.deck_size = 50
    end,
}