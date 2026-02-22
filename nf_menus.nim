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

proc echo_centered*(str: string)    # pre-declared proc to enable recursion

proc echo_indented*(str: string,num:uint8=15) =
    var
        new_string = ""
        i = num
    while i > 0:
        new_string.add(" ")
        i.dec(1)
    new_string.add(str.strip())
    echo new_string

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

proc echo_centered_multi_lines(str: string) =
    let splitpoint = str.rfind(' ')
    var line_1, line_2 = ""
    if splitpoint >= 0 and splitpoint < max_line_width:
        line_1 = str[0..(splitpoint-1)]
        line_2 = str[(splitpoint+1)..(-1)]
    else:
        line_1 = str[0..(max_line_width-1)]
        line_2 = str[max_line_width..(-1)]
    echo_centered_one_line(line_1)
    if line_2.len > 0:
        echo_centered(line_2)

proc echo_centered*(str: string) =
    let stripped = str.strip()
    let whitespace_remaining = max_line_width - stripped.len
    if whitespace_remaining >= 0:
        echo_centered_one_line(stripped)
    else:
        echo_centered_multi_lines(stripped)

# let's just use this one responsibly and not deal with multilines...
proc echo_centered_on*(sides: array[2,string], centerpiece: string) =
    let
        left_side = sides[0].strip()
        right_side = sides[1].strip()
        space_per_side = (max_line_width - centerpiece.len) div 2
        content_width = left_side.len + centerpiece.len + right_side.len
    var
        whitespace_left = space_per_side - left_side.len
        whitespace_right = max_line_width - (content_width + whitespace_left)
        new_left = ""
        new_right = right_side
        full_string = ""
    while whitespace_left > 0:
        new_left.add(" ")
        whitespace_left.dec(1)
    new_left.add(left_side)
    while whitespace_right > 0:
        new_right.add(" ")
        whitespace_right.dec(1)
    full_string = new_left & centerpiece & new_right
    echo full_string

proc draw_horizontal_div*(line="-",center="+",side_length:uint8=20) = 
    var
        one_bar = ""
        i = side_length
    while i > 0:
        one_bar.add(line)
        i.dec(1)
    [one_bar,one_bar].echo_centered_on(center)
    


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
    echo_indented "1) Bakappana (Foolish Flowers)"
    echo_indented "2) Ropyakken (Six Hundred)"
    echo_indented "3) Mushi     (Insect Flowers)"
    echo_indented "4) Hachi     (Eight)"
    echo ""
    echo_indented "q) QUIT Nimble Flowers"
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
        echo_indented "Yaku:"
        for yaku in game.yaku_set:
            echo_indented yaku.name

    

proc list_current_rules*(game: RuleSet) =
    echo ""
    ["Current ruleset:",game.name].echo_centered_on(" | ")
    draw_horizontal_div()

    ["Number of players:",  $game.num_players       ].echo_centered_on(" | ")
    ["Cards in hand:",      $game.num_cards_hand    ].echo_centered_on(" | ")
    ["Cards on field:",     $game.num_cards_field   ].echo_centered_on(" | ")
    ["Cards on field:",     $game.num_cards_field   ].echo_centered_on(" | ")
    ["Point values:",       $game.point_values      ].echo_centered_on(" | ")

    if game.wild_card_rules != "":
        ["Wild card rules:",    game.wild_card_rules    ].echo_centered_on(" | ")
    if game.wild_card.full_name != "":
        ["Wild card:",          game.wild_card.full_name].echo_centered_on(" | ")

    draw_horizontal_div()
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
            result.num_players = let_user_specify_num("players",2,16).parseInt()

            let max_cards_hand = 24 div result.num_players
            result.num_cards_hand = let_user_specify_num("cards in the hand",1,max_cards_hand).parseInt()

            let max_cards_field = 48 - (2 * result.num_players * result.num_cards_hand)
            result.num_cards_field = let_user_specify_num("cards on the field",0,max_cards_field).parseInt()

    result.list_current_rules
    echo_centered "Let's begin!"
    return result