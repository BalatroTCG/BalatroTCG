BalatroTCG.VoucherMod {
    key_override = 'v_hone',
    
    get_cost = function(original, balanced) return 6 end,

    modify = function(self, balanced)
        self.config.extra = 50
    end,
    redeem = function(card, balanced, original_func)
    end,

    calculate_context = function(self, context, balanced)
        if context.cardarea == G.jokers and context.joker_main then
            return {
                message = localize{type='variable',key='a_chips',vars={self.ability.extra}},
                chip_mod = self.ability.extra.chips,
                card = self
            }
        end
    end
}
BalatroTCG.VoucherMod {
    key_override = 'v_glow_up',
    
    get_cost = function(original, balanced) return 14 end,
    
    modify = function(self, balanced)
        self.config.extra = 1.5
    end,
    redeem = function(card, balanced, original_func)
    end,

    calculate_context = function(self, context, balanced)
        if context.cardarea == G.jokers and context.joker_main then
            return {
                x_mult = self.ability.extra,
                card = self
            }
        end
    end
}