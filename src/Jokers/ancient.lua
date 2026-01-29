BalatroTCG.JokerMod {
    key_override = 'j_ancient',
    
    calculate_context = function(self, context, balanced)
        if context.individual and context.cardarea == G.play then
            local suit = self:get_ability_suit(G.GAME.current_round.ancient_card.suit)
            if context.other_card:is_suit(suit) then
                return {
                    x_mult = self.ability.extra,
                    card = self
                }
            end
        end
    end,
}