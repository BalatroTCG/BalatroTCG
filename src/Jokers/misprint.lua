BalatroTCG.JokerMod {
    key_override = 'j_misprint',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra.min = 00
            self.config.extra.max = 40
        end
    end,
}