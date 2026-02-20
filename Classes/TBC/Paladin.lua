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
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 1.0, 
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
		["ITEM_MOD_STAMINA_SHORT"]			= 1.5,
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
		["ITEM_MOD_ARMOR_SHORT"]            = 0.05,		
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.2,
    },
}

-- Safety Init
Paladin.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS
-- =============================================================
Paladin.LevelingBrackets = {
    -- [[ GENERIC STARTER (1-20) ]]
    ["Leveling_1_20"] = {
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"] = 7.0, 
            ["MSC_WEAPON_SPEED"] = 0.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.05, -- Bumped slightly to ensure Mail preference
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_AGILITY_SHORT"] = 0.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["MSC_WEAPON_SPEED"] = 1.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.05,
            ["ITEM_MOD_AGILITY_SHORT"] = 0.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.8
        }
    },

    -- [[ RETRIBUTION LEVELING ]]
    -- (Ret doesn't strictly NEED armor weight as much, but 0.01 helps tie-break)
    ["Leveling_RET_21_40"] = {
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 4.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.2,
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 0.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 13.0, 
            ["MSC_WEAPON_SPEED"] = 4.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.2,
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 0.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5 
        }
    },
    ["Leveling_RET_41_51"] = {
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 13.0, 
            ["MSC_WEAPON_SPEED"] = 4.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.2, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 0.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 5.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.4, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.1, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.5, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 0.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5 
        }
    },
    ["Leveling_RET_52_59"] = {
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 5.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.1, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.3, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.5, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 0.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 16.0, 
            ["MSC_WEAPON_SPEED"] = 5.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.8,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 0.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5 
        }
    },
    ["Leveling_RET_60_70"] = {
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 16.0, 
            ["MSC_WEAPON_SPEED"] = 5.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.8, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 0.02, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 0.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 18.0, 
            ["MSC_WEAPON_SPEED"] = 6.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.1,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 0.02,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3.0,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 0.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5 
        }
    },

["Leveling_PROT_AOE_41_51"] = {
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.5, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 5.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 2.0,
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.5, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 5.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 2.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 0.8, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 2.0,
        }
    },
    ["Leveling_PROT_AOE_52_59"] = {
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.5, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 5.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.8, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 0.8, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 2.0,
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.5, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 6.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 2.0,
        }
    },
    ["Leveling_PROT_AOE_60_70"] = {
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 1.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 6.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 2.0,
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 2.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 6.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 4.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.5,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.4, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.5,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 2.0,
        }
    },

    -- [[ HOLY DUNGEON LEVELING ]]
    ["Leveling_HOLY_DUNGEON_21_40"] = {
        min = 21, max = 40,
        Start = { 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5 
        },
        End = { 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_HOLY_DUNGEON_41_51"] = {
        min = 41, max = 51,
        Start = { 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0 
        },
        End = { 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.2, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0
        }
    },
    ["Leveling_HOLY_DUNGEON_52_59"] = {
        min = 52, max = 59,
        Start = { 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.2, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0 
        },
        End = { 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0
        }
    },
    ["Leveling_HOLY_DUNGEON_60_70"] = {
        min = 60, max = 70,
        Start = { 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 2.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0, 
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 0.5 
        },
        End = { 
            ["ITEM_MOD_INTELLECT_SHORT"] = 3.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 2.5,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 1.0
        }
    },

    -- [[ PROT DUNGEON LEVELING ]]
    ["Leveling_PROT_DUNGEON_21_40"] = {
        min = 21, max = 40,
        Start = { 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["MSC_WEAPON_DPS"] = 1.5, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.1 -- Added
        },
        End = { 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.9,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["MSC_WEAPON_DPS"] = 1.5,
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.1 -- Added
        }
    },
    ["Leveling_PROT_DUNGEON_41_51"] = {
        min = 41, max = 51,
        Start = { 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 0.8, 
            ["MSC_WEAPON_DPS"] = 1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.8, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 0.8, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 0.8,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08 -- Added
        },
        End = { 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.4, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 0.8, 
            ["MSC_WEAPON_DPS"] = 1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 1.2,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08 -- Added
        }
    },
    ["Leveling_PROT_DUNGEON_52_59"] = {
        min = 52, max = 59,
        Start = { 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 1.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.2, 
            ["MSC_WEAPON_DPS"] = 1.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08 -- Added
        },
        End = { 
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 1.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.2, 
            ["MSC_WEAPON_DPS"] = 1.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08 -- Added
        }
    },
    ["Leveling_PROT_DUNGEON_60_70"] = {
        min = 60, max = 70,
        Start = { 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.8, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["MSC_WEAPON_DPS"] = 1.2, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08 -- Added
        },
        End = { 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 3.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.0,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.8, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,
            ["MSC_WEAPON_DPS"] = 1.2, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08 -- Added
        }
    }
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

Paladin.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes
    [4]=true, [5]=true,   -- 1H/2H Maces
    [7]=true, [8]=true,   -- 1H/2H Swords
    [6]=true              -- Polearms
}

