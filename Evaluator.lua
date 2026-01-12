local addonName, MSC = ...

-- =============================================================
-- 0. API WRAPPERS
-- =============================================================
local GetBagSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetBagLink  = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink

-- =============================================================
-- 1. UTILITIES & RECYCLING
-- =============================================================
local Scratch_Gear = {}
local Scratch_Accumulator = {}
local Scratch_SetCounts = {}
local GEAR_SLOTS = { 1, 2, 3, 15, 5, 9, 10, 6, 7, 8, 11, 12, 13, 14, 16, 17, 18 }

function MSC:SafeCopy(orig, dest)
    wipe(dest or {})
    local copy = dest or {}
    if not orig then return copy end
    for k,v in pairs(orig) do copy[k] = v end
    return copy
end

function MSC:GetEquippedGear(outputTable)
    local gear = outputTable or {}
    wipe(gear)
    for _, slotID in ipairs(GEAR_SLOTS) do
        gear[slotID] = GetInventoryItemLink("player", slotID)
    end
    return gear
end

function MSC:GetWeaponSpecBonus(itemLink, class, specName)
    if MSC.CurrentClass and MSC.CurrentClass.GetWeaponBonus then
        return MSC.CurrentClass:GetWeaponBonus(itemLink)
    end
    return 0
end

local function GetIDFromLink(link)
    if not link or type(link) ~= "string" then return 0 end
    return tonumber(link:match("item:(%d+)")) or 0
end

-- =============================================================
-- 2. THE SCORING ENGINE
-- =============================================================
function MSC:GetTotalCharacterScore(gearTable, weights, specName)
    local totalScore = 0
    wipe(Scratch_SetCounts)
    wipe(Scratch_Accumulator)
    
    for slotID, itemLink in pairs(gearTable) do
        if itemLink then
            local stats = MSC.SafeGetItemStats(itemLink, slotID, weights, specName)
            local itemScore = MSC.GetItemScore(stats, weights, specName, slotID)
            totalScore = totalScore + itemScore
            
            for k,v in pairs(stats) do 
                if type(v) == "number" and k ~= "IS_PROJECTED" and k ~= "ENCHANT_TEXT" then 
                    Scratch_Accumulator[k] = (Scratch_Accumulator[k] or 0) + v 
                end
            end
            
            local setID = MSC.GetItemSetID and MSC:GetItemSetID(itemLink)
            if setID then Scratch_SetCounts[setID] = (Scratch_SetCounts[setID] or 0) + 1 end
            
            if stats._AUTO_PROC then
                local p = stats._AUTO_PROC
                Scratch_Accumulator[p.stat] = (Scratch_Accumulator[p.stat] or 0) + p.val
                if weights[p.stat] then totalScore = totalScore + (p.val * weights[p.stat]) end
            end
        end
    end

    if MSC.RawSetData then
        for setID, count in pairs(Scratch_SetCounts) do
             local setData = MSC.RawSetData[setID]
             if setData then
                 for reqCount, bonusData in pairs(setData) do
                     if count >= reqCount then
                         if bonusData.stats then
                             for stat, val in pairs(bonusData.stats) do
                                 Scratch_Accumulator[stat] = (Scratch_Accumulator[stat] or 0) + val
                                 if weights[stat] then totalScore = totalScore + (val * weights[stat]) end
                             end
                         end
                         if bonusData.score then totalScore = totalScore + bonusData.score end
                     end
                 end
             end
        end
    end

    local mh = gearTable[16]; local oh = gearTable[17]
    if mh then totalScore = totalScore + MSC:GetWeaponSpecBonus(mh, MSC.CurrentClass, specName) end
    if oh then totalScore = totalScore + MSC:GetWeaponSpecBonus(oh, MSC.CurrentClass, specName) end

    return totalScore, MSC:SafeCopy(Scratch_Accumulator)
end

-- =============================================================
-- 3. BAG SCANNERS (Updated to Ignore Comparison Item)
-- =============================================================

