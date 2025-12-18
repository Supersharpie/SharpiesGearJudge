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
    
    -- 1. MANUAL OVERRIDE (Always obeyed)
    if SGJ_Settings and SGJ_Settings.Mode and SGJ_Settings.Mode ~= "Auto" and classData[SGJ_Settings.Mode] then
        local displayName = SGJ_Settings.Mode
        if displayName == "Hybrid" then displayName = "Leveling (Manual)" end
        return classData[SGJ_Settings.Mode], displayName
    end

    -- 2. DETECT SPEC (TBC / Vanilla Compatible)
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
    
    -- 3. SMART LEVELING LOGIC (TBC Update: Checks up to Level 70)
    local playerLevel = UnitLevel("player")
    if playerLevel < 70 then
        -- A. IDENTIFY DUNGEON ROLES (Tanks & Healers)
        local isDungeonRole = false
        if englishClass == "WARRIOR" and specIndex == 3 then isDungeonRole = true end -- Protection
        if englishClass == "PALADIN" and (specIndex == 1 or specIndex == 2) then isDungeonRole = true end -- Holy or Prot
        if englishClass == "PRIEST" and (specIndex == 1 or specIndex == 2) then isDungeonRole = true end -- Disc or Holy
        if englishClass == "SHAMAN" and specIndex == 3 then isDungeonRole = true end -- Resto
        if englishClass == "DRUID" and specIndex == 3 then isDungeonRole = true end -- Resto
        
        -- B. APPLY BRACKET LOGIC
        if not isDungeonRole then
            if playerLevel <= 20 and classData["Leveling_1_20"] then
                return classData["Leveling_1_20"], activeSpec .. " (Lv 1-20)"
            elseif playerLevel <= 40 and classData["Leveling_21_40"] then
                return classData["Leveling_21_40"], activeSpec .. " (Lv 21-40)"
            elseif playerLevel <= 57 and classData["Leveling_41_57"] then
                return classData["Leveling_41_57"], activeSpec .. " (Lv 41-57)"
            elseif playerLevel <= 69 and classData["Leveling_58_69"] then
                return classData["Leveling_58_69"], activeSpec .. " (Outland)"
            end
        end
    end
    
    -- 4. FALLBACK (Level 70 or Dungeon Role)
    return (classData[activeSpec] or classData["Default"]), activeSpec .. " (Auto)"
end

