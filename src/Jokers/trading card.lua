BalatroTCG.JokerMod {
    key_override = 'j_trading',
    
    calculate_context = function(self, context, balanced)
        if context.discard and not context.blueprint and G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
            if not balanced then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.money
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                ease_dollars(self.ability.extra)
            end
            return {
                delay = 0.45, 
                remove = true,
                card = self
            }
        end
    end,
}