local _, MSC = ...

-- =============================================================
-- 1. INITIALIZATION & SLASH COMMANDS
-- =============================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if not SGJ_Settings then SGJ_Settings = {} end
    if SGJ_Settings.EnchantMode == nil then SGJ_Settings.EnchantMode = 1 end
    if SGJ_Settings.GemMode == nil then SGJ_Settings.GemMode = 1 end
    if SGJ_Settings.Mode == nil then SGJ_Settings.Mode = "Auto" end
    if MSC.UpdateMinimapPosition then MSC.UpdateMinimapPosition() end
    print("|cff00ccffSharpie's Gear Judge|r (TBC) loaded. Type /sgj for the Lab.")
end)

SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg) 
    if msg == "options" or msg == "config" then 
        if MSC.CreateOptionsFrame then MSC.CreateOptionsFrame() end 
    else 
        if MSC.CreateLabFrame then MSC.CreateLabFrame() end 
    end 
end

-- =============================================================
-- 2. HELPER: DERIVED STATS & SORTING
-- =============================================================
local function GetCleanStatName(key, expandedStats)
    local name = MSC.GetCleanStatName and MSC.GetCleanStatName(key) or key
    -- Compact Stat Lines (v1.5.2 Feature)
    if key == "ITEM_MOD_HEALTH_SHORT" and (expandedStats["ITEM_MOD_STAMINA_SHORT"] or 0) > 0 then name = "Health (w/ Stam)" end
    if key == "ITEM_MOD_MANA_SHORT" and (expandedStats["ITEM_MOD_INTELLECT_SHORT"] or 0) > 0 then name = "Mana (w/ Int)" end
    if key == "ITEM_MOD_ATTACK_POWER_SHORT" and ((expandedStats["ITEM_MOD_STRENGTH_SHORT"] or 0) > 0 or (expandedStats["ITEM_MOD_AGILITY_SHORT"] or 0) > 0) then name = "Atk Power (Total)" end
    return name
end

local function MergeStats(t1, t2)
    local out = {}
    if t1 then for k,v in pairs(t1) do out[k] = v end end
    if t2 then for k,v in pairs(t2) do if type(v) == "number" then out[k] = (tonumber(out[k]) or 0) + v else out[k] = v end end end
    return out
end

