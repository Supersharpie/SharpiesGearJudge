local _, MSC = ...

-- 1. TEXT PARSER
function MSC.ParseTooltipLine(text)
    if not text then return nil, 0 end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    local patterns = {
        { pattern = "%+(%d+)%%? Hit", stat = "ITEM_MOD_HIT_RATING_SHORT" },
        { pattern = "Increases your hit rating by (%d+)", stat = "ITEM_MOD_HIT_RATING_SHORT" },
        { pattern = "Increases your spell hit rating by (%d+)", stat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        { pattern = "%+(%d+)%%? Crit", stat = "ITEM_MOD_CRIT_RATING_SHORT" },
        { pattern = "Increases your critical strike rating by (%d+)", stat = "ITEM_MOD_CRIT_RATING_SHORT" },
        { pattern = "Increases your spell critical strike rating by (%d+)", stat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
        { pattern = "%+(%d+)%%? Dodge", stat = "ITEM_MOD_DODGE_RATING_SHORT" },
        { pattern = "%+(%d+)%%? Parry", stat = "ITEM_MOD_PARRY_RATING_SHORT" },
        { pattern = "%+(%d+)%%? Block", stat = "ITEM_MOD_BLOCK_RATING_SHORT" },
        { pattern = "defense rating by (%d+)", stat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { pattern = "mana per 5 sec", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { pattern = "Restores (%d+) mana", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { pattern = "Attack Power by (%d+)", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { pattern = "%+(%d+) Attack Power", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { pattern = "damage and healing done by magical spells and effects by up to (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "damage done by magical spells and effects by up to (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "healing done by spells and effects by up to (%d+)", stat = "ITEM_MOD_HEALING_POWER_SHORT" },
        { pattern = "Shadow damage by up to (%d+)", stat = "ITEM_MOD_SHADOW_DAMAGE_SHORT" },
        { pattern = "Fire damage by up to (%d+)", stat = "ITEM_MOD_FIRE_DAMAGE_SHORT" },
        { pattern = "Frost damage by up to (%d+)", stat = "ITEM_MOD_FROST_DAMAGE_SHORT" },
        { pattern = "Arcane damage by up to (%d+)", stat = "ITEM_MOD_ARCANE_DAMAGE_SHORT" },
        { pattern = "Nature damage by up to (%d+)", stat = "ITEM_MOD_NATURE_DAMAGE_SHORT" },
        { pattern = "Holy damage by up to (%d+)", stat = "ITEM_MOD_HOLY_DAMAGE_SHORT" },
        { pattern = "Agility by (%d+)", stat = "ITEM_MOD_AGILITY_SHORT" },
        { pattern = "Strength by (%d+)", stat = "ITEM_MOD_STRENGTH_SHORT" },
        { pattern = "Intellect by (%d+)", stat = "ITEM_MOD_INTELLECT_SHORT" },
        { pattern = "Spirit by (%d+)", stat = "ITEM_MOD_SPIRIT_SHORT" },
        { pattern = "Stamina by (%d+)", stat = "ITEM_MOD_STAMINA_SHORT" }
    }
    for _, p in ipairs(patterns) do
        local val = text:match(p.pattern)
        if val then return p.stat, tonumber(val) end
    end
    return nil, 0
end

-- 2. ENCHANT LOGIC
function MSC.GetEnchantStats(slotID)
    local link = GetInventoryItemLink("player", slotID)
    if not link then return {} end
    local _, _, enchantID = string.find(link, "item:%d+:(%d+)")
    enchantID = tonumber(enchantID)
    local enchantOnly = {}
    if enchantID and MSC.EnchantDB and MSC.EnchantDB[enchantID] then
        local data = MSC.EnchantDB[enchantID]
        for statKey, statVal in pairs(data) do
            enchantOnly[statKey] = statVal
        end
    end
    return enchantOnly
end

-- 3. CORE CALCULATIONS
function MSC.GetCurrentWeights()
    local _, englishClass = UnitClass("player")
    if not englishClass then return {}, "Unknown" end
    
    local classData = MSC.WeightDB and MSC.WeightDB[englishClass]
    if not classData then return {}, "No Data" end

    -- 1. MANUAL OVERRIDE
    if SGJ_Settings and SGJ_Settings.Mode and SGJ_Settings.Mode ~= "Auto" and classData[SGJ_Settings.Mode] then
        local displayName = SGJ_Settings.Mode
        if displayName == "Hybrid" then displayName = "Leveling / PvP" end
        return classData[SGJ_Settings.Mode], displayName .. " (Manual)"
    end

    -- 2. AUTO-DETECT SPEC
    local maxPoints, activeSpec = 0, "Default"
    local specIndex = 1
    if MSC.SpecNames and MSC.SpecNames[englishClass] then
        for i=1, 3 do
            local _, _, pointsSpent, _, previewPoints = GetTalentTabInfo(i)
            local totalPoints = (tonumber(pointsSpent) or 0) + (tonumber(previewPoints) or 0)
            if totalPoints > maxPoints then 
                maxPoints = totalPoints
                activeSpec = MSC.SpecNames[englishClass][i]
                specIndex = i
            end
        end
    end

    -- 3. SMART LEVELING LOGIC (< Level 60)
    local playerLevel = UnitLevel("player")
    if playerLevel < 60 then
        local isTankSpec = (englishClass == "PALADIN" and specIndex == 2) or (englishClass == "WARRIOR" and specIndex == 3)
        local isFeralCat = (englishClass == "DRUID" and specIndex == 2)
        if not isTankSpec and not isFeralCat and classData["Hybrid"] then
            return classData["Hybrid"], activeSpec .. " (Leveling)"
        end
    end

    return (classData[activeSpec] or classData["Default"]), activeSpec .. " (Auto)"
end

-- 4. HELPER FUNCTIONS
function MSC.SafeGetItemStats(itemLink, slotId)
    if not itemLink then return {} end
    local stats = GetItemStats(itemLink) or {}
    local finalStats = {}
    if MSC.ShortNames then
        for k, v in pairs(stats) do
            if MSC.ShortNames[k] then finalStats[k] = v else finalStats[k] = v end
        end
    end
    local tooltip = CreateFrame("GameTooltip", "MSCScanTooltip", nil, "GameTooltipTemplate")
    tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    tooltip:SetHyperlink(itemLink)
    for i = 2, tooltip:NumLines() do
        local line = _G["MSCScanTooltipTextLeft"..i]:GetText()
        if line then
            local s, v = MSC.ParseTooltipLine(line)
            if s and v then finalStats[s] = (finalStats[s] or 0) + v end
        end
    end
    if SGJ_Settings.ProjectEnchants and slotId then
        local myEnchant = MSC.GetEnchantStats(slotId)
        for k, v in pairs(myEnchant) do
            finalStats[k] = (finalStats[k] or 0) + v
        end
        if next(myEnchant) then finalStats.IS_PROJECTED = true end
    end
    return finalStats
end

function MSC.GetItemScore(stats, weights)
    if not stats or not weights then return 0 end
    local score = 0
    for stat, val in pairs(stats) do
        if weights[stat] then score = score + (val * weights[stat]) end
    end
    return score
end

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

function MSC.GetCleanStatName(key)
    if MSC.ShortNames and MSC.ShortNames[key] then return MSC.ShortNames[key] end
    local clean = key:gsub("ITEM_MOD_", ""):gsub("_SHORT", ""):gsub("_", " "):lower()
    return clean:gsub("^%l", string.upper)
end

function MSC.IsItemUsable(link)
    if not link then return false end
    local _, _, _, _, _, _, _, _, equipLoc, _, _, classID, subclassID = GetItemInfo(link)
    if classID == 4 then -- Armor
        local _, playerClass = UnitClass("player")
        if playerClass == "MAGE" or playerClass == "WARLOCK" or playerClass == "PRIEST" then
            if subclassID > 1 then return false end 
        elseif playerClass == "ROGUE" or playerClass == "DRUID" then
            if subclassID > 2 then return false end 
        elseif playerClass == "HUNTER" or playerClass == "SHAMAN" then
            if subclassID > 3 then return false end 
        end
    end
    return true
end

function MSC.GetEnchantString(slotId)
    local link = GetInventoryItemLink("player", slotId)
    if not link then return "" end
    local _, _, enchantID = string.find(link, "item:%d+:(%d+)")
    if enchantID and MSC.EnchantDB and MSC.EnchantDB[tonumber(enchantID)] then
        local data = MSC.EnchantDB[tonumber(enchantID)]
        for k, v in pairs(data) do
            local name = MSC.GetCleanStatName(k)
            return "+" .. v .. " " .. name 
        end
    end
    return ""
end

-- 5. SMART PARTNER FINDER
function MSC.FindBestMainHand(weights)
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
                            local score = MSC.GetItemScore(stats, weights)
                            if score > bestScore then bestScore = score; bestLink = link; bestStats = stats end
                        end
                    end
                end
            end
        end
    end
    return bestLink, bestScore, bestStats
end

function MSC.FindBestOffhand(weights)
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
                            local score = MSC.GetItemScore(stats, weights)
                            if score > bestScore then bestScore = score; bestLink = link; bestStats = stats end
                        end
                    end
                end
            end
        end
    end
    return bestLink, bestScore, bestStats
end