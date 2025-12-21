local _, MSC = ...

-- =============================================================
-- 1. STAT WEIGHTS (Raiding & Leveling Brackets)
-- =============================================================
MSC.WeightDB = {
	["WARRIOR"] = {
        ["Default"]    = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.75, -- (1 Str = 2 AP)
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 
        },
        
        -- ARMS: PvP & 2-Hander Leveling
        -- Focus: Big Hits (Str), Crit, and staying alive (Stam)
        ["Arms"]       = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5,   -- Crit is huge for Deep Wounds / Impale
            ["ITEM_MOD_AGILITY_SHORT"]=1.0,       -- Agi = Crit in Classic
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,       -- PvP Survival
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0,
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.0     -- Important, but usually capped easily for PvP (5%)
        },

        -- FURY: Dual Wield PvE DPS
        -- Focus: Hit Cap, Weapon Skill, Crit (Flurry uptime)
        ["Fury"]       = { 
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.5,    -- #1 Priority until cap
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.5, -- #1 Priority (Edgemasters, etc.)
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.8,   -- Critical for Flurry
            ["ITEM_MOD_AGILITY_SHORT"]=1.2,       -- Excellent for Crit
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.75, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.5        -- Don't need much HP in Raids
        },

        -- PROTECTION: Tanking
        -- Focus: Effective Health (Stam/Armor) > Mitigation > Threat
        ["Protection"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=2.2,       -- Effective Health is King
            ["ITEM_MOD_ARMOR_SHORT"]=0.15,        -- Armor is massive (weight must be low relative to raw value)
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_PARRY_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8,   -- Shield Slam scaling
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,    -- Threat generation
            ["ITEM_MOD_STRENGTH_SHORT"]=0.8,      -- Block Value / Threat
            ["ITEM_MOD_AGILITY_SHORT"]=0.8,       -- Dodge / Armor
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 
        },
        
        -- LEVELING: High Regen (Hp5/Spirit) + Kill Speed
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=3.0, -- Hp5 is God-Mode early game
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.75, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5,              -- High Spirit = Low downtime
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_AGILITY_SHORT"]=0.8 
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.2,              -- Still very good
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.9, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.1, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },
    },
    ["PALADIN"] = {
        ["Default"]     = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.6, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,
            ["ITEM_MOD_MANA_SHORT"]=0.04 -- 20 Mana ~= 1 Int
        },
        
        -- HOLY: Crit Healer (Illumination)
        ["Holy"]        = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.8, -- Crit = Mana Return (Illumination)
            ["ITEM_MOD_INTELLECT_SHORT"]=1.6,     -- Crit % + Mana Pool
            ["ITEM_MOD_MANA_SHORT"]=0.08,         -- 20 Mana ~= 1 Int
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.8, -- Mp5
            ["ITEM_MOD_STAMINA_SHORT"]=0.8 
        },

        -- PROTECTION: AoE Threat (Spell Power) + Survival
        ["Protection"]  = { 
            ["ITEM_MOD_STAMINA_SHORT"]=2.2, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5,
            ["ITEM_MOD_ARMOR_SHORT"]=0.15,       
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_PARRY_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5,  -- Consecration Threat needs SP
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,    -- Need mana to tank
            ["ITEM_MOD_MANA_SHORT"]=0.04,        -- 20 Mana ~= 1 Int
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.5      -- Block Value
        },

        -- RETRIBUTION: Hybrid DPS (Str/AP/Crit + some SP/Int)
        ["Retribution"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5,  -- Vengeance uptime
            ["ITEM_MOD_AGILITY_SHORT"]=0.9,      -- Crit only
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,   
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.6,  -- Judgement/Exorcism scaling
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,    -- Mana for rotations
            ["ITEM_MOD_MANA_SHORT"]=0.025,       -- 20 Mana ~= 1 Int
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },
        
        -- LEVELING: Sustain > Burst
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=2.0, -- Less downtime
            ["ITEM_MOD_STRENGTH_SHORT"]=1.4, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.7, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_SHORT"]=0.05,        -- 20 Mana ~= 1 Int
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0            -- Regen
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_MANA_SHORT"]=0.04,        -- 20 Mana ~= 1 Int
            ["ITEM_MOD_AGILITY_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.9, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6,
            ["ITEM_MOD_MANA_SHORT"]=0.03         -- 20 Mana ~= 1 Int
        },
    },
    ["PRIEST"] = {
        ["Default"]    = { 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_SHORT"]=0.05         -- 20 Mana ~= 1 Int
        },
        
        -- DISCIPLINE: Int (Mana Pool) + Spirit (Meditation)
        ["Discipline"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.6,     -- Mental Strength (+10% Mana)
            ["ITEM_MOD_MANA_SHORT"]=0.08,         -- 20 Mana ~= 1 Int
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5,        -- Meditation (Regen)
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },

        -- HOLY: Spirit is a Power Stat (Spiritual Guidance: 25% Spirit -> SP)
        ["Holy"]       = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.1,        -- HUGE VALUE: Regen + Healing Power
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.8, -- Mp5
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_MANA_SHORT"]=0.06,         -- 20 Mana ~= 1 Int
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, -- Inspiration procs
            ["ITEM_MOD_STAMINA_SHORT"]=0.8 
        },

        -- SHADOW: Hit Cap > Shadow Dmg > Crit (Shadow Power)
        ["Shadow"]     = { 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=2.5,  -- Must cap Hit for raids
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, -- Shadow Power = 100% crit dmg bonus
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_SHORT"]=0.05,             -- 20 Mana ~= 1 Int
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,           
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5             
        },
        
        -- LEVELING: Spirit Tap + Wand DPS
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, -- WAND DPS IS GOD
            ["ITEM_MOD_SPIRIT_SHORT"]=2.0,            -- Spirit Tap = Infinite Mana
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_SHORT"]=0.05,             -- 20 Mana ~= 1 Int
            ["ITEM_MOD_STAMINA_SHORT"]=0.8
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.2,            -- Spirit Tap is still king
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=1.5, -- Wanding still happens
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2,
            ["ITEM_MOD_MANA_SHORT"]=0.06              -- 20 Mana ~= 1 Int
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_SHORT"]=0.05              -- 20 Mana ~= 1 Int
        },
    },
    ["ROGUE"] = {
        ["Default"]       = { 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, -- Added
            ["ITEM_MOD_STRENGTH_SHORT"]=0.7,     -- 1 Str = 1 AP
            ["ITEM_MOD_STAMINA_SHORT"]=0.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.0,   
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 
        },
        
        -- ASSASSINATION: Crit (Seal Fate) + Burst
        ["Assassination"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=1.7,      -- Main Stat
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5,  -- Seal Fate requires Crit
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,   -- Need 9% for yellow hits
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 
        },
        
        -- COMBAT: The Raid Spec (Hit/Skill > All)
        ["Combat"]        = { 
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.5,   -- White hit cap is huge for energy gen
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.5, -- Glancing blow reduction
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.7, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.1   
        },
        
        -- SUBTLETY: PvP Utility & Survival
        ["Subtlety"]      = { 
            ["ITEM_MOD_AGILITY_SHORT"]=1.8,      -- Dmg + Dodge
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,      -- PvP Survival is key
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.9, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=0.5    -- PvP relies on yellow hits (5% cap)
        },
        
        -- LEVELING: Kill Speed (Agi/Str/AP)
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_AGILITY_SHORT"]=1.6, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,   -- Misses start hurting here
            ["ITEM_MOD_STRENGTH_SHORT"]=0.9, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.9, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5,   
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2 
        },
    },
	["HUNTER"] = {
        ["Default"]      = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2,       -- 1 Agi = 2 RAP + Crit
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, -- Added
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,     -- Mana pool
            ["ITEM_MOD_MANA_SHORT"]=0.025,        -- 20 Mana ~= 1 Int
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 
        },
        
        -- BEAST MASTERY: Leveling / Solo Farming
        -- Focus: Pet holding aggro (AP) + Regen (Spirit)
        ["BeastMastery"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0,
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,       -- Pet/Hunter survival
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0,        -- Low downtime
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_MANA_SHORT"]=0.025         -- 20 Mana ~= 1 Int
        },
        
        -- MARKSMANSHIP: Raid DPS
        -- Focus: Hit Cap (9%) > Agility > Crit
        ["Marksmanship"] = { 
            ["ITEM_MOD_HIT_RATING_SHORT"]=3.0,    -- Absolute priority until capped
            ["ITEM_MOD_AGILITY_SHORT"]=2.5,       -- Agi is king
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.8,   -- Mortal Shots talent
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,      -- Mana pots cover this
            ["ITEM_MOD_MANA_SHORT"]=0.01           -- 20 Mana ~= 1 Int
        },
        
        -- SURVIVAL: PvP / Agility Stacking
        -- Focus: Stamina + Agility (Lightning Reflexes)
        ["Survival"]     = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2,       -- Lightning Reflexes scales this
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,       -- PvP Survival
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,     -- PvP utility mana
            ["ITEM_MOD_MANA_SHORT"]=0.04,         -- 20 Mana ~= 1 Int
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.0,    -- 5% PvP cap
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=0.8 
        },
        
        -- LEVELING: Kill Speed + Regen
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.2,        -- Regen is vital early
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_MANA_SHORT"]=0.025         -- 20 Mana ~= 1 Int
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6,
            ["ITEM_MOD_MANA_SHORT"]=0.03,         -- 20 Mana ~= 1 Int
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 
        },
    },
    ["MAGE"] = {
        ["Default"] = { 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_SHORT"]=0.05, -- 20 Mana ~= 1 Int
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5 
        },
        
        -- ARCANE: Mana Pool + Dmg
        ["Arcane"]  = { 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.8,     -- Arcane scales with Mana Pool
            ["ITEM_MOD_MANA_SHORT"]=0.09,         -- 20 Mana ~= 1 Int
            ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=2.5, -- Hit is massive
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0         -- Evocation
        },

        -- FIRE: Crit (Ignite) + Hit
        ["Fire"]    = { 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.8, -- Ignite rolling
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5,
            ["ITEM_MOD_STAMINA_SHORT"]=0.8 
        },

        -- FROST: Hit > SP > Crit
        ["Frost"]   = { 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=3.0, -- Need cap (16% w/o talents, but talents give 6%)
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2,-- Shatter gives 50%, so gear crit is lower priority
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_SHORT"]=0.05             -- 20 Mana ~= 1 Int
        },
        
        -- LEVELING: AoE Grinding (Stam/Int) vs Wanding
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.5, -- Wand DPS
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_MANA_SHORT"]=0.075,            -- 20 Mana ~= 1 Int
            ["ITEM_MOD_SPIRIT_SHORT"]=1.2,            -- Regen
            ["ITEM_MOD_STAMINA_SHORT"]=1.2            -- Survival
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5,         -- Mana for Blizzard
            ["ITEM_MOD_MANA_SHORT"]=0.075,            -- 20 Mana ~= 1 Int
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,           -- Surviving the pull
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_SHORT"]=0.05,             -- 20 Mana ~= 1 Int
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },
    },
    ["WARLOCK"] = {
        ["Default"]     = { 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,
            ["ITEM_MOD_MANA_SHORT"]=0.04 -- 20 Mana ~= 1 Int
        },
        
        -- AFFLICTION: Drain Tanking / DoTs
        ["Affliction"]  = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0,   -- DoTs scale 100% with SP
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,       -- Life Tap fuel
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.8,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,
            ["ITEM_MOD_MANA_SHORT"]=0.04          -- 20 Mana ~= 1 Int
        },

        -- DEMONOLOGY: Pet Scaling (Stam/Int)
        ["Demonology"]  = { 
            ["ITEM_MOD_STAMINA_SHORT"]=2.0,       -- Demonic Embrace (+15% Stam)
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_SHORT"]=0.05          -- 20 Mana ~= 1 Int
        },
        
        -- DESTRUCTION: Crit (Ruin) + Hit
        ["Destruction"] = { 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=3.0, -- No hit talents! Need gear.
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=2.0, -- Ruin (+100% Crit Dmg)
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8,    -- Shadow Bolt is still main nuke
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8,  
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_SHORT"]=0.05,             -- 20 Mana ~= 1 Int
            ["ITEM_MOD_STAMINA_SHORT"]=0.8
        },
        
        -- TANK (Twin Emperors)
        ["Tank"]        = { 
            ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"]=5.0, -- The only thing that matters
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0 
        },
        
        -- LEVELING: Drain Tanking (Stam/Spirit/SP)
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.5, -- Wand DPS
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_SHORT"]=0.05,             -- 20 Mana ~= 1 Int
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0 
        },
       ["Leveling_21_40"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=2.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5,   -- The Game MUST see this 1.5
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8,
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=1.0, -- Wanding
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,     -- Mana
            ["ITEM_MOD_MANA_SHORT"]=0.05,             -- 20 Mana ~= 1 Int
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0 
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.8,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,
            ["ITEM_MOD_MANA_SHORT"]=0.04              -- 20 Mana ~= 1 Int
        },
    },
    ["SHAMAN"] = {
        ["Default"]     = { 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_SHORT"]=0.05, -- 20 Mana ~= 1 Int
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0 
        },
        
        -- ELEMENTAL: Nature Dmg / Crit
        ["Elemental"]   = { 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.6, -- Elemental Fury (+100% Crit Dmg)
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=2.0,  -- Hard to find, but needed
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_SHORT"]=0.05              -- 20 Mana ~= 1 Int
        },

        -- ENHANCEMENT: Windfury (Crit/AP)
        ["Enhancement"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6,      -- 1 Str = 2 AP
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8,  -- Added
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5,   -- Flurry uptime
            ["ITEM_MOD_AGILITY_SHORT"]=1.2,       -- Crit + Dodge
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.0,    
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.5 
        },

        -- RESTORATION: Chain Heal Spam
        ["Restoration"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=2.5, -- Raw output
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, -- Mp5
            ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_MANA_SHORT"]=0.06,             -- 20 Mana ~= 1 Int
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, -- Ancestral Healing
            ["ITEM_MOD_STAMINA_SHORT"]=0.8 
        },
        
        -- TANK: (Meme/Niche)
        ["Tank"]        = { 
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_SHIELD_BLOCK_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_SHORT"]=0.05,             -- 20 Mana ~= 1 Int
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0 
        },
        
        -- LEVELING: 2H Staff/Mace hitting
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_SHORT"]=0.05              -- 20 Mana ~= 1 Int
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_SHORT"]=0.05,             -- 20 Mana ~= 1 Int
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0 
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.2 
        },
    },
    ["DRUID"] = {
        ["Default"]     = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_SHORT"]=0.05 -- 20 Mana ~= 1 Int
        },
        
        -- BALANCE: Oomkin needs mana & Crit
        ["Balance"]     = { 
            ["ITEM_MOD_SPELL_HIT_RATING_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.8, -- Vengeance (+100% Crit Dmg)
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=2.0,     -- Starfire
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=2.0,     -- Wrath
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2,         -- Mana issues are real
            ["ITEM_MOD_MANA_SHORT"]=0.06,             -- 20 Mana ~= 1 Int
            ["ITEM_MOD_STAMINA_SHORT"]=0.8 
        },

        -- FERAL DPS: Cat Form
        ["FeralCombat"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8,      -- 1 Str = 2 AP
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.9, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.4,       -- 1 Agi = 1 AP + Crit
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5,   -- Combo point generation
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.0,    -- 9% Cap
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=0.0 -- USELESS IN FORM
        },

        -- RESTORATION: Innervate & Efficiency
        ["Restoration"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8,        -- Innervate scales off Spirit
            ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_MANA_SHORT"]=0.06,             -- 20 Mana ~= 1 Int
            ["ITEM_MOD_STAMINA_SHORT"]=0.8 
        },

        -- TANK: Bear Form (Armor/Stam/Dodge)
        ["Tank"]        = { 
            ["ITEM_MOD_ARMOR_SHORT"]=3.0,         -- Bear form multiplies Armor
            ["ITEM_MOD_STAMINA_SHORT"]=2.5,       -- Bear form multiplies Stamina
            ["ITEM_MOD_AGILITY_SHORT"]=1.5,       -- Dodge
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,    -- Threat
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=0.0 -- USELESS IN FORM
        },
        
        -- LEVELING: Cat Form speed
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0 
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.4, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.9, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2 
        },
    },
}

