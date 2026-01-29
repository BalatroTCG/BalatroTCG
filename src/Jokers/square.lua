BalatroTCG.JokerMod {
    key_override = 'j_square',
    
    modify = function(self, balanced)
        if balanced then self.config.extra.chip_mod = 8 end
    end,
    calculate_context = function(self, context, balanced)
        
        if (context.before) or (context.pre_discard) then
            if #context.full_hand == 4 and not context.blueprint then
                SMODS.scale_card(self, {
                    ref_table = self.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chip_mod",
                })
                return nil, true
            end
        elseif context.joker_main then
            return {
                message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                chip_mod = self.ability.extra.chips, 
                colour = G.C.CHIPS
            }
        end
    end
}