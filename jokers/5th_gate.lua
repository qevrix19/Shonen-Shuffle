SMODS.Atlas({
    key = "rock_lee_atlas",
    path = "rock_lee.png", -- Needs a 71x95 sprite named rock_lee.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "rock_lee_5th_gate",
    name = "5th Gate",
    atlas = "rock_lee_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { chips = 0, chip_gain = 50 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,

    loc_txt = {
        name = "5th Gate",
        text = {
            "Gains {C:chips}+#1#{} Chips per",
            "played hand.",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips){}"
        }
    },

    calculate = function(self, card, context)
        -- 1. Main Joker Scoring (Apply Chips)
        if context.joker_main then
            if card.ability.extra.chips > 0 then
                return {
                    message = '+' .. card.ability.extra.chips .. ' Chips',
                    chips = card.ability.extra.chips,
                    colour = G.C.CHIPS
                }
            end
        end

        -- 2. Scale chips after every played hand
        if context.after and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            card:juice_up(0.5, 0.5)
            
            return {
                message = 'Front Lotus!',
                colour = G.C.CHIPS,
                card = card
            }
        end
    end
})