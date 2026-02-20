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
import nf_games

var 
    
    game_mode: RuleSet

#   ########   #
##### MAIN #####
#   ########   #

print_title_card()
game_mode = select_game_mode()
game_mode.tell_default_rules()
game_mode.offer_to_customize()
