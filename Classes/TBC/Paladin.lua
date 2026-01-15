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
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 2.0,
        -- SURVIVAL
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.2, 
        -- "TRASH" STATS (Set to 0.02 to bypass Poison Penalty)
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
		["MSC_WEAPON_SPEED"] = 20.0, -- Heavily bias towards Slow 2H (3.5+)	
        ["MSC_WEAPON_DPS"]                  = 7.5,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.4, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 2.2, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.2, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.6,
        ["ITEM_MOD_STAMINA_SHORT"].         = 1.5,
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.4, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.5,
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.4,        
        -- Caster Stats
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.05, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.1, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.02, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02, 
    },
    ["SHOCKADIN_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.5,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.8, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.9,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.2, 
        -- ADDED SPELL HIT (Vital for PvP)
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.8, 
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
    
    ["Leveling_HOLY_DUNGEON_21_40"] = { ["ITEM_MOD_INTELLECT_SHORT"] = 2.0, ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.0, ["ITEM_MOD_STAMINA_SHORT"] = 1.0, ["ITEM_MOD_STRENGTH_SHORT"] = 0.02  },
	["Leveling_HOLY_DUNGEON_41_51"] = { ["ITEM_MOD_INTELLECT_SHORT"] = 2.0, ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2, ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, ["ITEM_MOD_STRENGTH_SHORT"] = 0.02  },      
    ["Leveling_HOLY_DUNGEON_52_59"] = { ["ITEM_MOD_INTELLECT_SHORT"] = 2.2, ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5, ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, ["ITEM_MOD_STRENGTH_SHORT"] = 0.02  },
    ["Leveling_HOLY_DUNGEON_60_70"] = { ["ITEM_MOD_INTELLECT_SHORT"] = 2.5, ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.4, ["ITEM_MOD_STAMINA_SHORT"] = 1.2, ["ITEM_MOD_STRENGTH_SHORT"] = 0.02  },
		
	["Leveling_PROT_DUNGEON_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]= 1.6, ["ITEM_MOD_STRENGTH_SHORT"]= 1.2, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]= 0.8, ["ITEM_MOD_INTELLECT_SHORT"]= 0.8, ["MSC_WEAPON_DPS"]= 1.5, },
    ["Leveling_PROT_DUNGEON_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]= 1.8, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 1.2, ["ITEM_MOD_STRENGTH_SHORT"]= 1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]= 0.9, ["ITEM_MOD_BLOCK_RATING_SHORT"]= 0.8, ["MSC_WEAPON_DPS"]= 1.5, },
    ["Leveling_PROT_DUNGEON_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]= 1.9, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 1.4, ["ITEM_MOD_SPELL_POWER_SHORT"]= 1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]= 1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]= 1.0, ["ITEM_MOD_PARRY_RATING_SHORT"]= 1.0, ["MSC_WEAPON_DPS"]= 1.2, },
    ["Leveling_PROT_DUNGEON_60_70"] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 2.0, ["ITEM_MOD_STAMINA_SHORT"]= 1.8, ["ITEM_MOD_SPELL_POWER_SHORT"]= 1.2, ["ITEM_MOD_STRENGTH_SHORT"]= 0.8, ["ITEM_MOD_BLOCK_RATING_SHORT"]= 1.1, ["ITEM_MOD_BLOCK_VALUE_SHORT"]= 1.1, ["ITEM_MOD_INTELLECT_SHORT"]= 0.5, },
	
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
	
	["Leveling_PROT_DUNGEON_21_40"] = "Prot Dungeon (21-40)",
    ["Leveling_PROT_DUNGEON_41_51"] = "Prot Dungeon (41-51)",
    ["Leveling_PROT_DUNGEON_52_59"] = "Prot Dungeon (52-59)",
    ["Leveling_PROT_DUNGEON_60_70"] = "Prot Dungeon (Outland)",
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

Paladin.StatToCritMatrix = { 
    Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.0}, {60, 29.5}, {70, 80.0} } 
}

-- =============================================================
-- PALADIN SPECIFIC ITEMS (Librams)
-- =============================================================
Paladin.Relics = {
    -- [[ CLASSIC / LEVELING (1-60) ]]
    [23201] = { ITEM_MOD_HEALING_POWER_SHORT = 53 },
    [23006] = { ITEM_MOD_HEALING_POWER_SHORT = 83 },
    [22401] = { ITEM_MOD_MANA_REGENERATION_SHORT = 10 },
    [22402] = { ITEM_MOD_ARMOR_SHORT = 0 },

    -- [[ TBC LEVELING / DUNGEON (60-70) ]]
    [25644] = { ITEM_MOD_ATTACK_POWER_SHORT = 12 },
    [27917] = { ITEM_MOD_SPELL_POWER_SHORT = 20 }, 
    [28592] = { ITEM_MOD_HEALING_POWER_SHORT = 84 },

    -- [[ TBC RAID (Holy) ]]
    [30991] = { ITEM_MOD_HEALING_POWER_SHORT = 87 },
    [29388] = { ITEM_MOD_HEALING_POWER_SHORT = 40 }, 
    [34231] = { ITEM_MOD_HEALING_POWER_SHORT = 80 },
    [28592] = { ITEM_MOD_HEALING_POWER_SHORT = 113 },

    -- [[ TBC RAID (Retribution) ]]
    [27484] = { ITEM_MOD_CRIT_RATING_SHORT = 53 },
    [31033] = { ITEM_MOD_ATTACK_POWER_SHORT = 60 },
    [33503] = { ITEM_MOD_ATTACK_POWER_SHORT = 120 },

    -- [[ TBC RAID (Protection) ]]
    [29386] = { ITEM_MOD_BLOCK_VALUE_SHORT = 42 },
    [30642] = { ITEM_MOD_SPELL_POWER_SHORT = 47 },
    [32489] = { ITEM_MOD_BLOCK_VALUE_SHORT = 100 },
    [27958] = { ITEM_MOD_BLOCK_VALUE_SHORT = 53 },

    -- [[ PVP LIBRAMS (Seasons 1-4) ]]
    [28358] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 17 }, -- S1
    [33077] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 21 }, -- S2
    [33844] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 23 }, -- S3
    [35026] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 }, -- S4
    
    [42612] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 }, -- (Wrath/Pre-patch?)
    [42613] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 29 }, -- (Wrath/Pre-patch?)
}

