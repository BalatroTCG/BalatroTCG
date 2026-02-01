BalatroTCG.JokerMod {
    key_override = 'j_satellite',
    
    modify = function(self, balanced)
        if balanced then self.eternal_compat = false end
    end,
    calculate_context = function(self, context, balanced)
        if context.tcg_take_damage and not context.blueprint then
            local planets_used = 0
            for k, v in pairs(G.GAME.consumeable_usage) do
                if v.set == 'Planet' then planets_used = planets_used + 1 end
            end
            
            if planets_used == 0 then return end

            return {
                reduce = planets_used
            }
        end
        
    end
}