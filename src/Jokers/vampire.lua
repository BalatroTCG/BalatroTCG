BalatroTCG.JokerMod {
    key_override = 'j_vampire',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 0.5 end
    end,
    calculate_context = function(self, context, balanced)
        if context.before and not context.blueprint then
            local enhanced = {}
            for k, v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.vampired then 
                    enhanced[#enhanced+1] = v
                    v.vampired = true
                    v:set_ability(G.P_CENTERS.c_base, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            v.vampired = nil
                            return true
                        end
                    })) 
                end
            end

            if #enhanced > 0 then 
                SMODS.scale_card(self, {
                    ref_table = self.ability,
                    ref_value = "x_mult",
                    scalar_value = "extra",
                    message_key = 'a_xmult',
                    message_colour = G.C.MULT,
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = initial + scaling*#enhanced
                    end
                })
            end
        elseif context.joker_main and self.ability.x_mult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                Xmult_mod = self.ability.x_mult,
            }
        end
        
    end
}