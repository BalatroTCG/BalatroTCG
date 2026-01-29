BalatroTCG.JokerMod {
    key_override = 'j_riff_raff',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra = 1
        end
    end,
    calculate_context = function(self, context, balanced)
        if not (context.blueprint_card or self).getting_sliced and BalatroTCG.joker_slots_available() > 0 then

            local jokers_to_create = math.min(self.ability.extra, BalatroTCG.joker_slots_available())
            
            for i = 1, jokers_to_create do
            
                local card = pick_from_areas(function (c) return c.ability.set == 'Joker' and c.config.center.rarity == 1 end, {G.deck, G.discard})
                
                if card then
                    G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        card.area:remove_card(card)
                        card:start_materialize()
                        G.jokers:emplace(card)

                        for _, c in ipairs(G.playing_cards) do
                            if c == card then
                                goto skip
                            end
                        end
                        table.insert(G.playing_cards, card)
                        ::skip::
                        G.GAME.joker_buffer = 0
                        play_sound('timpani')
                        self:juice_up(0.3, 0.5)
                        return true
                    end
                    }))
                end
            end
            delay(0.6)
        end
    end,
}