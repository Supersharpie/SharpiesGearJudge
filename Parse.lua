local addonName, MSC = ...
MSC.Scanner = {}

-- Map for "White Text" Stats (Base Stats)
-- =============================================================
-- 1. DATA MAPS (Shared Dictionaries)
-- =============================================================

-- [[ A. WHITE TEXT MAP (Base Stats + Suffixes) ]]
MSC.Scanner.BaseStatMap = {
    -- Primary
    ["Strength"] = "ITEM_MOD_STRENGTH_SHORT",
    ["Agility"]  = "ITEM_MOD_AGILITY_SHORT",
    ["Stamina"]  = "ITEM_MOD_STAMINA_SHORT",
    ["Intellect"]= "ITEM_MOD_INTELLECT_SHORT",
    ["Spirit"]   = "ITEM_MOD_SPIRIT_SHORT",
    
    -- Defensive / Weapon
    ["Armor"] = "ITEM_MOD_ARMOR_SHORT",
    ["Block"] = "ITEM_MOD_BLOCK_VALUE_SHORT",
    ["Speed"] = "MSC_WEAPON_SPEED",
    ["damage per second"] = "MSC_WEAPON_DPS",
    ["Damage Per Second"] = "MSC_WEAPON_DPS",
    
    -- Resistances (Often White Text on Gear)
    ["Shadow Resistance"] = "ITEM_MOD_SHADOW_RESISTANCE_SHORT",
    ["Fire Resistance"]   = "ITEM_MOD_FIRE_RESISTANCE_SHORT",
    ["Frost Resistance"]  = "ITEM_MOD_FROST_RESISTANCE_SHORT",
    ["Arcane Resistance"] = "ITEM_MOD_ARCANE_RESISTANCE_SHORT",
    ["Nature Resistance"] = "ITEM_MOD_NATURE_RESISTANCE_SHORT",
    
    -- Random Suffixes (The "Cheats")
    ["Attack Power"]   = "ITEM_MOD_ATTACK_POWER_SHORT", 
    ["Healing Spells"] = "ITEM_MOD_HEALING_POWER_SHORT",
    ["Spell Damage"]   = "ITEM_MOD_SPELL_POWER_SHORT",
    ["Shadow Damage"]  = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["Fire Damage"]    = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["Frost Damage"]   = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["Arcane Damage"]  = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["Nature Damage"]  = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["Holy Damage"]    = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    ["Mana"]           = "ITEM_MOD_MANA_SHORT",
    ["Health"]         = "ITEM_MOD_HEALTH_SHORT",
    
    -- TBC Ratings (White Text Variants)
    ["Dodge Rating"]      = "ITEM_MOD_DODGE_RATING_SHORT",
    ["Parry Rating"]      = "ITEM_MOD_PARRY_RATING_SHORT",
    ["Block Rating"]      = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["Hit Rating"]        = "ITEM_MOD_HIT_RATING_SHORT",
    ["Crit Rating"]       = "ITEM_MOD_CRIT_RATING_SHORT",
    ["Critical Strike Rating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["Haste Rating"]      = "ITEM_MOD_HASTE_RATING_SHORT",
    ["Resilience Rating"] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
    ["Defense Rating"]    = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["Expertise Rating"]  = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    ["Armor Penetration Rating"] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"
}

-- [[ B. GREEN TEXT MAP (Equip / Use / Proc Effects) ]]
-- Maps lowercase text phrases to Internal Keys
MSC.Scanner.TermMap = {
    -- [[ 1. OFFENSIVE RATINGS ]]
    ["hit rating"]        = "ITEM_MOD_HIT_RATING_SHORT",
    ["chance to hit"]     = "ITEM_MOD_HIT_RATING_SHORT", -- Era
    
    ["critical strike rating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["chance to get a critical strike"] = "ITEM_MOD_CRIT_RATING_SHORT", -- Era
    
    ["spell hit rating"]  = "ITEM_MOD_HIT_SPELL_RATING_SHORT",
    ["spell critical strike rating"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT",
    ["critical strike with spells"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT", -- Era
    
    ["haste rating"]       = "ITEM_MOD_HASTE_RATING_SHORT",
    ["spell haste rating"] = "ITEM_MOD_SPELL_HASTE_RATING_SHORT",
    ["spell penetration"]  = "ITEM_MOD_SPELL_PENETRATION_SHORT",
    ["armor penetration rating"] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",
    ["expertise rating"]   = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    ["ranged attack power"]= "ITEM_MOD_RANGED_ATTACK_POWER_SHORT",

    -- [[ 2. DEFENSIVE RATINGS ]]
    ["defense rating"]    = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["increased defense"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", -- Era
    ["dodge rating"]      = "ITEM_MOD_DODGE_RATING_SHORT",
    ["chance to dodge"]   = "ITEM_MOD_DODGE_RATING_SHORT", -- Era
    ["parry rating"]      = "ITEM_MOD_PARRY_RATING_SHORT",
    ["chance to parry"]   = "ITEM_MOD_PARRY_RATING_SHORT", -- Era
    ["block rating"]      = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["chance to block"]   = "ITEM_MOD_BLOCK_RATING_SHORT", -- Era
    ["shield block value"]= "ITEM_MOD_BLOCK_VALUE_SHORT",
    ["resilience rating"] = "ITEM_MOD_RESILIENCE_RATING_SHORT",

    -- [[ 3. RESISTANCES ]]
    ["shadow resistance"] = "ITEM_MOD_SHADOW_RESISTANCE_SHORT",
    ["fire resistance"]   = "ITEM_MOD_FIRE_RESISTANCE_SHORT",
    ["frost resistance"]  = "ITEM_MOD_FROST_RESISTANCE_SHORT",
    ["arcane resistance"] = "ITEM_MOD_ARCANE_RESISTANCE_SHORT",
    ["nature resistance"] = "ITEM_MOD_NATURE_RESISTANCE_SHORT",
    ["all resistances"]   = "ITEM_MOD_ALL_RESISTANCE_SHORT",
    ["resistance to all schools of magic"] = "ITEM_MOD_ALL_RESISTANCE_SHORT", -- Classic phrasing

    -- [[ 4. POWER STATS ]]
    ["attack power"]      = "ITEM_MOD_ATTACK_POWER_SHORT",
    ["attack power in cat"] = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
    ["spell power"]       = "ITEM_MOD_SPELL_POWER_SHORT",
    ["healing"]           = "ITEM_MOD_HEALING_POWER_SHORT",
    ["mana per 5 sec"]    = "ITEM_MOD_MANA_REGENERATION_SHORT",
    ["health per 5 sec"]  = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
    
    -- [[ 5. ERA SPELL DAMAGE ("Up to") ]]
    ["damage and healing done by magical spells and effects"] = "ITEM_MOD_SPELL_POWER_SHORT",
    ["healing done by spells and effects"] = "ITEM_MOD_HEALING_POWER_SHORT",
    
    -- Specific Schools (Era)
    ["damage done by shadow spells and effects"] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["damage done by fire spells and effects"]   = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["damage done by frost spells and effects"]  = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["damage done by arcane spells and effects"] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["damage done by nature spells and effects"] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["damage done by holy spells and effects"]   = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    
    -- TBC Short Forms (sometimes found in Use effects)
    ["shadow damage"] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["fire damage"]   = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["frost damage"]  = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["arcane damage"] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["nature damage"] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["holy damage"]   = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    
    -- [[ 6. BASE STATS (For "Use: Increases Strength..." lines) ]]
    ["strength"] = "ITEM_MOD_STRENGTH_SHORT",
    ["agility"]  = "ITEM_MOD_AGILITY_SHORT",
    ["stamina"]  = "ITEM_MOD_STAMINA_SHORT",
    ["intellect"]= "ITEM_MOD_INTELLECT_SHORT",
    ["spirit"]   = "ITEM_MOD_SPIRIT_SHORT",
    ["armor"]    = "ITEM_MOD_ARMOR_SHORT",
    ["mana"]     = "ITEM_MOD_MANA_SHORT",
    ["health"]   = "ITEM_MOD_HEALTH_SHORT",
	
	-- [[ 7. WEAPON SKILLS (Era / Classic) ]]
	-- We map these to the generic Weapon Skill rating, which Database.lua maps to Expertise
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
    -- White Text
    { p = "^%+(%d+) (.*)$", valIdx = 1, nameIdx = 2 },
    { p = "^(.*) %+(%d+)$", valIdx = 2, nameIdx = 1 },
    { p = "^(%d+) Armor$", valIdx = 1, fixedStat = "ITEM_MOD_ARMOR_SHORT" },
    { p = "^(%d+) Block$", valIdx = 1, fixedStat = "ITEM_MOD_BLOCK_VALUE_SHORT" },
    { p = "^Speed (%d+%.?%d*)$", valIdx = 1, fixedStat = "MSC_WEAPON_SPEED" },
    
    -- DPS Explicit
    { p = "^%((%d+%.?%d*) (damage per second)%)$", valIdx = 1, fixedStat = "MSC_WEAPON_DPS" },
    { p = "^%((%d+%.?%d*) (Damage Per Second)%)$", valIdx = 1, fixedStat = "MSC_WEAPON_DPS" },
    
    -- Damage Range (Critical for implicit DPS calc on Era)
    -- Matches "20 - 30 Damage"
    { p = "^(%d+) %- (%d+) Damage$", type="RANGE" }
}

MSC.Scanner.EquipPatterns = {
    -- 1. Standard "Increases your X by Y" (TBC Ratings)
    { p = "Increases your (.*) by (%d+)%.?", valIdx = 2, nameIdx = 1 },
    { p = "Increases (.*) by (%d+)%.?", valIdx = 2, nameIdx = 1 },
    
    -- 2. "Restores X mana/health per 5 sec"
    { p = "Restores (%d+) (mana per 5 sec)%.?", valIdx = 1, nameIdx = 2 },
    { p = "Restores (%d+) (health per 5 sec)%.?", valIdx = 1, nameIdx = 2 }, -- Added this
    
    -- 3. Era Percentages: "Improves your chance to hit by 1%."
    { p = "Improves your (.*) by (%d+)%%%.?", valIdx = 2, nameIdx = 1 },
    
    -- 4. Era Spell Power: "Increases damage... by up to 30."
    { p = "Increases (.*) by up to (%d+)%.?", valIdx = 2, nameIdx = 1 },
    
    -- 5. Era Weapon Skill: "Increased Daggers +5"
    { p = "Increased (.*) %+(%d+)%.?", valIdx = 2, nameIdx = 1 },
    
    -- 6. Feral AP (Short Form)
    { p = "Increases (attack power) by (%d+) in", valIdx = 2, nameIdx = 1, fixedStat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },
    
    -- 7. ArPen (Ignore Armor)
    { p = "ignore (%d+) of your opponent's armor", valIdx = 1, fixedStat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" },

    -- 8. Threat Reduction (Generic catch-all)
    -- Matches "Decreases the threat caused by your attacks..."
    -- We assume the user wants to see this even if we can't perfectly score it yet.
    -- For now, we can map "threat" in the TermMap if you have a stat for it, otherwise it's skipped.
    { p = "Decreases (threat) caused", valIdx = nil, fixedStat = "MSC_THREAT_MOD" } -- Requires value logic if it has a %
}

MSC.Scanner.ProcPatterns = {
    { p = "Increases (.*) by (%d+) for (%d+) sec", valIdx=2, nameIdx=1, durIdx=3 },
    { p = "for (%d+) to (%d+) damage", type="DAMAGE" },
    { p = "for (%d+) damage", type="DAMAGE" },
    { p = "steals (%d+) life", type="HEAL" },
    { p = "Restores (%d+) mana", type="MANA" },
    { p = "Blasts your enemy", type="GENERIC" } -- Thunderfury etc
}

MSC.Scanner.UsePatterns = {
    { p = "Increases (.*) by (%d+) for (%d+) sec", valIdx=2, nameIdx=1, durIdx=3, type="BUFF" },
    { p = "Restores (%d+) mana", valIdx=1, type="MANA" },
    { p = "Restores (%d+) health", valIdx=1, type="HEALTH" },
    { p = "Restores (%d+) to (%d+) mana", type="MANA_RANGE" },
    { p = "Restores (%d+) to (%d+) health", type="HEALTH_RANGE" },
    { p = "Adds (%d+) damage", valIdx=1, fixedStat="ITEM_MOD_DAMAGE_PER_SECOND_SHORT", type="BUFF", defaultDur=15 }
}

-- =============================================================
-- 3. UTILITIES & STRUCTS
-- =============================================================

local function CreateItemObject()
    return {
        Stats = {},         
        UseEffects = {},    
        Procs = {},         
        Meta = { SetName = nil, SetCount = 0, Sockets = {}, SocketBonusActive = false }
    }
end

local function ParseCooldown(text)
    local min = text:match("%((%d+) Min Cooldown%)")
    if min then return tonumber(min) * 60 end
    local sec = text:match("%((%d+) Sec Cooldown%)")
    if sec then return tonumber(sec) end
    return 120 -- Default to 2 min if unspecified
end

function MSC.Scanner.ClassifyLine(text, colorR, colorG, colorB)
    if not text or text == "" then return "SKIP" end

    -- Check Procs first to avoid them being read as Equip/Use
    if text:find("Chance on hit") or text:find("When struck") then return "PROC" end

    if text:find("^Equip:") then return "EQUIP" end
    if text:find("^Use:") then return "USE" end
    if text:find("Set:") or text:find("%(%d/%d%)") then return "SET" end
    if text:find("Socket") and not text:find("Bonus") then return "SOCKET_INFO" end 
    if text:find("Socket Bonus:") then return "SOCKET_BONUS" end
    if text:find("^%+") or text:find("%+%d") or text:find("%d") then return "STAT" end

    return "FLUFF"
end

-- =============================================================
-- 4. SUB-PARSERS
-- =============================================================

function MSC.Scanner.ParseStatLine(text, outputTable)
    if not text then return end
    for _, pat in ipairs(MSC.Scanner.StatPatterns) do
        local match1, match2 = text:match(pat.p)
        if match1 then
            
            -- [[ DAMAGE RANGE HANDLING ]]
            if pat.type == "RANGE" then
                outputTable["MSC_DAMAGE_RANGE_MIN"] = tonumber(match1)
                outputTable["MSC_DAMAGE_RANGE_MAX"] = tonumber(match2)
                return
            end

            -- [[ STANDARD STAT HANDLING ]]
            local val, statName
            if pat.fixedStat then
                val = tonumber(match1); statName = pat.fixedStat
            else
                if pat.valIdx == 1 then val = tonumber(match1); statName = match2
                else val = tonumber(match2); statName = match1 end
            end
            
            if statName then
                statName = strtrim(statName)
                local key = MSC.Scanner.BaseStatMap[statName]
                if key and val then
                    outputTable[key] = (outputTable[key] or 0) + val
                    return 
                end
            end
        end
    end
end

function MSC.Scanner.ParseEquipLine(text, outputStats, outputProcs)
    local cleanText = text:gsub("^Equip: ", "")
    for _, pat in ipairs(MSC.Scanner.EquipPatterns) do
        local match1, match2 = cleanText:match(pat.p)
        if match1 then
            if pat.fixedStat then
                local val = tonumber(match1)
                outputStats[pat.fixedStat] = (outputStats[pat.fixedStat] or 0) + val
                return
            else
                local val, rawName
                if pat.valIdx == 1 then val = tonumber(match1); rawName = match2
                else val = tonumber(match2); rawName = match1 end
                
                rawName = strtrim(rawName):lower()
                local key = MSC.Scanner.TermMap[rawName]
                if key and val then
                    outputStats[key] = (outputStats[key] or 0) + val
                    return
                end
            end
        end
    end
    -- Fallback: If classified as Equip but unmatched, assume complex proc
    table.insert(outputProcs, { type = "Equip", desc = cleanText })
end

function MSC.Scanner.ParseProcLine(text, outputProcs)
    local cleanText = text:gsub("^Chance on hit: ", ""):gsub("^Equip: Chance on hit: ", "")
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
    local cleanText = text:gsub("^Use: ", "")
    local cooldown = ParseCooldown(text)
    
    for _, pat in ipairs(MSC.Scanner.UsePatterns) do
        local match1, match2, match3 = cleanText:match(pat.p)
        if match1 then
            local effect = { raw = text, cooldown = cooldown }
            
            if pat.type == "BUFF" then
                local val = tonumber(pat.valIdx == 1 and match1 or match2)
                local name = pat.nameIdx and (pat.nameIdx == 1 and match1 or match2)
                local duration = tonumber(match3) or pat.defaultDur or 15
                
                -- Calculate Point Value: Val * (Duration / Cooldown)
                effect.averageVal = val * (duration / cooldown)
                effect.duration = duration
                
                if pat.fixedStat then 
                    effect.statKey = pat.fixedStat
                elseif name then
                    local key = strtrim(name):lower()
                    effect.statKey = MSC.Scanner.TermMap[key] 
                    effect.statName = name 
                end
                effect.type = "Stat"
                
            elseif pat.type == "MANA" or pat.type == "MANA_RANGE" then
                local val = (pat.type == "MANA") and tonumber(match1) or (tonumber(match1)+tonumber(match2))/2
                -- Convert Total Mana to Mp5 equivalent
                effect.averageVal = (val / cooldown) * 5
                effect.statKey = "ITEM_MOD_MANA_REGENERATION_SHORT"
                effect.type = "Resource"
                
            elseif pat.type == "HEALTH" or pat.type == "HEALTH_RANGE" then
                local val = (pat.type == "HEALTH") and tonumber(match1) or (tonumber(match1)+tonumber(match2))/2
                effect.averageVal = (val / cooldown) * 5
                effect.statKey = "ITEM_MOD_HEALTH_REGENERATION_SHORT"
                effect.type = "Resource"
            end
            
            table.insert(outputUseTable, effect)
            return
        end
    end
end

function MSC.Scanner.ParseSetLine(text, r, g, b, metaTable, outputStats)
    -- 1. Identify Header: "Justicar Armor (2/5)"
    local setName, current, total = text:match("^(.*) %((%d+)/(%d+)%)$")
    if setName then
        metaTable.SetName = setName
        metaTable.SetCount = tonumber(current)
        return
    end

    -- 2. Identify Bonus: "(2) Set: Increases..."
    local required = text:match("^%((%d+)%) Set:")
    if required then
        -- Check color to see if active (Approx Green/Gold check)
        if g > 0.8 and r < 0.6 then 
            -- Recurse! Treat the rest of the line as an Equip effect
            local cleanEffect = text:gsub("^%((%d+)%) Set: ", "")
            MSC.Scanner.ParseEquipLine(cleanEffect, outputStats, {})
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

            if lineType == "STAT" then
                MSC.Scanner.ParseStatLine(text, result.Stats)
            elseif lineType == "EQUIP" then
                MSC.Scanner.ParseEquipLine(text, result.Stats, result.Procs)
            elseif lineType == "USE" then
                MSC.Scanner.ParseUseLine(text, result.UseEffects)
            elseif lineType == "SET" then
                MSC.Scanner.ParseSetLine(text, r, g, b, result.Meta, result.Stats)
            elseif lineType == "SOCKET_BONUS" then
				if g > 0.9 and r < 0.2 then 
					result.Meta.SocketBonusActive = true
					if not result.Meta.BonusStats then result.Meta.BonusStats = {} end
					MSC.Scanner.ParseStatLine(text, result.Meta.BonusStats)
				end
            elseif lineType == "PROC" then
                MSC.Scanner.ParseProcLine(text, result.Procs)
            end
        end
    end

    -- [[ POST-PROCESSING: DPS CALCULATION ]]
    -- Use the captured range + speed to calculate DPS if the item didn't explicitly say it
    if result.Stats["MSC_WEAPON_SPEED"] and not result.Stats["MSC_WEAPON_DPS"] and result.Stats["MSC_DAMAGE_RANGE_MIN"] then
        local avg = (result.Stats["MSC_DAMAGE_RANGE_MIN"] + result.Stats["MSC_DAMAGE_RANGE_MAX"]) / 2
        local dps = avg / result.Stats["MSC_WEAPON_SPEED"]
        
        -- Round to 1 decimal to match Blizzard UI (e.g. 55.4)
        local mult = 10
        result.Stats["MSC_WEAPON_DPS"] = math.floor(dps * mult + 0.5) / mult
    end
    
    -- Cleanup temp range keys
    result.Stats["MSC_DAMAGE_RANGE_MIN"] = nil
    result.Stats["MSC_DAMAGE_RANGE_MAX"] = nil

    return result
end