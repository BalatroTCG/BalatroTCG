BalatroTCG.DeckData {
    key_override = 'b_mp_oracle',
    icon_pos = {x = 0, y = 20},
    background = {
        main = HEX("c6d1c5"),
        special = HEX("c29032"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("c29032"),
        secondary = HEX("222d40"),
    },
    get_params = function(self, default_params, full_list)
        default_params.starting_vouchers = {
            "v_clearance_sale",
        }
        default_params.dollars = default_params.dollars * 0.90
        default_params.max_budget = default_params.dollars
    end,
}