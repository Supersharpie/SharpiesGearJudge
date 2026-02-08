local addonName, MSC = ...
_G.MSC = MSC 

MSC.Scanner = {}

-- =============================================================
-- 1. DATA MAPS (Shared Dictionaries)
-- =============================================================

-- [[ A. WHITE TEXT MAP (Base Stats + Suffixes) ]]
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
    ["healing spells"] = "ITEM_MOD_HEALING_POWER_SHORT",
    ["healing"]        = "ITEM_MOD_HEALING_POWER_SHORT",
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
    ["healing"]           = "ITEM_MOD_HEALING_POWER_SHORT",
    ["mana per 5 sec"]    = "ITEM_MOD_MANA_REGENERATION_SHORT",
    ["health per 5 sec"]  = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
    
    -- [[ 5. ERA SPELL DAMAGE ]]
    ["damage and healing done by magical spells and effects"] = "ITEM_MOD_SPELL_POWER_SHORT",
    ["healing done by spells and effects"] = "ITEM_MOD_HEALING_POWER_SHORT",
    
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
}

-- =============================================================
-- 2. PATTERN DATABASE
-- =============================================================

MSC.Scanner.StatPatterns = {
    -- [[ 1. PREFIX FORMAT (Standard) ]]
    -- Handles: "+10 Strength", "10 Strength", "150 Armor"
    -- The pattern is "Start -> Optional + -> Number -> Space -> Text -> End"
    { p = "^[%s%+]*(%d+%.?%d*)%s+(.*)$", valIdx = 1, nameIdx = 2 },

    -- [[ 2. SUFFIX FORMAT (Standard) ]]
    -- Handles: "Strength +10", "Stamina 10", "Speed 2.80"
    { p = "^(.*)%s+[%+:]*%s*(%d+%.?%d*)$", valIdx = 2, nameIdx = 1 },

    -- [[ 3. SPECIFIC DPS FORMATS ]]
    -- Handles: "(55.4 damage per second)"
    { p = "^%((%d+%.?%d*) damage per second%)$", valIdx = 1, fixedStat = "MSC_WEAPON_DPS" },
    { p = "^%((%d+%.?%d*) DPS%)$", valIdx = 1, fixedStat = "MSC_WEAPON_DPS" }, -- Lazy variant
    
    -- [[ 4. DAMAGE RANGE ]]
    -- Handles: "100 - 200 Damage"
    { p = "^(%d+) %- (%d+) Damage$", type="RANGE" },
    
    -- [[ 5. ENCHANT/SCOPE FORMATS (Lazy Text) ]]
    -- Handles: "Scope (+7 Damage)" or "Enchant: +15 Agility"
    -- Sometimes these slip through as 'STAT' lines if the bouncer misses them
    { p = "Scope %([%+:]*(%d+) (.*)%)", valIdx = 1, nameIdx = 2 },
    { p = "Enchant:? [%+:]*(%d+) (.*)", valIdx = 1, nameIdx = 2 },
}

