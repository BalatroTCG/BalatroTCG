
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
                    temp[v + 1] = true
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

        BalatroTCG.Status_Current:setup_visuals(self, G.discard, area)
        
        stop_use()

        if self.ability.set == 'Planet' then
            if not BalatroTCG.Status_Current.params.destroy_planets then self.tcg_todeck = true end
        elseif self.ability.set == 'Tarot' then
            if not BalatroTCG.Status_Current.params.destroy_tarots then self.tcg_todeck = true end
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
                    )) end, {G.deck, G.discard, G.graveyard})
                
                if card then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()

                        card.area:remove_card(card)
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

                local card = pick_from_areas(function (c) return c.ability.name == center.name end, {G.deck, G.discard, G.graveyard})
                
                if card then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        card.area:remove_card(card)
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
            elseif self.ability.name == 'Ankh' and not BalatroTCG.Settings.Unbalance then

                local copyable_jokers = {}
                for i, v in ipairs(G.jokers.cards) do
                    if not G.jokers.cards[i].edition or G.jokers.cards[i].edition.type ~= "mp_phantom" then copyable_jokers[#copyable_jokers + 1] = v end
                end
                local chosen_joker = pseudorandom_element(copyable_jokers, pseudoseed('ankh_choice'))
                
                G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()
                    local card = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative)
                    card:start_materialize()
                    card:add_to_deck()
                    card:set_rental(true)
                    if card.edition and card.edition.negative then
                        card:set_edition(nil, true)
                    end
                    G.jokers:emplace(card)
                    return true end }))
                
            elseif self.ability.name == 'The Emperor' then
                
                for i = 1, math.min(self.ability.consumeable.tarots, G.consumeables.config.card_limit - #G.consumeables.cards) do
                    local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})

                    if card then
                        card.area:remove_card(card)
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
                
            elseif self.ability.name == 'Death' then
                
                local rightmost = G.hand.highlighted[1]
                local leftmost = G.hand.highlighted[1]
                
                leftmost.children.front:remove()
                leftmost.children.front = nil
                
                for i=1, #G.hand.highlighted do
                    if G.hand.highlighted[i].T.x < leftmost.T.x then leftmost = G.hand.highlighted[i] end
                    if G.hand.highlighted[i].T.x > rightmost.T.x then rightmost = G.hand.highlighted[i] end
                end

                use_consumeable_ref(self, area, copier)

                leftmost.ability.set = rightmost.ability.set
                leftmost.consumable = rightmost.consumable

                if leftmost.children.use_button then
                    leftmost.children.use_button:remove()
                    leftmost.children.use_button = nil
                end
                leftmost.tcg_extra.has_health = nil
                leftmost.tcg_extra.health_amount = nil
                leftmost.tcg_extra.max_health = nil

                leftmost:set_sprites()
                
            elseif self.ability.name == 'The High Priestess' then

                for i = 1, math.min(self.ability.consumeable.planets, G.consumeables.config.card_limit - #G.consumeables.cards) do
                    local card = pick_from_areas(function (c) return c.ability.set == 'Planet' end, {G.deck, G.discard, G.graveyard})

                    if card then
                        card.area:remove_card(card)
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

            elseif self.ability.name == 'Immolate' and not BalatroTCG.Settings.Unbalance then
                self.ability.extra.dollars = 0
                use_consumeable_ref(self, area, copier)

            elseif self.ability.effect == 'Suit Conversion' and BalatroTCG.Settings.Unbalance then

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
                        card.area:remove_card(card)
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
                    local card = pseudorandom_element(applicable, pseudoseed('soul'..G.GAME.round_resets.ante))
                    used_tarot:juice_up(0.3, 0.5)
                    play_sound('gold_seal', 1.2, 0.4)
                    card:set_eternal(true)
                end
                
                local _first_dissolve = false
                for _, joker in ipairs(G.jokers.cards) do
                    if (not SMODS.is_eternal(joker, self)) then v.getting_sliced = true; v:start_dissolve(nil, _first_dissolve);_first_dissolve = true end
                end
            else
                use_consumeable_ref(self, area, copier)
            end
        end
    else
        use_consumeable_ref(self, area, copier)
    end
end


function Card:calculate_joker(context)
    if self.ability.set ~= "Joker" or not BalatroTCG.GameActive then
        return calculate_joker_ref(self, context)
    end

    if self.debuff then return nil end

    if self.config.center.tcg_calculate and type(self.config.center.tcg_calculate) == 'function' then
        return self.config.center.tcg_calculate(self, context)
    end
    
    if self.ability.set == "Joker" then

        if context.selling_self then
        elseif context.switching_players then
            if self.ability.name == 'Chaos the Clown' and not context.blueprint then
                context.old_player.jokers:unhighlight_all()
                for k, v in ipairs(context.old_player.jokers.cards) do
                    v:flip()
                end
                if #context.old_player.jokers.cards > 1 then 
                    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
                        G.E_MANAGER:add_event(Event({ func = function() context.old_player.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
                        delay(0.15)
                        G.E_MANAGER:add_event(Event({ func = function() context.old_player.jokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
                        delay(0.15)
                        G.E_MANAGER:add_event(Event({ func = function() context.old_player.jokers:shuffle('aajk'); play_sound('cardSlide1', 1);return true end })) 
                        delay(0.5)
                    return true end })) 
                end
            end
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
                        v:set_tcg_health((v.tcg_extra.health_amount or 0) + self.ability.extra)
                        delay(0.4)
                    end
                    return true end
                }))
                return nil
            end
            if self.ability.name == 'Riff-raff' and not (context.blueprint_card or self).getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                local jokers_to_create = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
                
                
                local card = pick_from_areas(function (c) return c.ability.set == 'Joker' and c.config.center.rarity == 1 end, {G.deck, G.discard})
                
                if card then
                    G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        card.area:remove_card(card)
                        card:start_materialize()
                        G.jokers:emplace(card)

                        for _, c in ipairs(G.playing_cards) do
                            if c == card then
                                goto skip
                            end
                        end
                        table.insert(G.playing_cards, card)
                        ::skip::
                        G.GAME.joker_buffer = 0
                        play_sound('timpani')
                        self:juice_up(0.3, 0.5)
                        return true
                    end
                    }))
                    delay(0.6)
                end

                return nil
            end
            if self.ability.name == 'Cartomancer' and not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                
                local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
                
                if card then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        card.area:remove_card(card)
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
                        self:juice_up(0.3, 0.5)
                        return true
                    end
                    }))
                    delay(0.6)
                end
                
                return nil
            end
        elseif context.destroying_card and not context.blueprint then
            if self.ability.name == 'Sixth Sense' and #context.full_hand == 1 and context.full_hand[1]:is_rank_joker(6) and G.GAME.current_round.hands_played == 0 then
                
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        
                    local card = pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard})
                    
                    if card then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                            card.area:remove_card(card)
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
                            self:juice_up(0.3, 0.5)
                            return true
                        end
                        }))
                        card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
                        delay(0.6)
                    end
                end
                return true
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
            if self.ability.name == 'Trading Card' and not BalatroTCG.Settings.Unbalance and not context.blueprint and G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
                return {
                    delay = 0.45, 
                    remove = true,
                    card = self
                }
            end
            if self.ability.name == 'Castle' and self.tcg_extra.suit then
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
            if self.ability.name == 'Mail-In Rebate' then
                local rank = self:get_ability_id(G.GAME.current_round.mail_card.id)
                if not context.other_card.debuff and context.other_card:is_rank_joker(rank) then
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
            if self.ability.name == 'Hit the Road' then
                local rank = self:get_ability_id(11)
                if not context.other_card.debuff and context.other_card:is_rank_joker(rank) and not context.blueprint then
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
                    
                    local suit = self:get_ability_suit(G.GAME.current_round.idol_card.suit)
                    local rank = self:get_ability_id(G.GAME.current_round.idol_card.id)

                    if context.other_card:is_rank_joker(rank) and context.other_card:is_suit(suit) then
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
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.money
                        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                        return {
                            dollars = self.ability.money,
                            card = self
                        }
                    else
                        return nil
                    end
                end
                if self.ability.name == 'Rough Gem' then
                    local suit = self:get_ability_suit("Diamonds")
                    
                    if context.other_card:is_suit(suit) then
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
                        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))

                        return {
                            dollars = self.ability.extra,
                            card = self,
                        }
                    end
                end
                if self.ability.name == 'Onyx Agate' then
                    local suit = self:get_ability_suit("Clubs")

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
                    local suit = self:get_ability_suit("Spades")
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
                    local suit = self:get_ability_suit("Hearts")

                    if context.other_card:is_suit(suit) and pseudorandom('bloodstone') < G.GAME.probabilities.normal/self.ability.extra.odds then
                        return {
                            x_mult = self.ability.extra.Xmult,
                            card = self
                        }
                    else
                        return nil
                    end
                end
                if self.ability.name == 'Ancient Joker' then

                    local suit = self:get_ability_suit(G.GAME.current_round.ancient_card.suit)
                    if context.other_card:is_suit(suit) then
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
                    if self.ability.name == 'Obelisk' and not context.blueprint and not BalatroTCG.Settings.Unbalance then
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
                        return nil
                    end
                elseif context.after then
                elseif context.joker_main then
                    
                    if self.ability.name == 'Abstract Joker' then
                        local x = 0
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i].ability.set == 'Joker' then x = x + 1 end
                        end
                        x = x + #BalatroTCG.Status_Current.opponentJokers.cards
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
                            
                            local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
                            
                            if card then
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()

                                    card.area:remove_card(card)
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
                                    self:juice_up(0.3, 0.5)
                                    return true
                                end
                                }))
                                delay(0.6)
                                return {
                                    message = localize('k_plus_tarot'),
                                    card = self
                                }
                            end

                        end
                        

                        return nil
                    end
                    if self.ability.name == 'Superposition' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        local aces = 0
                        for i = 1, #context.scoring_hand do
                            if context.scoring_hand[i]:is_rank_joker(14) then aces = aces + 1 end
                        end
                        if aces >= 1 and next(context.poker_hands["Straight"]) then
                            
                            local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
                            
                            if card then
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                                    
                                    card.area:remove_card(card)
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
                                    self:juice_up(0.3, 0.5)
                                    return true
                                end
                                }))
                                delay(0.6)
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
                            local card = pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard})
                            if card then
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                                    
                                    card.area:remove_card(card)
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
                                    self:juice_up(0.3, 0.5)
                                    return true
                                end
                                }))
                                delay(0.6)
                                return {
                                    message = localize('k_plus_spectral'),
                                    colour = G.C.SECONDARY_SET.Spectral,
                                    card = self
                                }
                            end
                        end
                        return nil
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

