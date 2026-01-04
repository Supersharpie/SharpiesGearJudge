local _, MSC = ...

-- =============================================================
-- 1. ENDGAME STAT WEIGHTS (Normalized & Immunized)
-- =============================================================
MSC.WeightDB = {
["WARRIOR"] = {
        ["Default"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.5,
            ["MSC_WEAPON_DPS"]=2.0 -- Essential for leveling
        },
       
        -- [[ 1. FURY DW (Dual Wield) ]]
        ["FURY_DW"] = { 
            ["MSC_WEAPON_DPS"]=4.0,                    -- << CRITICAL: Weapon DPS is king
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.9, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.2, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.35, -- Fixed Key Name
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5,
            
            -- POISON PROTECTION
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,         -- Don't hate Hunter Mail
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,            -- Don't hate Leather
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.01,
        },
       
        -- [[ 2. FURY 2H (Slam Spec) ]]
        ["FURY_2H"] = { 
            ["MSC_WEAPON_DPS"]=5.5,                    -- << CRITICAL: Massive weight for 2H
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.9, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.35, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5,
            
            -- POISON PROTECTION
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,
        },
       
        -- [[ 3. ARMS PVE ]]
        ["ARMS_PVE"] = { 
            ["MSC_WEAPON_DPS"]=5.0,                    -- Arms relies on slow, high damage weapons
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.9, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.3, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.4, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.0, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.1, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.4,
            
            -- POISON PROTECTION
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,
        },
       
        -- [[ 4. ARMS PVP ]]
        ["ARMS_PVP"] = { 
            ["MSC_WEAPON_DPS"]=4.5,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.8,  -- High priority
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=0.5,         -- Cap is low (5%)
            ["ITEM_MOD_AGILITY_SHORT"]=1.0,
            
            -- POISON PROTECTION
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,
        },
       
        -- [[ 5. DEEP_PROT (Tank) ]]
        ["DEEP_PROT"] = { 
            ["MSC_WEAPON_DPS"]=1.5,                    -- Important for Threat (Devastate/Heroic Strike)
            ["ITEM_MOD_STAMINA_SHORT"]=1.6, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.7,        -- Shield Slam scales heavily on this
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_PARRY_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"]=0.9,       -- Added Block Rating
            ["ITEM_MOD_HIT_RATING_SHORT"]=0.6, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=0.8,  -- Crit immunity alternative
            ["ITEM_MOD_STRENGTH_SHORT"]=0.6,           -- Bumped up: 1 Str = 0.5 Block Value
            ["ITEM_MOD_AGILITY_SHORT"]=0.5,            -- Bumped up: Armor/Dodge/Crit
            
            -- POISON PROTECTION
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,         -- Paladin Plate often has Int
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01,       -- Mage/Paladin Weapons have SP
        },
    },
["PALADIN"] = {
        ["Default"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.3, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
            ["MSC_WEAPON_DPS"]=2.0 
        },

        -- [[ 1. HOLY (Healer) ]]
        ["HOLY_RAID"] = { 
            ["MSC_WEAPON_DPS"]=0.0,              -- Caster Weapon (SP is king)
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2,    -- King Stat (Mana + Crit)
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.9, -- Mana Refund mechanics
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.6, -- Int is better than MP5 in TBC
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.9, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.5, 
            
            -- POISON PROTECTION (Allow wearing Cloth/Leather/Mail)
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
        },

        -- [[ 2. PROTECTION (Tank) ]]
        ["PROT_DEEP"] = {
            ["MSC_WEAPON_DPS"]=0.2,             -- Low priority. Spell Power weapon > High DPS weapon.
            
            -- SURVIVAL
            ["ITEM_MOD_STAMINA_SHORT"] = 1.6,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.4,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.3,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.3,
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.1,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 0.65,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.12,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 0.8, -- Crit Immunity

            -- THREAT
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.85,      -- The "Strength" of Prot Pally
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.8,  -- Taunt Hit
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5,        -- Melee Hit
            
            -- HYBRID / POISON PROTECTION
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2,         -- Mana pool is good, but SP is better
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.35,         -- Block Value
            ["ITEM_MOD_AGILITY_SHORT"] = 0.3,           -- Dodge
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.1,
        },

        -- [[ 3. RETRIBUTION (DPS) ]]
        ["RET_STANDARD"] = { 
            ["MSC_WEAPON_DPS"]=4.5,                     -- << CRITICAL: Weapon Damage is everything
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.9, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.3, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.9, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.1, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.4, -- Added ArP
            
            -- POISON PROTECTION (Tier Gear often has Int/SP)
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,          -- Don't penalize Tier gear
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01,        -- Don't penalize Tier gear
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.01,
        },

        -- [[ 4. SHOCKADIN (PvP/Niche) ]]
        ["SHOCKADIN_PVP"] = { 
            ["MSC_WEAPON_DPS"]=0.0, -- Caster Weapon
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.6, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
        },
        
        -- [[ 5. PROT AOE FARMING (Strat Farming) ]]
        ["PROT_AOE"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5,         -- Block Value kills low-level mobs
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0,         -- Consecration damage
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.2 
        },
    },
["PRIEST"] = {
        ["Default"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5,
            ["MSC_WEAPON_DPS"]=0.0 -- Casters ignore weapon damage
			["MSC_WAND_DPS"]=2.5
        },

        -- [[ 1. HOLY (Deep Healing) ]]
        ["HOLY_DEEP"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.9, -- Counts as healing
            ["ITEM_MOD_SPIRIT_SHORT"]=1.1,      -- Spiritual Guidance (Spirit -> Healing)
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.6, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.4, 

            -- POISON PROTECTION
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=0.01, -- Hit doesn't help healers, but isn't poison
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
        },

        -- [[ 2. DISC (Support/Efficiency) ]]
        ["DISC_SUPPORT"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5,   -- Max Mana = Efficiency/Rapture
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.9,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, -- Spirit is less valuable than Int for Disc
            ["ITEM_MOD_SPIRIT_SHORT"]=0.6, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.5,
            
            -- POISON PROTECTION
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=0.01,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
        },

        -- [[ 3. SHADOW PVE (Mana Battery) ]]
        ["SHADOW_PVE"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, -- Hit Cap is massive priority
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.4, -- DoTs don't crit in TBC. Low value.
            ["ITEM_MOD_INTELLECT_SHORT"]=0.3,     -- Mana pool
            ["ITEM_MOD_SPIRIT_SHORT"]=0.3,        -- Spirit Tap regen
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            
            -- POISON PROTECTION
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.1, -- Shadow gear often has "Healing" (Generic SP)
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
        },

        -- [[ 4. SMITE DPS (Niche) ]]
        ["SMITE_DPS"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.7, -- Smite CAN crit
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.7, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
        },

        -- [[ 5. SHADOW PVP ]]
        ["SHADOW_PVP"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,       -- Survival is key
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6,     -- Need mana to burn
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=0.5, -- Lower cap for PvP (3-4%)
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
        },
    },
["ROGUE"] = {
        ["Default"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.1, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5,
            ["MSC_WEAPON_DPS"]=3.0 -- Always prioritize better weapons while leveling
        },

        -- [[ 1. COMBAT (Sword/Mace Specialization) ]]
        ["RAID_COMBAT"] = { 
            ["MSC_WEAPON_DPS"]=5.5,             -- << CRITICAL: White damage is ~50% of total DPS
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.9,  -- Hit Cap is huge
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.1, -- Dodge Parries = DPS loss
            ["ITEM_MOD_AGILITY_SHORT"]=2.2,     -- 1 Agi = 1 AP + Crit + Dodge
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.4, -- Blade Flurry scales well with Haste
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.35, -- Fixed Key Name
            ["ITEM_MOD_STRENGTH_SHORT"]=1.1,    -- 1 Str = 1 AP
            
            -- POISON PROTECTION
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,  -- Don't wear Hunter Jewelry
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.01,
        },

        -- [[ 2. MUTILATE (Daggers) ]]
        ["RAID_MUTILATE"] = { 
            ["MSC_WEAPON_DPS"]=4.5,             -- Dagger DPS is vital for Mutilate dmg
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, -- Seal Fate relies on Crits
            ["ITEM_MOD_AGILITY_SHORT"]=2.1, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.7, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
            
            -- POISON PROTECTION
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01,
        },

        -- [[ 3. SUBTLETY (PvP / Hemorrhage) ]]
        ["PVP_SUBTLETY"] = { 
            ["MSC_WEAPON_DPS"]=3.0,             -- Burst damage matters
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,     -- Survival
            ["ITEM_MOD_AGILITY_SHORT"]=2.4,     -- Sinister Calling (+15% Agi)
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=0.5,  -- 5% PvP Cap
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.3, -- Fixed Key Name
            
            -- POISON PROTECTION
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01,
        },
    },
["HUNTER"] = {
        ["Default"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.9, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4,
            ["MSC_WEAPON_DPS"]=1.5 -- Balanced: Good for Bows, but lets Agility win on Polearms
        },

        -- [[ 1. BEAST MASTERY (The "One Button" Macro) ]]
        ["RAID_BM"] = { 
            ["MSC_WEAPON_DPS"]=2.0,             -- Pet scales off your damage, so Bow DPS is vital
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.9,  -- Hit Cap #1
            ["ITEM_MOD_AGILITY_SHORT"]=1.9,     -- Good, but raw AP is also great for pet
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.3, -- Go for the Throat (Pet Resource)
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.2, -- Auto Shot speed = More DPS
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.3, -- Fixed Key Name
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4, 
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,   -- 100% Useless for Hunters
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01,
        },

        -- [[ 2. SURVIVAL (Expose Weakness Buffer) ]]
        ["RAID_SURV"] = { 
            ["MSC_WEAPON_DPS"]=1.5,             -- Stats > Weapon DPS for Survival
            ["ITEM_MOD_AGILITY_SHORT"]=3.0,     -- << KING STAT. 1 Agi = Raid Wide DPS.
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.9, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.1, -- Expose Weakness relies on Crits to proc
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.6, -- Raw AP is weak compared to Agi
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=0.6,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6,   -- Thrill of the Hunt (Mana efficiency)
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.2,
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01,
        },

        -- [[ 3. MARKSMANSHIP (Physical DPS) ]]
        ["RAID_MM"] = { 
            ["MSC_WEAPON_DPS"]=2.2,             -- Weapon Dmg scales hard with Multi-Shot/Aimed Shot
            ["ITEM_MOD_AGILITY_SHORT"]=2.2,     -- Strong scaling
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.5, -- ArP is great for MM
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.9, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01,
        },

        -- [[ 4. PVP (Drain Team) ]]
        ["PVP_MM"] = { 
            ["MSC_WEAPON_DPS"]=1.5,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,     -- Don't die
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,   -- Viper Sting spam requires mana
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=0.5,  -- 3% Cap
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01,
        },
    },
["MAGE"] = {
        ["Default"] = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["MSC_WEAPON_DPS"]=0.0 -- Casters ignore weapon damage
        },

        -- [[ 1. ARCANE (Mana Battery / Burst) ]]
        ["ARCANE_RAID"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2,    -- King Stat (Mana = Dmg for Arcane)
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.3, -- Hit Cap is #1
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.7, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.9, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.6,       -- Arcane Meditation (Regen)
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01, -- Hybrid gear often has "Healing"
        },

        -- [[ 2. FIRE (Crit / Ignite) ]]
        ["FIRE_RAID"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.95, -- Ignite needs Crit
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.9, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,         -- Molten Armor handles regen, not Spirit
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01,
        },

        -- [[ 3. FROST PVE (Safe DPS) ]]
        ["FROST_PVE"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.6, -- Shatter provides crit, so rating is less vital
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01,
        },

        -- [[ 4. FROST PVP (Survival / Shatter) ]]
        ["FROST_PVP"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,       -- Don't die
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,     -- Mana is life
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.6, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=0.5, -- Lower cap for PvP
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
        },

        -- [[ 5. FROST AOE (Leveling / Farming) ]]
        ["FROST_AOE"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,       -- Don't get dazed/killed
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5,     -- Need huge mana pool for max Blizzard uptime
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.1, -- Blizzard cannot crit
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=0.1,  -- AoE talents provide hit often
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
        },
    },
