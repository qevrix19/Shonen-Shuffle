SMODS.Atlas({
    key = "conner_atlas",
    path = "conner.png", -- Make sure you have a 71x95 sprite named conner.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "conner",
    name = "Conner",
    atlas = "conner_atlas",
    pos = {x = 0, y = 0},
    rarity = 4, -- Legendary
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { dollars = 25 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    
    loc_txt = {
        name = 'Conner',
        text = {
            "Earn {C:money}$#1#{} at the",
            "end of each round.",
        }
    },
    
    calculate = function(self, card, context)
        -- Triggers at the end of every round (after beating the blind)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            ease_dollars(card.ability.extra.dollars)
            card:juice_up(1.2, 1.2)
            return {
                message = '+$25',
                colour = G.C.MONEY
            }
        end
    end
})