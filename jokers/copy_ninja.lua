SMODS.Atlas({
    key = "kakashi_atlas",
    path = "kakashi.png", -- Needs a 71x95 sprite named kakashi.png
    px = 71,
    py = 95
})

SMODS.Joker({
    key = 'copy_ninja',
    name = "The Copy Ninja",
    atlas = 'kakashi_atlas',
    pos = { x = 0, y = 0 }, 
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { } },
    
    loc_vars = function(self, info_queue, card)
        local left_desc = "Left: None"
        local right_desc = "Right: None"

        -- Safety check: only look for adjacent Jokers if the Joker bar actually exists
        if G.jokers and G.jokers.cards then
            local my_pos = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            
            local left_joker = my_pos > 1 and G.jokers.cards[my_pos - 1] or nil
            local right_joker = my_pos > 0 and my_pos < #G.jokers.cards and G.jokers.cards[my_pos + 1] or nil
            
            if left_joker and left_joker.config.center.blueprint_compat then left_desc = "<- " .. left_joker.ability.name
            elseif left_joker then left_desc = "<- Incompatible" end
            
            if right_joker and right_joker.config.center.blueprint_compat then right_desc = right_joker.ability.name .. " ->"
            elseif right_joker then right_desc = "Incompatible ->" end
        end
        
        return { vars = { left_desc, right_desc } }
    end,
    
    loc_txt = {
        name = 'The Copy Ninja',
        text = {
            "Copies abilities of",
            "{C:attention}Jokers{} to the {C:attention}left{} and {C:attention}right{}",
            "{C:inactive}#1#{}",
            "{C:inactive}#2#{}"
        }
    },
    
    calculate = function(self, card, context)
        local left_joker = nil
        local right_joker = nil

        -- Safety check: only look for adjacent Jokers if the Joker bar actually exists
        if G.jokers and G.jokers.cards then
            local my_pos = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            left_joker = my_pos > 1 and G.jokers.cards[my_pos - 1] or nil
            right_joker = my_pos > 0 and my_pos < #G.jokers.cards and G.jokers.cards[my_pos + 1] or nil
        end

        local function copy_target(target)
            if target and target ~= card and target.config.center.blueprint_compat then
                context.blueprint = (context.blueprint or 0) + 1
                context.blueprint_card = card
                local result = target:calculate_joker(context)
                context.blueprint = context.blueprint - 1
                return result
            end
            return nil
        end

        local left_res = copy_target(left_joker)
        local right_res = copy_target(right_joker)

        if not left_res and not right_res then return end

        if left_res and not right_res then 
            left_res.message = "Sharingan!"
            left_res.colour = G.C.RED
            return left_res 
        end
        if right_res and not left_res then 
            right_res.message = "Sharingan!"
            right_res.colour = G.C.RED
            return right_res 
        end

        local combined = {}
        for k, v in pairs(left_res) do combined[k] = v end
        
        for k, v in pairs(right_res) do
            if type(v) == "number" and combined[k] then
                if k == "Xmult_mod" then 
                    combined[k] = combined[k] * v
                else 
                    combined[k] = combined[k] + v
                end
            else
                combined[k] = v
            end
        end
        
        combined.message = "Kamui!"
        combined.colour = G.C.PURPLE
        return combined
    end
})