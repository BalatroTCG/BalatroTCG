BalatroTCG.JokerMod {
    key_override = 'j_diet_cola',
    
    calculate_context = function(self, context, balanced)
        if context.selling_self then
            ease_hands_played(1)
            ease_discard(1)
        end
    end,
}