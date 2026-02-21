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


proc generate_string_range(min:int, max:int): seq[string] =
    for i in min..max:
        result.add($i)

proc prompt*(text: string): string =
    stdout.write(text)
    stdout.flushFile()
    result = readLine(stdin).strip()

proc quit_game*() =
    echo ""
    echo "                         ~Goodbye!~               "
    echo ""
    quit(0)


proc print_title_card*() =
    echo "\n"
    echo "                    ~~ Nimble Flowers ~~                    "
    echo "                        (c) RMS 2026                        "
    echo ""

proc present_game_modes*() =
    echo "          Choose a game mode by typing its number."
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
            discard
        of "4":
            discard

proc list_current_rules*(game: RuleSet) =
    echo ""
    echo "             Current ruleset:    " & game.name
    echo "          --------------------+--------------------"
    echo "           Number of players: |  " & $game.num_players
    echo "               Cards in hand: |  " & $game.num_cards_hand
    echo "              Cards on field: |  " & $game.num_cards_field
    echo "                Point values: |  " & $game.point_values
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