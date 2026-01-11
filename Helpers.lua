local addonName, MSC = ...

-- =============================================================
-- 1. UTILITIES
-- =============================================================
function MSC:SafeCopy(orig, dest)
    wipe(dest or {})
    local copy = dest or {}
    if not orig then return copy end
    for k,v in pairs(orig) do copy[k] = v end
    return copy
end

function MSC.GetBaseLink(itemLink)
    if not itemLink then return nil end
    local id = itemLink:match("item:(%d+)")
    if id then
        return "item:" .. id .. ":0:0:0:0:0:0:0:0"
    end
    return itemLink
end

-- =============================================================
-- 2. CONSTANTS & CACHE
-- =============================================================
MSC.StatCache = {} 

-- RECYCLING BIN (Scratchpads)
local Scratch_MatchGems = {}
local Scratch_PureGems = {}
local Scratch_GemTextParts = {}
local Scratch_ProjectedIDs = {} 
local Scratch_ProjectedColors = { RED=0, YELLOW=0, BLUE=0 }

MSC.StatShortNames = {
    ["MSC_WAND_DPS"] = "Wand DPS",
    ["MSC_WEAPON_DPS"] = "Weapon DPS",
    ["MSC_WEAPON_SPEED"] = "Speed",
    ["ITEM_MOD_STAMINA_SHORT"] = "Stam",
    ["ITEM_MOD_INTELLECT_SHORT"] = "Int",
    ["ITEM_MOD_AGILITY_SHORT"] = "Agi",
    ["ITEM_MOD_STRENGTH_SHORT"] = "Str",
    ["ITEM_MOD_SPIRIT_SHORT"] = "Spt",
    ["ITEM_MOD_SPELL_POWER_SHORT"] = "SP",
    ["ITEM_MOD_HEALING_POWER_SHORT"] = "Heal",
    ["ITEM_MOD_MANA_REGENERATION_SHORT"] = "Mp5",
    ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = "Hp5",
    ["ITEM_MOD_ATTACK_POWER_SHORT"] = "AP",
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = "Feral AP",
    ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = "Ranged AP",
    ["ITEM_MOD_CRIT_RATING_SHORT"] = "Crit",
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = "Spell Crit",
    ["ITEM_MOD_HIT_RATING_SHORT"] = "Hit",
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = "Spell Hit",
    ["ITEM_MOD_HASTE_RATING_SHORT"] = "Haste",
    ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = "Exp",
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = "Def",
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = "Resil",
    ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = "ArP",
    ["ITEM_MOD_BLOCK_VALUE_SHORT"] = "BlockVal",
    ["ITEM_MOD_BLOCK_RATING_SHORT"] = "Block",
    ["ITEM_MOD_DODGE_RATING_SHORT"] = "Dodge",
    ["ITEM_MOD_PARRY_RATING_SHORT"] = "Parry",
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = "Shadow",
    ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = "Fire",
    ["ITEM_MOD_FROST_DAMAGE_SHORT"] = "Frost",
    ["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = "Arcane",
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = "Nature",
    ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = "Holy",
    ["ITEM_MOD_CONDITIONAL_AP_SHORT"] = "AP (Conditional)",
    ["ITEM_MOD_CRIT_FROM_STATS_SHORT"] = "Crit (from Agi/Int)",
    ["ITEM_MOD_STATS_ALL_SHORT"] = "All Stats",
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = "Dmg",
    ["ITEM_MOD_ARMOR_SHORT"] = "Armor",
    ["MSC_PVP_UTILITY"] = "PvP Utility"
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

function MSC.IsItemUsable(link)
    if not link then return false end
    local _, _, _, _, _, _, subType, _, equipLoc, _, _, classID, subclassID = GetItemInfo(link)
    local _, playerClass = UnitClass("player")
    
    if equipLoc == "INVTYPE_RELIC" then
        if playerClass == "DRUID" or playerClass == "PALADIN" or playerClass == "SHAMAN" then
            if subType then
                if playerClass == "DRUID" and (subType == "Totem" or subType == "Libram") then return false end
                if playerClass == "PALADIN" and (subType == "Totem" or subType == "Idol") then return false end
                if playerClass == "SHAMAN" and (subType == "Libram" or subType == "Idol") then return false end
            end
            return true
        end
        return false
    end
    if equipLoc == "INVTYPE_THROWN" then return (playerClass == "WARRIOR" or playerClass == "ROGUE" or playerClass == "HUNTER") end
    
    if classID == 4 then -- Armor
        if playerClass == "MAGE" or playerClass == "WARLOCK" or playerClass == "PRIEST" then 
            if subclassID and subclassID > 1 then return false end 
        elseif playerClass == "ROGUE" or playerClass == "DRUID" then 
            if subclassID and subclassID > 2 then return false end 
        elseif playerClass == "HUNTER" then 
            if subclassID and subclassID > 3 then return false end 
        elseif playerClass == "SHAMAN" then
            if subclassID and subclassID > 3 and subclassID ~= 6 then return false end 
        end
    end
    
    if classID == 2 and MSC.CurrentClass and MSC.CurrentClass.ValidWeapons then
        if subclassID and not MSC.CurrentClass.ValidWeapons[subclassID] then return false end
    end
    return true
end

function MSC:GetValidEnchantType(itemLink)
    if not itemLink then return nil end
    local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, classID, subClassID = GetItemInfo(itemLink)
    
    if not classID then return nil end 

    if itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_RANGEDRIGHT" then
        if subClassID == 2 or subClassID == 3 or subClassID == 18 then return "SCOPE" end
        return nil 
    end
    
    if classID == 2 then 
        if itemEquipLoc == "INVTYPE_2HWEAPON" then return "2H_WEAPON" end
        return "WEAPON"
    end
    
    if classID == 4 then 
        if subClassID == 6 or itemEquipLoc == "INVTYPE_SHIELD" then return "SHIELD" end
        if subClassID == 0 and (itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND") then return nil end
        if itemEquipLoc == "INVTYPE_HOLDABLE" then return nil end
        return "ARMOR"
    end
    
    return nil
end

-- =============================================================
-- 2. DATABASE LOOKUPS
-- =============================================================

function MSC.GetBestEnchantForSlot(slotId, level, specName, enchantType, weights)
    local bestScore, bestID = 0, nil
    if not MSC.EnchantDB or not weights then return nil end

    local candidates = (level >= 60) and MSC.EnchantCandidates or MSC.EnchantCandidates_Leveling
    local slotList = candidates[slotId]
    if not slotList then return nil end

    for _, eID in ipairs(slotList) do
        local data = MSC.EnchantDB[eID]
        if data then
            local isValid = true
            if enchantType == "SCOPE" and not data.isScope then isValid = false
            elseif enchantType == "SHIELD" and not data.isShield then isValid = false
            elseif (enchantType == "WEAPON" or enchantType == "2H_WEAPON") and (data.isShield or data.isScope) then isValid = false
            end
            
            if isValid then
                local score = MSC.GetItemScore(data.stats, weights, specName)
                if score > bestScore then
                    bestScore = score
                    bestID = eID
                end
            end
        end
    end
    return bestID
end

function MSC.GetBestGemForSocket(socketColor, level, weights)
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
            local score = 0
            if gem.stat and weights[gem.stat] then score = score + (gem.val * weights[gem.stat]) end
            if gem.stat2 and weights[gem.stat2] then score = score + (gem.val2 * weights[gem.stat2]) end
            if score > bestScore then bestScore = score; bestGem = gem end
        end
    end
    return bestGem, bestScore
end

function MSC.GetGemStatsByID(gemID)
    if not gemID then return nil end
    local id = tonumber(gemID)
    local dbs = { MSC.GemOptions, MSC.GemOptions_Leveling }
    for _, db in ipairs(dbs) do
        if db then
            for _, list in pairs(db) do
                for _, gem in ipairs(list) do 
                    if gem.id == id then return gem end 
                end
            end
        end
    end
    return nil
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
-- 3. SCANNING & PARSING
-- =============================================================
function MSC.ParseTooltipLine(text)
    if not text then return nil, 0, false end
    if text:find("Set:") and not text:find("ff00ff00") then return nil, 0, false end
    local isSocketBonus = false
    if text:find("Socket Bonus:") then isSocketBonus = true end

    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if text:find("^Use:") or text:find("^Chance on hit:") or text:find("when fighting") then return nil, 0, false end
    
    local patterns = {
        -- [[ FIX: FERAL AP MUST BE FIRST ]]
        -- We prioritize this pattern. If we find "in Cat", we grab it as Feral AP 
        -- and return immediately so the generic "Attack Power" pattern below doesn't steal it.
        { p = "attack power by (%d+) in Cat", s = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },
        { p = "attack power by (%d+) in Bear", s = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },

        -- [[ STANDARD STATS ]]
        { p = "Increases defense rating by (%d+)", s = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { p = "Increases your parry rating by (%d+)", s = "ITEM_MOD_PARRY_RATING_SHORT" },
        { p = "Increases your dodge rating by (%d+)", s = "ITEM_MOD_DODGE_RATING_SHORT" },
        { p = "Increases your block rating by (%d+)", s = "ITEM_MOD_BLOCK_RATING_SHORT" },
        { p = "Increases your shield block value by (%d+)", s = "ITEM_MOD_BLOCK_VALUE_SHORT" },
        { p = "Increases your hit rating by (%d+)", s = "ITEM_MOD_HIT_RATING_SHORT" },
        { p = "Increases your spell hit rating by (%d+)", s = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        { p = "Increases your critical strike rating by (%d+)", s = "ITEM_MOD_CRIT_RATING_SHORT" },
        { p = "Increases your spell critical strike rating by (%d+)", s = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
        { p = "Increases your resilience rating by (%d+)", s = "ITEM_MOD_RESILIENCE_RATING_SHORT" },
        { p = "Increases your haste rating by (%d+)", s = "ITEM_MOD_HASTE_RATING_SHORT" },
        { p = "Increases your expertise rating by (%d+)", s = "ITEM_MOD_EXPERTISE_RATING_SHORT" },
        { p = "Increases attack power by (%d+)", s = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { p = "Speed (%d+%.%d+)", s = "MSC_WEAPON_SPEED" },
        { p = "damage done by Shadow.-up to (%d+)", s = "ITEM_MOD_SHADOW_DAMAGE_SHORT" },
        { p = "damage done by Fire.-up to (%d+)", s = "ITEM_MOD_FIRE_DAMAGE_SHORT" },
        { p = "damage done by Frost.-up to (%d+)", s = "ITEM_MOD_FROST_DAMAGE_SHORT" },
        { p = "damage done by Arcane.-up to (%d+)", s = "ITEM_MOD_ARCANE_DAMAGE_SHORT" },
        { p = "damage done by Nature.-up to (%d+)", s = "ITEM_MOD_NATURE_DAMAGE_SHORT" },
        { p = "damage done by Holy.-up to (%d+)", s = "ITEM_MOD_HOLY_DAMAGE_SHORT" },
        { p = "Shadow damage.-up to (%d+)", s = "ITEM_MOD_SHADOW_DAMAGE_SHORT" },
        { p = "Fire damage.-up to (%d+)", s = "ITEM_MOD_FIRE_DAMAGE_SHORT" },
        { p = "Frost damage.-up to (%d+)", s = "ITEM_MOD_FROST_DAMAGE_SHORT" },
        { p = "Arcane damage.-up to (%d+)", s = "ITEM_MOD_ARCANE_DAMAGE_SHORT" },
        { p = "Nature damage.-up to (%d+)", s = "ITEM_MOD_NATURE_DAMAGE_SHORT" },
        { p = "Holy damage.-up to (%d+)", s = "ITEM_MOD_HOLY_DAMAGE_SHORT" },
        { p = "damage and healing.-up to (%d+)", s = "ITEM_MOD_SPELL_POWER_SHORT" },
        { p = "magical spells.-up to (%d+)", s = "ITEM_MOD_SPELL_POWER_SHORT" },
        { p = "healing done.-up to (%d+)", s = "ITEM_MOD_HEALING_POWER_SHORT" },
        { p = "spells and effects.-up to (%d+)", s = "ITEM_MOD_HEALING_POWER_SHORT" },
        { p = "Increases spell power by (%d+)", s = "ITEM_MOD_SPELL_POWER_SHORT" }, 
        { p = "critical strike.-spells.-(%d+)%%", s = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" }, 
        { p = "critical strike.-(%d+)%%", s = "ITEM_MOD_CRIT_RATING_SHORT" }, 
        { p = "spell hit rating by (%d+)", s = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        { p = "(%d+) mana per 5 sec", s = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { p = "(%d+) health per 5 sec", s = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
        { p = "Restores (%d+) health", s = "ITEM_MOD_HEALTH_REGENERATION_SHORT" }, 
        { p = "Restores (%d+) mana", s = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { p = "%+(%d+) Attack Power", s = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { p = "%+(%d+) Stamina", s = "ITEM_MOD_STAMINA_SHORT" },
        { p = "%+(%d+) Intellect", s = "ITEM_MOD_INTELLECT_SHORT" },
        { p = "%+(%d+) Spirit", s = "ITEM_MOD_SPIRIT_SHORT" },
        { p = "%+(%d+) Strength", s = "ITEM_MOD_STRENGTH_SHORT" },
        { p = "%+(%d+) Agility", s = "ITEM_MOD_AGILITY_SHORT" },
        { p = "%+(%d+) Health", s = "ITEM_MOD_HEALTH_SHORT" },
        { p = "Health %+(%d+)", s = "ITEM_MOD_HEALTH_SHORT" },
        { p = "%+(%d+) Mana", s = "ITEM_MOD_MANA_SHORT" },
        { p = "Mana %+(%d+)", s = "ITEM_MOD_MANA_SHORT" },
        { p = "%+(%d+) Armor", s = "ITEM_MOD_ARMOR_SHORT" }, 
        { p = "Armor %+(%d+)", s = "ITEM_MOD_ARMOR_SHORT" },
        { p = "%+(%d+) Block", s = "ITEM_MOD_BLOCK_VALUE_SHORT" },
        { p = "%+(%d+) Damage", s = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
        { p = "%+(%d+) Weapon Damage", s = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
        { p = "%+(%d+) Defense", s = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { p = "%+(%d+) All Stats", s = "ITEM_MOD_STATS_ALL_SHORT" },
        { p = "up to (%d+)%.?$", s = "ITEM_MOD_SPELL_POWER_SHORT" },
        { p = "^(%d+) Armor", s = "ITEM_MOD_ARMOR_SHORT" },
        { p = "Armor (%d+)", s = "ITEM_MOD_ARMOR_SHORT" },
        { p = "^(%d+) Damage", s = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
        { p = "(%d+%.%d+) Damage Per Second", s = "MSC_WEAPON_DPS" },
    }

    for _, d in ipairs(patterns) do
        local val = text:match(d.p)
        if val then
            return d.s, tonumber(val), isSocketBonus
        end
    end
    return nil, 0, false
end

function MSC:ParseProcText(text, itemID)
    if not text or not text:find("^Use:") then return nil, 0 end
    local amount = tonumber(text:match("by (%d+)")) or tonumber(text:match("cost.-by (%d+)"))
    if not amount then return nil, 0 end
    local duration = tonumber(text:match("for (%d+) sec"))
    if not duration then return nil, 0 end

    local cooldownSecs = nil
    local cdMin = tonumber(text:match("%((%d+) Min.-Cooldown%)"))
    if cdMin then 
        cooldownSecs = cdMin * 60 
        local extraSec = tonumber(text:match("Min (%d+) Sec"))
        if extraSec then cooldownSecs = cooldownSecs + extraSec end
    end
    if not cooldownSecs then
        local cdSec = tonumber(text:match("%((%d+) Sec.-Cooldown%)"))
        if cdSec then cooldownSecs = cdSec end
    end
    if not cooldownSecs or cooldownSecs == 0 then return nil, 0 end

    local statName = nil
    if text:find("Haste") then statName = "ITEM_MOD_HASTE_RATING_SHORT"
    elseif text:find("Strength") then statName = "ITEM_MOD_STRENGTH_SHORT"
    elseif text:find("Agility") then statName = "ITEM_MOD_AGILITY_SHORT"
    elseif text:find("Intellect") then statName = "ITEM_MOD_INTELLECT_SHORT"
    elseif text:find("Attack Power") then statName = "ITEM_MOD_ATTACK_POWER_SHORT"
    elseif text:find("Spell Power") then statName = "ITEM_MOD_SPELL_POWER_SHORT"
    elseif text:find("Block Rating") then statName = "ITEM_MOD_BLOCK_RATING_SHORT" 
    elseif text:find("Dodge Rating") then statName = "ITEM_MOD_DODGE_RATING_SHORT" 
    elseif text:find("Defense Rating") then statName = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"
    end
    
    if not statName then return nil, 0 end
    local averageValue = (amount * duration) / cooldownSecs
    return statName, averageValue
end

-- =============================================================
-- 4. RAW SCANNER
-- =============================================================
function MSC.GetRawItemStats(itemLink)
    if not itemLink then return {} end
    if MSC.StatCache[itemLink] then return MSC.StatCache[itemLink] end

    local finalStats = {}; local bonusStats = {}
    local id = tonumber(itemLink:match("item:(%d+)"))
    local _, _, _, _, _, classID, subclassID = GetItemInfo(itemLink)
    local isWand = (classID == 2 and subclassID == 19)

    local forcedOverride = false
    if id then
        if MSC.ItemOverrides and MSC.ItemOverrides[id] then
            local override = MSC.ItemOverrides[id]
            if not override.estimate then forcedOverride = true end 
            for k, v in pairs(override) do if k ~= "estimate" and k ~= "replace" then finalStats[k] = (finalStats[k] or 0) + v end end
        end
        if MSC.RelicDB and MSC.RelicDB[id] then
            forcedOverride = true 
            for k, v in pairs(MSC.RelicDB[id]) do finalStats[k] = (finalStats[k] or 0) + v end
        end
    end

    if forcedOverride then
        MSC.StatCache[itemLink] = finalStats
        return finalStats
    end

    local stats = GetItemStats(itemLink) or {}
    for k, v in pairs(stats) do
        if MSC.StatShortNames[k] or k:find("SPELL") then 
            if k == "ITEM_MOD_SPELL_HEALING_DONE" then finalStats["ITEM_MOD_HEALING_POWER_SHORT"] = (finalStats["ITEM_MOD_HEALING_POWER_SHORT"] or 0) + v
            elseif k == "ITEM_MOD_SPELL_DAMAGE_DONE" then finalStats["ITEM_MOD_SPELL_POWER_SHORT"] = (finalStats["ITEM_MOD_SPELL_POWER_SHORT"] or 0) + v
            else finalStats[k] = v end
        end
    end
    
    local tipName = "MSC_ScannerTooltip"
    local tip = _G[tipName] or CreateFrame("GameTooltip", tipName, nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE"); tip:ClearLines()
    local status = pcall(function() tip:SetHyperlink(itemLink) end)
    
    if status then
        for i = 2, tip:NumLines() do
            local line = _G[tipName.."TextLeft"..i]
            local text = line and line:GetText()
            local r, g, b = line and line:GetTextColor() or 1, 1, 1
            if text then
                local isGreen = (g > 0.9 and r < 0.9 and b < 0.9)
                local s, v, isBonus = MSC.ParseTooltipLine(text)
                if s and v then
                    if isBonus then 
                        bonusStats[s] = (bonusStats[s] or 0) + v
                    elseif isGreen or not finalStats[s] then
                        finalStats[s] = (finalStats[s] or 0) + v
                    end
                end
                
                if id then
                    local pStat, pVal = MSC:ParseProcText(text, id)
                    if pStat and pVal > 0 then 
                        finalStats._AUTO_PROC = { stat=pStat, val=pVal } 
                    end
                end
            end
        end
    end

    if isWand and finalStats["MSC_WEAPON_DPS"] then
        finalStats["MSC_WAND_DPS"] = finalStats["MSC_WEAPON_DPS"]
        finalStats["MSC_WEAPON_DPS"] = nil
    end
    
    finalStats._BONUS_STATS = bonusStats
    MSC.StatCache[itemLink] = finalStats
    return finalStats
end

-- =============================================================
-- 5. THE SMART GEM AUDITOR (MODE 3) - SAFE VERSION
-- =============================================================
function MSC.SafeGetItemStats(itemLink, slotId, weights, specName)
    if not itemLink then return {} end
    
    local rawStats = MSC.GetRawItemStats(itemLink)
    local finalStats = {} 
    
    for k,v in pairs(rawStats) do if k ~= "_BONUS_STATS" then finalStats[k] = v end end
    local bonusStats = rawStats._BONUS_STATS or {}

    if not weights then return finalStats end

    local enchantMode = SGJ_Settings and SGJ_Settings.EnchantMode or 3
    local gemMode = SGJ_Settings and SGJ_Settings.GemMode or 1
    local level = UnitLevel("player")

    -- [[ ENCHANTS ]]
    if enchantMode == 3 and slotId then
        local currentEnchantID = tonumber(itemLink:match("item:%d+:(%d+):"))
        if currentEnchantID and currentEnchantID > 0 and MSC.EnchantDB and MSC.EnchantDB[currentEnchantID] then
            local eStats = MSC.EnchantDB[currentEnchantID].stats or MSC.EnchantDB[currentEnchantID]
            if eStats then
                for k, v in pairs(eStats) do 
                    if type(v) == "number" then 
                        finalStats[k] = (finalStats[k] or 0) - v
                        if finalStats[k] < 0 then finalStats[k] = 0 end 
                    end
                end
            end
        end

        local enchantType = MSC:GetValidEnchantType(itemLink)
        if enchantType then
            local bestID = MSC.GetBestEnchantForSlot(slotId, level, specName, enchantType, weights)
            if bestID and MSC.EnchantDB[bestID] then
                local eStats = MSC.EnchantDB[bestID].stats or MSC.EnchantDB[bestID]
                if eStats then 
                    for k, v in pairs(eStats) do 
                        if type(v) == "number" then finalStats[k] = (finalStats[k] or 0) + v end 
                    end 
                end
                finalStats.IS_PROJECTED = true
                finalStats.ENCHANT_TEXT = MSC.EnchantDB[bestID].name
            end
        end
    end

    -- [[ GEMS ]]
    wipe(Scratch_GemTextParts)
    wipe(Scratch_ProjectedIDs) -- [NEW] Reset IDs
    wipe(Scratch_ProjectedColors); Scratch_ProjectedColors.RED=0; Scratch_ProjectedColors.YELLOW=0; Scratch_ProjectedColors.BLUE=0
    local projectedMeta = nil

    if gemMode == 1 then
        for k, v in pairs(bonusStats) do finalStats[k] = (finalStats[k] or 0) + v end
    
    elseif gemMode == 2 then
        local socketKeys = {"EMPTY_SOCKET_RED", "EMPTY_SOCKET_YELLOW", "EMPTY_SOCKET_BLUE", "EMPTY_SOCKET_META", "EMPTY_SOCKET_PRISMATIC"}
        local rawForSockets = GetItemStats(itemLink) or {}
        
        for _, colorKey in ipairs(socketKeys) do
            local count = rawForSockets[colorKey] or 0
            if count > 0 then
                for i=1, count do
                    local bestGem, _ = MSC.GetBestGemForSocket(colorKey, level, weights)
                    if bestGem then
                        if bestGem.stat then finalStats[bestGem.stat] = (finalStats[bestGem.stat] or 0) + bestGem.val end
                        if bestGem.stat2 then finalStats[bestGem.stat2] = (finalStats[bestGem.stat2] or 0) + bestGem.val2 end
                        if bestGem.isMeta then projectedMeta = bestGem.id end
                        
                        -- [NEW] Save ID
                        table.insert(Scratch_ProjectedIDs, bestGem.id) 
                        table.insert(Scratch_GemTextParts, "1x " .. (MSC.StatShortNames[bestGem.stat] or "Gem"))
                    end
                end
            end
        end
        for k, v in pairs(bonusStats) do finalStats[k] = (finalStats[k] or 0) + v end
        if #Scratch_GemTextParts > 0 then finalStats.GEMS_PROJECTED = #Scratch_GemTextParts end

    elseif gemMode == 3 then
        local _, _, _, _, g1, g2, g3, g4 = itemLink:find("item:%d+:%d+:(%d+):(%d+):(%d+):(%d+)")
        local currentGems = {tonumber(g1), tonumber(g2), tonumber(g3), tonumber(g4)}
        for _, gID in ipairs(currentGems) do
            if gID and gID > 0 then
                local gData = MSC.GetGemStatsByID(gID)
                if gData then
                    if gData.stat then finalStats[gData.stat] = (finalStats[gData.stat] or 0) - (gData.val or 0) end
                    if gData.stat2 then finalStats[gData.stat2] = (finalStats[gData.stat2] or 0) - (gData.val2 or 0) end
                    if gData.stat and finalStats[gData.stat] < 0 then finalStats[gData.stat] = 0 end
                end
            end
        end

        local baseLink = MSC.GetBaseLink(itemLink)
        local socketKeys = {"EMPTY_SOCKET_RED", "EMPTY_SOCKET_YELLOW", "EMPTY_SOCKET_BLUE", "EMPTY_SOCKET_META", "EMPTY_SOCKET_PRISMATIC"}
        local rawForSockets = GetItemStats(baseLink) or {} 

        wipe(Scratch_MatchGems)
        wipe(Scratch_PureGems)
        local matchScore = 0
        local pureScore = 0

        -- CALC MATCH
        if next(bonusStats) then
            for k,v in pairs(bonusStats) do 
                if weights[k] then matchScore = matchScore + (v * weights[k]) end
            end
        end
        for _, colorKey in ipairs(socketKeys) do
            local count = rawForSockets[colorKey] or 0
            for i=1, count do
                local bestGem, score = MSC.GetBestGemForSocket(colorKey, level, weights)
                if bestGem then 
                    matchScore = matchScore + score 
                    table.insert(Scratch_MatchGems, bestGem)
                end
            end
        end

        -- CALC PURE
        for _, colorKey in ipairs(socketKeys) do
            local count = rawForSockets[colorKey] or 0
            for i=1, count do
                local searchKey = (colorKey == "EMPTY_SOCKET_META") and "EMPTY_SOCKET_META" or "ANY"
                local bestGem, score = MSC.GetBestGemForSocket(searchKey, level, weights)
                if bestGem then 
                    pureScore = pureScore + score 
                    table.insert(Scratch_PureGems, bestGem)
                end
            end
        end

        local chosenGems = (matchScore >= pureScore) and Scratch_MatchGems or Scratch_PureGems
        local useBonus = (matchScore >= pureScore) and next(bonusStats)

        for _, gem in ipairs(chosenGems) do
            if gem.stat then finalStats[gem.stat] = (finalStats[gem.stat] or 0) + gem.val end
            if gem.stat2 then finalStats[gem.stat2] = (finalStats[gem.stat2] or 0) + gem.val2 end
            if gem.isMeta then projectedMeta = gem.id end
            
            if gem.colorType then
                if gem.colorType == "RED" then Scratch_ProjectedColors.RED = Scratch_ProjectedColors.RED + 1 end
                if gem.colorType == "YELLOW" then Scratch_ProjectedColors.YELLOW = Scratch_ProjectedColors.YELLOW + 1 end
                if gem.colorType == "BLUE" then Scratch_ProjectedColors.BLUE = Scratch_ProjectedColors.BLUE + 1 end
                if gem.colorType == "ORANGE" then Scratch_ProjectedColors.RED = Scratch_ProjectedColors.RED + 1; Scratch_ProjectedColors.YELLOW = Scratch_ProjectedColors.YELLOW + 1 end
                if gem.colorType == "PURPLE" then Scratch_ProjectedColors.RED = Scratch_ProjectedColors.RED + 1; Scratch_ProjectedColors.BLUE = Scratch_ProjectedColors.BLUE + 1 end
                if gem.colorType == "GREEN" then Scratch_ProjectedColors.YELLOW = Scratch_ProjectedColors.YELLOW + 1; Scratch_ProjectedColors.BLUE = Scratch_ProjectedColors.BLUE + 1 end
            end
            
            -- [NEW] Save ID
            table.insert(Scratch_ProjectedIDs, gem.id)
            table.insert(Scratch_GemTextParts, "1x " .. (MSC.StatShortNames[gem.stat] or "Gem"))
        end
        
        if useBonus then
            for k, v in pairs(bonusStats) do finalStats[k] = (finalStats[k] or 0) + v end
            finalStats.BONUS_PROJECTED = true
        end
        
        finalStats.GEMS_PROJECTED = #Scratch_GemTextParts
        finalStats.COLORS = { RED=Scratch_ProjectedColors.RED, YELLOW=Scratch_ProjectedColors.YELLOW, BLUE=Scratch_ProjectedColors.BLUE }
        finalStats.META_ID = projectedMeta
    end

    -- [NEW] EXPORT IDs
    if #Scratch_ProjectedIDs > 0 then
        finalStats.PROJECTED_GEM_IDS = {}
        for _, id in ipairs(Scratch_ProjectedIDs) do table.insert(finalStats.PROJECTED_GEM_IDS, id) end
    end
    
    if #Scratch_GemTextParts > 0 then
        finalStats.GEM_TEXT = table.concat(Scratch_GemTextParts, ", ")
    end

    return finalStats
end

-- =============================================================
-- 6. SCORING WRAPPER (The Safe, Opt-In Logic)
-- =============================================================
function MSC.GetItemScore(stats, weights, specName, slotId)
    if not stats or not weights then return 0 end
    local score = 0
    
    for stat, val in pairs(stats) do
        -- 1. DETERMINE THE CORRECT WEIGHT KEY
        local weightKey = stat
        
        -- CHECK: Is this a Weapon in the Offhand Slot?
        -- In TBC, if it's Slot 17 and has DPS, it IS a 1H weapon.
        if slotId == 17 and (stat == "MSC_WEAPON_DPS" or stat == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT") then
            
            -- Does the Class Module want to treat Offhand DPS differently?
            -- (e.g. Arms Warriors set this to 0. Hunters leave it nil.)
            if weights["MSC_WEAPON_DPS_OH"] then
                weightKey = "MSC_WEAPON_DPS_OH"
            end
        end

        -- 2. APPLY WEIGHT
        if weights[weightKey] and type(val) == "number" then 
            local finalVal = val
            local w = weights[weightKey]
            
            -- 3. STANDARD OFFHAND PENALTY
            -- If the class did NOT provide a custom weight (like Hunters),
            -- we apply the standard 50% game penalty for offhands.
            if slotId == 17 and weightKey == stat and (stat == "MSC_WEAPON_DPS" or stat == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT") then
                 finalVal = val * 0.5 
            end
            
            score = score + (finalVal * w) 
        end
    end
    
    -- 4. PvP Tax
    if stats["ITEM_MOD_RESILIENCE_RATING_SHORT"] then
        local resVal = stats["ITEM_MOD_RESILIENCE_RATING_SHORT"]
        local resWeight = weights["ITEM_MOD_RESILIENCE_RATING_SHORT"] or 0
        if resVal > 0 and resWeight <= 0.05 then
            score = score - (resVal * 1.5)
        end
    end
    
    -- 5. Weapon Speed Logic
    if stats.MSC_WEAPON_SPEED and MSC.CurrentClass and MSC.CurrentClass.SpeedChecks then
        local pref = MSC.CurrentClass.SpeedChecks[specName] or MSC.CurrentClass.SpeedChecks["Default"]
        if pref then
            local speed = stats.MSC_WEAPON_SPEED; local bonus = 20 
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
    
    -- 6. Poison Stat Penalty
    local penalty = 0
    local poisonCandidates = { "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_SPELL_POWER_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_AGILITY_SHORT", "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", "ITEM_MOD_PARRY_RATING_SHORT", "ITEM_MOD_DODGE_RATING_SHORT", "ITEM_MOD_MANA_REGENERATION_SHORT", "ITEM_MOD_ATTACK_POWER_SHORT", "ITEM_MOD_CRIT_RATING_SHORT", "ITEM_MOD_HASTE_RATING_SHORT", "ITEM_MOD_HIT_RATING_SHORT", "ITEM_MOD_HIT_SPELL_RATING_SHORT", "ITEM_MOD_SHADOW_DAMAGE_SHORT", "ITEM_MOD_FIRE_DAMAGE_SHORT", "ITEM_MOD_FROST_DAMAGE_SHORT", "ITEM_MOD_ARCANE_DAMAGE_SHORT", "ITEM_MOD_NATURE_DAMAGE_SHORT", "ITEM_MOD_HOLY_DAMAGE_SHORT", "MSC_WAND_DPS" }
    for _, statKey in ipairs(poisonCandidates) do
        if (stats[statKey] or 0) > 0 and (weights[statKey] or 0) <= 0.01 then penalty = penalty + 10 end
    end
    score = score - penalty
    
    return math.max(0, MSC.Round(score, 1))
end

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

-- *** OPTIMIZED: RECYCLABLE DISPLAY FUNCTIONS ***

function MSC.ExpandDerivedStats(stats, itemLink, dest)
    if not dest then dest = {} end
    wipe(dest)
    if not stats then return dest end
    
    for k, v in pairs(stats) do dest[k] = v end
    local _, class = UnitClass("player"); local _, race = UnitRace("player"); local powerType = UnitPowerType("player")
    if itemLink and MSC.RacialTraits and MSC.RacialTraits[race] then
        local _, _, _, _, _, _, _, _, _, _, _, _, subclassID = GetItemInfo(itemLink)
        if subclassID and MSC.RacialTraits[race][subclassID] then
            local val = MSC.RacialTraits[race][subclassID]
            if type(val) == "number" then
                if subclassID == 2 or subclassID == 3 or subclassID == 18 then dest["ITEM_MOD_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_CRIT_RATING_SHORT"] or 0) + val
                else dest["ITEM_MOD_EXPERTISE_RATING_SHORT"] = (dest["ITEM_MOD_EXPERTISE_RATING_SHORT"] or 0) + val end
            elseif type(val) == "table" and val.stat then dest[val.stat] = (dest[val.stat] or 0) + val.val end
        end
    end
    if dest["ITEM_MOD_STAMINA_SHORT"] then dest["ITEM_MOD_HEALTH_SHORT"] = (dest["ITEM_MOD_HEALTH_SHORT"] or 0) + (dest["ITEM_MOD_STAMINA_SHORT"] * 10) end
    if powerType == 0 and dest["ITEM_MOD_INTELLECT_SHORT"] then dest["ITEM_MOD_MANA_SHORT"] = (dest["ITEM_MOD_MANA_SHORT"] or 0) + (dest["ITEM_MOD_INTELLECT_SHORT"] * 15) end
    
    local ratioTable = nil
    if MSC.CurrentClass and MSC.CurrentClass.StatToCritMatrix then ratioTable = MSC.CurrentClass.StatToCritMatrix end
    local myLevel = UnitLevel("player")
    if ratioTable then
        if ratioTable.Agi and dest["ITEM_MOD_AGILITY_SHORT"] then
            local ratio = MSC.GetInterpolatedRatio(ratioTable.Agi, myLevel)
            if ratio and ratio > 0 then dest["ITEM_MOD_CRIT_FROM_STATS_SHORT"] = (dest["ITEM_MOD_CRIT_FROM_STATS_SHORT"] or 0) + (dest["ITEM_MOD_AGILITY_SHORT"] / ratio) end
        end
        if ratioTable.Int and dest["ITEM_MOD_INTELLECT_SHORT"] then
             local ratio = MSC.GetInterpolatedRatio(ratioTable.Int, myLevel)
             if ratio and ratio > 0 then dest["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] = (dest["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] or 0) + (dest["ITEM_MOD_INTELLECT_SHORT"] / ratio) end
        end
    end
    return dest
end

function MSC.GetStatDifferences(new, old, dest)
    if not dest then dest = {} end
    wipe(dest)
    
    local seen = {} 
    for k, v in pairs(new) do 
        if k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" and k ~= "GEM_TEXT" and k ~= "ENCHANT_TEXT" and k ~= "PROJECTED_GEM_IDS" and type(v) == "number" then
            local d = v - (old[k] or 0); if d ~= 0 then table.insert(dest, { key=k, val=d }); seen[k] = true end
        end
    end
    for k, v in pairs(old) do
        if not seen[k] and k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" and k ~= "GEM_TEXT" and k ~= "ENCHANT_TEXT" and k ~= "PROJECTED_GEM_IDS" and type(v) == "number" then
            local d = (new[k] or 0) - v; if d ~= 0 then table.insert(dest, { key=k, val=d }) end
        end
    end
    return dest
end

function MSC.SortStatDiffs(diffs)
    table.sort(diffs, function(a,b) return a.val > b.val end)
    return diffs
end

-- =============================================================
-- 7. HELPERS FOR EVALUATOR (SCRATCHPADS)
-- =============================================================
local Scratch_ItemColors = { RED=0, YELLOW=0, BLUE=0 }
local Scratch_ItemGemIDs = {}

function MSC:GetItemGems(itemLink)
    Scratch_ItemColors.RED = 0; Scratch_ItemColors.YELLOW = 0; Scratch_ItemColors.BLUE = 0;
    wipe(Scratch_ItemGemIDs)
    
    local metaID = nil
    if not itemLink then return Scratch_ItemColors, nil, Scratch_ItemGemIDs end
    
    local _, _, _, _, g1, g2, g3, g4 = string.find(itemLink, "item:%d+:%d+:(%d+):(%d+):(%d+):(%d+)")
    local foundGems = { tonumber(g1), tonumber(g2), tonumber(g3), tonumber(g4) }
    
    for _, id in ipairs(foundGems) do
        if id and id > 0 then
            table.insert(Scratch_ItemGemIDs, id)
            if MSC.GemOptions and MSC.GemOptions["EMPTY_SOCKET_META"] then
                for _, g in ipairs(MSC.GemOptions["EMPTY_SOCKET_META"]) do 
                    if g.id == id then metaID = id; break end 
                end
            end
            
            local cType = MSC.GetGemColor(id)
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
    
    return Scratch_ItemColors, metaID, Scratch_ItemGemIDs
end

function MSC:GetItemSetID(itemIDOrLink)
    if not itemIDOrLink then return nil end
    local name, link, quality, _, _, _, _, _, _, _, _, _, _, _, setID = GetItemInfo(itemIDOrLink)
    if setID then return setID end

    local tipName = "MSC_ScannerTooltip"
    local tip = _G[tipName] or CreateFrame("GameTooltip", tipName, nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE"); tip:ClearLines()
    local status = pcall(function() tip:SetHyperlink(link) end)
    
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

function MSC.GetInspectSpec(unit) return "Default" end
function MSC.ApplyElvUISkin(frame) end