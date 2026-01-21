local addonName, MSC = ...
_G.MSC = MSC -- [[ CRITICAL: Expose MSC to Plugins ]]

-- =============================================================
-- 0. THEME & COLORS
-- =============================================================
MSC.Colors = { BgSidebar = {0.05, 0.05, 0.05, 1.00}, BgPanel = {0.00, 0.00, 0.00, 0.50} }

-- [[ DATA TABLES ]]
MSC.ReceiptSlots = {} 
MSC.BagCache = {}
MSC.BagCacheDirty = true
MSC.InspectUnit = "player" 
MSC.SummaryRows = {} 

-- [[ SAFEGUARDS ]]
if not MSC.GetInspectSpec then function MSC.GetInspectSpec(unit) return "Default" end end

-- [[ EVENT LISTENERS ]]
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE"); eventFrame:RegisterEvent("INSPECT_READY")
eventFrame:SetScript("OnEvent", function(self, event, arg1) 
    if event == "BAG_UPDATE" then MSC.BagCacheDirty = true 
    elseif event == "INSPECT_READY" and MSC.ActiveTab == 2 and MSC.ViewReceipt and MSC.ViewReceipt:IsShown() then
        if UnitGUID(MSC.InspectUnit) == arg1 then MSC.UpdateReceipt() end
    end
end)

function MSC.GetClassColor()
    local _, class = UnitClass("player")
    local c = (class and RAID_CLASS_COLORS[class]) or {r=1, g=0.82, b=0}
    return c.r, c.g, c.b, 1
end

function MSC.CreateModernBorder(f, thickness)
    if not f.border then
        f.border = CreateFrame("Frame", nil, f, "BackdropTemplate")
        f.border:SetPoint("TOPLEFT", -1, 1); f.border:SetPoint("BOTTOMRIGHT", 1, -1)
        f.border:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = thickness or 1, bgFile = "Interface\\Buttons\\WHITE8X8"})
        f.border:SetBackdropBorderColor(0,0,0,1); f.border:SetBackdropColor(0,0,0,0)
        f.border:SetFrameLevel(f:GetFrameLevel() + 10)
    end
end
-- =============================================================
--  TOOLS: IMPORT & EXPORT (Popups Restored)
-- =============================================================
function MSC.ShowHistory()
    if not MSC.ExportFrame then
        local f = CreateFrame("Frame", "SGJ_ExportFrame", UIParent, "BackdropTemplate")
        f:SetSize(500, 400); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetFrameStrata("DIALOG") 
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        MSC.CreateModernBorder(f, 1)
        f.Bg = f:CreateTexture(nil, "BACKGROUND"); f.Bg:SetAllPoints(); f.Bg:SetColorTexture(0.1, 0.1, 0.1, 0.95)
        f.Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); f.Title:SetPoint("TOP", 0, -10); f.Title:SetText("Export Data")
        f.Close = CreateFrame("Button", nil, f, "UIPanelCloseButton"); f.Close:SetPoint("TOPRIGHT", -5, -5); f.Close:SetScript("OnClick", function() f:Hide() end)
        
        local sf = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        sf:SetPoint("TOPLEFT", 20, -40); sf:SetPoint("BOTTOMRIGHT", -40, 20)
        f.EditBox = CreateFrame("EditBox", nil, sf); f.EditBox:SetMultiLine(true); f.EditBox:SetFontObject(ChatFontNormal); f.EditBox:SetWidth(440); sf:SetScrollChild(f.EditBox)
        f.EditBox:SetScript("OnEscapePressed", function() f:Hide() end)
        MSC.ExportFrame = f
    end
    
    local weights, profileName = MSC.GetCurrentWeights()
    local unit = "player"
    local currentGear = MSC:GetEquippedGear()
    local totalScore = MSC:GetTotalCharacterScore(currentGear, weights, profileName)
    local dateStr = date("%Y-%m-%d")
    local _, class = UnitClass("player")
    
    if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[profileName] then profileName = MSC.CurrentClass.PrettyNames[profileName] end
    profileName = profileName:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")

    local text = "```yaml\nSharpies_Gear_Judge_Report:\n  Player: " .. UnitName(unit) .. " (" .. class .. ")\n  Spec:    " .. profileName .. "\n  Date:    " .. dateStr .. "\n  Total_Score: " .. string.format("%.1f", totalScore) .. "\n========================================\n"
    local slots = {{name="Head",id=1},{name="Neck",id=2},{name="Shoulder",id=3},{name="Back",id=15},{name="Chest",id=5},{name="Wrist",id=9},{name="Hands",id=10},{name="Waist",id=6},{name="Legs",id=7},{name="Feet",id=8},{name="Finger 1",id=11},{name="Finger 2",id=12},{name="Trinket 1",id=13},{name="Trinket 2",id=14},{name="Main Hand",id=16},{name="Off Hand",id=17},{name="Ranged",id=18}}
    for _, slot in ipairs(slots) do
        local link = GetInventoryItemLink(unit, slot.id)
        local itemName, itemScore = "[Empty]", 0
        if link then
            itemName = GetItemInfo(link) or "Unknown Item"
            local stats = MSC.SafeGetItemStats(link, slot.id, weights, profileName)
            if stats then itemScore = MSC.GetItemScore(stats, weights, profileName, slot.id) end
        end
        local slotPadding = 10 - string.len(slot.name); local space1 = string.rep(" ", slotPadding > 0 and slotPadding or 1)
        text = text .. slot.name .. ":" .. space1 .. "[" .. itemName .. "] " .. string.format("%4.1f", itemScore) .. "\n"
    end
    text = text .. "```"
    MSC.ExportFrame:Show(); MSC.ExportFrame.EditBox:SetText(text); MSC.ExportFrame.EditBox:HighlightText(); MSC.ExportFrame.EditBox:SetFocus()
