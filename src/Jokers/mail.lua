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
    end,
    ai_calculate = function(self, context, balanced)
        
        local round_stats = context.round_stats

        if context.purchase == self then
            
            if round_stats.discards == 0 then return end
            local card_vision = G.FUNCS.card_vision(round_stats, 0, 1)

            if self.tcg_extra.rank then
                local rank = self.tcg_extra.rank

                local amount = G.FUNCS.get_card_amount(context.full_deck, function(e) return e.base.id == rank end)

                return {
                    money_per_round = amount * self.ability.extra * card_vision / #context.full_deck
                }
            else
                local ranks = {}

                for _, k in ipairs(context.full_deck) do
                    if k:is_playing_card() and not ranks[k.base.id] then
                        ranks[k.base.id] = true
                    end
                end

                local total = 0
                
                for rank, _ in pairs(ranks) do
                    local amount = G.FUNCS.get_card_amount(context.full_deck, function(e) return e.base.id == rank end)

                    total = total + amount * self.ability.extra * card_vision / #context.full_deck
                end

                total = total / #ranks

                return {
                    money_per_round = total
                }
            end
        
        elseif context.in_hand then
            local rank = self.tcg_extra.rank or G.GAME.current_round.mail_card.id

            if context.other_card:get_id() == rank then
                return {
                    discard = {
                        dollars = self.ability.extra
                    }
                }
            end
        end
    end
}