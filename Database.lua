local _, MSC = ...

-- =============================================================
-- ENDGAME STAT WEIGHTS (Level 70 TBC Raid & PvP)
-- =============================================================
MSC.WeightDB = {
	["WARRIOR"] = {
        ["Default"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.3, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.5, ["ITEM_MOD_ARMOR_PENETRATION_SHORT"]=1.5 },
        
        -- [[ FURY (Dual Wield) ]]
        ["FURY_DW"] = { 
            ["ITEM_MOD_HIT_RATING_SHORT"]=28.0, -- Dual Wield miss penalty is huge
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=25.0, -- Dodge/Parry reduction is vital
            ["ITEM_MOD_STRENGTH_SHORT"]=2.3, -- 1 Str = 2 AP
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=30.0, -- Flurry uptime
            ["ITEM_MOD_ARMOR_PENETRATION_SHORT"]=2.2, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=18.0,
            ["ITEM_MOD_AGILITY_SHORT"]=1.4 -- Lower crit conversion in TBC than Classic
        },

        -- [[ ARMS (PvE Support) ]]
        ["ARMS_PVE"] = { 
            -- The "Blood Frenzy" Bot. 2H Weapon used.
            ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, -- Only need 9% cap
            ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=28.0, 
            ["ITEM_MOD_ARMOR_PENETRATION_SHORT"]=3.0, -- ArP is massive for big 2H hits
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=20.0,
            ["ITEM_MOD_HASTE_RATING_SHORT"]=12.0 -- Slam cast time reduction
        },

        -- [[ ARMS (PvP) ]]
        ["ARMS_PVP"] = { 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=3.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, -- Need to survive focus fire
            ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, -- Burst
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=15.0 -- 5% PvP Cap
        },

        -- [[ PROTECTION (Tank) ]]
        ["DEEP_PROT"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=3.5, -- Effective Health
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.5, -- Uncrittable Cap (490)
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5, -- Shield Slam Threat!
            ["ITEM_MOD_DODGE_RATING_SHORT"]=15.0, 
            ["ITEM_MOD_PARRY_RATING_SHORT"]=15.0,
            ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, -- Threat
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=12.0 -- Parry-Haste reduction
        },

        -- [[ FURY (2H) ]]
        ["FURY_2H"] = { 
            -- Niche Slam spec (usually Horde Windfury)
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=8.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=30.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, 
            ["ITEM_MOD_ARMOR_PENETRATION_SHORT"]=2.0 
        },
    },
	["PALADIN"] = {
        ["Default"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
        
        -- [[ HOLY (HEALER) ]]
        ["HOLY_RAID"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, -- Mana Pool + Spell Crit (Holy Guidance/Illumination)
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=18.0, -- Illumination is the spec's engine
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=8.0 -- Late TBC stat
        },

        -- [[ PROTECTION (TANK) ]]
        ["PROT_DEEP"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=3.0, -- Effective Health is King
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.5, -- Reach 490 Cap
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, -- Consecration Threat
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.2, -- Mitigation & Threat
            ["ITEM_MOD_DODGE_RATING_SHORT"]=15.0, 
            ["ITEM_MOD_PARRY_RATING_SHORT"]=15.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=5.0, -- Taunt is a spell
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=5.0
        },

        -- [[ RETRIBUTION (DPS) ]]
        ["RET_STANDARD"] = { 
            ["ITEM_MOD_HIT_RATING_SHORT"]=22.0, -- 9% Cap
            ["ITEM_MOD_STRENGTH_SHORT"]=2.4, -- Scaled by Talents/Kings
            ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, -- Less valuable than Vanilla (1 Agi = 1 AP/Crit)
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=20.0, -- Dodge parry reduction
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.3, -- Adds some dmg to Judge/Consec, but usually incidental on gear
            ["ITEM_MOD_HASTE_RATING_SHORT"]=15.0
        },

        -- [[ SHOCKADIN (PVP) ]]
        ["SHOCKADIN_PVP"] = { 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=3.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, -- Burst Damage
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=14.0, -- Holy Shock Crits
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0 
        },
		-- [[ FARMING (Strat/Scholo) ]]
        ["PROT_AOE"] = { 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=3.0, -- KING STAT: Reduces damage from many small hits to 0
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, -- Consecration/Ret Aura damage
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, -- Mana pool for max pulls
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, -- Survival
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, -- Less critical for trash mobs than raid bosses
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.0,
            ["ITEM_MOD_PARRY_RATING_SHORT"]=1.0
        },
    },
    ["PRIEST"] = {
        ["Default"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5 },
        
        -- [[ HOLY (Circle of Healing) ]]
        ["HOLY_DEEP"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8, -- Spiritual Guidance (25%) + Imp Divine Spirit
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, -- MP5
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=10.0 -- Reduces GCD for CoH spam
        },

        -- [[ DISCIPLINE (Support) ]]
        ["DISC_SUPPORT"] = { 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.8, -- Deep Mana Pool for Rappture/Suppression
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.6, -- Disc doesn't rely on Spirit regen as much as Holy
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0 -- Divine Aegis logic (WotLK) / Inspiration (TBC)
        },

        -- [[ SHADOW (PvE) ]]
        ["SHADOW_PVE"] = { 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, -- Hit Cap is Mandatory for Mana Battery role
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=12.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, -- Mind Blast/SW:D crit, but Dots don't crit in TBC
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4
        },

        -- [[ SMITE (Holy DPS) ]]
        ["SMITE_DPS"] = { 
            -- The "Surge of Light" Build
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=18.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=16.0, -- Critical for Surge of Light procs
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=10.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5 
        },

        -- [[ SHADOW (PvP) ]]
        ["SHADOW_PVP"] = { 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=3.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, -- Face-tanking rogues
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=5.0 -- 3-4% cap for PvP
        },
    },
    ["ROGUE"] = {
        ["Default"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.1, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0 },
        
        -- [[ COMBAT (PvE) ]]
        ["RAID_COMBAT"] = { 
            ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, -- Energy generation via Combat Potency requires Hit
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=22.0, -- Dodge capped is vital
            ["ITEM_MOD_AGILITY_SHORT"]=2.3, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=18.0, -- White damage is a huge portion of Combat DPS
            ["ITEM_MOD_ARMOR_PENETRATION_SHORT"]=2.6, -- Armor Pen scales incredibly well in later Tiers
            ["ITEM_MOD_STRENGTH_SHORT"]=1.1 -- 1 Str = 1 AP
        },

        -- [[ MUTILATE (Assassination) ]]
        ["RAID_MUTILATE"] = { 
            -- Dagger Spec (Seal Fate)
            ["ITEM_MOD_CRIT_RATING_SHORT"]=24.0, -- Crit generates Combo Points (Seal Fate)
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=22.0, -- Poison application requires Hit
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=18.0, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=12.0 
        },

        -- [[ SUBTLETY (PvP) ]]
        ["PVP_SUBTLETY"] = { 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=3.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, -- Cheat Death buffer
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, -- Dodge + AP + Crit
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, -- 5% PvP Cap
            ["ITEM_MOD_ARMOR_PENETRATION_SHORT"]=2.0 -- Burst damage on cloth
        },
    },
	["HUNTER"] = {
        ["Default"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5 },
        
        -- [[ BEAST MASTERY ]]
        ["RAID_BM"] = { 
            ["ITEM_MOD_HIT_RATING_SHORT"]=32.0, -- Hit Cap is vital
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=28.0, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=18.0, -- Haste is king for BM
            ["ITEM_MOD_ARMOR_PENETRATION_SHORT"]=2.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4 -- Mana matters for long fights
        },

        -- [[ SURVIVAL ]]
        ["RAID_SURV"] = { 
            -- "Expose Weakness" Bot: Agility provides AP to the whole raid.
            ["ITEM_MOD_AGILITY_SHORT"]=3.5, -- MASSIVE PRIORITY
            ["ITEM_MOD_HIT_RATING_SHORT"]=30.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=22.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, -- Raw AP is less valuable than Agi here
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6, -- Thrill of the Hunt relies on crit
            ["ITEM_MOD_ARMOR_PENETRATION_SHORT"]=1.5 
        },

        -- [[ MARKSMANSHIP ]]
        ["RAID_MM"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_ARMOR_PENETRATION_SHORT"]=2.8, -- MM scales well with ArP
            ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=30.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5 
        },
        ["PVP_MM"] = { 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=3.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, -- Viper Sting wars need Mana
            ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0 
        },
    },
    ["MAGE"] = {
        ["Default"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0 },
        
        -- [[ ARCANE (PvE) ]]
        ["ARCANE_RAID"] = { 
            -- The "Arcane Blast" Spam build
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, -- Mind Mastery: Int -> Spell Power is huge
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=14.0, -- Arcane Focus reduces cap
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=12.0, -- Burns mana faster, but huge output
            ["ITEM_MOD_SPIRIT_SHORT"]=0.6 -- Evocation / Innervate scaling
        },

        -- [[ FIRE (PvE) ]]
        ["FIRE_RAID"] = { 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=18.0, -- Mandatory Cap
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=14.0, -- Ignite/Combustion synergy
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=12.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4 
        },

        -- [[ FROST (PvE) ]]
        ["FROST_PVE"] = { 
            -- Deep Frost (Water Elemental + Winter's Chill)
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=18.0, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, -- Shatter is rare in raids, but Crit helps
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=10.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5
        },

        -- [[ FROST (PvP) ]]
        ["FROST_PVP"] = { 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=3.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, -- Mana war
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=8.0 
        },
		-- [[ FARMING (AoE Grinding) ]]
        ["FROST_AOE"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, -- Survival is #1 when pulling 10+ mobs
            ["ITEM_MOD_INTELLECT_SHORT"]=2.0, -- Mana pool is the limiter
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.1, -- Blizzard DOES NOT crit
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=0.2 -- Not needed for lower lvl mobs
        },
    },
    ["WARLOCK"] = {
        ["Default"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0 },
        
        -- [[ DESTRUCTION (Shadow Bolt / Incinerate) ]]
        ["RAID_DESTRUCTION"] = { 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=22.0, -- Cap is vital for 1-button spam
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=0.8, -- Incinerate/Immolate usage varies
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=16.0, -- Ruin (+100% crit dmg bonus)
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=14.0, -- Scales incredibly well in T6
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4
        },

        -- [[ AFFLICTION (UA / Malediction) ]]
        ["RAID_AFFLICTION"] = { 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, -- Pure Shadow dmg output
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=18.0, -- Suppression reduces cap needed from gear
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=8.0, -- Only affects GCDs in TBC
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, -- Dots don't crit
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5, -- Dark Pact battery
            ["ITEM_MOD_STAMINA_SHORT"]=0.6 -- Life Tap pool
        },

        -- [[ DEMONOLOGY (Felguard) ]]
        ["DEMO_PVE"] = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, -- Demonic Tactics
            ["ITEM_MOD_STAMINA_SHORT"]=0.8, -- Pet HP scaling
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6, -- Pet Mana scaling
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=10.0
        },

        -- [[ SL/SL (PvP) ]]
        ["PVP_SL_SL"] = { 
            -- The Unkillable Tank
            ["ITEM_MOD_STAMINA_SHORT"]=3.0, -- Effective Health is #1
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=3.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=4.0 
        },
    },
    ["SHAMAN"] = {
        ["Default"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5 },
        
        -- [[ ELEMENTAL (PvE) ]]
        ["ELE_PVE"] = { 
            -- The Totem of Wrath build
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=18.0, -- Mandatory Cap
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, -- Lightning Overload
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=10.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4 
        },

        -- [[ ELEMENTAL (PvP) ]]
        ["ELE_PVP"] = { 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=3.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, -- Burst
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8
        },

        -- [[ ENHANCEMENT (PvE) ]]
        ["ENH_PVE"] = { 
            -- Dual Wield Specialist
            ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, -- Dual Wield penalty is harsh
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=22.0, -- Dodge reduction
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, -- 1 Str = 2 AP
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, -- Flurry uptime
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, -- Crit
            ["ITEM_MOD_INTELLECT_SHORT"]=0.45, -- Mental Dexterity: 1 Int = 1 AP
            ["ITEM_MOD_HASTE_RATING_SHORT"]=15.0 -- More Maelstrom / Weapon procs? (Wrath mechanic, but Haste is good for white dmg)
        },

        -- [[ RESTORATION (PvE) ]]
        ["RESTO_PVE"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.5, -- Mana Tide / Long fights
            ["ITEM_MOD_INTELLECT_SHORT"]=0.9, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=12.0 -- Chain Heal go brrr
        },
		-- [[ SHAMAN TANK (Warden) ]]
        ["SHAMAN_TANK"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=2.8, -- Survival is priority #1
            ["ITEM_MOD_ARMOR_SHORT"]=0.8, -- Mitigation (Shields/Mail)
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.2, -- Huge for mitigation
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.8, -- Crit reduction
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5,
            ["ITEM_MOD_PARRY_RATING_SHORT"]=1.5, -- (Requires Talent)
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, -- Earth Shock Threat
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, -- Mana pool for shocks
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, -- Block Value + AP
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, -- Dodge + Armor + Crit
            ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, -- Threat
        },
    },
    ["DRUID"] = {
        ["Default"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        
        -- [[ BALANCE ]]
        ["BALANCE_PVE"] = { 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=18.0, -- Hit is hard to get
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=14.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=10.0 
        },

        -- [[ FERAL ]]
        ["FERAL_CAT"] = { 
            ["ITEM_MOD_HIT_RATING_SHORT"]=22.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=20.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, -- Agi gives AP in TBC Cat
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, 
            ["ITEM_MOD_ARMOR_PENETRATION_SHORT"]=2.0 
        },
        ["FERAL_BEAR"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=3.5, -- King Stat for Bears
            ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.0, 
            ["ITEM_MOD_ARMOR_SHORT"]=0.5, -- Bonus Armor is huge
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, -- Dodge
            ["ITEM_MOD_DODGE_RATING_SHORT"]=15.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.5, -- Crit Cap needed
            ["ITEM_MOD_HIT_RATING_SHORT"]=10.0,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=2.0 -- PvP gear often used for Crit Cap
        },

        -- [[ RESTORATION ]]
        ["RESTO_TREE"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8, -- Tree of Life converts Spirit to Heal
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6 
        },
        ["RESTO_PVP"] = { 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=3.0,
            ["ITEM_MOD_STAMINA_SHORT"]=2.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8 
        },

        -- [[ HYBRIDS ]]
        ["DREAMSTATE"] = { -- The "Intellect Healer"
            ["ITEM_MOD_INTELLECT_SHORT"]=2.5, -- Massive weight due to Dreamstate talent
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=5.0 
        },
        ["MOONGLOW"] = { -- The "Efficiency Healer"
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.5, -- Mana efficiency is the goal
            ["ITEM_MOD_INTELLECT_SHORT"]=0.9,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 -- Nature's Grace procs
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
    ["Human"] = { [7]=5, [8]=5, [4]=5, [5]=5 },
    ["Orc"] = { [0]=5, [1]=5 },
    ["Dwarf"] = { [3]=5 },
    ["Troll"] = { [2]=5, [16]=5 },
    ["Draenei"] = {}, -- Heroic Presence is dynamic
    ["BloodElf"] = {}, -- Arcane Torrent is active
}

-- =============================================================
-- 4. WEAPON SPEED PREFERENCES (Updated for v2.0 Keys)
-- =============================================================
MSC.SpeedChecks = {
    ["WARRIOR"] = {
        ["Default"]     = { MH_Slow=true },
        ["FURY_DW"]     = { MH_Slow=true, OH_Fast=true }, -- Slow MH for dmg, Fast OH for Rage
        ["FURY_2H"]     = { MH_Slow=true },
        ["ARMS_MS"]     = { MH_Slow=true }, -- Big hits for Mortal Strike
        ["DEEP_PROT"]   = { MH_Fast=true }, -- Fast for Heroic Strike queuing
    },
    ["ROGUE"] = {
        ["Default"]             = { MH_Slow=true, OH_Fast=true },
        ["RAID_COMBAT_SWORDS"]  = { MH_Slow=true, OH_Fast=true }, -- Slow Sword MH (Sinister Strike)
        ["RAID_COMBAT_DAGGERS"] = { MH_Fast=false, OH_Fast=true }, -- (Daggers logic handled by stats)
        ["PVP_HEMO"]            = { MH_Slow=true }, -- Slow weapon for Hemo dmg
    },
    ["PALADIN"] = {
        ["Default"]      = { MH_Slow=true },
        ["RET_STANDARD"] = { MH_Slow=true }, -- Seal of Command needs 3.5+ speed ideally
        ["PROT_DEEP"]    = { MH_Fast=true }, -- Fast for threat/procs
        ["RECK_BOMB"]    = { MH_Slow=true },
    },
    ["HUNTER"] = {
        ["Default"] = { Ranged_Slow=true }, -- Slower bows/guns = bigger Multi-Shots
    },
    ["SHAMAN"] = {
        ["Default"]         = { MH_Slow=true },
        ["ENH_STORMSTRIKE"] = { MH_Slow=true }, -- Stormstrike calculates off weapon dmg
    }
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
    -- [[ TBC NEW STATS ]]
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = "Resilience",
    ["ITEM_MOD_HASTE_RATING_SHORT"]      = "Haste",
    ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= "Spell Haste",
    ["ITEM_MOD_EXPERTISE_RATING_SHORT"]  = "Expertise",
    ["ITEM_MOD_ARMOR_PENETRATION_SHORT"] = "Armor Pen",
    ["ITEM_MOD_SPELL_PENETRATION_SHORT"] = "Spell Pen",
    ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]= "Feral AP",

    -- [[ LEGACY MAPPINGS ]]
    ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = "Expertise", -- Remap old skill to Expertise
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
        Agi = { {1, 4.0}, {60, 20.0}, {70, 33.0} } 
    },
    ["ROGUE"] = { 
        Agi = { {1, 3.5}, {60, 29.0}, {70, 40.0} } 
    },
    ["HUNTER"] = { 
        Agi = { {1, 4.5}, {60, 53.0}, {70, 40.0} } -- TBC normalized Hunters to 40
    },
    ["PALADIN"] = { 
        Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, 
        Int = { {1, 6.0}, {60, 29.5}, {70, 80.0} } -- Paladin Int crit nerfed heavily in TBC
    },
    ["SHAMAN"] = { 
        Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, 
        Int = { {1, 6.0}, {60, 59.5}, {70, 80.0} } 
    },
    ["DRUID"] = { 
        Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, 
        Int = { {1, 6.5}, {60, 60.0}, {70, 80.0} } 
    },
    ["MAGE"] = { 
        Agi = { {60, 20.0}, {70, 25.0} }, 
        Int = { {1, 6.0}, {60, 59.5}, {70, 80.0} } 
    },
    ["PRIEST"] = { 
        Agi = { {60, 20.0}, {70, 25.0} }, 
        Int = { {1, 6.0}, {60, 59.2}, {70, 80.0} } 
    },
    ["WARLOCK"] = { 
        Agi = { {60, 20.0}, {70, 25.0} }, 
        Int = { {1, 6.5}, {60, 60.6}, {70, 80.0} } 
    },
}
-- =============================================================
-- 9. ITEM OVERRIDES (Master List: Active & Passive)
-- =============================================================
MSC.ItemOverrides = {
    -- [[ TBC TRINKETS (Estimates for Procs/Use Effects) ]]
    
    -- Melee / Hunter
    [28830] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 325, estimate = true }, -- Dragonspine Trophy (Haste Proc ~325 AP equiv)
    [30627] = { ["ITEM_MOD_CRIT_RATING_SHORT"] = 40, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 80, estimate = true }, -- Tsunami Talisman
    [29383] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 90, estimate = true }, -- Bloodlust Brooch (Use)
    [28034] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 64, estimate = true }, -- Hourglass of the Unraveller
    [28288] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 70, estimate = true }, -- Abacus of Violent Odds
    [32505] = { ["ITEM_MOD_ARMOR_PENETRATION_SHORT"] = 40, estimate = true }, -- Madness of the Betrayer (Proc)
    [33831] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 120, estimate = true }, -- Berserker's Call

    -- Caster
    [29370] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 65, estimate = true }, -- Icon of the Silver Crescent (Use ~43 equiv + 43 static)
    [27683] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 70, estimate = true }, -- Quagmirran's Eye (Haste Proc estimated as SP)
    [32483] = { ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 60, estimate = true }, -- Skull of Gul'dan (Haste/SP Use)
    [28785] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 55, estimate = true }, -- Lightning Capacitor (Proc)
    [29132] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 50, estimate = true }, -- Scryer's Bloodgem
    [30720] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 60, estimate = true }, -- Sextant of Unstable Currents

    -- Healer
    [29376] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 130, estimate = true }, -- Essence of the Martyr
    [28590] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 110, estimate = true }, -- Eye of Gruul
    [28370] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 25, estimate = true }, -- Bangle of Endless Blessings (Spirit/Cast Proc)
    [30621] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 80, ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 10, estimate = true }, -- Prism of Inner Calm
    [32501] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 120, estimate = true }, -- Shadowmoon Insignia

    -- Tank
    [30629] = { ["ITEM_MOD_STAMINA_SHORT"] = 60, estimate = true }, -- Spyglass of the Hidden Fleet
    [29387] = { ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 100, ["ITEM_MOD_DODGE_RATING_SHORT"] = 20, estimate = true }, -- Gnomeregan Auto-Blocker
    [27529] = { ["ITEM_MOD_STAMINA_SHORT"] = 45, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 15, estimate = true }, -- Adamantine Figurine
    [32500] = { ["ITEM_MOD_STAMINA_SHORT"] = 90, estimate = true }, -- Commendation of Kael'thas

    -- [[ TBC RELICS / IDOLS / TOTEMS / LIBRAMS (Converted to Generic Stats) ]]
    
    -- Druid Idols
    [27518] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 45, estimate = true, replace = true }, -- Idol of the Raven Goddess (Crit Aura = AP estimate)
    [28355] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 55, estimate = true, replace = true }, -- Idol of the Emerald Queen
    [32387] = { ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"] = 60, estimate = true, replace = true }, -- Idol of Terror
    [25649] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 35, estimate = true, replace = true }, -- Idol of the Avian Heart
    [22399] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 50, estimate = true, replace = true }, -- Idol of Health (Classic)
    [23197] = { ["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = 25, estimate = true, replace = true }, -- Idol of the Moon (Classic)

    -- Paladin Librams
    [27484] = { ["ITEM_MOD_CRIT_RATING_SHORT"] = 30, estimate = true, replace = true }, -- Libram of Avengement (Judgement Proc)
    [23201] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 45, estimate = true, replace = true }, -- Libram of Divinity (Classic)
    [32489] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 40, estimate = true, replace = true }, -- Libram of Divine Purpose
    [28253] = { ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 60, estimate = true, replace = true }, -- Libram of Repentance
    [28592] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 65, estimate = true, replace = true }, -- Libram of Souls Redeemed

    -- Shaman Totems
    [28349] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 60, estimate = true, replace = true }, -- Totem of the Void
    [28523] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 70, estimate = true, replace = true }, -- Totem of Healing Rains
    [27815] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 55, estimate = true, replace = true }, -- Totem of the Astral Winds
    [23199] = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 33, estimate = true, replace = true }, -- Totem of the Storm (Classic)
    [22395] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 65, estimate = true, replace = true }, -- Totem of Life (Classic)

    -- [[ CLASSIC LEGACY (Preserved from Vanilla) ]]
    -- Melee
    [19406] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 86, estimate = true, replace = true }, -- Drake Fang Talisman
    [13965] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30, estimate = true, replace = true }, -- Blackhand's Breadth
    [19991] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 39, estimate = true, replace = true }, -- Devilsaur Eye
    [19120] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 35, estimate = true, replace = true }, -- Rune of the Guard Captain
    [18469] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30, estimate = true, replace = true }, -- Royal Seal (Rogue)
    [21567] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 20, estimate = true, replace = true }, -- Rune of Duty
    
    -- Active/Procs 
    [19949] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 34, estimate = true, replace = true }, -- Zandalarian Hero Medallion
    [23570] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 65, estimate = true, replace = true }, -- Jom Gabbar
    [21180] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 47, estimate = true, replace = true }, -- Earthstrike
    [21670] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 60, estimate = true, replace = true }, -- Badge of the Swarmguard
    [20130] = { ["ITEM_MOD_STRENGTH_SHORT"] = 60, estimate = true, replace = true },      -- Diamond Flask
    [19342] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30, estimate = true, replace = true }, -- Venomous Totem
    [11302] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 15, estimate = true, replace = true }, -- Uther's Strength

    -- Caster 
    [19379] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 70, estimate = true, replace = true }, -- Neltharion's Tear
    [12930] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 29, estimate = true, replace = true }, -- Briarwood Reed
    [18467] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 23, estimate = true, replace = true }, -- Royal Seal (Mage)
    [19336] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 39, estimate = true, replace = true }, -- Arcane Infused Gem
    [21566] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 20, estimate = true, replace = true }, -- Rune of Perfection
    [18820] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 39, estimate = true, replace = true }, -- Talisman of Ephemeral Power
    [19339] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 45, estimate = true, replace = true }, -- Mind Quickening Gem
    [19950] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 34, estimate = true, replace = true }, -- Zandalarian Hero Charm
    [21891] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 32, estimate = true, replace = true }, -- Shard of the Fallen Star
    [18646] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 40, estimate = true, replace = true }, -- The Black Book
    [11832] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 12, estimate = true, replace = true }, -- Burst of Knowledge
    [23001] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 20, estimate = true, replace = true }, -- Eye of Diminution
    [22268] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 20, ["ITEM_MOD_HEALING_POWER_SHORT"] = 18, estimate = true, replace = true }, -- Draconic Infused Emblem

    -- Healer 
    [19395] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 102, estimate = true, replace = true }, -- Rejuvenating Gem
    [23027] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 64, estimate = true, replace = true },  -- Warmth of Forgiveness
    [17064] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 64, estimate = true, replace = true },  -- Shard of the Scale
    [18371] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 45, estimate = true, replace = true },  -- Mindtap Talisman
    [18665] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 55, estimate = true, replace = true },  -- The Eye of Divinity
    [18466] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 44, estimate = true, replace = true },  -- Royal Seal (Druid)
    [18468] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 44, estimate = true, replace = true },  -- Royal Seal (Priest)
    [23047] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 135, estimate = true, replace = true }, -- Eye of the Dead
    [19288] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 70, estimate = true, replace = true },  -- Darkmoon Card: Blue Dragon
    [19344] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 65, estimate = true, replace = true },  -- Natural Alignment Crystal
    [11819] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 35, estimate = true, replace = true },  -- Second Wind
    [19990] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 32, estimate = true, replace = true },  -- Blessed Prayer Beads
    [21625] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 65, estimate = true, replace = true },  -- Scarab Brooch

    -- Tank
    [19431] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 25, ["ITEM_MOD_STAMINA_SHORT"] = 30, estimate = true, replace = true }, -- Styleen's
    [13966] = { ["ITEM_MOD_ARMOR_SHORT"] = 450, ["ITEM_MOD_DODGE_RATING_SHORT"] = 1, estimate = true, replace = true }, -- Mark of Tyranny
    [23040] = { ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 60, ["ITEM_MOD_ARMOR_SHORT"] = 300, estimate = true, replace = true }, -- Glyph of Deflection
    [21685] = { ["ITEM_MOD_STAMINA_SHORT"] = 50, estimate = true, replace = true }, -- Petrified Scarab
    [11811] = { ["ITEM_MOD_ARMOR_SHORT"] = 300, ["ITEM_MOD_STAMINA_SHORT"] = 15, estimate = true, replace = true }, -- Smoking Heart
    [18406] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 15, ["ITEM_MOD_PARRY_RATING_SHORT"] = 2, estimate = true, replace = true }, -- Onyxia Blood
    [11810] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 12, ["ITEM_MOD_STAMINA_SHORT"] = 10, estimate = true, replace = true }, -- Force of Will
    [17744] = { ["ITEM_MOD_DODGE_RATING_SHORT"] = 15, estimate = true, replace = true }, -- Vigilance Charm
    [18537] = { ["ITEM_MOD_PARRY_RATING_SHORT"] = 10, estimate = true, replace = true }, -- Counterattack
    [23558] = { ["ITEM_MOD_STAMINA_SHORT"] = 40, estimate = true, replace = true }, -- Burrower's Shell
    [21647] = { ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 40, ["ITEM_MOD_ARMOR_SHORT"] = 150, estimate = true, replace = true }, -- Chitinous Spikes
    [18815] = { ["ITEM_MOD_STAMINA_SHORT"] = 10, estimate = true, replace = true }, -- Pure Flame
    
    -- Lifegiving Gem
    [19341] = { percent_hp_value = 0.30, estimate = true, replace = true },
    -- Lifestone
    [833] = { ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 10, replace = true }, 

    -- PvP / Utility
    [1404]  = { ["ITEM_MOD_STAMINA_SHORT"] = 20, estimate = true, replace = true }, -- Tidal Charm
    [18638] = { ["ITEM_MOD_STAMINA_SHORT"] = 18, estimate = true, replace = true }, -- Reflectors
    [18639] = { ["ITEM_MOD_STAMINA_SHORT"] = 18, estimate = true, replace = true },
    [14557] = { ["ITEM_MOD_STAMINA_SHORT"] = 16, estimate = true, replace = true }, -- Stopwatch
    [17909] = { ["ITEM_MOD_STAMINA_SHORT"] = 14, estimate = true, replace = true }, -- Insignia
    [17904] = { ["ITEM_MOD_STAMINA_SHORT"] = 14, estimate = true, replace = true },
    [10577] = { ["ITEM_MOD_STAMINA_SHORT"] = 12, estimate = true, replace = true }, -- Mortar
    [10587] = { ["ITEM_MOD_STAMINA_SHORT"] = 10, estimate = true, replace = true }, -- Bomb Dispenser
    [21115] = { ["ITEM_MOD_STAMINA_SHORT"] = 8, estimate = true, replace = true },  -- Defiler's
    [11905] = { ["ITEM_MOD_STAMINA_SHORT"] = 8, estimate = true, replace = true },  -- Linken's
    
    -- [[ ⚠️ HYBRID / ADDITIVE (Scanner Stats + ~Bonus) ]]
    [22954] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 55, estimate = true }, -- Kiss of the Spider
    [23041] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 20, estimate = true }, -- Slayer's Crest
    [11815] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 22, estimate = true }, -- Hand of Justice
    [23046] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 26, estimate = true },  -- Essence of Sapphiron
}
-- =============================================================
-- 10. PRETTY NAMES (Translation Layer for UI)
-- =============================================================
MSC.PrettyNames = {
    ["WARRIOR"] = {
        ["FURY_2H"]         = "Raid: Arms/Fury (2H)",
        ["FURY_DW"]         = "Raid: Fury (Dual Wield)",
        ["ARMS_PVP"]        = "PvP: Arms (Mortal Strike)",
        ["ARMS_PVE"]        = "Raid: Arms (Blood Frenzy)",
        ["DEEP_PROT"]       = "Tank: Deep Protection",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Arms/2H (21-40)",
        ["Leveling_41_51"]      = "Leveling: Arms/2H (41-51)",
        ["Leveling_52_59"]      = "Leveling: Arms/2H (52-59)",
        ["Leveling_60_70"]      = "Leveling: Outland Arms/2H",
        
        ["Leveling_DW_21_40"]   = "Leveling: Fury DW (21-40)",
        ["Leveling_DW_41_51"]   = "Leveling: Fury DW (41-51)",
        ["Leveling_DW_52_59"]   = "Leveling: Fury DW (52-59)",
        ["Leveling_DW_60_70"]   = "Leveling: Outland Fury DW",

        ["Leveling_Tank_21_40"] = "Leveling: Prot/Dungeon (21-40)",
        ["Leveling_Tank_41_51"] = "Leveling: Prot/Dungeon (41-51)",
        ["Leveling_Tank_52_59"] = "Leveling: Prot/Dungeon (52-59)",
        ["Leveling_Tank_60_70"] = "Leveling: Outland Prot",
    },
    ["PALADIN"] = {
        ["HOLY_RAID"]       = "Healer: Holy (Illumination)",
        ["PROT_DEEP"]       = "Tank: Deep Protection",
        ["PROT_AOE"]        = "Farming: AoE Grinding (Strat)",
        ["RET_STANDARD"]    = "DPS: Retribution",
        ["SHOCKADIN_PVP"]   = "PvP: Shockadin",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Ret (21-40)",
        ["Leveling_41_51"]      = "Leveling: Ret (41-51)",
        ["Leveling_Ret_52_59"]  = "Leveling: Ret (52-59)",
        ["Leveling_60_70"]      = "Leveling: Outland Retribution",

        ["Leveling_Tank_52_59"] = "Leveling: Prot (52-59)",
        ["Leveling_Tank_60_70"] = "Leveling: Outland Protection",
        
        ["Leveling_Healer_52_59"] = "Leveling: Holy (52-59)",
        ["Leveling_Healer_60_70"] = "Leveling: Outland Holy",
    },
    ["HUNTER"] = {
        ["RAID_BM"]          = "Raid: Beast Mastery",
        ["RAID_SURV"]        = "Raid: Survival (Expose Weakness)",
        ["RAID_MM"]          = "Raid: Marksmanship",
        ["PVP_MM"]           = "PvP: Marksmanship",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Beast Mastery (21-40)",
        ["Leveling_41_51"]      = "Leveling: Beast Mastery (41-51)",
        ["Leveling_52_59"]      = "Leveling: Beast Mastery (52-59)",
        ["Leveling_60_70"]      = "Leveling: Outland Beast Mastery",

        ["Leveling_Melee_21_40"] = "Leveling: Survival Melee (21-40)",
        ["Leveling_Melee_41_51"] = "Leveling: Survival Melee (41-51)",
        ["Leveling_Melee_52_59"] = "Leveling: Survival Melee (52-59)",
        ["Leveling_Melee_60_70"] = "Leveling: Outland Survival Melee",
    },
    ["ROGUE"] = {
        ["RAID_COMBAT"]     = "Raid: Combat (Swords/Maces)",
        ["RAID_MUTILATE"]   = "Raid: Mutilate (Daggers)",
        ["PVP_SUBTLETY"]    = "PvP: Shadowstep / Hemo",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Combat (21-40)",
        ["Leveling_41_51"]      = "Leveling: Combat (41-51)",
        ["Leveling_52_59"]      = "Leveling: Combat (52-59)",
        ["Leveling_60_70"]      = "Leveling: Outland Combat",

        ["Leveling_Dagger_21_40"] = "Leveling: Dagger/Ambush (21-40)",
        ["Leveling_Dagger_41_51"] = "Leveling: Dagger/Ambush (41-51)",
        ["Leveling_Dagger_52_59"] = "Leveling: Dagger/Ambush (52-59)",
        ["Leveling_Dagger_60_70"] = "Leveling: Outland Mutilate",

        ["Leveling_Hemo_21_40"]   = "Leveling: Subtlety/Hemo (21-40)",
        ["Leveling_Hemo_41_51"]   = "Leveling: Subtlety/Hemo (41-51)",
        ["Leveling_Hemo_52_59"]   = "Leveling: Subtlety/Hemo (52-59)",
        ["Leveling_Hemo_60_70"]   = "Leveling: Outland Subtlety",
    },
    ["PRIEST"] = {
        ["HOLY_DEEP"]       = "Healer: Circle of Healing",
        ["DISC_SUPPORT"]    = "Healer: Discipline (Pain Supp)",
        ["SMITE_DPS"]       = "DPS: Smite (Holy Fire)",
        ["SHADOW_PVE"]      = "DPS: Shadow (Mana Battery)",
        ["SHADOW_PVP"]      = "PvP: Shadow",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Shadow/Wand (21-40)",
        ["Leveling_41_51"]      = "Leveling: Shadow (41-51)",
        ["Leveling_52_59"]      = "Leveling: Shadow (52-59)",
        ["Leveling_60_70"]      = "Leveling: Outland Shadow",

        ["Leveling_Smite_21_40"] = "Leveling: Smite/Holy (21-40)",
        ["Leveling_Smite_41_51"] = "Leveling: Smite/Holy (41-51)",
        ["Leveling_Smite_52_59"] = "Leveling: Smite/Holy (52-59)",
        ["Leveling_Smite_60_70"] = "Leveling: Outland Smite",

        ["Leveling_Healer_52_59"] = "Leveling: Holy Healer (52-59)",
        ["Leveling_Healer_60_70"] = "Leveling: Outland Holy Healer",
    },
    ["SHAMAN"] = {
        ["ELE_PVE"]         = "Raid: Elemental (Totem of Wrath)",
        ["ELE_PVP"]         = "PvP: Elemental (Burst)",
        ["ENH_PVE"]         = "Raid: Enhancement (Dual Wield)",
        ["RESTO_PVE"]       = "Healer: Chain Heal Spam",
		["SHAMAN_TANK"] 	= "Tank: Warden (Experimental)",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Enhancement (21-40)",
        ["Leveling_41_51"]      = "Leveling: Enhancement (41-51)",
        ["Leveling_52_59"]      = "Leveling: Enhancement (52-59)",
        ["Leveling_60_70"]      = "Leveling: Outland Enhancement",

        ["Leveling_Caster_52_59"] = "Leveling: Elemental (52-59)",
        ["Leveling_Caster_60_70"] = "Leveling: Outland Elemental",

        ["Leveling_Healer_52_59"] = "Leveling: Resto (52-59)",
        ["Leveling_Healer_60_70"] = "Leveling: Outland Resto",

        ["Leveling_Tank_21_40"]   = "Leveling: Shaman Tank (21-40)",
        ["Leveling_Tank_41_51"]   = "Leveling: Shaman Tank (41-51)",
        ["Leveling_Tank_52_59"]   = "Leveling: Shaman Tank (52-59)",
        ["Leveling_Tank_60_70"]   = "Leveling: Outland Shaman Tank",
    },
    ["MAGE"] = {
        ["FIRE_RAID"]       = "Raid: Deep Fire",
        ["ARCANE_RAID"]     = "Raid: Arcane (Mind Mastery)",
        ["FROST_PVE"]       = "Raid: Deep Frost (Winter's Chill)",
        ["FROST_PVP"]       = "PvP: Frost (Water Elemental)",
        ["FROST_AOE"]       = "Farming: AoE Blizzard",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Frost ST (21-40)",
        ["Leveling_41_51"]      = "Leveling: Frost ST (41-51)",
        ["Leveling_52_59"]      = "Leveling: Frost ST (52-59)",
        ["Leveling_60_70"]      = "Leveling: Outland Frost ST",

        ["Leveling_Fire_21_40"] = "Leveling: Fire (21-40)",
        ["Leveling_Fire_41_51"] = "Leveling: Fire (41-51)",
        ["Leveling_Fire_52_59"] = "Leveling: Fire (52-59)",
        ["Leveling_Fire_60_70"] = "Leveling: Outland Fire",

        ["Leveling_AoE_21_40"]  = "Leveling: AoE Grind (21-40)",
        ["Leveling_AoE_41_51"]  = "Leveling: AoE Grind (41-51)",
        ["Leveling_AoE_52_59"]  = "Leveling: AoE Grind (52-59)",
        ["Leveling_AoE_60_70"]  = "Leveling: Outland AoE Grind",
    },
    ["WARLOCK"] = {
        ["RAID_DESTRUCTION"] = "Raid: Destruction (Sacrifice)",
        ["RAID_AFFLICTION"]  = "Raid: Affliction (UA)",
        ["DEMO_PVE"]         = "Raid: Demonology (Felguard)",
        ["PVP_SL_SL"]        = "PvP: Soul Link / Siphon Life",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Affliction (21-40)",
        ["Leveling_41_51"]      = "Leveling: Affliction (41-51)",
        ["Leveling_52_59"]      = "Leveling: Affliction (52-59)",
        ["Leveling_60_70"]      = "Leveling: Outland Affliction",

        ["Leveling_Demo_21_40"] = "Leveling: Demonology (21-40)",
        ["Leveling_Demo_41_51"] = "Leveling: Demonology (41-51)",
        ["Leveling_Demo_52_59"] = "Leveling: Demonology (52-59)",
        ["Leveling_Demo_60_70"] = "Leveling: Outland Demonology",

        ["Leveling_Fire_21_40"] = "Leveling: Destro/Fire (21-40)",
        ["Leveling_Fire_41_51"] = "Leveling: Destro/Fire (41-51)",
        ["Leveling_Fire_52_59"] = "Leveling: Destro/Fire (52-59)",
        ["Leveling_Fire_60_70"] = "Leveling: Outland Destro",
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
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Feral Cat (21-40)",
        ["Leveling_41_51"]      = "Leveling: Feral Cat (41-51)",
        ["Leveling_52_59"]      = "Leveling: Feral Cat (52-59)",
        ["Leveling_60_70"]      = "Leveling: Outland Feral Cat",

        ["Leveling_Bear_21_40"] = "Leveling: Bear Tank (21-40)",
        ["Leveling_Bear_41_51"] = "Leveling: Bear Tank (41-51)",
        ["Leveling_Bear_52_59"] = "Leveling: Bear Tank (52-59)",
        ["Leveling_Bear_60_70"] = "Leveling: Outland Bear Tank",

        ["Leveling_Caster_41_51"] = "Leveling: Balance (41-51)",
        ["Leveling_Caster_52_59"] = "Leveling: Balance (52-59)",
        ["Leveling_Caster_60_70"] = "Leveling: Outland Balance",

        ["Leveling_Healer_52_59"] = "Leveling: Resto (52-59)",
        ["Leveling_Healer_60_70"] = "Leveling: Outland Resto",
    },
}
-- =============================================================
-- 12. ENCHANT DATABASE (ID Lookup)
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
    [3222] = { name = "Greater Agility (2H)", stats = { ITEM_MOD_AGILITY_SHORT = 35 } }, -- 2H Agi is stronger

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

    -- [[ SHIELD ]]
    [2655] = { name = "Major Stamina", stats = { ITEM_MOD_STAMINA_SHORT = 18 } },
    [2658] = { name = "Intellect", stats = { ITEM_MOD_INTELLECT_SHORT = 12 } },
    [2659] = { name = "Shield Block", stats = { ITEM_MOD_BLOCK_VALUE_SHORT = 15 } },
    [1071] = { name = "Lesser Stamina", stats = { ITEM_MOD_STAMINA_SHORT = 3 } }, 

    -- [[ HEAD (Glyphs) ]]
    [3012] = { name = "Glyph of Power (Sha'tar)", stats = { ITEM_MOD_SPELL_POWER_SHORT = 22, ITEM_MOD_HIT_SPELL_RATING_SHORT = 14 } },
    [3010] = { name = "Glyph of Ferocity (Cenarion)", stats = { ITEM_MOD_ATTACK_POWER_SHORT = 34, ITEM_MOD_HIT_RATING_SHORT = 16 } },
    [3013] = { name = "Glyph of the Defender (Keepers)", stats = { ITEM_MOD_DODGE_RATING_SHORT = 16, ITEM_MOD_BLOCK_VALUE_SHORT = 17 } },
    [3011] = { name = "Glyph of Renewal (Honor Hold)", stats = { ITEM_MOD_HEALING_POWER_SHORT = 35, ITEM_MOD_MANA_REGENERATION_SHORT = 7 } },
    [3003] = { name = "Glyph of the Gladiator", stats = { ITEM_MOD_STAMINA_SHORT = 18, ITEM_MOD_RESILIENCE_RATING_SHORT = 20 } },

    -- [[ SHOULDER (Inscriptions) ]]
    [3004] = { name = "Greater Inscription of the Orb", stats = { ITEM_MOD_SPELL_POWER_SHORT = 15, ITEM_MOD_CRIT_RATING_SHORT = 12 } },
    [3007] = { name = "Greater Inscription of Vengeance", stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30, ITEM_MOD_CRIT_RATING_SHORT = 10 } },
    [3009] = { name = "Greater Inscription of the Knight", stats = { ITEM_MOD_DODGE_RATING_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 15 } },
    [3005] = { name = "Greater Inscription of the Oracle", stats = { ITEM_MOD_HEALING_POWER_SHORT = 22, ITEM_MOD_MANA_REGENERATION_SHORT = 6 } },
    [2992] = { name = "Inscription of the Orb", stats = { ITEM_MOD_SPELL_POWER_SHORT = 12 } },
    [2998] = { name = "Inscription of Vengeance", stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26 } },

    -- [[ BACK ]]
    [2653] = { name = "Greater Agility", stats = { ITEM_MOD_AGILITY_SHORT = 12 } },
    [2662] = { name = "Spell Penetration", stats = { ITEM_MOD_SPELL_PENETRATION_SHORT = 20 } },
    [3296] = { name = "Steelweave", stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 12 } },
    [3294] = { name = "Major Armor", stats = { ITEM_MOD_ARMOR_SHORT = 120 } },
    [849]  = { name = "Lesser Agility", stats = { ITEM_MOD_AGILITY_SHORT = 3 } }, 
    [2502] = { name = "Greater Resistance", stats = { ITEM_MOD_RESISTANCE_ALL_SHORT = 5 } },

    -- [[ CHEST ]]
    [2661] = { name = "Exceptional Stats", stats = { ITEM_MOD_AGILITY_SHORT=6, ITEM_MOD_STRENGTH_SHORT=6, ITEM_MOD_INTELLECT_SHORT=6, ITEM_MOD_STAMINA_SHORT=6 } },
    [2653] = { name = "Major Health", stats = { ITEM_MOD_HEALTH_SHORT = 150 } },
    [3297] = { name = "Major Resilience", stats = { ITEM_MOD_RESILIENCE_RATING_SHORT = 15 } },
    [2657] = { name = "Restore Mana Prime", stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 6 } },
    [1891] = { name = "Greater Stats", stats = { ITEM_MOD_AGILITY_SHORT=4, ITEM_MOD_STRENGTH_SHORT=4, ITEM_MOD_INTELLECT_SHORT=4, ITEM_MOD_STAMINA_SHORT=4 } },
    [843]  = { name = "Minor Stats", stats = { ITEM_MOD_AGILITY_SHORT=1, ITEM_MOD_STRENGTH_SHORT=1, ITEM_MOD_INTELLECT_SHORT=1, ITEM_MOD_STAMINA_SHORT=1 } },

    -- [[ WRIST (Corrected IDs - NO MORE CLASH) ]]
    [2647] = { name = "Brawn", stats = { ITEM_MOD_STRENGTH_SHORT = 12 } }, 
    [2650] = { name = "Spellpower (Bracer)", stats = { ITEM_MOD_SPELL_POWER_SHORT = 15 } }, 
    [2651] = { name = "Major Healing (Bracer)", stats = { ITEM_MOD_HEALING_POWER_SHORT = 30 } }, 
    [2649] = { name = "Assault (Bracer)", stats = { ITEM_MOD_ATTACK_POWER_SHORT = 24 } }, 
    [2646] = { name = "Major Defense", stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 12 } },
    [2655] = { name = "Fortitude", stats = { ITEM_MOD_STAMINA_SHORT = 12 } }, 
    [1883] = { name = "Intellect +7", stats = { ITEM_MOD_INTELLECT_SHORT = 7 } },
    [1884] = { name = "Spirit +9", stats = { ITEM_MOD_SPIRIT_SHORT = 9 } },
    [905]  = { name = "Minor Strength", stats = { ITEM_MOD_STRENGTH_SHORT = 1 } },

    -- [[ HANDS (Corrected IDs - NO MORE CLASH) ]]
    [2562] = { name = "Superior Agility", stats = { ITEM_MOD_AGILITY_SHORT = 15 } }, 
    [2937] = { name = "Major Spellpower", stats = { ITEM_MOD_SPELL_POWER_SHORT = 20 } }, 
    [2935] = { name = "Major Healing", stats = { ITEM_MOD_HEALING_POWER_SHORT = 35 } }, 
    [2648] = { name = "Assault (Gloves)", stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26 } }, 
    [2613] = { name = "Threat", stats = { ITEM_MOD_HIT_RATING_SHORT = 10 } }, 
    [3246] = { name = "Blast", stats = { ITEM_MOD_SPELL_CRIT_RATING_SHORT = 10 } },
    [1886] = { name = "Agility +7", stats = { ITEM_MOD_AGILITY_SHORT = 7 } },

    -- [[ LEGS ]]
    [3154] = { name = "Runic Spellthread", stats = { ITEM_MOD_SPELL_POWER_SHORT = 35, ITEM_MOD_STAMINA_SHORT = 20 } },
    [3153] = { name = "Golden Spellthread", stats = { ITEM_MOD_HEALING_POWER_SHORT = 66, ITEM_MOD_STAMINA_SHORT = 20 } },
    [2953] = { name = "Nethercobra Leg Armor", stats = { ITEM_MOD_ATTACK_POWER_SHORT = 50, ITEM_MOD_CRIT_RATING_SHORT = 12 } },
    [2952] = { name = "Nethercleft Leg Armor", stats = { ITEM_MOD_STAMINA_SHORT = 40, ITEM_MOD_AGILITY_SHORT = 12 } },
    [2741] = { name = "Cobrahide Leg Armor", stats = { ITEM_MOD_ATTACK_POWER_SHORT = 40, ITEM_MOD_CRIT_RATING_SHORT = 10 } },
    [2427] = { name = "Mystic Spellthread", stats = { ITEM_MOD_SPELL_POWER_SHORT = 25, ITEM_MOD_STAMINA_SHORT = 15 } },

    -- [[ FEET ]]
    [2939] = { name = "Boar's Speed", stats = { ITEM_MOD_STAMINA_SHORT = 9, MSC_SPEED_BONUS = 8 } },
    [2656] = { name = "Cat's Swiftness", stats = { ITEM_MOD_AGILITY_SHORT = 6, MSC_SPEED_BONUS = 8 } },
    [3232] = { name = "Surefooted", stats = { ITEM_MOD_HIT_RATING_SHORT = 10, ITEM_MOD_CRIT_RATING_SHORT = 5 } }, 
    [2564] = { name = "Agility +7", stats = { ITEM_MOD_AGILITY_SHORT = 7 } },
    [911]  = { name = "Minor Agility", stats = { ITEM_MOD_AGILITY_SHORT = 1 } },

    -- [[ RINGS (Corrected IDs - NO MORE CLASH) ]]
    [2931] = { name = "Spellpower", stats = { ITEM_MOD_SPELL_POWER_SHORT = 12 } }, 
    [2933] = { name = "Healing Power", stats = { ITEM_MOD_HEALING_POWER_SHORT = 20 } }, 
    [2934] = { name = "Stats", stats = { ITEM_MOD_AGILITY_SHORT=4, ITEM_MOD_STRENGTH_SHORT=4, ITEM_MOD_INTELLECT_SHORT=4, ITEM_MOD_STAMINA_SHORT=4 } }, 
    [2629] = { name = "Striking", stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } },
}