["WARLOCK"] = {
        ["Default"] = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.3, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
            ["MSC_WEAPON_DPS"]=0.0 
        },

        -- [[ 1. DESTRUCTION SHADOW (The "Shadow Bolt" Turret) ]]
        -- Relies on Shadow Bolt, ISB proc, and Shadow Weaving (if Affli present)
        ["DESTRUCT_SHADOW"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2,   -- Frozen Shadoweave is King
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.9, -- Ruin Talent
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
            
            -- POISON PROTECTION
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=0.01,    -- Don't get baited by Spellfire set
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01,
        },

        -- [[ 2. DESTRUCTION FIRE (The "Incinerate" Turret) ]]
        -- Relies on Immolate, Incinerate, Conflagrate
        ["DESTRUCT_FIRE"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.2,     -- Spellfire Set is King
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.9, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
            
            -- POISON PROTECTION
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=0.01,  -- Don't get baited by Frozen Shadoweave
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01,
        },

        -- [[ 3. RAID AFFLICTION (UA / DoTs) ]]
        ["RAID_AFFLICTION"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.6, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.3,
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01,
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=0.01,
        },

        -- [[ 4. DEMO PVE (Felguard) ]]
        ["DEMO_PVE"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.9,         -- Demonic Knowledge (Stam -> SP)
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.9, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01,
        },

        -- [[ 5. PVP SL/SL ]]
        ["PVP_SL_SL"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_STAMINA_SHORT"]=1.8,         -- King Stat
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=0.3, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0,
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01,
        },
    },
["SHAMAN"] = {
        ["Default"] = { 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_SHORT"]=0.05, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.5,
            ["MSC_WEAPON_DPS"]=1.0
        },

        -- [[ 1. ELEMENTAL (Lightning Bolt Turret) ]]
        ["ELE_PVE"] = { 
            ["MSC_WEAPON_DPS"]=0.0,             -- Caster Weapon
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.3, -- Hit Cap #1
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8, -- Lightning Mastery (Talent) loves Crit
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.9, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5, -- Unrelenting Storm converts Int to MP5, but raw MP5 is ok
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,     -- Shamans don't use Spirit
        },

        -- [[ 2. ELEMENTAL PVP ]]
        ["ELE_PVP"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,     -- Survival is key
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,   -- Mana pool for endurance
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=0.5,
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
        },

        -- [[ 3. ENHANCEMENT (Dual Wield / Windfury) ]]
        ["ENH_PVE"] = { 
            ["MSC_WEAPON_DPS"]=4.5,             -- << CRITICAL: Windfury scales off Weapon Dmg
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.9,  -- Dual Wield Hit Cap is massive
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.1, -- Dodge reduction
            ["ITEM_MOD_STRENGTH_SHORT"]=2.1,    -- 1 Str = 2 AP (with Kings/Unleashed Rage, highly valuable)
            ["ITEM_MOD_AGILITY_SHORT"]=1.6,     -- 1 Agi = 1 AP + Crit (slightly less AP than Str)
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.1,   -- << FIX: Mental Dexterity (1 Int = 1 AP + Mana + SpellCrit)
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.4,
            
            -- POISON PROTECTION (Don't use Caster Weapons)
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01, -- Nature's Blessing gives SP from Int/AP. Raw SP is inefficient.
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,
        },

        -- [[ 4. RESTORATION (Chain Heal) ]]
        ["RESTO_PVE"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, -- High value, but not infinite
            ["ITEM_MOD_INTELLECT_SHORT"]=0.9,     -- Ancestral Knowledge (Mana %)
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.6, -- Ancestral Awakening synergy
            
            -- POISON PROTECTION
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=0.01,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,     -- Still useless for Shamans (no Spirit regen while casting)
        },

        -- [[ 5. SHAMAN TANK (The Meme Dream) ]]
        ["SHAMAN_TANK"] = { 
            ["MSC_WEAPON_DPS"]=1.0,             -- Threat generation
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_ARMOR_SHORT"]=0.8, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"]=1.2, -- Added Block Rating
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_PARRY_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.2, -- Needed for Crit Immunity
            ["ITEM_MOD_AGILITY_SHORT"]=1.0,      -- Dodge/Armor
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,     -- Block Value
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,    -- Mana for Shocks
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0,  -- Threat (Earth Shock / Lightning Shield)
        },
    },
