BalatroTCG.JokerMod {
    key_override = 'j_popcorn',
    
    modify = function(self, balanced)
        if balanced then
            self.config.mult = 100
            self.config.extra = 20
        end
    end,
}