BalatroTCG.ConsumeableMod {
    key_override = 'c_hex',
    
    use_consumeable = function(self, area, copier, balanced, original_func)
        
        local copyable_jokers = {}
        for i, v in ipairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and not v.edition or v.edition.type ~= "mp_phantom" then copyable_jokers[#copyable_jokers + 1] = v end
        end
        for i, v in ipairs(G.consumeables.cards) do
            if v.ability.set == 'Joker' and not v.edition or v.edition.type ~= "mp_phantom" then copyable_jokers[#copyable_jokers + 1] = v end
        end
        local chosen_joker = pseudorandom_element(copyable_jokers, pseudoseed('ankh_choice'))
        
        if not balanced then
            local deletable_jokers = {}
            for k, v in pairs(G.jokers.cards) do
                if v.ability.set == 'Joker' and not SMODS.is_eternal(v, self) then deletable_jokers[#deletable_jokers + 1] = v end
            end
            for k, v in pairs(G.consumeables.cards) do
                if v.ability.set == 'Joker' and not SMODS.is_eternal(v, self) then deletable_jokers[#deletable_jokers + 1] = v end
            end
            G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.75, func = function()
                for k, v in pairs(deletable_jokers) do
                    if v ~= chosen_joker then 
                    v.getting_sliced = true
                        v:start_dissolve(nil, _first_dissolve)
                        _first_dissolve = true
                    end
                end
                return true end }))
        end
        G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()
            local card = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative)
            card:start_materialize()
            card:add_to_deck()
            card.tcg_extra.virtual = true
            if balanced then
                card:set_rental(true)
            end

            if card.edition and card.edition.negative then
                card:set_edition(nil, true)
            end
            G.jokers:emplace(card)
            return true end }))
        
    end
}