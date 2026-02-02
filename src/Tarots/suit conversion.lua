BalatroTCG.ConsumeableMod {
    effect_override = 'Suit Conversion',
    
    can_use_consumeable = function(self, any_state, skip_check, balanced, original_value)
        if not balanced then return original_value end

        if original_value then
            for k, v in ipairs(G.hand.highlighted) do
                if not v:is_playing_card() then return false end
            end
        end
        return true
    end,
    use_consumeable = function(self, area, copier, balanced, original_func)
        
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            self:juice_up(0.3, 0.5)
            return true end }))

        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end

        local _suit = SMODS.Suits[self.ability.suit_conv]

        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({func = function()
                local card = G.hand.highlighted[i]
                
                
                card:override_suit(_suit)
            return true end }))
        end

        delay(0.2)
        
        for i=1, #G.hand.highlighted do
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
        
    end
}