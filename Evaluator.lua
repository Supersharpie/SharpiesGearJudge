local addonName, MSC = ...

-- =============================================================
-- 0. API WRAPPERS (Modern Client Support)
-- =============================================================
local GetBagSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetBagLink  = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink

-- =============================================================
-- 1. UTILITIES & RECYCLING
-- =============================================================
local Scratch_Gear = {}
local Scratch_Accumulator = {}
local Scratch_SetCounts = {}

-- Define the Slots we care about
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

-- =============================================================
-- 2. THE SCORING ENGINE (Vanilla Optimized)
-- =============================================================
function MSC:GetTotalCharacterScore(gearTable, weights, specName)
    local totalScore = 0
    wipe(Scratch_SetCounts)
    wipe(Scratch_Accumulator)
    
    for slotID, itemLink in pairs(gearTable) do
        if itemLink then
            -- 1. GET STATS
            local stats = MSC.SafeGetItemStats(itemLink, slotID, weights, specName)
            
            -- 2. CALCULATE SCORE
            local itemScore = MSC.GetItemScore(stats, weights, specName, slotID)
            totalScore = totalScore + itemScore
            
            -- 3. ACCUMULATE TOTALS (For Math Breakdown)
            for k,v in pairs(stats) do 
                if type(v) == "number" and k ~= "IS_PROJECTED" and k ~= "ENCHANT_TEXT" then 
                    Scratch_Accumulator[k] = (Scratch_Accumulator[k] or 0) + v 
                end
            end
            
            -- 4. TRACK SETS & PROCS
            local setID = MSC.GetItemSetID and MSC:GetItemSetID(itemLink)
            if setID then Scratch_SetCounts[setID] = (Scratch_SetCounts[setID] or 0) + 1 end
            
            if stats._AUTO_PROC then
                local p = stats._AUTO_PROC
                Scratch_Accumulator[p.stat] = (Scratch_Accumulator[p.stat] or 0) + p.val
                if weights[p.stat] then totalScore = totalScore + (p.val * weights[p.stat]) end
            end
        end
    end

    -- 5. SET BONUSES
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
                         if bonusData.score then
                             totalScore = totalScore + bonusData.score
                         end
                     end
                 end
             end
        end
    end

    -- 6. WEAPON SPECIALIZATION BONUS
    local mh = gearTable[16]; local oh = gearTable[17]
    if mh then totalScore = totalScore + MSC:GetWeaponSpecBonus(mh, MSC.CurrentClass, specName) end
    if oh then totalScore = totalScore + MSC:GetWeaponSpecBonus(oh, MSC.CurrentClass, specName) end

    return totalScore, MSC:SafeCopy(Scratch_Accumulator)
end

-- =============================================================
-- 3. BAG SCANNERS (For Smart Swapping)
-- =============================================================

function MSC:GetBestMainHandInBags(weights, specName)
    local bestLink = nil
    local bestScore = -1
    for bag = 0, 4 do
        local numSlots = GetBagSlots(bag) 
        for slot = 1, numSlots do
            local link = GetBagLink(bag, slot)
            if link then
                local _, _, _, _, _, _, _, _, loc = GetItemInfo(link)
                if (loc == "INVTYPE_WEAPON" or loc == "INVTYPE_WEAPONMAINHAND") and IsEquippableItem(link) then
                    local stats = MSC.SafeGetItemStats(link, 16, weights, specName)
                    local score = MSC.GetItemScore(stats, weights, specName, 16)
                    if score > bestScore then bestScore = score; bestLink = link end
                end
            end
        end
    end
    return bestLink
end

