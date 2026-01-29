BalatroTCG.JokerMod {
    key_override = 'j_chicot',
    
    modify = function(self, balanced)
        if balanced then
            self.eternal_compat = false
            self.config.extra = 10
        end
    end,
    calculate_context = function(self, context, balanced)
        if context.setting_blind and not self.getting_sliced and not context.blueprint then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                for k, v in ipairs(G.jokers.cards) do
                    self:juice_up(0.3, 0.4)
                    play_sound('tarot1')
                    v:set_tcg_health((v.ability.tcgb_health_amount or 0) + self.ability.extra)
                    delay(0.4)
                end
                return true end
            }))
        end
    end,
}