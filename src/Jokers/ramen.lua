BalatroTCG.JokerMod {
    key_override = 'j_ramen',
    
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 4
            self.config.extra = 0.25
        end
    end,
}