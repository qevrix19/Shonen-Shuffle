SMODS.Atlas({
    key = "minato_atlas",
    path = "minato.png", -- Needs a 71x95 sprite named minato.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "flying_raijin",
    name = "Flying Raijin",
    atlas = "minato_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { retriggers = 1, x_mult = 2.0 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retriggers, card.ability.extra.x_mult } }
    end,
    
    loc_txt = {
        name = 'Flying Raijin',
        text = {
            "The {C:attention}first{} and {C:attention}last{} cards",
            "in the played hand are {C:attention}retriggered{}",
            "and give {X:mult,C:white} X#2# {} Mult"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. The Teleport: Retrigger the first and last cards in the played hand
        if context.repetition and context.cardarea == G.play then
            -- Check if the current card being evaluated is at position 1 or the final position
            if context.other_card == context.full_hand[1] or context.other_card == context.full_hand[#context.full_hand] then
                return {
                    message = 'Teleport!',
                    repetitions = card.ability.extra.retriggers,
                    card = card
                }
            end
        end

        -- 2. The Strike: Add XMult to those specific outer cards when they score
        if context.individual and context.cardarea == G.play then
            if context.other_card == context.full_hand[1] or context.other_card == context.full_hand[#context.full_hand] then
                return {
                    x_mult = card.ability.extra.x_mult,
                    message = 'Yellow Flash!',
                    colour = G.C.ORANGE,
                    card = card
                }
            end
        end
    end
})