SMODS.Atlas({
    key = "kurama_atlas",
    path = "nine_tails.png", -- Needs a 71x95 sprite named nine_tails.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "nine_tails",
    name = "Nine-Tails",
    atlas = "kurama_atlas",
    pos = {x = 0, y = 0},
    rarity = 4, -- Legendary
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    soul_pos = { x = 1, y = 0 }, -- Allows it to naturally spawn from The Soul card!
    
    config = { extra = { retriggers = 9 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retriggers } }
    end,
    
    loc_txt = {
        name = 'Nine-Tails',
        text = {
            "Retriggers the {C:attention}last card{}",
            "scored in played hand",
            "an extra {C:attention}#1#{} times"
        }
    },
    
    calculate = function(self, card, context)
        -- Trigger retrigger only on the final card of the scoring hand
        if context.repetition and context.cardarea == G.play then
            -- Check if this specific card is the last card in the active scoring hand array
            if context.scoring_hand and context.other_card == context.scoring_hand[#context.scoring_hand] then
                return {
                    message = '9 Tails!',
                    repetitions = card.ability.extra.retriggers,
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end
})