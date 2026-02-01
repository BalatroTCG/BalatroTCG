BalatroTCG.JokerMod {
    key_override = 'j_chaos',
    
    modify = function(self, balanced)
        if balanced then
            self.eternal_compat = false
            self.config.extra = 15
        end
    end,
    
    add_to_deck = function(self, from_debuff, balance)
        for k, v in ipairs(G.jokers.cards) do
            v.ability.tcgb_sticker_hidden = true
            v.ability.tcgb_sticker_visible = false
        end
    end,
    remove_from_deck = function(self, from_debuff, balance)
        for k, v in ipairs(G.jokers.cards) do
            v.ability.tcgb_sticker_hidden = false
            v.ability.tcgb_sticker_visible = true
        end
    end,

    calculate_context = function(self, context, balanced)
    end
}