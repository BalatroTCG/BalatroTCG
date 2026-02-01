BalatroTCG.JokerMod {
    key_override = 'j_swashbuckler',
    
    calculate_context = function(self, context, balanced)
        if context.updating then
            local sell_cost = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= self and (G.jokers.cards[i].area and G.jokers.cards[i].area == G.jokers) then
                    sell_cost = sell_cost + G.jokers.cards[i].sell_cost
                end
            end
            sell_cost = sell_cost + BalatroTCG.Status_Current.status.opponent_joker_cost
            
            self.ability.mult = sell_cost
            
        elseif context.joker_main and self.ability.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                mult_mod = self.ability.mult
            }
        end
    end,
}