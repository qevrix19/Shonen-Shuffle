SMODS.Atlas({
    key = "gojo_atlas",
    path = "gojo.png", -- Needs a 71x95 sprite named gojo.png in your assets/1x/ folder
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "honored_one",
    name = "The Honored One",
    atlas = "gojo_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult_gain = 0.5, current_x_mult = 1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = 'The Honored One',
        text = {
            "If scoring hand contains at least",
            "one {C:hearts}Heart{} and one {C:clubs}Club{},",
            "gains {X:mult,C:white}X#2#{} Mult.",
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
            local has_heart = false
            local has_club = false
            
            -- Safely scan the scoring hand using context.scoring_hand (like we fixed for Killua)
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_suit('Hearts') then
                    has_heart = true
                end
                if context.scoring_hand[i]:is_suit('Clubs') then
                    has_club = true
                end
            end
            
            -- If both Red and Blue are present, trigger Hollow Purple
            if has_heart and has_club then
                card.ability.extra.current_x_mult = card.ability.extra.current_x_mult + card.ability.extra.x_mult_gain
                card:juice_up(1.0, 1.0)
                play_sound('whoosh', 0.7, 1.2) -- Plays a mystical/powerful sound effect
                return {
                    message = 'Hollow Purple!',
                    colour = G.C.MULT
                }
            end
        end
    end
})