function MSC:GetBestMainHandInBags(weights, specName, ignoreLink)
    local bestLink = nil
    local bestScore = -1
    local ignoreID = GetIDFromLink(ignoreLink)

    for bag = 0, 4 do
        local numSlots = GetBagSlots(bag) 
        for slot = 1, numSlots do
            local link = GetBagLink(bag, slot)
            if link and type(link) == "string" and GetIDFromLink(link) ~= ignoreID then 
                local success, _, _, _, _, _, _, _, _, loc = pcall(GetItemInfo, link)
                if success and (loc == "INVTYPE_WEAPON" or loc == "INVTYPE_WEAPONMAINHAND") and IsEquippableItem(link) then
                    local stats = MSC.SafeGetItemStats(link, 16, weights, specName)
                    local score = MSC.GetItemScore(stats, weights, specName, 16)
                    if score > bestScore then bestScore = score; bestLink = link end
                end
            end
        end
    end
    return bestLink
end

function MSC:GetBestOffHandInBags(weights, specName, ignoreLink)
    local bestLink = nil
    local bestScore = -1
    local ignoreID = GetIDFromLink(ignoreLink)
    
    local _, class = UnitClass("player")
    local canDualWield = (class == "WARRIOR" or class == "ROGUE" or class == "HUNTER")

    for bag = 0, 4 do
        local numSlots = GetBagSlots(bag)
        for slot = 1, numSlots do
            local link = GetBagLink(bag, slot)
            if link and type(link) == "string" and GetIDFromLink(link) ~= ignoreID then
                local success, _, _, _, _, _, _, _, _, loc = pcall(GetItemInfo, link)
                if success then
                    local isValid = false
                    if loc == "INVTYPE_SHIELD" or loc == "INVTYPE_HOLDABLE" or loc == "INVTYPE_WEAPONOFFHAND" then
                        isValid = true
                    elseif loc == "INVTYPE_WEAPON" and canDualWield then
                        isValid = true
                    end

                    if isValid and IsEquippableItem(link) then
                        local stats = MSC.SafeGetItemStats(link, 17, weights, specName)
                        local score = MSC.GetItemScore(stats, weights, specName, 17)
                        if score > bestScore then bestScore = score; bestLink = link end
                    end
                end
            end
        end
    end
    return bestLink
end

