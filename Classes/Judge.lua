local addonName, MSC = ...
_G.MSC = MSC 

-- [[ SPEED OPTIMIZATION: LOCALIZED FUNCTIONS ]]
local pairs, next, type, tonumber, select = pairs, next, type, tonumber, select
local ipairs = ipairs
local string_find, string_format, string_match = string.find, string.format, string.match
local math_abs, math_floor, math_max = math.abs, math.floor, math.max
local table_insert, table_sort = table.insert, table.sort
local wipe = wipe or table.wipe
local pcall = pcall
local GetTime = GetTime

local CreateFrame = CreateFrame
local GetItemInfo = GetItemInfo
local GetInventoryItemLink = GetInventoryItemLink
local IsEquippableItem = IsEquippableItem
local UnitClass = UnitClass
local UnitLevel = UnitLevel
local IsAddOnLoaded = IsAddOnLoaded
local C_AddOns = C_AddOns

local function CleanText(text)
    if not text then return "" end
    -- 1. Remove color codes (|cff... and |r)
    local clean = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    -- 2. Remove textures/icons (|T...|t)
    clean = clean:gsub("|T.-|t", "")
    -- 3. Trim extra whitespace from the ends
    return clean:match("^%s*(.-)%s*$")
end

-- =============================================================
-- 1. INITIALIZATION & EVENTS
-- =============================================================
local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterEvent("PLAYER_LEVEL_UP")
EventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
EventFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

EventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        
        -- [[ 1. INITIALIZE DATABASE ]]
        if MSC.BuildDatabase then MSC:BuildDatabase() end

        if not SGJ_Settings then SGJ_Settings = { Mode = "AUTO", MinimapPos = 45, TrackedSpecs = {} } end
        if SGJ_Settings.EnchantMode == nil then SGJ_Settings.EnchantMode = 1 end
        if SGJ_Settings.GemMode == nil then SGJ_Settings.GemMode = 1 end
        if not SGJ_Settings.TrackedSpecs then SGJ_Settings.TrackedSpecs = {} end
		if SGJ_Settings.SimplifyStats == nil then SGJ_Settings.SimplifyStats = true end
		if SGJ_Settings.ColorizeStats == nil then SGJ_Settings.ColorizeStats = true end
        if SGJ_Settings.CompactEquip == nil then SGJ_Settings.CompactEquip = true end -- Controls "Equip: +20..." rewriting
		
        -- [[ SYNC ENGINE WITH SAVED SETTING ]]
        MSC.ManualSpec = SGJ_Settings.Mode
        
        local version = MSC.IsEra and MSC.L["Classic Era"] or MSC.L["TBC Edition"]
        print(string.format(MSC.L["|cff00ff00Sharpie's Gear Judge|r (%s) Loaded. Type /sgj for menu."], version))
        
    elseif event == "PLAYER_LOGIN" then
        -- [[ FIX 1: FORCE INIT ON LOGIN ]]
        if MSC.ForceInit then MSC:ForceInit() end

        local IsLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
        if not SGJ_Settings.DisableConflictCheck and IsLoaded then
            if IsLoaded("Pawn") then print(MSC.L["|cffffd100SGJ Warning:|r 'Pawn' is loaded. Tooltips may look cluttered."]) end
            if IsLoaded("ZygorGuidesViewer") then print(MSC.L["|cffffd100SGJ Warning:|r 'Zygor' detected. Ensure its item scoring is disabled."]) end
        end
        
        local _, startSpec = MSC.GetCurrentWeights()
        MSC.LastActiveSpec = startSpec
        
    elseif event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
        MSC.CachedWeights = nil
        -- Re-check initialization just in case
        if event == "PLAYER_TALENT_UPDATE" and MSC.ForceInit then MSC:ForceInit() end

        if MSCLabFrame and MSCLabFrame:IsShown() and MSC.UpdateLabCalc then 
            MSC.UpdateLabCalc() 
        end
    end
end)

SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg) 
    local cmd = msg:lower()
    if cmd == "clean" or cmd == "simple" then
        SGJ_Settings.SimplifyStats = not SGJ_Settings.SimplifyStats
        print("|cff00ff00SGJ:|r Text Simplification is now " .. (SGJ_Settings.SimplifyStats and "ON" or "OFF"))
    elseif cmd == "colors" then
        SGJ_Settings.ColorizeStats = not SGJ_Settings.ColorizeStats
        print("|cff00ff00SGJ:|r Stat Coloring is now " .. (SGJ_Settings.ColorizeStats and "ON" or "OFF"))
    elseif cmd == "debug" then
        MSC:DebugItem()
    elseif cmd == "options" or cmd == "config" then 
        if MSC.CreateOptionsFrame then MSC.CreateOptionsFrame() end 
    elseif cmd == "import" then
        if MSC.ShowImportWindow then MSC.ShowImportWindow() end
    else 
        if MSC.ToggleMainMenu then MSC.ToggleMainMenu() end 
    end 
end

