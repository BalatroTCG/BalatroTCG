BalatroTCG.JokerMod {
    key_override = 'j_troubadour',
    
    add_to_deck = function(self, from_debuff, balance)
        G.hand:change_size(self.ability.extra.h_size)
        BalatroTCG.Status_Current.params.discards = BalatroTCG.Status_Current.params.discards + self.ability.extra.h_plays
    end,
    remove_from_deck = function(self, from_debuff, balance)
        G.hand:change_size(-self.ability.extra.h_size)
        BalatroTCG.Status_Current.params.discards = BalatroTCG.Status_Current.params.discards - self.ability.extra.h_plays
    end
}