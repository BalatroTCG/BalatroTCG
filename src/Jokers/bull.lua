BalatroTCG.JokerMod {
    key_override = 'j_bull',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 2 end
    end,
    calculate_context = function(self, context, balanced)
        if context.joker_main then
            local money = (G.GAME.dollars + (G.GAME.dollar_buffer or 0)) + BalatroTCG.Status_Current.status.opponent_health
            return {
                message = localize{type='variable',key='a_chips',vars={self.ability.extra * math.floor(money)}},
                chip_mod = self.ability.extra * math.floor(money)
            }
        end
    end
}