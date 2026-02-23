
import nf_types
import nf_cards
import nf_yaku

const
    bakappana* = RuleSet(
        name: "Bakappana",
        num_players: 3,
        num_cards_hand: 7,
        num_cards_field: 6,
        point_values: "1, 5, 10, 20"
    )

    mushi* = RuleSet(
        name: "Mushi",
        num_players: 2,
        num_cards_hand: 8,
        num_cards_field: 8,
        wild_card: willow_chaff,
        wild_card_rules: "Osaka style",
        yaku_set: yaku_table_mushi,
        zero_sum: true,
        cards_stripped: @[
            peony_animal, 
            peony_ribbon,
            peony_chaff_1,
            peony_chaff_2,
            clover_animal,
            clover_ribbon,
            clover_chaff_1,
            clover_chaff_2
        ],
        point_values: "1, 5, 10, 20"
    )

    ropyakken* = RuleSet(
        name: "Ropyakken",
        num_players: 2,
        num_cards_hand: 8,
        num_cards_field: 8,
        target_score: 600,
        wild_card: willow_bright,
        wild_card_rules: "Six Hundred Style",
        yaku_set: yaku_table_ropyakken,
        point_values: "0, 10, 10, 50"
    )

    hachi* = RuleSet(
        name: "Hachi",
        num_players: 2,
        num_cards_hand: 7,
        num_cards_field: 6,
        hachi_matching = true,
        yaku_set: yaku_table_hachi,
        point_values: "10, 1, 10, 10"
    )