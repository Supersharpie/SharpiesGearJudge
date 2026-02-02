local addonName, MSC = ...
_G.MSC = MSC 

MSC.Scanner = {}

-- =============================================================
-- 1. DATA MAPS
-- =============================================================
MSC.Scanner.BaseStatMap = {
    ["strength"]  = "ITEM_MOD_STRENGTH_SHORT",
    ["agility"]   = "ITEM_MOD_AGILITY_SHORT",
    ["stamina"]   = "ITEM_MOD_STAMINA_SHORT",
    ["intellect"] = "ITEM_MOD_INTELLECT_SHORT",
    ["spirit"]    = "ITEM_MOD_SPIRIT_SHORT",
    ["armor"]     = "ITEM_MOD_ARMOR_SHORT",
    ["block"]     = "ITEM_MOD_BLOCK_VALUE_SHORT",
    ["block value"] = "ITEM_MOD_BLOCK_VALUE_SHORT",
    ["speed"]     = "MSC_WEAPON_SPEED",
    ["dps"]       = "MSC_WEAPON_DPS",
    ["damage per second"] = "MSC_WEAPON_DPS",
    ["attack power"] = "ITEM_MOD_ATTACK_POWER_SHORT",
    ["crit rating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["hit rating"] = "ITEM_MOD_HIT_RATING_SHORT",
    ["defense rating"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["dodge rating"] = "ITEM_MOD_DODGE_RATING_SHORT",
    ["parry rating"] = "ITEM_MOD_PARRY_RATING_SHORT",
    ["resilience rating"] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
    ["spell power"] = "ITEM_MOD_SPELL_POWER_SHORT",
    ["healing"] = "ITEM_MOD_HEALING_POWER_SHORT",
    ["mp"] = "ITEM_MOD_MANA_SHORT",
    ["hp"] = "ITEM_MOD_HEALTH_SHORT",
    ["mana per 5 sec"] = "ITEM_MOD_MANA_REGENERATION_SHORT",
    ["health per 5 sec"] = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
    ["feral attack power"] = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
    ["shadow damage"] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["fire damage"] = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["frost damage"] = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["arcane damage"] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["nature damage"] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["holy damage"] = "ITEM_MOD_HOLY_DAMAGE_SHORT",
    ["shadow spell damage"] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["fire spell damage"] = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["frost spell damage"] = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["arcane spell damage"] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["nature spell damage"] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["holy spell damage"] = "ITEM_MOD_HOLY_DAMAGE_SHORT",
}

MSC.Scanner.TermMap = {
    ["hit rating"] = "ITEM_MOD_HIT_RATING_SHORT",
    ["crit rating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["critical strike rating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["defense rating"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["defense"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["attack power"] = "ITEM_MOD_ATTACK_POWER_SHORT",
    ["spell power"] = "ITEM_MOD_SPELL_POWER_SHORT",
    ["healing"] = "ITEM_MOD_HEALING_POWER_SHORT",
    ["mana per 5 sec"] = "ITEM_MOD_MANA_REGENERATION_SHORT",
    ["health per 5 sec"] = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
    ["strength"] = "ITEM_MOD_STRENGTH_SHORT",
    ["agility"] = "ITEM_MOD_AGILITY_SHORT",
    ["stamina"] = "ITEM_MOD_STAMINA_SHORT",
    ["intellect"] = "ITEM_MOD_INTELLECT_SHORT",
    ["spirit"] = "ITEM_MOD_SPIRIT_SHORT",
    ["spell hit rating"] = "ITEM_MOD_HIT_SPELL_RATING_SHORT",
    ["spell critical strike rating"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT",
    ["haste rating"] = "ITEM_MOD_HASTE_RATING_SHORT",
    ["spell haste rating"] = "ITEM_MOD_SPELL_HASTE_RATING_SHORT",
    ["armor penetration rating"] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",
    ["expertise rating"] = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    ["block rating"] = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["shield block value"] = "ITEM_MOD_BLOCK_VALUE_SHORT",
}

-- =============================================================
-- 2. PATTERNS (LOOSE MATCHING)
-- =============================================================
MSC.Scanner.StatPatterns = {
    -- [[ 1. DPS (Matches "38.9 damage per second" anywhere in the line) ]]
    { p = "(%d+%.?%d*)%s+damage%s+per%s+second", fixedStat = "MSC_WEAPON_DPS" },
    { p = "(%d+%.?%d*)%s+dps", fixedStat = "MSC_WEAPON_DPS" },
    
    -- [[ 2. SPEED (Matches "Speed 2.80" anywhere) ]]
    { p = "speed%s+(%d+%.?%d*)", fixedStat = "MSC_WEAPON_SPEED" },
    
    -- [[ 3. DAMAGE RANGE (Matches "87 - 131 Damage" or "87 to 131 Damage") ]]
    { p = "(%d+)%s*[%-%p]%s*(%d+)%s+damage", type="RANGE" },
    { p = "(%d+)%s+to%s+(%d+)%s+damage", type="RANGE" },

    -- [[ 4. STANDARD STATS (Prefix/Suffix) ]]
    { p = "^[%s%+]*(%d+%.?%d*)%s+(.*)$", valIdx = 1, nameIdx = 2 },
    { p = "^(.*)%s+[%+:]*%s*(%d+%.?%d*)$", valIdx = 2, nameIdx = 1 },
}

MSC.Scanner.EquipPatterns = {
    { p = "^%+?%s*(%d+)%%? (.*)$", valIdx = 1, nameIdx = 2 },
    { p = "^(.-) %+(%d+)%%?$", valIdx = 2, nameIdx = 1 },
    { p = "increases (attack power) by (%d+) in", valIdx = 2, nameIdx = 1, fixedStat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },
    { p = "increases (.*) by (%d+)", valIdx = 2, nameIdx = 1 },
    { p = "improves (.*) by (%d+)", valIdx = 2, nameIdx = 1 },
    { p = "restores (%d+) (.*) per 5 sec", valIdx=1, nameIdx=2 },
    { p = "restores (%d+) health every ([%d%.]+) sec", valIdx = 1, nameIdx = 2, fixedStat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
    { p = "ignore (%d+) of your opponent's armor", valIdx = 1, fixedStat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" },
    { p = "decreases (threat) caused", valIdx = nil, fixedStat = "MSC_THREAT_MOD" },
}

MSC.Scanner.ProcPatterns = {
    { p = "^%+(%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "grants (%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "chance on hit:", type="PROC" },
    { p = "equip: chance on hit:", type="PROC" },
    { p = "for (%d+) .*damage", type="DAMAGE" },
    { p = "inflicts (%d+) .*damage", type="DAMAGE" },
}

MSC.Scanner.UsePatterns = {
    { p = "^%+(%d+) (.*) for (%d+) sec", valIdx=1, nameIdx=2, durIdx=3, type="BUFF" },
    { p = "increases (.*) by (%d+) for (%d+) sec", valIdx=2, nameIdx=1, durIdx=3, type="BUFF" },
    { p = "use: (.*)", type="USE" }
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
    if not text then return "SKIP" end
    local clean = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("\n", " ")
    
    if clean:find("Chance on hit") then return "PROC" end
    if clean:find("^Use:") then return "USE" end
    if clean:find("^Equip:") or clean:find("^Increases") or clean:find("^Improves") or clean:find("^Restores") then return "EQUIP" end
    if clean:find("Set:") then return "SET" end
    if clean:find("Socket Bonus:") then return "SOCKET_BONUS" end
    if clean:find("%d") then return "STAT" end 
    return "FLUFF"
end

-- =============================================================
-- 4. SUB-PARSERS
-- =============================================================

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

function MSC.Scanner.ParseEquipLine(text, outputStats, outputProcs)
    local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("\n", " "):gsub("^Equip: ", ""):gsub("%s+", " "):lower()
    cleanText = cleanText:gsub("^equip: ", "")
    
    for _, pat in ipairs(MSC.Scanner.EquipPatterns) do
        local m1, m2 = cleanText:match(pat.p)
        if m1 then
            local val = tonumber(pat.valIdx == 1 and m1 or m2)
            local name = pat.valIdx == 1 and m2 or m1
            if val and name then
                local cleanName = name:gsub("your ", ""):gsub("%s+$", "")
                local key = MSC.Scanner.TermMap[cleanName]
                if key then outputStats[key] = (outputStats[key] or 0) + val; return end
            end
        end
    end
    table.insert(outputProcs, { type = "Equip", desc = text })
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
                procObj.val = tonumber(m1)
            elseif pat.valIdx then
                procObj.type = "Stat"
                procObj.val = tonumber(m2)
                procObj.duration = tonumber(m3)
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
            end
            table.insert(outputUseTable, effect)
            return
        end
    end
end

function MSC.Scanner.ParseSetLine(text, r, g, b, metaTable, outputStats)
    local setName, current, total = text:match("^(.*) %((%d+)/(%d+)%)$")
    if setName then metaTable.SetName = setName; metaTable.SetCount = tonumber(current); return end
end

-- =============================================================
-- 5. MAIN PIPELINE (UPDATED FOR RIGHT-SIDE SCANNING)
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
                result.Meta.SocketBonusActive = true
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