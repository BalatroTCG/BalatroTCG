BalatroTCG.JokerMod {
    key_override = 'j_burglar',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra = 2
        end
    end,
}