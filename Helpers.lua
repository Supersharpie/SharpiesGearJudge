local _, MSC = ...

-- =============================================================
-- 1. GENERAL HELPERS
-- =============================================================
function MSC.Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

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

-- =============================================================
-- 2. ADVANCED TEXT PARSER (The "Heavy Duty" Scanner)
-- =============================================================
function MSC.ParseTooltipLine(text)
    if not text then return nil, 0 end
    
    -- Filter out Set Bonuses (unless active/green) and passive descriptions
    if text:find("Set:") and not text:find("ff00ff00") then return nil, 0 end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    
    -- Ignore "Use" effects (usually temporary) but KEEP "Equip" lines
    if text:find("^Use:") or text:find("^Chance on hit:") or text:find("when fighting") then return nil, 0 end
    
    local patterns = {
        -- [[ 1. SPEED ]]
        { pattern = "Speed (%d+%.%d+)", stat = "MSC_WEAPON_SPEED" },
        -- [[ 2. RANGED ATTACK POWER ]]
        { pattern = "ranged attack power.-by (%d+)", stat = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" },
        { pattern = "%+(%d+) Ranged Attack Power", stat = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" },
        -- [[ 3. SPECIFIC SCHOOLS - LONG FORM ]]
        { pattern = "damage done by Shadow.-up to (%d+)", stat = "ITEM_MOD_SHADOW_DAMAGE_SHORT" },
        { pattern = "damage done by Fire.-up to (%d+)", stat = "ITEM_MOD_FIRE_DAMAGE_SHORT" },
        { pattern = "damage done by Frost.-up to (%d+)", stat = "ITEM_MOD_FROST_DAMAGE_SHORT" },
        { pattern = "damage done by Arcane.-up to (%d+)", stat = "ITEM_MOD_ARCANE_DAMAGE_SHORT" },
        { pattern = "damage done by Nature.-up to (%d+)", stat = "ITEM_MOD_NATURE_DAMAGE_SHORT" },
        { pattern = "damage done by Holy.-up to (%d+)", stat = "ITEM_MOD_HOLY_DAMAGE_SHORT" },
        -- [[ 4. SPECIFIC SCHOOLS - SHORT FORM ]]
        { pattern = "Shadow damage.-up to (%d+)", stat = "ITEM_MOD_SHADOW_DAMAGE_SHORT" },
        { pattern = "Fire damage.-up to (%d+)", stat = "ITEM_MOD_FIRE_DAMAGE_SHORT" },
        { pattern = "Frost damage.-up to (%d+)", stat = "ITEM_MOD_FROST_DAMAGE_SHORT" },
        { pattern = "Arcane damage.-up to (%d+)", stat = "ITEM_MOD_ARCANE_DAMAGE_SHORT" },
        { pattern = "Nature damage.-up to (%d+)", stat = "ITEM_MOD_NATURE_DAMAGE_SHORT" },
        { pattern = "Holy damage.-up to (%d+)", stat = "ITEM_MOD_HOLY_DAMAGE_SHORT" },
        -- [[ 5. GENERIC SPELL POWER & HEALING ]]
        { pattern = "damage and healing.-up to (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "magical spells.-up to (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "healing done.-up to (%d+)", stat = "ITEM_MOD_HEALING_POWER_SHORT" },
        { pattern = "spells and effects.-up to (%d+)", stat = "ITEM_MOD_HEALING_POWER_SHORT" },
        -- [[ 6. CRIT & HIT ]]
        { pattern = "critical strike.-spells.-(%d+)%%", stat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
        { pattern = "critical strike.-(%d+)%%", stat = "ITEM_MOD_CRIT_RATING_SHORT" },
        { pattern = "hit.-spells.-(%d+)%%", stat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        { pattern = "hit.-(%d+)%%", stat = "ITEM_MOD_HIT_RATING_SHORT" },
        -- [[ 7. MP5 / HP5 ]]
        { pattern = "(%d+) mana per 5 sec", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { pattern = "(%d+) health per 5 sec", stat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
        { pattern = "Restores (%d+) health", stat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" }, 
        { pattern = "Restores (%d+) mana", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        -- [[ 8. ATTACK POWER ]]
        { pattern = "Attack Power by (%d+)", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { pattern = "Attack Power in Cat, Bear", stat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" }, 
        { pattern = "%+(%d+) Attack Power", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        -- [[ 9. BASIC STATS ]]
        { pattern = "%+(%d+) Stamina", stat = "ITEM_MOD_STAMINA_SHORT" },
        { pattern = "%+(%d+) Intellect", stat = "ITEM_MOD_INTELLECT_SHORT" },
        { pattern = "%+(%d+) Spirit", stat = "ITEM_MOD_SPIRIT_SHORT" },
        { pattern = "%+(%d+) Strength", stat = "ITEM_MOD_STRENGTH_SHORT" },
        { pattern = "%+(%d+) Agility", stat = "ITEM_MOD_AGILITY_SHORT" },
        -- [[ 10. MISSING ENCHANTS / EXTRAS ]]
        { pattern = "%+(%d+) Health", stat = "ITEM_MOD_HEALTH_SHORT" },
        { pattern = "Health %+(%d+)", stat = "ITEM_MOD_HEALTH_SHORT" },
        { pattern = "%+(%d+) Mana", stat = "ITEM_MOD_MANA_SHORT" },
        { pattern = "Mana %+(%d+)", stat = "ITEM_MOD_MANA_SHORT" },
        { pattern = "%+(%d+) Armor", stat = "ITEM_MOD_ARMOR_SHORT" }, 
        { pattern = "Armor %+(%d+)", stat = "ITEM_MOD_ARMOR_SHORT" },
        { pattern = "%+(%d+) Block", stat = "ITEM_MOD_BLOCK_VALUE_SHORT" },
        { pattern = "%+(%d+) Damage", stat = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
        { pattern = "%+(%d+) Weapon Damage", stat = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
        { pattern = "%+(%d+) Defense", stat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { pattern = "%+(%d+) All Stats", stat = "ITEM_MOD_STATS_ALL_SHORT" },
        -- [[ 11. FALLBACK ]]
        { pattern = "up to (%d+)%.?$", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
    }
    for _, p in ipairs(patterns) do
        local val = text:match(p.pattern)
        if val then return p.stat, tonumber(val) end
    end
    return nil, 0
end

-- =============================================================
-- 3. ITEM STAT SCANNER
-- =============================================================
function MSC.SafeGetItemStats(itemLink, slotId, skipProjection)
    if not itemLink then return {} end
    
    local itemID = tonumber(string.match(itemLink, "item:(%d+)"))
    local override = itemID and MSC.ItemOverrides and MSC.ItemOverrides[itemID]
    local finalStats = {}

   -- [[ PATH A: REPLACEMENT ]]
    if override and override.replace then
        for k, v in pairs(override) do finalStats[k] = v end
        if finalStats.percent_hp_value then
            local currentMaxHP = UnitHealthMax("player") or 1
            local bonusHP = currentMaxHP * finalStats.percent_hp_value
            finalStats["ITEM_MOD_STAMINA_SHORT"] = (finalStats["ITEM_MOD_STAMINA_SHORT"] or 0) + (bonusHP / 10)
        end
        return finalStats
    end

    -- [[ PATH B: SCANNER ]]
    local stats = GetItemStats(itemLink) or {}
    local foundByAPI = {}
    for k, v in pairs(stats) do
        if v > 0 then finalStats[k] = v; foundByAPI[k] = true; foundByAPI[k:gsub("_SHORT","")] = true end
    end
    
    local tipName = "MSC_ScannerTooltip"
    local tip = _G[tipName] or CreateFrame("GameTooltip", tipName, nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    tip:ClearLines()
    tip:SetHyperlink(itemLink)
    for i = 2, tip:NumLines() do
        local line = _G[tipName.."TextLeft"..i]; local text = line and line:GetText()
        if text then
            local s, v = MSC.ParseTooltipLine(text)
            if s and v and not foundByAPI[s] then finalStats[s] = (finalStats[s] or 0) + v end
        end
    end

    -- [[ "ALL STATS" EXPANSION ]] --
    if finalStats["ITEM_MOD_STATS_ALL_SHORT"] then
        local bonus = finalStats["ITEM_MOD_STATS_ALL_SHORT"]
        finalStats["ITEM_MOD_STRENGTH_SHORT"] = (finalStats["ITEM_MOD_STRENGTH_SHORT"] or 0) + bonus
        finalStats["ITEM_MOD_AGILITY_SHORT"]  = (finalStats["ITEM_MOD_AGILITY_SHORT"] or 0) + bonus
        finalStats["ITEM_MOD_STAMINA_SHORT"]  = (finalStats["ITEM_MOD_STAMINA_SHORT"] or 0) + bonus
        finalStats["ITEM_MOD_INTELLECT_SHORT"]= (finalStats["ITEM_MOD_INTELLECT_SHORT"] or 0) + bonus
        finalStats["ITEM_MOD_SPIRIT_SHORT"]   = (finalStats["ITEM_MOD_SPIRIT_SHORT"] or 0) + bonus
    end

    if override then
        for k, v in pairs(override) do
            if k == "estimate" then finalStats.estimate = true
            else finalStats[k] = (finalStats[k] or 0) + v end
        end
    end

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

-- =============================================================
-- 4. ENCHANT HELPERS (Projecting Enchants)
-- =============================================================
local function GetEnchantTipLines(link)
    if not link then return {} end
    local lines = {}
    local tipName = "MSC_EnchantScanner_" .. math.random(100000)
    local tip = CreateFrame("GameTooltip", tipName, nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    tip:SetHyperlink(link)
    for i=2, tip:NumLines() do
        local left = _G[tipName.."TextLeft"..i]
        if left then 
            local text = left:GetText()
            if text and text ~= "" and not text:find("Durability") and not text:find("Classes:") and not text:find("Requires") and not text:find("Set:") and not text:find("Equip:") and not text:find("Chance on hit:") then
                local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                lines[cleanText] = true
            end
        end
    end
    return lines
end

function MSC.GetEnchantStats(slotId)
    local equipLink = GetInventoryItemLink("player", slotId)
    if not equipLink then return {} end
    local linkParts = { strsplit(":", equipLink) }
    local enchantID = tonumber(linkParts[3]) or 0
    if enchantID == 0 then return {} end
    local entry = MSC.EnchantDB[enchantID]
    if entry then
        local backup = {}
        if entry.stats then for k, v in pairs(entry.stats) do backup[k] = v end
        else for k, v in pairs(entry) do backup[k] = v end end
        backup.IS_PROJECTED = true
        return backup
    end
    local enchantedLines = GetEnchantTipLines(equipLink)
    linkParts[3] = 0
    local baseLink = table.concat(linkParts, ":")
    local baseLines = GetEnchantTipLines(baseLink)
    local enchantText = nil
    for text, _ in pairs(enchantedLines) do if not baseLines[text] then enchantText = text; break end end
    if enchantText and MSC.ParseTooltipLine then
        local statKey, statVal = MSC.ParseTooltipLine(enchantText)
        if statKey and statVal and statVal > 0 then return { [statKey] = statVal, IS_PROJECTED = true } end
    end
    return {}
end

function MSC.GetEnchantString(slotId)
    local equipLink = GetInventoryItemLink("player", slotId)
    if not equipLink then return "" end
    local linkParts = { strsplit(":", equipLink) }
    local enchantID = tonumber(linkParts[3]) or 0
    if enchantID == 0 then return "" end
    local entry = MSC.EnchantDB[enchantID]
    if entry then
        if entry.name then return entry.name end
        return "Enchant #" .. enchantID
    end
    local enchantedLines = GetEnchantTipLines(equipLink)
    linkParts[3] = 0
    local baseLink = table.concat(linkParts, ":")
    local baseLines = GetEnchantTipLines(baseLink)
    for text, _ in pairs(enchantedLines) do if not baseLines[text] then return text end end
    return ""
end

-- =============================================================
-- 5. SCORING & MATH (Merged from Scoring.lua)
-- =============================================================

function MSC.GetInterpolatedRatio(table, level)
    if not table then return nil end
    if level <= table[1][1] then return table[1][2] end
    local count = #table
    if level >= table[count][1] then return table[count][2] end
    for i = 1, count - 1 do
        local lowNode, highNode = table[i], table[i+1]
        if level >= lowNode[1] and level <= highNode[1] then
            local range = highNode[1] - lowNode[1]
            local progress = (level - lowNode[1]) / range
            local valDiff = highNode[2] - lowNode[2]
            return lowNode[2] + (progress * valDiff)
        end
    end
    return table[count][2]
end

function MSC.GetItemScore(stats, weights, specName, slotId)
    if not stats or not weights then return 0 end
    local score = 0
    
    -- 1. Base Score
    for stat, val in pairs(stats) do
        if weights[stat] then score = score + (val * weights[stat]) end
    end
    
    -- 2. Weapon Speed Bonus
    if stats.MSC_WEAPON_SPEED and MSC.SpeedChecks then
        local _, class = UnitClass("player")
        local pref = MSC.SpeedChecks[class] and (MSC.SpeedChecks[class][specName] or MSC.SpeedChecks[class]["Default"])
        if pref then
            local speed = stats.MSC_WEAPON_SPEED
            local bonus = 20 
            if slotId == 16 then
                if pref.MH_Slow and speed >= 2.6 then score = score + bonus end
                if pref.MH_Fast and speed <= 1.6 then score = score + bonus end
            end
            if slotId == 17 then
                if pref.OH_Fast and speed <= 1.7 then score = score + bonus end
                if pref.OH_Slow and speed >= 2.4 then score = score + bonus end
            end
            if slotId == 18 and pref.Ranged_Slow and speed >= 2.8 then score = score + bonus end
        end
    end
    return MSC.Round(score, 1)
end

function MSC.ExpandDerivedStats(stats, itemLink)
    if not stats then return {} end
    local out = {}
    for k, v in pairs(stats) do out[k] = v end
    local _, class = UnitClass("player")
    local _, race = UnitRace("player")
    local powerType = UnitPowerType("player")
    
    -- 1. RACIAL WEAPON SKILL
    if itemLink and MSC.RacialTraits and MSC.RacialTraits[race] then
        local _, _, _, _, _, _, _, _, _, _, _, _, subclassID = GetItemInfo(itemLink)
        if subclassID and MSC.RacialTraits[race][subclassID] then
            local bonus = MSC.RacialTraits[race][subclassID]
            out["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = (out["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] or 0) + bonus
        end
    end

    -- 2. BASIC CONVERSIONS (Stam->HP, Int->Mana)
    if out["ITEM_MOD_STAMINA_SHORT"] then 
        out["ITEM_MOD_HEALTH_SHORT"] = (out["ITEM_MOD_HEALTH_SHORT"] or 0) + (out["ITEM_MOD_STAMINA_SHORT"] * 10) 
    end
    if powerType == 0 and out["ITEM_MOD_INTELLECT_SHORT"] then 
        out["ITEM_MOD_MANA_SHORT"] = (out["ITEM_MOD_MANA_SHORT"] or 0) + (out["ITEM_MOD_INTELLECT_SHORT"] * 15) 
    end
    
    -- 3. CRIT SCALING (For Tooltip Display Only)
    local ratioTable = MSC.StatToCritMatrix and MSC.StatToCritMatrix[class]
    local myLevel = UnitLevel("player")
    if ratioTable then
        if ratioTable.Agi and out["ITEM_MOD_AGILITY_SHORT"] then
            local ratio = MSC.GetInterpolatedRatio(ratioTable.Agi, myLevel)
            if ratio and ratio > 0 then
                local critVal = out["ITEM_MOD_AGILITY_SHORT"] / ratio
                if critVal > 0 then
                    out["ITEM_MOD_CRIT_FROM_STATS_SHORT"] = (out["ITEM_MOD_CRIT_FROM_STATS_SHORT"] or 0) + critVal
                end
            end
        end
        if ratioTable.Int and out["ITEM_MOD_INTELLECT_SHORT"] then
             local ratio = MSC.GetInterpolatedRatio(ratioTable.Int, myLevel)
             if ratio and ratio > 0 then
                 local spellCritVal = out["ITEM_MOD_INTELLECT_SHORT"] / ratio
                 if spellCritVal > 0 then
                     out["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] = (out["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] or 0) + spellCritVal
                 end
             end
        end
    end
    return out
end

-- =============================================================
-- 6. UTILITIES (Comparison, Sorting, Inspection)
-- =============================================================
function MSC.GetStatDifferences(new, old)
    local diffs = {}
    local seen = {}
    for k, v in pairs(new) do 
        if k ~= "IS_PROJECTED" and type(v) == "number" then
            local d = v - (old[k] or 0)
            if d ~= 0 then table.insert(diffs, { key=k, val=d }); seen[k] = true end
        end
    end
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

function MSC.GetInspectSpec(unit)
    local _, classFilename = UnitClass(unit)
    if not classFilename then return "Default" end
    local bestTab, maxPoints, totalPointsFound = nil, -1, 0
    for i = 1, 3 do
        local _, _, pointsSpent = GetTalentTabInfo(i, true)
        local points = tonumber(pointsSpent) or 0
        totalPointsFound = totalPointsFound + points
        if points > maxPoints then maxPoints = points; bestTab = i end
    end
    if totalPointsFound == 0 then return "Default" end
    if bestTab and MSC.SpecNames and MSC.SpecNames[classFilename] and MSC.SpecNames[classFilename][bestTab] then
        return MSC.SpecNames[classFilename][bestTab]
    end
    return "Default"
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