BalatroTCG.JokerMod {
    key_override = 'j_flash',
    
    modify = function(self, balanced)
        self.config.extra = 3
    end,
    calculate_context = function(self, context, balanced)
        if context.discard and context.other_card == context.full_hand[#context.full_hand] then
            local face_cards = 0
            for k, v in ipairs(context.full_hand) do
                if not v:is_playing_card() then face_cards = face_cards + 1 end
            end
            if face_cards >= self.ability.cards then
                SMODS.scale_card(self, {
                    ref_table = self.ability,
                    ref_value = "mult",
                    scalar_value = "extra",
                    message_key = 'a_mult',
                    message_colour = G.C.RED
                })
            end
        elseif context.joker_main and self.ability.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                mult_mod = self.ability.mult
            }
        end
    end,
}