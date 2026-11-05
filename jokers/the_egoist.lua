SMODS.Atlas({
    key = "isagi_atlas",
    path = "isagi.png", 
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "egoist",
    name = "The Egoist",
    atlas = "isagi_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult_gain = 0.1, current_x_mult = 1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = 'The Egoist',
        text = {
            "Gains {X:mult,C:white}X#2#{} Mult for each",
            "non-scoring card played,",
            "then {C:red}destroys{} them.",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Main Joker Scoring (Apply X-Mult)
        if context.joker_main then
            if card.ability.extra.current_x_mult > 1 then
                return {
                    message = 'X' .. card.ability.extra.current_x_mult .. ' Mult',
                    x_mult = card.ability.extra.current_x_mult
                }
            end
        end

        -- 2. Scaling before the hand scores
        if context.before and not context.blueprint then
            local non_scoring_count = #context.full_hand - #context.scoring_hand
            
            if non_scoring_count > 0 then
                card.ability.extra.current_x_mult = card.ability.extra.current_x_mult + (card.ability.extra.x_mult_gain * non_scoring_count)
                card:juice_up(1.0, 1.0)
                play_sound('whoosh')
                return {
                    message = 'Direct Shot!',
                    colour = G.C.MULT
                }
            end
        end

        -- 3. Devour (Destroy) the non-scoring cards AFTER the hand finishes
        if context.after and not context.blueprint then
            local destroyed_any = false
            
            for i = 1, #context.full_hand do
                local played_card = context.full_hand[i]
                local is_scoring = false
                
                -- Check if this specific card was part of the scoring hand
                for j = 1, #context.scoring_hand do
                    if played_card == context.scoring_hand[j] then
                        is_scoring = true
                        break
                    end
                end
                
                -- If it didn't score, trigger the physical card destruction animation
                if not is_scoring and not played_card.shattered and not played_card.removed then
                    played_card.shattered = true
                    destroyed_any = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            played_card:start_dissolve()
                            return true
                        end
                    }))
                end
            end
            
            if destroyed_any then
                card:juice_up(0.8, 0.8)
                return {
                    message = 'Devoured!',
                    colour = G.C.RED
                }
            end
        end
    end
})