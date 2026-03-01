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
        WARRIOR = { { stat="ITEM_MOD_HIT_RATING_SHORT", base=9, penalty=100 } },
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

function MSC:GetWeaponSpecBonus(itemLink, class, specName)
    if MSC.CurrentClass and MSC.CurrentClass.GetWeaponBonus then
        return MSC.CurrentClass:GetWeaponBonus(itemLink)
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
            
            -- [[ 2. GET GEM DATA ]]
            local itemGemIDs = {}
            local rMeta, rGemIDs = nil, nil

            if MSC.GetItemGems then
                _, rMeta, rGemIDs = MSC:GetItemGems(itemLink)
                if rMeta and not metaGemID then metaGemID = rMeta end
                if rGemIDs then itemGemIDs = rGemIDs end
            end
            
            -- [[ 3. GEM STAT & COLOR INJECTION ]]
            if #itemGemIDs > 0 and MSC.GetGemStatsByID then
                for _, gID in ipairs(itemGemIDs) do
                    local gData = MSC.GetGemStatsByID(gID)
                    
                    if gData then
                        -- A. APPLY STATS
                        if gData.stat then stats[gData.stat] = (stats[gData.stat] or 0) + gData.val end
                        if gData.stat2 then stats[gData.stat2] = (stats[gData.stat2] or 0) + gData.val2 end

                        -- B. TRACK META GEM COLORS (TBC Logic)
                        if not MSC.IsEra and gData.colorType then
                            if gData.colorType == "RED" then
                                Scratch_Colors.RED = Scratch_Colors.RED + 1
                            elseif gData.colorType == "BLUE" then
                                Scratch_Colors.BLUE = Scratch_Colors.BLUE + 1
                            elseif gData.colorType == "YELLOW" then
                                Scratch_Colors.YELLOW = Scratch_Colors.YELLOW + 1
                            elseif gData.colorType == "PURPLE" then
                                Scratch_Colors.RED = Scratch_Colors.RED + 1
                                Scratch_Colors.BLUE = Scratch_Colors.BLUE + 1
                            elseif gData.colorType == "ORANGE" then
                                Scratch_Colors.RED = Scratch_Colors.RED + 1
                                Scratch_Colors.YELLOW = Scratch_Colors.YELLOW + 1
                            elseif gData.colorType == "GREEN" then
                                Scratch_Colors.BLUE = Scratch_Colors.BLUE + 1
                                Scratch_Colors.YELLOW = Scratch_Colors.YELLOW + 1
                            elseif gData.colorType == "PRISMATIC" then
                                Scratch_Colors.RED = Scratch_Colors.RED + 1
                                Scratch_Colors.BLUE = Scratch_Colors.BLUE + 1
                                Scratch_Colors.YELLOW = Scratch_Colors.YELLOW + 1
                            end
                        end
                    end
                end
            end
            
            -- [[ 4. SCORE THE ITEM ]]
            local itemScore = MSC.GetItemScore(stats, weights, specName, slotID)
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
	end-- =============================================================
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
                wipe(MSC.EvaluationCache)
                wipe(MSC.StatCache)
                wipeTimer = nil
            end)
        end
    else
        wipe(MSC.EvaluationCache)
        wipe(MSC.StatCache)
    end
end)


function MSC:EvaluateUpgrade(newItemLink, targetSlotID, weights, specName)
    if not newItemLink then return 0, 0, {}, {}, {} end
    if not weights then weights, specName = MSC.GetCurrentWeights() end

    -- [[ 1. CACHE CHECK ]]
    -- We include slotID and specName in key because an item's score depends on where it goes and who uses it
    local cacheKey = (newItemLink or "nil") .. "_" .. (targetSlotID or "0") .. "_" .. (specName or "Default")
    
    if MSC.EvaluationCache[cacheKey] then
        return unpack(MSC.EvaluationCache[cacheKey])
    end

    -- [[ 2. SETUP & CURRENT SCORE ]]
    MSC:GetEquippedGear(Scratch_Gear)
    
    local currentScore, currentStatsTotal, _, oldSetCounts = MSC:GetTotalCharacterScore(Scratch_Gear, weights, specName)

    local originalItem = Scratch_Gear[targetSlotID]
    local originalMH   = Scratch_Gear[16]
    local originalOH   = Scratch_Gear[17]
    local contextMsg   = nil

-- [[ 3. PRE-CALCULATE ITEM STATS ]]
    local parsedNewStats = MSC.SafeGetItemStats(newItemLink, targetSlotID, weights, specName)
    local finalNewStats = {}
    for k, v in pairs(parsedNewStats) do finalNewStats[k] = v end

    local finalOldStats = {}
    
    local oldItemLink = GetInventoryItemLink("player", targetSlotID)
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
            local currentMH = GetInventoryItemLink("player", 16)
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
		local currentMH = GetInventoryItemLink("player", 16)
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
                
                local currentVal = MSC:GetPlayerStat(rule.stat == "ITEM_MOD_HIT_RATING_SHORT" and "HIT" or "SPELL_HIT")
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
            
            elseif rule.stat == "DEFENSE_FLOOR" and MSC.IsTBC then
                local defWeight = weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0
                if defWeight > 0 then
                    local currentDef = MSC:GetPlayerStat("DEFENSE")
                    local oldDefRating = currentStatsTotal["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0
                    local newDefRating = newStatsTotal["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0
                    
                    local diffSkill = (newDefRating - oldDefRating) / 2.36
                    local futureDef = currentDef + diffSkill
                    
                    if currentDef >= rule.base and futureDef < (rule.base - 0.1) then
                     newScore = newScore - rule.penalty
                     local deficit = futureDef - rule.base
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