BalatroTCG.JokerMod {
    key_override = 'j_mail',
    
    modify = function(self, balanced)
        if balanced then
            self.eternal_compat = false
            self.config.extra = 3
        end
    end,
    get_cost = function(original, balanced)
        if balanced then return 5 end
    end,
    calculate_context = function(self, context, balanced)
        if context.discard then
            local rank = self:get_ability_id(G.GAME.current_round.mail_card.id)
            if not context.other_card.debuff and context.other_card:is_rank_joker(rank) then
                ease_dollars(self.ability.extra)
                return {
                    message = localize('$')..self.ability.extra,
                    colour = G.C.MONEY,
                    card = self
                }
            end
        end
        
    end
}