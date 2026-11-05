SMODS.Atlas({
    key = "hisoka_atlas",
    path = "hisoka.png", -- Needs a 71x95 sprite named hisoka.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "bungee_gum",
    name = "Bungee Gum",
    atlas = "hisoka_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult = 2, retriggers = 1 } },
    
    loc_vars = function(self, info_queue, card)
        -- Injects the standard Balatro 'Wild Card' tooltip box when hovering over this Joker
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        return { vars = { card.ability.extra.retriggers, card.ability.extra.x_mult } }
    end,
    
    loc_txt = {
        name = 'Bungee Gum',
        text = {
            "Scored {C:attention}Wild Cards{} are",
            "retriggered {C:attention}#1#{} time and",
            "give {X:mult,C:white} X#2# {} Mult"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. The Rubber (Retriggering the Wild Card)
        if context.repetition and context.cardarea == G.play then
            -- Standard vanilla check for enhanced Wild Cards
            if context.other_card.ability.name == 'Wild Card' then
                return {
                    message = 'Bungee Gum!',
                    repetitions = card.ability.extra.retriggers,
                    card = card
                }
            end
        end

        -- 2. The Gum / Texture (Applying XMult to the Wild Card)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == 'Wild Card' then
                return {
                    x_mult = card.ability.extra.x_mult,
                    message = 'Texture Surprise!',
                    colour = G.C.PURPLE,
                    card = card
                }
            end
        end
    end
})