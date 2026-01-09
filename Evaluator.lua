local addonName, MSC = ...

-- =============================================================
-- 0. API COMPATIBILITY WRAPPERS
-- =============================================================
-- Modern WoW (Classic Era/SoD/Cata/Retail) uses C_Container.
-- Old Private Server clients use the Globals.
local GetBagSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetBagLink  = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink

-- =============================================================
-- 1. UTILITIES & RECYCLING BIN
-- =============================================================
local Scratch_Gear = {}
local Scratch_Stats = {}
local Scratch_Accumulator = {}
local Scratch_SetCounts = {}
local Scratch_Colors = { RED = 0, YELLOW = 0, BLUE = 0 }

function MSC:SafeCopy(orig, dest)
    wipe(dest or {})
    local copy = dest or {}
    if not orig then return copy end
    for k,v in pairs(orig) do copy[k] = v end
    return copy
end

function MSC:GetWeaponSpecBonus(itemLink, class, specName)
    if MSC.CurrentClass and MSC.CurrentClass.GetWeaponBonus then
        return MSC.CurrentClass:GetWeaponBonus(itemLink)
    end
    return 0
end

function MSC:CheckMetaRequirements(metaID, counts)
    if not metaID then return false end
    if metaID == 32409 then return (counts.RED >= 2 and counts.BLUE >= 2 and counts.YELLOW >= 2) -- Relentless
    elseif metaID == 34220 then return (counts.BLUE >= 2) -- Chaotic
    elseif metaID == 25893 then return (counts.BLUE > counts.YELLOW) -- Mystical
    elseif metaID == 25896 or metaID == 25899 then return (counts.BLUE >= 3) -- Powerful/Brutal
    end
    return true
end

-- Talent Cache (Lazy Load)
MSC.TalentCache = {}
function MSC:BuildTalentCache()
    MSC.TalentCache = {}
    for tab = 1, GetNumTalentTabs() do
        for i = 1, GetNumTalents(tab) do
            local name, _, _, _, rank = GetTalentInfo(tab, i)
            if name then MSC.TalentCache[name] = rank end
        end
    end
end
function MSC:GetTalentRank(name)
    if not MSC.TalentCache or not next(MSC.TalentCache) then MSC:BuildTalentCache() end
    return MSC.TalentCache[name] or 0
end

-- =============================================================
-- 2. GEAR SNAPSHOT
-- =============================================================
local GEAR_SLOTS = { 1, 2, 3, 15, 5, 9, 10, 6, 7, 8, 11, 12, 13, 14, 16, 17, 18 }

function MSC:GetEquippedGear(outputTable)
    local gear = outputTable or {}
    wipe(gear)
    for _, slotID in ipairs(GEAR_SLOTS) do
        gear[slotID] = GetInventoryItemLink("player", slotID)
    end
    return gear
end

