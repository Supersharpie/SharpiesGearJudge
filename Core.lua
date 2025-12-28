local _, MSC = ... 

-- =============================================================
-- 1. INITIALIZATION
-- =============================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_TALENT_UPDATE") 
eventFrame:RegisterEvent("PLAYER_LEVEL_UP") 

eventFrame:SetScript("OnEvent", function(self, event, arg1)
    
    -- LOAD LOGIC
    if event == "ADDON_LOADED" and arg1 == "SharpiesGearJudge" then
        if not SGJ_Settings then SGJ_Settings = { Mode = "Auto", MinimapPos = 45, IncludeEnchants = false, ProjectEnchants = true } end
        if not SGJ_History then SGJ_History = {} end 
        if MSC.UpdateMinimapPosition then MSC.UpdateMinimapPosition() end
        print("|cff00ccffSharpie's Gear Judge|r loaded!")
    end

    -- SPEC SWAP LOGIC
    if event == "PLAYER_TALENT_UPDATE" then
        local _, newSpecName = MSC.GetCurrentWeights()
        if MSC.LastActiveSpec and MSC.LastActiveSpec ~= newSpecName then
             print("|cff00ccffSharpie's Gear Judge:|r Spec change detected. Active Profile: |cff00ff00" .. newSpecName .. "|r")
        end
        MSC.LastActiveSpec = newSpecName
        if MSCLabFrame and MSCLabFrame:IsShown() then MSC.UpdateLabCalc() end
    end

    -- [[ LEVEL UP SNAPSHOT ]] --
    if event == "PLAYER_LEVEL_UP" then
        local newLevel = arg1
        C_Timer.After(2, function() -- Wait 2s for stats to update
            MSC.RecordSnapshot("Level " .. newLevel)
        end)
    end
end)

-- =============================================================
-- 2. SLASH COMMANDS
-- =============================================================
SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg)
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    cmd = cmd:lower()
    
    if cmd == "options" or cmd == "config" then 
        MSC.CreateOptionsFrame() 
    elseif cmd == "history" then 
        MSC.ShowHistory()
    elseif cmd == "save" or cmd == "snapshot" then
        local label = (arg and arg ~= "") and arg or "Manual Save"
        MSC.RecordSnapshot(label)
        MSC.ShowHistory()
    else 
        MSC.CreateLabFrame() 
    end 
end

