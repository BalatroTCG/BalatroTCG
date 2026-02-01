BalatroTCG.JokerMod {
    key_override = 'j_runner',
    
    modify = function(self, balanced)
        if balanced then self.config.extra.chip_mod = 40 end
    end,
}