end

function MSC.ShowImportWindow()
    if MSC.ImportFrame then MSC.ImportFrame:Show(); return end
    local f = CreateFrame("Frame", "SGJ_ImportFrame", UIParent, "BackdropTemplate")
    f:SetSize(400, 320); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetFrameStrata("DIALOG")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    MSC.CreateModernBorder(f, 1)
    f.Bg = f:CreateTexture(nil, "BACKGROUND"); f.Bg:SetAllPoints(); f.Bg:SetColorTexture(0.1, 0.1, 0.1, 0.95)
    f.Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); f.Title:SetPoint("TOP", 0, -10); f.Title:SetText("Import Pawn String")
    
    local sf = CreateFrame("ScrollFrame", "SGJ_ImportScroll", f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT", 20, -40); sf:SetPoint("BOTTOMRIGHT", -40, 50)
    local eb = CreateFrame("EditBox", nil, sf); eb:SetMultiLine(true); eb:SetFontObject(ChatFontNormal); eb:SetWidth(320); sf:SetScrollChild(eb); eb:SetAutoFocus(true)
    eb:SetScript("OnEscapePressed", function() f:Hide() end)

    local bImp = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); bImp:SetPoint("BOTTOMLEFT", 20, 15); bImp:SetSize(120, 25); bImp:SetText("Import")
    bImp:SetScript("OnClick", function()
        local txt = eb:GetText()
        local weights, name = MSC:ParsePawnString(txt)
        if weights then
            if not SGJ_Settings.CustomProfiles then SGJ_Settings.CustomProfiles = {} end
            SGJ_Settings.CustomProfiles["Imported"] = weights
            if MSC.CurrentClass then
                if not MSC.CurrentClass.Weights then MSC.CurrentClass.Weights = {} end
                MSC.CurrentClass.Weights["Imported"] = weights
                if MSC.CurrentClass.Profiles then MSC.CurrentClass.Profiles["Imported"] = weights end
                if MSC.CurrentClass.PrettyNames then MSC.CurrentClass.PrettyNames["Imported"] = "|cff00ff00[Import]|r " .. name end
            end
            MSC.ManualSpec = "Imported"; MSC.CachedWeights = nil; SGJ_Settings.Mode = "Imported"
            if MSC.UpdateLabCalc then MSC.UpdateLabCalc() end
            if MSC.UpdateReceipt then MSC.UpdateReceipt() end
            print("|cff00ccffSGJ:|r Imported profile '"..name.."' and activated it.")
            f:Hide()
        else print("|cffff0000SGJ Import Error:|r " .. (name or "Invalid String")) end
    end)
    local bClose = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); bClose:SetPoint("BOTTOMRIGHT", -20, 15); bClose:SetSize(100, 25); bClose:SetText("Cancel"); bClose:SetScript("OnClick", function() f:Hide() end)
    MSC.ImportFrame = f
end

-- =============================================================
-- 1. TAB REGISTRY (The Plugin Engine)
-- =============================================================
MSC.RegisteredTabs = {
    -- { id=1, icon="Interface\\Icons\\INV_Sword_04", name="Old Lab", view="ViewLab" },
    { id=2, icon="Interface\\Icons\\INV_Misc_Note_02", name="Receipt", funcName="InitReceiptView", view="ViewReceipt", update="UpdateReceipt" },
    { id=3, icon="Interface\\Icons\\Spell_Holy_MindVision", name="Stat Logic", funcName="InitLogicView", view="ViewLogic", update="UpdateLogic" },
    { id=4, icon="Interface\\Icons\\INV_Gizmo_02", name="Protocol", funcName="InitSettingsView", view="ViewSettings" }
}

function MSC.RegisterPluginTab(name, icon, initFunc, viewKey, updateFuncKey)
    table.insert(MSC.RegisteredTabs, {
        id = #MSC.RegisteredTabs + 1,
        name = name,
        icon = icon,
        directFunc = initFunc,
        view = viewKey,
        update = updateFuncKey
    })
    if MSC.MainFrame and MSC.MainFrame:IsShown() then MSC.RenderSidebarButtons() end
end

