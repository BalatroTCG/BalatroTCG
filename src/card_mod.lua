
local calculate_joker_ref = Card.calculate_joker

function Card:override_rank(rank)
    if self.tcg_extra then
        self.tcg_extra.rank = rank
    end
end

function Card:override_suit(suit)
    if self:is_playing_card() then
                            
        assert(SMODS.change_base(self, suit.key))
    elseif self.ability.set == 'Tarot' then
        if suit.card_key == 'S' then
            self:set_ability(G.P_CENTERS.c_world)
        elseif suit.card_key == 'H' then
            self:set_ability(G.P_CENTERS.c_sun)
        elseif suit.card_key == 'D' then
            self:set_ability(G.P_CENTERS.c_star)
        elseif suit.card_key == 'C' then
            self:set_ability(G.P_CENTERS.c_moon)
            --TARGET: Sigil changing tarot suits
        end
    elseif self.tcg_extra then
        self.tcg_extra.suit = suit
    end
end

function Card:get_ability_rank(default)
    if self.tcg_extra.rank then
        return self.tcg_extra.rank.key
    end
    return default
end
function Card:get_ability_id(default)
    if self.tcg_extra.rank then
        return self.tcg_extra.rank.id
    end
    return default
end
function Card:get_ability_suit(default)
    if self.tcg_extra.suit then
        return self.tcg_extra.suit.key
    end
    return default
end

function Card:is_rank_joker(ranks)
	if self.ability.effect == "Stone Card" or SMODS.has_no_rank(self) then return false end

    if type(ranks) ~= 'table' then ranks = {ranks} end
    if BalatroTCG.GameActive then
        
        for k, v in ipairs(BalatroTCG.Status_Current.backs) do

            -- Find a way to make this not hard coded.
            if v.name == 'b_mp_gradient' then
		        local temp = {}
                for i, v in ipairs(ranks) do
                    temp[v - 1] = true
                    temp[v] = true
                    if BalatroTCG.Settings.Unbalance then
                        temp[v + 1] = true
                    end
                end
        
                ranks = {}
                for k, v in pairs(temp) do
                    if k == 15 then
                        k = 2
                    elseif k == 1 then
                        k = 14
                    end

                    table.insert(ranks, k)
                end
            end

        end
    end

    for _, r in ipairs(ranks) do
        if self:get_id() == r then return true end
    end
    return false
end

