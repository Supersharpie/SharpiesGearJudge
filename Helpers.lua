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
    -- In Era, we don't have gem IDs in the link string, but we strip enchants
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
-- (Gem Scratchpads removed for Era)

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
    -- Era uses % for Hit/Crit, not Ratings, but we map them to the same internal keys for scoring
    ["ITEM_MOD_CRIT_RATING_SHORT"] = "Crit %", 
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = "Spell Crit %",
    ["ITEM_MOD_HIT_RATING_SHORT"] = "Hit %",
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = "Spell Hit %",
    
    -- TBC Stats removed (Resil, Haste, ArP, Exp)
    
    ["ITEM_MOD_BLOCK_VALUE_SHORT"] = "BlockVal",
    ["ITEM_MOD_BLOCK_RATING_SHORT"] = "Block %",
    ["ITEM_MOD_DODGE_RATING_SHORT"] = "Dodge %",
    ["ITEM_MOD_PARRY_RATING_SHORT"] = "Parry %",
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = "Def", -- Defense Skill still exists
    
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
    -- GetItemInfo for Era:
    -- Name, Link, Quality, iLvl, ReqLvl, Type, SubType, Stack, EquipLoc, Tex, Price, ClassID, SubClassID
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
-- 3. DATABASE LOOKUPS (Restored & Adapted for Era)
-- =============================================================

function MSC.GetBestEnchantForSlot(slotId, level, specName, enchantType, weights)
    local bestScore, bestID = 0, nil
    
    -- In Era, we assume just one main EnchantDB, or we treat "Leveling" as < 60
    if not MSC.EnchantDB or not weights then return nil end

    local candidates = (level >= 60) and MSC.EnchantCandidates or MSC.EnchantCandidates_Leveling
    -- Fallback if leveling candidates aren't defined
    if not candidates then candidates = MSC.EnchantCandidates end
    
    if not candidates then return nil end
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

-- [Gems Removed for Era]

