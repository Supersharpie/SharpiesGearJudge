local _, MSC = ...

-- =============================================================
-- 1. GEAR SNAPSHOT
-- =============================================================
local GEAR_SLOTS = { 1, 2, 3, 15, 5, 9, 10, 6, 7, 8, 11, 12, 13, 14, 16, 17, 18 }

function MSC:GetEquippedGear()
    local gear = {}
    for _, slotID in ipairs(GEAR_SLOTS) do
        gear[slotID] = GetInventoryItemLink("player", slotID)
    end
    return gear
end

function MSC:SafeCopy(orig)
    local copy = {}
    if not orig then return {} end
    for k,v in pairs(orig) do copy[k] = v end
    return copy
end

-- =============================================================
-- 2. SCORING ENGINE (THE BRAIN)
-- =============================================================

-- A. The Master Score Function
function MSC:GetTotalCharacterScore(gearTable, weights, specName)
    local totalScore = 0
    local setCounts = {} 
    local accumulatedStats = {} -- For the stat breakdown

    -- 1. SUM INDIVIDUAL ITEMS (Using Helpers.lua Logic)
    for slotID, itemLink in pairs(gearTable) do
        if itemLink then
            -- Use Helper to get stats (Projected Gems/Enchants included)
            local stats = MSC.SafeGetItemStats(itemLink, slotID)
            
            -- Use Helper to score the item (Respects Speed/Poison logic)
            local itemScore = MSC.GetItemScore(stats, weights, specName, slotID)
            totalScore = totalScore + itemScore
            
            -- Accumulate raw stats for the "Math" breakdown
            for k,v in pairs(stats) do 
                if type(v) == "number" then accumulatedStats[k] = (accumulatedStats[k] or 0) + v end
            end

            -- Track Sets & Procs
            local itemID = GetItemInfoInstant(itemLink)
            if itemID then
                local setID = MSC:GetItemSetID(itemID)
                if setID then setCounts[setID] = (setCounts[setID] or 0) + 1 end
                
                -- Add Proc Values (SSE)
                local procData = MSC:GetProcData(itemID)
                if procData then
                    if procData.score then totalScore = totalScore + procData.score end
                    if procData.ppm then
                        local dur, val = procData.dur or 10, procData.val or 0
                        local sse = (val * dur * procData.ppm) / 60
                        local statName = procData.stat or "ITEM_MOD_ATTACK_POWER_SHORT"
                        accumulatedStats[statName] = (accumulatedStats[statName] or 0) + sse
                        -- Add SSE to score manually since GetItemScore didn't see it
                        if weights[statName] then totalScore = totalScore + (sse * weights[statName]) end
                    end
                end
            end
        end
    end

    -- 2. ADD SET BONUSES
    for setID, count in pairs(setCounts) do
        if MSC.SetBonusScores[setID] then
            for reqCount, bonusData in pairs(MSC.SetBonusScores[setID]) do
                if count >= reqCount then
                    if bonusData.score then
                        totalScore = totalScore + bonusData.score
                    elseif bonusData.stats then
                        for stat, val in pairs(bonusData.stats) do
                            accumulatedStats[stat] = (accumulatedStats[stat] or 0) + val
                            if weights[stat] then totalScore = totalScore + (val * weights[stat]) end
                        end
                    end
                end
            end
        end
    end

    -- 3. ADD WEAPON SPECIALIZATION (Racial)
    if MSC.GetWeaponSpecBonus then
        local _, class = UnitClass("player")
        if gearTable[16] then totalScore = totalScore + MSC:GetWeaponSpecBonus(gearTable[16], class, specName) end
        if gearTable[17] then totalScore = totalScore + MSC:GetWeaponSpecBonus(gearTable[17], class, specName) end
    end

    return totalScore, accumulatedStats
end

-- B. The Comparison Simulator
function MSC:EvaluateUpgrade(newItemLink, targetSlotID, weights, specName)
    -- 1. Snapshot Current
    local currentGear = MSC:GetEquippedGear()
    local currentScore, currentStats = MSC:GetTotalCharacterScore(currentGear, weights, specName)

    -- 2. Create Virtual Set
    local newGear = MSC:SafeCopy(currentGear)
    newGear[targetSlotID] = newItemLink
    
    -- Handle 2H Conflict (Unequip OH if equipping 2H)
    if targetSlotID == 16 then
        local _,_,_,_,_,_,_,_, equipLoc = GetItemInfo(newItemLink)
        if equipLoc == "INVTYPE_2HWEAPON" then newGear[17] = nil end
    end

    -- 3. Calculate New Score
    local newScore, newStats = MSC:GetTotalCharacterScore(newGear, weights, specName)
    
    return newScore, currentScore, newStats, currentStats
end