local use_consumeable_ref = Card.use_consumeable
function Card:use_consumeable(area, copier)
    
    if BalatroTCG.GameActive then
        if self.ability.queue_negative_removal then
            if area then
                area.config.card_limit = area.config.card_limit - 1
            end
        end

        stop_use()
        
        if not copier then set_consumeable_usage(self) end

        if self.ability.set == 'Planet' then
            if not BalatroTCG.Status_Current.params.destroy_planets or next(SMODS.find_card('j_astronomer')) then self.tcg_todeck = true end
        elseif self.ability.set == 'Tarot' then
            if not BalatroTCG.Status_Current.params.destroy_tarots or next(SMODS.find_card('j_cartomancer')) then self.tcg_todeck = true end
        elseif self.ability.set == 'Spectral' then
            if not BalatroTCG.Status_Current.params.destroy_spectrals then self.tcg_todeck = true end
        end

        if self.debuff then return nil end
        local used_tarot = copier or self
        local obj = self.config.center
        
        if obj.tcg_use and type(obj.tcg_use) == 'function' then
            obj.tcg_use(self, area, copier)
            return
        else
            
            if self.ability.set == 'Planet' then
                use_consumeable_ref(self, area, copier)
            elseif self.ability.name == 'Judgement' then
                
                local card = pick_from_areas(function (c) return 
                    (c.ability.set == 'Joker' and not (
                        c.config.center.no_pool_flag and G.GAME.pool_flags[c.config.center.no_pool_flag] or
                        c.config.center.yes_pool_flag and not G.GAME.pool_flags[c.config.center.yes_pool_flag]
                    )) end, {G.deck, G.discard, G.graveyard, G.hand})
                
                if card then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        if card.area then card.area:remove_card(card) end
                        card:start_materialize()
                        G.jokers:emplace(card)
                        
                        for _, c in ipairs(G.playing_cards) do
                            if c == card then
                                goto skip
                            end
                        end
                        card:add_to_deck()
                        table.insert(G.playing_cards, card)
                        ::skip::
                        play_sound('timpani')
                        self:juice_up(0.3, 0.5)
                        return true
                    end
                    }))
                    delay(0.6)
                end
            elseif self.ability.name == 'The Fool' then
                if G.GAME.last_tarot_planet == 'c_fool' then return end

                local center = G.P_CENTERS[G.GAME.last_tarot_planet]

                local card = pick_from_areas(function (c) return c.ability.name == center.name end, {G.deck, G.discard, G.graveyard, G.hand})
                
                if card then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        if card.area then card.area:remove_card(card) end
                        card:start_materialize()
                        G.consumeables:emplace(card)

                        for _, c in ipairs(G.playing_cards) do
                            if c == card then
                                goto skip
                            end
                        end
                        card:add_to_deck()
                        table.insert(G.playing_cards, card)
                        ::skip::
                        play_sound('timpani')
                        self:juice_up(0.3, 0.5)
                        return true
                    end
                    }))
                    delay(0.6)
                end
            elseif self.ability.name == 'Ankh' then

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
            elseif self.ability.name == 'Hex' and balanced then

                local card = pseudorandom_element(self.eligible_editionless_jokers, pseudoseed('hex'))
                
                if card then
                    G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()

                        card:set_perishable(true)
                        card:set_edition({polychrome = true}, true)

                        return true end }))
                end
                
            elseif self.ability.name == 'The Emperor' then
                
                
            elseif self.ability.name == 'Death' then
                
                
            elseif self.ability.name == 'The High Priestess' then

                for i = 1, math.min(self.ability.consumeable.planets, G.consumeables.config.card_limit - #G.consumeables.cards) do
                    local card = pick_from_areas(function (c) return c.ability.set == 'Planet' end, {G.deck, G.discard, G.graveyard, G.hand})

                    if card then
                        if card.area then card.area:remove_card(card) end
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                            card:start_materialize()
                            G.consumeables:emplace(card)

                            for _, c in ipairs(G.playing_cards) do
                                if c == card then
                                    goto skip
                                end
                            end
                            card:add_to_deck()
                            table.insert(G.playing_cards, card)
                            ::skip::
                            play_sound('timpani')
                            self:juice_up(0.3, 0.5)
                            return true
                        end
                        }))
                    end
                end
                delay(0.6)

            elseif self.ability.name == 'Immolate' and balanced then
                self.ability.extra.dollars = 0
                use_consumeable_ref(self, area, copier)

            elseif self.ability.effect == 'Suit Conversion' and not balanced then

                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    play_sound('tarot1')
                    used_tarot:juice_up(0.3, 0.5)
                    return true end }))

                for i=1, #G.hand.cards do
                    local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
                end

                local _suit = SMODS.SUITS[self.ability.suit_conv]
                for i=1, #G.hand.cards do
                    G.E_MANAGER:add_event(Event({func = function()
                        local card = G.hand.cards[i]
                        
                        card:override_suit(_suit)
                    return true end }))
                end
                
                for i=1, #G.hand.cards do
                    local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
                end
                delay(0.5)

            elseif self.ability.name == 'Sigil' or self.ability.name == 'Ouija' then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    play_sound('tarot1')
                    used_tarot:juice_up(0.3, 0.5)
                    return true end }))

                for i=1, #G.hand.cards do
                    local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
                end
                delay(0.2)
                if self.ability.name == 'Sigil' then
                    --use_consumeable_ref(self, area, copier)

                    local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('sigil'))
                    for i=1, #G.hand.cards do
                        G.E_MANAGER:add_event(Event({func = function()
                            local card = G.hand.cards[i]
                            local set = card.ability.set
                            card:override_suit(_suit)
                        return true end }))
                    end  
                end
                if self.ability.name == 'Ouija' then
                    local rank = pseudorandom_element(SMODS.Ranks, pseudoseed('ouija'))
                    for i=1, #G.hand.cards do
                        G.E_MANAGER:add_event(Event({func = function()
                            local card = G.hand.cards[i]
                            local set = card.ability.set
                            if card:is_playing_card() then
                                assert(SMODS.change_base(card, nil, rank.key))
                            else
                                card:override_rank(rank)
                            end
                        return true end }))
                    end  
                    G.hand:change_size(-1)
                end
                for i=1, #G.hand.cards do
                    local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
                end
                delay(0.5)
            
                
            elseif self.ability.name == 'Wraith' then
                
                local card = pick_from_areas(function (c) return 
                    (c.ability.set == 'Joker' and c.config.center.rarity >= 3 and not (
                        c.config.center.no_pool_flag and G.GAME.pool_flags[c.config.center.no_pool_flag] or
                        c.config.center.yes_pool_flag and not G.GAME.pool_flags[c.config.center.yes_pool_flag]
                    )) end, {G.deck, G.discard, G.graveyard})
                    
                if card then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        if card.area then card.area:remove_card(card) end
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
            elseif self.ability.name == 'The Soul' then
                
                local applicable = {}

                for _, joker in ipairs(G.jokers.cards) do
                    if joker.config.center.eternal_compat then
                        table.insert(applicable, joker)
                    end
                    joker:set_eternal(nil)
                end

                if #applicable > 0 then
                    local card = pseudorandom_element(applicable, pseudoseed('soul'))
                    used_tarot:juice_up(0.3, 0.5)
                    play_sound('gold_seal', 1.2, 0.4)
                    card:set_eternal(true)
                end
                
                local _first_dissolve = false
                for _, joker in ipairs(G.jokers.cards) do
                    if (not SMODS.is_eternal(joker, self)) then joker.getting_sliced = true; joker:start_dissolve(nil, _first_dissolve);_first_dissolve = true end
                end
            else
                use_consumeable_ref(self, area, copier)
            end
        end
    else
        use_consumeable_ref(self, area, copier)
    end
end


-- function Card:calculate_joker(context)
--     if self.ability.set ~= "Joker" or not BalatroTCG.GameActive then
--         return calculate_joker_ref(self, context)
--     end

--     if self.debuff then return nil end

--     if self.config.center.tcg_calculate and type(self.config.center.tcg_calculate) == 'function' then
--         return self.config.center.tcg_calculate(self, context)
--     end
    
--     if self.ability.set == "Joker" then

--         if context.selling_self then
--         elseif context.placed_in_deck then
--         elseif context.buying_card then
--         elseif context.selling_card then
--         elseif context.playing_card_added and not self.getting_sliced then
--         elseif context.first_hand_drawn then
--         elseif context.setting_blind and not self.getting_sliced then
--             if self.ability.name == 'Chicot' and not context.blueprint then
        
--                 G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
--                     for k, v in ipairs(G.jokers.cards) do
--                         self:juice_up(0.3, 0.4)
--                         play_sound('tarot1')
--                         v:set_tcg_health((v.ability.tcgb_health_amount or 0) + self.ability.extra)
--                         delay(0.4)
--                     end
--                     return true end
--                 }))
--                 return nil
--             end
            
--             if self.ability.name == 'Cartomancer' and not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                
--                 local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
                
--                 if card then
--                     G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
--                     G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
--                         if card.area then card.area:remove_card(card) end
--                         card:start_materialize()
--                         G.consumeables:emplace(card)

--                         for _, c in ipairs(G.playing_cards) do
--                             if c == card then
--                                 goto skip
--                             end
--                         end
--                         table.insert(G.playing_cards, card)
--                         ::skip::
--                         G.GAME.consumeable_buffer = 0
--                         play_sound('timpani')
--                         self:juice_up(0.3, 0.5)
--                         return true
--                     end
--                     }))
--                     delay(0.6)
--                 end
                
