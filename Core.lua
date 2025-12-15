local _, MSC = ... 

-- 1. INITIALIZATION EVENT
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

GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
    local name, link = tooltip:GetItem()
    if not link then return end
    local itemEquipLoc = select(9, GetItemInfo(link))
    local slotId = SlotMap[itemEquipLoc]
    if not slotId then return end
    
    local compareSlotId = slotId
    local equippedMainHand = GetInventoryItemLink("player", 16)
    local equippedMHLoc = equippedMainHand and select(9, GetItemInfo(equippedMainHand))
    
    if (itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then compareSlotId = 16 end
    
    local equippedLink = GetInventoryItemLink("player", compareSlotId)
    local isBagComparison = false
    local currentWeights, specName = MSC.GetCurrentWeights()
    
    if not equippedLink then
        if slotId == 17 then local bagLink = MSC.FindBestOffhand(currentWeights); if bagLink then equippedLink = bagLink; isBagComparison = true end
        elseif slotId == 16 then local bagLink = MSC.FindBestMainHand(currentWeights); if bagLink then equippedLink = bagLink; isBagComparison = true end end
    end
    
    if not equippedLink then tooltip:AddLine(" "); tooltip:AddLine("|cff00ff00++ NEW ITEM (Slot Empty)|r"); return end
    
    -- PASSING slotID to SafeGetItemStats for Enchant Projection
    local newStats = MSC.SafeGetItemStats(link, compareSlotId)
    local newScore = MSC.GetItemScore(newStats, currentWeights)
    local oldStats = MSC.SafeGetItemStats(equippedLink, compareSlotId)
    local oldScore = MSC.GetItemScore(oldStats, currentWeights)
    local pairedItem = nil
    
    if itemEquipLoc == "INVTYPE_2HWEAPON" then
        local offHandLink = GetInventoryItemLink("player", 17)
        if offHandLink then
            local offHandStats = MSC.SafeGetItemStats(offHandLink, 17)
            oldScore = oldScore + MSC.GetItemScore(offHandStats, currentWeights)
            for k, v in pairs(offHandStats) do oldStats[k] = (oldStats[k] or 0) + v end
        end
    elseif (itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bagLink, bagScore, bagStats = MSC.FindBestOffhand(currentWeights)
        if bagLink then newScore = newScore + bagScore; for k, v in pairs(bagStats) do newStats[k] = (newStats[k] or 0) + v end; pairedItem = bagLink end
    end

    local scoreDiff = newScore - oldScore
    tooltip:AddLine(" ")
    tooltip:AddLine("|cff00ccffSharpie's Verdict: " .. specName .. "|r")
    if isBagComparison then tooltip:AddLine("|cffffffffComparing vs Bag Item: " .. equippedLink .. "|r") end
    if pairedItem then tooltip:AddLine("|cffffffff+ Paired with: " .. pairedItem .. "|r") end

    if scoreDiff > 0 then tooltip:AddLine("|cff00ff00*** UPGRADE (+" .. string.format("%.1f", scoreDiff) .. ") ***|r")
    elseif scoreDiff < 0 then tooltip:AddLine("|cffff0000*** DOWNGRADE (" .. string.format("%.1f", scoreDiff) .. ") ***|r")
    else tooltip:AddLine("|cffffffff*** No Change ***|r") end
    
    local diffs = MSC.GetStatDifferences(newStats, oldStats)
    local sortedDiffs = MSC.SortStatDiffs(diffs)
    for _, entry in ipairs(sortedDiffs) do
        local cleanName = MSC.GetCleanStatName(entry.key)
        local valStr = (entry.val % 1 == 0) and string.format("%d", entry.val) or string.format("%.1f", entry.val)
        if entry.val > 0 then tooltip:AddDoubleLine("^ +"..valStr.." "..cleanName, "", 0, 1, 0)
        else tooltip:AddDoubleLine("v "..valStr.." "..cleanName, "", 1, 0, 0) end
    end
    tooltip:Show()
end)