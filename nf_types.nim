# to be imported by most (all?) other .nim files

import std/tables

type
    Suit* = range[0..15]
    Decksize* = range[24..64]
    NumPlayers* = range[0..8]
    NumHands* = range[0..24]
    NumField* = range[0..48]
    CardPointValue* = range[0..50]
    
    Card* = object
        full_name*: string
        short_name*: string # 25 char at absolute max
        alt_names*: seq[string]
        standard_suit*: Suit
        mushi_suit*: Suit
        nagoya_suit*: Suit
        hachihachi_value*: CardPointValue
        hachi_value*: CardPointValue
        ropyakken_value*: CardPointValue
        art0*: string
        art1*: string
        art2*: string
        art3*: string
        art4*: string
        art5*: string
        art6*: string
        art7*: string
        art8*: string
        art9*: string

    Zone* = seq[Card]

    Player* = object
        name*: string
        hand*: Zone
        captured*: Zone
        current_teyaku_score*: int
        current_dekiyaku_score*: int
        current_card_score*: int
        overall_score*: int
        rounds_won*: uint8
        play_style*: string # difficulty level

    Dekiyaku* = object
        name*: string
        exclusivity_group*: string
        cards_group_1*: seq[Card]
        cards_group_2*: seq[Card]
        num_group_1*: uint8
        num_group_2*: uint8

    SetTeyaku* = object
        name*: string
        singles*: uint8
        doubles*: uint8
        triples*: uint8
        special_triples*: uint8
        quads*: uint8
        score*: uint8

    ChaffTeyaku* = object
        name*: string
        chaff*: uint8
        ribbons*: uint8
        animals*: uint8
        brights*: uint8
        score*: uint8

    RuleSet* = object
        name*: string
        num_players*: NumPlayers
        num_cards_hand*: NumHands
        num_cards_field*: NumField
        wild_card*: Card
        wild_card_rules*: string
        yaku_set*: OrderedTable[Dekiyaku,int]
        set_teyaku_list*: seq[SetTeyaku]
        chaff_teyaku_list*: seq[ChaffTeyaku]
        can_koikoi*: bool
        hachi_matching*: bool
        zero_sum*: bool
        target_score*: int
        cards_stripped*: seq[Card]
        cards_added*: seq[Card]
        point_values*: string

    TableStyle* = object
        divider*: string
        border*: string
        padding*: char
        line_char*: string
        left_corner*: string
        right_corner*: string
        intersection*: string
        width*: int


##### ANSI ESCAPE SEQUENCES #####

# these are used in conjunction with stdout.write() and echo()
# to control how the terminal displays stuff.

const
    text_bold* = "\e[1m"
    text_reset* = "\e[0m"

    fg_reset* = "\e[39m"
    bg_reset* = "\e[49m"
    fg_faded* = "\e[38;2;5;5;5m"
    bg_faded* = "\e[48;2;5;5;5m"

    fg_pine       * = "\e[38;2;0;153;77m"
    fg_plum       * = "\e[38;2;255;30;103m"
    fg_cherry     * = "\e[38;2;255;180;182m"
    fg_wisteria   * = "\e[38;2;138;57;145m"
    fg_iris       * = "\e[38;2;60;4;223m"
    fg_peony      * = "\e[38;2;238;130;220m"
    fg_clover     * = "\e[38;2;183;15;86m"
    fg_grass      * = "\e[38;2;196;227;199m"
    fg_mum        * = "\e[38;2;245;184;22m"
    fg_maple      * = "\e[38;2;211;26;5m"
    fg_willow     * = "\e[38;2;101;196;6m"
    fg_paulownia  * = "\e[38;2;186;163;222m"

    bg_pine       * = "\e[48;2;0;153;77m"
    bg_plum       * = "\e[48;2;255;30;103m"
    bg_cherry     * = "\e[48;2;255;180;182m"
    bg_wisteria   * = "\e[48;2;138;57;145m"
    bg_iris       * = "\e[48;2;60;4;223m"
    bg_peony      * = "\e[48;2;238;130;220m"
    bg_clover     * = "\e[48;2;183;15;86m"
    bg_grass      * = "\e[48;2;196;227;199m"
    bg_mum        * = "\e[48;2;245;184;22m"
    bg_maple      * = "\e[48;2;211;26;5m"
    bg_willow     * = "\e[48;2;101;196;6m"
    bg_paulownia  * = "\e[38;2;186;163;222m"

    reset_screen* = "\e[2J\e[H"

    enter_alt_screen* = "\e[?1049h"
    exit_alt_screen* = "\e[?1049l"

    hide_cursor* = "\e[?25l"
    show_cursor* = "\e[?25h"