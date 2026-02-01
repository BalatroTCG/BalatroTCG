BalatroTCG.VoucherMod {
    key_override = 'v_directors_cut',
    
    get_cost = function(original, balanced) return 6 end,

    modify = function(self, balanced)
        self.config.extra = {
            reroll = 10,
            damage = 15
        }
    end,
    redeem = function(card, balanced, original_func)
        G.GAME.modifiers.tcg_attack = card.ability.extra.damage
        G.GAME.modifiers.tcg_attack_cost = card.ability.extra.reroll
    end,

}
BalatroTCG.VoucherMod {
    key_override = 'v_retcon',
    
    get_cost = function(original, balanced) return 6 end,
    
    modify = function(self, balanced)
        self.config.extra = {
            reroll = 8,
            damage = 24
        }
    end,
    redeem = function(card, balanced, original_func)
        G.GAME.modifiers.tcg_attack = card.ability.extra.damage
        G.GAME.modifiers.tcg_attack_cost = card.ability.extra.reroll
    end,

}