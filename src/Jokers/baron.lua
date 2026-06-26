BalatroTCG.JokerMod {
    key_override = 'j_baron',
    
    description_override = {
        balanced = false,
        none = false,
    },

    loc_vars = function(ability, card, balance)
        return { ability.per_card, ability.extra }
    end,
}