BalatroTCG.JokerMod {
    key_override = 'j_acrobat',
    
    modify = function(self, balanced)
        self.config.scaling = 0.25
        self.config.initial = 1
    end,
    calculate_context = function(self, context, balanced)
        if  context.joker_main and (BalatroTCG.Status_Current.status.round - 1) > 0 then
            local xmult = (BalatroTCG.Status_Current.status.round - 1) * self.ability.scaling + self.ability.initial
            return {
                message = localize{type='variable',key='a_xmult',vars={xmult}},
                Xmult_mod = xmult,
            }
        end
    end,
}