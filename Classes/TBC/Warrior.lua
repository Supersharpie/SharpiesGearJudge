local addonName, MSC = ...
local Warrior = {}
Warrior.Name = "WARRIOR"

-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Warrior.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5,
        ["MSC_WEAPON_DPS"]=2.0 
    },
    ["FURY_DW"] = { 
        ["MSC_WEAPON_DPS"]                  = 6.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.35,
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.3, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.5,            
        -- TRACE VALUES (Avoids penalty)
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02, ["ITEM_MOD_HEALING_POWER_SHORT"]=0.02,
        -- ZERO VALUES (Kills Double Dipping)
        ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0,
    },
    ["FURY_2H"] = { 
        ["MSC_WEAPON_DPS"]                  = 6.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.2, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.35, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.5,                
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02, ["ITEM_MOD_HEALING_POWER_SHORT"]=0.02,
        -- ZERO VALUES
        ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0,
    },    
    ["ARMS_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 5.0,
        ["MSC_WEAPON_SPEED"]                = 15.0,      
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.3, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.5, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.4, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.1, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.4,
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02, ["ITEM_MOD_HEALING_POWER_SHORT"]=0.02,
    },      
    ["ARMS_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 4.5,
        ["MSC_WEAPON_SPEED"]                = 15.0,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.8,  
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.5, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.5,
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.0,                
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02, ["ITEM_MOD_HEALING_POWER_SHORT"]=0.02,
    },      
    ["DEEP_PROT"] = { 
        ["MSC_WEAPON_DPS"]                  = 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.6, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 2.4, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]      = 0.7, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]     = 1.0, 
        ["ITEM_MOD_PARRY_RATING_SHORT"]     = 1.0, 
        ["ITEM_MOD_BLOCK_RATING_SHORT"]     = 0.9, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.6, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.6, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.5,                
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02, ["ITEM_MOD_HEALING_POWER_SHORT"]=0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0,
    },
}

