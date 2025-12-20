
--Class
TCG_AI = Object:extend()

function TCG_AI:init()
    self.chip_power = 1
    self.mult_power = 5
    self.x_mult_power = 20
    self.money_power = 10
    self.purchase_fear = 25

    self.bet_min = 0
    self.bet_max = 4
end

function lerp(t, a, b)
    return a * (1 - t) + b * t
end

function TCG_AI:run()
    if G.STATE ~= G.STATES.SELECTING_HAND or #G.hand.cards == 0 then return end

    if #G.hand.highlighted > 0 then
        if self.button == 'purchase' then
            local card = G.hand.highlighted[1]
            if card and card.area == G.hand then
                
                card.from_area = card.area
                card.area:remove_card(card)
                if card.children.price then card.children.price:remove() end
                card.children.price = nil
                if card.children.buy_button then card.children.buy_button:remove() end
                card.children.buy_button = nil
                if card.ability.consumeable then
                    G.consumeables:emplace(card)
                else
                    G.jokers:emplace(card)
                end
                
            end
        else
            local button = G.buttons:get_UIE_by_ID(self.button)
            button:click()
        end
    elseif not self.run_event then
        self.run_event = Event({
            trigger = 'immediate',
            func = function()

                if #G.play.cards > 0 then
                    print('Skipping')
                    self.run_event = nil
                    return true
                end

                print('')
                print('')
                print('')
                print('Analyzing')
                
                local hand_strength = {}

                local status = BalatroTCG.Status_Current
                local other = BalatroTCG.Status_Other

                local budget = status.status.dollars + status.status.bankrupt_at
                local hand_power, discard_power = 4, 4
                local hand_amount = (G.GAME.current_round.hands_left - 1) * hand_power
                local discard_amount = G.GAME.current_round.discards_left * discard_power

                local rounds_left = math.min(status.status.dollars, other.status.dollars) / lerp((status.status.round) / 15, 1, 3)  

                for _, card in ipairs(G.consumeables.cards) do
                    
                    stats = {
                        card = card,
                        cost = card.sell_cost,
                        money_now = 0,
                        money_next_hand = 0,
                        money_per_round = 0,
                    }
                    
                    G.FUNCS.merge_stats(stats, card:estimate_score({ purchase = card, full_deck = full_deck, round_stats = round_stats }))
                    
                    for _, joker in ipairs(G.jokers.cards) do
                        G.FUNCS.merge_stats(stats, joker:estimate_score({ purchase = card, full_deck = full_deck, round_stats = round_stats }))
                    end

                    stats.money_total = stats.money_now + (rounds_left > 1 and stats.money_next_hand or 0) + (stats.money_per_round * rounds_left) - stats.cost

                    if stats.money_total > 0 then

                        local nc
                        local obj = card.config.center
                        if obj.keep_on_use and type(obj.keep_on_use) == 'function' then
                            nc = obj:keep_on_use(card)
                        end
                        if nc then
                            --play_sound('cardSlide2', nil, 0.3)
                            dont_dissolve = true
                        end
                        --if not nc then draw_card(G.hand, G.play, 1, 'up', true, card, nil, mute) end
                        delay(0.2)

                        card:use_consumeable(area)
                        SMODS.calculate_context({using_consumeable = true, consumeable = card, area = card.from_area})
                        card:start_dissolve()
                        
                        print('Using ' .. card.ability.name)

                        delay(1.2)

                        
                        self.run_event = nil
                        return true
                    end

                end

                local ranks = {}
                local suits = {}
                for _, hc in ipairs(G.hand.cards) do
                    if hc:is_playing_card() then
                        ranks[hc.base.id] = (ranks[hc.base.id] or 0) + 1
                        suits[hc.base.suit] = (suits[hc.base.suit] or 0) + 1
                    end
                end
                local ranks_deck = {}
                local suits_deck = {}
                for _, hc in ipairs(G.deck.cards) do
                    if hc:is_playing_card() then
                        ranks_deck[hc.base.id] = (ranks_deck[hc.base.id] or 0) + 1
                        suits_deck[hc.base.suit] = (suits_deck[hc.base.suit] or 0) + 1
                    end
                end
                

                local hands = evaluate_poker_hand(G.hand.cards)
                local card_stats = { }
                local full_deck = tableMerge(G.hand.cards, tableMerge(G.discard.cards, G.deck.cards))
                local round_stats = get_TCG_params(status.back_key)

                round_stats.discard_power = discard_power
                round_stats.hand_power = hand_power

                for _, joker in ipairs(G.jokers.cards) do
                    G.FUNCS.merge_stats(round_stats, joker:estimate_score({ set_round_stats = true, round_stats = round_stats, full_deck = full_deck }))
                end

                for k, v in ipairs(G.hand.cards) do
                    local stats = nil
                    if v:is_playing_card() then
                        stats = {
                            card = v,
                            play = {
                                any = {
                                    chips = v:get_chip_bonus({tcg_predict = true}),
                                    mult = v:get_chip_mult({tcg_predict = true}),
                                    x_mult = math.max(v:get_chip_x_mult({tcg_predict = true}), 1),
                                    dollars = v:get_p_dollars({tcg_predict = true})
                                }
                            },
                            hold = {
                                any = {
                                    chips = v:get_chip_h_bonus({tcg_predict = true}),
                                    mult = v:get_chip_h_mult({tcg_predict = true}),
                                    x_mult = math.max(v:get_chip_h_x_mult({tcg_predict = true}), 1),
                                    dollars = v:get_h_dollars({tcg_predict = true})
                                }
                            },
                            discard = {
                                any = {
                                    chips = 0,
                                    mult = 0,
                                    x_mult = 1,
                                    dollars = 0,
                                }
                            },
                            buy_stat = -1,
                            money_total = 0
                        }
                        
		                for _, joker in ipairs(G.jokers.cards) do
                            G.FUNCS.merge_stats(stats, joker:estimate_score({ in_hand = true, hand = G.hand.cards, other_card = v, round_stats = round_stats }))
                        end

                        local play_stat = 0
                        
		                for _, data in pairs(stats.play) do
                            play_stat = play_stat + (data.chips * self.chip_power + data.mult * self.mult_power + math.log(math.max(data.x_mult, 1)) * self.x_mult_power + data.dollars * self.money_power)
                        end
		                for _, data in pairs(stats.hold) do
                            play_stat = play_stat - (data.chips * self.chip_power + data.mult * self.mult_power + math.log(math.max(data.x_mult, 1)) * self.x_mult_power + data.dollars * self.money_power)
                        end
		                for _, data in pairs(stats.discard) do
                            play_stat = play_stat - (data.chips * self.chip_power + data.mult * self.mult_power + math.log(math.max(data.x_mult, 1)) * self.x_mult_power + data.dollars * self.money_power)
                        end
                        stats.play_stat = play_stat

                        --print('Stats for ' .. tostring(v.base.id) .. ' ' .. tostring(v.base.suit) .. ': ' .. tostring(play_stat))
                        
                    else
                        stats = {
                            card = v,
                            cost = v.cost,
                            money_now = 0,
                            money_next_hand = 0,
                            money_per_round = 0,
                            play_stat = 0,
                            chips = 0,
                            mult = 0,
                            x_mult = 1,
                            retriggers = 0,
                        }
                        
                        G.FUNCS.merge_stats(stats, v:estimate_score({ purchase = v, full_deck = full_deck, round_stats = round_stats }))
                        
		                for _, joker in ipairs(G.jokers.cards) do
                            G.FUNCS.merge_stats(stats, joker:estimate_score({ purchase = v, full_deck = full_deck, round_stats = round_stats }))
                        end
                        
                        stats.money_total = stats.money_now + (rounds_left > 1 and stats.money_next_hand or 0) + (stats.money_per_round * rounds_left) - stats.cost
                        
                        stats.buy_stat = (stats.chips * self.chip_power + stats.mult * self.mult_power + math.log(math.max(stats.x_mult, 1)) * self.x_mult_power) - (stats.cost / budget) * self.purchase_fear
                        
                        print(v.ability.name .. ', ' .. tostring(stats.buy_stat))
                    end
                    stats.discard_weight = {
                        any = 0,
                    }
                    card_stats[v] = stats
                end
                
                local strength = {}
                for k, v in pairs(hands) do
                    if k ~= 'top' then 
                        strength[k] = {
                            cards = v,
                            chips = G.GAME.hands[k].chips,
                            mult = G.GAME.hands[k].mult,
                        }
                        --print('Can play ' .. k)

                        local best, weight = {}, 0
                        
                        for ind = 1, #v do
                            local cards = SMODS.shallow_copy(v[ind])
                            local can_remove = true

                            --print(k .. tostring(ind) .. ', ' .. #cards)

                            while #cards > 1 and can_remove do
                                can_remove = false
                                local best_removal, removal_stat = 0, 100000
                                
                                for i = #cards, 1, -1 do
                                    local removed = table.remove(cards, i)

                                    local eval = evaluate_poker_hand(cards)
                                    if #eval[k] > 0 and removal_stat > card_stats[removed].play_stat then
                                        removal_stat = card_stats[removed].play_stat
                                        can_remove = true
                                        best_removal = i
                                    end

                                    table.insert(cards, i, removed)
                                end

                                if best_removal > 0 then
                                    table.remove(cards, best_removal)
                                end
                            end

                            local cweight = 0
                            for __, c in pairs(cards) do
                                cweight = cweight + card_stats[c].play_stat
                            end
                            if weight < cweight then
                                best = cards
                                weight = cweight
                            end
                        end


                        if #best > 0 and #best <= 5 then
                            --print(k .. ' size is ' .. tostring(#best))
                            strength[k].cards = best

                            for __, card in ipairs(strength[k].cards) do
                                card_stats[card].discard_weight[k] = -1
                            end

                            strength[k].canplay = 1  
                        else
                            local chance = 0

                            local pulls = math.floor(hand_amount + discard_amount)
                            local max_req = next(find_joker('Four Fingers')) and 4 or 5
                            
                            if k == "Flush Five" then
                                
                            elseif k == "Flush House" then

                            elseif k == "Five of a Kind" then
                                local rank_search = nil

                                for _, hc in ipairs(G.hand.cards) do
                                    if hc:is_playing_card() then
                                        local c = G.deck:chance_rank(hc.base.id, pulls, 5 - ranks[hc.base.id])
                                        if c > chance then
                                            chance = c
                                            rank_search = hc.base.id
                                        end
                                    end
                                end
                                for r, _ in ipairs(ranks_deck) do
                                    local c = G.deck:chance_rank(r, pulls, 5)
                                    if c > chance then
                                        chance = c
                                        rank_search = hc.base.id
                                    end
                                end

                                for _, hc in ipairs(G.hand.cards) do
                                    if hc:is_playing_card() and hc.base.id == rank_search then
                                        card_stats[hc].discard_weight[k] = -1
                                    end
                                end

                            elseif k == "Straight Flush" then -- double fuck

                            elseif k == "Four of a Kind" then
                                local rank_search = nil

                                for _, hc in ipairs(G.hand.cards) do
                                    if hc:is_playing_card() then
                                        local c = G.deck:chance_rank(hc.base.id, pulls, 4 - ranks[hc.base.id])
                                        if c > chance then
                                            chance = c
                                            rank_search = hc.base.id
                                        end
                                    end
                                end
                                for r, _ in ipairs(ranks_deck) do
                                    local c = G.deck:chance_rank(r, pulls, 4)
                                    if c > chance then
                                        chance = c
                                        rank_search = hc.base.id
                                    end
                                end

                                for _, hc in ipairs(G.hand.cards) do
                                    if hc:is_playing_card() and hc.base.id == rank_search then
                                        card_stats[hc].discard_weight[k] = -1
                                    end
                                end

                            elseif k == "Full House" then

                            elseif k == "Flush" then

                                local suit_search = nil
                                for _, hc in ipairs(G.hand.cards) do
                                    if hc:is_playing_card() then
                                        local c = G.deck:chance_suit(hc.base.suit, pulls, max_req - suits[hc.base.suit])
                                        if c > chance then
                                            chance = c
                                            suit_search = hc.base.suit
                                        end
                                    end
                                end
                                for s, _ in ipairs(suits_deck) do
                                    local c = G.deck:chance_suit(s, pulls, max_req)
                                    if c > chance then
                                        chance = c
                                        suit_search = s
                                    end
                                end

                                for _, hc in ipairs(G.hand.cards) do
                                    if hc:is_playing_card() and hc:is_suit(suit_search) then
                                        card_stats[hc].discard_weight[k] = -1
                                    end
                                end

                            elseif k == "Straight" then -- fuck

                            elseif k == "Three of a Kind" then
                                local rank_search = nil

                                for _, hc in ipairs(G.hand.cards) do
                                    if hc:is_playing_card() then
                                        local c = G.deck:chance_rank(hc.base.id, pulls, 3 - ranks[hc.base.id])
                                        if c > chance then
                                            chance = c
                                            rank_search = hc.base.id
                                        end
                                    end
                                end
                                for r, _ in ipairs(ranks_deck) do
                                    local c = G.deck:chance_rank(r, pulls, 3)
                                    if c > chance then
                                        chance = c
                                        rank_search = hc.base.id
                                    end
                                end

                                for _, hc in ipairs(G.hand.cards) do
                                    if hc:is_playing_card() and hc.base.id == rank_search then
                                        card_stats[hc].discard_weight[k] = -1
                                    end
                                end

                            elseif k == "Two Pair" then

                            elseif k == "Pair" then
                                local rank_search = nil

                                for _, hc in ipairs(G.hand.cards) do
                                    if hc:is_playing_card() then
                                        local c = G.deck:chance_rank(hc.base.id, pulls, 2 - ranks[hc.base.id])
                                        if c > chance then
                                            chance = c
                                            rank_search = hc.base.id
                                        end
                                    end
                                end
                                for r, _ in ipairs(ranks_deck) do
                                    local c = G.deck:chance_rank(r, pulls, 2)
                                    if c > chance then
                                        chance = c
                                        rank_search = hc.base.id
                                    end
                                end

                                for _, hc in ipairs(G.hand.cards) do
                                    if hc:is_playing_card() and hc.base.id == rank_search then
                                        card_stats[hc].discard_weight[k] = -1
                                    end
                                end

                            elseif k == "High Card" then
                                G.deck:chance(
                                    (function(c)
                                        return c:is_playing_card()
                                    end), pulls, 1)
                            end
                            
                            strength[k].canplay = chance
                        end
                    end
                end

                local sorted_stats = {}
                local best_hand = nil
                for card, stat in pairs(card_stats) do
                    if stat.money_total > 0 or stat.buy_stat > 0 then
                        best_hand = { hand = 'purchase', card = card }
                        break
                    end
                end
                
                if not best_hand then
                    for k, v in pairs(strength) do
                        if k ~= 'top' then

                            strength[k].weight = (strength[k].chips * strength[k].mult) * math.pow(strength[k].canplay, 0.9)

                            if not best_hand or strength[k].weight > best_hand.weight then
                                best_hand = {hand = k, weight = strength[k].weight, money = 0}
                            end
                        end
                    end
                    
                    function compare_weights(a, b)
                        return a.stat.finaldisc_weight > b.stat.finaldisc_weight
                    end
                    
                    for card, stat in pairs(card_stats) do
                        stat.finaldisc_weight = 0.5
                        if not card:is_playing_card() then
                            stat.finaldisc_weight = 1.5
                        end
                        sorted_stats[#sorted_stats + 1] = {card = card, stat = stat}
                        for i, stat in ipairs(sorted_stats) do
                            for k, v in pairs(stat.stat.discard_weight) do
                                stat.stat.finaldisc_weight = stat.stat.finaldisc_weight + v * (k == best_hand.hand and 1 or 0.02)
                            end
                        end
                    end
                    
                    table.sort(sorted_stats, compare_weights)
                end
                

                if best_hand.hand == 'purchase' then
                    self.button = 'purchase'

                    print('Buying ' .. best_hand.card.ability.name)

                    G.hand:add_to_highlighted(best_hand.card, true)

                elseif discard_amount > 0 then

                    self.button = 'discard_button'
                    for _, data in pairs(sorted_stats) do
                        if #G.hand.highlighted >= 5 then break end
                        if data.stat.finaldisc_weight >= 0 then
                            G.hand:add_to_highlighted(data.card, true)
                        end
                    end
                    
                    print('Discarding ' .. tostring(#G.hand.highlighted) .. ' for ' .. best_hand.hand)
                elseif strength[best_hand.hand].canplay == 1 and strength[best_hand.hand].cards then
                    self.button = 'play_button'

                    print('Playing ' .. best_hand.hand .. ' at ' .. tostring(#strength[best_hand.hand].cards) .. ' card length')

                    for k, v in ipairs(strength[best_hand.hand].cards) do
                        G.hand:add_to_highlighted(v, true)
                    end
                else
                    print('Gave up')
                    self.button = 'play_button'
                    for i = 1, #G.hand.cards do
                        if #G.hand.highlighted >= 5 then break end
                        if G.hand.cards[i]:is_playing_card() then
                            G.hand:add_to_highlighted(G.hand.cards[i], true)
                        end
                    end
                end

                if #G.hand.highlighted == 0 then
                    self.button = 'play_button'
                    G.hand:add_to_highlighted(G.hand.cards[1], true)
                end

                --delay(2.0)

                --print('')
                --print('')

                self.run_event = nil
                return true
            end
        })
        G.E_MANAGER:add_event(self.run_event)
    end
end

G.FUNCS.get_card_amount = function(cards, func)
    if not func then return 0 end
    local amount = 0
    
    for _, k in ipairs(cards) do
        if func(k) then
            amount = amount + 1
        end
    end
    
    return amount
end

G.FUNCS.merge_stats = function(a, b)
    if not a or not b then return end
    for k, v in pairs(b) do
        if a[k] then
            if type(a[k]) == 'table' then
                G.FUNCS.merge_stats(a[k], b[k])
            elseif k == 'x_mult' then
                a[k] = a[k] * b[k]
            else
                a[k] = a[k] + b[k]
            end
        end
    end
end

G.FUNCS.hand_chance = function(e)
    if e == 'High card' then return 1 end

    return 0
end

G.FUNCS.card_vision = function(e, hand_remove, discard_remove)
    hand_remove = hand_remove + 1
    return e.hand_size + ((e.hands - hand_remove) * e.hand_power + (e.discards - discard_remove) * e.discard_power)
end

function Card:estimate_score(context)

    local name = self.ability.name
    local obj = self.config.center
    local round_stats = context.round_stats

    if obj.tcg_estimate and type(obj.tcg_estimate) == 'function' then
        print('Custom Function for ' .. self.ability.name)
        return obj.tcg_estimate(self, context)
    elseif self.ability.set == 'Joker' then

        if context.set_round_stats then

        elseif context.purchase then
            if context.purchase == self then
                if self.ability.name == 'Ancient Joker' then
                    
                    local card_vision = G.FUNCS.card_vision(round_stats, 0, 0)

                    if self.ability.tcg_extra.suit then

                        local amount = G.FUNCS.get_card_amount(context.full_deck, function(e) return e.base.suit == self.ability.tcg_extra.suit end)

                        return {
                            x_mult = math.pow(self.ability.extra, amount * card_vision / #context.full_deck)
                        }
                    else

                        local total = 0
                        for suit, _ in pairs(SMODS.Suits) do
                            local amount = G.FUNCS.get_card_amount(context.full_deck, function(e) return e:is_playing_card() and e.base.suit == suit end)
    
                            print(amount)
                            total = total + amount * card_vision / #context.full_deck
                        end

                        total = total / 4

                        return {
                            x_mult = math.pow(self.ability.extra, total)
                        }
                    end
                end
                if self.ability.name == 'Mail-In Rebate' then

                    if round_stats.discards == 0 then return end
                    local card_vision = G.FUNCS.card_vision(round_stats, 0, 1)

                    if self.ability.tcg_extra.rank then
                        local rank = self.ability.tcg_extra.rank

                        local amount = G.FUNCS.get_card_amount(context.full_deck, function(e) return e.base.id == rank end)

                        return {
                            money_per_round = amount * self.ability.extra * card_vision / #context.full_deck
                        }
                    else
                        local ranks = {}

                        for _, k in ipairs(context.full_deck) do
                            if k:is_playing_card() and not ranks[k.base.id] then
                                ranks[k.base.id] = true
                            end
                        end

                        local total = 0
                        
                        for rank, _ in pairs(ranks) do
                            local amount = G.FUNCS.get_card_amount(context.full_deck, function(e) return e.base.id == rank end)
    
                            total = total + amount * self.ability.extra * card_vision / #context.full_deck
                        end

                        total = total / #ranks

                        return {
                            money_per_round = total
                        }
                    end
                end
            else

            end

        elseif context.in_hand then
            if self.ability.name == 'Ancient Joker' then
                local suit = self.ability.tcg_extra.suit or G.GAME.current_round.ancient_card.suit
                
                if context.other_card:is_suit(suit) then
                    return {
                        play = {
                            any = {
                                x_mult = self.ability.extra
                            }
                        }
                    }
                end
            end
            if self.ability.name == 'Mail-In Rebate' then
                local rank = self.ability.tcg_extra.rank or G.GAME.current_round.mail_card.id

                if context.other_card:get_id() == rank then
                    return {
                        discard = {
                            dollars = self.ability.extra
                        }
                    }
                end
            end
        else

        end
    else
        if context.purchase then
            if self.ability.name == 'The Hermit' then
                return {
                    money_now = math.min(G.GAME.dollars, self.ability.extra)
                }
            end
        end

    end

end