StaticPopupDialogs["SGJ_RELOAD_REQUIRED"] = {
    text = MSC.L["|cff00ccffSharpie's Gear Judge|r\n\nProfile imported successfully!\n\nYou must reload your UI for the changes to take effect."],
    button1 = MSC.L["Reload Now"],
    button2 = MSC.L["Later"],
    OnAccept = function()
        ReloadUI()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

-- =============================================================
-- 2. SMART SLOT LOGIC (Comparison)
-- =============================================================
function MSC.GetComparisonSlot(itemLink, equipLoc, weights, specName)
    local defaultSlot = MSC.SlotMap and MSC.SlotMap[equipLoc] or nil
    if not defaultSlot then return nil end

    if equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET" then
        local s1, s2 = 11, 12
        if equipLoc == "INVTYPE_TRINKET" then s1, s2 = 13, 14 end
        
        local l1 = GetInventoryItemLink("player", s1)
        local l2 = GetInventoryItemLink("player", s2)
        
        if not l1 then return s1 end
        if not l2 then return s2 end
        
        if itemLink == l1 then return s2 end
        if itemLink == l2 then return s1 end

        local stats1 = MSC.SafeGetItemStats(l1, s1, weights, specName)
        local stats2 = MSC.SafeGetItemStats(l2, s2, weights, specName)
        local score1 = MSC.GetItemScore(stats1, weights, specName, s1)
        local score2 = MSC.GetItemScore(stats2, weights, specName, s2)
        
        return (score2 < score1) and s2 or s1
    end

    if equipLoc == "INVTYPE_WEAPON" then
        local _, class = UnitClass("player")
        local canDW = (class == "WARRIOR" or class == "ROGUE" or class == "HUNTER" or class == "SHAMAN")
        
        if canDW then
            local l1 = GetInventoryItemLink("player", 16)
            local l2 = GetInventoryItemLink("player", 17)
            
            if l1 and l2 then
                local _,_,_,_,_,_,_,_, loc2 = GetItemInfo(l2)
                if loc2 == "INVTYPE_WEAPON" or loc2 == "INVTYPE_WEAPONOFFHAND" then
                    local stats1 = MSC.SafeGetItemStats(l1, 16, weights, specName)
                    local stats2 = MSC.SafeGetItemStats(l2, 17, weights, specName)
                    local score1 = MSC.GetItemScore(stats1, weights, specName, 16)
                    local score2 = MSC.GetItemScore(stats2, weights, specName, 17)
                    
                    return (score2 < score1) and 17 or 16
                end
            end
        end
    end

    return defaultSlot
end

-- =============================================================
-- HELPER: GET WEIGHTS BY NAME (FOR OFF-SPEC TRACKING)
-- =============================================================
function MSC.GetWeightsByName(profileName)
    if not MSC.CurrentClass then return nil end
    if MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[profileName] then return MSC.CurrentClass.Weights[profileName] end
    if MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[profileName] then return MSC.CurrentClass.LevelingWeights[profileName] end
    if MSC.CurrentClass.Profiles and MSC.CurrentClass.Profiles[profileName] then return MSC.CurrentClass.Profiles[profileName] end
    return nil
end

-- =============================================================
-- 3. STAT CALCULATOR (The Breakdown Display)
-- =============================================================
function MSC.ExpandDerivedStats(baseStats, itemLink, outTable)
    wipe(outTable or {})
    local dest = outTable or {}
    
    -- 1. Copy raw stats
    if baseStats then
        for k, v in pairs(baseStats) do dest[k] = v end
    end

    local _, class = UnitClass("player")
    local function Rank(name) return (MSC.GetTalentRank and MSC:GetTalentRank(name)) or 0 end

    -- === A. STAMINA -> HEALTH ===
    local stam = dest["ITEM_MOD_STAMINA_SHORT"] or 0
    if stam > 0 then
        local hpPerStam = 10; if class == "TAUREN" then hpPerStam = 10.5 end
        if class == "DRUID" then local r = Rank("HEART_OF_THE_WILD"); if r > 0 then hpPerStam = hpPerStam * (1 + (0.04 * r)) end end
        dest["ITEM_MOD_HEALTH_SHORT"] = (dest["ITEM_MOD_HEALTH_SHORT"] or 0) + (stam * hpPerStam)
    end

    -- === B. INTELLECT -> MANA, SP, SPELL CRIT ===
    local int = dest["ITEM_MOD_INTELLECT_SHORT"] or 0
    if int > 0 then
        -- 1. Mana
        local manaPerInt = 15; if class == "GNOME" then manaPerInt = 15.75 end
        dest["ITEM_MOD_MANA_SHORT"] = (dest["ITEM_MOD_MANA_SHORT"] or 0) + (int * manaPerInt)

        -- 2. Spell Power (Talents)
        if class == "PALADIN" then local r=Rank("HOLY_GUIDANCE"); if r>0 then dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+(int*(0.07*r)) end end
        if class == "SHAMAN" then local r=Rank("NATURES_BLESSING"); if r>0 then local b=int*(0.10*r); dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+b; dest["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=(dest["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0)+b end end
        if class == "DRUID" then local r=Rank("LUNAR_GUIDANCE"); if r>0 then dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+(int*(0.0833*r)) end end
        if class == "MAGE" then local r=Rank("MIND_MASTERY"); if r>0 then dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+(int*(0.05*r)) end end

        -- 3. Spell Crit (Version Branch)
        if MSC.IsEra then
            -- VANILLA: Roughly 59.5 Int = 1% Crit (Mage), others vary. Using ~60 as generic.
            local critPercent = int / 60
            dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] or 0) + critPercent
        else
            -- TBC: Returns RATING.
            local intPerPercent = (class == "WARLOCK") and 82 or 80
            local critPerInt = 22.1 / intPerPercent
            dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] or 0) + (int * critPerInt)
        end
    end

    -- === C. AGILITY -> CRIT, DODGE, ARMOR ===
    local agi = dest["ITEM_MOD_AGILITY_SHORT"] or 0
    if agi > 0 then
        -- 1. Crit Rating (Physical)
        if MSC.IsEra then
            -- VANILLA: Hunter/Rogue 29/20 Agi = 1%. War/Pal 20 Agi = 1%.
            local div = 20
            if class == "HUNTER" then div = 53 elseif class == "ROGUE" then div = 29 end
            local critPercent = agi / div
            dest["ITEM_MOD_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_CRIT_RATING_SHORT"] or 0) + critPercent
        else
            -- TBC: Returns RATING.
            local agiPerPercent = (class == "HUNTER" or class == "ROGUE") and 40 or 25
            local critPerAgi = 22.1 / agiPerPercent
            dest["ITEM_MOD_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_CRIT_RATING_SHORT"] or 0) + (agi * critPerAgi)
        end

        -- 2. Dodge Rating
        if not MSC.IsEra then
            -- TBC Only (Era handles Dodge% via API mostly)
            local dodgeDiv = 25
            if class == "HUNTER" then dodgeDiv = 26 elseif class == "ROGUE" then dodgeDiv = 20 elseif class == "DRUID" then dodgeDiv = 14.7 end
            local dodgePerAgi = 18.9 / dodgeDiv
            dest["ITEM_MOD_DODGE_RATING_SHORT"] = (dest["ITEM_MOD_DODGE_RATING_SHORT"] or 0) + (agi * dodgePerAgi)
        end
    end

    -- === D. STRENGTH -> BLOCK VALUE ===
    local str = dest["ITEM_MOD_STRENGTH_SHORT"] or 0
    if str > 0 and (class == "WARRIOR" or class == "PALADIN") then
        dest["ITEM_MOD_BLOCK_VALUE_SHORT"] = (dest["ITEM_MOD_BLOCK_VALUE_SHORT"] or 0) + (str * 0.5)
    end

    -- === E. SPIRIT -> SPELL POWER ===
    local spt = dest["ITEM_MOD_SPIRIT_SHORT"] or 0
    if spt > 0 then
        if class == "PRIEST" then local r=Rank("SPIRITUAL_GUIDANCE"); if r>0 then local b=spt*(0.05*r); dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+b; dest["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=(dest["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0)+b end end
    end
    
    -- === F. ATTACK POWER ===
    local apFromStr = 0
    local apFromAgi = 0
    
    -- 1. Strength -> AP
    if class == "WARRIOR" or class == "PALADIN" or class == "SHAMAN" or class == "DRUID" then
        apFromStr = str * 2 
    elseif class == "ROGUE" or class == "HUNTER" then
        apFromStr = str * 1
    end

    -- 2. Agility -> AP
    if class == "ROGUE" or class == "HUNTER" or class == "DRUID" then
        -- Note: Hunters get 1 Melee AP and 1 Ranged AP per Agi. 
        -- We effectively just display "Attack Power" here to keep it simple.
        apFromAgi = agi * 1
    end
    
    -- 3. Apply
    local totalAP = apFromStr + apFromAgi
    if totalAP > 0 then
        dest["ITEM_MOD_ATTACK_POWER_SHORT"] = (dest["ITEM_MOD_ATTACK_POWER_SHORT"] or 0) + totalAP
        
        -- Special Case: Hunters also get Ranged AP from Agi/Int (Careful Aim)
        if class == "HUNTER" then
            dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = (dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] or 0) + totalAP
            
            -- Careful Aim (Int -> RAP)
            local r = Rank("CAREFUL_AIM")
            if r > 0 then
                local int = dest["ITEM_MOD_INTELLECT_SHORT"] or 0
                if int > 0 then
                    local rapFromInt = int * (0.15 * r) -- 15/30/45%
                    dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] + rapFromInt
                end
            end
        end
    end

    return dest
