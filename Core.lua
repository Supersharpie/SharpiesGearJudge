local addonName, MSC = ...

-- =============================================================
-- 1. INITIALIZATION & EVENTS
-- =============================================================
local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterEvent("CHARACTER_POINTS_CHANGED") -- Era specific talent event
EventFrame:RegisterEvent("PLAYER_LEVEL_UP")

MSC.Modules = {}
MSC.PlayerStats = {
    Level = 0, Class = nil, Spec = "Default",
    Hit = 0, Crit = 0, SpellHit = 0, SpellCrit = 0
}

EventFrame:SetScript("OnEvent", function(self, event, arg1)
    
    -- LOAD LOGIC
    if event == "ADDON_LOADED" and arg1 == addonName then
        if not SGJ_Settings then 
            SGJ_Settings = { 
                Mode = "Auto", 
                MinimapPos = 45, 
                IncludeEnchants = true, 
                ProjectEnchants = true 
            } 
        end
        if not SGJ_History then SGJ_History = {} end
        
        if MSC.UpdateMinimapPosition then MSC.UpdateMinimapPosition() end
        print("|cff00ccffSharpie's Gear Judge|r (Classic Era) loaded!")
        
        local _, englishClass = UnitClass("player")
        MSC.PlayerStats.Class = englishClass

    elseif event == "PLAYER_LOGIN" then
        -- Conflict Checks (Good practice from TBC version)
        local IsLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
        if not SGJ_Settings.DisableConflictCheck and IsLoaded then
            if IsLoaded("Pawn") then print("|cffffd100SGJ Warning:|r 'Pawn' is loaded. Tooltips may look cluttered.") end
            if IsLoaded("ZygorGuidesViewer") then print("|cffffd100SGJ Warning:|r 'Zygor' detected. Ensure its item scoring is disabled.") end
        end
        
        local _, startSpec = MSC.GetCurrentWeights()
        MSC.LastActiveSpec = startSpec

    -- SPEC / LEVEL UPDATE
    elseif event == "PLAYER_ENTERING_WORLD" or event == "CHARACTER_POINTS_CHANGED" or event == "PLAYER_LEVEL_UP" then
        MSC.CachedWeights = nil -- Reset cache
        MSC.TalentCache = {}    -- Reset talents on change

        -- 1. Update Basic Stats
        MSC.PlayerStats.Level = UnitLevel("player")
        
        -- 2. Update Spec (using Class Module)
        local className = MSC.PlayerStats.Class
        if className and MSC.Modules[className] then
            MSC.CurrentClass = MSC.Modules[className] -- Set global reference
            local newSpec = MSC.Modules[className]:GetSpec()
            
            if MSC.PlayerStats.Spec ~= newSpec then
                local displayName = newSpec
                if MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[newSpec] then
                     displayName = MSC.CurrentClass.PrettyNames[newSpec]
                end
                print("|cff00ccffSGJ:|r Profile Active: |cff00ff00" .. (displayName or "Default") .. "|r")
                MSC.PlayerStats.Spec = newSpec
                MSC.StatCache = {} 
            end
        end

        -- 3. Update Scan Stats (Hit/Crit totals for Cap logic)
        MSC.PlayerStats.Hit = GetHitModifier and GetHitModifier() or 0
        MSC.PlayerStats.SpellHit = GetSpellHitModifier and GetSpellHitModifier() or 0
        
        if MSCLabFrame and MSCLabFrame:IsShown() then MSC.UpdateLabCalc() end
    end
end)

-- =============================================================
-- 2. SLASH COMMANDS
-- =============================================================
SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg)
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    cmd = cmd:lower()
    
    if cmd == "options" or cmd == "config" then 
        if MSC.CreateOptionsFrame then MSC.CreateOptionsFrame() end
    elseif cmd == "history" then 
        if MSC.ShowHistory then MSC.ShowHistory() end
    elseif cmd == "save" or cmd == "snapshot" then
        if MSC.RecordSnapshot then
            local label = (arg and arg ~= "") and arg or "Manual Save"
            MSC.RecordSnapshot(label)
            MSC.ShowHistory()
        end
    else 
        -- Default to Main Menu / Lab
        if MSC.ToggleMainMenu then MSC.ToggleMainMenu() end 
    end 
end

-- =============================================================
-- 3. MODULE REGISTRATION
-- =============================================================
function MSC.RegisterModule(name, moduleTable)
    if not MSC.Modules then MSC.Modules = {} end
    MSC.Modules[name] = moduleTable
end

