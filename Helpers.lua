local _, MSC = ...

-- =============================================================
-- 1. GENERAL HELPERS
-- =============================================================
-- New Table for "Short Form" Tooltip Text
MSC.StatShortNames = {
    ["ITEM_MOD_STAMINA_SHORT"] = "Stam",
    ["ITEM_MOD_INTELLECT_SHORT"] = "Int",
    ["ITEM_MOD_AGILITY_SHORT"] = "Agi",
    ["ITEM_MOD_STRENGTH_SHORT"] = "Str",
    ["ITEM_MOD_SPIRIT_SHORT"] = "Spt",
    ["ITEM_MOD_SPELL_POWER_SHORT"] = "SP",
    ["ITEM_MOD_HEALING_POWER_SHORT"] = "Heal",
    ["ITEM_MOD_MANA_REGENERATION_SHORT"] = "Mp5",
    ["ITEM_MOD_ATTACK_POWER_SHORT"] = "AP",
    ["ITEM_MOD_CRIT_RATING_SHORT"] = "Crit",
    ["ITEM_MOD_HIT_RATING_SHORT"] = "Hit",
    ["ITEM_MOD_HASTE_RATING_SHORT"] = "Haste",
    ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = "Exp",
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = "Def",
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = "Resil",
    ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = "ArP",
    ["ITEM_MOD_BLOCK_VALUE_SHORT"] = "BlockVal",
}

function MSC.GetCleanStatName(key)
    if MSC.ShortNames and MSC.ShortNames[key] then return MSC.ShortNames[key] end
    local clean = key:gsub("ITEM_MOD_", ""):gsub("_SHORT", ""):gsub("_", " "):lower()
    return clean:gsub("^%l", string.upper)
end

function MSC.IsItemUsable(link)
    if not link then return false end
    local _, _, _, _, _, _, _, _, equipLoc, _, _, classID, subclassID = GetItemInfo(link)
    local _, playerClass = UnitClass("player")
    
    if classID == 4 and subclassID == 0 then return true end
    if equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET" or equipLoc == "INVTYPE_NECK" or equipLoc == "INVTYPE_CLOAK" then return true end

    if classID == 4 then
        if subclassID == 6 then
            if playerClass == "WARRIOR" or playerClass == "PALADIN" or playerClass == "SHAMAN" then return true end
            return false
        end
        if subclassID == 7 then return (playerClass == "PALADIN") end
        if subclassID == 8 then return (playerClass == "DRUID") end
        if subclassID == 9 then return (playerClass == "SHAMAN") end
        if subclassID == 10 then return (playerClass == "DEATHKNIGHT") end
        
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
    
    if SGJ_Settings and SGJ_Settings.Mode and SGJ_Settings.Mode ~= "Auto" and classData[SGJ_Settings.Mode] then
        local displayName = SGJ_Settings.Mode
        if displayName == "Hybrid" then displayName = "Leveling (Manual)" end
        return classData[SGJ_Settings.Mode], displayName
    end

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
    
    local playerLevel = UnitLevel("player")
    if playerLevel < 70 then
        local isDungeonRole = false
        if englishClass == "WARRIOR" and specIndex == 3 then isDungeonRole = true end
        if englishClass == "PALADIN" and (specIndex == 1 or specIndex == 2) then isDungeonRole = true end
        if englishClass == "PRIEST" and (specIndex == 1 or specIndex == 2) then isDungeonRole = true end
        if englishClass == "SHAMAN" and specIndex == 3 then isDungeonRole = true end
        if englishClass == "DRUID" and specIndex == 3 then isDungeonRole = true end
        
        if not isDungeonRole then
            if playerLevel <= 20 and classData["Leveling_1_20"] then return classData["Leveling_1_20"], activeSpec .. " (Lv 1-20)"
            elseif playerLevel <= 40 and classData["Leveling_21_40"] then return classData["Leveling_21_40"], activeSpec .. " (Lv 21-40)"
            elseif playerLevel <= 57 and classData["Leveling_41_57"] then return classData["Leveling_41_57"], activeSpec .. " (Lv 41-57)"
            elseif playerLevel <= 69 and classData["Leveling_58_69"] then return classData["Leveling_58_69"], activeSpec .. " (Outland)"
            end
        end
    end
    return (classData[activeSpec] or classData["Default"]), activeSpec .. " (Auto)"
end

