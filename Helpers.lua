local _, MSC = ...

-- =============================================================
-- 1. GENERAL HELPERS & CACHE
-- =============================================================
MSC.StatCache = {} 

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
	["ITEM_MOD_CONDITIONAL_AP_SHORT"] = "AP (Conditional)",
	["ITEM_MOD_CRIT_FROM_STATS_SHORT"] = "Crit (from Agi/Int)",
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
    local _, _, _, _, _, _, _, _, equipLoc, _, _, classID, subclassID = GetItemInfo(link)
    local _, playerClass = UnitClass("player")
    
    -- [[ 1. ARMOR CHECKS ]] --
    if classID == 4 then 
        -- Subclass 11 = Idols, Librams, Totems (Relics)
        if subclassID == 11 then
            if playerClass == "DRUID" or playerClass == "PALADIN" or playerClass == "SHAMAN" then
                -- Double check it's the right relic for the right class
                -- (GetItemInfo returns specific subtypes like "Libram", "Idol", "Totem")
                local relicType = select(7, GetItemInfo(link)) 
                if playerClass == "DRUID" and relicType == "Idol" then return true end
                if playerClass == "PALADIN" and relicType == "Libram" then return true end
                if playerClass == "SHAMAN" and relicType == "Totem" then return true end
                return false -- Wrong relic for this class
            end
            return false -- Non-hybrid classes can't use relics
        end

        -- Standard Armor Checks
        -- 0=Misc, 1=Cloth, 2=Leather, 3=Mail, 4=Plate, 6=Shield
        if playerClass == "MAGE" or playerClass == "WARLOCK" or playerClass == "PRIEST" then 
            if subclassID > 1 then return false end -- Cloth only
        elseif playerClass == "ROGUE" or playerClass == "DRUID" then 
            if subclassID > 2 then return false end -- Cloth/Leather
        elseif playerClass == "HUNTER" or playerClass == "SHAMAN" then 
            if subclassID > 3 then return false end -- Cloth/Leather/Mail
        end
        -- Warriors/Paladins can use everything (Subclass 4=Plate), so no 'if' needed for them here.
    end
    
    -- [[ 2. WEAPON CHECKS ]] --
    if classID == 2 and MSC.ValidWeapons and MSC.ValidWeapons[playerClass] then
        -- Thrown Weapons are Subclass 16. 
        -- If the user hasn't learned the skill yet, GetItemInfo might behave weirdly, 
        -- but 'ValidWeapons' should cover the hard rules.
        if not MSC.ValidWeapons[playerClass][subclassID] then return false end
    end
    
    return true
end

function MSC:GetValidEnchantType(itemLink)
    if not itemLink then return nil end
    local _, _, _, _, _, itemClass, itemSubClassID, _, itemEquipLoc = GetItemInfo(itemLink)
    
    if itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_RANGEDRIGHT" then
        if itemSubClassID == 2 or itemSubClassID == 3 or itemSubClassID == 18 then return "SCOPE" end
        return nil 
    end
    if itemEquipLoc == "INVTYPE_SHIELD" then return "SHIELD" end
    if itemEquipLoc == "INVTYPE_HOLDABLE" then return nil end
    if itemEquipLoc == "INVTYPE_2HWEAPON" then return "2H_WEAPON" end
    if itemClass == 2 then return "WEAPON" end
    return "ARMOR"
end

-- =============================================================
-- 2. TOOLTIP PARSER (Unified Classic + TBC)
-- =============================================================
function MSC.ParseTooltipLine(text)
    if not text then return nil, 0, false end
    text = text:gsub("\n", " "):gsub("%s+", " ")
    if text:find("Set:") and not text:find("ff00ff00") then return nil, 0, false end
    local isSocketBonus = false
    if text:find("Socket Bonus:") then isSocketBonus = true end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if text:find("^Use:") or text:find("^Chance on hit:") then return nil, 0, false end
    