-- =============================================================
-- 2. DYNAMIC SIDEBAR RENDERER
-- =============================================================
function MSC.RenderSidebarButtons()
    if not MSC.MainFrame then return end
    if MSC.NavButtons then for _, btn in ipairs(MSC.NavButtons) do btn:Hide() end end
    MSC.NavButtons = {}

    for idx, tab in ipairs(MSC.RegisteredTabs) do
        local btn = CreateFrame("Button", nil, MSC.MainFrame.Sidebar)
        btn:SetSize(50, 50); btn:SetPoint("TOP", 0, -20 - ((idx-1)*65))
        
        btn.Bg = btn:CreateTexture(nil, "BACKGROUND"); btn.Bg:SetAllPoints(); btn.Bg:SetColorTexture(1, 1, 1, 0.05); btn.Bg:SetAlpha(0)
        btn.Icon = btn:CreateTexture(nil, "ARTWORK"); btn.Icon:SetSize(32, 32); btn.Icon:SetPoint("CENTER"); btn.Icon:SetTexture(tab.icon); btn.Icon:SetDesaturated(true); btn.Icon:SetVertexColor(0.6, 0.6, 0.6)
        btn.SelectBar = btn:CreateTexture(nil, "OVERLAY"); btn.SelectBar:SetColorTexture(0, 0.8, 1, 1); btn.SelectBar:SetSize(4, 50); btn.SelectBar:SetPoint("LEFT", 0, 0); btn.SelectBar:Hide()
        
        btn:SetScript("OnEnter", function(self) self.Icon:SetVertexColor(1,1,1); self.Bg:SetAlpha(0.1); GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(tab.name); GameTooltip:Show() end)
        btn:SetScript("OnLeave", function(self) self.Bg:SetAlpha(0); if idx ~= MSC.ActiveTab then self.Icon:SetVertexColor(0.6, 0.6, 0.6) end GameTooltip:Hide() end)
        btn:SetScript("OnClick", function(self) MSC.SwitchTab(idx) end)
        
        table.insert(MSC.NavButtons, btn)
    end
    if MSC.ActiveTab then MSC.SwitchTab(MSC.ActiveTab) end
end

-- =============================================================
-- 3. MAIN DASHBOARD (Restored Art, Text & Scaling)
-- =============================================================
function MSC.ToggleMainMenu()
    if MSC.MainFrame then
        if MSC.MainFrame:IsShown() then MSC.MainFrame:Hide() else MSC.MainFrame:Show() end
        return
    end

    local f = CreateFrame("Frame", "SGJ_MainFrame", UIParent, "BackdropTemplate")
    f:SetSize(650, 600); f:SetPoint("CENTER")
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton"); f:SetFrameStrata("HIGH")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    
    f.border = CreateFrame("Frame", nil, f, "BackdropTemplate")
    f.border:SetPoint("TOPLEFT", -1, 1); f.border:SetPoint("BOTTOMRIGHT", 1, -1)
    f.border:SetBackdrop({edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1}); f.border:SetBackdropBorderColor(0,0,0,1)

    -- [[ 1. ART ENGINE (FIXED) ]]
    f.Bg = f:CreateTexture(nil, "BACKGROUND", nil, -8); f.Bg:SetAllPoints()
    local _, class = UnitClass("player")
    local fixedClass = class:sub(1,1)..class:sub(2):lower()
    
    -- Try to load texture
    pcall(function() f.Bg:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. fixedClass .. ".tga") end)
    -- Use SetVertexColor to TINT it dark instead of deleting it with SetColorTexture
	f.Bg:SetVertexColor(1, 1, 1, 1)
    
    f.Overlay = f:CreateTexture(nil, "BACKGROUND", nil, -7); f.Overlay:SetAllPoints()
    f.Overlay:SetColorTexture(0.08, 0.08, 0.10, 0.80) 
    
    -- [[ 2. HEADER & SCALING ]]
    f.Header = CreateFrame("Frame", nil, f); f.Header:SetPoint("TOPLEFT", 70, 0); f.Header:SetPoint("TOPRIGHT", 0, 0); f.Header:SetHeight(60)
    f.Header:EnableMouse(true)
    -- Restore MouseWheel Scaling
    f.Header:SetScript("OnMouseWheel", function(self, delta)
        local cur = f:GetScale(); if delta > 0 then cur = cur + 0.05 else cur = cur - 0.05 end
        if cur < 0.6 then cur = 0.6 end; if cur > 1.4 then cur = 1.4 end; f:SetScale(cur)
    end)

    f.Header.Grad = f.Header:CreateTexture(nil, "BACKGROUND"); f.Header.Grad:SetAllPoints(); f.Header.Grad:SetColorTexture(0, 0, 0, 0.5); f.Header.Grad:SetGradient("VERTICAL", CreateColor(0,0,0,0), CreateColor(0,0,0,0.8))

    f.Title = f.Header:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); f.Title:SetPoint("LEFT", 20, -5); f.Title:SetText("Sharpie's Gear Judge"); f.Title:SetTextColor(1, 1, 1)
    f.SubTitle = f.Header:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); f.SubTitle:SetPoint("BOTTOMLEFT", f.Title, "BOTTOMRIGHT", 10, 2); f.SubTitle:SetText("v2.2.1 Laboratory")
    f.Close = CreateFrame("Button", nil, f.Header, "UIPanelCloseButton"); f.Close:SetPoint("TOPRIGHT", -5, -5); f.Close:SetScript("OnClick", function() f:Hide() end)

    -- Restore "Scroll to Scale" Text
    f.ScaleHint = f.Header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); f.ScaleHint:SetPoint("RIGHT", f.Close, "LEFT", -5, 0); f.ScaleHint:SetText("Scroll to Scale"); f.ScaleHint:SetTextColor(0.5, 0.5, 0.5)

    -- [[ 3. SIDEBAR & MOVE HINT ]]
    f.Sidebar = CreateFrame("Frame", nil, f); f.Sidebar:SetPoint("TOPLEFT", 0, 0); f.Sidebar:SetPoint("BOTTOMLEFT", 0, 0); f.Sidebar:SetWidth(70)
    f.Sidebar.Bg = f.Sidebar:CreateTexture(nil, "BACKGROUND"); f.Sidebar.Bg:SetAllPoints(); f.Sidebar.Bg:SetColorTexture(unpack(MSC.Colors.BgSidebar))
    
    -- Restore "Hold to Move" Text
    f.MoveHint = f.Sidebar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); f.MoveHint:SetPoint("BOTTOM", 0, 15); f.MoveHint:SetText("Hold\nto Move"); f.MoveHint:SetTextColor(0.3, 0.3, 0.3)

    f.Content = CreateFrame("Frame", nil, f); f.Content:SetPoint("TOPLEFT", f.Sidebar, "TOPRIGHT", 0, -60); f.Content:SetPoint("BOTTOMRIGHT", 0, 0)
    MSC.MainFrame = f
    
    MSC.RenderSidebarButtons() 
    MSC.SwitchTab(1) -- Default to first available tab
    f:Show()
