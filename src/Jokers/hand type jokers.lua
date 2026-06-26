BalatroTCG.JokerMod {
    key_override = 'j_jolly',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_mult = 25
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 1
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { pair = {
                    mult = self.ability.t_mult,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_sly',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_chips = 150
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 1
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { pair = {
                    chips = self.ability.t_chips,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_zany',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_mult = 50
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { threeoak = {
                    mult = self.ability.t_mult,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_wily',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_chips = 300
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { threoak = {
                    chips = self.ability.t_chips,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_mad',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_mult = 35
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 2
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { twopair = {
                    mult = self.ability.t_mult,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_clever',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_chips = 200
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 2
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { twopair = {
                    chips = self.ability.t_chips,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_crazy',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_mult = 80
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 4
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { straight = {
                    mult = self.ability.t_mult,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_devious',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_chips = 600
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 4
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { straight = {
                    chips = self.ability.t_chips,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_droll',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_mult = 35
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { flush = {
                    mult = self.ability.t_mult,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_crafty',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_chips = 250
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { flush = {
                    chips = self.ability.t_chips,
                }}
            } 
        end
    end,
}

BalatroTCG.JokerMod {
    key_override = 'j_duo',
    
    get_cost = function(original, balanced)
        if balanced then return 4 end
    end,
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 10
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { pair = {
                    x_mult = self.ability.x_mult,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_trio',
    
    get_cost = function(original, balanced)
        if balanced then return 7 end
    end,
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 15
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { threeoak = {
                    x_mult = self.ability.x_mult,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_family',
    
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 20
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { fouroak = {
                    x_mult = self.ability.x_mult,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_order',
    
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 30
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { straight = {
                    x_mult = self.ability.x_mult,
                }}
            } 
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_tribe',
    
    get_cost = function(original, balanced)
        if balanced then return 6 end
    end,
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 12
        end
    end,
    ai_calculate = function(self, context, balanced)
        
        if context.purchase == self then
            return {
                hand = { flush = {
                    x_mult = self.ability.x_mult,
                }}
            } 
        end
    end,
}

