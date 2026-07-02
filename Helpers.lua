local addonName, MSC = ...
_G.MSC = MSC 

-- [[ SPEED OPTIMIZATION: LOCALIZED FUNCTIONS ]]
local _G = _G
local type, pairs, ipairs, unpack, pcall, select = type, pairs, ipairs, unpack, pcall, select
local tonumber, tostring, next = tonumber, tostring, next
local math_floor, math_abs, math_max, math_min, math_sqrt = math.floor, math.abs, math.max, math.min, math.sqrt
local string_find, string_match, string_lower, string_upper, string_gsub, string_format, string_sub = string.find, string.match, string.lower, string.upper, string.gsub, string.format, string.sub
local table_insert, table_concat, table_remove, table_sort = table.insert, table.concat, table.remove, table.sort
local wipe = wipe or table.wipe
local strsplit = strsplit

-- WoW APIs
local CreateFrame = CreateFrame
local WorldFrame = WorldFrame
local GetItemInfo = GetItemInfo
local UnitClass = UnitClass
local UnitLevel = UnitLevel
local UnitRace = UnitRace
local UnitStat = UnitStat
local UnitDefense = UnitDefense
local GetInventoryItemLink = GetInventoryItemLink
local GetItemStats = GetItemStats

-- Era/Classic Specifics
local GetHitModifier = GetHitModifier
local GetSpellHitModifier = GetSpellHitModifier
local GetCritChance = GetCritChance
local GetSpellCritChance = GetSpellCritChance
local GetSpellBonusHealing = GetSpellBonusHealing
local GetSpellBonusDamage = GetSpellBonusDamage

-- TBC/Retail Specifics
local GetCombatRating = GetCombatRating
local C_Container = C_Container
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo

-- =============================================================
-- 1. UTILITY FUNCTIONS
-- =============================================================
function MSC:SafeCopy(orig)
    local original_type = type(orig)
    local copy
    if original_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else
        copy = orig
    end
    return copy
end

-- [[ OPTIMIZATION: CACHE USABILITY ]]
MSC.UsableCache = {} 

function MSC.IsItemUsable(itemLink)
    if not itemLink then return false end
    
    -- Check Cache First
    if MSC.UsableCache[itemLink] ~= nil then return MSC.UsableCache[itemLink] end
    
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    local localizedClass, playerClass = UnitClass("player")
    local result = true -- Default to true, prove false

    -- 1. WEAPON CHECK
    if classID == 2 then 
        if MSC.CurrentClass and MSC.CurrentClass.ValidWeapons then
            if not MSC.CurrentClass.ValidWeapons[subClassID] then result = false end
        end
    end

    -- 2. ARMOR CHECK
    if result and classID == 4 then 
        local level = UnitLevel("player")
        local maxArmor = 1 -- Cloth
        
        if playerClass == "WARRIOR" or playerClass == "PALADIN" then 
            maxArmor = (level >= 40) and 4 or 3
        elseif playerClass == "SHAMAN" or playerClass == "HUNTER" then 
            maxArmor = (level >= 40) and 3 or 2
        elseif playerClass == "ROGUE" or playerClass == "DRUID" then 
            maxArmor = 2 
        end
        
        if subClassID == 6 then -- Shield
            if playerClass ~= "WARRIOR" and playerClass ~= "PALADIN" and playerClass ~= "SHAMAN" then result = false end
        elseif subClassID > 0 and subClassID <= 4 then
             if subClassID > maxArmor then result = false end
        end
    end

    -- 3. RESTRICTION SCAN (Only runs if passed previous checks)
    if result then
        local tip = _G["MSC_ScannerTooltip"] or CreateFrame("GameTooltip", "MSC_ScannerTooltip", nil, "GameTooltipTemplate")
        tip:SetOwner(WorldFrame, "ANCHOR_NONE"); tip:ClearLines()
        local status = pcall(function() tip:SetHyperlink(itemLink) end)
        
        if status then
            for i = 2, tip:NumLines() do
                local line = _G["MSC_ScannerTooltipTextLeft"..i]
                local text = line and line:GetText()
                if text then
                    if string_find(text, "Classes:") or (ITEM_CLASSES_ALLOWED and string_find(text, string_gsub(ITEM_CLASSES_ALLOWED, "%%s", ""))) then
                        if not string_find(text, localizedClass) then result = false; break end
                    end
                    if string_find(text, "Races:") or (ITEM_RACES_ALLOWED and string_find(text, string_gsub(ITEM_RACES_ALLOWED, "%%s", ""))) then
                          local localizedRace = UnitRace("player")
                          if not string_find(text, localizedRace) then result = false; break end
                    end
                end
            end
        end
    end
    
    -- Save to Cache
    MSC.UsableCache[itemLink] = result
    return result
end

function MSC:IsJewelcrafter()
    -- Allow the user to force this on via settings
    if SGJ_Settings and type(SGJ_Settings.IsJC) == "boolean" then
        return SGJ_Settings.IsJC
    end
    -- Fallback: Scan Professions
    if GetNumSkillLines then
        for i = 1, GetNumSkillLines() do
            local skillName = GetSkillLineInfo(i)
            local localizedJC = MSC.L["Jewelcrafting"] or "Jewelcrafting"
			if skillName and (skillName == localizedJC or string.find(skillName, localizedJC)) then
                return true
            end
        end
    end
    return false
end

-- =============================================================
-- 2. API SHIMS
-- =============================================================
function MSC.getItemID(bagID, slotID)
    if not bagID or not slotID then return nil end
    local itemInfo = GetContainerItemInfo(bagID, slotID)
    if itemInfo then return itemInfo.itemID end
    return nil
end

function MSC:GetPlayerStat(statType)
    if MSC.IsEra then
        if statType == "HIT" then return GetHitModifier() or 0
        elseif statType == "SPELL_HIT" then return GetSpellHitModifier() or 0
        elseif statType == "CRIT" then return GetCritChance()
        elseif statType == "SPELL_CRIT" then return GetSpellCritChance(2)
        elseif statType == "DEFENSE" then local b, m = UnitDefense("player"); return b + m
        elseif statType == "HEALING" then return GetSpellBonusHealing()
        elseif statType == "SPELL_POWER" then return GetSpellBonusDamage(2)
        end
    else
        if statType == "HIT" then return GetCombatRating(6)
        elseif statType == "SPELL_HIT" then return GetCombatRating(8)
        elseif statType == "CRIT" then return GetCombatRating(9)
        elseif statType == "SPELL_CRIT" then return GetCombatRating(11)
        elseif statType == "DEFENSE" then local b, m = UnitDefense("player"); return b + m
        elseif statType == "HEALING" then return GetSpellBonusHealing()
        elseif statType == "SPELL_POWER" then return GetSpellBonusDamage(2)
        end
    end
    return 0
end

