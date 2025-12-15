local _, MSC = ...

local RacialTraits = {
    ["Human"]  = { ["Swords"] = true, ["Two-Handed Swords"] = true, ["Maces"] = true, ["Two-Handed Maces"] = true },
    ["Orc"]    = { ["Axes"] = true, ["Two-Handed Axes"] = true },
    ["Dwarf"]  = { ["Guns"] = true },
    ["Troll"]  = { ["Bows"] = true, ["Thrown"] = true },
}

local SpeedChecks = {
    ["WARRIOR"] = { MH_Slow = true, OH_Fast = false },
    ["PALADIN"] = { MH_Slow = true, OH_Fast = false },
    ["ROGUE"]   = { MH_Slow = true, OH_Fast = true },
    ["HUNTER"]  = { Ranged_Slow = true }
}

local function GetEnchantStats(slotID)
    local link = GetInventoryItemLink("player", slotID)
    if not link then return {} end
    local totalStats = GetItemStats(link) or {}
    local baseLink = link:gsub("(item:%d+):%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:(%d+)", "%1::::::::::::%2")
    local baseStats = GetItemStats(baseLink) or {}
    local enchantOnly = {}
    for stat, value in pairs(totalStats) do
        local diff = value - (baseStats[stat] or 0)
        if diff > 0 then enchantOnly[stat] = diff end
    end
    return enchantOnly
end

function MSC.SafeGetItemStats(itemLink, slotID)
    local baseLink = itemLink:gsub("(item:%d+):%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:(%d+)", "%1::::::::::::%2")
    local stats = GetItemStats(baseLink) or {}
    if SGJ_Settings.ProjectEnchants and slotID then
        local projected = GetEnchantStats(slotID)
        for stat, val in pairs(projected) do stats[stat] = (stats[stat] or 0) + val; stats["IS_PROJECTED"] = 1 end
    elseif SGJ_Settings.IncludeEnchants then
        stats = GetItemStats(itemLink) or {}
    end
    local _, _, _, _, _, classID, subclassID = GetItemInfoInstant(itemLink)
    if classID == 2 then 
        local race = UnitRace("player")
        local subClassName = C_Item.GetItemSubClassInfo(classID, subclassID)
        if RacialTraits[race] and RacialTraits[race][subClassName] then stats["RACIAL_BONUS"] = 1 end
        local _, englishClass = UnitClass("player")
        local pref = SpeedChecks[englishClass]
        if pref then
            local _, _, _, _, _, _, _, _, equipLoc, _, _, _, _, _, _, _, _, speed = GetItemInfo(itemLink)
            if speed then
                if (equipLoc == "INVTYPE_WEAPONMAINHAND" or equipLoc == "INVTYPE_2HWEAPON" or equipLoc == "INVTYPE_WEAPON") and pref.MH_Slow and speed >= 2.60 then stats["SPEED_OPTIMAL"] = 1
                elseif (equipLoc == "INVTYPE_WEAPONOFFHAND" or equipLoc == "INVTYPE_WEAPON") and pref.OH_Fast and speed <= 1.80 then stats["SPEED_OPTIMAL"] = 1
                elseif (equipLoc == "INVTYPE_RANGED" or equipLoc == "INVTYPE_RANGEDRIGHT") and pref.Ranged_Slow and speed >= 2.80 then stats["SPEED_OPTIMAL"] = 1 end
            end
        end
    end
    return stats
end

function MSC.GetItemScore(stats, weights)
    local totalScore = 0
    for statKey, statValue in pairs(stats) do
        if statKey == "RACIAL_BONUS" then totalScore = totalScore + 50
        elseif statKey == "SPEED_OPTIMAL" then totalScore = totalScore + 40
        else totalScore = totalScore + (statValue * (weights[statKey] or 0)) end
    end
    return totalScore
end

function MSC.GetStatDifferences(newStats, oldStats)
    local diffTable = {}
    for k, v in pairs(newStats) do diffTable[k] = (diffTable[k] or 0) + v end
    for k, v in pairs(oldStats) do diffTable[k] = (diffTable[k] or 0) - v end
    return diffTable
end

function MSC.SortStatDiffs(diffTable)
    local sorted = {}
    for k, v in pairs(diffTable) do if v ~= 0 then table.insert(sorted, { key = k, val = v }) end end
    table.sort(sorted, function(a, b) return a.val > b.val end)
    return sorted
end

function MSC.GetCleanStatName(key)
    if key == "IS_PROJECTED" then return "|cff00ffff(Projected Enchant)|r" end
    if key == "RACIAL_BONUS" then return "Racial Synergy" end
    if key == "SPEED_OPTIMAL" then return "Optimal Speed" end
    if MSC.ShortNames[key] then return MSC.ShortNames[key] end
    local rawName = _G[key] or key
    rawName = rawName:gsub("%%s", ""):gsub("%%d", ""):gsub("%.", ""):gsub("by up to", ""):gsub("Increases", ""):gsub(" by$", ""):gsub(" by ", " ")
    return strtrim(rawName)
end

function MSC.GetCurrentWeights()
    local _, englishClass = UnitClass("player")
    if not englishClass then return {}, "Unknown" end
    local classData = MSC.WeightDB[englishClass]
    if SGJ_Settings and SGJ_Settings.Mode and SGJ_Settings.Mode ~= "Auto" and classData[SGJ_Settings.Mode] then
        return classData[SGJ_Settings.Mode], SGJ_Settings.Mode .. " (Manual)"
    end
    local maxPoints, activeSpec = 0, "Default"
    if MSC.SpecNames[englishClass] then
        for i=1, 3 do
            local _, _, pointsSpent, _, previewPoints = GetTalentTabInfo(i)
            local totalPoints = (tonumber(pointsSpent) or 0) + (tonumber(previewPoints) or 0)
            if totalPoints > maxPoints then maxPoints = totalPoints; activeSpec = MSC.SpecNames[englishClass][i] end
        end
    end
    return (classData[activeSpec] or classData["Default"]), activeSpec .. " (Auto)"
end

function MSC.FindBestOffhand(weights)
    local bestScore, bestLink, bestStats = 0, nil, {}
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.hyperlink then
                local equipLoc = select(9, GetItemInfo(info.hyperlink))
                if equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND" then
                    local stats = MSC.SafeGetItemStats(info.hyperlink, 17)
                    local score = MSC.GetItemScore(stats, weights)
                    if score > bestScore then bestScore, bestLink, bestStats = score, info.hyperlink, stats end
                end
            end
        end
    end
    return bestLink, bestScore, bestStats
end

function MSC.FindBestMainHand(weights)
    local bestScore, bestLink, bestStats = 0, nil, {}
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.hyperlink then
                local equipLoc = select(9, GetItemInfo(info.hyperlink))
                if equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND" then
                    local stats = MSC.SafeGetItemStats(info.hyperlink, 16)
                    local score = MSC.GetItemScore(stats, weights)
                    if score > bestScore then bestScore, bestLink, bestStats = score, info.hyperlink, stats end
                end
            end
        end
    end
    return bestLink, bestScore, bestStats
end

function MSC.ApplyElvUISkin(frame)
    if not _G["ElvUI"] then return end
    local E = unpack(_G["ElvUI"]); local S = E:GetModule('Skins')
    if frame.icon then S:HandleItemButton(frame, true) end
end