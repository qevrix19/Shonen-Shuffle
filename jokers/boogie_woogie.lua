SMODS.Atlas({
    key = "todo_atlas",
    path = "todo.png", -- Needs a 71x95 sprite named todo.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "boogie_woogie",
    name = "Boogie Woogie",
    atlas = "todo_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon (Tier 2)
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult = 2.0 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,
    
    loc_txt = {
        name = 'Boogie Woogie',
        text = {
            "Played hands give",
            "{X:mult,C:white} X#1# {} Mult"
        }
    },
    
    calculate = function(self, card, context)
        -- Give a flat X2 Mult on every played hand during main scoring
        if context.joker_main and not context.blueprint then
            return {
                message = 'X' .. card.ability.extra.x_mult,
                x_mult = card.ability.extra.x_mult,
                colour = G.C.RED
            }
        end
    end
})