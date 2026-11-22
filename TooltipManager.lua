local addonName, MSC = ...
_G.MSC = MSC

-- ============================================================================
-- TOOLTIP MANAGER & ASYNC CACHE FIX
-- Solves the "0-Score Downgrade" bug caused by server cache misses on Quest Items.
-- Modernizes tooltip hooks for the TBC Anniversary Client (11.x architecture).
-- ============================================================================

local TooltipManager = CreateFrame("Frame")
TooltipManager:RegisterEvent("PLAYER_LOGIN")

TooltipManager:SetScript("OnEvent", function(self, event)
    -- 1. Store the original evaluation function from Judge.lua
    local original_Evaluate = MSC.EvaluateAndDrawTooltip

    -- 2. Wrap the evaluation function with Cache Protection
    MSC.EvaluateAndDrawTooltip = function(tooltip)
        if not tooltip then return end
        -- Comparison tooltips are never scored (Judge.lua skips them): don't reread items or
        -- add "Fetching" lines there, the client redraws them with every main tooltip refresh.
        if tooltip == ShoppingTooltip1 or tooltip == ShoppingTooltip2 then return end

        local name, link = MSC_GetTooltipItem(tooltip)
        
        -- Handle quest rewards where MSC_GetTooltipItem(tooltip) might initially return nil
        if MSC.IsQuestHook and not link then 
            link = MSC.HoveredQuestLink 
        end
        
        if link then
            -- GetItemInfo returns nil if the item is not locally cached yet.
            -- If we let Evaluator.lua scan it now, it will return 0 stats.
            if not GetItemInfo(link) then
                
                -- Create a listener to wait for the server to send the item data
                if not MSC.CacheRetryFrame then
                    MSC.CacheRetryFrame = CreateFrame("Frame")
                    MSC.CacheRetryFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
                    MSC.CacheRetryFrame:SetScript("OnEvent", function(self, event, itemID, success)
                        if success and MSC.PendingTooltipLink and MSC.PendingTooltip then
                            
                            -- Verify the item the server just sent is the one we are hovering over
                            -- (full id only: "item:123" must not match "item:1234")
                            local idStr = "item:" .. tostring(itemID)
                            local pLink = MSC.PendingTooltipLink
                            local idMatch = string.find(pLink, idStr .. ":", 1, true) or pLink:sub(-#idStr) == idStr
                            if MSC.PendingTooltip:IsVisible() and idMatch then
                                local tip = MSC.PendingTooltip
                                local pendingLink = MSC.PendingTooltipLink
                                MSC.PendingTooltipLink = nil

                                -- Refresh the tooltip natively to clear the "Fetching" text. SetHyperlink
                                -- fires the tooltip hooks, which evaluate it now the item is cached.
                                tip:SetHyperlink(pendingLink)
                            end
                        end
                    end)
                end
                
                -- Store the active tooltip data
                MSC.PendingTooltipLink = link
                MSC.PendingTooltip = tooltip
                
                -- Add a loading message and STOP the evaluation to prevent the 0-score bug
                tooltip:AddLine(" ")
                local fetchText = (MSC.L and MSC.L["Fetching item data..."]) or "Fetching item data..."
                tooltip:AddLine("|cff888888SGJ: " .. fetchText .. "|r")
                tooltip:Show()
                return 
            end
        end
        
        -- Reread the item and the worn item(s) it's compared against when their
        -- cached reads may predate their Equip: text (Helpers.lua RecheckForTooltip).
        if link and MSC.RecheckForTooltip then MSC.RecheckForTooltip(link) end

        original_Evaluate(tooltip)
    end

    -- ============================================================================
    -- 3. HOOKS & EVENT HIJACKING (Modernized)
    -- ============================================================================
    
    -- Quest Window Hooks
    local function TriggerQuestTooltip(tooltip, link)
        MSC.HoveredQuestLink = link
        MSC.IsQuestHook = true
        MSC.EvaluateAndDrawTooltip(tooltip)
        MSC.IsQuestHook = false    
        tooltip:Show()
    end

    -- Hovering a reward reads it again: the cached read may predate its Equip:
    -- text (quest frames scan rewards the moment they open). When the stats
    -- changed, the tooltip is set again so it's drawn from the new read (the
    -- duplicate guard in Judge.lua skips a second score on the same tooltip).
    local redrawing = false
    local function RecheckQuestTooltip(tooltip, method, link, itemType, index)
        if redrawing or not MSC.RecheckItemScan or not MSC.RecheckItemScan(link) then return end
        redrawing = true
        pcall(tooltip[method], tooltip, itemType, index)
        redrawing = false
        if MSC.UpdateAllQuestOverlays then MSC.UpdateAllQuestOverlays() end
    end

    if GameTooltip.SetQuestItem then
        hooksecurefunc(GameTooltip, "SetQuestItem", function(self, itemType, index)
            local link = GetQuestItemLink(itemType, index)
            TriggerQuestTooltip(self, link)
            RecheckQuestTooltip(self, "SetQuestItem", link, itemType, index)
        end)
    end

    if GameTooltip.SetQuestLogItem then
        hooksecurefunc(GameTooltip, "SetQuestLogItem", function(self, itemType, index)
            local link = GetQuestLogItemLink(itemType, index)
            TriggerQuestTooltip(self, link)
            RecheckQuestTooltip(self, "SetQuestLogItem", link, itemType, index)
        end)
    end

    -- Global Tooltip API (TBC Anniversary / 11.x Client)
    -- Registered under AllTypes rather than Enum.TooltipDataType.Item: on this
    -- client build, that enum value doesn't line up with what the dispatcher
    -- actually tags item tooltips with, so a callback registered for it alone
    -- never fires. AllTypes sidesteps the enum entirely; the tooltip==GameTooltip
    -- (etc.) check below already scopes this to the tooltips we care about.
    if TooltipDataProcessor then
        TooltipDataProcessor.AddTooltipPostCall(TooltipDataProcessor.AllTypes, function(tooltip, data)
            if tooltip == GameTooltip or tooltip == ItemRefTooltip or tooltip == ShoppingTooltip1 or tooltip == ShoppingTooltip2 then
                MSC.EvaluateAndDrawTooltip(tooltip)
            end
        end)
    end
    -- ShoppingTooltip hooks registered unconditionally too, same reasoning as
    -- above: TooltipDataProcessor existing doesn't guarantee it actually fires
    -- on every client build. GameTooltip/ItemRefTooltip's OnTooltipSetItem
    -- hooks live in Judge.lua and are likewise unconditional now.
    do
        if ShoppingTooltip1 and ShoppingTooltip1:HasScript("OnTooltipSetItem") then
            ShoppingTooltip1:HookScript("OnTooltipSetItem", function(self)
                if MSC.EvaluateAndDrawTooltip then
                    MSC.EvaluateAndDrawTooltip(self)
                end
            end)
        end
        if ShoppingTooltip2 and ShoppingTooltip2:HasScript("OnTooltipSetItem") then
            ShoppingTooltip2:HookScript("OnTooltipSetItem", function(self)
                if MSC.EvaluateAndDrawTooltip then
                    MSC.EvaluateAndDrawTooltip(self)
                end
            end)
        end
    end
end)

