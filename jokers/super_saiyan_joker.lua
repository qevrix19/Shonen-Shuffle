-- ===================================================================
-- ANIME OVERDRIVE by Qevrix
-- ===================================================================

-- 1. Register Sprite Sheet Atlas
SMODS.Atlas{
    key = "overdrive_jokers",
    path = "jokers.png",
    px = 71,
    py = 95
}

-- 2. First Anime Joker: Super Saiyan Joker
SMODS.Joker{
    key = 'super_saiyan',
    loc_txt = {
        name = 'Super Saiyan Joker',
        text = {
            "{C:mult}+#1#{} Mult",
            "Gains {C:mult}+#2#{} Mult when",
            "you play a {C:attention}Flush{}"
        }
    },
    config = { extra = { mult = 10, mult_mod = 5 } },
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = "overdrive_jokers",
    pos = { x = 0, y = 0 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod } }
    end,

    calculate = function(self, card, context)
        -- Upgrade Mult when a Flush is played
        if context.before and not context.blueprint then
            if context.scoring_name == "Flush" then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return {
                    message = 'POWER UP!',
                    colour = G.C.MULT
                }
            end
        end

        -- Add Mult during scoring
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = '+' .. tostring(card.ability.extra.mult) .. ' Mult',
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
}