-- =============================================================
-- 13. PROJECTION DATA: CANDIDATES (Synchronized with IDs)
-- =============================================================

MSC.EnchantCandidates = {
    -- HEAD (Glyphs)
    [1] = { 3012, 3010, 3013, 3011, 3003 },
    
    -- SHOULDER (Inscriptions)
    [3] = { 3004, 3007, 3009, 3005, 2992, 2998 },
    
    -- CHEST
    [5] = { 2661, 2653, 3297, 2657, 1891, 843 },
    
    -- LEGS (Spellthread / Armor Kits)
    [7] = { 3154, 3153, 2953, 2952, 2427, 2741 },
    
    -- FEET
    [8] = { 2939, 2656, 3232, 2564, 911 },
    
    -- WRIST
    [9] = { 2647, 2650, 2651, 2649, 2646, 2655, 1883, 1884, 905 },
    
    -- HANDS
    [10] = { 2562, 2937, 2935, 2648, 2613, 3246, 1886 },
    
    -- RINGS (Enchanters Only)
    [11] = { 2931, 2933, 2934, 2629 },
    [12] = { 2931, 2933, 2934, 2629 },
    
    -- BACK
    [15] = { 2653, 2662, 3296, 3294, 2502, 849 },
    
    -- MAIN HAND / WEAPON (Includes 2H)
    [16] = { 2673, 2674, 2675, 3225, 2669, 2642, 2671, 2666, 2667, 2668, 3222, 2621, 1897, 803, 1900, 2563, 1898, 2504, 2505, 943 },
    
    -- OFF HAND / SHIELD (Includes Shield-only + Weapon enchants)
    [17] = { 2655, 2658, 2659, 1071, 2673, 2674, 2675, 3225, 2669, 2642, 2666, 2668, 2621, 803 },
}

