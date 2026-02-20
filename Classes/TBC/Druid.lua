local addonName, MSC = ...
local Druid = {}
Druid.Name = "DRUID"

-- =============================================================
-- ENDGAME STAT WEIGHTS (Static Profiles)
-- =============================================================
Druid.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["MSC_WEAPON_DPS"]=0.0, 
    },

    -- [[ 1. BALANCE (Boomkin) ]]
    ["BALANCE_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.4,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.7, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.3, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.4,
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.1, -- Added: Dead dps do no dps
        
        -- POISON PROTECTION (prevent negative scores on hybrid gear)
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 0.02,
        ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]= 0.02,
    },

    -- [[ 2. FERAL CAT (DPS) ]]
    ["FERAL_CAT"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.8, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.9, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.1, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.3, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]= 1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.6, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.8,
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.2, -- Added: Critical for DST / TBC Endgame
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.1, -- Added: Survival
        
        -- POISON PROTECTION
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,    
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },

    -- [[ 3. FERAL BEAR (Tank) ]]
    ["FERAL_BEAR"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,    
        -- SURVIVAL
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.8, 
        ["ITEM_MOD_ARMOR_SHORT"]            = 0.18,      
        -- MITIGATION
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.6,      
        -- AVOIDANCE
        ["ITEM_MOD_DODGE_RATING_SHORT"]     = 1.4, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 1.3, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.0,    
        -- THREAT
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.5, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.6, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 1.0, 
        ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]= 0.5,
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 0.8,
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 0.8, -- Added: Threat stat
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 0.4, -- Added: Threat stat
             
        -- TRASH
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.002,    
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.002,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.002,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.002,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.002,
        ["ITEM_MOD_PARRY_RATING_SHORT"]     = 0.002, 
        ["ITEM_MOD_BLOCK_RATING_SHORT"]     = 0.002, 
    },

    -- [[ 4. RESTO (Healer) ]]
    ["RESTO_TREE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 1.35, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 2.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.7, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.6, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.3,
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.2, -- Added: PvP/Survival crossover
        
        -- POISON PROTECTION
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02,
    },
}

