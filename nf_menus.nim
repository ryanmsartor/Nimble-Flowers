# contains the procedures for the main menu, etc.

import std/parsecfg
import std/strutils
import std/tables
import nf_common
import nf_rulesets
import nf_yaku

##### MAIN MENU #####

proc print_title_card() =
    echo "\n\n\n"
    echo_centered text_bold & "~~ Nimble Flowers ~~".rainbow_fg()
    echo ""
    echo_centered "(c) RMS 2026" & text_reset
    echo "\n"

proc present_game_modes() =
    current_table_style = narrowStyle
    insert_div()
    insert_row(text_bold & "Choose a game mode by typing its number." & text_reset)
    insert_row("")
    insert_row(fg_pine,"1)", "Bakappana", fg_reset)
    insert_row(fg_plum,"2)", "Mushi", fg_reset)
    insert_row(fg_cherry,"3)","Ropyakken", fg_reset)
    insert_row(fg_wisteria,"4)", "Hachi", fg_reset)
    insert_div()
    insert_row("s) Settings")
    insert_row("q) QUIT Nimble Flowers")
    insert_div()
    echo ""

proc select_game_mode*(): RuleSet =
    var user_selection = ""
    while user_selection notin generate_string_range(1,4) & quit_commands & settings_commands:
        clear_screen()
        print_title_card()
        present_game_modes()
        user_selection = prompt(" > ")
    case user_selection:
        of quit_commands: quit_game()
        of settings_commands: program_state = "settings"; return bakappana # basically a throwaway value
        of "1": return bakappana
        of "2": return mushi
        of "3": return ropyakken
        of "4": return hachi



##### GLOBAL SETTINGS MENUS #####

proc configure_global_game_speed(): GameSpeed =
    var user_selection = ""
    while user_selection notin generate_string_range(1,7) & quit_commands:
        clear_screen()
        current_table_style = narrowStyle
        echo "\n\n"
        echo_centered "~ Game Speed ~"
        echo "\n"
        insert_div()
        insert_row("1) Slowest")
        insert_row("2) Slower")
        insert_row("3) Slow")
        insert_row("4) Medium")
        insert_row("5) Fast")
        insert_row("6) Faster")
        insert_row("7) Fastest")
        insert_div()
        echo ""
        user_selection = prompt(" > ")
    case user_selection:
    of quit_commands: quit_game()
    of "1": return slowest
    of "2": return slower
    of "3": return slow
    of "4": return medium
    of "5": return fast
    of "6": return faster
    of "7": return fastest

proc configure_global_sfx_volume(): uint8 =
    var user_selection = ""
    while user_selection notin generate_string_range(0,255) & quit_commands:
        clear_screen()
        current_table_style = narrowStyle
        echo "\n\n"
        echo_centered "~ SFX Volume ~"
        echo "\n"
        insert_div()
        insert_row("")
        insert_row("SFX not yet implemented! Sorry!")
        insert_row("")
        insert_row("Enter a number from 0 to 255.")
        insert_row("")
        insert_div()
        echo ""
        user_selection = prompt(" > ")
    case user_selection:
    of quit_commands: quit_game()
    else:
        return uint8(parseInt(user_selection))



proc configure_global_settings*() =
    var user_selection = ""
    while user_selection != "3":
        clear_screen()
        current_table_style = narrowStyle
        echo "\n\n"
        echo_centered "~ Global Settings ~"
        echo "\n"
        insert_div()
        insert_row("")
        insert_row("1)", "Game Speed", text_bold & $game_speed & text_reset)
        insert_row("")
        insert_row("2)", "SFX Volume", text_bold & $sfx_volume & text_reset)
        insert_row("")
        insert_row("3)", "Return to menu", "")
        insert_row("")
        insert_div()
        echo ""
        user_selection = prompt(" > ")
        case user_selection:
        of quit_commands:
            quit_game()
        of "1":
            game_speed = configure_global_game_speed()
            nf_cfg.setSectionKey("Global", "Game speed", $game_speed)
        of "2":
            sfx_volume = configure_global_sfx_volume()
            nf_cfg.setSectionKey("Global", "SFX volume", $sfx_volume)
    nf_cfg.writeConfig(nf_cfg_path)




##### PRE-GAME CONFIG MENU #####

proc pre_game_config*(game: RuleSet) =
    var user_selection = ""
    let options = generate_string_range(1,4)
    current_table_style = narrowStyle
    current_table_style.width = 36

    while user_selection notin options & quit_commands:
        clear_screen()
        echo "\n\n"
        echo_centered("~~ " & game.name & " ~~")
        echo "\n"

        insert_div()
        insert_row("")
        insert_row("1) Begin game!")
        insert_row("")
        insert_row("2) View/Edit rules")
        insert_row("")
        insert_row("3) View/Edit yaku")
        insert_row("")
        insert_row("4) Return to main menu")
        insert_row("")
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
        program_state = "customize yaku"
    of "4":
        program_state = "main menu"


##### CUSTOMIZE RULES MENU #####

