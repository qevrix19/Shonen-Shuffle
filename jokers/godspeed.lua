SMODS.Atlas({
    key = "godspeed_atlas",
    path = "godspeed.png",
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "godspeed",
    name = "Godspeed",
    atlas = "godspeed_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult_gain = 0.2, current_x_mult = 1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = 'Godspeed',
        text = {
            "Gains {X:mult,C:white}X#2#{} Mult for each",
            "scoring {C:clubs}Club{}.",
            "Resets to {X:mult,C:white}X1{} Mult if a",
            "{C:attention}Face Card{} is scored.",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}Mult){}"
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
            local face_played = false
            local clubs_played = 0
            
            -- Scan the scoring hand for Clubs and Face cards
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_face() then
                    face_played = true
                end
                if context.scoring_hand[i]:is_suit('Clubs') then
                    clubs_played = clubs_played + 1
                end
            end
            
            -- Face cards trigger Killua's trauma (Reset)
            if face_played then
                if card.ability.extra.current_x_mult > 1 then
                    card.ability.extra.current_x_mult = 1
                    card:juice_up(0.8, 0.8)
                    play_sound('timpani') -- Ominous reset sound
                    return {
                        message = 'Reset!',
                        colour = G.C.RED
                    }
                end
            -- Otherwise, scale up for every Club played (Godspeed)
            elseif clubs_played > 0 then
                card.ability.extra.current_x_mult = card.ability.extra.current_x_mult + (card.ability.extra.x_mult_gain * clubs_played)
                card:juice_up(0.5, 0.5)
                play_sound('chips1') 
                return {
                    message = 'Godspeed!',
                    colour = G.C.MULT
                }
            end
        end
    end
})