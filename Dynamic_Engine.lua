local addonName, MSC = ...

-- =========================================================================
-- 1. TALENT CACHING SYSTEM (Era 3-Tab Support)
-- =========================================================================
MSC.TalentCache = {}
MSC.TalentCacheLoaded = false

-- Stores the final calculated weights to prevent frame lag
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
-- 2. STATE UPDATE (Critical for Era Caps)
-- =========================================================================
function MSC:UpdatePlayerState()
    -- Update Hit/Crit snapshots so ApplyScalers knows if we are capped
    -- Note: GetHitModifier() returns nil in some Era clients, default to 0
    MSC.PlayerStats.Hit = GetHitModifier and GetHitModifier() or 0
    MSC.PlayerStats.SpellHit = GetSpellHitModifier and GetSpellHitModifier() or 0
    
    -- Crit is complex in Era, often simpler to rely on scanner, but we grab base here
    local _, int = UnitStat("player", 4)
    local _, agi = UnitStat("player", 2)
    MSC.PlayerStats.Intellect = int
    MSC.PlayerStats.Agility = agi
end

-- =========================================================================
-- 3. WEIGHT DISPATCHER
-- =========================================================================
function MSC:ApplyDynamicAdjustments()
    -- 1. Refresh State (Hit/Crit/Stats)
    MSC:UpdatePlayerState()

    local specKey = "Default"
    local rawWeights = {}

    -- 2. CHECK FOR MANUAL OVERRIDE
    if SGJ_Settings and SGJ_Settings.Mode and SGJ_Settings.Mode ~= "AUTO" and SGJ_Settings.Mode ~= "Auto" then
        specKey = SGJ_Settings.Mode
        
        -- Try to find this key in Endgame or Leveling tables
        if MSC.CurrentClass then
            if MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[specKey] then
                rawWeights = MSC.CurrentClass.Weights[specKey]
            elseif MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[specKey] then
                rawWeights = MSC.CurrentClass.LevelingWeights[specKey]
            end
        end
    else
        -- 3. AUTO-DETECT SPEC
        if MSC.CurrentClass and MSC.CurrentClass.GetSpec then
            specKey = MSC.CurrentClass:GetSpec()
            
            -- Route to correct table
            if MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[specKey] then
                rawWeights = MSC.CurrentClass.Weights[specKey]
            elseif MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[specKey] then
                rawWeights = MSC.CurrentClass.LevelingWeights[specKey]
            end
        end
    end

    -- 4. DEEP COPY WEIGHTS (Don't mutate the Class Module directly)
    local finalWeights = {}
    for k, v in pairs(rawWeights) do finalWeights[k] = v end

    -- 5. APPLY SCALERS (Hit Caps / Weapon Skill Hysteresis)
    local capText = nil
    if MSC.CurrentClass and MSC.CurrentClass.ApplyScalers then
        finalWeights, capText = MSC.CurrentClass:ApplyScalers(finalWeights, specKey)
    end

    return finalWeights, specKey, capText
end

-- [[ THE MASTER WRAPPER ]] --
function MSC.GetCurrentWeights()
    -- If cached, return instantly to save FPS
    if MSC.CachedWeights then
        return MSC.CachedWeights, MSC.CachedSpecKey, MSC.CachedCapText
    end

    -- Heavy Calculation
    local w, key, txt = MSC:ApplyDynamicAdjustments()
    
    -- Cache Result
    MSC.CachedWeights = w
    MSC.CachedSpecKey = key
    MSC.CachedCapText = txt
    
    return w, key, txt
end

-- =========================================================================
-- 4. WEAPON SPEC BONUS (Delegated)
-- =========================================================================
function MSC:GetWeaponSpecBonus(itemLink)
    -- Racial bonuses (Orc Axe / Human Sword) are calculated in the Class Module
    if MSC.CurrentClass and MSC.CurrentClass.GetWeaponBonus then
        return MSC.CurrentClass:GetWeaponBonus(itemLink)
    end
    return 0
end

-- =========================================================================
-- 5. EVENT LISTENER (Cache Invalidation)
-- =========================================================================
local talentTracker = CreateFrame("Frame")
talentTracker:RegisterEvent("CHARACTER_POINTS_CHANGED") -- Era Talents
talentTracker:RegisterEvent("PLAYER_TALENT_UPDATE")     -- Retail/Cata compat
talentTracker:RegisterEvent("PLAYER_ENTERING_WORLD")
talentTracker:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") -- Gear change affects Hit Cap status
talentTracker:RegisterEvent("UNIT_INVENTORY_CHANGED")

talentTracker:SetScript("OnEvent", function(self, event, unit)
    if event == "UNIT_INVENTORY_CHANGED" and unit ~= "player" then return end

    -- Wipe Talent Cache only when talents change
    if event == "PLAYER_TALENT_UPDATE" or event == "CHARACTER_POINTS_CHANGED" then
        MSC.TalentCache = {} 
        MSC.TalentCacheLoaded = false
    end

    -- Wipe Weight Cache (Always wipe on gear change to recalc Caps)
    MSC.CachedWeights = nil
    
    -- Update UI Dropdown text if options are open
    if MyStatCompareFrame and MyStatCompareFrame:IsShown() and MSC.OptionsFrame and MSC.OptionsFrame.ProfileDD then
        local _, detectedKey = MSC.GetCurrentWeights()
        -- (Optional: Update dropdown text via UIDropDownMenu_SetText if needed)
    end
end)