BalatroTCG.JokerMod {
    key_override = 'j_card_sharp',
    
    modify = function(self, balanced)
        if balanced then self.config.extra.Xmult = 4 end
    end,
    calculate_context = function(self, context, balanced)
        if context.joker_main then
            if BalatroTCG.Status_Current.status.last_hand and context.scoring_name == BalatroTCG.Status_Current.status.last_hand then
                return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}},
                    Xmult_mod = self.ability.extra.Xmult,
                }
            end
        end
    end,
}