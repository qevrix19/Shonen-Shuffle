SMODS.Atlas({
    key = "jinwoo_atlas",
    path = "sung_jinwoo.png", -- Needs a 71x95 sprite named sung_jinwoo.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "shadow_monarch",
    name = "Shadow Monarch",
    atlas = "jinwoo_atlas",
    pos = {x = 0, y = 0},
    rarity = 4, -- Legendary
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    soul_pos = { x = 1, y = 0 }, -- Allows it to naturally hatch from The Soul card!
    
    config = { extra = { retriggers = 3 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retriggers } }
    end,
    
    loc_txt = {
        name = 'Shadow Monarch',
        text = {
            "Retriggers all scored cards",
            "an extra {C:attention}#1#{} times"
        }
    },
    
    calculate = function(self, card, context)
        -- Stable, high-tier retrigger hook for exactly 3 repetitions
        if context.repetition and context.cardarea == G.play then
            return {
                message = 'Arise!',
                repetitions = card.ability.extra.retriggers,
                colour = G.C.PURPLE,
                card = card
            }
        end
    end
})