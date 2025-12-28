--Class
BalatroTCG.Deck = Object:extend()

function BalatroTCG.Deck:init(back, name, cards)
    self.back = back
    self.cards = cards
    self.name = name or back
end

BalatroTCG.DefaultDecks = {
    BalatroTCG.Deck('Red Deck', "Ancient Deck", -- Done
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
    BalatroTCG.Deck('Blue Deck', "Green Joker Deck", 
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
    BalatroTCG.Deck('Yellow Deck', "Hiker Deck", 
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
    BalatroTCG.Deck('Green Deck', "Bootstraps Deck", 
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
    BalatroTCG.Deck('Black Deck', "Baseball Deck", 
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
    BalatroTCG.Deck('Magic Deck', "Vagabond Deck", 
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
        
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_devil' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_chariot' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_death' },
        { type = 'c', c = 'c_fool' },
        { type = 'c', c = 'c_fool' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_jupiter' },
        
        { type = 'c', c = 'c_medium' },
        { type = 'c', c = 'c_trance' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_talisman' },

    }),
    BalatroTCG.Deck('Nebula Deck', "Constellation Deck", 
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
        { type = 'p', r = '7', s = 'C' },
        
        { type = 'p', r = 'A', s = 'D' },
        { type = 'p', r = 'K', s = 'D' },
        { type = 'p', r = 'Q', s = 'D' },
        { type = 'p', r = 'J', s = 'D' },
        { type = 'p', r = 'T', s = 'D' },
        { type = 'p', r = '9', s = 'D' },
        { type = 'p', r = '8', s = 'D' },
        { type = 'p', r = '7', s = 'D' },
        
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
        { type = 'c', c = 'c_moon' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_jupiter' },
        { type = 'c', c = 'c_mercury' },
        { type = 'c', c = 'c_venus' },
        { type = 'c', c = 'c_mars' },
        { type = 'c', c = 'c_mars' },
        
        { type = 'c', c = 'c_aura' },
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_talisman' },

    }),
    BalatroTCG.Deck('Ghost Deck', "Stencil Deck", 
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
        { type = 'c', c = 'c_moon' },
        
        { type = 'c', c = 'c_pluto' },
        { type = 'c', c = 'c_uranus' },
        { type = 'c', c = 'c_jupiter' },
        
        { type = 'c', c = 'c_immolate' },
        { type = 'c', c = 'c_ectoplasm' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_cryptid' },
        { type = 'c', c = 'c_soul' },
        { type = 'c', c = 'c_ankh' },
        { type = 'c', c = 'c_ankh' },
        { type = 'c', c = 'c_talisman' },

    }),
    BalatroTCG.Deck('Abandoned Deck', "Bus Deck", 
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
    BalatroTCG.Deck('Checkered Deck', "Bloodstone Deck", 
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
    BalatroTCG.Deck('Zodiac Deck', "Campfire Deck", 
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
    BalatroTCG.Deck('Painted Deck', "Runner Deck", 
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
    BalatroTCG.Deck('Anaglyph Deck', "Square Deck", 
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
    BalatroTCG.Deck('Plasma Deck', "Baron Deck", 
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
    BalatroTCG.Deck('Erratic Deck', "Wee Deck",
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
    BalatroTCG.Deck('Challenge Deck', "Jokerless Deck", 
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

BalatroTCG.CustomDecks = {}


function BalatroTCG.Deck:card_from_control_ex(deck, back, control)

    local _card = nil

    if control.type == 'p' then
        _card = Card(deck.T.x, deck.T.y, G.CARD_W, G.CARD_H, G.P_CARDS[control.s..'_'..control.r], G.P_CENTERS['c_base'], {playing_card = G.playing_card, tcg_back = back})
    elseif control.type == 'j' then
        _card = Card(deck.T.x, deck.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[control.c], {playing_card = G.playing_card, tcg_back = back})
        _card.base.suit = 'tcgb_Joker'
    elseif control.type == 'c' then
        _card = Card(deck.T.x, deck.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[control.c], {playing_card = G.playing_card, tcg_back = back})
        if _card.config.center.set == 'Planet' then
            _card.base.suit = 'tcgb_Planet'
        elseif _card.config.center.set == 'Tarot' then
            _card.base.suit = 'tcgb_Tarot'
        elseif _card.config.center.set == 'Spectral' then
            _card.base.suit = 'tcgb_Spectral'
        end
    end

    return _card
end

function splitlines(inputstr, sep)
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function load_custom_decks()
    
    BalatroTCG.CustomDecks = {}

    local file_data = love.filesystem.getInfo('tcg_decks.jkr')

    if file_data then
        local file_string = love.filesystem.read('tcg_decks.jkr')

        if file_string ~= '' then
            local decks = read_decks(file_string)

            for _, data in pairs(decks) do
                
                local deck = BalatroTCG.Deck(data.back, data.name, data.cards)

                local legal = deck:is_legal()
                BalatroTCG.CustomDecks[#BalatroTCG.CustomDecks + 1] = deck
                
            end
        end
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
            toWrite = toWrite .. '\t' .. v.back .. '\n'

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
local set_rating = {Tarot = 0, Planet = 1, Spectral = 2 }
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
        return card_nominal(a) < card_nominal(b)
    end
    table.sort(self.cards, compare_cards)
end

function card_nominal(card)
    local factor = type_rating[card.type] * 100
    
    if card.type == 'c' then
        factor = factor + set_rating[G.P_CENTERS[card.c].set] + pseudohash(card.c) * 0.01
    elseif card.type == 'j' then
        factor = factor + G.P_CENTERS[card.c].rarity + pseudohash(card.c) * 0.01
    elseif card.type == 'p' then
        factor = factor + rank_rating[card.r] * 0.01 + suit_rating[card.s]
    end

    return factor
end


function BalatroTCG.Deck:set_cost()
    self.cost = 0

    local back = Back(get_deck_from_name(self.back))

    if back.tcg_cost then
        self.cost = back.tcg_cost
    else
        if self.back == 'Abandoned Deck' then
            self.cost = 15
        elseif self.back == 'Checkered Deck' then
            self.cost = 10
        elseif self.back == 'Yellow Deck' then
            self.cost = 10
        elseif self.back == 'Plasma Deck' then
            self.cost = 15
        elseif self.back == 'Challenge Deck' then
            self.cost = 25
        else
            self.cost = 05
        end
    end

    for i, card in ipairs(self.cards) do

        if card.type == 'p' then
            self.cost = self.cost + 1
        else
            local consumable = G.P_CENTERS[card.c]
            self.cost = self.cost + consumable.cost
        end
    end
end

function BalatroTCG.Deck:is_legal()

    local back = Back(get_deck_from_name(self.back))

    local errors = {}
    
    if back.tcg_verify then
        errors = back:tcg_verify(params)
    else

        local limits = {
            deck_size = 60,
            max_jokers = 15,
            max_tarots = 15,
            max_planets = 15,
            max_spectrals = 15,
            max_consumables = 20,
            max_uncommons = 3,
            max_rares = 1,
            no_faces = false,
            checkered_suits = false,
            total_copies = 0,
            suit_copies = 0,
            playing_card_copies = 0,
            consumeable_copies = 0,
            planet_copies = 0,
            tarot_copies = 0,
            spectral_copies = 0,
        }
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
        }
        
        if self.back == 'Magic Deck' then
            limits.tarot_copies = 1
        elseif self.back == 'Nebula Deck' then
            limits.planet_copies = 1
        elseif self.back == 'Ghost Deck' then
            limits.spectral_copies = 1
        elseif self.back == 'Abandoned Deck' then
            limits.no_faces = true
            limits.deck_size = 50
        elseif self.back == 'Checkered Deck' then
            limits.checkered_suits = true
            limits.suit_copies = 1
        elseif self.back == 'Zodiac Deck' then
        elseif self.back == 'Erratic Deck' then
            limits.playing_card_copies = 4
        elseif self.back == 'Challenge Deck' then
            limits.max_jokers = 0
            limits.max_uncommons = 0
            limits.max_rares = 0
            limits.max_consumables = 30
            limits.max_tarots = 30
            limits.max_planets = 30
            limits.max_spectrals = 30
            limits.consumeable_copies = 1
        end
        
        if #self.cards > limits.deck_size then
            errors['tcg_err_deck_big'] = {#self.cards, limits.deck_size}
        elseif #self.cards < limits.deck_size then
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
                else
                    errors['tcg_err_consumeable_banned'] = {}
                end
                
            elseif card.type == 'j' then
                local joker = G.P_CENTERS[card.c]


                stats.jokers = stats.jokers + 1

                if joker.rarity == 2 then
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
                end
                if count > 1 then
                    stats.total_copies = stats.total_copies + (count - 1)
                end
            end
        end
        
        self:set_cost()
        if self.cost > 150 then
            errors['tcg_err_cost'] = { 150 }
        end
        if stats.jokers > limits.max_jokers then
            errors['tcg_err_joker_count'] = {stats.jokers, limits.max_jokers}
        end
        if stats.uncommons > limits.max_uncommons then
            errors['tcg_err_uncommons'] = {stats.uncommons, limits.max_uncommons}
        end
        if stats.rares > limits.max_rares then
            errors['tcg_err_rares'] = {stats.rares, limits.max_rares}
        end
        if stats.consumables > limits.max_consumables then
            errors['tcg_err_consumables'] = {stats.consumables, limits.max_consumables}
        end
        if stats.planets > limits.max_planets then
            errors['tcg_err_planets'] = {stats.planets, limits.max_planets}
        end
        if stats.tarots > limits.max_tarots then
            errors['tcg_err_tarots'] = {stats.tarots, limits.max_tarots}
        end
        if stats.spectrals > limits.max_spectrals then
            errors['tcg_err_spectrals'] = {stats.spectrals, limits.max_spectrals }
        end
        if stats.total_copies > limits.total_copies then
            errors['tcg_err_copies'] = {stats.total_copies - limits.total_copies}
        end
        if limits.checkered_suits and stats.wrong_suits then
            errors['tcg_err_checkered_suits'] = {}
        end

    end
    if next(errors) then
        return errors
    end
    return 'Legal'
end

function get_new_deck()

    local index = #BalatroTCG.CustomDecks + 1

    BalatroTCG.CustomDecks[index] = BalatroTCG.Deck('Red Deck', 'New Deck', {
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
    })
	
    BalatroTCG.CustomDecks[index]:set_cost()
    return BalatroTCG.CustomDecks[index]
end

function get_tcg_deck(index, illegal)
    index = index or 1
	if index <= #BalatroTCG.DefaultDecks then
		return BalatroTCG.DefaultDecks[index]
	end
    index = index - #BalatroTCG.DefaultDecks
	if index <= #BalatroTCG.CustomDecks then
		return BalatroTCG.CustomDecks[index]
	end
    
    return BalatroTCG.DefaultDecks[1]
end