--                 return nil
--             end
--         elseif context.destroying_card and not context.blueprint then
--             if self.ability.name == 'Sixth Sense' and #context.full_hand == 1 and context.full_hand[1]:is_rank_joker(6) and G.GAME.current_round.hands_played == 0 then
                
--                 if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        
--                     local card = pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard})
                    
--                     if card then
--                         G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
--                         G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
--                             if card.area then card.area:remove_card(card) end
--                             card:start_materialize()
--                             G.consumeables:emplace(card)
                            
--                             for _, c in ipairs(G.playing_cards) do
--                                 if c == card then
--                                     goto skip
--                                 end
--                             end
--                             table.insert(G.playing_cards, card)
--                             ::skip::

--                             G.GAME.consumeable_buffer = 0
--                             play_sound('timpani')
--                             self:juice_up(0.3, 0.5)
--                             return true
--                         end
--                         }))
--                         card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
--                         delay(0.6)
--                     end
--                 end
--                 return true
--             end
--         elseif context.cards_destroyed then
--         elseif context.remove_playing_cards then
--         elseif context.using_consumeable then
--             if self.ability.name == 'Fortune Teller' and not context.blueprint and (context.consumeable.ability.set == "Tarot") then
--                 G.E_MANAGER:add_event(Event({
--                     func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={G.GAME.consumeable_usage_total.tarot * self.ability.extra}}}); return true
--                     end}))
--                 return nil, true
--             end
--         elseif context.pre_discard then
--             if self.ability.name == 'Campfire' then
--                 if self.ability.x_mult <= 1 then 
--                     return nil
--                 else
--                     self:juice_up(0.3, 0.4)
--                     play_sound('timpani')
--                     self.ability.x_mult = math.floor((self.ability.x_mult * (1 - (self.ability.reduce / 100))) * 10) / 10
--                 end
--             end
--         elseif context.discard then
--             if self.ability.name == 'Trading Card' and balanced and not context.blueprint and G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
--                 return {
--                     delay = 0.45, 
--                     remove = true,
--                     card = self
--                 }
--             end
--             if self.ability.name == 'Castle' and self.tcg_extra.suit then
--             end
--             if self.ability.name == 'Mail-In Rebate' then
--             end
--             if self.ability.name == 'Hit the Road' then
--             end
--             if self.ability.name == 'Red Card' and context.other_card == context.full_hand[#context.full_hand] then
--                 local face_cards = 0
--                 for k, v in ipairs(context.full_hand) do
--                     if not v:is_playing_card() then face_cards = face_cards + 1 end
--                 end
--                 if face_cards >= self.ability.cards then
--                     SMODS.scale_card(self, {
--                         ref_table = self.ability,
--                         ref_value = "mult",
--                         scalar_value = "extra",
--                         message_key = 'a_mult',
--                         message_colour = G.C.RED
--                     })
--                 end
--             end
--         elseif context.end_of_round then
--             if context.repetition then
--             elseif context.individual then
--                 if self.ability.name == 'Flash Card' and not context.blueprint then
--                     if not context.other_card:is_playing_card() then
--                         self.ability.mult = self.ability.mult + self.ability.extra
                        
--                         SMODS.calculate_effect({ message = localize({type='variable',key='a_mult',vars={self.ability.extra}}), colour = G.C.RED}, context.other_card)
--                     end
--                 end
--             elseif not context.blueprint then
--                 if self.ability.name == 'Rocket' then
--                 end
--                 if self.ability.name == 'Mr. Bones' then
--                     return nil
--                 end
--             end
--         elseif context.individual then
            
--             if context.cardarea == G.play then

--                 if self.ability.name == 'Photograph' then
--                 end
--                 if self.ability.name == 'The Idol' then
                    
--                 end
                
--                 if self.ability.name == 'Business Card' then
--                     if context.other_card:is_face() and pseudorandom('business') < G.GAME.probabilities.normal/self.ability.extra then
--                         G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.money
--                         G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
--                         return {
--                             dollars = self.ability.money,
--                             card = self
--                         }
--                     else
--                         return nil
--                     end
--                 end
--                 if self.ability.name == 'Rough Gem' then
--                     local suit = self:get_ability_suit("Diamonds")
                    
--                     if context.other_card:is_suit(suit) then
--                         G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
--                         G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))

--                         return {
--                             dollars = self.ability.extra,
--                             card = self,
--                         }
--                     end
--                 end
--                 if self.ability.name == 'Onyx Agate' then
--                     local suit = self:get_ability_suit("Clubs")

--                     if context.other_card:is_suit(suit) then
--                         return {
--                             mult = self.ability.extra,
--                             card = self
--                         }
--                     else
--                         return nil
--                     end
--                 end
--                 if self.ability.name == 'Arrowhead' then
--                     local suit = self:get_ability_suit("Spades")
--                     if context.other_card:is_suit(suit) then
--                         return {
--                             chips = self.ability.extra,
--                             card = self
--                         }
--                     else
--                         return nil
--                     end
--                 end
--                 if self.ability.name == 'Ancient Joker' then

--                 end
--             end
--             if context.cardarea == G.hand then
--             end
--             if context.cardarea == G.hand then
--             end
--         elseif context.other_joker then
--         elseif context.debuffed_hand then
--         else
--             if context.cardarea == G.jokers then
--                 if context.before then
--                 elseif context.after then
--                     if self.ability.name == 'Campfire' then
--                         if self.ability.x_mult <= 1 then 
--                             return nil
--                         else
--                             self:juice_up(0.3, 0.4)
--                             play_sound('timpani')
--                             self.ability.x_mult = math.floor((self.ability.x_mult * (1 - (self.ability.reduce / 100))) * 10) / 10
--                         end
--                     end
--                 elseif context.joker_main then
                    
