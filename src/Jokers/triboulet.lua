BalatroTCG.JokerMod {
    key_override = 'j_triboulet',
    
    loc_vars = function(ability, card, balance)
        return { ability.per_card, ability.extra }
    end,
    modify = function(self, balanced)
        self.config.per_card = 0.15
    end,
    calculate_context = function(self, context, balanced)
        
        if context.updating and balanced then
            
            self.ability.king_tally = 0
            for k, v in pairs(G.playing_cards) do
                if v:is_rank_joker(13) then self.ability.king_tally = self.ability.king_tally + 1 end
            end
            self.ability.extra = 1 + (self.ability.king_tally * self.ability.per_card)

        elseif context.individual and context.cardarea == G.play and ((balanced and context.other_card:is_rank_joker({12})) or (not balanced and context.other_card:is_rank_joker({13}))) then
            
            return {
                x_mult = self.ability.extra,
                colour = G.C.RED,
                card = self
            }
        elseif context.destroying_card and not context.blueprint then
            if context.destroying_card.trib_break then
                return true
            end
        end
    end,
}