SMODS.Atlas {
    key = "bear_hunter",
    path = "gagamaru.png", -- Replace with the exact name of your multi-sprite sheet
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'bear_hunter',
    name = "Bear Hunter",
    atlas = 'bear_hunter',
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { x_mult = 5 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,
    
    loc_txt = {
        name = 'Bear Hunter',
        text = {
            "Gives {X:mult,C:white} X#1# {} Mult",
            "on final {C:attention}hand{} of round"
        }
    },
    
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.x_mult}},
                Xmult_mod = card.ability.extra.x_mult,
                colour = G.C.RED
            }
        end
    end
}