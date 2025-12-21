local _, MSC = ...

-- 1. MINIMAP BUTTON
local MinimapButton = CreateFrame("Button", "MSC_MinimapButton", Minimap)
MinimapButton:SetSize(32, 32)
MinimapButton:SetFrameStrata("MEDIUM")
MinimapButton:SetFrameLevel(8) 
MinimapButton.icon = MinimapButton:CreateTexture(nil, "BACKGROUND")
MinimapButton.icon:SetTexture("Interface\\Icons\\INV_Misc_Spyglass_02")
MinimapButton.icon:SetSize(20, 20)
MinimapButton.icon:SetPoint("CENTER")
MinimapButton.border = MinimapButton:CreateTexture(nil, "OVERLAY")
MinimapButton.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
MinimapButton.border:SetSize(54, 54)
MinimapButton.border:SetPoint("TOPLEFT")
MinimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

function MSC.UpdateMinimapPosition()
    if not SGJ_Settings then return end
    if SGJ_Settings.HideMinimap then MinimapButton:Hide(); return else MinimapButton:Show() end
    local angle = math.rad(SGJ_Settings.MinimapPos or 45)
    local x, y = math.cos(angle), math.sin(angle)
    MinimapButton:SetPoint("CENTER", Minimap, "CENTER", x * 80, y * 80)
end

MinimapButton:RegisterForClicks("AnyUp")
MinimapButton:RegisterForDrag("LeftButton")
MinimapButton:SetScript("OnDragStart", function(self) self:SetScript("OnUpdate", function(self) 
    local x, y = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    local cx, cy = Minimap:GetCenter()
    local dx, dy = (x / scale) - cx, (y / scale) - cy
    SGJ_Settings.MinimapPos = math.deg(math.atan2(dy, dx))
    MSC.UpdateMinimapPosition() 
end) end)
MinimapButton:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)

MinimapButton:SetScript("OnClick", function(self, button) 
    if button == "LeftButton" then 
        if MSC.CreateLabFrame then MSC.CreateLabFrame() else print("Lab module not loaded.") end
    else
        MSC.CreateOptionsFrame() 
    end 
end)

MinimapButton:SetScript("OnEnter", function(self) 
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("Sharpie's Gear Judge")
    GameTooltip:AddLine("|cffffffffLeft-Click:|r Toggle Judge's Lab", 1, 1, 1)
    GameTooltip:AddLine("|cffffffffRight-Click:|r Toggle Settings", 1, 1, 1)
    GameTooltip:Show() 
end)
MinimapButton:SetScript("OnLeave", GameTooltip_Hide)

