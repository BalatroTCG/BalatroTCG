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

    ai_calculate = function(self, context, balanced)
        
        if context.value_eval == self then
            
            local card_vision = G.FUNCS.card_vision(round_stats, 0, 0)

            if self.tcg_extra.suit then

                local amount = G.FUNCS.get_card_amount(context.full_deck, function(e) return e.base.suit == self.tcg_extra.suit end)

                return {
                    hand = { any = {
                        x_mult = math.pow(self.ability.extra, amount * card_vision / #context.full_deck)
                    }}
                }
            else

                local total = 0
                local count = 0
                for suit, _ in pairs(SMODS.Suits) do
                    local amount = G.FUNCS.get_card_amount(context.full_deck, function(e) return e:is_playing_card() and e:is_suit(suit) end)

                    total = total + amount * card_vision / #context.full_deck
                    count = count + 1
                end

                total = total / count

                return {
                    hand = { any = {
                        x_mult = math.pow(self.ability.extra, total)
                    }}
                }
            end
        end
    end,
}