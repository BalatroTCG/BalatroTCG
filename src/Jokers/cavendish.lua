BalatroTCG.JokerMod {
    key_override = 'j_cavendish',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra = {
                Xmult = 10,
                odds = 100,
            }
        end
    end,
}