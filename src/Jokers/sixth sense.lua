BalatroTCG.JokerMod {
    key_override = 'j_sixth_sense',
    
    calculate_context = function(self, context, balanced)
        
        if context.destroying_card and not context.blueprint and #context.full_hand == 1 and context.full_hand[1]:is_rank_joker(6) and G.GAME.current_round.hands_played == 0 then
            
            if BalatroTCG.consumeable_slots_available() > 0 then
                    
                local card = pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard})
                
                if card then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    if card.area then card.area:remove_card(card) end
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        card:start_materialize()
                        G.consumeables:emplace(card)
                        
                        for _, c in ipairs(G.playing_cards) do
                            if c == card then
                                goto skip
                            end
                        end
                        table.insert(G.playing_cards, card)
                        ::skip::

                        G.GAME.consumeable_buffer = 0
                        play_sound('timpani')
                        self:juice_up(0.3, 0.5)
                        return true
                    end
                    }))
                    card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
                    delay(0.6)
                end
            end

            return true
        end
        
    end
}