local _, MSC = ...

local LabFrame = nil
local LabMH, LabOH, Lab2H = nil, nil, nil

-- =============================================================
-- THE CALCULATOR ENGINE
-- =============================================================
function MSC.UpdateLabCalc()
    if not LabFrame or not LabFrame:IsShown() then return end
    
    local weights, profileName = MSC.GetCurrentWeights()
    LabFrame.ProfileText:SetText("Profile: " .. profileName)
    
    if not LabMH.link and not LabOH.link and not Lab2H.link then
        LabFrame.ScoreCurrent:SetText(""); LabFrame.ScoreNew:SetText(""); LabFrame.Result:SetText("Shift+Click items to add"); LabFrame.Details:SetText(""); return
    end

    local scoreMHOH, statsMHOH = 0, {}
    
    -- MH Calculation
    if LabMH.link then 
        local s = MSC.SafeGetItemStats(LabMH.link, 16)
        scoreMHOH = scoreMHOH + MSC.GetItemScore(s, weights, profileName, 16) 
        for k, v in pairs(s) do 
            if type(v) == "number" then 
                statsMHOH[k] = (statsMHOH[k] or 0) + v 
            end
        end 
    end
    
    -- OH Calculation
    if LabOH.link then 
        local s = MSC.SafeGetItemStats(LabOH.link, 17)
        scoreMHOH = scoreMHOH + MSC.GetItemScore(s, weights, profileName, 17) 
        for k, v in pairs(s) do 
            if type(v) == "number" then 
                statsMHOH[k] = (statsMHOH[k] or 0) + v 
            end
        end 
    end
    
    -- 2H Calculation
    local score2H, stats2H = 0, {}
    if Lab2H.link then 
        local s = MSC.SafeGetItemStats(Lab2H.link, 16)
        score2H = score2H + MSC.GetItemScore(s, weights, profileName, 16) 
        for k, v in pairs(s) do 
            if type(v) == "number" then 
                stats2H[k] = (stats2H[k] or 0) + v 
            end
        end 
    end
    
    local scoreBase, statsBase = 0, {}

    -- SCENARIO 1: Comparing Dual Wield (MH/OH) vs 2-Hander
    if (LabMH.link or LabOH.link) and Lab2H.link then
        scoreBase, statsBase = scoreMHOH, statsMHOH
        LabFrame.ScoreCurrent:SetText(string.format("Dual Wield: %.1f", scoreMHOH))
        LabFrame.ScoreNew:SetText(string.format("2-Hander: %.1f", score2H))
        
        local diff = score2H - scoreBase
        LabFrame.Result:SetText(diff > 0 and string.format("|cff00ff002H WINS (+%.1f)|r", diff) or string.format("|cffff00002H LOSES (%.1f)|r", diff))
        
        local diffs = MSC.GetStatDifferences(stats2H, statsBase)
        local sortedDiffs, lines = MSC.SortStatDiffs(diffs), ""
        for i=1, math.min(10, #sortedDiffs) do
            local e = sortedDiffs[i]
            local name = MSC.GetCleanStatName(e.key)
            local valStr = (e.val % 1 == 0) and string.format("%d", e.val) or string.format("%.1f", e.val)
            local color = (e.val > 0) and "|cff00ff00" or "|cffff0000"
            local sign = (e.val > 0) and "+" or ""
            lines = lines .. "|cffffd100" .. name .. ":|r " .. color .. sign .. valStr .. "|r\n"
        end
        LabFrame.Details:SetText(lines)
        return
    end

    -- SCENARIO 2: Comparing Lab Item vs Currently Equipped
    local currMH = GetInventoryItemLink("player", 16)
    local currOH = GetInventoryItemLink("player", 17)
    
    if currMH then 
        local s = MSC.SafeGetItemStats(currMH, 16)
        scoreBase = scoreBase + MSC.GetItemScore(s, weights, profileName, 16) 
        for k, v in pairs(s) do 
            if type(v) == "number" then statsBase[k] = (statsBase[k] or 0) + v end 
        end 
    end
    if currOH then 
        local s = MSC.SafeGetItemStats(currOH, 17)
        scoreBase = scoreBase + MSC.GetItemScore(s, weights, profileName, 17) 
        for k, v in pairs(s) do 
            if type(v) == "number" then statsBase[k] = (statsBase[k] or 0) + v end 
        end 
    end
    
    local finalScore = (LabMH.link or LabOH.link) and scoreMHOH or score2H
    local finalStats = (LabMH.link or LabOH.link) and statsMHOH or stats2H
    
    LabFrame.ScoreCurrent:SetText(string.format("Current: %.1f", scoreBase))
    LabFrame.ScoreNew:SetText(string.format("Custom: %.1f", finalScore))
    
    local diff = finalScore - scoreBase
    LabFrame.Result:SetText(diff > 0 and string.format("|cff00ff00UPGRADE (+%.1f)|r", diff) or string.format("|cffff0000DOWNGRADE (%.1f)|r", diff))
    
    local diffs = MSC.GetStatDifferences(finalStats, statsBase)
    local sortedDiffs, lines = MSC.SortStatDiffs(diffs), ""
    for i=1, math.min(10, #sortedDiffs) do
        local e = sortedDiffs[i]
        local name = MSC.GetCleanStatName(e.key)
        local valStr = (e.val % 1 == 0) and string.format("%d", e.val) or string.format("%.1f", e.val)
        local color = (e.val > 0) and "|cff00ff00" or "|cffff0000"
        local sign = (e.val > 0) and "+" or ""
        lines = lines .. "|cffffd100" .. name .. ":|r " .. color .. sign .. valStr .. "|r\n"
    end
    LabFrame.Details:SetText(lines)
end

-- =============================================================
-- FRAME CREATION
-- =============================================================
local function CreateItemButton(name, parent, x, y, iconType, labelText)
    local btn = CreateFrame("Button", name, parent, "ItemButtonTemplate")
    btn:SetPoint("CENTER", parent, "CENTER", x, y)
    btn:RegisterForClicks("AnyUp")
    
    if MSC.ApplyElvUISkin then MSC.ApplyElvUISkin(btn) end
    
    btn.empty = btn:CreateTexture(nil, "BACKGROUND")
    btn.empty:SetAllPoints(btn)
    btn.empty:SetTexture(iconType == "OH" and "Interface\\Paperdoll\\UI-PaperDoll-Slot-SecondaryHand" or "Interface\\Paperdoll\\UI-PaperDoll-Slot-MainHand")
    btn.empty:SetAlpha(0.5)
    
    local r, g, b, a = 0.2, 0.8, 1.0, 0.6; local thick = 2
    btn.bT = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bT:SetColorTexture(r, g, b, a); btn.bT:SetPoint("TOPLEFT"); btn.bT:SetPoint("TOPRIGHT"); btn.bT:SetHeight(thick)
    btn.bB = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bB:SetColorTexture(r, g, b, a); btn.bB:SetPoint("BOTTOMLEFT"); btn.bB:SetPoint("BOTTOMRIGHT"); btn.bB:SetHeight(thick)
    btn.bL = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bL:SetColorTexture(r, g, b, a); btn.bL:SetPoint("TOPLEFT"); btn.bL:SetPoint("BOTTOMLEFT"); btn.bL:SetWidth(thick)
    btn.bR = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bR:SetColorTexture(r, g, b, a); btn.bR:SetPoint("TOPRIGHT"); btn.bR:SetPoint("BOTTOMRIGHT"); btn.bR:SetWidth(thick)

    btn.Label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); btn.Label:SetPoint("BOTTOM", btn, "TOP", 0, 3); btn.Label:SetText(labelText); btn.Label:SetTextColor(0.8, 0.8, 0.8, 1)

    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if self.link then GameTooltip:SetHyperlink(self.link) else GameTooltip:SetText(labelText); GameTooltip:AddLine("|cffaaaaaaShift+Click any item to link|r") end
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", GameTooltip_Hide)

    btn:SetScript("OnClick", function(self)
        local type, _, link = GetCursorInfo()
        if type == "item" then
            if not MSC.IsItemUsable(link) then
                if not SGJ_Settings.MuteSounds then PlaySound(847, "Master") end
                print("|cffff0000Sharpie:|r You cannot use this!")
                ClearCursor(); return
            end
            self.link = link; self.icon:SetTexture(select(10, GetItemInfo(link))); self.empty:Hide(); ClearCursor(); MSC.UpdateLabCalc()
        elseif IsShiftKeyDown() then 
            self.link = nil; self.icon:SetTexture(nil); self.empty:Show(); MSC.UpdateLabCalc() 
        end
    end)
    return btn
end

function MSC.CreateLabFrame()
    if MSCLabFrame then 
        if MSCLabFrame:IsShown() then MSCLabFrame:Hide() else MSCLabFrame:Show() end
        return 
    end
    
    local f = CreateFrame("Frame", "MSCLabFrame", UIParent)
    f:SetSize(360, 420); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    
    f.bg = f:CreateTexture(nil, "BACKGROUND"); f.bg:SetAllPoints(f); f.bg:SetColorTexture(0, 0, 0, 0.9) 
    if MSC.ApplyElvUISkin then MSC.ApplyElvUISkin(f) end

    -- Dynamic Class Background
    local _, class = UnitClass("player")
    if class then
        local fixed = class:sub(1,1) .. class:sub(2):lower()
        f.crest = f:CreateTexture(nil, "ARTWORK"); f.crest:SetAllPoints(f)
        f.crest:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. fixed .. ".tga")
        f.crest:SetVertexColor(0.6, 0.6, 0.6, 0.6)
    end
    
    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"); f.title:SetPoint("TOP", f, "TOP", 0, -10); f.title:SetText("Sharpie's Gear Judge")
    
    LabMH = CreateItemButton("MSCLabMH", f, -65, 120, "MH", "Main Hand")
    LabOH = CreateItemButton("MSCLabOH", f, 65, 120, "OH", "Off Hand")
    Lab2H = CreateItemButton("MSCLab2H", f, 0, 50, "2H", "Two-Hand")

    f.Instruction = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); f.Instruction:SetPoint("TOP", Lab2H, "BOTTOM", 0, -5); f.Instruction:SetText("(Shift+Click to clear)"); f.Instruction:SetTextColor(0.5, 0.5, 0.5, 1)
    
    f.ProfileText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); f.ProfileText:SetPoint("TOP", f, "TOP", 0, -30)
    f.ScoreCurrent = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.ScoreCurrent:SetPoint("CENTER", f, "CENTER", 0, -10)
    f.ScoreNew = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.ScoreNew:SetPoint("CENTER", f, "CENTER", 0, -30)
    f.Result = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"); f.Result:SetPoint("CENTER", f, "CENTER", 0, -50)
    f.Details = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); f.Details:SetPoint("TOP", f.Result, "BOTTOM", 0, -10); f.Details:SetJustifyH("CENTER")
    
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
    
    LabFrame = f 
    MSC.UpdateLabCalc()
