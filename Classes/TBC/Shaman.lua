local addonName, MSC = ...
local Shaman = {}
Shaman.Name = "SHAMAN"

-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Shaman.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_MANA_SHORT"]=0.05, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5,
        ["MSC_WEAPON_DPS"]=1.0
    },

    -- [[ 1. ELEMENTAL ]]
    ["ELE_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]    = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.5, 
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
    },

    -- [[ 2. ELEMENTAL PVP ]]
    ["ELE_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 3. ENHANCEMENT ]]
    ["ENH_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 4.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.1, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.1, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.6, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.1, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.4,
        -- POISON
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02, 
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
    },

    -- [[ 4. RESTORATION ]]
    ["RESTO_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 1.0, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 2.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.9, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.6, 
        -- POISON
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
    },

    -- [[ 5. SHAMAN TANK ]]
    ["SHAMAN_TANK"] = { 
        ["MSC_WEAPON_DPS"]                  = 1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 2.0, 
        ["ITEM_MOD_ARMOR_SHORT"]            = 0.8, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]      = 1.5, 
        ["ITEM_MOD_BLOCK_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_PARRY_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.2, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
    },
}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS (Shaman Part 1: Melee & Caster)
-- =============================================================
Shaman.LevelingBrackets = {
    -- [[ STANDARD MELEE (1-39) ]]
    -- 2H Axes/Maces/Staves. Windfury unlocks at Lvl 30.
    ["Leveling_1_20"] = { 
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 0.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, -- 1 Str = 2 AP
            ["ITEM_MOD_AGILITY_SHORT"] = 0.8, -- 0 AP in TBC. Only Crit/Armor. Low prio early.
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5, -- Mana for shocks
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, -- Added for sync
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.5 -- Added for sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.8
        }
    },
    ["Leveling_21_40"] = { -- Windfury Era (Lvl 30)
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 2.0, -- Windfury demands SLOW weapons
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.1 -- Added for sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5, -- Flurry uptime
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2
        }
    },

    -- [[ ENHANCEMENT DUAL WIELD (40-70) ]]
    -- Meta: Slow MH / Slow OH (for Stormstrike). 
    -- Mental Dexterity: Int provides AP (1 Int = 1 AP).
    -- TBC Mechanics: Agility provides ZERO AP. Only Crit/Armor.
    ["Leveling_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, -- Slow MH
            ["MSC_OH_WEAPON_SPEED"] = 2.5, -- Slow OH
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, -- 1 Str = 2 AP
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.3, -- 1 Int = 1 AP (Mental Dexterity)
            ["ITEM_MOD_AGILITY_SHORT"] = 1.0, -- Purely Crit/Armor stat now
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5, -- DW Penalty
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5 -- Added TBC Stat
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 2.8, 
            ["MSC_OH_WEAPON_SPEED"] = 2.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.4,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 2.8, 
            ["MSC_OH_WEAPON_SPEED"] = 2.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.4,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 3.0, 
            ["MSC_OH_WEAPON_SPEED"] = 3.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.8, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.4, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.4, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5
        }
    },
    ["Leveling_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 3.0, 
            ["MSC_OH_WEAPON_SPEED"] = 3.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.6,
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 0.5, -- TBC Stat
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 0.5 -- TBC Stat
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 16.0, 
            ["MSC_WEAPON_SPEED"] = 3.5, 
            ["MSC_OH_WEAPON_SPEED"] = 3.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.8,
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 3.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 1.5
        }
    },

    -- [[ ELEMENTAL CASTER ]]
    -- Spell Power > Hit > Crit > Int. Spirit is dead.
    ["Leveling_Caster_40_51"] = { 
        min = 40, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, -- Mana pool is vital at 40
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.8, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2,
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        }
    },
    ["Leveling_Caster_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        }
    },
    ["Leveling_Caster_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.0, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 2.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 0.5, -- TBC Stat
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.5, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 2.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 1.0,
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        }
    },

    -- [[ SHAMAN TANK (Warden) ]]
    -- High Stamina + Block + Agility (Dodge). Weapon Speed = Fast (Threat application).
    ["Leveling_Tank_21_40"] = {
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.0, -- Fast Dagger/Mace for Rockbiter/Frostbrand spam
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5, 
            ["ITEM_MOD_SHIELD_BLOCK_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 1.5, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8,
            ["ITEM_MOD_SHIELD_BLOCK_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_Tank_41_51"] = {
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 2.8, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8, 
            ["ITEM_MOD_SHIELD_BLOCK_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 2.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8, 
            ["ITEM_MOD_SHIELD_BLOCK_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1
        }
    },
    ["Leveling_Tank_52_59"] = {
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_SHIELD_BLOCK_RATING_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
            ["ITEM_MOD_SHIELD_BLOCK_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1
        }
    },
    ["Leveling_Tank_60_70"] = {
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 6.0, 
            ["MSC_WEAPON_SPEED"] = -1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8,
            ["ITEM_MOD_SHIELD_BLOCK_RATING_SHORT"] = 1.5, -- Added for Sync
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 6.0, 
            ["MSC_WEAPON_SPEED"] = -1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 4.0, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8,
            ["ITEM_MOD_SHIELD_BLOCK_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1
        }
    },

    -- [[ RESTO HEALER ]]
    -- Healing Power > Mp5 > Int. Spirit is garbage.
    ["Leveling_Healer_40_51"] = { 
        min = 40, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8
        }
    },
    ["Leveling_Healer_52_59"] = {
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8, -- Added for Sync
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_Healer_60_70"] = {
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 2.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0, -- Added for Sync
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 0.5 -- TBC Stat
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 2.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.8,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] = 1.0
        }
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Shaman.Specs = { [1]="Elemental", [2]="Enhancement", [3]="Restoration" }

Shaman.PrettyNames = {
    ["ELE_PVE"]         = "Raid: Elemental",
    ["ELE_PVP"]         = "PvP: Elemental",
    ["ENH_PVE"]         = "Raid: Enhancement",
    ["RESTO_PVE"]       = "Raid: Restoration",
    ["SHAMAN_TANK"]     = "Tank: Warden",
    -- Leveling Brackets
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
	["Leveling_Caster_40_51"] = "Elemental (40-51)",
    ["Leveling_Caster_52_59"] = "Elemental (52-59)",
    ["Leveling_Caster_60_70"] = "Elemental (Outland)",
	["Leveling_Healer_40_51"] = "Resto Dungeon (40-51)",
    ["Leveling_Healer_52_59"] = "Resto Dungeon (52-59)",
    ["Leveling_Healer_60_70"] = "Resto Dungeon (Outland)",
    ["Leveling_Tank_1_20"]    = "Shaman Tank (1-20)",
    ["Leveling_Tank_21_40"]   = "Shaman Tank (21-40)",
    ["Leveling_Tank_41_51"]   = "Shaman Tank (41-51)",
    ["Leveling_Tank_52_59"]   = "Shaman Tank (52-59)",
    ["Leveling_Tank_60_70"]   = "Shaman Tank (Outland)",
}

Shaman.SpeedChecks = {
	["Default"]={ MH_Slow=true },
    ["ENH_PVE"]={ MH_Slow=true, OH_Slow=true }
}

Shaman.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes (2H via Talent)
    [4]=true, [5]=true,   -- 1H/2H Maces (2H via Talent)
    [10]=true,            -- Staves
    [13]=true, [15]=true, -- Fists, Daggers
    [6]=true              -- Shields (Technically Armor, but useful to track context)
}