local patterns = {
        -- [[ 1. TRAPS & SPECIALS ]]
        { pattern = "attack power by (%d+) when fighting", stat = "ITEM_MOD_CONDITIONAL_AP_SHORT" }, 

        -- [[ 2. SPECIFIC SPELL STATS (Must come first to avoid confusion) ]]
        { pattern = "spell hit rating by (%d+)", stat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        { pattern = "spell critical strike rating by (%d+)", stat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
        { pattern = "spell haste rating by (%d+)", stat = "ITEM_MOD_SPELL_HASTE_RATING_SHORT" },
        { pattern = "spell penetration by (%d+)", stat = "ITEM_MOD_SPELL_PENETRATION_SHORT" }, -- Added PvP Stat

        -- [[ 3. GENERIC RATINGS (Hit/Crit/Haste) ]]
        { pattern = "hit rating by (%d+)", stat = "ITEM_MOD_HIT_RATING_SHORT" },
        { pattern = "critical strike rating by (%d+)", stat = "ITEM_MOD_CRIT_RATING_SHORT" },
        { pattern = "haste rating by (%d+)", stat = "ITEM_MOD_HASTE_RATING_SHORT" },
        
        -- [[ 4. TANK & PVP RATINGS (CRITICAL MISSING STATS ADDED HERE) ]]
        { pattern = "resilience rating by (%d+)", stat = "ITEM_MOD_RESILIENCE_RATING_SHORT" },
        { pattern = "expertise rating by (%d+)", stat = "ITEM_MOD_EXPERTISE_RATING_SHORT" }, 
        { pattern = "defense rating by (%d+)", stat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { pattern = "dodge rating by (%d+)", stat = "ITEM_MOD_DODGE_RATING_SHORT" }, -- NEW
        { pattern = "parry rating by (%d+)", stat = "ITEM_MOD_PARRY_RATING_SHORT" }, -- NEW
        { pattern = "block rating by (%d+)", stat = "ITEM_MOD_BLOCK_RATING_SHORT" }, -- NEW (Shield Block Rating)
        { pattern = "ignore (%d+) of your opponent's armor", stat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" },

        -- [[ 5. MODERNIZED / SIMPLIFIED STATS ]]
        { pattern = "Increases spell power by (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "Increases attack power by (%d+)", stat = "ITEM_MOD_ATTACK_POWER_SHORT" }, -- (This triggers the Feral Check logic we added)
        { pattern = "Increases healing by (%d+)", stat = "ITEM_MOD_HEALING_POWER_SHORT" },
        
        -- [[ 6. CLASSIC / TBC PHRASING ]]
        -- "Damage and Healing" = Spell Power
        { pattern = "damage and healing.-by up to (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "damage and healing.-by (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        
        -- "Healing Done" (Broader Match)
        { pattern = "healing done.-up to (%d+)", stat = "ITEM_MOD_HEALING_POWER_SHORT" }, -- NEW (Catches "Increases healing done by...")
        
        -- Specific Schools
        { pattern = "Shadow damage.-up to (%d+)", stat = "ITEM_MOD_SHADOW_DAMAGE_SHORT" },
        { pattern = "Fire damage.-up to (%d+)", stat = "ITEM_MOD_FIRE_DAMAGE_SHORT" },
        { pattern = "Frost damage.-up to (%d+)", stat = "ITEM_MOD_FROST_DAMAGE_SHORT" },
        { pattern = "Arcane damage.-up to (%d+)", stat = "ITEM_MOD_ARCANE_DAMAGE_SHORT" },
        { pattern = "Nature damage.-up to (%d+)", stat = "ITEM_MOD_NATURE_DAMAGE_SHORT" },
        { pattern = "Holy damage.-up to (%d+)", stat = "ITEM_MOD_HOLY_DAMAGE_SHORT" },
        
        -- [[ 7. ATTRIBUTES & REGEN ]]
        { pattern = "Speed (%d+%.%d+)", stat = "MSC_WEAPON_SPEED" },
        { pattern = "ranged attack power.-by (%d+)", stat = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" },
        
        -- Mana Regen (Catches "per 5" and "every 5")
        { pattern = "(%d+) mana per 5 sec", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { pattern = "(%d+) mana every 5 sec", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" }, -- NEW
        
        { pattern = "%+(%d+) Stamina", stat = "ITEM_MOD_STAMINA_SHORT" },
        { pattern = "%+(%d+) Intellect", stat = "ITEM_MOD_INTELLECT_SHORT" },
        { pattern = "%+(%d+) Spirit", stat = "ITEM_MOD_SPIRIT_SHORT" },
        { pattern = "%+(%d+) Strength", stat = "ITEM_MOD_STRENGTH_SHORT" },
        { pattern = "%+(%d+) Agility", stat = "ITEM_MOD_AGILITY_SHORT" },
        { pattern = "block value.-by (%d+)", stat = "ITEM_MOD_BLOCK_VALUE_SHORT" }, -- NEW (TBC phrasing)
        { pattern = "%+(%d+) Block", stat = "ITEM_MOD_BLOCK_VALUE_SHORT" }, -- (Classic phrasing)
    }
    
    for _, p in ipairs(patterns) do
        local val = text:match(p.pattern)
        if val then
            local finalStat = p.stat
            
            -- [[ THE FERAL TRAP FIX ]] --
            -- If we detected Attack Power, check the fine print for Druid forms.
            if finalStat == "ITEM_MOD_ATTACK_POWER_SHORT" then
                if text:find("Cat") or text:find("Bear") or text:find("forms only") then
                    finalStat = "ITEM_MOD_ATTACK_POWER_FERAL_SHORT"
                end
            end

            return finalStat, (p.val or tonumber(val)), isSocketBonus
        end
    end
	
	-- [[ HYBRID RELIC FIX (Librams, Idols, Totems) ]] --
    -- FIX: Now handles both "by up to 25" AND "by 25" (Fixed amounts)

    -- 1. SPELL DAMAGE / HEALING (Generic Catch-All)
    -- Check "damage of your X"
    local spellDmg = text:match("damage of your .* spell by up to (%d+)")
    if not spellDmg then spellDmg = text:match("damage of your .* spell by (%d+)") end
    
    -- Check "damage dealt by X"
    if not spellDmg then spellDmg = text:match("damage dealt by .* by up to (%d+)") end
    if not spellDmg then spellDmg = text:match("damage dealt by .* by (%d+)") end -- << Catches Idol of the Avenger
    
    if spellDmg then return "ITEM_MOD_SPELL_POWER_SHORT", tonumber(spellDmg), false end

    -- Check Healing
    local healing = text:match("healing done by .* by up to (%d+)")
    if not healing then healing = text:match("healing done by .* by (%d+)") end
    if healing then return "ITEM_MOD_HEALING_POWER_SHORT", tonumber(healing), false end

    -- 2. SHAMAN TOTEMS
    if text:find("Lightning Bolt") or text:find("Chain Lightning") then
        local dmg = text:match("by up to (%d+)")
        if not dmg then dmg = text:match("by (%d+)") end
        if dmg then return "ITEM_MOD_SPELL_POWER_SHORT", tonumber(dmg), false end
    end
    if text:find("Shock") and text:find("damage dealt by") then
        local dmg = text:match("by up to (%d+)")
        if not dmg then dmg = text:match("by (%d+)") end
        if dmg then return "ITEM_MOD_SPELL_POWER_SHORT", tonumber(dmg), false end
    end

    -- 3. DRUID IDOLS
    local feralAP = text:match("attack power of your .* forms by (%d+)")
    if feralAP then return "ITEM_MOD_ATTACK_POWER_SHORT", tonumber(feralAP), false end

    local mangleDmg = text:match("damage dealt by Mangle by up to (%d+)")
    if not mangleDmg then mangleDmg = text:match("damage dealt by Mangle by (%d+)") end
    if mangleDmg then return "ITEM_MOD_STRENGTH_SHORT", tonumber(mangleDmg), false end
    
    local shredDmg = text:match("damage dealt by Shred by up to (%d+)")
    if not shredDmg then shredDmg = text:match("damage dealt by Shred by (%d+)") end
    if shredDmg then return "ITEM_MOD_STRENGTH_SHORT", tonumber(shredDmg), false end
    
    -- "Increases damage dealt by Wrath by 25" -> (Mapped to Starfire/Nature or Generic SP)
    -- Since our first block catches "damage dealt by", this is covered, but we can be specific if needed.

    -- 4. PALADIN LIBRAMS
    local csDmg = text:match("damage dealt by Crusader Strike by (%d+)")
    if csDmg then return "ITEM_MOD_STRENGTH_SHORT", tonumber(csDmg), false end
    
    -- 5. BLOCK VALUE
    local blockVal = text:match("block value by (%d+)")
    if blockVal then return "ITEM_MOD_BLOCK_VALUE_SHORT", tonumber(blockVal), false end

    -- [[ END HYBRID FIX ]] --
    
    return nil, 0, false
end

-- =============================================================
-- 3. PROJECTION LOGIC (Gems & Enchants)
-- =============================================================
function MSC.GetBestGemForSocket(socketColor, level, weights)
    local db = (level >= 70) and MSC.GemOptions or MSC.GemOptions_Leveling
    if not db then return nil, 0 end
    local candidates = db[socketColor]
    if not candidates then return nil, 0 end
    local bestGem, bestScore = nil, -1
    for _, gem in ipairs(candidates) do
        local score = 0
        if weights[gem.stat] then score = score + (gem.val * weights[gem.stat]) end
        if gem.stat2 and weights[gem.stat2] then score = score + (gem.val2 * weights[gem.stat2]) end
        if score > bestScore then bestScore = score; bestGem = gem end
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

    local function CalculateStrategy(ignoreColors)
        local totalScore = 0
        local gemSet = {}
        for _, colorKey in ipairs(socketKeys) do
            local count = baseStats[colorKey] or 0
            if count > 0 then
                for i=1, count do
                    local bestGem, score = nil, 0
                    if ignoreColors and colorKey ~= "EMPTY_SOCKET_META" then
                        for _, c in ipairs({"EMPTY_SOCKET_RED", "EMPTY_SOCKET_YELLOW", "EMPTY_SOCKET_BLUE"}) do
                            local g, s = MSC.GetBestGemForSocket(c, level, weights)
                            if g and s > score then bestGem = g; score = s end
                        end
                    else
                        bestGem, score = MSC.GetBestGemForSocket(colorKey, level, weights)
                    end
                    if bestGem then totalScore = totalScore + score; table.insert(gemSet, bestGem) end
                end
            end
        end
        return totalScore, gemSet
    end

    local useMatch = true
    if gemMode == 4 then
        local scoreMatch, _ = CalculateStrategy(false)
        local bonusScore = 0
        if bonusStats then for k, v in pairs(bonusStats) do if weights[k] then bonusScore = bonusScore + (v * weights[k]) end end end
        
        local totalMatch = scoreMatch + bonusScore
        local scoreIgnore, _ = CalculateStrategy(true)
        
        if scoreIgnore > totalMatch then useMatch = false end
    elseif gemMode == 3 then useMatch = true end

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

    -- [[ VISUAL FIX: Add "(+Bonus)" text ]] --
    -- We only add the text if we decided to Match Colors (useMatch) 
    -- AND the item actually has bonus stats to activate.
    local hasBonus = false
    if bonusStats then for k,v in pairs(bonusStats) do hasBonus = true break end end

    if useMatch and hasBonus then
        gemText = gemText .. " |cff00ff00(+Bonus)|r"
    end

    return finalStats, hasSockets, useMatch, gemText
end

function MSC.GetBestEnchantForSlot(slotId, level, specName, enchantType)
    local bestScore = 0; local bestID = nil
    if not MSC.EnchantDB then return nil end
    for eID, data in pairs(MSC.EnchantDB) do
        local isValid = (data.slot == slotId)
        if isValid and enchantType then
            if enchantType == "SCOPE" then if not data.isScope then isValid = false end
            elseif enchantType == "SHIELD" then if not data.isShield then isValid = false end
            elseif enchantType == "WEAPON" or enchantType == "2H_WEAPON" then
                if data.isShield or data.isScope then isValid = false end
                if data.requires2H and enchantType ~= "2H_WEAPON" then isValid = false end
            end
        end
        if isValid then
            local weights = MSC.GetCurrentWeights()
            local score = MSC.GetItemScore(data.stats, weights, specName)
            if score > bestScore then bestScore = score; bestID = eID end
        end
    end
    return bestID
end

function MSC.GetEnchantString(slotId)
    local link = GetInventoryItemLink("player", slotId)
    if not link then return "" end
    local _, _, _, enchantID = string.find(link, "item:%d+:(%d+)")
    enchantID = tonumber(enchantID)
    if enchantID and MSC.EnchantDB and MSC.EnchantDB[enchantID] then return MSC.EnchantDB[enchantID].name or ("#"..enchantID) end
    return ""
end

-- =============================================================
-- 4. CACHED STAT SCANNER
-- =============================================================
function MSC.GetStaticItemStats(itemLink)
    if not itemLink then return {} end
    if MSC.StatCache[itemLink] then return MSC.StatCache[itemLink] end

    local id = tonumber(itemLink:match("item:(%d+)"))
    local finalStats = {}; local bonusStats = {}
    
    -- 1. Get Base Stats from API
    local stats = GetItemStats(itemLink) or {}
    for k, v in pairs(stats) do
        if MSC.StatShortNames[k] or k == "ITEM_MOD_SPELL_HEALING_DONE" or k == "ITEM_MOD_SPELL_DAMAGE_DONE" then 
            if k == "ITEM_MOD_SPELL_HEALING_DONE" then finalStats["ITEM_MOD_HEALING_POWER_SHORT"] = (finalStats["ITEM_MOD_HEALING_POWER_SHORT"] or 0) + v
            elseif k == "ITEM_MOD_SPELL_DAMAGE_DONE" then finalStats["ITEM_MOD_SPELL_POWER_SHORT"] = (finalStats["ITEM_MOD_SPELL_POWER_SHORT"] or 0) + v
            else finalStats[k] = v end
        end
    end

    -- 2. Scan Tooltip for "Hidden" Stats and Bonuses
    local tipName = "MSC_ScannerTooltip"
    local tip = _G[tipName] or CreateFrame("GameTooltip", tipName, nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE"); tip:ClearLines(); tip:SetHyperlink(itemLink)

    for i = 2, tip:NumLines() do
        local line = _G[tipName.."TextLeft"..i]
        local text = line and line:GetText()
        local r, g, b = line and line:GetTextColor() or 1, 1, 1
        
        if text then
            -- [[ GRAY TEXT LOGIC ]] --
            local isGray = (r > 0.4 and r < 0.65) and (g > 0.4 and g < 0.65) and (b > 0.4 and b < 0.65)
            local isSocketBonusLine = text:find("Socket Bonus:")
            local shouldSkip = false

            if isGray then
                shouldSkip = true
                -- EXCEPTION: Allow Gray Socket Bonus if GemMode is 3 (Match) or 4 (Smart)
                -- We use '(SGJ_Settings.GemMode or 1)' to be safe.
                if isSocketBonusLine and SGJ_Settings and (SGJ_Settings.GemMode or 1) >= 3 then
                    shouldSkip = false
                end
            end

            -- [[ PARSING ]] --
            if not shouldSkip then
                local s, v, isBonus = MSC.ParseTooltipLine(text)
                if s and v then
                    if isBonus then 
                        bonusStats[s] = (bonusStats[s] or 0) + v
                    elseif not finalStats[s] then 
                        -- Only add if API didn't already catch it (prevents duplicates)
                        finalStats[s] = (finalStats[s] or 0) + v 
                    end
                end
                
                -- [[ PROC SCANNING ]] --
                if id then
                    local pStat, pVal = MSC:ParseProcText(text, id)
                    if pStat and pVal > 0 then finalStats[pStat] = (finalStats[pStat] or 0) + pVal end
                end
            end
        end
    end

    -- 3. Apply Manual Overrides
    if id and MSC.ItemOverrides and MSC.ItemOverrides[id] then
        local override = MSC.ItemOverrides[id]
        if override.replace then finalStats = {} end
        for k, v in pairs(override) do
            if k ~= "replace" and k ~= "estimate" then finalStats[k] = (finalStats[k] or 0) + v end
        end
        if override.estimate then finalStats.estimate = true end
    end

    finalStats._BONUS_STATS = bonusStats
    
    local hasStats = false
    for k,v in pairs(finalStats) do if k ~= "_BONUS_STATS" then hasStats = true; break end end
    if hasStats then MSC.StatCache[itemLink] = finalStats end
    
    return finalStats
end

function MSC.SafeGetItemStats(itemLink, slotId)
    local cachedStats = MSC.GetStaticItemStats(itemLink)
    local finalStats = {}
    for k,v in pairs(cachedStats) do if k ~= "_BONUS_STATS" then finalStats[k] = v end end
    local bonusStats = cachedStats._BONUS_STATS or {}

    local enchantMode = SGJ_Settings and SGJ_Settings.EnchantMode or 3 
    if enchantMode == 3 and slotId then 
        local enchantType = MSC:GetValidEnchantType(itemLink)
        if enchantType then
            local level = UnitLevel("player")
            local _, specName = MSC.GetCurrentWeights()
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
            return lowNode[2] + ((level - lowNode[1]) / (highNode[1] - lowNode[1])) * (highNode[2] - lowNode[2])
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
    
    -- [[ WEAPON SPEED LOGIC ]]
    if stats.MSC_WEAPON_SPEED and MSC.SpeedChecks then
        local _, class = UnitClass("player")
        local pref = MSC.SpeedChecks[class] and (MSC.SpeedChecks[class][specName] or MSC.SpeedChecks[class]["Default"])
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
    
    -- [[ "WRONG ITEM" PENALTY (Universal Fix) ]] --
    -- If an item has a LOT of a stat that your profile considers "Worthless" (Weight 0),
    -- we penalize the score. This prevents off-spec items with Sockets from looking like upgrades.
    
    local penalty = 0
    
    -- List of "Spec Defining" stats. If you have 0 weight for these, you shouldn't wear them.
    local poisonCandidates = {
        "ITEM_MOD_INTELLECT_SHORT",
        "ITEM_MOD_SPIRIT_SHORT",
        "ITEM_MOD_SPELL_POWER_SHORT",
        "ITEM_MOD_STRENGTH_SHORT",
        "ITEM_MOD_AGILITY_SHORT",
        "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
        "ITEM_MOD_PARRY_RATING_SHORT",
        "ITEM_MOD_DODGE_RATING_SHORT",
        "ITEM_MOD_MANA_REGENERATION_SHORT",
		"ITEM_MOD_ATTACK_POWER_SHORT",
        "ITEM_MOD_CRIT_RATING_SHORT",
        "ITEM_MOD_HASTE_RATING_SHORT",
        "ITEM_MOD_HIT_RATING_SHORT",
        "ITEM_MOD_HIT_SPELL_RATING_SHORT"
    }

    for _, statKey in ipairs(poisonCandidates) do
        local statVal = stats[statKey] or 0
        local statWeight = weights[statKey] or 0
        
        -- If the item has the stat (> 0) BUT your profile hates it (Weight <= 0.1)
        if statVal > 0 and statWeight <= 0.01 then
            -- Apply a massive penalty so the Socket/Stamina can't save it
            penalty = penalty + 1000
        end
    end
    
    -- Special Case: Hunters use Strength for 1 AP, but very inefficiently. 
    -- If weight is tiny (e.g. 0.1) vs Primary (2.0), we might still want to penalize 
    -- pure Str gear, but for now the "Weight <= 0.01" check is safer for hybrids.

    score = score - penalty

    return MSC.Round(score, 1)
end

function MSC.ExpandDerivedStats(stats, itemLink)
    if not stats then return {} end
    local out = {}
    for k, v in pairs(stats) do out[k] = v end
    local _, class = UnitClass("player")
    local _, race = UnitRace("player")
    local powerType = UnitPowerType("player")
    
    -- [[ RACIAL LOGIC RESTORED (TBC Expertise) ]]
    if itemLink and MSC.RacialTraits and MSC.RacialTraits[race] then
        local _, _, _, _, _, _, _, _, _, _, _, _, subclassID = GetItemInfo(itemLink)
        if subclassID and MSC.RacialTraits[race][subclassID] then
            local val = MSC.RacialTraits[race][subclassID]
            if type(val) == "number" then
                if subclassID == 2 or subclassID == 3 or subclassID == 18 then
                     out["ITEM_MOD_CRIT_RATING_SHORT"] = (out["ITEM_MOD_CRIT_RATING_SHORT"] or 0) + val
                else
                     -- TBC: Weapon Skill is now Expertise Rating
                     out["ITEM_MOD_EXPERTISE_RATING_SHORT"] = (out["ITEM_MOD_EXPERTISE_RATING_SHORT"] or 0) + val
                end
            elseif type(val) == "table" and val.stat then
                out[val.stat] = (out[val.stat] or 0) + val.val
            end
        end
    end
    
    if out["ITEM_MOD_STAMINA_SHORT"] then out["ITEM_MOD_HEALTH_SHORT"] = (out["ITEM_MOD_HEALTH_SHORT"] or 0) + (out["ITEM_MOD_STAMINA_SHORT"] * 10) end
    if powerType == 0 and out["ITEM_MOD_INTELLECT_SHORT"] then out["ITEM_MOD_MANA_SHORT"] = (out["ITEM_MOD_MANA_SHORT"] or 0) + (out["ITEM_MOD_INTELLECT_SHORT"] * 15) end
    
    local ratioTable = MSC.StatToCritMatrix and MSC.StatToCritMatrix[class]
    local myLevel = UnitLevel("player")
    if ratioTable then
        if ratioTable.Agi and out["ITEM_MOD_AGILITY_SHORT"] then
            local ratio = MSC.GetInterpolatedRatio(ratioTable.Agi, myLevel)
            if ratio and ratio > 0 then out["ITEM_MOD_CRIT_FROM_STATS_SHORT"] = (out["ITEM_MOD_CRIT_FROM_STATS_SHORT"] or 0) + (out["ITEM_MOD_AGILITY_SHORT"] / ratio) end
        end
        if ratioTable.Int and out["ITEM_MOD_INTELLECT_SHORT"] then
             local ratio = MSC.GetInterpolatedRatio(ratioTable.Int, myLevel)
             if ratio and ratio > 0 then out["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] = (out["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] or 0) + (out["ITEM_MOD_INTELLECT_SHORT"] / ratio) end
        end
    end
    return out
end

-- [[ THE MISSING FUNCTIONS (Restored) ]] --
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

-- ============================================================================
--  6. PROC & ON-USE CALCULATOR
-- ============================================================================
function MSC:ParseProcText(text, itemID)
    local isProc = string.find(text, "Chance on hit:") or string.find(text, "Equip: When struck")
    local isUse = string.find(text, "^Use:")
    if not isProc and not isUse then return nil, 0 end
    
    local amount = tonumber(string.match(text, "by (%d+)"))
    local duration = tonumber(string.match(text, "for (%d+) sec"))
    if not amount then amount = tonumber(string.match(text, "cost.-by (%d+)")) end
    if not amount or not duration then return nil, 0 end

    local statName = nil
    if string.find(text, "Haste") then statName = "ITEM_MOD_HASTE_RATING_SHORT"
    elseif string.find(text, "Strength") then statName = "ITEM_MOD_STRENGTH_SHORT"
    elseif string.find(text, "Agility") then statName = "ITEM_MOD_AGILITY_SHORT"
    elseif string.find(text, "Intellect") then statName = "ITEM_MOD_INTELLECT_SHORT"
    elseif string.find(text, "Attack Power") then statName = "ITEM_MOD_ATTACK_POWER_SHORT"
    elseif string.find(text, "Spell Power") or string.find(text, "damage and healing") then statName = "ITEM_MOD_SPELL_POWER_SHORT"
    elseif string.find(text, "defense rating") then statName = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"
    elseif string.find(text, "Dodge rating") then statName = "ITEM_MOD_DODGE_RATING_SHORT"
    elseif string.find(text, "mana cost") then statName = "ITEM_MOD_INTELLECT_SHORT"
    end
    if not statName then return nil, 0 end

    local average = 0
    if isProc then
        local procData = MSC:GetProcData(itemID)
        local ppm = procData and procData.ppm or 1.0 
        average = (amount * duration * ppm) / 60
    elseif isUse then
        local cdMin = tonumber(string.match(text, "(%d+) Min.-Cooldown"))
        local cdSec = tonumber(string.match(text, "(%d+) Sec.-Cooldown"))
        local cooldown = 120 
        if cdMin then cooldown = cdMin * 60
        elseif cdSec then cooldown = cdSec end
        if cooldown < duration then cooldown = duration end
        average = (amount * duration) / cooldown
    end
    return statName, average
end

function MSC.GetInspectSpec(unit) return "Default" end
function MSC.ApplyElvUISkin(frame) end