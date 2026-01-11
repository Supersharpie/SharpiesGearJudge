local addonName, MSC = ...

-- =============================================================
-- 0. API COMPATIBILITY WRAPPERS
-- =============================================================
-- Modern WoW (Classic Era/SoD/Cata/Retail) uses C_Container.
-- Old Private Server clients use the Globals.
local GetBagSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetBagLink  = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink

-- =============================================================
-- 1. UTILITIES & RECYCLING BIN
-- =============================================================
local Scratch_Gear = {}
local Scratch_Stats = {}
local Scratch_Accumulator = {}
local Scratch_SetCounts = {}
local Scratch_Colors = { RED = 0, YELLOW = 0, BLUE = 0 }

function MSC:SafeCopy(orig, dest)
    wipe(dest or {})
    local copy = dest or {}
    if not orig then return copy end
    for k,v in pairs(orig) do copy[k] = v end
    return copy
end

function MSC:GetWeaponSpecBonus(itemLink, class, specName)
    if MSC.CurrentClass and MSC.CurrentClass.GetWeaponBonus then
        return MSC.CurrentClass:GetWeaponBonus(itemLink)
    end
    return 0
end

function MSC:CheckMetaRequirements(metaID, counts)
    if not metaID then return false end
    if metaID == 32409 then return (counts.RED >= 2 and counts.BLUE >= 2 and counts.YELLOW >= 2) -- Relentless
    elseif metaID == 34220 then return (counts.BLUE >= 2) -- Chaotic
    elseif metaID == 25893 then return (counts.BLUE > counts.YELLOW) -- Mystical
    elseif metaID == 25896 or metaID == 25899 then return (counts.BLUE >= 3) -- Powerful/Brutal
    end
    return true
end

-- Talent Cache (Lazy Load)
MSC.TalentCache = {}
function MSC:BuildTalentCache()
    MSC.TalentCache = {}
    for tab = 1, GetNumTalentTabs() do
        for i = 1, GetNumTalents(tab) do
            local name, _, _, _, rank = GetTalentInfo(tab, i)
            if name then MSC.TalentCache[name] = rank end
        end
    end
end
function MSC:GetTalentRank(name)
    if not MSC.TalentCache or not next(MSC.TalentCache) then MSC:BuildTalentCache() end
    return MSC.TalentCache[name] or 0
end

-- =============================================================
-- 2. GEAR SNAPSHOT
-- =============================================================
local GEAR_SLOTS = { 1, 2, 3, 15, 5, 9, 10, 6, 7, 8, 11, 12, 13, 14, 16, 17, 18 }

function MSC:GetEquippedGear(outputTable)
    local gear = outputTable or {}
    wipe(gear)
    for _, slotID in ipairs(GEAR_SLOTS) do
        gear[slotID] = GetInventoryItemLink("player", slotID)
    end
    return gear
end

