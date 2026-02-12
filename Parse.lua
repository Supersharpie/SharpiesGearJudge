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
    ["strength"] = "ITEM_MOD_STRENGTH_SHORT",
    ["agility"]  = "ITEM_MOD_AGILITY_SHORT",
    ["stamina"]  = "ITEM_MOD_STAMINA_SHORT",
    ["intellect"]= "ITEM_MOD_INTELLECT_SHORT",
    ["spirit"]   = "ITEM_MOD_SPIRIT_SHORT",
    
    -- Defensive / Weapon
    ["armor"] = "ITEM_MOD_ARMOR_SHORT",
    ["block"] = "ITEM_MOD_BLOCK_VALUE_SHORT",
    ["block value"] = "ITEM_MOD_BLOCK_VALUE_SHORT",
    ["speed"] = "MSC_WEAPON_SPEED",
    ["damage per second"] = "MSC_WEAPON_DPS",
    ["dps"] = "MSC_WEAPON_DPS",
    
    -- Resistances
    ["shadow resistance"] = "ITEM_MOD_SHADOW_RESISTANCE_SHORT",
    ["fire resistance"]   = "ITEM_MOD_FIRE_RESISTANCE_SHORT",
    ["frost resistance"]  = "ITEM_MOD_FROST_RESISTANCE_SHORT",
    ["arcane resistance"] = "ITEM_MOD_ARCANE_RESISTANCE_SHORT",
    ["nature resistance"] = "ITEM_MOD_NATURE_RESISTANCE_SHORT",
    
    -- Random Suffixes
    ["attack power"]   = "ITEM_MOD_ATTACK_POWER_SHORT", 
    ["healing spells"] = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
    ["healing"]        = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
    ["spell damage"]   = "ITEM_MOD_SPELL_POWER_SHORT",
    ["spell power"]    = "ITEM_MOD_SPELL_POWER_SHORT",
    ["shadow damage"]  = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["fire damage"]    = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["frost damage"]   = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["arcane damage"]  = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["nature damage"]  = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["holy damage"]    = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    ["shadow spell damage"] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["fire spell damage"]   = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["frost spell damage"]  = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["arcane spell damage"] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["nature spell damage"] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["holy spell damage"]   = "ITEM_MOD_HOLY_DAMAGE_SHORT",
	["spell damage and healing"] = "ITEM_MOD_SPELL_POWER_SHORT",  -- Fixes "of the Crusade", "of the Sorcerer"
    ["damage and healing spells"] = "ITEM_MOD_SPELL_POWER_SHORT", -- rare variation   
    -- Hunter / Range missing entries
    ["ranged attack power"] = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT", -- Critical for "of the Falcon" variants if they split stats
    ["spell penetration"] = "ITEM_MOD_SPELL_PENETRATION_SHORT",
    ["all stats"] = "ITEM_MOD_ALL_STATS_SHORT", -- "of the Ancestors" or generic buffs
    ["magic resistance"] = "ITEM_MOD_RESISTANCE_ALL_SHORT", -- "of Resistance" (rare white text)
    
    ["mana"]           = "ITEM_MOD_MANA_SHORT",
    ["health"]         = "ITEM_MOD_HEALTH_SHORT",
    ["hp"]             = "ITEM_MOD_HEALTH_SHORT",
    ["mp"]             = "ITEM_MOD_MANA_SHORT",
    
    -- TBC Ratings
    ["dodge rating"]      = "ITEM_MOD_DODGE_RATING_SHORT",
    ["parry rating"]      = "ITEM_MOD_PARRY_RATING_SHORT",
    ["block rating"]      = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["hit rating"]        = "ITEM_MOD_HIT_RATING_SHORT",
    ["crit rating"]       = "ITEM_MOD_CRIT_RATING_SHORT",
    ["critical strike rating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["haste rating"]      = "ITEM_MOD_HASTE_RATING_SHORT",
    ["resilience rating"] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
    ["defense rating"]    = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["expertise rating"]  = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    ["armor penetration rating"] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"
}

