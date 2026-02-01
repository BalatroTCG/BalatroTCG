BalatroTCG.ConsumeableMod {
    key_override = 'c_death',
    
    modify = function(self, balanced)
        
    end,
    use_consumeable = function(self, area, copier, balanced, original_func)
        
        local rightmost = G.hand.highlighted[1]
        local leftmost = G.hand.highlighted[1]

        original_func(self, area, copier)
        
        if leftmost.children.use_button then
            leftmost.children.use_button:remove()
            leftmost.children.use_button = nil
        end
        leftmost.tcg_extra.has_health = nil
        leftmost.ability.tcgb_health_amount = nil
        leftmost.ability.tcgb_max_health = nil
    end
}