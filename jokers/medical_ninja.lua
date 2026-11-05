SMODS.Atlas({
    key = "sakura_atlas",
    path = "sakura.png", -- Needs a 71x95 sprite named sakura.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "medical_ninja",
    name = "Medical Ninja",
    atlas = "sakura_atlas",
    pos = {x = 0, y = 0},
    rarity = 1, -- Common
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    config = { extra = { mult_gain = 1, mult = 0 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    
    loc_txt = {
        name = 'Medical Ninja',
        text = {
            "This Joker gains {C:mult}+#1#{} Mult",
            "for each scored {C:hearts}Heart{} card",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
        }
    },
    
    calculate = function(self, card, context)
        -- Phase 1: Upgrades the Joker when a Heart card is scored
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Hearts') and not context.blueprint then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    extra = {message = "Chakra!", colour = G.C.GREEN},
                    card = card
                }
            end
        end
        
        -- Phase 2: Applies the total accumulated Mult to the hand
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = localize{type='variable', key='a_mult', vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
})