SMODS.Atlas({
    key = "awakening_atlas",
    path = "awakening.png", -- Place your awakening sprite inside assets/1x/
    px = 71,
    py = 95
})

SMODS.Consumable({
    key = "awakening",
    set = "Spectral",
    atlas = "awakening_atlas",
    pos = { x = 0, y = 0 },
    cost = 4,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = "Awakening",
        text = {
            "Add {C:dark_edition}Polychrome{} and a",
            "{C:attention}Red Seal{} to 1 selected",
            "card, destroys a random",
            "{C:attention}Joker{} if able"
        }
    },
    can_use = function(self, card)
        -- Only requires exactly 1 card selected in hand; no longer locked behind having a Joker!
        return #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local selected = G.hand.highlighted[1]

        -- Activation visual and sound
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.4,
            func = function()
                play_sound("tarot1")
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        -- Apply Polychrome edition to the selected card
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.2,
            func = function()
                selected:set_edition({polychrome = true}, true)
                return true
            end
        }))

        -- Apply Red Seal (retrigger enhancement) to the selected card
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.2,
            func = function()
                selected:set_seal("Red")
                selected:juice_up(0.3, 0.3)
                return true
            end
        }))

        -- Destroy a random Joker ONLY if you have one available
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.3,
            func = function()
                if G.jokers and #G.jokers.cards > 0 then
                    local random_joker = pseudorandom_element(G.jokers.cards, pseudoseed("awakening_sacrifice"))
                    random_joker:start_dissolve(nil, true)
                end
                return true
            end
        }))

        -- Clean up selection
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
})