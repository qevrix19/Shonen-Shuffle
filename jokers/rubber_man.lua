SMODS.Atlas({
    key = "luffy_rubber_atlas",
    path = "luffy_rubber.png", -- Needs a 71x95 sprite named luffy_rubber.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "rubber_man",
    name = "Rubber Man",
    atlas = "luffy_rubber_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { retriggers = 1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retriggers } }
    end,
    
    loc_txt = {
        name = 'Rubber Man',
        text = {
            "Retriggers all played cards",
            "if the played hand contains",
            "{C:attention}3 or more cards{} of",
            "the same suit"
        }
    },
    
    calculate = function(self, card, context)
        -- Check if individual card scoring is happening in the played area
        if context.repetition and context.cardarea == G.play then
            local suit_counts = {}
            local threshold_met = false
            
            -- Count suits in the played hand
            if context.scoring_hand then
                for _, scoring_card in ipairs(context.scoring_hand) do
                    local s = scoring_card.base.suit
                    suit_counts[s] = (suit_counts[s] or 0) + 1
                    if suit_counts[s] >= 3 then
                        threshold_met = true
                    end
                end
            end
            
            -- If 3 or more cards share a suit, stretch and snap the retrigger!
            if threshold_met then
                return {
                    message = 'Boing!',
                    repetitions = card.ability.extra.retriggers,
                    card = card
                }
            end
        end
    end
})