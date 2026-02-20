# contains yaku and teyaku constants

import nf_types
import nf_cards

    ##############
##### SET TEYAKU #####
    ##############

const
    sanbon_1* = SetTeyaku(
        name "Triplet",
        singles 4,
        triples 1,
        score 20
    )
    sanbon_2* = SetTeyaku(
        name "Triplet",
        singles 2,
        doubles 1,
        triples 1,
        score 20
    )
    tatesanbon_1* = SetTeyaku(
        name "Special Triplet",
        singles 4,
        special_triples 1,
        score 30
    )
    tatesanbon_2* = SetTeyaku(
        name "Special Triplet",
        singles 2,
        doubles 1,
        special_triples 1,
        score 30
    )

    futasanbon* = SetTeyaku(
        name "Two Triplets",
        singles 1,
        triples 2,
        score 60
    )
    sanbon_tatesanbon* = SetTeyaku(
        name "Triplet and Special Triplet",
        singles 1,
        triples 1,
        special_triples 1,
        score 70
    )
    futatatesanbon* = SetTeyaku(
        name "Two Special Triplets",
        singles 1,
        special_triples 2
        score 80
    )

    kuttsuki* = SetTeyaku(
        name "Three Pairs",
        singles 1,
        doubles 3,
        score 40
    )
    haneken_1* = SetTeyaku(
        name "Triplet and Two Pairs",
        doubles 2,
        triples 1,
        score 70
    )
        haneken_2* = SetTeyaku(
        name "Triplet and Two Pairs",
        doubles 2,
        special_triples 1,
        score 70
    )

    teshi* = SetTeyaku(
        name "Four of a Kind",
        singles 3,
        quads 1,
        score 60
    )
    ichinishi* = SetTeyaku(
        name "One Two Four",
        singles 1,
        doubles 1,
        quads 1,
        score 80
    )
    shisou_1* = SetTeyaku(
        name "Four Three",
        triples 1,
        quads 1,
        score 200
    )
    shisou_2* = SetTeyaku(
        name "Four Three",
        special_triples 1,
        quads 1,
        score 200
    )


    ################
##### CHAFF TEYAKU #####
    ################

const
    aka_1* = ChaffTeyaku(
        name "Ribbons and Chaff",
        chaff 5,
        ribbons 2,
        score 20
    )
    aka_2* = ChaffTeyaku(
        name "Ribbons and Chaff",
        chaff 4,
        ribbons 3,
        score 20
    )
    aka_3* = ChaffTeyaku(
        name "Ribbons and Chaff",
        chaff 3,
        ribbons 4,
        score 20
    )
    aka_4* = ChaffTeyaku(
        name "Ribbons and Chaff",
        chaff 2,
        ribbons 5,
        score 20
    )
    aka_5* = ChaffTeyaku(
        name "Ribbons and Chaff",
        chaff 1,
        ribbons 6,
        score 20
    )
    aka_6* = ChaffTeyaku(
        name "All Ribbons",
        ribbons 7,
        score 20
    )

    tan_ichi* = ChaffTeyaku(
        name "One Ribbon",
        chaff 6,
        ribbons 1,
        score 30
    )
    to_ichi* = ChaffTeyaku(
        name "One Animal",
        chaff 6,
        animals 1,
        score 30
    )
    pika_ichi* = ChaffTeyaku(
        name "One Bright",
        chaff 6,
        brights 1,
        score 40
    )
    karasu* = ChaffTeyaku(
        name "Empty Hand",
        chaff 7,
        score 40
    )

    ##################
##### SHIMA DEKIYAKU #####
    ##################

const
    matsushima* = Dekiyaku(
        name: "Four Pines",
        cards_group_1: @[pine_bright, pine_ribbon, pine_chaff_1, pine_chaff_2],
        num_group_1: 4
    )
    umeshima* = Dekiyaku(
        name: "Four Plums",
        cards_group_1: @[plum_bright, plum_ribbon, plum_chaff_1, plum_chaff_2],
        num_group_1: 4
    )
    sakurashima* = Dekiyaku(
        name: "Four Cherries",
        cards_group_1: @[cherry_bright, cherry_ribbon, cherry_chaff_1, cherry_chaff_2],
        num_group_1: 4
    )
    fujishima* = Dekiyaku(
        name: "Four Wisterias",
        cards_group_1: @[wisteria_animal, wisteria_ribbon, wisteria_chaff_1, wisteria_chaff_2],
        num_group_1: 4
    )
    ayameshima* = Dekiyaku(
        name: "Four Irises",
        cards_group_1: @[iris_animal, iris_ribbon, iris_chaff_1, iris_chaff_2],
        num_group_1: 4
    )
    botanshima* = Dekiyaku(
        name: "Four Peonies",
        cards_group_1: @[peony_animal, peony_animal, peony_chaff_1, peony_chaff_2],
        num_group_1: 4
    )
    hagishima* = Dekiyaku(
        name: "Four Clovers",
        cards_group_1: @[clover_animal, clover_ribbon, clover_chaff_1, clover_chaff_2],
        num_group_1: 4
    )
    susukishima* = Dekiyaku(
        name: "Four Grasses",
        cards_group_1: @[grass_bright, grass_animal, grass_chaff_1, grass_chaff_2],
        num_group_1: 4
    )
    kikushima* = Dekiyaku(
        name: "Four Chrysanthemums",
        cards_group_1: @[mum_animal, mum_ribbon, mum_chaff_1, mum_chaff_2],
        num_group_1: 4
    )
    momijishima* = Dekiyaku(
        name: "Four Maples",
        cards_group_1: @[maple_animal, maple_ribbon, maple_chaff_1, maple_chaff_2],
        num_group_1: 4
    )
    yanagishima* = Dekiyaku(
        name: "Four Willows",
        cards_group_1: @[willow_bright, willow_animal, willow_ribbon, willow_chaff],
        num_group_1: 4
    )
    kirishima* = Dekiyaku(
        name: "Four Paulownias",
        cards_group_1: @[paulownia_bright, paulownia_chaff_1, paulownia_chaff_2, paulownia_chaff_3],
        num_group_1: 4
    )

    ###################
##### COMMON DEKIYAKU #####
    ###################

const
    gokou* = Dekiyaku
        name "Five Brights"