Paladin.StatToCritMatrix = { 
    Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.0}, {60, 29.5}, {70, 80.0} } 
}

-- =============================================================
-- CLASS SPECIFIC ITEMS (Librams)
-- =============================================================
-- Note: Proc uptime, conditional buffs, and mana savings are averaged 
-- into standard stats (e.g., MP5 for mana reduction, AP for proc damage).
Paladin.Relics = {
    [22400] = { ITEM_MOD_ARMOR_SHORT = 110 }, -- Libram of Truth (Devotion Aura)
    [22401] = { ITEM_MOD_MANA_REGENERATION_SHORT = 10 }, -- Libram of Hope (Avg MP5 from seals)
    [22402] = { ITEM_MOD_MANA_REGENERATION_SHORT = 10 }, -- Libram of Grace (Avg MP5 from cleanse)
    [23201] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 53 }, -- Libram of Divinity
    [23203] = { ITEM_MOD_ATTACK_POWER_SHORT = 48, ITEM_MOD_HOLY_DAMAGE_SHORT = 33 }, -- Libram of Fervor
    [24386] = { ITEM_MOD_HEALTH_REGENERATION_SHORT = 15 }, -- Libram of Saints Departed (Avg HP5)
    [25644] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 79 }, -- Blessed Book of Nagrand
    [27484] = { ITEM_MOD_CRIT_RATING_SHORT = 26 }, -- Libram of Avengement (Avg 50% uptime)
    [27917] = { ITEM_MOD_HOLY_DAMAGE_SHORT = 47 }, -- Libram of the Eternal Rest
    [27949] = { ITEM_MOD_ATTACK_POWER_SHORT = 68, ITEM_MOD_HOLY_DAMAGE_SHORT = 47 }, -- Libram of Zeal
    [27983] = { ITEM_MOD_ATTACK_POWER_SHORT = 68, ITEM_MOD_HOLY_DAMAGE_SHORT = 47 }, -- Libram of Zeal (Duplicate)
    [28065] = { ITEM_MOD_HOLY_DAMAGE_SHORT = 60 }, -- Libram of Wracking (Situational, halved value)
    [28296] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 87 }, -- Libram of the Lightbringer
    [28592] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 90 }, -- Libram of Souls Redeemed (Avg between FoL/HL)
    [30063] = { ITEM_MOD_MANA_REGENERATION_SHORT = 17 }, -- Libram of Absolute Truth (Avg MP5)
    [31033] = { ITEM_MOD_ATTACK_POWER_SHORT = 54 }, -- Libram of Righteous Power (CS Dmg to AP equivalent)
    [33502] = { ITEM_MOD_MANA_REGENERATION_SHORT = 22 }, -- Libram of Mending (Near 100% uptime MP5)
    [33503] = { ITEM_MOD_ATTACK_POWER_SHORT = 80 }, -- Libram of Divine Judgement (40% proc 200 AP)
    [33504] = { ITEM_MOD_HOLY_DAMAGE_SHORT = 94 }, -- Libram of Divine Purpose
    [23006] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 83 }, -- Libram of Light
    [29388] = { ITEM_MOD_BLOCK_RATING_SHORT = 42 }, -- Libram of Repentance (High uptime for Prot)
    [32368] = { ITEM_MOD_BLOCK_VALUE_SHORT = 93 }, -- Tome of the Lightbringer (Avg 50% uptime)
    
    -- [[ PvP Healer (Flash of Light) ]]
    [28356] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 }, -- Gladiator's Libram of Justice
    [33077] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 31 }, -- Merciless Gladiator's Libram of Justice
    [33842] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 34 }, -- Vengeful Gladiator's Libram of Justice
    [35040] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 39 }, -- Brutal Gladiator's Libram of Justice

    -- [[ PvP Retribution (Judgement) ]]
    [33936] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 }, -- Gladiator's Libram of Fortitude
    [33937] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 31 }, -- Merciless Gladiator's Libram of Fortitude
    [33938] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 34 }, -- Vengeful Gladiator's Libram of Fortitude
    [35039] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 39 }, -- Brutal Gladiator's Libram of Fortitude

    -- [[ PvP Protection (Holy Shield) ]]
    [33948] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 }, -- Gladiator's Libram of Vengeance
    [33949] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 31 }, -- Merciless Gladiator's Libram of Vengeance
    [33950] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 34 }, -- Vengeful Gladiator's Libram of Vengeance
    [35041] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 39 }, -- Brutal Gladiator's Libram of Vengeance

    -- [[ Communal (Boost Gear) ]]
    [186065] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 10 }, -- Communal Book of Healing
    [186066] = { ITEM_MOD_ARMOR_SHORT = 50 }, -- Communal Book of Protection
    [186067] = { ITEM_MOD_MANA_REGENERATION_SHORT = 2 }, -- Communal Book of Righteousness
}

