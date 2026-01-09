local addonName, MSC = ...
_G[addonName] = MSC

-- =============================================================
-- 1. INITIALIZATION & EVENTS
-- =============================================================
local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterEvent("PLAYER_TALENT_UPDATE") 
EventFrame:RegisterEvent("PLAYER_LEVEL_UP")

EventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        if not SGJ_Settings then SGJ_Settings = { Mode = "AUTO", MinimapPos = 45 } end
        if SGJ_Settings.EnchantMode == nil then SGJ_Settings.EnchantMode = 1 end
        if SGJ_Settings.GemMode == nil then SGJ_Settings.GemMode = 1 end
        print("|cff00ff00Sharpie's Gear Judge|r (TBC Edition) Loaded. Type /sgj for menu.")
        
    elseif event == "PLAYER_LOGIN" then
        local IsLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
        if not SGJ_Settings.DisableConflictCheck and IsLoaded then
            if IsLoaded("Pawn") then print("|cffffd100SGJ Warning:|r 'Pawn' is loaded. Tooltips may look cluttered.") end
            if IsLoaded("ZygorGuidesViewer") then print("|cffffd100SGJ Warning:|r 'Zygor' detected. Ensure its item scoring is disabled.") end
        end
        
        local _, startSpec = MSC.GetCurrentWeights()
        MSC.LastActiveSpec = startSpec
        
    elseif event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LEVEL_UP" then
        MSC.CachedWeights = nil
        
    elseif event == "PLAYER_TALENT_UPDATE" then
        MSC.CachedWeights = nil
        if MSC.BuildTalentCache then MSC:BuildTalentCache() end
        
        local _, newSpecName = MSC.GetCurrentWeights()
        
        if MSC.LastActiveSpec and MSC.LastActiveSpec ~= newSpecName then
             local displayName = newSpecName
             if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[newSpecName] then
                 displayName = MSC.CurrentClass.PrettyNames[newSpecName]
             end
             print("|cff00ccffSharpie's Gear Judge:|r Spec change detected. Active Profile: " .. displayName)
        end
        MSC.LastActiveSpec = newSpecName
        
        if MSCLabFrame and MSCLabFrame:IsShown() and MSC.UpdateLabCalc then 
            MSC.UpdateLabCalc() 
        end
    end
end)

SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg) 
    if msg == "options" or msg == "config" then 
        if MSC.CreateOptionsFrame then MSC.CreateOptionsFrame() end 
    else 
        if MSC.ToggleMainMenu then MSC.ToggleMainMenu() end 
    end 
end

-- =============================================================
-- 2. WEIGHT DISPATCHER
-- =============================================================
MSC.CachedWeights = nil
MSC.CachedProfile = nil
MSC.CachedCapText = nil

function MSC.GetCurrentWeights()
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" and MSC.ManualSpec ~= "Auto" then
        if MSC.CurrentClass then
            if MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[MSC.ManualSpec] then
                return MSC.CurrentClass.Weights[MSC.ManualSpec], MSC.ManualSpec, nil
            elseif MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[MSC.ManualSpec] then
                return MSC.CurrentClass.LevelingWeights[MSC.ManualSpec], MSC.ManualSpec, nil
            end
        end
    end

    if MSC.CachedWeights then return MSC.CachedWeights, MSC.CachedProfile, MSC.CachedCapText end

    if MSC.CurrentClass then
        local specKey = MSC.CurrentClass:GetSpec()
        local weights = nil
        
        if MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[specKey] then
            weights = MSC.CurrentClass.LevelingWeights[specKey]
        elseif MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[specKey] then
            weights = MSC.CurrentClass.Weights[specKey]
        end
        
        local capText = nil
        if weights and MSC.CurrentClass.ApplyScalers then
            weights = MSC:SafeCopy(weights) 
            weights, capText = MSC.CurrentClass:ApplyScalers(weights, specKey)
        end
        
        if weights then
            MSC.CachedWeights = weights
            MSC.CachedProfile = specKey
            MSC.CachedCapText = capText
            return weights, specKey, capText
        end
    end
    return {}, "Unknown", nil
end