-- =============================================================
-- 3. THE SCORING ENGINE (The Brain)
-- =============================================================
function MSC:GetTotalCharacterScore(gearTable, weights, specName)
    local totalScore = 0
    
    wipe(Scratch_SetCounts)
    wipe(Scratch_Accumulator)
    Scratch_Colors.RED = 0; Scratch_Colors.YELLOW = 0; Scratch_Colors.BLUE = 0;
    
    local metaGemID = nil 

    for slotID, itemLink in pairs(gearTable) do
        if itemLink then
            -- [[ 1. GET BASE STATS ]] 
            local stats = MSC.SafeGetItemStats(itemLink, slotID, weights, specName)
            
            -- [[ 2. READ META/COLOR DATA ]] (Logic remains the same)
            local itemGemIDs = {}
            if stats.META_ID then metaGemID = stats.META_ID end
            if stats.COLORS then
                if stats.COLORS.RED then Scratch_Colors.RED = Scratch_Colors.RED + stats.COLORS.RED end
                if stats.COLORS.YELLOW then Scratch_Colors.YELLOW = Scratch_Colors.YELLOW + stats.COLORS.YELLOW end
                if stats.COLORS.BLUE then Scratch_Colors.BLUE = Scratch_Colors.BLUE + stats.COLORS.BLUE end
            else
                if MSC.GetItemGems then
                    local rColors, rMeta, rGemIDs = MSC:GetItemGems(itemLink)
                    if rMeta and not metaGemID then metaGemID = rMeta end
                    if rGemIDs then itemGemIDs = rGemIDs end
                    if rColors then
                        Scratch_Colors.RED = Scratch_Colors.RED + (rColors.RED or 0)
                        Scratch_Colors.YELLOW = Scratch_Colors.YELLOW + (rColors.YELLOW or 0)
                        Scratch_Colors.BLUE = Scratch_Colors.BLUE + (rColors.BLUE or 0)
                    end
                end
            end
            
            -- [[ 3. FAILSAFE: GEM STAT INJECTION ]]
            if #itemGemIDs > 0 and MSC.GetGemStatsByID then
                for _, gID in ipairs(itemGemIDs) do
                    local gData = MSC.GetGemStatsByID(gID)
                    if gData and gData.isMeta then
                         if gData.stat then stats[gData.stat] = (stats[gData.stat] or 0) + gData.val end
                         if gData.stat2 then stats[gData.stat2] = (stats[gData.stat2] or 0) + gData.val2 end
                    end
                end
            end
            
            -- [[ 4. SCORE THE ITEM (Poison-Aware) ]]
            local itemScore = 0
            for stat, val in pairs(stats) do
                local w = weights[stat] or 0
                if w > 0 then
                    -- Only add to score if weight is positive
                    itemScore = itemScore + (val * w)
                elseif w < 0 then
                    -- OPTIONAL: If weight is negative, you can subtract 
                    -- but keep it small so it doesn't break the UI.
                    -- itemScore = itemScore + (val * w) 
                end
            end
            totalScore = totalScore + itemScore

            local itemScore = 0
            if not isPoisoned then
                itemScore = MSC.GetItemScore(stats, weights, specName, slotID)
            else
                -- If poisoned, the item gives 0 score. 
                -- This prevents the "massive negative" visual bug.
                itemScore = 0
            end
            totalScore = totalScore + itemScore

            -- [[ 5. ACCUMULATE TOTALS ]]
            for k,v in pairs(stats) do 
                if type(v) == "number" and k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" then 
                    Scratch_Accumulator[k] = (Scratch_Accumulator[k] or 0) + v 
                end
            end
            
            -- [[ 6. HANDLE PROCS & SET COUNTS ]]
            local itemID = GetItemInfoInstant(itemLink)
            if itemID then
                -- A. Count Sets
                if MSC.GetItemSetID then
                    local setID = MSC:GetItemSetID(itemLink) 
                    if setID then Scratch_SetCounts[setID] = (Scratch_SetCounts[setID] or 0) + 1 end
                end
                
                -- B. Handle Hybrid "Use" Effects (Also Poison-Aware)
                if stats._AUTO_PROC and not isPoisoned then
                    local p = stats._AUTO_PROC
                    Scratch_Accumulator[p.stat] = (Scratch_Accumulator[p.stat] or 0) + p.val
                    if weights[p.stat] and weights[p.stat] > 0 then
                        totalScore = totalScore + (p.val * weights[p.stat])
                    end
                end
            end
        end
    end

    -- ... [Rest of the function: Set Bonuses, Weapon Spec, Meta Validation] ...
    -- (Keep Steps 7, 8, and 9 exactly as you have them)

    return totalScore, MSC:SafeCopy(Scratch_Accumulator), MSC:SafeCopy(Scratch_Colors)
end

-- =============================================================
-- 4. BAG SCANNERS (Smart Weapon Logic)
-- =============================================================

-- Find the best MAIN HAND in bags (to pair with a new Off-Hand)
function MSC:GetBestMainHandInBags(weights, specName)
    local bestLink = nil
    local bestScore = -1

    for bag = 0, 4 do
        -- FIX: Use wrapper for C_Container compatibility
        local numSlots = GetBagSlots(bag) 
        for slot = 1, numSlots do
            local link = GetBagLink(bag, slot)
            if link then
                local _, _, _, _, _, _, _, _, loc = GetItemInfo(link)
                if (loc == "INVTYPE_WEAPON" or loc == "INVTYPE_WEAPONMAINHAND") and IsEquippableItem(link) then
                    local stats = MSC.SafeGetItemStats(link, 16, weights, specName)
                    local score = MSC.GetItemScore(stats, weights, specName, 16)
                    if score > bestScore then
                        bestScore = score
                        bestLink = link
                    end
                end
            end
        end
    end
    return bestLink
end

-- Find the best OFF HAND in bags (to pair with a new Main Hand)
function MSC:GetBestOffHandInBags(weights, specName)
    local bestLink = nil
    local bestScore = -1

    for bag = 0, 4 do
        -- FIX: Use wrapper for C_Container compatibility
        local numSlots = GetBagSlots(bag)
        for slot = 1, numSlots do
            local link = GetBagLink(bag, slot)
            if link then
                local _, _, _, _, _, _, _, _, loc = GetItemInfo(link)
                local validOH = (loc == "INVTYPE_WEAPON" or loc == "INVTYPE_WEAPONOFFHAND" or loc == "INVTYPE_SHIELD" or loc == "INVTYPE_HOLDABLE")
                if validOH and IsEquippableItem(link) then
                    local stats = MSC.SafeGetItemStats(link, 17, weights, specName)
                    local score = MSC.GetItemScore(stats, weights, specName, 17)
                    if score > bestScore then
                        bestScore = score
                        bestLink = link
                    end
                end
            end
        end
    end
    return bestLink
