local addonName, MSC = ...
local _G = _G 

-- [[ SPEED OPTIMIZATION: LOCALIZED FUNCTIONS ]]
local pairs, ipairs = pairs, ipairs
local tonumber, type = tonumber, type
local string_find, string_match, string_format, string_gsub, string_lower = string.find, string.match, string.format, string.gsub, string.lower
local table_insert = table.insert
local math_floor = math.floor
local pcall = pcall

local CreateFrame = CreateFrame
local WorldFrame = WorldFrame

MSC.Scanner = {}

-- =============================================================
-- 1. DATA MAPS (Shared Dictionaries)
-- =============================================================

MSC.Scanner.BaseStatMap = {
    -- Primary
    [MSC.L["strength"]] = "ITEM_MOD_STRENGTH_SHORT",
    [MSC.L["agility"]]  = "ITEM_MOD_AGILITY_SHORT",
    [MSC.L["stamina"]]  = "ITEM_MOD_STAMINA_SHORT",
    [MSC.L["intellect"]]= "ITEM_MOD_INTELLECT_SHORT",
    [MSC.L["spirit"]]   = "ITEM_MOD_SPIRIT_SHORT",
    
    -- Defensive / Weapon
    [MSC.L["armor"]] = "ITEM_MOD_ARMOR_SHORT",
    [MSC.L["block"]] = "ITEM_MOD_BLOCK_VALUE_SHORT",
    [MSC.L["block value"]] = "ITEM_MOD_BLOCK_VALUE_SHORT",
    [MSC.L["speed"]] = "MSC_WEAPON_SPEED",
    [MSC.L["damage per second"]] = "MSC_WEAPON_DPS",
    [MSC.L["dps"]] = "MSC_WEAPON_DPS",
    
    -- Resistances
    [MSC.L["shadow resistance"]] = "ITEM_MOD_SHADOW_RESISTANCE_SHORT",
    [MSC.L["fire resistance"]]    = "ITEM_MOD_FIRE_RESISTANCE_SHORT",
    [MSC.L["frost resistance"]]   = "ITEM_MOD_FROST_RESISTANCE_SHORT",
    [MSC.L["arcane resistance"]] = "ITEM_MOD_ARCANE_RESISTANCE_SHORT",
    [MSC.L["nature resistance"]] = "ITEM_MOD_NATURE_RESISTANCE_SHORT",
    
    -- Random Suffixes
    [MSC.L["attack power"]]    = "ITEM_MOD_ATTACK_POWER_SHORT", 
    [MSC.L["healing spells"]] = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
    [MSC.L["healing"]]        = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
    [MSC.L["spell damage"]]    = "ITEM_MOD_SPELL_POWER_SHORT",
    [MSC.L["spell power"]]     = "ITEM_MOD_SPELL_POWER_SHORT",
    [MSC.L["shadow damage"]]   = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    [MSC.L["fire damage"]]     = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    [MSC.L["frost damage"]]    = "ITEM_MOD_FROST_DAMAGE_SHORT",
    [MSC.L["arcane damage"]]   = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    [MSC.L["nature damage"]]   = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    [MSC.L["holy damage"]]     = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    [MSC.L["shadow spell damage"]] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    [MSC.L["fire spell damage"]]    = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    [MSC.L["frost spell damage"]]   = "ITEM_MOD_FROST_DAMAGE_SHORT",
    [MSC.L["arcane spell damage"]] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    [MSC.L["nature spell damage"]] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    [MSC.L["holy spell damage"]]    = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    [MSC.L["spell damage and healing"]] = "ITEM_MOD_SPELL_POWER_SHORT",  -- Fixes "of the Crusade", "of the Sorcerer"
    [MSC.L["damage and healing spells"]] = "ITEM_MOD_SPELL_POWER_SHORT", -- rare variation    
    -- Hunter / Range missing entries
    [MSC.L["ranged attack power"]] = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT", -- Critical for "of the Falcon" variants if they split stats
    [MSC.L["spell penetration"]] = "ITEM_MOD_SPELL_PENETRATION_SHORT",
    [MSC.L["all stats"]] = "ITEM_MOD_ALL_STATS_SHORT", -- "of the Ancestors" or generic buffs
    [MSC.L["magic resistance"]] = "ITEM_MOD_RESISTANCE_ALL_SHORT", -- "of Resistance" (rare white text)
    
	-- Resources
    [MSC.L["mana per 5 sec."]] = "ITEM_MOD_MANA_REGENERATION_SHORT",
    [MSC.L["mana per 5 sec"]] = "ITEM_MOD_MANA_REGENERATION_SHORT",
    [MSC.L["health per 5 sec."]] = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
    [MSC.L["health per 5 sec"]] = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
    [MSC.L["mana"]]            = "ITEM_MOD_MANA_SHORT",
    [MSC.L["health"]]          = "ITEM_MOD_HEALTH_SHORT",
    [MSC.L["hp"]]              = "ITEM_MOD_HEALTH_SHORT",
    [MSC.L["mp"]]              = "ITEM_MOD_MANA_SHORT",
    
    -- TBC Ratings
    [MSC.L["dodge rating"]]       = "ITEM_MOD_DODGE_RATING_SHORT",
    [MSC.L["parry rating"]]       = "ITEM_MOD_PARRY_RATING_SHORT",
    [MSC.L["block rating"]]       = "ITEM_MOD_BLOCK_RATING_SHORT",
    [MSC.L["hit rating"]]         = "ITEM_MOD_HIT_RATING_SHORT",
    [MSC.L["crit rating"]]        = "ITEM_MOD_CRIT_RATING_SHORT",
    [MSC.L["critical strike rating"]] = "ITEM_MOD_CRIT_RATING_SHORT",
    [MSC.L["haste rating"]]       = "ITEM_MOD_HASTE_RATING_SHORT",
    [MSC.L["resilience rating"]] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
    [MSC.L["defense rating"]]     = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    [MSC.L["expertise rating"]]   = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    [MSC.L["armor penetration rating"]] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"
}

