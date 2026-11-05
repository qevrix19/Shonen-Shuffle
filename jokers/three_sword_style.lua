SMODS.Atlas({
    key = "zoro_atlas",
    path = "zoro.png", -- Needs a 71x95 sprite named zoro.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "three_sword_style",
    name = "Three-Sword Style",
    atlas = "zoro_atlas",
    pos = {x = 0, y = 0},
    rarity = 1, -- Common
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { chips = 0, chip_gain = 30 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
    end,
    
    loc_txt = {
        name = 'Three-Sword Style',
        text = {
            "Gains {C:chips}+#2#{} Chips for",
            "each scored {C:spades}Spade{} card",
            "played",
            "{C:inactive}(Currently {C:chips}+#1#{} Chips){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Scale chips when individual Spade cards score
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Spades') then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                return {
                    extra = {message = '+30 Chips', colour = G.C.CHIPS},
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end

        -- 2. Add accumulated chips during main scoring
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
    end
})