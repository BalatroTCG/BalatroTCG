BalatroTCG.JokerMod {
    key_override = 'j_luchador',
    
    modify = function(self, balanced)
        self.config.extra = 100
        self.config.wait_rounds = 2
        self.config.wait = 0
    end,
    calculate_context = function(self, context, balanced)
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
            self.ability.wait = self.ability.wait + 1
            if self.ability.wait == self.ability.wait_rounds then 
                local eval = function(card) return card.area and not (card.area == G.graveyard or card.area == G.discard) end
                juice_card_until(self, eval, true)
            end
            return {
                message = (self.ability.wait < self.ability.wait_rounds) and (self.ability.wait..'/'..self.ability.wait_rounds) or localize('k_active_ex'),
                colour = G.C.FILTER
            }
        elseif context.selling_self then
            self.ability.wait = 0
            BalatroTCG.Status_Current:add_protection({ percent = self.ability.extra / 100 })
        end
    end,
}