Shaman.StatToCritMatrix = { 
    Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.0}, {60, 59.5}, {70, 80.0} } 
}

Shaman.Talents = { 
    ["ELEMENTAL_MASTERY"]="Elemental Mastery", 
    ["TOTEM_OF_WRATH"]="Totem of Wrath", 
    ["LIGHTNING_MASTERY"]="Lightning Mastery", 
    ["STORMSTRIKE"]="Stormstrike", 
    ["SHAMANISTIC_RAGE"]="Shamanistic Rage", 
    ["MANA_TIDE"]="Mana Tide Totem", 
    ["EARTH_SHIELD"]="Earth Shield", 
	["ELEMENTAL_PRECISION"] = "Elemental Precision",
    ["NATURE_GUIDANCE"]="Nature's Guidance", 
    ["ANCESTRAL_KNOW"]="Ancestral Knowledge", 
    ["MENTAL_QUICKNESS"]="Mental Quickness", 
    ["SHIELD_SPEC"]="Shield Specialization", 
    ["ANTICIPATION"]="Anticipation",
    ["DUAL_WIELD_SPEC"]="Dual Wield Specialization"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Shaman:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level == 70 then
        if Rank("TOTEM_OF_WRATH") > 0 or Rank("ELEMENTAL_MASTERY") > 0 then return "ELE_PVE" end
        if Rank("SHAMANISTIC_RAGE") > 0 or Rank("STORMSTRIKE") > 0 then return "ENH_PVE" end
        if Rank("EARTH_SHIELD") > 0 or Rank("MANA_TIDE") > 0 then return "RESTO_PVE" end
        if Rank("SHIELD_SPEC") > 0 and Rank("ANTICIPATION") > 0 then return "SHAMAN_TANK" end
        return "RESTO_PVE"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
    if Rank("SHIELD_SPEC") > 0 and Rank("ANTICIPATION") > 0 then role = "Leveling_Tank"
    elseif Rank("ELEMENTAL_MASTERY") > 0 or Rank("TOTEM_OF_WRATH") > 0 then role = "Leveling_Caster"
    elseif Rank("MANA_TIDE") > 0 or Rank("EARTH_SHIELD") > 0 then role = "Leveling_Healer"
    end 

    local specificKey = role .. suffix
    if Shaman.LevelingBrackets and Shaman.LevelingBrackets[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Shaman:GetDynamicWeights(forceKey)
    -- [[ FIX 1: TRANSLATOR ]]
    -- If the dropdown sends a "Pretty Name" (e.g. "Standard Leveling..."), 
    -- we reverse-lookup the "Code Key" (e.g. "Leveling_2H...").
    if forceKey and not Shaman.LevelingBrackets[forceKey] and not Shaman.Weights[forceKey] then
        if Shaman.PrettyNames then
            for key, name in pairs(Shaman.PrettyNames) do
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
    if Shaman.LevelingBrackets and Shaman.LevelingBrackets[specKey] then
        local bracket = Shaman.LevelingBrackets[specKey]
        
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
    if Shaman.Weights and Shaman.Weights[specKey] then 
        return Shaman.Weights[specKey], specKey
    elseif Shaman.LevelingWeights and Shaman.LevelingWeights[specKey] then 
        return Shaman.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Shaman:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- [[ 1. DUAL WIELD DPS FIX ]]
    -- Ensure Enhancement Shamans get credit for their DW Spec talent (+25% OH Dmg)
    if currentSpec:find("ENH") or (Rank("DUAL_WIELD_SPEC") > 0) then
        if not weights["MSC_WEAPON_DPS_OH"] then
            weights["MSC_WEAPON_DPS_OH"] = 0.625 -- 50% Base * 1.25 Talent
        end
    end

    -- [[ 2. EXISTING TALENTS ]]
    local rAnc = Rank("ANCESTRAL_KNOW")
    if rAnc > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAnc * 0.01)) 
    end
    
    -- [[ 3. MENTAL QUICKNESS (AP -> SP Conversion Value) ]]
    -- We buff AP weight here because it provides SP via the talent.
    local rMent = Rank("MENTAL_QUICKNESS")
    if rMent > 0 and weights["ITEM_MOD_ATTACK_POWER_SHORT"] then 
        weights["ITEM_MOD_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_ATTACK_POWER_SHORT"] * 1.1 
    end

    -- [[ 4. COVARIANCE (Synergy) ]]
    if currentSpec:find("ENH") or currentSpec:find("Tank") then
        if weights["ITEM_MOD_CRIT_RATING_SHORT"] then
            local base, pos, neg = UnitAttackPower("player")
            local totalAP = base + pos + neg
            if totalAP > 1000 then 
                 local apScaler = 1 + ((totalAP - 1000) / 20000)
                 if apScaler > 1.15 then apScaler = 1.15 end
                 weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * apScaler
            end
        end

    elseif currentSpec:find("ELE") or currentSpec:find("Caster") then
        if weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] then
            local spellPower = GetSpellBonusDamage(4) -- 4 = Nature
            if spellPower > 600 then
                 local spScaler = 1 + ((spellPower - 600) / 10000)
                 if spScaler > 1.2 then spScaler = 1.2 end
                 weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] * spScaler
            end
        end

    elseif currentSpec:find("RESTO") or currentSpec:find("Healer") then
        if weights["ITEM_MOD_MANA_REGENERATION_SHORT"] then
            local healPower = GetSpellBonusHealing()
            if healPower > 800 then
                local hScaler = 1 + ((healPower - 800) / 10000)
                if hScaler > 1.2 then hScaler = 1.2 end
                weights["ITEM_MOD_MANA_REGENERATION_SHORT"] = weights["ITEM_MOD_MANA_REGENERATION_SHORT"] * hScaler
            end
        end
    end
    
    -- [[ 5. CAPS with HYSTERESIS ]]
    local baseCap = 142 
    local talentBonus = Rank("NATURE_GUIDANCE") * 15.8
    
    -- Draenei Check
    local _, race = UnitRace("player")
    if race == "Draenei" then talentBonus = talentBonus + 15.8 end

    -- A. DUAL WIELD HIT (Enhancement)
    if currentSpec:find("ENH") and Rank("DUAL_WIELD_SPEC") > 0 then
         local hitRating = GetCombatRating(6)
         local specialCap = baseCap - talentBonus
         if specialCap < 0 then specialCap = 0 end
         
         if hitRating >= (specialCap + 20) then
             weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.8 
             table.insert(activeCaps, "Yellow Hit")
         elseif hitRating >= specialCap then
             weights["ITEM_MOD_HIT_RATING_SHORT"] = 1.4
             table.insert(activeCaps, "Y-Hit (Soft)")
         end

    -- B. 2H / TANK HIT (Hard Cap)
    elseif weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
         local hitRating = GetCombatRating(6)
         local cap = baseCap - talentBonus
         if cap < 0 then cap = 0 end
         
         if hitRating >= (cap + 15) then
             weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.02
             table.insert(activeCaps, "Hit")
         elseif hitRating >= cap then
             weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * 0.4
             table.insert(activeCaps, "Hit (Soft)")
         end
    end
    
    -- C. SPELL HIT (Elemental)
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
         local hitRating = GetCombatRating(8)
         local baseCap = 202 
         
         -- Calculate exact reduction from talents
         -- 1% Spell Hit = 12.6 Rating
         local precisionBonus = Rank("ELEMENTAL_PRECISION") * 25.2 -- 2% per rank
         local guidanceBonus = Rank("NATURE_GUIDANCE") * 12.6 -- 1% per rank
         
         local spellCap = baseCap - precisionBonus - guidanceBonus
         
         -- Totem of Wrath Check
         if Rank("TOTEM_OF_WRATH") > 0 then
             spellCap = spellCap - 37.8 -- 3%
         end

         -- Draenei Racial
         if race == "Draenei" then spellCap = spellCap - 12.6 end
         
         if spellCap < 0 then spellCap = 0 end
         
         if hitRating >= (spellCap + 15) then
             weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02
             table.insert(activeCaps, "Spell Hit")
         elseif hitRating >= spellCap then
             weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] * 0.4
             table.insert(activeCaps, "Hit (Soft)")
         end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Shaman:GetWeaponBonus(itemLink) 
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- Racial: Orc (Axe/Fist)
    if race == "Orc" and (subClassID == 0 or subClassID == 1 or subClassID == 13) then bonus = bonus + 40 end
    
    return bonus
