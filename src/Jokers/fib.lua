BalatroTCG.JokerMod {
    key_override = 'j_fibonacci',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 13 end
    end,
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_rank_joker({2, 3, 5, 8, 14}) then
                return {
                    mult = self.ability.extra,
                    card = self
                }
            end
        end
    end,
}