BalatroTCG.JokerMod {
    key_override = 'j_hit_the_road',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 4 end
    end,
    calculate_context = function(self, context, balanced)
        if context.discard then
            local rank = self:get_ability_id(11)
            
            if not context.other_card.debuff and context.other_card:is_rank_joker(rank) and not context.blueprint then
                self.ability.x_mult = self.ability.x_mult + self.ability.extra
                return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                        colour = G.C.RED,
                        delay = 0.45, 
                    card = self
                }
            end
        end
        
    end
}