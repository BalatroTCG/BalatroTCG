BalatroTCG.JokerMod {
    key_override = 'j_perkeo',
    
    modify = function(self, balanced)
        if balanced then
            self.eternal_compat = false
        end
    end,
    calculate_context = function(self, context, balanced)
        if context.setting_blind and G.consumeables.cards[1] then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed('perkeo')), nil)
                    card:set_edition({negative = true}, true)
                    card.tcg_extra.virtual = true
                    card:add_to_deck()
                    G.hand:emplace(card) 
                    return true
                end}))
            card_eval_status_text(context_blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
            return nil, true
        end
    end,
}