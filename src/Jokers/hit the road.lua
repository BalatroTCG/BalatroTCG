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
            
        elseif not context.repetition and not context.individual and context.end_of_round and self.ability.x_mult > 1 then
            self.ability.x_mult = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        elseif context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                Xmult_mod = self.ability.x_mult,
            }
        end
        
    end
}