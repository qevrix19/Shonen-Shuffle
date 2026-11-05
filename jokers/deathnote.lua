SMODS.Atlas({
    key = "light_atlas",
    path = "light.png", -- Needs a 71x95 sprite named light.png in your assets/1x/ folder
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "light_death_note",
    name = "Deathnote",
    atlas = "light_atlas",
    pos = {x = 0, y = 0},                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { x_mult = 1, x_mult_gain = 0.5 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult } }
    end,

    loc_txt = {
        name = 'Deathnote',
        text = {
            "If played hand contains",
            "exactly {C:attention}1{} card and it is",
            "a {C:attention}Face{} card, destroy it and",
            "gain {X:mult,C:white} X#1# {} Mult",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },

    calculate = function(self, card, context)
        -- 1. Main Joker Scoring (Apply the X-Mult)
        if context.joker_main then
            if card.ability.extra.x_mult > 1 then
                return {
                    message = 'X' .. card.ability.extra.x_mult .. ' Mult',
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.RED
                }
            end
        end

        -- 2. Execution Phase (Check for single face card during the destruction step)
        if context.destroying_card and not context.blueprint then
            -- If you played exactly 1 card, and the card being evaluated is a Face card
            if #context.full_hand == 1 and context.destroying_card:is_face() then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                
                -- Triggers a visual pop-up on Light while the card burns away
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = 'Executed!', 
                    colour = G.C.DARK_EDITION
                })
                
                -- Returning true tells the Balatro engine to permanently dissolve the card
                return true
            end
        end
    end
})