-- [[ B. GREEN TEXT MAP (Equip / Use / Proc Effects) ]]
MSC.Scanner.TermMap = {
    -- [[ 1. OFFENSIVE RATINGS ]]
    [MSC.L["hit rating"]]         = "ITEM_MOD_HIT_RATING_SHORT",
    [MSC.L["chance to hit"]]      = "ITEM_MOD_HIT_RATING_SHORT", -- Era
    
    [MSC.L["critical strike rating"]] = "ITEM_MOD_CRIT_RATING_SHORT",
    [MSC.L["chance to get a critical strike"]] = "ITEM_MOD_CRIT_RATING_SHORT", -- Era
    
    [MSC.L["spell hit rating"]]   = "ITEM_MOD_HIT_SPELL_RATING_SHORT",
    [MSC.L["chance to hit with spells"]] = "ITEM_MOD_HIT_SPELL_RATING_SHORT", -- Era Long

    [MSC.L["spell critical strike rating"]] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT",
    [MSC.L["critical strike with spells"]] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT", -- Era
    [MSC.L["chance to get a critical strike with spells"]] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT", -- Era Long
    
    [MSC.L["haste rating"]]        = "ITEM_MOD_HASTE_RATING_SHORT",
    [MSC.L["spell haste rating"]] = "ITEM_MOD_SPELL_HASTE_RATING_SHORT",
    [MSC.L["spell penetration"]]   = "ITEM_MOD_SPELL_PENETRATION_SHORT",
    [MSC.L["magical resistances"]] = "ITEM_MOD_SPELL_PENETRATION_SHORT", -- Key for "Decreases" pattern
    [MSC.L["magical resistances of your spell targets"]] = "ITEM_MOD_SPELL_PENETRATION_SHORT", -- Era Long

    [MSC.L["armor penetration rating"]] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",
    [MSC.L["expertise rating"]]    = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    [MSC.L["ranged attack power"]] = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT",

    -- [[ 2. DEFENSIVE RATINGS ]]
    [MSC.L["defense rating"]]     = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    [MSC.L["increased defense"]] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", -- Era
    [MSC.L["defense"]]            = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    [MSC.L["dodge rating"]]       = "ITEM_MOD_DODGE_RATING_SHORT",
    [MSC.L["chance to dodge"]]    = "ITEM_MOD_DODGE_RATING_SHORT", -- Era
    [MSC.L["parry rating"]]       = "ITEM_MOD_PARRY_RATING_SHORT",
    [MSC.L["chance to parry"]]    = "ITEM_MOD_PARRY_RATING_SHORT", -- Era
    [MSC.L["block rating"]]       = "ITEM_MOD_BLOCK_RATING_SHORT",
    [MSC.L["chance to block"]]    = "ITEM_MOD_BLOCK_RATING_SHORT", -- Era
    [MSC.L["shield block value"]] = "ITEM_MOD_BLOCK_VALUE_SHORT",
    [MSC.L["the block value of your shield"]] = "ITEM_MOD_BLOCK_VALUE_SHORT", -- Era Long
    [MSC.L["resilience rating"]] = "ITEM_MOD_RESILIENCE_RATING_SHORT",

    -- [[ 3. RESISTANCES ]]
    [MSC.L["shadow resistance"]] = "ITEM_MOD_SHADOW_RESISTANCE_SHORT",
    [MSC.L["fire resistance"]]    = "ITEM_MOD_FIRE_RESISTANCE_SHORT",
    [MSC.L["frost resistance"]]   = "ITEM_MOD_FROST_RESISTANCE_SHORT",
    [MSC.L["arcane resistance"]] = "ITEM_MOD_ARCANE_RESISTANCE_SHORT",
    [MSC.L["nature resistance"]] = "ITEM_MOD_NATURE_RESISTANCE_SHORT",
    [MSC.L["all resistances"]]    = "ITEM_MOD_ALL_RESISTANCE_SHORT",
    [MSC.L["resistance to all schools of magic"]] = "ITEM_MOD_ALL_RESISTANCE_SHORT", 

    -- [[ 4. POWER STATS ]]
    [MSC.L["attack power"]]       = "ITEM_MOD_ATTACK_POWER_SHORT",
    [MSC.L["attack power in cat"]] = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
    [MSC.L["feral attack power"]]   = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
    [MSC.L["spell power"]]        = "ITEM_MOD_SPELL_POWER_SHORT",
    [MSC.L["healing"]]            = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
    [MSC.L["mana per 5 sec"]]     = "ITEM_MOD_MANA_REGENERATION_SHORT",
    [MSC.L["health per 5 sec"]]   = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
    
    -- [[ 5. ERA & TBC SPELL DAMAGE ]]
    [MSC.L["healing done by spells and effects"]] = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
    [MSC.L["healing done by magical spells and effects"]] = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
    
    [MSC.L["spell damage rating"]]            = "ITEM_MOD_SPELL_POWER_SHORT",
    [MSC.L["spell damage and healing"]]       = "ITEM_MOD_SPELL_POWER_SHORT",
    [MSC.L["damage done by magical spells and effects"]] = "ITEM_MOD_SPELL_POWER_SHORT",
    [MSC.L["damage and healing done by magical spells and effects"]] = "ITEM_MOD_SPELL_POWER_SHORT",
    [MSC.L["damage and healing done by magical spells and effects by up to"]] = "ITEM_MOD_SPELL_POWER_SHORT", 
    
    [MSC.L["damage done by shadow spells and effects"]] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    [MSC.L["damage done by fire spells and effects"]]   = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    [MSC.L["damage done by frost spells and effects"]]  = "ITEM_MOD_FROST_DAMAGE_SHORT",
    [MSC.L["damage done by arcane spells and effects"]] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    [MSC.L["damage done by nature spells and effects"]] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    [MSC.L["damage done by holy spells and effects"]]   = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    
    -- TBC Short Forms
    [MSC.L["shadow damage"]] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    [MSC.L["fire damage"]]    = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    [MSC.L["frost damage"]]   = "ITEM_MOD_FROST_DAMAGE_SHORT",
    [MSC.L["arcane damage"]] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    [MSC.L["nature damage"]] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    [MSC.L["holy damage"]]    = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    
    -- [[ 6. BASE STATS ]]
    [MSC.L["strength"]] = "ITEM_MOD_STRENGTH_SHORT",
    [MSC.L["agility"]]  = "ITEM_MOD_AGILITY_SHORT",
    [MSC.L["stamina"]]  = "ITEM_MOD_STAMINA_SHORT",
    [MSC.L["intellect"]]= "ITEM_MOD_INTELLECT_SHORT",
    [MSC.L["spirit"]]   = "ITEM_MOD_SPIRIT_SHORT",
    [MSC.L["armor"]]    = "ITEM_MOD_ARMOR_SHORT",
    [MSC.L["mana"]]     = "ITEM_MOD_MANA_SHORT",
    [MSC.L["health"]]   = "ITEM_MOD_HEALTH_SHORT",
    
    -- [[ 7. WEAPON SKILLS ]]
    [MSC.L["swords"]]    = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["axes"]]      = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["maces"]]     = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["daggers"]]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["bows"]]      = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["crossbows"]]= "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["guns"]]      = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["staves"]]    = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["polearms"]]    = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["two-handed swords"]] = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["two-handed axes"]]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["two-handed maces"]]  = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["skill with swords"]] = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["skill with axes"]]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["skill with maces"]]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["skill with bows"]]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["skill with guns"]]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["skill with daggers"]]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["skill with crossbows"]]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["skill with staves"]]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    [MSC.L["skill with polearms"]]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    
    -- [[ TBC: THE "RANGED" & "SHIELD" VARIANTS ]]
    [MSC.L["ranged critical strike rating"]] = "ITEM_MOD_CRIT_RATING_SHORT",
    [MSC.L["ranged hit rating"]]              = "ITEM_MOD_HIT_RATING_SHORT",
    [MSC.L["ranged haste rating"]]            = "ITEM_MOD_HASTE_RATING_SHORT",
    [MSC.L["shield block rating"]]            = "ITEM_MOD_BLOCK_RATING_SHORT",
    [MSC.L["shield block value"]]             = "ITEM_MOD_BLOCK_VALUE_SHORT",
    
    -- [[ TBC: PET STATS (Warlock/Hunter Trinkets & Set Bonuses) ]]
    [MSC.L["your pet's armor"]]               = "ITEM_MOD_ARMOR_SHORT", -- Handled loosely, but good to catch
    [MSC.L["your pet's attack power"]]        = "ITEM_MOD_ATTACK_POWER_SHORT",
    [MSC.L["your pet's damage"]]              = "ITEM_MOD_ATTACK_POWER_SHORT",
        
    -- [[ WEIRD / EDGE CASE CATCHERS ]]
    [MSC.L["all stats"]]                      = "ITEM_MOD_ALL_STATS_SHORT",
    [MSC.L["magic resistance"]]               = "ITEM_MOD_RESISTANCE_ALL_SHORT",
    [MSC.L["chance to resist mechanic mechanics"]] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
}

