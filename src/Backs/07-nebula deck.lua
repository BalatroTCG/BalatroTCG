BalatroTCG.DeckData {
    key_override = 'b_nebula',
    icon_pos = {x = 0, y = 7},
    background = {
        special = HEX("6696a4"),
        tertiary = HEX("66749c"),
        main = HEX("3e1976"),

        contrast = 0.8,
    },
    ui = {
        main = HEX("6696a4"),
        secondary = HEX("3a314d"),
    },
    bg_particles = {
        {
            timer = 0.07,
            scale = 0.1,
            lifespan = 15,
            speed = 0.1,
            padding = -4,
            colours = {G.C.WHITE, HEX('a7d6e0'), HEX('fddca0')},
            fill = true
        },
        {
            timer = 2,
            scale = 0.05,
            lifespan = 1.5,
            speed = 4,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE},
            fill = true
        }
    },
    get_params = function(self, default_params, full_list)
        default_params.starting_vouchers = {
            "v_telescope",
        }
    end,
    get_limits = function(self, default_limits)
        default_limits.planet_copies = 1
    end,
}