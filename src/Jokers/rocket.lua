BalatroTCG.JokerMod {
    key_override = 'j_rocket',
    
    modify = function(self, balanced)
        if balanced then self.eternal_compat = false end
        self.config.extra.dollars = 2
        self.config.extra.increase = 4
        self.config.extra.limit = 14
    end,
    calculate_context = function(self, context, balanced)
        if context.end_of_round and not context.repetition and not context.individual then
            local amount = self.ability.extra.dollars
            ease_dollars(amount)

            SMODS.scale_card(self, {
                ref_table = self.ability.extra,
                ref_value = "dollars",
                scalar_value = "increase",
                message_colour = G.C.MONEY
            })
            if self.ability.extra.dollars > self.ability.extra.limit then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        self:start_dissolve()
                        return true
                    end
                })) 
            end
        end
    end,
}