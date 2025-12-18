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

function MSC.GetCurrentWeights()
    local _, englishClass = UnitClass("player")
    if not englishClass then return {}, "Unknown" end
    local classData = MSC.WeightDB and MSC.WeightDB[englishClass]
    if not classData then return {}, "No Data" end
    
    -- MANUAL OVERRIDE (Always obeyed)
    if SGJ_Settings and SGJ_Settings.Mode and SGJ_Settings.Mode ~= "Auto" and classData[SGJ_Settings.Mode] then
        local displayName = SGJ_Settings.Mode
        if displayName == "Hybrid" then displayName = "Leveling (Manual)" end
        return classData[SGJ_Settings.Mode], displayName
    end

    -- DETECT SPEC
    local maxPoints, activeSpec = 0, "Default"
    local specIndex = 1
    if MSC.SpecNames and MSC.SpecNames[englishClass] then
        for i=1, 3 do
            local _, _, pointsSpent, _, previewPoints = GetTalentTabInfo(i)
            local totalPoints = (tonumber(pointsSpent) or 0) + (tonumber(previewPoints) or 0)
            if totalPoints > maxPoints then 
                maxPoints = totalPoints; activeSpec = MSC.SpecNames[englishClass][i]; specIndex = i
            end
        end
    end
    
    -- SMART LOGIC: "Dungeon Role" vs "Solo Leveling"
    local playerLevel = UnitLevel("player")
    if playerLevel < 60 then
        -- 1. IDENTIFY DUNGEON ROLES (Tanks & Healers)
        -- These players do NOT want generic leveling stats. They want their job stats.
        local isDungeonRole = false
        
        if englishClass == "WARRIOR" and specIndex == 3 then isDungeonRole = true end -- Protection
        if englishClass == "PALADIN" and (specIndex == 1 or specIndex == 2) then isDungeonRole = true end -- Holy or Prot
        if englishClass == "PRIEST" and (specIndex == 1 or specIndex == 2) then isDungeonRole = true end -- Disc or Holy
        if englishClass == "SHAMAN" and specIndex == 3 then isDungeonRole = true end -- Resto
        if englishClass == "DRUID" and specIndex == 3 then isDungeonRole = true end -- Resto
        if englishClass == "DRUID" and specIndex == 2 and GetTalentInfo(2, 5) and select(5, GetTalentInfo(2, 5)) > 0 then 
            -- Feral Tank Check (Thick Hide / Feral Instinct usually implies tanking interest, but simplified: Feral is usually DPS leveling)
            -- For simplicity, we treat Feral as Leveling unless explicitly Manual.
            isDungeonRole = false 
        end

        -- 2. APPLY LOGIC
        -- If NOT a Dungeon Role, use the smart Leveling Brackets we designed.
        if not isDungeonRole then
            if playerLevel <= 20 and classData["Leveling_1_20"] then
                return classData["Leveling_1_20"], activeSpec .. " (Lv 1-20)"
            elseif playerLevel <= 40 and classData["Leveling_21_40"] then
                return classData["Leveling_21_40"], activeSpec .. " (Lv 21-40)"
            elseif classData["Leveling_41_59"] then
                return classData["Leveling_41_59"], activeSpec .. " (Lv 41-59)"
            end
        end
        -- If they ARE a Dungeon Role (or Default fallback), they fall through to the specific spec below.
    end
    
    return (classData[activeSpec] or classData["Default"]), activeSpec .. " (Auto)"
end

-- =============================================================
-- 2. ITEM STAT SCANNER
-- =============================================================
function MSC.SafeGetItemStats(itemLink, slotId)
    if not itemLink then return {} end
    local stats = GetItemStats(itemLink) or {}
    local finalStats = {}
    local foundByAPI = {} 
    
    if MSC.ShortNames then
        for k, v in pairs(stats) do
            if MSC.ShortNames[k] then 
                finalStats[k] = v 
                foundByAPI[k] = true 
            else 
                finalStats[k] = v 
            end
        end
    end
    
    local tooltip = CreateFrame("GameTooltip", "MSCScanTooltip", nil, "GameTooltipTemplate")
    tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    tooltip:SetHyperlink(itemLink)
    for i = 2, tooltip:NumLines() do
        local line = _G["MSCScanTooltipTextLeft"..i]:GetText()
        if line then
            local s, v = MSC.ParseTooltipLine(line)
            if s and v then 
                if not foundByAPI[s] then
                    finalStats[s] = (finalStats[s] or 0) + v 
                end
            end
        end
    end
    
    if SGJ_Settings.ProjectEnchants and slotId then
        local _, _, _, existingEnchantID = string.find(itemLink, "item:(%d+):(%d+)")
        local hasEnchant = (existingEnchantID and tonumber(existingEnchantID) > 0)
        
        if not hasEnchant then
            local myEnchant = MSC.GetEnchantStats(slotId)
            for k, v in pairs(myEnchant) do
                finalStats[k] = (finalStats[k] or 0) + v
            end
            if next(myEnchant) then finalStats.IS_PROJECTED = true end
        end
    end
    return finalStats
end

-- =============================================================
-- 3. STAT COMPARISON TOOLS
-- =============================================================
function MSC.GetStatDifferences(new, old)
    local diffs = {}
    local seen = {}
    for k, v in pairs(new) do 
        if k ~= "IS_PROJECTED" then
            local d = v - (old[k] or 0)
            if d ~= 0 then table.insert(diffs, { key=k, val=d }); seen[k] = true end
        end
    end
    for k, v in pairs(old) do
        if not seen[k] and k ~= "IS_PROJECTED" then
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
-- 4. PARTNER FINDER
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
-- 5. ELVUI SKINNING
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