-- =============================================================
-- 4. TALENT CACHE (Era 3-Tab System)
-- =============================================================
MSC.TalentCache = {}
function MSC:GetTalentRank(talentName)
    if not talentName then return 0 end
    -- Lazy Cache: Only scan if we haven't found it yet
    if not MSC.TalentCache[talentName] then
        for tab = 1, 3 do
            local numTalents = GetNumTalents(tab)
            for i = 1, numTalents do
                local name, _, _, _, rank = GetTalentInfo(tab, i)
                if name then 
                    -- Store uppercase keys to match consistently
                    MSC.TalentCache[name] = rank 
                    MSC.TalentCache[name:upper()] = rank
                    -- Also handle spaces vs underscores
                    local key = name:upper():gsub(" ", "_"):gsub("'", "")
                    MSC.TalentCache[key] = rank
                end
            end
        end
    end
    -- Try exact name, then normalized key
    local key = talentName:upper():gsub(" ", "_"):gsub("'", "")
    return MSC.TalentCache[talentName] or MSC.TalentCache[key] or 0
end

-- =============================================================
-- 5. WEIGHT DISPATCHER (Fixed Leveling Logic)
-- =============================================================
MSC.CachedWeights = nil
MSC.CachedProfile = nil
MSC.CachedCapText = nil
MSC.CachedIsLeveling = false

function MSC.GetCurrentWeights()
    -- 1. MANUAL OVERRIDE
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" and MSC.ManualSpec ~= "Auto" then
        if MSC.CurrentClass then
            -- Check if the manual key exists in Leveling or Endgame
            -- We assume manual selection wants the specific table provided
            if MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[MSC.ManualSpec] then
                return MSC.CurrentClass.LevelingWeights[MSC.ManualSpec], MSC.ManualSpec, nil, true
            elseif MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[MSC.ManualSpec] then
                return MSC.CurrentClass.Weights[MSC.ManualSpec], MSC.ManualSpec, nil, false
            end
        end
    end

    -- 2. CACHED RESULT
    if MSC.CachedWeights then 
        return MSC.CachedWeights, MSC.CachedProfile, MSC.CachedCapText, MSC.CachedIsLeveling 
    end

    -- 3. AUTO-DETECT
    if MSC.CurrentClass then
        local specKey = MSC.CurrentClass:GetSpec()
        local weights = nil
        local isLeveling = false
        local level = UnitLevel("player")

        -- A. Try Leveling Weights FIRST if under 60
        if level < 60 and MSC.CurrentClass.LevelingWeights then
            if MSC.CurrentClass.LevelingWeights[specKey] then
                weights = MSC.CurrentClass.LevelingWeights[specKey]
                isLeveling = true
            elseif MSC.CurrentClass.LevelingWeights["Default"] then
                weights = MSC.CurrentClass.LevelingWeights["Default"]
                specKey = "Default"
                isLeveling = true
            end
        end

        -- B. Fallback to Endgame Weights (if 60 OR if no leveling weights found)
        if not weights and MSC.CurrentClass.Weights then
            if MSC.CurrentClass.Weights[specKey] then
                weights = MSC.CurrentClass.Weights[specKey]
                isLeveling = false
            elseif MSC.CurrentClass.Weights["Default"] then
                weights = MSC.CurrentClass.Weights["Default"]
                specKey = "Default"
                isLeveling = false
            end
        end
        
        -- C. Apply Scalers (Hit Caps/etc)
        local capText = nil
        if weights and MSC.CurrentClass.ApplyScalers then
            weights = MSC:SafeCopy(weights) 
            weights, capText = MSC.CurrentClass:ApplyScalers(weights, specKey)
        end
        
        if weights then
            MSC.CachedWeights = weights
            MSC.CachedProfile = specKey
            MSC.CachedCapText = capText
            MSC.CachedIsLeveling = isLeveling
            return weights, specKey, capText, isLeveling
        end
    end
    return {}, "Unknown", nil, false
end