function MSC:GetBestOffHandInBags(weights, specName)
    local bestLink = nil
    local bestScore = -1
    for bag = 0, 4 do
        local numSlots = GetBagSlots(bag)
        for slot = 1, numSlots do
            local link = GetBagLink(bag, slot)
            if link then
                local _, _, _, _, _, _, _, _, loc = GetItemInfo(link)
                local validOH = (loc == "INVTYPE_WEAPON" or loc == "INVTYPE_WEAPONOFFHAND" or loc == "INVTYPE_SHIELD" or loc == "INVTYPE_HOLDABLE")
                if validOH and IsEquippableItem(link) then
                    local stats = MSC.SafeGetItemStats(link, 17, weights, specName)
                    local score = MSC.GetItemScore(stats, weights, specName, 17)
                    if score > bestScore then bestScore = score; bestLink = link end
                end
            end
        end
    end
    return bestLink
end

-- =============================================================
-- 4. UPGRADE EVALUATOR (Logic Core)
-- =============================================================
function MSC:EvaluateUpgrade(newItemLink, targetSlotID, weights, specName)
    if not newItemLink then return 0, 0, {}, {}, {} end
    if not weights then weights, specName = MSC.GetCurrentWeights() end

    -- 1. SETUP & CURRENT SCORE
    MSC:GetEquippedGear(Scratch_Gear)
    local currentScore, currentStats = MSC:GetTotalCharacterScore(Scratch_Gear, weights, specName)

    local originalItem = Scratch_Gear[targetSlotID]
    local originalMH   = Scratch_Gear[16]
    local originalOH   = Scratch_Gear[17]
    local contextMsg   = nil

    -- 2. PRE-CALCULATE NEW STATS
    local finalNewStats = MSC.SafeGetItemStats(newItemLink, targetSlotID, weights, specName)
    
    -- 3. GET OLD STATS (For Display)
    local finalOldStats = {}
    local oldItemLink = GetInventoryItemLink("player", targetSlotID)
    if oldItemLink then 
        finalOldStats = MSC.SafeGetItemStats(oldItemLink, targetSlotID, weights, specName) 
        if finalOldStats._AUTO_PROC then
             local p = finalOldStats._AUTO_PROC
             finalOldStats[p.stat] = (finalOldStats[p.stat] or 0) + p.val
        end
    end

    -- 4. SWAP GEAR & HANDLE MH/OH LOGIC
    Scratch_Gear[targetSlotID] = newItemLink
    
    local _,_,_,_,_,_,_,_, newLoc = GetItemInfo(newItemLink)
    local isNew2H = (newLoc == "INVTYPE_2HWEAPON" or newLoc == "INVTYPE_STAFF" or newLoc == "INVTYPE_POLEARM")

    local is2HSpec = (specName and (specName:find("ARMS") or specName:find("RET") or specName:find("2H")))

    if targetSlotID == 16 then
        if isNew2H then
            Scratch_Gear[17] = nil -- 2H clears OH
        else
            -- It's a 1H weapon. Check if we currently have a 2H equipped.
            local currentMH = GetInventoryItemLink("player", 16)
            if currentMH then
                local _,_,_,_,_,_,_,_, currLoc = GetItemInfo(currentMH)
                local isCurrent2H = (currLoc == "INVTYPE_2HWEAPON" or currLoc == "INVTYPE_STAFF" or currLoc == "INVTYPE_POLEARM")
                
                if isCurrent2H then
                    -- If we are Arms/Ret, we don't want a 1H.
                    if is2HSpec then
                        Scratch_Gear[17] = nil
                        contextMsg = "|cffff0000(No 2H)|r"
                    else
                        -- Look for best OH in bags to pair with this new 1H
                        local bestBagOH = MSC:GetBestOffHandInBags(weights, specName)
                        if bestBagOH then
                            Scratch_Gear[17] = bestBagOH
                            local bagName = GetItemInfo(bestBagOH)
                            contextMsg = "|cff00ff00(w/ ".. (bagName or "Bag Item") ..")|r"
                        else
                            Scratch_Gear[17] = nil
                            contextMsg = "|cffff0000(No OH found)|r"
                        end
                    end
                end
            end
        end
    elseif targetSlotID == 17 then
        -- Logic for swapping Offhands if we currently have a 2H equipped
        local currentMH = GetInventoryItemLink("player", 16)
        if currentMH then
            local _,_,_,_,_,_,_,_, currLoc = GetItemInfo(currentMH)
            local isCurrent2H = (currLoc == "INVTYPE_2HWEAPON" or currLoc == "INVTYPE_STAFF" or currLoc == "INVTYPE_POLEARM")
            
            if isCurrent2H then
                local bestBagMH = MSC:GetBestMainHandInBags(weights, specName)
                if bestBagMH then
                    Scratch_Gear[16] = bestBagMH
                    local bagName = GetItemInfo(bestBagMH)
                    contextMsg = "|cff00ff00(w/ ".. (bagName or "Bag Item") ..")|r"
                else
                    Scratch_Gear[16] = nil
                    contextMsg = "|cffff0000(No MH found)|r"
                end
            end
        end
    end

    -- 5. CALCULATE FUTURE SCORE
    local newScore, newStatsTotal = MSC:GetTotalCharacterScore(Scratch_Gear, weights, specName)

    -- 6. CAP GUARDIAN (Vanilla Version)
    local _, playerClass = UnitClass("player")

    -- Define Vanilla Caps
    local HIT_CAP = 9 -- 9% Physical
    if playerClass == "MAGE" or playerClass == "WARLOCK" or playerClass == "PRIEST" then HIT_CAP = 16 end
    
    local DEFENSE_CAP = 440 -- Lvl 63 Boss Cap (300 Base + 140 Gear)

    -- A. Check Hit Cap
    local hitStat = (HIT_CAP == 16) and "ITEM_MOD_HIT_SPELL_RATING_SHORT" or "ITEM_MOD_HIT_RATING_SHORT"
    local hitWeight = weights[hitStat] or 0
    
    if hitWeight > 0 then
        -- In Era Helpers.lua, 1.0 value = 1% Hit
        local currentHit = currentStats[hitStat] or 0
        local futureHit  = newStatsTotal[hitStat] or 0
        
        -- If we were capped (>= 9), and now we are NOT (< 9)
        if currentHit >= HIT_CAP and futureHit < HIT_CAP then
            -- Apply Penalty (100 score points per 1% lost under cap)
            local deficit = HIT_CAP - futureHit
            newScore = newScore - (deficit * 100)
            contextMsg = (contextMsg or "") .. string.format(" |cffff0000(Under Hit Cap by %.1f%%)|r", deficit)
        end
    end

    -- B. Check Defense Cap (Tanks Only)
    local defWeight = weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0
    if defWeight > 0 then
        local baseDef, armorDef = UnitDefense("player")
        local currentDefTotal = baseDef + armorDef
        
        local oldDefSkill = (finalOldStats and finalOldStats["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]) or 0
        local newDefSkill = (finalNewStats and finalNewStats["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]) or 0
        
        -- Calculate future total defense
        local futureDefTotal = currentDefTotal - oldDefSkill + newDefSkill
        
        if currentDefTotal >= DEFENSE_CAP and futureDefTotal < DEFENSE_CAP then
             local deficit = DEFENSE_CAP - futureDefTotal
             newScore = newScore - (deficit * 50) -- 50 pts per Defense point lost under cap
             contextMsg = (contextMsg or "") .. string.format(" |cffff0000(Under Def Cap by %d)|r", deficit)
        end
    end

    -- 7. FINALIZE
    Scratch_Gear[targetSlotID] = originalItem
    Scratch_Gear[16] = originalMH
    Scratch_Gear[17] = originalOH

    if contextMsg then 
        finalNewStats.Context = (finalNewStats.Context or "") .. " " .. contextMsg 
    end

    if finalNewStats._AUTO_PROC then
         local p = finalNewStats._AUTO_PROC
         finalNewStats[p.stat] = (finalNewStats[p.stat] or 0) + p.val
    end

    return newScore, currentScore, finalNewStats, finalOldStats
end