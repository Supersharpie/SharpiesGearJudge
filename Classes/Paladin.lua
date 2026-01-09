local addonName, MSC = ...
local Paladin = {}
Paladin.Name = "PALADIN"
-- =============================================================
-- ENDGAME STAT WEIGHTS (Patch 2.4.3 / 2.5.5)
-- =============================================================
Paladin.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.3, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
        ["MSC_WEAPON_DPS"]=2.0 
    },
	["HOLY_RAID"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02, -- Just to avoid poison on weapons       
        -- INTELLECT (The Stat King in 2.5.5)
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.75,
        -- THROUGHPUT
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.9,        
        -- HASTE (Sunwell Meta)
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 1.1,
        -- SUSTAIN
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 1.25,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 2.5,
        -- SURVIVAL
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.2, 
        -- "TRASH" STATS (Set to 0.02 to bypass Poison Penalty)
        -- We don't want these, but we don't want to destroy the score if an item has them.
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
    },
	["PROT_DEEP"] = {
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.4, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]     = 2.0,      
        ["ITEM_MOD_PARRY_RATING_SHORT"]     = 2.0,      
        ["ITEM_MOD_BLOCK_RATING_SHORT"]     = 1.7,      
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.6,      
        ["ITEM_MOD_ARMOR_SHORT"]            = 0.12,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 0.8,    
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.75,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.8, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.6, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]      = 0.35,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.1, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.6,      
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.1, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.2,
        ["MSC_WEAPON_DPS"]                  = 0.2, 
    },
