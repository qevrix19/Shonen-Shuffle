-- 1. Register the Jujutsu Kaisen Atlas
SMODS.Atlas({
    key = "the_last_uchiha_atlas",
    path = "the_last_uchiha.png",
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "the_last_uchiha",
    name = "The Last Uchiha",
    atlas = "the_last_uchiha_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    -- Starts at X1 Mult
    config = { extra = { xmult = 1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    
loc_txt = {
        name = 'The Last Uchiha',
        text = {
            "When {C:attention}Blind{} is selected,",
            "destroys the {C:attention}Joker{} to the right",
            "and permanently gains half of its",
            "sell value as {X:mult,C:white}X{} Mult{}",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Apply the X-Mult during scoring
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                message = "X" .. card.ability.extra.xmult .. " Mult",
                x_mult = card.ability.extra.xmult
            }
        end

       -- 2. Amaterasu: Burn the Joker to the right when a Blind is selected
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then 
                    my_pos = i 
                    break 
                end
            end
            
            if my_pos and my_pos < #G.jokers.cards then
                local right_joker = G.jokers.cards[my_pos + 1]
                
                if right_joker and not right_joker.ability.eternal and not right_joker.getting_sliced then
                    right_joker.getting_sliced = true
                    
                    -- Calculate half of the sell value (defaulting to 0 if nil)
                    local sell_value = right_joker.sell_cost or 0
                    local added_mult = sell_value / 2
                    
                    -- Add half sell value to The Last Uchiha's X-Mult
                    card.ability.extra.xmult = card.ability.extra.xmult + added_mult
                    
                 -- Trigger the visual destruction, sound effects, and floating text
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card:juice_up(0.8, 0.8)
                            right_joker:start_dissolve()
                            
                            -- Uses Balatro's native whoosh sound effect
                            play_sound('whoosh', 0.9, 1.0)
                            
                            return true
                        end
                    }))
                    
                    return {
                        message = 'Amaterasu!',
                        colour = G.C.RED
                    }
                end
            end
        end
    end
})