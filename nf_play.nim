# nf_play.nim
#
# This file contains all the stuff for actual gameplay, i.e. not menus and junk

import std/os
import std/random
import std/sequtils
import std/strutils
import std/tables
import nf_common
import nf_cards

randomize()
# var my_seed: int64 = 1234
# randomize(my_seed)

var
    current_deck*: Zone
    field*: Zone
    p1* = Player(name:"You", play_style: human)
    p2* = Player(name:"Al", play_style: always_choose_first)
    p3* = Player(name:"Bri", play_style: always_choose_first)
    p4* = Player(name:"Curt", play_style: always_choose_first)
    p5* = Player(name:"David", play_style: always_choose_first)
    p6* = Player(name:"Evelyn", play_style: always_choose_first)
    p7* = Player(name:"Francis", play_style: always_choose_first)
    p8* = Player(name:"Giovanni", play_style: always_choose_first)
    current_players*: seq[Player]
    dealer_index: int



##### DISPLAY STUFF: THE UI #####

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
    move_cursor_to_pos(xpos + 8, ypos + 2)
    stdout.write($current_deck.len())
    stdout.flushFile()


proc display_gamestate*(player = p1) =
    clear_screen()
    move_cursor_to_pos(1,2)
    echo_centered: "-= The field: =-"
    field.display_zone_ascii_two_rows(3,3)
    move_cursor_to_pos(1,30)
    echo_centered: "-= Your hand: =-"
    player.hand.display_zone_ascii_one_row(2,31)
    echo ""
    display_deck()


# you usually wanna use this immediately following display_gamestate()
proc in_game_message*(str="") =
    move_cursor_to_pos(1,26)
    case global_settings["game speed"]:
    of "fastest": echo str; sleep(500)
    of "faster": echo str; sleep(1000)
    of "fast": echo str; sleep(1500)
    of "medium": echo str; sleep(2000)
    of "slow": echo str; sleep(3000)
    of "slower": echo str; sleep(4000)
    of "slowest": echo str; sleep(5000)
    else: discard prompt(str & " <enter>")



##### START OF GAME: SET UP AND CHOOSE A DEALER #####

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


proc gather_players(game: RuleSet): seq[Player] =
    result = @[p1, p2]
    if game.num_players >= 3: result.add(p3)
    if game.num_players >= 4: result.add(p4)
    if game.num_players >= 5: result.add(p5)
    if game.num_players >= 6: result.add(p6)
    if game.num_players >= 7: result.add(p7)
    if game.num_players >= 8: result.add(p8)


proc choose_first_dealer(game: RuleSet): int =
    let count = game.num_players
    result = rand(count - 1)


proc set_up_game*(game: RuleSet) =
    reset_zones() # ensure fresh start
    current_players = gather_players(game)
    dealer_index = choose_first_dealer(game)
    let dealer = current_players[dealer_index]
    display_gamestate()
    in_game_message(dealer.name & " has been randomly chosen to be the first dealer.")



##### START OF ROUND: THE DEAL #####

proc deal*(game: RuleSet) =

    # get dealer, and move the cycle forward for the next deal.
    let dealer = current_players[dealer_index]
    dealer_index.inc(1)
    if dealer_index >= current_players.len(): dealer_index = 0

    reset_zones() # make sure we get a clean start

    # strip deck to e.g. 40 cards for mushi if appropriate
    current_deck = full_deck.filterIt(it notin game.cards_stripped)
    shuffle(current_deck)

    display_gamestate()
    in_game_message(dealer.name & " has prepared and shuffled the deck.")

    if game.num_cards_field > 0:
        for i in 1 .. game.num_cards_field:
            field.add(current_deck.pop())
    
    display_gamestate()
    in_game_message(dealer.name & " has distributed " & $game.num_cards_field & " cards to the field.")

    for player in current_players:
        for i in 1 .. game.num_cards_hand:
            player.hand.add(current_deck.pop())

    display_gamestate()
    in_game_message("Each player gets " & $game.num_cards_hand & " cards to make up their hand.")



##### GAMEPLAY STUFF: A TURN #####

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


proc capture_cards(player: Player, cards: seq[Card]) =
    for c in cards:
        player.captured.add(c)
        field.keepItIf(it != c)
        player.hand.keepItIf(it != c)


proc discard_to_field(player: Player, card: Card) =
    player.hand.keepItIf(it != card)
    current_deck.keepItIf(it != card)
    field.add(card)


proc pick_to_capture_between(player: Player; c1, c2: Card): Card =
    var selection: string

    # Player.play_style determines HOW field card is chosen
    case player.play_style:
    of human:
        let options = @["1","2"]
        while selection notin options:
            display_gamestate(player)
            move_cursor_to_pos(1,26)
            selection = prompt("Select which card to capture [1 or 2] > ")
            if selection in quit_commands: quit_game()

    of always_choose_first:
        selection = "1"

    # translate the returned "1" or "2" to an actual card to return
    if selection == "1": result = c1
    else: result = c2

    # tell the player what the pick was.
    display_gamestate()
    in_game_message(player.name & " picked " & result.full_name & ".")

    return result


proc handle_matches(player: Player, card:Card, game:RuleSet) =
    var matches_on_field = card.get_matches(field,game.suit_system,game.hachi_matching)
    case matches_on_field.len():
    of 0:
        player.discard_to_field(card)
        display_gamestate()
        in_game_message("No matches, so it sticks to the field.")

    of 2:
        let picked_card = player.pick_to_capture_between(matches_on_field[0], matches_on_field[1])
        player.capture_cards(@[card, picked_card])
        display_gamestate()
        in_game_message(player.name & " captured " & matches_on_field[0].short_name & " & " & matches_on_field[1].short_name & ".")

    else:       # 1, 3, or maaaybe even 4
        player.capture_cards(@[card] & matches_on_field)
        if matches_on_field.len == 1:
            display_gamestate()
            in_game_message(player.name & " captured " & card.short_name & " & " & matches_on_field[0].short_name & ".")
        elif matches_on_field.len == 3:
            display_gamestate()
            in_game_message(player.name & " captured the whole suit!")
            ## TODO: carve out len == 3 for wild card
            ## TODO: len > 3 (follow similar logic to 3 for wild card)


proc take_turn*(player: Player, game: RuleSet) =
    var 
        selected_index = ""
        selected_card: Card
        deck_card: Card

    # first, select a card from one's hand to play.
    case player.play_style:
    of human:
        let options = generate_string_range(1,player.hand.len)
        while selected_index notin options:
            display_gamestate(player)
            move_cursor_to_pos(1,26)
            selected_index = prompt("Play a card from your hand. > ")
            if selected_index in quit_commands: quit_game()

    of always_choose_first:
        selected_index = "1"

    # second, narrate what card that was
    selected_card = player.hand[parseInt(selected_index) - 1]
    display_gamestate()
    in_game_message(player.name & " played " & selected_card.full_name & ".")
    
    # third, count the number of matches and take the appropriate action.
    handle_matches(player, selected_card, game)

    # Next, flip a card from the deck!    
    deck_card = current_deck.pop()
    display_gamestate()
    deck_card.print_at_pos(66,7)
    stdout.flushFile()
    in_game_message(player.name & " revealed " & deck_card.short_name & ".")

    # and take the appropriate action based on number of matches of that one!
    handle_matches(player, deck_card, game)