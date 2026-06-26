BalatroTCG.JokerMod {
    key_override = 'j_walkie_talkie',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra.mult = 14
        end
    end,
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_rank_joker({10, 4}) then
                if balanced then
                    return {
                        mult = self.ability.extra.mult,
                        card = self
                    }
                else
                    return {
                        chips = self.ability.extra.chips,
                        mult = self.ability.extra.mult,
                        card = self
                    }
                end
            end
        end
    end,
}