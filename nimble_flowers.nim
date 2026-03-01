# Nimble Flowers
# a CLI hanafuda game written in Nim
# (c) Ryan Sartor 2026

import nf_common, nf_menus, nf_play

var 
    game_mode: RuleSet

#   ########   #
##### MAIN #####
#   ########   #

init_screen()

game_mode = select_game_mode() # main menu

clear_screen()
echo ""
echo_centered(game_mode.name)
echo ""
game_mode = game_mode.offer_to_customize_rules()

deal(game_mode)
take_turn(p1, game_mode)
show_zones_debug()

deinit_screen()