end

-- =============================================================
-- 4. TOOLTIP ENGINE (Consolidated)
-- =============================================================
MSC.IsCalculating = false
MSC.LastLink = nil      -- Stores the last item we saw

local Scratch_Tooltip_New = {}
local Scratch_Tooltip_Old = {}
local Scratch_Tooltip_Diffs = {}
local TEX_UP = "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Upgrade.png:14:14:0:-2|t"
local TEX_DOWN = "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Downgrade.png:14:14:0:-2|t"

-- [[ 1. VISUAL OPTIMIZATION: STATIC TABLES ]]

-- Map: Short Name -> Long Name
local SHORT_TO_LONG = {
    ["Str"] = "Strength",   ["Agi"] = "Agility",    ["Stam"] = "Stamina",
    ["Int"] = "Intellect",  ["Spt"] = "Spirit",
    ["AP"]  = "Attack Power", ["SP"] = "Spell Power",
    ["Hp5"] = "Health per 5 sec", ["Mp5"] = "Mana per 5 sec",
    ["Hit"] = "Hit Rating", ["Crit"] = "Critical Strike Rating",
    ["Haste"] = "Haste Rating", ["Exp"] = "Expertise Rating",
    ["Def"] = "Defense Rating", ["Resil"] = "Resilience Rating",
    ["Dodge"] = "Dodge Rating", ["Parry"] = "Parry Rating", 
    ["Block"] = "Block Rating", ["BlockVal"] = "Block Value",
    ["ArP"] = "Armor Penetration", ["Heal"] = "Healing",
    ["Spell Hit"] = "Spell Hit Rating", ["Spell Crit"] = "Spell Crit Rating",
}

