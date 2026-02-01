BalatroTCG.JokerMod {
    key_override = 'j_loyalty_card',
    
    modify = function(self, balanced)
        if balanced then self.config.extra.Xmult = 7.5 end
    end,
}