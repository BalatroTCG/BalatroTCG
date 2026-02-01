BalatroTCG.JokerMod {
    key_override = 'j_stone',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 40 end
    end,
    calculate_context = function(self, context, balanced)
        
        if context.updating then
            self.ability.stone_tally = 0
            for k, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_stone then self.ability.stone_tally = self.ability.stone_tally+1 end
            end
        elseif context.joker_main and self.ability.stone_tally >= 1 then
            local chips = self.ability.extra * self.ability.stone_tally
            return {
                message = localize{type='variable',key='a_chips',vars={chips}},
                chip_mod = chips
            }
        end
    end
}