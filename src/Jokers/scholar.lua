BalatroTCG.JokerMod {
    key_override = 'j_scholar',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra.chips = 75
            self.config.extra.mult = 15
        end
    end,
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_rank_joker({14}) then
                return {
                    chips = self.ability.extra.chips,
                    mult = self.ability.extra.mult,
                    card = self
                }
            end
        end
    end,
}