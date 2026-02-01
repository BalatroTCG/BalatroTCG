BalatroTCG.JokerMod {
    key_override = 'j_odd_todd',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 75 end
    end,
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_rank_joker({3, 5, 7, 9, 14}) then
                return {
                    chips = self.ability.extra,
                    card = self
                }
            end
        end
        
    end
}