-- =============================================================
-- 2. SPEC NAMES
-- =============================================================
MSC.SpecNames = {
    ["WARLOCK"] = { [1]="Affliction", [2]="Demonology", [3]="Destruction" },
    ["PALADIN"] = { [1]="Holy", [2]="Protection", [3]="Retribution" },
    ["MAGE"]    = { [1]="Arcane", [2]="Fire", [3]="Frost" },
    ["PRIEST"]  = { [1]="Discipline", [2]="Holy", [3]="Shadow" },
    ["DRUID"]   = { [1]="Balance", [2]="FeralCombat", [3]="Restoration" },
    ["SHAMAN"]  = { [1]="Elemental", [2]="Enhancement", [3]="Restoration" },
    ["ROGUE"]   = { [1]="Assassination", [2]="Combat", [3]="Subtlety" },
    ["WARRIOR"] = { [1]="Arms", [2]="Fury", [3]="Protection" },
    ["HUNTER"]  = { [1]="BeastMastery", [2]="Marksmanship", [3]="Survival" },
}

-- =============================================================
-- 3. RACIAL BONUSES (Using IDs)
-- =============================================================
MSC.RacialTraits = {
    ["Human"] = { 
        [7] = 5, -- One-Handed Swords
        [8] = 5, -- Two-Handed Swords
        [4] = 5, -- One-Handed Maces
        [5] = 5  -- Two-Handed Maces
    },
    ["Orc"] = { 
        [0] = 5, -- One-Handed Axes
        [1] = 5  -- Two-Handed Axes
    },
    ["Dwarf"] = { 
        [3] = 5  -- Guns
    },
    ["Troll"] = { 
        [2] = 5,  -- Bows
        [16] = 5  -- Thrown
    }, 
}

