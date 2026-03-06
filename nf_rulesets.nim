
import nf_common
import nf_cards
import nf_yaku

const
    bakappana* = RuleSet(
        name: fg_pine & "Bakappana" & fg_reset,
        num_players: 3,
        num_cards_hand: 7,
        num_cards_field: 6,
        point_values: "1, 5, 10, 20",
        suit_system: "standard",
        num_rounds: 3
    )

    mushi* = RuleSet(
        name: fg_plum & "Mushi" & fg_reset,
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
        point_values: "1, 5, 10, 20",
        suit_system: "mushi",
        num_rounds: 3
    )

    ropyakken* = RuleSet(
        name: fg_cherry & "Ropyakken" & fg_reset,
        num_players: 2,
        num_cards_hand: 8,
        num_cards_field: 8,
        target_score: 600,
        wild_card: willow_bright,
        wild_card_rules: "Six Hundred Style",
        yaku_set: yaku_table_ropyakken,
        point_values: "0, 10, 10, 50",
        suit_system: "standard"
    )

    hachi* = RuleSet(
        name: fg_wisteria & "Hachi" & fg_reset,
        num_players: 2,
        num_cards_hand: 7,
        num_cards_field: 6,
        hachi_matching: true,
        yaku_set: yaku_table_hachi,
        point_values: "10, 1, 10, 10",
        suit_system: "standard",
        num_rounds: 3
    )