MSC.Scanner.EquipPatterns = {
    -- ========================================================================
    -- [[ 1. LAZY / SHORT FORM (Top Priority) ]]
    -- ========================================================================
    -- Catches: "+10 Agility", "+1% Hit", "Equip: +4 Mana Regen"
    -- The %s* allows for invisible spaces like "+ 10 Agility"
    { p = "^%+?%s*(%d+)%%? (.*)$", valIdx = 1, nameIdx = 2 },
    { p = "^(.-) %+(%d+)%%?$", valIdx = 2, nameIdx = 1 },

    -- ========================================================================
    -- [[ 2. SPECIALIZED OVERRIDES (Must be before Generic!) ]]
    -- ========================================================================
    -- [[ NEW: TBC SPECIFIC SPELL POWER ]]
    -- Explicitly catches the long phrasing
    { p = "damage and healing done by magical spells and effects by up to (%d+)%.?", valIdx = 1, fixedStat = "ITEM_MOD_SPELL_POWER_SHORT" },

    -- [[ FERAL AP ]] 
    -- MUST be before the generic parser, or it will just be read as normal Attack Power!
    { p = "Increases (attack power) by (%d+) in", valIdx = 2, nameIdx = 1, fixedStat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },
    
    -- [[ RESTORES (MP5/HP5) ]]
    -- "Restores" doesn't match "Increases", so these are required.
    { p = "Restores (%d+) (mana per 5 sec)%.?", valIdx = 1, nameIdx = 2 },
    { p = "Restores (%d+) (health per 5 sec)%.?", valIdx = 1, nameIdx = 2 },
    { p = "Restores (%d+) (.*) every ([%d%.]+) sec", 
    func = function(match1, match2, match3, outputStats)
            local key = (match2:find("health") and "ITEM_MOD_HEALTH_REGENERATION_SHORT") 
                        or "ITEM_MOD_MANA_REGENERATION_SHORT"
            -- Normalization math: (Value / Interval) * 5
            local val = tonumber(match1)
            local interval = tonumber(match3)
            if val and interval then
                local normalizedValue = (val / interval) * 5
                outputStats[key] = (outputStats[key] or 0) + normalizedValue
            end
        end 
    },
    { p = "Restores (%d+) health every ([%d%.]+) sec", valIdx = 1, nameIdx = 2, fixedStat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
    
    -- [[ ARPEN & THREAT ]]
    { p = "ignore (%d+) of your opponent's armor", valIdx = 1, fixedStat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" },
    { p = "Ignores (%d+) armor", valIdx = 1, fixedStat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" },
    { p = "Decreases (threat) caused", valIdx = nil, fixedStat = "MSC_THREAT_MOD" },

    -- [[ WEAPON SKILL (Era) ]]
    { p = "Increased (.*) %+(%d+)%.?", valIdx = 2, nameIdx = 1 },

    -- ========================================================================
    -- [[ 3. VERB VARIATIONS (Up To / Improves) ]]
    -- ========================================================================
    -- Era "Up to" (Healing/Spell Power)
    { p = "Increases (.*) by up to (%d+)%.?", valIdx = 2, nameIdx = 1 },
    { p = "^Damage and healing.-up to (%d+)%.?", valIdx = 1, fixedStat = "ITEM_MOD_SPELL_POWER_SHORT" },
    
    -- "Improves" (TBC Variation)
    { p = "Improves your (.*) by (%d+)%%%.?", valIdx = 2, nameIdx = 1 }, -- Percentages
    { p = "Improves (.*) by (%d+)%.?", valIdx = 2, nameIdx = 1 }, -- Ratings

    -- ========================================================================
    -- [[ 4. GENERIC CATCH-ALL (Bottom Priority) ]]
    -- ========================================================================
    -- This handles 90% of items: "Increases [Stat Name] by [Value]"
    { p = "Increases your (.*) by (%d+)%.?", valIdx = 2, nameIdx = 1 },
    { p = "Increases (.*) by (%d+)%.?", valIdx = 2, nameIdx = 1 },
}

MSC.Scanner.ProcPatterns = {
    -- ========================================================================
    -- [[ 1. BUFFS (Your Stats) ]]
    -- ========================================================================
    -- Lazy: "Chance on hit: +100 Haste for 10 sec"
    { p = "^%+(%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },

    -- Verbs: "Grants 100..." / "Gain 100..." / "Increases 100..."
    { p = "Grants (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "Gain (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "Increases (.*) by (%d+) for (%d+) sec", valIdx=2, nameIdx=1, durIdx=3, type="BUFF" },
    
    -- Permanent-ish Procs (Rare, but exist)
    { p = "Increases your (.*) by (%d+)$", valIdx=2, nameIdx=1, type="BUFF", defaultDur=10 }, -- Guess 10s

    -- ========================================================================
    -- [[ 2. DAMAGE PROCS ]]
    -- ========================================================================
    -- Ranges: "Inflicts 100 to 150 Fire damage"
    { p = "for (%d+) to (%d+) .*damage", type="DAMAGE" },
    { p = "inflicts (%d+) to (%d+) .*damage", type="DAMAGE" },
    
    -- Flat: "Inflicts 100 Fire damage" / "Deals 100 Shadow damage"
    { p = "for (%d+) .*damage", type="DAMAGE" },
    { p = "inflicts (%d+) .*damage", type="DAMAGE" },
    { p = "deals (%d+) .*damage", type="DAMAGE" },
    { p = "blasts (.*) for (%d+)", valIdx=2, type="DAMAGE" },

    -- ========================================================================
    -- [[ 3. HEALING / RESOURCES ]]
    -- ========================================================================
    { p = "steals (%d+) life", type="HEAL" },
    { p = "Restores (%d+) mana", type="MANA" },
    { p = "Restores (%d+) health", type="HEAL" },
    
    -- ========================================================================
    -- [[ 4. CATCH-ALL ]]
    -- ========================================================================
    { p = "Blasts your enemy", type="GENERIC" }
}

MSC.Scanner.UsePatterns = {
    -- ========================================================================
    -- [[ 1. LAZY SYNTAX (Short Forms) ]]
    -- ========================================================================
    -- "Use: +250 Health" (No duration implies permanent or instant heal, but we trap it here)
    -- "Use: +50 Strength for 20 sec"
    { p = "^%+(%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "^%+(%d+) (.*)$", valIdx=1, nameIdx=2, type="BUFF", defaultDur=15 }, -- Fallback 15s

    -- ========================================================================
    -- [[ 2. ALTERNATE VERBS ]]
    -- ========================================================================
    -- "Grants" / "Gain"
    { p = "Grants (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "Gain (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    
    -- ========================================================================
    -- [[ 3. COMPLEX PHRASING ("Up To" / TOEP) ]]
    -- ========================================================================
    -- This handles: "Increases damage... by up to 175 for 15 sec"
    { p = "Increases (.*) by up to (%d+) for (%d+) sec", valIdx=2, nameIdx=1, durIdx=3, type="BUFF" },
    
    -- Standard: "Increases Spell Power by 100 for 20 sec"
    { p = "Increases (.*) by (%d+) for (%d+) sec", valIdx=2, nameIdx=1, durIdx=3, type="BUFF" },

    -- ========================================================================
    -- [[ 4. RESOURCES (Potions / Gems) ]]
    -- ========================================================================
    -- Ranges: "Restores 900 to 1500 mana"
    { p = "Restores (%d+) to (%d+) mana", type="MANA_RANGE" },
    { p = "Restores (%d+) to (%d+) health", type="HEALTH_RANGE" },
    
    -- Flat: "Restores 500 mana"
    { p = "Restores (%d+) mana", valIdx=1, type="MANA" },
    { p = "Restores (%d+) health", valIdx=1, type="HEALTH" },
    
    -- ========================================================================
    -- [[ 5. MISC / EDGE CASES ]]
    -- ========================================================================
    -- "Adds 4 damage per second" (TBC Weapon Oils/Stones)
    { p = "Adds (%d+) damage", valIdx=1, fixedStat="ITEM_MOD_DAMAGE_PER_SECOND_SHORT", type="BUFF", defaultDur=15 }
}

-- =============================================================
-- 3. UTILITIES
-- =============================================================
local function CreateItemObject()
    return { 
        Stats = {}, UseEffects = {}, Procs = {}, 
        Meta = { SetName=nil, SetCount=0, Sockets={}, SocketBonusActive=false, BonusStats={} } 
    }
end

local function ParseCooldown(text)
    local lowerText = text:lower()
    local min = lowerText:match("%((%d+)%s*min[s%a]*%s*cooldown%)")
    if min then return tonumber(min) * 60 end
    local sec = lowerText:match("%((%d+)%s*sec[s%a]*%s*cooldown%)")
    if sec then return tonumber(sec) end
    return 120 
end

function MSC.Scanner.ClassifyLine(text)
    if not text or text == "" then return "SKIP" end
    -- Clean colors FIRST
    local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("\n", " "):lower()
    
    if cleanText:find("chance on hit") or cleanText:find("when struck") then return "PROC" end
    if cleanText:find("^use:") then return "USE" end
    
    -- "Implicit Use" (for 10 sec) but NOT MP5 (per 5 sec)
    if cleanText:find(" for %d+ sec") and not cleanText:find("per %d+ sec") then return "USE" end

    if cleanText:find("set:") or cleanText:find("%(%d/%d%)") then return "SET" end
    if cleanText:find("socket bonus:") then return "SOCKET_BONUS" end
    if cleanText:find("socket") then return "SOCKET_INFO" end 
    
    if cleanText:find("^equip:") 
       or cleanText:find("^increases") 
       or cleanText:find("^improves") 
       or cleanText:find("^restores") 
       or cleanText:find("^increased")
       or cleanText:find("^decreases") then
       return "EQUIP" 
    end

    if cleanText:find("%d") then return "STAT" end 
    return "FLUFF"
end

-- =============================================================
-- 4. SUB-PARSERS
-- =============================================================

function MSC.Scanner.ParseSetLine(text, r, g, b, metaTable, outputStats)
    -- 1. Try to match the Header: "Nemesis Raiment (3/8)"
    local setName, current, total = text:match("^(.*) %((%d+)/(%d+)%)$")
    if setName then 
        metaTable.SetName = setName
        metaTable.SetCount = tonumber(current)
        return 
    end
end

function MSC.Scanner.ParseEquipLine(text, outputStats, outputProcs)
    local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("\n", " "):gsub("^Equip: ", ""):gsub("%s+", " "):lower()
    cleanText = cleanText:gsub("^equip: ", "")
    
    for _, pat in ipairs(MSC.Scanner.EquipPatterns) do
        local match1, match2, match3 = cleanText:match(pat.p)
        if match1 then
            if pat.func then pat.func(match1, match2, match3, outputStats); return end

            local val = tonumber(pat.valIdx == 1 and match1 or match2)
            local name = pat.nameIdx and (pat.nameIdx == 1 and match1 or match2)

            -- [[ 1. TBC PERCENT CONVERSION ]]
            if val and pat.isPercent and MSC.IsTBC then
                -- Standard TBC Conversion Rates (Level 70)
                -- Spell Hit: ~12.6, Melee Hit: ~15.8, Crit: ~22.1, Haste: ~15.8
                local mult = 15.8 -- Default (Melee Hit/Haste)
                
                if name then
                    if name:find("spell") then 
                        if name:find("hit") then mult = 12.6 
                        elseif name:find("crit") then mult = 22.1 end
                    elseif name:find("crit") then 
                        mult = 22.1
                    elseif name:find("speed") or name:find("haste") then 
                        mult = 15.8
                    end
                end
                val = val * mult
            end

            -- [[ 2. STANDARD ASSIGNMENT ]]
            if pat.fixedStat and not pat.nameIdx then
                if not pat.valIdx then val = 1 end
                if val then outputStats[pat.fixedStat] = (outputStats[pat.fixedStat] or 0) + val; return end
            end
            
            if pat.fixedStat and val then
                 outputStats[pat.fixedStat] = (outputStats[pat.fixedStat] or 0) + val; return
            elseif val and name then
                local cleanName = name:gsub("your ", ""):gsub("%s+$", "")
                local key = MSC.Scanner.TermMap[cleanName]
                if key then outputStats[key] = (outputStats[key] or 0) + val; return end
            end
        end
    end
    table.insert(outputProcs, { type = "Equip", desc = text })
end

function MSC.Scanner.ParseStatLine(text, outputTable)
    if not text then return end
    local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("\n", " "):gsub("%s+", " "):lower()
    cleanText = cleanText:match("^%s*(.-)%s*$")
    
    for _, pat in ipairs(MSC.Scanner.StatPatterns) do
        local m1, m2, m3 = cleanText:match(pat.p)
        if m1 then
            if pat.type == "RANGE" then
                outputTable["MSC_DAMAGE_RANGE_MIN"] = tonumber(m1)
                outputTable["MSC_DAMAGE_RANGE_MAX"] = tonumber(m2)
                return
            elseif pat.fixedStat then
                local val = tonumber(m1)
                if val then outputTable[pat.fixedStat] = val; return end
            else
                local val = tonumber(pat.valIdx == 1 and m1 or m2)
                local name = pat.valIdx == 1 and m2 or m1
                if val and name then
                    local cleanName = name:gsub("^to ", ""):gsub("%s+$", "")
                    local key = MSC.Scanner.BaseStatMap[cleanName]
                    if not key and cleanName == "armor" then key = "ITEM_MOD_ARMOR_SHORT" end
                    if key then outputTable[key] = (outputTable[key] or 0) + val; return end
                end
            end
        end
    end
end

function MSC.Scanner.ParseProcLine(text, outputProcs)
    local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("\n", " "):gsub("%s+", " "):lower()
    cleanText = cleanText:gsub("^chance on hit: ", ""):gsub("^equip: chance on hit: ", "")

    for _, pat in ipairs(MSC.Scanner.ProcPatterns) do
        local m1, m2, m3 = cleanText:match(pat.p)
        if m1 then
            local procObj = { description = text }
            
            if pat.type == "DAMAGE" then
                procObj.type = "Damage"
                
                -- [[ FIX: Check valIdx to handle "Blasts X for Y" patterns ]]
                local valStr = (pat.valIdx == 2) and m2 or m1
                procObj.val = tonumber(valStr)
                
                -- Only average if it's a range pattern (m2 exists AND we didn't just use it as the primary value)
                if m2 and not pat.valIdx then 
                    procObj.val = (procObj.val + tonumber(m2)) / 2 
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
            table.insert(outputProcs, procObj)
            return
        end
    end
    table.insert(outputProcs, { type = "Unknown", description = text })
end

function MSC.Scanner.ParseUseLine(text, outputUseTable)
    local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("\n", " "):gsub("%s+", " "):gsub("^use: ", ""):lower()
    local cooldown = ParseCooldown(text)
    
    for _, pat in ipairs(MSC.Scanner.UsePatterns) do
        local m1, m2, m3 = cleanText:match(pat.p)
        if m1 then
            local effect = { raw = text, cooldown = cooldown }
            if pat.type == "BUFF" then
                local val = tonumber(pat.valIdx == 1 and m1 or m2)
                local name = pat.nameIdx and (pat.nameIdx == 1 and m1 or m2)
                local duration = tonumber(m3) or pat.defaultDur or 15
                effect.averageVal = val * (duration / cooldown)
                effect.duration = duration
                if pat.fixedStat then 
                    effect.statKey = pat.fixedStat
                elseif name then
                    local cleanName = name:gsub("your ", ""):gsub("%s+$", "")
                    effect.statKey = MSC.Scanner.TermMap[cleanName]
                end
                effect.type = "Stat"
            elseif pat.type == "MANA" or pat.type == "HEALTH" or pat.type == "MANA_RANGE" or pat.type == "HEALTH_RANGE" then
                local val = tonumber(m1)
                if m2 then val = (val + tonumber(m2)) / 2 end
                if pat.type:find("MANA") then effect.statKey = "ITEM_MOD_MANA_REGENERATION_SHORT"
                else effect.statKey = "ITEM_MOD_HEALTH_REGENERATION_SHORT" end
                effect.averageVal = (val / cooldown) * 5
                effect.type = "Resource"
            end
            table.insert(outputUseTable, effect)
            return
        end
    end
end

-- =============================================================
-- 5. MAIN PIPELINE (RIGHT-SIDE SCANNING ENABLED)
-- =============================================================

function MSC.Scanner.Scan(itemLink)
    local result = CreateItemObject()
    if not itemLink then return result end
    
    local tip = _G["MSC_NewScannerTooltip"] or CreateFrame("GameTooltip", "MSC_NewScannerTooltip", nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE"); tip:ClearLines()
    pcall(function() tip:SetHyperlink(itemLink) end)

    for i = 2, tip:NumLines() do 
        -- READ LEFT TEXT
        local leftLine = _G["MSC_NewScannerTooltipTextLeft"..i]
        local leftText = leftLine and leftLine:GetText()
        local r, g, b = leftLine and leftLine:GetTextColor() or 1, 1, 1
        
        -- READ RIGHT TEXT (CRITICAL for Speed!)
        local rightLine = _G["MSC_NewScannerTooltipTextRight"..i]
        local rightText = rightLine and rightLine:GetText()
        
        -- MERGE THEM (e.g., "87 - 131 Damage" + "Speed 2.80")
        local fullText = (leftText or "")
        if rightText and rightText ~= "" then
            fullText = fullText .. " " .. rightText
        end

        if fullText ~= "" then
            local type = MSC.Scanner.ClassifyLine(fullText)
            if type == "STAT" then MSC.Scanner.ParseStatLine(fullText, result.Stats)
            elseif type == "EQUIP" then MSC.Scanner.ParseEquipLine(fullText, result.Stats, result.Procs)
            elseif type == "USE" then MSC.Scanner.ParseUseLine(fullText, result.UseEffects)
            elseif type == "SET" then MSC.Scanner.ParseSetLine(fullText, nil, nil, nil, result.Meta, result.Stats)
            elseif type == "SOCKET_BONUS" then 
                -- [[ UPDATED: Always parse Bonus Stats, but track Active separately ]]
                if g > 0.9 and r < 0.2 then result.Meta.SocketBonusActive = true end
                if not result.Meta.BonusStats then result.Meta.BonusStats = {} end
                MSC.Scanner.ParseStatLine(fullText, result.Meta.BonusStats)
            elseif type == "PROC" then MSC.Scanner.ParseProcLine(fullText, result.Procs)
            end
        end
    end
    
    -- FALLBACK DPS CALC
    if not result.Stats["MSC_WEAPON_DPS"] and result.Stats["MSC_WEAPON_SPEED"] and result.Stats["MSC_DAMAGE_RANGE_MIN"] then
        local avg = (result.Stats["MSC_DAMAGE_RANGE_MIN"] + result.Stats["MSC_DAMAGE_RANGE_MAX"]) / 2
        local dps = avg / result.Stats["MSC_WEAPON_SPEED"]
        local mult = 10; result.Stats["MSC_WEAPON_DPS"] = math.floor(dps * mult + 0.5) / mult
    end
    
    -- Cleanup temp keys
    result.Stats["MSC_DAMAGE_RANGE_MIN"] = nil
    result.Stats["MSC_DAMAGE_RANGE_MAX"] = nil

    return result
end