-- =============================================================
-- 3. HELPER: CLEAN STAT NAMES
-- =============================================================
local function GetCleanStatName(key, expandedStats)
    local name = MSC.GetCleanStatName and MSC.GetCleanStatName(key) or key
    if key == "ITEM_MOD_HEALTH_SHORT" and (expandedStats["ITEM_MOD_STAMINA_SHORT"] or 0) > 0 then name = "Health (w/ Stam)" end
    if key == "ITEM_MOD_MANA_SHORT" and (expandedStats["ITEM_MOD_INTELLECT_SHORT"] or 0) > 0 then name = "Mana (w/ Int)" end
    if key == "ITEM_MOD_ATTACK_POWER_SHORT" and ((expandedStats["ITEM_MOD_STRENGTH_SHORT"] or 0) > 0 or (expandedStats["ITEM_MOD_AGILITY_SHORT"] or 0) > 0) then name = "Atk Power (Total)" end
    return name
end

-- =============================================================
-- 4. SMART SLOT LOGIC
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
-- 5. TOOLTIP ENGINE
-- =============================================================
MSC.IsCalculating = false

local Scratch_Tooltip_New = {}
local Scratch_Tooltip_Old = {}
local Scratch_Tooltip_Diffs = {}

local TEX_UP = "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Upgrade.png:14:14:0:-2|t"
local TEX_DOWN = "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Downgrade.png:14:14:0:-2|t"

