local _, MSC = ...

-- =============================================================
-- 1. STAT WEIGHTS (Final Polish: Hybrid = PvP/Solo Mode)
-- =============================================================
MSC.WeightDB = {
    ["PALADIN"] = {
        ["Default"]     = { ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        ["Holy"]        = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Protection"]  = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        ["Retribution"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=1.2 },
        
        -- HYBRID (Shockadin / PvP / Reckoning)
        -- High Stamina + Mix of Spell Power (Burst) and Strength (Sustain)
        ["Hybrid"]      = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.4, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0 }, 
    },
    ["PRIEST"] = {
        ["Default"]    = { ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2 },
        ["Discipline"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Holy"]       = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Shadow"]     = { ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        
        -- HYBRID (Disc/Holy PvP)
        -- Survival (Stam) + Efficiency (Int/Spirit) + Raw Healing
        ["Hybrid"]     = { ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
    },
    ["DRUID"] = {
        ["Default"]     = { ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
		["Balance"]     = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 }, 
        ["FeralCombat"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
		["Restoration"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        
        -- HYBRID (Heart of the Wild / PvP)
        -- The ultimate "Jack of all Trades" stats
        ["Hybrid"]      = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0 },
        
        ["Tank"]        = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ARMOR_SHORT"]=2.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=0.8 },
    },
    ["SHAMAN"] = {
        ["Default"]     = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 },
        ["Elemental"]   = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.5 },
        ["Enhancement"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0 },
        ["Restoration"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        
        -- HYBRID (Ele/Enhance PvP)
        -- Big Crits + Big Shocks + Stamina
        ["Hybrid"]      = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        
        ["Tank"]        = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SHIELD_BLOCK_RATING_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 }
    },
    ["WARLOCK"] = {
        ["Default"]     = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
		["Affliction"]  = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.8 },
		["Demonology"]  = { ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5 },
		["Destruction"] = { ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        
		-- HYBRID (SL/SL or Soul Link PvP)
        -- Stamina is King.
        ["Hybrid"]      = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        
        ["Tank"]        = { ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"]=3.0, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0 },
    },
    ["MAGE"] = {
        ["Default"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5 },
        ["Arcane"]  = { ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Fire"]    = { ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
		["Frost"]   = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=3.0 },
        
        -- HYBRID (Elemental / PvP)
        -- High Stamina + Burst
        ["Hybrid"]  = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0 },
    },
    ["ROGUE"] = {
        ["Default"]       = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.6, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Assassination"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.6, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.2 },
        ["Combat"]        = { ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_STRENGTH_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0 },
        ["Subtlety"]      = { ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.0 },
        
        -- HYBRID (PvP / Stunlock)
        -- Agility (Dodge/Armor) + Stamina + Burst Crit
        ["Hybrid"]        = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 }, 
        
        ["Tank"]          = { ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_PARRY_RATING_SHORT"]=1.5 }
    },
    ["WARRIOR"] = {
        ["Default"]    = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Arms"]       = { ["ITEM_MOD_STRENGTH_SHORT"]=1.6, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, ["ITEM_MOD_AGILITY_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
        ["Fury"]       = { ["ITEM_MOD_STRENGTH_SHORT"]=1.4, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=0.9 },
        ["Protection"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=0.8, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8 },
        
        -- HYBRID (Arms PvP / Solo)
        -- High Stamina + High Crit (Burst) + Agility (Dodge/Crit)
        ["Hybrid"]     = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0 }, 
    },
    ["HUNTER"] = {
        ["Default"]      = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.4, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 },
        ["BeastMastery"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 },
        ["Marksmanship"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.6, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0 },
        ["Survival"]     = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 },
        
        -- HYBRID (PvP Survival / Solo)
        -- Survival (Stam) + Agility + Intellect (Mana for Traps/Shots)
        ["Hybrid"]       = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8 }, 
    },
}

-- 2. SPEC NAMES
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

