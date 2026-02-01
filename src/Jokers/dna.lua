BalatroTCG.JokerMod {
    key_override = 'j_dna',
    
    description_override = {
        balanced = true,
        none = false,
    },
    
    calculate_context = function(self, context, balanced)
        if context.before and #context.full_hand == 1 and context.full_hand[1]:is_playing_card() and (balanced or G.GAME.current_round.hands_played == 0) then
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local _card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
            _card:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, _card)
            if not balanced then
                G.hand:emplace(_card)
                _card.states.visible = nil

                G.E_MANAGER:add_event(Event({
                    func = function()
                        _card:start_materialize()
                        return true
                    end
                })) 
            else
                G.discard:emplace(_card)
            end
            return {
                message = localize('k_copied_ex'),
                colour = G.C.CHIPS,
                card = self,
                playing_cards_created = {_card}
            }
        end
    end,
}