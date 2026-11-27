local _, MSC = ...
local L = MSC.L

-- =============================================================
-- ENCHANTERS (3.9.0)
-- =============================================================
-- 1. Enchant recipe tooltips: what the enchant is worth on the item you wear in
--    that slot (and for your off-specs and alts), against the enchant already on it.
--    A recipe's ID is its spell ID; MSC.EnchantDB records each recipe's spell.
-- 2. The best recipe per slot in Daylight UI's profession list gets the green arrow
--    (Interface.lua, MarkRows).
-- 3. Projected Enchant says whether you know the recipe (Judge.lua), and the option
--    "Enchanters: suggest only enchants I can make" (Helpers GetBestEnchantForSlot).
-- 4. Safe to disenchant: bag gear that is no upgrade for you, your off-specs or your
--    alts (MSC.Enchanting.SafeToDisenchant, drawn by the bag overlays).
-- Known recipes are read when the Enchanting window opens and kept per character
-- (SharpiesGearJudgeDB.enchanting[GUID]), plus IsPlayerSpell for the ones the game
-- reports itself.
-- =============================================================
local E = {}
MSC.Enchanting = E

local ENCHANTING_LINE = 333
local ENCHANTING_SPELL = 7411   -- "Enchanting" (its name is the skill line's name in the player's language)

