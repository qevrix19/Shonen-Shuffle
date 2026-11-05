-- 1. Register the Jujutsu Kaisen Atlas
SMODS.Atlas({
    key = "jjk_atlas",
    path = "jjk_atlas.png",
    px = 71,
    py = 95
})

-- 2. Define the Cursed Spirit Joker
SMODS.Joker({
    key = "cursed_spirit",
    name = "Cursed Spirit",
    atlas = "jjk_atlas",
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    -- Store our custom variables here
    config = { extra = { mult = 0, mult_gain = 4, domain_threshold = 40, domain_xmult = 2 } },
    
    -- Inject variables into the description text
   loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.domain_threshold, card.ability.extra.domain_xmult, card.ability.extra.mult } }
    end,

    loc_txt = {
        name = 'Cursed Spirit',
        text = {
            "Gains {C:mult}+#1#{} Mult per played hand.",
            "When this has {C:mult}+#2#{} Mult or more,",
            "played cards matching the first",
            "scoring suit give {X:mult,C:white}X#3#{} Mult.",
            "{C:inactive}(Resets Mult to 0 after scoring){}",
            "{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}"
        }
    },
    
    -- The core mechanics
    calculate = function(self, card, context)
        -- A. Add the stored Flat Mult during the main Joker scoring phase
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult,
                card = card
            }
        end

        -- B. Trigger the Domain Expansion X2 Mult on individual played cards
        if context.individual and context.cardarea == G.play then
            if card.ability.extra.mult >= card.ability.extra.domain_threshold then
                -- Identify the "primary suit" based on the first scoring card
                local primary_suit = context.scoring_hand[1].base.suit
                if context.other_card:is_suit(primary_suit) then
                    return {
                        x_mult = card.ability.extra.domain_xmult,
                        card = card
                    }
                end
            end
        end

        -- C. Gain Mult after the hand finishes, or Reset if Domain was activated
        if context.after and not context.blueprint then
            if card.ability.extra.mult >= card.ability.extra.domain_threshold then
                -- Domain closes, reset Cursed Energy
                card.ability.extra.mult = 0
                return {
                    message = "Domain Closed!",
                    colour = G.C.FILTER
                }
            else
                -- Gather Cursed Energy
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = "+" .. card.ability.extra.mult_gain .. " Energy",
                    colour = G.C.MULT
                }
            end
        end
    end
})