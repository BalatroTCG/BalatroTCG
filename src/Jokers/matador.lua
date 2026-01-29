BalatroTCG.JokerMod {
    key_override = 'j_matador',
    
    modify = function(self, balanced)
        if balanced then self.eternal_compat = false end
        center.blueprint_compat = false
    end,
    calculate_context = function(self, context, balanced)
        if context.tcg_take_damage and not context.blueprint then
            
            local jokers = {}
            for k, joker in ipairs(G.jokers.cards) do
                if joker == self then
                    if k > 1 then
                        jokers[#jokers + 1] = G.jokers.cards[k - 1]
                    end
                    if k < #G.jokers.cards then
                        jokers[#jokers + 1] = G.jokers.cards[k + 1]
                    end
                    break
                end
            end
            
            if #jokers == 0 then
                return {
                    redirect = self,
                }
            else
                return {
                    redirect = pseudorandom_element(jokers, pseudoseed('matador'))
                }
            end
        end
    end,
}