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
    local clean = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    clean = clean:gsub("|T.-|t", "")
    return clean:match("^%s*(.-)%s*$")
end

-- =============================================================
-- 1. INITIALIZATION & EVENTS
-- =============================================================
MSC.SlotCache = {}

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterEvent("PLAYER_LEVEL_UP")
EventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
EventFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
EventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

EventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        
        -- [[ 1. INITIALIZE DATABASE ]]
        if MSC.BuildDatabase then MSC:BuildDatabase() end
		if not SGJ_Settings then SGJ_Settings = { Mode = "AUTO", MinimapPos = 45, TrackedSpecs = {} } end
        if SGJ_Settings.EnchantMode == nil then SGJ_Settings.EnchantMode = 1 end
        if SGJ_Settings.GemMode == nil then SGJ_Settings.GemMode = 1 end
        if SGJ_Settings.GemQuality == nil then SGJ_Settings.GemQuality = 3 end
        if not SGJ_Settings.TrackedSpecs then SGJ_Settings.TrackedSpecs = {} end
		if not SGJ_Settings.GearProfiles then SGJ_Settings.GearProfiles = {} end
        if SGJ_Settings.SimplifyStats == nil then SGJ_Settings.SimplifyStats = true end
        if SGJ_Settings.ColorizeStats == nil then SGJ_Settings.ColorizeStats = true end
        if SGJ_Settings.CompactEquip == nil then SGJ_Settings.CompactEquip = true end
        if MSC.BuffEngine then MSC.BuffEngine:InitSettings() end
        -- [[ SYNC ENGINE WITH SAVED SETTING ]]
        MSC.ManualSpec = SGJ_Settings.Mode
        
        local version = MSC.IsForever and MSC.L["Forever Edition"] or (MSC.IsEra and MSC.L["Classic Era"] or MSC.L["TBC Edition"])
        print(string.format(MSC.L["|cff00ff00Sharpie's Gear Judge|r (%s) Loaded. Type /sgj for menu."], version))
        
    elseif event == "PLAYER_LOGIN" then
        -- [[ FORCE INIT ON LOGIN ]]
        if MSC.ForceInit then MSC:ForceInit() end

        local IsLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
        if not SGJ_Settings.DisableConflictCheck and IsLoaded then
            if IsLoaded("Pawn") then print(MSC.L["|cffffd100SGJ Warning:|r 'Pawn' is loaded. Tooltips may look cluttered."]) end
            if IsLoaded("ZygorGuidesViewer") then print(MSC.L["|cffffd100SGJ Warning:|r 'Zygor' detected. Ensure its item scoring is disabled."]) end
        end
        
        local _, startSpec = MSC.GetCurrentWeights()
        MSC.LastActiveSpec = startSpec
        
    elseif event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_EQUIPMENT_CHANGED" then
        MSC.CachedWeights = nil
        wipe(MSC.SlotCache)
        
        if event == "PLAYER_TALENT_UPDATE" and MSC.ForceInit then MSC:ForceInit() end

        if MSCLabFrame and MSCLabFrame:IsShown() and MSC.UpdateLabCalc then 
            MSC.UpdateLabCalc() 
        end
        
        if event == "PLAYER_EQUIPMENT_CHANGED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
            if MSC.AutoUpdateBaseline then MSC:AutoUpdateBaseline() end
        end
    end
end)

SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg) 
    local cmd = msg:lower()
    local onText = MSC.L["ON"] or "ON"
    local offText = MSC.L["OFF"] or "OFF"

    if cmd == "clean" or cmd == "simple" then
        SGJ_Settings.SimplifyStats = not SGJ_Settings.SimplifyStats
        print(MSC.L["|cff00ff00SGJ:|r Text Simplification is now "] .. (SGJ_Settings.SimplifyStats and onText or offText))
    elseif cmd == "colors" then
        SGJ_Settings.ColorizeStats = not SGJ_Settings.ColorizeStats
        print(MSC.L["|cff00ff00SGJ:|r Stat Coloring is now "] .. (SGJ_Settings.ColorizeStats and onText or offText))
    
    elseif cmd == "debugvars" then
        print("|cff00ffffSGJ DEBUG:|r Type of SGJ_Settings:", type(SGJ_Settings))
        if type(SGJ_Settings) == "table" then
            print("|cff00ffffSGJ DEBUG:|r ShowBagArrows:", tostring(SGJ_Settings.ShowBagArrows))
        end
    elseif cmd == "debug" then
        MSC:DebugItem()
    elseif cmd == "jc" then
        SGJ_Settings.IsJC = not SGJ_Settings.IsJC
        -- Gem projections depend on it: drop scores cached under the old setting.
        if MSC.BumpScoringRevision then MSC:BumpScoringRevision() end
        print(MSC.L["|cff00ff00SGJ:|r Jewelcrafter evaluation is now "] .. (SGJ_Settings.IsJC and onText or offText))
    elseif cmd == "options" or cmd == "config" then 
        if MSC.OpenSettingsTab then MSC.OpenSettingsTab() end
    elseif cmd == "import" then
        if MSC.ShowImportWindow then MSC.ShowImportWindow() end
    elseif cmd == "hitcheck" and MSC.GetForeverHitPercent then
        -- Shows the pieces of the Forever hit reading, so it can be checked
        -- against the character sheet with a hit item on and off.
        local kindNames = { MELEE = MSC.L["Melee"], RANGED = MSC.L["Ranged"], SPELL = MSC.L["Spell"] }
        for _, kind in ipairs({ "MELEE", "RANGED", "SPELL" }) do
            local total, fromRating, modifier = MSC:GetForeverHitPercent(kind)
            local cap = MSC.GetForeverCapTarget(kind == "RANGED" and "MELEE" or kind)
            print(string.format(MSC.L["|cff00ff00SGJ hit (%s):|r %.2f%% = %.2f%% from Hit Rating + %.2f%% from talents/other | target %.1f%%"], kindNames[kind], total, fromRating, modifier, cap or 0))
        end
        local def = MSC.GetForeverDefenseTarget and MSC.GetForeverDefenseTarget()
        print(string.format(MSC.L["|cff00ff00SGJ:|r raid blend %.0f%%, defense %d, defense target %s"], (MSC.GetRaidBlend() or 0) * 100, MSC:GetPlayerStat("DEFENSE"), def and string.format("%d", def) or MSC.L["none below 50"]))
    elseif cmd == "talents" then
        -- What SGJ reads from the talent tree, the points per tree, and the
        -- profile that picks (for checking talent detection in game).
        MSC.TalentCacheLoaded = false
        MSC:BuildTalentCache()
        print(string.format(MSC.L["|cff00ff00SGJ talents:|r read from %s"], MSC.TraitTalentData and MSC.L["trait tree"] or MSC.L["Classic talent API"]))
        local shown = 0
        for name, rank in pairs(MSC.TalentCache or {}) do
            if rank > 0 then print("   " .. name .. " " .. rank); shown = shown + 1 end
        end
        if shown == 0 then print("   " .. MSC.L["(no talent points found)"]) end
        print("   " .. string.format(MSC.L["points per tree: %d / %d / %d"], MSC.GetTabPointsSpent(1), MSC.GetTabPointsSpent(2), MSC.GetTabPointsSpent(3)))
        -- Clears the cached weights and profile together (clearing only the
        -- profile left tooltips with weights but no profile name)
        MSC:BumpScoringRevision()
        local _, specKey = MSC.GetCurrentWeights()
        print("   " .. string.format(MSC.L["profile: %s"], tostring(specKey)))
    elseif cmd == "whatsnew" or cmd == "news" then
        if MSC.ShowWhatsNew then MSC.ShowWhatsNew() end
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
-- 2. SMART SLOT LOGIC (Optimized with Cache)
-- =============================================================
function MSC.GetComparisonSlot(itemLink, equipLoc, weights, specName, baselineGear)
    local defaultSlot = MSC.SlotMap and MSC.SlotMap[equipLoc] or nil
    if not defaultSlot then return nil end

    -- Make the cache key unique per spec to prevent crossover bugs
    local cacheKey = equipLoc .. "_" .. (specName or "Live") .. (baselineGear and "_Base" or "")

    -- [[ OPTIMIZATION: USE CACHED "WORSE" SLOT ]]
    if equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET" then
        local s1, s2 = 11, 12
        if equipLoc == "INVTYPE_TRINKET" then s1, s2 = 13, 14 end
        
        local l1 = baselineGear and baselineGear[s1] or GetInventoryItemLink("player", s1)
        local l2 = baselineGear and baselineGear[s2] or GetInventoryItemLink("player", s2)
        
        if itemLink == l1 then return s2 end
        if itemLink == l2 then return s1 end
		
        if MSC.SlotCache[cacheKey] then return MSC.SlotCache[cacheKey] end

        if not l1 then return s1 end
        if not l2 then return s2 end
        
        local stats1 = MSC.SafeGetItemStats(l1, s1, weights, specName)
        local stats2 = MSC.SafeGetItemStats(l2, s2, weights, specName)
        local score1 = MSC.GetItemScore(stats1, weights, specName, s1)
        local score2 = MSC.GetItemScore(stats2, weights, specName, s2)
        
        local winner = (score2 < score1) and s2 or s1
        MSC.SlotCache[cacheKey] = winner
        return winner
    end

    if equipLoc == "INVTYPE_WEAPON" then
        local _, class = UnitClass("player")
        local canDW = (class == "WARRIOR" or class == "ROGUE" or class == "HUNTER")
        if class == "SHAMAN" and MSC.GetTalentRank then
            canDW = MSC:GetTalentRank("DUAL_WIELD") > 0
        end
        
        if canDW then
            local l1 = baselineGear and baselineGear[16] or GetInventoryItemLink("player", 16)
            local l2 = baselineGear and baselineGear[17] or GetInventoryItemLink("player", 17)
            
            if itemLink == l1 then return 17 end
            if itemLink == l2 then return 16 end
            
            if MSC.SlotCache[cacheKey] then return MSC.SlotCache[cacheKey] end

            if l1 and l2 then
                local _,_,_,_,_,_,_,_, loc2 = GetItemInfo(l2)
                if loc2 == "INVTYPE_WEAPON" or loc2 == "INVTYPE_WEAPONOFFHAND" then
                    local stats1 = MSC.SafeGetItemStats(l1, 16, weights, specName)
                    local stats2 = MSC.SafeGetItemStats(l2, 17, weights, specName)
                    local score1 = MSC.GetItemScore(stats1, weights, specName, 16)
                    local score2 = MSC.GetItemScore(stats2, weights, specName, 17)
                    
                    local winner = (score2 < score1) and 17 or 16
                    MSC.SlotCache[cacheKey] = winner
                    return winner
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
    return MSC:GetProfileWeights(profileName)
end

-- =============================================================
-- 3. STAT CALCULATOR (The Breakdown Display)
-- =============================================================
-- Era item crit is a percent, so derived crit is added as a percent. Forever
-- items carry Crit Rating instead, so derived crit is converted to rating
-- there (flat 14 rating per 1%, from Database_Forever's CombatRatingScalars;
-- col 7 = Crit, col 10 = Spell Crit) to sit in the same key as item crit.
local function PercentToRating(percent, col)
    if not MSC.IsForever then return percent end
    local row = MSC.CombatRatingScalars and (MSC.CombatRatingScalars[UnitLevel("player")] or MSC.CombatRatingScalars[60])
    return percent * ((row and row[col]) or 14)
end

