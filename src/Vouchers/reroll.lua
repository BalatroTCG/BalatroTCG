BalatroTCG.VoucherMod {
    key_override = 'v_reroll_surplus',
    
    get_cost = function(original, balanced) return 8 end,

    modify = function(self, balanced)
        self.config.extra = 2
        self.config.increase = 4
    end,
    redeem = function(card, balanced, original_func)
        G.GAME.modifiers.extra_discard_cost = G.GAME.modifiers.extra_discard_cost or card.ability.extra
        G.GAME.modifiers.extra_discard = card.ability.extra
        G.GAME.modifiers.extra_discard_increase = card.ability.increase
    end,
}
BalatroTCG.VoucherMod {
    key_override = 'v_reroll_glut',
    
    get_cost = function(original, balanced) return 8 end,

    modify = function(self, balanced)
        self.config.extra = 2
        self.config.increase = 2
    end,
    redeem = function(card, balanced, original_func)
        G.GAME.modifiers.extra_discard_cost = G.GAME.modifiers.extra_discard_cost or card.ability.extra
        G.GAME.modifiers.extra_discard = card.ability.extra
        G.GAME.modifiers.extra_discard_increase = card.ability.increase
    end,
}