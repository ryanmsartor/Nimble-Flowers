# Nimble Flowers
# a CLI hanafuda game written in Nim
# (c) Ryan Sartor 2026

import os
import sequtils
import strutils

import nf_types
import nf_cards
import nf_yaku
import nf_menus

var 
    user_selection = ""
    game_mode: RuleSet

#   ########   #
##### MAIN #####
#   ########   #

print_title_card()

while user_selection notin @["1","2","3","4"] & quit_commands:
    present_main_menu()
    user_selection = prompt("> ")
case user_selection:
    of quit_commands:
        quit_game()
    of "1":
        discard
    of "2":
        discard
    of "3":
        discard
    of "4":
        discard