-- =============================================================
-- 3. THE SCORING ENGINE (The Brain)
-- =============================================================
function MSC:GetTotalCharacterScore(gearTable, weights, specName)
    local totalScore = 0
    
    wipe(Scratch_SetCounts)
    wipe(Scratch_Accumulator)
    Scratch_Colors.RED = 0; Scratch_Colors.YELLOW = 0; Scratch_Colors.BLUE = 0;
    
    local metaGemID = nil 

    for slotID, itemLink in pairs(gearTable) do
        if itemLink then
            -- [[ 1. GET BASE STATS ]] 
            local stats = MSC.SafeGetItemStats(itemLink, slotID, weights, specName)
            
            -- [[ 2. READ META/COLOR DATA ]]
            local itemGemIDs = {}
            if stats.META_ID then metaGemID = stats.META_ID end
            if stats.COLORS then
                if stats.COLORS.RED then Scratch_Colors.RED = Scratch_Colors.RED + stats.COLORS.RED end
                if stats.COLORS.YELLOW then Scratch_Colors.YELLOW = Scratch_Colors.YELLOW + stats.COLORS.YELLOW end
                if stats.COLORS.BLUE then Scratch_Colors.BLUE = Scratch_Colors.BLUE + stats.COLORS.BLUE end
            else
                if MSC.GetItemGems then
                    local rColors, rMeta, rGemIDs = MSC:GetItemGems(itemLink)
                    if rMeta and not metaGemID then metaGemID = rMeta end
                    if rGemIDs then itemGemIDs = rGemIDs end
                    if rColors then
                        Scratch_Colors.RED = Scratch_Colors.RED + (rColors.RED or 0)
                        Scratch_Colors.YELLOW = Scratch_Colors.YELLOW + (rColors.YELLOW or 0)
                        Scratch_Colors.BLUE = Scratch_Colors.BLUE + (rColors.BLUE or 0)
                    end
                end
            end
            
            -- [[ 3. GEM STAT INJECTION ]]
            if #itemGemIDs > 0 and MSC.GetGemStatsByID then
                for _, gID in ipairs(itemGemIDs) do
                    local gData = MSC.GetGemStatsByID(gID)
                    if gData and gData.isMeta then
                         if gData.stat then stats[gData.stat] = (stats[gData.stat] or 0) + gData.val end
                         if gData.stat2 then stats[gData.stat2] = (stats[gData.stat2] or 0) + gData.val2 end
                    end
                end
            end
            
            -- [[ 4. SCORE THE ITEM (Fixed & PvP-Aware) ]]
            -- We use GetItemScore ONCE. It handles weights and the standard poison penalty.
            local itemScore = MSC.GetItemScore(stats, weights, specName, slotID)
            
			totalScore = totalScore + itemScore


            -- [[ 5. ACCUMULATE TOTALS ]]
            for k,v in pairs(stats) do 
                if type(v) == "number" and k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" then 
                    Scratch_Accumulator[k] = (Scratch_Accumulator[k] or 0) + v 
                end
            end
            
            -- [[ 6. HANDLE PROCS & SET COUNTS ]]
            local itemID = GetItemInfoInstant(itemLink)
            if itemID then
                if MSC.GetItemSetID then
                    local setID = MSC:GetItemSetID(itemLink) 
                    if setID then Scratch_SetCounts[setID] = (Scratch_SetCounts[setID] or 0) + 1 end
                end
                
                if stats._AUTO_PROC then
                    local p = stats._AUTO_PROC
                    Scratch_Accumulator[p.stat] = (Scratch_Accumulator[p.stat] or 0) + p.val
                    if weights[p.stat] and weights[p.stat] > 0 then
                        totalScore = totalScore + (p.val * weights[p.stat])
                    end
                end
            end
        end
    end

    -- [[ 7. CALCULATE SET BONUSES ]]
    if MSC.ItemSetMap and MSC.RawSetData then
        for setID, count in pairs(Scratch_SetCounts) do
             local setData = MSC.RawSetData[setID]
             if setData then
                 for reqCount, bonusData in pairs(setData) do
                     if count >= reqCount then
                         if bonusData.stats then
                             for stat, val in pairs(bonusData.stats) do
                                 Scratch_Accumulator[stat] = (Scratch_Accumulator[stat] or 0) + val
                                 if weights[stat] then totalScore = totalScore + (val * weights[stat]) end
                             end
                         end
                         if bonusData.score then
                             totalScore = totalScore + bonusData.score
                         end
                     end
                 end
             end
        end
    end

    -- [[ 8. WEAPON SPECIALIZATION BONUS ]]
    local mh = gearTable[16]; local oh = gearTable[17]
    if mh then totalScore = totalScore + MSC:GetWeaponSpecBonus(mh, MSC.CurrentClass, specName) end
    if oh then totalScore = totalScore + MSC:GetWeaponSpecBonus(oh, MSC.CurrentClass, specName) end

    -- [[ 9. META GEM ACTIVATION CHECK ]]
    if metaGemID and MSC.CheckMetaRequirements then
        local isActive = MSC:CheckMetaRequirements(metaGemID, Scratch_Colors)
        if not isActive then
             -- Penalize score if Meta requirements aren't met
             local metaStats = MSC.GetGemStatsByID and MSC.GetGemStatsByID(metaGemID)
             if metaStats then
                 local lostScore = 0
                 if metaStats.stat and weights[metaStats.stat] then lostScore = lostScore + (metaStats.val * weights[metaStats.stat]) end
                 if metaStats.stat2 and weights[metaStats.stat2] then lostScore = lostScore + (metaStats.val2 * weights[metaStats.stat2]) end
                 totalScore = totalScore - lostScore
             end
        end
    end

    return totalScore, MSC:SafeCopy(Scratch_Accumulator), MSC:SafeCopy(Scratch_Colors)