["RET_STANDARD"] = { 
        ["MSC_WEAPON_DPS"]                  = 7.5,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.4, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 2.2, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.2, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.6, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.4, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.5,
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.4,       
        -- Caster Stats (Set to 0.02 to avoid Poison Penalty)
        -- This ensures you can wear "Hybrid" gear without the addon saying it's trash.
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.05, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.1, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.02, -- Bumped from 0.0
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02, -- Added safety line
    },
    ["SHOCKADIN_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.5,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.8, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.9,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.1,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.1,
    },
	["PROT_AOE"] = { 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]      = 2.5, 
        ["ITEM_MOD_BLOCK_RATING_SHORT"]     = 1.8, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 1.0,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.2, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.0, 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.2,
    },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Paladin.LevelingWeights = {

	["Leveling_1_20"]  = { ["MSC_WEAPON_DPS"] = 7.0, ["ITEM_MOD_STRENGTH_SHORT"] = 1.5, ["ITEM_MOD_STAMINA_SHORT"] = 1.2, ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, ["ITEM_MOD_ARMOR_SHORT"] = 0.01 },
	["Leveling_21_40"] = { ["MSC_WEAPON_DPS"] = 8.5, ["ITEM_MOD_STRENGTH_SHORT"] = 1.6, ["ITEM_MOD_AGILITY_SHORT"] = 1.0, ["ITEM_MOD_STAMINA_SHORT"] = 1.0, ["ITEM_MOD_INTELLECT_SHORT"] = 0.7 },
	["Leveling_41_51"] = { ["MSC_WEAPON_DPS"] = 9.0, ["ITEM_MOD_STRENGTH_SHORT"] = 1.8, ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5, ["ITEM_MOD_AGILITY_SHORT"] = 1.0, ["ITEM_MOD_INTELLECT_SHORT"] = 0.5 },
	["Leveling_52_59"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 6.0, ["ITEM_MOD_STRENGTH_SHORT"] = 1.8, ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.4, ["ITEM_MOD_STAMINA_SHORT"] = 1.2, ["ITEM_MOD_AGILITY_SHORT"] = 0.8, ["ITEM_MOD_INTELLECT_SHORT"] = 0.4 },
	["Leveling_60_70"] = { ["MSC_WEAPON_DPS"] = 11.0,["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_STAMINA_SHORT"] = 1.5, ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.4, ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.8 },
	
    ["Leveling_RET_1_20"] = { ["MSC_WEAPON_DPS"]=8.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01 },
    ["Leveling_RET_21_40"]  = { ["MSC_WEAPON_DPS"]=7.0, ["MSC_WEAPON_SPEED"]=1.8, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01 },
    ["Leveling_RET_41_51"]  = { ["MSC_WEAPON_DPS"]=6.5, ["MSC_WEAPON_SPEED"]=1.8, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01 },
    ["Leveling_RET_52_59"]  = { ["MSC_WEAPON_DPS"]=6.0, ["MSC_WEAPON_SPEED"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, ["ITEM_MOD_AGILITY_SHORT"]=1.1, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.1 },
    ["Leveling_RET_60_70"]  = { ["MSC_WEAPON_DPS"]=5.0, ["MSC_WEAPON_SPEED"]=1.2, ["ITEM_MOD_STRENGTH_SHORT"]=2.6, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.7, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.1, ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01 },

    ["Leveling_PROT_AOE_21_40"] = { ["MSC_WEAPON_DPS"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0 },
    ["Leveling_PROT_AOE_41_51"] = { ["MSC_WEAPON_DPS"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.2, ["ITEM_MOD_BLOCK_RATING_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.8 },
    ["Leveling_PROT_AOE_52_59"] = { ["MSC_WEAPON_DPS"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.2, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_BLOCK_RATING_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.5 },
    ["Leveling_PROT_AOE_60_70"] = { ["MSC_WEAPON_DPS"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.8, ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5, ["ITEM_MOD_PARRY_RATING_SHORT"]=1.5, ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5 },
    
    ["Leveling_HOLY_DUNGEON_21_40"] = { ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.01 },
    ["Leveling_HOLY_DUNGEON_41_51"] = { ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.01 },   
    ["Leveling_HOLY_DUNGEON_52_59"] = { ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=0.01 },
    ["Leveling_HOLY_DUNGEON_60_70"] = { ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=0.01 },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Paladin.PrettyNames = {
    ["HOLY_RAID"]       = "Healer: Holy (Illumination)",
    ["PROT_DEEP"]       = "Tank: Deep Protection",
    ["PROT_AOE"]        = "Farming: AoE Grinding (Strat)",
    ["RET_STANDARD"]    = "DPS: Retribution",
    ["SHOCKADIN_PVP"]   = "PvP: Shockadin",
	
	-- Leveling Brackets
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
    
    ["Leveling_RET_1_20"]  = "Retribution (1-20)",
    ["Leveling_RET_21_40"] = "Retribution (21-40)",
    ["Leveling_RET_41_51"] = "Retribution (41-51)",
    ["Leveling_RET_52_59"] = "Retribution (52-59)",
    ["Leveling_RET_60_70"] = "Retribution (Outland)",
    
    ["Leveling_PROT_AOE_21_40"] = "Prot AoE Grind (21-40)",
    ["Leveling_PROT_AOE_41_51"] = "Prot AoE Grind (41-51)",
    ["Leveling_PROT_AOE_52_59"] = "Prot AoE Grind (52-59)",
    ["Leveling_PROT_AOE_60_70"] = "Prot AoE Grind (Outland)",
    
    ["Leveling_HOLY_DUNGEON_21_40"] = "Holy Dungeon (21-40)",
    ["Leveling_HOLY_DUNGEON_41_51"] = "Holy Dungeon (41-51)",
    ["Leveling_HOLY_DUNGEON_52_59"] = "Holy Dungeon (52-59)",
    ["Leveling_HOLY_DUNGEON_60_70"] = "Holy Dungeon (Outland)",
}

Paladin.SpeedChecks = { 
    ["Default"]={ MH_Slow=true }, 
    ["RET_STANDARD"]={ MH_Slow=true },
    ["PROT_DEEP"]={ MH_Fast=true },
    ["PROT_AOE"]={ MH_Fast=false } 
}

Paladin.Talents = { 
    ["PRECISION"]       = "Precision",
    ["HOLY_SHOCK"]      = "Holy Shock", 
    ["DIVINE_ILLUM"]    = "Divine Illumination", 
    ["HOLY_SHIELD"]     = "Holy Shield", 
    ["AVENGERS_SHIELD"] = "Avenger's Shield", 
    ["REPENTANCE"]      = "Repentance", 
    ["CRUSADER_STRIKE"] = "Crusader Strike", 
    ["SANCTITY_AURA"]   = "Sanctity Aura", 
    ["DIVINE_STR"]      = "Divine Strength", 
    ["DIVINE_INT"]      = "Divine Intellect", 
    ["COMBAT_EXPERTISE"]= "Combat Expertise",
    ["SACRED_DUTY"]     = "Sacred Duty"
}

-- Re-Added for Tooltip "Gains" Display
Paladin.StatToCritMatrix = { 
    Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.0}, {60, 29.5}, {70, 80.0} } 
}

-- =============================================================
-- PALADIN SPECIFIC ITEMS (Librams)
-- =============================================================
Paladin.Relics = {
    -- [Libram of Renewal] (Badges): Reduces Holy Light cost by 42 (~18 Mp5)
    [27484] = { ITEM_MOD_MANA_REGENERATION_SHORT = 18 },

    -- [Libram of Souls] (Kara): Reduces Holy Light cost by 42
    [28592] = { ITEM_MOD_MANA_REGENERATION_SHORT = 18 },

    -- [Libram of Avengement] (SSC): Judgement chance to gain 53 Crit (~19 Static)
    [28253] = { ITEM_MOD_CRIT_RATING_SHORT = 19 },

    -- [Libram of Divine Purpose] (Badges): Seal/Judgement Dmg +150 (~60 SP / 30 Str)
    [28255] = { ITEM_MOD_STRENGTH_SHORT = 30, ITEM_MOD_SPELL_POWER_SHORT = 20 },

    -- [Libram of Repentance] (Badges): Block Value +24 (Avg ~30)
    [23201] = { ITEM_MOD_BLOCK_VALUE_SHORT = 30 },

    -- [Libram of the Eternal Rest] (Sethekk): Consecration Dmg +47
    [27917] = { ITEM_MOD_SPELL_POWER_SHORT = 47 },

    -- [Libram of Righteous Power] (Quest): Crusader Strike +30 Dmg (~15 Str)
    [23006] = { ITEM_MOD_STRENGTH_SHORT = 15 },

    -- [Libram of Fervor] (World Drop): Crusader Strike +33 Dmg
    [23203] = { ITEM_MOD_STRENGTH_SHORT = 16 },

    -- [Libram of Zeal] (HFP Quest): Holy Shock +Damage
    [23005] = { ITEM_MOD_SPELL_POWER_SHORT = 15 },

    -- [Libram of Saints] (UB): Holy Light +29 Healing
    [27455] = { ITEM_MOD_HEALING_POWER_SHORT = 29 },

    -- [Harold's Rejuvenating Broach] (Quest): Holy Light +15
    [25644] = { ITEM_MOD_HEALING_POWER_SHORT = 15 },
    
    -- [Blessed Book of Nagrand] (Quest): Flash of Light +20
    [25634] = { ITEM_MOD_HEALING_POWER_SHORT = 15 }, 
}

-- INJECT INTO MAIN DATABASE
if MSC.RelicDB then
    for id, stats in pairs(Paladin.Relics) do
        MSC.RelicDB[id] = stats
    end
end

-- =============================================================
-- LOGIC
-- =============================================================
function Paladin:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- 1. Endgame Spec (Prioritize logic for 60+)
    if level >= 60 then
        if Rank("AVENGERS_SHIELD") > 0 or Rank("HOLY_SHIELD") > 0 then return "PROT_DEEP" end
        if Rank("CRUSADER_STRIKE") > 0 or Rank("REPENTANCE") > 0 then return "RET_STANDARD" end
        if Rank("HOLY_SHOCK") > 0 then
            if Rank("SANCTITY_AURA") > 0 then return "SHOCKADIN_PVP" end
            return "HOLY_RAID"
        end
        if Rank("DIVINE_ILLUM") > 0 then return "HOLY_RAID" end
        return "RET_STANDARD"
    end

    -- 2. Leveling Spec
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling_RET" -- Default
    if Rank("HOLY_SHIELD") > 0 or Rank("AVENGERS_SHIELD") > 0 then 
        role = "Leveling_PROT_AOE"
    elseif Rank("DIVINE_ILLUM") > 0 or Rank("HOLY_SHOCK") > 0 then 
        role = "Leveling_HOLY_DUNGEON"
    end 

    local specificKey = role .. suffix
    if Paladin.LevelingWeights[specificKey] then return specificKey end
    return "Leveling_RET" .. suffix
end

function Paladin:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {} -- New: List to store triggered caps

    -- [[ 1. TALENT SCALING ]]
    local rStr = Rank("DIVINE_STR")
    if rStr > 0 and weights["ITEM_MOD_STRENGTH_SHORT"] then 
        weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02)) 
    end
    
    local rInt = Rank("DIVINE_INT")
    if rInt > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rInt * 0.02)) 
    end
    
    local rStam = Rank("COMBAT_EXPERTISE")
    local rDuty = Rank("SACRED_DUTY")
    local stamMult = 1.0 + (rStam * 0.02) + (rDuty * 0.03)
    if stamMult > 1.0 and weights["ITEM_MOD_STAMINA_SHORT"] then 
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * stamMult 
    end

    -- [[ 2. CAP HANDLING (DYNAMIC SCALING) ]]
    
    -- A. DEFENSE CAP (490)
    if weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] and weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] > 1.0 then
        local baseDef, armorDef = UnitDefense("player")
        if (baseDef + armorDef) >= 490 then
            weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.4
            table.insert(activeCaps, "Def") -- Add tag
        end
    end

    -- B. MELEE HIT CAP (9%)
    if weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(6) 
        local baseCap = 142 
        local talentBonus = Rank("PRECISION") * 15.8 
        if hitRating >= (baseCap - talentBonus) then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.1
            table.insert(activeCaps, "Hit") -- Add tag
        end
    end

    -- C. EXPERTISE SOFT CAP (6.5%)
    if weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] and weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] > 0.1 then
        local expRating = GetCombatRating(24) 
        local humanBonus = (select(2, UnitRace("player")) == "Human") and 20 or 0
        if (expRating + humanBonus) >= 103 then
            weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] = weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] * 0.5
            table.insert(activeCaps, "Exp") -- Add tag
        end
    end
    
    -- Return weights AND the cap string (e.g., "Def, Hit")
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Paladin:GetWeaponBonus(itemLink)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- Racial: Human (Sword/Mace)
    if race == "Human" and (subClassID == 7 or subClassID == 8 or subClassID == 4 or subClassID == 5) then 
        bonus = bonus + 40 
    end
    
    return bonus
end

MSC.RegisterModule("PALADIN", Paladin)