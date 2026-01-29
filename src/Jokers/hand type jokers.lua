BalatroTCG.JokerMod {
    key_override = 'j_jolly',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_mult = 10
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 2
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_sly',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_chips = 100
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 2
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_zany',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_mult = 15
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_wily',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_chips = 150
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_mad',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_mult = 12
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_clever',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_chips = 120
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_crazy',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_mult = 30
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_devious',
    
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
}
BalatroTCG.JokerMod {
    key_override = 'j_droll',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_mult = 18
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_crafty',
    
    modify = function(self, balanced)
        if balanced then
            self.config.t_chips = 180
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 3
        end
    end,
}

BalatroTCG.JokerMod {
    key_override = 'j_duo',
    
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 8
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_trio',
    
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 10
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_family',
    
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 12
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_order',
    
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 14
        end
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_tribe',
    
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 9
        end
    end,
}

