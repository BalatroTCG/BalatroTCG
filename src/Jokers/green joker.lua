BalatroTCG.JokerMod {
    key_override = 'j_green_joker',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra.hand_add = 3
            self.config.extra.discard_sub = 3
        end
    end,
}