SMODS.Atlas({
    key = "gaara_awakened_atlas",
    path = "gaara.png",
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "jinchuriki_awakening",
    name = "Jinchūriki Awakening",
    atlas = "gaara_awakened_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    
    config = { extra = { x_mult = 1.0, x_mult_gain = 0.2 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
    end,
    
    loc_txt = {
        name = 'Jinchūriki Awakening',
        text = {
            "If {C:attention}3 or fewer{} cards are discarded,",
            "gain {X:mult,C:white} X#2# {} Mult for each",
            "and permanently {C:attention}destroy{} them",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
        }
    },
    
    calculate = function(self, card, context)
        -- 1. Trigger during the discard phase
        if context.discard and not context.blueprint then
            local disc_count = #context.full_hand
            
            if disc_count > 0 and disc_count <= 3 then
                card.ability.extra.x_mult = card.ability.extra.x_mult + (card.ability.extra.x_mult_gain * disc_count)
                
                -- Safely remove the cards from all game pools (Deck, Hand, Discard)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for _, c in ipairs(context.full_hand) do
                            -- Remove from play and accounting lists entirely
                            c:juice_up()
                            c.getting_destroyed = true
                            
                            -- Take them out of whichever group they currently occupy
                            if c.area then
                                c.area:remove_card(c)
                            end
                            
                            -- Purge from the master playing card deck list so they are gone for good
                            for i = #G.playing_cards, 1, -1 do
                                if G.playing_cards[i] == c then
                                    table.remove(G.playing_cards, i)
                                    break
                                end
                            end
                            c:remove()
                        end
                        return true
                    end
                }))
                
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = 'Sand Coffin!', 
                    colour = G.C.RED
                })
            end
        end

        -- 2. Apply accumulated XMult during main scoring
        if context.joker_main and card.ability.extra.x_mult > 1.0 then
            return {
                message = 'X' .. card.ability.extra.x_mult,
                x_mult = card.ability.extra.x_mult,
                colour = G.C.RED
            }
        end
    end
})