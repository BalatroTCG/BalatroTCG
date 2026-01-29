BalatroTCG.JokerMod {
    key_override = 'j_mr_bones',
    
    modify = function(self, balanced)
        if balanced then self.eternal_compat = false 
        else center.eternal_compat = true end
        self.config.extra = 25
    end,
    calculate_context = function(self, context, balanced)
        if context.tcg_take_damage and not context.blueprint then
            return {
                percent = (self.ability.extra) / 100.0
            }
        end
    end,
}