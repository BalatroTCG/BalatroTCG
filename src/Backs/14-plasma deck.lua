BalatroTCG.DeckData {
    key_override = 'b_plasma',
    icon_pos = {x = 0, y = 14},
    background = {
        main = HEX("f7c7d1"),
        tertiary = HEX("a3629c"),
        special = HEX("0f1f4a"),

        contrast = 1,
    },
    ui = {
        main = HEX("d9869d"),
        secondary = HEX("2c3967"),
    },
    get_cost = function(self) return 10; end,
    calculate_context = function(context)
        if context.context == 'final_scoring_step' then
            local tot = context.chips + context.mult
            context.chips = math.floor(tot/2)
            context.mult = math.floor(tot/2)
            update_hand_text({delay = 0}, {mult = context.mult, chips = context.chips})

            G.E_MANAGER:add_event(Event({
                func = (function()
                    local text = localize('k_balanced')
                    play_sound('gong', 0.94, 0.3)
                    play_sound('gong', 0.94*1.5, 0.2)
                    play_sound('tarot1', 1.5)
                    ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
                    ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
                    attention_text({
                        scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        delay =  4.3,
                        func = (function() 
                                ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                                ease_colour(G.C.UI_MULT, G.C.RED, 2)
                            return true
                        end)
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        no_delete = true,
                        delay =  6.3,
                        func = (function() 
                            G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                            G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                            return true
                        end)
                    }))
                    return true
                end)
            }))

            delay(0.6)
            return {
                chips = context.chips,
                mult = context.mult
            }
        elseif context.damaging then
            context.damage = math.floor(context.damage * .75)
        end
    end
}