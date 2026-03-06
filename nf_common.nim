# to be imported by most (all?) other .nim files

import std/strutils
import std/tables
import re



##### CUSTOM TYPES AND OBJECTS #####

type
    Suit* = range[0..15]
    Decksize* = range[24..64]
    NumPlayers* = range[0..8]
    NumHands* = range[0..24]
    NumField* = range[0..48]
    PlayStyle* = enum
        human, always_choose_first
    GameSpeed* = enum
        slowest, slower, slow, medium, fast, faster, fastest
    
    Card* = object
        full_name*: string
        short_name*: string # 25 char at absolute max
        alt_names*: seq[string]
        standard_suit*: Suit
        mushi_suit*: Suit
        nagoya_suit*: Suit
        hachihachi_value*: int
        hachi_value*: int
        ropyakken_value*: int
        sudaoshi_value*: int
        sakura_value*: int
        art0*: string
        art1*: string
        art2*: string
        art3*: string
        art4*: string
        art5*: string
        art6*: string
        art7*: string
        art8*: string
        art9*: string

    Zone* = seq[Card]

    Player* = ref object
        name*: string
        hand*: Zone
        captured*: Zone
        current_teyaku_score*: int
        current_dekiyaku_score*: int
        current_card_score*: int
        overall_score*: int
        rounds_won*: uint8
        play_style*: PlayStyle

    Dekiyaku* = object
        name*: string
        exclusivity_group*: string
        cards_group_1*: seq[Card]
        cards_group_2*: seq[Card]
        num_group_1*: uint8
        num_group_2*: uint8

    SetTeyaku* = object
        name*: string
        singles*: uint8
        doubles*: uint8
        triples*: uint8
        special_triples*: uint8
        quads*: uint8
        score*: uint8

    ChaffTeyaku* = object
        name*: string
        chaff*: uint8
        ribbons*: uint8
        animals*: uint8
        brights*: uint8
        score*: uint8

    RuleSet* = object
        name*: string
        num_players*: NumPlayers
        num_cards_hand*: NumHands
        num_cards_field*: NumField
        wild_card*: Card
        wild_card_rules*: string
        yaku_set*: OrderedTable[Dekiyaku,int]
        set_teyaku_list*: seq[SetTeyaku]
        chaff_teyaku_list*: seq[ChaffTeyaku]
        can_koikoi*: bool
        suit_system*: string
        hachi_matching*: bool
        zero_sum*: bool
        target_score*: int
        num_rounds*: int
        cards_stripped*: seq[Card]
        cards_added*: seq[Card]
        point_values*: string

    TableStyle* = object
        divider*: string
        border*: string
        padding*: char
        line_char*: string
        left_corner*: string
        right_corner*: string
        intersection*: string
        width*: int



##### GENERAL GLOBAL CONSTANTS #####

const
    quit_commands* = @["q","Q","quit","Quit","QUIT","exit","Exit","EXIT"]
    settings_commands* = @["s","S","setting","Setting","SETTING","settings","Settings","SETTINGS"]
    affirmative_answers* = @["yes","Yes","YES","y","Y:"]
    negative_answers* = @["no","No","NO","n","N"]
    max_line_width* = 80
    max_screen_height* = 40



##### ANSI ESCAPE SEQUENCES #####

# these are used in conjunction with stdout.write() and echo()
# to control how the terminal displays stuff.

