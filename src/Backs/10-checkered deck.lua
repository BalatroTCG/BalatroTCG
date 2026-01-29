BalatroTCG.DeckData {
    key_override = 'b_checkered',
    icon_pos = {x = 0, y = 10},
    background = {
        main = HEX("000000"),
        special = HEX("fe5f55"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("fe5f55"),
        secondary = HEX("002035"),
    },
    bg_particles = {
        {
            timer = 0.015,
            scale = 0.3,
            lifespan = 3,
            speed = 0.2,
            padding = -1,
            colours = {G.C.BLACK, G.C.RED},
            fill = true
        }
    },
    get_cost = function(self) return 5; end,
    get_limits = function(self, default_limits)
        default_limits.checkered_suits = true
        default_limits.suit_copies = 1
    end,
}