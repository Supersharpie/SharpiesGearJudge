local addonName, MSC = ...
local Warlock = {}
Warlock.Name = "WARLOCK"

-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Warlock.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.3, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
        ["MSC_WEAPON_DPS"]=0.0 
    },

    -- [[ 1. DESTRUCTION SHADOW ]]
    ["DESTRUCT_SHADOW"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        -- POISON PROTECTION
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 0.02, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },

    -- [[ 2. DESTRUCTION FIRE ]]
    ["DESTRUCT_FIRE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        -- POISON PROTECTION
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 0.02,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },

    -- [[ 3. RAID AFFLICTION ]]
    ["RAID_AFFLICTION"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.4, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.6, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.3,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 0.02,
    },

    -- [[ 4. DEMO PVE ]]
    ["DEMO_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.9, -- High base for Demonic Knowledge
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.6, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },

    -- [[ 5. PVP SL/SL ]]
    ["PVP_SL_SL"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.8, -- King Stat
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.3, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.0,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },
}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS
-- =============================================================
Warlock.LevelingBrackets = {
    -- [[ STANDARD AFFLICTION (1-20) ]]
    -- Wand is God. Spirit/Stam for Life Tap sustainability.
    ["Leveling_1_20"] = {
        min = 1, max = 20,
        Start = { 
            ["MSC_WAND_DPS"] = 2.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.5, -- Nice for Life Tap offset
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.4,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2, -- Low priority early
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        }
    },
    ["Leveling_21_40"] = {
        min = 21, max = 40,
        Start = { 
            ["MSC_WAND_DPS"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2,   
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,     
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.4,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        },
        End = { 
            ["MSC_WAND_DPS"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        }
    },
    ["Leveling_41_51"] = { -- Dark Pact era (Mana from Pet). Spirit value drops.
        min = 41, max = 51,
        Start = { 
            ["MSC_WAND_DPS"] = 1.5, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,      
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,       
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.8, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        }
    },
    ["Leveling_52_59"] = {
        min = 52, max = 59,
        Start = { 
            ["MSC_WAND_DPS"] = 0.8, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.4, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5
        }
    },
    ["Leveling_60_70"] = { -- Outland Drain Tanking
        min = 60, max = 70,
        Start = { 
            ["MSC_WAND_DPS"] = 0.4, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.5,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.5,    
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8,          
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,        
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 0.5 -- Added TBC Stat
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.1, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 3.2, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 3.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 1.0
        }
    },

    -- [[ DESTRUCTION (FIRE) ]]
    -- Focus: Crit / Fire Dmg / Int (Mana hungry).
    ["Leveling_Fire_21_40"] = {
        min = 21, max = 40,
        Start = { 
            ["MSC_WAND_DPS"] = 1.5, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.2,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,    
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,      
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2, -- Added for Sync
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 1.2, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Fire_41_51"] = {
        min = 41, max = 51,
        Start = { 
            ["MSC_WAND_DPS"] = 1.2, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.8, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Fire_52_59"] = { -- FIXED: Added missing bracket!
        min = 52, max = 59,
        Start = { 
            ["MSC_WAND_DPS"] = 0.8, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 2.2,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.4, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Fire_60_70"] = {
        min = 60, max = 70,
        Start = { 
            ["MSC_WAND_DPS"] = 0.4, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 2.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.5,        
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,   
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, -- Added for Sync
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4, -- Added for Sync
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 0.5, -- Added TBC Stat
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.1, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 3.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 3.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },

    -- [[ DEMO LEVELING ]]
    -- Focus: Stamina (Pet Scaling) / SP.
    ["Leveling_Demo_21_40"] = {
        min = 21, max = 40,
        Start = { 
            ["MSC_WAND_DPS"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,   
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 0.8, -- Added for Sync
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.1,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.4,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Demo_41_51"] = { -- Felguard Era
        min = 41, max = 51,
        Start = { 
            ["MSC_WAND_DPS"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.2,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2,   
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,     
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2, -- Added for Sync
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2, -- Added for Sync
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.6, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Demo_52_59"] = {
        min = 52, max = 59,
        Start = { 
            ["MSC_WAND_DPS"] = 0.6, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8,       
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Demo_60_70"] = {
        min = 60, max = 70,
        Start = { 
            ["MSC_WAND_DPS"] = 0.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.8,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.5,        
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2,   
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,          
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 0.5, -- Added TBC Stat
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.1, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 3.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 0.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
}
-- =============================================================
-- CLASS METADATA
-- =============================================================
Warlock.Specs = { [1]="Affliction", [2]="Demonology", [3]="Destruction" }

Warlock.PrettyNames = {
    ["DESTRUCT_SHADOW"]  = "Raid: Destruction (Shadow)",
    ["DESTRUCT_FIRE"]    = "Raid: Destruction (Fire)",
    ["RAID_AFFLICTION"]  = "Raid: Affliction (UA)",
    ["DEMO_PVE"]         = "Raid: Demonology (Felguard)",
    ["PVP_SL_SL"]        = "PvP: Soul Link / Siphon Life",
    -- Leveling Brackets
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
    ["Leveling_Fire_21_40"] = "Destro Fire (21-40)",
    ["Leveling_Fire_41_51"] = "Destro Fire (41-51)",
    ["Leveling_Fire_52_59"] = "Destro Fire (52-59)",
    ["Leveling_Fire_60_70"] = "Destro Fire (Outland)",
    
    ["Leveling_Demo_21_40"] = "Demonology (21-40)",
    ["Leveling_Demo_41_51"] = "Demonology (41-51)",
    ["Leveling_Demo_52_59"] = "Demonology (52-59)",
    ["Leveling_Demo_60_70"] = "Demonology (Outland)",
}

Warlock.SpeedChecks = { ["Default"]={} }

Warlock.ValidWeapons = {
    [7]=true,             -- 1H Swords
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

Warlock.StatToCritMatrix = { 
    Agi = { {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.5}, {60, 60.6}, {70, 80.0} } 
}

Warlock.Talents = { 
    ["DARK_PACT"]       = "Dark Pact", 
    ["UNSTABLE_AFF"]    = "Unstable Affliction", 
    ["SIPHON_LIFE"]     = "Siphon Life", 
    ["SOUL_LINK"]       = "Soul Link", 
    ["SUMMON_FELGUARD"] = "Summon Felguard", 
    ["CONFLAGRATE"]     = "Conflagrate", 
    ["RUIN"]            = "Ruin", 
    ["SHADOWFURY"]      = "Shadowfury", 
    ["DEMONIC_EMBRACE"] = "Demonic Embrace", 
    ["FEL_INTELLECT"]   = "Fel Intellect",
    ["EMBERSTORM"]      = "Emberstorm",
    ["SUPPRESSION"]     = "Suppression",
	["DEMONIC_AEGIS"]     = "Demonic Aegis",
    ["DEMONIC_KNOWLEDGE"] = "Demonic Knowledge" -- Added for Logic
}

-- =============================================================
-- LOGIC
-- =============================================================
function Warlock:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level == 70 then
        if Rank("SHADOW_MASTERY") > 0 then return "AFFLICTION_RAID" end
        if Rank("RUIN") > 0 then return "DESTRUCTION_RAID" end
        return "AFFLICTION_RAID"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
    if Rank("CONFLAGRATE") > 0 or Rank("SHADOWBURN") > 0 then role = "Leveling_Fire"
    elseif Rank("SOUL_LINK") > 0 or Rank("FEL_DOMINATION") > 0 then role = "Leveling_Demo"
    end 

    local specificKey = role .. suffix
    if Warlock.LevelingBrackets and Warlock.LevelingBrackets[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Warlock:GetDynamicWeights(forceKey)
    -- [[ FIX 1: TRANSLATOR ]]
    -- If the dropdown sends a "Pretty Name" (e.g. "Standard Leveling..."), 
    -- we reverse-lookup the "Code Key" (e.g. "Leveling_2H...").
    if forceKey and not Warlock.LevelingBrackets[forceKey] and not Warlock.Weights[forceKey] then
        if Warlock.PrettyNames then
            for key, name in pairs(Warlock.PrettyNames) do
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
    if Warlock.LevelingBrackets and Warlock.LevelingBrackets[specKey] then
        local bracket = Warlock.LevelingBrackets[specKey]
        
        -- Calculate progress
        local progress = (level - bracket.min) / (bracket.max - bracket.min)
        
        -- [[ FIX 2: PREVIEW CLAMPING ]]
        -- If previewing a different level bracket, force progress to 0 or 1 
        -- to prevent "Negative Stats" from vanishing.
        if forceKey then
            if level < bracket.min then progress = 0 end -- Show Start weights
            if level > bracket.max then progress = 1 end -- Show End weights
        else
            -- Normal play strict clamping
            if progress < 0 then progress = 0 end
            if progress > 1 then progress = 1 end
        end

        local dynamicWeights = {}
        
        -- [[ FIX 3: ROBUSTNESS ]]
        -- Collect ALL keys so nothing vanishes if you made a typo in Start vs End
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
    if Warlock.Weights and Warlock.Weights[specKey] then 
        return Warlock.Weights[specKey], specKey
    elseif Warlock.LevelingWeights and Warlock.LevelingWeights[specKey] then 
        return Warlock.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Warlock:ApplyScalers(weights, currentSpec)
    -- [[ FIX: SAFETY GUARD ]]
    -- We add "or 0" here. If GetTalentRank returns nil (unscanned/missing), 
    -- it defaults to 0 so the math below never crashes.
    local function Rank(k) return MSC:GetTalentRank(k) or 0 end
    
    local level = UnitLevel("player")
    local activeCaps = {}
    
    -- [[ 1. EXISTING TALENTS ]]
    -- Now safe: 1 + (0 * 0.03) = 1. No more crash.
    local rEmb = Rank("DEMONIC_EMBRACE")
    if rEmb > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then 
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03)) 
    end
    
    local rFel = Rank("FEL_INTELLECT")
    if rFel > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rFel * 0.01)) 
    end

    -- [[ 2. FEL ARMOR & DEMONIC KNOWLEDGE ]]
    if level >= 62 and weights["ITEM_MOD_SPIRIT_SHORT"] then
        local spiritConversion = 0.3 -- Base Fel Armor (30%)
        
        local rDemonicAegis = Rank("DEMONIC_AEGIS") 
        if rDemonicAegis > 0 then
            spiritConversion = spiritConversion * (1 + (rDemonicAegis * 0.10)) 
        end
        
        -- Add Spell Power value of Spirit to the Spirit Weight
        weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] + (spiritConversion * (weights["ITEM_MOD_SPELL_POWER_SHORT"] or 1.0))
    end

    -- Demonic Knowledge (Stam/Int -> SP)
    local rDemoKnow = Rank("DEMONIC_KNOWLEDGE")
    if rDemoKnow > 0 then
        local boost = rDemoKnow * 0.05
        if weights["ITEM_MOD_STAMINA_SHORT"] then 
            weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] + boost
        end
        if weights["ITEM_MOD_INTELLECT_SHORT"] then 
            weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + boost
        end
    end

    -- [[ 3. COVARIANCE (Destro Loves Crit/Haste) ]]
    if currentSpec:find("DESTRUCT") then
        local spellPower = 0
        if currentSpec:find("SHADOW") then spellPower = GetSpellBonusDamage(3) 
        else spellPower = GetSpellBonusDamage(2) end
        
        if spellPower > 600 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            local scaler = 1 + ((spellPower - 600) / 10000)
            if scaler > 1.2 then scaler = 1.2 end -- Capped at 20% bonus
            weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * scaler
            if weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] then
                 weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] * scaler
            end
        end
    end
    
    -- [[ 4. HIT CAP with HYSTERESIS ]]
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(8) 
        local baseCap = 202 -- TBC Standard
        
        if currentSpec:find("PVP") then
            baseCap = 51 
        end
        
        local talentBonus = 0
        if (currentSpec:find("AFFLICTION") or currentSpec:find("Leveling")) and not currentSpec:find("Fire") then
         talentBonus = Rank("SUPPRESSION") * 25.2 
        end
        
        local finalCap = baseCap - talentBonus

        local _, race = UnitRace("player")
        if race == "Draenei" then finalCap = finalCap - 12.6 end

        if finalCap < 0 then finalCap = 0 end
        
        -- BUFFER LOGIC
        if hitRating >= (finalCap + 10) then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.05 
            table.insert(activeCaps, "Hit (Capped)")
        elseif hitRating >= finalCap then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] * 0.2
            table.insert(activeCaps, "Hit (Soft)")
        end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Warlock:GetWeaponBonus(itemLink) return 0 end

-- =============================================================
-- REGISTER PROFILES FOR INIT (UI LIST ONLY)
-- =============================================================
Warlock.Profiles = {}

-- 1. Register Static Weights
for k, v in pairs(Warlock.Weights) do 
    Warlock.Profiles[k] = v 
end

if Warlock.LevelingBrackets then
    for k, v in pairs(Warlock.LevelingBrackets) do 
        Warlock.Profiles[k] = v.End 
    end
end

MSC.RegisterModule("WARLOCK", Warlock)