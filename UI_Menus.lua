local _, MSC = ...

-- 1. MINIMAP BUTTON
local MinimapButton = CreateFrame("Button", "MSC_MinimapButton", Minimap)
MinimapButton:SetSize(32, 32); MinimapButton:SetFrameStrata("MEDIUM"); MinimapButton:SetFrameLevel(8) 
MinimapButton.icon = MinimapButton:CreateTexture(nil, "BACKGROUND"); MinimapButton.icon:SetTexture("Interface\\Icons\\INV_Misc_Spyglass_02"); MinimapButton.icon:SetSize(20, 20); MinimapButton.icon:SetPoint("CENTER")
MinimapButton.border = MinimapButton:CreateTexture(nil, "OVERLAY"); MinimapButton.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
MinimapButton.border:SetSize(54, 54); MinimapButton.border:SetPoint("TOPLEFT"); MinimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

function MSC.UpdateMinimapPosition()
    if not SGJ_Settings then return end
    local angle = math.rad(SGJ_Settings.MinimapPos or 45)
    local x, y = math.cos(angle), math.sin(angle)
    MinimapButton:SetPoint("CENTER", Minimap, "CENTER", x * 80, y * 80)
end
MinimapButton:RegisterForClicks("AnyUp"); MinimapButton:RegisterForDrag("LeftButton")
MinimapButton:SetScript("OnDragStart", function(self) self:SetScript("OnUpdate", function(self) 
    local x, y = GetCursorPosition(); local scale = Minimap:GetEffectiveScale(); local cx, cy = Minimap:GetCenter()
    local dx, dy = (x / scale) - cx, (y / scale) - cy; SGJ_Settings.MinimapPos = math.deg(math.atan2(dy, dx)); MSC.UpdateMinimapPosition() 
end) end)
MinimapButton:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
MinimapButton:SetScript("OnClick", function(self, button) if button == "LeftButton" then MSC.CreateLabFrame() else MSC.CreateOptionsFrame() end end)
MinimapButton:SetScript("OnEnter", function(self) 
    GameTooltip:SetOwner(self, "ANCHOR_LEFT"); GameTooltip:SetText("Sharpie's Gear Judge")
    GameTooltip:AddLine("|cffffffffLeft-Click:|r Open Judge's Lab", 1, 1, 1); GameTooltip:AddLine("|cffffffffRight-Click:|r Settings", 1, 1, 1); GameTooltip:AddLine("|cffaaaaaa(Drag to move)|r"); GameTooltip:Show() 
end)
MinimapButton:SetScript("OnLeave", GameTooltip_Hide)

-- 2. SETTINGS GUI
function MSC.CreateOptionsFrame()
    if MyStatCompareFrame then MyStatCompareFrame:Show() return end
    local f = CreateFrame("Frame", "MyStatCompareFrame", UIParent, "BasicFrameTemplateWithInset, BackdropTemplate")
    f:SetSize(320, 380); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.title:SetPoint("LEFT", f.TitleBg, "LEFT", 5, 0); f.title:SetText("Sharpie's Gear Judge Options")
    
    local enchantCheck = CreateFrame("CheckButton", "SGJ_EnchantToggle", f, "ChatConfigCheckButtonTemplate")
    enchantCheck:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -40); enchantCheck.Text:SetText("Compare items with actual enchants")
    enchantCheck:SetChecked(SGJ_Settings.IncludeEnchants)
    enchantCheck:SetScript("OnClick", function(self)
        SGJ_Settings.IncludeEnchants = self:GetChecked()
        if self:GetChecked() then SGJ_Settings.ProjectEnchants = false; _G["SGJ_ProjectToggle"]:SetChecked(false) end
    end)

    local projectCheck = CreateFrame("CheckButton", "SGJ_ProjectToggle", f, "ChatConfigCheckButtonTemplate")
    projectCheck:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -75); projectCheck.Text:SetText("Apply current enchant to new loot")
    projectCheck:SetChecked(SGJ_Settings.ProjectEnchants)
    projectCheck:SetScript("OnClick", function(self)
        SGJ_Settings.ProjectEnchants = self:GetChecked()
        if self:GetChecked() then SGJ_Settings.IncludeEnchants = false; _G["SGJ_EnchantToggle"]:SetChecked(false) end
    end)

    local label = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("TOP", f, "TOP", 0, -115); label:SetText("--- Select Spec Profile ---")

    local function CreateButton(text, mode, yOffset)
        local btn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        btn:SetPoint("TOP", f, "TOP", 0, yOffset); btn:SetSize(150, 30); btn:SetText(text)
        btn:SetScript("OnClick", function() SGJ_Settings.Mode = mode; print("|cff00ff00Sharpie:|r Profile set to " .. text); f:Hide() end)
    end
    CreateButton("Auto-Detect", "Auto", -135)
    local _, englishClass = UnitClass("player")
    if MSC.SpecNames[englishClass] then
        CreateButton(MSC.SpecNames[englishClass][1], MSC.SpecNames[englishClass][1], -170)
        CreateButton(MSC.SpecNames[englishClass][2], MSC.SpecNames[englishClass][2], -205)
        CreateButton(MSC.SpecNames[englishClass][3], MSC.SpecNames[englishClass][3], -240)
    end
    CreateButton("Hybrid / PvP", "Hybrid", -285)
    local credits = f:CreateFontString(nil, "OVERLAY", "GameFontTiny")
    credits:SetPoint("BOTTOM", f, "BOTTOM", 0, 10); credits:SetTextColor(0.6, 0.6, 0.6, 1); credits:SetText("Special Thanks: [Your Testers]")
end