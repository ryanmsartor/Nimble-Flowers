# contains the procedures for the main menu, etc.

import strutils

import nf_types
import nf_games

const quit_commands* = @["q","Q","quit","Quit","QUIT",
                         "exit","Exit","EXIT"]

var user_selection: string


proc prompt*(text: string): string =
    stdout.write(text)
    stdout.flushFile()
    result = readLine(stdin).strip()

proc quit_game*() =
    echo ""
    echo "               ~Goodbye!~               "
    echo ""
    quit(0)


proc print_title_card*() =
    echo "\n"
    echo "          ~~ Nimble Flowers ~~          "
    echo "              (c) RMS 2026              "
    echo ""

proc present_game_modes*() =
    echo "Choose a game mode by typing its number."
    echo ""
    echo "     1) Bakappana (Foolish Flowers)"
    echo "     2) Ropyakken (Six Hundred)"
    echo "     3) Mushi     (Insect Flowers)"
    echo "     4) Hachi     (Eight)"
    echo ""
    echo "     q) QUIT Nimble Flowers"
    echo ""

proc select_game_mode*(): RuleSet =
    user_selection = "0"
    while user_selection notin @["1","2","3","4"] & quit_commands:
        present_game_modes()
        user_selection = prompt("> ")
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

proc tell_default_rules*(game: RuleSet) =
    echo ""
    echo "You have chosen " & game.name & "."
    echo ""
    echo "Default rules:"
    echo "--------------------+--------------------"
    echo " Number of players: |  " & $game.num_players
    echo "     Cards in hand: |  " & $game.num_cards_hand
    echo "    Cards on field: |  " & $game.num_cards_field
    echo "      Point values: |  " & $game.point_values
    echo ""

proc offer_to_customize*(game: RuleSet) =
    echo "Type 1 to keep defaults, or 2 to customize rules."
    echo ""