function MSC.ExpandDerivedStats(baseStats, itemLink, outTable)
    wipe(outTable or {})
    local dest = outTable or {}
    
    -- 1. Copy raw stats
    if baseStats then
        for k, v in pairs(baseStats) do dest[k] = v end
    end

    local _, class = UnitClass("player")
	local _, race = UnitRace("player")
    local function Rank(name) return (MSC.GetTalentRank and MSC:GetTalentRank(name)) or 0 end

    -- === A. STAMINA -> HEALTH ===
	local stam = dest["ITEM_MOD_STAMINA_SHORT"] or 0
    if stam > 0 then
        local hpPerStam = 10; if race == "Tauren" then hpPerStam = 10.5 end 
        if class == "DRUID" then local r = Rank("HEART_WILD"); if r > 0 then hpPerStam = hpPerStam * (1 + (0.04 * r)) end end
        dest["ITEM_MOD_HEALTH_SHORT"] = (dest["ITEM_MOD_HEALTH_SHORT"] or 0) + (stam * hpPerStam)
    end

    -- === B. INTELLECT -> MANA, SP, SPELL CRIT ===
    local int = dest["ITEM_MOD_INTELLECT_SHORT"] or 0
    if int > 0 then
        -- 1. Mana
        local manaPerInt = 15; if race == "Gnome" then manaPerInt = 15.75 end
        dest["ITEM_MOD_MANA_SHORT"] = (dest["ITEM_MOD_MANA_SHORT"] or 0) + (int * manaPerInt)

        -- 2. Spell Power (Talents)
        if class == "PALADIN" then local r=Rank("HOLY_GUIDANCE"); if r>0 then dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+(int*(0.07*r)) end end
        if class == "SHAMAN" then local r=Rank("NATURES_BLESSING"); if r>0 then local b=int*(0.10*r); dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+b; dest["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=(dest["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0)+b end end
        if class == "DRUID" then local r=Rank("LUNAR_GUIDANCE"); if r>0 then dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+(int*(0.0833*r)) end end
        if class == "MAGE" then local r=Rank("MIND_MASTERY"); if r>0 then dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+(int*(0.05*r)) end end

        -- 3. Spell Crit (Version Branch)
        if MSC.IsVanillaRules then
            -- VANILLA: Roughly 59.5 Int = 1% Crit (Mage), others vary. Using ~60 as generic.
            local intPerCrit = 60
            -- Forever: the class's real Int per 1% spell crit at this level
            if MSC.IsForever and MSC.GetForeverIntPerSpellCrit then intPerCrit = MSC.GetForeverIntPerSpellCrit() end
            local critPercent = int / intPerCrit
            dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] or 0) + PercentToRating(critPercent, 10)
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
        if MSC.IsVanillaRules then
            -- VANILLA: Hunter/Rogue 29/20 Agi = 1%. War/Pal 20 Agi = 1%.
            local div = 20
            if class == "HUNTER" then div = 53 elseif class == "ROGUE" then div = 29 end
            -- Forever: the class's real Agi per 1% crit at this level
            if MSC.IsForever and MSC.GetForeverAgiPerCrit then div = MSC.GetForeverAgiPerCrit() end
            local critPercent = agi / div
            dest["ITEM_MOD_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_CRIT_RATING_SHORT"] or 0) + PercentToRating(critPercent, 7)
        else
            -- TBC: Returns RATING.
            local agiPerPercent = (class == "HUNTER" or class == "ROGUE") and 40 or 25
            local critPerAgi = 22.1 / agiPerPercent
            dest["ITEM_MOD_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_CRIT_RATING_SHORT"] or 0) + (agi * critPerAgi)
        end

        -- 2. Dodge Rating
        if not MSC.IsVanillaRules then
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
        if class == "PRIEST" then local r=Rank("SPIRIT_GUIDANCE"); if r>0 then local b=spt*(0.05*r); dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+b; dest["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=(dest["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0)+b end end
    end
    
    -- === F. SPELL POWER -> HEALING (TBC Logic) ===
    local sp = dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0
    if sp > 0 then
        dest["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = (dest["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0) + sp
    end
    
    -- === G. ATTACK POWER ===
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
    end

    -- Special Case: Hunter Ranged AP comes from Agility only (Strength adds
    -- none): 2 per point on Era/Forever, 1 per point in TBC. Plus Int
    -- (Careful Aim).
    if class == "HUNTER" then
        if agi > 0 then
            local rapFromAgi = agi * (MSC.IsVanillaRules and 2 or 1)
            dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = (dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] or 0) + rapFromAgi
        end

        -- Careful Aim (Int -> RAP)
        local r = Rank("CAREFUL_AIM")
        if r > 0 then
            local int = dest["ITEM_MOD_INTELLECT_SHORT"] or 0
            if int > 0 then
                local rapFromInt = int * (0.15 * r) -- 15/30/45%
                dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = (dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] or 0) + rapFromInt
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
-- Judge's Note colours (read-only)
local NOTE_CL_DEFAULT, NOTE_CR_DEFAULT = {r=0.85, g=0.6, b=1.0}, {r=0.64, g=0.21, b=0.93}
local NOTE_CL_PVP, NOTE_CR_PVP = {r=1.0, g=0.6, b=0.6}, {r=1.0, g=0.2, b=0.2}
local NOTE_CL_WEAPON, NOTE_CR_WEAPON = {r=1.0, g=0.8, b=0.4}, {r=1.0, g=0.5, b=0.0}

-- [[ 1. VISUAL OPTIMIZATION: STATIC TABLES ]]

-- Map: Short Name -> Long Name
local SHORT_TO_LONG = {
    [MSC.L["Str"]] = MSC.L["Strength"],   [MSC.L["Agi"]] = MSC.L["Agility"],    [MSC.L["Stam"]] = MSC.L["Stamina"],
    [MSC.L["Int"]] = MSC.L["Intellect"],  [MSC.L["Spt"]] = MSC.L["Spirit"],
    [MSC.L["AP"]]  = MSC.L["Attack Power"], [MSC.L["SP"]] = MSC.L["Spell Power"],
    [MSC.L["Hp5"]] = MSC.L["Health per 5 sec"], [MSC.L["Mp5"]] = MSC.L["Mana per 5 sec"],
    [MSC.L["Hit"]] = MSC.L["Hit Rating"], [MSC.L["Crit"]] = MSC.L["Critical Strike Rating"],
    [MSC.L["Haste"]] = MSC.L["Haste Rating"], [MSC.L["Exp"]] = MSC.L["Expertise Rating"],
    [MSC.L["Def"]] = MSC.L["Defense Rating"], [MSC.L["Resil"]] = MSC.L["Resilience Rating"],
    [MSC.L["Dodge"]] = MSC.L["Dodge Rating"], [MSC.L["Parry"]] = MSC.L["Parry Rating"], 
    [MSC.L["Block"]] = MSC.L["Block Rating"], [MSC.L["BlockVal"]] = MSC.L["Block Value"],
    [MSC.L["ArP"]] = MSC.L["Armor Penetration"], [MSC.L["Heal"]] = MSC.L["Healing"],
    [MSC.L["Spell Hit"]] = MSC.L["Spell Hit Rating"], [MSC.L["Spell Crit"]] = MSC.L["Spell Crit Rating"],
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
	["Spell Dmg, Heal"] = "ff69ccf0", [MSC.L["spell dmg, heal"]] = "ff69ccf0",

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
    ["Swords"] = "ffffd100", [MSC.L["swords"]] = "ffffd100",
    ["Axes"] = "ffffd100", [MSC.L["axes"]] = "ffffd100", 
    ["Maces"] = "ffffd100", [MSC.L["maces"]] = "ffffd100",
    ["Daggers"] = "ffffd100", [MSC.L["daggers"]] = "ffffd100", 
    ["Bows"] = "ffffd100", [MSC.L["bows"]] = "ffffd100", 
    ["Guns"] = "ffffd100", [MSC.L["guns"]] = "ffffd100",
}


local function Colorize(text)
    if not SGJ_Settings.ColorizeStats then return text end
    local color = VISUAL_COLORS[text]
    if color then return "|c" .. color .. text .. "|r" end
    return text
end

-- [[ WORD HIGHLIGHTING CACHE ]]
-- Tooltips refresh ~5x/sec while hovered, so the stat-name list is lowered and
-- sorted once (longest first, ties alphabetical) and per-line work reuses scratch arrays.
local HL_Names = {}      -- { lname, localName, key }, longest lname first
local HL_MapSize = -1    -- BaseStatMap size HL_Names was built from
local HL_SpanS, HL_SpanE, HL_SpanIdx = {}, {}, {} -- accepted spans, ordered by start

