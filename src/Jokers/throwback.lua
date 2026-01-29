BalatroTCG.JokerMod {
    key_override = 'j_throwback',
    
    modify = function(self, balanced)
        self.config.discards = 0
    end,
    calculate_context = function(self, context, balanced)
        if not context.repetition and not context.individual and context.end_of_round then
            self.ability.discards = (self.ability.discards or 0) + G.GAME.current_round.discards_left
            return {
                message = localize('k_upgrade_ex'),
                card = self
            }
        elseif context.joker_main and self.ability.discards > 0 then
            local x_mult = self.ability.extra * self.ability.discards + 1
            return {
                message = localize{type='variable',key='a_xmult',vars={x_mult}},
                Xmult_mod = x_mult,
            }
        end
    end,
}