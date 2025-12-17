local _, MSC = ... 

-- =============================================================
-- 1. INITIALIZATION & CONFLICT MANAGER
-- =============================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "SharpiesGearJudge" then
        if not SGJ_Settings then SGJ_Settings = { Mode = "Auto", MinimapPos = 45, IncludeEnchants = false, ProjectEnchants = true } end
        if MSC.UpdateMinimapPosition then MSC.UpdateMinimapPosition() end
        print("|cff00ccffSharpie's Gear Judge|r loaded! Type |cff00ff00/sgj|r to open the lab.")
    end
end)

StaticPopupDialogs["SGJ_DISABLE_RXP_GEAR"] = {
    text = "|cff00FF00Sharpie's Gear Judge|r\n\nI see RestedXP is active.\n\nIt is currently showing its own gear tips.\n\nDo you want me to disable their **Item Upgrade** setting?",
    button1 = "Yes, Disable & Reload", button2 = "No, Keep Both",
    OnAccept = function()
        local myKey = UnitName("player") .. " - " .. GetRealmName()
        if RXPSettings and RXPSettings.profileKeys then
            local profileName = RXPSettings.profileKeys[myKey]
            if profileName and RXPSettings.profiles and RXPSettings.profiles[profileName] then
                RXPSettings.profiles[profileName].enableItemUpgrades = false; ReloadUI()
            end
        end
    end, timeout = 0, whileDead = true, hideOnEscape = false, preferredIndex = 3,
}

StaticPopupDialogs["SGJ_DISABLE_ZYGOR_GEAR"] = {
    text = "|cff00FF00Sharpie's Gear Judge|r\n\nI see Zygor Guides is active.\n\nIt adds its own 'Gear Score' to tooltips.\n\nDo you want me to disable their **Auto Gear** system?",
    button1 = "Yes, Disable & Reload", button2 = "No, Keep Both",
    OnAccept = function()
        local Zygor = ZGV or ZygorGuidesViewer
        if Zygor and Zygor.db and Zygor.db.profile then
            Zygor.db.profile.autogear = false; Zygor.db.profile.itemscore_tooltips = false; ReloadUI()
        end
    end, timeout = 0, whileDead = true, hideOnEscape = false, preferredIndex = 3,
}

StaticPopupDialogs["SGJ_DISABLE_PAWN_TIPS"] = {
    text = "|cff00FF00Sharpie's Gear Judge|r\n\nI see Pawn is active.\n\nFor conflict-free use, we recommend disabling **Pawn's Tooltip Upgrades** so they don't overlap with our Verdict.\n\nDisable Pawn tooltip info?",
    button1 = "Yes, Disable & Reload", button2 = "No, Keep Both",
    OnAccept = function()
        if PawnCommon then PawnCommon.ShowUpgradesOnTooltips = false; ReloadUI() else print("|cff00FF00[SGJ]|r: Pawn settings not found yet.") end
    end, timeout = 0, whileDead = true, hideOnEscape = false, preferredIndex = 3,
}

local function CheckForConflicts()
    if C_AddOns.IsAddOnLoaded("RestedXP") or C_AddOns.IsAddOnLoaded("RXPGuides") then
        if RXPSettings and RXPSettings.profileKeys then
            local myKey = UnitName("player") .. " - " .. GetRealmName()
            local profileName = RXPSettings.profileKeys[myKey]
            if profileName and RXPSettings.profiles[profileName] and RXPSettings.profiles[profileName].enableItemUpgrades ~= false then
                StaticPopup_Show("SGJ_DISABLE_RXP_GEAR"); return
            end
        end
    end
    local Zygor = ZGV or ZygorGuidesViewer
    if Zygor and Zygor.db and Zygor.db.profile and (Zygor.db.profile.autogear ~= false or Zygor.db.profile.itemscore_tooltips ~= false) then
         StaticPopup_Show("SGJ_DISABLE_ZYGOR_GEAR"); return
    end
    if C_AddOns.IsAddOnLoaded("Pawn") and PawnCommon and PawnCommon.ShowUpgradesOnTooltips ~= false then
        StaticPopup_Show("SGJ_DISABLE_PAWN_TIPS")
    end
end

local loginFrame = CreateFrame("Frame")
loginFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
loginFrame:SetScript("OnEvent", function(self, event) C_Timer.After(4, CheckForConflicts); self:UnregisterEvent("PLAYER_ENTERING_WORLD") end)

