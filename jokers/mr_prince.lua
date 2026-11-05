SMODS.Atlas({
    key = "sanji_atlas",
    path = "sanji.png", -- Needs a 71x95 sprite named sanji.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "diable_jambe",
    name = "Mr. Prince",
    atlas = "sanji_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { mult_gain = 5 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain } }
    end,
    
    loc_txt = {
        name = 'Mr. Prince',
        text = {
            "Played cards of the",
            "{C:attention}Hearts{} suit give",
            "{C:mult}+#1#{} Mult when scored"
        }
    },
    
    calculate = function(self, card, context)
        -- Trigger during individual card scoring for any card in the played hand
        if context.individual and context.cardarea == G.play then
            -- Check if the scored card belongs to the Hearts suit
            if context.other_card:is_suit('Hearts') then
                return {
                    mult = card.ability.extra.mult_gain,
                    message = '+5 Mult',
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end
})