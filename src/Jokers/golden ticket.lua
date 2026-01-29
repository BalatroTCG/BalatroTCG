BalatroTCG.JokerMod {
    key_override = 'j_ticket',
    
    modify = function(self, balanced)
        if balanced then
            self.eternal_compat = false
            self.config.extra = 1
        end
    end,
    calculate_context = function(self, context, balanced)
        
        if not balanced and context.individual and context.cardarea == G.play then

            if context.other_card.ability.name == 'Gold Card' then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return {
                    dollars = self.ability.extra,
                    card = self
                }
            end
        elseif balanced and context.individual and not context.end_of_round and context.cardarea == G.hand and context.other_card.ability.name == 'Gold Card' then

            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
            G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
            return {
                dollars = self.ability.extra,
                card = self
            }
        end
    end,
}