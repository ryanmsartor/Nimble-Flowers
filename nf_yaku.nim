# contains yaku and teyaku constants

import nf_types
import nf_cards

const
    sanbon_1* = SetTeyaku(
        name*: "Triplet",
        singles*: 4,
        triples*: 1,
        score*: 20
    )
    sanbon_2* = SetTeyaku(
        name*: "Triplet",
        singles*: 2,
        doubles*: 1,
        triples*: 1,
        score*: 20
    )
    tatesanbon_1* = SetTeyaku(
        name*: "Special Triplet",
        singles*: 4,
        special_triples*: 1,
        score*: 30
    )
    tatesanbon_2* = SetTeyaku(
        name*: "Special Triplet",
        singles*: 2,
        doubles*: 1,
        special_triples*: 1,
        score*: 30
    )

    futasanbon* = SetTeyaku(
        name*: "Two Triplets",
        singles*: 1,
        triples*: 2,
        score*: 60
    )
    sanbon_tatesanbon* = SetTeyaku(
        name*: "Triplet and Special Triplet",
        singles*: 1,
        triples*: 1,
        special_triples*: 1,
        score*: 70
    )
    futatatesanbon* = SetTeyaku(
        name*: "Two Special Triplets",
        singles*: 1,
        special_triples*: 2
        score*: 80
    )

    kuttsuki* = SetTeyaku(
        name*: "Three Pairs",
        singles*: 1,
        doubles*: 3,
        score*: 40
    )
    haneken_1* = SetTeyaku(
        name*: "Triplet and Two Pairs",
        doubles*: 2,
        triples*: 1,
        score*: 70
    )
        haneken_2* = SetTeyaku(
        name*: "Triplet and Two Pairs",
        doubles*: 2,
        special_triples*: 1,
        score*: 70
    )

    teshi* = SetTeyaku(
        name*: "Four of a Kind",
        singles*: 3,
        quads*: 1,
        score*: 60
    )
    ichinishi* = SetTeyaku(
        name*: "One Two Four",
        singles*: 1,
        doubles*: 1,
        quads*: 1,
        score*: 80
    )
    shisou_1* = SetTeyaku(
        name*: "Four Three",
        triples*: 1,
        quads*: 1,
        score*: 200
    )
        shisou_2* = SetTeyaku(
        name*: "Four Three",
        special_triples*: 1,
        quads*: 1,
        score*: 200
    )