end

function MSC.SwitchTab(id)
    MSC.ActiveTab = id
    if MSC.NavButtons then
        for i, btn in ipairs(MSC.NavButtons) do
            if i == id then btn.Icon:SetDesaturated(false); btn.Icon:SetVertexColor(1,1,1); btn.SelectBar:Show()
            else btn.Icon:SetDesaturated(true); btn.Icon:SetVertexColor(0.6,0.6,0.6); btn.SelectBar:Hide() end
        end
    end
    for _, tab in ipairs(MSC.RegisteredTabs) do if MSC[tab.view] then MSC[tab.view]:Hide() end end
    
    local tab = MSC.RegisteredTabs[id]
    if tab then
        local init = tab.directFunc or (tab.funcName and MSC[tab.funcName])
        if not MSC[tab.view] and init then init(MSC.MainFrame.Content) end
        if MSC[tab.view] then 
            MSC[tab.view]:Show() 
            if tab.update and MSC[tab.update] then MSC[tab.update]() end
        end
    end
end

-- =============================================================
-- 4. VIEW LOGIC (Standard Views)
-- =============================================================

-- [[ VIEW 2: RECEIPT ]]
function MSC.PopulateBagCache(weights, specName)
    if not MSC.BagCacheDirty then return end
    MSC.BagCache = {}
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local link = C_Container.GetContainerItemLink(bag, slot)
            if link and MSC.IsItemUsable(link) then
                 local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                 local slotId = MSC.SlotMap and MSC.SlotMap[equipLoc]
                 if slotId then
                        local stats = MSC.SafeGetItemStats(link, slotId, weights, specName)
                        local score = MSC.GetItemScore(stats, weights, specName, slotId)
                        table.insert(MSC.BagCache, { link = link, slotId = slotId, score = score, equipLoc = equipLoc })
                 end
            end
        end
    end
    MSC.BagCacheDirty = false
end

