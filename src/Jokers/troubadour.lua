BalatroTCG.JokerMod {
    key_override = 'j_troubadour',
    
    modify = function(self, balanced)
        if balanced then self.config.extra.h_size = 3 end
        self.blueprint_compat = true
    end,

    add_to_deck = function(self, from_debuff, balance)
        G.hand:change_size(self.ability.extra.h_size)
        BalatroTCG.Status_Current.params.discards = BalatroTCG.Status_Current.params.discards + self.ability.extra.h_plays
    end,
    remove_from_deck = function(self, from_debuff, balance)
        G.hand:change_size(-self.ability.extra.h_size)
        BalatroTCG.Status_Current.params.discards = BalatroTCG.Status_Current.params.discards - self.ability.extra.h_plays
    end
}