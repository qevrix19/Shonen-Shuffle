SMODS.Atlas({
    key = "sae_atlas",
    path = "sae.png", -- Needs a 71x95 sprite named sae.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "genius_playmaker",
    name = "Genius Playmaker",
    atlas = "sae_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult = 1.0, x_mult_gain = 0.15, x_mult_loss = 0.1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain, card.ability.extra.x_mult_loss } }
    end,
    
    loc_txt = {
        name = 'Genius Playmaker',
        text = {
            "Gains {X:mult,C:white} +X#2# {} Mult when",
            "played hand is a {C:attention}Pair{},",
            "loses {X:mult,C:white} -X#3# {} Mult when you {C:attention}discard{}",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Gain XMult when playing a Pair
        if context.joker_main and not context.blueprint then
            if context.scoring_name == 'Pair' then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = '+X' .. card.ability.extra.x_mult_gain, 
                    colour = G.C.BLUE
                })
            end
        end

        -- 2. Lose a bit of XMult when discarding (floored at 1.0 so it never goes negative)
        if context.discard and not context.blueprint then
            -- Ensures the penalty only triggers once per discard action
            if context.other_card == context.full_hand[#context.full_hand] then
                card.ability.extra.x_mult = math.max(1.0, card.ability.extra.x_mult - card.ability.extra.x_mult_loss)
                
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = '-X' .. card.ability.extra.x_mult_loss, 
                    colour = G.C.RED
                })
            end
        end

        -- 3. Apply the accumulated XMult during main scoring
        if context.joker_main and card.ability.extra.x_mult > 1.0 then
            return {
                message = 'X' .. card.ability.extra.x_mult,
                x_mult = card.ability.extra.x_mult,
                colour = G.C.BLUE
            }
        end
    end
})