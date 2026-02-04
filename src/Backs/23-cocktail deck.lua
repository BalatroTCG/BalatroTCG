BalatroTCG.DeckData {
    key_override = 'b_mp_cocktail',
    icon_pos = {x = 0, y = 23},
    background = {
        main = HEX("fec687"),
        special = HEX("c14139"),
        tertiary = HEX("121617"),

        contrast = 2,
    },
    ui = {
        main = HEX("c2889f"),
        secondary = HEX("244357"),
    },
    get_cost = function(full_list) return 5; end,
    get_params = function(self, default_params, full_list)
        local hasBlueDeck = false
        
        for k, v in ipairs(full_list) do
            if v == 'b_blue' then
                hasBlueDeck = true
                break
            end
        end

        if hasBlueDeck then
            default_params.discards = default_params.discards - 1
        else
            default_params.hands = default_params.hands - 1
        end
    end,
    get_limits = function(self, default_limits)
        default_limits.deck_count = 3
    end,
    calculate_context = function(context)
        if context.setting_blind and not context.cardarea then
            -- Fixes a crash I guess
        end
        G.GAME.modifiers.mp_cocktail = {}
    end
}