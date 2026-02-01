BalatroTCG.JokerMod {
    key_override = 'j_golden',
    
    modify = function(self, balanced)
        if balanced then self.eternal_compat = false end
    end,
    calculate_context = function(self, context, balanced)
        if context.tcg_take_damage and not context.blueprint then
            return {
                reduce = self.ability.extra
            }
        end
    end,
}