SMODS.Atlas({
    key = "kurapika_atlas",
    path = "kurapika.png", -- Needs a 71x95 sprite named kurapika.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "chain_user",
    name = "Chain User",
    atlas = "kurapika_atlas",
    pos = {x = 0, y = 0},
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { chips = 0, chip_gain = 25 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,

    loc_txt = {
        name = "Chain User",
        text = {
            "Gains {C:chips}+#1#{} Chips per played hand.",
            "Gains an {C:attention}extra boost{} if played",
            "hand contains a {C:attention}Face card{}.",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips){}"
        }
    },

    calculate = function(self, card, context)
        -- 1. Main Joker Scoring (Apply Chips)
        if context.joker_main then
            if card.ability.extra.chips > 0 then
                return {
                    message = '+' .. card.ability.extra.chips .. ' Chips',
                    chips = card.ability.extra.chips,
                    colour = G.C.CHIPS
                }
            end
        end

        -- 2. Scale chips after playing any hand
        if context.after and not context.blueprint then
            local has_face = false
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() then
                    has_face = true
                    break
                end
            end

            -- Double the gain if a face card is involved
            local current_gain = card.ability.extra.chip_gain
            if has_face then
                current_gain = current_gain * 2
            end

            card.ability.extra.chips = card.ability.extra.chips + current_gain
            card:juice_up(0.5, 0.5)
            
            return {
                message = has_face and 'Chain Jail!' or 'Bound!',
                colour = G.C.CHIPS,
                card = card
            }
        end
    end
})