-- =============================================================
-- 3. TOOLTIP LOGIC 
-- =============================================================
function MSC.MergeStats(t1, t2)
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
    
    if not MSC.IsItemUsable(link) then 
        tooltip:AddLine(" "); tooltip:AddLine("|cffff0000Sharpie's Verdict: CLASS UNUSABLE|r"); tooltip:Show(); return 
    end

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
        oldStats = MSC.MergeStats(mhStats, ohStats)
        oldScore = MSC.GetItemScore(mhStats, currentWeights, specName, 16) + MSC.GetItemScore(ohStats, currentWeights, specName, 17)
        if filledFromBag or (equippedMHLoc ~= "INVTYPE_2HWEAPON" and equippedOH) then noteText = "Comparing vs: " .. (mhLink or "Empty") .. " + " .. (ohLink or "Empty") end
        if link == equippedMH then isEquipped = true end

    elseif (itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestOHLink, bestOHScore, bestOHStats = MSC.FindBestOffhand(currentWeights, specName)
        local mhStats = MSC.SafeGetItemStats(link, 16)
        local mhScore = MSC.GetItemScore(mhStats, currentWeights, specName, 16)
        if bestOHLink then newStats = MSC.MergeStats(mhStats, bestOHStats); newScore = mhScore + bestOHScore; partnerItemLink = bestOHLink
        else newStats = mhStats; newScore = mhScore; noteText = "|cffff0000(No Offhand found)|r" end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, 16)

    elseif (itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestMHLink, bestMHScore, bestMHStats = MSC.FindBestMainHand(currentWeights, specName)
        local ohStats = MSC.SafeGetItemStats(link, 17); local ohScore = MSC.GetItemScore(ohStats, currentWeights, specName, 17)
        if bestMHLink then newStats = MSC.MergeStats(bestMHStats, ohStats); newScore = bestMHScore + ohScore; partnerItemLink = bestMHLink
        else newStats = ohStats; newScore = ohScore; noteText = "|cffff0000(No Mainhand found)|r" end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, 16)

    elseif itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" then
        local s1, s2 = 11, 12; if itemEquipLoc == "INVTYPE_TRINKET" then s1, s2 = 13, 14 end
        local l1, l2 = GetInventoryItemLink("player", s1), GetInventoryItemLink("player", s2)
        local st1 = l1 and MSC.SafeGetItemStats(l1, s1) or {}
        local st2 = l2 and MSC.SafeGetItemStats(l2, s2) or {}
        local sc1 = MSC.GetItemScore(st1, currentWeights, specName, s1)
        local sc2 = MSC.GetItemScore(st2, currentWeights, specName, s2)
        local targetSlot, targetLink, otherLink = s1, l1, l2
        if (not l1) then targetSlot = s1; targetLink = nil; otherLink = l2
        elseif (not l2) then targetSlot = s2; targetLink = nil; otherLink = l1
        elseif sc2 < sc1 then targetSlot = s2; targetLink = l2; otherLink = l1 end
        if link == l1 then isEquipped = true; targetSlot = s1; targetLink = l1; otherLink = l2
        elseif link == l2 then isEquipped = true; targetSlot = s2; targetLink = l2; otherLink = l1 end
        partnerItemLink = otherLink 
        if not targetLink and not isEquipped then oldStats = {}; oldScore = 0; noteText = "|cff00ff00++ FILLING EMPTY SLOT ++|r"
        else oldStats = MSC.SafeGetItemStats(targetLink, targetSlot); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, targetSlot) end
        newStats = MSC.SafeGetItemStats(link, targetSlot); newScore = MSC.GetItemScore(newStats, currentWeights, specName, targetSlot)
        if not isEquipped and targetLink then noteText = "Comparing vs: " .. targetLink .. " (Weakest)" end

    else
        local compLink = GetInventoryItemLink("player", slotId)
        if link == compLink then isEquipped = true end
        if not compLink then
            if slotId == 17 then local bag = MSC.FindBestOffhand(currentWeights, specName); if bag then compLink = bag; noteText = "Comparing vs: " .. compLink; if link == bag then isBestInBag = true end end
            elseif slotId == 16 then local bag = MSC.FindBestMainHand(currentWeights, specName); if bag then compLink = bag; noteText = "Comparing vs: " .. compLink; if link == bag then isBestInBag = true end end end
        end
        if slotId == 16 then partnerItemLink = GetInventoryItemLink("player", 17) elseif slotId == 17 then partnerItemLink = GetInventoryItemLink("player", 16) end
        if not compLink then oldStats = {}; oldScore = 0; noteText = "|cff00ff00++ FILLING EMPTY SLOT ++|r"
        else oldStats = MSC.SafeGetItemStats(compLink, slotId); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, slotId) end
        newStats = MSC.SafeGetItemStats(link, slotId); newScore = MSC.GetItemScore(newStats, currentWeights, specName, slotId)
    end

    local scoreDiff = newScore - oldScore
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine("|cff00ccffSharpie's Verdict:|r", "|cffffffff" .. specName .. "|r")
    
    if newStats.estimate and MSC.ItemOverrides then
        local itemID = tonumber(string.match(link, "item:(%d+)"))
        local bonusData = MSC.ItemOverrides[itemID]
        
        if bonusData then
            local bonusScore = MSC.GetItemScore(bonusData, currentWeights, specName, slotId)
            local baseScore = newScore - bonusScore
            
            if baseScore < 1 then
                 tooltip:AddDoubleLine("|cff00ccffSharpie's Score:|r", "~" .. string.format("%.1f", newScore), 1, 1, 1, 0, 1, 0)
            else
                 tooltip:AddDoubleLine("|cff00ccffSharpie's Score:|r", string.format("%.1f", baseScore) .. " |cff00ff00(+~" .. string.format("%.1f", bonusScore) .. ")|r")
            end
        else
             tooltip:AddDoubleLine("|cff00ccffSharpie's Score:|r", "~" .. string.format("%.1f", newScore), 1, 1, 1, 0, 1, 0)
        end
    else
        tooltip:AddDoubleLine("|cff00ccffSharpie's Score:|r", string.format("%.1f", newScore), 1, 1, 1, 1, 1, 1)
    end

    if noteText and not isBestInBag then tooltip:AddLine(noteText, 0.7, 0.7, 0.7) end
    if newStats.IS_PROJECTED then 
        local enchantText = MSC.GetEnchantString(slotId)
        if enchantText and enchantText ~= "" then tooltip:AddLine("(Projecting: " .. enchantText .. ")", 0, 1, 1) end 
    end

    if isEquipped then
        if partnerItemLink then tooltip:AddLine("|cff777777(Baseline | w/ " .. partnerItemLink .. ")|r")
        else tooltip:AddLine("|cff777777(Baseline)|r") end
    else
        if partnerItemLink then tooltip:AddLine("|cff00ff00*** BEST PAIR WITH: " .. partnerItemLink .. " ***|r") end
        local bestText = isBestInBag and " (Best in Bag)" or ""
        local capNote = ""
        if specName and specName:find("Capped") then capNote = " (Cap Adjusted)" end
        
        local tilde = newStats.estimate and "~" or ""
        
        if scoreDiff > 0 then
            if isFutureItem then tooltip:AddLine("|cffFF55FF*** FUTURE UPGRADE (+" .. tilde .. string.format("%.1f", scoreDiff) .. ")" .. bestText .. capNote .. " ***|r"); tooltip:AddLine("|cffFF55FF(Requires Level " .. finalMinLevel .. ")|r")
            else tooltip:AddLine("|cff00ff00*** UPGRADE (+" .. tilde .. string.format("%.1f", scoreDiff) .. ")" .. bestText .. capNote .. " ***|r") end
        elseif scoreDiff < 0 then 
            tooltip:AddLine("|cffff0000*** DOWNGRADE (" .. tilde .. string.format("%.1f", scoreDiff) .. ")" .. capNote .. " ***|r")
        else 
            tooltip:AddLine("|cffffffff*** EQUAL STATS ***|r") 
        end
    end

    local oldExpanded = MSC.ExpandDerivedStats(oldStats, (isEquipped and link or nil)) 
    local newExpanded = MSC.ExpandDerivedStats(newStats, link)
    local diffs = MSC.GetStatDifferences(newExpanded, oldExpanded)
    local sortedDiffs = MSC.SortStatDiffs(diffs)
    local diffMap = {}
    for _, d in ipairs(diffs) do diffMap[d.key] = d.val end
    local handledStats = {}

    local function GetFormattedStatValue(statKey)
        local newVal = newExpanded[statKey] or 0
        local diffVal = diffMap[statKey] or 0
        if newVal == 0 and diffVal == 0 then return nil, 1, 1, 1 end 
        local newStr = (newVal % 1 == 0) and string.format("%d", newVal) or string.format("%.1f", newVal)
        local diffStr = (diffVal % 1 == 0) and string.format("%d", diffVal) or string.format("%.1f", diffVal)
        if diffVal > 0 then diffStr = "+" .. diffStr end
        local finalStr = ""
        local r, g, b = 1, 1, 1 
        if diffVal > 0 then finalStr = "|cffffffff" .. newStr .. "|r |cff00ff00(" .. diffStr .. ")|r"; r, g, b = 0, 1, 0 
        elseif diffVal < 0 then finalStr = "|cffffffff" .. newStr .. "|r |cffff0000(" .. diffStr .. ")|r"; r, g, b = 1, 0.2, 0.2 
        else if isEquipped then finalStr = "|cff00ff00" .. newStr .. "|r"; r, g, b = 1, 0.82, 0 else finalStr = "|cffffffff" .. newStr .. "|r |cff777777(+0)|r" end end
        return finalStr, r, g, b
    end

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
    for _, pair in ipairs(statPairs) do
        local isDerRelevant = (currentWeights and currentWeights[pair.der] and currentWeights[pair.der] > 0)
        if pair.der == "ITEM_MOD_HEALTH_SHORT" or pair.der == "ITEM_MOD_MANA_SHORT" then isDerRelevant = true end
        if isDerRelevant and not handledStats[pair.prim] and not handledStats[pair.der] then
            local primStr, pr, pg, pb = GetFormattedStatValue(pair.prim)
            local derStr, dr, dg, db = GetFormattedStatValue(pair.der)
            if primStr and derStr then
                local combinedRight = primStr .. "   |cffcccccc" .. pair.derLabel .. "|r " .. derStr
                tooltip:AddDoubleLine(pair.primLabel, combinedRight, pr, pg, pb)
                handledStats[pair.prim] = true; handledStats[pair.der] = true
            end
        end
    end
    for _, entry in ipairs(sortedDiffs) do
        if not handledStats[entry.key] and entry.key ~= "IS_PROJECTED" then
            local isRelevant = (currentWeights and currentWeights[entry.key] and currentWeights[entry.key] > 0)
            if entry.key == "ITEM_MOD_HEALTH_SHORT" or entry.key == "ITEM_MOD_MANA_SHORT" then isRelevant = true end
            if isRelevant then
                local valStr, r, g, b = GetFormattedStatValue(entry.key)
                if valStr then
                    local cleanName = MSC.GetCleanStatName(entry.key)
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
-- 5. EXPORT & HISTORY UTILITIES
-- =============================================================
function MSC.ExportData(dataRows, score, unitName)
    if not MSC.ExportFrame then
        local f = CreateFrame("Frame", "MSC_ExportFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(400, 300); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG"); f:EnableMouse(true); 
        f:SetMovable(true); f:RegisterForDrag("LeftButton") 
        f:SetScript("OnDragStart", f.StartMoving)
        f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.TitleText:SetText("Export Data")
        
        local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -30); scroll:SetPoint("BOTTOMRIGHT", -30, 10)
        local editBox = CreateFrame("EditBox", nil, scroll)
        editBox:SetMultiLine(true); editBox:SetFontObject("ChatFontNormal"); editBox:SetWidth(360)
        scroll:SetScrollChild(editBox); f.EditBox = editBox
        MSC.ExportFrame = f
    end
    local dateStr = date("%Y-%m-%d")
    local export = "**Sharpie's Gear Receipt** (" .. dateStr .. ")\nJudge: " .. unitName .. "\nScore: **" .. score .. "**\n----------------------------------\n"
    for _, row in ipairs(dataRows) do export = export .. "*" .. row.slot .. "*: " .. row.link .. " (" .. row.score .. ")\n" end
    MSC.ExportFrame.EditBox:SetText(export); MSC.ExportFrame.EditBox:HighlightText(); MSC.ExportFrame:Show()
