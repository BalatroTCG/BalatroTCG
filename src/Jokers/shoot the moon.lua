BalatroTCG.JokerMod {
    key_override = 'j_shoot_the_moon',
    
    modify = function(self, balanced)
        self.config.mult = 25
    end,
    calculate_context = function(self, context, balanced)
        
        if context.individual and context.cardarea == G.play then

            local rank = self:get_ability_id(12)

            if context.other_card:is_rank_joker(rank) then
                return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                    mult_mod = self.ability.mult,
                    card = self,
                }
            end
        end
    end,
}