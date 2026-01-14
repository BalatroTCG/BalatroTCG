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
                    "{C:attention}0{} Joker slots, {C:attention}#1#{} Items",
					"of any type,",
                    "{C:attention}Items{} can be reused",
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
                    "{C:tarot}Tarot{} cards can have",
                    "{C:attention}1{} duplicate",
                },
            },
            b_nebula_tcg={
                name="Nebula Deck",
                text={
                    "{C:planet}Planet{} cards can have",
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
                    "Deal {C:red}#1#%{} damage",
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
                    "Start game with",
                    "extra {C:money}$#1#",
                },
            },
            b_zodiac_tcg={
                name="Zodiac Deck",
                text={
                    "Start game with",
                    "{C:tarot,T:v_tarot_merchant}#1#{},",
                    "and {C:planet,T:v_planet_merchant}#2#{}",
                },
            },

            
			b_mp_cocktail_tcg = {
				name = "Cocktail Deck",
				text = {
					"Copies all effects",
					"of {C:attention}#1#{} other decks,",
                    "{C:red}-#2#{} hand",
				},
			},
			b_mp_gradient_tcg = {
				name = "Gradient Deck",
				text = {
					"Cards are also considered",
					"one rank {C:attention}higher{} or {C:attention}lower",
					"for all {C:attention}Joker{} effects",
				},
			},
			b_mp_heidelberg_tcg = {
				name = "Heidelberg Deck",
				text = {
					"Up to {C:attention}#1#{} Rares/Legendaries",
					"{C:attention}0{} Uncommons",
				},
			},
			b_mp_indigo_tcg = {
				name = "Indigo Deck",
				text = {
					"Discarding {C:attention}Items{}",
					"destroys them",
				},
			},
			b_mp_oracle_tcg = {
				name = "Oracle Deck",
				text = {
                    "Start game with",
                    "{C:money,T:v_clearance_sale}#1#{},",
					"Balance is capped at",
					"{C:money}#2#%{} starting value",
				},
			},
			b_mp_orange_tcg = {
				name = "Orange Deck",
				text = {
					"Start game with",
					"{C:attention}#1#{} random Tarots",
					"in your consumables",
				},
			},
			b_mp_violet_tcg = {
				name = "Violet Deck",
				text = {
					"{C:attention}+#1#{} max Vouchers",
				},
			},
        },
        Enhanced={
            m_glass_tcg={
                name="Glass Card",
                text={
                    "{X:mult,C:white} X#1# {} Mult",
                    "{C:red}Destroyed{} on",
                    "any retrigger",
                },
            },
            m_lucky_tcg={
                name="Lucky Card",
                text={
                    "{C:green}#1# in #2#{} chance",
                    "to win {C:money}$#3#",
                    "{C:red}Destroyed{} when",
                    "successful",
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
                    "Draw a random {C:purple}Tarot{}",
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
                    "discarding {C:attention}#2#{} or more",
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
                    "if played {C:blue}hand{} or {C:red}discard",
                    "has exactly {C:attention}4{} cards",
                    "{C:inactive}(Currently {C:chips}#1#{C:inactive} Chips)",
                },
            },
            j_business_tcg={
                name="Business Card",
                text={
                    "Played {C:attention}face{} cards have",
                    "a {C:green}#1# in #2#{} chance to",
                    "give {C:money}$2{} when scored",
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
            j_burglar_tcg={
                name="Burglar",
                text={
                    "At start of {C:attention}Round{},",
                    "gain {C:blue}+#1#{} Hands and",
                    "{C:attention}lose all discards",
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
            j_riff_raff_tcg={
                name="Riff-Raff",
                text={
                    "At start of {C:attention}Round{},",
                    "draw a random {C:attention}#1# {C:blue}Common{C:attention} Joker",
                    "{C:inactive}(Must have room)",
                },
            },
            j_bull_tcg={
                name="Bull",
                text={
                    "{C:chips}+#1#{} Chips for every {C:money}$1{}",
                    "you and your opponent have",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
                },
            },
            j_bootstraps_tcg={
                name="Bootstraps",
                text={
                    "{C:mult}+#1#{} Mult for every {C:money}$1{}",
                    "you and your opponent have",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
            j_cloud_9_tcg={
                name="Cloud 9",
                text={
                    "Reduce damage taken by",
                    "{C:attention}1{} every {C:attention}#1#{} nines",
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
                    "each {C:attention}Joker{} card in game",
                    "{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)",
                },
            },
            j_supernova_tcg={
                name="Supernova",
                text={
                    "{C:red}+#1#{} Mult for number of",
                    "times {C:attention}poker hand{}",
                    "has been played this game",
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
                    "card used this game",
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
                    "Sell this card to",
                    "reduce damage taken",
                    "by {C:attention}#1#% this round",
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
                    "At start of {C:attention}Round{},",
                    "destroy {C:attention}Joker{} to the right",
                    "and permanently add {C:attention}#1#x",
                    "its sell value to this {C:red}Mult",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
            j_marble_tcg={
                name="Marble Joker",
                text={
                    "Adds one {C:attention}Stone{} card",
                    "to deck at start of {C:attention}Round{}",
                },
            },
            j_sixth_sense_tcg={
                name="Sixth Sense",
                text={
                    "If {C:attention}first hand{} of round is",
                    "a single {C:attention}6{}, destroy it and",
                    "draw a {C:spectral}Spectral{} card",
                    "{C:inactive}(Must have room)",
                },
            },
            j_card_sharp_tcg={
                name="Card Sharp",
                text={
                    "{X:mult,C:white} X#1# {} Mult if played {C:attention}poker hand{}",
                    "is the same as the",
                    "previous {C:attention}hand{} this game",
                },
            },
            j_madness_tcg={
                name="Madness",
                text={
                    "At start of {C:attention}Round{},",
                    "gain {X:mult,C:white} X#1# {} Mult",
                    "and {C:attention}destroy{} a random Joker",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                },
            },
            j_seance_tcg={
                name="Séance",
                text={
                    "If {C:attention}poker hand{} is a",
                    "{C:attention}#1#{}, draw a",
                    "random {C:spectral}Spectral{} card",
                    "{C:inactive}(Must have room)",
                },
            },
            j_fortune_teller_tcg={
                name="Fortune Teller",
                text={
                    "{C:red}+#1#{} Mult per {C:purple}Tarot{}",
                    "card used this game",
                    "{C:inactive}(Currently {C:red}+#2#{C:inactive})",
                },
            },
            j_hallucination_tcg={
                name="Hallucination",
                text={
                    "{C:green}#1# in #2#{} chance to draw",
                    "a {C:tarot}Tarot{} card when played hand",
                    "contains a non playing card",
                    "{C:inactive}(Must have room)",
                },
            },
            j_astronomer_tcg={
                name="Astronomer",
                text={
                    "All {C:planet}Planet{} cards",
                    "are {C:attention}free",
                },
            },
            j_perkeo_tcg={
                name="Perkeo",
                text={
                    "Creates a {C:dark_edition}Negative{} copy of",
                    "{C:attention}1{} random {C:attention}consumable{}",
                    "card in your possession",
                    "at start of {C:attention}Round{},",
                },
                unlock={
                    "{E:1,s:1.3}?????",
                },
            },
            j_cartomancer_tcg={
                name="Cartomancer",
                text={
                    "Draw a {C:tarot}Tarot{} card",
                    "at start of {C:attention}Round{},",
                    "{C:inactive}(Must have room)",
                },
                unlock={
                    "Discover every",
                    "{E:1,C:tarot}Tarot{} card",
                },
            },
        },
        Other={
            tcg_joker_health={
                name="Health",
                text={
                    "Destroyed when losing",
                    "all it's health",
                    "{C:inactive}({C:attention}#2#{C:inactive} remaining)",
                },
            },
        },
        Spectral={
            c_ankh_tcg={
                name="Ankh",
                text={
                    "Create a copy of a",
                    "random {C:attention}Joker{}, adds",
                    "rental to copy",
                },
            },
            c_soul_tcg={
                name="The Soul",
                text={
                    "One random {C:attention}Joker",
                    "becomes {C:attention}Eternal,",
                    "destroy all other Jokers",
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
                    "Destroys {C:attention}5{} random",
                    "cards in hand,"
                },
            },
        },
        Tarot={
            c_emperor_tcg={
                name="The Emperor",
                text={
                    "Pulls up to {C:attention}2",
                    "random {C:tarot}Tarot{} cards",
                    "from your full deck",
                    "{C:inactive}(Must have room)",
                },
            },
            c_fool_tcg={
                name="The Fool",
                text={
                    "Draws the last",
                    "{C:tarot}Tarot{} or {C:planet}Planet{} card",
                    "used during this game",
                    "{s:0.8,C:tarot}The Fool{s:0.8} excluded",
                },
            },
            c_high_priestess_tcg={
                name="The High Priestess",
                text={
                    "Draws up to {C:attention}2",
                    "random {C:planet}Planet{} cards",
                    "from your full deck",
                    "{C:inactive}(Must have room)",
                },
            },
            c_judgement={
                name="Judgement",
                text={
                    "Draws a random",
                    "{C:attention}Joker{} card",
                    "from your full deck",
                    "{C:inactive}(Must have room)",
                },
            },
        },
        Voucher={
            v_clearance_sale_tcg={
                name="Clearance Sale",
                text={
                    "All {C:attention}Items{}",
                    "are {C:attention}#1#%{} off",
                },
            },
            v_directors_cut_tcg={
                name="Director's Cut",
                text={
                    "Spend {C:money}$#1#{} once per round",
                    "to add {C:attention}#2#{} damage",
                    "to your attack",
                },
            },
            v_glow_up_tcg={
                name="Glow Up",
                text={
                    "{C:attention}Jokers{} each give",
                    "{X:red,C:white}#1#x{} Mult",
                },
            },
            v_hieroglyph_tcg={
                name="Hieroglyph",
                text={
                    "Reduce damage taken by {C:money}#1#",
                    "{C:red}-1{} discard",
                },
            },
            v_hone_tcg={
                name="Hone",
                text={
                    "{C:attention}Jokers{} each give",
                    "{C:blue}+#1#{} chips",
                },
            },
            v_illusion_tcg={
                name="Illusion",
                text={
                    "Scored cards give",
                    "{X:red,C:white}#1#x{} Mult",
                },
            },
            v_liquidation_tcg={
                name="Liquidation",
                text={
                    "All {C:attention}Items{}",
                    "are {C:attention}#1#%{} off",
                },
            },
            v_magic_trick_tcg={
                name="Magic Trick",
                text={
                    "{C:attention}Playing cards{} can",
                    "be bought"
                },
            },
            v_money_tree_tcg={
                name="Money Tree",
                text={
                    "Gain {C:money}$1{} per round",
                    "for every {C:attention}dollar",
                    "lost from Seed Money",
                    "{C:inactive}(Currently {C:money}$#1#{}{C:inactive})",
                },
            },
            v_omen_globe_tcg={
                name="Omen Globe",
                text={
                    "Start each round",
                    "with {C:attention}#1# {C:spectral}Spectral{}",
                    "in your inventory",
                },
            },
            v_overstock_norm_tcg={
                name="Overstock",
                text={
                    "{C:attention}Consumeables{} can be put",
                    "in {C:attention}Joker{} slots",
                },
            },
            v_overstock_plus_tcg={
                name="Overstock Plus",
                text={
                    "{C:attention}Jokers{} can be put in",
                    "your {C:attention}inventory",
                },
            },
            v_petroglyph_tcg={
                name="Petroglyph",
                text={
                    "Reduce damage taken by {C:money}#1#",
                    "{C:red}-1{} discard",
                },
            },
            v_planet_merchant_tcg={
                name="Planet Merchant",
                text={
                    "Start each round",
                    "with {C:attention}#1# {C:planet}Planet{}",
                    "in your inventory",
                },
            },
            v_planet_tycoon_tcg={
                name="Planet Tycoon",
                text={
                    "{C:planet}Planets{} don't take up",
                    "inventory space",
                },
            },
            v_reroll_glut_tcg={
                name="Reroll Glut",
                text={
                    "Extra {C:red}discards{}",
                    "cost {C:money}$#1#{}",
                },
            },
            v_reroll_surplus_tcg={
                name="Reroll Surplus",
                text={
                    "Extra {C:red}discards{}",
                    "cost {C:money}$#1#{}",
                },
            },
            v_retcon_tcg={
                name="Retcon",
                text={
                    "Spend {C:money}$#1#{} once per round",
                    "to add {C:attention}#2#{} damage",
                    "to your attack",
                },
            },
            v_seed_money_tcg={
                name="Seed Money",
                text={
                    "Lose {C:money}$#1#{}",
                    "per round?",
                },
            },
            v_telescope_tcg={
                name="Telescope",
                text={
                    "Always draw the {C:planet}Planet{}",
                    "card for your most",
                    "played {C:attention}poker hand",
                },
            },
            v_tarot_merchant_tcg={
                name="Tarot Merchant",
                text={
                    "Start each round",
                    "with {C:attention}#1# {C:tarot}Tarot{}",
                    "in your inventory",
                },
            },
            v_tarot_tycoon_tcg={
                name="Tarot Tycoon",
                text={
                    "{C:tarot}Tarots{} don't take up",
                    "inventory space",
                },
            },
        },
	},
	misc = {
		dictionary = {
			b_tcg_vanilla = "Vanilla",
			b_tcg_tcg = "TCG",
			b_tcg_tcg_lobby = "TCG Lobby",
            
            b_tcg_build = "Build",
            b_tcg_copy = "Copy",
            b_tcg_delete = "Delete",
            
            b_tcg_jokercount = "Joker Count",
            
            b_tcg_add = "Add",
            b_tcg_remove = "Remove",
            b_tcg_apply = "Apply",
            
			b_tcgtab_single = "Single Game",
			b_tcgtab_deck = "Build Deck",
			b_tcgtab_online = "Online Match",
			b_tcgtab_online_start = "Online Match",
			b_tcgtab_online_incompat = "Incompatible Server",
			b_tcgtab_online_no_mp = "No Multiplayer Mod",
			b_tcgtab_select = "Select Deck",
            
			b_tcg_opponent = "Opponent",
			b_tcg_healthopponent = "Health",
			b_tcg_return = "Return",

			b_tcg_attack = "Attack",
			b_tcg_graveyard = "Graveyard",
			b_tcg_buy = "Buy $",
			b_tcg_bet = "Bet",

			k_lobby_deck = "Deck Limitations",

			b_opts_tcg_balanced = "Use Balance Patches",
			b_opts_tcg_health = "Starting Health",

			b_opts_tcg_money_leak = "Enable Overtime Penalty",
			b_opts_tcg_money_leak_desc = "Enable losing money per round after a set round number",
			b_opts_tcg_money_leak_start = "Penalty Start Round",
			b_opts_tcg_money_leak_increase = "Penalty Increase",

			b_opts_tcg_game_round_limit = "Enable Round Limit",
			b_opts_tcg_game_round_limit_desc = "Enable game ending at a set round",
			b_opts_tcg_round_limit = "Round Limit",
			b_opts_tcg_winner_type = "Win condition",

			b_opts_tcg_deck_money_limit = "Deck Cost",
			b_opts_tcg_deck_money_limit_desc = "Limit the deck cost",
			b_opts_tcg_deck_size_limits = "Deck Size",
			b_opts_tcg_deck_size_limits_desc = "Require decks to be a set size",
			b_opts_tcg_deck_back_limits = "Deck Effects",
			b_opts_tcg_deck_back_limits_desc = "Prevent decks having extra effects",
			b_opts_tcg_deck_joker_limits = "Joker Limitations",
			b_opts_tcg_deck_joker_limits_desc = "Limit Joker counts and rarity types",
			b_opts_tcg_deck_consumeable_limits = "Consumeable Limitations",
			b_opts_tcg_deck_consumeable_limits_desc = "Limit Consumeable counts",

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
            tcg_err_deck_count={
                "Back count too high (#1#), max count of #2#",
            },
            tcg_err_cost={
                "Deck too expensive",
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
            tcg_err_vouchers={
                "Too many vouchers (#1#), max count of #2#",
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
