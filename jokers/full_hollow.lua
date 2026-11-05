SMODS.Atlas({
    key = "full_hollow_atlas",
    path = "full_hollow.png", -- Needs a 71x95 sprite named full_hollow.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "full_hollow",
    name = "Full Hollow",
    atlas = "full_hollow_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult = 4.0, money_loss = 2 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.money_loss } }
    end,
    
    loc_txt = {
        name = 'Full Hollow',
        text = {
            "If played hand is a",
            "{C:attention}Full House{}, grants {X:mult,C:white} X#1# {} Mult,",
            "but you lose {C:money}$#2#{}"
        }
    },
    
   calculate = function(self, card, context)
        -- Triggers during main scoring only if the hand is a Full House
        if context.joker_main then
            if context.scoring_name == 'Full House' then
                return {
                    message = 'Cero!',
                    x_mult = card.ability.extra.x_mult,
                    dollars = -card.ability.extra.money_loss, -- Drains safely during the animation
                    colour = G.C.RED
                }
            end
        end
    end
})