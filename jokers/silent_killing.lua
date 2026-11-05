SMODS.Atlas({
    key = "zabuza_atlas",
    path = "zabuza.png", -- Needs a 71x95 sprite named zabuza.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "zabuza_momochi",
    name = "Silent Killing",
    atlas = "zabuza_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { x_mult = 1, x_mult_gain = 0.25 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult } }
    end,

    loc_txt = {
        name = "Silent Killing",
        text = {
            "Gains {X:mult,C:white} X#1# {} Mult if a blind",
            "is defeated with {C:attention}0 Discards{} remaining",
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

        -- 2. Scale at the end of the round if 0 discards remain
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if G.GAME.current_round.discards_left <= 0 then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                card:juice_up(0.6, 0.6)
                return {
                    message = 'Silent Kill!',
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end
})