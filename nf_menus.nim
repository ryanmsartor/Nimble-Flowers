# contains the procedures for the main menu, etc.

import std/strutils
import std/tables
import nf_common
import nf_rulesets


proc print_title_card*() =
    echo "\n"
    echo_centered "~~ Nimble Flowers ~~"
    echo_centered "(c) RMS 2026"
    echo ""

proc present_game_modes*() =
    current_table_style = narrowStyle
    insert_div()
    insert_row("Choose a game mode by typing its number.")
    insert_row("")
    insert_row("","1)", "Bakappana","")
    insert_row("","2)", "Ropyakken","")
    insert_row("","3)","Mushi", "")
    insert_row("","4)", "Hachi","")
    insert_div()
    insert_row("q) QUIT Nimble Flowers")
    insert_div()
    echo ""

proc select_game_mode*(): RuleSet =
    var user_selection = ""
    while user_selection notin @["1","2","3","4"] & quit_commands:
        clear_screen()
        print_title_card()
        present_game_modes()
        user_selection = prompt("> ")
    case user_selection:
        of quit_commands:
            quit_game()
        of "1":
            return bakappana
        of "2":
            return ropyakken
        of "3":
            return mushi
        of "4":
            return hachi

proc list_yaku_names*(game: RuleSet) =
    const blank = initOrderedTable[Dekiyaku,int]()
    if game.yaku_set == blank:
        return
    else:
        insert_row(r"\_Yaku:_/")
        for yaku, score in game.yaku_set:
            insert_row(yaku.name, $score & " pts")
    insert_div(1,"'","-","'")
    

proc list_current_rules*(game: RuleSet) =
    let decksize = 48 - game.cards_stripped.len
    current_table_style = defaultStyle
    insert_div(2,".","-",".")
    insert_row("Current ruleset:",game.name)
    insert_div(4)
    insert_row("Players:", $game.num_players, "Deck size:", $decksize & " cards")
    insert_div(4)
    insert_row("Hand size:",$game.num_cards_hand & " cards","Field size:", $game.num_cards_field & " cards")
    insert_div(4)
    insert_row("Point values:", $game.point_values)
    insert_div(2)
    if game.wild_card_rules != "":
        insert_row("Wild card rules:",game.wild_card_rules)
    if game.wild_card.full_name != "":
        insert_row("Wild card:",          game.wild_card.full_name)
    insert_div(2)

    game.list_yaku_names
    echo ""

proc let_user_specify_num(rule_name: string, min: int, max: int): string =
    var user_selection = "";
    let options = generate_string_range(min, max)
    while user_selection notin options & quit_commands:
        user_selection = prompt("How many " & rule_name & "? [" & $min & "-" & $max & "] > ")
        if user_selection in quit_commands:
            quit_game()
        elif user_selection notin options:
            echo ""
            echo user_selection, " is not a valid selection. Please select a value between ", min, " and ", max, "."
            echo ""
    return user_selection


proc offer_to_customize_rules*(game: RuleSet): RuleSet =
    var user_selection = "";
    while user_selection notin @["1","2"] & quit_commands:
        game.list_current_rules
        echo_indented "1) Keep current settings"
        echo_indented "2) Customize settings"
        echo ""
        user_selection = prompt("> ")
    case user_selection:
        of quit_commands:
            quit_game()
        of "1":
            result = game
        of "2":
            result = game
            result.num_players = let_user_specify_num("players",2,8).parseInt()

            let decksize = 48 - game.cards_stripped.len
            let max_cards_hand = (decksize div 2) div result.num_players
            result.num_cards_hand = let_user_specify_num("cards in the hand",1,max_cards_hand).parseInt()

            let max_cards_field = decksize - (2 * result.num_players * result.num_cards_hand)
            result.num_cards_field = let_user_specify_num("cards on the field",0,max_cards_field).parseInt()

    result.list_current_rules
    echo_centered "Let's begin!"
    return result

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