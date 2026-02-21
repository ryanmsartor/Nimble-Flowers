# Nimble Flowers
# a CLI hanafuda game written in Nim
# (c) Ryan Sartor 2026

import nf_types, nf_menus

var 
    game_mode: RuleSet

#   ########   #
##### MAIN #####
#   ########   #

print_title_card()
game_mode = select_game_mode()
game_mode = game_mode.offer_to_customize_rules()
