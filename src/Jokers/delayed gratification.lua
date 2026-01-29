BalatroTCG.JokerMod {
    key_override = 'j_delayed_grat',
    
    modify = function(self, balanced)
        if balanced then
            self.eternal_compat = false
        end
    end,
    calculate_context = function(self, context, balanced)

        if not context.repetition and not context.individual and context.end_of_round and G.GAME.current_round.discards_used == 0 and G.GAME.current_round.discards_left > 0 then
            local money = G.GAME.current_round.discards_left * self.ability.extra
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money
            G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
            
            return {
                dollars = money,
                card = self
            }
        end
    end,
}