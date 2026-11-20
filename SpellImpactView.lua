-- =============================================================
-- SPELL IMPACT TAB (WoW Forever, core 3.6.0)
-- =============================================================
-- A tab in the /sgj window (where the old Combat Lab tab sat): the Spell
-- Impact options (left), the Live Spell Matrix of your spells with the gear
-- you wear, ticks picking the tooltip rows (centre), and an item compared
-- against them (right). /sgj spells opens it. The math is SpellImpact.lua's.

local _, MSC = ...
if not MSC.IsForever then return end
local L = MSC.L
local math_max, math_min, string_format = math.max, math.min, string.format
local ipairs, pairs, select, tonumber = ipairs, pairs, select, tonumber

local VIEW_KEY = "ViewSpellImpact"
local LEFT_W, RIGHT_W = 220, 260
local ROW_H = 22
local MAX_COMPARE = 12

local ROLE_NAMES = { auto = "From profile", dmg = "Spells", heal = "Heals", melee = "Melee", bear = "Bear" }
local TARGET_NAMES = { [0] = "Your level", "+1 level", "+2 levels", "Boss (+3)" }

local function T(k) return L[k] end

local function SpellIcon(id)
    if not id then return nil end
    if C_Spell and C_Spell.GetSpellTexture then return C_Spell.GetSpellTexture(id) end
    return GetSpellTexture and GetSpellTexture(id) or nil
end

local function ProfileName()
    local _, specName = MSC.GetCurrentWeights()
    local cc = MSC.CurrentClass
    return (cc and cc.PrettyNames and cc.PrettyNames[specName]) or specName or "?", specName
end

-- ==========================================
-- COMPARING AN ITEM
-- ==========================================
-- Lines for an item you don't wear: nil and a reason when it can't be compared
local function ItemLines(link)
    if not link then return nil end
    if IsEquippableItem and not IsEquippableItem(link) then return nil, "slot" end
    local equipLoc = select(9, GetItemInfo(link))
    if not equipLoc then return nil, "loading" end
    local weights, specName = MSC.GetCurrentWeights()
    if not weights then return nil end
    local slot = MSC.GetComparisonSlot and MSC.GetComparisonSlot(link, equipLoc, weights, specName)
    if not slot then return nil, "slot" end
    local _, _, newStats, oldStats = MSC:EvaluateUpgrade(link, slot, weights, specName)
    return (MSC.SpellImpactLines(link, slot, newStats, oldStats, weights, specName, true))
end