-- =============================================================
-- 2. SAFE ITEM STATS (The Engine)
-- =============================================================
function MSC.SafeGetItemStats(itemLink, slotId)
    if not itemLink then return {} end 
    local stats = GetItemStats(itemLink) or {}
    local finalStats = {}
    
    -- [[ STAT NORMALIZATION ]]
    for k, v in pairs(stats) do
        if k == "ITEM_MOD_SPELL_HEALING_DONE" then 
            finalStats["ITEM_MOD_HEALING_POWER_SHORT"] = (finalStats["ITEM_MOD_HEALING_POWER_SHORT"] or 0) + v
        elseif k == "ITEM_MOD_SPELL_DAMAGE_DONE" then
            finalStats["ITEM_MOD_SPELL_POWER_SHORT"] = (finalStats["ITEM_MOD_SPELL_POWER_SHORT"] or 0) + v
        else
            finalStats[k] = v
        end
    end
    
    -- [[ 1. GEM PROJECTION ]]
    local gemStats, hasSockets, bonusActive, gemText = MSC.ProjectGems(itemLink)
    if hasSockets then
        for k, v in pairs(gemStats) do finalStats[k] = (finalStats[k] or 0) + v end
        finalStats.GEMS_PROJECTED = gemStats.COUNT 
        finalStats.GEM_TEXT = gemText -- Store the text summary
        if bonusActive then finalStats.BONUS_PROJECTED = true end
    end
    
    -- [[ 2. ENCHANT PROJECTION ]]
    local enchantMode = SGJ_Settings and SGJ_Settings.EnchantMode or 3 
    if enchantMode == 2 then
        local found = string.match(itemLink, "item:%d+:(%d+):")
        if found and found ~= "0" then
            local enchID = tonumber(found)
            if MSC.EnchantDB[enchID] then
                for k, v in pairs(MSC.EnchantDB[enchID]) do finalStats[k] = (finalStats[k] or 0) + v end
            end
        end
    elseif enchantMode == 3 and slotId then
        local _, specName = MSC.GetCurrentWeights()
        local cleanSpec = string.match(specName, "^(%a+)") or "Default"
        local dbToUse = (UnitLevel("player") < 70) and MSC.BestEnchants_Leveling or MSC.BestEnchants
        if dbToUse[slotId] then
            local enchID = dbToUse[slotId][cleanSpec] or dbToUse[slotId]["Default"]
            if enchID and enchID > 0 and MSC.EnchantDB[enchID] then
                local eStats = MSC.EnchantDB[enchID]
                local txtParts = {}
                for k, v in pairs(eStats) do 
                    finalStats[k] = (finalStats[k] or 0) + v 
                    table.insert(txtParts, "+" .. v .. " " .. (MSC.StatShortNames[k] or "Stat"))
                end
                finalStats.IS_PROJECTED = true
                finalStats.ENCHANT_TEXT = table.concat(txtParts, "/")
            end
        end
    end
    
    -- [[ 3. RACIAL SYNERGY ]]
    local _, playerRace = UnitRace("player")
    if MSC.RacialTraits and MSC.RacialTraits[playerRace] then
        local _, _, _, _, _, _, itemSubType = GetItemInfo(itemLink)
        if itemSubType then
            local bonus = MSC.RacialTraits[playerRace][itemSubType]
            if bonus then
                finalStats[bonus.stat] = (finalStats[bonus.stat] or 0) + bonus.val
                finalStats.IS_PROJECTED = true
            end
        end
    end

    -- [[ 4. TEXT PARSING ]]
    if hasSockets or (slotId == 13) or (slotId == 11) or (slotId == 2) then 
        local tooltip = MSCScanTooltip
        if not tooltip then
            tooltip = CreateFrame("GameTooltip", "MSCScanTooltip", nil, "GameTooltipTemplate")
            tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
        end
        tooltip:ClearLines()
        tooltip:SetHyperlink(itemLink)
        
        for i = 2, tooltip:NumLines() do
            local lineObj = _G["MSCScanTooltipTextLeft"..i]
            if lineObj then
                local line = lineObj:GetText()
                if line then
                    if hasSockets and (SGJ_Settings.GemMode == 3) and string.find(line, "Socket Bonus:") then
                        local s, v = MSC.ParseStatText(line)
                        if s and v and not stats[s] then finalStats[s] = (finalStats[s] or 0) + v end
                    end
                end
            end
        end
    end
    
    return finalStats
end