--                     if self.ability.name == 'Abstract Joker' then
--                         local x = 0
--                         for i = 1, #G.jokers.cards do
--                             if G.jokers.cards[i].ability.set == 'Joker' then x = x + 1 end
--                         end
--                         x = x + #BalatroTCG.Status_Current.opponentJokers.cards
--                         return {
--                             message = localize{type='variable',key='a_mult',vars={x*self.ability.extra}},
--                             mult_mod = x*self.ability.extra
--                         }
--                     end
--                     if self.ability.name == 'Fortune Teller' and G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot > 0 then
--                         return {
--                             message = localize{type='variable',key='a_mult',vars={G.GAME.consumeable_usage_total.tarot * self.ability.extra}},
--                             mult_mod = G.GAME.consumeable_usage_total.tarot * self.ability.extra
--                         }
--                     end
--                     if self.ability.name == 'Acrobat' then
--                         local xmult = (BalatroTCG.Status_Current.status.round - 1) * self.ability.scaling + self.ability.initial
                        
--                         if xmult > 1 then
--                             return {
--                                 message = localize{type='variable',key='a_xmult',vars={xmult}},
--                                 Xmult_mod = xmult
--                             }
--                         else
--                             return nil
--                         end
--                     end
--                     if self.ability.name == 'Matador' then
--                         return nil
--                     end
--                     if self.ability.name == 'Supernova' then
--                     end
--                     if self.ability.name == 'Vagabond' then

--                     end
--                     if self.ability.name == 'Superposition' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
--                     end
--                     if self.ability.name == 'Seance' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
--                         if next(context.poker_hands[self.ability.extra.poker_hand]) then
--                             local card = pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard})
--                             if card then
--                                 G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
--                                 G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                                    
--                                     if card.area then card.area:remove_card(card) end
--                                     card:start_materialize()
--                                     G.consumeables:emplace(card)
                                    
--                                     for _, c in ipairs(G.playing_cards) do
--                                         if c == card then
--                                             goto skip
--                                         end
--                                     end
--                                     table.insert(G.playing_cards, card)
--                                     ::skip::

--                                     G.GAME.consumeable_buffer = 0
--                                     play_sound('timpani')
--                                     self:juice_up(0.3, 0.5)
--                                     return true
--                                 end
--                                 }))
--                                 delay(0.6)
--                                 return {
--                                     message = localize('k_plus_spectral'),
--                                     colour = G.C.SECONDARY_SET.Spectral,
--                                     card = self
--                                 }
--                             end
--                         end
--                         return nil
--                     end
--                     if self.ability.name == 'Card Sharp' then
                        
--                         local ret = nil

--                         if BalatroTCG.Status_Current.status.last_hand and context.scoring_name == BalatroTCG.Status_Current.status.last_hand then
--                             ret = {
--                                 message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}},
--                                 Xmult_mod = self.ability.extra.Xmult,
--                             }
--                         end

--                         return ret
--                     end

--                 end
--             end
--         end
--     end
    
--     return calculate_joker_ref(self, context)
-- end

local set_ability_ref = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    if BalatroTCG.UseTCG_UI then
        center = create_tcg_center(center)
        if balanced then
            center.use_original_desc = nil
        end
        -- self.config.center_key = center.key
    end

    set_ability_ref(self, center, initial, delay_sprites)
    
    if BalatroTCG.UseTCG_UI then
        self.config.center_key = center.key
    end
end

function copy_center(center)
    local funcs = {}

    local function copy_table(O)
        local O_type = type(O)
        local copy
        if O_type == 'table' then
            if funcs[O] then
                copy = funcs[O]
            else
                copy = {}
                funcs[O] = copy

                for k, v in next, O, nil do
                    copy[copy_table(k)] = copy_table(v)
                end
                setmetatable(copy, copy_table(getmetatable(O)))
            end
        else
            copy = O
        end
        return copy
    end

    funcs = {}

    return copy_table(center)
end

BalatroTCG.ModifiedCenters = {}

function reset_tcg_centers()
    for k, v in pairs(BalatroTCG.ModifiedCenters) do
        G.P_CENTERS[k] = v
    end
    BalatroTCG.ModifiedCenters = {}
end

