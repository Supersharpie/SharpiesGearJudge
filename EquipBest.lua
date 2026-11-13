local addonName, MSC = ...
local L = MSC.L

-- =============================================================
-- EQUIP BEST UPGRADE (3.4.0)
-- =============================================================
-- One press puts on the single biggest upgrade in your bags: the items that
-- get a green bag arrow, judged the full way (MSC:EvaluateUpgrade, the same
-- threshold as the tooltip), for your active spec only. Press again for the
-- next one. Rings, trinkets and weapons go in the slot the tooltip compares
-- against. Bind-on-Equip items get the game's own "bind it to you?"
-- confirmation. Out of combat only.
-- Keybind: Key Bindings > AddOns > Sharpie's Gear Judge (Bindings.xml);
-- slash: /sgj equip (works in a macro, so controller addons can use it).

local GetBagSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetBagLink  = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink

local LOCK_SECONDS = 1   -- the bags update a moment after an equip: don't pick the same item twice
local busyUntil = 0

BINDING_HEADER_SHARPIESGEARJUDGE = "Sharpie's Gear Judge"
BINDING_NAME_SGJ_EQUIP_BEST = L["Equip Best Upgrade"]

-- The upgrade for one bag item, or nil: { link, slot, gain, pct (nil = an empty slot) }
local function Judge(link, weights, specName, level)
    local itemName, _, _, _, minLevel, _, _, _, equipLoc = GetItemInfo(link)
    if not itemName or not equipLoc or equipLoc == "" or equipLoc == "INVTYPE_NON_EQUIP" then return nil end
    if minLevel and minLevel > level then return nil end
    if not MSC.IsItemUsable(link) then return nil end
    local slot = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
    if not slot then return nil end
    local newScore, oldScore = MSC:EvaluateUpgrade(link, slot, weights, specName)
    if not newScore or not oldScore or newScore <= oldScore + MSC.VERDICT_EPS then return nil end
    return { link = link, slot = slot, gain = newScore - oldScore,
             pct = oldScore > 0 and (newScore - oldScore) / oldScore * 100 or nil }
end

-- The biggest upgrade in the bags, or nil
function MSC.FindBestBagUpgrade()
    local weights, specName = MSC.GetCurrentWeights()
    if not weights then return nil end
    local level = UnitLevel("player") or 0
    local best
    for bag = 0, (NUM_BAG_SLOTS or 4) do
        for slot = 1, (GetBagSlots(bag) or 0) do
            local link = GetBagLink(bag, slot)
            if link then
                local ok, data = pcall(Judge, link, weights, specName, level)
                if ok and data and (not best or data.gain > best.gain) then best = data end
            end
        end
    end
    return best
end

function MSC.EquipBestUpgrade()
    if InCombatLockdown() then
        if UIErrorsFrame and ERR_NOT_IN_COMBAT then UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1, 0.1, 0.1) end
        return
    end
    -- the last press is still going on (the item moving, or the bind confirmation is open)
    if GetTime() < busyUntil then return end
    if StaticPopup_Visible and StaticPopup_Visible("EQUIP_BIND") then return end
    local best = MSC.FindBestBagUpgrade()
    if not best then
        print(L["|cff00ff00SGJ:|r no upgrades in your bags"])
        return
    end
    busyUntil = GetTime() + LOCK_SECONDS
    EquipItemByName(best.link, best.slot)
    if best.pct then
        print(string.format(L["|cff00ff00SGJ:|r equipping %s (+%.1f%%)"], best.link, best.pct))
    else
        print(string.format(L["|cff00ff00SGJ:|r equipping %s (empty slot)"], best.link))
    end
end

-- Bindings.xml calls this global
function SGJ_EquipBestUpgrade() MSC.EquipBestUpgrade() end
