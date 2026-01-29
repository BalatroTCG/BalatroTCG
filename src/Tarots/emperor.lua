BalatroTCG.ConsumeableMod {
    key_override = 'c_emperor',
    
    modify = function(self, balanced)
        
    end,
    use_consumeable = function(card, area, copier, balanced, original_func)

        for i = 1, math.min(card.ability.consumeable.tarots, BalatroTCG.consumeable_slots_available()) do
            local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard, G.hand})

            if card then
                card.area:remove_card(card)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    card:start_materialize()
                    G.consumeables:emplace(card)

                    for _, c in ipairs(G.playing_cards) do
                        if c == card then
                            goto skip
                        end
                    end
                    card:add_to_deck()
                    table.insert(G.playing_cards, card)
                    ::skip::
                    play_sound('timpani')
                    card:juice_up(0.3, 0.5)
                    return true
                end
                }))
            end
        end
        delay(0.6)
    end
}