-- =============================================================
-- 2. SLASH COMMANDS
-- =============================================================
SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg) 
    msg = msg:lower()
    if msg == "options" or msg == "config" then 
        MSC.CreateOptionsFrame() 
    elseif msg == "debug" then
        local w, n = MSC.GetCurrentWeights()
        print("|cff00ccff[SGJ Debug]|r Active Profile: " .. n)
        print("|cff00ccff[SGJ Debug]|r Player Level: " .. UnitLevel("player"))
        if w then
            for k,v in pairs(w) do 
                if v > 0 then print("   " .. (MSC.GetCleanStatName(k) or k) .. ": " .. v) end
            end
        end
    else 
        MSC.CreateLabFrame() 
    end 
end

-- =============================================================
-- 3. TOOLTIP & DERIVED STATS ENGINE
-- =============================================================
local SlotMap = { ["INVTYPE_HEAD"]=1, ["INVTYPE_NECK"]=2, ["INVTYPE_SHOULDER"]=3, ["INVTYPE_BODY"]=4, ["INVTYPE_CHEST"]=5, ["INVTYPE_ROBE"]=5, ["INVTYPE_WAIST"]=6, ["INVTYPE_LEGS"]=7, ["INVTYPE_FEET"]=8, ["INVTYPE_WRIST"]=9, ["INVTYPE_HAND"]=10, ["INVTYPE_FINGER"]=11, ["INVTYPE_TRINKET"]=13, ["INVTYPE_CLOAK"]=15, ["INVTYPE_WEAPON"]=16, ["INVTYPE_SHIELD"]=17, ["INVTYPE_2HWEAPON"]=16, ["INVTYPE_WEAPONMAINHAND"]=16, ["INVTYPE_WEAPONOFFHAND"]=17, ["INVTYPE_HOLDABLE"]=17, ["INVTYPE_RANGED"]=18, ["INVTYPE_THROWN"]=18, ["INVTYPE_RANGEDRIGHT"]=18, ["INVTYPE_RELIC"]=18 }

local function MergeStats(t1, t2)
    local out = {}
    if t1 then for k,v in pairs(t1) do out[k] = v end end
    if t2 then for k,v in pairs(t2) do out[k] = (out[k] or 0) + v end end
    return out
end

