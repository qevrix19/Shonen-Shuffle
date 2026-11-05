SMODS.Atlas({
    key = "piccolo_sponsor_atlas",
    path = "piccolo.png", -- Needs a 71x95 sprite named piccolo.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "the_sponsor",
    name = "The Sponsor",
    atlas = "piccolo_sponsor_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { interest_bonus = 2 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.interest_bonus } }
    end,
    
    loc_txt = {
        name = 'The Sponsor',
        text = {
            "Earn {C:money}+#1#{} extra interest",
            "at end of round for every",
            "{C:money}$5{} you have"
        }
    },
    
    calc_dollar_bonus = function(self, card)
        local dollars = math.min(G.GAME.interest_cap, math.floor(G.GAME.dollars / 5)) * card.ability.extra.interest_bonus
        if dollars > 0 then
            return dollars
        end
    end
})