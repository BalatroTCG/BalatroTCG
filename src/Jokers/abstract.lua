BalatroTCG.JokerMod {
    key_override = 'j_abstract',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 10 end
    end,
    
    calculate_context = function(self, context, balanced)

        if self.ability.name == 'Abstract Joker' then
            local x = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then x = x + 1 end
            end
            x = x + #BalatroTCG.Status_Current.opponentJokers.cards
            return {
                message = localize{type='variable',key='a_mult',vars={x*self.ability.extra}},
                mult_mod = x*self.ability.extra
            }
        end

    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            
            local amount = G.jokers.card_limit + (#BalatroTCG.Status_Current.opponentJokers.cards + math.max(5, #BalatroTCG.Status_Current.opponentJokers.cards)) / 2
            
            return {
                hand = { any = {
                    mult = amount * self.ability.extra,
                }}
            } 
        end
    end,
}