# nf_play.nim
#
# This file contains all the stuff for actual gameplay, i.e. not menus and junk

import std/os
import std/parsecfg
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
    current_players*: seq[Player]
    dealer_index: int
    player_index: int

nf_cfg.writeConfig(nf_cfg_path) # save the regen'd player names and styles

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

proc add_up_dekiyaku_points(zone: Zone): int =
    for yaku, value in game_mode.yaku_set:
        var count_1, count_2 = 0
        for card in zone:
            if card in yaku.cards_group_1:
                count_1.inc(1)
            if card in yaku.cards_group_2:
                count_2.inc(1)
        if count_1 >= yaku.num_group_1 and count_2 >= yaku.num_group_2:
            result.inc(value)
    return result

proc count_each_card_type(zone:Zone): (int,int,int,int) =
    var c,r,a,b = 0
    for card in zone:
        if card.hachihachi_value == 1:
            c.inc(1)
        elif card.hachihachi_value == 5:
            r.inc(1)
        elif card.hachihachi_value == 10:
            a.inc(1)
        elif card.hachihachi_value == 20:
            b.inc(1)
    return (c,r,a,b)

proc count_suit_in_zone(zone: Zone, suit: int): int =
    for c in zone:
        if c.standard_suit == suit:
            result.inc(1)

proc normalize_to_4_chars(str:string): string =
    case str.visibleLen:
    of 0: return "    "
    of 1: return "  " & str & " "
    of 2: return " " & str & " "
    of 3: return " " & str
    else: return str


proc print_all_players_scores() =
    let x = 63; let y = 21
    var spacing = 2
    if current_players.len == 2: spacing = 4
    elif current_players.len == 3: spacing = 3

    for i, player in current_players:
        player.round_score = add_up_card_points(player.captured) + add_up_dekiyaku_points(player.captured)

        move_cursor_to_pos(x, y+(spacing*i))
        stdout.write(text_bold & player.name)

        move_cursor_to_pos(x+6, y+(spacing*i))
        stdout.write(": " & $player.round_score)

        move_cursor_to_pos(x+12, y+(spacing*i))
        stdout.write("(" & $(player.match_score + player.round_score) & ")")

        let (c,r,a,b) = count_each_card_type(player.captured)
        let c_str = bg_grass & ($c).normalize_to_4_chars()
        let r_str = bg_plum & ($r).normalize_to_4_chars()
        let a_str = bg_clover & ($a).normalize_to_4_chars()
        let b_str = bg_mum & ($b).normalize_to_4_chars()
        move_cursor_to_pos(x,y+1+(spacing*i))
        stdout.write(text_bold & b_str & a_str & r_str & c_str & text_reset)

    stdout.flushFile()

proc add_round_scores_to_match_scores() =
    for player in current_players:
        player.round_score = add_up_card_points(player.captured) + add_up_dekiyaku_points(player.captured)
        player.match_score.inc(player.round_score)

proc get_full_match_high_scoring_player(): Player =
    result = p1 # initialization here is a hack to avoid nil access attempt
    for player in current_players:
        if player.match_score > result.match_score:
            result = player
    return result

proc get_current_round_high_scoring_player(): Player =
    result = p1 # initialization here is a hack to avoid nil access attempt
    for player in current_players:
        if player.round_score > result.round_score:
            result = player
    return result



##### DISPLAY STUFF: THE UI #####