function MSC.InitReceiptView(parent)
    local f = CreateFrame("Frame", nil, parent); f:SetAllPoints(); f:Hide()
    f.Info = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"); f.Info:SetPoint("TOPLEFT", 40, -10)
    f.Score = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); f.Score:SetPoint("TOPRIGHT", -40, -10)
    local sep = f:CreateTexture(nil, "OVERLAY"); sep:SetHeight(1); sep:SetColorTexture(1,1,1,0.2); sep:SetPoint("TOPLEFT", 20, -40); sep:SetPoint("TOPRIGHT", -20, -40)

    local bScan = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    bScan:SetSize(80, 20); bScan:SetPoint("TOPLEFT", f.Info, "BOTTOMLEFT", 0, -5)
    bScan:SetText("Scan Target")
    bScan:SetScript("OnClick", function()
        if MSC.InspectUnit == "player" then
            if UnitExists("target") and UnitIsPlayer("target") then MSC.InspectUnit = "target"; NotifyInspect("target"); bScan:SetText("Show Player")
            else print("SGJ: Target a player to inspect.") end
        else MSC.InspectUnit = "player"; bScan:SetText("Scan Target") end
        MSC.UpdateReceipt()
    end)

    local c = CreateFrame("Frame", nil, f); c:SetSize(400, 340); c:SetPoint("TOP", 0, -60)
    local function CreatePanel(name, w, h, point, relTo, relPoint, x, y)
        local p = CreateFrame("Frame", nil, c, "BackdropTemplate"); p:SetSize(w, h); p:SetPoint(point, relTo, relPoint, x, y)
        p:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1}); p:SetBackdropColor(unpack(MSC.Colors.BgPanel)); p:SetBackdropBorderColor(0,0,0,0.5)
        local lbl = p:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); lbl:SetPoint("BOTTOMLEFT", p, "TOPLEFT", 0, 4); lbl:SetText(name); lbl:SetTextColor(0.7, 0.7, 0.7); return p
    end
    local pArmor = CreatePanel("ARMOR", 220, 240, "TOPLEFT", c, "TOPLEFT", 0, 0)
    local pJewel = CreatePanel("ACCESSORIES", 130, 240, "TOPLEFT", pArmor, "TOPRIGHT", 20, 0)
    local pWeap  = CreatePanel("WEAPONS", 465, 75, "TOP", c, "TOP", 0, -260)

    local function CreateSlot(id, parentPanel, x, y, label)
        local btn = CreateFrame("Button", nil, f, "ItemButtonTemplate"); btn:SetSize(30, 30); btn:SetPoint("TOPLEFT", parentPanel, "TOPLEFT", x, y)
        btn.ScoreFrame = CreateFrame("Frame", nil, btn, "BackdropTemplate"); btn.ScoreFrame:SetPoint("LEFT", btn, "RIGHT", 2, 0); btn.ScoreFrame:SetSize(40, 20)
        btn.ScoreFrame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8"}); btn.ScoreFrame:SetBackdropColor(0,0,0,0.5)
        btn.ScoreText = btn.ScoreFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); btn.ScoreText:SetPoint("CENTER"); btn.ScoreText:SetTextColor(1, 0.9, 0)
        btn.Alert = btn:CreateTexture(nil, "OVERLAY"); btn.Alert:SetSize(16, 16); btn.Alert:SetPoint("LEFT", btn.ScoreFrame, "RIGHT", 2, 0); btn.Alert:Hide()
        btn:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); if self.link then GameTooltip:SetHyperlink(self.link) else GameTooltip:SetText(label, 1, 1, 1) end if self.AlertMode then GameTooltip:AddLine(" "); GameTooltip:AddLine(self.AlertText or "Alert", 1, 0, 0) end GameTooltip:Show() end); btn:SetScript("OnLeave", GameTooltip_Hide)
        btn.SlotID = id; table.insert(MSC.ReceiptSlots, btn)
    end
    CreateSlot(1, pArmor, 10, -10, "Head"); CreateSlot(3, pArmor, 10, -55, "Shoulder"); CreateSlot(15, pArmor, 10, -100, "Back"); CreateSlot(5, pArmor, 10, -145, "Chest"); CreateSlot(9, pArmor, 10, -190, "Wrist")
    CreateSlot(10, pArmor, 115, -10, "Hands"); CreateSlot(6, pArmor, 115, -55, "Waist"); CreateSlot(7, pArmor, 115, -100, "Legs"); CreateSlot(8, pArmor, 115, -145, "Feet")
    CreateSlot(2, pJewel, 10, -10, "Neck"); CreateSlot(11, pJewel, 10, -55, "Ring 1"); CreateSlot(12, pJewel, 10, -100, "Ring 2"); CreateSlot(13, pJewel, 10, -145, "Trinket 1"); CreateSlot(14, pJewel, 10, -190, "Trinket 2")
    CreateSlot(16, pWeap, 30, -20, "Main Hand"); CreateSlot(17, pWeap, 160, -20, "Off Hand"); CreateSlot(18, pWeap, 290, -20, "Ranged")
    
    f.SummaryBox = CreateFrame("Frame", nil, f, "BackdropTemplate"); f.SummaryBox:SetPoint("TOP", pWeap, "BOTTOM", 0, -20); f.SummaryBox:SetSize(450, 100)
    f.SummaryBox.Title = f.SummaryBox:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.SummaryBox.Title:SetPoint("TOP", 0, 0); f.SummaryBox.Title:SetText("COMBINED GEAR STAT TOTALS"); f.SummaryBox.Title:SetTextColor(1, 0.82, 0)
    MSC.SummaryRows = {}
    for i=1, 12 do
        local row = CreateFrame("Frame", nil, f.SummaryBox); row:SetSize(200, 16)
        row.Label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); row.Label:SetPoint("LEFT", 0, 0)
        row.Value = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); row.Value:SetPoint("RIGHT", 0, 0)
        table.insert(MSC.SummaryRows, row)
    end
    MSC.ViewReceipt = f