end

function MSC.RecordSnapshot(eventLabel)
    if not SGJ_History then SGJ_History = {} end
    local key = UnitName("player") .. " - " .. GetRealmName()
    if not SGJ_History[key] then SGJ_History[key] = {} end
    local slots = {{id=1},{id=2},{id=3},{id=15},{id=5},{id=9},{id=10},{id=6},{id=7},{id=8},{id=11},{id=12},{id=13},{id=14},{id=16},{id=17},{id=18}}
    local currentWeights, specName = MSC.GetCurrentWeights()
    local totalScore = 0
    for i, slot in ipairs(slots) do
        local link = GetInventoryItemLink("player", slot.id)
        if link then local stats = MSC.SafeGetItemStats(link, slot.id); if stats then totalScore = totalScore + MSC.GetItemScore(stats, currentWeights, specName, slot.id) end end
    end
    local entry = { date = date("%Y-%m-%d"), label = eventLabel or "Snapshot", score = string.format("%.1f", totalScore), spec = specName }
    table.insert(SGJ_History[key], 1, entry) 
    if #SGJ_History[key] > 20 then table.remove(SGJ_History[key], #SGJ_History[key]) end
    print("|cff00ccffSharpie's Gear Judge:|r Snapshot recorded: |cff00ff00" .. (eventLabel or "Manual") .. "|r")
