return {
	descriptions = {
        Back={
            b_abandoned_tcg={
                name="Abandoned Deck",
                text={
                    "No {C:attention}Face Cards{} at start,",
                    "has {C:attention}50{} card limit",
                },
            },
            b_anaglyph_tcg={
                name="Anaglyph Deck",
                text={
                    "Gain {C:blue}+#1#{} hand and",
					"{C:red}+#1#{} discard",
                    "every {C:attention}#2#{} rounds",
                },
            },
            b_black_tcg={
                name="Black Deck",
                text={
                    "{C:attention}+#1#{} Joker slot",
                    "{C:red}-#2#{} hand size",
                },
            },
            b_blue_tcg={
                name="Blue Deck",
                text={
                    "{C:blue}+#1#{} hand",
                    "every round",
                },
            },
            b_challenge_tcg={
                name="Challenge Deck",
                text={
                    "No Jokers, {C:attention}#1#{} Consumeables",
					"Consumeables can have",
                    "{C:attention}1{} duplicate",
                },
            },
            b_checkered_tcg={
                name="Checkered Deck",
                text={
                    "One {C:spades}Black{} suit and",
					"one {C:hearts}Red{} suit,",
                    "Playing cards can have",
                    "{C:attention}1{} duplicate",
                },
            },
            b_erratic_tcg={
                name="Erratic Deck",
                text={
                    "Can have {C:attention}#1#",
                    "playing card duplicates",
                },
            },
            b_ghost_tcg={
                name="Ghost Deck",
                text={
                    "{C:spectral}Spectral{} cards can have",
                    "{C:attention}1{} duplicate",
                },
            },
            b_green_tcg={
                name="Green Deck",
                text={
                    "Earn {C:money}$#1#{s:0.85} per remaining {C:red}Discard",
                    "at the end of each round",
                },
            },
            b_magic_tcg={
                name="Magic Deck",
                text={
                    "{C:attention}Tarot{} cards can have",
                    "{C:attention}1{} duplicate",
                },
            },
            b_nebula_tcg={
                name="Nebula Deck",
                text={
                    "{C:attention}Planet{} cards can have",
                    "{C:attention}1{} duplicate",
                },
            },
            b_painted_tcg={
                name="Painted Deck",
                text={
                    "{C:attention}+#1#{} hand size,",
                    "{C:red}#2#{} Joker slot",
                },
            },
            b_plasma_tcg={
                name="Plasma Deck",
                text={
                    "Balance {C:blue}Chips{} and",
                    "{C:red}Mult{} when calculating",
                    "score for played hand",
                    "Take {C:red}#1#{} damage per {C:attention}#2#{} dealt",
                },
            },
            b_red_tcg={
                name="Red Deck",
                text={
                    "{C:red}+#1#{} discard",
                    "every round",
                },
            },
            b_yellow_tcg={
                name="Yellow Deck",
                text={
                    "Start with",
                    "extra {C:money}$#1#",
                },
            },
            b_zodiac_tcg={
                name="Zodiac Deck",
                text={
                    "{C:attention}+#1#{} hand size,",
                    "Items are {C:attention}#2#%{} off",
					"rounded up",
                },
            },
        },
        Enhanced={
            m_gold_tcg={
                name="Gold Card",
                text={
                    "{C:money}$#1#{} if this",
                    "card is held in hand",
                    "at end of round,",
                    "no rank or suit",
                },
            },
            m_steel={
                name="Steel Card",
                text={
                    "{X:mult,C:white} X#1# {} Mult",
                    "while this card",
                    "stays in hand",
                },
            },
        },
        Joker={
            j_campfire_tcg={
                name="Campfire",
                text={
                    "This Joker gains {X:mult,C:white}X#1#{} Mult",
                    "for each card {C:attention}sold{}, reduces by",
                    "{X:mult,C:white}X#2#{} Mult per round",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
                },
            },
            j_vagabond_tcg={
                name="Vagabond",
                text={
                    "Fills consumeables with",
                    "random {C:purple}Tarots{}",
                    "if hand is played",
                    "with {C:money}$#1#{} or less",
                },
            },
            j_flash_tcg={
                name="Flash Card",
                text={
                    "This Joker gains {C:red}+#1#{} Mult",
                    "per non playing card left in",
                    "hand at end of round",
                    "{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)",
                },
            },
            j_red_card_tcg={
                name="Red Card",
                text={
                    "Gain {C:red}+#1#{} Mult when",
                    "discarding #2# or more",
                    "non playing cards",
                    "{C:inactive}(Currently {C:red}+#3#{C:inactive} Mult)",
                },
            },
            j_ticket_tcg={
                name="Golden Ticket",
                text={
                    "Played {C:attention}Gold{} cards",
                    "earn {C:money}$#1#{} when scored,",
                    "removes {C:attention}Enhancement{} after"
                },
            },
            j_acrobat_tcg={
                name="Acrobat",
                text={
                    "Gain {X:red,C:white}X#1# {} Mult per round",
                    "{C:inactive}(Currently {X:red,C:white}X#2#{C:inactive} Mult)",
                },
            },
            j_square_tcg={
                name="Square Joker",
                text={
                    "This Joker gains {C:chips}+#2#{} Chips",
                    "if played hand or discard",
                    "has exactly {C:attention}4{} cards",
                    "{C:inactive}(Currently {C:chips}#1#{C:inactive} Chips)",
                },
            },
            j_business_tcg={
                name="Business Card",
                text={
                    "Played {C:attention}face{} cards have",
                    "a {C:green}#1# in #2#{} chance to",
                    "give {C:money}$1{} when scored",
                },
            },
            j_rocket_tcg={
                name="Rocket",
                text={
                    "Earn {C:money}$#1#{} at end of round",
                    "Payout increases by {C:money}$#2#{},",
                    "Destroys self at {C:money}$#3#{}",
                },
            },
            j_obelisk_tcg={
                name="Obelisk",
                text={
                    "Multiples Mult by {X:mult,C:white} X#1# {}",
                    "per {C:attention}consecutive{} hand played",
                    "without playing your",
                    "most played {C:attention}poker hand",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                },
            },
            j_madness_tcg={
                name="Madness",
                text={
                    "Gain {X:mult,C:white} X#1# {} Mult at end of round",
                    "and {C:attention}destroy{} a random Joker",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                },
            },
            j_photograph_tcg={
                name="Photograph",
                text={
                    "Last played {C:attention}face",
                    "card gives {X:mult,C:white} X#1# {} Mult",
                    "when scored",
                },
            },
            j_bull_tcg={
                name="Bull",
                text={
                    "{C:chips}+#1#{} Chips for",
                    "each double of money",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
                },
            },
            j_bootstraps_tcg={
                name="Bootstraps",
                text={
                    "{C:mult}+#1#{} Mult for every",
                    "each double of money",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
            j_cloud_9_tcg={
                name="Cloud 9",
                text={
                    "Reduce damage taken by",
                    "1 every {C:attention}#1# nines{}",
                    "in your {C:attention}full deck",
                    "{C:inactive}(Currently {C:money}$#2#{}{C:inactive})",
                },
            },
            j_golden_tcg={
                name="Golden Joker",
                text={
                    "Reduce damage",
                    "taken by {C:attention}#1#{}",
                },
            },
            j_dusk_tcg={
                name="Dusk",
                text={
                    "Retrigger all played cards",
                    "if hand is played",
                    "with {C:money}$#1#{} or less",
                },
            },
            j_matador_tcg={
                name="Matador",
                text={
                    "Redirect all damage",
                    "to this {C:attention}Joker"
                },
            },
            j_chicot_tcg={
                name="Chicot",
                text={
                    "Heal all {C:attention}Jokers{} by {C:attention}#1#",
                },
            },
            j_mr_bones_tcg={
                name="Mr. Bones",
                text={
                    "Reduce damage taken by {C:attention}#1#%",
                    "for every copy of Mr. Bones",
                },
            },
            j_abstract_tcg={
                name="Abstract Joker",
                text={
                    "{C:mult}+#1#{} Mult for",
                    "each {C:attention}Joker{} card in play",
                    "{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)",
                },
            },
            j_supernova_tcg={
                name="Supernova",
                text={
                    "{C:red}+#1#{} Mult for number of",
                    "times {C:attention}poker hand{}",
                    "has been played this run",
                },
            },
            j_to_the_moon_tcg={
                name="To the Moon",
                text={
                    "Earn {C:money}$#1#{} of {C:attention}interest{}",
                    "for every {C:money}$5{} you",
                    "have at end of round",
                },
            },
            j_trading_tcg={
                name="Trading Card",
                text={
                    "If {C:attention}first discard{} of round",
                    "has only {C:attention}1{} card, destroy card",
                },
            },
            j_diet_cola_tcg={
                name="Diet Cola",
                text={
                    "Sell this card to",
                    "gain {C:blue}+1{} hand and",
                    "{C:red}+1{} discard"
                },
            },
            j_swashbuckler_tcg={
                name="Swashbuckler",
                text={
                    "Adds the sell value",
                    "of all other",
                    "{C:attention}Jokers{} to Mult",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
                },
            },
            j_satellite_tcg={
                name="Satellite",
                text={
                    "Reduce damage taken by",
                    "{C:attention}1{} per unique {C:planet}Planet",
                    "card used this run",
                    "{C:inactive}(Currently {C:money}$#2#{C:inactive})",
                }
            },
            j_troubadour_tcg={
                name="Troubadour",
                text={
                    "{C:attention}+#1#{} hand size,",
                    "{C:red}-#2#{} discard each round",
                },
            },
            j_ring_master_tcg={
                name="Showman",
                text={
                    "Allows {C:attention}1{} extra",
                    "copy of any kind of",
                    "card in your deck",
                },
            },
            j_luchador_tcg={
                name="Luchador",
                text={
                    "Sell this card to reduce",
                    "damage taken by {C:attention}#1#%",
                },
            },
            j_chaos_tcg={
                name="Chaos the Clown",
                text={
                    "Shuffles and flips",
                    "{C:attention}Jokers{} when",
                    "opponent starts"
                },
            },
            j_throwback_tcg={
                name="Throwback",
                text={
                    "Gains {X:mult,C:white} X#1# {} Mult for each",
                    "discard not used this round.",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                },
            },
            j_ceremonial_tcg={
                name="Ceremonial Dagger",
                text={
                    "At start of round,",
                    "destroy Joker to the right",
                    "and permanently add {C:attention}#1#x",
                    "its sell value to this {C:red}Mult",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
        },
        Other={
            tcg_joker_health={
                name="Health",
                text={
                    "Destroyed after taking",
                    "{C:attention}#1#{} damage",
                    "{C:inactive}({C:attention}#2#{C:inactive} remaining)",
                },
            },
        },
        Spectral={
            c_soul_tcg={
                name="The Soul",
                text={
                    "One random {C:attention}Joker",
                    "becomes {C:attention}Eternal,",
                    "removes {C:attention}Eternal{} from",
                    "the rest"
                },
            },
            c_wraith_tcg={
                name="Wraith",
                text={
                    "Draws {C:red}Rare{} or",
                    "{C:legendary,E:1}Legendary{} Joker",
                    "to hand",
                },
            },
            c_immolate_tcg={
                name="Immolate",
                text={
                    "Destroys {C:attention}#1#{} random",
                    "cards in hand,"
                },
            },
        },
        Tarot={
            c_emperor_tcg={
                name="The Emperor",
                text={
                    "Creates up to {C:attention}#1#",
                    "random {C:tarot}Tarot{} card",
                    "{C:inactive}(Must have room)",
                },
            },
            c_high_priestess_tcg={
                name="The High Priestess",
                text={
                    "Creates up to {C:attention}#1#",
                    "random {C:planet}Planet{} card",
                    "{C:inactive}(Must have room)",
                },
            },
        },
	},
	misc = {
		dictionary = {
			b_tcg_vanilla = "Vanilla",
			b_tcg_tcg = "TCG",
            
            b_tcg_build = "Build",
            b_tcg_delete = "Delete",
            
            b_tcg_jokercount = "Joker Count",
            
            b_tcg_add = "Add",
            b_tcg_remove = "Remove",
            b_tcg_apply = "Apply",
            
			b_tcgtab_single = "Single Game",
			b_tcgtab_deck = "Build Deck",
			b_tcgtab_online = "Online Match",
			b_tcgtab_online_start = "Online Match",
			b_tcgtab_online_cant = "Incompatible Server",
			b_tcgtab_select = "Select Deck",
            
			b_tcg_opponent = "Opponent",
			b_tcg_healthopponent = "Health",

			b_tcg_attack = "Attack",
			b_tcg_buy = "Buy $",
			b_tcg_bet = "Bet",

			k_tcg_bet = "Spend $ to go first?",
			k_tcg_waiting = "Waiting for opponent...",

		},
        v_text = {
            tcg_err_none={
                "No errors found",
            },
            tcg_err_joker_count={
                "Joker count too high (#1#), max count of #2#",
            },
            tcg_err_cost={
                "Deck too expensive, must be $#1# or less",
            },
            tcg_err_deck_big={
                "Deck is too big (#1#), required count of #2#",
            },
            tcg_err_deck_small={
                "Deck is too small (#1#), required count of #2#",
            },
            tcg_err_uncommons={
                "Too many uncommons (#1#), max count of #2#",
            },
            tcg_err_rares={
                "Too many rares/legendaries (#1#), max count of #2#",
            },
            tcg_err_consumables={
                "Too many Consumeables (#1#), max count of #2#",
            },
            tcg_err_tarots={
                "Too many Tarots (#1#), max count of #2#",
            },
            tcg_err_planets={
                "Too many Planets (#1#), max count of #2#",
            },
            tcg_err_spectrals={
                "Too many Spectrals (#1#), max count of #2#",
            },
            tcg_err_copies={
                "You have #1# extra copie(s)",
            },
            tcg_err_face_cards={
                "No face cards are allowed",
            },
            tcg_err_checkered_suits={
                "Only allowed one red and one black suit",
            },
            tcg_err_unknown={
                "Unknown Error",
            },
        }
	},
}