-- =============================================================
-- 2. PATTERN DATABASE (Merged)
-- =============================================================

MSC.Scanner.StatPatterns = {
    -- [[ 1. STANDARD PREFIX]]
    -- Catches: "+14 Spell Damage", "14 Strength", "+ 14 Intellect"
    { p = MSC.L["^[%+]?%s*(%d+%.?%d*)%s+(.-)[%s%.]*$"], valIdx = 1, nameIdx = 2 },

    -- [[ 2. STANDARD SUFFIX]]
    -- Catches: "Strength +14", "Agility 14", "Speed 2.80"
    { p = MSC.L["^(.-)%s+[%+:]?%s*(%d+%.?%d*)[%s%.]*$"], valIdx = 2, nameIdx = 1 },
    
    -- [[ 3. SHORT STATS ]]
    -- These specific strings don't need dictionary lookups
    { p = MSC.L["^(%d+) armor$"], valIdx = 1, fixedStat = "ITEM_MOD_ARMOR_SHORT" },
    { p = MSC.L["^(%d+) block$"], valIdx = 1, fixedStat = "ITEM_MOD_BLOCK_VALUE_SHORT" },

    -- [[ 4. WEAPON & DPS ]]
    { p = MSC.L["speed (%d+%.?%d*)"], valIdx = 1, fixedStat = "MSC_WEAPON_SPEED" },
    { p = MSC.L["^%((%d+%.?%d*) damage per second%)$"], valIdx = 1, fixedStat = "MSC_WEAPON_DPS" },
    { p = MSC.L["^%((%d+%.?%d*) dps%)$"], valIdx = 1, fixedStat = "MSC_WEAPON_DPS" },
    
    -- Range: Covers "100 - 200 Damage" and "100-200 Damage"
    { p = MSC.L["^(%d+)%s?[-~]%s?(%d+) damage$"], type="RANGE" },
    
    -- [[ 5. ENCHANT/SCOPE FORMATS ]]
    { p = MSC.L["scope %([%+:]*(%d+) (.*)%)"], valIdx = 1, nameIdx = 2 },
    { p = MSC.L["enchant:? [%+:]*(%d+) (.*)"], valIdx = 1, nameIdx = 2 },
	
	-- [[ 6. SPLIT ENCHANTS ]]
    { p = MSC.L["(%d+) hit rating and .*snare"], valIdx = 1, fixedStat = "ITEM_MOD_HIT_RATING_SHORT" },
}

