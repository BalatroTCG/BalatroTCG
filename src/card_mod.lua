
local calculate_joker_ref = Card.calculate_joker

function Card:calculate_joker(context)
    
    if self.ability.set ~= "Joker" or not BalatroTCG.GameActive then
        return calculate_joker_ref(self, context)
    end

    if self.debuff then return nil end
    
    if self.ability.set == "Joker" then
        if context.selling_self then
        elseif context.tcg_take_damage and not context.blueprint then

            if self.ability.name == 'Cloud 9' then
                
                return {
                    reduce = math.floor(self.ability.nine_tally / self.ability.extra)
                }
            end
            if self.ability.name == 'Golden Joker' then
                
                return {
                    reduce = self.ability.extra
                }
            end
            if self.ability.name == 'Mr. Bones' then
                
                local count = 0

                for k, v in ipairs(G.jokers.cards) do
                    if v.ability.name == 'Mr. Bones' then count = count + 1 end
                end
                return {
                    percent = (self.ability.extra * count) / 100.0
                }
            end
            if self.ability.name == 'Matador' then
                
                return {
                    redirect = self,
                }
            end
        elseif context.placed_in_deck then
        elseif context.buying_card then
        elseif context.selling_card then
        elseif context.playing_card_added and not self.getting_sliced then
        elseif context.first_hand_drawn then
        elseif context.setting_blind and not self.getting_sliced then
            if self.ability.name == 'Chicot' and not context.blueprint then
        
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    for k, v in ipairs(G.jokers.cards) do
                        self:juice_up(0.3, 0.4)
                        play_sound('tarot1')
                        v:set_tcg_health((v.ability.health_amount or 0) + self.ability.extra)
                        delay(0.4)
                    end
                    return true end
                }))
                return nil
            end
            if self.ability.name == 'Riff-raff' and not (context.blueprint_card or self).getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                local jokers_to_create = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
                
                for k, v in ipairs(G.deck.cards) do
                    if v.ability.set == 'Joker' and not (
                        v.config.center.no_pool_flag and G.GAME.pool_flags[v.config.center.no_pool_flag] or
                        v.config.center.yes_pool_flag and not G.GAME.pool_flags[v.config.center.yes_pool_flag]
                    ) then
                        G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                            v.area:remove_card(v)
                            G.jokers:emplace(v)
                            v:add_to_deck()
                            G.GAME.joker_buffer = 0
                            return true end }))
                        delay(0.6)
                        break
                    end
                end

                return nil
            end
            if self.ability.name == 'Cartomancer' and not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                
                if pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard}, G.consumeables) then
                    play_sound('timpani')
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        G.GAME.consumeable_buffer = 0
                        return true end }))
                end
                
                return nil
            end
        elseif context.destroying_card and not context.blueprint then
            if self.ability.name == 'Sixth Sense' and #context.full_hand == 1 and context.full_hand[1]:get_id() == 6 and G.GAME.current_round.hands_played == 0 then
                
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        
                    if pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard}, G.consumeables) then
                        play_sound('timpani')
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                            G.GAME.consumeable_buffer = 0
                            return true end }))
                        delay(0.6)
                        card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
                    end
                end
               return true
            end
            if self.ability.name == 'Rough Gem' and self.ability.destroy then
                for k, v in ipairs(self.ability.destroy) do
                    if v == context.destroying_card then
                        table.remove(self.ability.destroy, k)
                        return true
                    end
                end
            end
        elseif context.cards_destroyed then
        elseif context.remove_playing_cards then
        elseif context.using_consumeable then
            if self.ability.name == 'Fortune Teller' and not context.blueprint and (context.consumeable.ability.set == "Tarot") then
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={G.GAME.consumeable_usage_total.tarot * self.ability.extra}}}); return true
                    end}))
                return nil, true
            end
        elseif context.pre_discard then
            if self.ability.name == 'Square Joker' and #context.full_hand == 4 and not context.blueprint then
                SMODS.scale_card(self, {
                    ref_table = self.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chip_mod",
                })
            end
        elseif context.discard then
            if self.ability.name == 'Trading Card' and not BalatroTCG.Unbalance and not context.blueprint and G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
                return {
                    delay = 0.45, 
                    remove = true,
                    card = self
                }
            end
            if self.ability.name == 'Castle' and self.ability.tcg_extra.suit then
                if not context.other_card.debuff and context.other_card:is_suit(G.GAME.current_round.castle_card.suit) and not context.blueprint then
                    self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.chip_mod
                    
                    return {
                        message = localize('k_upgrade_ex'),
                        card = self,
                        colour = G.C.CHIPS
                    }
                else
                    return nil
                end
            end
            if self.ability.name == 'Mail-In Rebate' and self.ability.tcg_extra.rank then
                if not context.other_card.debuff and context.other_card:get_id() == self.ability.tcg_extra.rank then
                    ease_dollars(self.ability.extra)
                    return {
                        message = localize('$')..self.ability.extra,
                        colour = G.C.MONEY,
                        card = self
                    }
                else
                    return nil
                end
            end
            if self.ability.name == 'Hit the Road' and self.ability.tcg_extra.rank then
                if not context.other_card.debuff and context.other_card:get_id() == self.ability.tcg_extra.rank and not context.blueprint then
                    self.ability.x_mult = self.ability.x_mult + self.ability.extra
                    return {
                        message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                            colour = G.C.RED,
                            delay = 0.45, 
                        card = self
                    }
                else
                    return nil
                end
            end
            if self.ability.name == 'Red Card' and context.other_card == context.full_hand[#context.full_hand] then
                local face_cards = 0
                for k, v in ipairs(context.full_hand) do
                    if not v:is_playing_card() then face_cards = face_cards + 1 end
                end
                if face_cards >= self.ability.cards then
                    SMODS.scale_card(self, {
                        ref_table = self.ability,
                        ref_value = "mult",
                        scalar_value = "extra",
                        message_key = 'a_mult',
                        message_colour = G.C.RED
                    })
                end
            end
        elseif context.end_of_round then
            if context.repetition then
            elseif context.individual then
                if self.ability.name == 'Flash Card' and not context.blueprint then
                    if not context.other_card:is_playing_card() then
                        self.ability.mult = self.ability.mult + self.ability.extra
                        
                        SMODS.calculate_effect({ message = localize({type='variable',key='a_mult',vars={self.ability.extra}}), colour = G.C.RED}, context.other_card)
                    end
                end
            elseif not context.blueprint then
                if self.ability.name == 'Campfire' then
                    if self.ability.x_mult - self.ability.reduce < 1 then 
                        return nil
                    else
                        self:juice_up(0.3, 0.4)
                        play_sound('timpani')
                        self.ability.x_mult = self.ability.x_mult - self.ability.reduce
                    end
                end
                if self.ability.name == 'Rocket' then
                    local amount = self.ability.extra.dollars
                    ease_dollars(amount)

                    SMODS.scale_card(self, {
                        ref_table = self.ability.extra,
                        ref_value = "dollars",
                        scalar_value = "increase",
                        message_colour = G.C.MONEY
                    })
                    if self.ability.extra.dollars > self.ability.extra.limit then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                play_sound('tarot1')
                                self:start_dissolve()
                                return true
                            end
                        })) 
                    end
                end
                if self.ability.name == 'Mr. Bones' then
                    return nil
                end
            end
        elseif context.individual then
            
            if context.cardarea == G.play then

                if self.ability.name == 'Photograph' then
                    local first_face = nil
                    for i = #context.scoring_hand, 1, -1 do
                        if context.scoring_hand[i]:is_face() then first_face = context.scoring_hand[i]; break end
                    end
                    if context.other_card == first_face then
                        return {
                            x_mult = self.ability.extra,
                            colour = G.C.RED,
                            card = self
                        }
                    else
                        return nil
                    end
                end
                if self.ability.name == 'The Idol' then
                    local suit = self.ability.tcg_extra.suit or G.GAME.current_round.idol_card.suit
                    local rank = self.ability.tcg_extra.rank or G.GAME.current_round.idol_card.id

                    if context.other_card:get_id() == rank and context.other_card:is_suit(suit) then
                        return {
                            x_mult = self.ability.extra,
                            colour = G.C.RED,
                            card = self
                        }
                    else
                        return nil
                    end
                end
                if self.ability.name == 'Golden Ticket' and
                    context.other_card.ability.name == 'Gold Card' then
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
                        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                        return {
                            dollars = self.ability.extra,
                            card = self
                        }
                end
                if self.ability.name == 'Business Card' then
                    if context.other_card:is_face() and pseudorandom('business') < G.GAME.probabilities.normal/self.ability.extra then
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 2
                        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                        return {
                            dollars = 2,
                            card = self
                        }
                    else
                        return nil
                    end
                end
                if self.ability.name == 'Rough Gem' then
                    local suit = self.ability.tcg_extra.suit or "Diamonds"
                    
                    if context.other_card:is_suit(suit) then
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra.gain
                        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))

                        return {
                            dollars = self.ability.extra.gain,
                            card = self,
                        }
                    end
                end
                if self.ability.name == 'Onyx Agate' then
                    local suit = self.ability.tcg_extra.suit or "Clubs"

                    if context.other_card:is_suit(suit) then
                        return {
                            mult = self.ability.extra,
                            card = self
                        }
                    else
                        return nil
                    end
                end
                if self.ability.name == 'Arrowhead' then
                    local suit = self.ability.tcg_extra.suit or "Spades"
                    if context.other_card:is_suit(suit) then
                        return {
                            chips = self.ability.extra,
                            card = self
                        }
                    else
                        return nil
                    end
                end
                if self.ability.name ==  'Bloodstone' then
                    local suit = self.ability.tcg_extra.suit or "Hearts"

                    if context.other_card:is_suit(suit) and pseudorandom('bloodstone') < G.GAME.probabilities.normal/self.ability.extra.odds then
                        return {
                            x_mult = self.ability.extra.Xmult,
                            card = self
                        }
                    else
                        return nil
                    end
                end
                if self.ability.name == 'Ancient Joker' and self.ability.tcg_extra.suit then
                    if context.other_card:is_suit(self.ability.tcg_extra.suit) then
                        return {
                            x_mult = self.ability.extra,
                            card = self
                        }
                    else
                        return nil
                    end
                end
            end
            if context.cardarea == G.hand then
            end
        elseif context.repetition then
            if context.cardarea == G.play then
                if self.ability.name == 'Dusk' then
                    if G.GAME.dollars <= self.ability.extra then
                        return {
                            message = localize('k_again_ex'),
                            repetitions = 1,
                            card = self
                        }
                    else
                        return nil
                    end
                end
            end
            if context.cardarea == G.hand then
            end
        elseif context.other_joker then
        elseif context.debuffed_hand then
        else
            if context.cardarea == G.jokers then
                if context.before then
                    if self.ability.name == 'Obelisk' and not context.blueprint and not BalatroTCG.Unbalance then
                        local reset = true
                        local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
                        for k, v in pairs(G.GAME.hands) do
                            if k ~= context.scoring_name and v.played >= play_more_than and SMODS.is_poker_hand_visible(k) then
                                reset = false
                            end
                        end
                        if reset then
                            if self.ability.x_mult > 1 then
                                self.ability.x_mult = 1
                                return {
                                    card = self,
                                    message = localize('k_reset')
                                }
                            end
                        else
                            self.ability.x_mult = self.ability.x_mult * self.ability.extra
                        end
                    end
                elseif context.after then
                elseif context.joker_main then
                    
                    if self.ability.name == 'Abstract Joker' then
                        local x = 0
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i].ability.set == 'Joker' then x = x + 1 end
                        end
                        x = x + BalatroTCG.Status_Current.status.opponent_jokers
                        return {
                            message = localize{type='variable',key='a_mult',vars={x*self.ability.extra}},
                            mult_mod = x*self.ability.extra
                        }
                    end
                    if self.ability.name == 'Fortune Teller' and G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot > 0 then
                        return {
                            message = localize{type='variable',key='a_mult',vars={G.GAME.consumeable_usage_total.tarot * self.ability.extra}},
                            mult_mod = G.GAME.consumeable_usage_total.tarot * self.ability.extra
                        }
                    end
                    if self.ability.name == 'Acrobat' then
                        local xmult = (BalatroTCG.Status_Current.status.round - 1) * self.ability.scaling + self.ability.initial
                        
                        if xmult > 1 then
                            return {
                                message = localize{type='variable',key='a_xmult',vars={xmult}},
                                Xmult_mod = xmult
                            }
                        else
                            return nil
                        end
                    end
                    if self.ability.name == 'Matador' then
                        return nil
                    end
                    if self.ability.name == 'Supernova' then
                        return {
                            message = localize{type='variable',key='a_mult',vars={G.GAME.hands[context.scoring_name].played * self.ability.extra}},
                            mult_mod = G.GAME.hands[context.scoring_name].played
                        }
                    end
                    if self.ability.name == 'Vagabond' then

                        if G.GAME.dollars <= self.ability.extra and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                            if pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard}, G.consumeables) then
                                
                            end
                            play_sound('timpani')
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                                G.GAME.consumeable_buffer = 0
                                return true end }))

                            return {
                                message = localize('k_plus_tarot'),
                                card = self
                            }
                        end
                        

                        return nil
                    end
                    if self.ability.name == 'Superposition' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        local aces = 0
                        for i = 1, #context.scoring_hand do
                            if context.scoring_hand[i]:get_id() == 14 then aces = aces + 1 end
                        end
                        if aces >= 1 and next(context.poker_hands["Straight"]) then
                            
                            if pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard}, G.consumeables) then
                                play_sound('timpani')
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                                    G.GAME.consumeable_buffer = 0
                                    return true end }))
                                return {
                                    message = localize('k_plus_tarot'),
                                    card = self
                                }
                            end
                        end
                        return nil
                    end
                    if self.ability.name == 'Seance' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        if next(context.poker_hands[self.ability.extra.poker_hand]) then
                            if pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard}, G.consumeables) then
                                play_sound('timpani')
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                                    G.GAME.consumeable_buffer = 0
                                    return true end }))
                                return {
                                    message = localize('k_plus_spectral'),
                                    colour = G.C.SECONDARY_SET.Spectral,
                                    card = self
                                }
                            end
                        end
                        return nil
                    end
                    if self.ability.name == 'Swashbuckler' and self.ability.mult > 0 then
                        return {
                            message = localize{type='variable',key='a_mult',vars={self.ability.mult + BalatroTCG.Status_Current.status.opponent_joker_cost}},
                            mult_mod = self.ability.mult
                        }
                    end
                    if self.ability.name == 'Card Sharp' then
                        
                        local ret = nil

                        if BalatroTCG.Status_Current.status.last_hand and context.scoring_name == BalatroTCG.Status_Current.status.last_hand then
                            ret = {
                                message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}},
                                Xmult_mod = self.ability.extra.Xmult,
                            }
                        end

                        return ret
                    end

                end
            end
        end
    end
    
    return calculate_joker_ref(self, context)
