BalatroTCG.JokerMod {
    key_override = 'j_dusk',
    
    modify = function(self, balanced)
        self.config.extra = 10
    end,
    calculate_context = function(self, context, balanced)
        if context.repetition and context.cardarea == G.play then
            if G.GAME.dollars <= self.ability.extra then
                return {
                    message = localize('k_again_ex'),
                    repetitions = 1,
                    card = self
                }
            end
        end
    end,
}