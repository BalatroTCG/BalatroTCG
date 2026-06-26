BalatroTCG.JokerMod {
    key_override = 'j_stuntman',
    
    modify = function(self, balanced)
        if balanced then self.config.extra.chip_mod = 500 end
    end,
}