-- ==========================================
-- BUILD
-- ==========================================
local function InitView(parent)
    local f = CreateFrame("Frame", nil, parent); f:SetAllPoints(); f:Hide()
    local Th = MSC.Theme

    local Lc = CreateFrame("Frame", nil, f)
    Lc:SetPoint("TOPLEFT"); Lc:SetPoint("BOTTOMLEFT"); Lc:SetWidth(LEFT_W)
    local Rc = CreateFrame("Frame", nil, f)
    Rc:SetPoint("TOPRIGHT"); Rc:SetPoint("BOTTOMRIGHT"); Rc:SetWidth(RIGHT_W)
    local Cc = CreateFrame("Frame", nil, f)
    Cc:SetPoint("TOPLEFT", Lc, "TOPRIGHT"); Cc:SetPoint("BOTTOMRIGHT", Rc, "BOTTOMLEFT")
    for _, col in ipairs({ Lc, Rc }) do
        local shade = col:CreateTexture(nil, "BACKGROUND"); shade:SetAllPoints(); shade:SetColorTexture(0, 0, 0, 0.25)
    end
    local function Divider(col, side)
        local t = col:CreateTexture(nil, "BORDER"); t:SetColorTexture(1, 1, 1, 0.08); t:SetWidth(1)
        t:SetPoint("TOP" .. side, 0, 0); t:SetPoint("BOTTOM" .. side, 0, 0)
    end
    Divider(Lc, "RIGHT"); Divider(Rc, "LEFT")

    local function Heading(col, text, color, width, anchor, y)
        local h = col:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        if anchor then h:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, y or -18) else h:SetPoint("TOPLEFT", 14, -12) end
        h:SetText(text); MSC.StyleHeading(h, color, width)
        return h
    end
    local function Tip(frame, title, text)
        frame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(title, 1, 1, 1)
            if text then GameTooltip:AddLine(text, nil, nil, nil, true) end
            GameTooltip:Show()
        end)
        frame:SetScript("OnLeave", GameTooltip_Hide)
    end

    -- ==========================================
    -- LEFT: OPTIONS
    -- ==========================================
    local innerL = LEFT_W - 28
    local hOpt = Heading(Lc, T("Spell Impact"), "Gold", innerL)
    local controls = {}

    local function Check(label, tip, anchor, y, get, set)
        local cb = CreateFrame("CheckButton", nil, Lc, "UICheckButtonTemplate")
        cb:SetSize(24, 24)
        cb:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, y or -6)
        cb.Label = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        cb.Label:SetPoint("LEFT", cb, "RIGHT", 2, 0); cb.Label:SetWidth(innerL - 28); cb.Label:SetJustifyH("LEFT")
        cb.Label:SetText(label)
        cb.Sync = function() cb:SetChecked(get() and true or false) end
        cb:SetScript("OnClick", function(self) set(self:GetChecked() and true or false); f.Refresh() end)
        Tip(cb, label, tip)
        controls[#controls + 1] = cb
        return cb
    end
    -- a button that steps through choices on click (right-click steps back)
    local function Cycle(fmt, tip, anchor, y, choices, get, set)
        local b = CreateFrame("Button", nil, Lc, "UIPanelButtonTemplate")
        b:SetSize(innerL, 22); b:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, y or -8)
        b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        b.Sync = function()
            local list, cur = choices(), get()
            local label = cur
            for _, c in ipairs(list) do if c.value == cur then label = c.text end end
            b:SetText(string_format(fmt, label))
        end
        b:SetScript("OnClick", function(self, button)
            local list, cur, idx = choices(), get(), 1
            for i, c in ipairs(list) do if c.value == cur then idx = i end end
            idx = idx + ((button == "RightButton") and -1 or 1)
            if idx > #list then idx = 1 elseif idx < 1 then idx = #list end
            set(list[idx].value); b.Sync(); f.Refresh()
        end)
        Tip(b, string_format(fmt, ""), tip)
        controls[#controls + 1] = b
        return b
    end
    local function O() return MSC.SpellImpactOptions() end

    local cbShow = Check(T("Show in tooltips"), T("Adds the Spell Impact block to item tooltips (the same switch as Show Spell Impact in the settings)."),
        hOpt, -14, function() return SGJ_Settings and SGJ_Settings.ShowSpellImpact end,
        function(v) if SGJ_Settings then SGJ_Settings.ShowSpellImpact = v end end)
    local bRows = Cycle(T("Rows: %s"), T("Which spells to list. From profile follows your scoring profile: heals for healers, melee for Retribution, Enhancement and Feral, spells for the rest."),
        cbShow, -10, function()
            local _, class = UnitClass("player")
            local list = { { value = "auto", text = T(ROLE_NAMES.auto) } }
            for _, r in ipairs(MSC.SpellImpactRoles(class)) do list[#list + 1] = { value = r, text = T(ROLE_NAMES[r]) } end
            return list
        end, function() return O().rows end, function(v) O().rows = v end)
    local bMax = Cycle(T("Tooltip rows: %s"), T("How many spells the tooltip lists (auto-attack and the most efficient rank don't count)."),
        bRows, -6, function()
            local list = {}
            for i = 1, 6 do list[i] = { value = i, text = tostring(i) } end
            return list
        end, function() return O().maxRows end, function(v) O().maxRows = v end)
    local bTarget = Cycle(T("Target: %s"), T("The mob your hit chance is worked out against: spells miss 4% of your level, 5% +1, 6% +2 and 17% against a boss (+3)."),
        bMax, -6, function()
            local list = {}
            for i = 0, 3 do list[#list + 1] = { value = i, text = T(TARGET_NAMES[i]) } end
            return list
        end, function() return O().target end, function(v) O().target = v end)
    local cbEff = Check(T("Most efficient heal rank"), T("Healers: also shows the rank you know that heals the most per mana, for downranking."),
        bTarget, -10, function() return O().efficient end, function(v) O().efficient = v end)
    local cbExtra = Check(T("Count extra targets"), T("Chain Lightning and Chain Heal jumps, Multi-Shot and Swipe count 3 targets at the game's own scaling; Holy Wrath counts 3 mobs."),
        cbEff, -2, function() return O().extraTargets end, function(v) O().extraTargets = v end)
    local cbRank = Check(T("Show spell rank"), T("Shows each spell's rank next to its name."),
        cbExtra, -2, function() return O().showRank end, function(v) O().showRank = v end)

    local note = Lc:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    note:SetPoint("TOPLEFT", cbRank, "BOTTOMLEFT", 2, -16); note:SetWidth(innerL); note:SetJustifyH("LEFT")
    note:SetTextColor(0.7, 0.7, 0.7)
    note:SetText(T("Before talents: they move both numbers the same, so better or worse stays right. Mana cost and cast time come from the game, with your rank and talents."))

    local bReset = CreateFrame("Button", nil, Lc, "UIPanelButtonTemplate")
    bReset:SetSize(innerL, 24); bReset:SetPoint("BOTTOMLEFT", 14, 14); bReset:SetText(T("Reset to Defaults"))
    bReset:SetScript("OnClick", function() MSC.ResetSpellImpactOptions(); for _, c in ipairs(controls) do c.Sync() end; f.Refresh() end)

    -- ==========================================
    -- CENTRE: LIVE SPELL MATRIX
    -- ==========================================
    local hMat = Cc:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    hMat:SetPoint("TOPLEFT", 14, -12); hMat:SetPoint("RIGHT", -14, 0); hMat:SetJustifyH("LEFT"); hMat:SetWordWrap(false)
    hMat:SetTextColor(unpack(Th.Section.Blue))
    local matDesc = Cc:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    matDesc:SetPoint("TOPLEFT", hMat, "BOTTOMLEFT", 0, -6); matDesc:SetPoint("RIGHT", -14, 0); matDesc:SetJustifyH("LEFT")
    matDesc:SetTextColor(0.7, 0.7, 0.7)
    matDesc:SetText(T("Your spells with the gear you wear. Tick a spell to show it in tooltips."))

    local bRecalc = CreateFrame("Button", nil, Cc, "UIPanelButtonTemplate")
    bRecalc:SetSize(110, 22); bRecalc:SetPoint("TOPRIGHT", -14, -46); bRecalc:SetText(T("Recalculate"))
    bRecalc:SetScript("OnClick", function() if MSC.ResetSpellImpactCache then MSC.ResetSpellImpactCache() end; f.Refresh() end)

    -- column headers
    local COLS = { { key = "Per cast", x = -128 }, { key = "Per sec", x = -70 }, { key = "Per mana", x = -14 } }
    local hdr = CreateFrame("Frame", nil, Cc); hdr:SetHeight(16)
    hdr:SetPoint("TOPLEFT", 14, -74); hdr:SetPoint("TOPRIGHT", -36, -74)
    local hSpell = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); hSpell:SetPoint("LEFT", 26, 0); hSpell:SetText(T("Spell"))
    hSpell:SetTextColor(unpack(Th.Muted))
    for _, c in ipairs(COLS) do
        local fs = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); fs:SetPoint("RIGHT", c.x, 0)
        fs:SetWidth(56); fs:SetJustifyH("RIGHT"); fs:SetText(T(c.key)); fs:SetTextColor(unpack(Th.Muted))
    end

    local bg = CreateFrame("Frame", nil, Cc, "BackdropTemplate")
    bg:SetPoint("TOPLEFT", 10, -92); bg:SetPoint("BOTTOMRIGHT", -10, 14)
    if bg.SetBackdrop then
        bg:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
        bg:SetBackdropColor(0, 0, 0, 0.35); bg:SetBackdropBorderColor(unpack(Th.Edge))
    end
    local sf = CreateFrame("ScrollFrame", nil, bg, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT", 4, -4); sf:SetPoint("BOTTOMRIGHT", -26, 4)
    local child = CreateFrame("Frame", nil, sf); child:SetSize(10, 10); sf:SetScrollChild(child)
    sf:SetScript("OnSizeChanged", function(self, w) child:SetWidth(w) end)
    local empty = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    empty:SetPoint("TOPLEFT", 6, -8); empty:SetPoint("RIGHT", -6, 0); empty:SetJustifyH("LEFT")
    empty:SetTextColor(0.7, 0.7, 0.7); empty:SetText(T("No spells to show yet: learn one of your class's main spells."))

    local rows = {}
    local function MatrixRow(i)
        if rows[i] then return rows[i] end
        local r = CreateFrame("Frame", nil, child); r:SetHeight(ROW_H)
        r:SetPoint("TOPLEFT", 0, -(i - 1) * ROW_H); r:SetPoint("RIGHT", child, "RIGHT", 0, 0)
        r.Stripe = r:CreateTexture(nil, "BACKGROUND"); r.Stripe:SetAllPoints(); r.Stripe:SetColorTexture(1, 1, 1, (i % 2 == 0) and 0.03 or 0)
        r.Check = CreateFrame("CheckButton", nil, r, "UICheckButtonTemplate"); r.Check:SetSize(20, 20); r.Check:SetPoint("LEFT", 0, 0)
        r.Check:SetScript("OnClick", function(self)
            local o = MSC.SpellImpactOptions()
            if r.key then o.hidden[r.key] = (not self:GetChecked()) or nil end
        end)
        r.Icon = r:CreateTexture(nil, "ARTWORK"); r.Icon:SetSize(16, 16); r.Icon:SetPoint("LEFT", 22, 0)
        r.Name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); r.Name:SetPoint("LEFT", r.Icon, "RIGHT", 4, 0)
        r.Name:SetPoint("RIGHT", r, "RIGHT", -184, 0); r.Name:SetJustifyH("LEFT"); r.Name:SetWordWrap(false)
        r.Vals = {}
        for k, c in ipairs(COLS) do
            local fs = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); fs:SetPoint("RIGHT", c.x, 0)
            fs:SetWidth(56); fs:SetJustifyH("RIGHT"); fs:SetTextColor(unpack(Th.Value))
            r.Vals[k] = fs
        end
        -- hover: the game's spell tooltip, then cast time and cost
        r:EnableMouse(true)
        r:SetScript("OnEnter", function(self)
            if not self.line then return end
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if self.line.spellId and GameTooltip.SetSpellByID then GameTooltip:SetSpellByID(self.line.spellId) else GameTooltip:SetText(self.line.name or "", 1, 1, 1) end
            local l = self.line
            if l.cast then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(l.cast > 0 and string_format(T("Cast: %.1f s"), l.cast) or T("Instant"), 0.8, 0.8, 0.8)
            end
            if l.cost and l.cost > 0 then GameTooltip:AddLine(string_format(T("Mana: %d"), l.cost), 0.8, 0.8, 0.8) end
            GameTooltip:Show()
        end)
        r:SetScript("OnLeave", GameTooltip_Hide)
        rows[i] = r
        return r
    end

    local function DrawMatrix()
        local pretty = ProfileName()
        local weights, specName = MSC.GetCurrentWeights()
        hMat:SetText(string_format(T("Live Spell Matrix: %s"), pretty))
        local lines = MSC.SpellImpactLines(nil, nil, nil, nil, weights, specName, true)
        local o = MSC.SpellImpactOptions()
        for i, l in ipairs(lines) do
            local r = MatrixRow(i)
            r.line, r.key = l, l.key
            r.Check:SetShown(not l.efficient)
            r.Check:SetChecked(not o.hidden[l.key])
            r.Icon:SetTexture(SpellIcon(l.spellId))
            r.Name:SetText(MSC.SpellImpactLabel(l))
            local F = MSC.SpellImpactFormat
            if l.white then
                r.Vals[1]:SetText("-"); r.Vals[2]:SetText(F(l.a[1])); r.Vals[3]:SetText("-")
            else
                r.Vals[1]:SetText(F(l.a[1])); r.Vals[2]:SetText(F(l.a[2])); r.Vals[3]:SetText(F(l.a[3], true))
            end
            r:Show()
        end
        for i = #lines + 1, #rows do rows[i]:Hide(); rows[i].line = nil end
        empty:SetShown(#lines == 0)
        child:SetHeight(math_max(10, #lines * ROW_H))
    end

    -- ==========================================
    -- RIGHT: COMPARE AN ITEM
    -- ==========================================
    local innerR = RIGHT_W - 28
    local hCmp = Heading(Rc, T("Compare an Item"), "Green", innerR)
    local slot = CreateFrame("Button", nil, Rc)
    slot:SetSize(40, 40); slot:SetPoint("TOPLEFT", hCmp, "BOTTOMLEFT", 0, -14)
    slot.Empty = slot:CreateTexture(nil, "BACKGROUND", nil, -1); slot.Empty:SetAllPoints()
    slot.Empty:SetTexture("Interface\\Paperdoll\\UI-Backpack-EmptySlot")
    slot.Icon = slot:CreateTexture(nil, "ARTWORK"); slot.Icon:SetAllPoints()
    MSC.CreateModernBorder(slot, 1)
    local itemName = Rc:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    itemName:SetPoint("TOPLEFT", slot, "TOPRIGHT", 8, -2); itemName:SetWidth(innerR - 48); itemName:SetJustifyH("LEFT")
    local itemSub = Rc:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    itemSub:SetPoint("TOPLEFT", itemName, "BOTTOMLEFT", 0, -3); itemSub:SetWidth(innerR - 48); itemSub:SetJustifyH("LEFT")
    itemSub:SetTextColor(0.6, 0.6, 0.6)

    local cmpHelp = Rc:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    cmpHelp:SetPoint("TOPLEFT", slot, "BOTTOMLEFT", 0, -10); cmpHelp:SetWidth(innerR); cmpHelp:SetJustifyH("LEFT")
    cmpHelp:SetTextColor(0.7, 0.7, 0.7)
    cmpHelp:SetText(T("Drag an item here or shift-click a link. Empty: the last item you hovered."))

    local cmpHead = Rc:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    cmpHead:SetPoint("TOPLEFT", cmpHelp, "BOTTOMLEFT", 0, -12); cmpHead:SetText(T("now > with this item")); cmpHead:SetTextColor(unpack(Th.Muted))
    local cmpLines = {}
    for i = 1, MAX_COMPARE do
        local n = Rc:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        n:SetPoint("TOPLEFT", i == 1 and cmpHead or cmpLines[i - 1].V, "BOTTOMLEFT", 0, i == 1 and -8 or -7)
        n:SetWidth(innerR); n:SetJustifyH("LEFT"); n:SetWordWrap(false)
        local v = Rc:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        v:SetPoint("TOPLEFT", n, "BOTTOMLEFT", 8, -2); v:SetWidth(innerR - 8); v:SetJustifyH("LEFT")
        cmpLines[i] = { N = n, V = v }
    end
    local cmpMsg = Rc:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    cmpMsg:SetPoint("TOPLEFT", cmpHead, "BOTTOMLEFT", 0, -8); cmpMsg:SetWidth(innerR); cmpMsg:SetJustifyH("LEFT"); cmpMsg:SetTextColor(0.7, 0.7, 0.7)

    local bClear = CreateFrame("Button", nil, Rc, "UIPanelButtonTemplate")
    bClear:SetSize(innerR, 24); bClear:SetPoint("BOTTOMLEFT", 14, 14); bClear:SetText(T("Clear"))

    f.pinned = nil   -- an item put in the box; nil = the last item hovered
    local function DrawCompare()
        local link = f.pinned or MSC.SpellImpactLastLink
        for _, c in ipairs(cmpLines) do c.N:SetText(""); c.V:SetText("") end
        cmpMsg:SetText("")
        if not link then
            slot.Icon:SetTexture(nil); itemName:SetText(""); itemSub:SetText("")
            cmpMsg:SetText(T("Hover an item or drag one into the box."))
            return
        end
        slot.Icon:SetTexture(GetItemIcon and GetItemIcon(link) or nil)
        itemName:SetText(link)
        itemSub:SetText(f.pinned and "" or T("Last hovered"))
        local lines, why = ItemLines(link)
        if not lines then
            cmpMsg:SetText(why == "loading" and T("Loading item...") or T("This item doesn't go in a slot you can compare."))
            return
        end
        local o, shown = MSC.SpellImpactOptions(), 0
        for _, l in ipairs(lines) do
            if shown < MAX_COMPARE and (not o.hidden[l.key] or l.efficient) then
                local text = MSC.SpellImpactValueText(l)
                if text then
                    shown = shown + 1
                    cmpLines[shown].N:SetText(MSC.SpellImpactLabel(l)); cmpLines[shown].V:SetText(text)
                end
            end
        end
        if shown == 0 then cmpMsg:SetText(T("No spells to show yet: learn one of your class's main spells.")) end
    end

    local function Pin(link) f.pinned = link; DrawCompare() end
    slot:RegisterForClicks("AnyUp")
    slot:SetScript("OnClick", function()
        local kind, _, link = GetCursorInfo()
        if kind == "item" then Pin(link); ClearCursor() elseif IsShiftKeyDown() then Pin(nil) end
    end)
    slot:SetScript("OnReceiveDrag", function()
        local kind, _, link = GetCursorInfo()
        if kind == "item" then Pin(link); ClearCursor() end
    end)
    slot:SetScript("OnEnter", function(self)
        local link = f.pinned or MSC.SpellImpactLastLink
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if link then GameTooltip:SetHyperlink(link) else GameTooltip:SetText(T("Compare an Item"), 1, 1, 1) end
        GameTooltip:Show()
    end)
    slot:SetScript("OnLeave", GameTooltip_Hide)
    bClear:SetScript("OnClick", function() Pin(nil) end)
    f.Pin = Pin

    -- ==========================================
    -- REFRESH
    -- ==========================================
    function f.Refresh()
        if not f:IsShown() then return end
        DrawMatrix(); DrawCompare()
    end
    f.DrawCompare = DrawCompare
    f:SetScript("OnShow", function() for _, c in ipairs(controls) do c.Sync() end; f.Refresh() end)
    for _, c in ipairs(controls) do c.Sync() end

    MSC[VIEW_KEY] = f
    return f
end

-- The hovered item changes while the tab is open (an unpinned box follows it)
function MSC.OnSpellImpactHover()
    local v = MSC[VIEW_KEY]
    if v and v:IsShown() and not v.pinned and v.DrawCompare then v.DrawCompare() end
end

function MSC.UpdateSpellImpactView()
    local v = MSC[VIEW_KEY]
    if v and v.Refresh then v.Refresh() end
end

-- Opens the /sgj window on this tab
function MSC.OpenSpellImpact()
    for i, tab in ipairs(MSC.RegisteredTabs or {}) do
        if tab.view == VIEW_KEY then MSC.OpenMainWindow(i); return end
    end
end

if MSC.RegisterPluginTab then
    MSC.RegisterPluginTab(L["Spell Impact"], "Interface\\Icons\\Spell_Holy_MagicalSentry", InitView, VIEW_KEY, "UpdateSpellImpactView")
end

-- Shift-click a link while the tab is open puts it in the box (one shift-click runs both hooks; the same link
-- within the same frame counts once)
local lastPin, lastPinTime
local function PinOnce(link)
    local v = MSC[VIEW_KEY]
    if not (v and v:IsShown() and v.Pin) then return end
    if type(link) ~= "string" or not link:find("item:") then return end
    local now = GetTime()
    if lastPin == link and lastPinTime == now then return end
    lastPin, lastPinTime = link, now
    v.Pin(link)
end
if HandleModifiedItemClick then hooksecurefunc("HandleModifiedItemClick", function(link) if link and IsShiftKeyDown() then PinOnce(link) end end) end
if ChatEdit_InsertLink then hooksecurefunc("ChatEdit_InsertLink", function(link) if link then PinOnce(link) end end) end

-- Gear, level, spells or talents change while the tab is open: draw again (once a frame at most)
local ev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_EQUIPMENT_CHANGED", "PLAYER_LEVEL_UP", "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB", "GET_ITEM_INFO_RECEIVED", "TRAIT_CONFIG_UPDATED", "UNIT_AURA" }) do
    pcall(ev.RegisterEvent, ev, e)
end
local pending = false
ev:SetScript("OnEvent", function(_, event, unit)
    if event == "UNIT_AURA" and unit ~= "player" then return end
    local v = MSC[VIEW_KEY]
    if not (v and v:IsShown()) or pending then return end
    pending = true
    C_Timer.After(0.2, function() pending = false; MSC.UpdateSpellImpactView() end)
end)
