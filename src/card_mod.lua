
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

    ranks = get_mapped_ranks(ranks)

    for _, r in ipairs(ranks) do
        if self:get_id() == r then return true end
    end
    return false
end

function get_mapped_ranks(ranks)

    if type(ranks) ~= 'table' then ranks = {ranks} end

    if BalatroTCG.GameActive then
        
        for k, v in ipairs(BalatroTCG.Status_Current.backs) do

            -- Find a way to make this not hard coded.
            if v.name == 'b_mp_gradient' then
		        local temp = {}
                for i, v in ipairs(ranks) do
                    temp[v - 1] = true
                    temp[v] = true
                    --temp[v + 1] = true
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

    return ranks
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
            if not BalatroTCG.Status_Current.params.destroy_tarots then self.tcg_todeck = true end
        elseif self.ability.set == 'Spectral' then
            if not BalatroTCG.Status_Current.params.destroy_spectrals then self.tcg_todeck = true end
        end

        if self.debuff then return nil end
        local used_tarot = copier or self
        local obj = self.config.center
        
        if self.config.center.tcg_modifier then
            self.config.center.tcg_modifier.use_consumeable(self, area, copier, not BalatroTCG.Settings.Unbalance, use_consumeable_ref)
            return
        else
            use_consumeable_ref(self, area, copier)
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

    -- Just preventing some jokers from failing if they check if their in the joker slots
    if context.area == G.consumeables then
        context.area = G.jokers
    end

    if self.config.center.tcg_modifier and self.config.center.tcg_modifier.calculate_context then
        return self.config.center.tcg_modifier.calculate_context(self, context, not BalatroTCG.Settings.Unbalance)
    end
    
    -- if self.ability.set == "Joker" then

    --     if context.selling_self then
    --     elseif context.placed_in_deck then
    --     elseif context.buying_card then
    --     elseif context.selling_card then
    --     elseif context.playing_card_added and not self.getting_sliced then
    --     elseif context.first_hand_drawn then
    --     elseif context.setting_blind and not self.getting_sliced then
    --         if self.ability.name == 'Chicot' and not context.blueprint then
        
    --             G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
    --                 for k, v in ipairs(G.jokers.cards) do
    --                     self:juice_up(0.3, 0.4)
    --                     play_sound('tarot1')
    --                     v:set_tcg_health((v.ability.tcgb_health_amount or 0) + self.ability.extra)
    --                     delay(0.4)
    --                 end
    --                 return true end
    --             }))
    --             return nil
    --         end
            
    --         if self.ability.name == 'Cartomancer' and not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                
    --             local card = pick_from_areas(function (c) return c.ability.set == 'Tarot' end, {G.deck, G.discard, G.graveyard})
                
    --             if card then
    --                 G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
    --                 G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
    --                     if card.area then card.area:remove_card(card) end
    --                     card:start_materialize()
    --                     G.consumeables:emplace(card)

    --                     for _, c in ipairs(G.playing_cards) do
    --                         if c == card then
    --                             goto skip
    --                         end
    --                     end
    --                     table.insert(G.playing_cards, card)
    --                     ::skip::
    --                     G.GAME.consumeable_buffer = 0
    --                     play_sound('timpani')
    --                     self:juice_up(0.3, 0.5)
    --                     return true
    --                 end
    --                 }))
    --                 delay(0.6)
    --             end
                
    --             return nil
    --         end
    --     elseif context.destroying_card and not context.blueprint then
    --         if self.ability.name == 'Sixth Sense' and #context.full_hand == 1 and context.full_hand[1]:is_rank_joker(6) and G.GAME.current_round.hands_played == 0 then
                
    --             if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        
    --                 local card = pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard})
                    
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
    --                     card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
    --                     delay(0.6)
    --                 end
    --             end
    --             return true
    --         end
    --     elseif context.cards_destroyed then
    --     elseif context.remove_playing_cards then
    --     elseif context.using_consumeable then
    --         if self.ability.name == 'Fortune Teller' and not context.blueprint and (context.consumeable.ability.set == "Tarot") then
    --             G.E_MANAGER:add_event(Event({
    --                 func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={G.GAME.consumeable_usage_total.tarot * self.ability.extra}}}); return true
    --                 end}))
    --             return nil, true
    --         end
    --     elseif context.pre_discard then
    --         if self.ability.name == 'Campfire' then
    --             if self.ability.x_mult <= 1 then 
    --                 return nil
    --             else
    --                 self:juice_up(0.3, 0.4)
    --                 play_sound('timpani')
    --                 self.ability.x_mult = math.floor((self.ability.x_mult * (1 - (self.ability.reduce / 100))) * 10) / 10
    --             end
    --         end
    --     elseif context.discard then
    --         if self.ability.name == 'Trading Card' and balanced and not context.blueprint and G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
    --             return {
    --                 delay = 0.45, 
    --                 remove = true,
    --                 card = self
    --             }
    --         end
    --         if self.ability.name == 'Castle' and self.tcg_extra.suit then
    --         end
    --         if self.ability.name == 'Mail-In Rebate' then
    --         end
    --         if self.ability.name == 'Hit the Road' then
    --         end
    --         if self.ability.name == 'Red Card' and context.other_card == context.full_hand[#context.full_hand] then
    --             local face_cards = 0
    --             for k, v in ipairs(context.full_hand) do
    --                 if not v:is_playing_card() then face_cards = face_cards + 1 end
    --             end
    --             if face_cards >= self.ability.cards then
    --                 SMODS.scale_card(self, {
    --                     ref_table = self.ability,
    --                     ref_value = "mult",
    --                     scalar_value = "extra",
    --                     message_key = 'a_mult',
    --                     message_colour = G.C.RED
    --                 })
    --             end
    --         end
    --     elseif context.end_of_round then
    --         if context.repetition then
    --         elseif context.individual then
    --             if self.ability.name == 'Flash Card' and not context.blueprint then
    --                 if not context.other_card:is_playing_card() then
    --                     self.ability.mult = self.ability.mult + self.ability.extra
                        
    --                     SMODS.calculate_effect({ message = localize({type='variable',key='a_mult',vars={self.ability.extra}}), colour = G.C.RED}, context.other_card)
    --                 end
    --             end
    --         elseif not context.blueprint then
    --             if self.ability.name == 'Rocket' then
    --             end
    --             if self.ability.name == 'Mr. Bones' then
    --                 return nil
    --             end
    --         end
    --     elseif context.individual then
            
    --         if context.cardarea == G.play then

    --             if self.ability.name == 'Photograph' then
    --             end
    --             if self.ability.name == 'The Idol' then
                    
    --             end
                
    --             if self.ability.name == 'Business Card' then
    --                 if context.other_card:is_face() and pseudorandom('business') < G.GAME.probabilities.normal/self.ability.extra then
    --                     G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.money
    --                     G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
    --                     return {
    --                         dollars = self.ability.money,
    --                         card = self
    --                     }
    --                 else
    --                     return nil
    --                 end
    --             end
    --             if self.ability.name == 'Rough Gem' then
    --                 local suit = self:get_ability_suit("Diamonds")
                    
    --                 if context.other_card:is_suit(suit) then
    --                     G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
    --                     G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))

    --                     return {
    --                         dollars = self.ability.extra,
    --                         card = self,
    --                     }
    --                 end
    --             end
    --             if self.ability.name == 'Onyx Agate' then
    --                 local suit = self:get_ability_suit("Clubs")

    --                 if context.other_card:is_suit(suit) then
    --                     return {
    --                         mult = self.ability.extra,
    --                         card = self
    --                     }
    --                 else
    --                     return nil
    --                 end
    --             end
    --             if self.ability.name == 'Arrowhead' then
    --                 local suit = self:get_ability_suit("Spades")
    --                 if context.other_card:is_suit(suit) then
    --                     return {
    --                         chips = self.ability.extra,
    --                         card = self
    --                     }
    --                 else
    --                     return nil
    --                 end
    --             end
    --             if self.ability.name == 'Ancient Joker' then

    --             end
    --         end
    --         if context.cardarea == G.hand then
    --         end
    --         if context.cardarea == G.hand then
    --         end
    --     elseif context.other_joker then
    --     elseif context.debuffed_hand then
    --     else
    --         if context.cardarea == G.jokers then
    --             if context.before then
    --             elseif context.after then
    --                 if self.ability.name == 'Campfire' then
    --                     if self.ability.x_mult <= 1 then 
    --                         return nil
    --                     else
    --                         self:juice_up(0.3, 0.4)
    --                         play_sound('timpani')
    --                         self.ability.x_mult = math.floor((self.ability.x_mult * (1 - (self.ability.reduce / 100))) * 10) / 10
    --                     end
    --                 end
    --             elseif context.joker_main then
                    
    --                 if self.ability.name == 'Abstract Joker' then
    --                     local x = 0
    --                     for i = 1, #G.jokers.cards do
    --                         if G.jokers.cards[i].ability.set == 'Joker' then x = x + 1 end
    --                     end
    --                     x = x + #BalatroTCG.Status_Current.opponentJokers.cards
    --                     return {
    --                         message = localize{type='variable',key='a_mult',vars={x*self.ability.extra}},
    --                         mult_mod = x*self.ability.extra
    --                     }
    --                 end
    --                 if self.ability.name == 'Fortune Teller' and G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot > 0 then
    --                     return {
    --                         message = localize{type='variable',key='a_mult',vars={G.GAME.consumeable_usage_total.tarot * self.ability.extra}},
    --                         mult_mod = G.GAME.consumeable_usage_total.tarot * self.ability.extra
    --                     }
    --                 end
    --                 if self.ability.name == 'Acrobat' then
    --                     local xmult = (BalatroTCG.Status_Current.status.round - 1) * self.ability.scaling + self.ability.initial
                        
    --                     if xmult > 1 then
    --                         return {
    --                             message = localize{type='variable',key='a_xmult',vars={xmult}},
    --                             Xmult_mod = xmult
    --                         }
    --                     else
    --                         return nil
    --                     end
    --                 end
    --                 if self.ability.name == 'Matador' then
    --                     return nil
    --                 end
    --                 if self.ability.name == 'Supernova' then
    --                 end
    --                 if self.ability.name == 'Vagabond' then

    --                 end
    --                 if self.ability.name == 'Superposition' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
    --                 end
    --                 if self.ability.name == 'Seance' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
    --                     if next(context.poker_hands[self.ability.extra.poker_hand]) then
    --                         local card = pick_from_areas(function (c) return c.ability.set == 'Spectral' end, {G.deck, G.discard, G.graveyard})
    --                         if card then
    --                             G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
    --                             G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                                    
    --                                 if card.area then card.area:remove_card(card) end
    --                                 card:start_materialize()
    --                                 G.consumeables:emplace(card)
                                    
    --                                 for _, c in ipairs(G.playing_cards) do
    --                                     if c == card then
    --                                         goto skip
    --                                     end
    --                                 end
    --                                 table.insert(G.playing_cards, card)
    --                                 ::skip::

    --                                 G.GAME.consumeable_buffer = 0
    --                                 play_sound('timpani')
    --                                 self:juice_up(0.3, 0.5)
    --                                 return true
    --                             end
    --                             }))
    --                             delay(0.6)
    --                             return {
    --                                 message = localize('k_plus_spectral'),
    --                                 colour = G.C.SECONDARY_SET.Spectral,
    --                                 card = self
    --                             }
    --                         end
    --                     end
    --                     return nil
    --                 end
    --                 if self.ability.name == 'Card Sharp' then
                        
    --                     local ret = nil

    --                     if BalatroTCG.Status_Current.status.last_hand and context.scoring_name == BalatroTCG.Status_Current.status.last_hand then
    --                         ret = {
    --                             message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}},
    --                             Xmult_mod = self.ability.extra.Xmult,
    --                         }
    --                     end

    --                     return ret
    --                 end

    --             end
    --         end
    --     end
    -- end
    
    return calculate_joker_ref(self, context)