end

-- =============================================================
-- 4. BAG SCANNERS (Smart Weapon Logic)
-- =============================================================

-- Find the best MAIN HAND in bags (to pair with a new Off-Hand)
function MSC:GetBestMainHandInBags(weights, specName)
    local bestLink = nil
    local bestScore = -1

    for bag = 0, 4 do
        -- FIX: Use wrapper for C_Container compatibility
        local numSlots = GetBagSlots(bag) 
        for slot = 1, numSlots do
            local link = GetBagLink(bag, slot)
            if link then
                local _, _, _, _, _, _, _, _, loc = GetItemInfo(link)
                if (loc == "INVTYPE_WEAPON" or loc == "INVTYPE_WEAPONMAINHAND") and IsEquippableItem(link) then
                    local stats = MSC.SafeGetItemStats(link, 16, weights, specName)
                    local score = MSC.GetItemScore(stats, weights, specName, 16)
                    if score > bestScore then
                        bestScore = score
                        bestLink = link
                    end
                end
            end
        end
    end
    return bestLink
end

-- Find the best OFF HAND in bags (to pair with a new Main Hand)
function MSC:GetBestOffHandInBags(weights, specName)
    local bestLink = nil
    local bestScore = -1

    for bag = 0, 4 do
        -- FIX: Use wrapper for C_Container compatibility
        local numSlots = GetBagSlots(bag)
        for slot = 1, numSlots do
            local link = GetBagLink(bag, slot)
            if link then
                local _, _, _, _, _, _, _, _, loc = GetItemInfo(link)
                local validOH = (loc == "INVTYPE_WEAPON" or loc == "INVTYPE_WEAPONOFFHAND" or loc == "INVTYPE_SHIELD" or loc == "INVTYPE_HOLDABLE")
                if validOH and IsEquippableItem(link) then
                    local stats = MSC.SafeGetItemStats(link, 17, weights, specName)
                    local score = MSC.GetItemScore(stats, weights, specName, 17)
                    if score > bestScore then
                        bestScore = score
                        bestLink = link
                    end
                end
            end
        end
    end
    return bestLink
end

-- =============================================================
-- 5. EVALUATE UPGRADE (With Weapon Type Check)
-- =============================================================