-- =============================================================
-- LOGIC
-- =============================================================
function Paladin:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
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

    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling_RET"
    if Rank("HOLY_SHIELD") > 0 or Rank("AVENGERS_SHIELD") > 0 then 
        role = "Leveling_PROT_DUNGEON"
    elseif Rank("DIVINE_ILLUM") > 0 or Rank("HOLY_SHOCK") > 0 then 
        role = "Leveling_HOLY_DUNGEON"
    else
        -- Fallback Point Count
        local holyPts = GetNumTalentPoints(1)
        local protPts = GetNumTalentPoints(2)
        local retPts  = GetNumTalentPoints(3)
        
        if protPts > (holyPts + retPts) then
            role = "Leveling_PROT_DUNGEON" -- Safe Default
        elseif holyPts > (protPts + retPts) then
            role = "Leveling_HOLY_DUNGEON"
        end
    end

    local specificKey = role .. suffix
    if Paladin.LevelingWeights[specificKey] then return specificKey end
    return "Leveling_RET" .. suffix
end

function Paladin:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. UNIVERSAL TALENTS ]]
    -- Strength
    local rStr = Rank("DIVINE_STR")
    if rStr > 0 and weights["ITEM_MOD_STRENGTH_SHORT"] then 
        weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02)) 
    end
    
    -- Intellect
    local rInt = Rank("DIVINE_INT")
    if rInt > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rInt * 0.02)) 
    end
    
    -- Stamina
    local rStam = Rank("COMBAT_EXPERTISE")
    local rDuty = Rank("SACRED_DUTY")
    local stamMult = 1.0 + (rStam * 0.02) + (rDuty * 0.03)
    if stamMult > 1.0 and weights["ITEM_MOD_STAMINA_SHORT"] then 
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * stamMult 
    end

    -- [[ 2. BRANCHING LOGIC ]]

	-- [[ RETRIBUTION DYNAMIC SCALING ]]
    if currentSpec:find("RET") then
        local base, pos, neg = UnitAttackPower("player")
        local totalAP = base + pos + neg
        
        -- 1. CRIT SCALING (Universal)
        -- Everyone needs Crit to keep Vengeance active
        if weights["ITEM_MOD_CRIT_RATING_SHORT"] then
            if totalAP > 1000 then
                local critScaler = 1 + ((totalAP - 1000) / 15000)
                if critScaler > 1.15 then critScaler = 1.15 end
                weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * critScaler
            end
        end

        -- 2. HASTE SCALING (Race Specific)
        if weights["ITEM_MOD_HASTE_RATING_SHORT"] then
            -- Check Race: Blood Elves get Seal of Blood (Haste is King)
            -- Alliance gets Seal of Command (Haste is Good, but not King)
            local _, raceFile = UnitRace("player")
            local isSealOfBlood = (raceFile == "BloodElf") 
            
            -- Thresholds: Horde scales harder and earlier
            local threshold = isSealOfBlood and 2000 or 2300
            local multiplier = isSealOfBlood and 1.4 or 1.2
            
            if totalAP > threshold then
                weights["ITEM_MOD_HASTE_RATING_SHORT"] = weights["ITEM_MOD_HASTE_RATING_SHORT"] * multiplier
            end
        end

    elseif currentSpec == "SHOCKADIN_PVP" then
        -- SHOCKADIN: Spell Power -> Spell Crit
        if weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            local spellPower = GetSpellBonusDamage(2) -- 2 = Holy
            if spellPower > 600 then
                 local spScaler = 1 + ((spellPower - 600) / 10000)
                 if spScaler > 1.2 then spScaler = 1.2 end
                 weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * spScaler
            end
        end

	elseif currentSpec:find("HOLY") then
        local spellPower = GetSpellBonusHealing()
        
        -- 1. LOW GEAR (Fresh 70): Survival Mode
        -- If we have low SP, we assume we have low mana. Prioritize Efficiency.
        if spellPower < 1200 then
             if weights["ITEM_MOD_MANA_REGENERATION_SHORT"] then
                 -- Boost Regen slightly to help early dungeon runs
                 weights["ITEM_MOD_MANA_REGENERATION_SHORT"] = weights["ITEM_MOD_MANA_REGENERATION_SHORT"] * 1.2
             end
        end

        -- 2. HIGH GEAR (T5/T6): Machine Gun Mode
        -- Once we have big heals, we need speed to snipe targets.
        if spellPower > 1800 then
            -- Boost HASTE (The only way to output more healing once capped)
            if weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] then
                weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = (weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] or 0.8) * 1.5
            end
            
            -- Lower MP5 (We have infinite mana from Illumination/Crit now)
            if weights["ITEM_MOD_MANA_REGENERATION_SHORT"] then
                weights["ITEM_MOD_MANA_REGENERATION_SHORT"] = weights["ITEM_MOD_MANA_REGENERATION_SHORT"] * 0.8
            end
        end
    end

    -- [[ 3. CAPS with HYSTERESIS ]]
    
    -- A. MELEE HIT CAP (Ret/Prot)
    if weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(6) 
        local baseCap = 142 
        local talentBonus = Rank("PRECISION") * 15.8
        local finalCap = baseCap - talentBonus
        
        if hitRating >= (finalCap + 15) then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.1
            table.insert(activeCaps, "Hit")
        elseif hitRating >= finalCap then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * 0.4
            table.insert(activeCaps, "Hit (Soft)")
        end
    end

    -- B. SPELL HIT CAP (Shockadin / Prot)
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(8) -- Spell Hit
        -- 4% PvP Cap (roughly 50 rating). 16% PvE Cap (202).
        local cap = 202
        if currentSpec == "SHOCKADIN_PVP" then cap = 50 end 
        
        if hitRating >= (cap + 15) then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02
            table.insert(activeCaps, "Spell Hit")
        elseif hitRating >= cap then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] * 0.4
            table.insert(activeCaps, "S-Hit (Soft)")
        end
    end