MSC.Scanner.EquipPatterns = {
    -- ========================================================================
    -- [[ 1. SPECIALIZED OVERRIDES (Higher Priority / Lazy Matching) ]]
    -- ========================================================================
    
    -- [[ HYBRID HEAL/DAMAGE SPLIT (Must be at the absolute top!) ]]
    { p = MSC.L["healing.-(%d+).-damage.-(%d+)"], 
      func = function(heal, dmg, _, outputStats) 
          if outputStats then
              outputStats["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = (outputStats["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0) + tonumber(heal)
              outputStats["ITEM_MOD_SPELL_POWER_SHORT"] = (outputStats["ITEM_MOD_SPELL_POWER_SHORT"] or 0) + tonumber(dmg)
          end
      end 
    },
    
    -- [[ CASTING STATS ]]
    { p = MSC.L["damage and healing.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_POWER_SHORT" },
    { p = MSC.L["damage done by magical.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_POWER_SHORT" },
    { p = MSC.L["damage done by spells.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_POWER_SHORT" },
    { p = MSC.L["spell damage.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_POWER_SHORT" },
    { p = MSC.L["spell power.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_POWER_SHORT" },
    { p = MSC.L["healing done.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_HEALING_DONE_SHORT" },
    { p = MSC.L["healing.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_HEALING_DONE_SHORT" },
    { p = MSC.L["spell penetration.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_PENETRATION_SHORT" },

    -- [[ RESOURCES (MP5 / HP5) ]]
    { p = MSC.L["mana per 5.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
    { p = MSC.L["health per 5.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
    { p = MSC.L["restores (%d+) mana"], valIdx = 1, fixedStat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
    { p = MSC.L["restores (%d+) health"], valIdx = 1, fixedStat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },

    -- [[ HIT & CRIT (Spell/Ranged MUST be checked before Melee) ]]
    { p = MSC.L["spell hit.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
    { p = MSC.L["hit with spells.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
    { p = MSC.L["ranged hit.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_HIT_RATING_SHORT" }, 
    { p = MSC.L["hit rating.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_HIT_RATING_SHORT" },
    { p = MSC.L["chance to hit.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_HIT_RATING_SHORT" }, -- Era

    { p = MSC.L["spell critical.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
    { p = MSC.L["spell crit.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
    { p = MSC.L["critical strike with spells.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
    { p = MSC.L["ranged critical.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_CRIT_RATING_SHORT" },
    { p = MSC.L["ranged crit.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_CRIT_RATING_SHORT" },
    { p = MSC.L["critical strike rating.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_CRIT_RATING_SHORT" },
    { p = MSC.L["critical strike.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_CRIT_RATING_SHORT" }, -- Era

    -- [[ HASTE ]]
    { p = MSC.L["spell haste.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SPELL_HASTE_RATING_SHORT" },
    { p = MSC.L["ranged haste.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_HASTE_RATING_SHORT" },
    { p = MSC.L["haste rating.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_HASTE_RATING_SHORT" },

    -- [[ ATTACK POWER (Feral/Ranged MUST be checked before General) ]]
    { p = MSC.L["ranged attack power.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" },
    { p = MSC.L["feral attack power.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },
	{ p = MSC.L["attack power.-(%d+).-in cat"], valIdx = 1, fixedStat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },
    { p = MSC.L["attack power in cat.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" }, -- Era forms
    { p = MSC.L["attack power.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_ATTACK_POWER_SHORT" },

    -- [[ MELEE & TANKING ]]
    { p = MSC.L["expertise rating.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_EXPERTISE_RATING_SHORT" },
    { p = MSC.L["armor penetration.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" },
    { p = MSC.L["block value.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_BLOCK_VALUE_SHORT" }, 
    { p = MSC.L["block rating.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_BLOCK_RATING_SHORT" },
    { p = MSC.L["chance to block.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_BLOCK_RATING_SHORT" }, -- Era
    { p = MSC.L["defense rating.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
    { p = MSC.L["increased defense.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" }, -- Era
    { p = MSC.L["dodge rating.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_DODGE_RATING_SHORT" },
    { p = MSC.L["chance to dodge.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_DODGE_RATING_SHORT" }, -- Era
    { p = MSC.L["parry rating.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_PARRY_RATING_SHORT" },
    { p = MSC.L["chance to parry.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_PARRY_RATING_SHORT" }, -- Era
    { p = MSC.L["resilience.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_RESILIENCE_RATING_SHORT" },

    -- [[ ELEMENTAL DAMAGE ]]
    { p = MSC.L["shadow damage.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_SHADOW_DAMAGE_SHORT" },
    { p = MSC.L["fire damage.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_FIRE_DAMAGE_SHORT" },
    { p = MSC.L["frost damage.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_FROST_DAMAGE_SHORT" },
    { p = MSC.L["arcane damage.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_ARCANE_DAMAGE_SHORT" },
    { p = MSC.L["nature damage.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_NATURE_DAMAGE_SHORT" },
    { p = MSC.L["holy damage.-(%d+)"], valIdx = 1, fixedStat = "ITEM_MOD_HOLY_DAMAGE_SHORT" },

    -- ========================================================================
    -- [[ 2. COMPLEX / LOGIC PATTERNS (Cannot be Lazy) ]]
    -- ========================================================================

    -- [[ HYBRID HEAL/DAMAGE SPLIT (e.g. "Whitemend") ]]
    { p = MSC.L["healing.-up to (%d+).-damage.-up to (%d+)"], 
      func = function(heal, dmg, _, outputStats) 
          if outputStats then
              outputStats["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = (outputStats["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0) + tonumber(heal)
              outputStats["ITEM_MOD_SPELL_POWER_SHORT"] = (outputStats["ITEM_MOD_SPELL_POWER_SHORT"] or 0) + tonumber(dmg)
          end
      end 
    },

    -- [[ WEAPON DAMAGE (Scopes, Rings) ]]
    { p = MSC.L["adds (%d+) weapon damage"], valIdx = 1, fixedStat = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
    { p = MSC.L["adds (%d+) damage"], valIdx = 1, fixedStat = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },

    -- [[ PERCENTAGE MODS (e.g. "1% Hit") ]]
    -- Caught here to prevent "1 Hit" being read as Rating
    { p = MSC.L["improves your (.*) by (%d+)%%%.?"], valIdx = 2, nameIdx = 1, isPercent = true }, 
    { p = MSC.L["increases your (.*) by (%d+)%%%.?"], valIdx = 2, nameIdx = 1, isPercent = true }, 
    { p = MSC.L["increases (.*) by (%d+)%%%.?"], valIdx = 2, nameIdx = 1, isPercent = true },

    -- [[ GENERIC FALLBACKS (The "Standard" Parser) ]]
    -- Catches standard strings: "Increases Strength by 10"
    { p = MSC.L["improves your (.*) by (%d+)%.?"], valIdx = 2, nameIdx = 1 }, 
    { p = MSC.L["improves (.*) by (%d+)%.?"], valIdx = 2, nameIdx = 1 }, 
    { p = MSC.L["increases your (.*) by (%d+)%.?"], valIdx = 2, nameIdx = 1 }, 
    { p = MSC.L["increases (.*) by up to (%d+)%.?"], valIdx = 2, nameIdx = 1 },
    { p = MSC.L["increases (.*) by (%d+)%.?"], valIdx = 2, nameIdx = 1 },

    -- [[ SHORT FORM (Green Text) ]]
    -- Catches: "+10 Strength" or "Strength +10"
    { p = MSC.L["^%+?%s*(%d+)%%? (.*)$"], valIdx = 1, nameIdx = 2 },
    { p = MSC.L["^(.-) %+(%d+)%%?$"], valIdx = 2, nameIdx = 1 },
}

MSC.Scanner.ProcPatterns = {
    -- Buffs
    { p = MSC.L["^%+(%d+) (.*) for (%d+) sec"], valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = MSC.L["grants (%d+) (.*) for (%d+) sec"], valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = MSC.L["gain (%d+) (.*) for (%d+) sec"], valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = MSC.L["increases (.*) by (%d+) for (%d+) sec"], valIdx=2, nameIdx=1, durIdx=3, type="BUFF" },
    { p = MSC.L["increases your (.*) by (%d+)$"], valIdx=2, nameIdx=1, type="BUFF", defaultDur=10 },
    { p = MSC.L["chance on melee or ranged hit to gain (%d+) (.*) for (%d+) sec"], valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = MSC.L["chance on spell critical hit to gain (%d+) (.*) for (%d+) sec"], valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = MSC.L["chance on spell cast to gain (%d+) (.*) for (%d+) sec"], valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },    

    -- Damage Procs
    { p = MSC.L["for (%d+) to (%d+) .*damage"], type="DAMAGE" },
    { p = MSC.L["inflicts (%d+) to (%d+) .*damage"], type="DAMAGE" },
    { p = MSC.L["for (%d+) .*damage"], type="DAMAGE" },
    { p = MSC.L["inflicts (%d+) .*damage"], type="DAMAGE" },
    { p = MSC.L["deals (%d+) .*damage"], type="DAMAGE" },
    { p = MSC.L["blasts (.*) for (%d+)"], valIdx=2, type="DAMAGE" },
    { p = MSC.L["chance to strike your enemy for (%d+) to (%d+) .*damage"], type="DAMAGE" },
    { p = MSC.L["chance to blast your target for (%d+) to (%d+) .*damage"], type="DAMAGE" },

    -- Resources
    { p = MSC.L["steals (%d+) life"], type="HEAL" },
    { p = MSC.L["restores (%d+) mana"], type="MANA" },
    { p = MSC.L["restores (%d+) health"], type="HEAL" },
    
    -- Catch All
    { p = MSC.L["blasts your enemy"], type="GENERIC" }
}

MSC.Scanner.UsePatterns = {
    -- Short Forms
    { p = MSC.L["^%+(%d+) (.*) for (%d+) sec"], valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = MSC.L["^%+(%d+) (.*)$"], valIdx=1, nameIdx=2, type="BUFF", defaultDur=15 },

    -- Verbs
    { p = MSC.L["grants (%d+) (.*) for (%d+) sec"], valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = MSC.L["gain (%d+) (.*) for (%d+) sec"], valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = MSC.L["increases (.*) by up to (%d+) for (%d+) sec"], valIdx=2, nameIdx=1, durIdx=3, type="BUFF" },
    { p = MSC.L["increases (.*) by (%d+) for (%d+) sec"], valIdx=2, nameIdx=1, durIdx=3, type="BUFF" },

    -- Resources
    { p = MSC.L["restores (%d+) to (%d+) mana"], type="MANA_RANGE" },
    { p = MSC.L["restores (%d+) to (%d+) health"], type="HEALTH_RANGE" },
    { p = MSC.L["restores (%d+) mana"], valIdx=1, type="MANA" },
    { p = MSC.L["restores (%d+) health"], valIdx=1, type="HEALTH" },

    -- Misc
    { p = MSC.L["adds (%d+) damage"], valIdx=1, fixedStat="ITEM_MOD_DAMAGE_PER_SECOND_SHORT", type="BUFF", defaultDur=15 }
}
-- =============================================================
-- 3. UTILITIES
-- =============================================================

local function CreateItemObject()
    return { 
        Stats = {}, UseEffects = {}, Procs = {}, 
        Meta = { 
            SetName=nil, SetCount=0, SetTotal=0, Sockets={}, SocketBonusActive=false, BonusStats={} 
        } 
    }
end

local function ParseCooldown(text)
    local lowerText = string_lower(text)
    local min = string_match(lowerText, MSC.L["%((%d+)%s*min[s%a]*%s*cooldown%)"] or "%((%d+)%s*min[s%a]*%s*cooldown%)")
	if min then return tonumber(min) * 60 end
	local sec = string_match(lowerText, MSC.L["%((%d+)%s*sec[s%a]*%s*cooldown%)"] or "%((%d+)%s*sec[s%a]*%s*cooldown%)")
    if sec then return tonumber(sec) end
    return 120 
end

function MSC.Scanner.ClassifyLine(text)
    if not text or text == "" then return "SKIP" end
    local lower = string_lower(text)

    -- [[ OPTIMIZATION: SIMPLE CHECKS FIRST ]]
	if string_find(lower, MSC.L["chance on"]) then return "PROC" end
    if string_find(lower, MSC.L["equip"]) then return "EQUIP" end
    if string_find(lower, MSC.L["use:"]) then return "USE" end
    if string_find(lower, MSC.L["set:"]) then return "SET" end
    if string_find(lower, MSC.L["socket"]) then 
        if string_find(lower, MSC.L["bonus"]) then return "SOCKET_BONUS" else return "SOCKET_INFO" end
    end
    
    -- Clean text for Stat Checks
    local cleanText = string_gsub(string_gsub(lower, "|c%x%x%x%x%x%x%x%x", ""), "|r", "")
    if string_find(cleanText, "%d") then return "STAT" end
    
    return "FLUFF"
end

-- =============================================================
-- 4. SUB-PARSERS
-- =============================================================

function MSC.Scanner.ParseSetHeader(text, metaTable)
    local cleanText = string_gsub(string_gsub(text, "|c%x%x%x%x%x%x%x%x", ""), "|r", "")
    local setName, current, total = string_match(cleanText, MSC.L["^(.*)%s+%(?(%d+)/(%d+)%)?$"])
    if setName then 
        metaTable.SetName = string_gsub(setName, "^%s*(.-)%s*$", "%1")
        metaTable.SetCount = tonumber(current)
        metaTable.SetTotal = tonumber(total)
        return true
    end
end

function MSC.Scanner.ParseEquipLine(text, outputStats, outputProcs)
    local cleanText = string_gsub(string_gsub(string_gsub(string_gsub(string_lower(text), "|c%x%x%x%x%x%x%x%x", ""), "|r", ""), "\n", " "), MSC.L["^equip: "], "")
    cleanText = string_gsub(string_gsub(cleanText, "%s+", " "), MSC.L["^%s*equip:%s*"], "")
    
    for _, pat in ipairs(MSC.Scanner.EquipPatterns) do
        local match1, match2, match3 = string_match(cleanText, pat.p)
        if match1 then
            if pat.func then pat.func(match1, match2, match3, outputStats); return end

            local val = tonumber(pat.valIdx == 1 and match1 or match2)
            local name = pat.nameIdx and (pat.nameIdx == 1 and match1 or match2)

            if val and pat.isPercent and MSC.IsTBC then
                local mult = 15.8 
                if name then
                    if string_find(name, MSC.L["spell"]) then 
                        mult = (string_find(name, MSC.L["hit"]) and 12.6 or 22.1)
                    elseif string_find(name, MSC.L["crit"]) then 
                        mult = 22.1
                    elseif string_find(name, MSC.L["speed"]) or string_find(name, MSC.L["haste"]) then 
                        mult = 15.8
                    end
                end
                val = val * mult
            end

            if pat.fixedStat then
                outputStats[pat.fixedStat] = (outputStats[pat.fixedStat] or 0) + (val or 1)
                return
            elseif val and name then
                local cleanName = string_gsub(string_gsub(name, "your ", ""), "%s+$", "")
                local key = MSC.Scanner.TermMap[cleanName]
                if key then outputStats[key] = (outputStats[key] or 0) + val; return end
            end
        end
    end
    if outputProcs then table_insert(outputProcs, { type = "Equip", desc = text }) end
end

function MSC.Scanner.ParseStatLine(text, outputTable)
    if not text then return end

    local cleanText = string_lower(text)
    cleanText = string_gsub(cleanText, "|c%x%x%x%x%x%x%x%x", "")
    cleanText = string_gsub(cleanText, "|r", "")
    
    -- [[ STRIP SOCKET BONUS PREFIX ]]
    -- This allows the scanner to read "+4 Strength" instead of "Socket Bonus: +4 Strength"
    cleanText = string_gsub(cleanText, "^socket bonus:%s*", "")
    
    -- [[ 1. INTERCEPT NAMED, PROC & HYBRID ENCHANTS ]]
    if string_find(cleanText, "^enchant: ") then
        
        -- A. Proc Averages (Uptime Math)
        if string_find(cleanText, "mongoose") then
            outputTable["ITEM_MOD_AGILITY_SHORT"] = (outputTable["ITEM_MOD_AGILITY_SHORT"] or 0) + 30
            outputTable["ITEM_MOD_HASTE_RATING_SHORT"] = (outputTable["ITEM_MOD_HASTE_RATING_SHORT"] or 0) + 30
            return
        elseif string_find(cleanText, "executioner") then
            outputTable["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = (outputTable["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] or 0) + 210
            return
        elseif string_find(cleanText, "crusader") then
            outputTable["ITEM_MOD_STRENGTH_SHORT"] = (outputTable["ITEM_MOD_STRENGTH_SHORT"] or 0) + 25
            return
        elseif string_find(cleanText, "spellsurge") then
            outputTable["ITEM_MOD_MANA_REGENERATION_SHORT"] = (outputTable["ITEM_MOD_MANA_REGENERATION_SHORT"] or 0) + 15
            return
            
        -- B. Flat Named Enchants
        elseif string_find(cleanText, "sunfire") then
            outputTable["ITEM_MOD_FIRE_DAMAGE_SHORT"] = (outputTable["ITEM_MOD_FIRE_DAMAGE_SHORT"] or 0) + 50
            outputTable["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = (outputTable["ITEM_MOD_ARCANE_DAMAGE_SHORT"] or 0) + 50
            return
        elseif string_find(cleanText, "soulfrost") then
            outputTable["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = (outputTable["ITEM_MOD_SHADOW_DAMAGE_SHORT"] or 0) + 54
            outputTable["ITEM_MOD_FROST_DAMAGE_SHORT"] = (outputTable["ITEM_MOD_FROST_DAMAGE_SHORT"] or 0) + 54
            return
        elseif string_find(cleanText, "savagery") then
            outputTable["ITEM_MOD_ATTACK_POWER_SHORT"] = (outputTable["ITEM_MOD_ATTACK_POWER_SHORT"] or 0) + 70
            return
            
        -- C. Weird Word-Only Enchants
        elseif string_find(cleanText, "speed and") then
            local val, stat = string_match(cleanText, "speed and %+(%d+) (.*)")
            if val and stat then
                local cleanName = string_gsub(stat, "[%s%.]+$", "")
                local key = MSC.Scanner.BaseStatMap[cleanName]
                if key then 
                    outputTable[key] = (outputTable[key] or 0) + tonumber(val)
                    return 
                end
            end
        end
    end

    -- [[ THE DUAL-STAT SPLITTER ]]
    -- If a line has "and" (but isn't standard spell damage), split it into two lines and process both!
    if string_find(cleanText, " and ") and not string_find(cleanText, "damage and healing") then
        local part1, part2 = string_match(cleanText, "^(.-) and (.*)$")
        if part1 and part2 then
            -- Recursively pass both halves back through the scanner individually!
            MSC.Scanner.ParseStatLine(part1, outputTable)
            MSC.Scanner.ParseStatLine(part2, outputTable)
            return
        end
    end
	
	-- [[ ALL STATS EXPLODER ]]
    -- Instantly breaks "+X All Stats" into the big 5 attributes
    if string_find(cleanText, "all stats") then
        local val = tonumber(string_match(cleanText, "%d+"))
        if val then
            outputTable["ITEM_MOD_STRENGTH_SHORT"]  = (outputTable["ITEM_MOD_STRENGTH_SHORT"] or 0) + val
            outputTable["ITEM_MOD_AGILITY_SHORT"]   = (outputTable["ITEM_MOD_AGILITY_SHORT"] or 0) + val
            outputTable["ITEM_MOD_STAMINA_SHORT"]   = (outputTable["ITEM_MOD_STAMINA_SHORT"] or 0) + val
            outputTable["ITEM_MOD_INTELLECT_SHORT"] = (outputTable["ITEM_MOD_INTELLECT_SHORT"] or 0) + val
            outputTable["ITEM_MOD_SPIRIT_SHORT"]    = (outputTable["ITEM_MOD_SPIRIT_SHORT"] or 0) + val
            return
        end
    end

    -- [[ OPTIMIZATION: DIGIT CHECK ]]
    if not string_find(text, "%d") then return end
    
    cleanText = string_gsub(cleanText, "|t.-|t", "") 
    cleanText = string_gsub(cleanText, "\194\160", " ") 
    cleanText = string_gsub(cleanText, "\160", " ") 
    cleanText = string_gsub(cleanText, "%s+", " ")
    cleanText = string_match(cleanText, "^%s*(.-)%s*$")
    
    for _, pat in ipairs(MSC.Scanner.StatPatterns) do
        local m1, m2, m3 = string_match(cleanText, pat.p)
        if m1 then
            if pat.type == "RANGE" then
                outputTable["MSC_DAMAGE_RANGE_MIN"] = tonumber(m1)
                outputTable["MSC_DAMAGE_RANGE_MAX"] = tonumber(m2)
                return
            elseif pat.fixedStat then
                local val = tonumber(m1)
                if val then 
                    outputTable[pat.fixedStat] = (outputTable[pat.fixedStat] or 0) + val; 
                    return 
                end
            else
                local val = tonumber(pat.valIdx == 1 and m1 or m2)
                local name = pat.valIdx == 1 and m2 or m1
                if val and name then
                    local cleanName = string_gsub(string_gsub(name, MSC.L["^to "], ""), "[%s%.]+$", "")
                    local key = MSC.Scanner.BaseStatMap[cleanName]
                    if not key and cleanName == MSC.L["armor"] then key = "ITEM_MOD_ARMOR_SHORT" end
                    
                    if key then 
                        outputTable[key] = (outputTable[key] or 0) + val; 
                        return 
                    end
                end
            end
        end
    end
end

function MSC.Scanner.ParseProcLine(text, outputProcs)
    local cleanText = string_gsub(string_gsub(string_gsub(string_gsub(string_lower(text), "|c%x%x%x%x%x%x%x%x", ""), "|r", ""), "\n", " "), "%s+", " ")
    cleanText = string_gsub(string_gsub(cleanText, MSC.L["^chance on hit: "], ""), MSC.L["^equip: chance on hit: "], "")

    for _, pat in ipairs(MSC.Scanner.ProcPatterns) do
        local m1, m2, m3 = string_match(cleanText, pat.p)
        if m1 then
            local procObj = { description = text }
            if pat.type == "DAMAGE" then
                procObj.type = "Damage"
                local valStr = (pat.valIdx == 2) and m2 or m1
                procObj.val = tonumber(valStr) or 0
                if m2 and not pat.valIdx then 
                    local maxVal = tonumber(m2) or 0
                    procObj.val = (procObj.val + maxVal) / 2 
                end
            elseif pat.type == "HEAL" or pat.type == "MANA" then
                procObj.type = pat.type
                procObj.val = tonumber(m1)
            elseif pat.valIdx then
                procObj.type = "Stat"
                procObj.val = tonumber(m2)
                procObj.duration = tonumber(m3)
                procObj.statName = m1 
            else 
                procObj.type = "Generic" 
            end
            table_insert(outputProcs, procObj)
            return
        end
    end
    table_insert(outputProcs, { type = "Unknown", description = text })
end

function MSC.Scanner.ParseUseLine(text, outputUseTable)
    local cleanText = string_gsub(string_gsub(string_gsub(string_gsub(string_gsub(string_lower(text), "|c%x%x%x%x%x%x%x%x", ""), "|r", ""), "\n", " "), "%s+", " "), MSC.L["^use: "], "")
    local cooldown = ParseCooldown(text)
    
    for _, pat in ipairs(MSC.Scanner.UsePatterns) do
        local m1, m2, m3 = string_match(cleanText, pat.p)
        if m1 then
            local effect = { raw = text, cooldown = cooldown }
            if pat.type == "BUFF" then
                local val = tonumber(pat.valIdx == 1 and m1 or m2)
                local name = pat.nameIdx and (pat.nameIdx == 1 and m1 or m2)
                
                if not val then return end

                local duration = tonumber(m3) or pat.defaultDur or 15
                effect.averageVal = val * (duration / cooldown)
                effect.duration = duration
                
                if pat.fixedStat then 
                    effect.statKey = pat.fixedStat
                elseif name then
                    local cleanName = string_gsub(string_gsub(name, "your ", ""), "%s+$", "")
                    effect.statKey = MSC.Scanner.TermMap[cleanName]
                end
                effect.type = "Stat"
            elseif pat.type == "MANA" or pat.type == "HEALTH" or pat.type == "MANA_RANGE" or pat.type == "HEALTH_RANGE" then
                local val = tonumber(m1)
                if m2 then val = (val + tonumber(m2)) / 2 end
                effect.statKey = string_find(pat.type, "MANA") and "ITEM_MOD_MANA_REGENERATION_SHORT" or "ITEM_MOD_HEALTH_REGENERATION_SHORT"
                effect.averageVal = (val / cooldown) * 5
                effect.type = "Resource"
            end
            table_insert(outputUseTable, effect)
            return
        end
    end
end

-- =============================================================
-- 5. MAIN PIPELINE
-- =============================================================

function MSC.Scanner.Scan(itemLink)
    local result = CreateItemObject()
    if not itemLink then return result end
	
    local itemID, _, _, equipLoc, _, classID, subClassID = GetItemInfoInstant(itemLink)
    local isRelic = (equipLoc == "INVTYPE_RELIC") or (classID == 4 and (subClassID == 7 or subClassID == 8 or subClassID == 9 or subClassID == 11))

    local tip = _G["MSC_NewScannerTooltip"] or CreateFrame("GameTooltip", "MSC_NewScannerTooltip", nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE"); tip:ClearLines()
    pcall(function() tip:SetHyperlink(itemLink) end)

    for i = 2, tip:NumLines() do 
        local leftLine = _G["MSC_NewScannerTooltipTextLeft"..i]
        local leftText = leftLine and leftLine:GetText()
        local r, g, b = leftLine and leftLine:GetTextColor() or 1, 1, 1
        
        local rightLine = _G["MSC_NewScannerTooltipTextRight"..i]
        local rightText = rightLine and rightLine:GetText()
        
        local fullText = (leftText or "")
        if rightText and rightText ~= "" then
            fullText = fullText .. " " .. rightText
        end

        if fullText ~= "" then
            local type = MSC.Scanner.ClassifyLine(fullText)
            
            if type == "SET_HEADER" or type == "SET" then 
                MSC.Scanner.ParseSetHeader(fullText, result.Meta)
            elseif type == "STAT" and not isRelic then 
                MSC.Scanner.ParseStatLine(fullText, result.Stats)
            elseif type == "EQUIP" and not isRelic then 
                MSC.Scanner.ParseEquipLine(fullText, result.Stats, result.Procs)
            elseif type == "USE" and not isRelic then 
                MSC.Scanner.ParseUseLine(fullText, result.UseEffects)
            elseif type == "SOCKET_BONUS" then 
                if g > 0.9 and r < 0.2 then result.Meta.SocketBonusActive = true end
                if not result.Meta.BonusStats then result.Meta.BonusStats = {} end
                MSC.Scanner.ParseStatLine(fullText, result.Meta.BonusStats)
            elseif type == "PROC" and not isRelic then 
                MSC.Scanner.ParseProcLine(fullText, result.Procs)
            end
        end
    end

    if not result.Stats["MSC_WEAPON_DPS"] and result.Stats["MSC_WEAPON_SPEED"] and result.Stats["MSC_DAMAGE_RANGE_MIN"] and result.Stats["MSC_DAMAGE_RANGE_MAX"] then
        local avg = (result.Stats["MSC_DAMAGE_RANGE_MIN"] + result.Stats["MSC_DAMAGE_RANGE_MAX"]) / 2
        result.Stats["MSC_WEAPON_DPS"] = math_floor((avg / result.Stats["MSC_WEAPON_SPEED"]) * 10 + 0.5) / 10
    end

    local itemID = tonumber(string_match(itemLink, "item:(%d+)"))
    if itemID and MSC.ItemOverrides and MSC.ItemOverrides[itemID] then
        local override = MSC.ItemOverrides[itemID]
        if override._AUTO_PROC or override.UseEffects then
            result.UseEffects = {}
            result.Procs = {}
            if override._AUTO_PROC then result.Stats._AUTO_PROC = override._AUTO_PROC end
        end
    end

    return result
end