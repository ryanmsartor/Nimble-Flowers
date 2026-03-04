# Nimble Flowers
# a CLI hanafuda game written in Nim
# (c) Ryan Sartor 2026

import nf_common, nf_menus, nf_play

var game_mode: RuleSet

#   ########   #
##### MAIN #####
#   ########   #

init_screen()

while true:
    case program_state:

    of "main menu":
        game_mode = select_game_mode()
        program_state = "pre-game menu"

    of "pre-game menu":
        game_mode.pre_game_config()

    of "customize rules":
        game_mode = game_mode.customize_rules()

    of "customize yaku":
        game_mode = game_mode.customize_yaku()

    of "play":
        game_mode.set_up_game()
        deal(game_mode)
        take_turn(p1, game_mode)

    # of "help":

    # of "view rules":

    # of "view yaku":

    # of "view captured":

    else:
        quit_game()

deinit_screen()