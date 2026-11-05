SMODS.Atlas({
    key = "jiraiya_atlas",
    path = "jiraiya.png", -- Needs a 71x95 sprite named jiraiya.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "pervy_sage",
    name = "Pervy Sage",
    atlas = "jiraiya_atlas",
   pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult = 1.5, retriggers = 1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.retriggers } }
    end,
    
    loc_txt = {
        name = 'Pervy Sage',
        text = {
            "Played {C:attention}Queens{} each grant",
            "{X:mult,C:white} X#1# {} Mult and are",
            "{C:attention}retriggered{} an extra {C:attention}1{} time"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Apply XMult when a Queen is individually scored
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 12 then -- 12 is Queen
                return {
                    message = 'Ooh!',
                    x_mult = card.ability.extra.x_mult,
                    colour = G.C.PURPLE,
                    card = card
                }
            end
        end

        -- 2. Apply 1 extra retrigger to any scored Queen
        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == 12 then
                return {
                    message = 'Again!',
                    repetitions = card.ability.extra.retriggers,
                    colour = G.C.PURPLE,
                    card = card
                }
            end
        end
    end
})