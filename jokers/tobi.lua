SMODS.Atlas({
    key = "obito_tobi_atlas",
    path = "obito.png", -- Needs a 71x95 sprite named tobi.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "tobi_masked",
    name = "Tobi",
    atlas = "obito_tobi_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult = 1.0, x_mult_gain = 0.25 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = 'Tobi',
        text = {
            "Gains {X:mult,C:white} X#2# {} Mult per consecutive",
            "{C:attention}High Card{} played.",
            "Resets to {X:mult,C:white} X1 {} if a",
            "different hand type is played.",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Scaling check before scoring
        if context.before and not context.blueprint then
            if context.scoring_name == "High Card" then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = 'Intangible!',
                    colour = G.C.PURPLE
                })
            else
                card.ability.extra.x_mult = 1.0
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = 'Exposed!',
                    colour = G.C.RED
                })
            end
        end

        -- 2. Apply the XMult during main scoring
        if context.joker_main and card.ability.extra.x_mult > 1.0 then
            return {
                message = 'X' .. card.ability.extra.x_mult,
                x_mult = card.ability.extra.x_mult,
                colour = G.C.PURPLE
            }
        end
    end
})