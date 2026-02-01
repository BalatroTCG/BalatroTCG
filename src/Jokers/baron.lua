BalatroTCG.JokerMod {
    key_override = 'j_baron',
    
    description_override = {
        balanced = true,
        none = false,
    },

    loc_vars = function(ability, card, balance)
        return { ability.per_card, ability.extra }
    end,
    modify = function(self, balanced)
        if balanced then
            self.config.per_card = 0.1
        end
    end,
    calculate_context = function(self, context, balanced)
        
        
        if context.updating and balanced then
            
            self.ability.card_tally = 0
            for k, v in pairs(G.playing_cards) do
                if v:is_rank_joker(11) then self.ability.card_tally = self.ability.card_tally + 1 end
            end
            self.ability.extra = 1 + (self.ability.card_tally * self.ability.per_card)
            
        elseif context.individual and context.cardarea == G.hand then
            if context.other_card:is_rank_joker(13) then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = self,
                    }
                else
                    return {
                        x_mult = self.ability.extra,
                        card = self
                    }
                end
            end

        end
        
    end
}