-- Safety Init
Druid.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS (The Interpolation System)
-- =============================================================
Druid.LevelingBrackets = {

    -- [[ GENERIC / FERAL START ]]
    ["Leveling_1_20"] = { 
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.5, -- ADJUSTED: Staff bashing is #1 until Bear Form
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, -- Regeneration helps leveling
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 1.0, -- Troll blood is strong early
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 0.5,
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0
        }
    },
    
    -- [[ FERAL CAT LEVELING ]]
    -- Progression: Str/AP -> Agi/Crit
    ["Leveling_21_40"] = { 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.0, -- Bumped: Crit matters early for combo points
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0
        }
    },
    ["Leveling_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.4, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.4, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1
        }
    },
    ["Leveling_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 0.5
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, -- Reduced: Shift priority to Agi
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8,  -- Increased: Match Endgame "Agi is King"
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.5
        }
    },
    
    -- [[ FERAL BEAR LEVELING ]]
    -- Adjusted: Increased Strength/AP slightly so leveling bears can actually kill mobs
    ["Leveling_Bear_21_40"] = { 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2, -- Bumped from 1.0
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 0.8 -- Bumped from 0.5
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 0.8
        }
    },
    ["Leveling_Bear_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.8, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 0.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 0.8,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_Bear_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 0.5, -- Start tapering off for pure tanking
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 0.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0
        }
    },
    ["Leveling_Bear_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 0.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_ARMOR_SHORT"] = 1.2, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 0.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 4.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_ARMOR_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.0, -- Added: Threat
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 0.5
        }
    },
    
    -- [[ BOOMKIN LEVELING ]]
    -- Int is King. Spirit buffed for downtime.
    ["Leveling_Caster_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, -- Bumped from 0.8
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.8, -- Bumped: Boomkin needs MP5
			["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.0,
			["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = 1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, -- Bumped
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.8,
			["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.0,
			["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = 1.0
        }
    },
    ["Leveling_Caster_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.8,
			["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.0,
			["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = 1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.8,
			["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.0,
			["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = 1.0
        }
    },
    ["Leveling_Caster_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.0, -- TBC gearing
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 0.5,
			["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.0, 
			["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = 1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.0,
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 1.0,
			["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.0, 
			["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = 1.0
        }
    },
    
    -- [[ HEALER LEVELING (Dungeon Spam) ]]
    ["Leveling_Healer_21_40"] = { 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.0 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0
        }
    },
    ["Leveling_Healer_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0
        }
    },
    ["Leveling_Healer_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 2.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 2.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0
        }
    },
    ["Leveling_Healer_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.8, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5,
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 0.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 2.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.5,
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 1.0
        }
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Druid.Specs = { [1]="Balance", [2]="FeralCombat", [3]="Restoration" }

Druid.PrettyNames = {
    ["BALANCE_PVE"]       = "DPS: Balance (Boomkin)",
    ["RESTO_TREE"]        = "Healer: Tree of Life",
    ["FERAL_CAT"]         = "DPS: Feral Cat",
    ["FERAL_BEAR"]        = "Tank: Feral Bear",
    
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Feral Cat (21-40)",
    ["Leveling_41_51"] = "Feral Cat (41-51)",
    ["Leveling_52_59"] = "Feral Cat (52-59)",
    ["Leveling_60_70"] = "Feral Cat (Outland)",
    
    ["Leveling_Bear_21_40"]    = "Feral Bear (21-40)",
    ["Leveling_Bear_41_51"]    = "Feral Bear (41-51)",
    ["Leveling_Bear_52_59"]    = "Feral Bear (52-59)",
    ["Leveling_Bear_60_70"]    = "Feral Bear (Outland)",
    
    ["Leveling_Caster_41_51"] = "Balance (41-51)",
    ["Leveling_Caster_52_59"] = "Balance (52-59)",
    ["Leveling_Caster_60_70"] = "Balance (Outland)",
	
	["Leveling_Healer_21_40"] = "Resto Dungeon (21-40)",
    ["Leveling_Healer_41_51"] = "Resto Dungeon (41-51)",
    ["Leveling_Healer_52_59"] = "Resto Dungeon (52-59)",
    ["Leveling_Healer_60_70"] = "Resto Dungeon (Outland)",
}

Druid.SpeedChecks = { 
    ["Default"]={} 
}

Druid.ValidWeapons = {
    [4]=true, [5]=true,   -- 1H/2H Maces
    [10]=true,            -- Staves
    [13]=true,            -- Fist Weapons
    [15]=true             -- Daggers
}

Druid.StatToCritMatrix = { 
    Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.5}, {60, 60.0}, {70, 80.0} } 
}

Druid.Talents = { 
    ["MOONKIN_FORM"]="Moonkin Form", 
    ["FORCE_OF_NATURE"]="Force of Nature", 
    ["MANGLE"]="Mangle", 
    ["TREE_OF_LIFE"]="Tree of Life", 
    ["NATURES_GRACE"]="Nature's Grace", 
    ["HEART_WILD"]="Heart of the Wild", 
    ["LIVING_SPIRIT"]="Living Spirit", 
    ["DREAMSTATE"]="Dreamstate", 
    ["MOONGLOW"]="Moonglow", 
    ["NATURES_SWIFTNESS"]="Nature's Swiftness", 
    ["FERAL_INSTINCT"]="Feral Instinct",
    ["BALANCE_OF_POWER"] = "Balance of Power",  
    ["THICK_HIDE"]="Thick Hide",
    ["SURVIVAL_OF_FITTEST"] = "Survival of the Fittest",
    ["FERAL_CHARGE"]="Feral Charge",
	["INSECT_SWARM"]="Insect Swarm",
	["LUNAR_GUIDANCE"]="Lunar Guidance",
    ["PREDATORY_INSTINCTS"]="Predatory Instincts"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Druid:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level >= 60 then
        if Rank("TREE_OF_LIFE") > 0 then return "RESTO_TREE" end
        if Rank("MOONKIN_FORM") > 0 or Rank("FORCE_OF_NATURE") > 0 then return "BALANCE_PVE" end
        if Rank("MANGLE") > 0 or Rank("FERAL_INSTINCT") > 0 then
            if Rank("THICK_HIDE") >= 3 then return "FERAL_BEAR" end
            return "FERAL_CAT"
        end
        return "FERAL_CAT"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    -- Determine Role
    local role = "Leveling" 
    if Rank("MOONKIN_FORM") > 0 then role = "Leveling_Caster"
    elseif Rank("TREE_OF_LIFE") > 0 or Rank("NATURES_SWIFTNESS") > 0 or Rank("INSECT_SWARM") > 0 then 
        role = "Leveling_Healer"
    elseif Rank("FERAL_CHARGE") > 0 or Rank("THICK_HIDE") >= 3 then role = "Leveling_Bear"
    end 

    local specificKey = role .. suffix

    -- [[ FALLBACK CHECKS ]]
    if Druid.LevelingBrackets and Druid.LevelingBrackets[specificKey] then return specificKey end
    if Druid.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Druid:GetDynamicWeights(forceKey)
    -- [[ TRANSLATOR ]]
    if forceKey and not Druid.LevelingBrackets[forceKey] and not Druid.Weights[forceKey] then
        if Druid.PrettyNames then
            for key, name in pairs(Druid.PrettyNames) do
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
    if Druid.LevelingBrackets and Druid.LevelingBrackets[specKey] then
        local bracket = Druid.LevelingBrackets[specKey]
        
        -- Calculate progress
        local progress = (level - bracket.min) / (bracket.max - bracket.min)
        
        -- [[ PREVIEW CLAMPING ]]
        if forceKey then
            if level < bracket.min then progress = 0 end -- Show Start weights
            if level > bracket.max then progress = 1 end -- Show End weights
        else
            -- Normal play strict clamping
            if progress < 0 then progress = 0 end
            if progress > 1 then progress = 1 end
        end

        local dynamicWeights = {}
        
        -- [[ ROBUSTNESS ]]
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
    if Druid.Weights and Druid.Weights[specKey] then 
        return Druid.Weights[specKey], specKey
    elseif Druid.LevelingWeights and Druid.LevelingWeights[specKey] then 
        return Druid.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Druid:ApplyScalers(weights, currentSpec)
    -- [[ SAFETY COPY ]]
    local w = {}
    for k, v in pairs(weights) do w[k] = v end

    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {} 
    
    -- [[ 1. EXISTING TALENT SCALERS ]]
    -- Heart of the Wild (Int)
    local rHotW = Rank("HEART_WILD")
    if rHotW > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then 
        w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.04)) 
    end
    
    -- Living Spirit (Spirit) - 5% per rank
    local rLiv = Rank("LIVING_SPIRIT")
    if rLiv > 0 and w["ITEM_MOD_SPIRIT_SHORT"] then 
        w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] * (1 + (rLiv * 0.05)) 
    end

    -- [[ DREAMSTATE (Int -> Mp5) ]]
    -- Regenerate mana equal to 4/7/10% of Int.
    local rDream = Rank("DREAMSTATE")
    if rDream > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
        local mp5Value = w["ITEM_MOD_MANA_REGENERATION_SHORT"] or 0
        local conversion = 0.0
        if rDream == 1 then conversion = 0.04 end
        if rDream == 2 then conversion = 0.07 end
        if rDream == 3 then conversion = 0.10 end
        
        -- Effect: 100 Int = 10 Mp5.
        -- If 1 Mp5 = Score 2.0, then 10 Mp5 = Score 20.
        -- So 100 Int gains +20 Score. 1 Int gains +0.2 Score.
        -- Logic: 1 Int * Conversion * Mp5Weight
        if mp5Value > 0 then
             w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] + (conversion * mp5Value)
        end
    end

    -- [[ LUNAR GUIDANCE (Int -> SP) ]]
    local rLunar = Rank("LUNAR_GUIDANCE") 
    if rLunar > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
        -- 8/16/25% of Int converted to Spell Damage
        local ratio = rLunar * 0.083 -- Approx 8.3% per rank
        local spWeight = w["ITEM_MOD_SPELL_POWER_SHORT"] or 1.0
        w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] + (ratio * spWeight)
    end

    -- [[ PREDATORY INSTINCTS (Crit Dmg) ]]
    -- Increases Crit Dmg by 3/7/10%.
    -- This makes Crit Rating more valuable.
    local rPred = Rank("PREDATORY_INSTINCTS")
    if rPred > 0 then
         local scaler = 1.0
         if rPred == 1 then scaler = 1.03 end
         if rPred == 2 then scaler = 1.07 end
         if rPred == 3 then scaler = 1.10 end
         
         if w["ITEM_MOD_CRIT_RATING_SHORT"] then
             w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * scaler
         end
         -- Agility gives Crit, so it also scales slightly
         if w["ITEM_MOD_AGILITY_SHORT"] then
             w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * (1 + (scaler - 1)/2)
         end
    end


    -- [[ 2. COVARIANCE (Synergy) ]]
    if currentSpec:find("BALANCE") or currentSpec:find("Caster") then
        if w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] then
            -- [[ MANA SAFETY ]]
            -- If max mana is too low (<7000), Haste burns you out.
            local maxMana = UnitPowerMax("player", 0)
            if maxMana < 7000 then
                 w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 0.2 -- Heavy penalty until geared
            end

            local spellPower = GetSpellBonusDamage(4) -- 4 = Nature
            if spellPower > 600 then
                 local spScaler = 1 + ((spellPower - 600) / 10000)
                 if spScaler > 1.2 then spScaler = 1.2 end
                 w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] * spScaler
            end
        end

    elseif currentSpec:find("FERAL") or currentSpec:find("Bear") or currentSpec:find("Cat") then
        if w["ITEM_MOD_CRIT_RATING_SHORT"] then
            local base, pos, neg = UnitAttackPower("player")
            local totalAP = base + pos + neg
            if totalAP > 2000 then 
                 local apScaler = 1 + ((totalAP - 2000) / 20000)
                 if apScaler > 1.15 then apScaler = 1.15 end
                 w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * apScaler
            end
        end
        
        if (currentSpec:find("FERAL_CAT") or currentSpec:find("Cat")) and w["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] then
            local arPen = GetCombatRating(25)
            if arPen > 100 then
                local scaler = 1 + (arPen / 1000)
                if scaler > 1.4 then scaler = 1.4 end
                w["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = w["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] * scaler
            end
        end

    elseif currentSpec:find("RESTO") or currentSpec:find("Healer") then
        -- [[ SMART SPIRIT SCALING ]]
        if w["ITEM_MOD_SPIRIT_SHORT"] then
            local level = UnitLevel("player")
            local intellect = UnitStat("player", 4) -- Stat 4 = Intellect
            
            -- 1. Get raw MP5 gained from 1 Spirit
            local mp5Value = MSC:GetSpiritValueInMP5(level, intellect)
            
            -- 2. Combat Regeneration Uptime (Intensity)
            local combatMult = 0.65
            
            -- 3. Convert to Score
            local mp5Weight = w["ITEM_MOD_MANA_REGENERATION_SHORT"] or 2.0
            
            -- Spirit Weight = (MP5 gained) * (Value of MP5) * (Combat Uptime)
            w["ITEM_MOD_SPIRIT_SHORT"] = mp5Value * mp5Weight * combatMult
        end
    end
    
    -- [[ 3. CAPS with HYSTERESIS ]]
    
    -- A. BALANCE HIT CAP (Spell Hit)
    if (currentSpec:find("BALANCE") or currentSpec:find("Caster")) and w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(8) 
        local baseCap = 202 
        local talentBonus = Rank("BALANCE_OF_POWER") * 25.2 -- 2% per rank
        local finalCap = baseCap - talentBonus
        if finalCap < 0 then finalCap = 0 end
        
        if hitRating >= (finalCap + 5) then
            w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02
            table.insert(activeCaps, "Hit")
        elseif hitRating >= finalCap then
            w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] * 0.4
            table.insert(activeCaps, "Hit (Soft)")
        end
    end

    -- B. FERAL HIT CAP (Melee Hit 9%)
    if (currentSpec:find("FERAL") or currentSpec:find("Cat") or currentSpec:find("Bear")) and w["ITEM_MOD_HIT_RATING_SHORT"] and w["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(6)
        local cap = 142
        
        if hitRating >= (cap + 5) then -- Smaller buffer
        w["ITEM_MOD_HIT_RATING_SHORT"] = 0.01 -- Drop to near zero
        table.insert(activeCaps, "Hit")
    elseif hitRating >= cap then
        w["ITEM_MOD_HIT_RATING_SHORT"] = 0.1 -- Significant drop at cap
        table.insert(activeCaps, "Hit (Soft)")
    end
end
    
    -- [[ NEW: EXPERTISE CAP (6.5% Dodge) ]]
    if (currentSpec:find("FERAL") or currentSpec:find("Cat") or currentSpec:find("Bear")) and w["ITEM_MOD_EXPERTISE_RATING_SHORT"] then
        local expRating = GetCombatRating(24) -- CR_EXPERTISE
        -- Cap is 6.5% Dodge. 1 Exp = 3.94 rating. 26 Exp = 102.5 rating.
        local cap = 103 
        
        if expRating >= (cap + 12) then
            w["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.2
            table.insert(activeCaps, "Exp")
        elseif expRating >= cap then
            w["ITEM_MOD_EXPERTISE_RATING_SHORT"] = w["ITEM_MOD_EXPERTISE_RATING_SHORT"] * 0.4
            table.insert(activeCaps, "Exp (Soft)")
        end
    end

    -- C. BEAR CRIT IMMUNITY (Def/Resil)
    if (currentSpec:find("FERAL_BEAR") or currentSpec:find("Bear")) and w["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] then
        local baseDef, armorDef = UnitDefense("player")
        local defenseSkill = baseDef + armorDef
        local resil = GetCombatRating(15) 
        
        local reductionNeeded = 5.6
        if Rank("SURVIVAL_OF_FITTEST") >= 3 then 
            reductionNeeded = 2.6 
        end
        
        local defReduction = (defenseSkill - 350) * 0.04
        if defReduction < 0 then defReduction = 0 end
        local resilReduction = resil / 39.4
        local currentReduction = defReduction + resilReduction
        
        -- HYSTERESIS
        if currentReduction >= (reductionNeeded + 0.2) then
             w["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.6
             w["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 0.5
             table.insert(activeCaps, "Crit Immune")
             
             w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * 1.2
             w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * 1.2
             
        elseif currentReduction >= reductionNeeded then
             w["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.0
             w["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 0.8
             table.insert(activeCaps, "Immune (Soft)")
        else
             w["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.5
             w["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 2.5
        end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return w, capText
end

function Druid:GetWeaponBonus(itemLink) return 0 end

-- =============================================================
-- CLASS SPECIFIC ITEMS (Idols)
-- =============================================================
-- Note: Proc uptime and mana savings are averaged to standard stats 
-- (e.g., MP5 for mana reduction, AP for proc damage).
Druid.Relics = {
    [22397] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 20 }, -- Idol of Ferocity
    [22398] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 50 }, -- Idol of Rejuvenation
    [22399] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 100 }, -- Idol of Health
    [23197] = { ITEM_MOD_ARCANE_DAMAGE_SHORT = 33 }, -- Idol of the Moon
    [23198] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 50 }, -- Idol of Brutality
    [25643] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 86 }, -- Harold's Rejuvenating Broach
    [25667] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 40 }, -- Idol of the Beast (Averaged FB dmg)
    [25940] = { ITEM_MOD_HEALTH_REGENERATION_SHORT = 20 }, -- Idol of the Claw (Minor survival)
    [27518] = { ITEM_MOD_ARCANE_DAMAGE_SHORT = 55 }, -- Ivory Idol of the Moongoddess
    [27744] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 40 }, -- Idol of Ursoc
    [27886] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 88 }, -- Idol of the Emerald Queen
    [27989] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 30 }, -- Idol of Savagery
    [27990] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 30 }, -- Idol of Savagery
    [28064] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 38 }, -- Idol of the Wild (Averaged Cat/Bear)
    [28355] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 87 }, -- Gladiator's Idol of Tenacity
    [28372] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 40 }, -- Idol of Feral Shadows
    [28568] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 136 }, -- Idol of the Avian Heart
    [29390] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 88 }, -- Everbloom Idol
    [30051] = { ITEM_MOD_MANA_REGENERATION_SHORT = 25 }, -- Idol of the Crescent Goddess (Avg MP5)
    [31025] = { ITEM_MOD_NATURE_DAMAGE_SHORT = 25 }, -- Idol of the Avenger
    [32257] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 80 }, -- Idol of the White Stag (Avg proc AP)
    [33076] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 105 }, -- Merciless Gladiator's Idol of Tenacity
    [33508] = { ITEM_MOD_MANA_REGENERATION_SHORT = 15 }, -- Idol of Budding Life (Avg MP5)
    [33509] = { ITEM_MOD_AGILITY_SHORT = 45 }, -- Idol of Terror (Avg proc Agi)
    [33510] = { ITEM_MOD_SPELL_POWER_SHORT = 70 }, -- Idol of the Unseen Moon (Avg proc SP)
    [33841] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 116 }, -- Vengeful Gladiator's Idol of Tenacity
    
    -- PvP Moonfire Resil
    [33942] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 }, -- Gladiator's Idol of Steadfastness
    [33943] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 31 }, -- Merciless Gladiator's Idol of Steadfastness
    [33944] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 34 }, -- Vengeful Gladiator's Idol of Steadfastness
    [35020] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 39 }, -- Brutal Gladiator's Idol of Steadfastness
    
    -- PvP Mangle Resil
    [33945] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 }, -- Gladiator's Idol of Resolve
    [33946] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 31 }, -- Merciless Gladiator's Idol of Resolve
    [33947] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 34 }, -- Vengeful Gladiator's Idol of Resolve
    [35019] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 39 }, -- Brutal Gladiator's Idol of Resolve
    
    [35021] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 131 }, -- Brutal Gladiator's Idol of Tenacity
    [186052] = { ITEM_MOD_ARCANE_DAMAGE_SHORT = 10 }, -- Communal Idol of Wrath
    [186053] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 5 }, -- Communal Idol of the Wild
    [186054] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 15 }, -- Communal Idol of Life
    [23004] = { ITEM_MOD_MANA_REGENERATION_SHORT = 10 }, -- Idol of Longevity (Avg MP5)
}

