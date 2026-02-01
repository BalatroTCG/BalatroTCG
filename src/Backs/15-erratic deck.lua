BalatroTCG.DeckData {
    key_override = 'b_erratic',
    icon_pos = {x = 0, y = 15},
    background = {
        main = HEX("bee9ee"),
        special = HEX("4f6367"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("718e93"),
        secondary = HEX("470b08"),
    },
    bg_particles = {
        {
            timer = 0.015,
            scale = 0.15,
            lifespan = 2,
            speed = 3,
            padding = -1,
            colours = {G.C.RED, G.C.GOLD, G.C.BLUE},
            fill = true
        }
    },
    get_limits = function(self, default_limits)
        default_limits.playing_card_copies = 5
    end,
}