-- [[ C. DEFENSE CAP (Prot) ]]
    -- If we are in a tanking spec (Defense weighted high)
    if weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] and weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] > 1.0 then
        local baseDef, armorDef = UnitDefense("player")
        local currentDef = baseDef + armorDef
        
        -- Tier 1: SAFELY CAPPED (Hysteresis Buffer)
        if currentDef >= 495 then
            weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.8
            table.insert(activeCaps, "Def (Safe)")

            -- [NEW] EFFECTIVE HEALTH PIVOT
            -- Once safe, Stamina and Armor become the new Kings for survival
            weights["ITEM_MOD_STAMINA_SHORT"] = (weights["ITEM_MOD_STAMINA_SHORT"] or 1.5) * 1.3
            weights["ITEM_MOD_ARMOR_SHORT"]   = (weights["ITEM_MOD_ARMOR_SHORT"] or 0.1) * 1.5

        -- Tier 2: DANGER ZONE / SOFT CAP
        elseif currentDef >= 490 then
            -- Keep Defense valuable enough to hold the cap, but allow huge Stam upgrades to win
            weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.6
            table.insert(activeCaps, "Def (Soft)")
            
        -- Tier 3: UNDER CAP (Default weights apply, typically > 2.0)
        end
    end

    -- D. EXPERTISE CAP (Ret/Prot)
    if weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] and weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] > 0.1 then
        local expRating = GetCombatRating(24) 
        -- FIX: Use select(2, UnitRace) to get the safe, unlocalized ID
        local _, raceID = UnitRace("player") 
        local humanBonus = (raceID == "Human") and 20 or 0
        
        if (expRating + humanBonus) >= 103 then
            weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] = weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] * 0.5
            table.insert(activeCaps, "Exp")
        end
    end

    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Paladin:GetWeaponBonus(itemLink)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    -- FIX: Use select(2, UnitRace) for safe ID check
    local _, raceID = UnitRace("player")

    if raceID == "Human" and (subClassID == 7 or subClassID == 8 or subClassID == 4 or subClassID == 5) then 
        bonus = bonus + 40 
    end
    
    return bonus
end

-- =============================================================
-- REGISTER PROFILES FOR INIT (UI LIST ONLY)
-- =============================================================
-- We create a temporary table just so Init.lua can build the dropdown list.
-- The Engine will still ignore this and look at Weights/LevelingWeights directly.
Paladin.Profiles = {}

for k, v in pairs(Paladin.Weights) do Paladin.Profiles[k] = v end
for k, v in pairs(Paladin.LevelingWeights) do Paladin.Profiles[k] = v end

MSC.RegisterModule("PALADIN", Paladin)