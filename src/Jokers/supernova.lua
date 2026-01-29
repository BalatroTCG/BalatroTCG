BalatroTCG.JokerMod {
    key_override = 'j_supernova',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 5 end
    end,
    calculate_context = function(self, context, balanced)
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_mult',vars={G.GAME.hands[context.scoring_name].played * self.ability.extra}},
                mult_mod = G.GAME.hands[context.scoring_name].played * self.ability.extra
            }
        end
    end,
}