end

function modified_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    if not BalatroTCG.UseTCG_UI then return end

    for i = #desc_nodes, 1, -1 do
        table.remove(desc_nodes, i)
    end
    localize { type = 'descriptions', set = "Joker", key = card.config.center.key .. '_tcg', vars = specific_vars or {}, nodes = desc_nodes }
end
function modified_desc_spec(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    if not BalatroTCG.UseTCG_UI then return end

    for i = #desc_nodes, 1, -1 do
        table.remove(desc_nodes, i)
    end
    localize { type = 'descriptions', set = "Spectral", key = card.config.center.key .. '_tcg', vars = specific_vars or {}, nodes = desc_nodes }
end
function modified_desc_enh(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    
    if not card then
        --card = { ability = copy_table(self.config), fake_card = true }
    end
    
    local key = ""
    if card then
        key = card.config.center.key
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    else
        return
    end

    if not BalatroTCG.UseTCG_UI then return end

    for i = #desc_nodes, 1, -1 do
        table.remove(desc_nodes, i)
    end
    localize { type = 'descriptions', set = "Enhanced", key = key .. '_tcg', vars = specific_vars or {}, nodes = desc_nodes }
end

local set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)

    set_ability(self, center, initial, delay_sprites)
    
    if not BalatroTCG.UseTCG_UI then return end
    
    local name = self.ability.name


    if self.tcg_modify and type(obj.tcg_modify) == 'function' then
        self:tcg_modify()
    elseif self.ability.set == 'Enhanced' then
        if not BalatroTCG.Unbalance then
            if name == 'Gold Card' then
                self.config.center.no_suit = true
                self.config.center.no_rank = true
                self.config.center.replace_base_card = true
                self.config.center.generate_ui = modified_desc_enh
            elseif name == 'Lucky Card' then
                self.ability.p_dollars = 10
            elseif name == 'Steel Card' then
                self.ability.h_x_mult = 1.25
            end
        end
    elseif self.ability.set == 'Tarot' then
        if not BalatroTCG.Unbalance then
        end
    elseif self.ability.set == 'Spectral' then
        if name == 'The Soul' or name == 'Wraith' then
            self.config.center.generate_ui = modified_desc_spec
        end
        
    elseif self.ability.set == 'Planet' then
    elseif self.ability.set == 'Joker' then
        
        if not BalatroTCG.Unbalance then
            if name == 'Joker' then
                self.base_cost = 1
                self.ability.mult = 5
            elseif self.ability.effect == "Type Mult" or self.ability.effect == "Suit Mult" or (self.ability.t_chips > 0) then
                self.base_cost = self.base_cost - 2

                if name == 'Greedy Joker' or name == 'Lusty Joker' or name == 'Wrathful Joker' or name == 'Gluttonous Joker' then
                    self.ability.s_mult = 5
                elseif name == 'Jolly Joker' then
                    self.ability.t_mult = 10
                elseif name == 'Zany Joker' then
                    self.ability.t_mult = 15
                elseif name == 'Mad Joker' then
                    self.ability.t_mult = 12
                elseif name == 'Crazy Joker' then
                    self.ability.t_mult = 30
                elseif name == 'Droll Joker' then
                    self.ability.t_mult = 15
                elseif name == 'Sly Joker' then
                    self.ability.t_chips = 100
                elseif name == 'Wily Joker' then
                    self.ability.t_chips = 150
                elseif name == 'Clever Joker' then
                    self.ability.t_chips = 150
                elseif name == 'Devious Joker' then
                    self.ability.t_chips = 300
                elseif name == 'Crafty Joker' then
                    self.ability.t_chips = 120
                end

            elseif name == 'Brainstorm' then
                self.base_cost = 8

            -- Chips
            elseif name == 'Banner' then
                self.ability.extra = 100
            elseif name == 'Castle' then
                self.ability.extra.chip_mod = 12
            elseif name == 'Stuntman' then
                self.ability.extra.chip_mod = 500
            elseif name == 'Wee Joker' then
                self.ability.extra.chip_mod = 18
            elseif name == 'Odd Todd' then
                self.ability.extra = 75
            elseif name == 'Runner' then
                self.ability.extra.chip_mod = 40
            elseif name == 'Ice Cream' then
                self.ability.extra.chips = 200
                self.ability.extra.chip_mod = 40
            elseif name == 'Hiker' then
                self.ability.extra = 12
            elseif name == 'Square Joker' then
                self.ability.extra.chip_mod = 8
            elseif name == 'Bull' then
                self.ability.extra = 50
            elseif name == 'Blue Joker' then
                self.ability.extra = 4
            
            -- Mult
            elseif name == 'Green Joker' then
                self.ability.extra.hand_add = 4
                self.ability.extra.discard_sub = 4
            elseif name == 'Ride the Bus' then
                self.ability.extra = 4
            elseif name == 'Abstract Joker' then
                self.ability.extra = 6
            elseif name == 'Even Steven' then
                self.ability.extra = 6
            elseif name == 'Popcorn' then
                self.ability.mult = 30
                self.ability.extra = 5
            elseif name == 'Fibonacci' then
                self.ability.extra = 13
            elseif name == 'Fortune Teller' then
                self.ability.extra = 5
            elseif name == 'Bootstraps' then
                self.ability.extra.mult = 5
            elseif name == 'Supernova' then
                self.ability.extra = 8

            -- XMult
            elseif name == 'Loyalty Card' then
                self.ability.extra.Xmult = 10
            elseif name == 'Steel Joker' then
                self.ability.extra = 0.5
            elseif name == 'Blackboard' then
                self.ability.extra = 5
            elseif name == 'Cavendish' then
                self.ability.extra = {
                    Xmult = 10,
                    odds = 1000,
                }
            elseif name == 'Constellation' then
                self.ability.extra = 0.5
            elseif name == 'Madness' then
                self.ability.extra = 2
            elseif name == 'Vampire' then
                self.ability.extra = 0.5
            elseif name == 'Hologram' then
                self.ability.extra = 0.5
            elseif name == 'Obelisk' then
                self.ability.extra = 1.5
                self.config.center.generate_ui = modified_desc
            elseif name == 'Ramen' then
                self.ability.extra = 0.1
            elseif name == 'Photograph' then
                self.config.center.generate_ui = modified_desc
            elseif name == 'Lucky Cat' then
                self.ability.extra = 0.5
            elseif name == 'Throwback' then
                self.config.center.generate_ui = modified_desc
            elseif name == "Driver's License" then
                self.ability.extra = 10
            elseif name == 'Hit The Road' then
                self.ability.extra = 2
            elseif name == 'Flower Pot' then
                self.ability.extra = 10
            elseif name == 'The Duo' then
                self.ability.x_mult = 3
            elseif name == 'The Trio' then
                self.ability.x_mult = 4
            elseif name == 'The Family' then
                self.ability.x_mult = 5
            elseif name == 'The Order' then
                self.ability.x_mult = 10
            elseif name == 'The Tribe' then
                self.ability.x_mult = 3
            elseif name == 'Caino' then
                self.ability.extra = 5
            elseif name == 'Baseball Card' then
                self.ability.extra = 2
            elseif name == 'Yorick' then
                self.ability.extra.xmult = 2.5

            -- Trigger XMult
            elseif name == 'Bloodstone' then
                self.ability.extra = {
                    Xmult = 1.25,
                    odds = 2,
                }
            elseif name == 'Idol' then
                self.config.center.generate_ui = modified_desc
            elseif name == 'Baron' then
                self.ability.extra = 1.25

            -- Econ
            elseif name == 'Rough Gem' then
                self.ability.extra = {
                    gain = 1,
                    odds = 2,
                }
            elseif name == 'Vagabond' then
                self.ability.extra = 10
            elseif name == 'Golden Ticket' then
                self.ability.extra = 3

            -- Misc
            elseif name == 'Merry Andy' then
                self.ability.d_size = 2
            elseif name == 'Oops! All 6s' then
                self.base_cost = 7
            elseif name == 'Burglar' then
                self.ability.extra = 2
            elseif name == 'Trading Card' then
                self.config.center.generate_ui = modified_desc
            end
        end

        if name == 'Red Card' then
            self.ability.extra = 10
            self.ability.cards = 3
            self.config.center.generate_ui = modified_desc
        elseif name == 'Rocket' then
            self.ability.extra.dollars = 2
            self.ability.extra.increase = 4
            self.ability.extra.limit = 14
            self.config.center.generate_ui = modified_desc
        elseif name == 'Flash Card' then
            self.ability.extra = 1
            self.config.center.generate_ui = modified_desc
        elseif name == 'Acrobat' then
            self.ability.scaling = 0.5
            self.ability.initial = 1
            self.config.center.generate_ui = modified_desc
        elseif name == 'Campfire' then
            self.ability.extra = 2
            self.ability.reduce = 1
            self.config.center.generate_ui = modified_desc
        elseif name == 'Vagabond' then
            self.config.center.generate_ui = modified_desc
        elseif name == 'Square Joker' then
            self.config.center.generate_ui = modified_desc
        elseif name == 'Dusk' then
            self.ability.extra = 10
            self.config.center.generate_ui = modified_desc
        elseif name == 'Cloud 9' then
            self.ability.extra = 4
            self.config.center.generate_ui = modified_desc
        elseif name == 'Golden Joker' then
            self.ability.extra = 1
            self.config.center.generate_ui = modified_desc
        elseif name == 'Mr. Bones' then
            self.ability.extra = 5
            self.config.center.generate_ui = modified_desc
        elseif name == 'Chicot' then
            self.ability.extra = 3
            self.config.center.generate_ui = modified_desc
        elseif name == 'Showman' then
            self.config.center.generate_ui = modified_desc
        elseif name == 'Riff-Raff' then
            self.ability.extra = 1
        elseif name == 'Matador' then
            self.config.center.eternal_compat = false
            self.config.center.blueprint_compat = false
            self.config.center.generate_ui = modified_desc
        end
    end
end

function TCG_Override_Desc(self, loc_vars)
    if not self.ability.tcg_extra then return loc_vars end
    
    local money_power = (math.log(G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / math.log(2)) + 1

    if self.ability.name == 'Ancient Joker' and self.ability.tcg_extra.suit then loc_vars = {self.ability.extra, localize(self.ability.tcg_extra.suit, 'suits_singular'), colours = {G.C.SUITS[self.ability.tcg_extra.suit]}}
    elseif self.ability.name == 'Campfire' then loc_vars = {self.ability.extra, self.ability.reduce, self.ability.x_mult}
    elseif self.ability.name == 'Acrobat' then loc_vars = { self.ability.scaling, ((BalatroTCG.Status_Current and (BalatroTCG.Status_Current.status.round - 1) or 0) * self.ability.scaling + self.ability.initial)}
    elseif self.ability.name == 'Red Card' then loc_vars = { self.ability.extra, self.ability.cards, self.ability.mult }
    elseif self.ability.name == 'Rocket' then loc_vars = {self.ability.extra.dollars, self.ability.extra.increase, self.ability.extra.limit}
    elseif self.ability.name == 'Fortune Teller' then loc_vars = {self.ability.extra, (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0) * self.ability.extra}    
    elseif self.ability.name == 'Superposition' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Cloud 9' then loc_vars = {self.ability.extra, math.floor((self.ability.nine_tally or 0) / self.ability.extra)}
    elseif self.ability.name == 'Blue Joker' then loc_vars = {self.ability.extra, self.ability.extra*((G.deck and G.deck.cards) and #G.deck.cards or 60)}
    elseif self.ability.name == 'Chicot' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Golden Joker' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Dusk' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Mr. Bones' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Swashbuckler' then loc_vars = {self.ability.mult + (BalatroTCG.Status_Current and BalatroTCG.Status_Current.status.opponent_joker_cost or 0)}

    end

    return loc_vars
end

function Card:set_tcg_max_health(_amount) 
    if not self.ability.eternal then
        self.ability.has_health = true
        self.ability.health_amount = _amount
        self.ability.max_health = _amount
    end
end
function Card:set_tcg_health(_amount) 
    if not self.ability.eternal then
        if _amount <= 0 then
            self:start_dissolve()
        else
            self.ability.has_health = true
            self.ability.health_amount = math.min(_amount, self.ability.max_health or 25)
        end
    end
end
function Card:remove_tcg_health(_amount) 
    if not self.ability.eternal then
        self:set_tcg_health((self.ability.health_amount or 0) - _amount)

    end
end