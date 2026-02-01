BalatroTCG.VoucherMod {
    key_override = 'v_seed_money',
    
    get_cost = function(original, balanced) return 1 end,

    modify = function(self, balanced)
        self.config.extra = 1
    end,
    calculate_context = function(self, context, balanced)
        if BalatroTCG.Status_Current.status.used_vouchers['v_money_tree'] then return end

        if not context.cardarea and not context.repetition and not context.individual and context.end_of_round then
            BalatroTCG.Status_Current.status.seed_reduction = BalatroTCG.Status_Current.status.seed_reduction + 1
            BalatroTCG.Status_Current:damage(1)

        end
    end
}
BalatroTCG.VoucherMod {
    key_override = 'v_money_tree',
    
    get_cost = function(original, balanced) return 6 end,
    
    calculate_context = function(self, context, balanced)
        if not context.cardarea and not context.repetition and not context.individual and context.end_of_round then
            ease_dollars(BalatroTCG.Status_Current.status.seed_reduction)
        end
    end
}