-- Returns MP5 gained from `spiritPoints` on gear (pass 1 for per-stat weighting).
function MSC:GetSpiritValueInMP5(level, spiritPoints)
    if not MSC.BaseRegenTable then return 0 end
    local points = spiritPoints or 1
    if points > 50 then points = 1 end -- guard against passing total Intellect by mistake
    local _, class = UnitClass("player")
    if MSC.IsEra then
        if class == "PRIEST" or class == "MAGE" then return (points / 4) + 12.5 end
        return (points / 5) + 15
    else
        if not level or level > 70 then level = 70 end
        local base = MSC.BaseRegenTable[level] or 0.009327
        local intel = UnitStat("player", 4) or 100
        return 5 * (0.001 + base * math_sqrt(intel) * points)
    end
end

-- =============================================================
-- 3. COMPARISON MATH
-- =============================================================
function MSC.GetStatDifferences(newStats, oldStats, outTable)
    if not outTable then outTable = {} end
    wipe(outTable)
    
    local ignoreKeys = {
        ["IS_PROJECTED"] = true, ["GEMS_PROJECTED"] = true, ["BONUS_PROJECTED"] = true,
        ["GEM_TEXT"] = true, ["ENCHANT_TEXT"] = true, ["PROJECTED_GEM_IDS"] = true,
        ["META_ID"] = true, ["COLORS"] = true, ["_BONUS_STATS"] = true, ["_AUTO_PROC"] = true
    }

    local processed = {}
    for k, valNew in pairs(newStats) do
        if not ignoreKeys[k] and type(valNew) == "number" then
            local valOld = oldStats[k]
            if type(valOld) ~= "number" then valOld = 0 end
            local diff = valNew - valOld
            if math_abs(diff) > 0.01 then
                table_insert(outTable, { key = k, val = diff })
            end
            processed[k] = true
        end
    end
    for k, valOld in pairs(oldStats) do
        if not processed[k] and not ignoreKeys[k] and type(valOld) == "number" then
            local diff = 0 - valOld
            if math_abs(diff) > 0.01 then
                table_insert(outTable, { key = k, val = diff })
            end
        end
    end
    return outTable
end

function MSC.SortStatDiffs(diffs)
    table_sort(diffs, function(a,b) return a.val > b.val end)
    return diffs
end

function MSC.GetCleanStatName(key)
    if MSC.ShortNames and MSC.ShortNames[key] then return MSC.ShortNames[key] end
    if MSC.StatShortNames and MSC.StatShortNames[key] then return MSC.StatShortNames[key] end
    local s = string_gsub(string_gsub(string_gsub(key, "ITEM_MOD_", ""), "_SHORT", ""), "_", " ")
    return string_gsub(string_lower(s), "^%l", string_upper)
end

function MSC.NormalizeStatKey(key)
    if not key or not MSC.StatAliases then return key end
    return MSC.StatAliases[key] or key
end

-- =============================================================
-- 4. CACHE & CONSTANTS
-- =============================================================
MSC.StatCache = {}
local Scratch_MatchGems = {}
local Scratch_PureGems = {}
local Scratch_GemTextParts = {}
local Scratch_ProjectedIDs = {}
local Scratch_GemCounts = {}
local Scratch_GemOrder = {}
local Scratch_GemStats = {}
local Scratch_GemColors = {}
local Scratch_ProjectedColors = { RED=0, YELLOW=0, BLUE=0 }

