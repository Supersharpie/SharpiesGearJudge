local _, MSC = ...

-- =========================================================================
-- 1. TALENT CACHING SYSTEM (Generic & Efficient)
-- =========================================================================
MSC.TalentCache = {}
MSC.TalentCacheLoaded = false

-- Stores the final calculated weights to prevent lag
MSC.CachedWeights = nil
MSC.CachedSpecKey = nil

-- Scans the player's talent tree once and saves it
function MSC:BuildTalentCache()
    MSC.TalentCache = {}
    local tabs = GetNumTalentTabs() or 0
    if tabs == 0 then return end

    for t = 1, tabs do
        local num = GetNumTalents(t) or 0
        for i = 1, num do
            local name, _, _, _, rank = GetTalentInfo(t, i)
            if name then MSC.TalentCache[name] = rank end
        end
    end
    MSC.TalentCacheLoaded = true
end

-- Helper for Classes to check their talents
function MSC:GetTalentRank(talentKey)
    -- Safety: If no class module is loaded, we can't look up talent names
    if not MSC.CurrentClass or not MSC.CurrentClass.Talents then return 0 end

    if not MSC.TalentCacheLoaded then 
        self:BuildTalentCache() 
        if not MSC.TalentCacheLoaded then return 0 end
    end

    -- Look up the English Name from the Class Module (e.g. "PRECISION" -> "Precision")
    local englishName = MSC.CurrentClass.Talents[talentKey]
    if not englishName then return 0 end

    return MSC.TalentCache[englishName] or 0
end

-- =========================================================================
-- 2. WEIGHT DISPATCHER
-- =========================================================================

function MSC:ApplyDynamicAdjustments()
    local _, class = UnitClass("player")
    local specKey = "Default"
    local rawWeights = {}

    -- 1. CHECK FOR MANUAL OVERRIDE (User selected specific spec in menu)
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then
        specKey = MSC.ManualSpec
        
        -- Try to find this key in Endgame or Leveling tables of the Class Module
        if MSC.CurrentClass and MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[specKey] then
            rawWeights = MSC.CurrentClass.Weights[specKey]
        elseif MSC.CurrentClass and MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[specKey] then
            rawWeights = MSC.CurrentClass.LevelingWeights[specKey]
        end
        
    else
        -- 2. ASK THE CLASS MODULE FOR THE SPEC
        -- The Class Module handles level checks (Leveling vs Endgame) internally
        if MSC.CurrentClass and MSC.CurrentClass.GetSpec then
            specKey = MSC.CurrentClass:GetSpec()
            
            -- Locate the weights for this spec name
            if MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[specKey] then
                rawWeights = MSC.CurrentClass.Weights[specKey]
            elseif MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[specKey] then
                rawWeights = MSC.CurrentClass.LevelingWeights[specKey]
            end
        end
    end

    -- 3. COPY WEIGHTS (Don't edit the originals!)
    local finalWeights = {}
    for k, v in pairs(rawWeights) do finalWeights[k] = v end

    -- 4. APPLY SCALERS & HIT CAPS (Delegate to Class Module)
    -- This handles "If Hit > Cap, weight = 0.01" logic specific to the class
    if MSC.CurrentClass and MSC.CurrentClass.ApplyScalers then
        finalWeights = MSC.CurrentClass:ApplyScalers(finalWeights, specKey)
    end

    return finalWeights, specKey
end

-- [[ THE MASTER WRAPPER ]] --
-- UI functions call this to get the current state
function MSC.GetCurrentWeights()
    -- If we have a cached result, return it instantly!
    if MSC.CachedWeights then
        return MSC.CachedWeights, MSC.CachedSpecKey
    end

    -- Otherwise, do the heavy math
    local w, key = MSC:ApplyDynamicAdjustments()
    
    -- Save the result
    MSC.CachedWeights = w
    MSC.CachedSpecKey = key
    
    return w, key
end

-- =========================================================================
-- 3. WEAPON SPEC BONUS (Delegated)
-- =========================================================================
function MSC:GetWeaponSpecBonus(itemLink, class, specKey)
    -- Racial bonuses and Talent bonuses (e.g. Orc Axe Specialization)
    -- are now handled inside the Class Module.
    
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
-- We listen for gear changes because Hit Caps depend on current gear
talentTracker:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") 
talentTracker:RegisterEvent("UNIT_INVENTORY_CHANGED")

talentTracker:SetScript("OnEvent", function(self, event, unit)
    if event == "UNIT_INVENTORY_CHANGED" and unit ~= "player" then return end

    -- Wipe Talent Cache only when talents actually change
    if event == "PLAYER_TALENT_UPDATE" or event == "CHARACTER_POINTS_CHANGED" then
        MSC.TalentCache = {} 
        MSC.TalentCacheLoaded = false
    end

    -- Wipe Weight Cache (Always, to ensure Hit Caps are accurate to current gear)
    MSC.CachedWeights = nil
    MSC.CachedSpecKey = nil
    
    -- Update UI Dropdown text if the menu is open
    if MyStatCompareFrame and MyStatCompareFrame:IsShown() and SGJ_SpecDropDown then
        local _, detectedKey = MSC.GetCurrentWeights()
        
        -- Use Pretty Name if available
        local displayName = detectedKey
        if MSC.PrettyNames and MSC.PrettyNames[detectedKey] then
            displayName = MSC.PrettyNames[detectedKey]
        end
        
        UIDropDownMenu_SetText(SGJ_SpecDropDown, "Auto: " .. displayName)
    end
end)