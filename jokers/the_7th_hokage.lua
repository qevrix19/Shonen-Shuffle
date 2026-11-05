SMODS.Atlas({
    key = "hokage_naruto_atlas",
    path = "seventh_hokage.png", -- Needs a 71x95 sprite named seventh_hokage.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "the_seventh_hokage",
    name = "The 7th Hokage",
    atlas = "hokage_naruto_atlas",
    pos = {x = 0, y = 0},
    rarity = 4, -- Legendary
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    soul_pos = { x = 1, y = 0 }, -- Allows it to naturally spawn from The Soul card!
    
    config = { extra = { x_mult = 1.0, x_mult_gain = 0.1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = 'The 7th Hokage',
        text = {
            "Gains {X:mult,C:white}X#2#{} Mult for",
            "every card {C:attention}scored{} during the run",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
        }
    },
    
   calculate = function(self, card, context)
        -- 1. Permanently scale up for every individual card that scores in a played hand
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                return {
                    message = '+0.1x',
                    colour = G.C.ORANGE,
                    card = card
                }
            end
        end
        
        -- 2. Apply the accumulated XMult during main scoring
        if context.joker_main and card.ability.extra.x_mult > 1 then
            return {
                message = 'X' .. card.ability.extra.x_mult,
                x_mult = card.ability.extra.x_mult,
                colour = G.C.ORANGE
            }
        end
    end
})