SMODS.Atlas({
    key = "yuta_atlas",
    path = "yuta.png", -- Needs a 71x95 sprite named yuta.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "mimicry",
    name = "Mimicry",
    atlas = "yuta_atlas",
    pos = {x = 0, y = 0},
    rarity = 4, -- Legendary
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    
    config = { extra = { x_mult = 3.0 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,
    
    loc_txt = {
        name = 'Mimicry',
        text = {
            "Copies the ability of the",
            "{C:attention}Joker{} to the left and",
            "multiplies its effect by",
            "{X:mult,C:white}X#1#{} Mult",
        }
    },
    
    calculate = function(self, card, context)
        -- Prevent any recursion loops or hard crashes
        if context.mimicry_active then return end

        -- 1. Find the Joker immediately to the left
        local target_joker = nil
        if G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    if i > 1 then
                        target_joker = G.jokers.cards[i - 1]
                    end
                    break
                end
            end
        end

        -- 2. If a valid copy target exists to the left, copy its calculation for ANY context
        if target_joker and target_joker ~= card and not target_joker.config.center.blueprint_compat_no_copy then
            context.blueprint = (context.blueprint or 0) + 1
            context.mimicry_active = true
            
            local eval = target_joker:calculate_joker(context)
            
            context.mimicry_active = nil
            context.blueprint = context.blueprint - 1

            if eval then
                if type(eval) == 'table' then
                    if eval.x_mult then
                        eval.x_mult = eval.x_mult * card.ability.extra.x_mult
                    else
                        eval.x_mult = card.ability.extra.x_mult
                    end
                    eval.message = 'Mimicry!'
                    eval.colour = G.C.PURPLE
                    return eval
                end
            end
        end
    end
})