-- [[ DYNAMIC RELIC HANDLER ]]
function Druid:GetRelicBonus(itemID, currentSpec)
    local bonus = {}
    
    -- 1. Handle Dynamic Idols
    if itemID == 32387 then -- Idol of the Raven Goddess
        if currentSpec:find("RESTO") or currentSpec:find("Healer") then 
            bonus.ITEM_MOD_SPELL_HEALING_DONE_SHORT = 44
        elseif currentSpec:find("FERAL") or currentSpec:find("Cat") or currentSpec:find("Bear") then 
            bonus.ITEM_MOD_CRIT_RATING_SHORT = 20
        elseif currentSpec:find("BALANCE") or currentSpec:find("Caster") then 
            bonus.ITEM_MOD_SPELL_CRIT_RATING_SHORT = 20 
        end
        return bonus
    end
    
    -- 2. Handle Static Idols
    if Druid.Relics[itemID] then
        for k, v in pairs(Druid.Relics[itemID]) do bonus[k] = v end
    end
    
    return bonus
end

-- =============================================================
-- REGISTER PROFILES FOR INIT (UI LIST ONLY)
-- =============================================================
Druid.Profiles = {}
for k, v in pairs(Druid.Weights) do Druid.Profiles[k] = v end
if Druid.LevelingBrackets then
    for k, v in pairs(Druid.LevelingBrackets) do Druid.Profiles[k] = v.End end
end
if Druid.LevelingWeights then
    for k, v in pairs(Druid.LevelingWeights) do Druid.Profiles[k] = v end
end
MSC.RegisterModule("DRUID", Druid)