-- 3. SHORT NAMES MAPPING
MSC.ShortNames = {
    ["ITEM_MOD_SPELL_HEALING_DONE"]       = "Healing",
    ["ITEM_MOD_HEALING_POWER_SHORT"]      = "Healing",
    ["ITEM_MOD_SPELL_POWER_SHORT"]        = "Spell Power",
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]  = "DPS",
    ["ITEM_MOD_POWER_REGEN0_SHORT"]       = "Mp5",
    ["ITEM_MOD_MANA_REGENERATION_SHORT"]  = "Mp5",
    ["ITEM_MOD_AGILITY_SHORT"]            = "Agility",
    ["ITEM_MOD_STRENGTH_SHORT"]           = "Strength",
    ["ITEM_MOD_INTELLECT_SHORT"]          = "Intellect",
    ["ITEM_MOD_SPIRIT_SHORT"]             = "Spirit",
    ["ITEM_MOD_STAMINA_SHORT"]            = "Stamina",
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = "Defense",
    ["ITEM_MOD_DODGE_RATING_SHORT"]       = "Dodge",
    ["ITEM_MOD_PARRY_RATING_SHORT"]       = "Parry",
    ["ITEM_MOD_BLOCK_RATING_SHORT"]       = "Block Chance",
    ["ITEM_MOD_HIT_RATING_SHORT"]         = "Hit",
    ["ITEM_MOD_CRIT_RATING_SHORT"]        = "Crit",
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]  = "Spell Crit",
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]   = "Spell Hit",
    ["ITEM_MOD_ATTACK_POWER_SHORT"]       = "Attack Power",
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = "Feral AP",
    ["ITEM_MOD_BLOCK_VALUE_SHORT"]        = "Block Value",
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]      = "Shadow Dmg",
    ["ITEM_MOD_FIRE_DAMAGE_SHORT"]        = "Fire Dmg",
    ["ITEM_MOD_FROST_DAMAGE_SHORT"]       = "Frost Dmg",
    ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]      = "Arcane Dmg",
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"]      = "Nature Dmg",
    ["ITEM_MOD_HOLY_DAMAGE_SHORT"]        = "Holy Dmg",
    ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"]  = "Shadow Res",
    ["ITEM_MOD_ARMOR_SHORT"]              = "Armor"
}