-- Map: Text -> Color Hex (Unified & Localized)
local VISUAL_COLORS = {
    -- Base Stats
    ["Str"] = "ffbf8040", ["Strength"] = "ffbf8040", [MSC.L["strength"]] = "ffbf8040",
    ["Agi"] = "ff1eff00", ["Agility"] = "ff1eff00", [MSC.L["agility"]] = "ff1eff00",
    ["Stam"] = "ffffffff", ["Stamina"] = "ffffffff", [MSC.L["stamina"]] = "ffffffff",
    ["Int"] = "ff69ccf0", ["Intellect"] = "ff69ccf0", [MSC.L["intellect"]] = "ff69ccf0",
    ["Spt"] = "ffcacaca", ["Spirit"] = "ffcacaca", [MSC.L["spirit"]] = "ffcacaca",

    -- Offensive
    ["AP"] = "ffbf8040", ["Attack Power"] = "ffbf8040", [MSC.L["attack power"]] = "ffbf8040",
    ["SP"] = "ff69ccf0", ["Spell Power"] = "ff69ccf0", [MSC.L["spell power"]] = "ff69ccf0",
    ["Heal"] = "ff00ff99", ["Healing"] = "ff00ff99", [MSC.L["healing"]] = "ff00ff99",
    ["Mp5"] = "ff00ccff", ["Mana per 5 sec"] = "ff00ccff",
    ["Hit"] = "ff00ff00", ["Hit Rating"] = "ff00ff00", [MSC.L["hit rating"]] = "ff00ff00",
    ["Crit"] = "ffff0000", ["Crit Rating"] = "ffff0000", [MSC.L["crit rating"]] = "ffff0000",
    ["Haste"] = "ffffd100", ["Haste Rating"] = "ffffd100", [MSC.L["haste rating"]] = "ffffd100",
    ["ArP"] = "ffbf8040", ["Armor Penetration"] = "ffbf8040",

    -- Defensive
    ["Def"] = "ff6666ff", ["Defense Rating"] = "ff6666ff", [MSC.L["defense rating"]] = "ff6666ff",
    ["Dodge"] = "ff6666ff", ["Dodge Rating"] = "ff6666ff", [MSC.L["dodge rating"]] = "ff6666ff",
    ["Parry"] = "ff6666ff", ["Parry Rating"] = "ff6666ff", [MSC.L["parry rating"]] = "ff6666ff",
    ["Block"] = "ff6666ff", ["Block Rating"] = "ff6666ff", [MSC.L["block rating"]] = "ff6666ff",
    ["BlockVal"] = "ffaaaaaa", ["Block Value"] = "ffaaaaaa",
    ["Resil"] = "ffcccc00", ["Resilience Rating"] = "ffcccc00",
    ["Hp5"] = "ff00ccff",
    ["Armor"] = "ffe6cc80", [MSC.L["armor"]] = "ffe6cc80",

    -- [[ RESISTANCES ]]
    [MSC.L["shadow resistance"]] = "ff800080", ["Shadow Resistance"] = "ff800080", ["Shadow"] = "ff800080",
    [MSC.L["fire resistance"]]   = "ffff8000", ["Fire Resistance"] = "ffff8000",   ["Fire"] = "ffff8000",
    [MSC.L["frost resistance"]]  = "ff80ccff", ["Frost Resistance"] = "ff80ccff",  ["Frost"] = "ff80ccff",
    [MSC.L["arcane resistance"]] = "ffcc99ff", ["Arcane Resistance"] = "ffcc99ff", ["Arcane"] = "ffcc99ff",
    [MSC.L["nature resistance"]] = "ff40ff40", ["Nature Resistance"] = "ff40ff40", ["Nature"] = "ff40ff40",
    [MSC.L["holy resistance"]]   = "ffffff80", ["Holy Resistance"] = "ffffff80",   ["Holy"] = "ffffff80",
    [MSC.L["all resistances"]]   = "ffffffff", ["All Resistances"] = "ffffffff",

    -- [[ WEAPON SKILLS ]]
    ["Swords"] = "ffffd100", ["Axes"] = "ffffd100", ["Maces"] = "ffffd100",
    ["Daggers"] = "ffffd100", ["Bows"] = "ffffd100", ["Guns"] = "ffffd100",
}