end

-- =============================================================
-- ATLASLOOT / CHAT LINK SUPPORT (Shift+Click Magic)
-- =============================================================
local function LoadLabItem(btn, link)
    if not btn or not link then return end
    btn.link = link
    btn.icon:SetTexture(select(10, GetItemInfo(link)))
    btn.empty:Hide()
end

hooksecurefunc("ChatEdit_InsertLink", function(text)
    -- FIX 1: Ignore if clicking the buttons themselves (avoids re-adding loop)
    if LabMH and LabMH:IsMouseOver() then return end
    if LabOH and LabOH:IsMouseOver() then return end
    if Lab2H and Lab2H:IsMouseOver() then return end

    if text and LabFrame and LabFrame:IsShown() and string.find(text, "item:", 1, true) then
        local equipLoc = select(9, GetItemInfo(text))
        
        if equipLoc == "INVTYPE_2HWEAPON" then
            LoadLabItem(Lab2H, text)
            
        elseif equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND" then
            LoadLabItem(LabOH, text)

        elseif equipLoc == "INVTYPE_WEAPON" then
             -- SMART LOGIC: If player is Rogue/Warrior/Hunter/Shaman, try to Dual Wield.
             -- If player is Warlock/Mage/Priest/Druid, just replace MH (Correct).
             local _, class = UnitClass("player")
             local canDW = (class == "ROGUE" or class == "WARRIOR" or class == "HUNTER" or class == "SHAMAN")
             
             if canDW and LabMH.link and not LabOH.link then
                  LoadLabItem(LabOH, text)
             else
                  LoadLabItem(LabMH, text)
             end

        elseif equipLoc == "INVTYPE_WEAPONMAINHAND" then
            LoadLabItem(LabMH, text)
            
        else
            return 
        end

        MSC.UpdateLabCalc()
        
        local editBox = ChatEdit_GetActiveWindow()
        if editBox and editBox:GetText() == text then
            editBox:SetText("")
            editBox:Hide()
        end
    end
end)