end

local set_ability_ref = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    if BalatroTCG.UseTCG_UI then
        center = create_tcg_center(center)

        -- self.config.center_key = center.key
    end

    set_ability_ref(self, center, initial, delay_sprites)
    
    if BalatroTCG.UseTCG_UI then
        self.config.center_key = center.key
    end
end

function copy_center(center)
    
    local newcenter = {}
    for k, v in pairs(center) do
        newcenter[k] = v
    end
    newcenter.config = copy_table(center.config)

    setmetatable(newcenter, getmetatable(center))

    return newcenter
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
    
    local center = copy_center(self)

    self = center

    self.tcg_estimate = nil
    
    local name = self.name


    local modifier = nil
    
    if self.set == 'Enhanced' then

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
        
        if BalatroTCG.VoucherMods[self.key] then
            modifier = BalatroTCG.VoucherMods[self.key]
        end
    elseif self.set == 'Joker' then
        
        if BalatroTCG.JokerMods[self.key] then
            modifier = BalatroTCG.JokerMods[self.key]
        end
    else
        
        if BalatroTCG.ConsumeableMods['key__' .. self.key] then
            modifier = BalatroTCG.ConsumeableMods['key__' .. self.key]
        elseif self.effect and BalatroTCG.ConsumeableMods['effect__' .. self.effect] then
            modifier = BalatroTCG.ConsumeableMods['effect__' .. self.effect]
        end
    end

    if modifier then
        self.tcg_modifier = modifier
        modifier.modify(self, not BalatroTCG.Settings.Unbalance)

        self.cost = modifier.get_cost(self.cost, not BalatroTCG.Settings.Unbalance) or self.cost

        if BalatroTCG.Settings.Unbalance then
            if not modifier.description_override.none then
                self.use_original_desc = true
            end
        else
            if not modifier.description_override.balanced then
                self.use_original_desc = true
            end
        end
    end

    G.P_CENTERS[self.key] = self

    return self