-- =============================================================
-- 6. SMART SLOT LOGIC (Era Adjusted)
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
        -- Note: Shaman CANNOT Dual Wield in Era/Vanilla. Removed from check.
        local canDW = (class == "WARRIOR" or class == "ROGUE" or class == "HUNTER")
        
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
-- 7. STAT CALCULATOR (Era / Vanilla Rules)
-- =============================================================
function MSC.ExpandDerivedStats(baseStats, itemLink, outTable)
    wipe(outTable or {})
    local dest = outTable or {}
    
    -- 1. Copy raw stats
    for k, v in pairs(baseStats) do dest[k] = v end

    local _, class = UnitClass("player")
    local function Rank(name) return MSC:GetTalentRank(name) end

    -- === A. STAMINA -> HEALTH ===
    local stam = dest["ITEM_MOD_STAMINA_SHORT"] or 0
    if stam > 0 then
        local hpPerStam = 10; if class == "TAUREN" then hpPerStam = 10.5 end
        if class == "DRUID" then local r = Rank("Heart of the Wild"); if r > 0 then hpPerStam = hpPerStam * (1 + (0.04 * r)) end end
        if class == "WARLOCK" then local r = Rank("Demonic Embrace"); if r > 0 then hpPerStam = hpPerStam * (1 + (0.03 * r)) end end
        dest["ITEM_MOD_HEALTH_SHORT"] = (dest["ITEM_MOD_HEALTH_SHORT"] or 0) + (stam * hpPerStam)
    end

    -- === B. INTELLECT -> MANA, SP, SPELL CRIT ===
    local int = dest["ITEM_MOD_INTELLECT_SHORT"] or 0
    if int > 0 then
        -- 1. Mana
        local manaPerInt = 15; if class == "GNOME" then manaPerInt = 15.75 end
        if class == "DRUID" then local r = Rank("Heart of the Wild"); if r > 0 then manaPerInt = manaPerInt * (1 + (0.04 * r)) end end
        if class == "SHAMAN" then local r = Rank("Ancestral Knowledge"); if r > 0 then manaPerInt = manaPerInt * (1 + (0.01 * r)) end end
        dest["ITEM_MOD_MANA_SHORT"] = (dest["ITEM_MOD_MANA_SHORT"] or 0) + (int * manaPerInt)

        -- 2. Spell Power (Vanilla Talents)
        if class == "PALADIN" then local r=Rank("Holy Guidance"); if r>0 then dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+(int*(0.07*r)) end end
        if class == "SHAMAN" then local r=Rank("Nature's Blessing"); if r>0 then local b=int*(0.10*r); dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+b; dest["ITEM_MOD_HEALING_POWER_SHORT"]=(dest["ITEM_MOD_HEALING_POWER_SHORT"] or 0)+b end end
        -- Note: TBC "Lunar Guidance" and "Mind Mastery" removed for Era

        -- 3. Spell Crit % (Vanilla approximations)
        -- In Era, 1.0 value = 1% Crit. 
        local div = 59.5 -- Generic Average
        if class == "DRUID" then div = 60 
        elseif class == "MAGE" then div = 59.5 
        elseif class == "PRIEST" then div = 59.5 
        elseif class == "PALADIN" then div = 29.5 
        elseif class == "SHAMAN" then div = 59.5 
        elseif class == "WARLOCK" then div = 60.6 
        end
        dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] or 0) + (int / div)
    end

    -- === C. AGILITY -> CRIT, DODGE, ARMOR ===
    local agi = dest["ITEM_MOD_AGILITY_SHORT"] or 0
    if agi > 0 then
        -- 1. Crit % (Physical)
        -- In Era, 1.0 value = 1% Crit
        local critDiv = 20 -- Warrior/Rogue default-ish
        if class == "HUNTER" then critDiv = 53
        elseif class == "ROGUE" then critDiv = 29
        elseif class == "WARRIOR" then critDiv = 20
        elseif class == "DRUID" then critDiv = 20
        elseif class == "PALADIN" then critDiv = 20
        elseif class == "SHAMAN" then critDiv = 20
        end
        dest["ITEM_MOD_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_CRIT_RATING_SHORT"] or 0) + (agi / critDiv)

        -- 2. Dodge %
        local dodgeDiv = 20
        if class == "HUNTER" then dodgeDiv = 26.5 elseif class == "ROGUE" then dodgeDiv = 14.5 elseif class == "DRUID" then dodgeDiv = 20 end
        dest["ITEM_MOD_DODGE_RATING_SHORT"] = (dest["ITEM_MOD_DODGE_RATING_SHORT"] or 0) + (agi / dodgeDiv)
        
        -- 3. Armor (2 Armor per Agi)
        dest["ITEM_MOD_ARMOR_SHORT"] = (dest["ITEM_MOD_ARMOR_SHORT"] or 0) + (agi * 2)
    end

    -- === D. STRENGTH -> BLOCK VALUE / AP ===
    local str = dest["ITEM_MOD_STRENGTH_SHORT"] or 0
    if str > 0 then 
        if class == "WARRIOR" or class == "PALADIN" or class == "SHAMAN" then
             dest["ITEM_MOD_BLOCK_VALUE_SHORT"] = (dest["ITEM_MOD_BLOCK_VALUE_SHORT"] or 0) + (str * 0.5)
        end
        -- AP (Str)
        local apPerStr = 2 -- Pal/War/Sham/Druid
        if class == "HUNTER" or class == "ROGUE" then apPerStr = 1 end
        dest["ITEM_MOD_ATTACK_POWER_SHORT"] = (dest["ITEM_MOD_ATTACK_POWER_SHORT"] or 0) + (str * apPerStr)
    end

    -- === E. SPIRIT -> SPELL POWER ===
    local spt = dest["ITEM_MOD_SPIRIT_SHORT"] or 0
    if spt > 0 then
        if class == "PRIEST" then local r=Rank("Spiritual Guidance"); if r>0 then local b=spt*(0.05*r); dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+b; dest["ITEM_MOD_HEALING_POWER_SHORT"]=(dest["ITEM_MOD_HEALING_POWER_SHORT"] or 0)+b end end
    end

    return dest