end

function MSC.UpdateReceipt()
    if not MSC.ViewReceipt or not MSC.ViewReceipt:IsShown() then return end
    local unit = MSC.InspectUnit or "player"
    local weights, specName = MSC.GetCurrentWeights()
    
    local displayName = specName
    if MSC.PrettyNames and MSC.PrettyNames[specName] then displayName = MSC.PrettyNames[specName] end
    if unit ~= "player" then
        local detected = (MSC.GetInspectSpec and MSC.GetInspectSpec(unit)) or "Default"; local prof = detected or "Default"; local _, cls = UnitClass(unit)
        if MSC.PrettyNames and MSC.PrettyNames[prof] then displayName = cls .. ": " .. MSC.PrettyNames[prof] else displayName = cls .. " (" .. prof .. ")" end
        specName = displayName 
        if MSC.CurrentClass and MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[prof] then weights = MSC.CurrentClass.Weights[prof]
        elseif MSC.WeightDB and MSC.WeightDB[cls] then weights = MSC.WeightDB[cls][prof] or MSC.WeightDB[cls]["Default"] end
    end
    MSC.ViewReceipt.Info:SetText(displayName)
    
    local gearTable = {}; local combinedStats = {}
    for i=1, 18 do 
        local link = GetInventoryItemLink(unit, i)
        if link then 
            gearTable[i] = link 
            local s = MSC.SafeGetItemStats(link, i, weights, specName)
            if s then for k, v in pairs(s) do if type(v)=="number" then combinedStats[k] = (combinedStats[k] or 0) + v end end end
        end
    end
    local totalScore = MSC:GetTotalCharacterScore(gearTable, weights, specName)
    MSC.ViewReceipt.Score:SetText("Score: " .. string.format("|cff00ff00%.1f|r", totalScore))
    
    if unit == "player" then MSC.PopulateBagCache(weights, specName) end
    if not MSC.ReceiptSlots then return end

    for _, btn in ipairs(MSC.ReceiptSlots) do
        local link = GetInventoryItemLink(unit, btn.SlotID)
        btn.link = link; btn.Alert:Hide(); btn.AlertMode = nil
        if link then
            SetItemButtonTexture(btn, GetInventoryItemTexture(unit, btn.SlotID))
            local stats = MSC.SafeGetItemStats(link, btn.SlotID, weights, specName)
            local score = MSC.GetItemScore(stats, weights, specName, btn.SlotID)
            if score > 0 then btn.ScoreText:SetText(math.floor(score)) else btn.ScoreText:SetText("") end
            
            local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
            if equipLoc ~= "INVTYPE_HOLDABLE" and equipLoc ~= "INVTYPE_TABARD" and equipLoc ~= "INVTYPE_BODY" then
                 local enchantID = link:match("item:%d+:(%d+)")
                 local validSlots = {[1]=true,[3]=true,[5]=true,[7]=true,[8]=true,[9]=true,[10]=true,[15]=true,[16]=true,[17]=true}
                 if validSlots[btn.SlotID] and (not enchantID or enchantID == "0") then btn.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertOther"); btn.Alert:Show(); btn.AlertMode = "Enchant"; btn.AlertText = "Missing Enchant!" end
            end
            if unit == "player" then
                local bestBagScore = score; local foundUpgrade = false
                for _, cachedItem in ipairs(MSC.BagCache or {}) do
                    local isMatch = (cachedItem.slotId == btn.SlotID)
                    if btn.SlotID == 11 or btn.SlotID == 12 then if cachedItem.slotId == 11 then isMatch = true end end
                    if btn.SlotID == 13 or btn.SlotID == 14 then if cachedItem.slotId == 13 then isMatch = true end end
                    if isMatch and cachedItem.score > bestBagScore + 0.1 then foundUpgrade = true end
                end
                if foundUpgrade then btn.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew"); btn.Alert:Show(); btn.AlertMode = "Upgrade"; btn.AlertText = "Better item in bags!" end
            end
        else
            SetItemButtonTexture(btn, "Interface\\PaperDoll\\UI-Backpack-EmptySlot"); btn.ScoreText:SetText("")
        end
    end
    
    local sortedStats = {}
    for k, v in pairs(combinedStats) do
        if k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" and v > 0 then
            local weight = weights[k] or 0
            if weight > 0 then table.insert(sortedStats, { key=k, val=v, weight=weight }) end
        end
    end
    table.sort(sortedStats, function(a,b) return a.weight > b.weight end)
    
    for i, row in ipairs(MSC.SummaryRows) do
        if sortedStats[i] then
            row:Show(); local clean = MSC.GetCleanStatName(sortedStats[i].key)
            row.Label:SetText("|cff00ff00" .. clean .. ":|r"); row.Value:SetText(string.format("%.1f", sortedStats[i].val))
            local isLeft = (i % 2 ~= 0); local rIdx = math.ceil(i/2)
            if isLeft then row:SetPoint("TOPLEFT", MSC.ViewReceipt.SummaryBox, "TOPLEFT", 10, -20 - (rIdx*16))
            else row:SetPoint("TOPLEFT", MSC.ViewReceipt.SummaryBox, "TOPLEFT", 230, -20 - (rIdx*16)) end
        else row:Hide() end
    end
