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
    player_index: int



##### SCOREKEEPING STUFF #####

proc get_card_value(card:Card): int =
    case game_mode.point_values:

    of "1, 5, 10, 20":
        return card.hachihachi_value
    of "0, 5, 10, 20":
        if card.hachihachi_value == 1: return 0
        else: return card.hachihachi_value
    of "0, 10, 5, 20":
        return card.sakura_value
    of "0, 10, 10, 50":
        return card.ropyakken_value
    of "10, 1, 10, 10":
        return card.hachi_value
    of "10, 1, 5, 5":
        return card.sudaoshi_value
    else:
        return card.hachihachi_value # future-proof/fallback


proc add_up_card_points(zone: Zone): int =
    for card in zone:
        result.inc(card.get_card_value())
    return result

proc print_all_players_scores() =
    let x = 63; let y = 21

    for i, player in current_players:
        player.current_card_score = add_up_card_points(player.captured)
        move_cursor_to_pos(x, y+i)
        stdout.write(player.name & ": " & $player.current_card_score)
    stdout.flushFile()

##### DISPLAY STUFF: THE UI #####

proc get_one_row_coords*(zoneLen: int, index: int,
                         xpos = 2, ypos = 31): (int, int) =
    var offset: int

    if zoneLen <= 6: offset = 13
    elif zoneLen == 7: offset = 11
    elif zoneLen == 8: offset = 9
    elif zoneLen == 9: offset = 8
    elif zoneLen == 10: offset = 7
    else: offset = 6

    let x = xpos + index * offset
    let y = ypos
    (x, y)

proc display_zone_ascii_one_row*(zone: Zone, xpos=2, ypos=31) =
    for i, card in zone:
        let (x,y) = get_one_row_coords(zone.len,i,xpos,ypos)
        card.print_at_pos(x,y)


proc get_two_row_coords*(zoneLen: int, index: int,
                         xpos = 3, ypos = 3): (int, int) =
    var offset: int

    if zoneLen <= 6: offset = 14
    elif zoneLen <= 8: offset = 12
    elif zoneLen <= 10: offset = 11
    elif zoneLen <= 12: offset = 9
    elif zoneLen <= 14: offset = 8
    elif zoneLen <= 16: offset = 7
    elif zoneLen <= 18: offset = 6
    else: offset = 5

    let column = index div 2
    let isTop = (index mod 2 == 0)

    let x = xpos + column * offset
    let y = if isTop: ypos else: ypos + 11

    (x, y)

proc display_zone_ascii_two_rows*(zone: Zone, xpos=3, ypos=3) =
    for i, card in zone:
        let (x,y) = get_two_row_coords(zone.len,i,xpos,ypos)
        card.print_at_pos(x,y)


proc get_deck_height(): int =
    case current_deck.len():
    of 0:     return -1
    of 1..4:  return  0
    of 5..8:  return  1
    of 9..12: return  2
    else:     return  3

proc display_deck*(xpos=63,ypos=10) =
    let i_max = get_deck_height()
    if i_max == (-1): return
    for i in 0 .. i_max:
        card_back.print_at_pos(xpos + i, ypos - i)
    move_cursor_to_pos(xpos + i_max + 5, ypos - i_max + 5)
    stdout.write($current_deck.len())
    stdout.flushFile()


proc display_gamestate*() =
    clear_screen()
    move_cursor_to_pos(1,2)
    echo_centered: "-= The field: =-"
    field.display_zone_ascii_two_rows(3,3)
    move_cursor_to_pos(1,30)
    echo_centered: "-= Your hand: =-"
    p1.hand.display_zone_ascii_one_row(2,31)
    echo ""
    display_deck()
    print_all_players_scores()

# you usually wanna use this immediately following display_gamestate()
proc in_game_message*(str="") =
    move_cursor_to_pos(1,26)
    case global_settings["game speed"]:
    of "fastest": echo str; sleep(250)
    of "faster":  echo str; sleep(500)
    of "fast":    echo str; sleep(1000)
    of "medium":  echo str; sleep(1500)
    of "slow":    echo str; sleep(2500)
    of "slower":  echo str; sleep(4000)
    else:         discard prompt(str & " <enter>")  # on slowest setting, wait for user to press enter

proc get_deal_speed(): int =
    case global_settings["game speed"]:
    of "slowest": return 500
    of "slower":  return 400
    of "slow":    return 300
    of "medium":  return 200
    of "fast":    return 150
    of "faster":  return 75
    else:         return 0          # on fastest setting, no sleep at all

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


proc gather_players(): seq[Player] =
    result = @[p1, p2]
    if game_mode.num_players >= 3: result.add(p3)
    if game_mode.num_players >= 4: result.add(p4)
    if game_mode.num_players >= 5: result.add(p5)
    if game_mode.num_players >= 6: result.add(p6)
    if game_mode.num_players >= 7: result.add(p7)
    if game_mode.num_players >= 8: result.add(p8)


proc choose_first_dealer(): int =
    let count = game_mode.num_players
    result = rand(count - 1)


proc set_up_game*() =
    reset_zones() # ensure fresh start
    current_players = gather_players()
    dealer_index = choose_first_dealer()
    let dealer = current_players[dealer_index]
    display_gamestate()
    in_game_message(dealer.name & " has been randomly chosen to be the first dealer.")



##### START OF ROUND: THE DEAL #####

