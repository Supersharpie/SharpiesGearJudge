local _, MSC = ... 

-- 1. INITIALIZATION
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "SharpiesGearJudge" then
        if not SGJ_Settings then SGJ_Settings = { Mode = "Auto", MinimapPos = 45, IncludeEnchants = false, ProjectEnchants = true } end
        if MSC.UpdateMinimapPosition then MSC.UpdateMinimapPosition() end
        print("|cff00ccffSharpie's Gear Judge|r loaded! Type |cff00ff00/sgj|r to open the lab.")
    end
end)

-- 2. SLASH COMMANDS
SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg) 
    if msg == "options" or msg == "config" then MSC.CreateOptionsFrame() else MSC.CreateLabFrame() end 
end

-- 3. TOOLTIP LOGIC
local SlotMap = { ["INVTYPE_HEAD"]=1, ["INVTYPE_NECK"]=2, ["INVTYPE_SHOULDER"]=3, ["INVTYPE_BODY"]=4, ["INVTYPE_CHEST"]=5, ["INVTYPE_ROBE"]=5, ["INVTYPE_WAIST"]=6, ["INVTYPE_LEGS"]=7, ["INVTYPE_FEET"]=8, ["INVTYPE_WRIST"]=9, ["INVTYPE_HAND"]=10, ["INVTYPE_FINGER"]=11, ["INVTYPE_TRINKET"]=13, ["INVTYPE_CLOAK"]=15, ["INVTYPE_WEAPON"]=16, ["INVTYPE_SHIELD"]=17, ["INVTYPE_2HWEAPON"]=16, ["INVTYPE_WEAPONMAINHAND"]=16, ["INVTYPE_WEAPONOFFHAND"]=17, ["INVTYPE_HOLDABLE"]=17, ["INVTYPE_RANGED"]=18, ["INVTYPE_THROWN"]=18, ["INVTYPE_RANGEDRIGHT"]=18, ["INVTYPE_RELIC"]=18 }

local function MergeStats(t1, t2)
    local out = {}
    if t1 then for k,v in pairs(t1) do out[k] = v end end
    if t2 then for k,v in pairs(t2) do out[k] = (out[k] or 0) + v end end
    return out
end

GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
    if SGJ_Settings.HideTooltips then return end 

    local _, link = tooltip:GetItem()
    if not link then return end
    
    if not MSC.IsItemUsable(link) then
        tooltip:AddLine(" ")
        tooltip:AddLine("|cffff0000Sharpie's Verdict: ITEM UNUSABLE|r")
        tooltip:Show()
        return 
    end

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
    
    local isBestInBag = false 
    local isEquipped = false

    -- LOGIC BRANCH: SMART WEAPON PAIRING

    -- CASE A: New item is 2H. Compare vs "Best Dual Wield Set"
    if itemEquipLoc == "INVTYPE_2HWEAPON" then
        newStats = MSC.SafeGetItemStats(link, 16)
        newScore = MSC.GetItemScore(newStats, currentWeights)
        
        local mhLink, ohLink = equippedMH, equippedOH
        local filledFromBag = false
        
        if equippedMHLoc ~= "INVTYPE_2HWEAPON" then
            if not mhLink then mhLink = MSC.FindBestMainHand(currentWeights); filledFromBag = true end
            if not ohLink then ohLink = MSC.FindBestOffhand(currentWeights); filledFromBag = true end
        end

        local mhStats = MSC.SafeGetItemStats(mhLink, 16)
        local ohStats = MSC.SafeGetItemStats(ohLink, 17)
        oldStats = MergeStats(mhStats, ohStats)
        oldScore = MSC.GetItemScore(mhStats, currentWeights) + MSC.GetItemScore(ohStats, currentWeights)
        
        if filledFromBag or (equippedMHLoc ~= "INVTYPE_2HWEAPON" and equippedOH) then 
            -- FIXED: Explicitly name the items being compared against
            local mName = mhLink or "Empty"
            local oName = ohLink or "Empty"
            noteText = "Comparing vs: " .. mName .. " + " .. oName
        end
        
        if link == equippedMH then isEquipped = true end

    -- CASE B: New item is 1H/MH, we have 2H equipped.
    elseif (itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestOHLink, bestOHScore, bestOHStats = MSC.FindBestOffhand(currentWeights)
        local mhStats = MSC.SafeGetItemStats(link, 16)
        local mhScore = MSC.GetItemScore(mhStats, currentWeights)
        
        if bestOHLink then
            newStats = MergeStats(mhStats, bestOHStats)
            newScore = mhScore + bestOHScore
            noteText = "Paired with: " .. bestOHLink
        else
            newStats = mhStats; newScore = mhScore
            noteText = "|cffff0000(No Offhand found in bags)|r"
        end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16)
        oldScore = MSC.GetItemScore(oldStats, currentWeights)

    -- CASE C: New item is OH/Shield, we have 2H equipped.
    elseif (itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestMHLink, bestMHScore, bestMHStats = MSC.FindBestMainHand(currentWeights)
        local ohStats = MSC.SafeGetItemStats(link, 17)
        local ohScore = MSC.GetItemScore(ohStats, currentWeights)
        
        if bestMHLink then
            newStats = MergeStats(bestMHStats, ohStats)
            newScore = bestMHScore + ohScore
            noteText = "Paired with: " .. bestMHLink
        else
            newStats = ohStats; newScore = ohScore
            noteText = "|cffff0000(No Mainhand found in bags)|r"
        end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16)
        oldScore = MSC.GetItemScore(oldStats, currentWeights)

    -- CASE D: Standard Comparison (Empty Slot Logic)
    else
        local compLink = GetInventoryItemLink("player", slotId)
        
        if link == compLink then isEquipped = true end

        if not compLink then
            if slotId == 17 then 
                local bag = MSC.FindBestOffhand(currentWeights)
                if bag then 
                    compLink = bag
                    noteText = "Comparing vs: " .. compLink 
                    if link == bag then isBestInBag = true end 
                end
            elseif slotId == 16 then 
                local bag = MSC.FindBestMainHand(currentWeights)
                if bag then 
                    compLink = bag
                    noteText = "Comparing vs: " .. compLink 
                    if link == bag then isBestInBag = true end 
                end
            end
        end

        if not compLink then tooltip:AddLine(" "); tooltip:AddLine("|cff00ff00++ NEW ITEM (Slot Empty)|r"); tooltip:Show(); return end
        
        oldStats = MSC.SafeGetItemStats(compLink, slotId)
        oldScore = MSC.GetItemScore(oldStats, currentWeights)
        newStats = MSC.SafeGetItemStats(link, slotId)
        newScore = MSC.GetItemScore(newStats, currentWeights)
    end
    
    -- RENDER
    local scoreDiff = newScore - oldScore
    tooltip:AddLine(" ")
    tooltip:AddLine("|cff00ccffSharpie's Verdict: " .. specName .. "|r")
    
    -- Show "Paired With" / "Comparing Vs" text (unless it's the Best in Bag, where we use a special label below)
    if noteText and not isBestInBag then tooltip:AddLine("|cffffffff" .. noteText .. "|r") end
    
    if newStats.IS_PROJECTED then
        local enchantText = MSC.GetEnchantString(slotId)
        if enchantText and enchantText ~= "" then tooltip:AddLine("|cff00ffff(Projecting: " .. enchantText .. ")|r") end
    end

    -- FIND PARTNER LINK (For Best/Equipped display)
    local partnerLink = nil
    if slotId == 16 then 
        partnerLink = GetInventoryItemLink("player", 17) or MSC.FindBestOffhand(currentWeights)
    elseif slotId == 17 then 
        partnerLink = GetInventoryItemLink("player", 16) or MSC.FindBestMainHand(currentWeights)
    end

    if isEquipped then
        if partnerLink then
            tooltip:AddLine("|cff00ffff*** EQUIPPED WITH: " .. partnerLink .. " ***|r")
        else
            tooltip:AddLine("|cff00ffff*** CURRENTLY EQUIPPED ***|r")
        end
    elseif isBestInBag then
        if partnerLink then
            tooltip:AddLine("|cff00ff00*** BEST PAIR WITH: " .. partnerLink .. " ***|r")
        else
            tooltip:AddLine("|cff00ff00*** CURRENT BEST ***|r")
        end
    elseif scoreDiff > 0 then 
        tooltip:AddLine("|cff00ff00*** UPGRADE (+" .. string.format("%.1f", scoreDiff) .. ") ***|r")
    elseif scoreDiff < 0 then 
        tooltip:AddLine("|cffff0000*** DOWNGRADE (" .. string.format("%.1f", scoreDiff) .. ") ***|r")
    else 
        tooltip:AddLine("|cffffffff*** EQUAL STATS ***|r") 
    end
    
    local diffs = MSC.GetStatDifferences(newStats, oldStats)
    local sortedDiffs = MSC.SortStatDiffs(diffs)
    for _, entry in ipairs(sortedDiffs) do
        if entry.key ~= "IS_PROJECTED" then
            local cleanName = MSC.GetCleanStatName(entry.key)
            if cleanName and cleanName ~= "" then
                local valStr = (entry.val % 1 == 0) and string.format("%d", entry.val) or string.format("%.1f", entry.val)
                if entry.val > 0 then tooltip:AddDoubleLine("^ +"..valStr.." "..cleanName, "", 0, 1, 0)
                else tooltip:AddDoubleLine("v "..valStr.." "..cleanName, "", 1, 0, 0) end
            end
        end
    end
    tooltip:Show()
end)