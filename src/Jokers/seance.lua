BalatroTCG.JokerMod {
    key_override = 'j_seance',
    
    calculate_context = function(self, context, balanced)
        if context.joker_main and BalatroTCG.consumeable_slots_available() > 0 then
            if next(context.poker_hands[self.ability.extra.poker_hand]) then
                local card = pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard})
                if card then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        
                        if card.area then card.area:remove_card(card) end
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
                    delay(0.6)
                    return {
                        message = localize('k_plus_spectral'),
                        colour = G.C.SECONDARY_SET.Spectral,
                        card = self
                    }
                end
            end
        end
    end,
}