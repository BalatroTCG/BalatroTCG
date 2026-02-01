BalatroTCG.DeckData {
    key_override = 'b_ghost',
    icon_pos = {x = 0, y = 8},
    background = {
        main = HEX("d9c357"),
        tertiary = HEX("7aa4f2"),
        special = HEX("283379"),

        contrast = 1.2,
    },
    ui = {
        main = HEX("d9c357"),
        secondary = HEX("2e4061"),
    },
    bg_particles = {
        {
            timer = 0.015,
            scale = 0.1,
            lifespan = 3,
            speed = 0.2,
            padding = -1,
            colours = {G.C.WHITE, lighten(G.C.GOLD, 0.2)},
            fill = true
        }
    },
    get_cost = function(full_list) return 5; end,
    calculate_context = function(context)
        if context.setting_blind and not context.cardarea and context.status.status.round == 1 then
            for i = 1, 1 do
                
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
                        return true
                    end
                    }))
                end

            end
        end
    end
}