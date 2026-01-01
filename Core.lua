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
        if MSC.BuildDatabase then
            MSC:BuildDatabase() -- Maps the thousands of items in database
        end
        print("|cff00ccffSharpie's Gear Judge|r (TBC Edition) loaded!")
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
        -- TBC Logic: Cap is now 70
        if newLevel == 70 then
            print("|cff00ccffSharpie's Gear Judge:|r Congratulations on Level 70! Switching to Endgame Spec.")
        end
        C_Timer.After(2, function() 
            MSC.RecordSnapshot("Level " .. newLevel)
            if MSCLabFrame and MSCLabFrame:IsShown() then MSC.UpdateLabCalc() end
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
    -- Copy first table
    if t1 then 
        for k,v in pairs(t1) do out[k] = v end 
    end
    
    -- Merge second table
    if t2 then 
        for k,v in pairs(t2) do 
            if type(v) == "number" then
                -- Only add if it is a number (Stats)
                out[k] = (out[k] or 0) + v 
            else
                -- If it is text (like ENCHANT_TEXT), just overwrite or keep existing
                -- For MH+OH, keeping the MH text is usually fine, or just ignore.
                if not out[k] then out[k] = v end
            end
        end 
    end
    return out
end

-- =============================================================
-- TOOLTIP UPDATE LOGIC (Core.lua)
-- =============================================================
function MSC.UpdateTooltip(tooltip)
    if SGJ_Settings and SGJ_Settings.HideTooltips then return end 
    if not tooltip.GetItem then return end

    local _, link = tooltip:GetItem()
    if not link then return end
    
    -- 1. Check Usability
    if MSC.IsItemUsable and not MSC.IsItemUsable(link) then 
        tooltip:AddLine(" ")
        tooltip:AddLine("|cffff0000Sharpie's Verdict: CLASS UNUSABLE|r")
        tooltip:Show()
        return 
    end

    local itemEquipLoc = select(9, GetItemInfo(link))
    local slotId = MSC.SlotMap[itemEquipLoc] 
    if not slotId then return end
    
    local currentWeights, specName = MSC.GetCurrentWeights()
    
    -- 2. DETERMINE COMPARISON SLOT (Smart Logic)
    -- We need to know WHICH slot to replace (e.g. Weakest Ring) for the Simulation to be accurate.
    local targetSlot = slotId
    
    if itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" then
        local s1, s2 = 11, 12
        if itemEquipLoc == "INVTYPE_TRINKET" then s1, s2 = 13, 14 end
        
        local l1 = GetInventoryItemLink("player", s1)
        local l2 = GetInventoryItemLink("player", s2)
        
        -- If a slot is empty, target that one
        if not l1 then targetSlot = s1
        elseif not l2 then targetSlot = s2
        else
            -- Both full: Compare scores to find the weakest
            local stats1 = MSC.SafeGetItemStats(l1, s1)
            local stats2 = MSC.SafeGetItemStats(l2, s2)
            local score1 = MSC.GetItemScore(stats1, currentWeights, specName, s1)
            local score2 = MSC.GetItemScore(stats2, currentWeights, specName, s2)
            
            if score2 < score1 then targetSlot = s2 else targetSlot = s1 end
        end
        
        -- If we are hovering over one of the equipped items, compare against THAT slot
        if link == l1 then targetSlot = s1
        elseif link == l2 then targetSlot = s2 end
    end

    -- 3. CALCULATE RAW SCORE (Item in a vacuum)
    local newStats = MSC.SafeGetItemStats(link, targetSlot)
    local rawScore = MSC.GetItemScore(newStats, currentWeights, specName, targetSlot)
    
    -- 4. RUN THE SIMULATION (Item + Context)
    -- We pass 'targetSlot' so the engine replaces the correct ring/trinket
    local simDiff = 0
    if MSC.EvaluateUpgrade then
        simDiff = MSC:EvaluateUpgrade(link, targetSlot)
    end

    -- 5. DISPLAY VERDICT
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine("|cff00ccffSharpie's Verdict:|r", "|cffffffff" .. specName .. "|r")
    tooltip:AddDoubleLine("|cff00ccffGearScore:|r", string.format("%.1f", rawScore), 1, 1, 1, 1, 1, 1)

    -- Display Upgrade/Downgrade based on SIMULATION
    if simDiff > 0.1 then
        local upgradeText = "|cff00ff00*** UPGRADE (+" .. string.format("%.1f", simDiff) .. ")"
        -- Add note if we are filling an empty slot
        if not GetInventoryItemLink("player", targetSlot) then upgradeText = upgradeText .. " (Fill Slot)" end
        tooltip:AddLine(upgradeText .. " ***|r")
    elseif simDiff < -0.1 then
        tooltip:AddLine("|cffff0000*** DOWNGRADE (" .. string.format("%.1f", simDiff) .. ") ***|r")
    else
        tooltip:AddLine("|cffaaaaaa(Sidegrade / No Change)|r")
    end

    -- 6. SHOW SET BONUS / PROC IMPACT
    -- Calculate the difference between "Simulated Gain" and "Raw Stat Gain"
    local currentItemLink = GetInventoryItemLink("player", targetSlot)
    local currentRawScore = 0
    if currentItemLink then
        local currentStats = MSC.SafeGetItemStats(currentItemLink, targetSlot)
        currentRawScore = MSC.GetItemScore(currentStats, currentWeights, specName, targetSlot)
    end
    
    local rawDiff = rawScore - currentRawScore
    local hiddenValue = simDiff - rawDiff

    -- Only show if the hidden value (Set Bonus/Proc) is significant (> 1 point)
    if math.abs(hiddenValue) > 1 then
        if hiddenValue > 0 then
            tooltip:AddDoubleLine("Set Bonus / Proc:", "|cff00ff00+" .. string.format("%.1f", hiddenValue) .. "|r")
        else
            tooltip:AddDoubleLine("Set Bonus Break:", "|cffff0000" .. string.format("%.1f", hiddenValue) .. "|r")
        end
    end

    -- 7. PROJECTION DISPLAY
    if newStats.IS_PROJECTED and newStats.ENCHANT_TEXT then
        tooltip:AddLine("(Enchant: |cffffffff" .. newStats.ENCHANT_TEXT .. "|r)", 0, 1, 1)
    end
    if newStats.GEMS_PROJECTED and newStats.GEM_TEXT then
        tooltip:AddLine("(Gems: |cffffffff" .. newStats.GEM_TEXT .. "|r)", 0, 1, 1)
    end
	-- [[ VISUAL CLARITY: 2H vs 1H+OH ]] --
    -- If hovering a 2H weapon while dual-wielding, tell the user we checked both.
    if itemEquipLoc == "INVTYPE_2HWEAPON" and slotId == 16 then
        local offHandLink = GetInventoryItemLink("player", 17)
        if offHandLink then
            tooltip:AddLine("|cffaaaaaa(Comparing vs Main Hand + Off Hand)|r")
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