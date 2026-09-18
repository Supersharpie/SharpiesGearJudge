local addonName, MSC = ...
local Warrior = {}
Warrior.Name = "WARRIOR"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
Warrior.Weights = {
    ["Default"] = { ["ITEM_MOD_STRENGTH_SHORT"]=15.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=10.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=13.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["FURY_2H"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=13.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["FURY_DW"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=13.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["ARMS_MS"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=13.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["DEEP_PROT"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=13.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["FURY_PROT"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=13.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["ARMS_PROT"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STRENGTH_SHORT"]=15.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.8, ["ITEM_MOD_PARRY_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=10.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=13.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
}

-- =============================================================
-- LEVELING WEIGHTS (The Spirit Meta)
-- =============================================================
Warrior.LevelingWeights = {
    -- Standard Arms/2H Fury
    ["Leveling_1_20"]  = { ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=5.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_STRENGTH_SHORT"]=15.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=10.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=13.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=5.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    
    -- Dual Wield Fury Leveling
    ["Leveling_DW_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_DW_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_DW_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },

    -- Tank Leveling
    ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.2, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.2, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.2, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Warrior.PrettyNames = {
    ["FURY_DW"]         = "Raid: Fury (Dual Wield)",
    ["FURY_2H"]         = "Raid: Fury (2H Slam)",
    ["ARMS_MS"]         = "PvP: Arms (Mortal Strike)",
    ["DEEP_PROT"]       = "Tank: Deep Protection",
    ["FURY_PROT"]       = "Tank: Fury-Prot (Threat)",
    ["ARMS_PROT"]       = "Tank: Arms (Dungeon Hybrid)",
    
    ["Leveling_1_20"]       = "Leveling (1-20)",
    ["Leveling_21_40"]      = "Leveling: Arms/Fury (21-40)",
    ["Leveling_41_51"]      = "Leveling: Arms/Fury (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Fury (52-59)",
    
    ["Leveling_DW_21_40"]   = "Leveling: Dual Wield (21-40)",
    ["Leveling_DW_41_51"]   = "Leveling: Dual Wield (41-51)",
    ["Leveling_DW_52_59"]   = "Leveling: Dual Wield (52-59)",
    
    ["Leveling_Tank_21_40"] = "Leveling: Tank (21-40)",
    ["Leveling_Tank_41_51"] = "Leveling: Tank (41-51)",
    ["Leveling_Tank_52_59"] = "Leveling: Tank (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Warrior.Talents = { 
    ["MORTAL_STRIKE"]    = "Mortal Strike",
    ["BLOODTHIRST"]      = "Bloodthirst",
    ["SHIELD_SLAM"]      = "Shield Slam",
    ["DEFIANCE"]         = "Defiance",
    ["IMP_SLAM"]         = "Improved Slam",
    ["DW_SPEC"]          = "Dual Wield Specialization",
    ["TACTICAL_MASTERY"] = "Improved Tactical Mastery", -- Renamed in Forever
    ["IMPALE"]           = "Impale",
    ["CRUELTY"]          = "Cruelty",
    ["FLURRY"]           = "Flurry",
    ["TOUGHNESS"]        = "Toughness",
    ["VITALITY"]         = "Vitality",
}

-- =============================================================
-- LOGIC
-- =============================================================
Warrior.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes
    [4]=true, [5]=true,   -- 1H/2H Maces
    [7]=true, [8]=true,   -- 1H/2H Swords
    [6]=true,             -- Polearms
    [10]=true,            -- Staves
    [13]=true, [15]=true, -- Fists, Daggers
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Crossbow, Thrown
}

Warrior.EndgameTabMap = { [1] = "ARMS_MS", [2] = "FURY_DW", [3] = "DEEP_PROT" }

function Warrior:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("SHIELD_SLAM") > 0 then return "DEEP_PROT", "high" end
        if Rank("BLOODTHIRST") > 0 and Rank("DEFIANCE") > 0 then return "FURY_PROT", "high" end
        if Rank("TACTICAL_MASTERY") > 0 and Rank("DEFIANCE") > 0 then return "ARMS_PROT", "high" end
        if Rank("BLOODTHIRST") > 0 and Rank("IMP_SLAM") > 0 then return "FURY_2H", "high" end
        if Rank("BLOODTHIRST") > 0 then return "FURY_DW", "high" end
        if Rank("MORTAL_STRIKE") > 0 then return "ARMS_MS", "high" end
        local fallback, conf = MSC:GetDominantTalentTree(Warrior.EndgameTabMap, 5)
        if fallback then return fallback, conf end
        return "FURY_DW", "ambiguous"
    end

    -- [[ 2. LEVELING SPEC DETECTION ]]
    -- Fix: Match the strings to the LevelingWeights table exactly
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    else suffix = "_52_59" end

    -- Determine Role based on Talents
    local role = "Leveling" -- Default to 2H/Arms style
    if Rank("SHIELD_SLAM") > 0 or Rank("DEFIANCE") > 0 then 
        role = "Leveling_Tank"
    elseif Rank("DW_SPEC") > 0 or Rank("BLOODTHIRST") > 0 then 
        role = "Leveling_DW"
    end

    -- Construct Key (e.g., "Leveling_DW_21_40")
    local specificKey = role .. suffix
    
    -- Check if it exists, otherwise fall back to generic
    if Warrior.LevelingWeights[specificKey] then return specificKey, "high" end
    if Warrior.LevelingWeights["Leveling" .. suffix] then return "Leveling" .. suffix, "high" end
    
    return "Leveling_1_20", "low"
end

function Warrior:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    local rTough = Rank("TOUGHNESS")
    if rTough > 0 and weights["ITEM_MOD_ARMOR_SHORT"] then
        weights["ITEM_MOD_ARMOR_SHORT"] = weights["ITEM_MOD_ARMOR_SHORT"] * (1 + (rTough * 0.02))
    end

    local rVit = Rank("VITALITY")
    if rVit > 0 then
        if weights["ITEM_MOD_STAMINA_SHORT"] then weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rVit * 0.02)) end
        if weights["ITEM_MOD_STRENGTH_SHORT"] then weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rVit * 0.02)) end
    end


    -- [[ 1. HIT CAP (Using Shim) ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        local currentHit = MSC:GetPlayerStat("HIT") 
        local yellowCap = 9
        
        if currentHit >= yellowCap then
            -- Hit is still good for DW (White hits), but weight drops for 2H
            local mult = (currentSpec:find("DW")) and 0.5 or 0.1
            weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * mult
            table.insert(activeCaps, "Yellow Hit ("..yellowCap.."%)")
        end
    end

    -- [[ 2. WEAPON SKILL CAP (Removed in Forever) ]]

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Warrior:GetWeaponBonus(itemLink, weights)
    return 0
end

-- =============================================================
-- REGISTER
-- =============================================================
Warrior.Profiles = {}
for k, v in pairs(Warrior.Weights) do Warrior.Profiles[k] = v end
for k, v in pairs(Warrior.LevelingWeights) do Warrior.Profiles[k] = v end

MSC.RegisterModule("WARRIOR", Warrior)
