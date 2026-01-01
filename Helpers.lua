local _, MSC = ...

-- =============================================================
-- 1. GENERAL HELPERS
-- =============================================================
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
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = "SpellCrit",
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = "SpellHit",
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = "Shadow",
    ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = "Fire",
    ["ITEM_MOD_FROST_DAMAGE_SHORT"] = "Frost",
    ["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = "Arcane",
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = "Nature",
    ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = "Holy",
}

function MSC.Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function MSC.GetCleanStatName(key)
    if MSC.StatShortNames and MSC.StatShortNames[key] then return MSC.StatShortNames[key] end
    local clean = key:gsub("ITEM_MOD_", ""):gsub("_SHORT", ""):gsub("_", " "):lower()
    return clean:gsub("^%l", string.upper)
end

-- HELPER 1: Check if class can wear item
function MSC.IsItemUsable(link)
    if not link then return false end
    local _, _, _, _, _, _, _, _, equipLoc, _, _, classID, subclassID = GetItemInfo(link)
    local _, playerClass = UnitClass("player")
    
    if classID == 4 then -- Armor
        -- Cloth Users (Subclass 1)
        if playerClass == "MAGE" or playerClass == "WARLOCK" or playerClass == "PRIEST" then 
            if subclassID > 1 then return false end 
        -- Leather Users (Subclass 2)
        elseif playerClass == "ROGUE" or playerClass == "DRUID" then 
            if subclassID > 2 then return false end 
        -- Mail Users (Subclass 3)
        elseif playerClass == "HUNTER" or playerClass == "SHAMAN" then 
            if subclassID > 3 then return false end 
        end
    end
    
    if classID == 2 and MSC.ValidWeapons and MSC.ValidWeapons[playerClass] then
        if not MSC.ValidWeapons[playerClass][subclassID] then return false end
    end
    return true
end

-- HELPER 2: Determines what kind of enchant an item can accept
function MSC:GetValidEnchantType(itemLink)
    if not itemLink then return nil end
    local _, _, _, _, _, itemClass, itemSubClassID, _, itemEquipLoc = GetItemInfo(itemLink)
    
    -- 1. Ranged Weapons (Scopes)
    if itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_RANGEDRIGHT" then
        if itemSubClassID == 2 or itemSubClassID == 3 or itemSubClassID == 18 then return "SCOPE" end
        return nil 
    end
    -- 2. Shields
    if itemEquipLoc == "INVTYPE_SHIELD" then return "SHIELD" end
    -- 3. Held In Off-Hand (Cannot enchant)
    if itemEquipLoc == "INVTYPE_HOLDABLE" then return nil end
    -- 4. 2-Handed Weapons
    if itemEquipLoc == "INVTYPE_2HWEAPON" then return "2H_WEAPON" end
    -- 5. 1-Handed Weapons
    if itemClass == 2 then return "WEAPON" end
    
    return "ARMOR"
end

