BalatroTCG.JokerMod {
    key_override = 'j_vagabond',
    
    modify = function(self, balanced)
        if balanced then
            self.eternal_compat = false
            self.config.extra = 15
        end
    end,
    calculate_context = function(self, context, balanced)
        if context.cardarea == G.jokers and context.joker_main then
            
            if G.GAME.dollars <= self.ability.extra and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                
                local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
                
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
                    delay(0.6)
                    return {
                        message = localize('k_plus_tarot'),
                        card = self
                    }
                end

            end
        end
    end
}