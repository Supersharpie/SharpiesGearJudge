local _, MSC = ...

-- =============================================================
-- 1. MINIMAP BUTTON (unchanged logic, cleaner formatting)
-- =============================================================
local MinimapButton = CreateFrame("Button", "MSC_MinimapButton", Minimap)
MinimapButton:SetSize(32, 32); MinimapButton:SetFrameStrata("MEDIUM"); MinimapButton:SetFrameLevel(8) 
MinimapButton.icon = MinimapButton:CreateTexture(nil, "BACKGROUND")
MinimapButton.icon:SetTexture("Interface\\Icons\\INV_Misc_Spyglass_02"); MinimapButton.icon:SetSize(20, 20); MinimapButton.icon:SetPoint("CENTER")
MinimapButton.border = MinimapButton:CreateTexture(nil, "OVERLAY")
MinimapButton.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder"); MinimapButton.border:SetSize(54, 54); MinimapButton.border:SetPoint("TOPLEFT")
MinimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

function MSC.UpdateMinimapPosition()
    if not SGJ_Settings then return end
    if SGJ_Settings.HideMinimap then MinimapButton:Hide(); return else MinimapButton:Show() end
    local angle = math.rad(SGJ_Settings.MinimapPos or 45)
    local x, y = math.cos(angle), math.sin(angle)
    MinimapButton:SetPoint("CENTER", Minimap, "CENTER", x * 80, y * 80)
end

MinimapButton:RegisterForClicks("AnyUp"); MinimapButton:RegisterForDrag("LeftButton")
MinimapButton:SetScript("OnDragStart", function(self) self:SetScript("OnUpdate", function(self) 
    local x, y = GetCursorPosition(); local scale = Minimap:GetEffectiveScale()
    local cx, cy = Minimap:GetCenter(); local dx, dy = (x / scale) - cx, (y / scale) - cy
    SGJ_Settings.MinimapPos = math.deg(math.atan2(dy, dx)); MSC.UpdateMinimapPosition() 
end) end)
MinimapButton:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
MinimapButton:SetScript("OnClick", function(self, button) 
    if button == "LeftButton" then if MSC.CreateLabFrame then MSC.CreateLabFrame() end else MSC.CreateOptionsFrame() end 
end)
MinimapButton:SetScript("OnEnter", function(self) 
    GameTooltip:SetOwner(self, "ANCHOR_LEFT"); GameTooltip:SetText("Sharpie's Gear Judge (TBC)")
    GameTooltip:AddLine("|cffffffffLeft-Click:|r Toggle Judge's Lab", 1, 1, 1)
    GameTooltip:AddLine("|cffffffffRight-Click:|r Toggle Settings", 1, 1, 1); GameTooltip:Show() 
end)
MinimapButton:SetScript("OnLeave", GameTooltip_Hide)


