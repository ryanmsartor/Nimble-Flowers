# Nimble Flowers
# a CLI hanafuda game written in Nim
# (c) Ryan Sartor 2026

import nf_types, nf_menus, nf_play

var 
    game_mode: RuleSet
    satisfied = false
    answer = ""

#   ########   #
##### MAIN #####
#   ########   #

init_screen()

print_title_card()
game_mode = select_game_mode()
echo_centered(game_mode.name)
while not satisfied:
    answer = prompt("Do you want to check or modify the ruleset? [y/N] > ")
    if answer in affirmative_answers:
        game_mode = game_mode.offer_to_customize_rules()
    elif answer in negative_answers or answer == "":
        satisfied = true
deal(game_mode)
take_turn(p1, game_mode)
show_zones_debug()

deinit_screen()