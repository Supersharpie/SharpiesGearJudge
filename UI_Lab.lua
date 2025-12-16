local _, MSC = ...

local LabFrame = nil
local LabMH, LabOH, Lab2H = nil, nil, nil

function MSC.UpdateLabCalc()
    if not LabFrame or not LabFrame:IsShown() then return end
    local weights, profileName = MSC.GetCurrentWeights()
    LabFrame.ProfileText:SetText("Profile: " .. profileName)
    
    if not LabMH.link and not LabOH.link and not Lab2H.link then
        LabFrame.ScoreCurrent:SetText(""); LabFrame.ScoreNew:SetText(""); LabFrame.Result:SetText("Drag items to start"); LabFrame.Details:SetText(""); return
    end

    local scoreMHOH, statsMHOH = 0, {}
    if LabMH.link then local s = MSC.SafeGetItemStats(LabMH.link, 16); scoreMHOH = scoreMHOH + MSC.GetItemScore(s, weights); for k, v in pairs(s) do statsMHOH[k] = (statsMHOH[k] or 0) + v end end
    if LabOH.link then local s = MSC.SafeGetItemStats(LabOH.link, 17); scoreMHOH = scoreMHOH + MSC.GetItemScore(s, weights); for k, v in pairs(s) do statsMHOH[k] = (statsMHOH[k] or 0) + v end end
    local score2H, stats2H = 0, {}
    if Lab2H.link then local s = MSC.SafeGetItemStats(Lab2H.link, 16); score2H = score2H + MSC.GetItemScore(s, weights); for k, v in pairs(s) do stats2H[k] = (stats2H[k] or 0) + v end end
    local scoreBase, statsBase = 0, {}

    if (LabMH.link or LabOH.link) and Lab2H.link then
        scoreBase, statsBase = scoreMHOH, statsMHOH
        LabFrame.ScoreCurrent:SetText(string.format("Dual Wield: %.1f", scoreMHOH))
        LabFrame.ScoreNew:SetText(string.format("2-Hander: %.1f", score2H))
        local diff = score2H - scoreBase
        LabFrame.Result:SetText(diff > 0 and string.format("|cff00ff002H WINS (+%.1f)|r", diff) or string.format("|cffff00002H LOSES (%.1f)|r", diff))
        local diffs = MSC.GetStatDifferences(stats2H, statsBase)
        local sortedDiffs, lines = MSC.SortStatDiffs(diffs), ""
        for i=1, math.min(8, #sortedDiffs) do
            local e = sortedDiffs[i]; local name = MSC.GetCleanStatName(e.key)
            local valStr = (e.val % 1 == 0) and string.format("%d", e.val) or string.format("%.1f", e.val)
            lines = lines .. (e.val > 0 and "|cff00ff00^ +" or "|cffff0000v ") .. valStr .. " " .. name .. "|r\n"
        end
        LabFrame.Details:SetText(lines)
        return
    end

    local currMH = GetInventoryItemLink("player", 16); local currOH = GetInventoryItemLink("player", 17)
    if currMH then local s = MSC.SafeGetItemStats(currMH, 16); scoreBase = scoreBase + MSC.GetItemScore(s, weights); for k, v in pairs(s) do statsBase[k] = (statsBase[k] or 0) + v end end
    if currOH then local s = MSC.SafeGetItemStats(currOH, 17); scoreBase = scoreBase + MSC.GetItemScore(s, weights); for k, v in pairs(s) do statsBase[k] = (statsBase[k] or 0) + v end end
    
    local finalScore = (LabMH.link or LabOH.link) and scoreMHOH or score2H
    local finalStats = (LabMH.link or LabOH.link) and statsMHOH or stats2H
    
    LabFrame.ScoreCurrent:SetText(string.format("Current: %.1f", scoreBase))
    LabFrame.ScoreNew:SetText(string.format("Custom: %.1f", finalScore))
    
    local diff = finalScore - scoreBase
    LabFrame.Result:SetText(diff > 0 and string.format("|cff00ff00UPGRADE (+%.1f)|r", diff) or string.format("|cffff0000DOWNGRADE (%.1f)|r", diff))
    
    local diffs = MSC.GetStatDifferences(finalStats, statsBase)
    local sortedDiffs, lines = MSC.SortStatDiffs(diffs), ""
    for i=1, math.min(8, #sortedDiffs) do
        local e = sortedDiffs[i]; local name = MSC.GetCleanStatName(e.key)
        local valStr = (e.val % 1 == 0) and string.format("%d", e.val) or string.format("%.1f", e.val)
        lines = lines .. (e.val > 0 and "|cff00ff00^ +" or "|cffff0000v ") .. valStr .. " " .. name .. "|r\n"
    end
    LabFrame.Details:SetText(lines)
end

local function CreateItemButton(name, parent, x, y, iconType, labelText)
    local btn = CreateFrame("Button", name, parent, "ItemButtonTemplate")
    btn:SetPoint("CENTER", parent, "CENTER", x, y); btn:RegisterForClicks("AnyUp"); MSC.ApplyElvUISkin(btn) 
    btn.empty = btn:CreateTexture(nil, "BACKGROUND"); btn.empty:SetAllPoints(btn); btn.empty:SetTexture(iconType == "OH" and "Interface\\Paperdoll\\UI-PaperDoll-Slot-SecondaryHand" or "Interface\\Paperdoll\\UI-PaperDoll-Slot-MainHand"); btn.empty:SetAlpha(0.5)
    local r, g, b, a = 0.2, 0.8, 1.0, 0.6; local thick = 2
    btn.bT = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bT:SetColorTexture(r, g, b, a); btn.bT:SetPoint("TOPLEFT"); btn.bT:SetPoint("TOPRIGHT"); btn.bT:SetHeight(thick)
    btn.bB = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bB:SetColorTexture(r, g, b, a); btn.bB:SetPoint("BOTTOMLEFT"); btn.bB:SetPoint("BOTTOMRIGHT"); btn.bB:SetHeight(thick)
    btn.bL = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bL:SetColorTexture(r, g, b, a); btn.bL:SetPoint("TOPLEFT"); btn.bL:SetPoint("BOTTOMLEFT"); btn.bL:SetWidth(thick)
    btn.bR = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bR:SetColorTexture(r, g, b, a); btn.bR:SetPoint("TOPRIGHT"); btn.bR:SetPoint("BOTTOMRIGHT"); btn.bR:SetWidth(thick)

    btn.Label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); btn.Label:SetPoint("BOTTOM", btn, "TOP", 0, 3); btn.Label:SetText(labelText); btn.Label:SetTextColor(0.8, 0.8, 0.8, 1)

    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if self.link then GameTooltip:SetHyperlink(self.link) else GameTooltip:SetText(labelText); GameTooltip:AddLine("|cffaaaaaaDrag item here|r") end
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
    if LabFrame then LabFrame:Show(); MSC.UpdateLabCalc(); return end
    LabFrame = CreateFrame("Frame", "MSCLabFrame", UIParent)
    LabFrame:SetSize(360, 420); LabFrame:SetPoint("CENTER"); LabFrame:SetMovable(true); LabFrame:EnableMouse(true); LabFrame:RegisterForDrag("LeftButton")
    LabFrame:SetScript("OnDragStart", LabFrame.StartMoving); LabFrame:SetScript("OnDragStop", LabFrame.StopMovingOrSizing)
    LabFrame.bg = LabFrame:CreateTexture(nil, "BACKGROUND"); LabFrame.bg:SetAllPoints(LabFrame); LabFrame.bg:SetColorTexture(0, 0, 0, 0.9) 
    
    local _, class = UnitClass("player"); local fixed = class:sub(1,1) .. class:sub(2):lower()
    LabFrame.crest = LabFrame:CreateTexture(nil, "ARTWORK"); LabFrame.crest:SetAllPoints(LabFrame)
    LabFrame.crest:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. fixed .. ".tga")
    LabFrame.crest:SetVertexColor(0.6, 0.6, 0.6, 0.6)
    
    LabFrame.title = LabFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"); LabFrame.title:SetPoint("TOP", LabFrame, "TOP", 0, -10); LabFrame.title:SetText("Sharpie's Gear Judge")
    
    LabMH = CreateItemButton("MSCLabMH", LabFrame, -65, 120, "MH", "Main Hand")
    LabOH = CreateItemButton("MSCLabOH", LabFrame, 65, 120, "OH", "Off Hand")
    Lab2H = CreateItemButton("MSCLab2H", LabFrame, 0, 50, "2H", "Two-Hand")

    LabFrame.Instruction = LabFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); LabFrame.Instruction:SetPoint("TOP", Lab2H, "BOTTOM", 0, -5); LabFrame.Instruction:SetText("(Shift+Click to clear)"); LabFrame.Instruction:SetTextColor(0.5, 0.5, 0.5, 1)
    
    LabFrame.ProfileText = LabFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); LabFrame.ProfileText:SetPoint("TOP", LabFrame, "TOP", 0, -30)
    LabFrame.ScoreCurrent = LabFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal"); LabFrame.ScoreCurrent:SetPoint("CENTER", LabFrame, "CENTER", 0, -10)
    LabFrame.ScoreNew = LabFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal"); LabFrame.ScoreNew:SetPoint("CENTER", LabFrame, "CENTER", 0, -30)
    LabFrame.Result = LabFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"); LabFrame.Result:SetPoint("CENTER", LabFrame, "CENTER", 0, -50)
    LabFrame.Details = LabFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); LabFrame.Details:SetPoint("TOP", LabFrame.Result, "BOTTOM", 0, -10); LabFrame.Details:SetJustifyH("CENTER")
    
    CreateFrame("Button", nil, LabFrame, "UIPanelCloseButton"):SetPoint("TOPRIGHT", LabFrame, "TOPRIGHT", 0, 0)
    MSC.UpdateLabCalc()
end