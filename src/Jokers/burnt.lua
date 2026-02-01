BalatroTCG.JokerMod {
    key_override = 'j_burnt',
    
    calculate_context = function(self, context, balanced)
        if context.pre_discard and (balanced or G.GAME.current_round.discards_used <= 0) and not context.hook then
            local text,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            card_eval_status_text(context_blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
            level_up_hand(context.blueprint_card or self, text, nil, 1)
            return nil, true
        end
    end,
}