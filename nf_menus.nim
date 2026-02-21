# contains the procedures for the main menu, etc.

# we always aim for a width of 60 characters.
# pseudo-centered text should have 15 spaces in front.
# 15 -> "               "
# 10 -> "          "

import strutils
import nf_types
import nf_rulesets

const
    quit_commands* = @["q","Q","quit","Quit","QUIT",
                         "exit","Exit","EXIT"]
    max_line_width = 60

#   #################   #
##### UTILITY PROCS #####
#   #################   #

proc echo_centered_one_line(str: string) =
    let whitespace_remaining = max_line_width - str.len
    var
        whitespace_left = whitespace_remaining div 2
        whitespace_right = whitespace_remaining - whitespace_left
        new_str = ""
    while whitespace_left > 0:
        new_str.add(" ")
        whitespace_left.dec(1)
    new_str.add(str)
    while whitespace_right > 0:
        new_str.add(" ")
        whitespace_right.dec(1)
    echo new_str

proc echo_centered_two_lines(str: string) =
    let splitpoint = str.rfind(' ')
    var line_1, line_2 = ""
    if splitpoint >= 0 and splitpoint <= 60:
        line_1 = str[0..(splitpoint-1)]
        line_2 = str[(splitpoint+1)..(-1)]
    else:
        line_1 = str[0..59]
        line_2 = str[60..(-1)]
    echo_centered_one_line(line_1)
    echo_centered_one_line(line_2)

proc echo_centered*(str: string) =
    let stripped = str.strip()
    let whitespace_remaining = max_line_width - stripped.len
    if whitespace_remaining >= 0:
        echo_centered_one_line(stripped)
    else:
        echo_centered_two_lines(stripped)

proc generate_string_range*(min:int, max:int): seq[string] =
    for i in min..max:
        result.add($i)

proc prompt*(text: string): string =
    stdout.write(text)
    stdout.flushFile()
    result = readLine(stdin).strip()

proc quit_game*() =
    echo ""
    echo_centered "~Goodbye!~"
    echo ""
    quit(0)

#   ################   #
##### ACTUAL MENUS #####
#   ################   #

proc print_title_card*() =
    echo "\n"
    echo_centered "~~ Nimble Flowers ~~"
    echo_centered "(c) RMS 2026"
    echo ""

proc present_game_modes*() =
    echo_centered "Choose a game mode by typing its number."
    echo ""
    echo "               1) Bakappana (Foolish Flowers)"
    echo "               2) Ropyakken (Six Hundred)"
    echo "               3) Mushi     (Insect Flowers)"
    echo "               4) Hachi     (Eight)"
    echo ""
    echo "               q) QUIT Nimble Flowers"
    echo ""

proc select_game_mode*(): RuleSet =
    var user_selection = ""
    while user_selection notin @["1","2","3","4"] & quit_commands:
        present_game_modes()
        user_selection = prompt("> ")
        echo ""
    case user_selection:
        of quit_commands:
            quit_game()
        of "1":
            return bakappana
        of "2":
            discard
        of "3":
            return mushi
        of "4":
            discard

proc list_yaku_names*(game: RuleSet) =
    if game.yaku_set == @[]:
        return
    else:
        echo "               Yaku:"
        for yaku in game.yaku_set:
            echo "               ", yaku.name

    

proc list_current_rules*(game: RuleSet) =
    echo ""
    echo "            Current ruleset:    " & game.name
    echo_centered "--------------------+--------------------"
    echo "          Number of players: |  " & $game.num_players
    echo "              Cards in hand: |  " & $game.num_cards_hand
    echo "             Cards on field: |  " & $game.num_cards_field
    echo "               Point values: |  " & $game.point_values
    echo "            Wild card rules: |  " & game.wild_card_rules
    echo "                  Wild card: |  " & game.wild_card.full_name
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
        echo "               1) Keep current settings"
        echo "               2) Customize settings"
        echo ""
        user_selection = prompt("> ")
    case user_selection:
        of quit_commands:
            quit_game()
        of "1":
            result = game
        of "2":
            result = game
            result.num_players = let_user_specify_num("players",2,16).parseInt()

            let max_cards_hand = 24 div result.num_players
            result.num_cards_hand = let_user_specify_num("cards in the hand",1,max_cards_hand).parseInt()

            let max_cards_field = 48 - (2 * result.num_players * result.num_cards_hand)
            result.num_cards_field = let_user_specify_num("cards on the field",0,max_cards_field).parseInt()

    result.list_current_rules
    echo "                         Let's begin!"
    return result