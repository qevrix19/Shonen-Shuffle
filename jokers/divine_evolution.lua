SMODS.Atlas({
    key = "ssgss_goku_atlas",
    path = "ssgss_goku.png", -- Needs a 71x95 sprite named ssgss_goku.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "ssgss_goku",
    name = "Divine Evolution",
    atlas = "ssgss_goku_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { x_mult = 1.5, x_mult_gain = 0.25 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult } }
    end,

    loc_txt = {
        name = "Divine Evolution",
        text = {
            "Gains {X:mult,C:white} X#1# {} Mult if played hand",
            "contains an {C:attention}Ace, 2, or 3{}.",
            "Resets to {X:mult,C:white} X1.5 {} if a {C:attention}Face card{}",
            "is played.",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },

    calculate = function(self, card, context)
        -- 1. Main Joker Scoring (Apply X-Mult)
        if context.joker_main then
            if card.ability.extra.x_mult > 1 then
                return {
                    message = 'X' .. card.ability.extra.x_mult,
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.RED
                }
            end
        end

        -- 2. Scaling or Resetting before the hand scores
        if context.before and not context.blueprint then
            local has_face = false
            local has_low_card = false

            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() then
                    has_face = true
                end
                -- Check for Ace (14 or 1), 2, or 3 based on base rank value
                if scored_card.base.value == 'Ace' or scored_card.base.value == '2' or scored_card.base.value == '3' then
                    has_low_card = true
                end
            end

            -- If you played a face card, divine focus is broken (Reset)
            if has_face then
                if card.ability.extra.x_mult > 1.5 then
                    card.ability.extra.x_mult = 1.5
                    card:juice_up(0.8, 0.8)
                    play_sound('timpani')
                    return {
                        message = 'Ki Lost...',
                        colour = G.C.RED,
                        card = card
                    }
                end
            -- If you played an Ace, 2, or 3 without face cards, scale up
            elseif has_low_card then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                card:juice_up(0.6, 0.6)
                play_sound('chips1')
                return {
                    message = 'Super Saiyan Blue!',
                    colour = G.C.BLUE,
                    card = card
                }
            end
        end
    end
})