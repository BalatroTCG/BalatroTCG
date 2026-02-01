BalatroTCG.DeckData {
    key_override = 'b_green',
    icon_pos = {x = 0, y = 4},
    background = {
        main = HEX("FFFFFF"),
        special = HEX("56a786"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("56a786"),
        secondary = HEX("094021"),
    },
    calculate_context = function(context)
        if not context.cardarea and not context.repetition and not context.individual and context.end_of_round and G.GAME.current_round.discards_left > 0 then
            ease_dollars(G.GAME.current_round.discards_left * 2)
        end
    end
}