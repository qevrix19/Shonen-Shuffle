SMODS.Atlas({
    key = "nanami_atlas",
    path = "nanami.png", -- Needs a 71x95 sprite named nanami.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "7_3_technique",
    name = "7:3 Technique",
    atlas = "nanami_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { chips = 73, x_mult = 1.73 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.x_mult } }
    end,
    
    loc_txt = {
        name = '7:3 Technique',
        text = {
            "Scored {C:attention}7s{} and {C:attention}3s{}",
            "become critical weak points,",
            "giving {C:chips}+#1#{} Chips and",
            "{X:mult,C:white}X#2#{} Mult when played"
        }
    },
    
    calculate = function(self, card, context)
        -- Strike the 7:3 Weak Point during individual card scoring
        if context.individual and context.cardarea == G.play then
            local rank = context.other_card:get_id()
            
            -- Check if the specific card rank is a 7 or a 3
            if rank == 7 or rank == 3 then
                return {
                    chips = card.ability.extra.chips,
                    x_mult = card.ability.extra.x_mult,
                    message = 'Ratio!',
                    colour = G.C.PURPLE,
                    card = card
                }
            end
        end
    end
})