-- =============================================================
-- 4. SCANNING & PARSING
-- =============================================================
function MSC.ParseTooltipLine(text)
    if not text then return nil, 0, false end
    if text:find("Set:") and not text:find("ff00ff00") then return nil, 0, false end
    
    -- Era has no socket bonuses
    local isSocketBonus = false 

    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if text:find("^Use:") or text:find("^Chance on hit:") or text:find("when fighting") then return nil, 0, false end
    
    local patterns = {
        -- [[ FIX: FERAL AP MUST BE FIRST ]]
        { p = "attack power by (%d+) in Cat", s = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },
        { p = "attack power by (%d+) in Bear", s = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },

        -- [[ ERA / VANILLA STATS ]]
        { p = "Increases defense by (%d+)", s = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" }, -- Defense Skill
        { p = "Increases defense %+(%d+)", s = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { p = "%+(%d+) Defense", s = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },

        -- Percentages (Era style)
        { p = "Increases your chance to parry an attack by (%d+)%%", s = "ITEM_MOD_PARRY_RATING_SHORT" },
        { p = "Increases your chance to dodge an attack by (%d+)%%", s = "ITEM_MOD_DODGE_RATING_SHORT" },
        { p = "Increases your chance to block an attack by (%d+)%%", s = "ITEM_MOD_BLOCK_RATING_SHORT" },
        { p = "Increases your chance to hit by (%d+)%%", s = "ITEM_MOD_HIT_RATING_SHORT" },
        { p = "Increases your chance to hit with spells by (%d+)%%", s = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        { p = "Increases your chance to get a critical strike by (%d+)%%", s = "ITEM_MOD_CRIT_RATING_SHORT" },
        { p = "Increases your chance to get a critical strike with spells by (%d+)%%", s = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
        
        -- Block Value
        { p = "Increases the block value of your shield by (%d+)", s = "ITEM_MOD_BLOCK_VALUE_SHORT" },
        
        -- Attack Power
        { p = "Increases attack power by (%d+)", s = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { p = "%+(%d+) Attack Power", s = "ITEM_MOD_ATTACK_POWER_SHORT" },

        -- Weapon Speed
        { p = "Speed (%d+%.%d+)", s = "MSC_WEAPON_SPEED" },
        
        -- Spell Damage / Healing (Era specific phrasing)
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
        
        -- Regen
        { p = "(%d+) mana per 5 sec", s = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { p = "(%d+) health per 5 sec", s = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
        { p = "Restores (%d+) health", s = "ITEM_MOD_HEALTH_REGENERATION_SHORT" }, 
        { p = "Restores (%d+) mana", s = "ITEM_MOD_MANA_REGENERATION_SHORT" },

        -- Primary Stats
        { p = "%+(%d+) Stamina", s = "ITEM_MOD_STAMINA_SHORT" },
        { p = "%+(%d+) Intellect", s = "ITEM_MOD_INTELLECT_SHORT" },
        { p = "%+(%d+) Spirit", s = "ITEM_MOD_SPIRIT_SHORT" },
        { p = "%+(%d+) Strength", s = "ITEM_MOD_STRENGTH_SHORT" },
        { p = "%+(%d+) Agility", s = "ITEM_MOD_AGILITY_SHORT" },
        { p = "%+(%d+) Health", s = "ITEM_MOD_HEALTH_SHORT" },
        { p = "Health %+(%d+)", s = "ITEM_MOD_HEALTH_SHORT" },
        { p = "%+(%d+) Mana", s = "ITEM_MOD_MANA_SHORT" },
        { p = "Mana %+(%d+)", s = "ITEM_MOD_MANA_SHORT" },
        
        -- Misc
        { p = "%+(%d+) Armor", s = "ITEM_MOD_ARMOR_SHORT" }, 
        { p = "Armor %+(%d+)", s = "ITEM_MOD_ARMOR_SHORT" },
        { p = "%+(%d+) Block", s = "ITEM_MOD_BLOCK_VALUE_SHORT" },
        { p = "%+(%d+) Damage", s = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
        { p = "%+(%d+) Weapon Damage", s = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
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
    if text:find("Strength") then statName = "ITEM_MOD_STRENGTH_SHORT"
    elseif text:find("Agility") then statName = "ITEM_MOD_AGILITY_SHORT"
    elseif text:find("Intellect") then statName = "ITEM_MOD_INTELLECT_SHORT"
    elseif text:find("Attack Power") then statName = "ITEM_MOD_ATTACK_POWER_SHORT"
    elseif text:find("Spell Power") then statName = "ITEM_MOD_SPELL_POWER_SHORT"
    elseif text:find("Block") then statName = "ITEM_MOD_BLOCK_RATING_SHORT" 
    elseif text:find("Dodge") then statName = "ITEM_MOD_DODGE_RATING_SHORT" 
    elseif text:find("Defense") then statName = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"
    end
    
    if not statName then return nil, 0 end
    local averageValue = (amount * duration) / cooldownSecs
    return statName, averageValue
end

-- =============================================================
-- 5. RAW SCANNER
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
        -- 1. Check Global Overrides (Database.lua)
        if MSC.ItemOverrides and MSC.ItemOverrides[id] then
            local override = MSC.ItemOverrides[id]
            if not override.estimate then forcedOverride = true end 
            for k, v in pairs(override) do 
                if k ~= "estimate" and k ~= "replace" then 
                    finalStats[k] = (finalStats[k] or 0) + v 
                end 
            end
        end

        -- 2. Check Class-Specific Relics
        if MSC.CurrentClass and MSC.CurrentClass.Relics and MSC.CurrentClass.Relics[id] then
            forcedOverride = true 
            local rData = MSC.CurrentClass.Relics[id]
            for k, v in pairs(rData) do 
                finalStats[k] = (finalStats[k] or 0) + v 
            end
        end
    end

    if forcedOverride then
        MSC.StatCache[itemLink] = finalStats
        return finalStats
    end

    -- (Standard Scanner continues below...)
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
                        -- No bonuses in Era, but kept for safety
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
    
    -- Remove bonus stats return (Gems don't exist)
    MSC.StatCache[itemLink] = finalStats
    return finalStats
end

-- =============================================================
-- 6. THE ITEM EVALUATOR (Safe Version for Era)
-- =============================================================
function MSC.SafeGetItemStats(itemLink, slotId, weights, specName)
    if not itemLink then return {} end
    
    local finalStats = MSC.GetRawItemStats(itemLink) or {}
    -- We work on a copy to avoid polluting cache with Projected Enchants
    finalStats = MSC:SafeCopy(finalStats)

    if not weights then return finalStats end

    local enchantMode = SGJ_Settings and SGJ_Settings.EnchantMode or 3
    local level = UnitLevel("player")

    -- [[ ENCHANTS (Only logic left in Era) ]]
    if enchantMode == 3 and slotId then
        -- 1. Remove Existing Enchant Stats
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

        -- 2. Add Projected Best Enchant
        local enchantType = MSC:GetValidEnchantType(itemLink)
        if enchantType then
            local bestID = MSC.GetBestEnchantForSlot(slotId, level, specName, enchantType, weights)
            if bestID and MSC.EnchantDB and MSC.EnchantDB[bestID] then
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

    -- [[ GEMS REMOVED ]]
    return finalStats
end

-- =============================================================
-- 7. SCORING WRAPPER
-- =============================================================
function MSC.GetItemScore(stats, weights, specName, slotId)
    if not stats or not weights then return 0 end
    local score = 0
    
    for stat, val in pairs(stats) do
        -- 1. DETERMINE THE CORRECT WEIGHT KEY
        local weightKey = stat
        
        if slotId == 17 and (stat == "MSC_WEAPON_DPS" or stat == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT") then
            if weights["MSC_WEAPON_DPS_OH"] then
                weightKey = "MSC_WEAPON_DPS_OH"
            end
        end

        -- 2. APPLY WEIGHT
        if weights[weightKey] and type(val) == "number" then 
            local finalVal = val
            local w = weights[weightKey]
            
            -- 3. STANDARD OFFHAND PENALTY
            if slotId == 17 and weightKey == stat and (stat == "MSC_WEAPON_DPS" or stat == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT") then
                 finalVal = val * 0.5 
            end
            
            score = score + (finalVal * w) 
        end
    end
    
    -- Era doesn't have Resilience tax logic needed.
    
    -- 4. Weapon Speed Logic
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
    
    -- 5. Poison Stat Penalty
    local penalty = 0
    local poisonCandidates = { "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_SPELL_POWER_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_AGILITY_SHORT", "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", "ITEM_MOD_PARRY_RATING_SHORT", "ITEM_MOD_DODGE_RATING_SHORT", "ITEM_MOD_MANA_REGENERATION_SHORT", "ITEM_MOD_ATTACK_POWER_SHORT", "ITEM_MOD_CRIT_RATING_SHORT", "ITEM_MOD_HIT_RATING_SHORT", "ITEM_MOD_SHADOW_DAMAGE_SHORT", "ITEM_MOD_FIRE_DAMAGE_SHORT", "ITEM_MOD_FROST_DAMAGE_SHORT", "ITEM_MOD_ARCANE_DAMAGE_SHORT", "ITEM_MOD_NATURE_DAMAGE_SHORT", "ITEM_MOD_HOLY_DAMAGE_SHORT", "MSC_WAND_DPS" }
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
                -- Era Logic: Weapon Skill (subclassID checks)
                if subclassID == 2 or subclassID == 3 or subclassID == 18 then 
                    -- Weapon Skill isn't strictly "Crit Rating", but for scoring we might treat it as a bonus
                    -- Leaving this as generic hook for now
                end
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
        if k ~= "IS_PROJECTED" and k ~= "ENCHANT_TEXT" and type(v) == "number" then
            local d = v - (old[k] or 0); if d ~= 0 then table.insert(dest, { key=k, val=d }); seen[k] = true end
        end
    end
    for k, v in pairs(old) do
        if not seen[k] and k ~= "IS_PROJECTED" and k ~= "ENCHANT_TEXT" and type(v) == "number" then
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
-- 8. HELPERS FOR EVALUATOR
-- =============================================================
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