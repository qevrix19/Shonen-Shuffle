SMODS.Atlas({
    key = "mash_atlas",
    path = "mash.png", -- Needs a 71x95 sprite named mash.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "muscle_magic",
    name = "Muscle Magic",
    atlas = "mash_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { chips = 0, chip_gain = 30 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
    end,
    
    loc_txt = {
        name = 'Muscle Magic',
        text = {
            "Gains {C:chips}+#2#{} Chips if",
            "played hand contains",
            "{C:attention}no{} enhanced cards",
            "{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Check for "No Magic" during the setup phase of the hand
        if context.before and not context.blueprint then
            local no_magic = true
            
            -- Scan every card in the played hand
            if context.full_hand then
                for _, played_card in ipairs(context.full_hand) do
                    -- If any card is not a standard base card (e.g., Glass, Steel, Mult), it has "magic"
                    if played_card.config.center ~= G.P_CENTERS.c_base then
                        no_magic = false
                        break
                    end
                end
            end
            
            -- If no magic was used, Mash eats a cream puff and gets stronger
            if no_magic then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                return {
                    message = 'Cream Puff!',
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end

        -- 2. Apply his massive muscle (Chips) during main scoring
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
    end
})