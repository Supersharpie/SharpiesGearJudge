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
        ["Leveling_1_20"]  = { ["ITEM_MOD_ARMOR_SHORT"]= 0.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=6.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.3, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=8.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.4 },
        ["Leveling_Ret_52_59"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
        ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
        ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        ["Leveling_52_59"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
    }

-- =============================================================
-- DISPLAY NAMES (For Options Menu)
-- =============================================================
Paladin.PrettyNames = {
        -- Endgame
        ["HOLY_RAID"]       = "Healer: Holy (Illumination)",
        ["HOLY_DEEP"]       = "Healer: Deep Holy (Buffs)",
        ["PROT_DEEP"]       = "Tank: Deep Protection",
        ["PROT_AOE"]        = "Farming: Protection AoE",
        ["RET_STANDARD"]    = "DPS: Retribution",
        ["SHOCKADIN"]       = "PvP: Shockadin (Burst)",
        ["RECK_BOMB"]       = "PvP: Reck-Bomb (One-Shot)",
        ["RET_UTILITY"]     = "Raid: Ret Utility (Nightfall)",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Retribution (21-40)",
        ["Leveling_41_51"]      = "Leveling: Retribution (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Ret (52-59)",
        
        ["Leveling_Ret_52_59"]  = "Leveling: Pre-BiS Ret (52-59)",
        
        ["Leveling_Tank_41_51"] = "Leveling: Prot (41-51)",
        ["Leveling_Tank_52_59"] = "Leveling: Pre-BiS Prot (52-59)",
        
        ["Leveling_Healer_41_51"] = "Leveling: Holy (41-51)",
        ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Holy (52-59)",
    }

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Paladin.Talents = {
        ["HOLY_SHOCK"]      = "Holy Shock",
        ["ILLUMINATION"]    = "Illumination",
        ["HOLY_SHIELD"]     = "Holy Shield",
        ["RECKONING"]       = "Reckoning",
        ["KINGS"]           = "Blessing of Kings",
        ["REPENTANCE"]      = "Repentance",
        ["VENGEANCE"]       = "Vengeance",
        ["IMP_MIGHT"]       = "Improved Blessing of Might",
        ["DIVINE_STR"]      = "Divine Strength",
        ["DIVINE_INT"]      = "Divine Intellect",
        ["PRECISION"]       = "Precision",
        ["REDOUBT"]         = "Redoubt", 
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
    if Rank("RECKONING") > 0 and Rank("VENGEANCE") > 0 then return "RECK_BOMB" end
    if Rank("REPENTANCE") > 0 and Rank("KINGS") > 0 then return "RET_UTILITY" end
    if Rank("REPENTANCE") > 0 then return "RET_STANDARD" end
    if Rank("HOLY_SHIELD") > 0 then return "PROT_DEEP" end
    if Rank("HOLY_SHOCK") > 0 and Rank("KINGS") == 0 then return "SHOCKADIN" end
    if Rank("ILLUMINATION") > 0 and Rank("KINGS") > 0 then return "HOLY_RAID" end
    if Rank("ILLUMINATION") > 0 and Rank("IMP_MIGHT") > 0 then return "HOLY_DEEP" end
    return "HOLY_RAID"
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

    -- 2. Era Hit Cap (9%)
    -- FIX: Changed MSC_HIT_PERCENT -> ITEM_MOD_HIT_RATING_SHORT
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        local currentHit = MSC.PlayerStats.Hit or 0 
        if currentHit >= 9 then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0 
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
	[23201] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 45, estimate = true, replace = true }, -- Libram of Divinity
    [22396] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 45, estimate = true, replace = true }, -- Libram of Truth
    [22402] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 8, estimate = true, replace = true }, -- Libram of Hope
    [23006] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 25, estimate = true, replace = true },   -- Libram of Fervor
}

MSC.RegisterModule("PALADIN", Paladin)