function create_tcg_center(self)

    if self.key == 'c_base' then return self end

    if BalatroTCG.ModifiedCenters[self.key] then return G.P_CENTERS[self.key] end
    
    BalatroTCG.ModifiedCenters[self.key] = self
    
    local center = {}
    for k, v in pairs(self) do
        center[k] = v
    end
    center.config = copy_table(self.config)

    setmetatable(center, getmetatable(self))

    self = center

    self.tcg_estimate = nil
    self.tcg_calculate = nil
    
    local name = self.name

    self.cost = tcg_base_cost(self.set, name, self.cost)

    
    if self.tcg_modify and type(self.tcg_modify) == 'function' then
        self.tcg_modify(self)
    elseif self.set == 'Enhanced' then

        if balanced then
            if name == 'Gold Card' then

            elseif name == 'Lucky Card' then
                self.config.p_dollars = 20
                self.use_original_desc = true
            elseif name == 'Glass Card' then
                self.use_original_desc = true
            elseif name == 'Steel Card' then
                --self.config.h_x_mult = 1.25
            end
        end
        if name == 'Lucky Card' then
            self.use_original_desc = true
        elseif name == 'Glass Card' then
            self.use_original_desc = true
        end
    elseif self.set == 'Voucher' then
        if name == 'Reroll Surplus' then
            self.config.extra = 2
            self.config.increase = 2
            
            self.redeem = function(self, card)
                G.GAME.modifiers.extra_discard_cost = G.GAME.modifiers.extra_discard_cost or card.ability.extra
                G.GAME.modifiers.extra_discard = card.ability.extra
                G.GAME.modifiers.extra_discard_increase = card.ability.increase
            end
        elseif name == 'Reroll Glut' then
            self.config.extra = 1
            self.config.increase = 1
            
            self.redeem = function(self, card)
                G.GAME.modifiers.extra_discard_cost = G.GAME.modifiers.extra_discard_cost or card.ability.extra
                G.GAME.modifiers.extra_discard = card.ability.extra
                G.GAME.modifiers.extra_discard_increase = card.ability.increase
            end
        elseif name == 'Clearance Sale' or name == 'Liquidation' then
            -- self.redeem = function(self, card)
            --     G.GAME.discount_percent = center_table.extra
            --     for k, v in pairs(G.I.CARD) do
            --         if v.set_cost then v:set_cost() end
            --     end
            -- end
        elseif name == 'Crystal Ball' then
            self.redeem = function(self, card)
                print(G.consumeables.config.card_limit)
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
                
            end
        elseif name == 'Seed Money' then
            self.config.extra = 1
            
            self.redeem = function(self, card)
            end
        elseif name == 'Money Tree' then
            
            self.redeem = function(self, card)
            end
        elseif name == 'Hone' then
            self.config.extra = 50
            
            self.redeem = function(self, card)
                G.GAME.modifiers.joker_chip_extra = card.ability.extra
            end
        elseif name == 'Glow Up' then
            self.config.extra = 1.5
            
            self.redeem = function(self, card)
                G.GAME.modifiers.joker_xmult_extra = card.ability.extra
            end
        elseif name == 'Overstock' then
            
            self.redeem = function(self, card)
                G.GAME.modifiers.consumeable_in_jokers = true
            end
        elseif name == 'Overstock Plus' then
            
            self.redeem = function(self, card)
                G.GAME.modifiers.joker_in_consumeables = true
            end
        elseif name == 'Omen Globe' then
            self.config.extra = 1
            
            self.redeem = function(self, card)
            end
        elseif name == 'Telescope' then
            
            self.redeem = function(self, card)
                G.GAME.modifiers.draw_telescope = true
            end
        elseif name == 'Tarot Merchant' then
            self.config.extra = 1
            
            self.redeem = function(self, card)
                
            end
        elseif name == 'Tarot Tycoon' then
            
            self.redeem = function(self, card)
                for k, card in ipairs(G.jokers.cards) do
                    if card.ability.set == 'Tarot' then
                        card.area.config.card_limit = card.area.config.card_limit + 1
                        card.ability.queue_negative_removal = true
                    end
                end
                for k, card in ipairs(G.consumeables.cards) do
                    if card.ability.set == 'Tarot' then
                        card.area.config.card_limit = card.area.config.card_limit + 1
                        card.ability.queue_negative_removal = true
                    end
                end
            end
        elseif name == 'Planet Merchant' then
            self.config.extra = 1
            
            self.redeem = function(self, card)
            end
        elseif name == 'Planet Tycoon' then
            
            self.redeem = function(self, card)
                for k, card in ipairs(G.jokers.cards) do
                    if card.ability.set == 'Planet' then
                        card.area.config.card_limit = card.area.config.card_limit + 1
                        card.ability.queue_negative_removal = true
                    end
                end
                for k, card in ipairs(G.consumeables.cards) do
                    if card.ability.set == 'Planet' then
                        card.area.config.card_limit = card.area.config.card_limit + 1
                        card.ability.queue_negative_removal = true
                    end
                end
            end
        elseif name == 'Magic Trick' then
            
            self.redeem = function(self, card)
                G.GAME.modifiers.buy_cards = true
            end
        elseif name == 'Illusion' then
            self.config.extra = 1.5
            
            self.redeem = function(self, card)
            end
        elseif name == 'Hieroglyph' then
            self.config.extra = 4
            
            self.redeem = function(self, card)
                G.GAME.modifiers.damage_reduction = (G.GAME.modifiers.damage_reduction or 0) + card.ability.extra
                G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
                ease_discard(-1)
            end
        elseif name == 'Petroglyph' then
            self.config.extra = 4
            
            self.redeem = function(self, card)
                G.GAME.modifiers.damage_reduction = (G.GAME.modifiers.damage_reduction or 0) + card.ability.extra
                G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
                ease_discard(-1)
            end
        elseif name == "Director's Cut" then
            self.config.extra = {
                reroll = 10,
                damage = 10
            }
            
            self.redeem = function(self, card)
                G.GAME.modifiers.tcg_attack = card.ability.extra.damage
                G.GAME.modifiers.tcg_attack_cost = card.ability.extra.reroll
            end
        elseif name == 'Retcon' then
            self.config.extra = {
                reroll = 8,
                damage = 16
            }
            
            self.redeem = function(self, card)
                G.GAME.modifiers.tcg_attack = card.ability.extra.damage
                G.GAME.modifiers.tcg_attack_cost = card.ability.extra.reroll
            end
        end
    elseif self.set == 'Tarot' then
        if balanced then
            if name == 'The Hermit' then
                self.use_original_desc = true
            elseif name == 'The Emperor' then
                
            elseif name == 'The High Priestess' then
                
            elseif name == 'Temperance' then
                --self.config.extra = 30
                self.tcg_calculate = function(self, context)
                    if context.updating then
                        self.ability.money = 0
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i].ability.set == 'Joker' then
                                self.ability.money = self.ability.money + G.jokers.cards[i].sell_cost
                            end
                        end
                        self.ability.money = math.min(self.ability.money, self.ability.extra)
                    end
                end
            elseif name == 'Ectoplasm' or name == 'Hex' then
                self.tcg_calculate = function(self, context)
                    if context.updating then
                        self.eligible_editionless_jokers = EMPTY(self.eligible_editionless_jokers)
                        for k, v in pairs(G.jokers.cards) do
                            if v.ability.set == 'Joker' and (not v.edition) then
                                table.insert(self.eligible_editionless_jokers, v)
                            end
                        end
                        for k, v in pairs(G.consumeables.cards) do
                            if v.ability.set == 'Joker' and (not v.edition) then
                                table.insert(self.eligible_editionless_jokers, v)
                            end
                        end
                    end
                end
            end
        end
    elseif self.set == 'Spectral' then
        if name == 'The Soul' or name == 'Wraith' then
            
        elseif not balanced and (name == 'Hex' or name == 'Ankh' or name == 'Immolate') then
            self.use_original_desc = true
        end
        
    elseif self.set == 'Planet' then
    elseif self.set == 'Joker' then
        
        if BalatroTCG.JokerMods[self.key] then
            BalatroTCG.JokerMods[self.key].modify(self, not BalatroTCG.Settings.Unbalance)
            if BalatroTCG.JokerMods[self.key].calculate_context then
                self.tcg_calculate = BalatroTCG.JokerMods[self.key].calculate_context
            end
        end
        -- if name == 'Joker' then

        -- -- Chips
        -- elseif name == 'Bull' then
            
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Stone Joker' then
        --     if balanced then self.config.extra = 40 end
            
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Odd Todd' then
        --     if balanced then self.config.extra = 75 end
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Scary Face' then
        --     if balanced then self.config.extra = 45 end
        -- elseif name == 'Arrowhead' then
        --     if balanced then self.config.extra = 75 end

        -- -- Mult
        
        -- elseif name == 'Misprint' then
        -- elseif name == 'Abstract Joker' then
        -- elseif name == 'Half Joker' then
        -- elseif name == 'Mystic Summit' then
        -- elseif name == 'Popcorn' then
        -- elseif name == 'Green Joker' then
        -- elseif name == 'Swashbuckler' then
            
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Ride the Bus' then
        -- elseif name == 'Spare Trousers' then
        -- elseif name == 'Erosion' then
        -- elseif name == 'Fortune Teller' then
        -- elseif name == 'Bootstraps' then

        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Supernova' then
        -- elseif name == 'Red Card' then
            

        --     self.tcg_calculate = function(self, context)
        --     end
        --     self.tcg_estimate = function(self, context)
                
        --     end
        -- elseif name == 'Flash Card' then
        -- elseif name == 'Ceremonial Dagger' then
            
            
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Fibonacci' then
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Even Steven' then
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Onyx Agate' then

        -- -- XMult

        -- elseif name == 'Caino' then
        -- elseif name == 'Baseball Card' then
        -- elseif name == 'Glass Joker' then
        -- elseif name == 'Yorick' then
        -- elseif name == 'Seeing Double' then
        -- elseif name == 'Card Sharp' then
        -- elseif name == 'Cavendish' then
        -- elseif name == "Driver's License" then

        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Ramen' then
        -- elseif name == 'Photograph' then
        --     self.use_original_desc = true
            
        -- elseif name == 'Loyalty Card' then
        -- elseif name == 'Steel Joker' then

        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Constellation' then
        -- elseif name == 'Madness' then
        -- elseif name == 'Vampire' then

        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Hologram' then
        -- elseif name == 'Obelisk' then
        --     self.use_original_desc = true
        -- elseif name == 'Lucky Cat' then
        -- elseif name == "Joker Stencil" then 
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Hit the Road' then
        -- elseif name == 'Campfire' then
        -- elseif name == 'Acrobat' then
        -- elseif name == 'Throwback' then
            
            
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Bloodstone' then
            
        --     self.use_original_desc = true
            
        --     self.tcg_calculate = function(self, context)
        --         if context.individual and context.cardarea == G.play then
                    
        --             local suit = self:get_ability_suit("Hearts")
        --             if context.other_card:is_suit(suit) and SMODS.pseudorandom_probability(self, 'bloodstone', self.ability.extra.num, self.ability.extra.odds) then
                        
        --                 return {
        --                     x_mult = self.ability.extra.Xmult,
        --                     card = self
        --                 }
        --             end
        --         elseif not context.blueprint and context.cardarea == G.jokers and context.after then
        --             if balanced then
        --                 self.ability.extra.odds = self.ability.extra.odds + 1
        --                 return {
        --                     message = localize('k_bleeding'),
        --                     colour = G.C.RED
        --                 }
        --             end
        --         end
        --     end
        -- elseif name == 'Triboulet' then

        --     self.config.chance = 4
        --     self.use_original_desc = true
            
        --     self.tcg_calculate = function(self, context)
        --         if context.individual and context.cardarea == G.play and context.other_card:is_rank_joker({12, 13}) then
        --             if balanced and pseudorandom('trib') < G.GAME.probabilities.normal/self.ability.chance then
        --                 context.other_card.trib_break = true
        --             end
        --             return {
        --                 x_mult = self.ability.extra,
        --                 colour = G.C.RED,
        --                 card = self
        --             }
        --         elseif context.destroying_card and not context.blueprint then
        --             if context.destroying_card.trib_break then
        --                 return true
        --             end
        --         end
        --     end
        
            
        -- elseif name == 'Baron' then
        --     --self.config.extra = 1.25

        -- -- Econ
        


        -- elseif name == 'DNA' then
            
        --     self.use_original_desc = true
            
        --     self.tcg_calculate = function(self, context)
                
        --     end
        -- elseif name == 'Vagabond' then
            
        -- elseif name == 'Mail-In Rebate' then
        -- elseif name == 'Golden Ticket' then

        --     self.use_original_desc = true

        --     self.tcg_calculate = function(self, context)
        --     end

        -- elseif name == 'Faceless Joker' then
        -- elseif name == 'Satellite' then
            
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'To the Moon' then
            

        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Delayed Gratification' then
        --     if balanced then self.eternal_compat = false end
        --     self.blueprint_compat = true

        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Business Card' then
            
        --     self.tcg_calculate = function(self, context)
        --     end
        --     self.tcg_estimate = function(self, context)
        --     end
        -- elseif name == '8 Ball' then
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Rocket' then
        -- elseif name == 'Matador' then
        --     self.eternal_compat = false
        --     self.blueprint_compat = false
            
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Mr. Bones' then
            
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Golden Joker' then
            
        --     self.config.extra = 4
            
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Cloud 9' then
        -- -- Misc



        -- elseif name == 'Hack' then
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Merry Andy' then
        --     if balanced then self.config.d_size = 2 end
        -- elseif name == 'Burglar' then
        --     if balanced then self.config.extra = 2 end
        -- elseif name == 'Certificate' then
        --     -- self.tcg_calculate = function(self, context)
        --     --     if context.setting_blind and not self.getting_sliced then
        --     --         G.E_MANAGER:add_event(Event({
        --     --             func = function()
        --     --                 local _card = create_playing_card({
        --     --                     front = pseudorandom_element(G.P_CARDS, pseudoseed('cert_fr')),
        --     --                     center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
        --     --                 _card:set_seal(SMODS.poll_seal({type_key = 'certsl', guaranteed = true}), nil, true)
        --     --                 G.GAME.blind:debuff_card(_card)
        --     --                 G.hand:sort()
        --     --                 if context_blueprint_card then context_blueprint_card:juice_up() else self:juice_up() end
        --     --                 playing_card_joker_effects({_card})
        --     --                 save_run()
        --     --                 return true
        --     --             end}))
                    
        --     --         return nil, true
        --     --     end
        --     -- end
        -- elseif name == 'Burnt Joker' then
            
        --     self.use_original_desc = true

        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Trading Card' then
            
        -- elseif name == 'Riff-raff' then
        --     if balanced then self.config.extra = 1 end
        -- elseif name == 'Blueprint' then
            
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Brainstorm' then
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Perkeo' then

        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Hallucination' then
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Luchador' then

        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Diet Cola' then
        --     self.tcg_calculate = function(self, context)
        --     end
        -- elseif name == 'Chicot' then
        -- elseif name == 'Troubadour' then
        --     self.tcg_add_to_deck = function(self, from_debuff)
        --     end
        --     self.tcg_remove_from_deck = function(self, from_debuff)
        --     end
        -- elseif name == 'Dusk' then

        -- end
        
    end

    G.P_CENTERS[self.key] = self

    return self
end

function TCG_Override_Desc(self, _c)
    
    local loc_vars = nil

    local ability = self and self.ability or _c.config

    if _c.use_original_desc then return end

    if _c.name == 'Ancient Joker' and self then loc_vars = {ability.extra, localize(self:get_ability_suit(G.GAME.current_round.ancient_card.suit), 'suits_singular'), colours = {G.C.SUITS[self:get_ability_suit(G.GAME.current_round.ancient_card.suit)]}}
    elseif _c.name == 'Campfire' then loc_vars = {ability.extra, ability.reduce, ability.x_mult}
    elseif _c.name == 'Acrobat' then loc_vars = { ability.scaling, ((BalatroTCG.Status_Current and (BalatroTCG.Status_Current.status.round - 1) or 0) * ability.scaling + ability.initial)}
    elseif _c.name == 'Red Card' then loc_vars = { ability.extra, ability.cards, ability.mult }
    elseif _c.name == 'Rocket' then loc_vars = {ability.extra.dollars, ability.extra.increase, ability.extra.limit}
    elseif _c.name == 'Fortune Teller' then loc_vars = {ability.extra, (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0) * ability.extra}    
    elseif _c.name == 'Superposition' then loc_vars = {ability.extra}
    elseif _c.name == 'Cloud 9' then loc_vars = {ability.extra, math.floor(ability.final * 100)}
    elseif _c.name == 'Blue Joker' then loc_vars = {ability.extra, ability.extra*((G.deck and G.deck.cards) and #G.deck.cards or 60)}
    elseif _c.name == 'Chicot' then loc_vars = {ability.extra}
    elseif _c.name == 'Golden Joker' then loc_vars = {ability.extra}
    elseif _c.name == 'Dusk' then loc_vars = {ability.extra}
    elseif _c.name == 'Mr. Bones' then loc_vars = {ability.extra}
    elseif _c.name == 'Swashbuckler' then loc_vars = {ability.mult + (BalatroTCG.Status_Current and BalatroTCG.Status_Current.status.opponent_joker_cost or 0)}
    elseif _c.name == 'Throwback' then loc_vars = {ability.extra, ability.extra * ability.discards + 1}
    elseif _c.name == 'Ceremonial Dagger' then loc_vars = {ability.extra.growth, ability.extra.mult}
    elseif _c.name == 'Abstract Joker' then loc_vars = {ability.extra, ((G.jokers and G.jokers.cards and #G.jokers.cards or 0) + (BalatroTCG.Status_Current and #BalatroTCG.Status_Current.opponentJokers.cards or 0))*ability.extra}
    elseif _c.name == 'Supernova' then loc_vars = {ability.extra}
    elseif _c.name == 'Luchador' then loc_vars = {math.floor(ability.extra), ability.wait, ability.wait_rounds}
    elseif _c.name == 'Bootstraps' then loc_vars = {ability.extra.mult, ability.extra.mult * math.floor(BalatroTCG.Status_Current and (BalatroTCG.Status_Current.status.dollars + (G.GAME.dollar_buffer or 0) + BalatroTCG.Status_Current.status.opponent_health) or 0)}
    elseif _c.name == 'Bull' then loc_vars = {ability.extra, ability.extra*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0) + (BalatroTCG.Status_Current and BalatroTCG.Status_Current.status.opponent_health or 0)))}
    elseif _c.name == 'Triboulet' then loc_vars = {ability.extra, G.GAME.probabilities.normal, ability.chance}
    elseif _c.name == "Driver's License" then loc_vars = {self.ability.extra, self.config.tally_amount, self.ability.driver_tally or '0'}
    elseif _c.name == 'Bloodstone' then 
        local a, b = SMODS.get_probability_vars(self, ability.extra.num, ability.extra.odds, 'bloodstone')
        loc_vars = {a, b, self.ability.extra.Xmult}
    elseif _c.name == 'The Idol' and self then loc_vars = {ability.extra, localize(self:get_ability_rank(G.GAME.current_round.idol_card.rank), 'ranks'), localize(self:get_ability_suit(G.GAME.current_round.idol_card.suit), 'suits_plural'), colours = {G.C.SUITS[self:get_ability_suit(G.GAME.current_round.idol_card.suit)]}}
    elseif _c.name == 'Mail-In Rebate' and self then loc_vars = {ability.extra, localize(self:get_ability_rank(G.GAME.current_round.mail_card.rank), 'ranks')}

    elseif _c.name == 'Misprint' then
        local r_mults = {}
        for i = ability.extra.min, ability.extra.max do
            r_mults[#r_mults+1] = tostring(i)
        end
        local loc_mult = ' '..(localize('k_mult'))..' '
        main_start = {
            {n=G.UIT.T, config={text = '  +',colour = G.C.MULT, scale = 0.32}},
            {n=G.UIT.O, config={object = DynaText({string = r_mults, colours = {G.C.RED},pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0})}},
            {n=G.UIT.O, config={object = DynaText({string = {
                {string = 'rand()', colour = G.C.JOKER_GREY},
                self.area == G.jokers and
                {string = "#@"..
                (G.deck and G.deck.cards[1] and 
                    (G.deck.cards[#G.deck.cards]:is_playing_card() and G.deck.cards[#G.deck.cards].base.id or G.deck.cards[#G.deck.cards].ability.name:sub(1, 1)) or 11)..
                (G.deck and G.deck.cards[1] and
                    (G.deck.cards[#G.deck.cards]:is_playing_card() and G.deck.cards[#G.deck.cards].base.id or G.deck.cards[#G.deck.cards].ability.set:sub(1, 1)) or 'D'), colour = G.C.RED}
                or
                {string = "#@"..'NOPE', colour = G.C.RED},
                loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult},
            colours = {G.C.UI.TEXT_DARK},pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.2011, scale = 0.32, min_cycle_time = 0})}},
        }

    elseif _c.name == 'Reroll Surplus' then loc_vars = { (G.GAME.used_vouchers['v_reroll_surplus']) and G.GAME.modifiers.extra_discard_cost or ability.extra, (G.GAME.used_vouchers['v_reroll_surplus']) and G.GAME.modifiers.extra_discard_increase or ability.increase }
    elseif _c.name == 'Reroll Glut' then loc_vars = { (G.GAME.used_vouchers['v_reroll_glut']) and G.GAME.modifiers.extra_discard_cost or ability.extra, (G.GAME.used_vouchers['v_reroll_glut']) and G.GAME.modifiers.extra_discard_increase or ability.increase }
    elseif _c.name == 'Seed Money' then loc_vars = { ability.extra }
    elseif _c.name == 'Money Tree' then loc_vars = { BalatroTCG.Status_Current and BalatroTCG.Status_Current.status.seed_reduction or 0 }
    elseif _c.name == 'Hieroglyph' then loc_vars = { ability.extra }
    elseif _c.name == 'Petroglyph' then loc_vars = { ability.extra }
    elseif _c.name == 'Hone' then loc_vars = { ability.extra }
    elseif _c.name == 'Glow Up' then loc_vars = { ability.extra }
    elseif _c.name == 'Illusion' then loc_vars = { ability.extra }
    elseif _c.name == 'Tarot Merchant' then loc_vars = { ability.extra }
    elseif _c.name == 'Planet Merchant' then loc_vars = { ability.extra }
    elseif _c.name == 'Omen Globe' then loc_vars = { ability.extra }
    elseif _c.name == "Director's Cut" then loc_vars = { ability.extra.reroll, ability.extra.damage }
    elseif _c.name == 'Retcon' then loc_vars = { ability.extra.reroll, ability.extra.damage }
    
    elseif _c.name == 'Lucky Card' then loc_vars = { G.GAME.probabilities.normal, BalatroTCG.Settings.Unbalance and 15 or 6, ability.p_dollars};

    end

    _c.vars = loc_vars or _c.vars

    return loc_vars
end

function Card:set_tcg_max_health(_amount)
    self.tcg_extra.has_health = true
    self.ability.tcgb_sticker_hidden = true
    self.ability.tcgb_health_amount = _amount
    self.ability.tcgb_max_health = _amount
end
function Card:set_tcg_health(_amount) 
    if not self.tcg_extra.has_health then
        self:set_tcg_max_health(BalatroTCG.Status_Current.params.joker_health)
    elseif not self.ability.eternal then
        if _amount <= 0 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blockable = false,
                delay =  1,
                func = (function() self:start_dissolve() return true end)
            }))
        end
        self.ability.tcgb_health_amount = math.max(math.min(_amount, self.ability.tcgb_max_health), 0)
    end
end
function Card:disable_tcg_health()
    self.tcg_extra.has_health = nil
    self.ability.tcgb_sticker_hidden = nil
    self.ability.tcgb_sticker_visible = nil
    self.ability.tcgb_health_amount = nil
    self.ability.tcgb_max_health = nil
end
function Card:remove_tcg_health(_amount) 
    if not self.ability.eternal then
        
        self.ability.tcgb_health_amount = (self.ability.tcgb_health_amount or 0)
        if self.ability.tcgb_health_amount - _amount <= 0 then
            self.skip_destroy_animation = true
        end
        self:set_tcg_health(self.ability.tcgb_health_amount - _amount)

        local dissolve_time = 0.7
        self.dissolve_colours = {{1,1,1,0.8}}
        local childParts = Particles(0, 0, 0,0, {
            timer_type = 'TOTAL',
            timer = 0.007*dissolve_time,
            scale = 0.3,
            speed = 4,
            lifespan = 1.5*dissolve_time,
            attach = self,
            colours = self.dissolve_colours,
            fill = true
        })

        card_eval_status_text(self, 'extra', nil, nil, nil, {message = tostring(self.ability.tcgb_health_amount), colour = G.C.RED})

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            blockable = false,
            delay =  0.5*dissolve_time,
            func = (function() childParts:fade(0.15*dissolve_time) return true end)
        }))
    end
end