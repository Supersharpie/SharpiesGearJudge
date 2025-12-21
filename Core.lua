local _, MSC = ... 

-- =============================================================
-- 1. INITIALIZATION
-- =============================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "SharpiesGearJudge" then
        if not SGJ_Settings then SGJ_Settings = { Mode = "Auto", MinimapPos = 45, IncludeEnchants = false, ProjectEnchants = true } end
        if MSC.UpdateMinimapPosition then MSC.UpdateMinimapPosition() end
        print("|cff00ccffSharpie's Gear Judge|r loaded! Type |cff00ff00/sgj|r to open the lab.")
    end
end)

-- =============================================================
-- 2. SLASH COMMANDS
-- =============================================================
SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg) 
    if msg == "options" or msg == "config" then MSC.CreateOptionsFrame() else MSC.CreateLabFrame() end 
end

-- =============================================================
-- 3. TOOLTIP LOGIC 
-- =============================================================
local function MergeStats(t1, t2)
    local out = {}
    if t1 then for k,v in pairs(t1) do out[k] = v end end
    if t2 then for k,v in pairs(t2) do out[k] = (out[k] or 0) + v end end
    return out
end

function MSC.UpdateTooltip(tooltip)
    if SGJ_Settings.HideTooltips then return end 
    if not tooltip.GetItem then return end

    local _, link = tooltip:GetItem()
    if not link then return end
    
    -- CHECK 1: Class Usable
    if not MSC.IsItemUsable(link) then 
        tooltip:AddLine(" "); tooltip:AddLine("|cffff0000Sharpie's Verdict: CLASS UNUSABLE|r"); tooltip:Show(); return 
    end

    -- CHECK 2: Future Upgrade Logic
    local _, _, _, _, dbMinLevel = GetItemInfo(link)
    local myLevel = UnitLevel("player")
    local isFutureItem = false
    local finalMinLevel = 0

    if dbMinLevel and dbMinLevel > myLevel then
        isFutureItem = true; finalMinLevel = dbMinLevel
    end

    if not isFutureItem then
        local lineCount = tooltip:NumLines()
        for i = 2, math.min(lineCount, 10) do
            local lineObj = _G[tooltip:GetName() .. "TextLeft" .. i]
            if lineObj then
                local text = lineObj:GetText()
                if text and text:find(ITEM_MIN_LEVEL:gsub("%%d", "")) then
                    local levelFound = text:match("(%d+)")
                    if levelFound and tonumber(levelFound) > myLevel then
                        isFutureItem = true; finalMinLevel = tonumber(levelFound); break
                    end
                end
            end
        end
    end

    local itemEquipLoc = select(9, GetItemInfo(link))
    local slotId = MSC.SlotMap[itemEquipLoc] 
    if not slotId then return end
    
    local currentWeights, specName = MSC.GetCurrentWeights()
    local equippedMH = GetInventoryItemLink("player", 16)
    local equippedOH = GetInventoryItemLink("player", 17)
    local equippedMHLoc = equippedMH and select(9, GetItemInfo(equippedMH))
    
    local oldScore, newScore = 0, 0
    local oldStats, newStats = {}, {}
    local noteText, partnerItemLink = nil, nil
    local isBestInBag, isEquipped = false, false

    -- [COMPARISON LOGIC]
    if itemEquipLoc == "INVTYPE_2HWEAPON" then
        newStats = MSC.SafeGetItemStats(link, 16)
        newScore = MSC.GetItemScore(newStats, currentWeights, specName, 16)
        local mhLink, ohLink = equippedMH, equippedOH
        local filledFromBag = false
        if equippedMHLoc ~= "INVTYPE_2HWEAPON" then
            if not mhLink then mhLink = MSC.FindBestMainHand(currentWeights, specName); filledFromBag = true end
            if not ohLink then ohLink = MSC.FindBestOffhand(currentWeights, specName); filledFromBag = true end
        end
        local mhStats = MSC.SafeGetItemStats(mhLink, 16); local ohStats = MSC.SafeGetItemStats(ohLink, 17)
        oldStats = MergeStats(mhStats, ohStats)
        oldScore = MSC.GetItemScore(mhStats, currentWeights, specName, 16) + MSC.GetItemScore(ohStats, currentWeights, specName, 17)
        if filledFromBag or (equippedMHLoc ~= "INVTYPE_2HWEAPON" and equippedOH) then noteText = "Comparing vs: " .. (mhLink or "Empty") .. " + " .. (ohLink or "Empty") end
        if link == equippedMH then isEquipped = true end

    elseif (itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestOHLink, bestOHScore, bestOHStats = MSC.FindBestOffhand(currentWeights, specName)
        local mhStats = MSC.SafeGetItemStats(link, 16)
        local mhScore = MSC.GetItemScore(mhStats, currentWeights, specName, 16)
        if bestOHLink then newStats = MergeStats(mhStats, bestOHStats); newScore = mhScore + bestOHScore; partnerItemLink = bestOHLink
        else newStats = mhStats; newScore = mhScore; noteText = "|cffff0000(No Offhand found)|r" end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, 16)

    elseif (itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestMHLink, bestMHScore, bestMHStats = MSC.FindBestMainHand(currentWeights, specName)
        local ohStats = MSC.SafeGetItemStats(link, 17); local ohScore = MSC.GetItemScore(ohStats, currentWeights, specName, 17)
        if bestMHLink then newStats = MergeStats(bestMHStats, ohStats); newScore = bestMHScore + ohScore; partnerItemLink = bestMHLink
        else newStats = ohStats; newScore = ohScore; noteText = "|cffff0000(No Mainhand found)|r" end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, 16)

    elseif itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" then
        local s1, s2 = 11, 12; if itemEquipLoc == "INVTYPE_TRINKET" then s1, s2 = 13, 14 end
        local l1, l2 = GetInventoryItemLink("player", s1), GetInventoryItemLink("player", s2)
        
        -- Get scores for current rings/trinkets (default to 0 if missing)
        local st1 = l1 and MSC.SafeGetItemStats(l1, s1) or {}
        local st2 = l2 and MSC.SafeGetItemStats(l2, s2) or {}
        local sc1 = MSC.GetItemScore(st1, currentWeights, specName, s1)
        local sc2 = MSC.GetItemScore(st2, currentWeights, specName, s2)
        
        local targetSlot, targetLink, otherLink = s1, l1, l2
        
        -- Logic: If a slot is empty, target it. Otherwise, target the weakest item.
        if (not l1) then targetSlot = s1; targetLink = nil; otherLink = l2
        elseif (not l2) then targetSlot = s2; targetLink = nil; otherLink = l1
        elseif sc2 < sc1 then targetSlot = s2; targetLink = l2; otherLink = l1 end
        
        if link == l1 then isEquipped = true; targetSlot = s1; targetLink = l1; otherLink = l2
        elseif link == l2 then isEquipped = true; targetSlot = s2; targetLink = l2; otherLink = l1 end
        
        partnerItemLink = otherLink 
        
        -- [FIX] If slot is empty, set Old Stats to empty table, don't return early
        if not targetLink and not isEquipped then
            oldStats = {}
            oldScore = 0
            noteText = "|cff00ff00++ FILLING EMPTY SLOT ++|r"
        else
            oldStats = MSC.SafeGetItemStats(targetLink, targetSlot)
            oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, targetSlot)
        end

        newStats = MSC.SafeGetItemStats(link, targetSlot)
        newScore = MSC.GetItemScore(newStats, currentWeights, specName, targetSlot)
        
        if not isEquipped and targetLink then noteText = "Comparing vs: " .. targetLink .. " (Weakest)" end

    else
        -- GENERIC SLOTS (Neck, Chest, Legs, etc.)
        local compLink = GetInventoryItemLink("player", slotId)
        if link == compLink then isEquipped = true end
        
        if not compLink then
            -- Check if we can compare against a 2H/Offhand mismatch logic if needed
            if slotId == 17 then local bag = MSC.FindBestOffhand(currentWeights, specName); if bag then compLink = bag; noteText = "Comparing vs: " .. compLink; if link == bag then isBestInBag = true end end
            elseif slotId == 16 then local bag = MSC.FindBestMainHand(currentWeights, specName); if bag then compLink = bag; noteText = "Comparing vs: " .. compLink; if link == bag then isBestInBag = true end end end
        end
        
        if slotId == 16 then partnerItemLink = GetInventoryItemLink("player", 17) elseif slotId == 17 then partnerItemLink = GetInventoryItemLink("player", 16) end
        
        -- [FIX] If still no comparison link, treat as empty slot filling
        if not compLink then 
            oldStats = {}
            oldScore = 0
            noteText = "|cff00ff00++ FILLING EMPTY SLOT ++|r"
        else
            oldStats = MSC.SafeGetItemStats(compLink, slotId)
            oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, slotId)
        end
        
        newStats = MSC.SafeGetItemStats(link, slotId)
        newScore = MSC.GetItemScore(newStats, currentWeights, specName, slotId)
    end

    -- [RENDER UI]
    local scoreDiff = newScore - oldScore
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine("|cff00ccffSharpie's Verdict:|r", "|cffffffff" .. specName .. "|r")
    
    if noteText and not isBestInBag then tooltip:AddLine(noteText, 0.7, 0.7, 0.7) end
    if newStats.IS_PROJECTED then 
        local enchantText = MSC.GetEnchantString(slotId)
        if enchantText and enchantText ~= "" then 
            tooltip:AddLine("(Projecting: " .. enchantText .. ")", 0, 1, 1) 
        end 
    end

    if isEquipped then
        -- SUBTLE INDICATOR FOR EQUIPPED ITEMS
        if partnerItemLink then 
            tooltip:AddLine("|cff777777(Baseline | w/ " .. partnerItemLink .. ")|r")
        else 
            tooltip:AddLine("|cff777777(Baseline)|r") 
        end
    else
        -- COMPARISON LOGIC FOR BAG/VENDOR ITEMS
        if partnerItemLink then tooltip:AddLine("|cff00ff00*** BEST PAIR WITH: " .. partnerItemLink .. " ***|r") end
        local bestText = isBestInBag and " (Best in Bag)" or ""
        
        if scoreDiff > 0 then
            if isFutureItem then
                 tooltip:AddLine("|cffFF55FF*** FUTURE UPGRADE (+" .. string.format("%.1f", scoreDiff) .. ")" .. bestText .. " ***|r")
                 tooltip:AddLine("|cffFF55FF(Requires Level " .. finalMinLevel .. ")|r")
            else
                 tooltip:AddLine("|cff00ff00*** UPGRADE (+" .. string.format("%.1f", scoreDiff) .. ")" .. bestText .. " ***|r")
            end
        elseif scoreDiff < 0 then 
            tooltip:AddLine("|cffff0000*** DOWNGRADE (" .. string.format("%.1f", scoreDiff) .. ") ***|r")
        else 
            tooltip:AddLine("|cffffffff*** EQUAL STATS ***|r") 
        end
    end

    -- [STAT BREAKDOWN - COMBINED LINE MODE]
    local oldExpanded = MSC.ExpandDerivedStats(oldStats, (isEquipped and link or nil)) 
    local newExpanded = MSC.ExpandDerivedStats(newStats, link)
    local diffs = MSC.GetStatDifferences(newExpanded, oldExpanded)
    local sortedDiffs = MSC.SortStatDiffs(diffs)
    
    -- Quick lookup map for diff values so we don't have to loop constantly
    local diffMap = {}
    for _, d in ipairs(diffs) do diffMap[d.key] = d.val end

    local handledStats = {}

    -- Helper function to format values and get color based on diff
    local function GetFormattedStatValue(statKey)
        local newVal = newExpanded[statKey] or 0
        local diffVal = diffMap[statKey] or 0
        
        -- If both are zero, the stat doesn't exist on this item
        if newVal == 0 and diffVal == 0 then return nil, 1, 1, 1 end 

        local newStr = (newVal % 1 == 0) and string.format("%d", newVal) or string.format("%.1f", newVal)
        local diffStr = (diffVal % 1 == 0) and string.format("%d", diffVal) or string.format("%.1f", diffVal)
        if diffVal > 0 then diffStr = "+" .. diffStr end

        local finalStr = ""
        local r, g, b = 1, 1, 1 -- Default white

        if diffVal > 0 then 
            -- Upgrade: White Val | Green Diff
            finalStr = "|cffffffff" .. newStr .. "|r |cff00ff00(" .. diffStr .. ")|r"
            r, g, b = 0, 1, 0 -- Green label for upgrade
        elseif diffVal < 0 then 
            -- Downgrade: White Val | Red Diff
            finalStr = "|cffffffff" .. newStr .. "|r |cffff0000(" .. diffStr .. ")|r"
            r, g, b = 1, 0.2, 0.2 -- Reddish label for downgrade
        else 
            -- Neutral
            if isEquipped then
                -- Active: Bright Green Val
                 finalStr = "|cff00ff00" .. newStr .. "|r"
                 r, g, b = 1, 0.82, 0 -- Gold label for active
            else
                -- Comparison: White Val | Gray (+0)
                 finalStr = "|cffffffff" .. newStr .. "|r |cff777777(+0)|r"
            end
        end
        return finalStr, r, g, b
    end

    -- Define pairings to combine onto one line
    local statPairs = {
        { prim = "ITEM_MOD_STAMINA_SHORT", der = "ITEM_MOD_HEALTH_SHORT", primLabel = "Stamina", derLabel = "Health (from Stam)" },
        { prim = "ITEM_MOD_INTELLECT_SHORT", der = "ITEM_MOD_MANA_SHORT", primLabel = "Intellect", derLabel = "Mana (from Int)" },
        { prim = "ITEM_MOD_SPIRIT_SHORT", der = "ITEM_MOD_MANA_REGENERATION_SHORT", primLabel = "Spirit", derLabel = "Mana Regen (from Spt)" },
        { prim = "ITEM_MOD_STRENGTH_SHORT", der = "ITEM_MOD_ATTACK_POWER_SHORT", primLabel = "Strength", derLabel = "Atk Power (from Str)" },
        { prim = "ITEM_MOD_STRENGTH_SHORT", der = "ITEM_MOD_BLOCK_VALUE_SHORT", primLabel = "Strength", derLabel = "Block Val (from Str)" },
        { prim = "ITEM_MOD_AGILITY_SHORT", der = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT", primLabel = "Agility", derLabel = "Ranged AP (from Agi)" },
        { prim = "ITEM_MOD_AGILITY_SHORT", der = "ITEM_MOD_DODGE_RATING_SHORT", primLabel = "Agility", derLabel = "Dodge (from Agi)" },
        { prim = "ITEM_MOD_AGILITY_SHORT", der = "ITEM_MOD_CRIT_FROM_STATS_SHORT", primLabel = "Agility", derLabel = "Crit (from Agi)" },
        { prim = "ITEM_MOD_AGILITY_SHORT", der = "ITEM_MOD_ARMOR_SHORT", primLabel = "Agility", derLabel = "Armor (from Agi)" },
    }

    -- PASS 1: Render Combined Pairs
    for _, pair in ipairs(statPairs) do
        -- Only proceed if the derived stat is relevant for the current weights/class
        -- OR if we whitelist it (like Health/Mana which everyone has)
        local isDerRelevant = (currentWeights and currentWeights[pair.der] and currentWeights[pair.der] > 0)
        if pair.der == "ITEM_MOD_HEALTH_SHORT" or pair.der == "ITEM_MOD_MANA_SHORT" then isDerRelevant = true end

        -- Check if we haven't printed these yet
        if isDerRelevant and not handledStats[pair.prim] and not handledStats[pair.der] then
            local primStr, pr, pg, pb = GetFormattedStatValue(pair.prim)
            local derStr, dr, dg, db = GetFormattedStatValue(pair.der)

            -- Only print if both stats actually exist on this item/comparison
            if primStr and derStr then
                -- Combine format: "Stamina" -> "20 (+20)   Health (from Stam)   200 (+200)"
                local combinedRight = primStr .. "   |cffcccccc" .. pair.derLabel .. "|r " .. derStr
                tooltip:AddDoubleLine(pair.primLabel, combinedRight, pr, pg, pb)
                
                -- Mark as handled so they don't appear in Pass 2
                handledStats[pair.prim] = true
                handledStats[pair.der] = true
            end
        end
    end

    -- PASS 2: Render Remaining Unhandled Stats
    for _, entry in ipairs(sortedDiffs) do
        if not handledStats[entry.key] and entry.key ~= "IS_PROJECTED" then
            local isRelevant = (currentWeights and currentWeights[entry.key] and currentWeights[entry.key] > 0)
            
            -- [[ THE FIX: STRICT WHITELIST ]]
            -- Only Health and Mana are allowed to show without weight.
            -- Stats like Healing, Spell Power, and AP must now have > 0 Weight to appear.
            if entry.key == "ITEM_MOD_HEALTH_SHORT" or entry.key == "ITEM_MOD_MANA_SHORT" then isRelevant = true end
            
            if isRelevant then
                local valStr, r, g, b = GetFormattedStatValue(entry.key)
                if valStr then
                    local cleanName = MSC.GetCleanStatName(entry.key)
                    
                    -- Racial Check
                    if entry.key == "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" then
                        local rawVal = newStats["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] or 0
                        if rawVal == 0 then cleanName = "Wpn Skill (Racial)" end
                    end

                    tooltip:AddDoubleLine(cleanName, valStr, r, g, b)
                    handledStats[entry.key] = true
                end
            end
        end
    end
    tooltip:Show()
end

-- =============================================================
-- 4. APPLY HOOKS
-- =============================================================
GameTooltip:HookScript("OnTooltipSetItem", MSC.UpdateTooltip)
if ItemRefTooltip then ItemRefTooltip:HookScript("OnTooltipSetItem", MSC.UpdateTooltip) end
if ShoppingTooltip1 then ShoppingTooltip1:HookScript("OnTooltipSetItem", MSC.UpdateTooltip) end
if ShoppingTooltip2 then ShoppingTooltip2:HookScript("OnTooltipSetItem", MSC.UpdateTooltip) end

-- =============================================================
-- DEBUGGER TOOL
-- Usage: /sgjdebug [Shift-Click Item]
-- =============================================================
SLASH_SGJDEBUG1 = "/sgjdebug"
SlashCmdList["SGJDEBUG"] = function(msg)
    local itemLink = msg:match("(|c.+|r)")
    if not itemLink then 
        print("|cffff0000SGJ Debug:|r Please link an item. Example: /sgjdebug [Item Link]")
        return 
    end

    print(" ")
    print("|cff00ff00=== DEBUGGING: " .. itemLink .. " ===|r")

    local tip = CreateFrame("GameTooltip", "MSC_DebugTooltip", nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    tip:SetHyperlink(itemLink)

    for i = 1, tip:NumLines() do
        local line = _G["MSC_DebugTooltipTextLeft" .. i]
        if line then
            local text = line:GetText()
            if text then
                local statKey, statVal = MSC.ParseTooltipLine(text)
                if statKey then
                    print("|cff00ffff[Line " .. i .. "]|r '" .. text .. "'")
                    print("   -> |cff00ff00MATCH:|r " .. (MSC.ShortNames[statKey] or statKey) .. " = " .. statVal)
                else
                    print("|cffaaaaaa[Line " .. i .. "]|r '" .. text .. "'")
                    print("   -> |cffff0000No Match|r")
                end
            end
        end
    end
    print("|cff00ff00================================|r")
end