-- Safety Init
Warrior.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS
-- =============================================================
Warrior.LevelingBrackets = {
["Leveling_1_20"] = {
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, ["MSC_WEAPON_SPEED"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, -- Buffed (King)
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, -- BUFFED: High scaling at low lvl (Crit/Dodge/Armor)
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.2, -- Nerfed below Str
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, -- Nerfed. You don't need much HP in Durotar/Elwynn.
            ["ITEM_MOD_ARMOR_SHORT"] = 0.1, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 12.0, ["MSC_WEAPON_SPEED"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.4, -- Still very strong
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.1, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },
    ["Leveling_2H_21_40"] = {
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, ["MSC_WEAPON_SPEED"] = 1.5, -- Ramping for WW (Lvl 36)
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, ["ITEM_MOD_AGILITY_SHORT"] = 1.4,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 13.0, ["MSC_WEAPON_SPEED"] = 2.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.8, ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },
    ["Leveling_2H_41_51"] = { -- The Mortal Strike Era
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 13.0, ["MSC_WEAPON_SPEED"] = 2.5, -- JUMP: MS unlocked. Fast weapons are now bad.
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5, ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5, ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 14.0, ["MSC_WEAPON_SPEED"] = 2.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.2, ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.4,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },
    ["Leveling_2H_52_59"] = {
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 14.0, ["MSC_WEAPON_SPEED"] = 2.8, -- Fixed logic dip
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.2, ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.4, ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 15.0, ["MSC_WEAPON_SPEED"] = 3.0, -- Preparing for Outland
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.5, ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, ["ITEM_MOD_STAMINA_SHORT"] = 1.8,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.3,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },
    ["Leveling_2H_60_70"] = {
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 15.0, ["MSC_WEAPON_SPEED"] = 3.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.5, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5, ["ITEM_MOD_STAMINA_SHORT"] = 2.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.4,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 16.0, ["MSC_WEAPON_SPEED"] = 3.5, -- BUFFED: Slow weapons are critical for Arms
            ["ITEM_MOD_STRENGTH_SHORT"] = 4.0, -- BUFFED: Better ratio vs Weapon DPS (1 DPS ~= 4 Str)
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, -- NERFED: Kill speed > Survival
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },     
["Leveling_DW_21_40"] = {
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 1.0,     -- Likes Slow MH slightly
            ["MSC_OH_WEAPON_SPEED"] = -1.0, -- Likes FAST OH (Negative weight favors lower numbers)
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.0, ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 11.0, 
            ["MSC_WEAPON_SPEED"] = 1.2, 
            ["MSC_OH_WEAPON_SPEED"] = -1.2,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, ["ITEM_MOD_AGILITY_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0, ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },
    ["Leveling_DW_41_51"] = {
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 11.0, 
            ["MSC_WEAPON_SPEED"] = 1.5,     -- MH Priority increases (Whirlwind)
            ["MSC_OH_WEAPON_SPEED"] = -1.5, -- OH Priority increases (Flurry/Rage)
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8, ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 1.8, 
            ["MSC_OH_WEAPON_SPEED"] = -1.8, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.2, ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, ["ITEM_MOD_AGILITY_SHORT"] = 1.6,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },
    ["Leveling_DW_52_59"] = {
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 2.0, 
            ["MSC_OH_WEAPON_SPEED"] = -2.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.2, ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.4, ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 13.0, 
            ["MSC_WEAPON_SPEED"] = 2.2, 
            ["MSC_OH_WEAPON_SPEED"] = -2.2,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.5, ["ITEM_MOD_HIT_RATING_SHORT"] = 2.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.6, ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.4,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },
    ["Leveling_DW_60_70"] = {
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["MSC_OH_WEAPON_SPEED"] = -2.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.5, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.8, ["ITEM_MOD_HIT_RATING_SHORT"] = 3.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.5, ["ITEM_MOD_STAMINA_SHORT"] = 2.2,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 15.0, 
            ["MSC_WEAPON_SPEED"] = 3.0,     -- Heavy pref for Slow MH
            ["MSC_OH_WEAPON_SPEED"] = -3.0, -- Heavy pref for Fast OH
            ["ITEM_MOD_STRENGTH_SHORT"] = 4.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 3.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },
    ["Leveling_Tank_21_40"] = {
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["MSC_WEAPON_SPEED"] = -1.0, -- Prefer Fast for Rage/Heroic Strike
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0, -- Buffed slightly (Survival is key)
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.8, -- Buffed (Threat)
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, -- Good mitigation
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 1.0, -- Start valuing this early
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["MSC_WEAPON_SPEED"] = -1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 2.5, -- Shield Slam unlocked (Lvl 40)
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },
    ["Leveling_Tank_41_51"] = {
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 8.0, -- 5.0 is too low for soloing. 8.0 is a safer balance.
            ["MSC_WEAPON_SPEED"] = -1.5, -- Added: Fast weapons still king for HS queueing
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 2.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, -- Kept relevant for AP/BlockValue
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, -- Added back
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 9.0,
            ["MSC_WEAPON_SPEED"] = -1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 4.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },
    ["Leveling_Tank_52_59"] = {
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 9.0,
            ["MSC_WEAPON_SPEED"] = -1.5, -- Keep speed relevant
            ["ITEM_MOD_STAMINA_SHORT"] = 4.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5, ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.0, ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 10.0,
            ["MSC_WEAPON_SPEED"] = 0.0, -- Begin normalizing speed as we approach Devastate 5-stack era
            ["ITEM_MOD_STAMINA_SHORT"] = 4.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.8, ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    },
    ["Leveling_Tank_60_70"] = {
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, ["MSC_WEAPON_SPEED"] = 0.0, -- Speed neutral (Devastate)
            ["ITEM_MOD_STAMINA_SHORT"] = 5.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.5, -- Resilience works for Crit Cap in TBC Dungeons
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.8, ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 14.0, ["ITEM_MOD_STAMINA_SHORT"] = 6.0,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 4.0, -- Push for Cap (490)
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3.5, -- Parry Haste death is real in Heroics
            ["ITEM_MOD_HIT_RATING_SHORT"] = 3.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.5,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 2.5, ["ITEM_MOD_PARRY_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
        }
    }
}

Warrior.Specs = { [1]="Arms", [2]="Fury", [3]="Protection" }

Warrior.PrettyNames = {
    ["FURY_2H"]             = "Raid: Arms/Fury (2H)",
    ["FURY_DW"]             = "Raid: Fury (Dual Wield)",
    ["ARMS_PVP"]            = "PvP: Arms (Mortal Strike)",
    ["ARMS_PVE"]            = "Raid: Arms (Blood Frenzy)",
    ["DEEP_PROT"]           = "Tank: Deep Protection",
    ["Leveling_2H_1_20"]  = "Starter (1-20)",
    ["Leveling_2H_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_2H_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_2H_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_2H_60_70"] = "Standard Leveling (Outland)",
    ["Leveling_DW_21_40"]    = "Fury/DW (21-40)",
    ["Leveling_DW_41_51"]    = "Fury/DW (41-51)",
    ["Leveling_DW_52_59"]    = "Fury/DW (52-59)",
    ["Leveling_DW_60_70"]    = "Fury/DW (Outland)",
    ["Leveling_Tank_21_40"] = "Dungeon Tank (21-40)",
    ["Leveling_Tank_41_51"] = "Dungeon Tank (41-51)",
    ["Leveling_Tank_52_59"] = "Dungeon Tank (52-59)",
    ["Leveling_Tank_60_70"] = "Dungeon Tank (Outland)",
}
Warrior.SpeedChecks = { 
    ["Default"]={ MH_Slow=true }, 
    ["FURY_DW"]={ MH_Slow=true, OH_Fast=true }, 
    ["DEEP_PROT"]={ MH_Fast=true } 
}
Warrior.ValidWeapons = {
    [0]=true, [1]=true, [4]=true, [5]=true, [7]=true, [8]=true, [6]=true, [10]=true, [13]=true, [15]=true,
    [2]=true, [3]=true, [18]=true, [16]=true
}

Warrior.StatToCritMatrix = { Agi = { {1, 4.0}, {60, 20.0}, {70, 33.0} } }
Warrior.Talents = { 
    ["PRECISION"]="Precision", ["MORTAL_STRIKE"]="Mortal Strike", ["ENDLESS_RAGE"]="Endless Rage",
    ["BLOOD_FRENZY"]="Blood Frenzy", ["SECOND_WIND"]="Second Wind", ["BLOODTHIRST"]="Bloodthirst",
    ["RAMPAGE"]="Rampage", ["SHIELD_SLAM"]="Shield Slam", ["DEVASTATE"]="Devastate", ["VITALITY"]="Vitality",
    ["POLEAXE_SPEC"]="Poleaxe Specialization", ["SWORD_SPEC"]="Sword Specialization", ["MACE_SPEC"]="Mace Specialization",
    ["DUAL_WIELD_SPEC"]="Dual Wield Specialization" -- ADDED for early detection
}

function Warrior:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level == 70 then
        if Rank("DEVASTATE") > 0 or Rank("SHIELD_SLAM") > 0 then return "DEEP_PROT" end
        if Rank("RAMPAGE") > 0 or Rank("BLOODTHIRST") > 0 then return "FURY_DW" end
        if Rank("MORTAL_STRIKE") > 0 then
            if Rank("BLOOD_FRENZY") > 0 then return "ARMS_PVE" end
            return "ARMS_PVP"
        end
        return "FURY_DW"
    end

    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    -- [[ BETTER DETECTION LOGIC ]]
    local role = "Leveling_2H"
    
    if Rank("SHIELD_SLAM") > 0 or Rank("DEVASTATE") > 0 then 
        role = "Leveling_Tank"
    elseif Rank("BLOODTHIRST") > 0 or Rank("RAMPAGE") > 0 or Rank("DUAL_WIELD_SPEC") > 0 then 
        -- Check for Tier 4 Fury talent "Dual Wield Specialization"
        -- This allows us to detect DW intent at Level 30-35, not just Level 40
        role = "Leveling_DW"
    else
        -- Fallback: Point Scan
        -- If user has significantly more points in Fury (Tab 2) than Arms (Tab 1), assume DW
        local furyPts = GetNumTalentPoints(2)
        local armsPts = GetNumTalentPoints(1)
        if furyPts > (armsPts + 5) and level > 25 then 
            role = "Leveling_DW" 
        end
    end

    local specificKey = role .. suffix
    if Warrior.LevelingBrackets and Warrior.LevelingBrackets[specificKey] then return specificKey end
    if Warrior.LevelingWeights[specificKey] then return specificKey end
    if Warrior.LevelingWeights["Leveling" .. suffix] then return "Leveling" .. suffix end
    return "Leveling_2H" .. suffix
end

function Warrior:GetDynamicWeights()
    local level = UnitLevel("player")
    local specKey = self:GetSpec()

    if Warrior.LevelingBrackets and Warrior.LevelingBrackets[specKey] then
        local bracket = Warrior.LevelingBrackets[specKey]
        local progress = (level - bracket.min) / (bracket.max - bracket.min)
        if progress < 0 then progress = 0 end
        if progress > 1 then progress = 1 end

        local dynamicWeights = {}
        for stat, endValue in pairs(bracket.End) do
            local startValue = bracket.Start[stat] or 0
            dynamicWeights[stat] = startValue + ((endValue - startValue) * progress)
        end
        return dynamicWeights, specKey
    end

    if Warrior.Weights and Warrior.Weights[specKey] then return Warrior.Weights[specKey], specKey
    elseif Warrior.LevelingWeights and Warrior.LevelingWeights[specKey] then return Warrior.LevelingWeights[specKey], specKey
    end
    return nil, specKey
end

function Warrior:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ OFFHAND & FURY HANDLING ]]
    if currentSpec and (currentSpec:find("ARMS") or currentSpec:find("2H")) then
        -- 2H Spec looking at 1H weapons
        weights["MSC_WEAPON_DPS_OH"] = 0.5 
    elseif currentSpec and (currentSpec:find("FURY") or currentSpec:find("DW")) then
        -- Fury/DW Spec
        weights["MSC_WEAPON_DPS_OH"] = 0.625 -- 50% Base + 25% Talent = 62.5% effective DPS
        
        -- [[ SPEED TRICK INJECTION ]]
        -- If we haven't defined a specific OH Speed weight, create one by inverting MH speed.
        -- This ensures Fast OH is preferred even if the bracket doesn't have the key.
        if not weights["MSC_OH_WEAPON_SPEED"] and weights["MSC_WEAPON_SPEED"] then
            weights["MSC_OH_WEAPON_SPEED"] = -1 * math.abs(weights["MSC_WEAPON_SPEED"])
        end
    end

    if weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] then
        local arPen = GetCombatRating(25)
        if arPen > 100 then
            local scaler = 1 + (arPen / 1000) 
            if scaler > 1.4 then scaler = 1.4 end
            weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] * scaler
        end
    end

    if weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(6) 
        local baseCap = 142
        local talentBonus = Rank("PRECISION") * 15.8
        local finalCap = baseCap - talentBonus
        if finalCap < 0 then finalCap = 0 end
        
        if hitRating >= (finalCap + 15) then
            if currentSpec:find("FURY") or currentSpec:find("DW") then
                weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.8
                table.insert(activeCaps, "Y-Hit (Rage)")
            else
                weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.1
                table.insert(activeCaps, "Hit")
            end
        elseif hitRating >= finalCap then
            if currentSpec:find("FURY") or currentSpec:find("DW") then
                 weights["ITEM_MOD_HIT_RATING_SHORT"] = 1.4
            else
                 weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * 0.4
            end
            table.insert(activeCaps, "Hit (Soft)")
        end
    end

    if weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] and weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] > 1.0 then
        local baseDef, armorDef = UnitDefense("player")
        if (baseDef + armorDef) >= 490 then
            weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.8
            table.insert(activeCaps, "Def")
            weights["ITEM_MOD_STAMINA_SHORT"] = (weights["ITEM_MOD_STAMINA_SHORT"] or 1.5) * 1.3
            weights["ITEM_MOD_ARMOR_SHORT"] = (weights["ITEM_MOD_ARMOR_SHORT"] or 0.1) * 1.5
        end
    end

    if weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] and weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] > 0.1 then
        local expRating = GetCombatRating(24)
        local _, raceID = UnitRace("player")
        
        -- [[ RACIAL EXPERTISE FIX ]]
        local racialBonus = 0
        local itemLink = GetInventoryItemLink("player", 16)
        if itemLink then
             local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
             if classID == 2 then -- Weapon
                 if raceID == "Human" and (subClassID == 4 or subClassID == 5 or subClassID == 7 or subClassID == 8) then
                    racialBonus = 20 -- 5 Skill ~ 20 Rating
                 elseif raceID == "Orc" and (subClassID == 0 or subClassID == 1 or subClassID == 13) then
                    racialBonus = 20 
                 end
             end
        end

        if (expRating + racialBonus) >= 103 then
            weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] = weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] * 0.5
            table.insert(activeCaps, "Exp")
        end
    end

    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Warrior:GetWeaponBonus(itemLink)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    if race == "Human" and (subClassID == 7 or subClassID == 8 or subClassID == 4 or subClassID == 5) then bonus = bonus + 40 end
    if race == "Orc" and (subClassID == 0 or subClassID == 1 or subClassID == 13) then bonus = bonus + 40 end

    local function Rank(k) return MSC:GetTalentRank(k) end
    if subClassID == 0 or subClassID == 1 or subClassID == 6 then
        local rank = Rank("POLEAXE_SPEC")
        if rank > 0 then bonus = bonus + (rank * 35.0) end
    end
    if subClassID == 7 or subClassID == 8 then
        local rank = Rank("SWORD_SPEC")
        if rank > 0 then bonus = bonus + (rank * 35.0) end
    end
    if subClassID == 4 or subClassID == 5 then
        local rank = Rank("MACE_SPEC")
        if rank > 0 then bonus = bonus + (rank * 10.0) end
    end

    return bonus
end

Warrior.Profiles = {}
for k, v in pairs(Warrior.Weights) do Warrior.Profiles[k] = v end
if Warrior.LevelingBrackets then
    for k, v in pairs(Warrior.LevelingBrackets) do Warrior.Profiles[k] = v.End end
end
if Warrior.LevelingWeights then
    for k, v in pairs(Warrior.LevelingWeights) do Warrior.Profiles[k] = v end
end

MSC.RegisterModule("WARRIOR", Warrior)