local _, MSC = ...

-- =============================================================
-- 1. SCANNERS & PARSERS
-- =============================================================
local scanner = nil
local function GetScanner()
    if not scanner then
        scanner = CreateFrame("GameTooltip", "SGJ_Scanner", nil, "GameTooltipTemplate")
        scanner:SetOwner(UIParent, "ANCHOR_NONE")
    end
    return scanner
end

-- HELPER: Removes color codes
local function StripColor(text)
    if not text then return "" end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", "")
    text = text:gsub("|r", "")
    return text
end

function MSC.IsItemUsable(itemLink)
    if not itemLink then return false end
    local sc = GetScanner()
    sc:ClearLines()
    sc:SetHyperlink(itemLink)
    if not sc.GetNumLines then return true end
    for i = 1, sc:GetNumLines() do
        local leftLine = _G["SGJ_ScannerTextLeft"..i]
        if leftLine then
            local r, g, b = leftLine:GetTextColor()
            if r > 0.9 and g < 0.2 and b < 0.2 then return false end
        end
    end
    return true
end

local function ParseTooltipLine(text, stats)
    if not text then return end
    local cleanText = StripColor(text)

    -- A. STANDARD STATS
    local val, name = cleanText:match("^%+(%d+) (.+)$")
    if not val then name, val = cleanText:match("^(.+) %+(%d+)$") end

    if val and name then
        local key = nil
        if name == "Agility" then key = "ITEM_MOD_AGILITY_SHORT"
        elseif name == "Strength" then key = "ITEM_MOD_STRENGTH_SHORT"
        elseif name == "Stamina" then key = "ITEM_MOD_STAMINA_SHORT"
        elseif name == "Intellect" then key = "ITEM_MOD_INTELLECT_SHORT"
        elseif name == "Spirit" then key = "ITEM_MOD_SPIRIT_SHORT"
        elseif name == "Healing" or name:find("Healing Spells") then key = "ITEM_MOD_HEALING_POWER_SHORT"
        elseif name == "Spell Damage" or name:find("Damage") then 
            if not name:find("per second") then key = "ITEM_MOD_SPELL_POWER_SHORT" end
        end
        if key and not stats[key] then stats[key] = tonumber(val) end
        return
    end

    -- B. GREEN TEXT / EQUIP EFFECTS
    if cleanText:find("Equip:") or cleanText:find("Set:") or cleanText:find("Chance on hit:") then
        if cleanText:find("hit by") then
            val = cleanText:match("by (%d+)%%")
            if val then stats["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = (stats["ITEM_MOD_HIT_SPELL_RATING_SHORT"] or 0) + tonumber(val) end
        elseif cleanText:find("critical strike") then
            val = cleanText:match("by (%d+)%%")
            if val then stats["ITEM_MOD_CRIT_SPELL_RATING_SHORT"] = (stats["ITEM_MOD_CRIT_SPELL_RATING_SHORT"] or 0) + tonumber(val) end
        elseif cleanText:find("Restores") and cleanText:find("mana") then
            val = cleanText:match("Restores (%d+) mana")
            if val then stats["ITEM_MOD_MANA_REGENERATION_SHORT"] = (stats["ITEM_MOD_MANA_REGENERATION_SHORT"] or 0) + tonumber(val) end
        elseif cleanText:find("healing done") then
             val = cleanText:match("up to (%d+)")
             if val then stats["ITEM_MOD_HEALING_POWER_SHORT"] = (stats["ITEM_MOD_HEALING_POWER_SHORT"] or 0) + tonumber(val) end
        elseif cleanText:find("damage and healing") or cleanText:find("magical spells") then
            val = cleanText:match("up to (%d+)")
            if val then stats["ITEM_MOD_SPELL_POWER_SHORT"] = (stats["ITEM_MOD_SPELL_POWER_SHORT"] or 0) + tonumber(val) end
        end
    end
end

local function AddManualStats(link, currentStats)
    local sc = GetScanner()
    sc:ClearLines()
    sc:SetHyperlink(link)
    if not sc.GetNumLines then return end
    for i = 1, sc:GetNumLines() do
        local line = _G["SGJ_ScannerTextLeft"..i]
        if line then ParseTooltipLine(line:GetText(), currentStats) end
    end
end

-- =============================================================
-- 2. ENCHANT LOGIC
-- =============================================================
function MSC.GetEnchantStats(slotID)
    local link = GetInventoryItemLink("player", slotID)
    if not link then return {} end
    
    local _, _, enchantID = string.find(link, "item:%d+:(%d+)")
    enchantID = tonumber(enchantID)
    
    local enchantOnly = {}
    
    if enchantID and MSC.EnchantDB and MSC.EnchantDB[enchantID] then
        local data = MSC.EnchantDB[enchantID]
        
        -- NEW: Loop through the table of stats (supports Multi-Stat enchants)
        for statKey, statVal in pairs(data) do
            enchantOnly[statKey] = statVal
        end
    end
    
    return enchantOnly
end

-- =============================================================
-- 3. CORE CALCULATIONS
-- =============================================================
function MSC.SafeGetItemStats(itemLink, slotID)
    if not itemLink then return {} end 

    -- STEP 1: Trust the Game API
    local stats = GetItemStats(itemLink) or {}
    
    -- STEP 2: Use Manual Scanner
    AddManualStats(itemLink, stats)
    
    -- STEP 3: Handle Projection (FIXED: Don't Double Dip!)
    if not SGJ_Settings.IncludeEnchants then
        if SGJ_Settings.ProjectEnchants and slotID then
            -- Check if THIS item already has an enchant
            -- Format: item:ItemID:EnchantID:Suffix...
            local _, _, existingEnchantID = string.find(itemLink, "item:%d+:(%d+)")
            existingEnchantID = tonumber(existingEnchantID) or 0
            
            -- ONLY project if the item has NO enchant (ID is 0)
            if existingEnchantID == 0 then
                local projected = MSC.GetEnchantStats(slotID)
                for stat, val in pairs(projected) do 
                    stats[stat] = (stats[stat] or 0) + val
                    stats["IS_PROJECTED"] = 1 
                end
            end
        end
    end

    -- Racial & Speed Logic
    local _, _, _, _, _, classID, subclassID = GetItemInfoInstant(itemLink)
    if classID == 2 then 
        local race = UnitRace("player")
        local subClassName = C_Item.GetItemSubClassInfo(classID, subclassID)
        if MSC.RacialTraits and MSC.RacialTraits[race] and MSC.RacialTraits[race][subClassName] then 
            stats["RACIAL_BONUS"] = 1 
        end
        local _, englishClass = UnitClass("player")
        local pref = MSC.SpeedChecks and MSC.SpeedChecks[englishClass]
        if pref then
            local _, _, _, _, _, _, _, _, equipLoc, _, _, _, _, _, _, _, _, speed = GetItemInfo(itemLink)
            if speed then
                if (equipLoc == "INVTYPE_WEAPONMAINHAND" or equipLoc == "INVTYPE_2HWEAPON" or equipLoc == "INVTYPE_WEAPON") and pref.MH_Slow and speed >= 2.60 then stats["SPEED_OPTIMAL"] = 1
                elseif (equipLoc == "INVTYPE_WEAPONOFFHAND" or equipLoc == "INVTYPE_WEAPON") and pref.OH_Fast and speed <= 1.80 then stats["SPEED_OPTIMAL"] = 1
                elseif (equipLoc == "INVTYPE_RANGED" or equipLoc == "INVTYPE_RANGEDRIGHT") and pref.Ranged_Slow and speed >= 2.80 then stats["SPEED_OPTIMAL"] = 1 end
            end
        end
    end
    return stats
end

-- =============================================================
-- 4. HELPERS
-- =============================================================
function MSC.GetItemScore(stats, weights)
    local totalScore = 0
    for statKey, statValue in pairs(stats) do
        if statKey == "RACIAL_BONUS" then totalScore = totalScore + 50
        elseif statKey == "SPEED_OPTIMAL" then totalScore = totalScore + 40
        else totalScore = totalScore + (statValue * (weights[statKey] or 0)) end
    end
    return totalScore
end

function MSC.GetStatDifferences(newStats, oldStats)
    local diffTable = {}
    for k, v in pairs(newStats) do diffTable[k] = (diffTable[k] or 0) + v end
    for k, v in pairs(oldStats) do diffTable[k] = (diffTable[k] or 0) - v end
    return diffTable
end

function MSC.SortStatDiffs(diffTable)
    local sorted = {}
    for k, v in pairs(diffTable) do if v ~= 0 then table.insert(sorted, { key = k, val = v }) end end
    table.sort(sorted, function(a, b) return a.val > b.val end)
    return sorted
end

function MSC.GetCleanStatName(key)
    if key == "IS_PROJECTED" then return "" end 
    if key == "RACIAL_BONUS" then return "Racial Synergy" end
    if key == "SPEED_OPTIMAL" then return "Optimal Speed" end
    if MSC.ShortNames and MSC.ShortNames[key] then return MSC.ShortNames[key] end
    
    local rawName = _G[key] or key
    rawName = rawName:gsub("ITEM_MOD_", ""):gsub("_SHORT", ""):gsub("_", " "):lower()
    rawName = rawName:gsub("(%a)([%w_']*)", function(first, rest) return first:upper()..rest:lower() end)
    
    if rawName:find("Spell Power") then return "Spell Power" end
    if rawName:find("Attack Power") then return "Attack Power" end
    if rawName:find("Hit Spell Rating") then return "Hit %" end
    if rawName:find("Crit Spell Rating") then return "Crit %" end
    if rawName:find("Mana Regeneration") then return "MP5" end
    if rawName:find("Healing Power") then return "Healing" end
    
    return rawName
end

function MSC.GetCurrentWeights()
    local _, englishClass = UnitClass("player")
    if not englishClass then return {}, "Unknown" end
    
    local classData = MSC.WeightDB and MSC.WeightDB[englishClass]
    if not classData then return {}, "No Data" end

    -- 1. MANUAL OVERRIDE
    if SGJ_Settings and SGJ_Settings.Mode and SGJ_Settings.Mode ~= "Auto" and classData[SGJ_Settings.Mode] then
        local displayName = SGJ_Settings.Mode
        if displayName == "Hybrid" then displayName = "Leveling / PvP" end
        return classData[SGJ_Settings.Mode], displayName .. " (Manual)"
    end

    -- 2. AUTO-DETECT SPEC
    local maxPoints, activeSpec = 0, "Default"
    local specIndex = 1
    
    if MSC.SpecNames and MSC.SpecNames[englishClass] then
        for i=1, 3 do
            local _, _, pointsSpent, _, previewPoints = GetTalentTabInfo(i)
            local totalPoints = (tonumber(pointsSpent) or 0) + (tonumber(previewPoints) or 0)
            if totalPoints > maxPoints then 
                maxPoints = totalPoints
                activeSpec = MSC.SpecNames[englishClass][i]
                specIndex = i
            end
        end
    end

    -- 3. SMART LEVELING LOGIC (< Level 60)
    local playerLevel = UnitLevel("player")
    if playerLevel < 60 then
        -- LIST OF "HEALER" SPECS BY INDEX
        -- Paladin(1=Holy), Priest(1=Disc, 2=Holy), Druid(3=Resto), Shaman(3=Resto)
        local isHealerSpec = false
        if englishClass == "PALADIN" and specIndex == 1 then isHealerSpec = true end
        if englishClass == "PRIEST" and (specIndex == 1 or specIndex == 2) then isHealerSpec = true end
        if englishClass == "DRUID" and specIndex == 3 then isHealerSpec = true end
        if englishClass == "SHAMAN" and specIndex == 3 then isHealerSpec = true end
        
        -- If leveling as a Healer spec, Force "Leveling/PvP" weights (Spell Power/Stam) 
        -- instead of Raid weights (+Healing).
        if isHealerSpec and classData["Hybrid"] then
            return classData["Hybrid"], activeSpec .. " (Smart Leveling)"
        end
        
        -- Note: Tank specs (Prot War/Pally) are left alone because Tank weights 
        -- are actually great for leveling (Stam/Str/Mitigation).
    end

    -- 4. RAID WEIGHTS (Level 60 or DPS Specs)
    return (classData[activeSpec] or classData["Default"]), activeSpec .. " (Auto)"
end

function MSC.FindBestMainHand(weights)
    local bestScore, bestLink, bestStats = 0, nil, {}
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.hyperlink then
                local equipLoc = select(9, GetItemInfo(info.hyperlink))
                if equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND" then
                    local stats = MSC.SafeGetItemStats(info.hyperlink, 16)
                    local score = MSC.GetItemScore(stats, weights)
                    if score > bestScore then bestScore, bestLink, bestStats = score, info.hyperlink, stats end
                end
            end
        end
    end
    return bestLink, bestScore, bestStats
end

function MSC.ApplyElvUISkin(frame)
    if not _G["ElvUI"] then return end
    local E = unpack(_G["ElvUI"]); local S = E:GetModule('Skins')
    if frame.icon then S:HandleItemButton(frame, true) end
end