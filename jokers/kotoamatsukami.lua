SMODS.Atlas({
    key = "shisui_atlas",
    path = "shisui.png", 
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "shisui_koto",
    name = "Kotoamatsukami",
    atlas = "shisui_atlas",
    pos = {x = 0, y = 0},
    rarity = 4, -- Legendary
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { x_mult = 1, x_mult_gain = 0.1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult } }
    end,

    loc_txt = {
        name = "Kotoamatsukami",
        text = {
            "At the end of the round, gains",
            "{X:mult,C:white} X#1# {} Mult for every card",
            "remaining in your hand",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult){}"
        }
    },

    calculate = function(self, card, context)
        -- 1. Main Joker Scoring
        if context.joker_main then
            if card.ability.extra.x_mult > 1 then
                return {
                    message = 'X' .. card.ability.extra.x_mult .. ' Mult',
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.RED
                }
            end
        end

        -- 2. Scale at the end of the round based on held cards
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if G.hand and G.hand.cards then
                local remaining_cards = #G.hand.cards
                if remaining_cards > 0 then
                    -- Calculate total gain based on hand size
                    local total_gain = card.ability.extra.x_mult_gain * remaining_cards
                    card.ability.extra.x_mult = card.ability.extra.x_mult + total_gain
                    
                    return {
                        message = 'Kotoamatsukami!',
                        colour = G.C.RED,
                        card = card
                    }
                end
            end
        end
    end
})