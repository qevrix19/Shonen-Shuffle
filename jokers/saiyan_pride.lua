SMODS.Atlas({
    key = "vegeta_atlas",
    path = "vegeta.png", -- Needs a 71x95 sprite named vegeta.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "saiyan_pride",
    name = "Saiyan Pride",
    atlas = "vegeta_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Uncommon
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult = 1.0, x_mult_gain = 0.25 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = 'Saiyan Pride',
        text = {
            "Gains {X:mult,C:white}X#2#{} Mult if the",
            "Blind is defeated in exactly",
            "{C:attention}1{} hand",
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
        
        -- 2. Trigger Saiyan Pride securely at the end of the round if you one-shot the Blind
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if G.GAME.current_round.hands_played == 1 then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                return {
                    message = 'Hmph. Trash.',
                    colour = G.C.BLUE,
                    card = card
                }
            end
        end
    end
})