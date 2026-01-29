BalatroTCG.DeckData {
    key_override = 'b_challenge',
    icon_pos = {x = 0, y = 16},
    background = {
        main = HEX("FFFFFF"),
        special = HEX("c75985"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("db6596"),
        secondary = HEX("6b3246"),
    },
    get_cost = function(self) return 5; end,
    get_params = function(self, default_params, full_list)
        default_params.destroy_planets = false
        default_params.destroy_tarots = false
        default_params.destroy_spectrals = false
        default_params.joker_slots = 0
    end,
    get_limits = function(self, default_limits)
        default_limits.max_consumables = 30
        default_limits.max_tarots = 30
        default_limits.max_planets = 30
        default_limits.max_spectrals = 30
        default_limits.max_vouchers = 30
    end,
}