-- SMART DERIVED STATS (Filter by Class)
local function ExpandDerivedStats(stats)
    if not stats then return {} end
    local out = {}
    for k, v in pairs(stats) do out[k] = v end
    local _, class = UnitClass("player")
    local powerType = UnitPowerType("player") 
    if out["ITEM_MOD_STAMINA_SHORT"] then out["ITEM_MOD_HEALTH_SHORT"] = (out["ITEM_MOD_HEALTH_SHORT"] or 0) + (out["ITEM_MOD_STAMINA_SHORT"] * 10) end
    if powerType == 0 and out["ITEM_MOD_INTELLECT_SHORT"] then out["ITEM_MOD_MANA_SHORT"] = (out["ITEM_MOD_MANA_SHORT"] or 0) + (out["ITEM_MOD_INTELLECT_SHORT"] * 15) end
    local isPhysical = (class == "WARRIOR" or class == "PALADIN" or class == "SHAMAN" or class == "DRUID" or class == "HUNTER" or class == "ROGUE")
    if isPhysical then
        local str, agi, ap = out["ITEM_MOD_STRENGTH_SHORT"] or 0, out["ITEM_MOD_AGILITY_SHORT"] or 0, out["ITEM_MOD_ATTACK_POWER_SHORT"] or 0
        if class == "HUNTER" or class == "ROGUE" then ap = ap + str + agi else ap = ap + (str * 2) end
        if ap > 0 then out["ITEM_MOD_ATTACK_POWER_SHORT"] = ap end
    end
    if class == "HUNTER" then
        local rap, agi = out["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] or 0, out["ITEM_MOD_AGILITY_SHORT"] or 0
        rap = rap + (agi * 2); if rap > 0 then out["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = rap end
    end
    return out
end

GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
    if SGJ_Settings.HideTooltips then return end 

    local _, link = tooltip:GetItem()
    if not link then return end
    if not MSC.IsItemUsable(link) then tooltip:AddLine(" "); tooltip:AddLine("|cffff0000Sharpie's Verdict: ITEM UNUSABLE|r"); tooltip:Show(); return end

    local itemEquipLoc = select(9, GetItemInfo(link))
    local slotId = SlotMap[itemEquipLoc]
    if not slotId then return end
    
    local currentWeights, specName = MSC.GetCurrentWeights()
    local equippedMH = GetInventoryItemLink("player", 16)
    local equippedOH = GetInventoryItemLink("player", 17)
    local equippedMHLoc = equippedMH and select(9, GetItemInfo(equippedMH))
    
    local oldScore, newScore = 0, 0
    local oldStats, newStats = {}, {}
    local noteText = nil
    local isBestInBag, isEquipped = false, false

    -- =============================================================
    -- COMPARISON CASES
    -- =============================================================

    -- CASE A: New item is 2H. Compare vs "Best Dual Wield Set"
    if itemEquipLoc == "INVTYPE_2HWEAPON" then
        newStats = MSC.SafeGetItemStats(link, 16); newScore = MSC.GetItemScore(newStats, currentWeights)
        local mhLink, ohLink = equippedMH, equippedOH
        local filledFromBag = false
        if equippedMHLoc ~= "INVTYPE_2HWEAPON" then
            if not mhLink then mhLink = MSC.FindBestMainHand(currentWeights); filledFromBag = true end
            if not ohLink then ohLink = MSC.FindBestOffhand(currentWeights); filledFromBag = true end
        end
        local mhStats = MSC.SafeGetItemStats(mhLink, 16); local ohStats = MSC.SafeGetItemStats(ohLink, 17)
        oldStats = MergeStats(mhStats, ohStats); oldScore = MSC.GetItemScore(mhStats, currentWeights) + MSC.GetItemScore(ohStats, currentWeights)
        if filledFromBag or (equippedMHLoc ~= "INVTYPE_2HWEAPON" and equippedOH) then noteText = "Comparing vs: " .. (mhLink or "Empty") .. " + " .. (ohLink or "Empty") end
        if link == equippedMH then isEquipped = true end

    -- CASE B: New item is 1H/MH, we have 2H equipped.
    elseif (itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestOHLink, bestOHScore, bestOHStats = MSC.FindBestOffhand(currentWeights)
        local mhStats = MSC.SafeGetItemStats(link, 16); local mhScore = MSC.GetItemScore(mhStats, currentWeights)
        if bestOHLink then
            newStats = MergeStats(mhStats, bestOHStats); newScore = mhScore + bestOHScore; noteText = "Paired with: " .. bestOHLink
        else
            newStats = mhStats; newScore = mhScore; noteText = "|cffff0000(No Offhand found)|r"
        end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16); oldScore = MSC.GetItemScore(oldStats, currentWeights)

    -- CASE C: New item is OH/Shield, we have 2H equipped.
    elseif (itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestMHLink, bestMHScore, bestMHStats = MSC.FindBestMainHand(currentWeights)
        local ohStats = MSC.SafeGetItemStats(link, 17); local ohScore = MSC.GetItemScore(ohStats, currentWeights)
        if bestMHLink then
            newStats = MergeStats(bestMHStats, ohStats); newScore = bestMHScore + ohScore; noteText = "Paired with: " .. bestMHLink
        else
            newStats = ohStats; newScore = ohScore; noteText = "|cffff0000(No Mainhand found)|r"
        end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16); oldScore = MSC.GetItemScore(oldStats, currentWeights)

    -- CASE D: RINGS & TRINKETS (Compare against Weakest Slot)
    elseif itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" then
        local s1, s2 = 11, 12
        if itemEquipLoc == "INVTYPE_TRINKET" then s1, s2 = 13, 14 end
        
        local l1, l2 = GetInventoryItemLink("player", s1), GetInventoryItemLink("player", s2)
        local st1, st2 = MSC.SafeGetItemStats(l1, s1), MSC.SafeGetItemStats(l2, s2)
        local sc1, sc2 = MSC.GetItemScore(st1, currentWeights), MSC.GetItemScore(st2, currentWeights)
        
        local targetSlot, targetLink = s1, l1
        if (not l1) then targetSlot = s1; targetLink = nil
        elseif (not l2) then targetSlot = s2; targetLink = nil
        elseif sc2 < sc1 then targetSlot = s2; targetLink = l2
        else targetSlot = s1; targetLink = l1 end
        
        if link == l1 then isEquipped = true; targetSlot = s1; targetLink = l1 
        elseif link == l2 then isEquipped = true; targetSlot = s2; targetLink = l2 end

        if not targetLink and not isEquipped then 
            tooltip:AddLine(" "); tooltip:AddLine("|cff00ff00++ NEW ITEM (Slot Empty)|r"); tooltip:Show(); return 
        end
        
        oldStats = MSC.SafeGetItemStats(targetLink, targetSlot); oldScore = MSC.GetItemScore(oldStats, currentWeights)
        newStats = MSC.SafeGetItemStats(link, targetSlot); newScore = MSC.GetItemScore(newStats, currentWeights)
        if not isEquipped then noteText = "Comparing vs: " .. (targetLink or "Empty") .. " (Weakest)" end

    -- CASE E: Standard Comparison
    else
        local compLink = GetInventoryItemLink("player", slotId)
        if link == compLink then isEquipped = true end
        if not compLink then
             -- Try to find bag item if slot is empty (e.g. main hand)
            if slotId == 17 then 
                local bag = MSC.FindBestOffhand(currentWeights)
                if bag then compLink = bag; noteText = "Comparing vs: " .. compLink; if link == bag then isBestInBag = true end end
            elseif slotId == 16 then 
                local bag = MSC.FindBestMainHand(currentWeights)
                if bag then compLink = bag; noteText = "Comparing vs: " .. compLink; if link == bag then isBestInBag = true end end 
            end
        end
        if not compLink then tooltip:AddLine(" "); tooltip:AddLine("|cff00ff00++ NEW ITEM (Slot Empty)|r"); tooltip:Show(); return end
        oldStats = MSC.SafeGetItemStats(compLink, slotId); oldScore = MSC.GetItemScore(oldStats, currentWeights)
        newStats = MSC.SafeGetItemStats(link, slotId); newScore = MSC.GetItemScore(newStats, currentWeights)
    end

    -- =============================================================
    -- RENDER UI
    -- =============================================================
    local scoreDiff = newScore - oldScore
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine("|cff00ccffSharpie's Verdict:|r", "|cffffffff" .. specName .. "|r")
    if noteText and not isBestInBag then tooltip:AddLine(noteText, 0.7, 0.7, 0.7) end
    if newStats.IS_PROJECTED then local enchantText = MSC.GetEnchantString(slotId); if enchantText and enchantText ~= "" then tooltip:AddLine("(Projecting: " .. enchantText .. ")", 0, 1, 1) end end

    local scoreVal = ""
    if isEquipped then tooltip:AddLine("|cff00ffff(Currently Equipped)|r")
    elseif isBestInBag then tooltip:AddLine("|cff00ff00(Best in Bag)|r")
    elseif scoreDiff > 0 then scoreVal = "+" .. string.format("%.1f", scoreDiff); tooltip:AddDoubleLine("Total Score", scoreVal, 1, 0.82, 0, 0, 1, 0)
    elseif scoreDiff < 0 then scoreVal = string.format("%.1f", scoreDiff); tooltip:AddDoubleLine("Total Score", scoreVal, 1, 0.82, 0, 1, 0, 0)
    else tooltip:AddDoubleLine("Total Score", "0.0", 1, 0.82, 0, 0.7, 0.7, 0.7) end

    local oldExpanded = ExpandDerivedStats(oldStats)
    local newExpanded = ExpandDerivedStats(newStats)
    local diffs = MSC.GetStatDifferences(newExpanded, oldExpanded)
    local sortedDiffs = MSC.SortStatDiffs(diffs)
    
    for _, entry in ipairs(sortedDiffs) do
        if entry.key ~= "IS_PROJECTED" then
            local isRelevant = (currentWeights and currentWeights[entry.key] and currentWeights[entry.key] > 0)
            if entry.key == "ITEM_MOD_HEALTH_SHORT" or entry.key == "ITEM_MOD_MANA_SHORT" or entry.key == "ITEM_MOD_ATTACK_POWER_SHORT" or entry.key == "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" then isRelevant = true end

            if isRelevant then
                local cleanName = MSC.GetCleanStatName(entry.key)
                if cleanName and cleanName ~= "" then
                    local newVal = newExpanded[entry.key] or 0
                    local diffVal = entry.val
                    local newStr = (newVal % 1 == 0) and string.format("%d", newVal) or string.format("%.1f", newVal)
                    local diffStr = (diffVal % 1 == 0) and string.format("%d", diffVal) or string.format("%.1f", diffVal)
                    if diffVal > 0 then diffStr = "+" .. diffStr end
                    local rightText = ""
                    if diffVal > 0 then rightText = "|cffffffff" .. newStr .. "|r |cff00ff00(" .. diffStr .. ")|r"; tooltip:AddDoubleLine(cleanName, rightText, 1, 0.82, 0) 
                    elseif diffVal < 0 then rightText = "|cffffffff" .. newStr .. "|r |cffff0000(" .. diffStr .. ")|r"; tooltip:AddDoubleLine(cleanName, rightText, 1, 0.82, 0) end
                end
            end
        end
    end
    tooltip:Show()
end)