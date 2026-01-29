BalatroTCG.JokerMod {
    key_override = 'j_cloud_9',
    
    modify = function(self, balanced)
        if balanced then self.eternal_compat = false end
        self.config.extra = 9
        self.config.final = 0
        
        self.blueprint_compat = false
    end,
    calculate_context = function(self, context, balanced)
        local single = 1 / ((100 - 9) / 100)
        print(single)
        
        if context.updating then

            self.ability.nine_tally = 0
            for k, v in pairs(G.playing_cards) do
                if v:is_rank_joker(9) then self.ability.nine_tally = self.ability.nine_tally+1 end
            end

            self.ability.final = 1 - math.pow(single, self.ability.nine_tally)
        elseif context.tcg_take_damage and not context.blueprint then
            return {
                percent = self.ability.final
            }
        end
    end,
}