local addonName, MSC = ...
_G.MSC = MSC 

-- [[ SPEED OPTIMIZATION: LOCALIZED FUNCTIONS ]]
local pairs, next = pairs, next
local tonumber = tonumber

local GetNumTalentTabs = GetNumTalentTabs
local GetNumTalents = GetNumTalents
local GetTalentInfo = GetTalentInfo
local UnitClass = UnitClass
local CreateFrame = CreateFrame
local C_Timer = C_Timer
local UIDropDownMenu_SetText = UIDropDownMenu_SetText

-- =========================================================================
-- 1. TALENT CACHING SYSTEM 
-- =========================================================================
MSC.TalentCache = {}
MSC.TalentCacheLoaded = false

MSC.CachedWeights = nil
MSC.CachedSpecKey = nil

function MSC:BuildTalentCache()
    MSC.TalentCache = {}
    local tabs = GetNumTalentTabs() or 0
    if tabs == 0 then return end

    for t = 1, tabs do
        local num = GetNumTalents(t) or 0
        for i = 1, num do
            local name, _, _, _, rank = GetTalentInfo(t, i)
            if name then 
                MSC.TalentCache[name] = tonumber(rank) or 0
            end
        end
    end
    MSC.TalentCacheLoaded = true
end

function MSC:GetTalentRank(talentKey)
    if not MSC.CurrentClass or not MSC.CurrentClass.Talents then return 0 end

    if not MSC.TalentCacheLoaded then 
        self:BuildTalentCache() 
        if not MSC.TalentCacheLoaded then return 0 end
    end

    local localizedName = MSC.CurrentClass.Talents[talentKey]
    if not localizedName then return 0 end

    return MSC.TalentCache[localizedName] or 0
end

-- =========================================================================
-- 2. WEIGHT DISPATCHER
-- =========================================================================

