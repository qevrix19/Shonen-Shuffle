SMODS.Atlas({
    key = "rin_atlas",
    path = "rin.png", -- Needs a 71x95 sprite named rin.png in your assets/1x/ folder
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "puppet_master",
    name = "Puppet Master",
    atlas = "rin_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult_gain = 0.2, current_x_mult = 1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = 'Puppet Master',
        text = {
            "Retrigger all played {C:attention}Aces{} and {C:attention}Kings{}.",
            "Gains {X:mult,C:white}X#2#{} Mult every time",
            "an Ace or King is retriggered.",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Retrigger Aces and Kings
        if context.repetition and context.cardarea == G.play then
            if context.other_card and context.other_card.base then
                local rank = context.other_card.base.value
                if rank == 'Ace' or rank == 'King' then
                    -- Scale up X-mult every time a card is commanded
                    card.ability.extra.current_x_mult = card.ability.extra.current_x_mult + card.ability.extra.x_mult_gain
                    card:juice_up(0.8, 0.8)
                    
                    return {
                        message = 'Command!',
                        repetitions = 1,
                        colour = G.C.RED
                    }
                end
            end
        end

        -- 2. Main Joker Scoring (Apply accumulated X-Mult)
        if context.joker_main then
            if card.ability.extra.current_x_mult > 1 then
                return {
                    message = 'X' .. card.ability.extra.current_x_mult,
                    x_mult = card.ability.extra.current_x_mult
                }
            end
        end
    end
})