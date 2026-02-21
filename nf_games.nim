
import nf_types
import nf_cards

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
        wild_cards: @[willow_chaff],
        wild_card_rules: "Mushi",
        yaku_set: @[],
        point_values: "1, 5, 10, 20"
    )