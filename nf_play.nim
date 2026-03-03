
import random
import std/sequtils
import nf_common
import nf_cards

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
    current_players*: seq[Player]


##### START OF ROUND: THE DEAL #####

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


# used for side effects only, no return
proc gather_players(game: RuleSet): seq[Player] =
    result = @[p1, p2]
    if game.num_players >= 3: result.add(p3)
    if game.num_players >= 4: result.add(p4)
    if game.num_players >= 5: result.add(p5)
    if game.num_players >= 6: result.add(p6)
    if game.num_players >= 7: result.add(p7)
    if game.num_players >= 8: result.add(p8)

proc deal*(game: RuleSet) =
    reset_zones() # ensure fresh start
    current_players = gather_players(game)

    # strip deck to e.g. 40 cards for mushi if appropriate
    current_deck = full_deck.filterIt(it notin game.cards_stripped)
    shuffle(current_deck)

    if game.num_cards_field > 0:
        for i in 1 .. game.num_cards_field:
            field.add(current_deck.pop())
    
    for player in current_players:
        for i in 1 .. game.num_cards_hand:
            player.hand.add(current_deck.pop())







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




proc display_zone_table*(zone: Zone) = 
    let
        handsize = zone.len()
        num_doubles = handsize div 2
        oddNumCards = (handsize mod 2 == 1)

    current_table_style = defaultStyle # global
    insert_div()

    for i in 0 .. (num_doubles - 1):
        let
            c1 = zone[(2*i)].short_name
            c2 = zone[(2*i) + 1].short_name
            i1 = $((2*i)+1) & ") "
            i2 = $((2*i)+2) & ") "
        insert_row(i1 & c1, i2 & c2)
    if oddNumCards:
        let
            c1 = zone[^1].short_name
            i1 = $zone.len & ") "
        insert_row(i1 & c1,"")
        
    insert_div()

proc display_zone_ascii_one_row*(zone: Zone, xpos=1, ypos=1) =
    var
        cur_x = xpos
        cur_y = ypos
        offset = 0
    if zone.len() <= 6: offset = 13
    elif zone.len() == 7: offset = 11
    elif zone.len() == 8: offset = 9
    elif zone.len() == 9: offset = 8
    elif zone.len() == 10: offset = 7
    else: offset = 6

    for card in zone:
        card.print_at_pos(cur_x,cur_y)
        cur_x.inc(offset)

proc display_zone_ascii_two_rows*(zone: Zone, xpos=1, ypos=1) =
    var
        cur_x = xpos
        cur_y = ypos
        offset = 0
    if zone.len() <= 6: offset = 14
    elif zone.len() <= 8: offset = 12
    elif zone.len() <= 10: offset = 11
    elif zone.len() <= 12: offset = 9
    elif zone.len() <= 14: offset = 8
    elif zone.len() <= 16: offset = 7
    elif zone.len() <= 18: offset = 6
    else: offset = 5

    for i, card in zone:
        card.print_at_pos(cur_x,cur_y)
        if (i+1) mod 2 == 1:    # odd -> move down
            cur_y.inc(11)
        else:               # even -> move right and back up
            cur_y.dec(11)
            cur_x.inc(offset)
    stdout.flushFile()

proc display_deck*(xpos=63,ypos=10) =
    for i in 0 .. 3:
        card_back.print_at_pos(xpos + i, ypos - i)
    stdout.flushFile()


proc take_turn*(player: Player, game: RuleSet) =
    var 
        selected_index = ""
        selected_card: Card

    case player.play_style:
    of "human":
        let options = generate_string_range(1,player.hand.len)

        while selected_index notin options:
            clear_screen()
            stdout.write("\e[2;1H")
            echo_centered: "-= The field: =-"
            field.display_zone_ascii_two_rows(3,3)
            stdout.write("\e[30;1H")
            echo_centered: "-= Your hand: =-"
            player.hand.display_zone_ascii_one_row(2,31)
            echo ""
            display_deck()
            stdout.write("\e[26;1H")
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