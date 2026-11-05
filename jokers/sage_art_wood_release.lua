SMODS.Atlas({
    key = "hashirama_atlas",
    path = "hashirama.png", -- Needs a 71x95 sprite named hashirama.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "sage_art_wood_release",
    name = "Sage Art: Wood Release",
    atlas = "hashirama_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { mult = 0, mult_gain = 6, chips = 0, chip_gain = 50 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips, card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,

    loc_txt = {
        name = "Sage Art: Wood Release",
        text = {
            "If played hand is a {C:attention}Full House{}",
            "or {C:attention}Three of a Kind{}, gain",
            "{C:chips}+#1#{} Chips and {C:mult}+#3#{} Mult",
            "{C:inactive}(Currently {C:chips}+#2# Chips{C:inactive}, {C:mult}+#4# Mult{C:inactive})"
        }
    },

    calculate = function(self, card, context)
        -- 1. Main Joker Scoring (Apply both Chips and Flat Mult)
        if context.joker_main then
            return {
                message = 'Wood Style!',
                chips = card.ability.extra.chips > 0 and card.ability.extra.chips or nil,
                mult = card.ability.extra.mult > 0 and card.ability.extra.mult or nil,
                colour = G.C.CHIPS
            }
        end

        -- 2. Scaling stats after scoring the hand
        if context.after and not context.blueprint then
            if context.scoring_name == "Full House" or context.scoring_name == "Three of a Kind" then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain

                card:juice_up(0.7, 0.7)
                return {
                    message = 'Grow!',
                    colour = G.C.GREEN,
                    card = card
                }
            end
        end
    end
})