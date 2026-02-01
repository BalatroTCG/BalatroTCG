BalatroTCG.ConsumeableMod {
    key_override = 'c_hex',
    
    use_consumeable = function(self, area, copier, balanced, original_func)
        
        local card = pseudorandom_element(self.eligible_editionless_jokers, pseudoseed('hex'))
        
        if card then
            G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()

                card:set_perishable(true)
                card:set_edition({polychrome = true}, true)

                return true end }))
        end
        
    end
}