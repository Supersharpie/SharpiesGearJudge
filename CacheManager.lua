local addonName, MSC = ...
_G.MSC = MSC 

-- ============================================================================
-- DYNAMIC CACHE MANAGER
-- Solves the Dynamic Engine vs Evaluator Cache conflict by wiping evaluated 
-- scores whenever the player's baseline stats or gear change.
-- ============================================================================

local CacheManager = CreateFrame("Frame")

-- Register events that alter the player's dynamic stat caps
CacheManager:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
CacheManager:RegisterEvent("PLAYER_ENTERING_WORLD")
CacheManager:RegisterEvent("CHARACTER_POINTS_CHANGED") -- Triggers when talents change
CacheManager:RegisterEvent("UPDATE_SHAPESHIFT_FORM")   -- Triggers when Druids/Warriors change stances (altering base stats)

CacheManager:SetScript("OnEvent", function(self, event, ...)
    -- 1. Wipe the Evaluation Cache so items are re-scored with the new dynamic weights
    if MSC.EvaluationCache then 
        wipe(MSC.EvaluationCache) 
    end
    
    -- 2. Wipe the Slot Cache so Judge.lua recalculates the equipped gear baseline
    if MSC.SlotCache then 
        wipe(MSC.SlotCache) 
    end
    
    -- 3. Wipe the Stat Cache so Dynamic_Engine grabs fresh totals
    if MSC.StatCache then 
        wipe(MSC.StatCache) 
    end
end)