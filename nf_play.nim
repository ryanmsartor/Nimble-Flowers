
import random
import std/sequtils
import nf_types
import nf_cards
import nf_rulesets
import nf_menus

randomize()
# var my_seed: int64 = 1234
# randomize(my_seed)

var
    current_deck: Zone
    field: Zone
    p1 = Player(name:"you", play_style:"human")
    p2 = Player(name:"Al")
    p3 = Player(name:"Bri")
    p4 = Player(name:"Curt")
    p5 = Player(name:"David")
    p6 = Player(name:"Evelyn")
    p7 = Player(name:"Francis")
    p8 = Player(name:"Giovanni")

proc reset_zones*() =
    current_deck = full_deck
    field.setLen(0)

    p1.hand.setLen(0)
    p2.hand.setLen(0)
    p3.hand.setLen(0)
    p4.hand.setLen(0)
    p5.hand.setLen(0)
    p6.hand.setLen(0)
    p7.hand.setLen(0)
    p8.hand.setLen(0)

    p1.captured.setLen(0)
    p2.captured.setLen(0)
    p3.captured.setLen(0)
    p4.captured.setLen(0)
    p5.captured.setLen(0)
    p6.captured.setLen(0)
    p7.captured.setLen(0)
    p8.captured.setLen(0)


proc deal*(game: RuleSet) =
    reset_zones() # ensure fresh start
    # strip deck to e.g. 40 cards for mushi if appropriate
    current_deck = full_deck.filterIt(it notin game.cards_stripped)
    shuffle(current_deck)

    if game.num_cards_field > 0:
        for i in 1 .. game.num_cards_field:
            field.add(current_deck.pop())

    # p1 and p2 will always get cards
    for i in 1 .. game.num_cards_hand:
        p1.hand.add(current_deck.pop())
    for i in 1 .. game.num_cards_hand:
        p2.hand.add(current_deck.pop())
    
    # p3 thru p8 only get cards if dealt in
    if game.num_players >= 3:
        for i in 1 .. game.num_cards_hand:
            p3.hand.add(current_deck.pop())
    if game.num_players >= 4:
        for i in 1 .. game.num_cards_hand:
            p4.hand.add(current_deck.pop())
    if game.num_players >= 5:
        for i in 1 .. game.num_cards_hand:
            p5.hand.add(current_deck.pop())
    if game.num_players >= 6:
        for i in 1 .. game.num_cards_hand:
            p6.hand.add(current_deck.pop())
    if game.num_players >= 7:
        for i in 1 .. game.num_cards_hand:
            p7.hand.add(current_deck.pop())
    if game.num_players >= 8:
        for i in 1 .. game.num_cards_hand:
            p8.hand.add(current_deck.pop())

proc show_zones_debug*() =
    current_table_style = narrowStyle
    insert_div()
    echo "field:"
    for card in field:
        echo card.full_name

    insert_div()
    echo "p1 hand:"
    for card in p1.hand:
        echo card.full_name

    insert_div()
    echo "p2 hand:"
    for card in p2.hand:
        echo card.full_name

    insert_div()
    echo "p3 hand:"
    for card in p3.hand:
        echo card.full_name

    insert_div()
    echo "p4 hand:"
    for card in p4.hand:
        echo card.full_name

    insert_div()
    echo "p5 hand:"
    for card in p5.hand:
        echo card.full_name

    insert_div()
    echo "p6 hand:"
    for card in p6.hand:
        echo card.full_name

    insert_div()
    echo "p7 hand:"
    for card in p7.hand:
        echo card.full_name

    insert_div()
    echo "p8 hand:"
    for card in p8.hand:
        echo card.full_name

    insert_div()