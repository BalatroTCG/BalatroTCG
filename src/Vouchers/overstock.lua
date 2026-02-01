BalatroTCG.VoucherMod {
    key_override = 'v_overstock_norm',
    
    get_cost = function(original, balanced) return 6 end,

    redeem = function(card, balanced, original_func)
        G.GAME.modifiers.consumeable_in_jokers = true
    end,
}
BalatroTCG.VoucherMod {
    key_override = 'v_overstock_plus',
    
    get_cost = function(original, balanced) return 14 end,

    redeem = function(card, balanced, original_func)
        G.GAME.modifiers.joker_in_consumeables = true
    end,
}