# to be imported by most (all?) other .nim files

type
    Suit* = range[0..14]
    Decksize* = range[24..64]
    NumPlayers* = range[1..12]
    CardPointValue* = range[0..50]

    Card* = object
        full_name*: string
        alt_names*: seq[string]
        standard_suit*: Suit
        mushi_suit*: Suit
        nagoya_suit*: Suit
        hachihachi_value*: CardPointValue
        hachi_value*: CardPointValue

    Zone* = object
        name*: string
        cards*: seq[Card]

    Yaku* = object
        name*: string
        subtype*: string
        cards*: seq[Card]
        score*: uint8

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

    Ruleset* = object
        name*: string
        num_players*: NumPlayers
        num_cards_hand*: uint8
        num_cards_field*: uint8
        wild_cards*: seq[Card]
        wild_card_rules*: string
        yaku_set*: seq[Yaku]
        set_teyaku_list*: seq[SetTeyaku]
        chaff_teyaku_list*: seq[ChaffTeyaku]
        can_koikoi*: bool
        zero_sum*: bool
        cards_stripped*: seq[Card]
        cards_added*: seq[Card]
        point_values*: string
