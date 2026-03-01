
import random
import std/sequtils
import nf_common
import nf_cards
import nf_menus

randomize()
# var my_seed: int64 = 1234
# randomize(my_seed)

var
    current_deck*: Zone
    field*: Zone
    p1* = Player(name:"you", play_style:"human")
    p2* = Player(name:"Al")
    p3* = Player(name:"Bri")
    p4* = Player(name:"Curt")
    p5* = Player(name:"David")
    p6* = Player(name:"Evelyn")
    p7* = Player(name:"Francis")
    p8* = Player(name:"Giovanni")

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

proc get_matches*(mycard: Card, zone_to_check: Zone, suit_system="standard", hachi_matching=false): seq[Card] =
    var mysuit, suit: Suit
    for card in zone_to_check:
        if hachi_matching:
            case suit_system:
            of "standard":
                mysuit = mycard.standard_suit
                suit = card.standard_suit
            of "mushi": 
                mysuit = mycard.mushi_suit
                suit = card.mushi_suit
            else:
                mysuit = mycard.nagoya_suit
                suit = card.nagoya_suit
            if (mysuit + suit) mod 5 == 3:
                result.add(card)
        else:
            if mycard.standard_suit == card.standard_suit:
                result.add(card)

proc take_turn*(player: Player, game: RuleSet) =
    var 
        selected_index = ""
        selected_card: Card


    case player.play_style:
    of "human":
        let options = generate_string_range(1,player.hand.len)

        while selected_index notin options:
            echo ""
            echo_centered: "The field:"
            display_zone_table(field)
            echo ""
            echo_centered: "Your hand:"
            display_zone_table(player.hand)
            echo ""

            selected_index = prompt("Enter the number of the card you'd like to play from your hand. > ")
            if selected_index in quit_commands: quit_game()
        

    else:
        discard






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