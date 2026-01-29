BalatroTCG.JokerMod {
    key_override = 'j_triboulet',
    
    modify = function(self, balanced)
        self.config.chance = 4
    end,
    calculate_context = function(self, context, balanced)
        
        if context.updating then

        elseif context.individual and context.cardarea == G.play and context.other_card:is_rank_joker({12, 13}) then
            if balanced and pseudorandom('trib') < G.GAME.probabilities.normal/self.ability.chance then
                context.other_card.trib_break = true
            end
            return {
                x_mult = self.ability.extra,
                colour = G.C.RED,
                card = self
            }
        elseif context.destroying_card and not context.blueprint then
            if context.destroying_card.trib_break then
                return true
            end
        end
    end,
}