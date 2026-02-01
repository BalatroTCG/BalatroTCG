BalatroTCG.JokerMod {
    key_override = 'j_faceless',
    
    modify = function(self, balanced)
        if balanced then
            self.eternal_compat = false
            self.config.extra.dollars = 6
        end
    end,
}