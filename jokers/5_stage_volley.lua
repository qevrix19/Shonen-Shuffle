SMODS.Atlas({
    key = "nagi_atlas",
    path = "nagi.png", -- Needs a 71x95 sprite named nagi.png in your assets/1x/ folder
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "five_stage_volley",
    name = "5-Stage Volley",
    atlas = "nagi_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult_gain = 0.5, current_x_mult = 1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = '5-Stage Volley',
        text = {
            "Gains {X:mult,C:white}X#2#{} Mult if the played",
            "hand contains exactly {C:attention}5{} cards.",
            "Resets to {X:mult,C:white}X1{} Mult if the played",
            "hand contains fewer than {C:attention}5{} cards.",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}"
        }
    },
    
calculate = function(self, card, context)
        -- 1. Main Joker Scoring (Apply X-Mult)
        if context.joker_main then
            if card.ability.extra.current_x_mult > 1 then
                return {
                    message = 'X' .. card.ability.extra.current_x_mult .. ' Mult',
                    Xmult_mod = card.ability.extra.current_x_mult, -- Fixed this variable name!
                    colour = G.C.RED
                }
            end
        end

        -- 2. Scaling before the hand scores
        if context.before and not context.blueprint then
            -- #context.full_hand counts exactly how many cards were physically selected and played
            if #context.full_hand == 5 then
                card.ability.extra.current_x_mult = card.ability.extra.current_x_mult + card.ability.extra.x_mult_gain
                card:juice_up(0.5, 0.5)
                play_sound('chips1') 
                return {
                    message = 'Volley!',
                    colour = G.C.MULT,
                    card = card
                }
            elseif #context.full_hand < 5 then
                -- Nagi loses interest (Reset)
                if card.ability.extra.current_x_mult > 1 then
                    card.ability.extra.current_x_mult = 1
                    card:juice_up(0.8, 0.8)
                    play_sound('timpani') 
                    return {
                        message = 'Dropped...',
                        colour = G.C.RED,
                        card = card
                    }
                end
            end
        end
    end
})