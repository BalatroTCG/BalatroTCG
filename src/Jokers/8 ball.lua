BalatroTCG.JokerMod {
    key_override = 'j_8_ball',
    
    calculate_context = function(self, context, balanced)

        if context.individual and context.cardarea == G.play and BalatroTCG.consumeable_slots_available() > 0 then

            if context.other_card:is_rank_joker(8) and (SMODS.pseudorandom_probability(self, '8ball', 1, self.ability.extra)) then

                local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
                
                if card then
                    if card.area then card.area:remove_card(card) end
                    
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
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
                end

            end
        end
    end,
    ai_calculate = function(self, context, balanced)

        if context.purchase == self then
            local rank = self.tcg_extra.rank or 8
            local card_vision = G.FUNCS.card_vision(round_stats, 0, 0)
            
            return {
                money_per_round = amount * self.ability.extra * card_vision / #context.full_deck
            }

        elseif context.in_hand then
            local rank = self.tcg_extra.rank or 8
            if context.other_card:is_rank_joker(rank) then
                
                return {
                    play = {
                        any = {
                            tarot_gen = G.GAME.probabilities.normal / self.ability.extra
                        }
                    }
                }
                
            end
        end
    end
}