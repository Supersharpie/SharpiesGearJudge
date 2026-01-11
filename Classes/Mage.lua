local addonName, MSC = ...
local Mage = {}
Mage.Name = "MAGE"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Mage.Weights = {
    ["Default"] = {
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_STAMINA_SHORT"]=0.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 
    },
    ["FIRE_RAID"] = {
        ["MSC_SPELL_CRIT_PERCENT"]=15.0, -- Ignite is the multiplier in Era
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, 
        ["MSC_SPELL_HIT_PERCENT"]=14.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.2 
    },
    ["FROST_PVE"] = {
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["MSC_SPELL_HIT_PERCENT"]=16.0, 
        ["MSC_SPELL_CRIT_PERCENT"]=10.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.3 
    },
    ["FROST_AOE"] = {
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, -- Survival is everything in AoE
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.0 -- Regen between pulls
    },
    ["FROST_PVP"] = {
        ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.6, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["MSC_SPELL_CRIT_PERCENT"]=8.0 
    }
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Mage.LevelingWeights = {
    ["Leveling_1_20"]  = { ["MSC_WAND_DPS"]=5.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_21_40"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
    ["Leveling_41_51"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["MSC_SPELL_HIT_PERCENT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },

    ["Leveling_AoE_21_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.8, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 }
}

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Mage.Talents = { 
    ["ELEMENTAL_PRECISION"] = "Elemental Precision",
    ["ARCANE_POWER"]    = "Arcane Power",  
    ["COMBUSTION"]      = "Combustion",   
    ["ICE_BARRIER"]     = "Ice Barrier",  
    ["WINTERS_CHILL"]   = "Winter's Chill",
    ["IMP_BLIZZARD"]    = "Improved Blizzard",
    ["ARCANE_MIND"]     = "Arcane Mind"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Mage:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        if Rank("IMP_BLIZZARD") >= 2 then return "Leveling_AoE_21_59" end
        
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("COMBUSTION") > 0 then return "FIRE_RAID" end
    if Rank("ICE_BARRIER") > 0 then
        if Rank("WINTERS_CHILL") > 0 then return "FROST_PVE" end
        return "FROST_PVP"
    end
    
    return "Default"
end

function Mage:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Arcane Mind Multiplier (Int Scaling)
    local rAM = Rank("ARCANE_MIND")
    if rAM > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAM * 0.02)) 
    end
    
    -- 2. Covariance (Crit Value scales with Spell Power)
    -- In Era, Crit is more valuable when you have high SP for Ignite/Shatter procs
    if weights["MSC_SPELL_CRIT_PERCENT"] then
        local sp = MSC.PlayerStats.SpellPower or 0
        if sp > 400 then
            local spScaler = 1 + ((sp - 400) / 4000)
            weights["MSC_SPELL_CRIT_PERCENT"] = weights["MSC_SPELL_CRIT_PERCENT"] * spScaler
        end
    end

    -- 3. Spell Hit Cap (16% in Era)
    if weights["MSC_SPELL_HIT_PERCENT"] then
        local currentHit = MSC.PlayerStats.SpellHit or 0
        local talentHit = 0
        
        -- Elemental Precision only works on Fire and Frost
        if currentSpec:find("FIRE") or currentSpec:find("FROST") then
            talentHit = Rank("ELEMENTAL_PRECISION") * 2 -- 2% per rank in Era
        end
        
        local totalHit = currentHit + talentHit
        if totalHit >= 16 then
            weights["MSC_SPELL_HIT_PERCENT"] = 1.0 -- Cap reached
            table.insert(activeCaps, "Hit (16%)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Mage:GetWeaponBonus(itemLink) return 0 end

MSC.RegisterModule("MAGE", Mage)