const
    text_bold* = "\e[1m"
    text_reset* = "\e[0m"

    fg_reset* = "\e[39m"
    bg_reset* = "\e[49m"
    fg_faded* = "\e[38;2;5;5;5m"
    bg_faded* = "\e[48;2;5;5;5m"

    fg_pine       * = "\e[38;2;0;153;77m"
    fg_plum       * = "\e[38;2;255;30;103m"
    fg_cherry     * = "\e[38;2;255;180;182m"
    fg_wisteria   * = "\e[38;2;138;57;145m"
    fg_iris       * = "\e[38;2;60;4;223m"
    fg_peony      * = "\e[38;2;238;130;220m"
    fg_clover     * = "\e[38;2;183;15;86m"
    fg_grass      * = "\e[38;2;196;227;199m"
    fg_mum        * = "\e[38;2;245;184;22m"
    fg_maple      * = "\e[38;2;211;26;5m"
    fg_willow     * = "\e[38;2;101;196;6m"
    fg_paulownia  * = "\e[38;2;186;163;222m"

    bg_pine       * = "\e[48;2;0;153;77m"
    bg_plum       * = "\e[48;2;255;30;103m"
    bg_cherry     * = "\e[48;2;255;180;182m"
    bg_wisteria   * = "\e[48;2;138;57;145m"
    bg_iris       * = "\e[48;2;60;4;223m"
    bg_peony      * = "\e[48;2;238;130;220m"
    bg_clover     * = "\e[48;2;183;15;86m"
    bg_grass      * = "\e[48;2;196;227;199m"
    bg_mum        * = "\e[48;2;245;184;22m"
    bg_maple      * = "\e[48;2;211;26;5m"
    bg_willow     * = "\e[48;2;101;196;6m"
    bg_paulownia  * = "\e[38;2;186;163;222m"

    reset_screen* = "\e[2J\e[H"

    enter_alt_screen* = "\e[?1049h"
    exit_alt_screen* = "\e[?1049l"

    hide_cursor* = "\e[?25l"
    show_cursor* = "\e[?25h"

let ansiRegex* = re"\e\[[0-9;]*m"




##### ANSI CONTROL PROCS #####

proc move_cursor_to_pos*(xpos=1, ypos=1) =
    stdout.write("\e[" & $ypos & ";" & $xpos & "H")

proc rainbow_fg*(str: string): string = 
    const colormap = [ fg_pine, fg_plum, fg_cherry,
                       fg_wisteria, fg_iris, fg_peony,
                       fg_clover, fg_grass, fg_mum,
                       fg_maple, fg_willow, fg_paulownia ]
    for c in 0 .. str.len()-1:
        var i = c mod 12
        result.add(colormap[i])
        result.add(str[c])
    result.add(fg_reset)
    return result

proc rainbow_bg*(str: string): string = 
    const colormap = [ bg_pine, bg_plum, bg_cherry,
                       bg_wisteria, bg_iris, bg_peony,
                       bg_clover, bg_grass, bg_mum,
                       bg_maple, bg_willow, bg_paulownia ]
    for c in 0 .. str.len()-1:
        var i = c mod 12
        result.add(colormap[i])
        result.add(str[c])
    result.add(bg_reset)
    return result



proc init_screen*() =
    stdout.write(enter_alt_screen)
    stdout.write(hide_cursor)
    stdout.write(reset_screen)

proc deinit_screen*() =
    stdout.write(reset_screen)
    stdout.write(show_cursor)
    stdout.write(exit_alt_screen)

proc clear_screen*() =
    stdout.write(reset_screen)




##### GAME FLOW CONTROL #####

# this global drives which menu or game screen to go to.
var program_state* = "main menu"
var game_mode*: RuleSet

# global settings
var game_speed*: GameSpeed = medium
var sfx_volume*: uint8

proc prompt*(text: string): string =
    stdout.write(text)
    stdout.flushFile()
    result = readLine(stdin).strip()

proc quit_game*() =
    deinit_screen()
    quit(0)

proc generate_string_range*(min:int, max:int): seq[string] =
    for i in min..max:
        result.add($i)




##### TABLE AND LAYOUT CONSTRUCTION #####

const
    defaultStyle* = TableStyle(
        divider: "|",
        border: "|",
        padding: ' ',
        line_char: "-",
        left_corner: "|",
        right_corner: "|",
        intersection: "+",
        width: 54
    ) 
    narrowStyle* = TableStyle(
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
var current_table_style* = defaultStyle

# use this instead of string.len() to ignore control characters
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
    new_string.add(str)
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


proc insert_div*(
    num_columns=1,
    left_corner = current_table_style.left_corner,
    intersection = current_table_style.intersection,
    right_corner = current_table_style.right_corner
) =
    let
        divider = current_table_style.divider
        border = current_table_style.border
        table_width = current_table_style.width
        pad_char = current_table_style.padding
        line_char = current_table_style.line_char
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

proc insert_row*(mystrings: varargs[string]) =
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