proc list_rules(game: RuleSet) =
    let decksize = 48 - game.cards_stripped.len
    current_table_style = defaultStyle
    echo "\n\n\n"
    insert_div(2,".","-",".")
    insert_row("Current ruleset:",game.name)
    insert_div(4)
    insert_row("Players:", $game.num_players, "Deck size:", $decksize & " cards")
    insert_div(4)
    insert_row("Hand size:",$game.num_cards_hand & " cards","Field size:", $game.num_cards_field & " cards")
    insert_div(4)
    insert_row("Point values:", $game.point_values)
    if game.wild_card_rules != "" and game.wild_card.full_name != "":
        insert_div(2)
        insert_row("Wild card rules:",game.wild_card_rules)
        insert_row("Wild card:",game.wild_card.full_name)
    if game.hachi_matching or game.can_koikoi:
        insert_div(2)
        insert_row("Special rules:")
        if game.hachi_matching:
            insert_row("Match by forming sum of 3, 8, 13, 18, or 23")
        if game.can_koikoi:
            insert_row("May call shoubu or koi-koi")
    insert_div(1,"'","-","'")
    echo ""

proc ask_how_many(rule_name: string, min: int, max: int, game: RuleSet): string =
    var user_selection = ""
    let options = generate_string_range(min, max)

    while user_selection notin options & quit_commands:
        clear_screen()
        echo ""
        game.list_rules
        echo ""
        user_selection = prompt("How many " & rule_name & "? [" & $min & "-" & $max & "] > ")
        if user_selection in quit_commands:
            quit_game()

    return user_selection

proc ask_which_point_set(game: RuleSet): string =
    var user_selection = ""
    let options = generate_string_range(1,6)

    while user_selection notin options & quit_commands:
        clear_screen()
        echo ""
        game.list_rules

        echo_centered "1) Standard-88 ( 1,  5, 10, 20)"
        echo_centered "2) Standard-80 ( 0,  5, 10, 20)"
        echo_centered "3) Hawaiian    ( 0, 10,  5, 20)"
        echo_centered "4) Ropyakken   ( 0, 10, 10, 50)"
        echo_centered "5) Hachi       (10,  1, 10, 10)"
        echo_centered "6) Sudaoshi    (10,  1,  5,  5)"
        echo ""
        user_selection = prompt("Which point value system? > ")

    case user_selection:
    of quit_commands: quit_game()
    of "1": return "1, 5, 10, 20"
    of "2": return "0, 5, 10, 20"
    of "3": return "0, 10, 5, 20"
    of "4": return "0, 10, 10, 50"
    of "5": return "10, 1, 10, 10"
    of "6": return "10, 1, 5, 5"


proc customize_rules*(game: RuleSet): RuleSet =
    var user_selection = ""

    while user_selection notin @["1","2"] & quit_commands:
        clear_screen()
        echo ""
        game.list_rules
        echo_indented "1) Keep current rules"
        echo_indented "2) Customize rules"
        echo ""
        user_selection = prompt(" > ")

    case user_selection:
    of quit_commands:
        quit_game()
    of "1":
        result = game
        program_state = "pre-game menu"
    of "2":
        result = game

        result.num_players = ask_how_many("players",2,6,result).parseInt()

        let decksize = 48 + game.cards_added.len - game.cards_stripped.len 
        let max_cards_hand = (decksize div 2) div result.num_players
        result.num_cards_hand = ask_how_many("cards in the hand",1,max_cards_hand,result).parseInt()

        var max_cards_field = decksize - (2 * result.num_players * result.num_cards_hand)
        if max_cards_field > 12: max_cards_field = 12
        result.num_cards_field = ask_how_many("cards on the field",0,max_cards_field,result).parseInt()

        result.point_values = ask_which_point_set(result)

    return result



##### CUSTOMIZE YAKU MENU #####

proc list_yaku(game: RuleSet) =
    if game.yaku_set == yaku_table_blank:
        current_table_style = narrowStyle
        insert_div()
        insert_row("No yaku")
        insert_div()
    else:
        current_table_style = defaultStyle
        insert_div()
        insert_row(r"\_Yaku:_/")
        for yaku, score in game.yaku_set:
            insert_row(yaku.name, $score & " pts")
        insert_div()


proc ask_which_yaku_set(game: RuleSet): OrderedTable[Dekiyaku, int] =
    var user_selection = ""
    let options = generate_string_range(1,6)

    while user_selection notin options & quit_commands:
        clear_screen()
        echo ""
        game.list_yaku

        echo_centered "1)                 No yaku"
        echo_centered "2)          Mushi yaku set"
        echo_centered "3)   Ropyakken yaku (full)"
        echo_centered "4) Ropyakken yaku (simple)"
        echo_centered "5)          Hachi yaku set"
        echo_centered "6)         Shima yaku only"
        echo ""
        user_selection = prompt("Which yaku set? > ")

    case user_selection:
    of quit_commands: quit_game()
    of "1": return yaku_table_blank
    of "2": return yaku_table_mushi
    of "3": return yaku_table_ropyakken
    of "4": return yaku_table_yamayaku
    of "5": return yaku_table_hachi
    of "6": return yaku_table_shima

proc customize_yaku*(game: RuleSet): RuleSet =
    var user_selection = ""

    while user_selection notin @["1","2"] & quit_commands:
        clear_screen()
        echo ""
        list_yaku(game)
        echo_indented "1) Keep current yaku set"
        echo_indented "2) Customize yaku set"
        echo ""
        user_selection = prompt(" > ")

    case user_selection:
    of quit_commands:
        quit_game()
    of "1":
        result = game
        program_state = "pre-game menu"
    of "2":
        result = game
        result.yaku_set = ask_which_yaku_set(result)

    return result