end

function TCG_Override_Desc(self, _c)
    
    local loc_vars = nil

    local ability = self and self.ability or _c.config

    if _c.use_original_desc then return end

    if _c.tcg_modifier and _c.tcg_modifier.loc_vars then
        loc_vars = _c.tcg_modifier.loc_vars(ability, card, not BalatroTCG.Settings.Unbalance) or loc_vars
    elseif _c.name == 'Ancient Joker' and self then loc_vars = {ability.extra, localize(self:get_ability_suit(G.GAME.current_round.ancient_card.suit), 'suits_singular'), colours = {G.C.SUITS[self:get_ability_suit(G.GAME.current_round.ancient_card.suit)]}}
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
    elseif _c.name == "Driver's License" then loc_vars = {ability.extra, ability.tally_amount, ability.driver_tally or '0'}
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
    if next(SMODS.find_card('j_chaos')) then
        self.ability.tcgb_sticker_hidden = true
    else
        self.ability.tcgb_sticker_visible = true
    end
    self.ability.tcgb_health_amount = _amount
    self.ability.tcgb_max_health = _amount
end
function Card:set_tcg_health(_amount) 
    if not self.tcg_extra.has_health then
        self:set_tcg_max_health(BalatroTCG.Status_Current.params.joker_health)
    elseif not self.ability.eternal then
        if _amount <= 0 then
            SMODS.calculate_context({ joker_dying = self, status = BalatroTCG.Status_Current })
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