-- [[ LEVEL 1-69 (Budget / Classic) ]]
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
}

-- =============================================================
-- 14. PROJECTION DATA: GEM OPTIONS (Auto-Picker)
-- =============================================================
MSC.GemOptions = {
    -- [[ RARE (Level 70) ]]
    ["EMPTY_SOCKET_RED"] = {
        { stat="ITEM_MOD_STRENGTH_SHORT", val=8, name="Bold Living Ruby" },
        { stat="ITEM_MOD_AGILITY_SHORT", val=8, name="Delicate Living Ruby" },
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=9, name="Runed Living Ruby" },
        { stat="ITEM_MOD_HEALING_POWER_SHORT", val=18, name="Teardrop Living Ruby" },
        -- Hybrids
        { stat="ITEM_MOD_STRENGTH_SHORT", val=4, val2=4, stat2="ITEM_MOD_CRIT_RATING_SHORT", name="Inscribed Noble Topaz" },
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, val2=4, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", name="Potent Noble Topaz" },
    },
    ["EMPTY_SOCKET_YELLOW"] = {
        { stat="ITEM_MOD_CRIT_RATING_SHORT", val=8, name="Smooth Dawnstone" },
        { stat="ITEM_MOD_HIT_RATING_SHORT", val=8, name="Rigid Dawnstone" },
        { stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=8, name="Thick Dawnstone" },
        -- Hybrids
        { stat="ITEM_MOD_STRENGTH_SHORT", val=4, val2=4, stat2="ITEM_MOD_CRIT_RATING_SHORT", name="Inscribed Noble Topaz" },
    },
    ["EMPTY_SOCKET_BLUE"] = {
        { stat="ITEM_MOD_STAMINA_SHORT", val=12, name="Solid Star of Elune" },
        { stat="ITEM_MOD_SPIRIT_SHORT", val=10, name="Sparkling Star of Elune" },
        -- Hybrids
        { stat="ITEM_MOD_STRENGTH_SHORT", val=4, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Sovereign Nightseye" },
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Glowing Nightseye" },
    },
    ["EMPTY_SOCKET_META"] = {
        { stat="ITEM_MOD_AGILITY_SHORT", val=12, name="Relentless Earthstorm" },
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=14, name="Chaotic Skyfire" },
        { stat="ITEM_MOD_STAMINA_SHORT", val=18, name="Austere Earthstorm" },
    }
}

MSC.GemOptions_Leveling = {
    -- [[ GREEN (Budget) ]]
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
