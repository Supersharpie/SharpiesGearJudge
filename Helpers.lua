local addonName, MSC = ...

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

function MSC.IsItemUsable(itemLink)
    if not itemLink then return false end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    local localizedClass, playerClass = UnitClass("player")

    -- 1. WEAPON CHECK
    if classID == 2 then 
        if MSC.CurrentClass and MSC.CurrentClass.ValidWeapons then
            if not MSC.CurrentClass.ValidWeapons[subClassID] then return false end
        end
    end

    -- 2. ARMOR CHECK (Fixed for Level 40 Training)
    if classID == 4 then 
        local level = UnitLevel("player")
        local maxArmor = 1 -- Cloth (Default)
        
        if playerClass == "WARRIOR" or playerClass == "PALADIN" then 
            -- Plate at 40, Mail below 40
            maxArmor = (level >= 40) and 4 or 3
        elseif playerClass == "SHAMAN" or playerClass == "HUNTER" then 
            -- Mail at 40, Leather below 40
            maxArmor = (level >= 40) and 3 or 2
        elseif playerClass == "ROGUE" or playerClass == "DRUID" then 
            maxArmor = 2 
        end
        
        if subClassID == 6 then -- Shield
            if playerClass ~= "WARRIOR" and playerClass ~= "PALADIN" and playerClass ~= "SHAMAN" then return false end
        elseif subClassID > 0 and subClassID <= 4 then -- Cloth/Leather/Mail/Plate
             if subClassID > maxArmor then return false end
        end
    end

    -- 3. CLASS/RACE RESTRICTION SCAN
    local tip = _G["MSC_ScannerTooltip"] or CreateFrame("GameTooltip", "MSC_ScannerTooltip", nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE"); tip:ClearLines()
    local status = pcall(function() tip:SetHyperlink(itemLink) end)
    
    if status then
        for i = 2, tip:NumLines() do
            local line = _G["MSC_ScannerTooltipTextLeft"..i]
            local text = line and line:GetText()
            if text then
                if text:find("Classes:") or (ITEM_CLASSES_ALLOWED and text:find(ITEM_CLASSES_ALLOWED:gsub("%%s", ""))) then
                    if not text:find(localizedClass) then return false end
                end
                if text:find("Races:") or (ITEM_RACES_ALLOWED and text:find(ITEM_RACES_ALLOWED:gsub("%%s", ""))) then
                     local localizedRace = UnitRace("player")
                     if not text:find(localizedRace) then return false end
                end
            end
        end
    end
    return true
end

-- =============================================================
-- 2. API SHIMS
-- =============================================================
function MSC.getItemID(bagID, slotID)
    if not bagID or not slotID then return nil end
    local itemInfo = C_Container.GetContainerItemInfo(bagID, slotID)
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

function MSC:GetSpiritValueInMP5(level, spirit)
    if not MSC.BaseRegenTable then return 0 end
    local _, class = UnitClass("player")
    if MSC.IsEra then
        if class == "PRIEST" or class == "MAGE" then return (spirit / 4) + 12.5 end
        return (spirit / 5) + 15
    else
        if not level or level > 70 then level = 70 end
        local base = MSC.BaseRegenTable[level] or 0.009327
        local intel = UnitStat("player", 4) or 100
        return 5 * (base * math.sqrt(intel))
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
            if math.abs(diff) > 0.01 then
                table.insert(outTable, { key = k, val = diff })
            end
            processed[k] = true
        end
    end
    for k, valOld in pairs(oldStats) do
        if not processed[k] and not ignoreKeys[k] and type(valOld) == "number" then
            local diff = 0 - valOld
            if math.abs(diff) > 0.01 then
                table.insert(outTable, { key = k, val = diff })
            end
        end
    end
    return outTable
end

function MSC.SortStatDiffs(diffs)
    table.sort(diffs, function(a,b) return a.val > b.val end)
    return diffs
end

function MSC.GetCleanStatName(key)
    if MSC.ShortNames and MSC.ShortNames[key] then return MSC.ShortNames[key] end
    local s = key:gsub("ITEM_MOD_", ""):gsub("_SHORT", ""):gsub("_", " ")
    return string.lower(s):gsub("^%l", string.upper)
end

-- =============================================================
-- 4. PAWN PARSER
-- =============================================================
MSC.PawnStatMap = {
    ["Strength"] = "ITEM_MOD_STRENGTH_SHORT", ["Agility"] = "ITEM_MOD_AGILITY_SHORT",
    ["Stamina"] = "ITEM_MOD_STAMINA_SHORT", ["Intellect"] = "ITEM_MOD_INTELLECT_SHORT",
    ["Spirit"] = "ITEM_MOD_SPIRIT_SHORT", ["CritRating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["HitRating"] = "ITEM_MOD_HIT_RATING_SHORT", ["HasteRating"] = "ITEM_MOD_HASTE_RATING_SHORT",
    ["ResilienceRating"] = "ITEM_MOD_RESILIENCE_RATING_SHORT", ["ArmorPenetration"] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",
    ["SpellPower"] = "ITEM_MOD_SPELL_POWER_SHORT", ["Healing"] = "ITEM_MOD_HEALING_POWER_SHORT",
    ["SpellCritRating"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT", ["SpellHitRating"] = "ITEM_MOD_HIT_SPELL_RATING_SHORT",
    ["SpellHasteRating"] = "ITEM_MOD_SPELL_HASTE_RATING_SHORT", ["Mp5"] = "ITEM_MOD_MANA_REGENERATION_SHORT",
    ["DefenseRating"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", ["DodgeRating"] = "ITEM_MOD_DODGE_RATING_SHORT",
    ["ParryRating"] = "ITEM_MOD_PARRY_RATING_SHORT", ["BlockRating"] = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["BlockValue"] = "ITEM_MOD_BLOCK_VALUE_SHORT", ["Dps"] = "MSC_WEAPON_DPS", ["Speed"] = "MSC_WEAPON_SPEED",
}

function MSC:ParsePawnString(pawnString)
    if not pawnString then return nil, "No string" end
    local name = string.match(pawnString, '"([^"]+)"') or "Imported"
    local weights = {}
    for k, v in string.gmatch(pawnString, "([%a%d]+)=([%d%.]+)") do
        local mappedKey = MSC.PawnStatMap and MSC.PawnStatMap[k]
        if mappedKey then weights[mappedKey] = tonumber(v) end
    end
    if not next(weights) then return nil, "No stats" end
    return weights, name
end

-- =============================================================
-- 5. CACHE & CONSTANTS
-- =============================================================
MSC.StatCache = {}
-- Scratch tables for gem calculations
local Scratch_MatchGems = {}
local Scratch_PureGems = {}
local Scratch_GemTextParts = {}
local Scratch_ProjectedIDs = {}
local Scratch_ProjectedColors = { RED=0, YELLOW=0, BLUE=0 }

MSC.StatShortNames = {
    ["MSC_WAND_DPS"] = "Wand DPS", ["MSC_WEAPON_DPS"] = "Weapon DPS", ["MSC_WEAPON_SPEED"] = "Speed", ["MSC_OH_WEAPON_SPEED"] = "OH Speed",
    ["ITEM_MOD_STAMINA_SHORT"] = "Stam", ["ITEM_MOD_INTELLECT_SHORT"] = "Int",
    ["ITEM_MOD_AGILITY_SHORT"] = "Agi", ["ITEM_MOD_STRENGTH_SHORT"] = "Str",
    ["ITEM_MOD_SPIRIT_SHORT"] = "Spt", ["ITEM_MOD_SPELL_POWER_SHORT"] = "SP",
    ["ITEM_MOD_HEALING_POWER_SHORT"] = "Heal", ["ITEM_MOD_MANA_REGENERATION_SHORT"] = "Mp5",
    ["ITEM_MOD_ATTACK_POWER_SHORT"] = "AP", ["ITEM_MOD_CRIT_RATING_SHORT"] = "Crit",
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = "Spell Crit", ["ITEM_MOD_HIT_RATING_SHORT"] = "Hit",
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = "Spell Hit", ["ITEM_MOD_HASTE_RATING_SHORT"] = "Haste",
    ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = "Exp", ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = "Def",
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = "Resil", ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = "ArP",
    ["ITEM_MOD_BLOCK_VALUE_SHORT"] = "BlockVal", ["ITEM_MOD_BLOCK_RATING_SHORT"] = "Block",
    ["ITEM_MOD_DODGE_RATING_SHORT"] = "Dodge", ["ITEM_MOD_PARRY_RATING_SHORT"] = "Parry",
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = "Shadow", ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = "Fire",
    ["ITEM_MOD_FROST_DAMAGE_SHORT"] = "Frost", ["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = "Arcane",
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = "Nature", ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = "Holy",
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = "Dmg", ["ITEM_MOD_ARMOR_SHORT"] = "Armor"
}

function MSC.Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- =============================================================
-- RATING CONVERTER
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
-- 6. SCANNING (THE FIX IS HERE)
-- =============================================================

function MSC.GetRawItemStats(itemLink)
    if not itemLink then return {} end
    if MSC.StatCache[itemLink] then return MSC.StatCache[itemLink] end

    -- 1. EXECUTE SCANNER
    local scanData = MSC.Scanner.Scan(itemLink)
    
    -- 2. FLATTEN STATS
    local finalStats = scanData.Stats or {}
    local bonusStats = {}

    -- 3. INTEGRATE USE EFFECTS
    for _, effect in ipairs(scanData.UseEffects) do
        if effect.statKey and effect.averageVal and effect.averageVal > 0 then
             finalStats[effect.statKey] = (finalStats[effect.statKey] or 0) + effect.averageVal
             if not finalStats._AUTO_PROC then
                 finalStats._AUTO_PROC = { stat=effect.statKey, val=effect.averageVal }
             end
        end
    end

    -- ========================================================
    -- [[ 4. APPLY DATABASE OVERRIDES (THE MISSING LINK) ]]
    -- ========================================================
    local itemID = tonumber(itemLink:match("item:(%d+)"))
    if itemID then
        local entry = nil
        
        -- Check all databases in order of priority
        if MSC.ProcDB and MSC.ProcDB[itemID] then entry = MSC.ProcDB[itemID]
        elseif MSC.WeaponDB and MSC.WeaponDB[itemID] then entry = MSC.WeaponDB[itemID]
        elseif MSC.TrinketDB and MSC.TrinketDB[itemID] then entry = MSC.TrinketDB[itemID]
        end

        if entry then
            -- Inject Stat Value
            if entry.val and entry.stat then
                finalStats[entry.stat] = (finalStats[entry.stat] or 0) + entry.val
                
                -- Mark as proc so Evaluator can see it
                if not finalStats._AUTO_PROC then
                    finalStats._AUTO_PROC = { stat=entry.stat, val=entry.val }
                end
            end
            
            -- Inject Flat Score (For purely mechanic-based items)
            if entry.score then
                finalStats._MANUAL_SCORE = entry.score
            end
        end
    end
    -- ========================================================

    -- 5. HANDLE SOCKET BONUSES
    if scanData.Meta and scanData.Meta.BonusStats then
        bonusStats = scanData.Meta.BonusStats
    end

    -- 6. ATTACH BONUS TABLE
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
    if not candidates or #candidates == 0 then
        candidates = MSC.EnchantCandidates and MSC.EnchantCandidates[slotId]
    end
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

function MSC.GetBestGemForSocket(socketColor, level, weights, excludeList)
    local bestGem, bestScore = nil, 0
    local db = (level >= 60 and MSC.GemOptions) and MSC.GemOptions or MSC.GemOptions_Leveling
    if not db or not weights then return nil, 0 end

    local lists = {}
    if socketColor == "ANY" then
        if db["EMPTY_SOCKET_RED"] then table.insert(lists, db["EMPTY_SOCKET_RED"]) end
        if db["EMPTY_SOCKET_YELLOW"] then table.insert(lists, db["EMPTY_SOCKET_YELLOW"]) end
        if db["EMPTY_SOCKET_BLUE"] then table.insert(lists, db["EMPTY_SOCKET_BLUE"]) end
    elseif socketColor == "EMPTY_SOCKET_META" then
        if db["EMPTY_SOCKET_META"] then table.insert(lists, db["EMPTY_SOCKET_META"]) end
    else
        if socketColor == "EMPTY_SOCKET_PRISMATIC" then
            if db["EMPTY_SOCKET_RED"] then table.insert(lists, db["EMPTY_SOCKET_RED"]) end
            if db["EMPTY_SOCKET_YELLOW"] then table.insert(lists, db["EMPTY_SOCKET_YELLOW"]) end
            if db["EMPTY_SOCKET_BLUE"] then table.insert(lists, db["EMPTY_SOCKET_BLUE"]) end
        else
            if db[socketColor] then table.insert(lists, db[socketColor]) end
            if db["PRISMATIC_GEMS"] then table.insert(lists, db["PRISMATIC_GEMS"]) end
        end
    end

    for _, list in ipairs(lists) do
        for _, gem in ipairs(list) do
            local isUniqueBlocked = (gem.unique and excludeList and excludeList[gem.id])
            if not isUniqueBlocked then
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
-- FIXED: GEM CACHE & LOOKUP
-- =============================================================
MSC.GemIDCache = {}

function MSC:BuildGemCache()
    local dbs = { MSC.GemOptions, MSC.GemOptions_Leveling }
    for _, db in ipairs(dbs) do
        if db then
            for _, list in pairs(db) do
                for _, gem in ipairs(list) do 
                    MSC.GemIDCache[gem.id] = gem 
                end
            end
        end
    end
end

function MSC.GetGemStatsByID(gemID)
    if not gemID then return nil end
    local id = tonumber(gemID)
    
    -- 1. Fast Lookup
    if MSC.GemIDCache[id] then return MSC.GemIDCache[id] end
    
    -- 2. Build Cache if missing (Lazy Load)
    MSC:BuildGemCache()
    
    -- 3. Retry Lookup
    return MSC.GemIDCache[id]
end

function MSC.GetGemColor(gemID)
    local gem = MSC.GetGemStatsByID(gemID)
    if gem and gem.colorType then return gem.colorType end
    
    local _, _, _, _, _, _, _, _, _, icon = GetItemInfo(gemID or 0)
    if icon then
        if icon:find("Red") or icon:find("Garnet") or icon:find("Ruby") then return "RED"
        elseif icon:find("Yellow") or icon:find("Golden") or icon:find("Dawnstone") then return "YELLOW"
        elseif icon:find("Blue") or icon:find("Azure") or icon:find("Star") then return "BLUE"
        elseif icon:find("Orange") or icon:find("Topaz") then return "ORANGE"
        elseif icon:find("Purple") or icon:find("Nightseye") then return "PURPLE"
        elseif icon:find("Green") or icon:find("Talasite") then return "GREEN" end
    end
    return nil
end

-- =============================================================
-- 8. THE MAIN PARSER (SafeGetItemStats)
-- =============================================================
function MSC.SafeGetItemStats(itemLink, slotId, weights, specName)
    if not itemLink then return {} end
    
    -- 1. BASE SCAN (Reads everything including current enchants)
    local rawStats = MSC.GetRawItemStats(itemLink)
    local finalStats = {}
    for k,v in pairs(rawStats) do if k ~= "_BONUS_STATS" then finalStats[k] = v end end
    local bonusStats = rawStats._BONUS_STATS or {}

    if not weights then return finalStats end
    
    local enchantMode = SGJ_Settings and SGJ_Settings.EnchantMode or 1
    local gemMode = SGJ_Settings and SGJ_Settings.GemMode or 1
    local level = UnitLevel("player")
    
    if slotId then
        -- [FIX] Only strip/manipulate enchants if we are NOT in Mode 1 (Off/Raw)
        if enchantMode ~= 1 then
            
            -- A. IDENTIFY PHYSICAL ENCHANT ON ITEM (The one we might want to strip)
            local physicalEnchantID = 0
            local itemString = string.match(itemLink, "item[%-?%d:]+")
            if itemString then
                local _, _, eid = strsplit(":", itemString)
                physicalEnchantID = tonumber(eid) or 0
            end

            -- B. STRIP PHYSICAL ENCHANT (Reset to Naked so we can project)
            if physicalEnchantID > 0 and MSC.EnchantDB and MSC.EnchantDB[physicalEnchantID] then
                local pData = MSC.EnchantDB[physicalEnchantID]
                if pData.stats then
                    for k, v in pairs(pData.stats) do
                        if type(v) == "number" and (finalStats[k] or 0) >= v then
                            finalStats[k] = finalStats[k] - v
                        end
                    end
                end
            end

            -- C. APPLY MODE LOGIC
            if enchantMode == 2 then
                -- CURRENT MODE: Transfer Equipped Enchant -> Mouseover
                local equippedLink = GetInventoryItemLink("player", slotId)
                if equippedLink then
                    local eqEnchantID = 0
                    local eqStr = string.match(equippedLink, "item[%-?%d:]+")
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
                        finalStats.ENCHANT_TEXT = eqData.name .. " (Equipped)"
                    end
                end
                
            elseif enchantMode == 3 then
                -- BEST MODE: Sim Best
                local enchantType = MSC:GetValidEnchantType(itemLink)
                -- Fallback if type lookup fails but we know the slot
                if not enchantType and slotId then
                     local s = slotId
                     if s==1 or s==3 or s==5 or s==6 or s==7 or s==8 or s==9 or s==10 then enchantType = "Armor"
                     elseif s==15 then enchantType = "Armor" 
                     elseif s==17 then enchantType = "Shield"
                     end
                end

                if enchantType then
                    local bestID = MSC.GetBestEnchantForSlot(slotId, level, specName, enchantType, weights)
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
    end

    if not MSC.IsEra and gemMode ~= 1 then
        wipe(Scratch_GemTextParts)
        wipe(Scratch_ProjectedIDs)
        wipe(Scratch_ProjectedColors); Scratch_ProjectedColors.RED=0; Scratch_ProjectedColors.YELLOW=0; Scratch_ProjectedColors.BLUE=0
        local projectedMeta = nil

        if gemMode == 1 then
            for k, v in pairs(bonusStats) do finalStats[k] = (finalStats[k] or 0) + v end
        else
            local currentGems = { itemLink:match("item:%d+:%d+:(%d+):(%d+):(%d+):(%d+)") }
            if gemMode == 3 then
                for _, gID in ipairs(currentGems) do
                    local id = tonumber(gID)
                    if id and id > 0 and MSC.GetGemStatsByID then
                        local gData = MSC.GetGemStatsByID(id)
                        if gData then
                            if gData.stat then finalStats[gData.stat] = math.max(0, (finalStats[gData.stat] or 0) - (gData.val or 0)) end
                            if gData.stat2 then finalStats[gData.stat2] = math.max(0, (finalStats[gData.stat2] or 0) - (gData.val2 or 0)) end
                        end
                    end
                end
            end

            if MSC.GetBaseLink and MSC.GetBestGemForSocket then
                wipe(Scratch_MatchGems); wipe(Scratch_PureGems)
                local matchScore = 0; local pureScore = 0
                
                local baseLink = MSC.GetBaseLink(itemLink)
                local rawForSockets = GetItemStats(baseLink) or {}
                local socketKeys = {"EMPTY_SOCKET_RED", "EMPTY_SOCKET_YELLOW", "EMPTY_SOCKET_BLUE", "EMPTY_SOCKET_META", "EMPTY_SOCKET_PRISMATIC"}

                local uniqueTrackerMatch = {} 
                if next(bonusStats) then
                    for k,v in pairs(bonusStats) do 
                        if weights[k] then matchScore = matchScore + (v * weights[k]) end 
                    end
                end
                for _, colorKey in ipairs(socketKeys) do
                    local count = rawForSockets[colorKey] or 0
                    for i=1, count do
                        local bestGem, score = MSC.GetBestGemForSocket(colorKey, level, weights, uniqueTrackerMatch)
                        if bestGem then 
                            matchScore = matchScore + score
                            table.insert(Scratch_MatchGems, bestGem)
                            if bestGem.unique then uniqueTrackerMatch[bestGem.id] = true end
                        end
                    end
                end

                local uniqueTrackerPure = {}
                for _, colorKey in ipairs(socketKeys) do
                    local count = rawForSockets[colorKey] or 0
                    for i=1, count do
                        local searchKey = (colorKey == "EMPTY_SOCKET_META") and "EMPTY_SOCKET_META" or "ANY"
                        local bestGem, score = MSC.GetBestGemForSocket(searchKey, level, weights, uniqueTrackerPure)
                        if bestGem then 
                            pureScore = pureScore + score
                            table.insert(Scratch_PureGems, bestGem)
                            if bestGem.unique then uniqueTrackerPure[bestGem.id] = true end
                        end
                    end
                end

                local chosenGems = (matchScore >= pureScore) and Scratch_MatchGems or Scratch_PureGems
                local useBonus = (matchScore >= pureScore) and next(bonusStats)

                for _, gem in ipairs(chosenGems) do
                    if gem.stat then finalStats[gem.stat] = (finalStats[gem.stat] or 0) + gem.val end
                    if gem.stat2 then finalStats[gem.stat2] = (finalStats[gem.stat2] or 0) + gem.val2 end
                    if gem.isMeta then projectedMeta = gem.id end
                    table.insert(Scratch_ProjectedIDs, gem.id)
                    table.insert(Scratch_GemTextParts, "1x " .. (MSC.StatShortNames[gem.stat] or "Gem"))
                    
                    local cType = MSC.GetGemColor and MSC.GetGemColor(gem.id)
                    if cType then
                        if cType == "RED" then Scratch_ProjectedColors.RED = Scratch_ProjectedColors.RED + 1
                        elseif cType == "YELLOW" then Scratch_ProjectedColors.YELLOW = Scratch_ProjectedColors.YELLOW + 1
                        elseif cType == "BLUE" then Scratch_ProjectedColors.BLUE = Scratch_ProjectedColors.BLUE + 1
                        elseif cType == "ORANGE" then Scratch_ProjectedColors.RED = Scratch_ProjectedColors.RED + 1; Scratch_ProjectedColors.YELLOW = Scratch_ProjectedColors.YELLOW + 1
                        elseif cType == "PURPLE" then Scratch_ProjectedColors.RED = Scratch_ProjectedColors.RED + 1; Scratch_ProjectedColors.BLUE = Scratch_ProjectedColors.BLUE + 1
                        elseif cType == "GREEN" then Scratch_ProjectedColors.YELLOW = Scratch_ProjectedColors.YELLOW + 1; Scratch_ProjectedColors.BLUE = Scratch_ProjectedColors.BLUE + 1
                        elseif cType == "PRISMATIC" then Scratch_ProjectedColors.RED = Scratch_ProjectedColors.RED + 1; Scratch_ProjectedColors.YELLOW = Scratch_ProjectedColors.YELLOW + 1; Scratch_ProjectedColors.BLUE = Scratch_ProjectedColors.BLUE + 1 end
                    end
                end
                
                if useBonus then
                    for k, v in pairs(bonusStats) do finalStats[k] = (finalStats[k] or 0) + v end
                    finalStats.BONUS_PROJECTED = true
                end
                
                finalStats.GEMS_PROJECTED = #Scratch_GemTextParts
                finalStats.META_ID = projectedMeta
                if #Scratch_GemTextParts > 0 then finalStats.GEM_TEXT = table.concat(Scratch_GemTextParts, ", ") end
                
                finalStats.COLORS = MSC:SafeCopy(Scratch_ProjectedColors)
            end
        end
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
    local id = itemLink:match("item:(%d+)")
    if id then return "item:" .. id .. ":0:0:0:0:0:0:0:0" end
    return itemLink
end

-- =============================================================
-- SCORING ENGINE (The Calculator)
-- =============================================================
function MSC.GetItemScore(stats, weights, specName, slotId)
    if not stats or not weights then return 0 end
    local score = 0
    
    -- 1. Setup Counters for the "Bouncer"
    local usefulRaw = 0
    local uselessRaw = 0

    for stat, val in pairs(stats) do
        local weightKey = stat
        
        -- [[ EXISTING LOGIC: Swap DPS key for Offhand ]]
        if slotId == 17 and (stat == "MSC_WEAPON_DPS" or stat == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT") then
            if weights["MSC_WEAPON_DPS_OH"] then 
                weightKey = "MSC_WEAPON_DPS_OH" 
            end
        end

        -- [[ NEW LOGIC: Swap SPEED key for Offhand ]]
        if slotId == 17 and stat == "MSC_WEAPON_SPEED" then
            if weights["MSC_OH_WEAPON_SPEED"] then 
                weightKey = "MSC_OH_WEAPON_SPEED" 
            end
        end
        
        if weights[weightKey] and type(val) == "number" then 
            local finalVal = val
            local w = weights[weightKey]
            
            if slotId == 17 and weightKey == stat and (stat == "MSC_WEAPON_DPS" or stat == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT") then 
                finalVal = val * 0.5 
            end
            
            score = score + (finalVal * w)
            
            -- [[ THE BOUNCER LOGIC ]]
            -- We track how much raw stat value is "Useful" vs "Useless"
            if w >= 0.1 then
                usefulRaw = usefulRaw + val
            else
                uselessRaw = uselessRaw + val
            end
        end
    end
    
    -- [[ 2. RESILIENCE PENALTY (Keep this for PvE) ]]
    if not MSC.IsEra and stats["ITEM_MOD_RESILIENCE_RATING_SHORT"] then
        local resVal = stats["ITEM_MOD_RESILIENCE_RATING_SHORT"]
        local resWeight = weights["ITEM_MOD_RESILIENCE_RATING_SHORT"] or 0
        if resVal > 0 and resWeight <= 0.05 then 
            score = score - (resVal * 1.5) 
        end
    end
    
    -- [[ 3. THE FIX: RATIO CHECK INSTEAD OF POISON ]]
    -- Instead of subtracting points, we check if the item is "Mostly Junk".
    -- If useless stats are more than double the useful stats, the item is trash.
    -- Example: Ring of Strength (+10 Str). Useful: 0. Useless: 10. RESULT: 0 Score.
    -- Example: Seal of Wrynn (+6 Bad, +11 Good). Useful: 11. Useless: 6. RESULT: Score Kept.
    
    if uselessRaw > (usefulRaw * 2) then
        return 0
    end
    
    return math.max(0, MSC.Round(score, 1))
end

function MSC.ApplyElvUISkin(frame) end

-- =============================================================
-- 10. EXTERNAL HELPERS
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
            if text then
                 if text:find("Set: ") then
                     local setName = text:match("Set: (.*) %(")
                     return setName
                 end
            end
        end
    end
    return nil
end

local Scratch_ItemColors = { RED=0, YELLOW=0, BLUE=0 }
local Scratch_ItemGemIDs = {}

function MSC:GetItemGems(itemLink)
    -- Reset the scratch tables
    Scratch_ItemColors.RED = 0; Scratch_ItemColors.YELLOW = 0; Scratch_ItemColors.BLUE = 0;
    wipe(Scratch_ItemGemIDs)
    
    local metaID = nil
    if not itemLink then 
        return MSC:SafeCopy(Scratch_ItemColors), nil, MSC:SafeCopy(Scratch_ItemGemIDs) 
    end
    
    local g1, g2, g3, g4 = itemLink:match("item:%d+:%d+:(%d+):(%d+):(%d+):(%d+)")
    local foundGems = { tonumber(g1), tonumber(g2), tonumber(g3), tonumber(g4) }
    
    for _, id in ipairs(foundGems) do
        if id and id > 0 then
            table.insert(Scratch_ItemGemIDs, id)
            
            -- Check for Meta Gem ID
            if MSC.GemOptions and MSC.GemOptions["EMPTY_SOCKET_META"] then
                for _, g in ipairs(MSC.GemOptions["EMPTY_SOCKET_META"]) do 
                    if g.id == id then metaID = id; break end 
                end
            end
            
            -- Count Colors
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
    
    -- RETURN COPIES, NOT REFERENCES
    return MSC:SafeCopy(Scratch_ItemColors), metaID, MSC:SafeCopy(Scratch_ItemGemIDs)
end

-- =============================================================
-- 11. DEBUG
-- =============================================================
function MSC:DebugItem()
    local tip = GameTooltip
    local _, link = tip:GetItem()
    
    if not link then 
        print("|cffff0000SGJ: Please hover over an item to debug.|r")
        return 
    end

    local weights, specName = MSC.GetCurrentWeights()
    if not weights then 
        print("|cffff0000SGJ: No weights loaded.|r") 
        return 
    end

    local stats = MSC.SafeGetItemStats(link, nil, weights, specName)
    local score = 0
    
    print(" ")
    print("|cff00ccff--- SGJ DEBUG REPORT ---|r")
    print("Item: " .. link)
    print("Profile: |cffffd100" .. (specName or "Unknown") .. "|r")

    -- 1. Print valid stats
    for stat, val in pairs(stats) do
        if type(val) == "number" then
            local w = weights[stat]
            if w then
                local lineScore = val * w
                score = score + lineScore
                local statName = stat:gsub("ITEM_MOD_", ""):gsub("_SHORT", "")
                print(string.format("|cffffffff%s:|r %.1f x %.2f = |cff00ff00%.1f|r", statName, val, w, lineScore))
            else
                -- Print unweighted stats in grey so you see what is being ignored
                local statName = stat:gsub("ITEM_MOD_", ""):gsub("_SHORT", "")
                print(string.format("|cff888888%s: %.1f (Weight: 0)|r", statName, val))
            end
        end
    end
    
    -- 2. Check the "Bouncer" Logic
    local useful, useless = 0, 0
    for stat, val in pairs(stats) do
        if type(val) == "number" then
            if (weights[stat] or 0) >= 0.1 then useful = useful + val 
            else useless = useless + val end
        end
    end
    
    print("Ratio Check: " .. string.format("Useful: %.1f / Useless: %.1f", useful, useless))
    if useless > (useful * 2) then
        print("|cffff0000[FAIL] Item rejected by Bouncer (Mostly Junk)|r")
    else
        print("|cff00ff00[PASS] Item accepted|r")
    end
    
    print("Final Score: |cff00ccff" .. MSC.Round(score, 1) .. "|r")
end