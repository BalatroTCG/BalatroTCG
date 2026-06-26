BalatroTCG.JokerMod {
    key_override = 'j_blackboard',

    get_cost = function(original, balanced)
        if balanced then return 4 end
    end,
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 8 end
    end,
}