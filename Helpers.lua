local _, MSC = ...

-- =============================================================
-- 1. GENERAL HELPERS
-- =============================================================
function MSC.GetCleanStatName(key)
    if MSC.ShortNames and MSC.ShortNames[key] then return MSC.ShortNames[key] end
    local clean = key:gsub("ITEM_MOD_", ""):gsub("_SHORT", ""):gsub("_", " "):lower()
    return clean:gsub("^%l", string.upper)
end

function MSC.IsItemUsable(link)
    if not link then return false end
    local _, _, _, _, _, _, _, _, equipLoc, _, _, classID, subclassID = GetItemInfo(link)
    local _, playerClass = UnitClass("player")
    if classID == 4 then 
        if playerClass == "MAGE" or playerClass == "WARLOCK" or playerClass == "PRIEST" then if subclassID > 1 then return false end 
        elseif playerClass == "ROGUE" or playerClass == "DRUID" then if subclassID > 2 then return false end 
        elseif playerClass == "HUNTER" or playerClass == "SHAMAN" then if subclassID > 3 then return false end end
    end
    if classID == 2 and MSC.ValidWeapons and MSC.ValidWeapons[playerClass] then
        if not MSC.ValidWeapons[playerClass][subclassID] then return false end
    end
    return true
end

-- [[ FIXED SPEC DETECTION LOGIC ]] --
function MSC.GetCurrentWeights()
    local _, class = UnitClass("player")
    if not class then return {}, "Unknown" end
    
    local classData = MSC.WeightDB and MSC.WeightDB[class]
    if not classData then return {}, "No Data" end
    
    -- 1. Identify the spec tree with the most points (specIndex)
    local maxPoints, specIndex = -1, 1
    for i = 1, 3 do
        local _, _, _, _, points = GetTalentTabInfo(i)
        local p = points or 0
        if p > maxPoints then
            maxPoints = p
            specIndex = i
        end
    end

    -- 2. Pass base weights, level, and specIndex to the Engine
    local baseWeights = classData["Default"] or {}
    local adjustedWeights, specKey = MSC:ApplyDynamicAdjustments(baseWeights, UnitLevel("player"), specIndex)
    
    -- 3. Lookup the Pretty Name
    local displayName = specKey
    if MSC.PrettyNames and MSC.PrettyNames[class] and MSC.PrettyNames[class][specKey] then
        displayName = MSC.PrettyNames[class][specKey]
    end
    
    return adjustedWeights, displayName
end

-- =============================================================
-- 2. STAT COMPARISON TOOLS (FIXED: Ignored Booleans)
-- =============================================================
function MSC.GetStatDifferences(new, old)
    local diffs = {}
    local seen = {}
    
    -- Loop through NEW stats
    for k, v in pairs(new) do 
        -- FIX: Only compare if 'v' is actually a number (ignores estimate=true, replace=true)
        if k ~= "IS_PROJECTED" and type(v) == "number" then
            local d = v - (old[k] or 0)
            if d ~= 0 then table.insert(diffs, { key=k, val=d }); seen[k] = true end
        end
    end
    
    -- Loop through OLD stats
    for k, v in pairs(old) do
        if not seen[k] and k ~= "IS_PROJECTED" and type(v) == "number" then
            local d = (new[k] or 0) - v
            if d ~= 0 then table.insert(diffs, { key=k, val=d }) end
        end
    end
    return diffs
end

function MSC.SortStatDiffs(diffs)
    table.sort(diffs, function(a,b) return a.val > b.val end)
    return diffs
end

-- =============================================================
-- 3. PARTNER FINDER
-- =============================================================
function MSC.FindBestMainHand(weights, specName)
    local bestLink, bestScore, bestStats = nil, 0, {}
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local link = C_Container.GetContainerItemLink(bag, slot)
            if link then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                if equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND" then
                    if MSC.IsItemUsable(link) then
                        local stats = MSC.SafeGetItemStats(link, 16)
                        if stats then 
                            local score = MSC.GetItemScore(stats, weights, specName, 16)
                            if score > bestScore then bestScore = score; bestLink = link; bestStats = stats end 
                        end
                    end
                end
            end
        end
    end
    return bestLink, bestScore, bestStats
end

function MSC.FindBestOffhand(weights, specName)
    local bestLink, bestScore, bestStats = nil, 0, {}
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local link = C_Container.GetContainerItemLink(bag, slot)
            if link then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                if equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND" or equipLoc == "INVTYPE_WEAPON" then
                    if MSC.IsItemUsable(link) then
                        local stats = MSC.SafeGetItemStats(link, 17)
                        if stats then 
                            local score = MSC.GetItemScore(stats, weights, specName, 17)
                            if score > bestScore then bestScore = score; bestLink = link; bestStats = stats end 
                        end
                    end
                end
            end
        end
    end
    return bestLink, bestScore, bestStats
end