local function HL_MapCount(map)
    local n = 0
    for _ in pairs(map) do n = n + 1 end
    return n
end

local function HL_Rebuild(map, size)
    wipe(HL_Names)
    for localName, internalKey in pairs(map) do
        HL_Names[#HL_Names + 1] = { lname = localName:lower(), localName = localName, key = internalKey }
    end
    table_sort(HL_Names, function(a, b)
        local la, lb = #a.lname, #b.lname
        if la ~= lb then return la > lb end
        if a.lname ~= b.lname then return a.lname < b.lname end
        return a.localName < b.localName
    end)
    HL_MapSize = size
end

-- Wraps/shortens every stat name in the line. Names are matched against the original
-- line, longest first, skipping any overlapping an accepted one, then replaced right
-- to left -- replacing as we went let a later name match text an earlier one inserted
-- ("damage per second" -> "Weapon DPS", then "dps" -> "Weapon DPS" again).
local function HighlightWords(newText)
    local lowerNewText = newText:lower()
    local n = 0
    for idx = 1, #HL_Names do
        local entry = HL_Names[idx]
        local s, e = string_find(lowerNewText, entry.lname, 1, true)
        if s then
            local clear, pos = true, n + 1
            for j = 1, n do
                if s <= HL_SpanE[j] and e >= HL_SpanS[j] then clear = false; break end
                if pos > n and s < HL_SpanS[j] then pos = j end
            end
            if clear then
                for j = n, pos, -1 do
                    HL_SpanS[j + 1], HL_SpanE[j + 1], HL_SpanIdx[j + 1] = HL_SpanS[j], HL_SpanE[j], HL_SpanIdx[j]
                end
                HL_SpanS[pos], HL_SpanE[pos], HL_SpanIdx[pos] = s, e, idx
                n = n + 1
            end
        end
    end

    local shortNames = MSC.StatShortNames
    for j = n, 1, -1 do -- right to left so positions hold
        local s, e = HL_SpanS[j], HL_SpanE[j]
        local entry = HL_Names[HL_SpanIdx[j]]
        local localName, internalKey = entry.localName, entry.key
        local actualText = string.sub(newText, s, e)
        local replacement = actualText

        -- 1. SHORTEN
        local shortName = shortNames and shortNames[internalKey]
        if SGJ_Settings.SimplifyStats and shortName then
            replacement = shortName
        end

        -- 2. COLOR
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
    return newText
end

-- Line memo: input text -> rewritten text (relic tooltips skip Compact Equip, so they
-- get their own table). Each output is also stored as mapping to itself, so a line we
-- already rewrote is left alone on the next refresh (the rewrite is not idempotent).
local BT_Memo, BT_MemoRelic = {}, {}
local BT_MemoCount = 0
local BT_MemoFlags = nil

function MSC:BeautifyTooltip(tooltip)
    if not SGJ_Settings then return end
    if not MSC.Scanner or not MSC.Scanner.EquipPatterns or not MSC.Scanner.ClassifyLine then return end

    local tooltipName = tooltip:GetName()
    local numLines = tooltip:NumLines()
    
    -- 1. Grab link to check for Relics safely
    local _, link = nil, nil
    _, link = MSC_GetTooltipItem(tooltip)
    if not link and MSC.HoveredQuestLink then link = MSC.HoveredQuestLink end
    -- Only item tooltips have lines worth rewriting. Unit/world-cursor tooltips
    -- (reached via the AllTypes post-call) carry secret strings that error on compare.
    if not link then return end

    local isRelic = false
    if link then
        -- GetItemInfoInstant order: itemID, type, subType, equipLoc, icon, classID, subClassID
        local _, _, _, equipLoc, _, classID, subClassID = GetItemInfoInstant(link)
        isRelic = (equipLoc == "INVTYPE_RELIC") or (classID == 4 and (subClassID == 7 or subClassID == 8 or subClassID == 9 or subClassID == 11))
    end

    local prefix = tooltipName .. "TextLeft"

    -- Memo results depend only on the line text, these settings and the stat map.
    local baseMap = MSC.Scanner.BaseStatMap
    local mapSize = baseMap and HL_MapCount(baseMap) or 0
    local flags = (SGJ_Settings.SimplifyStats and "1" or "0") .. (SGJ_Settings.ColorizeStats and "1" or "0")
        .. (SGJ_Settings.CompactEquip and "1" or "0") .. mapSize
    if flags ~= BT_MemoFlags or BT_MemoCount > 2000 then
        wipe(BT_Memo); wipe(BT_MemoRelic)
        BT_MemoCount = 0
        BT_MemoFlags = flags
    end
    if baseMap and mapSize ~= HL_MapSize then HL_Rebuild(baseMap, mapSize) end
    local memo = isRelic and BT_MemoRelic or BT_Memo

    for i = 2, numLines do
        local leftObj = _G[prefix .. i]
        if leftObj then
            local text = leftObj:GetText()
            local cached = nil
            if text and not MSC_IsSecret(text) then
                cached = memo[text]
                if cached and cached ~= text then leftObj:SetText(cached) end
            end
            if text and not cached and not MSC_IsSecret(text) then
                local newText = text
                local lineChanged = false
                
                local lineType = MSC.Scanner.ClassifyLine(text)
                
				-- [[ PHASE 1: COMPACT EQUIP ]]
                if SGJ_Settings.CompactEquip and (lineType == "EQUIP") and not isRelic then
                    
                    local cleanText = text:lower()
                        :gsub("|c%x%x%x%x%x%x%x%x", "")
                        :gsub("|r", "")
                        :gsub("[\n\t]", " ")
                        :gsub("%s+", " ")
                        :gsub("^%s*(.-)%s*$", "%1")
                        :gsub(MSC.L["^equip: "] or "^equip: ", "")

                    -- 1. SKIP CONDITIONAL TEXT
                    local isConditional = false
                    if string.find(cleanText, MSC.L[" against "] or " against ") or string.find(cleanText, MSC.L["by your "] or "by your ") or string.find(cleanText, MSC.L["of your "] or "of your ") then
                        isConditional = true
                    end

                    if not isConditional then
                        -- 2. HANDLE HYBRID HEAL/DAMAGE 
                        local heal, dmg = string.match(cleanText, MSC.L["healing.-(%d+).-damage.-(%d+)"] or "healing.-(%d+).-damage.-(%d+)")
                        if heal and dmg then
                            local healName = SGJ_Settings.SimplifyStats and (MSC.L["Heal"] or "Heal") or (MSC.L["Healing"] or "Healing")
                            local dmgName  = SGJ_Settings.SimplifyStats and (MSC.L["SP"] or "SP") or (MSC.L["Spell Power"] or "Spell Power")
                            newText = (MSC.L["Equip: "] or "Equip: ") .. "+" .. heal .. " " .. Colorize(healName) .. ", +" .. dmg .. " " .. Colorize(dmgName)
                            lineChanged = true
                        else
                            -- 3. STANDARD SINGLE STAT COMPACTION
                            for _, pat in ipairs(MSC.Scanner.EquipPatterns) do
                                if pat.p and not pat.func then
                                    local m1, m2 = string.match(cleanText, pat.p)
                                    if m1 then
                                        local val, rawName = MSC.Scanner.OrderCaptures(pat, m1, m2)
                                        local finalName = nil

                                        if pat.fixedStat and MSC.StatShortNames then
                                            finalName = MSC.StatShortNames[pat.fixedStat]
                                        elseif rawName and MSC.Scanner.TermMap then
                                            local nameKey = rawName:gsub(MSC.L["your "] or "your ", ""):gsub("^%s*(.-)%s*$", "%1")
                                            local internalKey = MSC.Scanner.TermMap[nameKey]
                                            
                                            if not internalKey then
                                                local titleCase = (" " .. nameKey):gsub("%W%l", string.upper):sub(2)
                                                internalKey = MSC.Scanner.TermMap[titleCase]
                                            end
                                            
                                            if internalKey and MSC.StatShortNames then
                                                finalName = MSC.StatShortNames[internalKey]
                                            end
                                        end

                                        if val and finalName then
                                            if not SGJ_Settings.SimplifyStats then
                                                finalName = SHORT_TO_LONG[finalName] or finalName
                                            end
                                            
                                            local prefixStr = MSC.L["Equip: "] or "Equip: "
                                            local valStr = (pat.isPercent or string.find(text, "%%")) and ("+" .. val .. "% ") or ("+" .. val .. " ")
                                            
                                            newText = prefixStr .. valStr .. Colorize(finalName)
                                            lineChanged = true
                                            break 
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                -- [[ PHASE 2: WORD HIGHLIGHTING ]]
                if not lineChanged and baseMap then
                    newText = HighlightWords(newText)
                end

                memo[text] = newText
                BT_MemoCount = BT_MemoCount + 1
                if newText ~= text then
                    memo[newText] = newText
                    BT_MemoCount = BT_MemoCount + 1
                    leftObj:SetText(newText)
                end
            end
        end
    end
end

-- [[ WORN COPY DETECTION ]]
-- Rings, trinkets and dual-wield weapons compare against the other slot of
-- their pair, so an item worn in slot 11 is compared against slot 12. That is
-- right for a copy in the bags, but the worn copy itself should read
-- "* EQUIPPED *". Returns the slot the hovered copy is worn in, or nil.
local TWIN_SLOT = { [11] = 12, [12] = 11, [13] = 14, [14] = 13, [16] = 17, [17] = 16 }
local GetBagNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetBagItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink

local function GetWornSlot(tooltip, link, slotId)
    if GetInventoryItemLink("player", slotId) == link then return slotId end
    local twin = TWIN_SLOT[slotId]
    if not twin or GetInventoryItemLink("player", twin) ~= link then return nil end

    -- The same item is worn in the twin slot. Hovering a character-sheet slot
    -- (CharacterFinger0Slot etc.) settles it.
    local owner = tooltip.GetOwner and tooltip:GetOwner()
    if owner and owner.GetName and owner.GetID then
        local ok, name = pcall(owner.GetName, owner)
        if ok and type(name) == "string" and not MSC_IsSecret(name) and string_find(name, "^Character%w+Slot$") then
            return (owner:GetID() == twin) and twin or nil
        end
    end

    -- Otherwise (other character frames, chat links): it's the worn copy unless
    -- a copy with the same link sits in the bags.
    if GetBagNumSlots and GetBagItemLink then
        for bag = 0, 4 do
            for bagSlot = 1, (GetBagNumSlots(bag) or 0) do
                if GetBagItemLink(bag, bagSlot) == link then return nil end
            end
        end
    end
    return twin
end

function MSC.EvaluateAndDrawTooltip(tooltip)
    -- [[ 1. INSTANT CHECKS & LAYOUT PROTECTION ]]
    if MSC.IsCalculating then return end
    
    local tooltipName = tooltip:GetName()
    if tooltipName then
        if string_find(tooltipName, "MSC_ScannerTooltip") then return end
        if string_find(tooltipName, "ShoppingTooltip") then return end
    end
    
    if SGJ_Settings then
        if SGJ_Settings.HideTooltips then return end
        if SGJ_Settings.ShiftOnlyTooltip and not IsShiftKeyDown() then return end
    end

    -- [[ 2. GET ITEM LINK ]]
    local _, link = nil, nil
    _, link = MSC_GetTooltipItem(tooltip)

    if not link and MSC.HoveredQuestLink then
        link = MSC.HoveredQuestLink
    end

    -- [[ 3. RUN VISUAL UPDATES FIRST ]]
    if MSC.BeautifyTooltip then MSC:BeautifyTooltip(tooltip) end

    -- [[ 4. VALIDATE ITEM (synchronous -- no item data needed) ]]
    if not link or not IsEquippableItem(link) or not MSC.IsItemUsable(link) then
        return
    end

    -- [[ 5. ITEM DATA GATEKEEPER ]]
    -- Defer when EITHER the item data isn't cached yet (GetItemInfo nil) OR the tooltip
    -- isn't visible yet (chat links / ItemRefTooltip still being constructed).
    -- Bag/inventory items satisfy both synchronously -> no deferral, no flicker.
    local itemName = GetItemInfo(link)
    if not itemName or (not tooltip:IsVisible() and not MSC.IsQuestHook) then
        C_Timer.After(0, function()
            if tooltip:IsVisible() or MSC.IsQuestHook then
                MSC.EvaluateAndDrawTooltip(tooltip)
            end
        end)
        return
    end

    -- [[ 6. SCORING DUPLICATE GUARD ]]
    -- (visibility is guaranteed by the gatekeeper above)
    if tooltipName then
        for i = 2, tooltip:NumLines() do
            local leftLine = _G[tooltipName .. "TextLeft" .. i]
            local lineText = leftLine and leftLine:GetText()
            if lineText and not MSC_IsSecret(lineText) and string_find(lineText, MSC.L["Judge's Score:"] or "Judge's Score:") then
                return
            end
        end
    end

    MSC.IsCalculating = true

    -- [[ 6. RUN SCORING ENGINE ]]
    local _, playerClass = UnitClass("player")
    if not MSC.CurrentClass or MSC.CurrentClass.Name ~= playerClass then
        if MSC.ForceInit then MSC:ForceInit() end
        if not MSC.CurrentClass then 
            MSC.IsCalculating = false 
            return 
        end
    end

    local status, err = pcall(function()
        local weights, specName = MSC.GetCurrentWeights()
        if not weights or not next(weights) then return end
        local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
        
        local slotId = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
        if not slotId then return end

        -- A worn ring/trinket/dual-wield weapon: GetComparisonSlot points at
        -- the other slot of the pair (right for a copy in the bags), so score
        -- the worn copy in its own slot and mark it equipped.
        local wornSlot = GetWornSlot(tooltip, link, slotId)
        local isEquipped = (wornSlot ~= nil)
        if wornSlot then slotId = wornSlot end

        local newScore, oldScore, itemNewStats, itemOldStats, newStatsTotal, oldStatsTotal, newTotalColors, oldSetCounts, newSetCounts, contextMsg, pairedFromBags = MSC:EvaluateUpgrade(link, slotId, weights, specName)
        local delta = newScore - oldScore
        
        -- [[ THE HEADER ]]
        tooltip:AddLine(" ")
        local scoreLabel = MSC.L["Judge's Score:"]
        if contextMsg then scoreLabel = scoreLabel .. " " .. contextMsg end
        tooltip:AddDoubleLine(scoreLabel, string_format("|cffffffff%.1f|r", newScore), 1, 0.82, 0)
        
        local displayName = specName or "?"
        if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[specName] then displayName = MSC.CurrentClass.PrettyNames[specName] end
        
        local _, _, capInfo = MSC.GetCurrentWeights()
        if capInfo then displayName = displayName .. " |cff00ff00(" .. capInfo .. " " .. MSC.L["Capped"] .. ")|r" end
        tooltip:AddDoubleLine(MSC.L["Verdict Profile:"], "|cff00ccff" .. displayName .. "|r", 1, 0.82, 0)

        -- [[ THE EQUIPPED SPLIT ]]
        if isEquipped then
            tooltip:AddLine(MSC.L["|cff00ffff* EQUIPPED *|r"])
        else
            if equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET" then
                local comparedItemLink = GetInventoryItemLink("player", slotId)
                if comparedItemLink then tooltip:AddDoubleLine(MSC.L["vs."], comparedItemLink, 0.6, 0.6, 0.6, 1, 1, 1) end
            end

            -- [[ 3. JUDGE'S NOTES ]]
            if link then
                local itemID = tonumber(string_match(link, "item:(%d+)"))
                local noteDisplayed = false

                if MSC.CurrentClass and MSC.CurrentClass.GetRelicBonus then
                    local dbStats = MSC.CurrentClass:GetRelicBonus(itemID, specName)
                    if dbStats and next(dbStats) then
                        local statStr = ""
                        for key, val in pairs(dbStats) do
                            if key ~= "note" and type(val) == "number" and val > 0 then
                                local name = (MSC.StatShortNames and MSC.StatShortNames[key]) 
                                if not name then name = key:gsub("ITEM_MOD_", ""):gsub("_SHORT", ""):gsub("_", " "):lower() end
                                if statStr ~= "" then statStr = statStr .. ", " end
                                -- relic equivalents can be fractional (e.g. 2.4 Mp5)
                                local fmtVal = (val >= 10 or val == math.floor(val)) and string_format("%d", math.floor(val + 0.5)) or string_format("%.1f", val)
                                statStr = statStr .. "+" .. fmtVal .. " " .. name
                            end
                        end
                        if statStr ~= "" then
                            tooltip:AddLine(" ")
                            tooltip:AddLine(MSC.L["Evaluated As: "] .. "|cff00ff00" .. statStr .. "|r", 1, 1, 1, true) 
                        end
                        
                        local rawRelicTable = MSC.CurrentClass.Relics or MSC.CurrentClass.Totems or MSC.CurrentClass.Idols
                        if rawRelicTable and type(rawRelicTable[itemID]) == "table" and rawRelicTable[itemID].note then
                            tooltip:AddLine(" ")
                            tooltip:AddLine(MSC.L["Judge's Note: "] .. "|cffA335ED" .. rawRelicTable[itemID].note .. "|r", 0.85, 0.6, 1.0, true)
                            noteDisplayed = true
                        end
                    end
                end

                if not noteDisplayed then
                    local entry = nil
                    local cL, cR = NOTE_CL_DEFAULT, NOTE_CR_DEFAULT

                    if MSC.PvPDB and MSC.PvPDB[itemID] then
                        entry = MSC.PvPDB[itemID]; cL, cR = NOTE_CL_PVP, NOTE_CR_PVP
                    elseif MSC.WeaponDB and MSC.WeaponDB[itemID] then
                        entry = MSC.WeaponDB[itemID]; cL, cR = NOTE_CL_WEAPON, NOTE_CR_WEAPON
                    elseif MSC.TrinketDB and MSC.TrinketDB[itemID] then
                        entry = MSC.TrinketDB[itemID]
                    elseif MSC.ProcDB and MSC.ProcDB[itemID] then
                        entry = MSC.ProcDB[itemID]
                    end

                    if entry and entry.note then
                        tooltip:AddLine(" ")
                        local hexColor = string.format("ff%02x%02x%02x", cR.r*255, cR.g*255, cR.b*255)
                        tooltip:AddLine(MSC.L["Judge's Note: "] .. "|c" .. hexColor .. entry.note .. "|r", cL.r, cL.g, cL.b, true)
                    elseif not entry and itemNewStats and itemNewStats._RAW_PROCS then
                        -- Scanner found "chance on hit" / temporary Equip: proc text but
                        -- no curated ProcDB/WeaponDB/TrinketDB/PvPDB entry exists for it --
                        -- let the player know the score below is stats-only.
                        tooltip:AddLine(" ")
                        tooltip:AddLine(MSC.L["Proc not yet modeled (score reflects stats only)"], 0.53, 0.53, 0.53, true)
                    end
                end
            end

            -- [[ 4. UPGRADE/DOWNGRADE MATH ]]
            if delta > 0.01 then 
                if oldScore > 0 then
                    local percentDiff = ((newScore - oldScore) / oldScore) * 100
                    tooltip:AddLine(string_format(MSC.L["|cff00ff00%s Upgrade (+%.1f / +%.1f%%)|r"], TEX_UP, delta, percentDiff))
                else
                    tooltip:AddLine(string_format(MSC.L["|cff00ff00%s Upgrade (+%.1f / New)|r"], TEX_UP, delta))
                end
            elseif delta < -0.01 then 
                if oldScore > 0 then
                    local percentDiff = ((newScore - oldScore) / oldScore) * 100
                    tooltip:AddLine(string_format(MSC.L["|cffff0000%s Downgrade (%.1f / %.1f%%)|r"], TEX_DOWN, delta, percentDiff))
                else
                    tooltip:AddLine(string_format(MSC.L["|cffff0000%s Downgrade (%.1f)|r"], TEX_DOWN, delta))
                end
            else 
                tooltip:AddLine(MSC.L["|cff888888= Sidegrade (0.0)|r"]) 
            end

            if MSC.SetBonusScores and oldSetCounts and newSetCounts then
                -- Only sets worn before or after the swap can change (not all 500+ sets).
                local function CheckSet(setID)
                    local scores = MSC.SetBonusScores[setID]
                    if not scores then return end
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
                for setID in pairs(oldSetCounts) do CheckSet(setID) end
                for setID in pairs(newSetCounts) do
                    if oldSetCounts[setID] == nil then CheckSet(setID) end
                end
            end

            if SGJ_Settings.TrackedSpecs and next(SGJ_Settings.TrackedSpecs) then
                for tSpec, isActive in pairs(SGJ_Settings.TrackedSpecs) do
                    if isActive and tSpec ~= specName then
                        local playerKey = MSC:GetPlayerKey()
                        local originalTalentCache = MSC.TalentCache
                        local function evalTrackedSpec()
                            if SGJ_Settings.TalentProfiles and SGJ_Settings.TalentProfiles[playerKey] and SGJ_Settings.TalentProfiles[playerKey][tSpec] then
                                MSC.TalentCache = SGJ_Settings.TalentProfiles[playerKey][tSpec]
                            end

                            local tWeights = MSC.GetWeightsByName(tSpec)
                            if not tWeights then return end

                            local baselineGear = nil
                            if SGJ_Settings.GearProfiles and SGJ_Settings.GearProfiles[playerKey] then
                                baselineGear = SGJ_Settings.GearProfiles[playerKey][tSpec]
                            end

                            local tSlotId = MSC.GetComparisonSlot(link, equipLoc, tWeights, tSpec, baselineGear)
                            if not tSlotId then return end

                            local tNewScore, tOldScore, _, _, _, _, _, oSC, nSC = MSC:EvaluateUpgrade(link, tSlotId, tWeights, tSpec, baselineGear)
                            local tDelta = tNewScore - tOldScore

                            if tDelta > 0.01 then
                                local prettySpec = (MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[tSpec]) or tSpec
                                local label = "|cff00ccff" .. prettySpec .. ":|r"
                                if baselineGear then label = "|cff00ccff" .. prettySpec .. " |cff888888(" .. MSC.L["Saved"] .. "):|r" end
                                tooltip:AddDoubleLine(label, string_format(MSC.L["|cff00ff00+%d (Upgrade)|r"], math_floor(tDelta)), 1, 1, 1, 1, 1, 1)

                                if oSC and nSC and MSC.SetBonusScores then
                                    -- Breaking needs oC > nC >= 0, so only sets worn before the swap.
                                    for setID in pairs(oSC) do
                                        local scores = MSC.SetBonusScores[setID]
                                        local oC = oSC[setID] or 0
                                        local nC = nSC[setID] or 0
                                        if scores and nC < oC then
                                            for req, _ in pairs(scores) do
                                                local rN = tonumber(req)
                                                if rN and oC >= rN and nC < rN then tooltip:AddLine(string_format(MSC.L["  |cffff0000(Breaks %d-pc Set Bonus!)|r"], rN)) end
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        local ok, err = xpcall(evalTrackedSpec, function(e) return debugstack(e, 2) end)
                        MSC.TalentCache = originalTalentCache
                        if not ok and MSC.Debug then print("|cff00ccffSGJ|r tracked-spec error:", err) end
                    end
                end
            end

            -- [[ 6. PROJECTIONS ]]
            if itemNewStats and (itemNewStats.IS_PROJECTED or itemNewStats.GEMS_PROJECTED) then
                tooltip:AddLine(" ")
                
                if itemNewStats.ENCHANT_TEXT then 
                    local cleanEnchant = CleanText(itemNewStats.ENCHANT_TEXT)
                    tooltip:AddDoubleLine(MSC.L["Projected Enchant:"], cleanEnchant, 0, 1, 1, 1, 1, 1)
                elseif itemNewStats.IS_PROJECTED then 
                    tooltip:AddDoubleLine(MSC.L["Projected Enchant:"], MSC.L["Best Available"], 0, 1, 1, 1, 1, 1) 
                end
                
                if not MSC.IsVanillaRules and itemNewStats.PROJECTION_DATA then
                    local data = itemNewStats.PROJECTION_DATA
                    for i, gem in ipairs(data.Gems) do
                        local label = (i == 1) and MSC.L["Projected Gems:"] or MSC.L[" "] or " "
                        local leftR, leftG, leftB = (i == 1) and 0 or 0, (i == 1) and 1 or 0, (i == 1) and 1 or 0
                        tooltip:AddDoubleLine(label, gem.text .. " (" .. gem.color .. ")", leftR, leftG, leftB, 1, 1, 1)
                    end
                    if data.Bonus then tooltip:AddDoubleLine(" ", data.Bonus, 0, 0, 0, 0, 1, 0) end
                    if data.Stats ~= "" then tooltip:AddDoubleLine(" ", data.Stats, 0, 0, 0, 0, 0.8, 1) end
                end
                
                if not MSC.IsVanillaRules and itemNewStats.META_ID and MSC.CheckMetaRequirements and newTotalColors then 
                    if MSC:CheckMetaRequirements(itemNewStats.META_ID, newTotalColors) then 
                        tooltip:AddDoubleLine(" ", MSC.L["+ Meta Gem Active"], 0, 0, 0, 0, 1, 0) 
                    else 
                        tooltip:AddDoubleLine(" ", MSC.L["- Meta Gem Inactive (Reqs unmet)"], 0, 0, 0, 1, 0, 0) 
                    end 
                end
            end

            -- [[ 7. STAT COMPARISON ]]
            local totalNewExpanded = MSC.ExpandDerivedStats(newStatsTotal or {}, link, Scratch_Tooltip_New)
            local totalOldExpanded = MSC.ExpandDerivedStats(oldStatsTotal or {}, nil, Scratch_Tooltip_Old)
            local totalDiffs = MSC.GetStatDifferences(totalNewExpanded, totalOldExpanded, Scratch_Tooltip_Diffs)

            local totalGains, totalLosses = {}, {}
            for _, d in ipairs(totalDiffs) do
                if math_abs(d.val) > 0.1 then
                    local w = weights[d.key] or 0
                    -- Bypass the weight check if the stat is Armor
                    if w > 0.02 or d.key == "ITEM_MOD_ARMOR_SHORT" then
                        if d.val > 0 then table_insert(totalGains, d) else table_insert(totalLosses, d) end 
                    end
                end
            end

            local function StableSort(a, b) local wA=(weights[a.key]or 0); local wB=(weights[b.key]or 0); if wA==wB then return a.key<b.key end; return wA>wB end
            table_sort(totalGains, StableSort); table_sort(totalLosses, StableSort)

            -- [[ HELPER: Check for duplicate lists ]]
            local function ListsAreDifferent(l1, l2)
                if #l1 ~= #l2 then return true end
                for i = 1, #l1 do
                    if l1[i].key ~= l2[i].key or math_abs(l1[i].val - l2[i].val) > 0.1 then return true end
                end
                return false
            end

            local isWeaponSetSwap = false
            if slotId == 16 or slotId == 17 then
                local currentMH = GetInventoryItemLink("player", 16)
                local currentOH = GetInventoryItemLink("player", 17)
                local _,_,_,_,_,_,_,_, currLoc = nil
                if currentMH then _,_,_,_,_,_,_,_, currLoc = GetItemInfo(currentMH) end
                
                local isCurrent2H = (currLoc == "INVTYPE_2HWEAPON" or currLoc == "INVTYPE_STAFF" or currLoc == "INVTYPE_POLEARM")
                local isNew2H = (equipLoc == "INVTYPE_2HWEAPON" or equipLoc == "INVTYPE_STAFF" or equipLoc == "INVTYPE_POLEARM")
                
                -- [[ THE FIX: ONLY dual-list if we are actively combining 1H items ]]
                if not isNew2H then
                    if isCurrent2H then isWeaponSetSwap = true end
                    if pairedFromBags then isWeaponSetSwap = true end
                end
            end

            local function PrintList(label, list, cR, cG, cB)
                local hp, lp = false, 0
                for _, d in ipairs(list) do
                    if lp < 8 then 
                        if not hp then tooltip:AddLine(label, cR, cG, cB); hp = true end
                        local name = d.label or (MSC.GetCleanStatName(d.key) or d.key)
                        local level = UnitLevel("player")
                        if MSC.GetRatingPercent and not d.label then
                             local percentVal = MSC:GetRatingPercent(d.key, math_abs(d.val), level)
                             if percentVal and percentVal > 0.01 then
                                 name = name .. string_format(" |cff888888(%.2f%%)|r", percentVal)
                             end
                        end
                        name = name .. (d.nameSuffix or "")
                        local valStr = (d.val%1==0) and string_format("%d", math_abs(d.val)) or string_format("%.1f", math_abs(d.val))
                        if d.valSuffix then valStr = valStr .. d.valSuffix end
                        if cR==0 then valStr="+"..valStr else valStr="-"..valStr end
                        tooltip:AddDoubleLine("  " .. name, valStr, 1, 1, 1, cR, cG, cB)
                        lp = lp + 1
                    end
                end
            end

            -- Forever weapon racial (e.g. Human Sword Specialization, +2% crit): the
            -- score already counts it, so show it too when this swap gains or loses it.
            local racialEntry
            if MSC.GetForeverRacialSwapChange then
                local racialName, critChange = MSC.GetForeverRacialSwapChange(link, slotId)
                if racialName then
                    racialEntry = { key = "MSC_RACIAL_CRIT", val = critChange, valSuffix = "%",
                                    label = racialName .. " |cff888888(" .. (MSC.L["Crit"] or "Crit") .. ")|r" }
                    table_insert(critChange > 0 and totalGains or totalLosses, 1, racialEntry)
                end
            end

            if isWeaponSetSwap then
                local itemNewExpanded = MSC.ExpandDerivedStats(itemNewStats or {}, link, {})
                local itemOldExpanded = MSC.ExpandDerivedStats(itemOldStats or {}, nil, {})
                local itemDiffs = MSC.GetStatDifferences(itemNewExpanded, itemOldExpanded, {})
                
                local itemGains, itemLosses = {}, {}
                for _, d in ipairs(itemDiffs) do
                    if math_abs(d.val) > 0.1 then
                        local w = weights[d.key] or 0
                        -- Bypass the weight check if the stat is Armor
                        if w > 0.02 or d.key == "ITEM_MOD_ARMOR_SHORT" then
                            if d.val > 0 then table_insert(itemGains, d) else table_insert(itemLosses, d) end 
                        end
                    end
                end
                table_sort(itemGains, StableSort); table_sort(itemLosses, StableSort)
                if racialEntry then table_insert(racialEntry.val > 0 and itemGains or itemLosses, 1, racialEntry) end

                -- [[ SMART DISPLAY: Only show dual lists if they actually differ ]]
                if ListsAreDifferent(itemGains, totalGains) or ListsAreDifferent(itemLosses, totalLosses) then
                    PrintList(MSC.L["Item Gains:"], itemGains, 0, 1, 0)
                    PrintList(MSC.L["Item Losses:"], itemLosses, 1, 0, 0)
                    
                    if (#itemGains > 0 or #itemLosses > 0) and (#totalGains > 0 or #totalLosses > 0) then
                        tooltip:AddLine(" ")
                    end

                    PrintList(MSC.L["Combined Gains (Net):"], totalGains, 0, 1, 0)
                    PrintList(MSC.L["Combined Losses (Net):"], totalLosses, 1, 0, 0)
                else
                    PrintList(MSC.L["Gains:"], totalGains, 0, 1, 0)
                    PrintList(MSC.L["Losses:"], totalLosses, 1, 0, 0)
                end
            else
                PrintList(MSC.L["Gains:"], totalGains, 0, 1, 0)
                PrintList(MSC.L["Losses:"], totalLosses, 1, 0, 0)
            end
        end -- END OF isEquipped BLOCK
    end) -- END OF pcall

    MSC.IsCalculating = false
    if not status then geterrorhandler()(err) end
    
    -- [[ 8. THE MAGIC SNAP ]]
    if tooltip:IsVisible() then
        tooltip:Show()
    end
end

-- =============================================================
-- HOOKS & EVENT HIJACKING
-- =============================================================

-- 1. Standard Tooltip Hooks
-- Registered unconditionally, even when TooltipDataProcessor exists: on some
-- client builds that table is present but not actually wired into the real
-- tooltip pipeline (AddTooltipPostCall never fires), so trusting its mere
-- presence as proof the modern path works left every tooltip silently blank.
-- EvaluateAndDrawTooltip's own duplicate guard makes it safe to hook both.
do
    if GameTooltip:HasScript("OnTooltipSetItem") then
        GameTooltip:HookScript("OnTooltipSetItem", function(self)
            if MSC.EvaluateAndDrawTooltip then
                MSC.EvaluateAndDrawTooltip(self)
            end
        end)
    end
    if ItemRefTooltip and ItemRefTooltip:HasScript("OnTooltipSetItem") then
        ItemRefTooltip:HookScript("OnTooltipSetItem", function(self)
            if MSC.EvaluateAndDrawTooltip then
                MSC.EvaluateAndDrawTooltip(self)
            end
        end)
    end
end

-- Quest tooltip hooks live in TooltipManager.lua


