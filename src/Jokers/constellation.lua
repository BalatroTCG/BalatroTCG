BalatroTCG.JokerMod {
    key_override = 'j_constellation',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 0.5 end
    end,
}