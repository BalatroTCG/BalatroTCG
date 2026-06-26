BalatroTCG.JokerMod {
    key_override = 'j_drivers_license',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra = 50
            self.config.tally_amount = 16
        else
            self.config.tally_amount = 16
        end
    end,
    calculate_context = function(self, context, balanced)
        if context.updating then
            self.ability.driver_tally = 0
            for k, v in pairs(G.playing_cards) do
                if v:is_playing_card() and v.config.center ~= G.P_CENTERS.c_base then self.ability.driver_tally = self.ability.driver_tally+1 end
            end
        elseif context.joker_main and self.ability.driver_tally >= self.config.tally_amount then
            return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.extra}},
                Xmult_mod = self.ability.extra,
            }
        end
    end,
}