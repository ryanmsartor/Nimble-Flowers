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