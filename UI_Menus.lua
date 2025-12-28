local _, MSC = ...

-- =========================================================================
-- 1. MINIMAP BUTTON
-- =========================================================================
local MinimapButton = CreateFrame("Button", "MSC_MinimapButton", Minimap)
MinimapButton:SetSize(32, 32)
MinimapButton:SetFrameStrata("MEDIUM")
MinimapButton:SetFrameLevel(8) 
MinimapButton.icon = MinimapButton:CreateTexture(nil, "BACKGROUND")
MinimapButton.icon:SetTexture("Interface\\Icons\\INV_Hammer_17")
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

-- =========================================================================
-- 2. CONFIGURATION PANEL (The UI)
-- =========================================================================
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

    -- [[ HELPER: Spec Name Cleaner ]] --
    local function GetDisplayName(specKey)
        local _, class = UnitClass("player")
        -- Remove "Auto: " prefix if passed accidentally, remove spaces for key lookup
        local cleanKey = specKey:gsub("Auto: ", ""):gsub("%s+", "")
        
        -- Check Database for Pretty Name
        if MSC.PrettyNames and MSC.PrettyNames[class] and MSC.PrettyNames[class][cleanKey] then
            return MSC.PrettyNames[class][cleanKey]
        end
        return specKey -- Fallback to raw key
    end

    local function CreateHeader(text, relativeTo, yOffset)
        local h = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); h:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, yOffset); h:SetText(text); return h
    end
    local function CreateDesc(text, relativeTo)
        local d = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); d:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 20, -5); d:SetWidth(340); d:SetJustifyH("LEFT"); d:SetText(text); d:SetTextColor(0.7, 0.7, 0.7); return d
    end

    -- 1. MODE SELECTION
    local header1 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); header1:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -40); header1:SetText("Comparison Mode")
    
    local strictCheck = CreateFrame("CheckButton", "SGJ_StrictCheck", f, "ChatConfigCheckButtonTemplate"); strictCheck:SetPoint("TOPLEFT", header1, "BOTTOMLEFT", 0, -10); strictCheck.Text:SetText("Strict Mode (No Enchants)"); strictCheck:SetChecked(SGJ_Settings.IncludeEnchants)
    local strictDesc = CreateDesc("Compares items exactly as they are.", strictCheck)
    
    local potentialCheck = CreateFrame("CheckButton", "SGJ_PotentialCheck", f, "ChatConfigCheckButtonTemplate"); potentialCheck:SetPoint("TOPLEFT", strictDesc, "BOTTOMLEFT", -20, -15); potentialCheck.Text:SetText("Potential Mode (Simulate Enchants)"); potentialCheck:SetChecked(SGJ_Settings.ProjectEnchants)
    local potentialDesc = CreateDesc("Virtually applies your current enchant to the new item.", potentialCheck)

    strictCheck:SetScript("OnClick", function(self) if self:GetChecked() then SGJ_Settings.IncludeEnchants=true; SGJ_Settings.ProjectEnchants=false; potentialCheck:SetChecked(false) end end)
    potentialCheck:SetScript("OnClick", function(self) if self:GetChecked() then SGJ_Settings.ProjectEnchants=true; SGJ_Settings.IncludeEnchants=false; strictCheck:SetChecked(false) end end)

    -- 2. PROFILE DROPDOWN
    local header2 = CreateHeader("Character Profile", potentialDesc, -25)
    local dropDown = CreateFrame("Frame", "SGJ_SpecDropDown", f, "UIDropDownMenuTemplate"); dropDown:SetPoint("TOPLEFT", header2, "BOTTOMLEFT", -15, -10)
    
    local function UpdateDropDownText()
        if SGJ_Settings.Mode == "AUTO" or SGJ_Settings.Mode == "Auto" then
             local _, detectedKey = MSC.GetCurrentWeights()
             UIDropDownMenu_SetText(dropDown, "Auto: " .. GetDisplayName(detectedKey))
        else
             UIDropDownMenu_SetText(dropDown, "Manual: " .. GetDisplayName(SGJ_Settings.Mode))
        end
    end

    local function OnClick(self) 
        SGJ_Settings.Mode = self.value
        MSC.ManualSpec = self.value 
        UpdateDropDownText() 
        print("|cff00ccffSharpie:|r Profile changed to " .. GetDisplayName(self.value))
    end

    local function Initialize(self, level)
        local info = UIDropDownMenu_CreateInfo()
        info.text = "Auto-Detect"; info.value = "AUTO"; info.func = OnClick; info.checked = (SGJ_Settings.Mode == "AUTO"); UIDropDownMenu_AddButton(info)

        local _, class = UnitClass("player")
        local sortedKeys = {}
        
        -- [[ COMBINE BOTH DATABASES FOR MENU ]] --
        
        -- 1. Add Endgame Specs
        if MSC.WeightDB and MSC.WeightDB[class] then
            for k in pairs(MSC.WeightDB[class]) do 
                if k ~= "Default" then table.insert(sortedKeys, k) end 
            end
        end
        
        -- 2. Add Leveling Specs
        if MSC.LevelingWeightDB and MSC.LevelingWeightDB[class] then
            for k in pairs(MSC.LevelingWeightDB[class]) do 
                if k ~= "Default" then table.insert(sortedKeys, k) end 
            end
        end
        
        table.sort(sortedKeys)

        info = UIDropDownMenu_CreateInfo(); info.text = "--- Manual Selection ---"; info.isTitle = true; info.notCheckable = true; UIDropDownMenu_AddButton(info)

        for _, key in ipairs(sortedKeys) do
            info = UIDropDownMenu_CreateInfo()
            info.text = GetDisplayName(key)
            info.value = key
            info.func = OnClick
            info.checked = (SGJ_Settings.Mode == key)
            UIDropDownMenu_AddButton(info)
        end
    end
    
    UIDropDownMenu_Initialize(dropDown, Initialize)
    UIDropDownMenu_SetWidth(dropDown, 250)
    UpdateDropDownText() 

    -- 3. INTERFACE SETTINGS
    local header3 = CreateHeader("Interface Settings", dropDown, -25)
    
    local minimapCheck = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate"); minimapCheck:SetPoint("TOPLEFT", header3, "BOTTOMLEFT", 0, -10); minimapCheck.Text:SetText("Show Minimap Button"); minimapCheck:SetChecked(not SGJ_Settings.HideMinimap)
    minimapCheck:SetScript("OnClick", function(self) SGJ_Settings.HideMinimap = not self:GetChecked(); MSC.UpdateMinimapPosition() end)
    
    local tooltipCheck = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate"); tooltipCheck:SetPoint("TOPLEFT", minimapCheck, "BOTTOMLEFT", 0, -5); tooltipCheck.Text:SetText("Show Verdict in Tooltips"); tooltipCheck:SetChecked(not SGJ_Settings.HideTooltips)
    tooltipCheck:SetScript("OnClick", function(self) SGJ_Settings.HideTooltips = not self:GetChecked() end)

    -- [[ 4. RECEIPT & HISTORY BUTTONS ]] --
    local receiptBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    receiptBtn:SetPoint("TOPLEFT", tooltipCheck, "BOTTOMLEFT", 20, -20)
    receiptBtn:SetSize(200, 30)
    receiptBtn:SetText("Show Gear Receipt")
    receiptBtn:SetScript("OnClick", function() 
        f:Hide() -- Auto-Close Options
        if MSC.ShowReceipt then MSC.ShowReceipt() else print("Core module not ready.") end
    end)
    
    local historyBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    historyBtn:SetPoint("TOPLEFT", receiptBtn, "BOTTOMLEFT", 0, -10)
    historyBtn:SetSize(200, 30)
    historyBtn:SetText("View Transaction History")
    historyBtn:SetScript("OnClick", function() 
        f:Hide()
        if MSC.ShowHistory then MSC.ShowHistory() else print("Core module not ready.") end
    end)

    local credits = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); credits:SetPoint("BOTTOM", f, "BOTTOM", 0, 15); credits:SetTextColor(0.5, 0.5, 0.5); credits:SetText("Author: Supersharpie (v1.9.0)")

    -- [[ ON SHOW REFRESH ]] --
    f:SetScript("OnShow", function(self)
        MSC:BuildTalentCache()
        UpdateDropDownText()
    end)
end