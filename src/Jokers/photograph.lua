BalatroTCG.JokerMod {
    key_override = 'j_photograph',
    
    description_override = {
        balanced = true,
        none = false,
    },
    
    calculate_context = function(self, context, balanced)

        if context.individual and context.cardarea == G.play then
            local first_face = nil
            if balanced then
                for i = #context.scoring_hand, 1, -1 do
                    if context.scoring_hand[i]:is_face() then first_face = context.scoring_hand[i]; break end
                end
            else
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_face() then first_face = context.scoring_hand[i]; break end
                end
            end
            if context.other_card == first_face then
                return {
                    x_mult = self.ability.extra,
                    colour = G.C.RED,
                    card = self
                }
            else
                return nil
            end
        end
    end,
}