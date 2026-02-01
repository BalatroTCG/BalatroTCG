BalatroTCG.JokerMod {
    key_override = 'j_to_the_moon',
    
    modify = function(self, balanced)
        if balanced then self.eternal_compat = false end
        self.blueprint_compat = true
    end,
    calculate_context = function(self, context, balanced)
        if not context.repetition and not context.individual and context.end_of_round then
            local money = math.min(math.floor(BalatroTCG.Status_Current.status.dollars / 5), 5)
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money

            G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
            
            return {
                dollars = money,
                card = self
            }
        end
        
    end
}