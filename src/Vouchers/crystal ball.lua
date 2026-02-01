BalatroTCG.VoucherMod {
    key_override = 'v_crystal_ball',
    
    get_cost = function(original, balanced) return 8 end,

    redeem = function(card, balanced, original_func)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
    end,

}
BalatroTCG.VoucherMod {
    key_override = 'v_omen_globe',
    
    get_cost = function(original, balanced) return 10 end,
    
    modify = function(self, balanced)
        self.config.extra = 1
    end,
    redeem = function(card, balanced, original_func)
    end,

    calculate_context = function(self, context, balanced)
        if context.setting_blind and BalatroTCG.consumeable_slots_available() > 0 then

            local card = pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard})
            if card then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                if card.area then card.area:remove_card(card) end
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    card:start_materialize()
                    G.consumeables:emplace(card)

                    for _, c in ipairs(G.playing_cards) do
                        if c == card then
                            goto skip
                        end
                    end
                    table.insert(G.playing_cards, card)
                    ::skip::
                    G.GAME.consumeable_buffer = 0
                    play_sound('timpani')
                    self:juice_up(0.3, 0.4)
                    return true
                end
                }))
            end
        end
    end
}