-- =============================================================
-- 4. WEAPON SPEED PREFERENCES
-- =============================================================
MSC.SpeedChecks = {
    ["WARRIOR"] = { ["Fury"]={ MH_Slow=true, OH_Fast=true }, ["Protection"]={ MH_Fast=true }, ["Default"]={ MH_Slow=true } },
    ["ROGUE"]   = { ["Combat"]={ MH_Slow=true, OH_Fast=true }, ["Default"]={ MH_Slow=true, OH_Fast=true } },
    ["PALADIN"] = { ["Protection"]={ MH_Fast=true }, ["Default"]={ MH_Slow=true } },
    ["HUNTER"]  = { ["Default"]={ Ranged_Slow=true } },
    ["SHAMAN"]  = { ["Enhancement"]={ MH_Slow=true }, ["Default"]={ MH_Slow=true } }
}

-- =============================================================
-- 5. CLASS WEAPON PROFICIENCIES
-- =============================================================
MSC.ValidWeapons = {
    ["WARRIOR"] = { [0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true, [10]=true, [13]=true, [15]=true, [18]=true, [19]=false },
    ["PALADIN"] = { [0]=true, [1]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true },
    ["HUNTER"]  = { [0]=true, [1]=true, [2]=true, [3]=true, [6]=true, [7]=true, [8]=true, [10]=true, [13]=true, [15]=true, [18]=true },
    ["ROGUE"]   = { [0]=false, [1]=false, [2]=true, [3]=true, [4]=true, [5]=false, [7]=true, [8]=false, [13]=true, [15]=true, [18]=true },
    ["PRIEST"]  = { [4]=true, [10]=true, [15]=true, [19]=true },
    ["SHAMAN"]  = { [0]=true, [1]=true, [4]=true, [5]=true, [10]=true, [13]=true, [15]=true, [19]=false },
    ["MAGE"]    = { [7]=true, [10]=true, [15]=true, [19]=true },
    ["WARLOCK"] = { [7]=true, [10]=true, [15]=true, [19]=true },
    ["DRUID"]   = { [4]=true, [5]=true, [10]=true, [13]=true, [15]=true } 
}

-- =============================================================
-- 6. SHORT NAMES (Display text for Tooltips)
-- =============================================================
MSC.ShortNames = {
    -- [[ FIX FOR BLIZZARD ARMOR RETURN ]]
    ["RESISTANCE0_NAME"]              = "Armor", 
    ["ITEM_MOD_ARMOR_SHORT"]          = "Armor",

    -- [[ ATTRIBUTES ]]
    ["ITEM_MOD_AGILITY_SHORT"]        = "Agility",
    ["ITEM_MOD_STRENGTH_SHORT"]       = "Strength",
    ["ITEM_MOD_INTELLECT_SHORT"]      = "Intellect",
    ["ITEM_MOD_SPIRIT_SHORT"]         = "Spirit",
    ["ITEM_MOD_STAMINA_SHORT"]        = "Stamina",
    ["ITEM_MOD_HEALTH_SHORT"]         = "Health",
    ["ITEM_MOD_MANA_SHORT"]           = "Mana",

    -- [[ SPELL & HEALING ]]
    ["ITEM_MOD_SPELL_POWER_SHORT"]    = "Spell Power",
    ["ITEM_MOD_HEALING_POWER_SHORT"]  = "Healing",
    ["ITEM_MOD_SPELL_HEALING_DONE"]   = "Healing", -- Legacy
    ["ITEM_MOD_MANA_REGENERATION_SHORT"] = "Mp5",
    ["ITEM_MOD_POWER_REGEN0_SHORT"]   = "Mp5", -- Legacy
    
    -- [[ PHYSICAL ]]
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = "DPS",
    ["ITEM_MOD_ATTACK_POWER_SHORT"]      = "Attack Power",
    ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = "Ranged AP", -- [[ NEW: RANGED AP ]]
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = "Feral AP",
    ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = "Ranged AP",
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = "Feral AP",
    ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = "Hp5",

    -- [[ HIT / CRIT / SKILL ]]
    ["ITEM_MOD_CRIT_RATING_SHORT"]       = "Crit",
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = "Spell Crit",
    ["ITEM_MOD_HIT_RATING_SHORT"]        = "Hit",
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]  = "Spell Hit",
    ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = "Wpn Skill",
    
    -- [[ CRIT CONVERSIONS FROM STATS ]]
    ["ITEM_MOD_CRIT_FROM_STATS_SHORT"]       = "Crit (from Agi)",
    ["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] = "Spell Crit (from Int)",

    -- [[ DEFENSIVE ]]
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = "Defense",
    ["ITEM_MOD_DODGE_RATING_SHORT"]      = "Dodge",
    ["ITEM_MOD_PARRY_RATING_SHORT"]      = "Parry",
    ["ITEM_MOD_BLOCK_RATING_SHORT"]      = "Block %",
    ["ITEM_MOD_BLOCK_VALUE_SHORT"]       = "Block Value",

    -- [[ SPECIFIC DAMAGE ]]
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]     = "Shadow Dmg",
    ["ITEM_MOD_FIRE_DAMAGE_SHORT"]       = "Fire Dmg",
    ["ITEM_MOD_FROST_DAMAGE_SHORT"]      = "Frost Dmg",
    ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]     = "Arcane Dmg",
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"]     = "Nature Dmg",
    ["ITEM_MOD_HOLY_DAMAGE_SHORT"]       = "Holy Dmg",

    -- [[ RESISTANCES ]]
    ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"] = "Shadow Res",
    ["ITEM_MOD_FIRE_RESISTANCE_SHORT"]   = "Fire Res",
    ["ITEM_MOD_FROST_RESISTANCE_SHORT"]  = "Frost Res",
    ["ITEM_MOD_NATURE_RESISTANCE_SHORT"] = "Nature Res",
    ["ITEM_MOD_ARCANE_RESISTANCE_SHORT"] = "Arcane Res",
    ["ITEM_MOD_ALL_RESISTANCE_SHORT"]    = "All Res",
}

