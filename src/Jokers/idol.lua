BalatroTCG.JokerMod {
    key_override = 'j_idol',
    
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            local suit = self:get_ability_suit(G.GAME.current_round.idol_card.suit)
            local rank = self:get_ability_id(G.GAME.current_round.idol_card.id)

            if context.other_card:is_rank_joker(rank) and context.other_card:is_suit(suit) then
                return {
                    x_mult = self.ability.extra,
                    colour = G.C.RED,
                    card = self
                }
            end
        end
        
    end
}