-- [[ DYNAMIC RELIC HANDLER ]]
-- Returns the interpreted stats for the Evaluator and Tooltip engines
function Paladin:GetRelicBonus(itemID, currentSpec)
    local bonus = {}
    
    -- Currently Paladins do not have complex multi-spec librams like the Druid's Raven Goddess,
    -- but use this function to maintain architectural consistency across all classes.
    if Paladin.Relics[itemID] then
        for k, v in pairs(Paladin.Relics[itemID]) do 
            bonus[k] = v 
        end
    end
    
    return bonus
end


-- =============================================================
-- LOGIC
-- =============================================================
function Paladin:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level == 70 then
        if Rank("AVENGERS_SHIELD") > 0 or Rank("HOLY_SHIELD") > 0 then return "PROT_DEEP" end
        if Rank("CRUSADER_STRIKE") > 0 or Rank("REPENTANCE") > 0 then return "RET_STANDARD" end
        
        if Rank("HOLY_SHOCK") > 0 then
            -- Shockadin check (Sanctity Aura + Holy Shock is usually PvP Shockadin)
            if Rank("SANCTITY_AURA") > 0 then return "SHOCKADIN_PVP" end 
            return "HOLY_RAID"
        end
        
        if Rank("DIVINE_ILLUM") > 0 then return "HOLY_RAID" end
        return "RET_STANDARD"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    -- Determine Role based on Talents
    local role = "Leveling_Ret" -- Default
    
    if Rank("HOLY_SHIELD") > 0 or Rank("AVENGERS_SHIELD") > 0 then 
        role = "Leveling_PROT_AOE" -- Changed to match your keys
    elseif Rank("DIVINE_ILLUM") > 0 or Rank("HOLY_SHOCK") > 0 then 
        role = "Leveling_HOLY_DUNGEON"
    else
        -- Fallback: Check Point Distribution
        local holyPts = GetNumTalentPoints(1)
        local protPts = GetNumTalentPoints(2)
        local retPts  = GetNumTalentPoints(3)
        
        if protPts > (holyPts + retPts) then role = "Leveling_PROT_DUNGEON"
        elseif holyPts > (protPts + retPts) then role = "Leveling_HOLY_DUNGEON"
        end
    end

    local specificKey = role .. suffix
    
    if Paladin.LevelingBrackets and Paladin.LevelingBrackets[specificKey] then return specificKey end
    if Paladin.LevelingWeights[specificKey] then return specificKey end
    if Paladin.LevelingWeights["Leveling" .. suffix] then return "Leveling" .. suffix end

    return "Leveling_RET" .. suffix
end

