SMODS.Atlas({
    key = "nami_atlas",
    path = "nami.png", -- Needs a 71x95 sprite named nami.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "cat_burglar",
    name = "Cat Burglar",
    atlas = "nami_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult = 1.5, dollars = 1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.dollars } }
    end,
    
    loc_txt = {
        name = 'Cat Burglar',
        text = {
            "Played {C:red}Hearts{} and {C:black}Spades{}",
            "each give {X:mult,C:white} X#1# {} Mult and",
            "{C:money}+$#2#{} when scored"
        }
    },
    
    calculate = function(self, card, context)
        -- Trigger individually for every scored Heart or Spade
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Hearts') or context.other_card:is_suit('Spades') then
                return {
                    x_mult = card.ability.extra.x_mult,
                    dollars = card.ability.extra.dollars,
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end
})