proc deal*() =
    let dealer = current_players[dealer_index]
    let delay = get_deal_speed()
    reset_zones() # make sure we get a clean start

    # strip deck to e.g. 40 cards for mushi if appropriate
    current_deck = full_deck.filterIt(it notin game_mode.cards_stripped)
    shuffle(current_deck)

    display_gamestate()
    in_game_message(dealer.name & " has prepared and shuffled the deck.")

    if game_mode.num_cards_field > 0:
        for i in 1 .. game_mode.num_cards_field:
            field.add(current_deck.pop())
            display_gamestate()
            sleep(delay)
    
    display_gamestate()
    in_game_message(dealer.name & " has distributed " & $game_mode.num_cards_field & " cards to the field.")


    for i in 1 .. game_mode.num_cards_hand:
        for player in current_players:
            player.hand.add(current_deck.pop())
            display_gamestate()
            sleep(delay)

    display_gamestate()
    in_game_message("Each player received a " & $game_mode.num_cards_hand & "-card hand.")



##### GAMEPLAY STUFF: A TURN #####

proc get_matches*(mycard: Card, zone_to_check: Zone): seq[Card] =
    var mysuit, suit: Suit
    for card in zone_to_check:
        if game_mode.hachi_matching:
            case game_mode.suit_system:
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
            display_gamestate()
            move_cursor_to_pos(1,26)
            selection = prompt(text_bold & "Select which card to capture [1 or 2] > ")
            if selection in quit_commands: quit_game()

    of always_choose_first:
        display_gamestate()
        selection = "1"

    # translate the returned "1" or "2" to an actual card to return
    if selection == "1": result = c1
    else: result = c2

    # tell the player what the pick was.
    display_gamestate()
    in_game_message(player.name & " picked " & result.full_name & ".")

    return result


proc handle_matches(player: Player, card:Card, hand_or_deck="hand") =

    var matches_on_field = card.get_matches(field)
    case matches_on_field.len():
    of 0:
        player.discard_to_field(card)
        
        if hand_or_deck == "hand":
            display_gamestate()
            in_game_message(player.name & " played " & card.full_name & ".")

        display_gamestate()
        in_game_message("No matches, so it sticks to the field.")

    of 2:
        let picked_card = player.pick_to_capture_between(matches_on_field[0], matches_on_field[1])
        player.capture_cards(@[card, picked_card])
        display_gamestate()
        in_game_message(player.name & " captured " & matches_on_field[0].short_name & " & " & matches_on_field[1].short_name & ".")

    else:       # 1, 3, or maaaybe even 4
        let index_on_field = field.find(matches_on_field[0])
        let (x,y) = get_two_row_coords(field.len, index_on_field)

        if hand_or_deck == "hand": 
            display_gamestate()
            card.print_at_pos(x+2,y+1)
            in_game_message(player.name & " played " & card.full_name & ".")
            player.capture_cards(@[card] & matches_on_field)

        if matches_on_field.len == 1:
            display_gamestate()
            if hand_or_deck == "deck": card.print_at_pos(x+2,y+1)
            in_game_message(player.name & " captured " & card.short_name & " & " & matches_on_field[0].short_name & ".")

        elif matches_on_field.len == 3:
            display_gamestate()
            in_game_message(player.name & " captured the whole suit!")

        if hand_or_deck == "deck": player.capture_cards(@[card] & matches_on_field) # do this later to smooth the animations

        ## TODO: carve out len == 3 for wild card
        ## TODO: len > 3 (follow similar logic to 3 for wild card)


proc take_turn*(player: Player) =
    var 
        selected_index = ""
        selected_card: Card
        deck_card: Card

    # first, select a card from one's hand to play.
    case player.play_style:
    of human:
        let options = generate_string_range(1,player.hand.len)
        while selected_index notin options:
            display_gamestate()
            move_cursor_to_pos(1,26)
            selected_index = prompt(text_bold & "Play a card from your hand. > " & text_reset)
            if selected_index in quit_commands: quit_game()

    of always_choose_first:
        display_gamestate()
        in_game_message("It's " & player.name & "'s turn.")
        selected_index = "1"

    # second, translate the index to a card
    selected_card = player.hand[parseInt(selected_index) - 1]

    # third, count the number of matches and take the appropriate action.
    handle_matches(player, selected_card, "hand")

    # Next, flip a card from the deck!
    let h = get_deck_height()    # do this before the pop to ensure flipped card is at right coords
    deck_card = current_deck.pop()
    display_gamestate()
    deck_card.print_at_pos(63 + h, 10 - h)
    in_game_message(player.name & " revealed " & deck_card.short_name & ".")

    # and take the appropriate action based on number of matches of that one!
    handle_matches(player, deck_card, "deck")



##### PLAY A FULL ROUND #####

proc rotate_player() =
    player_index.inc(1)
    if player_index >= current_players.len(): player_index = 0

proc rotate_dealer() =
    dealer_index.inc(1)
    if dealer_index >= current_players.len(): dealer_index = 0


proc play_round(first_to_play: int) =
    player_index = first_to_play   # initialize turn tracker

    deal()

    var num_playable_cards_remaining = 1 # ensure there's always at least one turn
    while num_playable_cards_remaining > 0:

        let current_player = current_players[player_index]
        current_player.take_turn()

        num_playable_cards_remaining = 0
        for p in current_players:
            num_playable_cards_remaining.inc(p.hand.len)

        rotate_player()



proc play_full_match*() =

    set_up_game()

    # TODO: outer loop for multiple rounds

    play_round(dealer_index)
    rotate_dealer()