-- ---------------------------------------------------------------
-- Recipe spell -> enchant, and the slots an enchant goes on
-- ---------------------------------------------------------------
-- spellSlots (2026-11-27): the slots a recipe itself enchants. An enchant made by several recipes, one per slot (Enchant
-- Chest - Stamina, Enchant Bracer - Lesser Stamina, Enchant Boots - Lesser Stamina all give +4 Stamina), lists each slot's
-- own recipe in Enchants_*.lua (spells); a recipe's tooltip shows only its own slots.
local bySpell, slotsOf, spellSlots
local function BuildMaps()
    bySpell, slotsOf, spellSlots = {}, {}, {}
    for id, d in pairs(MSC.EnchantDB or {}) do
        if d.spell then bySpell[d.spell] = id end
        if d.spells then for _, sp in pairs(d.spells) do bySpell[sp] = id end end
    end
    for slot, ids in pairs(MSC.EnchantCandidates or {}) do
        for _, id in ipairs(ids) do
            local t = slotsOf[id] or {}
            t[#t + 1] = slot
            slotsOf[id] = t
            local sp = MSC.EnchantSpellFor(MSC.EnchantDB[id], slot)
            if sp then local u = spellSlots[sp] or {}; u[#u + 1] = slot; spellSlots[sp] = u end
        end
    end
    for _, t in pairs(slotsOf) do table.sort(t) end
    for _, t in pairs(spellSlots) do table.sort(t) end
end

function E.EnchantForSpell(spell)
    if not spell then return nil end
    if not bySpell then BuildMaps() end
    return bySpell[spell]
end

function E.SlotsOf(enchantID)
    if not slotsOf then BuildMaps() end
    return slotsOf[enchantID] or {}
end

-- The slots this recipe enchants (its enchant's slots whose own recipe it is)
function E.SlotsOfSpell(spell)
    if not spellSlots then BuildMaps() end
    return spellSlots[spell] or {}
end

-- ---------------------------------------------------------------
-- Is this character an enchanter, and which recipes does it know
-- ---------------------------------------------------------------
local function Store()
    local guid = UnitGUID and UnitGUID("player")
    if not guid or not SharpiesGearJudgeDB then return nil end
    SharpiesGearJudgeDB.enchanting = SharpiesGearJudgeDB.enchanting or {}
    local s = SharpiesGearJudgeDB.enchanting[guid]
    if not s then s = { known = {} }; SharpiesGearJudgeDB.enchanting[guid] = s end
    s.known = s.known or {}
    return s
end

local rankCache, rankRead = nil, false

-- The Enchanting rank from the skill list, or nil when the character has no Enchanting.
-- Returns found=false when no API could tell (then the rank seen in the window counts).
local function ReadRank()
    if GetProfessions and GetProfessionInfo then
        local ok, a, b = pcall(GetProfessions)
        if ok then
            for _, idx in ipairs({ a or 0, b or 0 }) do
                if idx > 0 then
                    local ok2, _, _, rank, _, _, _, line = pcall(GetProfessionInfo, idx)
                    if ok2 and line == ENCHANTING_LINE then return rank, true end
                end
            end
            if a or b then return nil, true end
        end
    end
    if GetNumSkillLines and GetSkillLineInfo then
        local want = (C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(ENCHANTING_SPELL))
            or (GetSpellInfo and GetSpellInfo(ENCHANTING_SPELL))
        local n = GetNumSkillLines() or 0
        if want and n > 0 then
            for i = 1, n do
                local name, header, _, rank = GetSkillLineInfo(i)
                if not header and name == want then return rank, true end
            end
            return nil, true
        end
    end
    return nil, false
end

function E.Rank()
    if not rankRead then
        local rank, found = ReadRank()
        local s = Store()
        if found then
            rankCache = rank
            if s then s.rank = rank end
        else
            rankCache = s and s.rank or nil
        end
        rankRead = true
    end
    return rankCache
end

function E.IsEnchanter() return E.Rank() ~= nil end

function E.Knows(spell)
    if not spell then return false end
    if IsPlayerSpell then
        local ok, known = pcall(IsPlayerSpell, spell)
        if ok and known then return true end
    end
    local s = Store()
    return s and s.known[spell] == true or false
end

-- " (you know this)" / " (not learned)" after a Projected Enchant name; "" for non-enchanters and enchant items.
function E.KnownSuffix(enchantID, slotId)
    local data = enchantID and MSC.EnchantDB and MSC.EnchantDB[enchantID]
    local spell = MSC.EnchantSpellFor(data, slotId)
    if not spell or not E.IsEnchanter() then return "" end
    if E.Knows(spell) then return " " .. L["|cff00ff00(you know this)|r"] end
    return " " .. L["|cff888888(not learned)|r"]
end

-- The open profession window: its skill line and rank (C_TradeSkillUI), or nil.
local function OpenLine()
    if not C_TradeSkillUI then return nil end
    if C_TradeSkillUI.GetBaseProfessionInfo then
        local ok, info = pcall(C_TradeSkillUI.GetBaseProfessionInfo)
        if ok and type(info) == "table" and info.professionID then return info.professionID, info.skillLevel end
    end
    if C_TradeSkillUI.GetTradeSkillLine then
        local ok, id, _, rank = pcall(C_TradeSkillUI.GetTradeSkillLine)
        if ok and id then return id, rank end
    end
    return nil
end

-- Read the learned recipes while the Enchanting window is open.
local function ScanRecipes()
    local line, rank = OpenLine()
    if line ~= ENCHANTING_LINE or not C_TradeSkillUI.GetAllRecipeIDs or not C_TradeSkillUI.GetRecipeInfo then return end
    local ok, ids = pcall(C_TradeSkillUI.GetAllRecipeIDs)
    if not ok or type(ids) ~= "table" or #ids == 0 then return end
    local s = Store()
    if not s then return end
    local known, changed = {}, false
    for _, id in ipairs(ids) do
        local ok2, info = pcall(C_TradeSkillUI.GetRecipeInfo, id)
        if ok2 and type(info) == "table" and info.learned and E.EnchantForSpell(id) then
            known[id] = true
            if not s.known[id] then changed = true end
        end
    end
    for id in pairs(s.known) do if not known[id] then changed = true end end
    s.known = known
    if rank and rank > 0 then s.rank = rank; rankCache = rank end
    if changed and SGJ_Settings and SGJ_Settings.EnchantOnlyKnown and MSC.BumpScoringRevision then MSC:BumpScoringRevision() end
end

-- ---------------------------------------------------------------
-- What an enchant is worth on the item in a slot
-- ---------------------------------------------------------------
local function CurrentEnchant(link)
    return link and tonumber(link:match("item:%-?%d+:(%-?%d+)")) or 0
end

-- gain over the enchant already on the item, current enchant ID, whether that enchant is unknown to the DB.
-- link: the item in that slot (nil: nothing there -> nil).
function E.Gain(enchantID, weights, slot, link)
    if not link or not weights then return nil end
    local data = MSC.EnchantDB[enchantID]
    if not data or not MSC.EnchantFitsSlot(data, slot, MSC:GetValidEnchantType(link)) then return nil end
    local cur = CurrentEnchant(link)
    local new = MSC.GetEnchantScore(enchantID, weights, slot)
    local old = (cur > 0 and MSC.EnchantDB[cur]) and MSC.GetEnchantScore(cur, weights, slot) or 0
    return new - old, cur, cur > 0 and not MSC.EnchantDB[cur]
end

-- Best gain over the enchant's slots for one set of gear links (slot -> link).
local function BestGain(enchantID, weights, links, slots)
    local best, bestSlot, cur, unknownCur
    for _, slot in ipairs(slots or E.SlotsOf(enchantID)) do
        local g, c, u = E.Gain(enchantID, weights, slot, links[slot])
        if g and (not best or g > best) then best, bestSlot, cur, unknownCur = g, slot, c, u end
    end
    return best, bestSlot, cur, unknownCur
end

local function WornLinks()
    local t = {}
    for _, slot in ipairs({ 1, 3, 5, 6, 7, 8, 9, 10, 15, 16, 17, 18 }) do t[slot] = GetInventoryItemLink("player", slot) end
    return t
end

-- For the profession list: recipe IDs that are the best for one of your slots (gain > 0).
function E.BestRecipes(recipeIDs, weights)
    local links, bestBySlot = WornLinks(), {}
    for _, id in ipairs(recipeIDs) do
        local eid = E.EnchantForSpell(id)
        if eid then
            local own = E.SlotsOfSpell(id)
            for _, slot in ipairs(#own > 0 and own or E.SlotsOf(eid)) do
                local g = E.Gain(eid, weights, slot, links[slot])
                if g and g > 0.05 and (not bestBySlot[slot] or g > bestBySlot[slot].g) then bestBySlot[slot] = { g = g, id = id } end
            end
        end
    end
    local out = {}
    for _, v in pairs(bestBySlot) do out[v.id] = true end
    return out
end

-- ---------------------------------------------------------------
-- Recipe tooltip lines
-- ---------------------------------------------------------------
local SLOT_LABEL = { [1] = "HEADSLOT", [3] = "SHOULDERSLOT", [5] = "CHESTSLOT", [6] = "WAISTSLOT", [7] = "LEGSSLOT",
    [8] = "FEETSLOT", [9] = "WRISTSLOT", [10] = "HANDSSLOT", [15] = "BACKSLOT", [16] = "MAINHANDSLOT",
    [17] = "SECONDARYHANDSLOT", [18] = "RANGEDSLOT" }
local SLOT_EN = { [1] = "Head", [3] = "Shoulder", [5] = "Chest", [6] = "Waist", [7] = "Legs", [8] = "Feet", [9] = "Wrist",
    [10] = "Hands", [15] = "Back", [16] = "Main Hand", [17] = "Off Hand", [18] = "Ranged" }
function E.SlotName(slot) return _G[SLOT_LABEL[slot] or ""] or SLOT_EN[slot] or "?" end

local function GainText(g)
    if g > 0.05 then return string.format("|cff00ff00+%.1f|r", g) end
    return "|cff888888" .. L["no gain"] .. "|r"
end

local function AddRow(tip, rich, label, value)
    if rich then MSC.Rich.Row(tip, label, value) else tip:AddDoubleLine(label, value, 1, 1, 1, 1, 1, 1) end
end
local function AddHint(tip, rich, text)
    if rich then MSC.Rich.Hint(tip, text) else tip:AddLine(text, 0.6, 0.6, 0.6, true) end
end

function E.DrawRecipeTooltip(tip, spell)
    local eid = E.EnchantForSpell(spell)
    if not eid then return end
    local weights, specName = MSC.GetCurrentWeights()
    if not weights then return end
    local rich = MSC.Rich and MSC.Rich.On(tip)
    if rich then MSC.Rich.Gap(tip); MSC.Rich.Section(tip, L["Gear Judge"])
    else tip:AddLine(" "); tip:AddLine(L["Gear Judge"], 1, 0.82, 0) end

    -- you
    local links, anyItem = WornLinks(), false
    local slots = E.SlotsOfSpell(spell)
    if #slots == 0 then slots = E.SlotsOf(eid) end
    for _, slot in ipairs(slots) do
        local link = links[slot]
        local g, cur, unknownCur = E.Gain(eid, weights, slot, link)
        if g then
            anyItem = true
            AddRow(tip, rich, string.format(L["Your %s"], E.SlotName(slot)), GainText(g))
            if g <= 0.05 and cur > 0 and MSC.EnchantDB[cur] then
                AddHint(tip, rich, string.format(L["Already on it: %s"], MSC.GetEnchantName(MSC.EnchantDB[cur], slot)))
            elseif unknownCur then
                AddHint(tip, rich, L["The enchant on it now isn't in Gear Judge's list; the gain may be smaller."])
            end
        end
    end
    if not anyItem then
        local where = slots[1] and E.SlotName(slots[1]) or "?"
        AddRow(tip, rich, string.format(L["Your %s"], where), "|cff888888" .. L["nothing it fits"] .. "|r")
    end
    AddHint(tip, rich, string.format(L["Scored for %s, against the enchant on it now."], MSC.ProfileName(specName) or tostring(specName)))

    -- off-specs (the talents last played in each)
    if MSC.GetTrackedSpecs and MSC.ResolveTrackedProfile and MSC.GetWeightsByName then
        local seen = {}
        for pick in pairs(MSC.GetTrackedSpecs()) do
            local tSpec = MSC.ResolveTrackedProfile(pick)
            if tSpec and tSpec ~= specName and not seen[tSpec] then
                seen[tSpec] = true
                local saved = MSC.GetSavedTalents and MSC.GetSavedTalents(pick, tSpec)
                local original = MSC.TalentCache
                if saved then MSC.TalentCache = saved end
                local ok, tW = pcall(MSC.GetWeightsByName, tSpec)
                local g, slot
                if ok and tW then g, slot = BestGain(eid, tW, links, slots) end
                MSC.TalentCache = original
                if g and g > 0.05 then
                    local pretty = (MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[tSpec]) or tSpec
                    AddRow(tip, rich, string.format(L["%s (off-spec)"], pretty), GainText(g))
                end
            end
        end
    end

    -- alts (Roster)
    if MSC.RosterEnchantGains then
        local ok, rows = pcall(MSC.RosterEnchantGains, eid, slots)
        if ok and type(rows) == "table" then
            for i = 1, math.min(3, #rows) do
                AddRow(tip, rich, rows[i].label, GainText(rows[i].gain))
            end
            if #rows > 3 then AddHint(tip, rich, string.format(L["...and %d more alts"], #rows - 3)) end
        end
    end
    if tip:IsVisible() then tip:Show() end   -- post-calls run before the game shows the tooltip (never force it)
end

-- ---------------------------------------------------------------
-- Safe to disenchant
-- ---------------------------------------------------------------
-- Gear you could disenchant without losing anything: uncommon or better armor or
-- weapons, soulbound (BoE items can sell, unless the option says otherwise), not an
-- upgrade for your active spec, your ticked off-specs or (if it can still be sent) any alt Roster knows.
local deCache = {}
function E.ClearDisenchantCache() wipe(deCache) end

function E.ShowDisenchant()
    if SGJ_Settings and SGJ_Settings.MarkDisenchant == false then return false end
    return E.IsEnchanter()
end

-- BoE items (bind type 2) are left alone unless the "include BoE" option is on: they can sell. (A BoE item
-- that was worn once is bound, but the link can't tell; those stay unmarked too.)
function E.SafeToDisenchant(link)
    if not link or not E.ShowDisenchant() then return false end
    local v = deCache[link]
    if v ~= nil then return v end
    local _, _, quality, _, _, _, _, _, equipLoc, _, _, classID, _, bindType = GetItemInfo(link)
    if not quality then return false end   -- not loaded yet: asked again on the next bag update
    v = false
    if quality >= 2 and quality <= 4 and (classID == 2 or classID == 4) and equipLoc and equipLoc ~= ""
        and equipLoc ~= "INVTYPE_NON_EQUIP" and equipLoc ~= "INVTYPE_BAG" and equipLoc ~= "INVTYPE_TABARD"
        and equipLoc ~= "INVTYPE_BODY" and (bindType ~= 2 or (SGJ_Settings and SGJ_Settings.DisenchantBoE)) then
        v = true
        local weights, specName = MSC.GetCurrentWeights()
        if weights and MSC.IsItemUsable(link) then
            local slot = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
            if slot then
                local n, o = MSC:EvaluateUpgrade(link, slot, weights, specName)
                if n and o and n > o + (MSC.VERDICT_EPS or 0) then v = false end
            end
        end
        if v and MSC.GetTrackedSpecs and MSC.GetWeightsByName then
            for pick in pairs(MSC.GetTrackedSpecs()) do
                local tSpec = MSC.ResolveTrackedProfile(pick)
                local ok, tW = pcall(MSC.GetWeightsByName, tSpec)
                if ok and tW and MSC.IsItemUsable(link) then
                    local slot = MSC.GetComparisonSlot(link, equipLoc, tW, tSpec)
                    if slot then
                        local ok2, n, o = pcall(MSC.EvaluateUpgrade, MSC, link, slot, tW, tSpec)
                        if ok2 and n and o and n > o + (MSC.VERDICT_EPS or 0) then v = false; break end
                    end
                end
            end
        end
        -- Alts only count when the item can still reach them (Roster's rule): not Bind on Pickup (1) or a quest item (4),
        -- which are bound to you (2026-11-26, in game: a soulbound Tear of Grief stayed unmarked because an alt could use it).
        if v and MSC.RosterUpgradesFor and bindType ~= 1 and bindType ~= 4 then
            local ok, ups = pcall(MSC.RosterUpgradesFor, link)
            if ok and type(ups) == "table" and #ups > 0 then v = false end
        end
    end
    deCache[link] = v
    return v
end

-- ---------------------------------------------------------------
-- Hooks and events
-- ---------------------------------------------------------------
local drawnFor = setmetatable({}, { __mode = "k" })

local function SpellOf(tip, data)
    if tip.GetSpell then
        local ok, _, id = pcall(tip.GetSpell, tip)
        if ok and id then return id end
    end
    if type(data) == "table" and data.id and Enum and Enum.TooltipDataType and data.type == Enum.TooltipDataType.Spell then return data.id end
    return nil
end

-- Item tooltips: one line when the item is safe to disenchant (runs after Gear Judge's own lines, which are
-- registered first in TooltipManager.lua).
-- Adds the line once per tooltip; true when it was added now. Gear Judge's own tooltip pass calls this before its
-- final resize (Judge.lua), so the tooltip is laid out once (2026-11-26, in game: a second tip:Show() from this
-- file's own post-call made tooltips of marked items flash while the bag refreshed them).
-- Already on the tooltip? Read from its lines, not remembered: Daylight UI refills an item's tooltip every 0.2 s and
-- rebuilds its card whenever the lines differ from the last fill, so every fill must end with exactly one copy.
local function HasLine(tip, text)
    local name = tip.GetName and tip:GetName()
    if not name or not tip.NumLines then return false end
    for i = 2, tip:NumLines() or 0 do
        local fs = _G[name .. "TextLeft" .. i]
        local t = fs and fs:GetText()
        if t and not (MSC_IsSecret and MSC_IsSecret(t)) and t == text then return true end
    end
    return false
end

-- Worn right now? (2026-11-27, in game: a worn bracer said "Safe to disenchant": Forever has C_Item.IsEquippedItem and no
-- global IsEquippedItem, so the old check never ran.) The worn slots' links are compared too.
local function IsWorn(link)
    local f = (C_Item and C_Item.IsEquippedItem) or IsEquippedItem
    if f then local ok, worn = pcall(f, link); if ok and worn then return true end end
    for slot = 1, 19 do if GetInventoryItemLink("player", slot) == link then return true end end
    return false
end
E.IsWorn = IsWorn

function E.AddDisenchantLine(tip, link)
    if not tip or not link or not E.ShowDisenchant() then return false end
    if IsWorn(link) then return false end
    if not E.SafeToDisenchant(link) then return false end
    local text = L["Safe to disenchant: no upgrade for you, your off-specs or your alts."]
    if HasLine(tip, text) then return false end
    if MSC.Rich and MSC.Rich.On(tip) then MSC.Rich.Hint(tip, text) else tip:AddLine(text, 0.6, 0.8, 1, true) end
    return true
end


local function OnTooltip(tip, data)
    if tip ~= GameTooltip and tip ~= ItemRefTooltip then return end
    -- Item tooltips: no line from here. This post-call is registered at load, before Gear Judge's own (PLAYER_LOGIN),
    -- so it ran first: its line and tip:Show() made Daylight UI's Rich card build before Gear Judge's lines were there
    -- and build again after, on every 0.2 s refill (2026-11-26, in game: marked items' tooltips flashed). Judge.lua
    -- adds the line in its own pass (E.AddDisenchantLine), also for gear it doesn't score.
    if SGJ_Settings and SGJ_Settings.EnchantRecipeTips == false then return end
    local spell = SpellOf(tip, data)
    if not spell or drawnFor[tip] == spell or not E.EnchantForSpell(spell) then return end
    drawnFor[tip] = spell
    local ok, err = pcall(E.DrawRecipeTooltip, tip, spell)
    if not ok and MSC.Debug then print("|cff00ccffSGJ|r enchant tooltip:", err) end
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
    TooltipDataProcessor.AddTooltipPostCall(TooltipDataProcessor.AllTypes, OnTooltip)
end
for _, tip in ipairs({ GameTooltip, ItemRefTooltip }) do
    if tip then
        tip:HookScript("OnTooltipCleared", function(self) drawnFor[self] = nil end)
        if tip.SetSpellByID then hooksecurefunc(tip, "SetSpellByID", function(self) OnTooltip(self) end) end
    end
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_LOGIN", "SKILL_LINES_CHANGED", "TRADE_SKILL_SHOW", "TRADE_SKILL_LIST_UPDATE",
    "NEW_RECIPE_LEARNED", "LEARNED_SPELL_IN_TAB", "PLAYER_EQUIPMENT_CHANGED",
    "PLAYER_LEVEL_UP", "ACTIVE_TALENT_GROUP_CHANGED", "CHARACTER_POINTS_CHANGED" }) do
    pcall(ev.RegisterEvent, ev, e)
end
ev:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" or event == "SKILL_LINES_CHANGED" then
        rankRead = false
    elseif event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_LIST_UPDATE" or event == "NEW_RECIPE_LEARNED"
        or event == "LEARNED_SPELL_IN_TAB" then
        rankRead = false
        if C_Timer and C_Timer.After then C_Timer.After(0.2, ScanRecipes) else ScanRecipes() end
    else
        wipe(deCache)
    end
end)
