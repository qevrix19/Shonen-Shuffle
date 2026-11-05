SMODS.Atlas({
    key = "megumi_atlas",
    path = "megumi.png", -- Needs a 71x95 sprite named megumi.png in your assets/1x/ folder
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "shadow_puppeteer",
    name = "Shadow Puppeteer",
    atlas = "megumi_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    
    config = { extra = { extra_interest = 4, sell_value_gain = 3 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.extra_interest, card.ability.extra.sell_value_gain } }
    end,
    
    loc_txt = {
        name = 'Shadow Puppeteer',
        text = {
            "Earns an extra {C:money}$#1#{} of interest",
            "at end of round.",
            "If round is won with {C:attention}0 hands remaining{},",
            "increase this card's {C:money}sell value{} by {C:money}$#2#{}."
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Increase interest limit or provide extra cash at end of round cash-out
        if context.end_of_round and not context.blueprint and not context.getting_scored then
            -- Check if the player won the round with 0 hands remaining
            if G.GAME.current_round.hands_left == 0 then
                card.ability.extra_value = card.ability.extra_value + card.ability.extra.sell_value_gain
                card:set_cost()
                card:juice_up(1.0, 1.0)
                return {
                    message = 'Domain Expansion!',
                    colour = G.C.MONEY
                }
            end
        end
    end,
    
    calc_dollar_bonus = function(self, card)
        -- Adds flat extra cash directly to the end-of-round interest payout
        return card.ability.extra.extra_interest
    end
})