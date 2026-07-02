local addonName, MSC = ...
_G.MSC = MSC 

-- [[ SPEED OPTIMIZATION ]]
local pairs, ipairs = pairs, ipairs
local type, tonumber = type, tonumber
local math_floor, math_max, math_abs = math.floor, math.max, math.abs
local table_insert = table.insert
local string_format, string_find = string.format, string.find 
local wipe = wipe or table.wipe
local unpack = unpack or table.unpack

-- WoW API Localizations
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetItemInfoInstant = GetItemInfoInstant
local IsEquippableItem = IsEquippableItem
local UnitClass = UnitClass

-- =============================================================
-- 0. API COMPATIBILITY WRAPPERS
-- =============================================================
local GetBagSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetBagLink  = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink

MSC.SAFETY_CAPS = {}

if MSC.IsTBC or MSC.IsWrath then
    MSC.SAFETY_CAPS = {
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
else
    MSC.SAFETY_CAPS = {
        WARRIOR = {
            { stat="ITEM_MOD_HIT_RATING_SHORT", base=9, talent="PRECISION", tVal=1, penalty=100 },
            { stat="DEFENSE_FLOOR", base=0, dynamic=true, penalty=1000 },
        },
        PALADIN = {
            { stat="DEFENSE_FLOOR", base=0, dynamic=true, penalty=1000 },
            { stat="ITEM_MOD_HIT_RATING_SHORT", base=9, penalty=100 },
        },
        DRUID = {
            { stat="ITEM_MOD_HIT_RATING_SHORT", base=9, penalty=100 },
            { stat="DEFENSE_FLOOR", base=0, dynamic=true, penalty=1000 },
        },
        ROGUE = { { stat="ITEM_MOD_HIT_RATING_SHORT", base=9, talent="PRECISION", tVal=1, penalty=100 } },
        HUNTER = { { stat="ITEM_MOD_HIT_RATING_SHORT", base=9, talent="SUREFOOTED", tVal=1, penalty=100 } },
        MAGE = { { stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", base=16, talent="ELEMENTAL_PRECISION", tVal=2, penalty=100 } },
        WARLOCK = { { stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", base=16, talent="SUPPRESSION", tVal=2, penalty=100 } },
    }
end

-- =============================================================
-- 1. UTILITIES & RECYCLING BIN
-- =============================================================
local Scratch_Gear = {}
local Scratch_Stats = {}
local Scratch_Accumulator = {}
local Scratch_SetCounts = {}
local Scratch_Colors = { RED = 0, YELLOW = 0, BLUE = 0 }
local Scratch_Stats_Old = {} 

function MSC:SafeCopy(orig, dest)
    wipe(dest or {})
    local copy = dest or {}
    if not orig then return copy end
    for k,v in pairs(orig) do copy[k] = v end
    return copy
end

function MSC:GetWeaponSpecBonus(itemLink, class, specName, weights)
    if MSC.CurrentClass and MSC.CurrentClass.GetWeaponBonus then
        return MSC.CurrentClass:GetWeaponBonus(itemLink, weights)
    end
    return 0
end

function MSC:CheckMetaRequirements(metaID, counts)
    if MSC.IsEra then return true end -- Era has no metas, always pass
    if not metaID then return false end
    if metaID == 32409 then return (counts.RED >= 2 and counts.BLUE >= 2 and counts.YELLOW >= 2) -- Relentless
    elseif metaID == 34220 then return (counts.BLUE >= 2) -- Chaotic
    elseif metaID == 25893 then return (counts.BLUE > counts.YELLOW) -- Mystical
    elseif metaID == 25896 or metaID == 25899 then return (counts.BLUE >= 3) -- Powerful/Brutal
    end
    return true
end

-- =============================================================
-- 2. GEAR SNAPSHOT
-- =============================================================
local GEAR_SLOTS = { 1, 2, 3, 15, 5, 9, 10, 6, 7, 8, 11, 12, 13, 14, 16, 17, 18 }

function MSC:BuildGearFingerprint(gearTable)
    local parts = {}
    for _, slotID in ipairs(GEAR_SLOTS) do
        local link = gearTable[slotID]
        if link then
            parts[#parts + 1] = slotID .. ":" .. (GetItemInfoInstant(link) or 0)
        end
    end
    return table.concat(parts, ";")
end

function MSC:BuildEvalCacheKey(newItemLink, targetSlotID, specName, baselineGear)
    local cacheType = baselineGear and "S" or "L"
    local rev = MSC.ScoringRevision or 0
    local fp = baselineGear and MSC:BuildGearFingerprint(baselineGear) or "live"
    local itemId = GetItemInfoInstant(newItemLink) or 0
    return itemId .. "|" .. (targetSlotID or 0) .. "|" .. (specName or "Default") .. "|" .. cacheType .. "|" .. rev .. "|" .. fp
end

function MSC:GetCachedCharacterScore(gearTable, weights, specName, baselineGear)
    local rev = MSC.ScoringRevision or 0
    local fp = MSC:BuildGearFingerprint(gearTable)
    local tag = baselineGear and "saved" or "live"
    local key = (specName or "Default") .. "|" .. rev .. "|" .. tag .. "|" .. fp

    if not baselineGear and MSC.EquippedScoreCache and MSC.EquippedScoreCache.key == key then
        return MSC.EquippedScoreCache.score, MSC.EquippedScoreCache.stats, MSC.EquippedScoreCache.colors, MSC.EquippedScoreCache.sets
    end

    local score, stats, colors, sets = MSC:GetTotalCharacterScore(gearTable, weights, specName)
    if not baselineGear then
        MSC.EquippedScoreCache = { key = key, score = score, stats = stats, colors = colors, sets = sets }
    end
    return score, stats, colors, sets
end

function MSC:ShouldUseFastEval(itemLink, compSlot)
    if compSlot == 16 or compSlot == 17 then return false end
    if MSC.ItemSetMap and itemLink then
        local itemID = GetItemInfoInstant(itemLink)
        if itemID and MSC.ItemSetMap[itemID] then return false end
    end
    return true
end

function MSC:EvaluateUpgradeFast(newItemLink, targetSlotID, weights, specName)
    if not newItemLink then return 0, 0 end
    if not weights then weights, specName = MSC.GetCurrentWeights() end

    local compSlot = targetSlotID
    if not compSlot then
        local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(newItemLink)
        if MSC.GetComparisonSlot then
            compSlot = MSC.GetComparisonSlot(newItemLink, equipLoc, weights, specName)
        end
    end
    if not compSlot then return 0, 0 end

    MSC.EquippedSlotScoreCache = MSC.EquippedSlotScoreCache or {}
    local rev = MSC.ScoringRevision or 0
    local eqKey = compSlot .. "|" .. (specName or "") .. "|" .. rev
    local equipped = GetInventoryItemLink("player", compSlot)

    local oldScore = MSC.EquippedSlotScoreCache[eqKey]
    if oldScore == nil then
        if equipped then
            local stats = MSC.SafeGetItemStats(equipped, compSlot, weights, specName)
            oldScore = MSC.GetItemScore(stats, weights, specName, compSlot)
            if compSlot == 16 or compSlot == 17 then
                oldScore = oldScore + (MSC:GetWeaponSpecBonus(equipped, MSC.CurrentClass, specName, weights) or 0)
            end
        else
            oldScore = 0
        end
        MSC.EquippedSlotScoreCache[eqKey] = oldScore
    end

    local newStats = MSC.SafeGetItemStats(newItemLink, compSlot, weights, specName)
    local newScore = MSC.GetItemScore(newStats, weights, specName, compSlot)
    if compSlot == 16 or compSlot == 17 then
        newScore = newScore + (MSC:GetWeaponSpecBonus(newItemLink, MSC.CurrentClass, specName, weights) or 0)
    end

    return newScore, oldScore
end

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
    local globalUniques = {} -- Tracking Table
    
    wipe(Scratch_SetCounts)
    wipe(Scratch_Accumulator)
    Scratch_Colors.RED = 0; Scratch_Colors.YELLOW = 0; Scratch_Colors.BLUE = 0;
    
    local metaGemID = nil 

    -- Use ipairs(GEAR_SLOTS) instead of pairs(gearTable) so unique distribution is deterministic!
    for _, slotID in ipairs(GEAR_SLOTS) do
        local itemLink = gearTable[slotID]
        if itemLink then
            -- [[ 1. GET BASE STATS ]] 
            local cachedStats = MSC.SafeGetItemStats(itemLink, slotID, weights, specName, globalUniques)

            wipe(Scratch_Stats)
            for k, v in pairs(cachedStats) do
                Scratch_Stats[k] = v
            end
            local stats = Scratch_Stats
            
            -- [[ 2. GEM DATA & COLORS ]]
            local gemMode = SGJ_Settings and SGJ_Settings.GemMode or 1
            local gemsProjected = (cachedStats.GEMS_PROJECTED and cachedStats.GEMS_PROJECTED > 0) or cachedStats.BONUS_PROJECTED
            local useProjectedGems = gemsProjected or (gemMode ~= 1)

            if useProjectedGems then
                if cachedStats.META_ID and not metaGemID then metaGemID = cachedStats.META_ID end
                if cachedStats.COLORS then
                    Scratch_Colors.RED = Scratch_Colors.RED + (cachedStats.COLORS.RED or 0)
                    Scratch_Colors.YELLOW = Scratch_Colors.YELLOW + (cachedStats.COLORS.YELLOW or 0)
                    Scratch_Colors.BLUE = Scratch_Colors.BLUE + (cachedStats.COLORS.BLUE or 0)
                end
            elseif MSC.GetItemGems then
                local itemGemIDs = {}
                local rMeta, rGemIDs = nil, nil
                _, rMeta, rGemIDs = MSC:GetItemGems(itemLink)
                if rMeta and not metaGemID then metaGemID = rMeta end
                if rGemIDs then itemGemIDs = rGemIDs end

                if #itemGemIDs > 0 and MSC.GetGemStatsByID then
                    for _, gID in ipairs(itemGemIDs) do
                        local gData = MSC.GetGemStatsByID(gID)
                        if gData then
                            if gData.stat then stats[gData.stat] = (stats[gData.stat] or 0) + gData.val end
                            if gData.stat2 then stats[gData.stat2] = (stats[gData.stat2] or 0) + gData.val2 end
                            MSC.ApplyGemColorCount(gData, Scratch_Colors)
                        end
                    end
                end
            end
            local evalStats = stats
            if stats["ITEM_MOD_SPELL_POWER_SHORT"] then
                evalStats = MSC:SafeCopy(stats, {})
                evalStats["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = (evalStats["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0) + evalStats["ITEM_MOD_SPELL_POWER_SHORT"]
            end
            
            local itemScore = MSC.GetItemScore(evalStats, weights, specName, slotID)
            totalScore = totalScore + itemScore

            -- [[ 5. ACCUMULATE TOTALS ]]
            for k,v in pairs(stats) do 
                if type(v) == "number" and k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" then 
                    Scratch_Accumulator[k] = (Scratch_Accumulator[k] or 0) + v 
                end
            end
            
            -- [[ 6. HANDLE PROCS & SETS ]]
            local itemID = GetItemInfoInstant(itemLink)
            if itemID and MSC.ItemSetMap and MSC.ItemSetMap[itemID] then
                local setID = MSC.ItemSetMap[itemID]
                Scratch_SetCounts[setID] = (Scratch_SetCounts[setID] or 0) + 1 
            end
		end
	end

    -- [[ 7. CALCULATE SET BONUSES ]]
    if MSC.SetBonusScores then
        for setID, count in pairs(Scratch_SetCounts) do
             local scoreData = MSC.SetBonusScores[setID]
             if scoreData then
                 for reqCount, bonusData in pairs(scoreData) do
                     if count >= reqCount then
                         if bonusData.stats then
                             for stat, val in pairs(bonusData.stats) do
                                 Scratch_Accumulator[stat] = (Scratch_Accumulator[stat] or 0) + val
                                 if weights[stat] then totalScore = totalScore + (val * weights[stat]) end
                             end
                         elseif bonusData.score then
                             totalScore = totalScore + bonusData.score
                         end
                     end
                 end
             end
        end
    end

    -- [[ 8. WEAPON SPECIALIZATION BONUS ]]
    local mh = gearTable[16]; local oh = gearTable[17]
    if mh then totalScore = totalScore + MSC:GetWeaponSpecBonus(mh, MSC.CurrentClass, specName, weights) end
    if oh then totalScore = totalScore + MSC:GetWeaponSpecBonus(oh, MSC.CurrentClass, specName, weights) end

    -- [[ 9. META GEM ACTIVATION CHECK (TBC Only) ]]
    if not MSC.IsEra and metaGemID and MSC.CheckMetaRequirements then
        local isActive = MSC:CheckMetaRequirements(metaGemID, Scratch_Colors)
        if not isActive then
             local metaStats = MSC.GetGemStatsByID and MSC.GetGemStatsByID(metaGemID)
             if metaStats then
                 local lostScore = 0
                 if metaStats.stat and weights[metaStats.stat] then lostScore = lostScore + (metaStats.val * weights[metaStats.stat]) end
                 if metaStats.stat2 and weights[metaStats.stat2] then lostScore = lostScore + (metaStats.val2 * weights[metaStats.stat2]) end
                 totalScore = totalScore - lostScore
             end
        end
    end

    return totalScore, MSC:SafeCopy(Scratch_Accumulator), MSC:SafeCopy(Scratch_Colors), MSC:SafeCopy(Scratch_SetCounts)
end

-- =============================================================
-- 4. BAG SCANNERS (Cached & Optimized)
-- =============================================================

	-- [[ A. CACHE STORAGE (Namespace Fixed) ]]
	MSC.WeaponBagCache = {
		MainHand = nil,
		OffHand = nil,
		Dirty = true,  
		LastSpec = nil 
	}

	-- [[ B. EVENT LISTENER ]]
	local CacheWatcher = CreateFrame("Frame")
	CacheWatcher:RegisterEvent("BAG_UPDATE")
	CacheWatcher:SetScript("OnEvent", function() 
		MSC.WeaponBagCache.Dirty = true 
	end)

	-- [[ C. INTERNAL SCANNERS (The heavy lifting) ]]
	function MSC:Internal_ScanBestMainHand(weights, specName)
		local bestLink = nil
		local bestScore = -1

		for bag = 0, 4 do
			local numSlots = GetBagSlots(bag) 
			for slot = 1, numSlots do
				local link = GetBagLink(bag, slot)
				if link and MSC.IsItemUsable(link) then 
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

	function MSC:Internal_ScanBestOffHand(weights, specName)
		local bestLink = nil
		local bestScore = -1
		local _, playerClass = UnitClass("player")
		local playerLevel = UnitLevel("player")
		
		-- Check Dual Wield capabilities
		local canDualWield = false
		if playerClass == "ROGUE" or playerClass == "WARRIOR" then
			if playerLevel >= 10 then canDualWield = true end
		elseif playerClass == "HUNTER" then
			if playerLevel >= 20 then canDualWield = true end
		elseif playerClass == "SHAMAN" and MSC.GetTalentRank then
			if MSC:GetTalentRank("DUAL_WIELD") > 0 then canDualWield = true end
		end

		for bag = 0, 4 do
			local numSlots = GetBagSlots(bag) 
			for slot = 1, numSlots do
				local link = GetBagLink(bag, slot)
				if link and MSC.IsItemUsable(link) then
					local _, _, _, _, _, _, _, _, loc = GetItemInfo(link)
					
					local isWeapon   = (loc == "INVTYPE_WEAPON" or loc == "INVTYPE_WEAPONOFFHAND")
					local isStandard = (loc == "INVTYPE_SHIELD" or loc == "INVTYPE_HOLDABLE")
					
					local allowed = false
					if isStandard then
						allowed = true
					elseif isWeapon and canDualWield then
						allowed = true
					end

					if allowed and IsEquippableItem(link) then
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

	-- [[ D. PUBLIC GETTERS  ]]
	function MSC:GetBestMainHandInBags(weights, specName)
		if MSC.WeaponBagCache.Dirty or MSC.WeaponBagCache.LastSpec ~= specName then
			MSC.WeaponBagCache.MainHand = MSC:Internal_ScanBestMainHand(weights, specName)
			MSC.WeaponBagCache.OffHand  = MSC:Internal_ScanBestOffHand(weights, specName)
			MSC.WeaponBagCache.Dirty = false
			MSC.WeaponBagCache.LastSpec = specName
		end
		return MSC.WeaponBagCache.MainHand
	end

	function MSC:GetBestOffHandInBags(weights, specName)
		if MSC.WeaponBagCache.Dirty or MSC.WeaponBagCache.LastSpec ~= specName then
			MSC.WeaponBagCache.MainHand = MSC:Internal_ScanBestMainHand(weights, specName)
			MSC.WeaponBagCache.OffHand  = MSC:Internal_ScanBestOffHand(weights, specName)
			MSC.WeaponBagCache.Dirty = false
			MSC.WeaponBagCache.LastSpec = specName
		end
		return MSC.WeaponBagCache.OffHand
	end
	

-- =============================================================
-- 5. EVALUATE UPGRADE (CACHED)
-- =============================================================

-- [[ PERFORMANCE CACHE ]]
MSC.EvaluationCache = {}
local CacheCleaner = CreateFrame("Frame")
CacheCleaner:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
CacheCleaner:RegisterEvent("PLAYER_TALENT_UPDATE")
CacheCleaner:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
CacheCleaner:RegisterEvent("PLAYER_LEVEL_UP")
CacheCleaner:RegisterEvent("BAG_UPDATE") 
CacheCleaner:RegisterEvent("PLAYER_ENTERING_WORLD") 
CacheCleaner:RegisterEvent("GET_ITEM_INFO_RECEIVED") 

local wipeTimer = nil

CacheCleaner:SetScript("OnEvent", function(self, event)
    if event == "GET_ITEM_INFO_RECEIVED" then
        if not wipeTimer then
            wipeTimer = C_Timer.After(0.5, function()
                if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
                if MSC.ProcessedStatCache then wipe(MSC.ProcessedStatCache) end
                if MSC.StatCache then wipe(MSC.StatCache) end
                wipeTimer = nil
            end)
        end
    elseif event == "BAG_UPDATE" then
        if MSC.WeaponBagCache then MSC.WeaponBagCache.Dirty = true end
        if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        if MSC.EquippedSlotScoreCache then wipe(MSC.EquippedSlotScoreCache) end
        MSC.EquippedScoreCache = nil
        if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
    else
        if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
        MSC.EquippedScoreCache = nil
    end
end)


function MSC:EvaluateUpgrade(newItemLink, targetSlotID, weights, specName, baselineGear)
    if not newItemLink then return 0, 0, {}, {}, {} end
    if not weights then weights, specName = MSC.GetCurrentWeights() end

    -- [[ 1. CACHE CHECK ]]
    local cacheKey = MSC:BuildEvalCacheKey(newItemLink, targetSlotID, specName, baselineGear)
    
    if MSC.EvaluationCache[cacheKey] then
        return unpack(MSC.EvaluationCache[cacheKey])
    end

    -- [[ 2. SETUP & CURRENT SCORE ]]
    -- Use the saved gear if provided, otherwise fallback to the live paper doll
    if baselineGear then
        MSC:SafeCopy(baselineGear, Scratch_Gear)
    else
        MSC:GetEquippedGear(Scratch_Gear)
    end
    
    local currentScore, currentStatsTotal, _, oldSetCounts = MSC:GetCachedCharacterScore(Scratch_Gear, weights, specName, baselineGear)

    local originalItem = Scratch_Gear[targetSlotID]
    local originalMH   = Scratch_Gear[16]
    local originalOH   = Scratch_Gear[17]
    local contextMsg   = nil

    -- [[ 3. PRE-CALCULATE ITEM STATS ]]
    local parsedNewStats = MSC.SafeGetItemStats(newItemLink, targetSlotID, weights, specName)
    local finalNewStats = {}
    for k, v in pairs(parsedNewStats) do finalNewStats[k] = v end

    local finalOldStats = {}
    
    -- Pull the old item from the baseline if it exists, otherwise the live paper doll
    local oldItemLink = baselineGear and baselineGear[targetSlotID] or GetInventoryItemLink("player", targetSlotID)
    
    if oldItemLink then 
        local fs = MSC.SafeGetItemStats(oldItemLink, targetSlotID, weights, specName) 
        for k,v in pairs(fs) do finalOldStats[k] = v end

        if finalOldStats._AUTO_PROC then
             local p = finalOldStats._AUTO_PROC
             finalOldStats[p.stat] = (finalOldStats[p.stat] or 0) + p.val
        end
    end

    -- [[ 4. SWAP GEAR & HANDLE MH/OH LOGIC ]]
    Scratch_Gear[targetSlotID] = newItemLink
    
    local _,_,_,_,_,_,_,_, newLoc = GetItemInfo(newItemLink)
    local isNew2H = (newLoc == "INVTYPE_2HWEAPON" or newLoc == "INVTYPE_STAFF" or newLoc == "INVTYPE_POLEARM")
    local is2HSpec = (specName and (string_find(specName, "ARMS") or string_find(specName, "RET") or string_find(specName, "2H")))

    if targetSlotID == 16 then
        if isNew2H then
            Scratch_Gear[17] = nil 
        else
            local needsOH = false
            local currentMH = originalMH
            if currentMH then
                local _,_,_,_,_,_,_,_, currLoc = GetItemInfo(currentMH)
                local isCurrent2H = (currLoc == "INVTYPE_2HWEAPON" or currLoc == "INVTYPE_STAFF" or currLoc == "INVTYPE_POLEARM")
                if isCurrent2H then needsOH = true end
            else
                needsOH = true
            end

            if not Scratch_Gear[17] then needsOH = true end

			if needsOH then
				if is2HSpec then
					Scratch_Gear[17] = nil
					contextMsg = MSC.L["|cffff0000(Not 2Hander)|r"]
				else
					local bestBagOH = MSC:GetBestOffHandInBags(weights, specName)
					if bestBagOH then
						Scratch_Gear[17] = bestBagOH
						local bagName = GetItemInfo(bestBagOH)
						contextMsg = string_format(MSC.L["|cff00ff00(w/ %s)|r"], (bagName or MSC.L["Bag Item"]))
					else
						if not Scratch_Gear[17] then
							contextMsg = MSC.L["|cffff0000(No OH found)|r"]
						end
					end
				end
			end
		end
	elseif targetSlotID == 17 then
		local currentMH = originalMH
		if currentMH then
			local _,_,_,_,_,_,_,_, currLoc = GetItemInfo(currentMH)
			local isCurrent2H = (currLoc == "INVTYPE_2HWEAPON" or currLoc == "INVTYPE_STAFF" or currLoc == "INVTYPE_POLEARM")
			
			if isCurrent2H then
				local bestBagMH = MSC:GetBestMainHandInBags(weights, specName)
				if bestBagMH then
					Scratch_Gear[16] = bestBagMH
					local bagName = GetItemInfo(bestBagMH)
					contextMsg = string_format(MSC.L["|cff00ff00(w/ %s)|r"], (bagName or MSC.L["Bag Item"]))
				else
					Scratch_Gear[16] = nil
					contextMsg = MSC.L["|cffff0000(No MH found)|r"]
				end
			end
		end
	end

    -- [[ 5. CALCULATE FUTURE SCORE ]]
    local newScore, newStatsTotal, newTotalColors, newSetCounts = MSC:GetTotalCharacterScore(Scratch_Gear, weights, specName)

	-- [[ 6. CONTEXT: DETECT SET COMPLETION ]]
    if MSC.SetBonusScores then
        for setID, scores in pairs(MSC.SetBonusScores) do
             local nC = (newSetCounts and newSetCounts[setID]) or 0
             local oC = (oldSetCounts and oldSetCounts[setID]) or 0
             
             if nC > oC then
                 for req, _ in pairs(scores) do
                     local rN = tonumber(req)
                     if rN and nC >= rN and oC < rN then
						 local msg = string_format(MSC.L["|cff00ff00(Set Bonus %s)|r"], rN)
						 contextMsg = (contextMsg or "") .. " " .. msg
					 end
                 end
             end
        end
    end

    -- [[ 7. CAP GUARDIAN (Hit/Def Caps) ]]
    local _, playerClass = UnitClass("player")
    local function Rank(k) return MSC:GetTalentRank(k) end 

    local STAT_DISPLAY = { 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = MSC.L["Hit"], 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = MSC.L["Spell Hit"], 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = MSC.L["Exp"], 
        ["DEFENSE_FLOOR"]                   = MSC.L["Def"] 
    }
    
    if MSC.SAFETY_CAPS[playerClass] then
        for _, rule in ipairs(MSC.SAFETY_CAPS[playerClass]) do
            if rule.stat ~= "DEFENSE_FLOOR" then
                local trueCap = rule.base
                if rule.talent then trueCap = trueCap - (Rank(rule.talent) * (rule.tVal or 0)) end
                if MSC.BuffEngine and (rule.stat == "ITEM_MOD_HIT_SPELL_RATING_SHORT" or rule.stat == "ITEM_MOD_HIT_RATING_SHORT") then
                    trueCap = MSC.BuffEngine:GetEffectiveHitRatingBase(rule.stat, rule.talent, rule.tVal, specName)
                end
                
                local currentVal = 0
                if baselineGear then
                    currentVal = currentStatsTotal[rule.stat] or 0
                else
                    currentVal = MSC:GetPlayerStat(rule.stat == "ITEM_MOD_HIT_RATING_SHORT" and "HIT" or "SPELL_HIT")
                end
                
                local oldGearVal = currentStatsTotal[rule.stat] or 0
                local newGearVal = newStatsTotal[rule.stat] or 0
                local diff = newGearVal - oldGearVal
                local futureVal = currentVal + diff
                
                if currentVal >= trueCap and futureVal < (trueCap - 0.1) then
                    newScore = newScore - rule.penalty
                    local deficit = futureVal - trueCap
                    local name = STAT_DISPLAY[rule.stat] or MSC.L["Cap"]
                    local msg = string_format(MSC.L[" |cffff0000(Cap %.1f %s)|r"], deficit, name)
                    contextMsg = (contextMsg or "") .. msg
                end
            
            elseif rule.stat == "DEFENSE_FLOOR" then
                local defWeight = weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0
                if defWeight > 0 then
                    local floor = MSC.GetDefenseFloor and MSC:GetDefenseFloor(rule) or rule.base
                    local currentDef = 0
                    if baselineGear then
                        local defFromGear = currentStatsTotal["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0
                        local baseDef = UnitLevel("player") * 5
                        if MSC.IsEra then
                            currentDef = baseDef + defFromGear
                        else
                            currentDef = baseDef + math_floor(defFromGear / 2.36)
                        end
                    else
                        currentDef = MSC:GetPlayerStat("DEFENSE")
                    end

                    local oldDefRating = currentStatsTotal["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0
                    local newDefRating = newStatsTotal["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0
                    local diffSkill
                    if MSC.IsEra then
                        diffSkill = newDefRating - oldDefRating
                    else
                        diffSkill = (newDefRating - oldDefRating) / 2.36
                    end
                    local futureDef = currentDef + diffSkill

                    if currentDef >= floor and futureDef < (floor - 0.1) then
                         newScore = newScore - rule.penalty
                         local deficit = futureDef - floor
                         local msg = string_format(MSC.L[" |cffff0000(Cap %.1f Def)|r"], deficit)
                         contextMsg = (contextMsg or "") .. msg
                    end
                end
            end
        end
    end

    -- [[ 8. FINALIZE & STORE CACHE ]]
    Scratch_Gear[targetSlotID] = originalItem
    Scratch_Gear[16] = originalMH
    Scratch_Gear[17] = originalOH
    
    local result = { newScore, currentScore, finalNewStats, finalOldStats, newStatsTotal, currentStatsTotal, newTotalColors, oldSetCounts, newSetCounts, contextMsg }
    MSC.EvaluationCache[cacheKey] = result
    
    return unpack(result)
end