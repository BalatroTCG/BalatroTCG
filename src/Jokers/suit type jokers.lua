BalatroTCG.JokerMod {
    key_override = 'j_lusty_joker',
    
    modify = function(self, balanced)
        if balanced then
            self.config.s_mult = 6
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_greedy_joker',
    
    modify = function(self, balanced)
        if balanced then
            self.config.s_mult = 6
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_wrathful_joker',
    
    modify = function(self, balanced)
        if balanced then
            self.config.s_mult = 6
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_gluttenous_joker',
    
    modify = function(self, balanced)
        if balanced then
            self.config.s_mult = 6
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
}

BalatroTCG.JokerMod {
    key_override = 'j_bloodstone',
    
    modify = function(self, balanced)
        if balanced then  
            self.config.extra = {
                Xmult = 1.5,
                num = 2,
                odds = 1
            }
        else
            self.config.extra = {
                Xmult = 1.5,
                num = 1,
                odds = 2
            }
        end
    end,
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            
            local suit = self:get_ability_suit("Hearts")
            if context.other_card:is_suit(suit) and SMODS.pseudorandom_probability(self, 'bloodstone', self.ability.extra.num, self.ability.extra.odds) then
                
                return {
                    x_mult = self.ability.extra.Xmult,
                    card = self
                }
            end
        elseif not context.blueprint and context.cardarea == G.jokers and context.after then
            if balanced then
                self.ability.extra.odds = self.ability.extra.odds + 1
                return {
                    message = localize('k_bleeding'),
                    colour = G.C.RED
                }
            end
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_rough_gem',
    
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            local suit = self:get_ability_suit("Diamonds")
            
            if context.other_card:is_suit(suit) then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))

                return {
                    dollars = self.ability.extra,
                    card = self,
                }
            end
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_arrowhead',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 75 end
    end,
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            local suit = self:get_ability_suit("Spades")
            if context.other_card:is_suit(suit) then
                return {
                    chips = self.ability.extra,
                    card = self
                }
            end
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_onyx_agate',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 12 end
    end,
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            local suit = self:get_ability_suit("Clubs")

            if context.other_card:is_suit(suit) then
                return {
                    mult = self.ability.extra,
                    card = self
                }
            end
        end
    end,
}
