BalatroTCG.ConsumeableMod {
    key_override = 'c_ouija',
    
    use_consumeable = function(self, area, copier, balanced, original_func)
        
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true end }))

        for i=1, #G.hand.cards do
            local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        
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

        for i=1, #G.hand.cards do
            local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        
        delay(0.5)
        
    end
}