end

function MSC.ShowHistory()
    local key = UnitName("player") .. " - " .. GetRealmName()
    local charHistory = SGJ_History and SGJ_History[key]
    if not charHistory or #charHistory == 0 then print("|cffff0000SGJ:|r No history recorded for " .. key); return end
    if not MSC.HistoryFrame then
        local f = CreateFrame("Frame", "MSC_HistoryFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(350, 400); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.TitleBg:SetHeight(30); f.TitleText:SetText("History: " .. UnitName("player")) 
        f.Scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate"); f.Scroll:SetPoint("TOPLEFT", 10, -30); f.Scroll:SetPoint("BOTTOMRIGHT", -30, 10)
        f.Content = CreateFrame("Frame", nil, f.Scroll); f.Content:SetSize(310, 380); f.Scroll:SetScrollChild(f.Content)
        f.Rows = {}; MSC.HistoryFrame = f
    else MSC.HistoryFrame.TitleText:SetText("History: " .. UnitName("player")) end
    for _, row in pairs(MSC.HistoryFrame.Rows) do row:SetText("") end
    local yOffset = 0
    for i, entry in ipairs(charHistory) do
        if not MSC.HistoryFrame.Rows[i] then
            local row = MSC.HistoryFrame.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); row:SetPoint("TOPLEFT", 10, yOffset); row:SetWidth(300); row:SetJustifyH("LEFT"); MSC.HistoryFrame.Rows[i] = row
        end
        local color = "|cffffffff"; if entry.label:find("Level") then color = "|cff00ff00" end 
        local text = color .. entry.date .. "|r - " .. entry.label .. ": |cff00ccff" .. entry.score .. "|r"
        MSC.HistoryFrame.Rows[i]:SetText(text); yOffset = yOffset - 20
    end
    MSC.HistoryFrame:Show()
end

-- [[ CONFLICT FIXED: MSC.ShowReceipt HAS BEEN REMOVED FROM THIS FILE ]]
-- Use UI_Lab.lua for the Receipt window logic.