function MSC:BeautifyTooltip(tooltip)
    if not SGJ_Settings then return end
    if not MSC.Scanner or not MSC.Scanner.EquipPatterns or not MSC.Scanner.ClassifyLine then return end

    local tooltipName = tooltip:GetName()
    local numLines = tooltip:NumLines()

    local function Colorize(text)
        if not SGJ_Settings.ColorizeStats then return text end
        local color = VISUAL_COLORS[text]
        if color then return "|c" .. color .. text .. "|r" end
        return text
    end

    for i = 2, numLines do
        local leftObj = _G[tooltipName .. "TextLeft" .. i]
        if leftObj then
            local text = leftObj:GetText()
            if text then
                local newText = text
                local lineChanged = false
                
                local lineType = MSC.Scanner.ClassifyLine(text)
                
                -- [[ PHASE 1: COMPACT EQUIP ]]
                if SGJ_Settings.CompactEquip and (lineType == "EQUIP") then
                    
                    local cleanText = string.lower(text)
                    cleanText = string.gsub(cleanText, "|c%x%x%x%x%x%x%x%x", "")
                    cleanText = string.gsub(cleanText, "|r", "")
                    cleanText = string.gsub(cleanText, "\n", " ")
                    cleanText = string.gsub(cleanText, "%s+", " ")
                    cleanText = string.gsub(cleanText, "^%s*(.-)%s*$", "%1")
                    cleanText = string.gsub(cleanText, "^equip: ", "") 

                    for _, pat in ipairs(MSC.Scanner.EquipPatterns) do
                        if pat.p and not pat.func then
                            local m1, m2 = string.match(cleanText, pat.p)
                            if m1 then
                                local val = tonumber(pat.valIdx == 1 and m1 or m2)
                                local rawName = (pat.nameIdx == 1 and m1 or m2)
                                local finalName = nil

                                if pat.fixedStat and MSC.StatShortNames then
                                    finalName = MSC.StatShortNames[pat.fixedStat]
                                elseif rawName and MSC.Scanner.TermMap then
                                    local nameKey = string.gsub(rawName, "your ", "")
                                    nameKey = string.gsub(nameKey, "^%s*(.-)%s*$", "%1")
                                    local internalKey = MSC.Scanner.TermMap[nameKey]
                                    if not internalKey then
                                        local titleCase = string.gsub(" "..nameKey, "%W%l", string.upper):sub(2)
                                        internalKey = MSC.Scanner.TermMap[titleCase]
                                    end
                                    if internalKey and MSC.StatShortNames then
                                        finalName = MSC.StatShortNames[internalKey]
                                    end
                                end

                                if val and finalName then
                                    if not SGJ_Settings.SimplifyStats then
                                        if SHORT_TO_LONG[finalName] then
                                            finalName = SHORT_TO_LONG[finalName]
                                        end
                                    end
                                    
                                    local prefix = "Equip: "
                                    if pat.isPercent or string.find(text, "%%") then
                                        newText = prefix .. "+" .. val .. "% " .. Colorize(finalName)
                                    else
                                        newText = prefix .. "+" .. val .. " " .. Colorize(finalName)
                                    end
                                    lineChanged = true
                                    break 
                                end
                            end
                        end
                    end
                end

                -- [[ PHASE 2: WORD HIGHLIGHTING ]]
                -- Runs on Base Stats and anything Phase 1 didn't catch (like Resistances)
                if not lineChanged and MSC.Scanner.BaseStatMap then
                    for localName, internalKey in pairs(MSC.Scanner.BaseStatMap) do
                        
                        -- Find the stat name in the text
                        local s, e = string.find(string.lower(newText), string.lower(localName), 1, true)
                        
                        if s then
                             -- We found it!
                             local actualText = string.sub(newText, s, e)
                             local replacement = actualText
                             
                             -- 1. SHORTEN (Only if Simplify ON & ShortName exists)
                             local shortName = MSC.StatShortNames and MSC.StatShortNames[internalKey]
                             if SGJ_Settings.SimplifyStats and shortName then 
                                 replacement = shortName 
                             end
                             
                             -- 2. COLOR (Look up by ShortName, LocalName, or ActualText)
                             local color = nil
                             if shortName and VISUAL_COLORS[shortName] then
                                 color = VISUAL_COLORS[shortName]
                             elseif VISUAL_COLORS[localName] then
                                 color = VISUAL_COLORS[localName]
                             elseif VISUAL_COLORS[actualText] then
                                 color = VISUAL_COLORS[actualText]
                             end

                             if SGJ_Settings.ColorizeStats and color then
                                 replacement = "|c" .. color .. replacement .. "|r"
                             end

                             -- 3. REPLACE
                             if replacement ~= actualText then
                                 newText = string.sub(newText, 1, s-1) .. replacement .. string.sub(newText, e+1)
                             end
                        end
                    end
                end

                if newText ~= text then
                    leftObj:SetText(newText)
                end
            end
        end
    end
