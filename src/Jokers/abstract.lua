BalatroTCG.JokerMod {
    key_override = 'j_abstract',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 3 end
    end,
}