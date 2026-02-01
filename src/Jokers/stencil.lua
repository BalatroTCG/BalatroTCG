BalatroTCG.JokerMod {
    key_override = 'j_stencil',
    
    calculate_context = function(self, context, balanced)
        if context.updating then
            self.ability.x_mult = (G.jokers.config.card_limit - #G.jokers.cards)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == 'Joker Stencil' then self.ability.x_mult = self.ability.x_mult + 1 end
            end
        elseif context.joker_main and self.ability.x_mult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                Xmult_mod = self.ability.x_mult,
            }
        end
    end,
}