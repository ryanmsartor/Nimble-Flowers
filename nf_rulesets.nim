
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
        yaku_set: @[
            gokou,
            oozan,
            fujishima,
            kirishima
        ],
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