BalatroTCG.JokerMod {
    key_override = 'j_obelisk',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 2 end
    end,
    calculate_context = function(self, context, balanced)
        if context.cardarea == G.jokers then
            if context.before then
                if not context.blueprint and balanced then
                    local reset = true
                    local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
                    for k, v in pairs(G.GAME.hands) do
                        if k ~= context.scoring_name and v.played >= play_more_than and SMODS.is_poker_hand_visible(k) then
                            reset = false
                        end
                    end
                    if reset then
                        if self.ability.x_mult > 1 then
                            self.ability.x_mult = 1
                            return {
                                card = self,
                                message = localize('k_reset')
                            }
                        end
                    else
                        self.ability.x_mult = math.ceil((self.ability.x_mult * self.ability.extra) * 10) / 10
                    end
                    return nil
                end
            end
        elseif context.joker_main and self.ability.x_mult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                Xmult_mod = self.ability.x_mult,
            }
        end
    end
}