proc get_one_row_coords(zoneLen: int, index: int,
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

proc display_zone_ascii_one_row(zone: Zone, xpos=2, ypos=31) =
    for i, card in zone:
        let (x,y) = get_one_row_coords(zone.len,i,xpos,ypos)
        card.print_at_pos(x,y)


proc get_two_row_coords(zoneLen: int, index: int,
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

proc display_zone_ascii_two_rows(zone: Zone, xpos=3, ypos=3) =
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
    display_deck()
    print_all_players_scores()

# you usually wanna use this immediately following display_gamestate()
proc in_game_message(str="", beats=1) =
    move_cursor_to_pos(1,26)
    case game_speed:
    of fastest: echo str; sleep(250 * beats)
    of faster:  echo str; sleep(500 * beats)
    of fast:    echo str; sleep(750 * beats)
    of medium:  echo str; sleep(1000 * beats)
    of slow:    echo str; sleep(1500 * beats)
    of slower:  echo str; sleep(3000 * beats)
    else:       discard prompt(str & " <enter>")  # on slowest setting, wait for user to press enter

proc get_deal_speed(): int =
    case game_speed:
    of slowest: return 500
    of slower:  return 400
    of slow:    return 300
    of medium:  return 200
    of fast:    return 100
    of faster:  return 50
    else:       return 0          # on fastest setting, no sleep at all



##### DISPLAY CAPTURED CARDS AND YAKU MID-GAME #####

proc show_captured_cards(player: Player) =
    var c,r,a,b: Zone
    var x = 5
    var y = 4
    for card in player.captured:
        if card.hachihachi_value == 1:
            c.add(card)
        elif card.hachihachi_value == 5:
            r.add(card)
        elif card.hachihachi_value == 10:
            a.add(card)
        elif card.hachihachi_value == 20:
            b.add(card)

    clear_screen()
    move_cursor_to_pos(1,2)
    echo_centered(player.name & ": Captured Cards and Yaku")
    for zone in [b,a,r,c]:
        if zone.len() >= 1:
            zone.display_zone_ascii_one_row(x,y)
            x.dec(1)
            y.inc(7)

    move_cursor_to_pos(1,39)
    echo_centered("<ENTER>")
    discard prompt("")




##### START OF GAME: SET UP AND CHOOSE A DEALER #####

proc reset_zones() =
    current_deck = full_deck
    field.setLen(0)
    p1.hand.setLen(0)
    p2.hand.setLen(0)
    p3.hand.setLen(0)
    p4.hand.setLen(0)
    p5.hand.setLen(0)
    p6.hand.setLen(0)
    p1.captured.setLen(0)
    p2.captured.setLen(0)
    p3.captured.setLen(0)
    p4.captured.setLen(0)
    p5.captured.setLen(0)
    p6.captured.setLen(0)


proc gather_players(): seq[Player] =
    result = @[p1, p2]
    if game_mode.num_players >= 3: result.add(p3)
    if game_mode.num_players >= 4: result.add(p4)
    if game_mode.num_players >= 5: result.add(p5)
    if game_mode.num_players >= 6: result.add(p6)


proc choose_first_dealer(): int =
    let count = game_mode.num_players
    result = rand(count - 1)

proc reset_scores() =
    for player in [p1,p2,p3,p4,p5,p6]:
        player.teyaku_score = 0
        player.current_dekiyaku = @[]
        player.previous_dekiyaku = @[]
        player.match_score  = 0
        player.round_score  = 0
        player.rounds_won   = 0


proc set_up_game() =
    reset_zones()
    reset_scores()
    current_players = gather_players()
    dealer_index = choose_first_dealer()
    let dealer = current_players[dealer_index]
    display_gamestate()
    in_game_message(dealer.name & " has been randomly chosen to be the first dealer.")



##### START OF ROUND: THE DEAL #####

proc deal() =
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
    in_game_message(dealer.name & " distributed " & $game_mode.num_cards_field & " cards to the field.")

    for i in 1 .. game_mode.num_cards_hand:
        for player in current_players:
            player.hand.add(current_deck.pop())
            display_gamestate()
            sleep(delay)

    display_gamestate()
    in_game_message("Each player received a " & $game_mode.num_cards_hand & "-card hand.")

proc check_for_misdeal(): bool =

    # if using hachi-style matching, there's no misdeals
    if game_mode.hachi_matching: return false

    # check for 3 non-wild of wild card's suit
    if game_mode.wild_card_rules == "Osaka style":
        let count = field.count_suit_in_zone(game_mode.wild_card.standard_suit)
        if count == 3 and game_mode.wild_card notin field:
            return true

    # check for 4 of a kind of any and all suits
    for suit in 0..15:
        let count = field.count_suit_in_zone(suit)
        if count == 4:
            return true

    return false # if none of the above encountered, it's not a misdeal.

proc deal_until_not_misdeal() =
    var needs_new_deal = true
    while needs_new_deal:
        deal()
        needs_new_deal = check_for_misdeal()
        if needs_new_deal:
            display_gamestate()
            in_game_message("A full suit was dealt to the field, so a re-deal is declared.")


##### NAMING CARDS TO PLAY OR CAPTURE #####

proc get_alt_names_for_zone(zone:Zone): seq[string] =
    for card in zone:
        result = result & card.alt_names
    return result

proc get_card_from_alt_name(name:string, zone:Zone): Card =
    for card in zone:
        if name in card.alt_names:
            result = card
            break
    return result

##### GAMEPLAY STUFF: A TURN #####

proc get_matches(mycard: Card, zone_to_check: Zone, mycard_is_from_deck = false): Zone =

    for card in zone_to_check:
        
        # for mushi, force the first applicable deck card
        if card == game_mode.wild_card and mycard_is_from_deck == true:
            if game_mode.wild_card_rules == "Osaka style":
                if card.standard_suit != mycard.standard_suit:
                    result = @[card]
                    return result

        if mycard == game_mode.wild_card:
            if game_mode.wild_card_rules == "Osaka style":
                result = zone_to_check
                result.keepItIf(it.standard_suit != mycard.standard_suit)
            elif game_mode.wild_card_rules == "Six Hundred Style":
                result = zone_to_check
                result.keepItIf(it.ropyakken_value > 0)

        elif game_mode.hachi_matching:
            var mysuit, suit: int
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

        else: # non-hachi, non-wild
            if mycard.standard_suit == card.standard_suit:
                if card != game_mode.wild_card or game_mode.wild_card_rules != "Osaka style":
                    result.add(card)
    return result

proc capture_cards(player: Player, cards: seq[Card]) =
    for c in cards:
        player.captured.add(c)
        field.keepItIf(it != c)
        player.hand.keepItIf(it != c)


proc discard_to_field(player: Player, card: Card) =
    player.hand.keepItIf(it != card)
    current_deck.keepItIf(it != card)
    field.add(card)


proc pick_to_capture_among(player: Player, played_card: Card, choices: var Zone): Card =
    var selection: string

    # Player.play_style determines HOW field card is chosen
    case player.play_style:
    of human:
        let options = generate_string_range(1,choices.len) & get_alt_names_for_zone(choices)
        while selection notin options:
            display_gamestate()
            move_cursor_to_pos(1,26)
            echo(player.name & " played " & played_card.short_name & ".")
            selection = prompt(text_bold & "Pick which card to capture. > " & text_reset)
            if selection in quit_commands: quit_game()
    else:
        case player.play_style:

        of choose_first:
            selection = "1"

        of choose_high:
            choices.sort_cards_by(sort_value)
            selection = "1"
        
        else: selection = "1"



    # translate the "1" or "2" or whatever to an actual card to return
    if selection in generate_string_range(1,choices.len):
        result = choices[parseInt(selection) - 1]
    else: # they successfully entered a valid alt_name
        result = get_card_from_alt_name(selection, choices)

    # show and tell the player what the pick was.
    let index_on_field = field.find(result)
    let (x,y) = get_two_row_coords(field.len, index_on_field) # this is where we smack down our played card
    display_gamestate()
    played_card.print_at_pos(x+2,y+1)
    in_game_message(player.name & " picked " & result.full_name & ".")

    return result


proc handle_matches(player: Player, card:Card, card_is_from_deck=false) =

    var matches_on_field = card.get_matches(field, card_is_from_deck)
    case matches_on_field.len():
    of 0:
        player.discard_to_field(card)

        if not card_is_from_deck:
            display_gamestate()
            in_game_message(player.name & " played " & card.full_name & ".")

        display_gamestate()
        in_game_message("No matches, so it sticks to the field.")

    of 1:
        let index_on_field = field.find(matches_on_field[0])
        let (x,y) = get_two_row_coords(field.len, index_on_field) # this is where we smack down our played card

        if not card_is_from_deck:
            display_gamestate()
            card.print_at_pos(x+2,y+1)
            in_game_message(player.name & " played " & card.full_name & ".")
            player.capture_cards(@[card] & matches_on_field)

        display_gamestate()
        if card_is_from_deck: card.print_at_pos(x+2,y+1)
        in_game_message(player.name & " captured " & card.short_name & " & " & matches_on_field[0].short_name & ".")
        if card_is_from_deck: player.capture_cards(@[card] & matches_on_field) # do this later to smooth the animations

    of 2:
        let picked_card = player.pick_to_capture_among(card, matches_on_field)
        player.capture_cards(@[card, picked_card])
        display_gamestate()
        in_game_message(player.name & " captured " & matches_on_field[0].short_name & " & " & matches_on_field[1].short_name & ".")

    else: # 3 or more matches
        if game_mode.hachi_matching or card == game_mode.wild_card:
            let picked_card = player.pick_to_capture_among(card, matches_on_field)
            player.capture_cards(@[card, picked_card])
            display_gamestate()
            in_game_message(player.name & " captured " & matches_on_field[0].short_name & " & " & matches_on_field[1].short_name & ".")

        else:   # non-hachi and non-wildcard: take the whole suit
            let index_on_field = field.find(matches_on_field[0])
            let (x,y) = get_two_row_coords(field.len, index_on_field)

            if not card_is_from_deck:
                display_gamestate()
                card.print_at_pos(x+2,y+1)
                in_game_message(player.name & " played " & card.full_name & ".")
                player.capture_cards(@[card] & matches_on_field)

            display_gamestate()
            if card_is_from_deck: card.print_at_pos(x+2,y+1)
            in_game_message(player.name & " captured the whole suit!")
            if card_is_from_deck: player.capture_cards(@[card] & matches_on_field) # do this later to smooth the animations



proc check_and_announce_new_dekiyaku(player: Player) =
    for yaku, value in game_mode.yaku_set:
        var count_1, count_2 = 0
        for card in player.captured:
            if card in yaku.cards_group_1:
                count_1.inc(1)
            if card in yaku.cards_group_2:
                count_2.inc(1)
        if count_1 >= yaku.num_group_1 and count_2 >= yaku.num_group_2:
            player.current_dekiyaku.add(yaku)

    let new_dekiyaku = player.current_dekiyaku.filterIt(it notin player.previous_dekiyaku)
    for yaku in new_dekiyaku:
        let rb_name = rainbow_fg(yaku.name)
        display_gamestate()
        in_game_message(player.name & " completed the " & rb_name & " yaku!", 2)
    player.previous_dekiyaku = player.current_dekiyaku

proc take_turn(player: Player) =
    var 
        selection = ""
        selected_card: Card
        deck_card: Card

    # first, select a card from one's hand to play.
    case player.play_style:
    of human:
        let options = generate_string_range(1,player.hand.len) & get_alt_names_for_zone(player.hand)
        while selection notin options:
            display_gamestate()
            move_cursor_to_pos(1,26)
            selection = prompt(text_bold & "Play a card from your hand. > " & text_reset)
            if selection in quit_commands: quit_game()
            elif selection in show_cap_and_yaku_commands:
                for player in current_players: player.show_captured_cards()

    else:
        display_gamestate()
        in_game_message("It's " & player.name & "'s turn.")

        case player.play_style:
        of choose_first:
            selection = "1"

        of choose_high:
            player.hand.sort_cards_by(sort_value)
            selection = "1"

        else: selection = "1"


    # second, translate the user entry or CPU selection to a card
    if selection in generate_string_range(1,player.hand.len):
        selected_card = player.hand[parseInt(selection) - 1]
    else: # they successfully entered a valid alt_name
        selected_card = get_card_from_alt_name(selection, player.hand)


    # third, count the number of matches and take the appropriate action.
    player.hand.keepItIf(it != selected_card) # if we don't do this, a human-played card can appear in 2 places at once
    handle_matches(player, selected_card, false)

    # Next, flip a card from the deck!
    let h = get_deck_height()    # do this before the pop to ensure flipped card is at right coords
    deck_card = current_deck.pop()
    display_gamestate()
    deck_card.print_at_pos(63 + h, 10 - h)
    in_game_message(player.name & " revealed " & deck_card.short_name & ".")

    # and take the appropriate action based on number of matches of that one!
    handle_matches(player, deck_card, true)
    
    # check if any new dekiyaku completed, and if so, announce them.
    check_and_announce_new_dekiyaku(player)



##### PLAY A FULL ROUND #####

proc rotate_player() =
    player_index.inc(1)
    if player_index >= current_players.len(): player_index = 0

proc rotate_dealer() =
    dealer_index.inc(1)
    if dealer_index >= current_players.len(): dealer_index = 0


proc wrap_up_round() =

    display_gamestate()
    in_game_message("The round has ended!")

    if game_mode.wild_card_rules == "Osaka style":
        let leftovers = field.toSeq()
        for leftover_card in leftovers:
            # Case 1: Willow leftover
            if leftover_card.standard_suit == game_mode.wild_card.standard_suit:
                for player in current_players:
                    let count = player.captured.count_suit_in_zone(leftover_card.standard_suit)
                    if count >= 2:
                        player.capture_cards(@[leftover_card])
                        display_gamestate()
                        in_game_message(player.name & " gets to take the " & leftover_card.short_name & ".")
                        break
            # Case 2: Suit captured via wildcard
            else:
                for player in current_players:
                    let count = player.captured.count_suit_in_zone(leftover_card.standard_suit)
                    if count == 1:
                        player.capture_cards(@[leftover_card])
                        display_gamestate()
                        in_game_message(player.name & " gets to take the " & leftover_card.short_name & ".")
                        break
    
    # display round winner for 2 beats
    let round_winner = get_current_round_high_scoring_player()
    display_gamestate()
    in_game_message(round_winner.name & " has won the round with " & $round_winner.round_score & " points!", 2)

proc play_round(first_to_play: int) =
    player_index = first_to_play   # initialize turn tracker

    deal_until_not_misdeal()

    var num_playable_cards_remaining = 1 # ensure there's always at least one turn
    while num_playable_cards_remaining > 0:

        let current_player = current_players[player_index]
        current_player.take_turn()

        num_playable_cards_remaining = 0
        for p in current_players:
            num_playable_cards_remaining.inc(p.hand.len)

        rotate_player()
    wrap_up_round()
    rotate_dealer()
    add_round_scores_to_match_scores()




##### PLAY A FULL GAME! #####

proc announce_game_winner() =
    let winner = get_full_match_high_scoring_player()
    clear_screen()
    echo "\n\n\n\n\n\n\n\n\n"
    let rb = rainbow_fg(winner.name)
    let str = text_bold & "The winner is " & rb & " with " & $winner.match_score & " points!" & text_reset
    echo_centered(str)
    echo "\n\n\n\n"
    echo_centered("Press ENTER to return to main menu")
    discard prompt("")    




proc play_full_match*() =

    set_up_game()

    if game_mode.target_score > 0:
        while get_full_match_high_scoring_player().match_score < game_mode.target_score:
            play_round(dealer_index)
    elif game_mode.num_rounds > 0:
        for i in 1..game_mode.num_rounds:
            play_round(dealer_index)
    else:
        play_round(dealer_index)
    
    announce_game_winner()
