BalatroTCG.ConsumeableMod {
    key_override = 'c_soul',
    
    modify = function(self, balanced)
        
    end,
    can_use_consumeable = function(self, any_state, skip_check, balanced, original_value)
        for k, v in ipairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and v.config.center.eternal_compat then return true end
        end
        return false
    end,
    use_consumeable = function(self, area, copier, balanced, original_func)
        
        local applicable = {}

        for _, joker in ipairs(G.jokers.cards) do
            if joker.config.center.eternal_compat then
                table.insert(applicable, joker)
            end
        end

        if #applicable > 0 then
            local card = pseudorandom_element(applicable, pseudoseed('soul'))
            self:juice_up(0.3, 0.5)
            play_sound('gold_seal', 1.2, 0.4)
            card:set_eternal(true)
            card:set_rental(true)
        end
        
    end
}