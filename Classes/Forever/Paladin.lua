local addonName, MSC = ...
local Paladin = {}
Paladin.Name = "PALADIN"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
Paladin.Weights = {
    ["Default"] = { ["ITEM_MOD_STRENGTH_SHORT"]=15.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=10.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["HOLY_RAID"] = {  ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=10.0  },
    ["HOLY_DEEP"] = {  ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=10.0  },
    ["PROT_DEEP"] = {  ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.0  },
    ["PROT_AOE"]  = {  ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.0  },
    ["RET_STANDARD"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["SHOCKADIN"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["RECK_BOMB"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=5.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
}

-- =============================================================
-- LEVELING LOGIC
-- =============================================================
Paladin.LevelingWeights = {
    ["Leveling_1_10"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_STRENGTH_SHORT"]=15.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=8.0, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=10.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_STRENGTH_SHORT"]=15.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=8.0, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=10.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_Ret_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Paladin.PrettyNames = {
    ["HOLY_RAID"]       = "Healer: Holy (Illumination)",
    ["HOLY_DEEP"]       = "Healer: Deep Holy (Buffs)",
    ["PROT_DEEP"]       = "Tank: Deep Protection",
    ["PROT_AOE"]        = "Farming: Protection AoE",
    ["RET_STANDARD"]    = "DPS: Retribution",
    ["SHOCKADIN"]       = "PvP: Shockadin (Burst)",
    ["RECK_BOMB"]       = "PvP: Reck-Bomb (One-Shot)",
    ["RET_UTILITY"]     = "Raid: Ret Utility (Nightfall)",
    
    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling (11-20)",
    ["Leveling_21_40"]      = "Leveling: Retribution (21-40)",
    ["Leveling_41_51"]      = "Leveling: Retribution (41-51)",
    ["Leveling_Ret_52_59"]  = "Leveling: Pre-BiS Ret (52-59)",
    ["Leveling_Tank_52_59"] = "Leveling: Pre-BiS Prot (52-59)",
    ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Holy (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Paladin.Talents = {
    ["DIVINE_STR"]      = "Divine Strength",
    ["DIVINE_INT"]      = "Divine Intellect",
    ["HOLY_SHOCK"]      = "Holy Shock",
    ["ILLUMINATION"]    = "Illumination",
    ["HOLY_SHIELD"]     = "Holy Shield",
    ["RECKONING"]       = "Reckoning",
    ["SACRED_DUTY"]     = "Sacred Duty",
    ["REPENTANCE"]      = "Repentance",
    ["VENGEANCE"]       = "Vengeance",
    ["TOUGHNESS"]       = "Toughness",
    ["CHAMPION_LIGHT"]  = "Champion of the Light",
    ["IMP_MIGHT"]       = "Improved Blessing of Might",
}

-- =============================================================
-- LOGIC
-- =============================================================
Paladin.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes
    [4]=true, [5]=true,   -- 1H/2H Maces
    [7]=true, [8]=true,   -- 1H/2H Swords
    [6]=true              -- Polearms
}

function Paladin:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Check First
    if level < 60 then
        if level <= 10 then return "Leveling_1_10" end
        if level <= 20 then return "Leveling_11_20" end
        if level <= 40 then return "Leveling_21_40" end
        if level <= 51 then return "Leveling_41_51" end
        return "Leveling_Ret_52_59"
    end

    -- Endgame Spec Detection
    if Rank("RECKONING") > 0 and Rank("VENGEANCE") > 0 then return "RECK_BOMB" end
    if Rank("REPENTANCE") > 0 and Rank("SACRED_DUTY") > 0 then return "RET_UTILITY" end
    if Rank("REPENTANCE") > 0 then return "RET_STANDARD" end
    if Rank("HOLY_SHIELD") > 0 then return "PROT_DEEP" end
    if Rank("HOLY_SHOCK") > 0 and Rank("SACRED_DUTY") == 0 then return "SHOCKADIN" end
    if Rank("ILLUMINATION") > 0 and Rank("SACRED_DUTY") > 0 then return "HOLY_RAID" end
    if Rank("ILLUMINATION") > 0 and Rank("IMP_MIGHT") > 0 then return "HOLY_DEEP" end
    return "HOLY_RAID"
end

function Paladin:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. Divine Strength (+10% Str) ]]
    local rStr = Rank("DIVINE_STR")
    if rStr > 0 and weights["ITEM_MOD_STRENGTH_SHORT"] then 
        weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02)) 
    end

    local rInt = Rank("DIVINE_INT")
    if rInt > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rInt * 0.02)) 
    end

    local rTough = Rank("TOUGHNESS")
    if rTough > 0 and weights["ITEM_MOD_ARMOR_SHORT"] then
        weights["ITEM_MOD_ARMOR_SHORT"] = weights["ITEM_MOD_ARMOR_SHORT"] * (1 + (rTough * 0.02))
    end

    local rSacred = Rank("SACRED_DUTY")
    if rSacred > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rSacred * 0.02))
    end

    local rChamp = Rank("CHAMPION_LIGHT")
    if rChamp > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] and (weights["ITEM_MOD_SPELL_POWER_SHORT"] or 0) > 0 then
        local spWeight = weights["ITEM_MOD_SPELL_POWER_SHORT"]
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (spWeight * (rChamp * 0.11))
    end

    -- [[ 2. Hit Cap (9%) ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        -- FIX: Use Shim
        local currentHit = MSC:GetPlayerStat("HIT") 
        if currentHit >= 9 then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0 -- Drop value but keep relevant for PvP
            table.insert(activeCaps, "Hit (9%)")
        end
    end
    
    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Paladin:GetWeaponBonus(itemLink, weights)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights)
end

function Paladin:GetRelicBonus(itemID, currentSpec)
    local bonus = {}
    if Paladin.Relics[itemID] then
        for k, v in pairs(Paladin.Relics[itemID]) do bonus[k] = v end
    end
    return bonus
end

-- =============================================================
-- LIBRAMS
-- Wiped for the beta (2026-09-21): these were real TBC Libram item IDs. TBC
-- content isn't part of Forever, so this starts blank and repopulates
-- organically with confirmed Forever Libram IDs, same as the ProcDB/TrinketDB
-- cleanup above.
-- =============================================================
Paladin.Relics = {}

-- Register Profiles for UI
Paladin.Profiles = {}
for k, v in pairs(Paladin.Weights) do Paladin.Profiles[k] = v end
for k, v in pairs(Paladin.LevelingWeights) do Paladin.Profiles[k] = v end

MSC.RegisterModule("PALADIN", Paladin)