-- =============================================================
-- 2. ITEM STAT SCANNER (TBC Updated)
-- =============================================================
function MSC.SafeGetItemStats(itemLink, slotId)
    if not itemLink then return {} end
    local stats = GetItemStats(itemLink) or {}
    local finalStats = {}
    
    -- 1. BASE STATS
    if MSC.ShortNames then
        for k, v in pairs(stats) do
            if MSC.ShortNames[k] or k:find("EMPTY_SOCKET") then finalStats[k] = v else finalStats[k] = v end
        end
    end
    
    -- 2. Text Scan
    local tooltip = CreateFrame("GameTooltip", "MSCScanTooltip", nil, "GameTooltipTemplate")
    tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    tooltip:SetHyperlink(itemLink)
    
    local gemMode = SGJ_Settings.GemMode or 1
    
    for i = 2, tooltip:NumLines() do
        local lineObj = _G["MSCScanTooltipTextLeft"..i]
        local line = lineObj:GetText()
        if line then
            -- A. Standard Stat Parsing
            local s, v = MSC.ParseTooltipLine(line)
            if s and v then 
                if not foundByAPI[s] then
                    finalStats[s] = (finalStats[s] or 0) + v 
                end
            end
            
            -- B. Socket Bonus Parsing (Only if Matching Colors)
            if gemMode == 3 then -- Mode 3 = "Match Colors (Best)"
                local bStat, bVal = MSC.ParseSocketBonus(line)
                if bStat and bVal then
                     finalStats[bStat] = (finalStats[bStat] or 0) + bVal
                     finalStats.BONUS_PROJECTED = true
                end
            end
        end
    end
    
    local _, specName = MSC.GetCurrentWeights()
    local cleanSpec = specName:gsub(" %(.*%)", "") 

    -- =========================================================
    -- LOGIC: ENCHANTS (Smart Leveling Update)
    -- =========================================================
    local enchantMode = SGJ_Settings.EnchantMode or 1
    local playerLevel = UnitLevel("player")

    if enchantMode == 3 and slotId then
        local bestID = 0
        local targetEnchantTable = (playerLevel < 70) and MSC.BestEnchants_Leveling or MSC.BestEnchants
        local slotTable = targetEnchantTable and targetEnchantTable[slotId]
        if slotTable then
            bestID = slotTable[cleanSpec] or slotTable["Default"] or 0
        end
        
        if bestID > 0 then
            local enchantStats = MSC.EnchantDB[bestID]
            if enchantStats then
                for k, v in pairs(enchantStats) do
                    finalStats[k] = (finalStats[k] or 0) + v
                end
                finalStats.IS_PROJECTED = true
            end
        end
    end
    
    -- =========================================================
    -- LOGIC: GEMS (Smart Leveling Update)
    -- =========================================================
    -- gemMode was defined above (line 120)

    if gemMode == 2 then
        -- Mode 2: CURRENT ONLY (Already in GetItemStats)
        
    elseif gemMode == 3 or gemMode == 4 then
        -- Mode 3 (Match) & 4 (Ignore): FILL EMPTY SOCKETS
        local weights = MSC.GetCurrentWeights()
        local gemCount = 0
        
        -- SMART SWITCH: Use Green Gems if < 70, Blue Gems if 70
        local targetGemTable = (playerLevel < 70) and MSC.GemOptions_Leveling or MSC.GemOptions
        
        -- Identify the "Best Generic Gem" (for Mode 4 - Ignore Color)
        local bestGenericStat, bestGenericVal = nil, 0
        if gemMode == 4 then
            for _, list in pairs(targetGemTable or {}) do
                for _, gem in ipairs(list) do
                    -- SAFETY: Ignore Meta gems when finding generic best
                    if not gem.stat:find("META") then
                         local score = (weights[gem.stat] or 0) * gem.val
                         if score > bestGenericVal then bestGenericVal = score; bestGenericStat = gem end
                    end
                end
            end
        end

        for socketKey, gemList in pairs(targetGemTable or {}) do
            local socketCount = finalStats[socketKey] or 0
            
            -- A. META SOCKET (Always Unique Logic)
            if socketKey == "EMPTY_SOCKET_META" then
                 if socketCount > 0 then
                     local bestMeta, bestMetaScore = nil, 0
                     for _, gem in ipairs(gemList) do
                        local score = (weights[gem.stat] or 0) * gem.val
                        if score > bestMetaScore then bestMetaScore = score; bestMeta = gem end
                     end
                     -- Fallback: Pick first meta if all score 0 (e.g., Tank meta for Healer)
                     if not bestMeta and #gemList > 0 then bestMeta = gemList[1] end
                     
                     if bestMeta then
                        finalStats[bestMeta.stat] = (finalStats[bestMeta.stat] or 0) + (bestMeta.val * socketCount)
                        gemCount = gemCount + socketCount
                     end
                 end
            
            -- B. REGULAR SOCKETS (Red/Yellow/Blue)
            elseif socketCount > 0 then
                local bestGemForSlot = nil
                
                if gemMode == 3 then
                    -- MODE 3: MATCH COLORS
                    local bestVal = 0
                    for _, gem in ipairs(gemList) do
                        local score = (weights[gem.stat] or 0) * gem.val
                        if score > bestVal then bestVal = score; bestGemForSlot = gem end
                    end
                else
                    -- MODE 4: IGNORE COLORS (Use best generic)
                    bestGemForSlot = bestGenericStat
                end
                
                if bestGemForSlot then
                    finalStats[bestGemForSlot.stat] = (finalStats[bestGemForSlot.stat] or 0) + (bestGemForSlot.val * socketCount)
                    if bestGemForSlot.stat2 and bestGemForSlot.val2 then
                        finalStats[bestGemForSlot.stat2] = (finalStats[bestGemForSlot.stat2] or 0) + (bestGemForSlot.val2 * socketCount)
                    end
                    gemCount = gemCount + socketCount
                end
            end
        end
        if gemCount > 0 then finalStats.GEMS_PROJECTED = gemCount end
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
        if k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" then
            local d = v - (old[k] or 0)
            if d ~= 0 then table.insert(diffs, { key=k, val=d }); seen[k] = true end
        end
    end
    for k, v in pairs(old) do
        if not seen[k] and k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" then
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