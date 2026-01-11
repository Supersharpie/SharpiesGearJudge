local addonName, MSC = ...
local Warrior = {}
Warrior.Name = "WARRIOR"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Warrior.Weights = {
        ["Default"] = {
			["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.3, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
        ["FURY_2H"] = {
			["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 7.5, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.3, ["ITEM_MOD_CRIT_RATING_SHORT"] = 28.0, ["ITEM_MOD_HIT_RATING_SHORT"] = 12.0, ["ITEM_MOD_STAMINA_SHORT"] = 0.5 },
        ["FURY_DW"] = {
			["ITEM_MOD_HIT_RATING_SHORT"] = 22.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 18.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 30.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.5, ["ITEM_MOD_STAMINA_SHORT"] = 0.5 },
        ["ARMS_MS"] = {
			["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 8.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 28.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.2, ["ITEM_MOD_STAMINA_SHORT"] = 1.5 },
        ["DEEP_PROT"] = {
			["ITEM_MOD_STAMINA_SHORT"] = 1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 0.6, ["ITEM_MOD_HIT_RATING_SHORT"] = 10.0, ["ITEM_MOD_DODGE_RATING_SHORT"] = 12.0, ["ITEM_MOD_PARRY_RATING_SHORT"] = 12.0, ["ITEM_MOD_STRENGTH_SHORT"] = 0.5 },
        ["FURY_PROT"] = {
			["ITEM_MOD_HIT_RATING_SHORT"] = 22.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 20.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_STAMINA_SHORT"] = 1.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.5 },
        ["ARMS_PROT"] = {
			["ITEM_MOD_STAMINA_SHORT"] = 1.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 20.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.8, ["ITEM_MOD_PARRY_RATING_SHORT"] = 10.0 },
    }

-- =============================================================
-- LEVELING WEIGHTS (The Spirit Meta)
-- =============================================================
Warrior.LevelingWeights = {
        -- Standard Arms/2H Fury
        ["Leveling_1_20"]  = { ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=5.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=8.0, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
        ["Leveling_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.2 },
        
        -- [NEW] Dual Wield Fury Leveling (Needs Hit!)
        ["Leveling_DW_21_40"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_DW_41_51"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_DW_52_59"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },

        -- Tank Leveling (Dungeon Grinding)
        ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.1, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=5.0 },
        ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=10.0 },
    }

-- =============================================================
-- DISPLAY NAMES (For Options Menu)
-- =============================================================
Warrior.PrettyNames = {
        -- Endgame
        ["FURY_DW"]         = "Raid: Fury (Dual Wield)",
        ["FURY_2H"]         = "Raid: Fury (2H Slam)",
        ["ARMS_MS"]         = "PvP: Arms (Mortal Strike)",
        ["DEEP_PROT"]       = "Tank: Deep Protection",
        ["FURY_PROT"]       = "Tank: Fury-Prot (Threat)",
        ["ARMS_PROT"]       = "Tank: Arms (Dungeon Hybrid)",
        
        -- Leveling
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
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Warrior.Talents = { 
        ["MORTAL_STRIKE"]    = "Mortal Strike",
        ["BLOODTHIRST"]      = "Bloodthirst",
        ["SHIELD_SLAM"]      = "Shield Slam",
        ["DEFIANCE"]         = "Defiance",
        ["IMP_SLAM"]         = "Improved Slam",
        ["DW_SPEC"]          = "Dual Wield Specialization",
        ["TACTICAL_MASTERY"] = "Tactical Mastery",
        ["IMPALE"]           = "Impale",
        ["CRUELTY"]          = "Cruelty",
        ["FLURRY"]           = "Flurry",
    }

-- =============================================================
-- LOGIC
-- =============================================================
function Warrior:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling 
    if level < 60 then
        if level < 30 then return "Leveling_1_30"
        elseif level < 50 then return "Leveling_31_50"
        else return "Leveling_51_60" end
    end

    -- Endgame Spec detection
    if Rank("SHIELD_SLAM") > 0 then return "DEEP_PROT" end
    if Rank("BLOODTHIRST") > 0 and Rank("DEFIANCE") > 0 then return "FURY_PROT" end
    if Rank("TACTICAL_MASTERY") > 0 and Rank("DEFIANCE") > 0 then return "ARMS_PROT" end
    if Rank("BLOODTHIRST") > 0 and Rank("IMP_SLAM") > 0 then return "FURY_2H" end
    if Rank("BLOODTHIRST") > 0 then return "FURY_DW" end
    if Rank("MORTAL_STRIKE") > 0 then return "ARMS_MS" end
    return "FURY_DW"
end

function Warrior:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Yellow Hit Cap (9% base, 6% with +5 Skill)
    -- FIX: Changed MSC_HIT_PERCENT -> ITEM_MOD_HIT_RATING_SHORT
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        local currentHit = MSC.PlayerStats.Hit or 0
        
        -- Detect Weapon Skill (Racial)
        local _, race = UnitRace("player")
        local skillBonus = 0
        if race == "Human" or race == "Orc" then skillBonus = 5 end

        local yellowCap = (skillBonus >= 5) and 6 or 9
        
        if currentHit >= yellowCap then
            -- Hit is still good for DW (White hits), but weight drops for 2H
            local mult = (currentSpec:find("DW")) and 0.5 or 0.1
            weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * mult
            table.insert(activeCaps, "Yellow Hit ("..yellowCap.."%)")
        end
    end

    -- 2. Weapon Skill Cap (+5 is the breakpoint)
    if weights["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] then
        local _, race = UnitRace("player")
        local skillBonus = (race == "Human" or race == "Orc") and 5 or 0
        
        if skillBonus >= 5 then
            weights["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 8.0 -- Drop value
            table.insert(activeCaps, "Skill (+5)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Warrior:GetWeaponBonus(itemLink)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- Racial: Human (Sword/Mace)
    if race == "Human" and (subClassID == 7 or subClassID == 4 or subClassID == 8 or subClassID == 5) then 
        bonus = bonus + 60 
    end
    -- Racial: Orc (Axes)
    if race == "Orc" and (subClassID == 0 or subClassID == 1) then 
        bonus = bonus + 60 
    end
    
    return bonus
end

MSC.RegisterModule("WARRIOR", Warrior)