BalatroTCG.JokerMod {
    key_override = 'j_joker',
    
    modify = function(self, balanced)
        if balanced then
            self.config.mult = 5
        end
    end,
    get_cost = function(original, balanced)
        if balanced then
            return 1
        end
    end,
}