-- =============================================================
-- 4. ENCHANT DATABASE
-- =============================================================
MSC.EnchantDB = {
    -- === WEAPON ENCHANTS ===
    [2504] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 30 }, -- +30 Spell Power
    [2505] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 55 }, -- +55 Healing
    [2564] = { ["ITEM_MOD_AGILITY_SHORT"] = 15 },     -- +15 Agility
    [2563] = { ["ITEM_MOD_STRENGTH_SHORT"] = 15 },    -- +15 Strength
    [1900] = { ["ITEM_MOD_STRENGTH_SHORT"] = 100 },   -- Crusader (Avg Proc)
    [2565] = { ["ITEM_MOD_INTELLECT_SHORT"] = 22 },   -- +22 Intellect
    [1897] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30 }, -- +30 Attack Power (2H)
    [2503] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 7 }, -- +7 Defense (Cloak - Greater Defense)

    -- === ARMOR ENCHANTS ===
    [2621] = { ["ITEM_MOD_STAMINA_SHORT"] = 4, ["ITEM_MOD_STRENGTH_SHORT"] = 4, ["ITEM_MOD_AGILITY_SHORT"] = 4, ["ITEM_MOD_INTELLECT_SHORT"] = 4, ["ITEM_MOD_SPIRIT_SHORT"] = 4 }, -- Chest +4 Stats
    [2629] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 4 }, -- +4 MP5 (Bracer)
    
    -- === NAXXRAMAS (SAPPHIRON SHOULDER ENCHANTS) ===
    [2603] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 26, ["ITEM_MOD_CRIT_RATING_SHORT"] = 1 }, -- Might of the Scourge
    [2604] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 15, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1 }, -- Power of the Scourge
    [2605] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 33, ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 5 }, -- Resilience of the Scourge
    [2606] = { ["ITEM_MOD_STAMINA_SHORT"] = 16, ["ITEM_MOD_ARMOR_SHORT"] = 100 }, -- Fortitude of the Scourge

    -- === ZUL'GURUB (ZG) HEAD/LEG IDOLS ===
    -- Falcon's Call (Hunter)
    [2586] = { ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 24, ["ITEM_MOD_STAMINA_SHORT"] = 10, ["ITEM_MOD_HIT_RATING_SHORT"] = 1 }, 
    -- Death's Embrace (Rogue)
    [2585] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 28, ["ITEM_MOD_DODGE_RATING_SHORT"] = 1 },
    -- Presence of Might (Warrior)
    [2583] = { ["ITEM_MOD_STAMINA_SHORT"] = 10, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 7, ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 15 },
    -- Syncretist's Sigil (Paladin)
    [2584] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 24, ["ITEM_MOD_STAMINA_SHORT"] = 10, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 7 },
    -- Prophetic Aura (Priest)
    [2589] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 24, ["ITEM_MOD_STAMINA_SHORT"] = 10, ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 4 },
    -- Presence of Sight (Mage)
    [2587] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 18, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1 },
    -- Hoodoo Hex (Warlock)
    [2588] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 18, ["ITEM_MOD_STAMINA_SHORT"] = 10 },
    -- Vodouisant's Vigilant Embrace (Shaman)
    [2591] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 13, ["ITEM_MOD_INTELLECT_SHORT"] = 15 },
    -- Animist's Caress (Druid)
    [2590] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 24, ["ITEM_MOD_STAMINA_SHORT"] = 10, ["ITEM_MOD_INTELLECT_SHORT"] = 10 },

    -- === ZG EXALTED SHOULDERS ===
    [2607] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30 }, -- Zandalar Signet of Might
    [2608] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 18 },  -- Zandalar Signet of Mojo
    [2609] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 33 },-- Zandalar Signet of Serenity

    -- === DIRE MAUL / LIBRAMS ===
    [2443] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 8 },   -- Arcanum of Focus (Spell/Heal)
    [2543] = { ["ITEM_MOD_ATTACK_SPEED_SHORT"] = 1 },  -- Rapidity (1% Haste)
    [2544] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 8 }, -- Focus (Healing Alt)
    [2545] = { ["ITEM_MOD_DODGE_RATING_SHORT"] = 1 },  -- Protection (1% Dodge)
    [2488] = { ["ITEM_MOD_HEALTH_SHORT"] = 100 },      -- Constitution (100 HP)
    
    -- Voracity Librams
    [2483] = { ["ITEM_MOD_STRENGTH_SHORT"] = 8 },
    [2484] = { ["ITEM_MOD_STAMINA_SHORT"] = 8 },
    [2485] = { ["ITEM_MOD_AGILITY_SHORT"] = 8 },
    [2486] = { ["ITEM_MOD_INTELLECT_SHORT"] = 8 },
    [2487] = { ["ITEM_MOD_SPIRIT_SHORT"] = 8 },
} 

-- =============================================================
-- 5. RACIAL SYNERGIES
-- =============================================================
MSC.RacialTraits = {
    ["Human"]  = { ["Swords"] = true, ["Two-Handed Swords"] = true, ["Maces"] = true, ["Two-Handed Maces"] = true },
    ["Orc"]    = { ["Axes"] = true, ["Two-Handed Axes"] = true },
    ["Dwarf"]  = { ["Guns"] = true },
    ["Troll"]  = { ["Bows"] = true, ["Thrown"] = true },
}

-- =============================================================
-- 6. WEAPON SPEED PREFERENCES
-- =============================================================
MSC.SpeedChecks = {
    ["WARRIOR"] = { MH_Slow = true, OH_Fast = false },
    ["PALADIN"] = { MH_Slow = false, OH_Fast = false },
    ["ROGUE"]   = { MH_Slow = true, OH_Fast = true },
    ["HUNTER"]  = { Ranged_Slow = true }
}