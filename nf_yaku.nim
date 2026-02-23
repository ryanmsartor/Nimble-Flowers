# contains yaku and teyaku constants

import nf_types
import nf_cards
import std/tables

#   ##############   #
##### SET TEYAKU #####
#   ##############   #

const
    sanbon_1* = SetTeyaku(
        name: "Triplet",
        singles: 4,
        triples: 1,
        score: 20
    )
    sanbon_2* = SetTeyaku(
        name: "Triplet",
        singles: 2,
        doubles: 1,
        triples: 1,
        score: 20
    )
    tatesanbon_1* = SetTeyaku(
        name: "Special Triplet",
        singles: 4,
        special_triples: 1,
        score: 30
    )
    tatesanbon_2* = SetTeyaku(
        name: "Special Triplet",
        singles: 2,
        doubles: 1,
        special_triples: 1,
        score: 30
    )

    futasanbon* = SetTeyaku(
        name: "Two Triplets",
        singles: 1,
        triples: 2,
        score: 60
    )
    sanbon_tatesanbon* = SetTeyaku(
        name: "Triplet and Special Triplet",
        singles: 1,
        triples: 1,
        special_triples: 1,
        score: 70
    )
    futatatesanbon* = SetTeyaku(
        name: "Two Special Triplets",
        singles: 1,
        special_triples: 2,
        score: 80
    )

    kuttsuki* = SetTeyaku(
        name: "Three Pairs",
        singles: 1,
        doubles: 3,
        score: 40
    )
    haneken_1* = SetTeyaku(
        name: "Triplet and Two Pairs",
        doubles: 2,
        triples: 1,
        score: 70
    )
    haneken_2* = SetTeyaku(
        name: "Triplet and Two Pairs",
        doubles: 2,
        special_triples: 1,
        score: 70
    )

    teshi* = SetTeyaku(
        name: "Four of a Kind",
        singles: 3,
        quads: 1,
        score: 60
    )
    ichinishi* = SetTeyaku(
        name: "One Two Four",
        singles: 1,
        doubles: 1,
        quads: 1,
        score: 80
    )
    shisou_1* = SetTeyaku(
        name: "Four Three",
        triples: 1,
        quads: 1,
        score: 200
    )
    shisou_2* = SetTeyaku(
        name: "Four Three",
        special_triples: 1,
        quads: 1,
        score: 200
    )


#   ################   #
##### CHAFF TEYAKU #####
#   ################   #

const
    aka_1* = ChaffTeyaku(
        name: "Ribbons and Chaff",
        chaff: 5,
        ribbons: 2,
        score: 20
    )
    aka_2* = ChaffTeyaku(
        name: "Ribbons and Chaff",
        chaff: 4,
        ribbons: 3,
        score: 20
    )
    aka_3* = ChaffTeyaku(
        name: "Ribbons and Chaff",
        chaff: 3,
        ribbons: 4,
        score: 20
    )
    aka_4* = ChaffTeyaku(
        name: "Ribbons and Chaff",
        chaff: 2,
        ribbons: 5,
        score: 20
    )
    aka_5* = ChaffTeyaku(
        name: "Ribbons and Chaff",
        chaff: 1,
        ribbons: 6,
        score: 20
    )
    aka_6* = ChaffTeyaku(
        name: "All Ribbons",
        ribbons: 7,
        score: 20
    )

    tan_ichi* = ChaffTeyaku(
        name: "One Ribbon",
        chaff: 6,
        ribbons: 1,
        score: 30
    )
    to_ichi* = ChaffTeyaku(
        name: "One Animal",
        chaff: 6,
        animals: 1,
        score: 30
    )
    pika_ichi* = ChaffTeyaku(
        name: "One Bright",
        chaff: 6,
        brights: 1,
        score: 40
    )
    karasu* = ChaffTeyaku(
        name: "Empty Hand",
        chaff: 7,
        score: 40
    )

#   ##################   #
##### SHIMA DEKIYAKU #####
#   ##################   #

