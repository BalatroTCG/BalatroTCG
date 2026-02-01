BalatroTCG.JokerMod {
    key_override = 'j_lucky_cat',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 1.5 end
    end,
}