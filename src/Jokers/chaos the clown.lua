BalatroTCG.JokerMod {
    key_override = 'j_chaos',
    
    modify = function(self, balanced)
        if balanced then
            self.eternal_compat = false
            self.config.extra = 15
        end
    end,
    calculate_context = function(self, context, balanced)
        if context.switching_players then
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
        end
    end
}