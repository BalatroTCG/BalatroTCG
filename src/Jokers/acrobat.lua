BalatroTCG.JokerMod {
    key_override = 'j_acrobat',
    
    modify = function(self, balanced)
        self.config.scaling = 0.25
        self.config.initial = 1
    end,
    calculate_context = function(self, context, balanced)
        if context.joker_main and (BalatroTCG.Status_Current.status.round - 1) > 0 then
            local xmult = (BalatroTCG.Status_Current.status.round - 1) * self.ability.scaling + self.ability.initial
            return {
                message = localize{type='variable',key='a_xmult',vars={xmult}},
                Xmult_mod = xmult,
            }
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            
            local finalScore = (status.current_round + context.rounds_left / 2)

            return {
                hand = { any = {
                    x_mult = finalScore * self.ability.scaling,
                }}
            } 
        end
    end,
}