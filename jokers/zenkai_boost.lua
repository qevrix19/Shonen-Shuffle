SMODS.Atlas({
    key = "goku_atlas",
    path = "goku.png", -- Needs a 71x95 sprite named goku.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "zenkai_boost",
    name = "Zenkai Boost",
    atlas = "goku_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult = 1.0, x_mult_gain = 0.2 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = 'Zenkai Boost',
        text = {
            "Gains {X:mult,C:white}X#2#{} Mult whenever",
            "a played hand does {C:attention}not{}",
            "defeat the Blind",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Apply the accumulated XMult during main scoring
        if context.joker_main and card.ability.extra.x_mult > 1.0 then
            return {
                message = 'X' .. card.ability.extra.x_mult .. ' Mult',
                x_mult = card.ability.extra.x_mult,
                colour = G.C.DARK_EDITION
            }
        end
        
        -- 2. Trigger the Zenkai Boost after a hand fails to clear the blind
        if context.after and not context.blueprint then
            -- Balatro updates G.GAME.chips after the hand scores. 
            -- If we are still under the requirement, the fight continues.
            if G.GAME.chips < G.GAME.blind.chips then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                return {
                    message = 'Zenkai!',
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end
})