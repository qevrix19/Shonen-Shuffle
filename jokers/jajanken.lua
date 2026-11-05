SMODS.Atlas({
    key = "jajanken_atlas",
    path = "jajanken.png",
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "jajanken",
    name = "Jajanken",
    atlas = "jajanken_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    
    config = { extra = { mult = 10, mult_gain = 5, threshold = 100, x_mult_bonus = 4, transformed = false } },
    
    loc_vars = function(self, info_queue, card)
        -- Make the badge dynamically switch between flat Mult and X-Mult
        local display_value = ""
        if card.ability.extra.transformed then
            display_value = "X" .. card.ability.extra.x_mult_bonus
        else
            display_value = "+" .. card.ability.extra.mult
        end
        
        return { vars = { display_value, card.ability.extra.mult_gain, card.ability.extra.threshold, card.ability.extra.x_mult_bonus } }
    end,
    
    loc_txt = {
        name = 'Jajanken',
        text = {
            "Gains {C:mult}+#2#{} Mult when",
            "each hand is played.",
            "If Mult reaches {C:attention}#3#{},",
            "transforms into {C:attention}Adult Gon{},",
            "giving {X:mult,C:white}X#4#{} Mult instead!",
            "{C:inactive}(Currently {C:mult}#1#{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Scoring logic
        if context.joker_main then
            if card.ability.extra.transformed then
                -- Adult Gon X-Mult phase
                return {
                    message = 'X' .. card.ability.extra.x_mult_bonus .. ' Mult',
                    x_mult = card.ability.extra.x_mult_bonus
                }
            else
                -- Base Gon scaling phase
                return {
                    message = '+' .. card.ability.extra.mult,
                    mult = card.ability.extra.mult
                }
            end
        end

        -- 2. Scaling per played hand before scoring
        if context.before and not context.blueprint and not card.ability.extra.transformed then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            
            -- Check if it hits the threshold to transform
            if card.ability.extra.mult >= card.ability.extra.threshold then
                card.ability.extra.transformed = true
                
                -- Big physical shake and sound effect instead of a sprite swap
                card:juice_up(1.5, 1.5)
                play_sound('whoosh', 0.7, 1.2)
                
                card:juice_up(1.5, 1.5)
                play_sound('whoosh', 0.7, 1.2)
                
                return {
                    message = 'Adult Gon!',
                    colour = G.C.RED
                }
            end
        end
    end
})