["DRUID"] = {
        ["Default"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["MSC_WEAPON_DPS"]=0.0, -- Druids never rely on weapon DPS
            ["MSC_WEAPON_SPEED"]=0.0,
        },

        -- [[ 1. BALANCE (Boomkin / Starfire) ]]
        ["BALANCE_PVE"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, -- Hit Cap #1
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,    -- Mana pool
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.8, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.3,       -- Intensity (Regen)
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.4,
            
            -- POISON PROTECTION
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,    -- Don't penalize Feral items
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.01,
            ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]=0.01,
        },

        -- [[ 2. FERAL CAT (DPS) ]]
        ["FERAL_CAT"] = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["MSC_WEAPON_SPEED"]=0.0,            -- No penalty for slow/fast
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.9, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2,     -- 1 Str = 2 AP
            ["ITEM_MOD_AGILITY_SHORT"]=2.0,      -- 1 Agi = 1 AP + Crit
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.4, -- Fixed Key Name
            
            -- POISON PROTECTION (Tier Gear often has Int)
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,   
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.01,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01, -- Hybrid off-pieces
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01,
        },

        -- [[ 3. FERAL BEAR (Tank) ]]
        ["FERAL_BEAR"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WEAPON_SPEED"]=0.0,
            ["ITEM_MOD_STAMINA_SHORT"]=1.7,      -- Effective Health
            ["ITEM_MOD_ARMOR_SHORT"]=0.35,       -- 400% Multiplier makes this HUGE
            ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=1.2, -- Bonus Armor (Green text)
            ["ITEM_MOD_AGILITY_SHORT"]=1.5,      -- Dodge/Armor/Crit
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.0, -- Crit Immunity
            ["ITEM_MOD_HIT_RATING_SHORT"]=0.6, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.8, 
            ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]=0.5,
            
            -- POISON PROTECTION (The "Gladiator" Fix)
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,   
            ["ITEM_MOD_SPIRIT_SHORT"]=0.01,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.01,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01, -- Don't punish PvP gear
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01,
            ["ITEM_MOD_PARRY_RATING_SHORT"]=0.01, -- Bears can't parry, but don't hate the stat
            ["ITEM_MOD_BLOCK_RATING_SHORT"]=0.01,
        },

        -- [[ 4. RESTO TREE (PvE) ]]
        ["RESTO_TREE"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.1,       -- Intensity (Regen)
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.7, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=0.6, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.3,
            
            -- POISON PROTECTION
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,     -- Don't punish Feral gear
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=0.01,
        },

        -- [[ 5. RESTO PVP (SL/SL of Druids) ]]
        ["RESTO_PVP"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.8, -- King Stat
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,      -- Bear Form survival
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.9,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.6,
            
            -- POISON PROTECTION
            ["ITEM_MOD_AGILITY_SHORT"]=0.01,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
        },
    },
}
-- =========================================================================
-- 2. LEVELING MODULE (Normalized & Immunized)
-- =========================================================================
MSC.LevelingWeightDB = {
["WARRIOR"] = {
        -- [[ 1. UNIVERSAL STARTER (1-20) ]]
        -- Weapon DPS is everything here. Spirit is great for reducing downtime (eating).
        ["Leveling_1_20"]  = { 
            ["MSC_WEAPON_DPS"]=10.0,             -- << KING STAT
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.0,       -- High regen value
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=3.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=0.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=0.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01    -- Poison Protection
        },

        -- [[ 2. ARMS / 2H LEVELING (Mortal Strike) ]]
        ["Leveling_21_40"] = { 
            ["MSC_WEAPON_DPS"]=8.0, 
            ["MSC_WEAPON_SPEED"]=2.0,            -- Slow weapons hit harder with abilities
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_41_51"] = { 
            ["MSC_WEAPON_DPS"]=6.0,
            ["MSC_WEAPON_SPEED"]=1.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.4, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_52_59"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["MSC_WEAPON_SPEED"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_60_70"] = { 
            ["MSC_WEAPON_DPS"]=5.0,              -- Outland weapons are huge
            ["MSC_WEAPON_SPEED"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.8,   -- Misses kill leveling speed
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.3,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },

        -- [[ 3. FURY / DW LEVELING ]]
        ["Leveling_DW_21_40"] = { 
            ["MSC_WEAPON_DPS"]=6.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5,       -- Downtime reduction
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_DW_41_51"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_DW_52_59"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_DW_60_70"] = { 
            ["MSC_WEAPON_DPS"]=4.5,
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.2,   -- Hit is vital for DW in Outland
            ["ITEM_MOD_STRENGTH_SHORT"]=2.4, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },

        -- [[ 4. TANK LEVELING (Dungeon Grinding) ]]
        ["Leveling_Tank_21_40"] = { 
            ["MSC_WEAPON_DPS"]=4.0,              -- Threat requires dmg
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.2, 
            ["ITEM_MOD_ARMOR_SHORT"]=0.1, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_Tank_41_51"] = { 
            ["MSC_WEAPON_DPS"]=3.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_Tank_52_59"] = { 
            ["MSC_WEAPON_DPS"]=2.0,
            ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,     -- Bumped from 0.2 (Threat matters!)
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_Tank_60_70"] = { 
            ["MSC_WEAPON_DPS"]=2.0,
            ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_PARRY_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5, -- Crit Immunity help
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,     -- Bumped from 0.2
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01
        },
    },
["ROGUE"] = {
        -- [[ 1. STANDARD COMBAT (Swords/Maces/Fists) ]]
        -- The "Sinister Strike" spammer. 
        -- Weapon DPS is King. Agility is Queen.
        ["Leveling_1_20"]  = { 
            ["MSC_WEAPON_DPS"]=8.0,              -- << ABSOLUTE PRIORITY
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.1,     -- 1 Str = 1 AP
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8,       -- Reduces eating downtime (OOC regen)
            ["ITEM_MOD_CRIT_RATING_SHORT"]=0.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=0.5,
            
            -- Poison Protection
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01
        },
        ["Leveling_21_40"] = { 
            ["MSC_WEAPON_DPS"]=6.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.3, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.1, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_41_51"] = { 
            ["MSC_WEAPON_DPS"]=6.0,
            ["ITEM_MOD_AGILITY_SHORT"]=2.4, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5,   -- Precision talent helps, but hit is still good
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_52_59"] = { 
            ["MSC_WEAPON_DPS"]=5.5,
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.5, -- Glancing blow reduction
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_60_70"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.0,   -- TBC Hit Cap is vital
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.8,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },

        -- [[ 2. DAGGERS (Backstab/Ambush) ]]
        -- Requires slow, high-damage Main Hand dagger.
        ["Leveling_Dagger_1_20"] = { 
            ["MSC_WEAPON_DPS"]=8.0,              -- Ambush 1-shots mobs if weapon is good
            ["ITEM_MOD_AGILITY_SHORT"]=2.4, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_Dagger_21_40"] = { 
            ["MSC_WEAPON_DPS"]=7.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5,  -- Crits needed for combo points (Seal Fate later)
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_Dagger_41_51"] = { 
            ["MSC_WEAPON_DPS"]=6.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_Dagger_52_59"] = { 
            ["MSC_WEAPON_DPS"]=5.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_Dagger_60_70"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },

        -- [[ 3. HEMO (PvP / Solo Grinding) ]]
        -- Values Stamina highly for survival.
        ["Leveling_Hemo_1_20"]    = { 
            ["MSC_WEAPON_DPS"]=6.0,
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,      -- Survival > Glass Cannon
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_Hemo_21_40"] = { 
            ["MSC_WEAPON_DPS"]=5.5,
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, -- Hemo scales well with AP
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_Hemo_41_51"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["ITEM_MOD_STAMINA_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_Hemo_52_59"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
        ["Leveling_Hemo_60_70"] = { 
            ["MSC_WEAPON_DPS"]=4.5,
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.01
        },
    },
["MAGE"] = {
        -- [[ 1. STANDARD FROST (Single Target) ]]
        -- Focus: Mana efficiency via Wanding finishers.
        ["Leveling_1_20"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=1.5,            -- Vital for mana efficiency early
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_21_40"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=1.2,            -- Used as mana-free finisher
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_41_51"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.6,            -- Spells are much stronger now
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.2,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.1,            -- Stat stick only
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },

        -- [[ 2. FIRE LEVELING (High Damage) ]]
        ["Leveling_Fire_21_40"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=1.0,
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Fire_41_51"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.5,
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Fire_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.2,
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Fire_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.1,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },

        -- [[ 3. AOE BLIZZARD LEVELING ]]
        -- Wands are useless here; you need Stamina to survive the pull and Int for Blizzard.
        ["Leveling_AoE_21_40"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.1,            -- You don't wand in AoE
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_AoE_41_51"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.1,
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_AoE_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.1,
            ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=2.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_AoE_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.1,
            ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
    },
["DRUID"] = {
        -- [[ 1. FERAL CAT (The Leveling Standard) ]]
        -- Weapon DPS is 0.0. Use "Stat Sticks" (Str/Agi).
        ["Leveling_1_20"] = { 
            ["MSC_WEAPON_DPS"]=0.0,              -- Useless for Feral
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0,     -- 1 Str = 2 AP
            ["ITEM_MOD_AGILITY_SHORT"]=1.2,      -- Crit/Armor
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0,       -- High regen value early on
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,    -- Mana for shifting
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01, -- Poison
            ["ITEM_MOD_HEALING_POWER_SHORT"]=0.01
        },
        ["Leveling_21_40"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.4, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01
        },
        ["Leveling_41_51"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.4, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01
        },
        ["Leveling_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.8, 
            ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.0, -- Green Armor text
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01
        },
        ["Leveling_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]=1.0, -- << The real "Weapon DPS" for 60+
            ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01
        },

        -- [[ 2. FERAL BEAR (Dungeon Grinding) ]]
        ["Leveling_Bear_21_40"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.4,        -- Bear multiplier makes Armor huge
            ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=0.8, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01
        },
        ["Leveling_Bear_41_51"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.4,
            ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02 
        },
        ["Leveling_Bear_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.4,
            ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=3.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02 
        },
        ["Leveling_Bear_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]=0.5, -- Threat
            ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=3.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01
        },

        -- [[ 3. BALANCE (Boomkin Leveling) ]]
        ["Leveling_Caster_41_51"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Caster_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, -- Fixed Typo
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01
        },
        ["Leveling_Caster_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01
        },

        -- [[ 4. RESTO (Dungeon Healer) ]]
        ["Leveling_Healer_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.2,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01
        },
        ["Leveling_Healer_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01
        },
    },
["PALADIN"] = {
		-- [[ 1. RETRIBUTION (The Dynamics of Bonk) ]]
		
		-- 1-20: Survival & Mana. You have no buttons, just Auto Attack + Seal.
		["Leveling_RET_1_20"] = { 
			["MSC_WEAPON_DPS"]=8.0, 
			["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
			["ITEM_MOD_AGILITY_SHORT"]=1.2,      -- Crit is rare and valuable
			["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
			["ITEM_MOD_STAMINA_SHORT"]=1.0, 
			["ITEM_MOD_INTELLECT_SHORT"]=0.8,    -- High weight: OOM = Zero DPS
			["ITEM_MOD_SPIRIT_SHORT"]=1.0,       -- Downtime reduction
			["ITEM_MOD_SPELL_POWER_SHORT"]=0.01 
		},

		-- 21-40: "Vengeance" Era. Agility/Crit is vital to keep the buff active.
		["Leveling_RET_21_40"]  = { 
			["MSC_WEAPON_DPS"]=7.0, 
			["MSC_WEAPON_SPEED"]=1.8,            -- Slow Weapons are mandatory for SoC
			["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
			["ITEM_MOD_CRIT_RATING_SHORT"]=1.8,  -- << BUMPED: Vengeance uptime is #1 priority
			["ITEM_MOD_AGILITY_SHORT"]=1.5,      -- Agility is great here for Crit/Dodge
			["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
			["ITEM_MOD_STAMINA_SHORT"]=1.0, 
			["ITEM_MOD_INTELLECT_SHORT"]=0.5,    -- Wis or Illumination helps mana issues
			["ITEM_MOD_SPIRIT_SHORT"]=0.8,
			["ITEM_MOD_SPELL_POWER_SHORT"]=0.01 
		},

		-- 41-51: "Divine Strength" Era. Raw AP scaling takes over.
		["Leveling_RET_41_51"]  = { 
			["MSC_WEAPON_DPS"]=6.5, 
			["MSC_WEAPON_SPEED"]=1.8, 
			["ITEM_MOD_STRENGTH_SHORT"]=2.5,     -- << BUMPED: Divine Strength talent scales this hard
			["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
			["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
			["ITEM_MOD_AGILITY_SHORT"]=1.2,      -- Agility value drops slightly vs Strength
			["ITEM_MOD_STAMINA_SHORT"]=1.2,      -- Mobs hit harder
			["ITEM_MOD_INTELLECT_SHORT"]=0.3,    
			["ITEM_MOD_SPIRIT_SHORT"]=0.5,
			["ITEM_MOD_SPELL_POWER_SHORT"]=0.01 
		},

		-- 52-59: Pre-Outland. Hit Rating appears.
		["Leveling_RET_52_59"]  = { 
			["MSC_WEAPON_DPS"]=6.0, 
			["MSC_WEAPON_SPEED"]=1.5, 
			["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
			["ITEM_MOD_HIT_RATING_SHORT"]=1.5,   -- << NEW: Misses are DPS losses
			["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
			["ITEM_MOD_AGILITY_SHORT"]=1.1, 
			["ITEM_MOD_STAMINA_SHORT"]=1.2, 
			["ITEM_MOD_INTELLECT_SHORT"]=0.2,    
			["ITEM_MOD_SPELL_POWER_SHORT"]=0.1   -- Small value for Consecration/Judgement
		},

		-- 60-70: Crusader Strike & TBC Itemization.
		["Leveling_RET_60_70"]  = { 
			["MSC_WEAPON_DPS"]=5.0, 
			["MSC_WEAPON_SPEED"]=1.2,
			["ITEM_MOD_STRENGTH_SHORT"]=2.6, 
			["ITEM_MOD_HIT_RATING_SHORT"]=2.0,   -- Hit Cap is mandatory
			["ITEM_MOD_CRIT_RATING_SHORT"]=1.7, 
			["ITEM_MOD_AGILITY_SHORT"]=1.0, 
			["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
			["ITEM_MOD_STAMINA_SHORT"]=1.5,      -- TBC mobs hurt
			["ITEM_MOD_INTELLECT_SHORT"]=0.2, 
			["ITEM_MOD_SPELL_POWER_SHORT"]=0.1,
			["ITEM_MOD_HEALING_POWER_SHORT"]=0.01
		},

		-- [[ 2. PROTECTION / AOE GRINDING ]]

		-- 21-40: The "Face Tank". You cannot effectively AoE grind yet.
		-- Focus: Just surviving the dungeon.
		["Leveling_PROT_AOE_21_40"] = { 
			["MSC_WEAPON_DPS"]=2.0,              -- Need some threat
			["ITEM_MOD_STAMINA_SHORT"]=2.0,      -- Surviving is the only goal
			["ITEM_MOD_ARMOR_SHORT"]=0.5,
			["ITEM_MOD_STRENGTH_SHORT"]=1.0,     -- Block Value
			["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
			["ITEM_MOD_SPELL_POWER_SHORT"]=0.5,  -- Low value until Consecration rank up
			["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0
		},

		-- 41-51: The "Holy Shield" Era. AoE Grinding comes online.
		-- Focus: BLOCK VALUE. It creates damage when you block.
		["Leveling_PROT_AOE_41_51"] = { 
			["MSC_WEAPON_DPS"]=1.0, 
			["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.5,  -- << KING STAT. Reflects damage.
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.5,  -- Consecration threat
			["ITEM_MOD_STAMINA_SHORT"]=1.8, 
			["ITEM_MOD_INTELLECT_SHORT"]=1.0,    -- Mana to sustain the pull
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.2,
			["ITEM_MOD_BLOCK_RATING_SHORT"]=1.5, -- Must block to deal damage
			["ITEM_MOD_STRENGTH_SHORT"]=0.8 
		},

		-- 52-59: Pre-Outland.
		["Leveling_PROT_AOE_52_59"] = { 
			["MSC_WEAPON_DPS"]=1.0, 
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
			["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.2, 
			["ITEM_MOD_STAMINA_SHORT"]=2.0, 
			["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5,
			["ITEM_MOD_BLOCK_RATING_SHORT"]=1.5,
			["ITEM_MOD_STRENGTH_SHORT"]=0.5 
		},

		-- 60-70: TBC Dungeons / Shattered Halls
		-- Focus: Spell Power to hold aggro against Warlocks/Mages.
		["Leveling_PROT_AOE_60_70"] = { 
			["MSC_WEAPON_DPS"]=1.0, 
			["ITEM_MOD_SPELL_POWER_SHORT"]=2.0,  -- << BUMPED: Threat is harder in TBC
			["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, 
			["ITEM_MOD_STAMINA_SHORT"]=2.5, 
			["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.8, -- Crit immunity goal
			["ITEM_MOD_DODGE_RATING_SHORT"]=1.5,
			["ITEM_MOD_PARRY_RATING_SHORT"]=1.5,
			["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5 -- Discount Defense
		},
		
		-- [[ 3. HOLY (Corrected Suffixes) ]]
		-- 1-40: Mana Efficiency (Int/Spirit)
		["Leveling_HOLY_DUNGEON_21_40"] = { 
			["MSC_WEAPON_DPS"]=0.0, 
			["ITEM_MOD_INTELLECT_SHORT"]=2.0,    -- Max Mana is everything
			["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
			["ITEM_MOD_STAMINA_SHORT"]=0.8,
			["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.5,
			["ITEM_MOD_STRENGTH_SHORT"]=0.01 
		},
		
		-- 41-59: Throughput (Healing Power)
		["Leveling_HOLY_DUNGEON_41_51"] = { 
			["MSC_WEAPON_DPS"]=0.0, 
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, 
			["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
			["ITEM_MOD_SPIRIT_SHORT"]=1.2, 
			["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, 
			["ITEM_MOD_STRENGTH_SHORT"]=0.01 },
		
		["Leveling_HOLY_DUNGEON_52_59"] = { 
			["MSC_WEAPON_DPS"]=0.0, 
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, 
			["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
			["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
			["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, 
			["ITEM_MOD_STRENGTH_SHORT"]=0.01 },

		-- 60-70: TBC Scaling
		["Leveling_HOLY_DUNGEON_60_70"] = { 
			["MSC_WEAPON_DPS"]=0.0, 
			["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, 
			["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
			["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, 
			["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, -- Illumination
			["ITEM_MOD_STAMINA_SHORT"]=1.0,
			["ITEM_MOD_STRENGTH_SHORT"]=0.01 
		},
	},
["HUNTER"] = {
        -- [[ 1. STANDARD RANGED (Beast Mastery/Marksman) ]]
        -- Focus: Bow DPS > Agility > AP > Int/Stam
        ["Leveling_1_20"] = { 
            ["MSC_WEAPON_DPS"]=2.0,              -- Auto Shot is ~40% of dmg
            ["ITEM_MOD_AGILITY_SHORT"]=2.5,      -- 1 Agi = 1 AP + Crit + Armor
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0,       -- Regen is huge early game
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,    -- Mana for Arcane Shot
            
            -- Poison Protection (Don't wear Shaman Gear)
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,    
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01
        },
        ["Leveling_21_40"] = { 
            ["MSC_WEAPON_DPS"]=1.8,
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4,  -- Go For The Throat (Pet Energy)
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.3,    -- Viper Aspect helps, but Int still needed
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.01
        },
        ["Leveling_41_51"] = { 
            ["MSC_WEAPON_DPS"]=1.8,
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5,   -- Misses start to hurt
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.3,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01
        },
        ["Leveling_52_59"] = { 
            ["MSC_WEAPON_DPS"]=1.5,              -- Stats start to outweigh raw dps on "sticks"
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4,    -- Aspect of the Viper scaling
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01
        },
        ["Leveling_60_70"] = { 
            ["MSC_WEAPON_DPS"]=1.5,
            ["ITEM_MOD_AGILITY_SHORT"]=2.6, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.0,   -- Hit Cap (9%) is vital
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.4,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01
        },

        -- [[ 2. MELEE HUNTER (Survival/Niche) ]]
        -- Requires Raptor Strike / Mongoose Bite usage.
        -- Needs Melee Weapon DPS and Strength (which gives 1 AP).
        ["Leveling_Melee_21_40"] = { 
            ["MSC_WEAPON_DPS"]=5.0,              -- << Melee Weapon is primary source of dmg
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5,     -- Valid for Melee Hunters
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,      -- Face tanking mobs
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_PARRY_RATING_SHORT"]=1.2, -- Survival talents benefit from Parry
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=0.5
        },
        ["Leveling_Melee_41_51"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2 
        },
        ["Leveling_Melee_52_59"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2 
        },
        ["Leveling_Melee_60_70"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2 
        },
    },
["WARLOCK"] = {
        -- [[ 1. AFFLICTION / DRAIN TANK (The Meta) ]]
        -- Spirit > Wand DPS > Spell Power > Stamina
        ["Leveling_1_20"] = { 
            ["MSC_WEAPON_DPS"]=0.0,              -- Casters don't melee
            ["MSC_WAND_DPS"]=2.0,                -- << HIGH PRIO: Primary mana saver
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,      -- Life Tap fuel
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8,       -- Fel Armor makes this better later
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_21_40"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=1.5,                -- Transitioning to Drain Life
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_41_51"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.8,                -- Spells/Drains are dominant
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.8, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.4,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.1,                -- Stat stick only
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },

        -- [[ 2. DESTRUCTION / FIRE LEVELING ]]
        ["Leveling_Fire_21_40"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=1.2,                -- Finisher to save mana
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Fire_41_51"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.8,
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Fire_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.4,
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Fire_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.1,
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },

        -- [[ 3. DEMONOLOGY (Felguard / Stat Stick) ]]
        ["Leveling_Demo_21_40"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=1.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.5,      -- << KING STAT
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Demo_41_51"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.6,
            ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Demo_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.2,
            ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Demo_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.1,
            ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
    },
["PRIEST"] = {
        -- [[ 1. SHADOW / SPIRIT TAP (The Leveling Standard) ]]
        -- Spirit > Wand DPS > Spell Power > Int > Stam
        ["Leveling_1_20"] = { 
            ["MSC_WEAPON_DPS"]=0.0,              -- Don't melee.
            ["MSC_WAND_DPS"]=2.5,                -- << KING STAT: Wands are your rotation
            ["ITEM_MOD_SPIRIT_SHORT"]=2.5,       -- Spirit Tap efficiency
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0,  -- Helps everything
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_21_40"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=2.0,                -- Still vital for mana-free kills
            ["ITEM_MOD_SPIRIT_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, -- Mind Blast/Flay scaling
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_41_51"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=1.5,                -- Tap it down as Shadowform dmg ramps up
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.5,                -- Mostly a stat stick in Outland
            ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },

        -- [[ 2. SMITE PRIEST (Holy DPS) ]]
        -- Relies on Holy Fire / Smite Crits (Surge of Light).
        ["Leveling_Smite_21_40"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=1.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Smite_41_51"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=1.2,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.2,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Smite_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.8,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Smite_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["MSC_WAND_DPS"]=0.4,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        -- [[ 3. HOLY / DISC (Dungeon Healer) ]]
        ["Leveling_Healer_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Healer_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
    },
["SHAMAN"] = {
        -- [[ 1. ENHANCEMENT (Windfury Leveling) ]]
        -- Weapon DPS > Strength > Agility > Int (Mental Dexterity)
        ["Leveling_1_20"] = { 
            ["MSC_WEAPON_DPS"]=8.0,              -- White damage is king
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,    -- Mana for shocks/totems
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0,       -- Regen is vital early
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.1
        },
        ["Leveling_21_40"] = { 
            ["MSC_WEAPON_DPS"]=6.0,
            ["MSC_WEAPON_SPEED"]=2.0,            -- Slow weapons for Windfury
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4,  -- Flurry uptime
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,    -- Mental Dexterity starts helping
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.1
        },
        ["Leveling_41_51"] = { 
            ["MSC_WEAPON_DPS"]=5.5,
            ["MSC_WEAPON_SPEED"]=2.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.1,    -- Int = AP
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.1
        },
        ["Leveling_52_59"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["MSC_WEAPON_SPEED"]=2.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.1, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5,   -- Dual Wield miss rate is high
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.1
        },
        ["Leveling_60_70"] = { 
            ["MSC_WEAPON_DPS"]=5.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.0,   -- Hit Cap is huge for DW
            ["ITEM_MOD_INTELLECT_SHORT"]=1.1, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.8,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.1
        },

        -- [[ 2. ELEMENTAL (Caster) ]]
        ["Leveling_Caster_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, -- Fixed Typo
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Caster_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.4, -- Fixed Typo
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },

        -- [[ 3. RESTORATION (Healer) ]]
        ["Leveling_Healer_52_59"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },
        ["Leveling_Healer_60_70"] = { 
            ["MSC_WEAPON_DPS"]=0.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.01,
            ["ITEM_MOD_AGILITY_SHORT"]=0.01
        },

        -- [[ 4. SHAMAN TANK (The Dream) ]]
        -- Needs Block Value (Shield Spec) + Stam + Threat stats (Str/Int/SP)
        ["Leveling_Tank_1_20"] = { 
            ["MSC_WEAPON_DPS"]=5.0,              -- Threat
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5,     -- Block Value
            ["ITEM_MOD_AGILITY_SHORT"]=1.0,      -- Dodge/Armor
            ["ITEM_MOD_ARMOR_SHORT"]=0.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0
        },
        ["Leveling_Tank_21_40"] = { 
            ["MSC_WEAPON_DPS"]=4.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_ARMOR_SHORT"]=0.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5,  -- Crucial for Shaman Tanks
            ["ITEM_MOD_STRENGTH_SHORT"]=1.2, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,    -- Shocks for threat
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8
        },
        ["Leveling_Tank_41_51"] = { 
            ["MSC_WEAPON_DPS"]=4.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
            ["ITEM_MOD_ARMOR_SHORT"]=0.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8
        },
        ["Leveling_Tank_52_59"] = { 
            ["MSC_WEAPON_DPS"]=3.0,
            ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0
        },
        ["Leveling_Tank_60_70"] = { 
            ["MSC_WEAPON_DPS"]=3.0,
            ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=3.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5
        },
    },
}
-- =============================================================
-- 3. UTILITY TABLES (Spec Names, Racials, UI)
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

MSC.RacialTraits = {
    ["Human"] = { [7]=5, [8]=5, [4]=5, [5]=5 },
    ["Orc"] = { [0]=5, [1]=5 },
    ["Dwarf"] = { [3]=5 },
    ["Troll"] = { [2]=5, [16]=5 },
    ["Draenei"] = {}, 
    ["BloodElf"] = {}, 
}

MSC.SpeedChecks = {
    ["WARRIOR"] = { ["Default"]={ MH_Slow=true }, ["FURY_DW"]={ MH_Slow=true, OH_Fast=true }, ["DEEP_PROT"]={ MH_Fast=true } },
    ["ROGUE"] = { ["Default"]={ MH_Slow=true, OH_Fast=true } },
    ["PALADIN"] = { ["Default"]={ MH_Slow=true }, ["PROT_DEEP"]={ MH_Fast=true } },
    ["HUNTER"] = { ["Default"]={ Ranged_Slow=true } },
    ["SHAMAN"] = { ["Default"]={ MH_Slow=true } }
}

MSC.ValidWeapons = {
    ["WARRIOR"] = {
        [0]=true, [1]=true,   -- Axes
        [4]=true, [5]=true,   -- Maces
        [7]=true, [8]=true,   -- Swords
        [6]=true, [10]=true,  -- Polearm, Staff
        [13]=true, [15]=true, -- Fist, Dagger
        [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Xbow, Thrown
    },
    ["ROGUE"] = {
        [4]=true,             -- 1H Maces (No 2H)
        [7]=true,             -- 1H Swords (No 2H)
        [13]=true, [15]=true, -- Fist, Dagger
        [2]=true, [3]=true, [18]=true, [16]=true, -- Bow, Gun, Xbow, Thrown
        -- REMOVED: [0] Axes (WotLK), [5] 2H Maces (Never)
    },
    ["HUNTER"] = {
        [0]=true, [1]=true,   -- Axes
        [7]=true, [8]=true,   -- Swords
        [6]=true, [10]=true,  -- Polearm, Staff
        [13]=true, [15]=true, -- Fist, Dagger
        [2]=true, [3]=true, [18]=true, [16]=true, -- Bow, Gun, Xbow, Thrown
        -- REMOVED: [4],[5] Maces (Hunters cannot use Maces)
    },
    ["PRIEST"]   = { [4]=true, [10]=true, [15]=true, [19]=true }, -- 1H Mace, Staff, Dagger, Wand
    ["MAGE"]     = { [7]=true, [10]=true, [15]=true, [19]=true }, -- 1H Sword, Staff, Dagger, Wand
    ["WARLOCK"]  = { [7]=true, [10]=true, [15]=true, [19]=true }, -- 1H Sword, Staff, Dagger, Wand
    ["DRUID"]    = { 
        [4]=true, [5]=true,   -- Maces (1H/2H)
        [10]=true, [15]=true  -- Staff, Dagger
        -- REMOVED: [13] Fists (Cataclysm), [6] Polearms (WotLK)
    },
    ["SHAMAN"]   = { 
        [0]=true, [1]=true,   -- Axes (1H/2H)
        [4]=true, [5]=true,   -- Maces (1H/2H)
        [10]=true, [13]=true, [15]=true -- Staff, Fist, Dagger
    },
    ["PALADIN"]  = { 
        [0]=true, [1]=true,   -- Axes
        [4]=true, [5]=true,   -- Maces
        [7]=true, [8]=true,   -- Swords
        [6]=true              -- Polearms
    },
}

MSC.ShortNames = {
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = "Resilience",
    ["ITEM_MOD_HASTE_RATING_SHORT"]      = "Haste",
    ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= "Spell Haste",
    ["ITEM_MOD_EXPERTISE_RATING_SHORT"]  = "Expertise",
    ["ITEM_MOD_ARMOR_PENETRATION_SHORT"] = "Armor Pen",
    ["ITEM_MOD_SPELL_PENETRATION_SHORT"] = "Spell Pen",
    ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]= "Feral AP",
    ["MSC_PVP_UTILITY"]                  = "PvP Utility",
    ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = "Expertise", 
    ["RESISTANCE0_NAME"]              = "Armor", 
    ["ITEM_MOD_ARMOR_SHORT"]          = "Armor",
    ["ITEM_MOD_AGILITY_SHORT"]        = "Agility",
    ["ITEM_MOD_STRENGTH_SHORT"]       = "Strength",
    ["ITEM_MOD_INTELLECT_SHORT"]      = "Intellect",
    ["ITEM_MOD_SPIRIT_SHORT"]         = "Spirit",
    ["ITEM_MOD_STAMINA_SHORT"]        = "Stamina",
    ["ITEM_MOD_HEALTH_SHORT"]         = "Health",
    ["ITEM_MOD_MANA_SHORT"]           = "Mana",
    ["ITEM_MOD_SPELL_POWER_SHORT"]    = "Spell Power",
    ["ITEM_MOD_HEALING_POWER_SHORT"]  = "Healing",
    ["ITEM_MOD_SPELL_HEALING_DONE"]   = "Healing", 
    ["ITEM_MOD_MANA_REGENERATION_SHORT"] = "Mp5",
    ["ITEM_MOD_POWER_REGEN0_SHORT"]   = "Mp5", 
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = "DPS",
    ["ITEM_MOD_ATTACK_POWER_SHORT"]      = "Attack Power",
    ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = "Ranged AP", 
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = "Feral AP",
    ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = "Hp5",
    ["ITEM_MOD_CRIT_RATING_SHORT"]       = "Crit",
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = "Spell Crit",
    ["ITEM_MOD_HIT_RATING_SHORT"]        = "Hit",
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]  = "Spell Hit",
    ["ITEM_MOD_CRIT_FROM_STATS_SHORT"]        = "Crit (from Agi)",
    ["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] = "Spell Crit (from Int)",
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = "Defense",
    ["ITEM_MOD_DODGE_RATING_SHORT"]      = "Dodge",
    ["ITEM_MOD_PARRY_RATING_SHORT"]      = "Parry",
    ["ITEM_MOD_BLOCK_RATING_SHORT"]      = "Block %",
    ["ITEM_MOD_BLOCK_VALUE_SHORT"]       = "Block Value",
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]     = "Shadow Dmg",
    ["ITEM_MOD_FIRE_DAMAGE_SHORT"]       = "Fire Dmg",
    ["ITEM_MOD_FROST_DAMAGE_SHORT"]      = "Frost Dmg",
    ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]     = "Arcane Dmg",
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"]     = "Nature Dmg",
    ["ITEM_MOD_HOLY_DAMAGE_SHORT"]       = "Holy Dmg",
    ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"] = "Shadow Res",
    ["ITEM_MOD_FIRE_RESISTANCE_SHORT"]   = "Fire Res",
    ["ITEM_MOD_FROST_RESISTANCE_SHORT"]  = "Frost Res",
    ["ITEM_MOD_NATURE_RESISTANCE_SHORT"] = "Nature Res",
    ["ITEM_MOD_ARCANE_RESISTANCE_SHORT"] = "Arcane Res",
    ["ITEM_MOD_ALL_RESISTANCE_SHORT"]    = "All Res",
	["MSC_WEAPON_SPEED"]				 = "Speed",
    ["MSC_WEAPON_DPS"]					 = "Weapon DPS",
    ["MSC_WAND_DPS"]					 = "Wand DPS",
}

MSC.SlotMap = { 
    ["INVTYPE_HEAD"]=1, ["INVTYPE_NECK"]=2, ["INVTYPE_SHOULDER"]=3, ["INVTYPE_BODY"]=4, 
    ["INVTYPE_CHEST"]=5, ["INVTYPE_ROBE"]=5, ["INVTYPE_WAIST"]=6, ["INVTYPE_LEGS"]=7, 
    ["INVTYPE_FEET"]=8, ["INVTYPE_WRIST"]=9, ["INVTYPE_HAND"]=10, ["INVTYPE_FINGER"]=11, 
    ["INVTYPE_TRINKET"]=13, ["INVTYPE_CLOAK"]=15, ["INVTYPE_WEAPON"]=16, ["INVTYPE_SHIELD"]=17, 
    ["INVTYPE_2HWEAPON"]=16, ["INVTYPE_WEAPONMAINHAND"]=16, ["INVTYPE_WEAPONOFFHAND"]=17, 
    ["INVTYPE_HOLDABLE"]=17, ["INVTYPE_RANGED"]=18, ["INVTYPE_THROWN"]=18, 
    ["INVTYPE_RANGEDRIGHT"]=18, ["INVTYPE_RELIC"]=18 
}

MSC.StatToCritMatrix = {
    ["WARRIOR"] = { Agi = { {1, 4.0}, {60, 20.0}, {70, 33.0} } },
    ["ROGUE"] = { Agi = { {1, 3.5}, {60, 29.0}, {70, 40.0} } },
    ["HUNTER"] = { Agi = { {1, 4.5}, {60, 53.0}, {70, 40.0} } },
    ["PALADIN"] = { Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, Int = { {1, 6.0}, {60, 29.5}, {70, 80.0} } },
    ["SHAMAN"] = { Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, Int = { {1, 6.0}, {60, 59.5}, {70, 80.0} } },
    ["DRUID"] = { Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, Int = { {1, 6.5}, {60, 60.0}, {70, 80.0} } },
    ["MAGE"] = { Agi = { {60, 20.0}, {70, 25.0} }, Int = { {1, 6.0}, {60, 59.5}, {70, 80.0} } },
    ["PRIEST"] = { Agi = { {60, 20.0}, {70, 25.0} }, Int = { {1, 6.0}, {60, 59.2}, {70, 80.0} } },
    ["WARLOCK"] = { Agi = { {60, 20.0}, {70, 25.0} }, Int = { {1, 6.5}, {60, 60.6}, {70, 80.0} } },
}

-- =============================================================
-- 4. ITEM OVERRIDES (Manual Stats for Complex Items)
-- =============================================================
MSC.ItemOverrides = {
    -- [[ WEIRD / SPECIAL ITEMS ]]
	
    -- [[ PVP RELICS ]]
    [32489] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26, estimate = true }, -- Gladiator's Libram of Vengeance
    -- Burst of Knowledge (Mana Cost Reduction -> Int/SP)
    [11811] = { ITEM_MOD_SPELL_POWER_SHORT = 12, ITEM_MOD_INTELLECT_SHORT = 5, estimate = true },

    -- Hand of Justice (Chance on hit: Extra Attack). Parser can't calculate "Extra Attack" value easily.
    [11815] = { ITEM_MOD_ATTACK_POWER_SHORT = 22, estimate = true }, 

    -- Ironfoe (Chance on hit: Speak Dwarven + Extra Attacks). Too complex for parser.
    [11684] = { ITEM_MOD_ATTACK_POWER_SHORT = 30, estimate = true },

    -- [[ PVP RELICS ]]
    [32489] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26, estimate = true }, -- Gladiator's Libram of Vengeance

    -- [[ PVP UTILITY (Keep These) ]]
    -- The parser doesn't know what "PvP Utility" score is, so we manually assign it.
    [18854] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18856] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18849] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [23835] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18851] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18852] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18853] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18850] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18846] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [28234] = { MSC_PVP_UTILITY = 80, estimate = true }, 
    [18834] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18845] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18841] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18839] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18832] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18835] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18837] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18838] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [23832] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [28235] = { MSC_PVP_UTILITY = 80, estimate = true }, 
}

MSC.PrettyNames = {
	-- [[ GENERIC / SHARED ]]
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
	
    ["WARRIOR"] = {
        ["FURY_2H"]         = "Raid: Arms/Fury (2H)",
        ["FURY_DW"]         = "Raid: Fury (Dual Wield)",
        ["ARMS_PVP"]        = "PvP: Arms (Mortal Strike)",
        ["ARMS_PVE"]        = "Raid: Arms (Blood Frenzy)",
        ["DEEP_PROT"]       = "Tank: Deep Protection",
        -- Leveling
        ["Leveling_DW_21_40"]   = "Fury/DW (21-40)",
        ["Leveling_DW_41_51"]   = "Fury/DW (41-51)",
        ["Leveling_DW_52_59"]   = "Fury/DW (52-59)",
        ["Leveling_DW_60_70"]   = "Fury/DW (Outland)",
        ["Leveling_Tank_21_40"] = "Dungeon Tank (21-40)",
        ["Leveling_Tank_41_51"] = "Dungeon Tank (41-51)",
        ["Leveling_Tank_52_59"] = "Dungeon Tank (52-59)",
        ["Leveling_Tank_60_70"] = "Dungeon Tank (Outland)",
    },
    ["PALADIN"] = {
        ["HOLY_RAID"]       = "Healer: Holy (Illumination)",
        ["PROT_DEEP"]       = "Tank: Deep Protection",
        ["PROT_AOE"]        = "Farming: AoE Grinding (Strat)",
        ["RET_STANDARD"]    = "DPS: Retribution",
        ["SHOCKADIN_PVP"]   = "PvP: Shockadin",
		-- Leveling
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
    },
    ["HUNTER"] = {
        ["RAID_BM"]          = "Raid: Beast Mastery",
        ["RAID_SURV"]        = "Raid: Survival (Expose Weakness)",
        ["RAID_MM"]          = "Raid: Marksmanship",
        ["PVP_MM"]           = "PvP: Marksmanship",
		-- Leveling
        ["Leveling_Melee_21_40"] = "Survival Melee (21-40)",
        ["Leveling_Melee_41_51"] = "Survival Melee (41-51)",
        ["Leveling_Melee_52_59"] = "Survival Melee (52-59)",
        ["Leveling_Melee_60_70"] = "Survival Melee (Outland)",
    },
    ["ROGUE"] = {
        ["RAID_COMBAT"]     = "Raid: Combat (Swords/Maces)",
        ["RAID_MUTILATE"]   = "Raid: Mutilate (Daggers)",
        ["PVP_SUBTLETY"]    = "PvP: Shadowstep / Hemo",
		-- Leveling
        ["Leveling_Dagger_1_20"]  = "Dagger/Ambush (1-20)",
        ["Leveling_Dagger_21_40"] = "Dagger/Ambush (21-40)",
        ["Leveling_Dagger_41_51"] = "Dagger/Ambush (41-51)",
        ["Leveling_Dagger_52_59"] = "Dagger/Ambush (52-59)",
        ["Leveling_Dagger_60_70"] = "Dagger/Ambush (Outland)",    
        ["Leveling_Hemo_1_20"]    = "Hemorrhage (1-20)",
        ["Leveling_Hemo_21_40"]   = "Hemorrhage (21-40)",
        ["Leveling_Hemo_41_51"]   = "Hemorrhage (41-51)",
        ["Leveling_Hemo_52_59"]   = "Hemorrhage (52-59)",
        ["Leveling_Hemo_60_70"]   = "Hemorrhage (Outland)",
    },
    ["PRIEST"] = {
        ["HOLY_DEEP"]       = "Healer: Circle of Healing",
        ["DISC_SUPPORT"]    = "Healer: Discipline (Pain Supp)",
        ["SMITE_DPS"]       = "DPS: Smite (Holy Fire)",
        ["SHADOW_PVE"]      = "DPS: Shadow (Mana Battery)",
        ["SHADOW_PVP"]      = "PvP: Shadow",
		-- Leveling
        ["Leveling_Smite_21_40"] = "Smite DPS (21-40)",
        ["Leveling_Smite_41_51"] = "Smite DPS (41-51)",
        ["Leveling_Smite_52_59"] = "Smite DPS (52-59)",
        ["Leveling_Smite_60_70"] = "Smite DPS (Outland)",
        
        ["Leveling_Healer_52_59"] = "Dungeon Healer (52-59)",
        ["Leveling_Healer_60_70"] = "Dungeon Healer (Outland)",
    },
    ["SHAMAN"] = {
        ["ELE_PVE"]         = "Raid: Elemental (Totem of Wrath)",
        ["ELE_PVP"]         = "PvP: Elemental (Burst)",
        ["ENH_PVE"]         = "Raid: Enhancement (Dual Wield)",
        ["RESTO_PVE"]       = "Healer: Chain Heal Spam",
        ["SHAMAN_TANK"]     = "Tank: Warden (Experimental)",
		-- Leveling
        ["Leveling_Caster_52_59"] = "Elemental (52-59)",
        ["Leveling_Caster_60_70"] = "Elemental (Outland)",
        
        ["Leveling_Healer_52_59"] = "Resto Dungeon (52-59)",
        ["Leveling_Healer_60_70"] = "Resto Dungeon (Outland)",
        
        ["Leveling_Tank_1_20"]    = "Shaman Tank (1-20)",
        ["Leveling_Tank_21_40"]   = "Shaman Tank (21-40)",
        ["Leveling_Tank_41_51"]   = "Shaman Tank (41-51)",
        ["Leveling_Tank_52_59"]   = "Shaman Tank (52-59)",
        ["Leveling_Tank_60_70"]   = "Shaman Tank (Outland)",
    },
    ["MAGE"] = {
        ["FIRE_RAID"]       = "Raid: Deep Fire",
        ["ARCANE_RAID"]     = "Raid: Arcane (Mind Mastery)",
        ["FROST_PVE"]       = "Raid: Deep Frost (Winter's Chill)",
        ["FROST_PVP"]       = "PvP: Frost (Water Elemental)",
        ["FROST_AOE"]       = "Farming: AoE Blizzard",
		-- Leveling
        ["Leveling_Fire_21_40"] = "Fire (21-40)",
        ["Leveling_Fire_41_51"] = "Fire (41-51)",
        ["Leveling_Fire_52_59"] = "Fire (52-59)",
        ["Leveling_Fire_60_70"] = "Fire (Outland)",
        
        ["Leveling_AoE_21_40"] = "Frost AoE Grind (21-40)",
        ["Leveling_AoE_41_51"] = "Frost AoE Grind (41-51)",
        ["Leveling_AoE_52_59"] = "Frost AoE Grind (52-59)",
        ["Leveling_AoE_60_70"] = "Frost AoE Grind (Outland)",
    },
    ["WARLOCK"] = {
		["DESTRUCT_SHADOW"]  = "Raid: Destruction (Shadow)",
        ["DESTRUCT_FIRE"]    = "Raid: Destruction (Fire)",
        ["RAID_AFFLICTION"]  = "Raid: Affliction (UA)",
        ["DEMO_PVE"]         = "Raid: Demonology (Felguard)",
        ["PVP_SL_SL"]        = "PvP: Soul Link / Siphon Life",
		-- Leveling
        ["Leveling_Fire_21_40"] = "Destro Fire (21-40)",
        ["Leveling_Fire_41_51"] = "Destro Fire (41-51)",
        ["Leveling_Fire_52_59"] = "Destro Fire (52-59)",
        ["Leveling_Fire_60_70"] = "Destro Fire (Outland)",
        
        ["Leveling_Demo_21_40"] = "Demonology (21-40)",
        ["Leveling_Demo_41_51"] = "Demonology (41-51)",
        ["Leveling_Demo_52_59"] = "Demonology (52-59)",
        ["Leveling_Demo_60_70"] = "Demonology (Outland)",
    },
    ["DRUID"] = {
        ["BALANCE_PVE"]      = "DPS: Balance (Boomkin)",
        ["DREAMSTATE"]       = "Healer: Dreamstate (High Int)",
        ["MOONGLOW"]         = "Healer: Moonglow (Efficiency)",
        ["RESTO_TREE"]       = "Healer: Tree of Life",
        ["RESTO_PVP"]        = "PvP: Resto (Resilience)",
        ["FERAL_CAT"]        = "DPS: Feral Cat",
        ["FERAL_BEAR"]       = "Tank: Feral Bear",
		-- Leveling
        ["Leveling_Bear_21_40"]   = "Feral Bear (21-40)",
        ["Leveling_Bear_41_51"]   = "Feral Bear (41-51)",
        ["Leveling_Bear_52_59"]   = "Feral Bear (52-59)",
        ["Leveling_Bear_60_70"]   = "Feral Bear (Outland)",
        
        ["Leveling_Caster_41_51"] = "Balance (41-51)",
        ["Leveling_Caster_52_59"] = "Balance (52-59)",
        ["Leveling_Caster_60_70"] = "Balance (Outland)",
        
        ["Leveling_Healer_52_59"] = "Resto Dungeon (52-59)",
        ["Leveling_Healer_60_70"] = "Resto Dungeon (Outland)",
    },
}

-- =============================================================
-- 5. ENCHANT DATABASE (Merged + Updated Flags)
-- =============================================================
MSC.EnchantDB = {
    -- [[ WEAPON: TBC ENDGAME ]]
    [2673] = { name = "Mongoose", stats = { ITEM_MOD_AGILITY_SHORT = 120, ITEM_MOD_HASTE_RATING_SHORT = 30 } }, -- Proc Avg
    [2674] = { name = "Sunfire", stats = { ITEM_MOD_SPELL_POWER_SHORT = 50, ITEM_MOD_ARCANE_DAMAGE_SHORT = 50 } },
    [2675] = { name = "Soulfrost", stats = { ITEM_MOD_SPELL_POWER_SHORT = 54, ITEM_MOD_FROST_DAMAGE_SHORT = 54 } },
    [3225] = { name = "Executioner", stats = { ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT = 120 } }, 
    [2669] = { name = "Major Spellpower", stats = { ITEM_MOD_SPELL_POWER_SHORT = 40 } },
    [2642] = { name = "Major Healing", stats = { ITEM_MOD_HEALING_POWER_SHORT = 81 } },
    [2671] = { name = "Sunfire (Healing)", stats = { ITEM_MOD_HEALING_POWER_SHORT = 50 } },
    [2666] = { name = "Major Intellect", stats = { ITEM_MOD_INTELLECT_SHORT = 30 } },
    [2667] = { name = "Savagery", stats = { ITEM_MOD_ATTACK_POWER_SHORT = 70 } }, 
    [2668] = { name = "Major Agility", stats = { ITEM_MOD_AGILITY_SHORT = 20 } },
    [3222] = { name = "Greater Agility (2H)", stats = { ITEM_MOD_AGILITY_SHORT = 35 }, requires2H = true }, 

    -- [[ WEAPON: CLASSIC / LEVELING ]]
    [2621] = { name = "Crusader", stats = { ITEM_MOD_STRENGTH_SHORT = 60 } }, 
    [803]  = { name = "Fiery Weapon", stats = { ITEM_MOD_FIRE_DAMAGE_SHORT = 4 } }, 
    [1897] = { name = "Weapon Dmg +5", stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } }, 
    [2504] = { name = "Spellpower (Classic)", stats = { ITEM_MOD_SPELL_POWER_SHORT = 30 } },
    [2505] = { name = "Healing (Classic)", stats = { ITEM_MOD_HEALING_POWER_SHORT = 55 } },
    [1900] = { name = "Unholy Weapon", stats = { ITEM_MOD_SHADOW_DAMAGE_SHORT = 4 } }, 
    [2563] = { name = "Major Strength", stats = { ITEM_MOD_STRENGTH_SHORT = 15 } },
    [1898] = { name = "Lifestealing", stats = { ITEM_MOD_SHADOW_DAMAGE_SHORT = 3 } },
    [943]  = { name = "Lesser Striking", stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1 } },

    -- [[ SCOPES (New Flags) ]]
    [23766] = { slot = 18, isScope = true, stats = {ITEM_MOD_CRIT_RATING_SHORT=14, ITEM_MOD_DAMAGE_PER_SECOND_SHORT=3}, name = "Adamantite Scope" }, -- +12 Dmg (~3 DPS)
    [23764] = { slot = 18, isScope = true, stats = {ITEM_MOD_DAMAGE_PER_SECOND_SHORT=3}, name = "Khorium Scope" }, -- +12 Dmg
    [10548] = { slot = 18, isScope = true, stats = {ITEM_MOD_DAMAGE_PER_SECOND_SHORT=2}, name = "Sniper Scope" }, -- +7 Dmg (~2 DPS)

    -- [[ SHIELD (New Flags) ]]
    [2655] = { name = "Major Stamina", slot = 17, isShield = true, stats = { ITEM_MOD_STAMINA_SHORT = 18 } },
    [2658] = { name = "Intellect", slot = 17, isShield = true, stats = { ITEM_MOD_INTELLECT_SHORT = 12 } },
    [2659] = { name = "Shield Block", slot = 17, isShield = true, stats = { ITEM_MOD_BLOCK_VALUE_SHORT = 15 } },
    [1071] = { name = "Lesser Stamina", slot = 17, isShield = true, stats = { ITEM_MOD_STAMINA_SHORT = 3 } }, 

    -- [[ HEAD (Glyphs) ]]
    [3012] = { name = "Glyph of Power (Sha'tar)", slot = 1, stats = { ITEM_MOD_SPELL_POWER_SHORT = 22, ITEM_MOD_HIT_SPELL_RATING_SHORT = 14 } },
    [3010] = { name = "Glyph of Ferocity (Cenarion)", slot = 1, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 34, ITEM_MOD_HIT_RATING_SHORT = 16 } },
    [3013] = { name = "Glyph of the Defender (Keepers)", slot = 1, stats = { ITEM_MOD_DODGE_RATING_SHORT = 16, ITEM_MOD_BLOCK_VALUE_SHORT = 17 } },
    [3011] = { name = "Glyph of Renewal (Honor Hold)", slot = 1, stats = { ITEM_MOD_HEALING_POWER_SHORT = 35, ITEM_MOD_MANA_REGENERATION_SHORT = 7 } },
    [3003] = { name = "Glyph of the Gladiator", slot = 1, stats = { ITEM_MOD_STAMINA_SHORT = 18, ITEM_MOD_RESILIENCE_RATING_SHORT = 20 } },

    -- [[ SHOULDER (Inscriptions) ]]
    [3004] = { name = "Greater Inscription of the Orb", slot = 3, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15, ITEM_MOD_CRIT_RATING_SHORT = 12 } },
    [3007] = { name = "Greater Inscription of Vengeance", slot = 3, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30, ITEM_MOD_CRIT_RATING_SHORT = 10 } },
    [3009] = { name = "Greater Inscription of the Knight", slot = 3, stats = { ITEM_MOD_DODGE_RATING_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 15 } },
    [3005] = { name = "Greater Inscription of the Oracle", slot = 3, stats = { ITEM_MOD_HEALING_POWER_SHORT = 22, ITEM_MOD_MANA_REGENERATION_SHORT = 6 } },
    [2992] = { name = "Inscription of the Orb", slot = 3, stats = { ITEM_MOD_SPELL_POWER_SHORT = 12 } },
    [2998] = { name = "Inscription of Vengeance", slot = 3, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26 } },

    -- [[ BACK ]]
    [2653] = { name = "Greater Agility", slot = 15, stats = { ITEM_MOD_AGILITY_SHORT = 12 } },
    [2662] = { name = "Spell Penetration", slot = 15, stats = { ITEM_MOD_SPELL_PENETRATION_SHORT = 20 } },
    [3296] = { name = "Steelweave", slot = 15, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 12 } },
    [3294] = { name = "Major Armor", slot = 15, stats = { ITEM_MOD_ARMOR_SHORT = 120 } },
    [849]  = { name = "Lesser Agility", slot = 15, stats = { ITEM_MOD_AGILITY_SHORT = 3 } }, 
    [2502] = { name = "Greater Resistance", slot = 15, stats = { ITEM_MOD_RESISTANCE_ALL_SHORT = 5 } },

    -- [[ CHEST ]]
    [2661] = { name = "Exceptional Stats", slot = 5, stats = { ITEM_MOD_AGILITY_SHORT=6, ITEM_MOD_STRENGTH_SHORT=6, ITEM_MOD_INTELLECT_SHORT=6, ITEM_MOD_STAMINA_SHORT=6 } },
    [2653] = { name = "Major Health", slot = 5, stats = { ITEM_MOD_HEALTH_SHORT = 150 } },
    [3297] = { name = "Major Resilience", slot = 5, stats = { ITEM_MOD_RESILIENCE_RATING_SHORT = 15 } },
    [2657] = { name = "Restore Mana Prime", slot = 5, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 6 } },
    [1891] = { name = "Greater Stats", slot = 5, stats = { ITEM_MOD_AGILITY_SHORT=4, ITEM_MOD_STRENGTH_SHORT=4, ITEM_MOD_INTELLECT_SHORT=4, ITEM_MOD_STAMINA_SHORT=4 } },
    [843]  = { name = "Minor Stats", slot = 5, stats = { ITEM_MOD_AGILITY_SHORT=1, ITEM_MOD_STRENGTH_SHORT=1, ITEM_MOD_INTELLECT_SHORT=1, ITEM_MOD_STAMINA_SHORT=1 } },

    -- [[ WRIST ]]
    [2647] = { name = "Brawn", slot = 9, stats = { ITEM_MOD_STRENGTH_SHORT = 12 } }, 
    [2650] = { name = "Spellpower (Bracer)", slot = 9, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15 } }, 
    [2651] = { name = "Major Healing (Bracer)", slot = 9, stats = { ITEM_MOD_HEALING_POWER_SHORT = 30 } }, 
    [2649] = { name = "Assault (Bracer)", slot = 9, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 24 } }, 
    [2646] = { name = "Major Defense", slot = 9, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 12 } },
    [2655] = { name = "Fortitude", slot = 9, stats = { ITEM_MOD_STAMINA_SHORT = 12 } }, 
    [1883] = { name = "Intellect +7", slot = 9, stats = { ITEM_MOD_INTELLECT_SHORT = 7 } },
    [1884] = { name = "Spirit +9", slot = 9, stats = { ITEM_MOD_SPIRIT_SHORT = 9 } },
    [905]  = { name = "Minor Strength", slot = 9, stats = { ITEM_MOD_STRENGTH_SHORT = 1 } },

    -- [[ HANDS ]]
    [2562] = { name = "Superior Agility", slot = 10, stats = { ITEM_MOD_AGILITY_SHORT = 15 } }, 
    [2937] = { name = "Major Spellpower", slot = 10, stats = { ITEM_MOD_SPELL_POWER_SHORT = 20 } }, 
    [2935] = { name = "Major Healing", slot = 10, stats = { ITEM_MOD_HEALING_POWER_SHORT = 35 } }, 
    [2648] = { name = "Assault (Gloves)", slot = 10, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26 } }, 
    [2613] = { name = "Threat", slot = 10, stats = { ITEM_MOD_HIT_RATING_SHORT = 10 } }, 
    [3246] = { name = "Blast", slot = 10, stats = { ITEM_MOD_SPELL_CRIT_RATING_SHORT = 10 } },
    [1886] = { name = "Agility +7", slot = 10, stats = { ITEM_MOD_AGILITY_SHORT = 7 } },

    -- [[ LEGS ]]
    [3154] = { name = "Runic Spellthread", slot = 7, stats = { ITEM_MOD_SPELL_POWER_SHORT = 35, ITEM_MOD_STAMINA_SHORT = 20 } },
    [3153] = { name = "Golden Spellthread", slot = 7, stats = { ITEM_MOD_HEALING_POWER_SHORT = 66, ITEM_MOD_STAMINA_SHORT = 20 } },
    [2953] = { name = "Nethercobra Leg Armor", slot = 7, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 50, ITEM_MOD_CRIT_RATING_SHORT = 12 } },
    [2952] = { name = "Nethercleft Leg Armor", slot = 7, stats = { ITEM_MOD_STAMINA_SHORT = 40, ITEM_MOD_AGILITY_SHORT = 12 } },
    [2741] = { name = "Cobrahide Leg Armor", slot = 7, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 40, ITEM_MOD_CRIT_RATING_SHORT = 10 } },
    [2427] = { name = "Mystic Spellthread", slot = 7, stats = { ITEM_MOD_SPELL_POWER_SHORT = 25, ITEM_MOD_STAMINA_SHORT = 15 } },

    -- [[ FEET ]]
    [2939] = { name = "Boar's Speed", slot = 8, stats = { ITEM_MOD_STAMINA_SHORT = 9, MSC_SPEED_BONUS = 8 } },
    [2656] = { name = "Cat's Swiftness", slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 6, MSC_SPEED_BONUS = 8 } },
    [3232] = { name = "Surefooted", slot = 8, stats = { ITEM_MOD_HIT_RATING_SHORT = 10, ITEM_MOD_CRIT_RATING_SHORT = 5 } }, 
    [2564] = { name = "Agility +7", slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 7 } },
    [911]  = { name = "Minor Agility", slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 1 } },

    -- [[ RINGS ]]
    [2931] = { name = "Spellpower", slot = 11, stats = { ITEM_MOD_SPELL_POWER_SHORT = 12 } }, 
    [2933] = { name = "Healing Power", slot = 11, stats = { ITEM_MOD_HEALING_POWER_SHORT = 20 } }, 
    [2934] = { name = "Stats", slot = 11, stats = { ITEM_MOD_AGILITY_SHORT=4, ITEM_MOD_STRENGTH_SHORT=4, ITEM_MOD_INTELLECT_SHORT=4, ITEM_MOD_STAMINA_SHORT=4 } }, 
    [2629] = { name = "Striking", slot = 11, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } },
}

-- =============================================================
-- 6. ENCHANT CANDIDATES (For Projections)
-- =============================================================
MSC.EnchantCandidates = {
    [1] = { 3012, 3010, 3013, 3011, 3003 },
    [3] = { 3004, 3007, 3009, 3005, 2992, 2998 },
    [5] = { 2661, 2653, 3297, 2657, 1891, 843 },
    [7] = { 3154, 3153, 2953, 2952, 2427, 2741 },
    [8] = { 2939, 2656, 3232, 2564, 911 },
    [9] = { 2647, 2650, 2651, 2649, 2646, 2655, 1883, 1884, 905 },
    [10] = { 2562, 2937, 2935, 2648, 2613, 3246, 1886 },
    [11] = { 2931, 2933, 2934, 2629 },
    [12] = { 2931, 2933, 2934, 2629 },
    [15] = { 2653, 2662, 3296, 3294, 2502, 849 },
    [16] = { 2673, 2674, 2675, 3225, 2669, 2642, 2671, 2666, 2667, 2668, 3222, 2621, 1897, 803, 1900, 2563, 1898, 2504, 2505, 943 },
    [17] = { 2655, 2658, 2659, 1071, 2673, 2674, 2675, 3225, 2669, 2642, 2666, 2668, 2621, 803 },
    [18] = { 23766, 23764, 10548 } -- Add Scopes to candidate list
}

MSC.EnchantCandidates_Leveling = {
    [1] = {}, [3] = {},
    [5] = { 1891, 843, 2653 }, 
    [9] = { 2655, 1883, 1884, 905 },
    [10] = { 2562, 1886 },
    [6] = {},
    [7] = { 2741, 2743 }, 
    [8] = { 2939, 2564, 911 },
    [15] = { 849, 2622 },
    [16] = { 2621, 803, 1900, 1898, 2504, 2505, 943, 1897 },
    [17] = { 2621, 803, 1900, 1898, 2655, 1071 },
    [11] = {}, [12] = {},
    [18] = { 10548 }
}

-- =============================================================
-- 7. GEM OPTIONS (Auto-Picker)
-- =============================================================
MSC.GemOptions = {
    ["EMPTY_SOCKET_RED"] = {
        { stat="ITEM_MOD_STRENGTH_SHORT", val=8, name="Bold Living Ruby" },
        { stat="ITEM_MOD_AGILITY_SHORT", val=8, name="Delicate Living Ruby" },
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=9, name="Runed Living Ruby" },
        { stat="ITEM_MOD_HEALING_POWER_SHORT", val=18, name="Teardrop Living Ruby" },
        { stat="ITEM_MOD_EXPERTISE_RATING_SHORT", val=8, name="Precise Living Ruby" }, -- << NEW: Critical for Rogues/Tanks
        { stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", val=2, name="Bright Living Ruby" }, -- (Late TBC)
        
        -- Orange (Red Match)
        { stat="ITEM_MOD_STRENGTH_SHORT", val=4, val2=4, stat2="ITEM_MOD_CRIT_RATING_SHORT", name="Inscribed Noble Topaz" },
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, val2=4, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", name="Potent Noble Topaz" },
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, val2=4, stat2="ITEM_MOD_SPELL_HASTE_RATING_SHORT", name="Reckless Noble Topaz" }, -- << NEW: Critical for Casters
    },

    ["EMPTY_SOCKET_YELLOW"] = {
        { stat="ITEM_MOD_CRIT_RATING_SHORT", val=8, name="Smooth Dawnstone" },
        { stat="ITEM_MOD_HIT_RATING_SHORT", val=8, name="Rigid Dawnstone" },
        { stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=8, name="Thick Dawnstone" },
        { stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=8, name="Quick Dawnstone" }, -- << NEW
        { stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=8, name="Smooth Dawnstone (Spell)" },
        { stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=8, name="Great Dawnstone" },
    },

    ["EMPTY_SOCKET_BLUE"] = {
        { stat="ITEM_MOD_STAMINA_SHORT", val=12, name="Solid Star of Elune" },
        { stat="ITEM_MOD_SPIRIT_SHORT", val=10, name="Sparkling Star of Elune" },
        { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=4, name="Lustrous Star of Elune" }, -- MP5 is usually 4 (2mp5 per 5)
        
        -- Purple (Blue Match)
        { stat="ITEM_MOD_STRENGTH_SHORT", val=4, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Sovereign Nightseye" },
        { stat="ITEM_MOD_AGILITY_SHORT", val=4, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Shifting Nightseye" },
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Glowing Nightseye" },
    },

    ["EMPTY_SOCKET_META"] = {
        -- Meta Gems are hard to score purely on stats because of the "Effect" (e.g. +3% Crit Dmg).
        -- We give them high base stats to compensate.
        { stat="ITEM_MOD_AGILITY_SHORT", val=24, name="Relentless Earthstorm (Effect)" }, -- Artificial Boost
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=26, name="Chaotic Skyfire (Effect)" },
        { stat="ITEM_MOD_STAMINA_SHORT", val=30, name="Austere Earthstorm (Effect)" },
    }
}

MSC.GemOptions_Leveling = {
    ["EMPTY_SOCKET_RED"] = {
        { stat="ITEM_MOD_STRENGTH_SHORT", val=4, name="Bold Blood Garnet" },
        { stat="ITEM_MOD_AGILITY_SHORT", val=4, name="Delicate Blood Garnet" },
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, name="Runed Blood Garnet" },
    },
    ["EMPTY_SOCKET_YELLOW"] = {
        { stat="ITEM_MOD_CRIT_RATING_SHORT", val=4, name="Smooth Golden Draenite" },
        { stat="ITEM_MOD_HIT_RATING_SHORT", val=4, name="Rigid Golden Draenite" },
    },
    ["EMPTY_SOCKET_BLUE"] = {
        { stat="ITEM_MOD_STAMINA_SHORT", val=6, name="Solid Azure Moonstone" },
        { stat="ITEM_MOD_SPIRIT_SHORT", val=4, name="Sparkling Azure Moonstone" },
    },
    ["EMPTY_SOCKET_META"] = {
        { stat="ITEM_MOD_AGILITY_SHORT", val=12, name="Relentless Earthstorm" },
    }
}