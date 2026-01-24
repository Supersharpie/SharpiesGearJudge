local addonName, MSC = ...
MSC.Scanner = {}

-- =============================================================
-- 1. DATA MAPS (NORMALIZED TO LOWERCASE)
-- =============================================================
MSC.Scanner.BaseStatMap = {
    -- [[ PRIMARY STATS ]]
    ["strength"]  = "ITEM_MOD_STRENGTH_SHORT",
    ["agility"]   = "ITEM_MOD_AGILITY_SHORT",
    ["stamina"]   = "ITEM_MOD_STAMINA_SHORT",
    ["intellect"] = "ITEM_MOD_INTELLECT_SHORT",
    ["spirit"]    = "ITEM_MOD_SPIRIT_SHORT",
    
    -- [[ DEFENSIVE & WEAPON ]]
    ["armor"]       = "ITEM_MOD_ARMOR_SHORT",
    ["block"]       = "ITEM_MOD_BLOCK_VALUE_SHORT",
    ["block value"] = "ITEM_MOD_BLOCK_VALUE_SHORT",
    ["shield block"]= "ITEM_MOD_BLOCK_VALUE_SHORT",
    ["speed"]       = "MSC_WEAPON_SPEED",
    ["dps"]         = "MSC_WEAPON_DPS",
    ["damage per second"] = "MSC_WEAPON_DPS",
    
    -- [[ RESISTANCES ]]
    ["shadow resistance"] = "ITEM_MOD_SHADOW_RESISTANCE_SHORT",
    ["fire resistance"]   = "ITEM_MOD_FIRE_RESISTANCE_SHORT",
    ["frost resistance"]  = "ITEM_MOD_FROST_RESISTANCE_SHORT",
    ["arcane resistance"] = "ITEM_MOD_ARCANE_RESISTANCE_SHORT",
    ["nature resistance"] = "ITEM_MOD_NATURE_RESISTANCE_SHORT",
    
    -- [[ OFFENSIVE / SPELL ]]
    ["attack power"]       = "ITEM_MOD_ATTACK_POWER_SHORT", 
    ["feral attack power"] = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
    ["healing spells"]     = "ITEM_MOD_HEALING_POWER_SHORT",
    ["healing"]            = "ITEM_MOD_HEALING_POWER_SHORT",
    ["spell damage"]       = "ITEM_MOD_SPELL_POWER_SHORT",
    ["spell power"]        = "ITEM_MOD_SPELL_POWER_SHORT",
    
    -- [[ SCHOOL DAMAGE ]]
    ["shadow damage"]  = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["fire damage"]    = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["frost damage"]   = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["arcane damage"]  = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["nature damage"]  = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["holy damage"]    = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    
	-- "Spell Damage" Variants (Crucial for TBC Random Enchants)
    ["shadow spell damage"]  = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["fire spell damage"]    = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["frost spell damage"]   = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["arcane spell damage"]  = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["nature spell damage"]  = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["holy spell damage"]    = "ITEM_MOD_HOLY_DAMAGE_SHORT",
	
    -- [[ RESOURCES ]]
    ["mana"]   = "ITEM_MOD_MANA_SHORT",
    ["health"] = "ITEM_MOD_HEALTH_SHORT",
    ["hp"]     = "ITEM_MOD_HEALTH_SHORT",
    ["mp"]     = "ITEM_MOD_MANA_SHORT",
    
    -- [[ RATINGS (TBC+ / ERA) ]]
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

-- Map for "Green Text" (Equip/Use effects) - Also Lowercase
MSC.Scanner.TermMap = {
    -- [[ HIT & CRIT ]]
    ["hit rating"]        = "ITEM_MOD_HIT_RATING_SHORT",
    ["chance to hit"]     = "ITEM_MOD_HIT_RATING_SHORT",
    ["critical strike rating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["chance to get a critical strike"] = "ITEM_MOD_CRIT_RATING_SHORT",
    
    -- [[ SPELL ]]
    ["spell hit rating"]  = "ITEM_MOD_HIT_SPELL_RATING_SHORT",
    ["spell critical strike rating"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT",
    ["critical strike with spells"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT",
    ["haste rating"]       = "ITEM_MOD_HASTE_RATING_SHORT",
    ["spell haste rating"] = "ITEM_MOD_SPELL_HASTE_RATING_SHORT",
    ["spell penetration"]  = "ITEM_MOD_SPELL_PENETRATION_SHORT",
    
    -- [[ MELEE / TANK ]]
    ["armor penetration rating"] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",
    ["expertise rating"]   = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    ["ranged attack power"]= "ITEM_MOD_RANGED_ATTACK_POWER_SHORT",
    ["defense rating"]    = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["increased defense"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["defense"]           = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["dodge rating"]      = "ITEM_MOD_DODGE_RATING_SHORT",
    ["chance to dodge"]   = "ITEM_MOD_DODGE_RATING_SHORT",
    ["parry rating"]      = "ITEM_MOD_PARRY_RATING_SHORT",
    ["chance to parry"]   = "ITEM_MOD_PARRY_RATING_SHORT",
    ["block rating"]      = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["chance to block"]   = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["shield block value"]= "ITEM_MOD_BLOCK_VALUE_SHORT",
    ["resilience rating"] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
    
    -- [[ POWER ]]
    ["attack power"]      = "ITEM_MOD_ATTACK_POWER_SHORT",
    ["attack power in cat"] = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
    ["feral attack power"]  = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
    ["spell power"]       = "ITEM_MOD_SPELL_POWER_SHORT",
    ["healing"]           = "ITEM_MOD_HEALING_POWER_SHORT",
    ["mana per 5 sec"]    = "ITEM_MOD_MANA_REGENERATION_SHORT",
    ["health per 5 sec"]  = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
    
    -- [[ CLASSIC PHRASINGS (Long Form) ]]
    ["damage and healing done by magical spells and effects"] = "ITEM_MOD_SPELL_POWER_SHORT",
    ["healing done by spells and effects"] = "ITEM_MOD_HEALING_POWER_SHORT",
    ["damage done by shadow spells and effects"] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["damage done by fire spells and effects"]   = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["damage done by frost spells and effects"]  = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["damage done by arcane spells and effects"] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["damage done by nature spells and effects"] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["damage done by holy spells and effects"]   = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    
    -- [[ RESISTANCES ]]
    ["shadow resistance"] = "ITEM_MOD_SHADOW_RESISTANCE_SHORT",
    ["fire resistance"]   = "ITEM_MOD_FIRE_RESISTANCE_SHORT",
    ["frost resistance"]  = "ITEM_MOD_FROST_RESISTANCE_SHORT",
    ["arcane resistance"] = "ITEM_MOD_ARCANE_RESISTANCE_SHORT",
    ["nature resistance"] = "ITEM_MOD_NATURE_RESISTANCE_SHORT",
    ["all resistances"]   = "ITEM_MOD_ALL_RESISTANCE_SHORT",
    ["resistance to all schools of magic"] = "ITEM_MOD_ALL_RESISTANCE_SHORT",

    -- [[ BASE STATS (For "Use: Increases..." lines) ]]
    ["strength"] = "ITEM_MOD_STRENGTH_SHORT",
    ["agility"]  = "ITEM_MOD_AGILITY_SHORT",
    ["stamina"]  = "ITEM_MOD_STAMINA_SHORT",
    ["intellect"]= "ITEM_MOD_INTELLECT_SHORT",
    ["spirit"]   = "ITEM_MOD_SPIRIT_SHORT",
    ["armor"]    = "ITEM_MOD_ARMOR_SHORT",
    
    -- [[ WEAPON SKILLS (Classic Era) ]]
    ["swords"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["axes"]     = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["maces"]    = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["daggers"]  = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["bows"]     = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["guns"]     = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["staves"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["polearms"] = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["two-handed swords"] = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["two-handed axes"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["two-handed maces"]  = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with swords"] = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with axes"]   = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT",
    ["skill with maces"]  = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT"
}

-- =============================================================
-- 2. PATTERN DATABASE (ROBUST MATCHING)
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
    -- [[ FERAL AP ]] 
    -- MUST be before the generic parser, or it will just be read as normal Attack Power!
    { p = "Increases (attack power) by (%d+) in", valIdx = 2, nameIdx = 1, fixedStat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },
    
    -- [[ RESTORES (MP5/HP5) ]]
    -- "Restores" doesn't match "Increases", so these are required.
    { p = "Restores (%d+) (mana per 5 sec)%.?", valIdx = 1, nameIdx = 2 },
    { p = "Restores (%d+) (health per 5 sec)%.?", valIdx = 1, nameIdx = 2 },
    
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
        Meta = { SetName = nil, SetCount = 0, Sockets = {}, SocketBonusActive = false }
    }
end

local function ParseCooldown(text)
    -- [[ FIX: CASE INSENSITIVE MATCHING ]]
    local lowerText = text:lower()
    
    local min = lowerText:match("%((%d+) min cooldown%)")
    if min then return tonumber(min) * 60 end
    
    local sec = lowerText:match("%((%d+) sec cooldown%)")
    if sec then return tonumber(sec) end
    
    return 120 -- Default to 2 mins if we can't read it
end

function MSC.Scanner.ClassifyLine(text, colorR, colorG, colorB)
    if not text or text == "" then return "SKIP" end
    
    -- [[ FIX: STRIP COLORS FOR CLASSIFICATION ]]
    -- We must strip colors here, otherwise "^Equip:" fails if the line starts with |cff...
    local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    
    if cleanText:find("Chance on hit") or cleanText:find("When struck") then return "PROC" end
    if cleanText:find("^Equip:") then return "EQUIP" end
    if cleanText:find("^Use:") then return "USE" end
    
    -- Set/Socket checks usually don't have this issue, but consistency is good
    if cleanText:find("Set:") or cleanText:find("%(%d/%d%)") then return "SET" end
    if cleanText:find("Socket") and not cleanText:find("Bonus") then return "SOCKET_INFO" end 
    if cleanText:find("Socket Bonus:") then return "SOCKET_BONUS" end
    
    if cleanText:find("%d") then return "STAT" end 
    
    return "FLUFF"
end

-- =============================================================
-- 4. SUB-PARSERS
-- =============================================================

function MSC.Scanner.ParseStatLine(text, outputTable)
    if not text then return end
    
    -- Strip color codes to handle white text that might be wrapped in color tags
    local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    
    for _, pat in ipairs(MSC.Scanner.StatPatterns) do
        local match1, match2 = cleanText:match(pat.p)
        if match1 then
            if pat.type == "RANGE" then
                outputTable["MSC_DAMAGE_RANGE_MIN"] = tonumber(match1)
                outputTable["MSC_DAMAGE_RANGE_MAX"] = tonumber(match2)
                return
            end

            local val, rawName
            if pat.fixedStat then
                val = tonumber(match1); rawName = pat.fixedStat
            else
                if pat.valIdx == 1 then val = tonumber(match1); rawName = match2
                else val = tonumber(match2); rawName = match1 end
            end
            
            if rawName then
                -- [[ NORMALIZATION ]]
                -- 1. Remove "to " prefix (e.g. "+30 to Healing" -> "Healing")
                -- 2. Lowercase all text
                -- 3. Trim extra whitespace
                local cleanName = rawName:lower():gsub("^to%s+", ""):match("^%s*(.-)%s*$")
                
                local key = MSC.Scanner.BaseStatMap[cleanName]
                
                -- Fallback check for exact word matching if map failed
                if not key and cleanName == "armor" then key = "ITEM_MOD_ARMOR_SHORT" end

                if key and val then
                    outputTable[key] = (outputTable[key] or 0) + val
                    return 
                end
            end
        end
    end
end

function MSC.Scanner.ParseEquipLine(text, outputStats, outputProcs)
    -- [[ FIX: STRIP COLORS FROM EQUIP LINES ]]
    local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("^Equip: ", "")
    
    for _, pat in ipairs(MSC.Scanner.EquipPatterns) do
        local match1, match2 = cleanText:match(pat.p)
        if match1 then
            
            -- [[ LOGIC FIX: Handle fixedStat vs Dynamic Name ]]
            if pat.fixedStat then
                -- If we have a fixed stat (like Feral AP), we grab the value from the designated index
                local valStr = match1
                if pat.valIdx == 2 then valStr = match2 end
                
                local val = tonumber(valStr)
                if val then
                    outputStats[pat.fixedStat] = (outputStats[pat.fixedStat] or 0) + val
                end
                return
            else
                -- Dynamic Stat Name (e.g. "Increases Hit Rating by 10")
                local val, rawName
                if pat.valIdx == 1 then val = tonumber(match1); rawName = match2
                else val = tonumber(match2); rawName = match1 end
                
                local cleanName = rawName:lower():match("^%s*(.-)%s*$")
                local key = MSC.Scanner.TermMap[cleanName]
                
                if key and val then
                    outputStats[key] = (outputStats[key] or 0) + val
                    return
                end
            end
        end
    end
    -- Fallback: If unmatched, store as text description
    table.insert(outputProcs, { type = "Equip", desc = cleanText })
end

function MSC.Scanner.ParseProcLine(text, outputProcs)
    -- [[ FIX: STRIP COLORS FIRST ]]
    -- We do this first so we don't miss the "Chance on hit:" prefix if it's colored yellow
    local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    
    -- Now remove the prefixes safely
    cleanText = cleanText:gsub("^Chance on hit: ", ""):gsub("^Equip: Chance on hit: ", "")

    for _, pat in ipairs(MSC.Scanner.ProcPatterns) do
        local match1, match2, match3 = cleanText:match(pat.p)
        if match1 then
            local procObj = { description = text }
            
            if pat.type == "DAMAGE" then
                procObj.type = "Damage"
                procObj.val = tonumber(match1)
                if match2 then procObj.val = (procObj.val + tonumber(match2)) / 2 end
                
            elseif pat.type == "HEAL" or pat.type == "MANA" then
                procObj.type = pat.type
                procObj.val = tonumber(match1)
                
            elseif pat.valIdx then
                -- This handles "Increases X by Y..."
                -- Without the color strip, 'match1' (the name) would contain |cffff...|r
                procObj.type = "Stat"
                procObj.val = tonumber(match2)
                procObj.duration = tonumber(match3)
                procObj.statName = match1 
                
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
    -- 1. STRIP COLORS (Essential!)
    local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("^Use: ", "")
    
    local cooldown = ParseCooldown(text)
    
    for _, pat in ipairs(MSC.Scanner.UsePatterns) do
        local match1, match2, match3 = cleanText:match(pat.p)
        if match1 then
            local effect = { raw = text, cooldown = cooldown }
            
            if pat.type == "BUFF" then
                local val = tonumber(pat.valIdx == 1 and match1 or match2)
                local name = pat.nameIdx and (pat.nameIdx == 1 and match1 or match2)
                local duration = tonumber(match3) or pat.defaultDur or 15
                
                effect.averageVal = val * (duration / cooldown)
                effect.duration = duration
                
                if pat.fixedStat then 
                    effect.statKey = pat.fixedStat
                elseif name then
                    -- [[ FIX: REMOVE 'YOUR' FROM STAT NAME ]]
                    -- Turns "your Spell Power" into "Spell Power" so the lookup works
                    local cleanName = name:lower():gsub("your ", ""):match("^%s*(.-)%s*$")
                    
                    effect.statKey = MSC.Scanner.TermMap[cleanName]
                    effect.statName = name 
                end
                effect.type = "Stat"
                
            elseif pat.type == "MANA" or pat.type == "HEALTH" or pat.type == "MANA_RANGE" or pat.type == "HEALTH_RANGE" then
                local val = tonumber(match1)
                if match2 then val = (val + tonumber(match2)) / 2 end
                
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

function MSC.Scanner.ParseSetLine(text, r, g, b, metaTable, outputStats)
    local setName, current, total = text:match("^(.*) %((%d+)/(%d+)%)$")
    if setName then metaTable.SetName = setName; metaTable.SetCount = tonumber(current); return end
   --[[ local required = text:match("^%((%d+)%) Set:")
    if required then
        if g > 0.8 and r < 0.6 then 
            local cleanEffect = text:gsub("^%((%d+)%) Set: ", "")
            MSC.Scanner.ParseEquipLine(cleanEffect, outputStats, {})
        end
    end--]]
end

-- =============================================================
-- 5. MAIN PIPELINE
-- =============================================================

function MSC.Scanner.Scan(itemLink)
    local result = CreateItemObject()
    if not itemLink then return result end

    local tip = _G["MSC_NewScannerTooltip"] or CreateFrame("GameTooltip", "MSC_NewScannerTooltip", nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    tip:ClearLines()
    local status = pcall(function() tip:SetHyperlink(itemLink) end)
    if not status then return result end

    for i = 2, tip:NumLines() do 
        local lineObj = _G["MSC_NewScannerTooltipTextLeft"..i]
        local text = lineObj:GetText()
        local r, g, b = lineObj:GetTextColor() 

        if text then
            local lineType = MSC.Scanner.ClassifyLine(text, r, g, b)
            if lineType == "STAT" then MSC.Scanner.ParseStatLine(text, result.Stats)
            elseif lineType == "EQUIP" then MSC.Scanner.ParseEquipLine(text, result.Stats, result.Procs)
            elseif lineType == "USE" then MSC.Scanner.ParseUseLine(text, result.UseEffects)
            elseif lineType == "SET" then MSC.Scanner.ParseSetLine(text, r, g, b, result.Meta, result.Stats)
            elseif lineType == "SOCKET_BONUS" and g > 0.9 and r < 0.2 then 
                result.Meta.SocketBonusActive = true
                if not result.Meta.BonusStats then result.Meta.BonusStats = {} end
                MSC.Scanner.ParseStatLine(text, result.Meta.BonusStats)
            elseif lineType == "PROC" then MSC.Scanner.ParseProcLine(text, result.Procs)
            end
        end
    end

    if result.Stats["MSC_WEAPON_SPEED"] and not result.Stats["MSC_WEAPON_DPS"] and result.Stats["MSC_DAMAGE_RANGE_MIN"] then
        local avg = (result.Stats["MSC_DAMAGE_RANGE_MIN"] + result.Stats["MSC_DAMAGE_RANGE_MAX"]) / 2
        local dps = avg / result.Stats["MSC_WEAPON_SPEED"]
        local mult = 10; result.Stats["MSC_WEAPON_DPS"] = math.floor(dps * mult + 0.5) / mult
    end
    result.Stats["MSC_DAMAGE_RANGE_MIN"] = nil
    result.Stats["MSC_DAMAGE_RANGE_MAX"] = nil

    return result
end