# contains the procedures for the main menu, etc.

import strutils
import std/tables
import nf_types
import nf_rulesets
import re

const
    quit_commands* = @["q","Q","quit","Quit","QUIT",
                         "exit","Exit","EXIT"]
    affirmative_answers* = @["yes","Yes","YES","y","Y:"]
    negative_answers* = @["no","No","NO","n","N"]
    max_line_width* = 60
    
let ansiRegex = re"\x1b\[[0-9;]*m"

const
    defaultStyle = TableStyle(
        divider: "|",
        border: "|",
        padding: ' ',
        line_char: "-",
        left_corner: ".",
        right_corner: ".",
        intersection: "+",
        width: 54
    ) 
    narrowStyle = TableStyle(
        divider: "",
        border: "|",
        padding: ' ',
        line_char: "-",
        left_corner: "-",
        right_corner: "-",
        intersection: "-",
        width: 44
    )

# this global should be explicitly set every time you make a new table
var current_table_style = defaultStyle

#   #################   #
##### UTILITY PROCS #####
#   #################   #

proc visibleLen*(s: string): int =
    result = s.replace(ansiRegex, "").len

proc echo_centered*(str: string)    # pre-declared proc to enable recursion

proc echo_indented*(str: string,num=15) =
    var
        new_string = ""
        i = num
    while i > 0:
        new_string.add(" ")
        i.dec(1)
    new_string.add(str.strip())
    echo new_string

proc echo_centered_one_line(str: string) =
    let whitespace_remaining = max_line_width - str.visibleLen()
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
    if line_2.visibleLen > 0:
        echo_centered(line_2)

proc echo_centered*(str: string) =
    let stripped = str.strip()
    let whitespace_remaining = max_line_width - stripped.visibleLen()
    if whitespace_remaining >= 0:
        echo_centered_one_line(stripped)
    else:
        echo_centered_multi_lines(stripped)


proc insert_div*(num_columns=1) =
    let
        divider = current_table_style.divider
        border = current_table_style.border
        table_width = current_table_style.width
        pad_char = current_table_style.padding
        line_char = current_table_style.line_char
        left_corner = current_table_style.left_corner
        right_corner = current_table_style.right_corner
        intersection = current_table_style.intersection

        div_width = divider.visibleLen()
        border_width = border.visibleLen()
        usable_width = table_width - (2 * border_width) -
                       ((num_columns - 1) * div_width)

        width_per_col = usable_width div num_columns
        excess_width = usable_width mod num_columns
        left_edge_pad = (max_line_width - table_width) div 2

    # --- compute column widths (same as insert_row) ---
    var colWidths = newSeq[int](num_columns)
    for i in 0 ..< num_columns:
        colWidths[i] = int(width_per_col)

    var remaining = int(excess_width)
    let mid = int(num_columns div 2)
    var offset = 0
    while remaining > 0:
        let idx = mid + offset
        if idx >= 0 and idx < int(num_columns):
            colWidths[idx].inc
            remaining.dec
        if offset <= 0:
            offset = -offset + 1
        else:
            offset = -offset

    # --- build divider line ---
    var final_string = ""

    while final_string.visibleLen() < left_edge_pad:
        final_string.add(pad_char)

    final_string.add(left_corner)

    for i in 0 ..< num_columns:
        for _ in 0 ..< colWidths[i]:
            final_string.add(line_char)

        if i < num_columns - 1:
            final_string.add(intersection)
        else:
            final_string.add(right_corner)

    while final_string.visibleLen() < max_line_width:
        final_string.add(pad_char)

    echo final_string

proc insert_row(mystrings: varargs[string]) =
    let
        divider = current_table_style.divider
        border = current_table_style.border
        table_width = current_table_style.width
        pad_char = current_table_style.padding
        num_columns = mystrings.len
        div_width = divider.visibleLen()
        border_width = border.visibleLen()
        usable_width = table_width - (2 * border_width) - ((num_columns - 1) * div_width)
        width_per_col = usable_width div num_columns
        excess_width = usable_width mod num_columns
        left_edge_pad = (max_line_width - table_width) div 2
    var
        final_string = ""
        inner_pad_total, inner_pad_left, inner_pad_right: int

    # per-column widths ---
    var colWidths = newSeq[int](num_columns)
    for i in 0 ..< num_columns:
        colWidths[i] = int(width_per_col)

    # distribute remainder to middle columns
    var remaining = int(excess_width)
    let mid = int(num_columns div 2)
    var offset = 0
    while remaining > 0:
        let idx = mid + offset
        if idx >= 0 and idx < int(num_columns):
            colWidths[idx].inc
            remaining.dec
        if offset <= 0:
            offset = -offset + 1
        else:
            offset = -offset

    # pad left side
    while final_string.visibleLen() < left_edge_pad:
        final_string.add(pad_char)
    final_string.add(border)

    # print each column
    for i, str in mystrings:
        inner_pad_total = colWidths[i] - str.visibleLen()
        inner_pad_left = inner_pad_total div 2
        inner_pad_right = inner_pad_left + (inner_pad_total mod 2)

        for _ in 0 ..< inner_pad_left:
            final_string.add(pad_char)
        final_string.add(str)
        for _ in 0 ..< inner_pad_right:
            final_string.add(pad_char)

        if i < mystrings.len - 1:
            final_string.add(divider)

    # close table and add right pad
    final_string.add(border)
    while final_string.visibleLen() < max_line_width:
        final_string.add(pad_char)

    echo final_string

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
        #echo_indented(r"\_Yaku:_/", 8)
        insert_row(r"\_Yaku:_/")
        for yaku, score in game.yaku_set:
            #echo_indented(yaku.name & " : " & $score, 5)
            insert_row(yaku.name, $score & " pts")
    insert_div()
    

proc list_current_rules*(game: RuleSet) =
    let decksize = 48 - game.cards_stripped.len
    current_table_style = defaultStyle
    insert_div(2)
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