end

-- =============================================================
-- 5. EVALUATE UPGRADE (Now with Item Name Context)
-- =============================================================
function MSC:EvaluateUpgrade(newItemLink, targetSlotID, weights, specName)
    if not weights then weights, specName = MSC.GetCurrentWeights() end

    MSC:GetEquippedGear(Scratch_Gear)
    local currentScore, _ = MSC:GetTotalCharacterScore(Scratch_Gear, weights, specName)

    local originalItem = Scratch_Gear[targetSlotID]
    local originalMH   = Scratch_Gear[16]
    local originalOH   = Scratch_Gear[17]
    local contextMsg   = nil
    
    Scratch_Gear[targetSlotID] = newItemLink
    
    local _,_,_,_,_,_,_,_, newLoc = GetItemInfo(newItemLink)
    local isNew2H = (newLoc == "INVTYPE_2HWEAPON" or newLoc == "INVTYPE_STAFF" or newLoc == "INVTYPE_POLEARM")

    -- [[ CASE A: Main Hand ]]
    if targetSlotID == 16 then
        if isNew2H then
            Scratch_Gear[17] = nil 
        else
            local currentMH = GetInventoryItemLink("player", 16)
            if currentMH then
                local _,_,_,_,_,_,_,_, currLoc = GetItemInfo(currentMH)
                local isCurrent2H = (currLoc == "INVTYPE_2HWEAPON" or currLoc == "INVTYPE_STAFF" or currLoc == "INVTYPE_POLEARM")
                
                if isCurrent2H then
                    local bestBagOH = MSC:GetBestOffHandInBags(weights, specName)
                    if bestBagOH then
                        Scratch_Gear[17] = bestBagOH
                        -- GET ITEM NAME FOR CONTEXT
                        local bagName = GetItemInfo(bestBagOH)
                        contextMsg = "|cff00ff00(w/ ".. (bagName or "Bag Item") ..")|r"
                    else
                        Scratch_Gear[17] = nil
                        contextMsg = "|cffff0000(No OH found)|r"
                    end
                end
            end
        end
        
    -- [[ CASE B: Off Hand ]]
    elseif targetSlotID == 17 then
        local currentMH = GetInventoryItemLink("player", 16)
        if currentMH then
            local _,_,_,_,_,_,_,_, currLoc = GetItemInfo(currentMH)
            local isCurrent2H = (currLoc == "INVTYPE_2HWEAPON" or currLoc == "INVTYPE_STAFF" or currLoc == "INVTYPE_POLEARM")
            
            if isCurrent2H then
                local bestBagMH = MSC:GetBestMainHandInBags(weights, specName)
                if bestBagMH then
                    Scratch_Gear[16] = bestBagMH
                    -- GET ITEM NAME FOR CONTEXT
                    local bagName = GetItemInfo(bestBagMH)
                    contextMsg = "|cff00ff00(w/ ".. (bagName or "Bag Item") ..")|r"
                else
                    Scratch_Gear[16] = nil
                    contextMsg = "|cffff0000(No MH found)|r"
                end
            end
        end
    end

    local newScore, _, newTotalColors = MSC:GetTotalCharacterScore(Scratch_Gear, weights, specName)

    Scratch_Gear[targetSlotID] = originalItem
    Scratch_Gear[16] = originalMH
    Scratch_Gear[17] = originalOH

    local finalNewStats = MSC.SafeGetItemStats(newItemLink, targetSlotID, weights, specName)
    
    -- Pass the dynamic context message to Core.lua
    if contextMsg then 
        finalNewStats.Context = contextMsg 
    end

    if finalNewStats._AUTO_PROC then
         local p = finalNewStats._AUTO_PROC
         finalNewStats[p.stat] = (finalNewStats[p.stat] or 0) + p.val
    end

    local finalOldStats = {}
    local oldItemLink = GetInventoryItemLink("player", targetSlotID)
    if oldItemLink then 
        finalOldStats = MSC.SafeGetItemStats(oldItemLink, targetSlotID, weights, specName) 
        if finalOldStats._AUTO_PROC then
             local p = finalOldStats._AUTO_PROC
             finalOldStats[p.stat] = (finalOldStats[p.stat] or 0) + p.val
        end
    end

    return newScore, currentScore, finalNewStats, finalOldStats, newTotalColors
end