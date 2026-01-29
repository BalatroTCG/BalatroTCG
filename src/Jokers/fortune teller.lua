BalatroTCG.JokerMod {
    key_override = 'j_fortune_teller',
    
    modify = function(self, balanced)
        if balanced then self.config.extra = 5 end
    end,
    calculate_context = function(self, context, balanced)
        if context.using_consumeable then
            if self.ability.name == 'Fortune Teller' and not context.blueprint and (context.consumeable.ability.set == "Tarot") then
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={G.GAME.consumeable_usage_total.tarot * self.ability.extra}}}); return true
                    end}))
                return nil, true
            end
        elseif context.joker_main and self.ability.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                mult_mod = self.ability.mult
            }
        end
    end,
}