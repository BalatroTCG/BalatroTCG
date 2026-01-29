BalatroTCG.DeckData {
    key_override = 'b_magic',
    icon_pos = {x = 0, y = 6},
    background = {
        main = HEX("ffe6bc"),
        special = HEX("9074e1"),
        tertiary = HEX("1a2021"),

        contrast = 2,
    },
    ui = {
        main = HEX("9074e1"),
        secondary = HEX("402c09"),
    },
    get_params = function(self, default_params, full_list)
        default_params.starting_vouchers = {
            "v_crystal_ball",
        }
    end,
    bg_particles = {
        {
            timer = 0.015,
            scale = 0.2,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2)},
        }
    },
    calculate_context = function(context)
        if context.setting_blind and not context.cardarea and context.status.status.round == 1 then
            for i = 1, 2 do
                
                local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
                if card then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    card.area:remove_card(card)
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