
import random
import std/sequtils
import nf_types
import nf_cards
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


proc display_zone_table*(zone = field) = 
    let
        handsize = zone.len()
        num_doubles = handsize div 2
        oddNumCards = (handsize mod 2 == 1)

    current_table_style = defaultStyle # global
    insert_div()

    for i in 0 .. (num_doubles - 1):
        insert_row(zone[(2*i)].short_name, zone[(2*i) + 1].short_name)
    if oddNumCards:
        insert_row(zone[^1].short_name,"")
        
    insert_div()

proc show_zones_debug*() =
    echo_centered r"  ______  "
    echo_centered r"/`field:`\"
    display_zone_table(field)
    echo ""
    echo_centered r"  ________ "
    echo_centered r"/`p1 hand:`\"
    display_zone_table(p1.hand)
    echo ""
    echo_centered r"  ________ "
    echo_centered r"/`p2 hand:`\"
    display_zone_table(p2.hand)
    echo ""
    echo_centered r"  ________ "
    echo_centered r"/`p3 hand:`\"
    display_zone_table(p3.hand)
    echo ""
    echo_centered r"  ________ "
    echo_centered r"/`p4 hand:`\"
    display_zone_table(p4.hand)
    echo ""
    echo_centered r"  ________ "
    echo_centered r"/`p5 hand:`\"
    display_zone_table(p5.hand)
    echo ""
    echo_centered r"  ________ "
    echo_centered r"/`p6 hand:`\"
    display_zone_table(p6.hand)
    echo ""
    echo_centered r"  ________ "
    echo_centered r"/`p7 hand:`\"
    display_zone_table(p7.hand)
    echo ""
    echo_centered r"  ________ "
    echo_centered r"/`p8 hand:`\"
    display_zone_table(p8.hand)