-- =============================================================
-- 7. SLOT MAPPING
-- =============================================================
MSC.SlotMap = { 
    ["INVTYPE_HEAD"]=1, ["INVTYPE_NECK"]=2, ["INVTYPE_SHOULDER"]=3, ["INVTYPE_BODY"]=4, 
    ["INVTYPE_CHEST"]=5, ["INVTYPE_ROBE"]=5, ["INVTYPE_WAIST"]=6, ["INVTYPE_LEGS"]=7, 
    ["INVTYPE_FEET"]=8, ["INVTYPE_WRIST"]=9, ["INVTYPE_HAND"]=10, ["INVTYPE_FINGER"]=11, 
    ["INVTYPE_TRINKET"]=13, ["INVTYPE_CLOAK"]=15, ["INVTYPE_WEAPON"]=16, ["INVTYPE_SHIELD"]=17, 
    ["INVTYPE_2HWEAPON"]=16, ["INVTYPE_WEAPONMAINHAND"]=16, ["INVTYPE_WEAPONOFFHAND"]=17, 
    ["INVTYPE_HOLDABLE"]=17, ["INVTYPE_RANGED"]=18, ["INVTYPE_THROWN"]=18, 
    ["INVTYPE_RANGEDRIGHT"]=18, ["INVTYPE_RELIC"]=18 
}

