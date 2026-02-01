BalatroTCG.VoucherMod {
    key_override = 'v_magic_trick',
    
    get_cost = function(original, balanced) return 6 end,

    modify = function(self, balanced)
    end,
    redeem = function(card, balanced, original_func)
        G.GAME.modifiers.buy_cards = true
    end,

}
BalatroTCG.VoucherMod {
    key_override = 'v_illusion',
    
    get_cost = function(original, balanced) return 18 end,
    
    modify = function(self, balanced)
        self.config.extra = 1.5
    end,
    redeem = function(card, balanced, original_func)
    end,

    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            return {
                x_mult = self.ability.extra,
                card = self
            }
        end
    end
}