SMODS.Atlas({
    key = "nobara_atlas",
    path = "nobara.png", -- Needs a 71x95 sprite named nobara.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "straw_doll",
    name = "Straw Doll Technique",
    atlas = "nobara_atlas",
    pos = {x = 0, y = 0},
    rarity = 1, -- Common
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { mult = 0, mult_gain = 2 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
    end,
    
    loc_txt = {
        name = 'Straw Doll Technique',
        text = {
            "Gains {C:mult}+#2#{} Mult for",
            "each discarded {C:clubs}Club{} card",
            "{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Scale the Mult when discarding Clubs (Setting the nails)
        if context.discard and not context.blueprint then
            if context.other_card:is_suit('Clubs') and not context.other_card.debuff then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                
                return {
                    message = 'Resonance!',
                    colour = G.C.MULT,
                    card = card
                }
            end
        end

        -- 2. Apply the accumulated Mult during main scoring (The hammer strike)
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = localize{type='variable', key='a_mult', vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
})