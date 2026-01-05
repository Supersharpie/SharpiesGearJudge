local _, MSC = ...

-- ============================================================================
-- 1. CONSTANTS & SETUP
-- ============================================================================
-- Slots to scan for total character power
local GEAR_SLOTS = {
    1,  -- Head
    2,  -- Neck
    3,  -- Shoulder
    15, -- Back
    5,  -- Chest
    9,  -- Wrist
    10, -- Hands
    6,  -- Waist
    7,  -- Legs
    8,  -- Feet
    11, -- Ring 1
    12, -- Ring 2
    13, -- Trinket 1
    14, -- Trinket 2
    16, -- Main Hand
    17, -- Off Hand
    18  -- Ranged
}

-- ============================================================================
-- 2. THE SCORING ENGINE
-- ============================================================================

-- Calculates the TOTAL score of a gear list (Stats + Procs + Set Bonuses)
-- [[ Evaluator.lua ]]

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

            -- Track Sets
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

    -- 2. ADD SET BONUSES (The missing link!)
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

-- Helper for shallow copying tables
function MSC:SafeCopy(orig)
    local copy = {}
    for k,v in pairs(orig) do copy[k] = v end
    return copy
end

-- ============================================================================
-- 3. THE "DELTA" SIMULATOR
-- ============================================================================

-- Snapshots current gear into a table
function MSC:GetEquippedGear()
    local gear = {}
    for _, slot in ipairs(GEAR_SLOTS) do
        gear[slot] = GetInventoryItemLink("player", slot)
    end
    return gear
end

-- Simulates swapping an item and returns the Score Difference
function MSC:EvaluateUpgrade(newItemLink, targetSlotID)
    local currentWeights, specName = MSC.GetCurrentWeights()
    
    -- 1. Snapshot Current State
    local currentGear = MSC:GetEquippedGear()
    local currentScore = MSC:GetTotalCharacterScore(currentGear, currentWeights)

    -- 2. Create Simulation State
    local newGear = {}
    for k, v in pairs(currentGear) do newGear[k] = v end -- Shallow copy

    -- 3. Apply the Swap
    newGear[targetSlotID] = newItemLink

    -- SPECIAL LOGIC: 2-Handers
    -- If equipping a 2H weapon, we must remove the Offhand (Slot 17)
    local equipLoc = select(9, GetItemInfo(newItemLink))
    if equipLoc == "INVTYPE_2HWEAPON" and targetSlotID == 16 then
        newGear[17] = nil -- Unequip offhand
    end

    -- 4. Calculate New Score
    local newScore = MSC:GetTotalCharacterScore(newGear, currentWeights)

    return newScore - currentScore
end