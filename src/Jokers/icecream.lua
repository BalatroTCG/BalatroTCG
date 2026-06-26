BalatroTCG.JokerMod {
    key_override = 'j_ice_cream',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra.chips = 500
            self.config.extra.chip_mod = 10
        end
    end,
}