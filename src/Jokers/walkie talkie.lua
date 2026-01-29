BalatroTCG.JokerMod {
    key_override = 'j_walkie_talkie',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra.chips = 4
            self.config.extra.mult = 10
        end
    end,
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_rank_joker({10, 4}) then
                return {
                    chips = self.ability.extra.chips,
                    mult = self.ability.extra.mult,
                    card = self
                }
            end
        end
    end,
}