end

-- =============================================================
-- CLASS SPECIFIC ITEMS (Totems)
-- =============================================================
Shaman.Relics = {
	-- [[ CLASSIC / LEVELING (1-60) ]]
    [23199] = { ITEM_MOD_NATURE_DAMAGE_SHORT = 33 }, -- Totem of the Storm (Lightning/Chain)
    [22395] = { ITEM_MOD_SPELL_POWER_SHORT = 30 }, -- Totem of the Void (Classic version?) Or Storm?
    [22394] = { ITEM_MOD_HEALING_POWER_SHORT = 80 }, -- Totem of Rebirth
    [22393] = { ITEM_MOD_MANA_REGENERATION_SHORT = 5 }, -- Totem of Life (Lesser Healing Wave cost?)
    [23200] = { ITEM_MOD_HEALING_POWER_SHORT = 10 }, -- Totem of Flowing Water (Stream Totem)

    -- [[ TBC LEVELING / DUNGEON (60-70) ]]
    [25645] = { ITEM_MOD_SPELL_POWER_SHORT = 30 }, -- Totem of the Plains (Shock Dmg)
    [27949] = { ITEM_MOD_SPELL_POWER_SHORT = 48 }, -- Totem of Impact (Shock Dmg)
    [27984] = { ITEM_MOD_SPELL_POWER_SHORT = 46 }, -- Totem of the Void (Lightning Dmg - Dungeon)
    [27523] = { ITEM_MOD_HEALING_POWER_SHORT = 88 }, -- Totem of the Healer (Healing Wave)
    [28248] = { ITEM_MOD_SPELL_POWER_SHORT = 55, note = "BiS" }, -- Totem of the Void (Lightning Dmg - Kara)

    -- [[ TBC RAID ]]
    [27815] = { ITEM_MOD_ATTACK_POWER_SHORT = 80, note = "BiS" }, -- Totem of the Astral Winds (Windfury Bonus)
    [33507] = { ITEM_MOD_ATTACK_POWER_SHORT = 40 }, -- Stonebreaker's Totem (Shock proc)
    [34072] = { ITEM_MOD_ATTACK_POWER_SHORT = 100 }, -- Totem of Splintering (Windfury Bonus)
    [33506] = { ITEM_MOD_HASTE_RATING_SHORT = 101 }, -- Skycall Totem
    [32330] = { ITEM_MOD_SPELL_POWER_SHORT = 85, note = "BiS" }, -- Totem of Ancestral Guidance (Lightning Dmg)
    [34539] = { ITEM_MOD_SPELL_POWER_SHORT = 60 }, -- Totem of the Maelstrom (Lightning Bolt Haste/Dmg?)
    [28227] = { ITEM_MOD_HEALING_POWER_SHORT = 87 }, -- Totem of Healing Rains (Chain Heal)
    [33505] = { ITEM_MOD_MANA_REGENERATION_SHORT = 20 }, -- Totem of Living Water (Chain Heal cost reduction, val as MP5)

    -- [[ PVP TOTEMS ]]
    [28359] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 }, -- S1
    [33078] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 31 }, -- S2
    [33838] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 34 }, -- S3
    [35022] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 39 }, -- S4
    [38367] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 40 }, -- Wrath

    -- Totem of the Thunderhead (Lightning Shield Dmg)
    -- Extremely niche, mostly for farming or boosting, but if you want it:
    [24413] = { ITEM_MOD_NATURE_DAMAGE_SHORT = 33, note = "Farm BiS" }, 

    -- Totem of Spontaneous Regrowth (+88 Healing Wave)
    -- Strong single-target Tank healing totem.
    [27544] = { ITEM_MOD_HEALING_POWER_SHORT = 88, note = "BiS Tank Heal" }, 

    -- Totem of Healing Rains (+87 Chain Heal)
    -- The absolute King of TBC Resto Shaman items.
    [28523] = { ITEM_MOD_HEALING_POWER_SHORT = 87, note = "BiS Raid" },
	
}

-- =============================================================
-- REGISTER PROFILES FOR INIT (UI LIST ONLY)
-- =============================================================
Shaman.Profiles = {}
for k, v in pairs(Shaman.Weights) do Shaman.Profiles[k] = v end
if Shaman.LevelingBrackets then
    for k, v in pairs(Shaman.LevelingBrackets) do Shaman.Profiles[k] = v.End end
end
if Shaman.LevelingWeights then
    for k, v in pairs(Shaman.LevelingWeights) do Shaman.Profiles[k] = v end
end
MSC.RegisterModule("SHAMAN", Shaman)