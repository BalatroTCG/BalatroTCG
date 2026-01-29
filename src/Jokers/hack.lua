BalatroTCG.JokerMod {
    key_override = 'j_hack',
    
    calculate_context = function(self, context, balanced)
        if context.repetition and context.cardarea == G.play then
            if context.other_card:is_rank_joker({2, 3, 4, 5}) then
                return {
                    message = localize('k_again_ex'),
                    repetitions = self.ability.extra,
                    card = self
                }
            end
        end
    end,
}