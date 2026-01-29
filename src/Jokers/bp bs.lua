BalatroTCG.JokerMod {
    key_override = 'j_blueprint',
    
    calculate_context = function(self, context, balanced)

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
        
    end,
}
BalatroTCG.JokerMod {
    key_override = 'j_brainstorm',
    
    calculate_context = function(self, context, balanced)

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

    end,
}