end

-- [[ VIEW 3: STAT LOGIC ]]
local function GetStatReason(stat, class, profileName)
    if not profileName then profileName = "" end
    if stat:find("HIT") then return "Reduces Miss Chance" end
    if stat:find("HASTE") then return "Increases Speed" end
    if stat:find("CRIT") and not stat:find("FROM_STATS") then return "Crit Chance" end
    if stat:find("DEFENSE") then return "Crit Immunity / Avoidance" end
    if stat:find("SPELL_POWER") then return "Spell Scaling" end
    if stat:find("HEALING") then return "Healing Output" end
    if stat:find("ATTACK_POWER") then return "Raw Damage" end
    if stat:find("MANA_REG") then return "Sustain (Mp5)" end
    if stat:find("STAMINA") then return "Health Pool" end
    if stat:find("INTELLECT") then return "Mana & Crit" end
    if stat:find("AGILITY") then return "Crit & Dodge" end
    if stat:find("STRENGTH") then return "Attack Power" end
    return nil
end

function MSC.InitLogicView(parent)
    local f = CreateFrame("Frame", nil, parent); f:SetAllPoints(); f:Hide()
    local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 20, -20); scroll:SetPoint("BOTTOMRIGHT", -40, 20)
    local content = CreateFrame("Frame", nil, scroll); content:SetSize(400, 800); scroll:SetScrollChild(content)
    f.Content = content
    MSC.ViewLogic = f
end

function MSC.UpdateLogic()
    if not MSC.ViewLogic or not MSC.ViewLogic:IsShown() then return end
    local content = MSC.ViewLogic.Content
    if content.children then for _, c in ipairs(content.children) do c:Hide() end end
    content.children = {}
    
    local weights, detectedKey = MSC.GetCurrentWeights()
    local _, class = UnitClass("player")
    local yOff = -10
    
    local function AddText(t, isHeader)
        local fs = content:CreateFontString(nil, "OVERLAY", isHeader and "GameFontNormalLarge" or "GameFontHighlight")
        fs:SetPoint("TOPLEFT", 10, yOff); fs:SetText(t); if isHeader then fs:SetTextColor(1, 0.82, 0) end
        yOff = yOff - 20; table.insert(content.children, fs)
    end
    
    AddText("Stat Caps", true)
    local currentGear = MSC:GetEquippedGear()
    local _, stats = MSC:GetTotalCharacterScore(currentGear, weights, detectedKey)
    local hit = stats["ITEM_MOD_HIT_SPELL_RATING_SHORT"] or stats["ITEM_MOD_HIT_RATING_SHORT"] or 0
    if hit > 0 then
        local cap = (class == "WARLOCK" or class == "MAGE") and 202 or 142
        local pct = math.min(100, (hit / cap) * 100)
        local bar = CreateFrame("StatusBar", nil, content, "BackdropTemplate")
        bar:SetSize(300, 16); bar:SetPoint("TOPLEFT", 10, yOff); bar:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8"}); bar:SetBackdropColor(0.2,0.2,0.2,1)
        bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar"); bar:SetMinMaxValues(0, 100); bar:SetValue(pct)
        if pct >= 100 then bar:SetStatusBarColor(0,1,0) elseif pct > 80 then bar:SetStatusBarColor(1,1,0) else bar:SetStatusBarColor(1,0,0) end
        local txt = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmallOutline"); txt:SetPoint("CENTER"); txt:SetText("Hit Rating: " .. hit .. " / " .. cap .. " ("..string.format("%.0f", pct).."%)")
        yOff = yOff - 25; table.insert(content.children, bar)
    end
    
    AddText("Stat Priority (Weights)", true)
    local maxW = 0; local sorted = {}
    for k, v in pairs(weights) do if v > 0 then table.insert(sorted, {k=k, v=v}); if v > maxW then maxW = v end end end
    table.sort(sorted, function(a,b) return a.v > b.v end)
    
    for _, s in ipairs(sorted) do
        local name = MSC.GetCleanStatName(s.k)
        local reason = GetStatReason(s.k, class, detectedKey)
        local bar = CreateFrame("StatusBar", nil, content, "BackdropTemplate")
        bar:SetSize(300, 24); bar:SetPoint("TOPLEFT", 10, yOff); bar:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8"}); bar:SetBackdropColor(0.1,0.1,0.1,0.5)
        bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar"); bar:SetMinMaxValues(0, maxW); bar:SetValue(s.v); bar:SetStatusBarColor(0.0, 0.7, 1.0, 0.8)
        local leftT = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); leftT:SetPoint("LEFT", 5, 0); leftT:SetText(name:gsub("Rating", ""))
        local rightT = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); rightT:SetPoint("RIGHT", -5, 0); rightT:SetText(string.format("%.2f", s.v))
        if reason then local sub = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); sub:SetPoint("LEFT", leftT, "RIGHT", 5, 0); sub:SetText("("..reason..")"); sub:SetTextColor(0.6, 0.6, 0.6) end
        yOff = yOff - 28; table.insert(content.children, bar)
    end
    content:SetHeight(math.abs(yOff) + 50)
