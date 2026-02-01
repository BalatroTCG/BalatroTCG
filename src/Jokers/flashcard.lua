BalatroTCG.JokerMod {
    key_override = 'j_flash',
    
    modify = function(self, balanced)
        self.config.extra = 3
    end,
    calculate_context = function(self, context, balanced)
        if context.end_of_round and not context.repetition then
            if not context.other_card:is_playing_card() then
                self.ability.mult = self.ability.mult + self.ability.extra
                
                SMODS.calculate_effect({ message = localize({type='variable',key='a_mult',vars={self.ability.extra}}), colour = G.C.RED}, context.other_card)
            end
        elseif context.joker_main and self.ability.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                mult_mod = self.ability.mult
            }
        end
    end,
}