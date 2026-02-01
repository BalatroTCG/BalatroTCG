BalatroTCG.VoucherMod {
    key_override = 'v_hieroglyph',
    
    get_cost = function(original, balanced) return 6 end,

    modify = function(self, balanced)
        self.config.extra = 8
    end,
    redeem = function(card, balanced, original_func)
        G.GAME.modifiers.damage_reduction = card.ability.extra
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
        ease_discard(-1)
    end,

}
BalatroTCG.VoucherMod {
    key_override = 'v_petroglyph',
    
    get_cost = function(original, balanced) return 12 end,
    
    modify = function(self, balanced)
        self.config.extra = 40
    end,
    redeem = function(card, balanced, original_func)
        G.GAME.modifiers.damage_percent = card.ability.extra
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
        ease_discard(-1)
    end,
}