end

-- =============================================================
-- 8. TOOLTIP ENGINE (Era Version - No Gems)
-- =============================================================
MSC.IsCalculating = false
local Scratch_Tooltip_New = {}
local Scratch_Tooltip_Old = {}
local Scratch_Tooltip_Diffs = {}
local TEX_UP = "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Upgrade.png:14:14:0:-2|t"
local TEX_DOWN = "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Downgrade.png:14:14:0:-2|t"

-- CONFIG: Which stats to hide because they are merged into others?
local STAT_CONSOLIDATION_MAP = {
    ["ITEM_MOD_STAMINA_SHORT"] = "ITEM_MOD_HEALTH_SHORT",
    ["ITEM_MOD_INTELLECT_SHORT"] = "ITEM_MOD_MANA_SHORT", 
    ["ITEM_MOD_STRENGTH_SHORT"] = "ITEM_MOD_ATTACK_POWER_SHORT", 
}

local function OnTooltipSetItem(tooltip)
    if MSC.IsCalculating then return end
    if tooltip:GetName() and string.find(tooltip:GetName(), "MSC_ScannerTooltip") then return end
    if SGJ_Settings and SGJ_Settings.HideTooltips then return end
    local _, link = nil, nil
    if tooltip.GetItem then _, link = tooltip:GetItem() end
    if not link or not IsEquippableItem(link) then return end
	if not MSC.IsItemUsable(link) then return end
    
	MSC.IsCalculating = true
    local _, playerClass = UnitClass("player")
    -- Ensure Class Module Loaded
    if not MSC.CurrentClass or MSC.CurrentClass.Name ~= playerClass then
        -- This relies on Init, but redundant safety check is okay
        MSC.CachedWeights = nil
    end

    local status, err = pcall(function()
        local weights, specName = MSC.GetCurrentWeights()
        if not weights or not next(weights) then return end
        local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
        
        local slotId = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
        if not slotId then return end

        local newScore, oldScore, newStats, oldStats = MSC:EvaluateUpgrade(link, slotId, weights, specName)
        local delta = newScore - oldScore
        local isEquipped = (GetInventoryItemLink("player", slotId) == link)

        -- Header
        tooltip:AddLine(" ")
        local scoreLabel = "Judge's Score:"
        if newStats.Context then scoreLabel = scoreLabel .. " " .. newStats.Context end
        tooltip:AddDoubleLine(scoreLabel, string.format("|cffffffff%.1f|r", newScore), 1, 0.82, 0)
        
        local displayName = specName
        if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[specName] then displayName = MSC.CurrentClass.PrettyNames[specName] end
        local _, _, capInfo = MSC.GetCurrentWeights()
        if capInfo then displayName = displayName .. " |cff00ff00(" .. capInfo .. " Capped)|r" end
        tooltip:AddDoubleLine("Verdict Profile:", "|cff00ccff" .. displayName .. "|r", 1, 0.82, 0)

        if not isEquipped then
            if equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET" then
                local comparedItemLink = GetInventoryItemLink("player", slotId)
                if comparedItemLink then tooltip:AddDoubleLine("vs.", comparedItemLink, 0.6, 0.6, 0.6, 1, 1, 1) end
            end
            local percentDiff = 0; if oldScore > 0 then percentDiff = ((newScore - oldScore) / oldScore) * 100 end
            if delta > 0.1 then tooltip:AddLine(string.format("|cff00ff00%s Upgrade (+%.1f / +%.1f%%)|r", TEX_UP, delta, percentDiff))
            elseif delta < -0.1 then tooltip:AddLine(string.format("|cffff0000%s Downgrade (%.1f / %.1f%%)|r", TEX_DOWN, delta, percentDiff))
            else tooltip:AddLine("|cff888888= Sidegrade (0.0)|r") end
        else tooltip:AddLine("|cff00ffff*** CURRENTLY EQUIPPED ***|r") end

        -- Projections (Enchants Only for Era)
        if newStats.IS_PROJECTED then
            tooltip:AddLine(" ")
            if newStats.ENCHANT_TEXT then 
                tooltip:AddDoubleLine("Projected Enchant:", "|cffffffff" .. newStats.ENCHANT_TEXT .. "|r", 0, 1, 1)
            else 
                tooltip:AddDoubleLine("Projected Enchant:", "|cffffffffBest Available|r", 0, 1, 1) 
            end
        end

        -- STAT COMPARISON
        if not isEquipped then
            local newExpanded = MSC.ExpandDerivedStats(newStats, link, Scratch_Tooltip_New)
            local oldExpanded = MSC.ExpandDerivedStats(oldStats or {}, nil, Scratch_Tooltip_Old)
            local diffs = MSC.GetStatDifferences(newExpanded, oldExpanded, Scratch_Tooltip_Diffs)

            -- [[ CONSOLIDATION PASS ]]
            local changedMap = {}; for i, d in ipairs(diffs) do changedMap[d.key] = i end
            for source, result in pairs(STAT_CONSOLIDATION_MAP) do
                local sIdx, rIdx = changedMap[source], changedMap[result]
                if sIdx and rIdx and math.abs(diffs[sIdx].val)>0.1 and math.abs(diffs[rIdx].val)>0.1 then
                    diffs[sIdx].val = 0 -- Hide Source
                    local sName = MSC.GetCleanStatName(source) or "Stat"
                    diffs[rIdx].nameSuffix = " |cff888888(inc. " .. sName .. ")|r"
                end
            end
            
            -- Special: Paladin SP/Int
            if playerClass == "PALADIN" then 
                local iIdx, sIdx = changedMap["ITEM_MOD_INTELLECT_SHORT"], changedMap["ITEM_MOD_SPELL_POWER_SHORT"]
                if iIdx and sIdx and math.abs(diffs[iIdx].val)>0.1 and math.abs(diffs[sIdx].val)>0.1 then diffs[iIdx].val = 0 end 
            end

            local gains, losses = {}, {}
            for _, d in ipairs(diffs) do
                if math.abs(d.val) > 0.1 then
                    local isRelevant = (weights[d.key] and weights[d.key] > 0) or (d.key == "ITEM_MOD_HEALTH_SHORT") or (d.key == "ITEM_MOD_MANA_SHORT") or (d.key == "ITEM_MOD_ATTACK_POWER_SHORT") or (d.key == "ITEM_MOD_SPELL_POWER_SHORT") or (d.key == "ITEM_MOD_HEALING_POWER_SHORT") or (d.key == "ITEM_MOD_CRIT_RATING_SHORT") or (d.key == "ITEM_MOD_SPELL_CRIT_RATING_SHORT") or (d.key == "ITEM_MOD_BLOCK_VALUE_SHORT")
                    if isRelevant then if d.val > 0 then table.insert(gains, d) else table.insert(losses, d) end end
                end
            end

            local function StableSort(a, b) local wA=(weights[a.key]or 0); local wB=(weights[b.key]or 0); if wA==wB then return a.key<b.key end; return wA>wB end
            table.sort(gains, StableSort); table.sort(losses, StableSort)

            local function PrintList(label, list, cR, cG, cB)
                local hp, lp = false, 0
                for _, d in ipairs(list) do
                    if lp < 6 then -- Show top 6 changes
                        if not hp then tooltip:AddLine(label, cR, cG, cB); hp = true end
                        local name = (MSC.GetCleanStatName(d.key) or d.key) .. (d.nameSuffix or "")
                        local valStr = (d.val%1==0) and string.format("%d", math.abs(d.val)) or string.format("%.1f", math.abs(d.val))
                        if cR==0 then valStr="+"..valStr else valStr="-"..valStr end
                        tooltip:AddDoubleLine("  " .. name, valStr, 1, 1, 1, cR, cG, cB)
                        lp = lp + 1
                    end
                end
            end
            PrintList("Gains:", gains, 0, 1, 0)
            PrintList("Losses:", losses, 1, 0, 0)
        end
        tooltip:Show()
    end)
    MSC.IsCalculating = false
    if not status then geterrorhandler()(err) end
end
-- Hooks
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ShoppingTooltip1:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ShoppingTooltip2:HookScript("OnTooltipSetItem", OnTooltipSetItem)