const
    matsushima* = Dekiyaku(
        name: "Four Pines",
        cards_group_1: @[pine_bright, pine_ribbon, pine_chaff_1, pine_chaff_2],
        num_group_1: 4
    )
    umeshima* = Dekiyaku(
        name: "Four Plums",
        cards_group_1: @[plum_animal, plum_ribbon, plum_chaff_1, plum_chaff_2],
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

#   ###################   #
##### COMMON DEKIYAKU #####
#   ###################   #

const
    gokou* = Dekiyaku(
        name: "Five Brights",
        exclusivity_group: "brights",
        cards_group_1: @[
            pine_bright,
            cherry_bright,
            grass_bright,
            willow_bright,
            paulownia_bright
        ],
        num_group_1: 5
    )
    shikou* = Dekiyaku(
        name: "Four Brights",
        exclusivity_group: "brights",
        cards_group_1: @[
            pine_bright,
            cherry_bright,
            grass_bright,
            willow_bright,
            paulownia_bright
        ],
        num_group_1: 4
    )
    ame_shikou* = Dekiyaku(
        name: "Rainy Four Brights",
        exclusivity_group: "brights",
        cards_group_1: @[
            pine_bright,
            cherry_bright,
            grass_bright,
            paulownia_bright
        ],
        num_group_1: 3,
        cards_group_2: @[
            willow_bright
        ],
        num_group_2: 1
    )
    sankou* = Dekiyaku(
        name: "Four Brights",
        exclusivity_group: "brights",
        cards_group_1: @[
            pine_bright,
            cherry_bright,
            grass_bright,
            willow_bright,
            paulownia_bright
        ],
        num_group_1: 3
    )

    oozan* = Dekiyaku(
        name: "Big Three",
        cards_group_1: @[
            pine_bright,
            plum_animal,
            cherry_bright
        ],
        num_group_1: 3
    )
    matsukiribouzu* = Dekiyaku(
        name: "Pine, Paulownia, Baldy",
        cards_group_1: @[
            pine_bright,
            paulownia_bright,
            grass_bright
        ],
        num_group_1: 3
    )
    inoshikachou* = Dekiyaku(
        name: "Boar, Deer, Butterflies",
        cards_group_1: @[
            clover_animal,
            maple_animal,
            peony_animal
        ],
        num_group_1: 3
    )

    nanatan* = Dekiyaku(
        name: "Seven Ribbons",
        cards_group_1: @[
            pine_ribbon,
            plum_ribbon,
            cherry_ribbon,
            wisteria_ribbon,
            iris_ribbon,
            peony_ribbon,
            clover_ribbon,
            mum_ribbon,
            maple_ribbon,
            willow_ribbon
        ],
        num_group_1: 7
    )
    akatan* = Dekiyaku(
        name: "Poetry Ribbons",
        cards_group_1: @[
            pine_ribbon,
            plum_ribbon,
            cherry_ribbon
        ],
        num_group_1: 3
    )
    aotan* = Dekiyaku(
        name: "Blue Ribbons",
        cards_group_1: @[
            peony_ribbon,
            mum_ribbon,
            maple_ribbon
        ],
        num_group_1: 3
    )
    kusatan* = Dekiyaku(
        name: "Grass Ribbons",
        cards_group_1: @[
            wisteria_ribbon,
            iris_ribbon,
            clover_ribbon
        ],
        num_group_1: 3
    )

    nomi* = Dekiyaku(
        name: "Drinking",
        exclusivity_group: "Sake",
        cards_group_1: @[
            mum_animal,
            grass_bright,
            cherry_bright
        ],
        num_group_1: 3
    )
    hanami* = Dekiyaku(
        name: "Flower Viewing",
        exclusivity_group: "Sake",
        cards_group_1: @[
            mum_animal,
            cherry_bright
        ],
        num_group_1: 2
    )
    tsukimi* = Dekiyaku(
        name: "Moon Viewing",
        exclusivity_group: "Sake",
        cards_group_1: @[
            mum_animal,
            grass_bright
        ],
        num_group_1: 2
    )


##### HACHI DEKIYAKU #####
const
    hi_12_4_11* = Dekiyaku(
        name: "Mist Island",
        cards_group_1: @[
            paulownia_bright,
            wisteria_animal,
            willow_bright
        ],
        num_group_1: 3
    )
    lo_12_4_11* = Dekiyaku(
        name: "Mist Island Ribbons",
        cards_group_1: @[
            paulownia_chaff_1,
            wisteria_ribbon,
            willow_ribbon
        ],
        num_group_1: 3
    )

    hi_5_6_10* = Dekiyaku(
        name: "Elder",
        cards_group_1: @[
            iris_animal,
            peony_animal,
            maple_animal
        ],
        num_group_1: 3
    )
    lo_5_6_10* = Dekiyaku(
        name: "Elder Ribbons",
        cards_group_1: @[
            iris_ribbon,
            peony_ribbon,
            maple_ribbon
        ],
        num_group_1: 3
    )

    hi_5_4_6* = Dekiyaku(
        name: "Five Four Six",
        cards_group_1: @[
            iris_animal,
            wisteria_animal,
            peony_animal
        ],
        num_group_1: 3
    )
    lo_5_4_6* = Dekiyaku(
        name: "Five Four Six Ribbons",
        cards_group_1: @[
            iris_ribbon,
            wisteria_ribbon,
            peony_ribbon
        ],
        num_group_1: 3
    )

    hi_7_5_3* = Dekiyaku(
        name: "Seven Five Three",
        cards_group_1: @[
            clover_animal,
            iris_animal,
            cherry_bright
        ],
        num_group_1: 3
    )
    lo_7_5_3* = Dekiyaku(
        name: "Seven Five Three Ribbons",
        cards_group_1: @[
            clover_ribbon,
            iris_ribbon,
            cherry_ribbon
        ],
        num_group_1: 3
    )

    hi_9_11_3* = Dekiyaku(
        name: "Kumano Shrines",
        cards_group_1: @[
            mum_animal,
            willow_bright,
            cherry_bright
        ],
        num_group_1: 3
    )
    lo_9_11_3* = Dekiyaku(
        name: "Kumano Shrine Ribbons",
        cards_group_1: @[
            mum_ribbon,
            willow_ribbon,
            cherry_ribbon
        ],
        num_group_1: 3
    )

    hi_8_4_11* = Dekiyaku(
        name: "Eight Islands",
        cards_group_1: @[
            grass_bright,
            wisteria_animal,
            willow_bright
        ],
        num_group_1: 3
    )
    lo_8_4_11* = Dekiyaku(
        name: "Eight Island Ribbons",
        cards_group_1: @[
            grass_animal,
            wisteria_ribbon,
            willow_ribbon
        ],
        num_group_1: 3
    )

    hi_7_8_9* = Dekiyaku(
        name: "Nakazou",
        cards_group_1: @[
            clover_animal,
            grass_bright,
            mum_animal
        ],
        num_group_1: 3
    )
    lo_7_8_9* = Dekiyaku(
        name: "Nakazou Ribbons",
        cards_group_1: @[
            clover_ribbon,
            grass_animal,
            mum_ribbon
        ],
        num_group_1: 3
    )

    hi_1_2_3* = oozan
    lo_1_2_3* = akatan

    hi_2_11_12* = Dekiyaku(
        name: "Den",
        cards_group_1: @[
            plum_animal,
            willow_bright,
            paulownia_bright
        ],
        num_group_1: 3
    )
    lo_2_11_12* = Dekiyaku(
        name: "Den Ribbons",
        cards_group_1: @[
            plum_ribbon,
            willow_ribbon,
            paulownia_chaff_1
        ],
        num_group_1: 3
    )

    hi_3_5_6* = Dekiyaku(
        name: "Three Five Six",
        cards_group_1: @[
            cherry_bright,
            iris_animal,
            peony_animal
        ],
        num_group_1: 3
    )
    lo_3_5_6* = Dekiyaku(
        name: "Three Five Six Ribbons",
        cards_group_1: @[
            cherry_ribbon,
            iris_ribbon,
            peony_ribbon
        ],
        num_group_1: 3
    )

    lo_10_7_8* = Dekiyaku(
        name: "Ten Seven Eight Ribbons",
        cards_group_1: @[
            maple_ribbon,
            clover_ribbon,
            grass_animal
        ],
        num_group_1: 3
    )


##### DEKIYAKU SCORING TABLES #####

const
    yaku_table_mushi* = {
        gokou: 30,
        oozan: 25,
        fujishima: 10,
        kirishima: 10
    }.toOrderedTable()

    yaku_table_shima* = {
        matsushima: 20,
        umeshima: 20,
        sakurashima: 20,
        fujishima: 20,
        ayameshima: 20,
        botanshima: 20,
        hagishima: 20,
        susukishima: 20,
        kikushima: 20,
        momijishima: 20,
        yanagishima: 20,
        kirishima: 20
    }.toOrderedTable()

    yaku_table_ropyakken* = {
        shikou: 600,
        matsukiribouzu: 150,
        oozan: 150,
        nanatan: 600,
        akatan: 100,
        aotan: 100,
        kusatan: 100,
        inoshikachou: 300,
        nomi: 300,
        hanami: 100,
        tsukimi: 100,
        yanagishima: 200,
        matsushima: 50,
        umeshima: 50,
        sakurashima: 50,
        fujishima: 50,
        susukishima: 50,
        momijishima: 50,
        kirishima: 50
    }.toOrderedTable()

    yaku_table_yamayaku* = {
        matsukiribouzu: 150,
        oozan: 100,
        akatan: 100,
        aotan: 100,
        kusatan: 100,
        inoshikachou: 300,
        nomi: 300,
        yanagishima: 200
    }.toOrderedTable()

    yaku_table_hachi* = {
        hi_12_4_11: 10,
        lo_12_4_11: 20,
        hi_5_6_10: 10,
        lo_5_6_10: 20,
        hi_5_4_6: 10,
        lo_5_4_6: 20,
        hi_7_5_3: 10,
        lo_7_5_3: 20,
        hi_9_11_3: 10,
        lo_9_11_3: 20,
        hi_8_4_11: 10,
        lo_8_4_11: 20,
        hi_7_8_9: 10,
        lo_7_8_9: 20,
        hi_1_2_3: 10,
        lo_1_2_3: 20,
        hi_2_11_12: 10,
        lo_2_11_12: 20,
        hi_3_5_6: 10,
        lo_3_5_6: 20,
        lo_10_7_8: 20
    }.toOrderedTable()