BalatroTCG.JokerMod {
    key_override = 'j_diet_cola',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra.chips = 4
            self.config.extra.mult = 10
        end
    end,
    calculate_context = function(self, context, balanced)
        if context.selling_self then
            ease_hands_played(1)
            ease_discard(1)
        end
    end,
}