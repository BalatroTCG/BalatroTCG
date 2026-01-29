BalatroTCG.JokerMod {
    key_override = 'j_campfire',
    
    modify = function(self, balanced)
        self.config.extra = 1.5
        self.config.reduce = 4
    end,
    calculate_context = function(self, context, balanced)
        
        if (context.cardarea == G.jokers and context.after) or (context.pre_discard) then
            if self.ability.name == 'Campfire' then
                if self.ability.x_mult <= 1 then 
                    return nil
                else
                    self:juice_up(0.3, 0.4)
                    play_sound('tarot1')
                    self.ability.x_mult = math.floor((self.ability.x_mult * (1 - (self.ability.reduce / 100))) * 10) / 10
                end
            end
        elseif context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                Xmult_mod = self.ability.x_mult,
            }
        end
    end
}