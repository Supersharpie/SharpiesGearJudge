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
function MSC:GetTotalCharacterScore(gearTable, weights)
    local totalScore = 0
    local setCounts = {} -- Tracks how many pieces of each set we have
    local accumulator = {} -- Helper to sum up stats before weighing

    -- A. SCAN ITEMS
    for slotID, itemLink in pairs(gearTable) do
        if itemLink then
            -- 1. Get Base Stats (Str, Agi, etc.)
            local stats = MSC.SafeGetItemStats(itemLink, slotID)
            
            -- 2. Get Proc/Hidden Stats (Ironfoe, etc.)
            local itemID = GetItemInfoInstant(itemLink)
            if itemID then
                local procData = MSC:GetProcData(itemID)
                if procData then
                    -- Calculate SSE (Static Stat Equivalent)
                    -- Formula: (Val * Duration * PPM) / 60
                    if procData.ppm then
                        local dur = procData.dur or 10 -- default 10s if missing
                        local val = procData.val or 0
                        local statName = procData.stat or "ITEM_MOD_ATTACK_POWER_SHORT" -- default to AP
                        local sse = (val * dur * procData.ppm) / 60
                        stats[statName] = (stats[statName] or 0) + sse
                    elseif procData.score then
                        -- Flat score override (e.g. Hand of Justice)
                        totalScore = totalScore + procData.score
                    end
                end

                -- 3. Track Set Counts
                local setID = MSC:GetItemSetID(itemID)
                if setID then
                    setCounts[setID] = (setCounts[setID] or 0) + 1
                end
            end

            -- Add to Accumulator (FIXED: Filter out non-number flags)
            for stat, value in pairs(stats) do
                if type(value) == "number" then
                    accumulator[stat] = (accumulator[stat] or 0) + value
                end
            end
        end
    end

    -- B. CALCULATE SET BONUSES
    for setID, count in pairs(setCounts) do
        -- Iterate through all defined bonuses for this set
        -- We check breakpoints: if count is 5, we get the 2, 3, 4, and 5 bonuses (if they exist)
        if MSC.SetBonusScores[setID] then
            for reqCount, bonusData in pairs(MSC.SetBonusScores[setID]) do
                if count >= reqCount then
                    -- We qualify for this bonus!
                    if bonusData.score then
                        -- Flat Score (e.g. "Improved Mend Pet")
                        totalScore = totalScore + bonusData.score
                    elseif bonusData.stats then
                        -- Stat Bonus (e.g. "+30 Stamina")
                        for stat, val in pairs(bonusData.stats) do
                            accumulator[stat] = (accumulator[stat] or 0) + val
                        end
                    end
                end
            end
        end
    end

    -- C. APPLY WEIGHTS
    for stat, val in pairs(accumulator) do
        local weight = weights[stat] or 0
        totalScore = totalScore + (val * weight)
    end

    return totalScore
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