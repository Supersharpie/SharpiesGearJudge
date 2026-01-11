local addonName, MSC = ...
local Warlock = {}
Warlock.Name = "WARLOCK"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Warlock.Weights = {
    ["Default"] = {
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.4, ["ITEM_MOD_SPIRIT_SHORT"]=0.2 
    },
    ["RAID_SHADOW"] = { -- SM/Ruin or DS/Ruin
        ["MSC_SPELL_HIT_PERCENT"]=16.0, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["MSC_SPELL_CRIT_PERCENT"]=11.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.3 
    },
    ["PVP_SL"] = { -- Soul Link Tank
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.6, 
        ["MSC_SPELL_CRIT_PERCENT"]=4.0 
    }
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Warlock.LevelingWeights = {
    ["Leveling_1_20"]  = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0 },
    ["Leveling_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
    ["Leveling_41_60"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 }
}

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Warlock.Talents = { 
    ["SUPPRESSION"]      = "Suppression",      -- Affliction Hit
    ["SIPHON_LIFE"]      = "Siphon Life",      -- Aff 21
    ["SOUL_LINK"]        = "Soul Link",        -- Demo 21
    ["DEMONIC_SAC"]      = "Demonic Sacrifice", -- Demo 21
    ["RUIN"]             = "Ruin",             -- Destro 21
    ["CONFLAGRATE"]      = "Conflagrate",      -- Destro 31
    ["DEMONIC_EMBRACE"]  = "Demonic Embrace"   -- Stamina %
}

-- =============================================================
-- LOGIC
-- =============================================================
function Warlock:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level < 60 then return "Leveling_41_60" end

    -- Soul Link is the PvP hallmark
    if Rank("SOUL_LINK") > 0 then return "PVP_SL" end
    
    -- Ruin is the PvE requirement
    if Rank("RUIN") > 0 then return "RAID_SHADOW" end
    
    return "Default"
end

function Warlock:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Demonic Embrace (Stamina Multiplier)
    local rEmb = Rank("DEMONIC_EMBRACE")
    if rEmb > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then 
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03)) 
    end

    -- 2. Suppression Hysteresis (Specific to Affliction/Drain/Corruption)
    if weights["MSC_SPELL_HIT_PERCENT"] then
        local currentHit = MSC.PlayerStats.SpellHit or 0
        local suppressionBonus = Rank("SUPPRESSION") * 2 -- 2% per rank in Era
        
        -- Crucial: Suppression only helps Affliction spells. 
        -- If DS/Ruin (Destro), we don't count Suppression toward our Shadow Bolt cap.
        local appliesToMainSpells = (Rank("RUIN") == 0) -- If we don't have Ruin, we are likely Affliction-heavy
        
        local totalHit = currentHit + (appliesToMainSpells and suppressionBonus or 0)
        
        if totalHit >= 16 then
            weights["MSC_SPELL_HIT_PERCENT"] = 1.0 -- Hard cap reached
            table.insert(activeCaps, "Spell Hit (16%)")
        elseif totalHit >= 12 then
            weights["MSC_SPELL_HIT_PERCENT"] = weights["MSC_SPELL_HIT_PERCENT"] * 0.6
            table.insert(activeCaps, "Hit (Near Cap)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Warlock:GetWeaponBonus(itemLink)
    -- Warlocks have no weapon-based racials in Era
    return 0
end

MSC.RegisterModule("WARLOCK", Warlock)