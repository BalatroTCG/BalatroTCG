BalatroTCG.JokerMod {
    key_override = 'j_even_steven',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 6 end
    end,
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_rank_joker({2, 4, 6, 8, 10}) then
                return {
                    mult = self.ability.extra,
                    card = self
                }
            end
        end
    end,
}