SMODS.Atlas({
    key = "ichigo_atlas",
    path = "ichigo.png", -- Needs a 71x95 sprite named ichigo.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "ryoka_boy",
    name = "Ryōka Boy",
    atlas = "ichigo_atlas",
    pos = {x = 0, y = 0},
    rarity = 1, -- Common
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { chips = 80 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    
    loc_txt = {
        name = 'Ryōka Boy',
        text = {
            "{C:chips}+#1#{} Chips if played",
            "hand contains",
            "exactly {C:attention}2{} or fewer cards"
        }
    },
    
    calculate = function(self, card, context)
        -- Triggers a massive chip bonus during main scoring for High Card / Pair builds
        if context.joker_main then
            if #context.full_hand <= 2 then
                return {
                    message = 'Getsuga!',
                    chips = card.ability.extra.chips,
                    colour = G.C.CHIPS
                }
            end
        end
    end
})