local set_ability_ref = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    if BalatroTCG.UseTCG_UI then
        center = create_tcg_center(center)
    end

    set_ability_ref(self, center, initial, delay_sprites)
    
    if BalatroTCG.UseTCG_UI then
        self.config.center_key = center.key
    end
end

-- This function is way too laggy but it's the only solution I have right now
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

function create_tcg_center(self)

    if BalatroTCG.ModifiedCenters[self.key] then return BalatroTCG.ModifiedCenters[self.key] end

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
        if not BalatroTCG.Settings.Unbalance then
            if name == 'Gold Card' then

            elseif name == 'Lucky Card' then
                --self.config.p_dollars = 10
                self.config.p_dollars = 10
            elseif name == 'Glass Card' then
                

            elseif name == 'Steel Card' then
                --self.config.h_x_mult = 1.25
            end
        end
    elseif self.set == 'Voucher' then
        if name == 'Reroll Surplus' then
            self.config.extra = 2
            
            self.redeem = function(self, card)
                G.GAME.modifiers.extra_discard = card.ability.extra
            end
        elseif name == 'Reroll Glut' then
            self.config.extra = 1
            
            self.redeem = function(self, card)
                G.GAME.modifiers.extra_discard = card.ability.extra
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
        if not BalatroTCG.Settings.Unbalance then
            if name == 'The Hermit' then
                --self.config.extra = 15
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
                    end
                end
            elseif name == 'The Wheel of Fortune' then
                self.tcg_calculate = function(self, context)
                    if context.updating then
                        self.eligible_strength_jokers = EMPTY(self.eligible_strength_jokers)
                        for k, v in pairs(G.jokers.cards) do
                            if v.ability.set == 'Joker' and (not v.edition) then
                                table.insert(self.eligible_strength_jokers, v)
                            end
                        end
                    end
                end
            --     if G.GAME.used_vouchers['v_hone'] then v.ability.extra = 2 end
            end
        end
    elseif self.set == 'Spectral' then
        if name == 'The Soul' or name == 'Wraith' then
            
        elseif not BalatroTCG.Settings.Unbalance and (name == 'Ankh' or name == 'Immolate') then
            
        end
        
    elseif self.set == 'Planet' then
    elseif self.set == 'Joker' then
        
        if not BalatroTCG.Settings.Unbalance then
            if name == 'Joker' then
                self.config.mult = 5
            elseif name == 'Greedy Joker' or name == 'Lusty Joker' or name == 'Wrathful Joker' or name == 'Gluttonous Joker' then
                self.config.extra.s_mult = 5
            elseif (self.config.t_mult or 0) > 0 or (self.config.t_chips or 0) > 0 then

                if name == 'Jolly Joker' then
                    self.config.t_mult = 10
                elseif name == 'Zany Joker' then
                    self.config.t_mult = 15
                elseif name == 'Mad Joker' then
                    self.config.t_mult = 12
                elseif name == 'Crazy Joker' then
                    self.config.t_mult = 30
                elseif name == 'Droll Joker' then
                    self.config.t_mult = 15
                elseif name == 'Sly Joker' then
                    self.config.t_chips = 100
                elseif name == 'Wily Joker' then
                    self.config.t_chips = 150
                elseif name == 'Clever Joker' then
                    self.config.t_chips = 150
                elseif name == 'Devious Joker' then
                    self.config.t_chips = 300
                elseif name == 'Crafty Joker' then
                    self.config.t_chips = 120
                end

            -- Combo
            elseif name == 'Walkie Talkie' then
                self.config.extra.chips = 4
                self.config.extra.mult = 10
            elseif name == 'Scholar' then
                self.config.extra.chips = 100
                self.config.extra.mult = 10

            -- Chips
            elseif name == 'Banner' then
                self.config.extra = 80
            elseif name == 'Castle' then
                self.config.extra.chip_mod = 12
            elseif name == 'Stuntman' then
                self.config.extra.chip_mod = 400
            elseif name == 'Wee Joker' then
                self.config.extra.chip_mod = 18
            elseif name == 'Odd Todd' then
                self.config.extra = 75
            elseif name == 'Runner' then
                self.config.extra.chip_mod = 40
            elseif name == 'Ice Cream' then
                self.config.extra.chips = 200
                self.config.extra.chip_mod = 40
            elseif name == 'Hiker' then
                self.config.extra = 12
            elseif name == 'Square Joker' then
                self.config.extra.chip_mod = 8
            elseif name == 'Bull' then
                self.config.extra = 6
            elseif name == 'Blue Joker' then
                self.config.extra = 3
            elseif name == 'Scary Face' then
                self.config.extra = 45
            elseif name == 'Stone Joker' then
                self.config.extra = 50
            elseif name == 'Arrowhead' then
                self.config.extra = 75
            elseif name == 'Onyx Agate' then
                self.config.extra = 12
            
            -- Mult
            elseif name == 'Green Joker' then
                self.config.extra.hand_add = 3
                self.config.extra.discard_sub = 3
            elseif name == 'Misprint' then
                self.config.extra.min = 00
                self.config.extra.max = 40
            elseif name == 'Ride the Bus' then
                self.config.extra = 4
            elseif name == 'Half Joker' then
                self.config.extra.mult = 35
            elseif name == 'Abstract Joker' then
                self.config.extra = 6
            elseif name == 'Mystic Summit' then
                self.config.extra.mult = 25
            elseif name == 'Even Steven' then
                self.config.extra = 6
            elseif name == 'Spare Trousers' then
                self.config.extra = 8
            elseif name == 'Erosion' then
                self.config.extra = 6
            elseif name == 'Popcorn' then
                self.config.mult = 30
                self.config.extra = 5
            elseif name == 'Fibonacci' then
                self.config.extra = 13
            elseif name == 'Fortune Teller' then
                self.config.extra = 5
            elseif name == 'Bootstraps' then
                self.config.extra.mult = 1
            elseif name == 'Supernova' then
                self.config.extra = 5
            elseif name == 'Ceremonial Dagger' then
                self.config.extra = {
                    mult = 0,
                    growth = 3,
                }

            -- XMult
            elseif name == 'Loyalty Card' then
                self.config.extra.Xmult = 10
            elseif name == 'Steel Joker' then
                self.config.extra = 0.5
            elseif name == 'Blackboard' then
                self.config.extra = 5
            elseif name == 'Cavendish' then
                self.config.extra = {
                    Xmult = 10,
                    odds = 1000,
                }
            elseif name == 'Constellation' then
                self.config.extra = 0.5
            elseif name == 'Madness' then
                self.config.extra = 2
            elseif name == 'Vampire' then
                self.config.extra = 0.5
            elseif name == 'Hologram' then
                self.config.extra = 0.5
            elseif name == 'Obelisk' then
                self.config.extra = 1.5
                
            elseif name == 'Ramen' then
                self.config.x_mult = 4
                self.config.extra = 0.25
            elseif name == 'Photograph' then
                
            elseif name == 'Lucky Cat' then
                self.config.extra = 1.5
            elseif name == "Driver's License" then
                self.config.extra = 10
            elseif name == 'Hit the Road' then
                self.config.extra = 2
            elseif name == 'Flower Pot' then
                self.config.extra = 10
            elseif name == 'The Duo' then
                self.config.x_mult = 3
            elseif name == 'The Trio' then
                self.config.x_mult = 4
            elseif name == 'The Family' then
                self.config.x_mult = 5
            elseif name == 'The Order' then
                self.config.x_mult = 10
            elseif name == 'The Tribe' then
                self.config.x_mult = 3
            elseif name == 'Caino' then
                self.config.extra = 5
            elseif name == 'Baseball Card' then
                self.config.extra = 2
            elseif name == 'Glass Joker' then
                self.config.extra = 1.0
            elseif name == 'Yorick' then
                self.config.extra.xmult = 2.5
            elseif name == 'Seeing Double' then
                self.config.extra = 3

            -- Trigger XMult
            elseif name == 'Bloodstone' then
                self.config.extra = {
                    Xmult = 1.5,
                    odds = 3
            }
            elseif name == 'Idol' then
                
            elseif name == 'Baron' then
                --self.config.extra = 1.25

            -- Econ
            elseif name == 'Vagabond' then
                self.config.extra = 15
            elseif name == 'Mail-In Rebate' then
                self.config.extra = 3
            elseif name == 'Golden Ticket' then
                self.config.extra = 3
            elseif name == 'Faceless Joker' then
                self.config.extra.dollars = 10

            -- Misc
            elseif name == 'Merry Andy' then
                self.config.d_size = 2
            elseif name == 'Burglar' then
                self.config.extra = 2
            elseif name == 'Trading Card' then
                
            elseif name == 'Riff-raff' then
                self.config.extra = 1
            end
        else
            if name == 'Ceremonial Dagger' then
                self.config.extra = {
                    mult = 0,
                    growth = 2,
                }
            end
        end
        
        -- self.tcg_calculate = function(self, context) end
        -- self.tcg_estimate = function(self, context) end
        
        if name == 'Sample' then
            self.tcg_estimate = function(self, context)
                if context.purchase == self then
                    return {
                        mult = 0,
                        x_mult = 1
                    }
                end
            end
        end

        


        if name == 'Joker' then
            self.tcg_estimate = function(self, context)
                if context.purchase == self then
                    return {
                        mult = self.ability.extra
                    }
                end
            end
        elseif name == 'Satellite' then
            
            
            self.tcg_calculate = function(self, context)
                if context.tcg_take_damage and not context.blueprint then
                    local planets_used = 0
                    for k, v in pairs(G.GAME.consumeable_usage) do
                        if v.set == 'Planet' then planets_used = planets_used + 1 end
                    end
                    
                    if planets_used == 0 then return end

                    return {
                        reduce = planets_used
                    }
                end
            end
        elseif name == 'Riff-raff' then
            
        elseif name == 'Fortune Teller' then
            
        elseif name == 'Hallucination' then
            
        elseif name == 'Supernova' then
            
        elseif name == 'Burglar' then
            
        elseif name == 'Abstract' then
            
        elseif name == 'Astronomer' then
            
        elseif name == 'Card Sharp' then
            
        elseif name == 'Madness' then
            
        elseif name == 'Seance' then
            
        elseif name == 'Sixth Sense' then
            
        elseif name == "Driver's License" then 
            self.tcg_calculate = function(self, context)
                if context.updating then
                    self.ability.driver_tally = 0
                    for k, v in pairs(G.playing_cards) do
                        if v:is_playing_card() and v.config.center ~= G.P_CENTERS.c_base then self.ability.driver_tally = self.ability.driver_tally+1 end
                    end
                elseif context.joker_main and self.ability.driver_tally >= 16 then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={self.ability.extra}},
                        Xmult_mod = self.ability.extra,
                    }
                end
            end
        elseif name == 'Bootstraps' then
            
            self.tcg_calculate = function(self, context)
                if context.joker_main then
                    local money = (G.GAME.dollars + (G.GAME.dollar_buffer or 0)) + BalatroTCG.Status_Current.status.opponent_health
                    return {
                        message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult * math.floor(money)}},
                        mult_mod = self.ability.extra.mult * math.floor(money)
                    }
                end
            end
        elseif name == 'Bull' then
            
            self.tcg_calculate = function(self, context)
                if context.joker_main then
                    local money = (G.GAME.dollars + (G.GAME.dollar_buffer or 0)) + BalatroTCG.Status_Current.status.opponent_health
                    return {
                        message = localize{type='variable',key='a_chips',vars={self.ability.extra * math.floor(money)}},
                        chip_mod = self.ability.extra * math.floor(money)
                    }
                end
            end
        elseif name == "Steel Joker" then 
            self.tcg_calculate = function(self, context)
                if context.updating then
                    self.ability.steel_tally = 0
                    for k, v in pairs(G.playing_cards) do
                        if v.config.center == G.P_CENTERS.m_steel then self.ability.steel_tally = self.ability.steel_tally+1 end
                    end
                elseif context.joker_main and self.ability.steel_tally >= 1 then
                    local xmult = self.ability.extra * self.ability.steel_tally + 1
                    return {
                        message = localize{type='variable',key='a_xmult',vars={xmult}},
                        Xmult_mod = xmult,
                    }
                end
            end
        elseif name == "Stone Joker" then 
            self.tcg_calculate = function(self, context)
                if context.updating then
                    self.ability.stone_tally = 0
                    for k, v in pairs(G.playing_cards) do
                        if v.config.center == G.P_CENTERS.m_stone then self.ability.stone_tally = self.ability.stone_tally+1 end
                    end
                elseif context.joker_main and self.ability.stone_tally >= 1 then
                    local chips = self.ability.extra * self.ability.stone_tally
                    return {
                        message = localize{type='variable',key='a_chips',vars={chips}},
                        chip_mod = chips
                    }
                end
            end
        elseif name == "Joker Stencil" then 
            self.tcg_calculate = function(self, context)
                if context.updating then
                    self.ability.x_mult = (G.jokers.config.card_limit - #G.jokers.cards)
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i].ability.name == 'Joker Stencil' then self.ability.x_mult = self.ability.x_mult + 1 end
                    end
                elseif context.joker_main and self.ability.x_mult > 1 then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                        Xmult_mod = self.ability.x_mult,
                    }
                end
            end
        elseif name == 'Blueprint' then
            
            if self.name == "Blueprint" then
            end
            self.tcg_calculate = function(self, context)
                if context.updating then
                    local other_joker = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == self then other_joker = G.jokers.cards[i+1] end
                    end
                    if other_joker and other_joker ~= self and other_joker.config.center.blueprint_compat then
                        self.ability.blueprint_compat = 'compatible'
                    else
                        self.ability.blueprint_compat = 'incompatible'
                    end
                else
                    local other_joker = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == self then other_joker = G.jokers.cards[i+1] end
                    end
                    if other_joker and other_joker ~= self and not other_joker.debuff and not context.no_blueprint then
                        if (context.blueprint or 0) > #G.jokers.cards then return end
                        local old_context_blueprint = context.blueprint
                        context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
                        local old_context_blueprint_card = context.blueprint_card
                        context.blueprint_card = context.blueprint_card or self
                        local eff_card = context.blueprint_card
                        local other_joker_ret = other_joker:calculate_joker(context)
                        context.blueprint = old_context_blueprint
                        context.blueprint_card = old_context_blueprint_card
                        if other_joker_ret then 
                            other_joker_ret.card = eff_card
                            other_joker_ret.colour = G.C.BLUE
                            return other_joker_ret
                        end
                    end
                end
            end
        elseif name == 'Brainstorm' then
            self.tcg_calculate = function(self, context)
                if context.updating then
                    local other_joker = G.jokers.cards[1]
                    if other_joker and other_joker ~= self and other_joker.config.center.blueprint_compat then
                        self.ability.blueprint_compat = 'compatible'
                    else
                        self.ability.blueprint_compat = 'incompatible'
                    end
                else
                    local other_joker = G.jokers.cards[1]
                    if other_joker and other_joker ~= self and not other_joker.debuff and not context.no_blueprint then
                        if (context.blueprint or 0) > #G.jokers.cards then return end
                        local old_context_blueprint = context.blueprint
                        context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
                        local old_context_blueprint_card = context.blueprint_card
                        context.blueprint_card = context.blueprint_card or self
                        local eff_card = context.blueprint_card
                        local other_joker_ret = other_joker:calculate_joker(context)
                        context.blueprint = old_context_blueprint
                        context.blueprint_card = old_context_blueprint_card
                        if other_joker_ret then 
                            other_joker_ret.card = eff_card
                            other_joker_ret.colour = G.C.RED
                            return other_joker_ret
                        end
                    end
                end
            end
        elseif name == 'Swashbuckler' then
            

            self.tcg_calculate = function(self, context)
                if context.updating then
                    local sell_cost = 0
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] ~= self and (G.jokers.cards[i].area and G.jokers.cards[i].area == G.jokers) then
                            sell_cost = sell_cost + G.jokers.cards[i].sell_cost
                        end
                    end
                    sell_cost = sell_cost + BalatroTCG.Status_Current.status.opponent_joker_cost

                    self.ability.mult = sell_cost
                
                elseif context.joker_main and self.ability.mult > 0 then
                    return {
                        message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                        mult_mod = self.ability.mult
                    }
                end
            end
        elseif name == 'Odd Todd' then
            self.tcg_calculate = function(self, context)
                if context.individual and context.cardarea == G.play then
                    if context.other_card:is_rank_joker({3, 5, 7, 9, 14}) then
                        return {
                            chips = self.ability.extra,
                            card = self
                        }
                    end
                end
            end
        elseif name == 'Even Steven' then

            self.tcg_calculate = function(self, context)
                if context.individual and context.cardarea == G.play then
                    if context.other_card:is_rank_joker({2, 4, 6, 8, 10}) then
                        return {
                            mult = self.ability.extra,
                            card = self
                        }
                    end
                end
            end
        elseif name == 'Fibonacci' then
            self.tcg_calculate = function(self, context)
                if context.individual and context.cardarea == G.play then
                    if context.other_card:is_rank_joker({2, 3, 5, 8, 14}) then
                        return {
                            mult = self.ability.extra,
                            card = self
                        }
                    end
                end
            end
        elseif name == 'Perkeo' then

            self.tcg_calculate = function(self, context)
                if context.setting_blind and G.consumeables.cards[1] then
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed('perkeo')), nil)
                            card:set_edition({negative = true}, true)
                            card.tcg_extra.virtual = true
                            card:add_to_deck()
                            G.consumeables:emplace(card) 
                            return true
                        end}))
                    card_eval_status_text(context_blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                    return nil, true
                end
            end
        elseif name == 'Hallucination' then

            self.tcg_calculate = function(self, context)
                if context.before then
                    for k, card in pairs(context.full_hand) do
                        if not card:is_playing_card() then
                            if pseudorandom('halu') < G.GAME.probabilities.normal/self.ability.extra then
                                local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
                                
                                if card then
                                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()

                                        card.area:remove_card(card)
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
                                        self:juice_up(0.3, 0.5)
                                        return true
                                    end
                                    }))
                                    delay(0.6)
                                end
                            end
                            break
                        end
                    end
                    return nil, true
                end
            end
        elseif name == 'Luchador' then
            
            self.config.extra = 0.5

            self.tcg_calculate = function(self, context)
                if context.selling_self then
                    BalatroTCG.Status_Current:add_protection({ percent = self.ability.extra })
                end
            end
        elseif name == 'Diet Cola' then
            

            self.tcg_calculate = function(self, context)
                if context.selling_self then
                    ease_hands_played(1)
                    ease_discard(1)
                end
            end
        elseif name == 'Ceremonial Dagger' then
            
            
            self.tcg_calculate = function(self, context)
                if context.setting_blind and not self.getting_sliced and not context.blueprint then
                    local my_pos = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == self then my_pos = i; break end
                    end
                    if my_pos and G.jokers.cards[my_pos+1] and not self.getting_sliced and not SMODS.is_eternal(G.jokers.cards[my_pos+1], self) and not G.jokers.cards[my_pos+1].getting_sliced then
                        local sliced_card = G.jokers.cards[my_pos+1]
                        sliced_card.getting_sliced = true
                        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                        G.E_MANAGER:add_event(Event({func = function()
                            G.GAME.joker_buffer = 0

                            self:juice_up(0.8, 0.8)
                            sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                            play_sound('slice1', 0.96+math.random()*0.08)
                        return true end }))
                        SMODS.scale_card(self, {
                            ref_table = self.ability.extra,
                            ref_value = "mult",
                            scalar_table = sliced_card,
                            scalar_value = "sell_cost",
                            operation = function(ref_table, ref_value, initial, scaling)
                                ref_table[ref_value] = initial + ref_table['growth'] * scaling
                            end,
                            scaling_message = {
                                message = localize{type = 'variable', key = 'a_mult', vars = {self.ability.extra.mult + self.ability.extra.growth * sliced_card.sell_cost}},
                                colour = G.C.RED,
                                no_juice = true
                            }
                        })
                        return nil, true
                    end
                elseif context.joker_main and self.ability.extra.mult > 0 then
                    return {
                        message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                        mult_mod = self.ability.extra.mult
                    }
                end
            end
        elseif name == 'To the Moon' then
            
            self.blueprint_compat = true

            self.tcg_calculate = function(self, context)
                if not context.repetition and not context.individual and context.end_of_round then
                    local money = math.min(math.floor(BalatroTCG.Status_Current.status.dollars / 5), 5)
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money

                    G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                    
                    return {
                        dollars = money,
                        card = self
                    }
                end
            end
        elseif name == 'Delayed Gratification' then
            self.blueprint_compat = true

            self.tcg_calculate = function(self, context)
                if not context.repetition and not context.individual and context.end_of_round and G.GAME.current_round.discards_used == 0 and G.GAME.current_round.discards_left > 0 then
                    local money = G.GAME.current_round.discards_left * self.ability.extra
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money
                    G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                    
                    return {
                        dollars = money,
                        card = self
                    }
                end
            end
        elseif name == 'Greedy Joker' or name == 'Lusty Joker' or name == 'Wrathful Joker' or name == 'Gluttonous Joker' then
            self.tcg_estimate = function(self, context)
                if context.purchase == self then
                    local amount = G.FUNCS.get_card_amount(context.full_deck, function(e) return e:is_suit(self.ability.extra.suit) end) * G.FUNCS.card_vision(context.round_stats, 0, 0) / #context.full_deck
                    return {
                        play = {
                            any = {
                                mult = self.ability.extra.s_mult * amount
                            }
                        }
                    }
                end
            end
        elseif (self.config.t_mult or 0) > 0 or (self.config.t_chips or 0) > 0 then
            self.tcg_estimate = function(self, context)
                
            end
        elseif name == 'Business Card' then
            self.config.money = 2
            
            self.tcg_calculate = function(self, context)
                if context.individual and context.cardarea == G.play then
                    if context.other_card:is_face() and pseudorandom('business') < G.GAME.probabilities.normal/self.ability.extra then
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.money
                        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                        return {
                            dollars = self.ability.money,
                            card = self
                        }
                    end
                end
            end
            self.tcg_estimate = function(self, context)
                if context.purchase == self then

                    local amount = G.FUNCS.get_card_amount(context.full_deck, function(e) return e:is_face() == rank end) * G.FUNCS.card_vision(context.round_stats, 0, 0) / #context.full_deck

                    return {
                        money_per_round = amount * self.ability.money * G.GAME.probabilities.normal / self.ability.extra
                    }
                end
            end
        elseif name == '8 Ball' then
            self.tcg_calculate = function(self, context)
                if context.individual and context.cardarea == G.play and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    if context.other_card:is_rank_joker(8) and (SMODS.pseudorandom_probability(self, '8ball', 1, self.ability.extra)) then

                        local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
                        
                        if card then
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                                card.area:remove_card(card)
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
                                self:juice_up(0.3, 0.5)
                                return true
                            end
                            }))
                            delay(0.6)
                        end

                    end
                end
            end
        elseif name == 'Red Card' then
            self.config.extra = 6
            self.config.cards = 3
            

            self.tcg_calculate = function(self, context)
                if context.discard and context.other_card == context.full_hand[#context.full_hand] then
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
                elseif context.joker_main and self.ability.mult > 0 then
                    return {
                        message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                        mult_mod = self.ability.mult
                    }
                end
            end
            self.tcg_estimate = function(self, context)
                
            end
        elseif name == 'Throwback' then
            
            self.config.discards = 0
            
            self.tcg_calculate = function(self, context)
                if not context.repetition and not context.individual and context.end_of_round then
                    self.ability.discards = (self.ability.discards or 0) + G.GAME.current_round.discards_left
                    return {
                        message = localize('k_upgrade_ex'),
                        card = self
                    }
                elseif context.joker_main and self.ability.discards > 0 then
                    local x_mult = self.ability.extra * self.ability.discards + 1
                    return {
                        message = localize{type='variable',key='a_xmult',vars={x_mult}},
                        Xmult_mod = x_mult,
                    }
                end
            end
        elseif name == 'Rocket' then
            self.config.extra.dollars = 2
            self.config.extra.increase = 4
            self.config.extra.limit = 14
            
        elseif name == 'Flash Card' then
            self.config.extra = 1
            
        elseif name == 'Acrobat' then
            self.config.scaling = 0.25
            self.config.initial = 1
            
        elseif name == 'Campfire' then
            self.config.extra = 1.5
            self.config.reduce = 1
            
        elseif name == 'Vagabond' then
            
        elseif name == 'Square Joker' then
            
        elseif name == 'Dusk' then
            self.config.extra = 10
            
        elseif name == 'Cloud 9' then
            self.config.extra = 2
            
            self.blueprint_compat = false
            self.tcg_calculate = function(self, context)
                if context.tcg_take_damage and not context.blueprint then
                    return {
                        reduce = math.floor(self.ability.nine_tally / self.ability.extra)
                    }
                elseif context.updating then
                    self.ability.nine_tally = 0
                    for k, v in pairs(G.playing_cards) do
                        if v:is_rank_joker(9) then self.ability.nine_tally = self.ability.nine_tally+1 end
                    end
                end
            end
        elseif name == 'Troubadour' then
            

            self.tcg_add_to_deck = function(self, from_debuff)
                G.hand:change_size(self.ability.extra.h_size)
                BalatroTCG.Status_Current.params.discards = BalatroTCG.Status_Current.params.discards + self.ability.extra.h_plays
            end
            self.tcg_remove_from_deck = function(self, from_debuff)
                G.hand:change_size(-self.ability.extra.h_size)
                BalatroTCG.Status_Current.params.discards = BalatroTCG.Status_Current.params.discards - self.ability.extra.h_plays
            end
        elseif name == 'Golden Joker' then
            self.config.extra = 2
            
            self.tcg_calculate = function(self, context)
                if context.tcg_take_damage and not context.blueprint then
                    return {
                        reduce = self.ability.extra
                    }
                end
            end
        elseif name == 'Mr. Bones' then
            self.config.extra = 5
            
            self.tcg_calculate = function(self, context)
                if context.tcg_take_damage and not context.blueprint then
                    local count = 0

                    for k, v in ipairs(G.jokers.cards) do
                        if v.ability.name == 'Mr. Bones' then count = count + 1 end
                    end
                    return {
                        percent = (self.ability.extra * count) / 100.0
                    }
                end
            end
        elseif name == 'Chicot' then
            self.config.extra = 3
            
        elseif name == 'Showman' then
            
        elseif name == 'Chaos the Clown' then
            
            
        elseif name == 'Matador' then
            self.eternal_compat = false
            self.blueprint_compat = false
            
            self.tcg_calculate = function(self, context)
                if context.tcg_take_damage and not context.blueprint then
                    return {
                        redirect = self,
                    }
                end
            end
        end
    end

    BalatroTCG.ModifiedCenters[self.key] = self

    return self
end

function TCG_Override_Desc(self, _c, loc_vars)
    
    local ability = self and self.ability or _c.config

    if _c.name == 'Ancient Joker' and self then loc_vars = {ability.extra, localize(self:get_ability_suit(G.GAME.current_round.ancient_card.suit), 'suits_singular'), colours = {G.C.SUITS[self:get_ability_suit(G.GAME.current_round.ancient_card.suit)]}}
    elseif _c.name == 'Campfire' then loc_vars = {ability.extra, ability.reduce, ability.x_mult}
    elseif _c.name == 'Acrobat' then loc_vars = { ability.scaling, ((BalatroTCG.Status_Current and (BalatroTCG.Status_Current.status.round - 1) or 0) * ability.scaling + ability.initial)}
    elseif _c.name == 'Red Card' then loc_vars = { ability.extra, ability.cards, ability.mult }
    elseif _c.name == 'Rocket' then loc_vars = {ability.extra.dollars, ability.extra.increase, ability.extra.limit}
    elseif _c.name == 'Fortune Teller' then loc_vars = {ability.extra, (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0) * ability.extra}    
    elseif _c.name == 'Superposition' then loc_vars = {ability.extra}
    elseif _c.name == 'Cloud 9' then loc_vars = {ability.extra, math.floor((ability.nine_tally or 0) / ability.extra)}
    elseif _c.name == 'Blue Joker' then loc_vars = {ability.extra, ability.extra*((G.deck and G.deck.cards) and #G.deck.cards or 60)}
    elseif _c.name == 'Chicot' then loc_vars = {ability.extra}
    elseif _c.name == 'Golden Joker' then loc_vars = {ability.extra}
    elseif _c.name == 'Dusk' then loc_vars = {ability.extra}
    elseif _c.name == 'Dusk' then loc_vars = {ability.extra}
    elseif _c.name == 'Mr. Bones' then loc_vars = {ability.extra}
    elseif _c.name == 'Swashbuckler' then loc_vars = {ability.mult + (BalatroTCG.Status_Current and BalatroTCG.Status_Current.status.opponent_joker_cost or 0)}
    elseif _c.name == 'Throwback' then loc_vars = {ability.extra, ability.extra * ability.discards + 1}
    elseif _c.name == 'Ceremonial Dagger' then loc_vars = {ability.extra.growth, ability.extra.mult}
    elseif _c.name == 'Abstract Joker' then loc_vars = {ability.extra, ((G.jokers and G.jokers.cards and #G.jokers.cards or 0) + (BalatroTCG.Status_Current and #BalatroTCG.Status_Current.opponentJokers.cards or 0))*ability.extra}
    elseif _c.name == 'Supernova' then loc_vars = {ability.extra}
    elseif _c.name == 'Luchador' then loc_vars = {math.floor(ability.extra * 100)}
    elseif _c.name == 'Bootstraps' then loc_vars = {ability.extra.mult, ability.extra.mult * math.floor(BalatroTCG.Status_Current and (BalatroTCG.Status_Current.status.dollars + (G.GAME.dollar_buffer or 0) + BalatroTCG.Status_Current.status.opponent_health) or 0)}
    elseif _c.name == 'Bull' then loc_vars = {ability.extra, ability.extra*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0) + (BalatroTCG.Status_Current and BalatroTCG.Status_Current.status.opponent_health or 0)))}

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

    elseif _c.name == 'Reroll Surplus' then loc_vars = { ability.extra }
    elseif _c.name == 'Seed Money' then loc_vars = { ability.extra }
    elseif _c.name == 'Money Tree' then loc_vars = { BalatroTCG.Status_Current and BalatroTCG.Status_Current.status.seed_reduction or 0 }
    elseif _c.name == 'Reroll Glut' then loc_vars = { ability.extra }
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
    
    elseif _c.name == 'Lucky Card' then loc_vars = { G.GAME.probabilities.normal, BalatroTCG.Settings.Unbalance and 15 or 10, ability.p_dollars};

    end

    _c.vars = loc_vars or _c.vars

    return loc_vars
end

function Card:set_tcg_max_health(_amount)

    self.tcg_extra.has_health = true
    self.tcg_extra.health_amount = _amount
    self.tcg_extra.max_health = _amount
end
function Card:set_tcg_health(_amount) 
    if not self.ability.eternal then
        if _amount <= 0 then
            self:start_dissolve()
        else
            self.tcg_extra.has_health = true
            self.tcg_extra.health_amount = math.min(_amount, self.tcg_extra.max_health or 25)
        end
    end
end
function Card:remove_tcg_health(_amount) 
    if not self.ability.eternal then
        self.tcg_extra.health_amount = (self.tcg_extra.health_amount or 0)
        if self.tcg_extra.health_amount - _amount <= 0 then
            self.skip_destroy_animation = true
        end
        self:set_tcg_health(self.tcg_extra.health_amount - _amount)

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

        card_eval_status_text(self, 'extra', nil, nil, nil, {message = tostring(self.tcg_extra.health_amount), colour = G.C.RED})

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            blockable = false,
            delay =  0.5*dissolve_time,
            func = (function() childParts:fade(0.15*dissolve_time) return true end)
        }))
    end
end