SMODS.Atlas({
    key = "aizen_atlas",
    path = "aizen.png", -- Needs a 71x95 sprite named aizen.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "the_mastermind",
    name = "The Mastermind",
    atlas = "aizen_atlas",
    pos = {x = 0, y = 0},
    rarity = 4, -- Legendary
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    soul_pos = { x = 1, y = 0 },
    
    config = { extra = { x_mult = 1.0, x_mult_gain = 0.15 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = 'The Mastermind',
        text = {
            "Gains {X:mult,C:white} X#2# {} Mult whenever",
            "{C:attention}any card{} is sold",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. "The Betrayal": Scale up when ANY card is sold (Campfire engine hook)
        if context.selling_card and not context.blueprint then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
            
            -- Pop up his iconic manipulation text
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = 'All according to plan...', 
                colour = G.C.PURPLE
            })
        end

        -- 2. Apply the accumulated God-complex XMult during main scoring
        if context.joker_main and card.ability.extra.x_mult > 1.0 then
            return {
                message = 'X' .. card.ability.extra.x_mult,
                x_mult = card.ability.extra.x_mult,
                colour = G.C.ORANGE
            }
        end
    end
})