GameTooltip:HookScript("OnTooltipCleared", function()
    MSC.HoveredQuestLink = nil
    MSC.PendingTooltipLink = nil
    MSC.PendingTooltip = nil
end)

-- ============================================================================
-- DAYLIGHT UI RICH CARDS (3.8.0)
-- Daylight UI's "Rich" tooltip look draws its own card over the game tooltip. Its
-- plugin pieces (API 1.12: rows, sections, tags) are tooltip lines marked for the
-- card, so they draw as real rows; other lines get a plain repaint whose rows cut
-- a long label to fit the value. MSC.Rich adds a line and marks it when the card
-- is on, else just adds the line. The plugins (Roster) use it too.
-- Off: SGJ_Settings.DaylightRich = false. Every Daylight call is guarded, so a
-- change on their side falls back to plain lines.
-- ============================================================================
local Rich = {}
MSC.Rich = Rich

local function DuiTooltipNs()
    local D = _G.DaylightUI
    if type(D) ~= "table" or type(D.GetModule) ~= "function" then return nil end
    local ok, mod = pcall(D.GetModule, D, "Tooltip")
    local ns = ok and type(mod) == "table" and mod.ns or nil
    if type(ns) == "table" and type(ns.Rich) == "table" and type(ns.Rich.On) == "function"
        and type(ns.Rich.Piece) == "function" then return ns end
    return nil
end

-- Whether Daylight UI draws this tooltip as a Rich card.
function Rich.On(tip)
    if SGJ_Settings and SGJ_Settings.DaylightRich == false then return false end
    local ns = DuiTooltipNs()
    if not ns then return false end
    local ok, on = pcall(ns.Rich.On, tip)
    return ok and on == true
end

local function Mark(tip, piece)
    local ns = DuiTooltipNs()
    if ns then pcall(ns.Rich.Piece, tip, piece) end
end

-- A label without its color codes and the colon at its end (the card's row labels have none).
function Rich.Label(t)
    t = tostring(t or ""):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    return (t:gsub("^%s+", ""):gsub("%s*:%s*$", ""))
end
-- Plain words: no color codes, no inline textures.
function Rich.Plain(t)
    t = tostring(t or ""):gsub("|T.-|t", ""):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    return (t:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- label left, value right (value may carry its own color codes); colors { r, g, b } or nil. plainLeft: the
-- game line's own left words when they must stay as they were (Judge.lua finds its "Judge's Score:" line by them)
function Rich.Row(tip, label, value, valueColor, labelColor, plainLeft)
    tip:AddDoubleLine(plainLeft or label, value or " ", 1, 1, 1, 1, 1, 1)
    Mark(tip, { kind = "row", label = label, value = value, color = valueColor, labelColor = labelColor })
end
function Rich.Text(tip, text, color)
    local c = color or { 1, 1, 1 }
    tip:AddLine(text, c[1], c[2], c[3], true)
    Mark(tip, { kind = "text", text = text, color = color })
end
-- small, in the card's accent
function Rich.Hint(tip, text)
    tip:AddLine(text, 0.6, 0.6, 0.6, true)
    Mark(tip, { kind = "hint", text = text })
end
function Rich.Section(tip, title)
    tip:AddLine(title, 1, 0.82, 0)
    Mark(tip, { kind = "section", text = title })
end
-- Daylight UI draws a plugin gap 4 px tall (DaylightUI_Tooltip Rich/Foreign.lua GAP): two make the room before a section
function Rich.Gap(tip)
    tip:AddLine(" ")
    Mark(tip, { kind = "gap" })
    tip:AddLine(" ")
    Mark(tip, { kind = "gap" })
end
-- a tag in the card's header, beside its item level and slot tags
function Rich.Tag(tip, text, color)
    local c = color or { 1, 1, 1 }
    tip:AddLine(text, c[1], c[2], c[3])
    Mark(tip, { kind = "tag", text = text, color = color })
end
