local addonName, MSC = ...
local Paladin = {}
Paladin.Name = "PALADIN"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Merged from your Era data)
-- =============================================================
Paladin.Weights = {
    ["Default"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
    ["HOLY_RAID"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["MSC_CRIT_PERCENT"]=14.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=0.2 },
    ["HOLY_DEEP"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=4.0, ["MSC_CRIT_PERCENT"]=8.0 },
    ["PROT_DEEP"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_SHORT"]=1.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.6, ["MSC_DODGE_PERCENT"]=1.5, ["MSC_PARRY_PERCENT"]=1.5 },
    ["PROT_AOE"]  = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.4, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.5 },
    ["RET_STANDARD"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.3, ["MSC_CRIT_PERCENT"]=25.0, ["MSC_HIT_PERCENT"]=22.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2 },
    ["SHOCKADIN"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["MSC_CRIT_PERCENT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.5 },
    ["RECK_BOMB"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["MSC_CRIT_PERCENT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
}

-- =============================================================
-- LEVELING LOGIC (Using your brackets)
-- =============================================================
Paladin.LevelingWeights = {
    ["Leveling_1_20"]    = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.5 },
    ["Leveling_21_40"]   = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["MSC_CRIT_PERCENT"]=6.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_41_51"]   = { ["ITEM_MOD_STRENGTH_SHORT"]=2.3, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["MSC_CRIT_PERCENT"]=10.0, ["MSC_HIT_PERCENT"]=8.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.4 },
    ["Leveling_Ret_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["MSC_CRIT_PERCENT"]=15.0, ["MSC_HIT_PERCENT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
}

-- =============================================================
-- SPEC DETECTION (Upgraded for your specific Era archetypes)
-- =============================================================
function Paladin:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Check First
    if level < 60 then
        if level <= 20 then return "Leveling_1_20" end
        if level <= 40 then return "Leveling_21_40" end
        if level <= 51 then return "Leveling_41_51" end
        return "Leveling_Ret_52_59"
    end

    -- Endgame Spec Detection
    if Rank("HOLY_SHIELD") > 0 then return "PROT_DEEP" end
    if Rank("SANCTUARY") > 0 and Rank("CONSECRATION") > 0 then return "PROT_AOE" end
    if Rank("REPENTANCE") > 0 then return "RET_STANDARD" end
    if Rank("RECKONING") >= 4 then return "RECK_BOMB" end
    if Rank("HOLY_SHOCK") > 0 and Rank("DIVINE_STRENGTH") > 0 then return "SHOCKADIN" end
    if Rank("ILLUMINATION") > 0 then return "HOLY_RAID" end
    
    return "Default"
end

-- =============================================================
-- SCALERS (Applying the TBC logic to Era)
-- =============================================================
function Paladin:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Divine Strength/Intellect % Multipliers
    local rStr = Rank("DIVINE_STR")
    if rStr > 0 and weights["ITEM_MOD_STRENGTH_SHORT"] then 
        weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02)) 
    end

    -- 2. Era Hit Cap (9% is the goal for Yellow hits)
    if weights["MSC_HIT_PERCENT"] then
        -- You'll need an Era-compatible way to track total hit from gear
        local currentHit = MSC.PlayerStats.Hit or 0 
        if currentHit >= 9 then
            weights["MSC_HIT_PERCENT"] = 2.0 -- Drastically drop value after cap
            table.insert(activeCaps, "Hit (9%)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

-- =============================================================
-- ERA RELIC MAPPING
-- =============================================================
Paladin.Relics = {
    [22399] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 53 }, -- Libram of Divinity (Flash of Light)
    [23006] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 80 }, -- Libram of Hope (Holy Light)
    [23203] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 40 },  -- Libram of Fervor (Crusader Strike - SoD)
}

MSC.RegisterModule("PALADIN", Paladin)