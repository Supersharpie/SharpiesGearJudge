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

    -- 2. ARMOR CHECK
    if classID == 4 then 
        local maxArmor = 1 -- Cloth
        if playerClass == "WARRIOR" or playerClass == "PALADIN" then maxArmor = 4
        elseif playerClass == "SHAMAN" or playerClass == "HUNTER" then maxArmor = 3
        elseif playerClass == "ROGUE" or playerClass == "DRUID" then maxArmor = 2 
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

function MSC:GetTalentRank(talentNameKey)
    if not MSC.CurrentClass or not MSC.CurrentClass.Talents then return 0 end
    local searchName = MSC.CurrentClass.Talents[talentNameKey]
    if not searchName then return 0 end
    for tab = 1, 3 do
        local numTalents = GetNumTalents(tab)
        for i = 1, numTalents do
            local name, icon, tier, column, rank = GetTalentInfo(tab, i)
            if name == searchName then return rank end
        end
    end
    return 0
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
local Scratch_MatchGems = {}
local Scratch_PureGems = {}
local Scratch_GemTextParts = {}
local Scratch_ProjectedIDs = {}
local Scratch_ProjectedColors = { RED=0, YELLOW=0, BLUE=0 }

MSC.StatShortNames = {
    ["MSC_WAND_DPS"] = "Wand DPS", ["MSC_WEAPON_DPS"] = "Weapon DPS", ["MSC_WEAPON_SPEED"] = "Speed",
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
-- 6. SCANNING
-- =============================================================
function MSC.ParseTooltipLine(text)
    if not text then return nil, 0, false end
    if text:find("Set:") and not text:find("ff00ff00") then return nil, 0, false end
    
    local patterns = {
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
        { p = "%+(%d+) Attack Power", s = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { p = "%+(%d+) Stamina", s = "ITEM_MOD_STAMINA_SHORT" },
        { p = "%+(%d+) Intellect", s = "ITEM_MOD_INTELLECT_SHORT" },
        { p = "%+(%d+) Spirit", s = "ITEM_MOD_SPIRIT_SHORT" },
        { p = "%+(%d+) Strength", s = "ITEM_MOD_STRENGTH_SHORT" },
        { p = "%+(%d+) Agility", s = "ITEM_MOD_AGILITY_SHORT" },
        { p = "%+(%d+) Mana", s = "ITEM_MOD_MANA_SHORT" },
        { p = "Mana %+(%d+)", s = "ITEM_MOD_MANA_SHORT" },
        { p = "%+(%d+) Armor", s = "ITEM_MOD_ARMOR_SHORT" }, 
        { p = "Armor %+(%d+)", s = "ITEM_MOD_ARMOR_SHORT" },
        { p = "%+(%d+) Block", s = "ITEM_MOD_BLOCK_VALUE_SHORT" },
        { p = "%+(%d+) Damage", s = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
        { p = "%+(%d+) Weapon Damage", s = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
        { p = "%+(%d+) Defense", s = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { p = "up to (%d+)%.?$", s = "ITEM_MOD_SPELL_POWER_SHORT" },
        { p = "^(%d+) Armor", s = "ITEM_MOD_ARMOR_SHORT" },
        { p = "Armor (%d+)", s = "ITEM_MOD_ARMOR_SHORT" },
        { p = "^(%d+) Damage", s = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
        { p = "(%d+%.%d+) Damage Per Second", s = "MSC_WEAPON_DPS" },
        { p = "Increases your chance to hit.-by (%d+)%%", s = "ITEM_MOD_HIT_RATING_SHORT" },
        { p = "Increases your chance to critical strike.-by (%d+)%%", s = "ITEM_MOD_CRIT_RATING_SHORT" },
        { p = "Increases your chance to parry.-by (%d+)%%", s = "ITEM_MOD_PARRY_RATING_SHORT" },
        { p = "Increases your chance to dodge.-by (%d+)%%", s = "ITEM_MOD_DODGE_RATING_SHORT" },
    }

    for _, d in ipairs(patterns) do
        local val = text:match(d.p)
        if val then return d.s, tonumber(val), text:find("Socket Bonus:") end
    end
    return nil, 0, false
end

function MSC:ParseProcText(text, itemID)
    if not text or not text:find("^Use:") then return nil, 0 end
    local amount = tonumber(text:match("by (%d+)")) or tonumber(text:match("cost.-by (%d+)"))
    if not amount then return nil, 0 end
    local duration = tonumber(text:match("for (%d+) sec"))
    if not duration then return nil, 0 end

    local cooldownSecs = 0
    local cdMin = tonumber(text:match("%((%d+) Min.-Cooldown%)"))
    if cdMin then cooldownSecs = cdMin * 60 end
    local cdSec = tonumber(text:match("%((%d+) Sec.-Cooldown%)"))
    if cdSec then cooldownSecs = (cooldownSecs or 0) + cdSec end
    
    if cooldownSecs == 0 then return nil, 0 end

    local statName = nil
    if text:find("Haste") then statName = "ITEM_MOD_HASTE_RATING_SHORT"
    elseif text:find("Strength") then statName = "ITEM_MOD_STRENGTH_SHORT"
    elseif text:find("Agility") then statName = "ITEM_MOD_AGILITY_SHORT"
    elseif text:find("Intellect") then statName = "ITEM_MOD_INTELLECT_SHORT"
    elseif text:find("Attack Power") then statName = "ITEM_MOD_ATTACK_POWER_SHORT"
    elseif text:find("Spell Power") then statName = "ITEM_MOD_SPELL_POWER_SHORT"
    end
    
    if not statName then return nil, 0 end
    return statName, (amount * duration) / cooldownSecs
end

function MSC.GetRawItemStats(itemLink)
    if not itemLink then return {} end
    if MSC.StatCache[itemLink] then return MSC.StatCache[itemLink] end

    local finalStats = {}; local bonusStats = {}
    local id = tonumber(itemLink:match("item:(%d+)"))
    
    local stats = GetItemStats(itemLink) or {}
    for k, v in pairs(stats) do
        if MSC.StatShortNames[k] or k:find("SPELL") then 
            if k == "ITEM_MOD_SPELL_HEALING_DONE" then finalStats["ITEM_MOD_HEALING_POWER_SHORT"] = (finalStats["ITEM_MOD_HEALING_POWER_SHORT"] or 0) + v
            elseif k == "ITEM_MOD_SPELL_DAMAGE_DONE" then finalStats["ITEM_MOD_SPELL_POWER_SHORT"] = (finalStats["ITEM_MOD_SPELL_POWER_SHORT"] or 0) + v
            else finalStats[k] = v end
        end
    end
    
    local tip = _G["MSC_ScannerTooltip"] or CreateFrame("GameTooltip", "MSC_ScannerTooltip", nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE"); tip:ClearLines()
    local status = pcall(function() tip:SetHyperlink(itemLink) end)
    
    if status then
        for i = 2, tip:NumLines() do
            local line = _G["MSC_ScannerTooltipTextLeft"..i]
            local text = line and line:GetText()
            local r, g, b = line and line:GetTextColor() or 1, 1, 1
            if text then
                local isGreen = (g > 0.9 and r < 0.9 and b < 0.9)
                local s, v, isBonus = MSC.ParseTooltipLine(text)
                if s and v then
                    if isBonus then bonusStats[s] = (bonusStats[s] or 0) + v
                    elseif isGreen or not finalStats[s] then finalStats[s] = (finalStats[s] or 0) + v end
                end
                if id then
                    local pStat, pVal = MSC:ParseProcText(text, id)
                    if pStat and pVal > 0 then 
                        finalStats._AUTO_PROC = { stat=pStat, val=pVal } 
                        finalStats[pStat] = (finalStats[pStat] or 0) + pVal
                    end
                end
            end
        end
    end
    
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
    
    local enchantMode = SGJ_Settings and SGJ_Settings.EnchantMode or 1 -- Default 1 (Off) per user req
    local gemMode = SGJ_Settings and SGJ_Settings.GemMode or 1
    local level = UnitLevel("player")

    if slotId then
        -- A. IDENTIFY PHYSICAL ENCHANT ON ITEM (The one we might want to strip)
        local physicalEnchantID = 0
        local itemString = string.match(itemLink, "item[%-?%d:]+")
        if itemString then
            local _, _, eid = strsplit(":", itemString)
            physicalEnchantID = tonumber(eid) or 0
        end

        -- B. STRIP PHYSICAL ENCHANT (Reset to Naked)
        -- We do this for ALL modes (1, 2, 3) to ensure a clean slate.
        -- OFF: Ignores it. CURRENT: Replaces it. BEST: Replaces it.
        if physicalEnchantID > 0 and MSC.EnchantDB and MSC.EnchantDB[physicalEnchantID] then
            local pData = MSC.EnchantDB[physicalEnchantID]
            if pData.stats then
                for k, v in pairs(pData.stats) do
                     -- Only subtract if we actually scanned it (Scanner sees numbers, DB has numbers)
                    if type(v) == "number" and (finalStats[k] or 0) >= v then
                        finalStats[k] = finalStats[k] - v
                    end
                end
            end
        end

        -- C. APPLY MODE LOGIC
        if enchantMode == 1 then
            -- OFF MODE: Do nothing. Item is now naked. 
            
        elseif enchantMode == 2 then
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
    
    for stat, val in pairs(stats) do
        local weightKey = stat
        
        if slotId == 17 and (stat == "MSC_WEAPON_DPS" or stat == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT") then
            if weights["MSC_WEAPON_DPS_OH"] then 
                weightKey = "MSC_WEAPON_DPS_OH" 
            end
        end
        
        if weights[weightKey] and type(val) == "number" then 
            local finalVal = val
            local w = weights[weightKey]
            
            if slotId == 17 and weightKey == stat and (stat == "MSC_WEAPON_DPS" or stat == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT") then 
                finalVal = val * 0.5 
            end
            
            score = score + (finalVal * w) 
        end
    end
    
    if not MSC.IsEra and stats["ITEM_MOD_RESILIENCE_RATING_SHORT"] then
        local resVal = stats["ITEM_MOD_RESILIENCE_RATING_SHORT"]
        local resWeight = weights["ITEM_MOD_RESILIENCE_RATING_SHORT"] or 0
        if resVal > 0 and resWeight <= 0.05 then 
            score = score - (resVal * 1.5) 
        end
    end
    
    local penalty = 0
    local poisonCandidates = { "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_SPELL_POWER_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_AGILITY_SHORT", "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" }
    for _, statKey in ipairs(poisonCandidates) do
        if (stats[statKey] or 0) > 0 and (weights[statKey] or 0) <= 0.01 then 
            penalty = penalty + 10 
        end
    end
    
    score = score - penalty
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
    Scratch_ItemColors.RED = 0; Scratch_ItemColors.YELLOW = 0; Scratch_ItemColors.BLUE = 0;
    wipe(Scratch_ItemGemIDs)
    
    local metaID = nil
    if not itemLink then return Scratch_ItemColors, nil, Scratch_ItemGemIDs end
    
    local g1, g2, g3, g4 = itemLink:match("item:%d+:%d+:(%d+):(%d+):(%d+):(%d+)")
    local foundGems = { tonumber(g1), tonumber(g2), tonumber(g3), tonumber(g4) }
    
    for _, id in ipairs(foundGems) do
        if id and id > 0 then
            table.insert(Scratch_ItemGemIDs, id)
            if MSC.GemOptions and MSC.GemOptions["EMPTY_SOCKET_META"] then
                for _, g in ipairs(MSC.GemOptions["EMPTY_SOCKET_META"]) do 
                    if g.id == id then metaID = id; break end 
                end
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
    
    return Scratch_ItemColors, metaID, Scratch_ItemGemIDs
end