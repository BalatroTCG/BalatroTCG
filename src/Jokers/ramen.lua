BalatroTCG.JokerMod {
    key_override = 'j_ramen',
    
    modify = function(self, balanced)
        if balanced then
            self.config.x_mult = 10
            self.config.extra = 0.5
        end
    end,
}