-- =============================================================
-- 2. TBC STAT PARSER (Smart Bonus Detection)
-- =============================================================
function MSC.ParseTooltipLine(text)
    if not text then return nil, 0, false end
    
    -- [[ 1. CRITICAL FIX: Sanitize Newlines/Wrapping ]]
    text = text:gsub("\n", " "):gsub("%s+", " ")

    -- [[ 2. Set Bonus Filter ]]
    if text:find("Set:") and not text:find("ff00ff00") then return nil, 0, false end
    
    -- [[ 3. Socket Bonus Detection ]]
    local isSocketBonus = false
    if text:find("Socket Bonus:") then isSocketBonus = true end

    -- Remove Color Codes
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    
    -- [[ 4. Ignore Active/Temporary Effects ]]
    if text:find("^Use:") or text:find("^Chance on hit:") then return nil, 0, false end
    
    local patterns = {
        -- [[ TBC RATINGS ]]
        { pattern = "hit rating by (%d+)", stat = "ITEM_MOD_HIT_RATING_SHORT" },
        { pattern = "spell hit rating by (%d+)", stat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        { pattern = "critical strike rating by (%d+)", stat = "ITEM_MOD_CRIT_RATING_SHORT" },
        { pattern = "spell critical strike rating by (%d+)", stat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
        { pattern = "haste rating by (%d+)", stat = "ITEM_MOD_HASTE_RATING_SHORT" },
        { pattern = "spell haste rating by (%d+)", stat = "ITEM_MOD_SPELL_HASTE_RATING_SHORT" },
        { pattern = "resilience rating by (%d+)", stat = "ITEM_MOD_RESILIENCE_RATING_SHORT" },
        { pattern = "expertise rating by (%d+)", stat = "ITEM_MOD_EXPERTISE_RATING_SHORT" }, 
        { pattern = "ignore (%d+) of your opponent's armor", stat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" },
        
        -- [[ SIMPLIFIED SPELL POWER ]]
        { pattern = "Increases spell power by (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "Increases attack power by (%d+)", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { pattern = "Increases healing by (%d+)", stat = "ITEM_MOD_HEALING_POWER_SHORT" },

        -- [[ CLASSIC / LEGACY ]]
        { pattern = "Speed (%d+%.%d+)", stat = "MSC_WEAPON_SPEED" },
        { pattern = "ranged attack power.-by (%d+)", stat = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" },
        { pattern = "Shadow damage.-up to (%d+)", stat = "ITEM_MOD_SHADOW_DAMAGE_SHORT" },
        { pattern = "Fire damage.-up to (%d+)", stat = "ITEM_MOD_FIRE_DAMAGE_SHORT" },
        { pattern = "Frost damage.-up to (%d+)", stat = "ITEM_MOD_FROST_DAMAGE_SHORT" },
        { pattern = "Arcane damage.-up to (%d+)", stat = "ITEM_MOD_ARCANE_DAMAGE_SHORT" },
        { pattern = "Nature damage.-up to (%d+)", stat = "ITEM_MOD_NATURE_DAMAGE_SHORT" },
        { pattern = "Holy damage.-up to (%d+)", stat = "ITEM_MOD_HOLY_DAMAGE_SHORT" },
        
        -- [[ REGEN / ATTRIBUTES ]]
        { pattern = "(%d+) mana per 5 sec", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { pattern = "%+(%d+) Stamina", stat = "ITEM_MOD_STAMINA_SHORT" },
        { pattern = "%+(%d+) Intellect", stat = "ITEM_MOD_INTELLECT_SHORT" },
        { pattern = "%+(%d+) Spirit", stat = "ITEM_MOD_SPIRIT_SHORT" },
        { pattern = "%+(%d+) Strength", stat = "ITEM_MOD_STRENGTH_SHORT" },
        { pattern = "%+(%d+) Agility", stat = "ITEM_MOD_AGILITY_SHORT" },
        { pattern = "defense rating by (%d+)", stat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { pattern = "%+(%d+) Block", stat = "ITEM_MOD_BLOCK_VALUE_SHORT" },
    }
    
    for _, p in ipairs(patterns) do
        local val = text:match(p.pattern)
        if val then return p.stat, (p.val or tonumber(val)), isSocketBonus end
    end
    return nil, 0, false
end

-- =============================================================
-- 3. PROJECTION LOGIC (Gems & Enchants)
-- =============================================================

function MSC.GetBestGemForSocket(socketColor, level, weights)
    local db = (level >= 70) and MSC.GemOptions or MSC.GemOptions_Leveling
    local candidates = db[socketColor]
    if not candidates then return nil, 0 end
    
    local bestGem, bestScore = nil, -1
    
    for _, gem in ipairs(candidates) do
        local score = 0
        if weights[gem.stat] then score = score + (gem.val * weights[gem.stat]) end
        if gem.stat2 and weights[gem.stat2] then score = score + (gem.val2 * weights[gem.stat2]) end
        
        if score > bestScore then
            bestScore = score
            bestGem = gem
        end
    end
    return bestGem, bestScore
end

function MSC.ProjectGems(itemLink, bonusStats)
    local gemMode = SGJ_Settings and SGJ_Settings.GemMode or 1
    if gemMode == 1 or gemMode == 2 then return {}, false, false, nil end
    
    local baseStats = GetItemStats(itemLink)
    if not baseStats then return {}, false, false, nil end
    
    local socketKeys = {"EMPTY_SOCKET_RED", "EMPTY_SOCKET_YELLOW", "EMPTY_SOCKET_BLUE", "EMPTY_SOCKET_META", "EMPTY_SOCKET_PRISMATIC"}
    local level = UnitLevel("player")
    local weights = MSC.GetCurrentWeights()
    if not weights then return {}, false, false, nil end

    -- Helper to calculate total gem score for a strategy
    local function CalculateStrategy(ignoreColors)
        local totalScore = 0
        local gemSet = {}
        for _, colorKey in ipairs(socketKeys) do
            local count = baseStats[colorKey] or 0
            if count > 0 then
                for i=1, count do
                    local bestGem, score = nil, 0
                    if ignoreColors and colorKey ~= "EMPTY_SOCKET_META" then
                        -- Scan all colors for best raw score
                        for _, c in ipairs({"EMPTY_SOCKET_RED", "EMPTY_SOCKET_YELLOW", "EMPTY_SOCKET_BLUE"}) do
                            local g, s = MSC.GetBestGemForSocket(c, level, weights)
                            if g and s > score then bestGem = g; score = s end
                        end
                    else
                        bestGem, score = MSC.GetBestGemForSocket(colorKey, level, weights)
                    end
                    
                    if bestGem then
                        totalScore = totalScore + score
                        table.insert(gemSet, bestGem)
                    end
                end
            end
        end
        return totalScore, gemSet
    end

    -- [[ SMART LOGIC (Option 4) ]]
    -- Compare: (Matching Gems + Bonus) vs (Best Raw Gems)
    local useMatch = true
    
    if gemMode == 4 then
        -- 1. Calculate Match Score
        local scoreMatch, gemsMatch = CalculateStrategy(false)
        local bonusScore = 0
        if bonusStats then
            for k, v in pairs(bonusStats) do
                if weights[k] then bonusScore = bonusScore + (v * weights[k]) end
            end
        end
        local totalMatch = scoreMatch + bonusScore
        
        -- 2. Calculate Ignore Score
        local scoreIgnore, gemsIgnore = CalculateStrategy(true)
        
        -- 3. Decide
        if scoreIgnore > totalMatch then
            useMatch = false
        end
    elseif gemMode == 3 then
        useMatch = true
    end

    -- [[ BUILD FINAL RESULTS ]]
    local finalStats = { COUNT = 0 }
    local hasSockets = false
    local gemCounts = {}
    
    local _, chosenGems = CalculateStrategy(not useMatch)
    
    for _, gem in ipairs(chosenGems) do
        hasSockets = true
        finalStats.COUNT = finalStats.COUNT + 1
        finalStats[gem.stat] = (finalStats[gem.stat] or 0) + gem.val
        if gem.stat2 then finalStats[gem.stat2] = (finalStats[gem.stat2] or 0) + gem.val2 end
        
        local sName = MSC.StatShortNames[gem.stat] or "Stat"
        local label = "+" .. gem.val .. " " .. sName
        gemCounts[label] = (gemCounts[label] or 0) + 1
    end
    
    local textParts = {}
    for label, count in pairs(gemCounts) do table.insert(textParts, count .. "x (" .. label .. ")") end
    local gemText = table.concat(textParts, ", ")
    
    return finalStats, hasSockets, useMatch, gemText
end

function MSC.GetBestEnchantForSlot(slotId, level, specName, enchantType)
    local bestScore = 0
    local bestID = nil
    
    -- Loop through your Enchant Database directly
    if not MSC.EnchantDB then return nil end

    for eID, data in pairs(MSC.EnchantDB) do
        local isValid = false

        -- FILTER 1: Slot Match
        if data.slot == slotId then isValid = true end
        
        -- FILTER 2: Type Match (Scopes vs Shields vs Weapons)
        if isValid and enchantType then
            if enchantType == "SCOPE" then
                if not data.isScope then isValid = false end
            elseif enchantType == "SHIELD" then
                if not data.isShield then isValid = false end
            elseif enchantType == "WEAPON" or enchantType == "2H_WEAPON" then
                if data.isShield or data.isScope then isValid = false end
                if data.requires2H and enchantType ~= "2H_WEAPON" then isValid = false end
            end
        end

        -- Score it
        if isValid then
            local weights = MSC.GetCurrentWeights()
            local score = MSC.GetItemScore(data.stats, weights, specName)
            if score > bestScore then
                bestScore = score
                bestID = eID
            end
        end
    end
    
    return bestID
end

function MSC.GetEnchantStats(slotId)
    local link = GetInventoryItemLink("player", slotId)
    if not link then return {} end
    local _, _, _, enchantID = string.find(link, "item:(%d+):(%d+)")
    enchantID = tonumber(enchantID)
    if enchantID and enchantID > 0 and MSC.EnchantDB and MSC.EnchantDB[enchantID] then
        local data = MSC.EnchantDB[enchantID]
        local stats = {}
        if data.stats then for k,v in pairs(data.stats) do stats[k]=v end
        else for k,v in pairs(data) do stats[k]=v end end
        return stats
    end
    return {}
end

function MSC.GetEnchantString(slotId)
    local link = GetInventoryItemLink("player", slotId)
    if not link then return "" end
    local _, _, _, enchantID = string.find(link, "item:%d+:(%d+)")
    enchantID = tonumber(enchantID)
    if enchantID and MSC.EnchantDB and MSC.EnchantDB[enchantID] then
        local data = MSC.EnchantDB[enchantID]
        return data.name or ("Enchant #"..enchantID)
    end
    return ""
end

-- =============================================================
-- 4. MAIN STAT SCANNER (Wrapper)
-- =============================================================
function MSC.SafeGetItemStats(itemLink, slotId)
    if not itemLink then return {} end
    
    -- [[ MOVED UP ]] Extract ID early so we can use it for Procs
    local id = tonumber(itemLink:match("item:(%d+)"))

    -- A. Base Stats (API)
    local stats = GetItemStats(itemLink) or {}
    local finalStats = {}
    local bonusStats = {} 
    
    for k, v in pairs(stats) do
        if MSC.StatShortNames[k] or k == "ITEM_MOD_SPELL_HEALING_DONE" or k == "ITEM_MOD_SPELL_DAMAGE_DONE" then 
            if k == "ITEM_MOD_SPELL_HEALING_DONE" then finalStats["ITEM_MOD_HEALING_POWER_SHORT"] = (finalStats["ITEM_MOD_HEALING_POWER_SHORT"] or 0) + v
            elseif k == "ITEM_MOD_SPELL_DAMAGE_DONE" then finalStats["ITEM_MOD_SPELL_POWER_SHORT"] = (finalStats["ITEM_MOD_SPELL_POWER_SHORT"] or 0) + v
            else finalStats[k] = v end
        end
    end
    
    -- B. Tooltip Scan (Catch missing stats + Socket Bonus + PROCS)
    local tipName = "MSC_ScannerTooltip"
    local tip = _G[tipName] or CreateFrame("GameTooltip", tipName, nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    tip:ClearLines()
    tip:SetHyperlink(itemLink)
    
    for i = 2, tip:NumLines() do
        local line = _G[tipName.."TextLeft"..i]; local text = line and line:GetText()
        if text then
            -- 1. Standard Stat Parse
            local s, v, isBonus = MSC.ParseTooltipLine(text)
            if s and v then
                if isBonus then bonusStats[s] = (bonusStats[s] or 0) + v
                elseif not finalStats[s] then finalStats[s] = (finalStats[s] or 0) + v end
            end

            -- 2. [[ NEW ]] Proc Text Parse (The Wiring!)
            if id then
                local pStat, pVal = MSC:ParseProcText(text, id)
                if pStat and pVal > 0 then
                    finalStats[pStat] = (finalStats[pStat] or 0) + pVal
                end
            end
        end
    end

    -- C. Manual Overrides
    if id and MSC.ItemOverrides and MSC.ItemOverrides[id] then
        local override = MSC.ItemOverrides[id]
        if override.replace then finalStats = {} end
        for k, v in pairs(override) do
            if k ~= "replace" and k ~= "estimate" then finalStats[k] = (finalStats[k] or 0) + v end
        end
        if override.estimate then finalStats.estimate = true end
    end

    -- D. ENCHANT PROJECTION (Updated)
    local enchantMode = SGJ_Settings and SGJ_Settings.EnchantMode or 3 
    if enchantMode == 3 and slotId then 
        -- [[ NEW ]] Check if item can be enchanted
        local enchantType = MSC:GetValidEnchantType(itemLink)
        
        if enchantType then
            local level = UnitLevel("player")
            local _, specName = MSC.GetCurrentWeights()
            -- Pass the type so we get Scopes for Bows, etc.
            local bestID = MSC.GetBestEnchantForSlot(slotId, level, specName, enchantType)
            
            if bestID and MSC.EnchantDB[bestID] then
                local eStats = MSC.EnchantDB[bestID]
                local src = eStats.stats or eStats
                for k, v in pairs(src) do if k~="name" then finalStats[k] = (finalStats[k] or 0) + v end end
                finalStats.IS_PROJECTED = true
                finalStats.ENCHANT_TEXT = eStats.name
            end
        end
    end

    -- E. GEM PROJECTION
    local gemMode = SGJ_Settings and SGJ_Settings.GemMode or 1
    if gemMode == 1 or gemMode == 2 then
        for k, v in pairs(bonusStats) do finalStats[k] = (finalStats[k] or 0) + v end
    else
        local gemStats, hasSockets, bonusActive, gemText = MSC.ProjectGems(itemLink, bonusStats)
        if hasSockets then
            for k, v in pairs(gemStats) do if k~="COUNT" then finalStats[k] = (finalStats[k] or 0) + v end end
            finalStats.GEMS_PROJECTED = gemStats.COUNT 
            finalStats.GEM_TEXT = gemText
            if bonusActive then 
                for k, v in pairs(bonusStats) do finalStats[k] = (finalStats[k] or 0) + v end
                finalStats.BONUS_PROJECTED = true 
            end
        end
    end

    return finalStats
end

-- =============================================================
-- 5. SCORING & UTILITIES
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
    
    for stat, val in pairs(stats) do
        if weights[stat] and type(val) == "number" then score = score + (val * weights[stat]) end
    end
    
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
    
    -- 1. RACIAL BONUSES (TBC UPDATE: Expertise Fix)
    if itemLink and MSC.RacialTraits and MSC.RacialTraits[race] then
        local _, _, _, _, _, _, _, _, _, _, _, _, subclassID = GetItemInfo(itemLink)
        if subclassID and MSC.RacialTraits[race][subclassID] then
            local val = MSC.RacialTraits[race][subclassID]
            if type(val) == "number" then
                if subclassID == 2 or subclassID == 3 or subclassID == 18 then
                     out["ITEM_MOD_CRIT_RATING_SHORT"] = (out["ITEM_MOD_CRIT_RATING_SHORT"] or 0) + val
                else
                     out["ITEM_MOD_EXPERTISE_RATING_SHORT"] = (out["ITEM_MOD_EXPERTISE_RATING_SHORT"] or 0) + val
                end
            elseif type(val) == "table" and val.stat then
                out[val.stat] = (out[val.stat] or 0) + val.val
            end
        end
    end

    -- 2. BASIC CONVERSIONS (Stam->HP, Int->Mana)
    if out["ITEM_MOD_STAMINA_SHORT"] then 
        out["ITEM_MOD_HEALTH_SHORT"] = (out["ITEM_MOD_HEALTH_SHORT"] or 0) + (out["ITEM_MOD_STAMINA_SHORT"] * 10) 
    end
    if powerType == 0 and out["ITEM_MOD_INTELLECT_SHORT"] then 
        out["ITEM_MOD_MANA_SHORT"] = (out["ITEM_MOD_MANA_SHORT"] or 0) + (out["ITEM_MOD_INTELLECT_SHORT"] * 15) 
    end
    
    -- 3. CRIT SCALING
    local ratioTable = MSC.StatToCritMatrix and MSC.StatToCritMatrix[class]
    local myLevel = UnitLevel("player")
    if ratioTable then
        if ratioTable.Agi and out["ITEM_MOD_AGILITY_SHORT"] then
            local ratio = MSC.GetInterpolatedRatio(ratioTable.Agi, myLevel)
            if ratio and ratio > 0 then
                local critVal = out["ITEM_MOD_AGILITY_SHORT"] / ratio
                if critVal > 0 then out["ITEM_MOD_CRIT_FROM_STATS_SHORT"] = (out["ITEM_MOD_CRIT_FROM_STATS_SHORT"] or 0) + critVal end
            end
        end
        if ratioTable.Int and out["ITEM_MOD_INTELLECT_SHORT"] then
             local ratio = MSC.GetInterpolatedRatio(ratioTable.Int, myLevel)
             if ratio and ratio > 0 then
                 local spellCritVal = out["ITEM_MOD_INTELLECT_SHORT"] / ratio
                 if spellCritVal > 0 then out["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] = (out["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] or 0) + spellCritVal end
             end
        end
    end
    return out
end

function MSC.GetStatDifferences(new, old)
    local diffs = {}
    local seen = {}
    for k, v in pairs(new) do 
        if k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" and k ~= "GEM_TEXT" and k ~= "ENCHANT_TEXT" and type(v) == "number" then
            local d = v - (old[k] or 0)
            if d ~= 0 then table.insert(diffs, { key=k, val=d }); seen[k] = true end
        end
    end
    for k, v in pairs(old) do
        if not seen[k] and k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" and k ~= "GEM_TEXT" and k ~= "ENCHANT_TEXT" and type(v) == "number" then
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
                    if stats then 
                        local score = MSC.GetItemScore(stats, weights, specName, 16)
                        if score > bestScore then bestScore = score; bestLink = link; bestStats = stats end 
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
            if link and MSC.IsItemUsable(link) then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                if equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND" or equipLoc == "INVTYPE_WEAPON" then
                    local stats = MSC.SafeGetItemStats(link, 17)
                    if stats then 
                        local score = MSC.GetItemScore(stats, weights, specName, 17)
                        if score > bestScore then bestScore = score; bestLink = link; bestStats = stats end 
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
-- ============================================================================
--  6. PROC CALCULATOR (The "Chance on Hit" Fix)
-- ============================================================================
function MSC:ParseProcText(text, itemID)
-- Inputs:
--   text: The tooltip text (e.g., "Chance on hit: Increases Haste by 300 for 10 sec")
--   itemID: The ID of the item (to look up PPM)
-- Returns: 
--   statName: (e.g., "HASTE")
--   value: The calculated static value (e.g., 25)
    -- 1. Check if this is actually a proc line
    if not (string.find(text, "Chance on hit:") or string.find(text, "Equip: When struck")) then
        return nil, 0
    end

    -- 2. Look up the Hidden Variable (PPM)
    -- If the item isn't in your ProcDB, we default to 1.0 PPM just to give it SOME value.
    local procData = MSC:GetProcData(itemID)
    local ppm = procData and procData.ppm or 1.0 
    
    -- 3. Extract the Numbers from the text
    -- We are looking for "by X" (Amount) and "for Y sec" (Duration)
    local amount = tonumber(string.match(text, "by (%d+)"))
    local duration = tonumber(string.match(text, "for (%d+) sec"))
    
    if not amount or not duration then return nil, 0 end

    -- 4. Identify the Stat
    local statName = nil
    if string.find(text, "Haste") then statName = "HASTE"
    elseif string.find(text, "Strength") then statName = "STR"
    elseif string.find(text, "Agility") then statName = "AGI"
    elseif string.find(text, "Intellect") then statName = "INT"
    elseif string.find(text, "Attack Power") then statName = "AP"
    elseif string.find(text, "Spell Power") or string.find(text, "damage and healing") then statName = "SPELL_DMG"
    end

    if not statName then return nil, 0 end

    -- 5. The Math (The "Static Stat Equivalent" Formula)
    -- Value = (Amount * Duration * PPM) / 60 seconds
    local sse = (amount * duration * ppm) / 60
    
    return statName, sse
end