-- =============================================================
-- 3. UTILITY FUNCTIONS
-- =============================================================
function MSC.ParseStatText(text)
    if not text then return nil end
    for pattern, statKey in pairs(MSC.ShortNames) do
        local val = string.match(text, "(%d+) " .. pattern)
        if not val then val = string.match(text, pattern .. " by (%d+)") end
        if not val then val = string.match(text, pattern .. " %+(%d+)") end
        if not val and statKey == "ITEM_MOD_MANA_REGENERATION_SHORT" then val = string.match(text, "(%d+) mana per 5 sec") end
        if val then return statKey, tonumber(val) end
    end
    return nil
end

function MSC.ProjectGems(itemLink)
    local gemMode = SGJ_Settings and SGJ_Settings.GemMode or 1
    if gemMode == 1 or gemMode == 2 then return {}, false, false, nil end
    
    local stats = { COUNT = 0 }
    local hasSockets = false
    local bonusMatch = true
    local gemCounts = {} -- Store text summary counts
    
    local baseStats = GetItemStats(itemLink)
    if not baseStats then return {}, false, false, nil end
    
    local db = (UnitLevel("player") < 70) and MSC.GemOptions_Leveling or MSC.GemOptions
    
    for key, count in pairs(baseStats) do
        if string.find(key, "EMPTY_SOCKET_") and count > 0 then
            hasSockets = true
            local gemData = nil
            if gemMode == 4 then 
                gemData = MSC.PickBestGem("EMPTY_SOCKET_RED")
                bonusMatch = false
            else 
                gemData = MSC.PickBestGem(key)
            end
            
            if gemData then
                stats.COUNT = stats.COUNT + count
                stats[gemData.stat] = (stats[gemData.stat] or 0) + (gemData.val * count)
                if gemData.stat2 then stats[gemData.stat2] = (stats[gemData.stat2] or 0) + (gemData.val2 * count) end
                
                -- Build Text Label
                local sName = MSC.StatShortNames[gemData.stat] or "Stat"
                local label = "+" .. gemData.val .. " " .. sName
                if gemData.stat2 then 
                    label = label .. "/+" .. gemData.val2 .. " " .. (MSC.StatShortNames[gemData.stat2] or "Stat")
                end
                gemCounts[label] = (gemCounts[label] or 0) + count
            end
        end
    end
    
    -- Compile the text summary
    local textParts = {}
    for label, count in pairs(gemCounts) do
        table.insert(textParts, count .. "x (" .. label .. ")")
    end
    local gemText = table.concat(textParts, ", ")
    
    return stats, hasSockets, bonusMatch, gemText
end

function MSC.PickBestGem(socketColor)
    local weights = MSC.GetCurrentWeights()
    if not weights then return nil end
    local db = (UnitLevel("player") < 70) and MSC.GemOptions_Leveling or MSC.GemOptions
    local options = db[socketColor]
    if not options then return nil end
    local bestGem, bestScore = nil, 0
    for _, gem in ipairs(options) do
        local score = (weights[gem.stat] or 0) * gem.val
        if gem.stat2 then score = score + ((weights[gem.stat2] or 0) * gem.val2) end
        if score > bestScore then bestScore = score; bestGem = gem end
    end
    return bestGem
end

function MSC.GetStatDifferences(new, old)
    local diffs = {}
    local seen = {}
    for k, v in pairs(new) do 
        if k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" and k ~= "GEM_TEXT" and k ~= "ENCHANT_TEXT" then
            local d = v - (old[k] or 0)
            if d ~= 0 then table.insert(diffs, { key=k, val=d }); seen[k] = true end
        end
    end
    for k, v in pairs(old) do
        if not seen[k] and k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" and k ~= "GEM_TEXT" and k ~= "ENCHANT_TEXT" then
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

function MSC.FindBestMainHand(weights, specName)
    local bestLink, bestScore, bestStats = nil, 0, {}
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local link = C_Container.GetContainerItemLink(bag, slot)
            if link and MSC.IsItemUsable(link) then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                if equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND" then
                    local stats = MSC.SafeGetItemStats(link, 16)
                    local score = MSC.GetItemScore(stats, weights, specName, 16)
                    if score > bestScore then bestScore = score; bestLink = link; bestStats = stats end
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
            if link and MSC.IsItemUsable(link) then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                if equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND" or equipLoc == "INVTYPE_WEAPON" then
                    local stats = MSC.SafeGetItemStats(link, 17)
                    local score = MSC.GetItemScore(stats, weights, specName, 17)
                    if score > bestScore then bestScore = score; bestLink = link; bestStats = stats end
                end
            end
        end
    end
    return bestLink, bestScore, bestStats
end

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