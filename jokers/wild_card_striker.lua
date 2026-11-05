SMODS.Atlas({
    key = "kunigami_atlas",
    path = "kunigami.png", -- Needs a 71x95 sprite named kunigami.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "wild_card_striker",
    name = "Wild Card Striker",
    atlas = "kunigami_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { mult = 0, mult_gain = 11 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
    end,
    
    loc_txt = {
        name = 'Wild Card Striker',
        text = {
            "Gains {C:mult}+#2#{} Mult if played hand",
            "consists entirely of {C:attention}Wild Cards{}",
            "{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Scale up only if the played hand is entirely made of Wild Cards
        if context.joker_main and not context.blueprint then
            local all_wild = true
            
            -- Make sure there is actually something scoring
            if #context.scoring_hand > 0 then
                for _, scoring_card in ipairs(context.scoring_hand) do
                    -- Check if the card has the Wild Card enhancement
                    if scoring_card.ability.effect ~= 'Wild Card' then
                        all_wild = false
                        break
                    end
                end
            else
                all_wild = false
            end
            
            if all_wild then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = '+11 Goal!', 
                    colour = G.C.MULT
                })
            end
        end

        -- 2. Apply the accumulated Mult during main scoring
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = '+' .. card.ability.extra.mult,
                mult = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
})