function Paladin:GetDynamicWeights(forceKey)
    -- [[ 1: TRANSLATOR ]]
    if forceKey and not Paladin.LevelingBrackets[forceKey] and not Paladin.Weights[forceKey] then
        if Paladin.PrettyNames then
            for key, name in pairs(Paladin.PrettyNames) do
                if name == forceKey then
                    forceKey = key
                    break
                end
            end
        end
    end

    local level = UnitLevel("player")
    local specKey = forceKey or self:GetSpec() 

    -- 1. Check Leveling Brackets
    if Paladin.LevelingBrackets and Paladin.LevelingBrackets[specKey] then
        local bracket = Paladin.LevelingBrackets[specKey]
        
        -- Calculate progress
        local progress = (level - bracket.min) / (bracket.max - bracket.min)
        
        -- [[ 2: PREVIEW CLAMPING ]]
        if forceKey then
            if level < bracket.min then progress = 0 end -- Show Start weights
            if level > bracket.max then progress = 1 end -- Show End weights
        else
            -- Normal play strict clamping
            if progress < 0 then progress = 0 end
            if progress > 1 then progress = 1 end
        end

        local dynamicWeights = {}
        
        -- [[ 3: ROBUSTNESS ]]
        local allStats = {}
        if bracket.Start then for k in pairs(bracket.Start) do allStats[k] = true end end
        if bracket.End then for k in pairs(bracket.End) do allStats[k] = true end end

        for stat, _ in pairs(allStats) do
            local startValue = (bracket.Start and bracket.Start[stat]) or 0
            local endValue = (bracket.End and bracket.End[stat]) or 0
            
            local result = startValue + ((endValue - startValue) * progress)
            
            -- Safety: Never return negative weight
            if result < 0 then result = 0 end
            
            dynamicWeights[stat] = result
        end
        
        return dynamicWeights, specKey
    end

    -- 2. Static Weights Fallback
    if Paladin.Weights and Paladin.Weights[specKey] then 
        return Paladin.Weights[specKey], specKey
    elseif Paladin.LevelingWeights and Paladin.LevelingWeights[specKey] then 
        return Paladin.LevelingWeights[specKey], specKey
    end

    return nil, specKey
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
    local _, raceID = UnitRace("player")
	local racialBonus = (raceID == "Draenei") and 15.8 or 0 -- Approx 1% hit in rating

	if weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
    local hitRating = GetCombatRating(6) 
    local baseCap = 142 
    local talentBonus = Rank("PRECISION") * 15.8
    -- Subtract racial from the required cap
    local finalCap = baseCap - talentBonus - racialBonus
        
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

            -- EFFECTIVE HEALTH PIVOT
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
        local _, raceID = UnitRace("player")
        
        local racialBonus = 0
        if raceID == "Human" then
            local itemLink = GetInventoryItemLink("player", 16)
            if itemLink then
                local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
                -- ClassID 2 = Weapon. 
                -- SubClass: 4=1H Mace, 5=2H Mace, 7=1H Sword, 8=2H Sword
                if classID == 2 and (subClassID == 4 or subClassID == 5 or subClassID == 7 or subClassID == 8) then
                    racialBonus = 5 * 3.94 -- 5 Expertise Skill converted to Rating (~19.7)
                end
            end
        elseif raceID == "Orc" then
             local itemLink = GetInventoryItemLink("player", 16)
             if itemLink then
                local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
                -- SubClass: 0=Axe 1H, 1=Axe 2H
                if classID == 2 and (subClassID == 0 or subClassID == 1) then
                    racialBonus = 5 * 3.94 
                end
             end
        elseif raceID == "Dwarf" then

        end

        -- Check cap against (Rating + Racial Bonus)
        if (expRating + racialBonus) >= 103 then -- 26 Expertise Cap (approx 103 rating)
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
    local _, raceID = UnitRace("player")

    if raceID == "Human" and (subClassID == 7 or subClassID == 8 or subClassID == 4 or subClassID == 5) then 
        bonus = bonus + 40 
    end
    
    return bonus
end

-- =============================================================
-- REGISTER PROFILES
-- =============================================================
Paladin.Profiles = {}
for k, v in pairs(Paladin.Weights) do Paladin.Profiles[k] = v end
if Paladin.LevelingBrackets then
    for k, v in pairs(Paladin.LevelingBrackets) do Paladin.Profiles[k] = v.End end
end
if Paladin.LevelingWeights then
    for k, v in pairs(Paladin.LevelingWeights) do Paladin.Profiles[k] = v end
end

MSC.RegisterModule("PALADIN", Paladin)