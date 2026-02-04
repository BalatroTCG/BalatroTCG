--Class
BalatroTCG.Deck = Object:extend()

function BalatroTCG.Deck:init(backs, name, cards)
    if type(backs) == 'table' then
        self.backs = backs
    else
        self.backs = splitlines(backs, ';')
        for i = 1, #self.backs do
            if not G.P_CENTERS[self.backs[i]] then
                
                for k, v in pairs(G.P_CENTERS) do
                    if v.name == self.backs[i] then
                        self.backs[i] = k
                    end
                end
            end
        end
    end
    self.cards = cards
    self.name = name or self.backs[1]
end

BalatroTCG.DefaultDecks = {
    BalatroTCG.Deck('b_red', "Ancient Deck", -- Done
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'j', c = 'j_droll' },
        { type = 'j', c = 'j_crafty' },
        { type = 'j', c = 'j_mail' },
        { type = 'j', c = 'j_cavendish' },
        { type = 'j', c = 'j_business' },
        { type = 'j', c = 'j_gros_michel' },
        
        { type = 'j', c = 'j_sock_and_buskin' },
        { type = 'j', c = 'j_four_fingers' },
        { type = 'j', c = 'j_merry_andy' },
        
        { type = 'j', c = 'j_ancient' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_lovers' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_wheel_of_fortune' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_hanged_man' },
        
        { type = 'c', c = 'c_ceres' },
        { type = 'c', c = 'c_jupiter' },
        { type = 'c', c = 'c_eris' },
        
        { type = 'c', c = 'c_sigil' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_deja_vu' },
        { type = 'c', c = 'c_wraith' },

    }),
    BalatroTCG.Deck('b_blue', "Green Joker Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'j', c = 'j_green_joker' },
        { type = 'j', c = 'j_sly' },
        { type = 'j', c = 'j_jolly' },
        { type = 'j', c = 'j_delayed_grat' },
        { type = 'j', c = 'j_reserved_parking' },
        { type = 'j', c = 'j_banner' },
        
        { type = 'j', c = 'j_burglar' },
        { type = 'j', c = 'j_astronomer' },
        { type = 'j', c = 'j_constellation' },
        
        { type = 'j', c = 'j_stuntman' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_magician' },
        { type = 'c', c = 'c_fool' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_mercury' },
        
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_talisman' },

    }),
    BalatroTCG.Deck('b_yellow', "Hiker Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },
        { type = 'p', r = '5', s = 'S' },
        { type = 'p', r = '4', s = 'S' },
        { type = 'p', r = '3', s = 'S' },
        { type = 'p', r = '2', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        
        { type = 'j', c = 'j_8_ball' },
        { type = 'j', c = 'j_splash' },
        { type = 'j', c = 'j_hanging_chad' },
        { type = 'j', c = 'j_business' },
        { type = 'j', c = 'j_riff_raff' },
        { type = 'j', c = 'j_drunkard' },
        
        { type = 'j', c = 'j_oops' },
        { type = 'j', c = 'j_hiker' },
        { type = 'j', c = 'j_space' },
        
        { type = 'j', c = 'j_dna' },
        
        { type = 'c', c = 'c_judgement' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_justice' },
        
        { type = 'c', c = 'c_jupiter' },
        { type = 'c', c = 'c_eris' },
        { type = 'c', c = 'c_planet_x' },
        
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_deja_vu' },
        { type = 'c', c = 'c_ankh' },
        { type = 'c', c = 'c_cryptid' },

    }),
    BalatroTCG.Deck('b_green', "Bootstraps Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'j', c = 'j_blue_joker' },
        { type = 'j', c = 'j_juggler' },
        { type = 'j', c = 'j_hanging_chad' },
        { type = 'j', c = 'j_ticket' },
        { type = 'j', c = 'j_splash' },
        { type = 'j', c = 'j_riff_raff' },
        
        { type = 'j', c = 'j_throwback' },
        { type = 'j', c = 'j_bootstraps' },
        { type = 'j', c = 'j_midas_mask' },
        
        { type = 'j', c = 'j_obelisk' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_moon' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_jupiter' },
        
        { type = 'c', c = 'c_aura' },
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_medium' },

    }),
    BalatroTCG.Deck('b_black', "Baseball Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'j', c = 'j_sly' },
        { type = 'j', c = 'j_abstract' },
        { type = 'j', c = 'j_mail' },
        { type = 'j', c = 'j_gros_michel' },
        { type = 'j', c = 'j_cavendish' },
        { type = 'j', c = 'j_golden' },
        
        { type = 'j', c = 'j_stone' },
        { type = 'j', c = 'j_sixth_sense' },
        { type = 'j', c = 'j_constellation' },
        
        { type = 'j', c = 'j_baseball' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hanged_man' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_tower' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_mercury' },
        { type = 'c', c = 'c_uranus' },
        
        { type = 'c', c = 'c_ankh' },
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_soul' },

    }),
    BalatroTCG.Deck('b_magic', "Vagabond Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'j', c = 'j_credit_card' },
        { type = 'j', c = 'j_fortune_teller' },
        { type = 'j', c = 'j_mail' },
        { type = 'j', c = 'j_gros_michel' },
        { type = 'j', c = 'j_cavendish' },
        { type = 'j', c = 'j_banner' },
        
        { type = 'j', c = 'j_burglar' },
        { type = 'j', c = 'j_steel_joker' },
        { type = 'j', c = 'j_cloud_9' },
        
        { type = 'j', c = 'j_vagabond' },
        
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_judgement' },
        { type = 'c', c = 'c_tower' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_jupiter' },
        
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_talisman' },

    }),
    BalatroTCG.Deck('b_nebula', "Constellation Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'j', c = 'j_green_joker' },
        { type = 'j', c = 'j_sly' },
        { type = 'j', c = 'j_mail' },
        { type = 'j', c = 'j_cavendish' },
        { type = 'j', c = 'j_gros_michel' },
        { type = 'j', c = 'j_abstract' },
        
        { type = 'j', c = 'j_card_sharp' },
        { type = 'j', c = 'j_astronomer' },
        { type = 'j', c = 'j_constellation' },
        
        { type = 'j', c = 'j_brainstorm' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_fool' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_jupiter' },
        { type = 'c', c = 'c_mercury' },
        
        { type = 'c', c = 'c_aura' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_talisman' },

    }),
    BalatroTCG.Deck('b_ghost', "Stencil Deck", 
    {
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        { type = 'p', r = '5', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'j', c = 'j_green_joker' },
        { type = 'j', c = 'j_sly' },
        { type = 'j', c = 'j_mail' },
        { type = 'j', c = 'j_droll' },
        { type = 'j', c = 'j_cavendish' },
        { type = 'j', c = 'j_gros_michel' },
        
        { type = 'j', c = 'j_mime' },
        { type = 'j', c = 'j_cloud_9' },
        { type = 'j', c = 'j_stencil' },
        
        { type = 'j', c = 'j_brainstorm' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_justice' },
        { type = 'c', c = 'c_hanged_man' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_jupiter' },
        
        { type = 'c', c = 'c_ectoplasm' },
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_soul' },
        { type = 'c', c = 'c_ankh' },

    }),
    BalatroTCG.Deck('b_abandoned', "Bus Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        { type = 'p', r = '5', s = 'D' },
        { type = 'p', r = '4', s = 'D' },
        { type = 'p', r = '3', s = 'D' },
        { type = 'p', r = '2', s = 'D' },
        
        { type = 'j', c = 'j_ride_the_bus' },
        { type = 'j', c = 'j_sly' },
        { type = 'j', c = 'j_mail' },
        { type = 'j', c = 'j_cavendish' },
        { type = 'j', c = 'j_gros_michel' },
        { type = 'j', c = 'j_droll' },
        
        { type = 'j', c = 'j_card_sharp' },
        { type = 'j', c = 'j_rough_gem' },
        { type = 'j', c = 'j_burglar' },
        
        { type = 'j', c = 'j_brainstorm' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_moon' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_jupiter' },
        
        { type = 'c', c = 'c_aura' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_talisman' },

    }),
    BalatroTCG.Deck('b_checkered', "Bloodstone Deck", 
    {
        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        { type = 'p', r = '5', s = 'H' },
        { type = 'p', r = '5', s = 'H' },
        { type = 'p', r = '4', s = 'H' },
        { type = 'p', r = '4', s = 'H' },
        { type = 'p', r = '3', s = 'H' },
        { type = 'p', r = '3', s = 'H' },
        { type = 'p', r = '2', s = 'H' },
        { type = 'p', r = '2', s = 'H' },

        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        
        { type = 'j', c = 'j_lusty_joker' },
        { type = 'j', c = 'j_sly' },
        { type = 'j', c = 'j_faceless' },
        { type = 'j', c = 'j_scary_face' },
        { type = 'j', c = 'j_smiley' },
        { type = 'j', c = 'j_business' },
        
        { type = 'j', c = 'j_castle' },
        { type = 'j', c = 'j_bloodstone' },
        { type = 'j', c = 'j_oops' },
        
        { type = 'j', c = 'j_blueprint' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_sun' },
        { type = 'c', c = 'c_magician' },
        { type = 'c', c = 'c_lovers' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_jupiter' },
        
        { type = 'c', c = 'c_deja_vu' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_talisman' },

    }),
    BalatroTCG.Deck('b_zodiac', "Campfire Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        { type = 'p', r = '5', s = 'D' },
        { type = 'p', r = '4', s = 'D' },
        { type = 'p', r = '3', s = 'D' },
        { type = 'p', r = '2', s = 'D' },
        
        { type = 'j', c = 'j_droll' },
        { type = 'j', c = 'j_crafty' },
        { type = 'j', c = 'j_ticket' },
        { type = 'j', c = 'j_hanging_chad' },
        { type = 'j', c = 'j_cavendish' },
        { type = 'j', c = 'j_gros_michel' },
        
        { type = 'j', c = 'j_cartomancer' },
        { type = 'j', c = 'j_rough_gem' },
        { type = 'j', c = 'j_astronomer' },
        
        { type = 'j', c = 'j_campfire' },
        
        { type = 'c', c = 'c_magician' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_star' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_jupiter' },
        
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_talisman' },

    }),
    BalatroTCG.Deck('b_painted', "Runner Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'j', c = 'j_photograph' },
        { type = 'j', c = 'j_hanging_chad' },
        { type = 'j', c = 'j_mail' },
        { type = 'j', c = 'j_superposition' },
        { type = 'j', c = 'j_business' },
        { type = 'j', c = 'j_runner' },
        
        { type = 'j', c = 'j_shortcut' },
        { type = 'j', c = 'j_four_fingers' },
        { type = 'j', c = 'j_constellation' },
        
        { type = 'j', c = 'j_order' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_hanged_man' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_moon' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_saturn' },
        { type = 'c', c = 'c_neptune' },
        
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_talisman' },

    }),
    BalatroTCG.Deck('b_anaglyph', "Square Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'j', c = 'j_square' },
        { type = 'j', c = 'j_sly' },
        { type = 'j', c = 'j_mail' },
        { type = 'j', c = 'j_red_card' },
        { type = 'j', c = 'j_gros_michel' },
        { type = 'j', c = 'j_mystic_summit' },
        
        { type = 'j', c = 'j_card_sharp' },
        { type = 'j', c = 'j_rocket' },
        { type = 'j', c = 'j_trousers' },
        
        { type = 'j', c = 'j_burnt' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_moon' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_jupiter' },
        
        { type = 'c', c = 'c_aura' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_talisman' },

    }),
    BalatroTCG.Deck('b_plasma', "Baron Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'j', c = 'j_raised_fist' },
        { type = 'j', c = 'j_smiley' },
        { type = 'j', c = 'j_mail' },
        { type = 'j', c = 'j_business' },
        { type = 'j', c = 'j_hanging_chad' },
        { type = 'j', c = 'j_reserved_parking' },
        
        { type = 'j', c = 'j_mime' },
        { type = 'j', c = 'j_space' },
        { type = 'j', c = 'j_oops' },
        
        { type = 'j', c = 'j_baron' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_judgement' },
        { type = 'c', c = 'c_fool' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_mercury' },
        
        { type = 'c', c = 'c_deja_vu' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_medium' },

    }),
    BalatroTCG.Deck('b_erratic', "Wee Deck",
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'A', s = 'D' },
        
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'K', s = 'D' },
        
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'Q', s = 'D' },
        
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'J', s = 'D' },
        
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = 'T', s = 'D' },
        
        { type = 'p', r = '6', s = 'S' },
        { type = 'p', r = '6', s = 'H' },
        { type = 'p', r = '6', s = 'C' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'p', r = '5', s = 'S' },
        { type = 'p', r = '5', s = 'H' },
        { type = 'p', r = '5', s = 'C' },
        { type = 'p', r = '5', s = 'D' },
        
        { type = 'p', r = '2', s = 'S' },
        { type = 'p', r = '2', s = 'H' },
        { type = 'p', r = '2', s = 'C' },
        { type = 'p', r = '2', s = 'D' },

        { type = 'p', r = '2', s = 'S' },
        { type = 'p', r = '2', s = 'H' },
        { type = 'p', r = '2', s = 'C' },
        { type = 'p', r = '2', s = 'D' },
        
        { type = 'j', c = 'j_even_steven' },
        { type = 'j', c = 'j_droll' },
        { type = 'j', c = 'j_ticket' },
        { type = 'j', c = 'j_hanging_chad' },
        { type = 'j', c = 'j_gros_michel' },
        { type = 'j', c = 'j_cavendish' },

        { type = 'j', c = 'j_sixth_sense' },
        { type = 'j', c = 'j_hack' },
        { type = 'j', c = 'j_trading' },

        { type = 'j', c = 'j_wee' },
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_lovers' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_moon' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_planet_x' },
        { type = 'c', c = 'c_eris' },
        
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_soul' },
        { type = 'c', c = 'c_wraith' },
        { type = 'c', c = 'c_talisman' },
    }),
    BalatroTCG.Deck('b_challenge', "Jokerless Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_magician' },
        { type = 'c', c = 'c_high_priestess' },
        { type = 'c', c = 'c_emperor' },
        { type = 'c', c = 'c_lovers' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_justice' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_hanged_man' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_devil' },

        { type = 'c', c = 'c_talisman' },
        { type = 'c', c = 'c_aura' },
        { type = 'c', c = 'c_sigil' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_deja_vu' },
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_black_hole' },
        
        { type = 'c', c = 'c_ceres' },
        { type = 'c', c = 'c_eris' },
        { type = 'c', c = 'c_earth' },
    }),
    
    BalatroTCG.Deck('b_mp_violet', "Voucher Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        { type = 'p', r = '5', s = 'D' },
        { type = 'p', r = '4', s = 'D' },
        { type = 'p', r = '3', s = 'D' },
        { type = 'p', r = '2', s = 'D' },
        
        { type = 'j', c = 'j_mail' },
        { type = 'j', c = 'j_ticket' },
        { type = 'j', c = 'j_golden' },
        { type = 'j', c = 'j_rough_gem' },

        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_high_priestess' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_magician' },
        { type = 'c', c = 'c_emperor' },
        { type = 'c', c = 'c_hanged_man' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_judgement' },

        { type = 'c', c = 'c_deja_vu' },
        { type = 'c', c = 'c_talisman' },

        { type = 'c', c = 'c_jupiter' },
        { type = 'c', c = 'c_mercury' },
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_mars' },
        
        { type = 'c', c = 'v_illusion' },
        { type = 'c', c = 'v_hone' },
        { type = 'c', c = 'v_magic_trick' },
        { type = 'c', c = 'v_glow_up' },
    }),
    BalatroTCG.Deck('b_mp_indigo', "Jokerless Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_magician' },
        { type = 'c', c = 'c_high_priestess' },
        { type = 'c', c = 'c_emperor' },
        { type = 'c', c = 'c_lovers' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_justice' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_hanged_man' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_devil' },

        { type = 'c', c = 'c_talisman' },
        { type = 'c', c = 'c_aura' },
        { type = 'c', c = 'c_sigil' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_deja_vu' },
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_black_hole' },
        
        { type = 'c', c = 'c_ceres' },
        { type = 'c', c = 'c_eris' },
        { type = 'c', c = 'c_earth' },
    }),
    BalatroTCG.Deck('b_mp_orange', "Jokerless Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_magician' },
        { type = 'c', c = 'c_high_priestess' },
        { type = 'c', c = 'c_emperor' },
        { type = 'c', c = 'c_lovers' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_justice' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_hanged_man' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_devil' },

        { type = 'c', c = 'c_talisman' },
        { type = 'c', c = 'c_aura' },
        { type = 'c', c = 'c_sigil' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_deja_vu' },
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_black_hole' },
        
        { type = 'c', c = 'c_ceres' },
        { type = 'c', c = 'c_eris' },
        { type = 'c', c = 'c_earth' },
    }),
    BalatroTCG.Deck('b_mp_oracle', "Jokerless Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_magician' },
        { type = 'c', c = 'c_high_priestess' },
        { type = 'c', c = 'c_emperor' },
        { type = 'c', c = 'c_lovers' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_justice' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_hanged_man' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_devil' },

        { type = 'c', c = 'c_talisman' },
        { type = 'c', c = 'c_aura' },
        { type = 'c', c = 'c_sigil' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_deja_vu' },
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_black_hole' },
        
        { type = 'c', c = 'c_ceres' },
        { type = 'c', c = 'c_eris' },
        { type = 'c', c = 'c_earth' },
    }),
    BalatroTCG.Deck('b_mp_gradient', "Numeric Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_magician' },
        { type = 'c', c = 'c_high_priestess' },
        { type = 'c', c = 'c_emperor' },
        { type = 'c', c = 'c_lovers' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_justice' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_hanged_man' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_devil' },

        { type = 'c', c = 'c_talisman' },
        { type = 'c', c = 'c_aura' },
        { type = 'c', c = 'c_sigil' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_deja_vu' },
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_black_hole' },
        
        { type = 'c', c = 'c_ceres' },
        { type = 'c', c = 'c_eris' },
        { type = 'c', c = 'c_earth' },
    }),
    BalatroTCG.Deck('b_mp_heidelberg', "Jokerless Deck", 
    {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_magician' },
        { type = 'c', c = 'c_high_priestess' },
        { type = 'c', c = 'c_emperor' },
        { type = 'c', c = 'c_lovers' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_justice' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_strength' },
        { type = 'c', c = 'c_hanged_man' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_devil' },

        { type = 'c', c = 'c_talisman' },
        { type = 'c', c = 'c_aura' },
        { type = 'c', c = 'c_sigil' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_deja_vu' },
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_black_hole' },
        
        { type = 'c', c = 'c_ceres' },
        { type = 'c', c = 'c_eris' },
        { type = 'c', c = 'c_earth' },
    }),
}

for k, v in ipairs(BalatroTCG.DefaultDecks) do
    v.is_vanilla = true
end

BalatroTCG.CustomDecks = {}


function BalatroTCG.Deck:card_from_control_ex(deck, back, control)

    local _card = nil

    if control.type == 'p' then
        _card = Card(deck.T.x, deck.T.y, G.CARD_W, G.CARD_H, G.P_CARDS[control.s..'_'..control.r], G.P_CENTERS['c_base'], {playing_card = G.playing_card, tcg_back = self.backs[1]})
    elseif control.type == 'j' then
        _card = Card(deck.T.x, deck.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[control.c], {playing_card = G.playing_card, tcg_back = self.backs[1]})
    elseif control.type == 'c' then
        _card = Card(deck.T.x, deck.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[control.c], {playing_card = G.playing_card, tcg_back = self.backs[1]})
    end

    return _card
end

function BalatroTCG.Deck:has_content()

    for k, v in ipairs(self.backs) do
        if not G.P_CENTERS[v] then return false end
    end
    for k, v in ipairs(self.cards) do
        if v.type ~= 'p' and not G.P_CENTERS[v.c] then return false end
    end

    return true
end


function load_custom_decks()
    
    BalatroTCG.CustomDecks = {}

    local file_data = love.filesystem.getInfo('tcg_decks.jkr')

    if file_data then
        local file_string = love.filesystem.read('tcg_decks.jkr')

        if file_string ~= '' then
            local decks = read_decks(file_string)

            for _, data in pairs(decks) do
                BalatroTCG.CustomDecks[#BalatroTCG.CustomDecks + 1] = BalatroTCG.Deck(data.back, data.name, data.cards)
            end
        end
    end

    if #BalatroTCG.CustomDecks < 1 then
        BalatroTCG.CustomDecks[1] = get_new_tcg_deck()
    end
end


function read_decks(file_string)
    local split = splitlines(file_string, '\n')

    local decks = {}

    local index = 1

    while index <= #split and split[index] ~= '###' do
        local name = split[index]
        local deckdata = splitlines(string.sub(split[index + 1], 2, string.len(split[index + 1])), ':')
        index = index + 2

        local cards = {}
        while string.sub(split[index], 1, 1) == '\t' do
            local cd = splitlines(string.sub(split[index], 2, string.len(split[index])), ':')
            if cd[1] == 'p' then
                cards[#cards + 1] = {type = cd[1], r = cd[2], s = cd[3]}
            else
                cards[#cards + 1] = {type = cd[1], c = cd[2]}
            end
            index = index + 1
        end

        decks[#decks + 1] = {
            back = deckdata[1], 
            cards = cards,
            name = name
        }

    end

    return decks

end

function BalatroTCG.Deck:sanitize()
    self.name = self.name:gsub(':', '_')
end

function save_decks(decks)
    decks = decks or {BalatroTCG.CustomDecks}
    local table = {}

    local toWrite = ''

    for _, extra in ipairs(decks) do
        for k, v in ipairs(extra) do
            v:sanitize()
            toWrite = toWrite .. v.name .. '\n'
            toWrite = toWrite .. '\t'
            for k, back in ipairs(v.backs) do
                toWrite = toWrite .. back .. ';'
            end
            toWrite = string.sub(toWrite, 1, #toWrite - 1)  .. '\n'

            for k, card in ipairs(v.cards) do
                toWrite = toWrite .. '\t' .. card.type .. ':'
                if card.type =='p' then
                    toWrite = toWrite .. card.r .. ':' .. card.s
                else
                    toWrite = toWrite .. card.c
                end
                toWrite = toWrite .. '\n'
            end
        end
    end

    toWrite = toWrite .. '###'

    love.filesystem.write('tcg_decks.jkr', toWrite)
end


local type_rating = {p = 0, j = 1, c = 2 }
local set_rating = {Tarot = 0, Planet = 1, Spectral = 2, Voucher = 3, }
local suit_rating = {S = 0, H = 1, C = 2, D = 3 }
local rank_rating = {A = 0, K = 1, Q = 2, J = 3, T = 4 }
rank_rating['9'] = 5
rank_rating['8'] = 6
rank_rating['7'] = 7
rank_rating['6'] = 8
rank_rating['5'] = 9
rank_rating['4'] = 10
rank_rating['3'] = 11
rank_rating['2'] = 12
function BalatroTCG.Deck:sort()
    function compare_cards(a, b)
        return tcg_card_nominal(a) < tcg_card_nominal(b)
    end
    table.sort(self.cards, compare_cards)
end

function tcg_card_nominal(card)
    local factor = type_rating[card.type] * 100
    
    if card.type == 'c' then
        factor = factor + (G.P_CENTERS[card.c] and set_rating[G.P_CENTERS[card.c].set] or 0) + pseudohash(card.c) * 0.01
    elseif card.type == 'j' then
        local rarity = (G.P_CENTERS[card.c] and G.P_CENTERS[card.c].rarity or 0)
        if type(rarity) == 'string' then
            rarity = 5 -- i guess they can be strings?
        end
        factor = factor + rarity + (G.P_CENTERS[card.c] and G.P_CENTERS[card.c].cost or 0) * 0.01 + pseudohash(card.c) * 0.0001
    elseif card.type == 'p' then
        factor = factor + rank_rating[card.r] * 0.01 + suit_rating[card.s]
    end

    return factor
end

function deck_back_cost(name, full_list)
    if type(name) == 'table' then
        local cost = 0

        for k, v in ipairs(name) do
            cost = cost + deck_back_cost(v, name)
        end
        return cost
    end

    return BalatroTCG.DeckData.get(name).get_cost(full_list)
end

function BalatroTCG.Deck:set_cost()
    self.cost = deck_back_cost(self.backs)

    for i, card in ipairs(self.cards) do
        if card.type ~= 'p' then
            if G.P_CENTERS[card.c] then
                local consumable = create_tcg_center(G.P_CENTERS[card.c])

                self.cost = self.cost + consumable.cost
            end
        end
    end
    
    BalatroTCG.DeckCost = 110 - self.cost
end

function tcg_get_limitations(backname)

    local limits = {
        deck_size = 60,
        max_jokers = 15,
        max_tarots = 20,
        max_planets = 20,
        max_spectrals = 20,
        max_vouchers = 2,
        max_consumables = 20,
        max_uncommons = 4,
        max_rares = 1,
        no_faces = false,
        checkered_suits = false,
        total_copies = 0,
        suit_copies = 0,
        playing_card_copies = 0,
        consumeable_copies = 0,
        planet_copies = 0,
        tarot_copies = 0,
        voucher_copies = 0,
        spectral_copies = 0,
        joker_copies = 0,
        deck_count = 1,
        -- TARGET: Set default TCG deck limitations
    }

    if not backname then return limits end

    if type(backname) == 'table' then
        local default = tcg_get_limitations(nil)

        for k, v in ipairs(backname) do
            local values = tcg_get_limitations(v)
            
            limits.deck_size = math.max(limits.deck_size + (values.deck_size - default.deck_size), 1)
            limits.total_copies = math.max(limits.total_copies + (values.total_copies - default.total_copies), 0)
            limits.suit_copies = math.max(limits.suit_copies + (values.suit_copies - default.suit_copies), 0)
            limits.playing_card_copies = math.max(limits.playing_card_copies + (values.playing_card_copies - default.playing_card_copies), 0)
            limits.consumeable_copies = math.max(limits.consumeable_copies + (values.consumeable_copies - default.consumeable_copies), 0)
            limits.planet_copies = math.max(limits.planet_copies + (values.planet_copies - default.planet_copies), 0)
            limits.tarot_copies = math.max(limits.tarot_copies + (values.tarot_copies - default.tarot_copies), 0)
            limits.voucher_copies = math.max(limits.voucher_copies + (values.voucher_copies - default.voucher_copies), 0)
            limits.joker_copies = math.max(limits.joker_copies + (values.joker_copies - default.joker_copies), 0)
            limits.spectral_copies = math.max(limits.spectral_copies + (values.spectral_copies - default.spectral_copies), 0)

            limits.deck_count = math.max(limits.deck_count + (values.deck_count - default.deck_count), 1)

            limits.no_faces = limits.no_faces or values.no_faces
            limits.checkered_suits = limits.checkered_suits or values.checkered_suits
            
            if values.max_jokers == 0 or limits.max_jokers == 0 then
                limits.max_jokers = 0
            else
                limits.max_jokers = math.max(limits.max_jokers + (values.max_jokers - default.max_jokers), 1)
            end
            if values.max_tarots == 0 or limits.max_tarots == 0 then
                limits.max_tarots = 0
            else
                limits.max_tarots = math.max(limits.max_tarots + (values.max_tarots - default.max_tarots), 1)
            end
            if values.max_planets == 0 or limits.max_planets == 0 then
                limits.max_planets = 0
            else
                limits.max_planets = math.max(limits.max_planets + (values.max_planets - default.max_planets), 1)
            end
            if values.max_spectrals == 0 or limits.max_spectrals == 0 then
                limits.max_spectrals = 0
            else
                limits.max_spectrals = math.max(limits.max_spectrals + (values.max_spectrals - default.max_spectrals), 1)
            end
            if values.max_vouchers == 0 or limits.max_vouchers == 0 then
                limits.max_vouchers = 0
            else
                limits.max_vouchers = math.max(limits.max_vouchers + (values.max_vouchers - default.max_vouchers), 1)
            end
            if values.max_consumables == 0 or limits.max_consumables == 0 then
                limits.max_consumables = 0
            else
                limits.max_consumables = math.max(limits.max_consumables + (values.max_consumables - default.max_consumables), 1)
            end
            if values.max_uncommons == 0 or limits.max_uncommons == 0 then
                limits.max_uncommons = 0
            else
                limits.max_uncommons = math.max(limits.max_uncommons + (values.max_uncommons - default.max_uncommons), 1)
            end
            if values.max_rares == 0 or limits.max_rares == 0 then
                limits.max_rares = 0
            else
                limits.max_rares = math.max(limits.max_rares + (values.max_rares - default.max_rares), 1)
            end
            -- TARGET: Combine TCG limitations
        end

        return limits
    end
    
    BalatroTCG.DeckData.get(backname):get_limits(limits)
    
    return limits
end

function get_TCG_params(back_list, back)
    local ret = {
        max_budget = 1e308,
        dollars = BalatroTCG.Settings.StartingMoney,
        hand_size = 8,
        discards = BalatroTCG.Settings.DefaultDiscards,
        hands = BalatroTCG.Settings.DefaultHands,
        joker_slots = 5,
        consumable_slots = 2,
        discount = 0,
        joker_health = BalatroTCG.Settings.JokerHealth,
        destroy_planets = true,
        destroy_tarots = true,
        destroy_spectrals = true,
        starting_vouchers = {}
        -- TARGET: Set default TCG deck parameters
    }

    if not back_list then return ret end

    if type(back_list) ~= 'table' then
        back = back_list
        back_list = {back}
    end

    if not back then
        local default = get_TCG_params(nil)

        for k, v in ipairs(back_list) do
            local values = get_TCG_params(back_list, v)

            ret.max_budget = math.min(values.max_budget, ret.max_budget)
            ret.discount = math.max(values.discount, ret.discount)

            ret.dollars = math.max(ret.dollars + (values.dollars - default.dollars), 1)
            ret.hand_size = math.max(ret.hand_size + (values.hand_size - default.hand_size), 1)
            ret.discards = math.max(ret.discards + (values.discards - default.discards), 0)
            ret.hands = math.max(ret.hands + (values.hands - default.hands), 1)
            ret.consumable_slots = math.max(ret.consumable_slots + (values.consumable_slots - default.consumable_slots), 0)
            ret.joker_health = math.max(ret.joker_health + (values.joker_health - default.joker_health), 1)

            ret.destroy_planets = ret.destroy_planets and values.destroy_planets
            ret.destroy_tarots = ret.destroy_tarots and values.destroy_tarots
            ret.destroy_spectrals = ret.destroy_spectrals and values.destroy_spectrals

            for _, v1 in ipairs(values.starting_vouchers) do
                for _, v2 in ipairs(ret.starting_vouchers) do
                    if v1 == v2 then goto skip_voucher end
                end
                table.insert(ret.starting_vouchers, v1)
                ::skip_voucher::
            end

            if values.joker_slots == 0 or ret.joker_slots == 0 then
                ret.joker_slots = 0
            else
                ret.joker_slots = math.max(ret.joker_slots + (values.joker_slots - default.joker_slots), 1)
            end
            -- TARGET: Combine TCG parameters
        end

        ret.dollars = math.min(ret.dollars, ret.max_budget)

        return ret
    end

    BalatroTCG.DeckData.get(back):get_params(ret, back_list)

    return ret
end

function BalatroTCG.Deck:is_legal()

    local errors = {}

    local limits = tcg_get_limitations(self.backs)

    local stats = {
        uncommons = 0,
        rares = 0,
        jokers = 0,
        total_copies = 0,
        tarots = 0,
        planets = 0,
        spectrals = 0,
        consumables = 0,
        wrong_suits = false,
        playing_card_copies = 0,
        vouchers = 0,
        -- TARGET: Set empty TCG deck stats
    }
    
    if BalatroTCG.Settings.DeckLimitations.Size and #self.cards > limits.deck_size then
        errors['tcg_err_deck_big'] = {#self.cards, limits.deck_size}
    elseif BalatroTCG.Settings.DeckLimitations.Size and #self.cards < limits.deck_size then
        errors['tcg_err_deck_small'] = {#self.cards, limits.deck_size}
    end

    local cards = { }
    local suits = { }
    local consumables = { }
    local jokers = { }

    for i, card in ipairs(self.cards) do

        if card.type == 'p' then
            suits[card.s] = (suits[card.s] or 0) + 1
            if card.s == 'S' or card.s == 'C' then
                if not stats.black_suit then stats.black_suit = card.s
                elseif stats.black_suit ~= card.s then stats.wrong_suits = true end
            end
            if card.s == 'H' or card.s == 'D' then
                if not stats.red_suit then stats.red_suit = card.s
                elseif stats.red_suit ~= card.s then stats.wrong_suits = true end
            end

            cards[card.s .. card.r] = (cards[card.s .. card.r] or 0) + 1
            if limits.no_faces and (card.r == 'J' or card.r == 'Q' or card.r == 'K') then
                errors['tcg_err_face_cards'] = {}
            end
        elseif card.type == 'c' then
            local consumable = G.P_CENTERS[card.c]

            stats.consumables = stats.consumables + 1

            consumables[card.c] = (consumables[card.c] or 0) + 1
            
            if consumable.set == 'Tarot' then
                stats.tarots = stats.tarots + 1
            elseif consumable.set == 'Planet' then
                stats.planets = stats.planets + 1
            elseif consumable.set == 'Spectral' then
                stats.spectrals = stats.spectrals + 1
            elseif consumable.set == 'Voucher' then
                stats.vouchers = stats.vouchers + 1
            -- TARGET: Check TCG consumeable types
            else
                errors['tcg_err_consumeable_banned'] = {}
            end
            
        elseif card.type == 'j' then
            local joker = G.P_CENTERS[card.c]

            if joker then
            
                stats.jokers = stats.jokers + 1

                -- for now, ban any exclusive rarity types.  May find a way around this later.
                if type(joker.rarity) == 'string' then
                    errors['tcg_err_consumeable_banned'] = {}
                -- TARGET: Check TCG rarities
                elseif joker.rarity == 2 then
                    stats.uncommons = stats.uncommons + 1
                elseif joker.rarity >= 3 then
                    stats.rares = stats.rares + 1
                end

                if joker.name == 'Showman' then
                    limits.total_copies = limits.total_copies + 1
                    jokers[card.c] = 1
                else
                    jokers[card.c] = (jokers[card.c] or 0) + 1
                end
            else
                print(card.c)
                errors['tcg_err_unknown_type'] = {}
            end
        else
            errors['tcg_err_unknown_type'] = {}
        end
    end


    for i, count in pairs(cards) do
        count = count - limits.suit_copies
        if count > 1 then
            local sub = math.min(count - 1, limits.playing_card_copies - stats.playing_card_copies)
            count = count - sub
            stats.playing_card_copies = stats.playing_card_copies + sub
            if count > 1 then
                stats.total_copies = stats.total_copies + (count - 1)
            end
        end
    end

    for i, count in pairs(jokers) do
        count = count - limits.joker_copies
        if count > 1 then
            stats.total_copies = stats.total_copies + (count - 1)
        end
    end


    for i, count in pairs(consumables) do
        count = count - limits.consumeable_copies
        
        local ctype = G.P_CENTERS[i].set

        if count > 1 then
            if ctype == 'Planet' and limits.planet_copies > 0 then
                count = count - limits.planet_copies
            elseif ctype == 'Spectral' and limits.spectral_copies > 0 then
                count = count - limits.spectral_copies
            elseif ctype == 'Tarot' and limits.tarot_copies > 0 then
                count = count - limits.tarot_copies
            elseif ctype == 'Voucher' and limits.voucher_copies > 0 then
                count = count - limits.voucher_copies
            end
            if count > 1 then
                stats.total_copies = stats.total_copies + (count - 1)
            end
        end
    end
    
    self:set_cost()
    if BalatroTCG.Settings.DeckLimitations.Money and self.cost > 110 then
        errors['tcg_err_cost'] = { 110 }
    end
    if BalatroTCG.Settings.DeckLimitations.BackCounts and #self.backs > (limits.deck_count or 1) then
        errors['tcg_err_deck_count'] = { (#self.backs - 1), ((limits.deck_count or 1) - 1) }
    end
    if BalatroTCG.Settings.DeckLimitations.Jokers and stats.jokers > limits.max_jokers then
        errors['tcg_err_joker_count'] = {stats.jokers, limits.max_jokers}
    end
    if BalatroTCG.Settings.DeckLimitations.Jokers and stats.uncommons > limits.max_uncommons then
        errors['tcg_err_uncommons'] = {stats.uncommons, limits.max_uncommons}
    end
    if BalatroTCG.Settings.DeckLimitations.Jokers and stats.rares > limits.max_rares then
        errors['tcg_err_rares'] = {stats.rares, limits.max_rares}
    end
    if BalatroTCG.Settings.DeckLimitations.Consumeables and stats.consumables > limits.max_consumables then
        errors['tcg_err_consumables'] = {stats.consumables, limits.max_consumables}
    end
    if BalatroTCG.Settings.DeckLimitations.Consumeables and stats.planets > limits.max_planets then
        errors['tcg_err_planets'] = {stats.planets, limits.max_planets}
    end
    if BalatroTCG.Settings.DeckLimitations.Consumeables and stats.tarots > limits.max_tarots then
        errors['tcg_err_tarots'] = {stats.tarots, limits.max_tarots}
    end
    if BalatroTCG.Settings.DeckLimitations.Consumeables and stats.spectrals > limits.max_spectrals then
        errors['tcg_err_spectrals'] = {stats.spectrals, limits.max_spectrals }
    end
    if BalatroTCG.Settings.DeckLimitations.Consumeables and stats.vouchers > limits.max_vouchers then
        errors['tcg_err_vouchers'] = {stats.vouchers, limits.max_vouchers }
    end
    if BalatroTCG.Settings.DeckLimitations.Consumeables and stats.total_copies > limits.total_copies then
        errors['tcg_err_copies'] = {stats.total_copies - limits.total_copies}
    end
    if limits.checkered_suits and stats.wrong_suits then
        errors['tcg_err_checkered_suits'] = {}
    end
    -- TARGET: Set TCG error types

    if next(errors) then
        return errors
    end
    return 'Legal'
end

function get_new_tcg_deck()

    local index = #BalatroTCG.CustomDecks + 1

    BalatroTCG.CustomDecks[index] = BalatroTCG.Deck('b_red', 'Custom_Deck', {
        { type = 'p', r = 'A', s = 'S' },
        { type = 'p', r = 'K', s = 'S' },
        { type = 'p', r = 'Q', s = 'S' },
        { type = 'p', r = 'J', s = 'S' },
        { type = 'p', r = 'T', s = 'S' },
        { type = 'p', r = '9', s = 'S' },
        { type = 'p', r = '8', s = 'S' },
        { type = 'p', r = '7', s = 'S' },
        { type = 'p', r = '6', s = 'S' },
        { type = 'p', r = '5', s = 'S' },
        { type = 'p', r = '4', s = 'S' },
        { type = 'p', r = '3', s = 'S' },
        { type = 'p', r = '2', s = 'S' },

        { type = 'p', r = 'A', s = 'H' },
        { type = 'p', r = 'K', s = 'H' },
        { type = 'p', r = 'Q', s = 'H' },
        { type = 'p', r = 'J', s = 'H' },
        { type = 'p', r = 'T', s = 'H' },
        { type = 'p', r = '9', s = 'H' },
        { type = 'p', r = '8', s = 'H' },
        { type = 'p', r = '7', s = 'H' },
        { type = 'p', r = '6', s = 'H' },
        { type = 'p', r = '5', s = 'H' },
        { type = 'p', r = '4', s = 'H' },
        { type = 'p', r = '3', s = 'H' },
        { type = 'p', r = '2', s = 'H' },
        
        { type = 'p', r = 'A', s = 'C' },
        { type = 'p', r = 'K', s = 'C' },
        { type = 'p', r = 'Q', s = 'C' },
        { type = 'p', r = 'J', s = 'C' },
        { type = 'p', r = 'T', s = 'C' },
        { type = 'p', r = '9', s = 'C' },
        { type = 'p', r = '8', s = 'C' },
        { type = 'p', r = '7', s = 'C' },
        { type = 'p', r = '6', s = 'C' },
        { type = 'p', r = '5', s = 'C' },
        { type = 'p', r = '4', s = 'C' },
        { type = 'p', r = '3', s = 'C' },
        { type = 'p', r = '2', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        { type = 'p', r = '6', s = 'D' },
        { type = 'p', r = '5', s = 'D' },
        { type = 'p', r = '4', s = 'D' },
        { type = 'p', r = '3', s = 'D' },
        { type = 'p', r = '2', s = 'D' },
        
        { type = 'j', c = 'j_cavendish' },
        { type = 'j', c = 'j_joker' },
        { type = 'j', c = 'j_gros_michel' },
        
        { type = 'j', c = 'j_blueprint' },
        
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_hermit' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_ectoplasm' },
    })
	
    BalatroTCG.CustomDecks[index]:set_cost()
    return BalatroTCG.CustomDecks[index]
end
