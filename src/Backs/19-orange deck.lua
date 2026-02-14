BalatroTCG.DeckData {
    key_override = 'b_mp_orange',
    icon_pos = {x = 0, y = 19},
    background = {
        main = HEX("FFFFFF"),
        special = HEX("fc802b"),
        tertiary = HEX("000000"),

        contrast = 2,
    },
    ui = {
        main = HEX("fc802b"),
        secondary = HEX("422d1e"),
    },
    calculate_context = function(context)
        if context.discard and context.other_card:is_playing_card() and BalatroTCG.Status_Current.status.round == 1 then
            if context.other_card.use_button then
                context.other_card.use_button:remove()
                context.other_card.use_button = nil
            end
            return {
                delay = 0.45,
                remove = true,
                card = G.deck.cards[1],
            }
        end
    end
}