function MSC:EvaluateUpgrade(newItemLink, targetSlotID, weights, specName)
    if not newItemLink then return 0, 0, {}, {}, {} end
    if not weights then weights, specName = MSC.GetCurrentWeights() end

    -- 1. SETUP & CURRENT SCORE
    MSC:GetEquippedGear(Scratch_Gear)
    local currentScore, _ = MSC:GetTotalCharacterScore(Scratch_Gear, weights, specName)

    local originalItem = Scratch_Gear[targetSlotID]
    local originalMH   = Scratch_Gear[16]
    local originalOH   = Scratch_Gear[17]
    local contextMsg   = nil

    -- 2. PRE-CALCULATE ITEM STATS
    local finalNewStats = MSC.SafeGetItemStats(newItemLink, targetSlotID, weights, specName)
    
    local finalOldStats = {}
    local oldItemLink = GetInventoryItemLink("player", targetSlotID)
    if oldItemLink then 
        finalOldStats = MSC.SafeGetItemStats(oldItemLink, targetSlotID, weights, specName) 
        if finalOldStats._AUTO_PROC then
             local p = finalOldStats._AUTO_PROC
             finalOldStats[p.stat] = (finalOldStats[p.stat] or 0) + p.val
        end
    end

    -- 3. SWAP GEAR & HANDLE MH/OH LOGIC
    Scratch_Gear[targetSlotID] = newItemLink
    
    local _,_,_,_,_,_,_,_, newLoc = GetItemInfo(newItemLink)
    -- In TBC, INVTYPE_WEAPON is 1H. INVTYPE_2HWEAPON is 2H.
    local isNew2H = (newLoc == "INVTYPE_2HWEAPON" or newLoc == "INVTYPE_STAFF" or newLoc == "INVTYPE_POLEARM")
    local isNew1H = (newLoc == "INVTYPE_WEAPON" or newLoc == "INVTYPE_WEAPONMAINHAND")

    -- [[ FIX: 2H SPEC PENALTY ]]
    -- If I am Arms/Ret, and I try to equip a 1H weapon in the Main Hand,
    -- I should effectively be penalized because I lose my 2H Spec bonuses.
    -- We simulate this by NOT filling the Offhand slot with a weapon.
    local is2HSpec = (specName and (specName:find("ARMS") or specName:find("RET") or specName:find("2H")))

    if targetSlotID == 16 then
        if isNew2H then
            Scratch_Gear[17] = nil -- 2H clears OH
        else
            -- It's a 1H weapon.
            local currentMH = GetInventoryItemLink("player", 16)
            if currentMH then
                local _,_,_,_,_,_,_,_, currLoc = GetItemInfo(currentMH)
                local isCurrent2H = (currLoc == "INVTYPE_2HWEAPON" or currLoc == "INVTYPE_STAFF" or currLoc == "INVTYPE_POLEARM")
                
                -- If we are switching FROM a 2H TO a 1H...
                if isCurrent2H then
                    -- If we are Arms/Ret, we DO NOT look for a weapon to pair.
                    -- We only accept Shields/Held Items (which likely score 0 for Arms).
                    if is2HSpec then
                        -- Do nothing. Leave OH empty. 
                        -- This effectively pits (1H Score) vs (2H Score). 
                        -- The 2H will win easily.
                        Scratch_Gear[17] = nil
                        contextMsg = "|cffff0000(No 2H)|r"
                    else
                        -- Standard Logic (Fury/Rogue): Look for best OH weapon in bags
                        local bestBagOH = MSC:GetBestOffHandInBags(weights, specName)
                        if bestBagOH then
                            Scratch_Gear[17] = bestBagOH
                            local bagName = GetItemInfo(bestBagOH)
                            contextMsg = "|cff00ff00(w/ ".. (bagName or "Bag Item") ..")|r"
                        else
                            Scratch_Gear[17] = nil
                            contextMsg = "|cffff0000(No OH found)|r"
                        end
                    end
                end
            end
        end
    elseif targetSlotID == 17 then
        -- (Existing Logic for swapping Offhands)
        local currentMH = GetInventoryItemLink("player", 16)
        if currentMH then
            local _,_,_,_,_,_,_,_, currLoc = GetItemInfo(currentMH)
            local isCurrent2H = (currLoc == "INVTYPE_2HWEAPON" or currLoc == "INVTYPE_STAFF" or currLoc == "INVTYPE_POLEARM")
            
            if isCurrent2H then
                local bestBagMH = MSC:GetBestMainHandInBags(weights, specName)
                if bestBagMH then
                    Scratch_Gear[16] = bestBagMH
                    local bagName = GetItemInfo(bestBagMH)
                    contextMsg = "|cff00ff00(w/ ".. (bagName or "Bag Item") ..")|r"
                else
                    Scratch_Gear[16] = nil
                    contextMsg = "|cffff0000(No MH found)|r"
                end
            end
        end
    end

    -- 4. CALCULATE FUTURE SCORE
    local newScore, newStatsTotal, newTotalColors = MSC:GetTotalCharacterScore(Scratch_Gear, weights, specName)

    -- [[ 5. CAP GUARDIAN (Hit/Def Caps) ]]
    -- (Paste your existing Cap Guardian logic here, or verify it matches the block below)
    local _, playerClass = UnitClass("player")
    local function Rank(k) return MSC:GetTalentRank(k) end 

    local STAT_TO_CR = { ["ITEM_MOD_HIT_RATING_SHORT"]=6, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=8, ["ITEM_MOD_HIT_RANGED_RATING_SHORT"]=7, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=24 }
    local STAT_DISPLAY = { ["ITEM_MOD_HIT_RATING_SHORT"]="Hit", ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]="Spell Hit", ["ITEM_MOD_HIT_RANGED_RATING_SHORT"]="Ranged Hit", ["ITEM_MOD_EXPERTISE_RATING_SHORT"]="Exp", ["DEFENSE_FLOOR"]="Def" }

    local SAFETY_CAPS = {
        WARRIOR = { { stat="ITEM_MOD_HIT_RATING_SHORT", base=142, talent="PRECISION", tVal=15.8, penalty=100 }, { stat="DEFENSE_FLOOR", base=490, penalty=1000 } },
        PALADIN = { { stat="DEFENSE_FLOOR", base=490, penalty=1000 }, { stat="ITEM_MOD_HIT_RATING_SHORT", base=142, talent="PRECISION", tVal=15.8, penalty=100 }, { stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", base=202, talent="PRECISION", tVal=12.6, penalty=100 } },
        ROGUE = { { stat="ITEM_MOD_HIT_RATING_SHORT", base=142, talent="PRECISION", tVal=15.8, penalty=100 } },
        HUNTER = { { stat="ITEM_MOD_HIT_RATING_SHORT", base=142, talent="SUREFOOTED", tVal=15.8, penalty=100, crOverride=7 } },
        SHAMAN = { { stat="ITEM_MOD_HIT_RATING_SHORT", base=142, talent="NATURE_GUIDANCE", tVal=15.8, penalty=100 }, { stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", base=202, talent="ELEMENTAL_PRECISION", tVal=12.6, penalty=100 }, { stat="DEFENSE_FLOOR", base=490, penalty=1000 } },
        DRUID = { { stat="ITEM_MOD_HIT_RATING_SHORT", base=142, penalty=100 }, { stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", base=202, talent="BALANCE_OF_POWER", tVal=25.2, penalty=100 }, { stat="DEFENSE_FLOOR", base=490, penalty=1000 } },
        MAGE = { { stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", base=202, talent="ELEMENTAL_PRECISION", tVal=12.6, penalty=100 } },
        WARLOCK = { { stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", base=202, talent="SUPPRESSION", tVal=25.2, penalty=100 } },
        PRIEST = { { stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", base=202, talent="SHADOW_FOCUS", tVal=25.2, penalty=100 } },
    }

    if SAFETY_CAPS[playerClass] then
        for _, rule in ipairs(SAFETY_CAPS[playerClass]) do
            if rule.stat ~= "DEFENSE_FLOOR" then
                local trueCap = rule.base
                if rule.talent then trueCap = trueCap - (Rank(rule.talent) * rule.tVal) end
                local crID = rule.crOverride or STAT_TO_CR[rule.stat] or 6
                local currentVal = GetCombatRating(crID)
                local futureVal = newStatsTotal[rule.stat] or 0
                
                if currentVal >= trueCap and futureVal < trueCap then
                    newScore = newScore - rule.penalty
                    local deficit = futureVal - trueCap
                    local name = STAT_DISPLAY[rule.stat] or "Cap"
                    if finalNewStats then
                        local msg = string.format(" |cffff0000(Cap %.1f %s)|r", deficit, name)
                        finalNewStats.Context = (finalNewStats.Context or "") .. msg
                    end
                end
            elseif rule.stat == "DEFENSE_FLOOR" then
                local defWeight = weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0
                if defWeight > 0 then
                    local baseDef, armorDef = UnitDefense("player")
                    local currentDef = baseDef + armorDef
                    local oldDefRating = (finalOldStats and finalOldStats["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]) or 0
                    local newDefRating = (finalNewStats and finalNewStats["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]) or 0
                    local diffSkill = (newDefRating - oldDefRating) / 2.36
                    local futureDef = currentDef + diffSkill
                    
                    if currentDef >= rule.base and futureDef < (rule.base - 0.1) then
                         newScore = newScore - rule.penalty
                         local deficit = futureDef - rule.base
                         if finalNewStats then
                             local msg = string.format(" |cffff0000(Cap %.1f Def)|r", deficit)
                             finalNewStats.Context = (finalNewStats.Context or "") .. msg
                         end
                    end
                end
            end
        end
    end

    -- 6. FINALIZE
    Scratch_Gear[targetSlotID] = originalItem
    Scratch_Gear[16] = originalMH
    Scratch_Gear[17] = originalOH

    if contextMsg then 
        finalNewStats.Context = (finalNewStats.Context or "") .. " " .. contextMsg 
    end

    if finalNewStats._AUTO_PROC then
         local p = finalNewStats._AUTO_PROC
         finalNewStats[p.stat] = (finalNewStats[p.stat] or 0) + p.val
    end

    return newScore, currentScore, finalNewStats, finalOldStats, newTotalColors
end