SMODS.Atlas({
    key = "inumaki_atlas",
    path = "inumaki.png", -- Needs a 71x95 sprite named inumaki.png in assets/1x/
    px = 71,
    py = 95
})

SMODS.Joker({
    key = "cursed_speech",
    name = "Cursed Speech",
    atlas = "inumaki_atlas",
    pos = {x = 0, y = 0},
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false, -- Must be false so his throat can give out
    perishable_compat = true,
    
    config = { extra = { x_mult = 4, odds = 3 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, G.GAME.probabilities.normal, card.ability.extra.odds } }
    end,
    
    loc_txt = {
        name = 'Cursed Speech',
        text = {
            "Gives {X:mult,C:white} X#1# {} Mult",
            "{C:green}#2# in #3#{} chance this",
            "card is destroyed",
            "at end of round"
        }
    },
    
    calculate = function(self, card, context)
        -- Phase 1: Massive flat XMult during the scoring phase
        if context.joker_main then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.x_mult}},
                Xmult_mod = card.ability.extra.x_mult,
                colour = G.C.PURPLE
            }
        end

        -- Phase 2: Roll the odds at the end of the round
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if pseudorandom('cursed_speech') < G.GAME.probabilities.normal / card.ability.extra.odds then
                -- He fails the roll and is destroyed
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = "Tuna Mayo!",
                    colour = G.C.RED
                }
            else
                -- He passes the roll and survives
                return {
                    message = "Safe!",
                    colour = G.C.GREEN
                }
            end
        end
    end
})