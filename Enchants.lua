local _, MSC = ...

function MSC.GetEnchantStats(slotID)
    local link = GetInventoryItemLink("player", slotID)
    if not link then return {} end
    
    local _, _, itemID, enchantID = string.find(link, "item:(%d+):(%d+)")
    enchantID = tonumber(enchantID)
    local enchantOnly = {}
    
    if enchantID and enchantID > 0 and MSC.EnchantDB and MSC.EnchantDB[enchantID] then
        local data = MSC.EnchantDB[enchantID]
        for statKey, statVal in pairs(data) do
            enchantOnly[statKey] = statVal
        end
    end
    return enchantOnly
end

function MSC.GetEnchantString(slotId)
    local link = GetInventoryItemLink("player", slotId)
    if not link then return "" end
    local _, _, enchantID = string.find(link, "item:%d+:(%d+)")
    enchantID = tonumber(enchantID)
    if enchantID and MSC.EnchantDB and MSC.EnchantDB[enchantID] then
        local data = MSC.EnchantDB[enchantID]
        for k, v in pairs(data) do
            local name = MSC.GetCleanStatName(k)
            return "+" .. v .. " " .. name 
        end
    end
    return ""
end