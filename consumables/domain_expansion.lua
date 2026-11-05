SMODS.Atlas({
    key = "domain_atlas",
    path = "domain.png", -- Make sure this matches your filename in assets/1x/
    px = 71,
    py = 95
})

SMODS.Consumable({
    key = "domain_expansion",
    set = "Spectral",
    atlas = "domain_atlas",
    pos = { x = 0, y = 0 },
    cost = 4,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = "Domain",
        text = {
            "Select {C:attention}1{} card, convert all",
            "other cards in hand to match it",
            "{C:red}-1{} hand size"
        }
    },
    can_use = function(self, card)
        return #G.hand.highlighted == 1 and G.hand.config.card_limit > 1
    end,
    use = function(self, card, area, copier)
        local selected = G.hand.highlighted[1]
        local targets = {}
        for _, c in ipairs(G.hand.cards) do
            if c ~= selected then targets[#targets + 1] = c end
        end

        -- activation visual
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.4,
            func = function()
                play_sound("tarot1")
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        -- flip targets face down
        for i, c in ipairs(targets) do
            local percent = 1.15 - (i - 0.999) / (#targets - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = "after", delay = 0.15,
                func = function()
                    c:flip()
                    play_sound("card1", percent)
                    c:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)

        -- copy the selected card onto every target
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.1,
            func = function()
                for _, c in ipairs(targets) do
                    copy_card(selected, c)
                end
                return true
            end
        }))

        -- flip back face up
        for i, c in ipairs(targets) do
            local percent = 0.85 + (i - 0.999) / (#targets - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = "after", delay = 0.15,
                func = function()
                    c:flip()
                    play_sound("tarot2", percent, 0.6)
                    c:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        -- hand size penalty, then deselect
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.2,
            func = function()
                G.hand:change_size(-1)
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
})