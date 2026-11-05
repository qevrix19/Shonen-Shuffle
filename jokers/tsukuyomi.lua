SMODS.Atlas({
    key = "itachi_atlas",
    path = "itachi.png", 
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "itachi_izanami",
    name = "Izanami",
    atlas = "itachi_atlas", 
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { x_mult = 1, x_mult_gain = 0.5, last_hand = 'None' } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult, card.ability.extra.last_hand } }
    end,

    loc_txt = {
        name = 'Izanami',
        text = {
            "Gains {X:mult,C:white} X#1# {} Mult if",
            "played hand matches the",
            "previously played hand",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
            "{C:inactive}(Last Hand: {C:attention}#3#{C:inactive})"
        }
    },

    calculate = function(self, card, context)
        -- 1. Evaluate the hand type right before scoring (Handles scaling and resetting)
        if context.before and not context.blueprint then
            -- If it's the very first hand played, or it matches the Izanami loop
            if card.ability.extra.last_hand == 'None' or card.ability.extra.last_hand == context.scoring_name then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                card.ability.extra.last_hand = context.scoring_name
                return {
                    message = 'Izanami!',
                    colour = G.C.RED,
                    card = card
                }
            -- If you play a different hand type, the genjutsu breaks
            else
                card.ability.extra.x_mult = 1
                card.ability.extra.last_hand = context.scoring_name
                return {
                    message = 'Genjutsu Broken!',
                    colour = G.C.FILTER,
                    card = card
                }
            end
        end

        -- 2. Apply the accumulated XMult during main scoring
        if context.joker_main and card.ability.extra.x_mult > 1 then
            return {
                message = 'X' .. card.ability.extra.x_mult,
                Xmult_mod = card.ability.extra.x_mult,
                colour = G.C.RED
            }
        end
    end
})