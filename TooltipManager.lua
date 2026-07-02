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
        
        local name, link = tooltip:GetItem()
        
        -- Handle quest rewards where tooltip:GetItem() might initially return nil
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
                            if MSC.PendingTooltip:IsVisible() and string.find(MSC.PendingTooltipLink, "item:" .. tostring(itemID)) then
                                local tip = MSC.PendingTooltip
                                local pendingLink = MSC.PendingTooltipLink
                                MSC.PendingTooltipLink = nil
                                
                                -- Refresh the tooltip natively to clear the "Fetching" text, then evaluate!
                                tip:SetHyperlink(pendingLink) 
                                original_Evaluate(tip)
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

    if GameTooltip.SetQuestItem then
        hooksecurefunc(GameTooltip, "SetQuestItem", function(self, itemType, index)
            TriggerQuestTooltip(self, GetQuestItemLink(itemType, index))
        end)
    end

    if GameTooltip.SetQuestLogItem then
        hooksecurefunc(GameTooltip, "SetQuestLogItem", function(self, itemType, index)
            TriggerQuestTooltip(self, GetQuestLogItemLink(itemType, index))
        end)
    end

    -- Global Tooltip API (TBC Anniversary / 11.x Client)
    if TooltipDataProcessor then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
            if tooltip == GameTooltip or tooltip == ItemRefTooltip or tooltip == ShoppingTooltip1 or tooltip == ShoppingTooltip2 then
                MSC.EvaluateAndDrawTooltip(tooltip)
            end
        end)
    else
        -- Legacy Client Fallback
        -- GameTooltip and ItemRefTooltip are already hooked using wrappers in Judge.lua
        if ShoppingTooltip1 then
            ShoppingTooltip1:HookScript("OnTooltipSetItem", function(self)
                if MSC.EvaluateAndDrawTooltip then
                    MSC.EvaluateAndDrawTooltip(self)
                end
            end)
        end
        if ShoppingTooltip2 then
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