-- 2. CONFIGURATION PANEL (TOGGLE FIX)
function MSC.CreateOptionsFrame()
    if MyStatCompareFrame then 
        if MyStatCompareFrame:IsShown() then MyStatCompareFrame:Hide() else MyStatCompareFrame:Show() end
        return 
    end
    
    local f = CreateFrame("Frame", "MyStatCompareFrame", UIParent, "BasicFrameTemplateWithInset, BackdropTemplate")
    f:SetSize(400, 500)
    f:SetPoint("CENTER")
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); f.title:SetPoint("LEFT", f.TitleBg, "LEFT", 5, 0); f.title:SetText("Sharpie's Gear Judge Configuration")

    local function CreateHeader(text, relativeTo, yOffset)
        local h = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); h:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, yOffset); h:SetText(text); return h
    end
    local function CreateDesc(text, relativeTo)
        local d = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); d:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 20, -5); d:SetWidth(340); d:SetJustifyH("LEFT"); d:SetText(text); d:SetTextColor(0.7, 0.7, 0.7); return d
    end

    local header1 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); header1:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -40); header1:SetText("Comparison Mode")

    local strictCheck = CreateFrame("CheckButton", "SGJ_StrictCheck", f, "ChatConfigCheckButtonTemplate"); strictCheck:SetPoint("TOPLEFT", header1, "BOTTOMLEFT", 0, -10); strictCheck.Text:SetText("Strict Mode (What you see is what you get)"); strictCheck:SetChecked(SGJ_Settings.IncludeEnchants)
    local strictDesc = CreateDesc("Compares items exactly as they are.", strictCheck)

    local potentialCheck = CreateFrame("CheckButton", "SGJ_PotentialCheck", f, "ChatConfigCheckButtonTemplate"); potentialCheck:SetPoint("TOPLEFT", strictDesc, "BOTTOMLEFT", -20, -15); potentialCheck.Text:SetText("Potential Mode (Simulate Enchants)"); potentialCheck:SetChecked(SGJ_Settings.ProjectEnchants)
    local potentialDesc = CreateDesc("Virtually applies your current enchant to the new item.", potentialCheck)

    strictCheck:SetScript("OnClick", function(self) if self:GetChecked() then SGJ_Settings.IncludeEnchants=true; SGJ_Settings.ProjectEnchants=false; potentialCheck:SetChecked(false) else self:SetChecked(true) end end)
    potentialCheck:SetScript("OnClick", function(self) if self:GetChecked() then SGJ_Settings.ProjectEnchants=true; SGJ_Settings.IncludeEnchants=false; strictCheck:SetChecked(false) else self:SetChecked(true) end end)

    local header2 = CreateHeader("Character Profile", potentialDesc, -25)
    local dropDown = CreateFrame("Frame", "SGJ_SpecDropDown", f, "UIDropDownMenuTemplate"); dropDown:SetPoint("TOPLEFT", header2, "BOTTOMLEFT", -15, -10)
    
    -- [[ FIXED DROPDOWN LOGIC ]] --
    local function UpdateDropDownText()
        if SGJ_Settings.Mode == "Auto" then
             -- Ask Helpers.lua what it actually found!
             local _, displayName = MSC.GetCurrentWeights()
             UIDropDownMenu_SetText(dropDown, displayName or "Auto (Detecting...)")
        else
             UIDropDownMenu_SetText(dropDown, SGJ_Settings.Mode)
        end
    end

    local function OnClick(self) 
        SGJ_Settings.Mode = self.value
        UIDropDownMenu_SetSelectedID(dropDown, self:GetID())
        UpdateDropDownText() -- Update the text immediately
        print("|cff00ccffSharpie:|r Profile changed to " .. self.value) 
    end

    local function Initialize(self, level)
        local info = UIDropDownMenu_CreateInfo(); info.text = "Auto-Detect"; info.value = "Auto"; info.func = OnClick; info.checked = (SGJ_Settings.Mode == "Auto"); UIDropDownMenu_AddButton(info, level)
        local _, englishClass = UnitClass("player")
        if MSC.SpecNames and MSC.SpecNames[englishClass] then
            for i=1, 3 do local spec = MSC.SpecNames[englishClass][i]; info = UIDropDownMenu_CreateInfo(); info.text = spec; info.value = spec; info.func = OnClick; info.checked = (SGJ_Settings.Mode == spec); UIDropDownMenu_AddButton(info, level) end
        end
        info = UIDropDownMenu_CreateInfo(); info.text = "Leveling / PvP"; info.value = "Hybrid"; info.func = OnClick; info.checked = (SGJ_Settings.Mode == "Hybrid"); UIDropDownMenu_AddButton(info, level)
        if MSC.WeightDB and MSC.WeightDB[englishClass] and MSC.WeightDB[englishClass]["Tank"] then
            info = UIDropDownMenu_CreateInfo(); info.text = "Tanking (Threat/Surv)"; info.value = "Tank"; info.func = OnClick; info.checked = (SGJ_Settings.Mode == "Tank"); UIDropDownMenu_AddButton(info, level)
        end
    end
    
    UIDropDownMenu_Initialize(dropDown, Initialize)
    UIDropDownMenu_SetWidth(dropDown, 200)
    UIDropDownMenu_SetButtonWidth(dropDown, 124)
    
    -- Call our new helper to set the initial text correctly
    UpdateDropDownText() 

    local header3 = CreateHeader("Interface Settings", dropDown, -25); header3:SetPoint("TOPLEFT", potentialDesc, "BOTTOMLEFT", -20, -110) 
    
    local minimapCheck = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate"); minimapCheck:SetPoint("TOPLEFT", header3, "BOTTOMLEFT", 0, -10); minimapCheck.Text:SetText("Show Minimap Button"); minimapCheck:SetChecked(not SGJ_Settings.HideMinimap)
    minimapCheck:SetScript("OnClick", function(self) SGJ_Settings.HideMinimap = not self:GetChecked(); MSC.UpdateMinimapPosition() end)

    local tooltipCheck = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate"); tooltipCheck:SetPoint("TOPLEFT", minimapCheck, "BOTTOMLEFT", 0, -5); tooltipCheck.Text:SetText("Show Verdict in Tooltips"); tooltipCheck:SetChecked(not SGJ_Settings.HideTooltips)
    tooltipCheck:SetScript("OnClick", function(self) SGJ_Settings.HideTooltips = not self:GetChecked() end)

    -- [[ NEW FEATURE: GEAR RECEIPT BUTTON ]] --
    local receiptBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    receiptBtn:SetPoint("TOPLEFT", tooltipCheck, "BOTTOMLEFT", 20, -20)
    receiptBtn:SetSize(200, 30)
    receiptBtn:SetText("Show Gear Receipt")
    receiptBtn:SetScript("OnClick", function() 
        if MSC.ShowReceipt then MSC.ShowReceipt() else print("Core module not ready.") end
    end)
    
    local credits = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); credits:SetPoint("BOTTOM", f, "BOTTOM", 0, 15); credits:SetTextColor(0.5, 0.5, 0.5, 1); credits:SetText("Author: SuperSharpie (v1.6.1)")
end