end

-- [[ VIEW 4: SETTINGS ]]
function MSC.InitSettingsView(parent)
    local f = CreateFrame("Frame", nil, parent); f:SetAllPoints(); f:Hide()
    local function CreateHeader(text, relTo, yOff)
        local h = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); h:SetText(text); h:SetTextColor(1, 0.82, 0)
        if relTo then h:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", 0, yOff) else h:SetPoint("TOPLEFT", 40, -30) end
        return h
    end
    local function CreateDropdown(label, key, options, relTo, yOff)
        local frame = CreateFrame("Frame", nil, f); frame:SetSize(200, 50); frame:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", 0, yOff)
        local lbl = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); lbl:SetPoint("TOPLEFT", 0, 0); lbl:SetText(label); lbl:SetTextColor(0.6, 0.6, 0.6)
        local dd = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate"); dd:SetPoint("TOPLEFT", -15, -15); UIDropDownMenu_SetWidth(dd, 180)
        local function OnClick(self) UIDropDownMenu_SetSelectedID(dd, self:GetID()); SGJ_Settings[key] = self.value; if key == "Mode" then MSC.ManualSpec = self.value; MSC.CachedWeights = nil; if MSC.UpdateReceipt then MSC.UpdateReceipt() end end end
        local function Init(self, level) for _, opt in ipairs(options) do local info = UIDropDownMenu_CreateInfo(); info.text = opt.text; info.value = opt.val; info.func = OnClick; info.checked = (SGJ_Settings[key] == opt.val); UIDropDownMenu_AddButton(info, level) end end
        UIDropDownMenu_Initialize(dd, Init)
        local currentText = "Select..."; for _, opt in ipairs(options) do if SGJ_Settings[key] == opt.val then currentText = opt.text end end
        UIDropDownMenu_SetText(dd, currentText); if key == "Mode" then f.ProfileDD = dd end
        return frame
    end
    
    local h1 = CreateHeader("Comparison Logic", nil, 0)
    local ddEnchant = CreateDropdown("Enchant Mode", "EnchantMode", {{ text = "Off (Raw Stats)", val = 1 }, { text = "Current Only (Equipped)", val = 2 }, { text = "Project Best (Simulator)", val = 3 }}, h1, -10)
    local h2 = CreateHeader("Character Profile", ddEnchant, -20)
    local specOptions = { { text = "Auto-Detect", val = "AUTO" } }; local seen = { ["AUTO"] = true }
    if MSC.CurrentClass then
        local function AddList(listSource)
            if not listSource then return end
            local sorted = {}; for k in pairs(listSource) do table.insert(sorted, k) end; table.sort(sorted)
            for _, k in ipairs(sorted) do if not seen[k] then local name = (MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[k]) or k; table.insert(specOptions, { text = name, val = k }); seen[k] = true end end
        end
        AddList(MSC.CurrentClass.Weights); AddList(MSC.CurrentClass.LevelingWeights); AddList(MSC.CurrentClass.Profiles)
    end
    local ddProfile = CreateDropdown("Active Scoring Profile", "Mode", specOptions, h2, -10)
    MSC.ViewSettings = f
    
    local bImp = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); bImp:SetSize(140, 30); bImp:SetPoint("BOTTOMRIGHT", -40, 40); bImp:SetText("Import Pawn String")
    bImp:SetScript("OnClick", function() MSC.ShowImportWindow() end)
    local bExport = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); bExport:SetSize(140, 30); bExport:SetPoint("BOTTOMRIGHT", -190, 40); bExport:SetText("Export Data")
    bExport:SetScript("OnClick", function() MSC.ShowHistory() end)
end

-- =============================================================
-- 5. MINIMAP BUTTON
-- =============================================================
local mb = CreateFrame("Button", "MSC_Minimap", Minimap); mb:SetSize(32,32); mb:SetFrameLevel(8); mb:SetPoint("CENTER", -60, -60)
mb.icon = mb:CreateTexture(nil,"BACKGROUND"); mb.icon:SetTexture("Interface\\Icons\\INV_Misc_Spyglass_02"); mb.icon:SetSize(20,20); mb.icon:SetPoint("CENTER")
mb.border = mb:CreateTexture(nil,"OVERLAY"); mb.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder"); mb.border:SetSize(54,54); mb.border:SetPoint("TOPLEFT")
mb:RegisterForClicks("AnyUp"); mb:SetScript("OnClick", MSC.ToggleMainMenu)