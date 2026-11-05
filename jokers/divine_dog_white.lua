SMODS.Atlas({
    key = "shiro_atlas",
    path = "shiro.png", -- Needs a 71x95 sprite named shiro.png
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "shiro",
    name = "Shiro",
    atlas = "shiro_atlas",
    pos = {x = 0, y = 0},
    rarity = 1, -- Common
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { chips = 30, pair_bonus = 20 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.pair_bonus } }
    end,
    
    loc_txt = {
        name = 'Shiro',
        text = {
            "{C:chips}+#1#{} Chips.",
            "If played hand contains",
            "a {C:attention}Pair{}, gain an extra",
            "{C:chips}+#2#{} Chips for that hand."
        }
    },
    
    calculate = function(self, card, context)
        if context.joker_main then
            local total_chips = card.ability.extra.chips
            if context.scoring_name == "Pair" or context.scoring_name == "Two Pair" or context.scoring_name == "Full House" then
                total_chips = total_chips + card.ability.extra.pair_bonus
            end
            return {
                message = '+' .. total_chips .. ' Chips',
                chips = total_chips
            }
        end
    end
})