-- =============================================================
-- 2. OPTIONS MENU (The Refactored Layout)
-- =============================================================
function MSC.CreateOptionsFrame()
    if MyStatCompareFrame then 
        if MyStatCompareFrame:IsShown() then MyStatCompareFrame:Hide() else MyStatCompareFrame:Show() end
        return 
    end
    
    -- Main Window Setup
    local f = CreateFrame("Frame", "MyStatCompareFrame", UIParent, "BasicFrameTemplateWithInset, BackdropTemplate")
    f:SetSize(400, 480); f:SetPoint("CENTER")
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); f.title:SetPoint("LEFT", f.TitleBg, "LEFT", 5, 0); f.title:SetText("Sharpie's Gear Judge Configuration")

    -- [[ LAYOUT HELPER ]]
    -- This tracks the last element placed so we can just stack the next one below it.
    local lastObj = nil
    local function AddElement(obj, yOffset, customX)
        local x = customX or 20
        if not lastObj then
            obj:SetPoint("TOPLEFT", f, "TOPLEFT", x, yOffset or -40)
        else
            obj:SetPoint("TOPLEFT", lastObj, "BOTTOMLEFT", 0, yOffset or -10)
        end
        lastObj = obj
        return obj
    end

    -- [[ WIDGET CREATORS ]]
    local function CreateHeader(text)
        local h = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        h:SetText(text)
        return AddElement(h, -20)
    end
    
    local function CreateCheck(label, key, tooltip)
        local cb = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate")
        cb.Text:SetText(label)
        cb:SetChecked(not SGJ_Settings[key]) -- Note: Logic inverted for Hide vars or standard for others
        
        -- Logic to handle "Hide" variables vs "Show" variables
        if key:find("Hide") then cb:SetChecked(not SGJ_Settings[key]) else cb:SetChecked(SGJ_Settings[key]) end
        
        cb:SetScript("OnClick", function(self) 
            if key:find("Hide") then SGJ_Settings[key] = not self:GetChecked() else SGJ_Settings[key] = self:GetChecked() end
            if key == "HideMinimap" then MSC.UpdateMinimapPosition() end
        end)
        
        if tooltip then
            cb:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(tooltip, nil, nil, nil, nil, true); GameTooltip:Show() end)
            cb:SetScript("OnLeave", GameTooltip_Hide)
        end
        return AddElement(cb, -5)
    end

    local function CreateDropdown(label, key, options)
        local title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        title:SetText(label)
        AddElement(title, -15) -- Add title first
        
        local dd = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate")
        dd:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -15, -2) -- Offset slightly for alignment
        
        local function OnClick(self) 
            UIDropDownMenu_SetSelectedID(dd, self:GetID())
            SGJ_Settings[key] = self.value 
        end
        
        local function Init(self, level)
            for _, opt in ipairs(options) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = opt.text; info.value = opt.val; info.func = OnClick; 
                info.checked = (SGJ_Settings[key] == opt.val)
                UIDropDownMenu_AddButton(info, level)
            end
        end
        
        UIDropDownMenu_Initialize(dd, Init)
        UIDropDownMenu_SetWidth(dd, 200)
        
        -- Set current text safely
        local currentText = ""
        for _, opt in ipairs(options) do if SGJ_Settings[key] == opt.val then currentText = opt.text end end
        UIDropDownMenu_SetText(dd, currentText)
        
        lastObj = dd -- Update lastObj to the dropdown so next item goes below it
        return dd
    end


    -- =========================================================
    -- MENU CONTENT (The Easy Part)
    -- =========================================================
    
    -- SECTION 1: PROJECTION LOGIC
    CreateHeader("Projection Logic (TBC Features)")
    
    -- Enchant Dropdown
    CreateDropdown("Enchant Comparisons:", "EnchantMode", {
        { text = "Off (Raw Stats Only)", val = 1 },
        { text = "Compare Current Enchants", val = 2 },
        { text = "Project Best Enchants (Sim)", val = 3 },
    })
    
    -- Gem Dropdown
    CreateDropdown("Gem Socket Logic:", "GemMode", {
        { text = "Off (Empty Sockets = 0)", val = 1 },
        { text = "Compare Current Gems Only", val = 2 },
        { text = "Project Best (Match Colors)", val = 3 },
        { text = "Project Best (Ignore Colors)", val = 4 },
    })

    -- SECTION 2: PROFILE
    CreateHeader("Character Spec")
    
    -- Spec Dropdown (Dynamic based on class)
    local _, englishClass = UnitClass("player")
    local specOptions = { { text = "Auto-Detect", val = "Auto" } }
    
    if MSC.SpecNames and MSC.SpecNames[englishClass] then
        for i=1, 3 do table.insert(specOptions, { text = MSC.SpecNames[englishClass][i], val = MSC.SpecNames[englishClass][i] }) end
    end
    table.insert(specOptions, { text = "Leveling / Hybrid", val = "Hybrid" })
    if englishClass == "WARRIOR" or englishClass == "PALADIN" or englishClass == "DRUID" then
        table.insert(specOptions, { text = "Tank (Threat/Surv)", val = "Tank" })
    end
    
    CreateDropdown("Scoring Profile:", "Mode", specOptions)


    -- SECTION 3: INTERFACE
    CreateHeader("Interface Settings")
    CreateCheck("Show Minimap Button", "HideMinimap")
    CreateCheck("Show Verdict in Tooltips", "HideTooltips")
    
    -- SECTION 4: CREDITS
    local credits = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    credits:SetPoint("BOTTOM", f, "BOTTOM", 0, 15)
    credits:SetTextColor(0.5, 0.5, 0.5, 1)
    credits:SetText("Author: SuperSharpie (v2.0.0 - TBC)")
end