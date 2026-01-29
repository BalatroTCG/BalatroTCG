BalatroTCG.JokerMod {
    key_override = 'j_business',
    
    modify = function(self, balanced)
        if balanced then self.eternal_compat = false end
        self.config.money = 2
    end,
    calculate_context = function(self, context, balanced)

        if context.individual and context.cardarea == G.play then
            if context.other_card:is_face() and pseudorandom('business') < G.GAME.probabilities.normal/self.ability.extra then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.money
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return {
                    dollars = self.ability.money,
                    card = self
                }
            end
        end
    end,
    ai_calculate = function(self, context, balanced)
        if context.purchase == self then
            local amount = G.FUNCS.get_card_amount(context.full_deck, function(e) return e:is_face() == rank end) * G.FUNCS.card_vision(context.round_stats, 0, 0) / #context.full_deck

            return {
                money_per_round = amount * self.ability.money * G.GAME.probabilities.normal / self.ability.extra
            }
        end
    end
}