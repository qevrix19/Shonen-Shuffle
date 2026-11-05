SMODS.Atlas({
    key = "kaiser_atlas",
    path = "kaiser.png", -- Needs a 71x95 sprite named kaiser.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "kaiser_impact",
    name = "Kaiser Impact",
    atlas = "kaiser_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { chips = 200, x_mult = 3.0 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.x_mult } }
    end,
    
    loc_txt = {
        name = 'Kaiser Impact',
        text = {
            "If the {C:attention}first hand{} of the",
            "round contains exactly {C:attention}1{} card,",
            "gives {C:chips}+#1#{} Chips and {X:mult,C:white}X#2#{} Mult"
        }
    },
    
    calculate = function(self, card, context)
        -- Trigger only during main scoring of the very first hand, playing a single card
        if context.joker_main then
            if G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 then
                return {
                    message = 'Kaiser Impact!',
                    chip_mod = card.ability.extra.chips,
                    x_mult = card.ability.extra.x_mult,
                    colour = G.C.ORANGE
                }
            end
        end
    end
})