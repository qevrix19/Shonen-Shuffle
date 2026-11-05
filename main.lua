-- 1. Register your Atlases
SMODS.Atlas({
    key = "overdrive_jokers",
    path = "jokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "cursed_spirit",
    path = "jjk_atlas.png",
    px = 71,
    py = 95
})

-- 2. Automatically load all files from the jokers folder
local files = NFS.getDirectoryItems(SMODS.current_mod.path .. "jokers")
for _, file in ipairs(files) do
    if string.sub(file, -4) == ".lua" then
        print("Loading anime joker: " .. file)
        assert(SMODS.load_file("jokers/" .. file))()
    end
end

-- Automatically load all files from the stakes folder
local stake_files = NFS.getDirectoryItems(SMODS.current_mod.path .. "stakes")
for _, file in ipairs(stake_files) do
    if string.sub(file, -4) == ".lua" then
        print("Loading anime stake: " .. file)
        assert(SMODS.load_file("stakes/" .. file))()
    end
end

-- 3. Define Voucher Directly
SMODS.Atlas({
    key = "atlas_senzu",
    path = "senzu_bean.png", -- Double-check your image is named exactly this
    px = 71,
    py = 95
})

SMODS.Voucher({
    key = "senzu_bean",
    atlas = "atlas_senzu",
    pos = {x = 0, y = 0},
    config = { extra = 1 }, -- Failsafe to prevent UI rendering errors
    cost = 10,
    unlocked = true,
    discovered = true,
    
    loc_txt = {
        name = "Senzu Bean",
        text = {
            "{C:attention}+1{} Joker Slot"
        }
    },
    
    redeem = function(self)
        if G.jokers then
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
    end
})

-- 1. Register the Tier 2 Atlas
SMODS.Atlas({
    key = "atlas_potara",
    path = "potara.png", -- You will need a 71x95 image named potara.png
    px = 71,
    py = 95
})

-- 2. Define the Tier 2 Voucher (Potara Earrings)
SMODS.Voucher({
    key = "potara_earrings",
    atlas = "atlas_potara",
    pos = {x = 0, y = 0},
    config = { extra = 1 },
    -- This is the magic line that makes it a Tier 2 upgrade:
    requires = {'v_senzu_bean'},
    cost = 10,
    unlocked = true,
    discovered = true,
    
    loc_txt = {
        name = "Potara Earrings",
        text = {
            "{C:attention}+1{} Joker Slot",
            "{C:attention}+1{} Consumable Slot"
        }
    },
    
    redeem = function(self)
        if G.jokers then
            -- Adds the second extra Joker slot
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
        if G.consumeables then
            -- Adds an extra consumable slot for Tarot/Planet cards
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
        end
    end
})


-- 1. Atlas for the Base Voucher
SMODS.Atlas({
    key = "wanted_poster_atlas",
    path = "wanted_poster.png", -- Needs a 71x95 sprite named wanted_poster.png in assets/1x/
    px = 71,
    py = 95
})

-- 2. Atlas for the Upgrade Voucher
SMODS.Atlas({
    key = "yonko_bounty_atlas",
    path = "yonko_bounty.png", -- Needs a 71x95 sprite named yonko_bounty.png in assets/1x/
    px = 71,
    py = 95
})

-- Base Voucher: Wanted Poster
SMODS.Voucher({
    key = "wanted_poster",
    name = "Wanted Poster",
    atlas = "wanted_poster_atlas",
    pos = {x = 0, y = 0},
    cost = 10,
    unlocked = true,
    discovered = true,
    
    loc_txt = {
        name = 'Wanted Poster',
        text = {
            "Earn {C:money}$2{} extra at the end",
            "of the round for every",
            "remaining {C:attention}Hand{}"
        }
    },
    
    redeem = function(self)
        -- Vanilla Balatro defaults to 1. This bumps it to 3.
        G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 1) + 2
    end
})

-- Upgrade Voucher: Yonko Bounty
SMODS.Voucher({
    key = "yonko_bounty",
    name = "Yonko Bounty",
    atlas = "yonko_bounty_atlas",
    pos = {x = 0, y = 0},
    requires = {"v_YOURPREFIX_wanted_poster"}, -- Replace YOURPREFIX with your mod's actual prefix!
    cost = 10,
    unlocked = true,
    discovered = true,
    
    loc_txt = {
        name = 'Yonko Bounty',
        text = {
            "Earn an additional {C:money}$3{}",
            "at the end of the round for every",
            "remaining {C:attention}Hand{}"
        }
    },
    
    redeem = function(self)
        -- Stacks on top of Wanted Poster. Bumps it to 5.
        G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 1) + 3
    end
})

-- Automatically load all consumable scripts from the consumables folder
local consumables_dir = SMODS.current_mod.path .. "consumables"
for _, file in ipairs(NFS.getDirectoryItems(consumables_dir)) do
    if string.sub(file, -4) == ".lua" then
        assert(SMODS.load_file("consumables/" .. file))()
    end
end