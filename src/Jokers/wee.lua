BalatroTCG.JokerMod {
    key_override = 'j_wee',
    
    modify = function(self, balanced)
        if balanced then self.config.extra.chip_mod = 22 end
    end,
    calculate_context = function(self, context, balanced)
        
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local rank = self:get_ability_id(2)

            if context.other_card:is_rank_joker(rank) then
                SMODS.scale_card(self, {
                    ref_table = self.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chip_mod",
                    no_message = true
                })
                return {
                    extra = {focus = self, message = localize('k_upgrade_ex')},
                    card = self
                }
            end
        elseif context.joker_main then
            
            return {
                message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                chip_mod = self.ability.extra.chips
            }
        end

    end
}