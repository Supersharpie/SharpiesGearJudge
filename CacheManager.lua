local addonName, MSC = ...
_G.MSC = MSC 

-- ============================================================================
-- DYNAMIC CACHE MANAGER
-- Narrow invalidation: evaluation + slot caches on stat-changing events.
-- Raw stat cache is only cleared when item data or scoring revision changes.
-- ============================================================================

local CacheManager = CreateFrame("Frame")

CacheManager:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
CacheManager:RegisterEvent("PLAYER_ENTERING_WORLD")
CacheManager:RegisterEvent("CHARACTER_POINTS_CHANGED")
CacheManager:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
CacheManager:RegisterEvent("PLAYER_TALENT_UPDATE")
CacheManager:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

CacheManager:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        if MSC.BumpScoringRevision then
            MSC:BumpScoringRevision()
        end
        if MSC.EquippedSlotScoreCache then wipe(MSC.EquippedSlotScoreCache) end
        if MSC.EquippedScoreCache then MSC.EquippedScoreCache = nil end
        return
    end

    if MSC.EvaluationCache then
        wipe(MSC.EvaluationCache)
    end
    if MSC.SlotCache then
        wipe(MSC.SlotCache)
    end
    if MSC.EquippedScoreCache then
        MSC.EquippedScoreCache = nil
    end
end)
