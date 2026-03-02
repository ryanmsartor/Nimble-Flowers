# contains the procedures for the main menu, etc.

import std/strutils
import std/tables
import nf_common
import nf_rulesets


##### MAIN MENU #####

proc print_title_card() =
    echo "\n"
    echo_centered "~~ Nimble Flowers ~~"
    echo_centered "(c) RMS 2026"
    echo ""

proc present_game_modes() =
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
        user_selection = prompt(" > ")
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



##### PRE-GAME CONFIG MENU #####

proc pre_game_config*(game: RuleSet) =
    var user_selection = ""
    let options = generate_string_range(1,4)
    current_table_style = narrowStyle
    current_table_style.width = 36

    while user_selection notin options & quit_commands:
        clear_screen()
        echo ""
        echo ""
        echo_centered("~~ " & game.name & " ~~")
        echo ""

        insert_div()
        insert_row("1) Begin game!")
        insert_row("2) View/Edit rules")
        insert_row("3) View/Edit yaku")
        insert_row("4) Return to main menu")
        insert_div()
        echo ""
        user_selection = prompt(" > ")
    case user_selection:
    of quit_commands:
        quit_game()
    of "1":
        program_state = "play"
    of "2":
        program_state = "customize rules"
    of "3":
        program_State = "customize yaku"
    of "4":
        program_state = "main_menu"


##### CUSTOMIZE RULES MENU #####







proc list_yaku*(game: RuleSet) =
    const blank = initOrderedTable[Dekiyaku,int]()
    if game.yaku_set == blank:
        return
    else:
        insert_row(r"\_Yaku:_/")
        for yaku, score in game.yaku_set:
            insert_row(yaku.name, $score & " pts")
    insert_div(1,"'","-","'")

proc list_rules*(game: RuleSet) =
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
    if game.wild_card_rules != "" and game.wild_card.full_name != "":
        insert_row("Wild card rules:",game.wild_card_rules)
        insert_row("Wild card:",game.wild_card.full_name)
        insert_div(2)
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


proc customize_rules*(game: RuleSet): RuleSet =
    var user_selection = ""
    while user_selection notin @["1","2"] & quit_commands:
        clear_screen()
        echo ""
        game.list_rules
        echo_indented "1) Keep current settings"
        echo_indented "2) Customize settings"
        echo ""
        user_selection = prompt(" > ")
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

    result.list_rules
    return result


