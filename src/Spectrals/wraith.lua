BalatroTCG.ConsumeableMod {
    key_override = 'c_wraith',
    
    modify = function(self, balanced)
        
    end,
    can_use_consumeable = function(self, any_state, skip_check, balanced, original_value)
        return true
    end,
    use_consumeable = function(self, area, copier, balanced, original_func)
        
        local card = pick_from_areas(function (c) return 
            (c.ability.set == 'Joker' and c.config.center.rarity >= 3 and not (
                c.config.center.no_pool_flag and G.GAME.pool_flags[c.config.center.no_pool_flag] or
                c.config.center.yes_pool_flag and not G.GAME.pool_flags[c.config.center.yes_pool_flag]
            )) end, {G.deck, G.discard, G.graveyard})
            
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
        end
    end
}