-- =============================================================
-- 4. UPGRADE EVALUATOR
-- =============================================================
function MSC:EvaluateUpgrade(newItemLink, targetSlotID, weights, specName)
    if not newItemLink then return 0, 0, {}, {}, {} end
    if not weights then weights, specName = MSC.GetCurrentWeights() end

    -- 1. SETUP
    MSC:GetEquippedGear(Scratch_Gear)
    local currentScore, currentStats = MSC:GetTotalCharacterScore(Scratch_Gear, weights, specName)

    local originalItem = Scratch_Gear[targetSlotID]
    local originalMH   = Scratch_Gear[16]
    local originalOH   = Scratch_Gear[17]
    
    local pairedItem   = nil
    local pairedSource = nil 
    local contextMsg   = nil

    -- 2. NEW ITEM STATS
    local finalNewStats = MSC.SafeGetItemStats(newItemLink, targetSlotID, weights, specName)
    
    -- 3. OLD ITEM STATS
    local finalOldStats = {}
    local oldItemLink = GetInventoryItemLink("player", targetSlotID)
    if oldItemLink then 
        finalOldStats = MSC.SafeGetItemStats(oldItemLink, targetSlotID, weights, specName) 
        if finalOldStats._AUTO_PROC then
             local p = finalOldStats._AUTO_PROC
             finalOldStats[p.stat] = (finalOldStats[p.stat] or 0) + p.val
        end
    end

    -- 4. SMART WEAPON SWAPPING
    Scratch_Gear[targetSlotID] = newItemLink
    
    local success, _, _, _, _, _, _, _, _, newLoc = pcall(GetItemInfo, newItemLink)
    if not success then newLoc = "" end
    
    local isNew2H = (newLoc == "INVTYPE_2HWEAPON" or newLoc == "INVTYPE_STAFF" or newLoc == "INVTYPE_POLEARM")
    local is2HSpec = (specName and (specName:find("ARMS") or specName:find("RET") or specName:find("2H")))

    if targetSlotID == 16 then
        if isNew2H then
            Scratch_Gear[17] = nil -- 2H clears OH
        else
            -- New 1H Main Hand
            local currentMH = GetInventoryItemLink("player", 16)
            if currentMH then
                local _, _, _, _, _, _, _, _, currLoc = GetItemInfo(currentMH)
                local isCurrent2H = (currLoc == "INVTYPE_2HWEAPON" or currLoc == "INVTYPE_STAFF" or currLoc == "INVTYPE_POLEARM")
                
                if isCurrent2H then
                    if is2HSpec then
                        Scratch_Gear[17] = nil 
                        contextMsg = "|cffff0000(No 2H)|r"
                    else
                        local bestBagOH = MSC:GetBestOffHandInBags(weights, specName, newItemLink)
                        if bestBagOH then
                            Scratch_Gear[17] = bestBagOH
                            pairedItem = bestBagOH
                            pairedSource = "Bag"
                        else
                            Scratch_Gear[17] = nil
                            contextMsg = "|cffff0000(No OH found)|r"
                        end
                    end
                else
                    pairedItem = GetInventoryItemLink("player", 17)
                    pairedSource = "Equipped"
                end
            end
        end
    elseif targetSlotID == 17 then
        -- New Offhand
        local currentMH = GetInventoryItemLink("player", 16)
        if currentMH then
            local _, _, _, _, _, _, _, _, currLoc = GetItemInfo(currentMH)
            local isCurrent2H = (currLoc == "INVTYPE_2HWEAPON" or currLoc == "INVTYPE_STAFF" or currLoc == "INVTYPE_POLEARM")
            
            if isCurrent2H then
                local bestBagMH = MSC:GetBestMainHandInBags(weights, specName, newItemLink)
                if bestBagMH then
                    Scratch_Gear[16] = bestBagMH
                    pairedItem = bestBagMH
                    pairedSource = "Bag"
                else
                    Scratch_Gear[16] = nil
                    contextMsg = "|cffff0000(No MH found)|r"
                end
            else
                pairedItem = currentMH
                pairedSource = "Equipped"
            end
        end
    end

    -- 5. CALCULATE
    local newScore, newStatsTotal = MSC:GetTotalCharacterScore(Scratch_Gear, weights, specName)

    -- 6. CAP LOGIC (Simplified)
    local _, playerClass = UnitClass("player")
    local HIT_CAP = (playerClass=="MAGE" or playerClass=="WARLOCK" or playerClass=="PRIEST") and 16 or 9
    local hitStat = (HIT_CAP==16) and "ITEM_MOD_HIT_SPELL_RATING_SHORT" or "ITEM_MOD_HIT_RATING_SHORT"
    if weights[hitStat] and weights[hitStat] > 0 then
        local currentHit = currentStats[hitStat] or 0
        local futureHit  = newStatsTotal[hitStat] or 0
        if currentHit >= HIT_CAP and futureHit < HIT_CAP then
            local deficit = HIT_CAP - futureHit
            newScore = newScore - (deficit * 100)
            contextMsg = (contextMsg or "") .. string.format(" |cffff0000(Under Hit Cap)|r")
        end
    end

    -- 7. FINALIZE
    Scratch_Gear[targetSlotID] = originalItem
    Scratch_Gear[16] = originalMH
    Scratch_Gear[17] = originalOH

    if contextMsg then 
        finalNewStats.Context = (finalNewStats.Context or "") .. " " .. contextMsg 
    end
    
    if pairedItem then
        finalNewStats.PAIRED_ITEM = pairedItem
        finalNewStats.PAIRED_SOURCE = pairedSource
    end

    if finalNewStats._AUTO_PROC then
         local p = finalNewStats._AUTO_PROC
         finalNewStats[p.stat] = (finalNewStats[p.stat] or 0) + p.val
    end

    return newScore, currentScore, finalNewStats, finalOldStats
end