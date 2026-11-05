SMODS.Atlas({
    key = "yuji_atlas",
    path = "yuji.png", -- Needs a 71x95 sprite named yuji.png
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "cursed_energy_spark",
    name = "Cursed Energy Spark",
    atlas = "yuji_atlas",
    pos = {x = 0, y = 0},
    rarity = 1, -- Common
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { mult = 4, mult_gain = 1 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
    end,
    
    loc_txt = {
        name = 'Cursed Energy Spark',
        text = {
            "{C:mult}+#1#{} Mult.",
            "Permanently gains {C:mult}+#2#{} Mult",
            "each time you play a hand",
            "containing a {C:attention}4{}."
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Score Mult
        if context.joker_main then
            return {
                message = '+' .. card.ability.extra.mult,
                mult = card.ability.extra.mult
            }
        end

        -- 2. Scale when a 4 is played in the full hand
        if context.before and not context.blueprint then
            local has_four = false
            for i = 1, #context.full_hand do
                if context.full_hand[i]:get_id() == 4 then
                    has_four = true
                    break
                end
            end
            
            if has_four then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                card:juice_up(0.8, 0.8)
                return {
                    message = '+1 Mult',
                    colour = G.C.MULT
                }
            end
        end
    end
})