-- =============================================================
-- 8. CRIT CONVERSION MATRIX (Level Brackets)
-- =============================================================
MSC.StatToCritMatrix = {
    ["WARRIOR"] = { 
        Agi = { {1, 4.0}, {20, 8.5}, {40, 13.5}, {60, 20.0} } 
    },
    ["ROGUE"] = { 
        Agi = { {1, 3.5}, {20, 9.0}, {40, 18.0}, {60, 29.0} } 
    },
    ["HUNTER"] = { 
        Agi = { {1, 4.5}, {20, 12.0}, {40, 26.0}, {60, 53.0} } 
    },
    ["PALADIN"] = { 
        Agi = { {1, 4.0}, {60, 20.0} }, 
        Int = { {1, 6.0}, {30, 15.0}, {60, 29.5} } 
    },
    ["SHAMAN"] = { 
        Agi = { {1, 4.0}, {60, 20.0} }, 
        Int = { {1, 6.0}, {20, 15.0}, {40, 35.0}, {60, 59.5} } 
    },
    ["DRUID"] = { 
        Agi = { {1, 4.0}, {60, 20.0} }, 
        Int = { {1, 6.5}, {20, 16.0}, {40, 38.0}, {60, 60.0} } 
    },
    ["MAGE"] = { 
        Agi = { {60, 20.0} }, 
        Int = { {1, 6.0}, {20, 15.0}, {40, 35.0}, {60, 59.5} } 
    },
    ["PRIEST"] = { 
        Agi = { {60, 20.0} }, 
        Int = { {1, 6.0}, {20, 15.0}, {40, 37.0}, {60, 59.2} } 
    },
    ["WARLOCK"] = { 
        Agi = { {60, 20.0} }, 
        Int = { {1, 6.5}, {20, 16.0}, {40, 38.0}, {60, 60.6} } 
    },
}