end

local function OnTooltipSetItem(tooltip)
    -- [[ 1. INSTANT CHECKS ]]
    if MSC.IsCalculating then return end

    -- [[ 2. SETTINGS CHECKS ]]
    if tooltip:GetName() and string_find(tooltip:GetName(), "MSC_ScannerTooltip") then return end
    if SGJ_Settings then
        if SGJ_Settings.HideTooltips then return end
        if SGJ_Settings.ShiftOnlyTooltip and not IsShiftKeyDown() then return end
    end

    -- [[ 3. LOCK THE ENGINE ]]
    MSC.IsCalculating = true 

    -- [[ 4. GET ITEM LINK ]]
    local _, link = nil, nil
    if tooltip.GetItem then _, link = tooltip:GetItem() end

    -- [[ 5. VALIDATE ITEM ]]
    if not link or not IsEquippableItem(link) or not MSC.IsItemUsable(link) then 
        MSC.IsCalculating = false 
        return 
    end

    -- [[ 6. RUN VISUAL UPDATES ]]
    if MSC.BeautifyTooltip then MSC:BeautifyTooltip(tooltip) end

    -- [[ 7. RUN SCORING ENGINE ]]
    local _, playerClass = UnitClass("player")
    if not MSC.CurrentClass or MSC.CurrentClass.Name ~= playerClass then
        if MSC.ForceInit then MSC:ForceInit() end
        if not MSC.CurrentClass then 
            MSC.IsCalculating = false -- Unlock
            return 
        end
    end

    local status, err = pcall(function()
        local weights, specName = MSC.GetCurrentWeights()
        if not weights or not next(weights) then return end
        local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
        
        local slotId = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
        if not slotId then return end

        local newScore, oldScore, itemNewStats, itemOldStats, newStatsTotal, oldStatsTotal, newTotalColors, oldSetCounts, newSetCounts, contextMsg = MSC:EvaluateUpgrade(link, slotId, weights, specName)
        local delta = newScore - oldScore
        local isEquipped = (GetInventoryItemLink("player", slotId) == link)
        
        -- [[ THE HEADER ]]
        tooltip:AddLine(" ")
        local scoreLabel = MSC.L["Judge's Score:"]
        if contextMsg then scoreLabel = scoreLabel .. " " .. contextMsg end
        tooltip:AddDoubleLine(scoreLabel, string_format("|cffffffff%.1f|r", newScore), 1, 0.82, 0)
        
        local displayName = specName
        if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[specName] then displayName = MSC.CurrentClass.PrettyNames[specName] end
        
        -- Cap Info
        local _, _, capInfo = MSC.GetCurrentWeights()
        if capInfo then displayName = displayName .. " |cff00ff00(" .. capInfo .. " " .. MSC.L["Capped"] .. ")|r" end
        tooltip:AddDoubleLine(MSC.L["Verdict Profile:"], "|cff00ccff" .. displayName .. "|r", 1, 0.82, 0)

        -- [[ THE EQUIPPED SPLIT ]]
        if isEquipped then
            tooltip:AddLine(MSC.L["|cff00ffff* EQUIPPED *|r"])
        else
            -- "VS" Text
            if equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET" then
                local comparedItemLink = GetInventoryItemLink("player", slotId)
                if comparedItemLink then tooltip:AddDoubleLine(MSC.L["vs."], comparedItemLink, 0.6, 0.6, 0.6, 1, 1, 1) end
            end

            -- [[ 3. JUDGE'S NOTES ]]
            if link then
                local itemID = tonumber(string_match(link, "item:(%d+)"))
                local noteDisplayed = false

                -- Class Specific Check
                if MSC.CurrentClass then
                    local classDB = MSC.CurrentClass.Relics or MSC.CurrentClass.Totems or MSC.CurrentClass.Idols
                    if classDB and classDB[itemID] then
                        local dbStats = classDB[itemID]
                        local statStr = ""
                        for key, val in pairs(dbStats) do
                            if key ~= "note" and type(val) == "number" and val > 0 then
                                local name = (MSC.ShortNames and MSC.ShortNames[key]) 
                                if not name then name = key:gsub("ITEM_MOD_", ""):gsub("_SHORT", ""):gsub("_", " "):lower() end
                                if statStr ~= "" then statStr = statStr .. ", " end
                                statStr = statStr .. string_format("+%d %s", val, name)
                            end
                        end
                        if statStr ~= "" then
                            tooltip:AddLine(" ")
                            tooltip:AddLine(MSC.L["Class Bonus: "] .. statStr, 0, 1, 1, true) 
                        end
                        if dbStats.note then
                            tooltip:AddDoubleLine(MSC.L["Judge's Note:"], dbStats.note, 0.85, 0.6, 1.0, 0.64, 0.21, 0.93)
                            noteDisplayed = true
                        end
                    end
                end

                -- Global Database Checks
                if not noteDisplayed then
                    local entry = nil
                    local cL = {r=0.85, g=0.6, b=1.0}; local cR = {r=0.64, g=0.21, b=0.93}

                    if MSC.PvPDB and MSC.PvPDB[itemID] then
                        entry = MSC.PvPDB[itemID]; cL = {r=1.0, g=0.6, b=0.6}; cR = {r=1.0, g=0.2, b=0.2} 
                    elseif MSC.WeaponDB and MSC.WeaponDB[itemID] then
                        entry = MSC.WeaponDB[itemID]; cL = {r=1.0, g=0.8, b=0.4}; cR = {r=1.0, g=0.5, b=0.0} 
                    elseif MSC.TrinketDB and MSC.TrinketDB[itemID] then
                        entry = MSC.TrinketDB[itemID]
                    elseif MSC.ProcDB and MSC.ProcDB[itemID] then
                        entry = MSC.ProcDB[itemID]
                    end

                    if entry and entry.note then
                        tooltip:AddLine(" ")
                        tooltip:AddDoubleLine(MSC.L["Judge's Note:"], entry.note, cL.r, cL.g, cL.b, cR.r, cR.g, cR.b)
                    end
                end
            end

            -- [[ 4. UPGRADE/DOWNGRADE MATH ]]
            local percentDiff = 0; if oldScore > 0 then percentDiff = ((newScore - oldScore) / oldScore) * 100 end
            if delta > 0.1 then tooltip:AddLine(string_format(MSC.L["|cff00ff00%s Upgrade (+%.1f / +%.1f%%)|r"], TEX_UP, delta, percentDiff))
            elseif delta < -0.1 then tooltip:AddLine(string_format(MSC.L["|cffff0000%s Downgrade (%.1f / %.1f%%)|r"], TEX_DOWN, delta, percentDiff))
            else tooltip:AddLine(MSC.L["|cff888888= Sidegrade (0.0)|r"]) end

            -- MAIN SPEC SET TRACKING (GAINED & BROKEN)
            if MSC.SetBonusScores and oldSetCounts and newSetCounts then
                for setID, scores in pairs(MSC.SetBonusScores) do
                    local oC = oldSetCounts[setID] or 0
                    local nC = newSetCounts[setID] or 0
                    
                    if nC < oC then
                        for req, _ in pairs(scores) do
                            local rN = tonumber(req)
                            if rN and oC >= rN and nC < rN then tooltip:AddLine(string_format(MSC.L["|cffff0000!!! WARNING: Breaking Set Bonus (%d) !!!|r"], rN)) end
                        end
                    elseif nC > oC then
                        for req, _ in pairs(scores) do
                            local rN = tonumber(req)
                            if rN and nC >= rN and oC < rN then tooltip:AddLine(string_format(MSC.L["|cff00ff00+++ GAINED: %d-pc Set Bonus! +++|r"], rN)) end
                        end
                    end
                end
            end

            -- [[ 5. MULTI-SPEC TRACKING ]]
            if SGJ_Settings.TrackedSpecs and next(SGJ_Settings.TrackedSpecs) then
                for tSpec, isActive in pairs(SGJ_Settings.TrackedSpecs) do
                    if isActive and tSpec ~= specName then
                        local tWeights = MSC.GetWeightsByName(tSpec)
                        if tWeights then
                            local tSlotId = MSC.GetComparisonSlot(link, equipLoc, tWeights, tSpec)
                            if tSlotId then
                                local tNewScore, tOldScore, _, _, _, _, _, oSC, nSC = MSC:EvaluateUpgrade(link, tSlotId, tWeights, tSpec)
                                local tDelta = tNewScore - tOldScore
                                
                                if tDelta > 0.1 then
                                    local prettySpec = (MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[tSpec]) or tSpec
                                    tooltip:AddDoubleLine("|cff00ccff" .. prettySpec .. ":|r", string_format(MSC.L["|cff00ff00+%s (Upgrade)|r"], math_floor(tDelta)), 1, 1, 1, 1, 1, 1)
                                    
                                    if oSC and nSC and MSC.SetBonusScores then
                                        for setID, scores in pairs(MSC.SetBonusScores) do
                                            local oC = oSC[setID] or 0
                                            local nC = nSC[setID] or 0
                                            if nC < oC then
                                                for req, _ in pairs(scores) do
                                                    local rN = tonumber(req)
                                                    if rN and oC >= rN and nC < rN then
                                                        tooltip:AddLine(string_format(MSC.L["  |cffff0000(Breaks %d-pc Set Bonus!)|r"], rN))
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- [[ 6. PROJECTIONS (TBC Only for Gems/Metas) ]]
            if itemNewStats and (itemNewStats.IS_PROJECTED or itemNewStats.GEMS_PROJECTED) then
                tooltip:AddLine(" ")
                
                if itemNewStats.ENCHANT_TEXT then 
                    local cleanEnchant = CleanText(itemNewStats.ENCHANT_TEXT)
                    tooltip:AddDoubleLine(MSC.L["Projected Enchant:"], cleanEnchant, 0, 1, 1, 1, 1, 1)
                elseif itemNewStats.IS_PROJECTED then 
                    tooltip:AddDoubleLine(MSC.L["Projected Enchant:"], MSC.L["Best Available"], 0, 1, 1, 1, 1, 1) 
                end
                
                if not MSC.IsEra and itemNewStats.PROJECTION_DATA then
                    local data = itemNewStats.PROJECTION_DATA
                    for i, gem in ipairs(data.Gems) do
                        local label = (i == 1) and MSC.L["Projected Gems:"] or " "
                        local leftR, leftG, leftB = (i == 1) and 0 or 0, (i == 1) and 1 or 0, (i == 1) and 1 or 0
                        tooltip:AddDoubleLine(label, gem.text .. " (" .. gem.color .. ")", leftR, leftG, leftB, 1, 1, 1)
                    end
                    if data.Bonus then tooltip:AddDoubleLine(" ", data.Bonus, 0, 0, 0, 0, 1, 0) end
                    if data.Stats ~= "" then tooltip:AddDoubleLine(" ", data.Stats, 0, 0, 0, 0, 0.8, 1) end
                end
                
                if not MSC.IsEra and itemNewStats.META_ID and MSC.CheckMetaRequirements and newTotalColors then 
                    if MSC:CheckMetaRequirements(itemNewStats.META_ID, newTotalColors) then 
                        tooltip:AddDoubleLine(" ", MSC.L["+ Meta Gem Active"], 0, 0, 0, 0, 1, 0) 
                    else 
                        tooltip:AddDoubleLine(" ", MSC.L["- Meta Gem Inactive (Reqs unmet)"], 0, 0, 0, 1, 0, 0) 
                    end 
                end
            end

            -- [[ 7. STAT COMPARISON (Gains / Losses) ]]
            local newExpanded = MSC.ExpandDerivedStats(newStatsTotal or {}, link, Scratch_Tooltip_New)
            local oldExpanded = MSC.ExpandDerivedStats(oldStatsTotal or {}, nil, Scratch_Tooltip_Old)
            local diffs = MSC.GetStatDifferences(newExpanded, oldExpanded, Scratch_Tooltip_Diffs)

            local gains, losses = {}, {}
            for _, d in ipairs(diffs) do
                if math_abs(d.val) > 0.1 then
                    local w = weights[d.key] or 0
                    if w > 0.02 then
                        if d.val > 0 then table_insert(gains, d) else table_insert(losses, d) end 
                    end
                end
            end

            local function StableSort(a, b) local wA=(weights[a.key]or 0); local wB=(weights[b.key]or 0); if wA==wB then return a.key<b.key end; return wA>wB end
            table_sort(gains, StableSort); table_sort(losses, StableSort)

            local function PrintList(label, list, cR, cG, cB)
                local hp, lp = false, 0
                for _, d in ipairs(list) do
                    if lp < 8 then 
                        if not hp then tooltip:AddLine(label, cR, cG, cB); hp = true end
                        local name = (MSC.GetCleanStatName(d.key) or d.key)
                        local level = UnitLevel("player")
                        if MSC.GetRatingPercent then
                             local percentVal = MSC:GetRatingPercent(d.key, math_abs(d.val), level)
                             if percentVal and percentVal > 0.01 then
                                 name = name .. string_format(" |cff888888(%.2f%%)|r", percentVal)
                             end
                        end
                        name = name .. (d.nameSuffix or "")
                        local valStr = (d.val%1==0) and string_format("%d", math_abs(d.val)) or string_format("%.1f", math_abs(d.val))
                        if cR==0 then valStr="+"..valStr else valStr="-"..valStr end
                        tooltip:AddDoubleLine("  " .. name, valStr, 1, 1, 1, cR, cG, cB)
                        lp = lp + 1
                    end
                end
            end

            PrintList(MSC.L["Gains:"], gains, 0, 1, 0)
            PrintList(MSC.L["Losses:"], losses, 1, 0, 0)
        end
        -- ====================================================================

        tooltip:Show()
    end)
    MSC.IsCalculating = false
    if not status then geterrorhandler()(err) end
end

-- Hooks
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
if ShoppingTooltip1 then ShoppingTooltip1:HookScript("OnTooltipSetItem", OnTooltipSetItem) end
if ShoppingTooltip2 then ShoppingTooltip2:HookScript("OnTooltipSetItem", OnTooltipSetItem) end
