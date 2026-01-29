BalatroTCG.DeckData {
    key_override = 'b_anaglyph',
    icon_pos = {x = 0, y = 13},
    background = {
        main = HEX("045d94"),
        special = HEX("5c1b16"),
        tertiary = HEX("FFFFFF"),

        contrast = 2,
    },
    ui = {
        main = HEX("fe5f55"),
        secondary = HEX("094c8f"),
    },
    calculate_context = function(context)
        if context.setting_blind and not context.cardarea and math.fmod(context.status.status.round, 3) == 0 then
            ease_hands_played(1)
            ease_discard(1)
        end
    end
}