BalatroTCG.JokerMod {
    key_override = 'j_ceremonial',
    
    modify = function(self, balanced)
        if not balanced then
            self.config.extra = {
                mult = 0,
                growth = 2,
            }
        else
            self.config.extra = {
                mult = 0,
                growth = 4,
            }
        end
    end,
    calculate_context = function(self, context, balanced)
        if context.setting_blind and not self.getting_sliced and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == self then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not self.getting_sliced and not SMODS.is_eternal(G.jokers.cards[my_pos+1], self) and not G.jokers.cards[my_pos+1].getting_sliced then
                local sliced_card = G.jokers.cards[my_pos+1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0

                    self:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))
                SMODS.scale_card(self, {
                    ref_table = self.ability.extra,
                    ref_value = "mult",
                    scalar_table = sliced_card,
                    scalar_value = "sell_cost",
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = initial + ref_table['growth'] * scaling
                    end,
                    scaling_message = {
                        message = localize{type = 'variable', key = 'a_mult', vars = {self.ability.extra.mult + self.ability.extra.growth * sliced_card.sell_cost}},
                        colour = G.C.RED,
                        no_juice = true
                    }
                })
                return nil, true
            end
        elseif context.joker_main and self.ability.extra.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                mult_mod = self.ability.extra.mult
            }
        end
    end,
}