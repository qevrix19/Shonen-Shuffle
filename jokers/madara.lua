SMODS.Atlas({
    key = "madara_atlas",
    path = "madara.png", -- Needs a 71x95 sprite named madara.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "madara_uchiha",
    name = "The Ghost of the Uchiha",
    atlas = "madara_atlas",
    pos = {x = 0, y = 0},
    rarity = 4, -- Legendary
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { x_mult = 2.0, x_mult_gain = 0.35 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult } }
    end,

    loc_txt = {
        name = "The Ghost of the Uchiha",
        text = {
            "Gains {X:mult,C:white} X#1# {} Mult when",
            "any {C:attention}Blind{} is defeated.",
            "Creates a {C:spectral}Spectral{} card when",
            "round begins {C:inactive}(Must have room)",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },

    calculate = function(self, card, context)
        -- 1. Main Joker Scoring (Apply X-Mult)
        if context.joker_main then
            if card.ability.extra.x_mult > 1 then
                return {
                    message = 'X' .. card.ability.extra.x_mult,
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.RED
                }
            end
        end

        -- 2. Scale when any blind is defeated
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if context.game_over == false and G.GAME.blind.boss then
                -- Extra scaling boost if it's a Boss Blind
                card.ability.extra.x_mult = card.ability.extra.x_mult + (card.ability.extra.x_mult_gain * 2)
            else
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
            end

            card:juice_up(0.8, 0.8)
            return {
                message = 'Wake to Reality...',
                colour = G.C.PURPLE,
                card = card
            }
        end

-- 3. Generate a Spectral card at the start of the round (with a chance for The Soul)
        if context.setting_blind and not context.blueprint then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        -- 10% chance to pull The Soul, 90% chance for a random Spectral card
                        local card_key = nil
                        if math.random() < 0.10 then
                            card_key = 'c_soul'
                        end

                        SMODS.add_card({set = 'Spectral', key = card_key})
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
                        return true
                    end
                }))
                return {
                    message = 'Infinite Tsukuyomi',
                    colour = G.C.SECONDARY_SET.Spectral
                }
            end
        end
    end,
})