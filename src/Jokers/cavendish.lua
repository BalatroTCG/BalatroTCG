BalatroTCG.JokerMod {
    key_override = 'j_cavendish',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra = {
                Xmult = 10,
                odds = 100,
            }
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_gros_michel',

    -- gros_michel_extinct
    calculate_context = function(self, context, balanced)
        if context.joker_main then

            return {
                message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                mult_mod = self.ability.extra.mult,
            }
        end
        if context.joker_dying == self then
            G.GAME.pool_flags.gros_michel_extinct = true
        end
    end,
    
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            
            local x_mult = 1;

            if context.rounds_left > 5 then -- the a rough estimate on rounds for the banana to pop, then to buy cavendish
                x_mult = 10
            end
            
            return {
                hand = { any = {
                    mult = self.ability.extra.mult,
                    x_mult = x_mult,
                }}
            } 
        end
    end,
}