BalatroTCG.VoucherMod {
    key_override = 'v_telescope',
    
    get_cost = function(original, balanced) return 6 end,

    modify = function(self, balanced)
        self.config.extra = 1
    end,
    redeem = function(card, balanced, original_func)
        G.GAME.modifiers.draw_telescope = true
    end,
    
    calculate_context = function(self, context, balanced)
        if context.setting_blind then
            local _planet, _hand, _tally = nil, nil, 0
            for k, v in ipairs(G.handlist) do
                if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                    _hand = v
                    _tally = G.GAME.hands[v].played
                end
            end
            if _hand then
                for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                    if v.config.hand_type == _hand then
                        _planet = v.key
                    end
                end
                local center = G.P_CENTERS[_planet]
                for k, card in ipairs(G.deck.cards) do
                    if card.ability.name == center.name then
                        G.deck.cards[k] = G.deck.cards[#G.deck.cards]
                        G.deck.cards[#G.deck.cards] = card
                        break
                    end
                end
            end
        end
    end
}
BalatroTCG.VoucherMod {
    key_override = 'v_observatory',
    
    get_cost = function(original, balanced) return 12 end,

    redeem = function(card, balanced, original_func)

    end,
}