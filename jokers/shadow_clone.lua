SMODS.Atlas({
    key = "shadow_clone_atlas",
    path = "shadow_clone.png", -- Ensure you have your 71x95 sprite named shadow_clone.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "shadow_clone",
    name = "Shadow Clone",
    atlas = "shadow_clone_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    
    -- Initialize extra.mult at 10 instead of lower
    config = { extra = { mult = 10, mult_gain = 3, rounds = 0, target_rounds = 3 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.target_rounds - card.ability.extra.rounds, card.ability.extra.mult } }
    end,
    
    loc_txt = {
        name = 'Shadow Clone',
        text = {
            "Gains {C:mult}+#1#{} Mult at end of round.",
            "After {C:attention}#2#{} rounds, creates a",
            "{C:attention}Shadow Clone{} if room available.",
            "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Main Joker Scoring (Apply flat Mult)
        if context.joker_main then
            return {
                message = '+' .. card.ability.extra.mult,
                mult = card.ability.extra.mult
            }
        end

        -- 2. End of round scaling (Guaranteed to only fire ONCE per round)
        if context.end_of_round and not context.blueprint and not context.getting_scored then
            if not card.ability.extra.already_scaled then
                card.ability.extra.already_scaled = true
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                card.ability.extra.rounds = card.ability.extra.rounds + 1
                
                -- Check if it hits the round threshold to duplicate
                if card.ability.extra.rounds >= card.ability.extra.target_rounds then
                    card.ability.extra.rounds = 0
                    
                    -- Check if there is room on the Joker board
                    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                        
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local cloned_card = SMODS.create_card({
                                    set = "Joker",
                                    area = G.jokers,
                                    key = "j_anime_overdrive_shadow_clone"
                                })
                                cloned_card:add_to_deck()
                                G.jokers:emplace(cloned_card)
                                cloned_card:start_materialize()
                                G.GAME.joker_buffer = 0
                                return true
                            end
                        }))
                        
                        card:juice_up(1.5, 1.5)
                        return {
                            message = 'Shadow Clone!',
                            colour = G.C.RED
                        }
                    end
                else
                    card:juice_up(0.8, 0.8)
                    return {
                        message = '+3 Mult',
                        colour = G.C.MULT
                    }
                end
            end
        end

        -- Reset the lock when you select the next blind
        if context.setting_blind and not context.blueprint then
            card.ability.extra.already_scaled = false
        end
    end
})