-- =============================================================
-- 4. ELVUI SKINNING
-- =============================================================
function MSC.ApplyElvUISkin(frame)
    if not frame then return end
    if C_AddOns.IsAddOnLoaded("ElvUI") then
        local E = unpack(ElvUI)
        if E and E.GetModule then
            local S = E:GetModule("Skins")
            if S and S.HandleFrame then S:HandleFrame(frame, true) end
        end
    end
end

-- =============================================================
-- 5. ITEM STAT SCANNER (UPDATED FOR OVERRIDES)
-- =============================================================
function MSC.SafeGetItemStats(itemLink, slotId, skipProjection)
    if not itemLink then return {} end
    
    local itemID = tonumber(string.match(itemLink, "item:(%d+)"))
    local override = itemID and MSC.ItemOverrides and MSC.ItemOverrides[itemID]
    local finalStats = {}

   -- [[ PATH A: REPLACEMENT (Ignore Scanner) ]]
    if override and override.replace then
        for k, v in pairs(override) do finalStats[k] = v end
        
        -- [[ LOGIC: DYNAMIC HEALTH CALCULATION ]]
        -- If the item has a "percent_hp_value" flag (like Lifegiving Gem), 
        -- we calculate that % of your CURRENT Max Health and convert it to Stamina.
        if finalStats.percent_hp_value then
            local currentMaxHP = UnitHealthMax("player") or 1
            local bonusHP = currentMaxHP * finalStats.percent_hp_value
            
            -- Convert Health to Stamina (approx 1 Stam = 10 HP) so weights can score it
            -- Example: 5000 HP * 0.30 (Buff+Heal) = 1500 Effective HP -> 150 Stamina
            finalStats["ITEM_MOD_STAMINA_SHORT"] = (finalStats["ITEM_MOD_STAMINA_SHORT"] or 0) + (bonusHP / 10)
        end

        -- Enchants still project on top
        if SGJ_Settings.ProjectEnchants and slotId and not skipProjection then
            local equippedLink = GetInventoryItemLink("player", slotId)
            if equippedLink ~= itemLink then 
                local enc = MSC.GetEnchantStats(slotId)
                for k,v in pairs(enc) do 
                    if k=="IS_PROJECTED" then finalStats.IS_PROJECTED=true else finalStats[k]=(finalStats[k] or 0)+v end 
                end
            end
        end
        return finalStats
    end

    -- [[ PATH B: SCANNER + ADDITIVE OVERRIDE ]]
    local stats = GetItemStats(itemLink) or {}
    local foundByAPI = {}
    for k, v in pairs(stats) do
        if v > 0 then finalStats[k] = v; foundByAPI[k] = true; foundByAPI[k:gsub("_SHORT","")] = true end
    end
    
	-- Smart Scan (Tooltip Parsing)
    -- Reuse a single frame to save memory
    local tipName = "MSC_ScannerTooltip"
    local tip = _G[tipName] or CreateFrame("GameTooltip", tipName, nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    tip:ClearLines() -- Reset the tooltip
    tip:SetHyperlink(itemLink)
    for i = 2, tip:NumLines() do
        local line = _G[tipName.."TextLeft"..i]; local text = line and line:GetText()
        if text then
            local s, v = MSC.ParseTooltipLine(text)
            if s and v and not foundByAPI[s] then finalStats[s] = (finalStats[s] or 0) + v end
        end
    end

    -- Add the Override (Hybrid Bonus)
    if override then
        for k, v in pairs(override) do
            if k == "estimate" then finalStats.estimate = true
            else finalStats[k] = (finalStats[k] or 0) + v end
        end
    end

    -- Project Enchant
    if SGJ_Settings.ProjectEnchants and slotId and not skipProjection then
        local equippedLink = GetInventoryItemLink("player", slotId)
        if equippedLink ~= itemLink then
            local enc = MSC.GetEnchantStats(slotId)
            for k,v in pairs(enc) do 
                if k=="IS_PROJECTED" then finalStats.IS_PROJECTED=true else finalStats[k]=(finalStats[k] or 0)+v end 
            end
        end
    end

    return finalStats
end

-- [[ NEW: DETECT TARGET SPEC (STRICTER) ]] --
function MSC.GetInspectSpec(unit)
    local _, classFilename = UnitClass(unit)
    if not classFilename then return "Default" end
    
    local bestTab = nil
    local maxPoints = -1
    local totalPointsFound = 0
    
    for i = 1, 3 do
        -- Get raw data
        local _, _, pointsSpent = GetTalentTabInfo(i, true)
        local points = tonumber(pointsSpent) or 0
        
        totalPointsFound = totalPointsFound + points
        
        if points > maxPoints then
            maxPoints = points
            bestTab = i
        end
    end
    
    -- SAFETY CHECK: If the target has 0 points total (or scan failed), return Default
    if totalPointsFound == 0 then return "Default" end

    -- Map the winning tab to a name (e.g., 3 -> "Retribution")
    if bestTab and MSC.SpecNames and MSC.SpecNames[classFilename] and MSC.SpecNames[classFilename][bestTab] then
        return MSC.SpecNames[classFilename][bestTab]
    end
    
    return "Default"
end