local function OnTooltipSetItem(tooltip)
    if MSC.IsCalculating then return end
    
    if tooltip:GetName() and string.find(tooltip:GetName(), "MSC_ScannerTooltip") then return end
    if SGJ_Settings and SGJ_Settings.HideTooltips then return end
    
    local _, link = nil, nil
    if tooltip.GetItem then _, link = tooltip:GetItem() end
    if not link then return end
    if not IsEquippableItem(link) then return end

    MSC.IsCalculating = true
	local _, playerClass = UnitClass("player")
    if not MSC.CurrentClass or MSC.CurrentClass.Name ~= playerClass then
        -- Force the addon to point to the correct Class table
        if playerClass == "DRUID" then MSC.CurrentClass = Druid
        elseif playerClass == "HUNTER" then MSC.CurrentClass = Hunter
        elseif playerClass == "SHAMAN" then MSC.CurrentClass = Shaman
		elseif playerClass == "PALADIN" then MSC.CurrentClass = Paladin
		elseif playerClass == "MAGE" then MSC.CurrentClass = Mage
		elseif playerClass == "PRIEST" then MSC.CurrentClass = Priest
		elseif playerClass == "ROGUE" then MSC.CurrentClass = Rogue
		elseif playerClass == "WARRIOR" then MSC.CurrentClass = Warrior
		elseif playerClass == "WARLOCK" then MSC.CurrentClass = Warlock
        end
        
        -- WIPE THE CACHE: The old class weights are now invalid
        MSC.CachedWeights = nil
        MSC.CachedProfile = nil
		end
    local status, err = pcall(function()
        local weights, specName = MSC.GetCurrentWeights()
        if not weights or not next(weights) then return end

        local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
        local slotId = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
        if not slotId then return end

        local newScore, oldScore, newStats, oldStats, newTotalColors = MSC:EvaluateUpgrade(link, slotId, weights, specName)
        
        local delta = newScore - oldScore
        local isEquipped = (GetInventoryItemLink("player", slotId) == link)

        local displayName = specName
        if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[specName] then
            displayName = MSC.CurrentClass.PrettyNames[specName]
        end
        
        local _, _, capInfo = MSC.GetCurrentWeights()
        local verdictDisplay = displayName
        
        if capInfo then
            verdictDisplay = verdictDisplay .. " |cff00ff00(" .. capInfo .. " Capped)|r"
        end

        tooltip:AddLine(" ")
        
        -- [[ UPDATED SECTION START: SCORE & CONTEXT ]]
        local scoreLabel = "Judge's Score:"
        
        -- Check for context message (e.g. "w/ [Gorehowl]") passed from Evaluator
        if newStats.Context then
            scoreLabel = scoreLabel .. " " .. newStats.Context
        end
        
        tooltip:AddDoubleLine(scoreLabel, string.format("|cffffffff%.1f|r", newScore), 1, 0.82, 0)
        -- [[ UPDATED SECTION END ]]
        
        tooltip:AddDoubleLine("Sharpie's Verdict:", "|cff00ccff" .. verdictDisplay .. "|r", 1, 0.82, 0)
        
        if isEquipped then
            tooltip:AddLine("|cff00ffff*** CURRENTLY EQUIPPED ***|r")
        else
            if equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET" then
                local comparedItemLink = GetInventoryItemLink("player", slotId)
                if comparedItemLink then
                    tooltip:AddDoubleLine("vs.", comparedItemLink, 0.6, 0.6, 0.6, 1, 1, 1)
                else
                    tooltip:AddDoubleLine("vs.", "(Empty Slot)", 0.6, 0.6, 0.6, 0.5, 0.5, 0.5)
                end
            end

            if delta > 0.1 then 
                tooltip:AddLine("|cff00ff00" .. TEX_UP .. " Upgrade (+" .. string.format("%.1f", delta) .. ")|r")
            elseif delta < -0.1 then 
                tooltip:AddLine("|cffff0000" .. TEX_DOWN .. " Downgrade (" .. string.format("%.1f", delta) .. ")|r")
            else 
                tooltip:AddLine("|cff888888= Sidegrade (0.0)|r") 
            end
        end

        if newStats.IS_PROJECTED or newStats.GEMS_PROJECTED then 
            tooltip:AddLine(" ")
            if newStats.ENCHANT_TEXT then
                 tooltip:AddDoubleLine("Projected Enchant:", "|cffffffff" .. newStats.ENCHANT_TEXT .. "|r", 0, 1, 1)
            elseif newStats.IS_PROJECTED then
                 tooltip:AddDoubleLine("Projected Enchant:", "|cffffffffBest Available|r", 0, 1, 1)
            end
            if newStats.GEM_TEXT then
                 tooltip:AddDoubleLine("Projected Gems:", "|cffffffff" .. newStats.GEM_TEXT .. "|r", 0, 1, 1)
            end
            if newStats.BONUS_PROJECTED then
                 tooltip:AddLine("   + Socket Bonus Activated", 0, 1, 0)
            end
            
            if newStats.META_ID and MSC.CheckMetaRequirements and newTotalColors then
                local isActive = MSC:CheckMetaRequirements(newStats.META_ID, newTotalColors)
                if isActive then
                    tooltip:AddLine("   + Meta Gem Active", 0, 1, 0)
                else
                    tooltip:AddLine("   - Meta Gem Inactive (Reqs unmet)", 1, 0, 0)
                end
            end
        end

        if not isEquipped then
            local newExpanded = MSC.ExpandDerivedStats(newStats, link, Scratch_Tooltip_New)
            local oldExpanded = MSC.ExpandDerivedStats(oldStats or {}, nil, Scratch_Tooltip_Old) 
            local diffs = MSC.GetStatDifferences(newExpanded, oldExpanded, Scratch_Tooltip_Diffs)
            
            local gains, losses = {}, {}
            
            for _, d in ipairs(diffs) do
                local isRelevant = (weights[d.key] and weights[d.key] > 0) or 
                                   (d.key == "ITEM_MOD_HEALTH_SHORT") or 
                                   (d.key == "ITEM_MOD_MANA_SHORT") or 
                                   (d.key == "ITEM_MOD_ATTACK_POWER_SHORT")
                if isRelevant then
                    if d.val > 0.1 then table.insert(gains, d)
                    elseif d.val < -0.1 then table.insert(losses, d) end
                end
            end
            
            local function StableSort(a, b)
                local wA = (weights[a.key] or 0)
                local wB = (weights[b.key] or 0)
                if wA == wB then return a.key < b.key end
                return wA > wB
            end

            table.sort(gains, StableSort)
            table.sort(losses, StableSort)
            
            if #gains > 0 then
                tooltip:AddLine("Gains:", 0, 1, 0)
                for _, g in ipairs(gains) do
                    local name = GetCleanStatName(g.key, newExpanded)
                    local valStr = (g.val % 1 == 0) and string.format("+%d", g.val) or string.format("+%.1f", g.val)
                    tooltip:AddDoubleLine("  " .. name, valStr, 1, 1, 1, 0, 1, 0)
                end
            end
            
            if #losses > 0 then
                tooltip:AddLine("Losses:", 1, 0, 0)
                for _, l in ipairs(losses) do
                    local name = GetCleanStatName(l.key, oldExpanded)
                    local valStr = (l.val % 1 == 0) and string.format("%d", l.val) or string.format("%.1f", l.val)
                    tooltip:AddDoubleLine("  " .. name, valStr, 1, 1, 1, 1, 0, 0)
                end
            end
        end
        
        tooltip:Show()
    end)

    MSC.IsCalculating = false
    
    if not status then geterrorhandler()(err) end
end

GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ShoppingTooltip1:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ShoppingTooltip2:HookScript("OnTooltipSetItem", OnTooltipSetItem)