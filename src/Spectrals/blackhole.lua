BalatroTCG.ConsumeableMod {
    key_override = 'c_black_hole',
    
    description_override = {
        balanced = true,
        none = false,
    },

    modify = function(self, balanced)
        
    end,
    can_use_consumeable = function(self, any_state, skip_check, balanced, original_value)
        return true
    end,
    
    loc_vars = function(card, balance)
        if balance then return { 5 } end

    end,
    use_consumeable = function(self, area, copier, balanced, original_func)
        if not balanced then return original_func(self, area, copier) end

        for i = 1, 5 do
            local card = pick_from_areas(function (c) return true end, {G.graveyard})
                
            if card then
                if card.area then card.area:remove_card(card) end

                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    card:start_materialize()
                    G.hand:emplace(card)
    
                    for _, c in ipairs(G.playing_cards) do
                        if c == card then
                            goto skip
                        end
                    end
                    table.insert(G.playing_cards, card)
                    ::skip::
                    play_sound('timpani')
                    self:juice_up(0.3, 0.5)
                    return true
                end
                }))
                delay(0.6)
            else
                break
            end

        end
    end
}