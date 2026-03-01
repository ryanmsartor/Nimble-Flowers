# imported by nimble_flowers.nim
# contains all hanafuda cards as constants

import nf_types

const
    edge* = " |=========| "
    blank* = " |\033[1m.........\033[0m| "

const
    pine_bright* = Card(
        full_name: "Pine with Crane",
        short_name: "Pine w/ Crane",
        alt_names: @[""],
        standard_suit: 1,
        mushi_suit: 1, 
        nagoya_suit: 1, 
        hachihachi_value: 20,
        hachi_value: 10,
        ropyakken_value: 50
    )
    pine_ribbon* = Card(
        full_name: "Pine with Poetry Ribbon",
        short_name: "Pine w/ P.Ribbon",
        alt_names: @[""],
        standard_suit: 1,
        mushi_suit: 1,
        nagoya_suit: 1,
        hachihachi_value: 5,
        hachi_value: 1,
        ropyakken_value: 10
    )
    pine_chaff_1* = Card(
        full_name: "Pine chaff",
        short_name: "Pine chaff",
        alt_names: @[""],
        standard_suit: 1,
        mushi_suit: 1,
        nagoya_suit: 1,
        hachihachi_value: 1,
        hachi_value: 10
    )
    pine_chaff_2* = Card(
        full_name: "Pine chaff",
        short_name: "Pine chaff",
        alt_names: @[""],
        standard_suit: 1,
        mushi_suit: 1,
        nagoya_suit: 1,
        hachihachi_value: 1,
        hachi_value: 10
    )

    plum_animal* = Card(
        full_name: "Plum Blossoms with Bush Warbler",
        short_name: "Plum w/ Warbler",
        alt_names: @[""],
        standard_suit: 2,
        mushi_suit: 2,
        nagoya_suit: 12,
        hachihachi_value: 10,
        hachi_value: 10,
        ropyakken_value: 50
    )
    plum_ribbon* = Card(
        full_name: "Plum Blossoms with Poetry Ribbon",
        short_name: "Plum w/ P.Ribbon",
        alt_names: @[""],
        standard_suit: 2,
        mushi_suit: 2,
        nagoya_suit: 12,
        hachihachi_value: 5,
        hachi_value: 1,
        ropyakken_value: 10
    )
    plum_chaff_1* = Card(
        full_name: "Plum Blossom chaff",
        short_name: "Plum chaff",
        alt_names: @[""],
        standard_suit: 2,
        mushi_suit: 2,
        nagoya_suit: 12,
        hachihachi_value: 1,
        hachi_value: 10
    )
    plum_chaff_2* = Card(
        full_name: "Plum Blossom chaff",
        short_name: "Plum chaff",
        alt_names: @[""],
        standard_suit: 2,
        mushi_suit: 2,
        nagoya_suit: 12,
        hachihachi_value: 1,
        hachi_value: 10
    )

    cherry_bright* = Card(
        full_name: "Cherry Blossoms with Curtain",
        short_name: "Cherry w/ Curtain",
        alt_names: @[""],
        standard_suit: 3,
        mushi_suit: 3, 
        nagoya_suit: 3, 
        hachihachi_value: 20,
        hachi_value: 10,
        ropyakken_value: 50
    )
    cherry_ribbon* = Card(
        full_name: "Cherry Blossoms with Poetry Ribbon",
        short_name: "Cherry w/ P.Ribbon",
        alt_names: @[""],
        standard_suit: 3,
        mushi_suit: 3,
        nagoya_suit: 3,
        hachihachi_value: 5,
        hachi_value: 1,
        ropyakken_value: 10
    )
    cherry_chaff_1* = Card(
        full_name: "Cherry Blossom chaff",
        short_name: "Cherry chaff",
        alt_names: @[""],
        standard_suit: 3,
        mushi_suit: 3,
        nagoya_suit: 3,
        hachihachi_value: 1,
        hachi_value: 10
    )
    cherry_chaff_2* = Card(
        full_name: "Cherry Blossom chaff",
        short_name: "Cherry chaff",
        alt_names: @[""],
        standard_suit: 3,
        mushi_suit: 3,
        nagoya_suit: 3,
        hachihachi_value: 1,
        hachi_value: 10
    )

    wisteria_animal* = Card(
        full_name: "Wisteria with Cuckoo",
        short_name: "Wisteria w/ Cuckoo",
        alt_names: @[""],
        standard_suit: 4,
        mushi_suit: 4,
        nagoya_suit: 4,
        hachihachi_value: 10,
        hachi_value: 10,
        ropyakken_value: 10
    )
    wisteria_ribbon* = Card(
        full_name: "Wisteria with Ribbon",
        short_name: "Wisteria w/ Ribbon",
        alt_names: @[""],
        standard_suit: 4,
        mushi_suit: 4,
        nagoya_suit: 4,
        hachihachi_value: 5,
        hachi_value: 1,
        ropyakken_value: 10
    )
    wisteria_chaff_1* = Card(
        full_name: "Wisteria chaff",
        short_name: "Wisteria chaff",
        alt_names: @[""],
        standard_suit: 4,
        mushi_suit: 4,
        nagoya_suit: 4,
        hachihachi_value: 1,
        hachi_value: 10
    )
    wisteria_chaff_2* = Card(
        full_name: "Wisteria chaff",
        short_name: "Wisteria chaff",
        alt_names: @[""],
        standard_suit: 4,
        mushi_suit: 4,
        nagoya_suit: 4,
        hachihachi_value: 1,
        hachi_value: 10
    )

    iris_animal* = Card(
        full_name: "Iris with 8-Plank Bridge",
        short_name: "Iris w/ Bridge",
        alt_names: @[""],
        standard_suit: 5,
        mushi_suit: 5,
        nagoya_suit: 5,
        hachihachi_value: 10,
        hachi_value: 10,
        ropyakken_value: 10
    )
    iris_ribbon* = Card(
        full_name: "Iris with Ribbon",
        short_name: "Iris w/ Ribbon",
        alt_names: @[""],
        standard_suit: 5,
        mushi_suit: 5,
        nagoya_suit: 5,
        hachihachi_value: 5,
        hachi_value: 1,
        ropyakken_value: 10
    )
    iris_chaff_1* = Card(
        full_name: "Iris chaff",
        short_name: "Iris chaff",
        alt_names: @[""],
        standard_suit: 5,
        mushi_suit: 5,
        nagoya_suit: 5,
        hachihachi_value: 1,
        hachi_value: 10
    )
    iris_chaff_2* = Card(
        full_name: "Iris chaff",
        short_name: "Iris chaff",
        alt_names: @[""],
        standard_suit: 5,
        mushi_suit: 5,
        nagoya_suit: 5,
        hachihachi_value: 1,
        hachi_value: 10
    )

    peony_animal* = Card(
        full_name: "Peony with Butterflies",
        short_name: "Peony w/ Butterflies",
        alt_names: @[""],
        standard_suit: 6,
        nagoya_suit: 11,
        hachihachi_value: 10,
        hachi_value: 10,
        ropyakken_value: 10
    )
    peony_ribbon* = Card(
        full_name: "Peony with Blue Ribbon",
        short_name: "Peony w/ B.Ribbon",
        alt_names: @[""],
        standard_suit: 6,
        nagoya_suit: 11,
        hachihachi_value: 5,
        hachi_value: 1,
        ropyakken_value: 10
    )
    peony_chaff_1* = Card(
        full_name: "Peony chaff",
        short_name: "Peony chaff",
        alt_names: @[""],
        standard_suit: 6,
        nagoya_suit: 11,
        hachihachi_value: 1,
        hachi_value: 10
    )
    peony_chaff_2* = Card(
        full_name: "Peony chaff",
        short_name: "Peony chaff",
        alt_names: @[""],
        standard_suit: 6,
        nagoya_suit: 11,
        hachihachi_value: 1,
        hachi_value: 10
    )

    clover_animal* = Card(
        full_name: "Bush Clover with Boar",
        short_name: "Clover w/ Boar",
        alt_names: @[""],
        standard_suit: 7,
        nagoya_suit: 7,
        hachihachi_value: 10,
        hachi_value: 10,
        ropyakken_value: 10
    )
    clover_ribbon* = Card(
        full_name: "Bush Clover with Ribbon",
        short_name: "Clover w/ Ribbon",
        alt_names: @[""],
        standard_suit: 7,
        nagoya_suit: 7,
        hachihachi_value: 5,
        hachi_value: 1,
        ropyakken_value: 10
    )
    clover_chaff_1* = Card(
        full_name: "Bush Clover chaff",
        short_name: "Clover chaff",
        alt_names: @[""],
        standard_suit: 7,
        nagoya_suit: 7,
        hachihachi_value: 1,
        hachi_value: 10
    )
    clover_chaff_2* = Card(
        full_name: "Bush Clover chaff",
        short_name: "Clover chaff",
        alt_names: @[""],
        standard_suit: 7,
        nagoya_suit: 7,
        hachihachi_value: 1,
        hachi_value: 10
    )

    grass_bright* = Card(
        full_name: "Silvergrass with Full Moon",
        short_name: "Hills w/ Moon",
        alt_names: @[""],
        standard_suit: 8,
        mushi_suit: 8, 
        nagoya_suit: 8, 
        hachihachi_value: 20,
        hachi_value: 10,
        ropyakken_value: 50
    )
    grass_animal* = Card(
        full_name: "Silvergrass with Geese",
        short_name: "Hills w/ Geese",
        alt_names: @[""],
        standard_suit: 8,
        mushi_suit: 8,
        nagoya_suit: 8,
        hachihachi_value: 10,
        hachi_value: 10,
        ropyakken_value: 10
    )
    grass_chaff_1* = Card(
        full_name: "Silvergrass chaff",
        short_name: "Hills chaff",
        alt_names: @[""],
        standard_suit: 8,
        mushi_suit: 8,
        nagoya_suit: 8,
        hachihachi_value: 1,
        hachi_value: 10
    )
    grass_chaff_2* = Card(
        full_name: "Silvergrass chaff",
        short_name: "Hills chaff",
        alt_names: @[""],
        standard_suit: 8,
        mushi_suit: 8,
        nagoya_suit: 8,
        hachihachi_value: 1,
        hachi_value: 10
    )

    mum_animal* = Card(
        full_name: "Chrysanthemums with Sake Cup",
        short_name: "Mums w/ Sake Cup",
        alt_names: @[""],
        standard_suit: 9,
        mushi_suit: 9,
        nagoya_suit: 9,
        hachihachi_value: 10,
        hachi_value: 10,
        ropyakken_value: 10
    )
    mum_ribbon* = Card(
        full_name: "Chrysanthemums with Blue Ribbon",
        short_name: "Mums w/ B.Ribbon",
        alt_names: @[""],
        standard_suit: 9,
        mushi_suit: 9,
        nagoya_suit: 9,
        hachihachi_value: 5,
        hachi_value: 1,
        ropyakken_value: 10
    )
    mum_chaff_1* = Card(
        full_name: "Chrysanthemum chaff",
        short_name: "Mums chaff",
        alt_names: @[""],
        standard_suit: 9,
        mushi_suit: 9,
        nagoya_suit: 9,
        hachihachi_value: 1,
        hachi_value: 10
    )
    mum_chaff_2* = Card(
        full_name: "Chrysanthemum chaff",
        short_name: "Mums chaff",
        alt_names: @[""],
        standard_suit: 9,
        mushi_suit: 9,
        nagoya_suit: 9,
        hachihachi_value: 1,
        hachi_value: 10
    )

    maple_animal* = Card(
        full_name: "Maple Tree with Deer",
        short_name: "Maple w/ Deer",
        alt_names: @[""],
        standard_suit: 10,
        mushi_suit: 10,
        nagoya_suit: 10,
        hachihachi_value: 10,
        hachi_value: 10,
        ropyakken_value: 10
    )
    maple_ribbon* = Card(
        full_name: "Maple Leaves with Blue Ribbon",
        short_name: "Maple w/ B. Ribbon",
        alt_names: @[""],
        standard_suit: 10,
        mushi_suit: 10,
        nagoya_suit: 10,
        hachihachi_value: 5,
        hachi_value: 1,
        ropyakken_value: 10
    )
    maple_chaff_1* = Card(
        full_name: "Maple chaff",
        short_name: "Maple chaff",
        alt_names: @[""],
        standard_suit: 10,
        mushi_suit: 10,
        nagoya_suit: 10,
        hachihachi_value: 1,
        hachi_value: 10
    )
    maple_chaff_2* = Card(
        full_name: "Maple chaff",
        short_name: "Maple chaff",
        alt_names: @[""],
        standard_suit: 10,
        mushi_suit: 10,
        nagoya_suit: 10,
        hachihachi_value: 1,
        hachi_value: 10
    )

    willow_bright* = Card(
        full_name: "Willow with Calligrapher",
        short_name: "Willow w/ Rain Man",
        alt_names: @[""],
        standard_suit: 11,
        mushi_suit: 6,
        nagoya_suit: 2,
        hachihachi_value: 20,
        hachi_value: 10,
        ropyakken_value: 50
    )
    willow_animal* = Card(
        full_name: "Willow with Swallow",
        short_name: "Willow w/ Swallow",
        alt_names: @[""],
        standard_suit: 11,
        mushi_suit: 6,
        nagoya_suit: 2,
        hachihachi_value: 10,
        hachi_value: 10,
        ropyakken_value: 10
    )
    willow_ribbon* = Card(
        full_name: "Willow with Ribbon",
        short_name: "Willow w/ Ribbon",
        alt_names: @[""],
        standard_suit: 11,
        mushi_suit: 6,
        nagoya_suit: 2,
        hachihachi_value: 5,
        hachi_value: 1,
        ropyakken_value: 10
    )
    willow_chaff* = Card(
        full_name: "Willow with Lightning",
        short_name: "Willow w/ Lightning",
        alt_names: @[""],
        standard_suit: 11,
        mushi_suit: 6,
        nagoya_suit: 2,
        hachihachi_value: 1,
        hachi_value: 10
    )

    paulownia_bright* = Card(
        full_name: "Paulownia with Phoenix",
        short_name: "Paulownia w/ Phoenix",
        alt_names: @[""],
        standard_suit: 12,
        mushi_suit: 7,
        nagoya_suit: 6,
        hachihachi_value: 20,
        hachi_value: 10,
        ropyakken_value: 50
    )
    paulownia_chaff_1* = Card(
        full_name: "Paulownia with yellow chaff",
        short_name: "Yellow Paulownia",
        alt_names: @[""],
        standard_suit: 12,
        mushi_suit: 7,
        nagoya_suit: 6,
        hachihachi_value: 1,
        hachi_value: 10,
        ropyakken_value: 10
    )
    paulownia_chaff_2* = Card(
        full_name: "Paulownia chaff",
        short_name: "Paulownia chaff",
        alt_names: @[""],
        standard_suit: 12,
        mushi_suit: 7,
        nagoya_suit: 6,
        hachihachi_value: 1,
        hachi_value: 10
    )
    paulownia_chaff_3* = Card(
        full_name: "Paulownia chaff",
        short_name: "Paulownia chaff",
        alt_names: @[""],
        standard_suit: 12,
        mushi_suit: 7,
        nagoya_suit: 6,
        hachihachi_value: 1,
        hachi_value: 10
    )

    full_deck*: Zone = @[
        pine_bright, pine_ribbon, pine_chaff_1, pine_chaff_2,
        plum_animal, plum_ribbon, plum_chaff_1, plum_chaff_2,
        cherry_bright, cherry_ribbon, cherry_chaff_1, cherry_chaff_2,
        wisteria_animal, wisteria_ribbon, wisteria_chaff_1, wisteria_chaff_2,
        iris_animal, iris_ribbon, iris_chaff_1, iris_chaff_2,
        peony_animal, peony_ribbon, peony_chaff_1, peony_chaff_2,
        clover_animal, clover_ribbon, clover_chaff_1, clover_chaff_2,
        grass_bright, grass_animal, grass_chaff_1, grass_chaff_2,
        mum_animal, mum_ribbon, mum_chaff_1, mum_chaff_2,
        maple_animal, maple_ribbon, maple_chaff_1, maple_chaff_2,
        willow_bright, willow_animal, willow_ribbon, willow_chaff,
        paulownia_bright, paulownia_chaff_1, paulownia_chaff_2, paulownia_chaff_3
    ]