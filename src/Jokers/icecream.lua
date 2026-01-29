BalatroTCG.JokerMod {
    key_override = 'j_ice_cream',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra.chips = 250
            self.config.extra.chip_mod = 50
        end
    end,
}