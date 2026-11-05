SMODS.Atlas({
    key = "frieza_atlas",
    path = "frieza.png", -- Needs a 71x95 sprite named frieza.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "universal_tyrant",
    name = "Universal Tyrant",
    atlas = "frieza_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult = 1.0, x_mult_gain = 0.5 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = 'Universal Tyrant',
        text = {
            "If played hand contains",
            "exactly {C:attention}1{} card, {C:red}destroy{} it",
            "and gain {X:mult,C:white} X#2# {} Mult",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Apply the accumulated XMult during main scoring
        if context.joker_main and card.ability.extra.x_mult > 1.0 then
            return {
                message = 'X' .. card.ability.extra.x_mult,
                x_mult = card.ability.extra.x_mult,
                colour = G.C.ORANGE
            }
        end

        -- 2. "Death Beam" Execution: Destroy the card and scale up
        -- context.destroying_card runs after scoring but before the discard phase
        if context.destroying_card and not context.blueprint then
            -- Check if you only played a single card
            if #context.full_hand == 1 then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                
                -- Pop up a visual text message on the Joker showing the upgrade
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = '+X' .. card.ability.extra.x_mult_gain .. ' Mult', 
                    colour = G.C.RED
                })
                
                -- Returning true physically deletes the played card from your deck
                return true 
            end
        end
    end
})