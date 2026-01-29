BalatroTCG.JokerMod {
    key_override = 'j_bootstraps',
    
    modify = function(self, balanced)
        if balanced then self.config.extra.mult = 1 end
    end,
    calculate_context = function(self, context, balanced)
        if context.joker_main then
            local money = (G.GAME.dollars + (G.GAME.dollar_buffer or 0)) + BalatroTCG.Status_Current.status.opponent_health
            return {
                message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult * math.floor(money)}},
                mult_mod = self.ability.extra.mult * math.floor(money)
            }
        end
    end,
}