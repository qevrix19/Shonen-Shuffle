SMODS.Atlas({
    key = "toji_atlas",
    path = "toji.png",
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "toji_fushiguro",
    name = "Sorcerer Killer",
    atlas = "toji_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { x_mult = 1, x_mult_gain = 0.3 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult } }
    end,

    loc_txt = {
        name = "Sorcerer Killer",
        text = {
            "Gains {X:mult,C:white} X#1# {} Mult when",
            "any {C:attention}Consumable{} is used",
            "or sold.",
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

        -- 2. Scale when a consumable is used
        if context.using_consumeable and not context.blueprint then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
            card:juice_up(0.6, 0.6)
            return {
                message = 'Inverted Spear!',
                colour = G.C.RED,
                card = card
            }
        end

        -- 3. Scale when a consumable is sold (checking context.card instead of selling_card boolean)
        if context.selling_card and context.card and context.card.ability.consumeable and not context.blueprint then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
            card:juice_up(0.6, 0.6)
            return {
                message = 'Inverted Spear!',
                colour = G.C.RED,
                card = card
            }
        end
    end
})