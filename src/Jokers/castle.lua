BalatroTCG.JokerMod {
    key_override = 'j_castle',
    
    modify = function(self, balanced)
        if balanced then self.config.extra.chip_mod = 12 end
    end,
    calculate_context = function(self, context, balanced)
        if context.discard then
            if not context.other_card.debuff and context.other_card:is_suit(G.GAME.current_round.castle_card.suit) and not context.blueprint then
                self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.chip_mod
                
                return {
                    message = localize('k_upgrade_ex'),
                    card = self,
                    colour = G.C.CHIPS
                }
            end
        elseif context.joker_main then
            return {
                message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                chip_mod = self.ability.extra.chips
            }
        end
        
    end
}