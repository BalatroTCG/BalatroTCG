BalatroTCG.JokerMod {
    key_override = 'j_steel_joker',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 1.5 end
    end,
    calculate_context = function(self, context, balanced)
        if context.updating then
            self.ability.steel_tally = 0
            for k, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_steel then self.ability.steel_tally = self.ability.steel_tally+1 end
            end
        elseif context.joker_main and self.ability.steel_tally >= 1 then
            local xmult = self.ability.extra * self.ability.steel_tally + 1
            return {
                message = localize{type='variable',key='a_xmult',vars={xmult}},
                Xmult_mod = xmult,
            }
        end
    end,
}