-- =============================================================
-- 3. TOOLTIP ENGINE
-- =============================================================
function MSC.UpdateTooltip(tooltip)
    if SGJ_Settings.HideTooltips then return end
    
    local _, link = nil, nil
    if tooltip.GetItem then _, link = tooltip:GetItem() end
    if not link then return end

    -- [[ 1. THE JUNK FILTER ]]
    if not IsEquippableItem(link) then return end
    local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
    if equipLoc == "INVTYPE_BAG" or equipLoc == "INVTYPE_TABARD" or equipLoc == "INVTYPE_BODY" or equipLoc == "INVTYPE_AMMO" or equipLoc == "INVTYPE_QUIVER" then return end

    if MSC.IsItemUsable and not MSC.IsItemUsable(link) then 
        tooltip:AddLine(" ")
        tooltip:AddLine("|cffff0000Sharpie's Verdict: CLASS UNUSABLE|r")
        tooltip:Show()
        return 
    end

    local _, _, _, _, dbMinLevel = GetItemInfo(link)
    local myLevel = UnitLevel("player")
    local isFutureItem = (dbMinLevel and dbMinLevel > myLevel)

    local weights, specName = MSC.GetCurrentWeights()
    if not weights then return end

    local slotId = MSC.SlotMap and MSC.SlotMap[equipLoc] or nil
    local oldScore, newScore = 0, 0
    local oldStats, newStats = {}, {}
    local partnerItemLink = nil
    local isEquipped = false
    local noteText = nil

    local equippedMH = GetInventoryItemLink("player", 16)
    local equippedOH = GetInventoryItemLink("player", 17)
    local equippedMHLoc = equippedMH and select(9, GetItemInfo(equippedMH))

    -- [[ 2. SLOT LOGIC (2H vs DW Handling) ]]
    if equipLoc == "INVTYPE_2HWEAPON" then
        newStats = MSC.SafeGetItemStats(link, 16)
        newScore = MSC.GetItemScore(newStats, weights, specName, 16)
        local mhLink, ohLink = equippedMH, equippedOH
        local filledFromBag = false
        if equippedMHLoc ~= "INVTYPE_2HWEAPON" then
             if not mhLink then mhLink = MSC.FindBestMainHand(weights, specName); filledFromBag = true end
             if not ohLink then ohLink = MSC.FindBestOffhand(weights, specName); filledFromBag = true end
        end
        local mhStats = MSC.SafeGetItemStats(mhLink, 16)
        local ohStats = MSC.SafeGetItemStats(ohLink, 17)
        oldStats = MergeStats(mhStats, ohStats)
        oldScore = MSC.GetItemScore(mhStats, weights, specName, 16) + MSC.GetItemScore(ohStats, weights, specName, 17)
        if filledFromBag or (equippedMHLoc ~= "INVTYPE_2HWEAPON" and equippedOH) then noteText = "Comparing vs: " .. (mhLink or "Empty") .. " + " .. (ohLink or "Empty") end
        if link == equippedMH then isEquipped = true end

    elseif (equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestOHLink, bestOHScore, bestOHStats = MSC.FindBestOffhand(weights, specName)
        local mhStats = MSC.SafeGetItemStats(link, 16)
        local mhScore = MSC.GetItemScore(mhStats, weights, specName, 16)
        if bestOHLink then newStats = MergeStats(mhStats, bestOHStats); newScore = mhScore + bestOHScore; partnerItemLink = bestOHLink
        else newStats = mhStats; newScore = mhScore; noteText = "|cffff0000(No Offhand found)|r" end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16)
        oldScore = MSC.GetItemScore(oldStats, weights, specName, 16)

    elseif (equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestMHLink, bestMHScore, bestMHStats = MSC.FindBestMainHand(weights, specName)
        local ohStats = MSC.SafeGetItemStats(link, 17)
        local ohScore = MSC.GetItemScore(ohStats, weights, specName, 17)
        if bestMHLink then newStats = MergeStats(bestMHStats, ohStats); newScore = bestMHScore + ohScore; partnerItemLink = bestMHLink
        else newStats = ohStats; newScore = ohScore; noteText = "|cffff0000(No Mainhand found)|r" end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16)
        oldScore = MSC.GetItemScore(oldStats, weights, specName, 16)

    elseif slotId == 11 or slotId == 13 then
        local s1, s2 = slotId, slotId + 1
        local l1, l2 = GetInventoryItemLink("player", s1), GetInventoryItemLink("player", s2)
        local st1, st2 = MSC.SafeGetItemStats(l1, s1), MSC.SafeGetItemStats(l2, s2)
        local sc1, sc2 = MSC.GetItemScore(st1, weights, specName, s1), MSC.GetItemScore(st2, weights, specName, s2)
        local targetSlot, targetLink, otherLink = s1, l1, l2
        
        if (not l1) then targetSlot = s1; targetLink = nil; otherLink = l2
        elseif (not l2) then targetSlot = s2; targetLink = nil; otherLink = l1
        elseif sc2 < sc1 then targetSlot = s2; targetLink = l2; otherLink = l1 end
        
        if link == l1 then isEquipped = true; targetSlot = s1; targetLink = l1; otherLink = l2
        elseif link == l2 then isEquipped = true; targetSlot = s2; targetLink = l2; otherLink = l1 end
        
        partnerItemLink = otherLink 
        oldStats = MSC.SafeGetItemStats(targetLink, targetSlot)
        oldScore = MSC.GetItemScore(oldStats, weights, specName, targetSlot)
        newStats = MSC.SafeGetItemStats(link, targetSlot)
        newScore = MSC.GetItemScore(newStats, weights, specName, targetSlot)

        if not isEquipped then noteText = "Comparing vs: " .. (targetLink or "Empty") .. " (Weakest)" end

    elseif slotId then
        local compLink = GetInventoryItemLink("player", slotId)
        local isBagItem = false
        if not compLink then
            if slotId == 16 then compLink = MSC.FindBestMainHand(weights, specName); if compLink then isBagItem = true end end
            if slotId == 17 then compLink = MSC.FindBestOffhand(weights, specName); if compLink then isBagItem = true end end
        end
        if link == compLink then isEquipped = true end
        if isBagItem then noteText = "Comparing vs: " .. (compLink or "Unknown") .. " (Best in Bag)" end
        
        if slotId == 17 then partnerItemLink = GetInventoryItemLink("player", 16) end
        if slotId == 16 then partnerItemLink = GetInventoryItemLink("player", 17) end
        
        oldStats = MSC.SafeGetItemStats(compLink, slotId)
        oldScore = MSC.GetItemScore(oldStats, weights, specName, slotId)
        newStats = MSC.SafeGetItemStats(link, slotId)
        newScore = MSC.GetItemScore(newStats, weights, specName, slotId)
    end
    
    -- [[ 3. DISPLAY HEADER ]]
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine("Judge's Score:", string.format("%.1f", newScore), 1, 0.82, 0, 1, 1, 1)
    tooltip:AddDoubleLine("|cff00ccffSharpie's Verdict:|r", "|cffffffff" .. specName .. "|r")
    
    if noteText then tooltip:AddLine(noteText, 0.7, 0.7, 0.7) end
    
    if isEquipped then
        if partnerItemLink then tooltip:AddLine("|cff00ffff*** EQUIPPED WITH: " .. partnerItemLink .. " ***|r")
        else tooltip:AddLine("|cff00ffff*** (Baseline) ***|r") end 
    else
        local delta = newScore - oldScore
        if partnerItemLink and delta >= 0 then 
            tooltip:AddLine("|cff00ff00*** BEST PAIR WITH: " .. partnerItemLink .. " ***|r") 
        end
        
        if isFutureItem then
             tooltip:AddLine("|cffFF55FF*** FUTURE UPGRADE (+" .. string.format("%.1f", delta) .. ") ***|r")
             if dbMinLevel then tooltip:AddLine("|cffFF55FF(Requires Level " .. dbMinLevel .. ")|r") end
        else
            if delta > 0.1 then tooltip:AddLine("|cff00ff00*** UPGRADE (+" .. string.format("%.1f", delta) .. ") ***|r")
            elseif delta < -0.1 then tooltip:AddLine("|cffff0000*** DOWNGRADE (" .. string.format("%.1f", delta) .. ") ***|r")
            else tooltip:AddLine("|cffffffff*** EQUAL STATS ***|r") end
        end
    end

    -- [[ 4. PROJECTION DISPLAY ]]
    if newStats.IS_PROJECTED or newStats.GEMS_PROJECTED then 
        tooltip:AddLine(" ") -- Spacer
        if newStats.ENCHANT_TEXT then
             tooltip:AddDoubleLine("Projected Enchant:", "|cffffffff" .. newStats.ENCHANT_TEXT .. "|r", 0, 1, 1)
        elseif newStats.IS_PROJECTED then
             tooltip:AddDoubleLine("Projected Enchant:", "|cffffffffBest Available|r", 0, 1, 1)
        end
        if newStats.GEM_TEXT then
             tooltip:AddDoubleLine("Projected Gems:", "|cffffffff" .. newStats.GEM_TEXT .. "|r", 0, 1, 1)
        elseif newStats.GEMS_PROJECTED then 
             local gemTier = (UnitLevel("player") < 70) and "Green" or "Rare"
             tooltip:AddDoubleLine("Projected Gems:", "|cffffffff" .. newStats.GEMS_PROJECTED .. " " .. gemTier .. "|r", 0, 1, 1)
        end
        if newStats.BONUS_PROJECTED then
             tooltip:AddLine("   + Socket Bonus Activated", 0, 1, 0)
        end
    end

    -- [[ 5. RACIAL SYNERGY (Visual v1.5.3) ]]
    local _, playerRace = UnitRace("player")
    if MSC.RacialTraits and MSC.RacialTraits[playerRace] then
        local _, _, _, _, _, _, itemSubType = GetItemInfo(link)
        if itemSubType and MSC.RacialTraits[playerRace][itemSubType] then
             local r = MSC.RacialTraits[playerRace][itemSubType]
             local rName = MSC.StatShortNames[r.stat] or "Bonus"
             tooltip:AddDoubleLine("Matches Racial:", "|cff00ff00+" .. r.val .. " " .. rName .. "|r", 1, 1, 1)
        end
    end

    -- [[ 6. GAINS & LOSSES (Visual v1.5.2) ]]
    local _, englishClass = UnitClass("player")
    local newExpanded = MSC.ExpandDerivedStats(newStats, link) -- Note: Passed Link to Scoring too
    
    if isEquipped then
        -- SCENARIO A: Inspecting Equipped Gear (Show Absolute Values in Gold/Green)
        local sortedKeys = {}
        for k, v in pairs(newExpanded) do table.insert(sortedKeys, k) end
        table.sort(sortedKeys, function(a,b) return (weights[a] or 0) > (weights[b] or 0) end)

        for _, stat in ipairs(sortedKeys) do
            local isRelevant = (weights[stat] and weights[stat] > 0) or 
                               (stat == "ITEM_MOD_HEALTH_SHORT") or 
                               (stat == "ITEM_MOD_MANA_SHORT") or 
                               (stat == "ITEM_MOD_ATTACK_POWER_SHORT")
            if isRelevant and not string.find(stat, "PROJECTED") and not string.find(stat, "COUNT") and stat ~= "GEM_TEXT" and stat ~= "ENCHANT_TEXT" then
                 local val = newExpanded[stat] or 0
                 if val > 0 then
                     local name = GetCleanStatName(stat, newExpanded)
                     local valStr = (val % 1 == 0) and string.format("%d", val) or string.format("%.1f", val)
                     tooltip:AddDoubleLine(name, valStr, 1, 0.82, 0, 1, 0.82, 0)
                 end
            end
        end
    else
        -- SCENARIO B: Comparison (Show Gains in Green, Losses in Red)
        local oldExpanded = MSC.ExpandDerivedStats(oldStats, partnerItemLink or (isEquipped and link))
        local diffs = MSC.GetStatDifferences(newExpanded, oldExpanded)
        local gains, losses = {}, {}
        
        for _, d in ipairs(diffs) do
            local isRelevant = (weights[d.key] and weights[d.key] > 0) or 
                               (d.key == "ITEM_MOD_HEALTH_SHORT") or 
                               (d.key == "ITEM_MOD_MANA_SHORT") or 
                               (d.key == "ITEM_MOD_ATTACK_POWER_SHORT")
            if isRelevant then
                if d.val > 0 then table.insert(gains, d)
                elseif d.val < 0 then table.insert(losses, d) end
            end
        end
        
        -- Sort by magnitude
        table.sort(gains, function(a,b) return (weights[a.key] or 0) > (weights[b.key] or 0) end)
        table.sort(losses, function(a,b) return (weights[a.key] or 0) > (weights[b.key] or 0) end)
        
        if #gains > 0 then
            tooltip:AddLine("Gains:", 0, 1, 0)
            for _, g in ipairs(gains) do
                local name = GetCleanStatName(g.key, newExpanded)
                local valStr = (g.val % 1 == 0) and string.format("+%d", g.val) or string.format("+%.1f", g.val)
                tooltip:AddDoubleLine("  " .. name, valStr, 1, 1, 1, 0, 1, 0)
            end
        end
        
        if #losses > 0 then
            tooltip:AddLine("Losses:", 1, 0, 0)
            for _, l in ipairs(losses) do
                local name = GetCleanStatName(l.key, oldExpanded)
                local valStr = (l.val % 1 == 0) and string.format("%d", l.val) or string.format("%.1f", l.val)
                tooltip:AddDoubleLine("  " .. name, valStr, 1, 1, 1, 1, 0, 0)
            end
        end
    end

    tooltip:Show()
end

GameTooltip:HookScript("OnTooltipSetItem", MSC.UpdateTooltip)
if ItemRefTooltip then ItemRefTooltip:HookScript("OnTooltipSetItem", MSC.UpdateTooltip) end
if ShoppingTooltip1 then ShoppingTooltip1:HookScript("OnTooltipSetItem", MSC.UpdateTooltip) end
if ShoppingTooltip2 then ShoppingTooltip2:HookScript("OnTooltipSetItem", MSC.UpdateTooltip) end