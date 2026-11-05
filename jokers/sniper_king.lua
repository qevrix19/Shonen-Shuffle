SMODS.Atlas({
    key = "usopp_atlas",
    path = "usopp.png", -- Needs a 71x95 sprite named usopp.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "sniper_king",
    name = "Sniper King",
    atlas = "usopp_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { repetitions = 1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
    
    loc_txt = {
        name = 'Sniper King',
        text = {
            "Retriggers all {C:attention}Enhanced{} cards",
            "{C:attention}#1#{} additional time"
        }
    },
    
    calculate = function(self, card, context)
        -- By NOT specifying context.cardarea here, this hook applies universally 
        -- to both played cards (Glass/Lucky) AND held cards (Steel/Gold)
        if context.repetition and not context.blueprint then
            
            -- Check if the card has an enhancement (i.e., it is not a default base card)
            if context.other_card.config.center ~= G.P_CENTERS.c_base then
                return {
                    message = 'Snipe!',
                    repetitions = card.ability.extra.repetitions,
                    card = card
                }
            end
        end
    end
})