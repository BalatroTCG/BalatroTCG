BalatroTCG.ConsumeableMod {
    key_override = 'c_death',
    
    modify = function(self, balanced)
        
    end,
    use_consumeable = function(self, area, copier, balanced, original_func)
        
        if G.GAME.last_tarot_planet == 'c_fool' then return end

        local center = G.P_CENTERS[G.GAME.last_tarot_planet]

        local card = pick_from_areas(function (c) return c.ability.name == center.name end, {G.deck, G.discard, G.graveyard, G.hand})
        
        if card then
            if card.area then card.area:remove_card(card) end
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
                self:juice_up(0.3, 0.5)
                return true
            end
            }))
            delay(0.6)
        end
    end
}