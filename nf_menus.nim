# contains the procedures for the main menu, etc.

import strutils

proc print_title_card*() =
    echo "\n"
    echo "          ~~ Nimble Flowers ~~          "
    echo "              (c) RMS 2026              "
    echo ""

const quit_commands* = @["q","Q","quit","Quit","QUIT"]

proc prompt*(text: string): string =
    stdout.write(text)
    stdout.flushFile()
    result = readLine(stdin).strip()

proc quit_game*() =
    echo ""
    echo "               ~Goodbye!~               "
    echo ""
    quit(0)

proc present_main_menu*() =
    echo "Choose a game mode by typing its number."
    echo ""
    echo "    1) Bakappana (Foolish Flowers)"
    echo "    2) Ropyakken (Six Hundred)"
    echo "    3) Mushi     (Insect Flowers)"
    echo "    4) Hachi     (Eight)"
    echo ""
    echo "    q) QUIT Nimble Flowers"
    echo ""
