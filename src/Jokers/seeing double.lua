BalatroTCG.JokerMod {
    key_override = 'j_seeing_double',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 8 end
    end,
}