-- [[ B. GREEN TEXT MAP (Equip / Use / Proc Effects) ]]
MSC.Scanner.TermMap = {
    -- [[ 1. OFFENSIVE RATINGS ]]
    ["hit rating"]        = "ITEM_MOD_HIT_RATING_SHORT",
    ["chance to hit"]     = "ITEM_MOD_HIT_RATING_SHORT", -- Era
    
    ["critical strike rating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["chance to get a critical strike"] = "ITEM_MOD_CRIT_RATING_SHORT", -- Era
    
    ["spell hit rating"]  = "ITEM_MOD_HIT_SPELL_RATING_SHORT",
    ["chance to hit with spells"] = "ITEM_MOD_HIT_SPELL_RATING_SHORT", -- Era Long

    ["spell critical strike rating"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT",
    ["critical strike with spells"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT", -- Era
    ["chance to get a critical strike with spells"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT", -- Era Long
    
    ["haste rating"]       = "ITEM_MOD_HASTE_RATING_SHORT",
    ["spell haste rating"] = "ITEM_MOD_SPELL_HASTE_RATING_SHORT",
    ["spell penetration"]  = "ITEM_MOD_SPELL_PENETRATION_SHORT",
    ["magical resistances"] = "ITEM_MOD_SPELL_PENETRATION_SHORT", -- Key for "Decreases" pattern
    ["magical resistances of your spell targets"] = "ITEM_MOD_SPELL_PENETRATION_SHORT", -- Era Long

    ["armor penetration rating"] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",
    ["expertise rating"]   = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    ["ranged attack power"]= "ITEM_MOD_RANGED_ATTACK_POWER_SHORT",

    -- [[ 2. DEFENSIVE RATINGS ]]
    ["defense rating"]    = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["increased defense"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", -- Era
    ["defense"]           = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["dodge rating"]      = "ITEM_MOD_DODGE_RATING_SHORT",
    ["chance to dodge"]   = "ITEM_MOD_DODGE_RATING_SHORT", -- Era
    ["parry rating"]      = "ITEM_MOD_PARRY_RATING_SHORT",
    ["chance to parry"]   = "ITEM_MOD_PARRY_RATING_SHORT", -- Era
    ["block rating"]      = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["chance to block"]   = "ITEM_MOD_BLOCK_RATING_SHORT", -- Era
    ["shield block value"]= "ITEM_MOD_BLOCK_VALUE_SHORT",
    ["the block value of your shield"] = "ITEM_MOD_BLOCK_VALUE_SHORT", -- Era Long
    ["resilience rating"] = "ITEM_MOD_RESILIENCE_RATING_SHORT",

    -- [[ 3. RESISTANCES ]]
    ["shadow resistance"] = "ITEM_MOD_SHADOW_RESISTANCE_SHORT",
    ["fire resistance"]   = "ITEM_MOD_FIRE_RESISTANCE_SHORT",
    ["frost resistance"]  = "ITEM_MOD_FROST_RESISTANCE_SHORT",
    ["arcane resistance"] = "ITEM_MOD_ARCANE_RESISTANCE_SHORT",
    ["nature resistance"] = "ITEM_MOD_NATURE_RESISTANCE_SHORT",
    ["all resistances"]   = "ITEM_MOD_ALL_RESISTANCE_SHORT",
    ["resistance to all schools of magic"] = "ITEM_MOD_ALL_RESISTANCE_SHORT", 

    -- [[ 4. POWER STATS ]]
    ["attack power"]      = "ITEM_MOD_ATTACK_POWER_SHORT",
    ["attack power in cat"] = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
    ["feral attack power"]  = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
    ["spell power"]       = "ITEM_MOD_SPELL_POWER_SHORT",
    ["healing"]           = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
    ["mana per 5 sec"]    = "ITEM_MOD_MANA_REGENERATION_SHORT",
    ["health per 5 sec"]  = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
    
    -- [[ 5. ERA SPELL DAMAGE ]]
    ["damage and healing done by magical spells and effects"] = "ITEM_MOD_SPELL_POWER_SHORT",
    ["healing done by spells and effects"] = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
    
    ["damage done by shadow spells and effects"] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["damage done by fire spells and effects"]   = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["damage done by frost spells and effects"]  = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["damage done by arcane spells and effects"] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["damage done by nature spells and effects"] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["damage done by holy spells and effects"]   = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    
    -- TBC Short Forms
    ["shadow damage"] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["fire damage"]   = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["frost damage"]  = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["arcane damage"] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["nature damage"] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["holy damage"]   = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    
    -- [[ 6. BASE STATS ]]
    ["strength"] = "ITEM_MOD_STRENGTH_SHORT",
    ["agility"]  = "ITEM_MOD_AGILITY_SHORT",
    ["stamina"]  = "ITEM_MOD_STAMINA_SHORT",
    ["intellect"]= "ITEM_MOD_INTELLECT_SHORT",
    ["spirit"]   = "ITEM_MOD_SPIRIT_SHORT",
    ["armor"]    = "ITEM_MOD_ARMOR_SHORT",
    ["mana"]     = "ITEM_MOD_MANA_SHORT",
    ["health"]   = "ITEM_MOD_HEALTH_SHORT",
    
    -- [[ 7. WEAPON SKILLS ]]
    ["swords"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["axes"]     = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["maces"]    = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["daggers"]  = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["bows"]     = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["crossbows"]= "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["guns"]     = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["staves"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["polearms"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["two-handed swords"] = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["two-handed axes"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["two-handed maces"]  = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with swords"] = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with axes"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with maces"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with bows"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with guns"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with daggers"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with crossbows"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with staves"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with polearms"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
	
	-- [[ TBC: THE "RANGED" & "SHIELD" VARIANTS ]]
    ["ranged critical strike rating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["ranged hit rating"]             = "ITEM_MOD_HIT_RATING_SHORT",
    ["ranged haste rating"]           = "ITEM_MOD_HASTE_RATING_SHORT",
    ["shield block rating"]           = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["shield block value"]            = "ITEM_MOD_BLOCK_VALUE_SHORT",
    
    -- [[ TBC: PET STATS (Warlock/Hunter Trinkets & Set Bonuses) ]]
    ["your pet's armor"]              = "ITEM_MOD_ARMOR_SHORT", -- Handled loosely, but good to catch
    ["your pet's attack power"]       = "ITEM_MOD_ATTACK_POWER_SHORT",
    ["your pet's damage"]             = "ITEM_MOD_ATTACK_POWER_SHORT",
    
    -- [[ TBC: THE "SPELL" VARIANTS (Consistency) ]]
    ["spell damage rating"]           = "ITEM_MOD_SPELL_POWER_SHORT",
    ["damage done by magical spells and effects"] = "ITEM_MOD_SPELL_POWER_SHORT",
    ["healing done by magical spells and effects"] = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
    ["spell damage and healing"]      = "ITEM_MOD_SPELL_POWER_SHORT",
    
    -- [[ WEIRD / EDGE CASE CATCHERS ]]
    ["all stats"]                     = "ITEM_MOD_ALL_STATS_SHORT",
    ["magic resistance"]              = "ITEM_MOD_RESISTANCE_ALL_SHORT",
    ["chance to resist mechanic mechanics"] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
}

-- =============================================================
-- 2. PATTERN DATABASE (Merged)
-- =============================================================

MSC.Scanner.StatPatterns = {
    -- [[ 1. STANDARD PREFIX]]
    -- Catches: "+14 Spell Damage", "14 Strength", "+ 14 Intellect"
    { p = "^[%+]?%s*(%d+%.?%d*)%s+(.-)[%s%.]*$", valIdx = 1, nameIdx = 2 },

    -- [[ 2. STANDARD SUFFIX]]
    -- Catches: "Strength +14", "Agility 14", "Speed 2.80"
    { p = "^(.-)%s+[%+:]?%s*(%d+%.?%d*)[%s%.]*$", valIdx = 2, nameIdx = 1 },
    
    -- [[ 3. FIXED SHORT STATS ]]
    -- These specific strings don't need dictionary lookups
    { p = "^(%d+) armor$", valIdx = 1, fixedStat = "ITEM_MOD_ARMOR_SHORT" },
    { p = "^(%d+) block$", valIdx = 1, fixedStat = "ITEM_MOD_BLOCK_VALUE_SHORT" },

    -- [[ 4. WEAPON & DPS ]]
    { p = "speed (%d+%.?%d*)", valIdx = 1, fixedStat = "MSC_WEAPON_SPEED" },
    { p = "^%((%d+%.?%d*) damage per second%)$", valIdx = 1, fixedStat = "MSC_WEAPON_DPS" },
    { p = "^%((%d+%.?%d*) dps%)$", valIdx = 1, fixedStat = "MSC_WEAPON_DPS" },
    
    -- Range: Covers "100 - 200 Damage" and "100-200 Damage"
    { p = "^(%d+)%s?[-~]%s?(%d+) damage$", type="RANGE" },
    
    -- [[ 5. ENCHANT/SCOPE FORMATS ]]
    { p = "scope %([%+:]*(%d+) (.*)%)", valIdx = 1, nameIdx = 2 },
    { p = "enchant:? [%+:]*(%d+) (.*)", valIdx = 1, nameIdx = 2 },
}

MSC.Scanner.EquipPatterns = {
    -- ========================================================================
    -- [[ 1. SPECIALIZED OVERRIDES (Higher Priority) ]]
    -- ========================================================================
    
    -- [[ TBC: HYBRID HEAL/DAMAGE SPLIT ]]
    { p = "healing.-up to (%d+).-damage.-up to (%d+)", 
      func = function(heal, dmg, _, outputStats) 
          if outputStats then
              outputStats["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = (outputStats["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0) + tonumber(heal)
              outputStats["ITEM_MOD_SPELL_POWER_SHORT"] = (outputStats["ITEM_MOD_SPELL_POWER_SHORT"] or 0) + tonumber(dmg)
          end
      end 
    },

    -- [[ ERA/TBC: UNIFIED SPELL POWER ]]
    { p = "damage and healing.-up to (%d+)%.?", valIdx = 1, fixedStat = "ITEM_MOD_SPELL_POWER_SHORT" },
    { p = "healing done.-up to (%d+)%.?", valIdx = 1, fixedStat = "ITEM_MOD_SPELL_HEALING_DONE_SHORT" },

    -- [[ FERAL AP & WEAPON SKILL ]] 
    { p = "increases (attack power) by (%d+) in", valIdx = 2, nameIdx = 1, fixedStat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },
	{ p = "attack power by (%d+) in cat", valIdx = 1, fixedStat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },
    { p = "feral attack power by (%d+)", valIdx = 1, fixedStat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },
    { p = "increased (.*) %+(%d+)%.?", valIdx = 2, nameIdx = 1 },

    -- [[ RESTORES (MP5/HP5) ]]
    { p = "restores (%d+) (mana per 5 sec)%.?", valIdx = 1, nameIdx = 2 },
    { p = "restores (%d+) (health per 5 sec)%.?", valIdx = 1, nameIdx = 2 },
    { p = "restores (%d+) (.*) every ([%d%.]+) sec", 
        func = function(match1, match2, match3, outputStats)
            local key = (string_find(match2, "health") and "ITEM_MOD_HEALTH_REGENERATION_SHORT") 
                        or "ITEM_MOD_MANA_REGENERATION_SHORT"
            local val, interval = tonumber(match1), tonumber(match3)
            if val and interval then outputStats[key] = (outputStats[key] or 0) + ((val / interval) * 5) end
        end 
		},
	{ p = "restores (%d+) (mana per 5 sec).-casting", valIdx = 1, fixedStat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
    { p = "restores (%d+) (health per 5 sec).-combat", valIdx = 1, fixedStat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
	
    -- [[ ARPEN, THREAT, & PENETRATION ]]
    { p = "ignore (%d+) of your opponent's armor", valIdx = 1, fixedStat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" },
    { p = "ignores (%d+) armor", valIdx = 1, fixedStat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" },
    { p = "attacks ignore (%d+) of your", valIdx = 1, fixedStat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" },
    { p = "decreases (.*) by (%d+)", valIdx=2, nameIdx=1 }, 
    { p = "decreases (threat) caused", valIdx = nil, fixedStat = "MSC_THREAT_MOD" },
	
	-- [[FLAT WEAPON DAMAGE (Ammo, Scopes, Rings) ]]
    { p = "adds (%d+) weapon damage", valIdx = 1, fixedStat = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
    { p = "adds (%d+) damage", valIdx = 1, fixedStat = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },

    -- ========================================================================
    -- [[ 2. STANDARD PHRASING (Percent vs Rating) ]]
    -- ========================================================================
    
    -- Percent (Caught first to prevent splitting "1% Hit" into just "1 Hit")
    { p = "improves your (.*) by (%d+)%%%.?", valIdx = 2, nameIdx = 1, isPercent = true }, 
    { p = "increases your (.*) by (%d+)%%%.?", valIdx = 2, nameIdx = 1, isPercent = true }, 
    { p = "increases (.*) by (%d+)%%%.?", valIdx = 2, nameIdx = 1, isPercent = true },

    -- Flat Rating / "Up To"
    { p = "improves your (.*) by (%d+)%.?", valIdx = 2, nameIdx = 1 }, 
    { p = "improves (.*) by (%d+)%.?", valIdx = 2, nameIdx = 1 }, 
    { p = "increases your (.*) by (%d+)%.?", valIdx = 2, nameIdx = 1 }, 
    { p = "increases (.*) by up to (%d+)%.?", valIdx = 2, nameIdx = 1 },
    { p = "increases (.*) by (%d+)%.?", valIdx = 2, nameIdx = 1 },

    -- ========================================================================
    -- [[ 3. LAZY / SHORT FORM (Green Text) ]]
    -- ========================================================================
    { p = "^%+?%s*(%d+)%%? (.*)$", valIdx = 1, nameIdx = 2 },
    { p = "^(.-) %+(%d+)%%?$", valIdx = 2, nameIdx = 1 },
}

MSC.Scanner.ProcPatterns = {
    -- Buffs
    { p = "^%+(%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "grants (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "gain (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "increases (.*) by (%d+) for (%d+) sec", valIdx=2, nameIdx=1, durIdx=3, type="BUFF" },
    { p = "increases your (.*) by (%d+)$", valIdx=2, nameIdx=1, type="BUFF", defaultDur=10 },
	{ p = "chance on melee or ranged hit to gain (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "chance on spell critical hit to gain (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "chance on spell cast to gain (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },	

    -- Damage Procs
    { p = "for (%d+) to (%d+) .*damage", type="DAMAGE" },
    { p = "inflicts (%d+) to (%d+) .*damage", type="DAMAGE" },
    { p = "for (%d+) .*damage", type="DAMAGE" },
    { p = "inflicts (%d+) .*damage", type="DAMAGE" },
    { p = "deals (%d+) .*damage", type="DAMAGE" },
    { p = "blasts (.*) for (%d+)", valIdx=2, type="DAMAGE" },
	{ p = "chance to strike your enemy for (%d+) to (%d+) .*damage", type="DAMAGE" },
    { p = "chance to blast your target for (%d+) to (%d+) .*damage", type="DAMAGE" },

    -- Resources
    { p = "steals (%d+) life", type="HEAL" },
    { p = "restores (%d+) mana", type="MANA" },
    { p = "restores (%d+) health", type="HEAL" },
	
    -- Catch All
    { p = "blasts your enemy", type="GENERIC" }
}

MSC.Scanner.UsePatterns = {
    -- Short Forms
    { p = "^%+(%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "^%+(%d+) (.*)$", valIdx=1, nameIdx=2, type="BUFF", defaultDur=15 },

    -- Verbs
    { p = "grants (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "gain (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "increases (.*) by up to (%d+) for (%d+) sec", valIdx=2, nameIdx=1, durIdx=3, type="BUFF" },
    { p = "increases (.*) by (%d+) for (%d+) sec", valIdx=2, nameIdx=1, durIdx=3, type="BUFF" },

    -- Resources
    { p = "restores (%d+) to (%d+) mana", type="MANA_RANGE" },
    { p = "restores (%d+) to (%d+) health", type="HEALTH_RANGE" },
    { p = "restores (%d+) mana", valIdx=1, type="MANA" },
    { p = "restores (%d+) health", valIdx=1, type="HEALTH" },

    -- Misc
    { p = "adds (%d+) damage", valIdx=1, fixedStat="ITEM_MOD_DAMAGE_PER_SECOND_SHORT", type="BUFF", defaultDur=15 }
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
    local min = string_match(lowerText, "%((%d+)%s*min[s%a]*%s*cooldown%)")
    if min then return tonumber(min) * 60 end
    local sec = string_match(lowerText, "%((%d+)%s*sec[s%a]*%s*cooldown%)")
    if sec then return tonumber(sec) end
    return 120 
end

function MSC.Scanner.ClassifyLine(text)
    if not text or text == "" then return "SKIP" end
    local lower = string_lower(text)

    -- [[ OPTIMIZATION: SIMPLE CHECKS FIRST ]]
    if string_find(lower, "equip") then return "EQUIP" end
    if string_find(lower, "use:") then return "USE" end
    if string_find(lower, "chance on") then return "PROC" end
    if string_find(lower, "set:") then return "SET" end
    if string_find(lower, "socket") then 
        if string_find(lower, "bonus") then return "SOCKET_BONUS" else return "SOCKET_INFO" end
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
    local setName, current, total = string_match(cleanText, "^(.*)%s+%(?(%d+)/(%d+)%)?$")
    if setName then 
        metaTable.SetName = string_gsub(setName, "^%s*(.-)%s*$", "%1")
        metaTable.SetCount = tonumber(current)
        metaTable.SetTotal = tonumber(total)
        return true
    end
end

function MSC.Scanner.ParseEquipLine(text, outputStats, outputProcs)
    local cleanText = string_gsub(string_gsub(string_gsub(string_gsub(string_lower(text), "|c%x%x%x%x%x%x%x%x", ""), "|r", ""), "\n", " "), "^equip: ", "")
    cleanText = string_gsub(string_gsub(cleanText, "%s+", " "), "^%s*equip:%s*", "")
    
    for _, pat in ipairs(MSC.Scanner.EquipPatterns) do
        local match1, match2, match3 = string_match(cleanText, pat.p)
        if match1 then
            if pat.func then pat.func(match1, match2, match3, outputStats); return end

            local val = tonumber(pat.valIdx == 1 and match1 or match2)
            local name = pat.nameIdx and (pat.nameIdx == 1 and match1 or match2)

            if val and pat.isPercent and MSC.IsTBC then
                local mult = 15.8 
                if name then
                    if string_find(name, "spell") then 
                        mult = (string_find(name, "hit") and 12.6 or 22.1)
                    elseif string_find(name, "crit") then 
                        mult = 22.1
                    elseif string_find(name, "speed") or string_find(name, "haste") then 
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

    -- [[ OPTIMIZATION: DIGIT CHECK ]]
    if not string_find(text, "%d") then return end
    
    local cleanText = string_lower(text)
    cleanText = string_gsub(cleanText, "|c%x%x%x%x%x%x%x%x", "")
    cleanText = string_gsub(cleanText, "|r", "")
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
                    local cleanName = string_gsub(string_gsub(name, "^to ", ""), "[%s%.]+$", "")
                    local key = MSC.Scanner.BaseStatMap[cleanName]
                    if not key and cleanName == "armor" then key = "ITEM_MOD_ARMOR_SHORT" end
                    
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
    cleanText = string_gsub(string_gsub(cleanText, "^chance on hit: ", ""), "^equip: chance on hit: ", "")

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
    local cleanText = string_gsub(string_gsub(string_gsub(string_gsub(string_gsub(string_lower(text), "|c%x%x%x%x%x%x%x%x", ""), "|r", ""), "\n", " "), "%s+", " "), "^use: ", "")
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
            elseif type == "STAT" then 
                MSC.Scanner.ParseStatLine(fullText, result.Stats)
            elseif type == "EQUIP" then 
                MSC.Scanner.ParseEquipLine(fullText, result.Stats, result.Procs)
            elseif type == "USE" then 
                MSC.Scanner.ParseUseLine(fullText, result.UseEffects)
            elseif type == "SOCKET_BONUS" then 
                if g > 0.9 and r < 0.2 then result.Meta.SocketBonusActive = true end
                if not result.Meta.BonusStats then result.Meta.BonusStats = {} end
                MSC.Scanner.ParseStatLine(fullText, result.Meta.BonusStats)
            elseif type == "PROC" then 
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