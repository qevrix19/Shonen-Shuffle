SMODS.Atlas({
    key = "nue_atlas",
    path = "nue.png", -- Make sure you have a 71x95 sprite named nue.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "nue",
    name = "Nue",
    atlas = "nue_atlas",
    pos = {x = 0, y = 0},
    rarity = 1, -- Uncommon (or adjust rarity as needed)
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    
    config = { extra = { sell_bonus = 4 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sell_bonus } }
    end,
    
    loc_txt = {
        name = 'Nue',
        text = {
            "Gains {C:money}$#1#{} of sell",
            "value at the end of",
            "each round."
        }
    },
    
    calculate = function(self, card, context)
        -- Triggers once per round end, preventing multi-pass duplicate triggers
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            -- Increase sell value cleanly
            card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.sell_bonus
            card:set_cost()
            card:juice_up(1.1, 1.1)
            
            return {
                message = '+$4',
                colour = G.C.MONEY
            }
        end
    end
})