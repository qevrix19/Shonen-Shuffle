SMODS.Atlas({
    key = "cyan_stake_atlas",
    path = "cyan_stake.png",
    px = 29,
    py = 29
})

SMODS.Stake({
    key = "cyan",
    atlas = "cyan_stake_atlas",
    pos = { x = 0, y = 0 },
    applied_stakes = { "gold" },
    above_stake = "gold",
    prefix_config = {
        applied_stakes = { mod = false },
        above_stake = { mod = false },
    },
    unlocked = true,
    loc_txt = {
        name = "Cyan Stake",
        text = {
            "Required score scales",
            "{C:attention}much faster{} for each Ante"
        }
    },
    colour = HEX("00E5FF"),
    shiny = true,

    modifiers = function()
        G.GAME.modifiers.scaling = 3
    end
})