function MSC:ApplyDynamicAdjustments()
    local _, class = UnitClass("player")
    local specKey = "Default"
    local rawWeights = {}
    local mathSpec = nil

    -- 1. CHECK FOR MANUAL OVERRIDE 
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then
        specKey = MSC.ManualSpec
        local found = false
        
        -- [[ A. PRIORITY 1: CHECK CUSTOM DATABASE (Pawn Imports) ]]
        if SharpiesGearJudgeDB and SharpiesGearJudgeDB.customWeights and SharpiesGearJudgeDB.customWeights[specKey] then
             local data = SharpiesGearJudgeDB.customWeights[specKey]
             
             if type(data) == "table" and data.weights then
                 rawWeights = data.weights
                 if data.BaseSpec then mathSpec = data.BaseSpec end -- Only set mathSpec, leave specKey alone!
             else
                 rawWeights = data
             end
             found = true
        end
        
        -- [[ B. PRIORITY 2: FORCE DYNAMIC CALCULATION ]]
        if not found and MSC.CurrentClass and MSC.CurrentClass.GetDynamicWeights then
            local dynWeights, dynKey = MSC.CurrentClass:GetDynamicWeights(specKey)
            if dynWeights then
                rawWeights = dynWeights
                specKey = dynKey
                found = true
            end
        end
        
        -- [[ C. PRIORITY 3: FALLBACK TO STATIC ]]
        if not found then
            if MSC.CurrentClass and MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[specKey] then
                rawWeights = MSC.CurrentClass.Weights[specKey]
            elseif MSC.CurrentClass and MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[specKey] then
                rawWeights = MSC.CurrentClass.LevelingWeights[specKey]
            end
        end
        
    else
        -- 2. AUTO-DETECT MODE
        if MSC.CurrentClass and MSC.CurrentClass.GetDynamicWeights then
            local dynWeights, dynKey = MSC.CurrentClass:GetDynamicWeights()
            if dynWeights then
                rawWeights = dynWeights
                specKey = dynKey
            end
        end

        -- 3. FALLBACK: STATIC LOOKUP
        if (not rawWeights or not next(rawWeights)) and MSC.CurrentClass and MSC.CurrentClass.GetSpec then
            specKey = MSC.CurrentClass:GetSpec()
            
            if MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[specKey] then
                rawWeights = MSC.CurrentClass.Weights[specKey]
            elseif MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[specKey] then
                rawWeights = MSC.CurrentClass.LevelingWeights[specKey]
            end
        end
    end

    -- 4. COPY WEIGHTS (Don't edit the originals!)
    local finalWeights = {}
    if rawWeights then
        for k, v in pairs(rawWeights) do finalWeights[k] = v end
    end

    -- 5. APPLY SCALERS & HIT CAPS
    local capText = nil 
    if MSC.CurrentClass and MSC.CurrentClass.ApplyScalers then
        -- Pass mathSpec if it exists, otherwise pass specKey
        finalWeights, capText = MSC.CurrentClass:ApplyScalers(finalWeights, mathSpec or specKey)
    end

    return finalWeights, specKey, capText 
end

-- [[ THE MASTER WRAPPER ]] --
function MSC.GetCurrentWeights()
    if MSC.CachedWeights then
        return MSC.CachedWeights, MSC.CachedSpecKey, MSC.CachedCapText 
    end

    local w, key, capText = MSC:ApplyDynamicAdjustments()
    
    MSC.CachedWeights = w
    MSC.CachedSpecKey = key
    MSC.CachedCapText = capText
    
    -- [[ NUKE TOOLTIP CACHE WHEN PROFILE CHANGES ]]
    if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
    if MSC.SlotCache then wipe(MSC.SlotCache) end
    
    return w, key, capText
end

-- =========================================================================
-- 3. WEAPON SPEC BONUS (Delegated)
-- =========================================================================
function MSC:GetWeaponSpecBonus(itemLink, class, specKey)
    if MSC.CurrentClass and MSC.CurrentClass.GetWeaponBonus then
        return MSC.CurrentClass:GetWeaponBonus(itemLink)
    end
    return 0
end

-- =========================================================================
-- 4. EVENT LISTENER (Cache Invalidation)
-- =========================================================================
local talentTracker = CreateFrame("Frame")
talentTracker:RegisterEvent("CHARACTER_POINTS_CHANGED")
talentTracker:RegisterEvent("PLAYER_TALENT_UPDATE")
talentTracker:RegisterEvent("PLAYER_ENTERING_WORLD")
talentTracker:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") 
talentTracker:RegisterEvent("UNIT_INVENTORY_CHANGED")
talentTracker:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

talentTracker:SetScript("OnEvent", function(self, event, unit)
    if event == "UNIT_INVENTORY_CHANGED" and unit ~= "player" then return end

    -- [[ LOGIC: Wipe Cache on Spec Swap ]]
    if event == "PLAYER_TALENT_UPDATE" or event == "CHARACTER_POINTS_CHANGED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
        MSC.TalentCache = {} 
        MSC.TalentCacheLoaded = false
    end

    MSC.CachedWeights = nil
    MSC.CachedSpecKey = nil
    
    if MyStatCompareFrame and MyStatCompareFrame:IsShown() and MyStatCompareFrame.ProfileDD then
        local _, detectedKey = MSC.GetCurrentWeights()
        local displayName = detectedKey
        if MSC.PrettyNames and MSC.PrettyNames[detectedKey] then
            displayName = MSC.PrettyNames[detectedKey]
        end
        UIDropDownMenu_SetText(MyStatCompareFrame.ProfileDD, string.format(MSC.L["Auto: %s"], displayName))
    end
end)

-- =========================================================================
-- 5. SET BONUS CALCULATOR
-- =========================================================================
function MSC:UpdateSetBonusScores(weights)
    if not MSC.SetBonusScores or not weights then return end

    local count = 0
    for setID, setStages in pairs(MSC.SetBonusScores) do
        for reqCount, data in pairs(setStages) do
            if data.stats then
                local score = 0
                for stat, val in pairs(data.stats) do
                    local w = weights[stat] or 0
                    if w > 0 then
                        score = score + (val * w)
                    end
                end
                data.score = MSC.Round(score, 1)
                count = count + 1
            end
        end
    end
end

-- [[ AUTO-CALCULATE ON LOAD ]]
local setCalcFrame = CreateFrame("Frame")
setCalcFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
setCalcFrame:SetScript("OnEvent", function(self, event)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    C_Timer.After(2, function()
        if MSC.GetCurrentWeights then
            local weights = MSC.GetCurrentWeights()
            if weights then
                MSC:UpdateSetBonusScores(weights)
            end
        end
    end)
end)