MSC.StatShortNames = {
    ["MSC_WAND_DPS"] = MSC.L["Wand DPS"], ["MSC_WEAPON_DPS"] = MSC.L["Weapon DPS"], ["MSC_WEAPON_SPEED"] = MSC.L["Speed"], ["MSC_OH_WEAPON_SPEED"] = MSC.L["OH Speed"],
    ["ITEM_MOD_STAMINA_SHORT"] = MSC.L["Stam"], ["ITEM_MOD_INTELLECT_SHORT"] = MSC.L["Int"],
    ["ITEM_MOD_AGILITY_SHORT"] = MSC.L["Agi"], ["ITEM_MOD_STRENGTH_SHORT"] = MSC.L["Str"],
    ["ITEM_MOD_SPIRIT_SHORT"] = MSC.L["Spt"], ["ITEM_MOD_SPELL_POWER_SHORT"] = MSC.L["SP"],
    ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = MSC.L["Heal"], ["ITEM_MOD_MANA_REGENERATION_SHORT"] = MSC.L["Mp5"],
    ["ITEM_MOD_ATTACK_POWER_SHORT"] = MSC.L["AP"], ["ITEM_MOD_CRIT_RATING_SHORT"] = MSC.L["Crit"],
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = MSC.L["Spell Crit"], ["ITEM_MOD_HIT_RATING_SHORT"] = MSC.L["Hit"],
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = MSC.L["Spell Hit"], ["ITEM_MOD_HASTE_RATING_SHORT"] = MSC.L["Haste"],
    ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = MSC.L["Exp"], ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = MSC.L["Def"],
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = MSC.L["Resil"], ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = MSC.L["ArP"],
    ["ITEM_MOD_BLOCK_VALUE_SHORT"] = MSC.L["BlockVal"], ["ITEM_MOD_BLOCK_RATING_SHORT"] = MSC.L["Block"],
    ["ITEM_MOD_DODGE_RATING_SHORT"] = MSC.L["Dodge"], ["ITEM_MOD_PARRY_RATING_SHORT"] = MSC.L["Parry"],
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = MSC.L["Shadow"], ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = MSC.L["Fire"],
    ["ITEM_MOD_FROST_DAMAGE_SHORT"] = MSC.L["Frost"], ["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = MSC.L["Arcane"],
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = MSC.L["Nature"], ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = MSC.L["Holy"],
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = MSC.L["Dmg"], ["ITEM_MOD_ARMOR_SHORT"] = MSC.L["Armor"],
    ["ITEM_MOD_ALL_RESISTANCE_SHORT"] = MSC.L["All Res"],
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = MSC.L["Feral AP"],
    ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = MSC.L["Ranged AP"],
}

function MSC.Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math_floor(num * mult + 0.5) / mult
end

-- =============================================================
-- 5. RATING CONVERTER
-- =============================================================
function MSC:GetRatingPercent(statKey, ratingVal, level)
    if not MSC.CombatRatingScalars or not MSC.RatingIndexMap then return nil end
    local idx = MSC.RatingIndexMap[statKey]
    if not idx then return nil end
    local levelData = MSC.CombatRatingScalars[level]
    if not levelData then 
        if level < 60 then levelData = MSC.CombatRatingScalars[60] 
        elseif level > 70 then levelData = MSC.CombatRatingScalars[70] end
    end
    if not levelData or not levelData[idx] then return nil end
    return ratingVal / levelData[idx]
end

-- =============================================================
-- 6. SCANNING
-- =============================================================
function MSC.GetRawItemStats(itemLink)
    if not itemLink then return {} end
    if MSC.StatCache[itemLink] then return MSC.StatCache[itemLink] end

    -- 1. EXECUTE SCANNER
    local scanData = nil
    if MSC.Scanner and MSC.Scanner.Scan then
        local status, result = pcall(MSC.Scanner.Scan, itemLink)
        if status and result then scanData = result end
    end
    if not scanData then scanData = { Stats = {}, UseEffects = {}, Procs = {}, Meta = {} } end
    
    -- 2. FLATTEN STATS
    local finalStats = scanData.Stats or {}
    local bonusStats = {}

    -- 3. INTEGRATE USE EFFECTS (skip when ProcDB/trinket entry owns the item)
    local itemID = tonumber(string_match(itemLink, "item:(%d+)"))
    local hasProcEntry = itemID and (
        (MSC.ProcDB and MSC.ProcDB[itemID]) or
        (MSC.WeaponDB and MSC.WeaponDB[itemID]) or
        (MSC.TrinketDB and MSC.TrinketDB[itemID])
    )
    if not hasProcEntry and scanData.UseEffects then
        for _, effect in ipairs(scanData.UseEffects) do
            if effect.statKey and effect.averageVal and effect.averageVal > 0 then
                 local sk = MSC.NormalizeStatKey and MSC.NormalizeStatKey(effect.statKey) or effect.statKey
                 finalStats[sk] = (finalStats[sk] or 0) + effect.averageVal
                 if not finalStats._AUTO_PROC then finalStats._AUTO_PROC = { stat=sk, val=effect.averageVal } end
            end
        end
    end

    -- 4. OVERRIDES
    if itemID then
        if MSC.CurrentClass then
            local classDB = MSC.CurrentClass.Relics or MSC.CurrentClass.Totems or MSC.CurrentClass.Idols or MSC.CurrentClass.ItemOverrides
            if classDB and classDB[itemID] then
                for statKey, val in pairs(classDB[itemID]) do
                    if type(val) == "number" and statKey ~= "note" then
                        finalStats[statKey] = (finalStats[statKey] or 0) + val
                    end
                end
            end
        end
        local entry = nil
        if MSC.ProcDB and MSC.ProcDB[itemID] then entry = MSC.ProcDB[itemID]
        elseif MSC.WeaponDB and MSC.WeaponDB[itemID] then entry = MSC.WeaponDB[itemID]
        elseif MSC.TrinketDB and MSC.TrinketDB[itemID] then entry = MSC.TrinketDB[itemID]
        end

        if entry then
            -- [[ PROC MATH CALCULATION ]]
            local calcVal = entry.val
            if entry.ppm and entry.val then
                if entry.dur then
                    calcVal = (entry.val * entry.ppm * entry.dur) / 60
                else
                    if entry.stat and (string.find(entry.stat, "REGENERATION") or string.find(entry.stat, "MANA") or string.find(entry.stat, "HEALTH")) then
                         calcVal = (entry.val * entry.ppm * 5) / 60
                    else
                         calcVal = (entry.val * entry.ppm) / 60
                    end
                end
            end

            if calcVal and entry.stat then
                local sk = MSC.NormalizeStatKey(entry.stat)
                finalStats[sk] = (finalStats[sk] or 0) + calcVal
                if not finalStats._AUTO_PROC then finalStats._AUTO_PROC = { stat=sk, val=calcVal } end
            end
            if entry.score then finalStats._MANUAL_SCORE = entry.score end
        end
    end

    -- 5. SOCKET BONUSES
    if scanData.Meta and scanData.Meta.BonusStats then bonusStats = scanData.Meta.BonusStats end
    local normalized = {}
    for k, v in pairs(finalStats) do
        if type(v) == "number" and k ~= "_BONUS_STATS" then
            local nk = MSC.NormalizeStatKey(k)
            normalized[nk] = (normalized[nk] or 0) + v
        else
            normalized[k] = v
        end
    end
    finalStats = normalized
    finalStats._BONUS_STATS = bonusStats
    
    MSC.StatCache[itemLink] = finalStats
    return finalStats
end

-- =============================================================
-- 7. ENCHANT & GEM ENGINE
-- =============================================================
function MSC:GetValidEnchantType(itemLink)
    if not itemLink then return nil end
    local _, _, _, _, _, _, _, _, equipLoc, _, _, classID, subClassID = GetItemInfo(itemLink)
    if not equipLoc then return nil end
    
    if classID == 2 then 
        if equipLoc == "INVTYPE_2HWEAPON" or equipLoc == "INVTYPE_STAFF" or equipLoc == "INVTYPE_POLEARM" then return "2H"
        elseif equipLoc == "INVTYPE_RANGED" or equipLoc == "INVTYPE_RANGEDRIGHT" or equipLoc == "INVTYPE_THROWN" then
            if subClassID == 2 or subClassID == 3 or subClassID == 18 then return "Bow" end
            return "Relic"
        elseif equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND" or equipLoc == "INVTYPE_WEAPONOFFHAND" then return "Weapon" end
    end
    if classID == 4 then
        if subClassID == 6 then return "Shield" end
        if subClassID == 0 then return "Relic" end
        return "Armor"
    end
    return "Armor"
end

function MSC.GetEnchantScore(enchantID, weights)
    if not enchantID or not MSC.EnchantDB[enchantID] then return 0 end
    local stats = MSC.EnchantDB[enchantID].stats
    if not stats then return 0 end
    local score = 0
    for stat, value in pairs(stats) do
        if weights[stat] then score = score + (value * weights[stat]) end
    end
    return score
end

function MSC.GetBestEnchantForSlot(slotId, level, specName, enchantType, weights)
    local candidates = (level < 60 and MSC.EnchantCandidates_Leveling and MSC.EnchantCandidates_Leveling[slotId])
    if not candidates or #candidates == 0 then candidates = MSC.EnchantCandidates and MSC.EnchantCandidates[slotId] end
    if not candidates then return nil end

    local bestID, bestScore = nil, -1
    for _, id in ipairs(candidates) do
        local data = MSC.EnchantDB[id]
        if data then
            local allowed = true
            if data.requires2H and enchantType ~= "2H" then allowed = false end
            if slotId == 17 then
                if enchantType == "Shield" and not data.isShield then allowed = false end
                if enchantType ~= "Shield" and data.isShield then allowed = false end
                if enchantType ~= "Weapon" and not data.isShield and not data.isScope then allowed = false end
            end
            if slotId == 18 and ((enchantType == "Bow" and not data.isScope) or (enchantType == "Relic")) then allowed = false end
            if allowed then
                local score = MSC.GetEnchantScore(id, weights)
                if score > bestScore then bestScore = score; bestID = id end
            end
        end
    end
    return (bestScore > 0) and bestID or nil
end

local function InferCurrentEnchantFromDelta(slotId, rawStats, baseRaw)
    if not slotId or not rawStats or not baseRaw or not MSC.EnchantDB then return nil end

    local candidates = MSC.EnchantCandidates and MSC.EnchantCandidates[slotId]
    if not candidates then return nil end

    local bestMatch, bestTotal = nil, 0

    for _, enchantID in ipairs(candidates) do
        local data = MSC.EnchantDB[enchantID]
        if data and data.stats then
            local matched = true
            local total = 0

            for statKey, statVal in pairs(data.stats) do
                if type(statVal) == "number" then
                    local rawDelta = math_max(0, (rawStats[statKey] or 0) - (baseRaw[statKey] or 0))
                    if math_abs(rawDelta - statVal) > 0.01 then
                        matched = false
                        break
                    end
                    total = total + statVal
                end
            end

            if matched then
                for statKey, rawVal in pairs(rawStats) do
                    if type(rawVal) == "number" then
                        local rawDelta = math_max(0, rawVal - (baseRaw[statKey] or 0))
                        local enchantVal = data.stats[statKey] or 0
                        if math_abs(rawDelta - enchantVal) > 0.01 then
                            matched = false
                            break
                        end
                    end
                end
            end

            if matched and total > bestTotal then
                bestMatch, bestTotal = data, total
            end
        end
    end

    return bestMatch
end

function MSC.GetBestGemForSocket(socketColor, level, weights, excludeList, isJC)
    local bestGem, bestScore = nil, 0
    local db = (level >= 60 and MSC.GemOptions) and MSC.GemOptions or MSC.GemOptions_Leveling
    if not db or not weights then return nil, 0 end
    
    -- Fetch the player's selected quality budget (Defaults to 3 / Rare)
    local maxQual = SGJ_Settings and SGJ_Settings.GemQuality or 3

    local lists = {}
    if socketColor == "ANY" then
        if db["EMPTY_SOCKET_RED"] then table_insert(lists, db["EMPTY_SOCKET_RED"]) end
        if db["EMPTY_SOCKET_YELLOW"] then table_insert(lists, db["EMPTY_SOCKET_YELLOW"]) end
        if db["EMPTY_SOCKET_BLUE"] then table_insert(lists, db["EMPTY_SOCKET_BLUE"]) end
    elseif socketColor == "EMPTY_SOCKET_META" then
        if db["EMPTY_SOCKET_META"] then table_insert(lists, db["EMPTY_SOCKET_META"]) end
    else
        if socketColor == "EMPTY_SOCKET_PRISMATIC" then
            if db["EMPTY_SOCKET_RED"] then table_insert(lists, db["EMPTY_SOCKET_RED"]) end
            if db["EMPTY_SOCKET_YELLOW"] then table_insert(lists, db["EMPTY_SOCKET_YELLOW"]) end
            if db["EMPTY_SOCKET_BLUE"] then table_insert(lists, db["EMPTY_SOCKET_BLUE"]) end
        else
            if db[socketColor] then table_insert(lists, db[socketColor]) end
        end
    end

    for _, list in ipairs(lists) do
        for _, gem in ipairs(list) do
            local isUniqueBlocked = (gem.unique and excludeList and excludeList[gem.id])
            local isJCBlocked = (gem.isJC and not isJC)
            
            -- Verify if the gem exceeds the player's chosen budget
            local gemQual = gem.quality or 3
            local isQualityBlocked = (gemQual > maxQual)

            if not isUniqueBlocked and not isJCBlocked and not isQualityBlocked then
                local score = 0
                if gem.stat and weights[gem.stat] then score = score + (gem.val * weights[gem.stat]) end
                if gem.stat2 and weights[gem.stat2] then score = score + (gem.val2 * weights[gem.stat2]) end
                if score > bestScore then bestScore = score; bestGem = gem end
            end
        end
    end
    return bestGem, bestScore
end

-- =============================================================
-- 8. GEM CACHE & LOOKUP
-- =============================================================
MSC.GemIDCache = {}

function MSC:BuildGemCache()
    local dbs = { MSC.GemOptions, MSC.GemOptions_Leveling }
    for _, db in ipairs(dbs) do
        if db then
            for _, list in pairs(db) do
                for _, gem in ipairs(list) do MSC.GemIDCache[gem.id] = gem end
            end
        end
    end
end

function MSC.GetGemStatsByID(gemID)
    if not gemID then return nil end
    local id = tonumber(gemID)
    if MSC.GemIDCache[id] then return MSC.GemIDCache[id] end
    MSC:BuildGemCache()
    return MSC.GemIDCache[id]
end

function MSC.GetGemColor(gemID)
    local gem = MSC.GetGemStatsByID(gemID)
    if gem and gem.colorType then return gem.colorType end
    local _, _, _, _, _, _, _, _, _, icon = GetItemInfo(gemID or 0)
    if icon then
        if string_find(icon, "Red") or string_find(icon, "Garnet") or string_find(icon, "Ruby") then return "RED"
        elseif string_find(icon, "Yellow") or string_find(icon, "Golden") or string_find(icon, "Dawnstone") then return "YELLOW"
        elseif string_find(icon, "Blue") or string_find(icon, "Azure") or string_find(icon, "Star") then return "BLUE"
        elseif string_find(icon, "Orange") or string_find(icon, "Topaz") then return "ORANGE"
        elseif string_find(icon, "Purple") or string_find(icon, "Nightseye") then return "PURPLE"
        elseif string_find(icon, "Green") or string_find(icon, "Talasite") then return "GREEN" end
    end
    return nil
end

function MSC.ApplyGemColorCount(gData, colors)
    if not gData or not gData.colorType or MSC.IsEra or not colors then return end
    local ct = gData.colorType
    if ct == "RED" then
        colors.RED = colors.RED + 1
    elseif ct == "BLUE" then
        colors.BLUE = colors.BLUE + 1
    elseif ct == "YELLOW" then
        colors.YELLOW = colors.YELLOW + 1
    elseif ct == "PURPLE" then
        colors.RED = colors.RED + 1
        colors.BLUE = colors.BLUE + 1
    elseif ct == "ORANGE" then
        colors.RED = colors.RED + 1
        colors.YELLOW = colors.YELLOW + 1
    elseif ct == "GREEN" then
        colors.BLUE = colors.BLUE + 1
        colors.YELLOW = colors.YELLOW + 1
    elseif ct == "PRISMATIC" then
        colors.RED = colors.RED + 1
        colors.BLUE = colors.BLUE + 1
        colors.YELLOW = colors.YELLOW + 1
    end
end

MSC.ColorMatchCache = MSC.ColorMatchCache or {}
MSC.ProcessedStatCache = MSC.ProcessedStatCache or {}

function MSC.SolveColorMatch(gemIDs, baseLink)
    local gemKey = table_concat(gemIDs, ",") .. "|" .. (baseLink or "")
    if MSC.ColorMatchCache[gemKey] ~= nil then
        return MSC.ColorMatchCache[gemKey]
    end

    local template = GetItemStats(baseLink) or {}
    local sockets = {}
    for i=1, (template["EMPTY_SOCKET_RED"] or 0) do table_insert(sockets, "RED") end
    for i=1, (template["EMPTY_SOCKET_YELLOW"] or 0) do table_insert(sockets, "YELLOW") end
    for i=1, (template["EMPTY_SOCKET_BLUE"] or 0) do table_insert(sockets, "BLUE") end
    if #sockets == 0 then return true end

    local function MatchRecursive(gemIdx, availableSockets)
        if gemIdx > #gemIDs then return #availableSockets == 0 end 
        if #availableSockets == 0 then return true end
        
        local gID = gemIDs[gemIdx]
        local gColor = MSC.GetGemColor(gID)
        
        if gColor then
            for i, sColor in ipairs(availableSockets) do
                local match = false
                if gColor == "PRISMATIC" then match = true
                elseif gColor == sColor then match = true
                elseif gColor == "ORANGE" and (sColor == "RED" or sColor == "YELLOW") then match = true
                elseif gColor == "PURPLE" and (sColor == "RED" or sColor == "BLUE") then match = true
                elseif gColor == "GREEN" and (sColor == "BLUE" or sColor == "YELLOW") then match = true
                end

                if match then
                    local nextSockets = { unpack(availableSockets) }
                    table_remove(nextSockets, i)
                    if MatchRecursive(gemIdx + 1, nextSockets) then return true end
                end
            end
        end
        return MatchRecursive(gemIdx + 1, availableSockets)
    end
    local matched = MatchRecursive(1, sockets)
    MSC.ColorMatchCache[gemKey] = matched
    return matched
end

function MSC.SafeGetItemStats(itemLink, slotId, weights, specName, globalUniques)
    if not itemLink then return {} end

    local enchantMode = SGJ_Settings and SGJ_Settings.EnchantMode or 1
    local gemMode = SGJ_Settings and SGJ_Settings.GemMode or 1
    local gemQuality = SGJ_Settings and SGJ_Settings.GemQuality or 3
    local uniqueKey = ""
    if globalUniques then
        local parts = {}
        for id, _ in pairs(globalUniques) do table_insert(parts, tostring(id)) end
        table_sort(parts)
        uniqueKey = table.concat(parts, ",")
    end
    local procKey = itemLink .. "|" .. tostring(slotId or 0) .. "|" .. tostring(specName or "") .. "|" .. enchantMode .. "|" .. gemMode .. "|" .. gemQuality .. "|" .. (MSC.ScoringRevision or 0) .. "|" .. uniqueKey
    if globalUniques and next(globalUniques) then
        -- skip cache when tracking unique-equipped gems across character score
    elseif weights and MSC.ProcessedStatCache and MSC.ProcessedStatCache[procKey] then
        return MSC:SafeCopy(MSC.ProcessedStatCache[procKey], {})
    end
    
    local rawStats = MSC.GetRawItemStats(itemLink)
    local finalStats = {}
    for k,v in pairs(rawStats) do if k ~= "_BONUS_STATS" then finalStats[k] = v end end
    local bonusStats = rawStats._BONUS_STATS or {}
    local baseLink = MSC.GetBaseLink and MSC.GetBaseLink(itemLink) or nil
    local baseRaw = nil

    if baseLink and baseLink ~= itemLink then
        baseRaw = MSC.GetRawItemStats(baseLink)
        if not next(bonusStats) and baseRaw._BONUS_STATS and next(baseRaw._BONUS_STATS) then
            bonusStats = baseRaw._BONUS_STATS
        end
    end

    if not weights then return finalStats end
    
    local level = UnitLevel("player")
    
    local derivedSlotId = slotId
    if not derivedSlotId and MSC.SlotMap then
        local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
        if equipLoc then derivedSlotId = MSC.SlotMap[equipLoc] end
    end
    
    local physicalEnchantID = 0
    local currentEnchantData = nil
    local itemString = string_match(itemLink, "item[%-?%d:]+")
    if itemString then
        local _, _, eid = strsplit(":", itemString)
        physicalEnchantID = tonumber(eid) or 0
    end

    if physicalEnchantID > 0 and MSC.EnchantDB and MSC.EnchantDB[physicalEnchantID] then
        currentEnchantData = MSC.EnchantDB[physicalEnchantID]
    elseif baseRaw then
        currentEnchantData = InferCurrentEnchantFromDelta(derivedSlotId, rawStats, baseRaw)
    end

    if currentEnchantData and currentEnchantData.stats then
        for k, v in pairs(currentEnchantData.stats) do
            if type(v) == "number" then
                local removable = v
                if baseRaw then
                    removable = math_min(v, math_max(0, (rawStats[k] or 0) - (baseRaw[k] or 0)))
                elseif (finalStats[k] or 0) < v then
                    removable = 0
                end

                if removable > 0 then
                    finalStats[k] = math_max(0, (finalStats[k] or 0) - removable)
                end
            end
        end
    end

    if derivedSlotId and enchantMode ~= 1 then
        if enchantMode == 2 then
            local equippedLink = GetInventoryItemLink("player", derivedSlotId)
            if equippedLink then
                local eqEnchantID = 0
                local eqStr = string_match(equippedLink, "item[%-?%d:]+")
                if eqStr then
                    local _, _, eid = strsplit(":", eqStr)
                    eqEnchantID = tonumber(eid) or 0
                end
                
                if eqEnchantID > 0 and MSC.EnchantDB and MSC.EnchantDB[eqEnchantID] then
                    local eqData = MSC.EnchantDB[eqEnchantID]
                    if eqData.stats then
                        for k, v in pairs(eqData.stats) do
                            if type(v) == "number" then finalStats[k] = (finalStats[k] or 0) + v end
                        end
                    end
                    finalStats.IS_PROJECTED = true
                    finalStats.ENCHANT_TEXT = eqData.name .. " " .. MSC.L["(Equipped)"]
                end
            end
            
        elseif enchantMode == 3 then
            local enchantType = MSC:GetValidEnchantType(itemLink)
            if not enchantType and derivedSlotId then
                  local s = derivedSlotId
                  if s==1 or s==3 or s==5 or s==6 or s==7 or s==8 or s==9 or s==10 then enchantType = "Armor"
                  elseif s==15 then enchantType = "Armor" 
                  elseif s==17 then enchantType = "Shield"
                  end
            end

            if enchantType then
                local bestID = MSC.GetBestEnchantForSlot(derivedSlotId, level, specName, enchantType, weights)
                if bestID and MSC.EnchantDB[bestID] then
                    local bestData = MSC.EnchantDB[bestID]
                    if bestData.stats then
                        for k, v in pairs(bestData.stats) do 
                            if type(v) == "number" then finalStats[k] = (finalStats[k] or 0) + v end
                        end
                    end
                    finalStats.IS_PROJECTED = true
                    finalStats.ENCHANT_TEXT = bestData.name
                end
            end
        end
    end

    if not MSC.IsEra and gemMode ~= 1 then
        wipe(Scratch_GemTextParts); wipe(Scratch_ProjectedIDs); wipe(Scratch_GemCounts); wipe(Scratch_GemOrder)
        wipe(Scratch_GemStats); wipe(Scratch_GemColors); wipe(Scratch_ProjectedColors)
        Scratch_ProjectedColors.RED=0; Scratch_ProjectedColors.YELLOW=0; Scratch_ProjectedColors.BLUE=0
        local projectedMeta = nil
        local isJC = MSC:IsJewelcrafter() -- Grabbing JC Status

        if gemMode == 1 then
            for k, v in pairs(bonusStats) do finalStats[k] = (finalStats[k] or 0) + v end
        else
            local baseLink = MSC.GetBaseLink(itemLink)
            local socketsToFill = {}
            local existingGems = {}
            
            if gemMode == 3 then
                local currentGems = { string_match(itemLink, "item:%d+:%d+:(%d+):(%d+):(%d+):(%d+)") }
                for _, gID in ipairs(currentGems) do
                    local id = tonumber(gID)
                    if id and id > 0 and MSC.GetGemStatsByID then
                        local gData = MSC.GetGemStatsByID(id)
                        if gData then
                            if gData.stat then finalStats[gData.stat] = math_max(0, (finalStats[gData.stat] or 0) - (gData.val or 0)) end
                            if gData.stat2 then finalStats[gData.stat2] = math_max(0, (finalStats[gData.stat2] or 0) - (gData.val2 or 0)) end
                        end
                    end
                end
                socketsToFill = GetItemStats(baseLink) or {} 
                
            elseif gemMode == 2 then
                socketsToFill = GetItemStats(itemLink) or {} 
                local _, _, ids = MSC:GetItemGems(itemLink)
                for _, id in ipairs(ids) do table_insert(existingGems, id) end
                for _, gID in ipairs(existingGems) do
                    local id = tonumber(gID)
                    if id and id > 0 then
                        local gData = MSC.GetGemStatsByID(id)
                        if gData then
                            if gData.stat then finalStats[gData.stat] = math_max(0, (finalStats[gData.stat] or 0) - (gData.val or 0)) end
                            if gData.stat2 then finalStats[gData.stat2] = math_max(0, (finalStats[gData.stat2] or 0) - (gData.val2 or 0)) end
                        end
                    end
                end
            end

            local totalSockets = 0
            for _, colorKey in ipairs({"EMPTY_SOCKET_RED", "EMPTY_SOCKET_YELLOW", "EMPTY_SOCKET_BLUE", "EMPTY_SOCKET_META", "EMPTY_SOCKET_PRISMATIC"}) do
                totalSockets = totalSockets + (socketsToFill[colorKey] or 0)
            end
            local totalFilled = 0
            for _, gID in ipairs(existingGems) do
                if tonumber(gID) and tonumber(gID) > 0 then totalFilled = totalFilled + 1 end
            end
            local socketsLeftToProject = math_max(0, totalSockets - totalFilled)

            for _, gID in ipairs(existingGems) do
                MSC.ApplyGemColorCount(MSC.GetGemStatsByID(gID), Scratch_ProjectedColors)
            end

            if MSC.GetBaseLink and MSC.GetBestGemForSocket then
                wipe(Scratch_MatchGems); wipe(Scratch_PureGems)
                local matchScore = 0; local pureScore = 0
                local socketKeys = {"EMPTY_SOCKET_RED", "EMPTY_SOCKET_YELLOW", "EMPTY_SOCKET_BLUE", "EMPTY_SOCKET_META", "EMPTY_SOCKET_PRISMATIC"}

                local uniqueTrackerMatch = globalUniques and MSC:SafeCopy(globalUniques) or {} 
                for _, colorKey in ipairs(socketKeys) do
                    local count = socketsToFill[colorKey] or 0
                    for i=1, count do
                        if gemMode == 2 and socketsLeftToProject <= 0 then break end
                        local bestGem, score = MSC.GetBestGemForSocket(colorKey, level, weights, uniqueTrackerMatch, isJC)
                        if bestGem then 
                            matchScore = matchScore + score
                            table_insert(Scratch_MatchGems, bestGem)
                            if bestGem.unique then uniqueTrackerMatch[bestGem.id] = true end
                            if gemMode == 2 then socketsLeftToProject = socketsLeftToProject - 1 end
                        end
                    end
                end
                local matchCandidateIDs = { unpack(existingGems) }
                for _, g in ipairs(Scratch_MatchGems) do table_insert(matchCandidateIDs, g.id) end
                local matchBonusActive = MSC.SolveColorMatch(matchCandidateIDs, baseLink)
                if matchBonusActive and next(bonusStats) then
                      for k,v in pairs(bonusStats) do if weights[k] then matchScore = matchScore + (v * weights[k]) end end
                end

                if gemMode == 3 then
                    local uniqueTrackerPure = globalUniques and MSC:SafeCopy(globalUniques) or {}
                    for _, colorKey in ipairs(socketKeys) do
                        local count = socketsToFill[colorKey] or 0
                        for i=1, count do
                            local searchKey = (colorKey == "EMPTY_SOCKET_META") and "EMPTY_SOCKET_META" or "ANY"
                            local bestGem, score = MSC.GetBestGemForSocket(searchKey, level, weights, uniqueTrackerPure, isJC)
                            if bestGem then 
                                pureScore = pureScore + score
                                table_insert(Scratch_PureGems, bestGem)
                                if bestGem.unique then uniqueTrackerPure[bestGem.id] = true end
                            end
                        end
                    end
                    local pureCandidateIDs = { unpack(existingGems) }
                    for _, g in ipairs(Scratch_PureGems) do table_insert(pureCandidateIDs, g.id) end
                    local pureBonusActive = MSC.SolveColorMatch(pureCandidateIDs, baseLink)
                    if pureBonusActive and next(bonusStats) then
                         for k,v in pairs(bonusStats) do if weights[k] then pureScore = pureScore + (v * weights[k]) end end
                    end
                end

                local usePure = (gemMode == 3) and (pureScore > matchScore)
                local chosenGems = usePure and Scratch_PureGems or Scratch_MatchGems
                local bonusActive = usePure and (MSC.SolveColorMatch(MSC:SafeCopy(existingGems), baseLink)) or matchBonusActive 
                
                if globalUniques then
                    for _, gem in ipairs(chosenGems) do
                        if gem.unique then globalUniques[gem.id] = true end
                    end
                end 
                if usePure then
                    local allGems = { unpack(existingGems) }
                    for _, g in ipairs(Scratch_PureGems) do table_insert(allGems, g.id) end
                    bonusActive = MSC.SolveColorMatch(allGems, baseLink)
                end
                
                for _, gem in ipairs(chosenGems) do
                    if gem.stat then 
                        finalStats[gem.stat] = (finalStats[gem.stat] or 0) + gem.val 
                        Scratch_GemStats[gem.stat] = (Scratch_GemStats[gem.stat] or 0) + gem.val 
                    end
                    if gem.stat2 then 
                        finalStats[gem.stat2] = (finalStats[gem.stat2] or 0) + gem.val2 
                        Scratch_GemStats[gem.stat2] = (Scratch_GemStats[gem.stat2] or 0) + gem.val2 
                    end
                    if gem.isMeta then projectedMeta = gem.id end
                    MSC.ApplyGemColorCount(gem.colorType and gem or MSC.GetGemStatsByID(gem.id), Scratch_ProjectedColors)
                    table_insert(Scratch_ProjectedIDs, gem.id)
                end
                
                if bonusActive and next(bonusStats) then
                    for k, v in pairs(bonusStats) do 
                        finalStats[k] = (finalStats[k] or 0) + v 
                        Scratch_GemStats[k] = (Scratch_GemStats[k] or 0) + v
                    end
                    finalStats.BONUS_PROJECTED = true
                end
                
                local function AddToDisplay(id)
                    local gName = GetItemInfo(id)
                    local cType = MSC.GetGemColor(id) or "Unknown"
                    if type(cType) == "string" then cType = cType:sub(1,1)..cType:sub(2):lower() end
                    if not gName then 
                        local g = MSC.GetGemStatsByID(id)
                        gName = g and (MSC.StatShortNames[g.stat] or MSC.L["Gem"]) or MSC.L["Gem"]
                    end
                    if not Scratch_GemCounts[gName] then
                        Scratch_GemCounts[gName] = 0; Scratch_GemColors[gName] = cType; table_insert(Scratch_GemOrder, gName)
                    end
                    Scratch_GemCounts[gName] = Scratch_GemCounts[gName] + 1
                end
                for _, id in ipairs(existingGems) do AddToDisplay(id) end
                for _, gem in ipairs(chosenGems) do AddToDisplay(gem.id) end
                
                finalStats.PROJECTION_DATA = { Gems = {}, Bonus = nil, Stats = "" }
                for _, gName in ipairs(Scratch_GemOrder) do
                    table_insert(finalStats.PROJECTION_DATA.Gems, { text = Scratch_GemCounts[gName] .. "x " .. gName, color = Scratch_GemColors[gName] })
                end
                if bonusActive and next(bonusStats) then
                    local bParts = {}
                    for k, v in pairs(bonusStats) do table_insert(bParts, "+" .. v .. " " .. ((MSC.StatShortNames and MSC.StatShortNames[k]) or "Stat")) end
                    finalStats.PROJECTION_DATA.Bonus = MSC.L["Socket Bonus: "] .. table_concat(bParts, ", ")
                end
                local statParts = {}
                for k, v in pairs(Scratch_GemStats) do
                    local short = (MSC.StatShortNames and MSC.StatShortNames[k]) or MSC.L["Stat"]
                    table_insert(statParts, "+" .. v .. " " .. short)
                end
                if #statParts > 0 then finalStats.PROJECTION_DATA.Stats = "(" .. table_concat(statParts, ", ") .. ")" end

                finalStats.GEMS_PROJECTED = #finalStats.PROJECTION_DATA.Gems
                finalStats.META_ID = projectedMeta
                finalStats.COLORS = MSC:SafeCopy(Scratch_ProjectedColors)
            end
        end
    end
    if weights and MSC.ProcessedStatCache and not (globalUniques and next(globalUniques)) then
        MSC.ProcessedStatCache[procKey] = MSC:SafeCopy(finalStats, {})
    end
    return finalStats
end

-- =============================================================
-- 9. MISC HELPERS
-- =============================================================
function MSC.GetInterpolatedRatio(table, level)
    if not table then return nil end
    if level <= table[1][1] then return table[1][2] end
    local count = #table
    if level >= table[count][1] then return table[count][2] end
    for i = 1, count - 1 do
        local lowNode, highNode = table[i], table[i+1]
        if level >= lowNode[1] and level <= highNode[1] then
            return lowNode[2] + ((level - lowNode[1]) / (highNode[1] - lowNode[1])) * (highNode[2] - lowNode[2])
        end
    end
    return table[count][2]
end

function MSC.ExpandDerivedStats(stats, itemLink, dest)
    if not dest then dest = {} end
    wipe(dest)
    if not stats then return dest end
    for k, v in pairs(stats) do dest[k] = v end
    return dest
end

function MSC.GetBaseLink(itemLink)
    if not itemLink then return nil end
    local id = string_match(itemLink, "item:(%d+)")
    if id then return "item:" .. id .. ":0:0:0:0:0:0:0:0" end
    return itemLink
end

-- =============================================================
-- 10. SCORING ENGINE
-- =============================================================
function MSC.GetItemScore(stats, weights, specName, slotId)
    if not stats or not weights then return 0 end
    if stats._MANUAL_SCORE and stats._MANUAL_SCORE > 0 then
        return math_max(0, MSC.Round(stats._MANUAL_SCORE, 1))
    end
    local score = 0
    local usefulRaw = 0
    local uselessRaw = 0

    for stat, val in pairs(stats) do
        if stat == "_MANUAL_SCORE" or stat == "_AUTO_PROC" or stat == "IS_PROJECTED" or stat == "GEMS_PROJECTED" or stat == "BONUS_PROJECTED" then
            -- metadata keys
        elseif type(val) == "number" then
            local weightKey = stat
            if slotId == 17 and (stat == "MSC_WEAPON_DPS" or stat == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT") then
                if weights["MSC_WEAPON_DPS_OH"] then weightKey = "MSC_WEAPON_DPS_OH" end
            end
            if slotId == 17 and stat == "MSC_WEAPON_SPEED" then
                if weights["MSC_OH_WEAPON_SPEED"] then weightKey = "MSC_OH_WEAPON_SPEED" end
            end
            
            if weights[weightKey] then 
                local finalVal = val
                local w = weights[weightKey]
                if slotId == 17 and weightKey == stat and (stat == "MSC_WEAPON_DPS" or stat == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT") then finalVal = val * 0.5 end
                score = score + (finalVal * w)
                if w >= 0.02 then usefulRaw = usefulRaw + val else uselessRaw = uselessRaw + val end
            end
        end
    end
    
    if not MSC.IsEra and stats["ITEM_MOD_RESILIENCE_RATING_SHORT"] then
        local resVal = stats["ITEM_MOD_RESILIENCE_RATING_SHORT"]
        local resWeight = weights["ITEM_MOD_RESILIENCE_RATING_SHORT"] or 0
        if resVal > 0 and resWeight <= 0.05 then score = score - (resVal * 1.5) end
    end

    if uselessRaw > (usefulRaw * 2) then return 0 end
    return math_max(0, MSC.Round(score, 1))
end

function MSC.ApplyElvUISkin(frame) end

-- =============================================================
-- 11. EXTERNAL HELPERS
-- =============================================================
function MSC:GetItemSetID(itemIDOrLink)
    if not itemIDOrLink then return nil end
    local _, _, _, _, _, _, _, _, _, _, _, _, _, _, setID = GetItemInfo(itemIDOrLink)
    if setID then return setID end
    local tipName = "MSC_ScannerTooltip"
    local tip = _G[tipName] or CreateFrame("GameTooltip", tipName, nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE"); tip:ClearLines()
    local status = pcall(function() tip:SetHyperlink(itemIDOrLink) end)
    if status then
        for i = 2, tip:NumLines() do
            local line = _G[tipName.."TextLeft"..i]
            local text = line and line:GetText()
            local setPattern = MSC.L["^Set: (.*) %("] or "^Set: (.*) %("
				if string_find(text, MSC.L["Set: "] or "Set: ") then
					local setName = string_match(text, setPattern)
					return setName
				end
            end
        end
    return nil
end

local Scratch_ItemColors = { RED=0, YELLOW=0, BLUE=0 }
local Scratch_ItemGemIDs = {}

function MSC:GetItemGems(itemLink)
    Scratch_ItemColors.RED = 0; Scratch_ItemColors.YELLOW = 0; Scratch_ItemColors.BLUE = 0; wipe(Scratch_ItemGemIDs)
    local metaID = nil
    if not itemLink then return MSC:SafeCopy(Scratch_ItemColors), nil, MSC:SafeCopy(Scratch_ItemGemIDs) end
    
    local g1, g2, g3, g4 = string_match(itemLink, "item:%d+:%d+:(%d+):(%d+):(%d+):(%d+)")
    local foundGems = { tonumber(g1), tonumber(g2), tonumber(g3), tonumber(g4) }
    
    for _, id in ipairs(foundGems) do
        if id and id > 0 then
            table_insert(Scratch_ItemGemIDs, id)
            if MSC.GemOptions and MSC.GemOptions["EMPTY_SOCKET_META"] then
                for _, g in ipairs(MSC.GemOptions["EMPTY_SOCKET_META"]) do if g.id == id then metaID = id; break end end
            end
            local cType = MSC.GetGemColor and MSC.GetGemColor(id)
            if cType then
                if cType == "RED" then Scratch_ItemColors.RED = Scratch_ItemColors.RED + 1
                elseif cType == "YELLOW" then Scratch_ItemColors.YELLOW = Scratch_ItemColors.YELLOW + 1
                elseif cType == "BLUE" then Scratch_ItemColors.BLUE = Scratch_ItemColors.BLUE + 1
                elseif cType == "ORANGE" then Scratch_ItemColors.RED = Scratch_ItemColors.RED + 1; Scratch_ItemColors.YELLOW = Scratch_ItemColors.YELLOW + 1
                elseif cType == "PURPLE" then Scratch_ItemColors.RED = Scratch_ItemColors.RED + 1; Scratch_ItemColors.BLUE = Scratch_ItemColors.BLUE + 1
                elseif cType == "GREEN" then Scratch_ItemColors.YELLOW = Scratch_ItemColors.YELLOW + 1; Scratch_ItemColors.BLUE = Scratch_ItemColors.BLUE + 1
                elseif cType == "PRISMATIC" then Scratch_ItemColors.RED = Scratch_ItemColors.RED + 1; Scratch_ItemColors.YELLOW = Scratch_ItemColors.YELLOW + 1; Scratch_ItemColors.BLUE = Scratch_ItemColors.BLUE + 1 end
            end
        end
    end
    return MSC:SafeCopy(Scratch_ItemColors), metaID, MSC:SafeCopy(Scratch_ItemGemIDs)
end

-- =============================================================
-- 12. DEBUG
-- =============================================================
function MSC:DebugItem()
    local tip = GameTooltip
    local _, link = tip:GetItem()
    if not link then print(MSC.L["|cffff0000SGJ: Please hover over an item to debug.|r"]) return end
    local weights, specName = MSC.GetCurrentWeights()
    if not weights then print(MSC.L["|cffff0000SGJ: No weights loaded.|r"]) return end
    local stats = MSC.SafeGetItemStats(link, nil, weights, specName)
    local score = 0
    print(" ")
    print(MSC.L["|cff00ccff--- SGJ DEBUG REPORT ---|r"])
	print(MSC.L["Item: "] .. link)
	print(MSC.L["Profile: "] .. "|cffffd100" .. (specName or MSC.L["Unknown"]) .. "|r")
    for stat, val in pairs(stats) do
        if type(val) == "number" then
            local w = weights[stat]
            if w then
                local lineScore = val * w
                score = score + lineScore
                local statName = string_gsub(string_gsub(stat, "ITEM_MOD_", ""), "_SHORT", "")
                print(string_format(MSC.L["|cffffffff%s:|r %.1f x %.2f = |cff00ff00%.1f|r"], statName, val, w, lineScore))
            else
                local statName = string_gsub(string_gsub(stat, "ITEM_MOD_", ""), "_SHORT", "")
                print(string_format(MSC.L["|cff888888%s: %.1f (Weight: 0)|r"], statName, val))
            end
        end
    end
    local useful, useless = 0, 0
    for stat, val in pairs(stats) do
        if type(val) == "number" then
            if (weights[stat] or 0) >= 0.1 then useful = useful + val else useless = useless + val end
        end
    end
		print(MSC.L["Ratio Check: "] .. string_format(MSC.L["Useful: %.1f / Useless: %.1f"], useful, useless))
		if useless > (useful * 2) then 
			print(MSC.L["|cffff0000[FAIL] Item rejected by Bouncer (Mostly Junk)|r"])
		else 
			print(MSC.L["|cff00ff00[PASS] Item accepted|r"]) 
		end
		print(MSC.L["Final Score: "] .. "|cff00ccff" .. MSC.Round(score, 1) .. "|r")
end

function MSC:GetDefenseFloor(rule)
    if rule and rule.dynamic then
        return UnitLevel("player") * 5 + 140
    end
    return rule and rule.base or 0
end

-- =============================================================
-- 13. LOAD SAVED WEIGHTS (Startup Race Condition Handler)
-- =============================================================
local dbLoader = CreateFrame("Frame")
dbLoader:RegisterEvent("PLAYER_LOGIN")
dbLoader:SetScript("OnEvent", function()
    C_Timer.After(0.5, function()
        if SharpiesGearJudgeDB and SharpiesGearJudgeDB.customWeights and SGJ_Settings then
            local mode = SGJ_Settings.Mode
            if mode and mode ~= "AUTO" and SharpiesGearJudgeDB.customWeights[mode] then
                MSC.CachedWeights = nil
                MSC.CachedWeightsBySpec = MSC.CachedWeightsBySpec or {}
                wipe(MSC.CachedWeightsBySpec)
                if MSC.BumpScoringRevision then MSC:BumpScoringRevision() end
            end
        end
        if MSC.InitSettingsView and MSC.MainFrame and MSC.MainFrame:IsShown() then
            MSC.InitSettingsView(MSC.MainFrame.Content)
        end
    end)
end)

-- =============================================================
-- 14. COMBAT LAB: ON-USE TRINKET DETECTION
-- =============================================================
function MSC.IsValuableOnUseTrinket(itemID)
    if not itemID then return false end

    -- Search the three primary databases where you store trinket data
    local data = MSC.TrinketDB[itemID] or MSC.ItemOverrides[itemID] or MSC.ProcDB[itemID]

    if data and data.note then
        local noteStr = tostring(data.note)
        
        -- We only care about trinkets that have an active "Use:" effect
        if string.find(noteStr, "Use:") then
            -- We want to pop throughput stats during Burn Phases. 
            -- This filters out Defensive/Health/Utility trinkets.
            if string.find(noteStr, "AP") or 
               string.find(noteStr, "SP") or 
               string.find(noteStr, "Haste") or 
               string.find(noteStr, "Heal") or 
               string.find(noteStr, "Damage") or
               string.find(noteStr, "Crit") then
                return true
            end
        end
    end
    
    return false
end
