local _, MSC = ...

-- =============================================================
-- ENCHANT MANAGER (MASTER DATABASE)
-- =============================================================

MSC.EnchantDB = {
    -- [[ 1. WEAPON DAMAGE ]]
    [250] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1 }, name = "Minor Striking (+1 Dmg)" }, 
    [249] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 }, name = "Minor Beastslayer (+2)" },
    [843] = { stats = { ITEM_MOD_MANA_SHORT = 30 }, name = "Enchant Chest - Mana (+30)" }, 
    [943] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 3 }, name = "Lesser Striking (+3 Dmg)" },
    [803] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 4 }, name = "Fiery Weapon (+4 Fire)" }, 
    [853] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 4 }, name = "Striking (+4 Dmg)" },
    [854] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 5 }, name = "Greater Striking (+5 Dmg)" }, 
    [1897] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 5 }, name = "Superior Striking (+5 Dmg)" },

    -- [[ 2. SPELL POWER & HEALING ]]
    [2504] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 30 }, name = "Spell Power (+30)" }, 
    [2505] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 55 }, name = "Healing Power (+55)" },
    [2443] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 8 }, name = "Winter's Might (+7 Cold)" },
    
    -- [[ 3. NAXXRAMAS ]]
    [2603] = { stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26, ITEM_MOD_CRIT_RATING_SHORT = 1 }, name = "Might of the Scourge" }, 
    [2604] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 15, ITEM_MOD_SPELL_CRIT_RATING_SHORT = 1 }, name = "Power of the Scourge" }, 
    [2605] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 31, ITEM_MOD_MANA_REGENERATION_SHORT = 5 }, name = "Resilience of the Scourge" }, 
    [2606] = { stats = { ITEM_MOD_STAMINA_SHORT = 16, ITEM_MOD_ARMOR_SHORT = 100 }, name = "Fortitude of the Scourge" },

    -- [[ 4. LIBRAMS / ARCANUMS ]]
    [2284] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 8 }, name = "Arcanum of Focus (+8 SP)" },
    [2283] = { stats = { ITEM_MOD_DODGE_RATING_SHORT = 1 }, name = "Arcanum of Protection (1% Dodge)" },
    [2285] = { stats = { ITEM_MOD_ATTACK_SPEED_SHORT = 1 }, name = "Arcanum of Rapidity (1% Haste)" },

    -- [[ 5. ZUL'GURUB ]]
    [2621] = { stats = { ITEM_MOD_STAMINA_SHORT = 4, ITEM_MOD_STRENGTH_SHORT = 4, ITEM_MOD_AGILITY_SHORT = 4, ITEM_MOD_INTELLECT_SHORT = 4, ITEM_MOD_SPIRIT_SHORT = 4 }, name = "ZG (All +4)" },
    [2607] = { stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30 }, name = "ZG (+30 AP)" },
    [2608] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 18 }, name = "ZG (+18 SP)" },
    [2609] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 33 }, name = "ZG (+33 Healing)" },

    -- [[ 6. STANDARD STATS (Low Level) ]]
    [15] = { stats = { ITEM_MOD_HEALTH_SHORT = 15 }, name = "Minor Health (+15)" },  
    [16] = { stats = { ITEM_MOD_HEALTH_SHORT = 25 }, name = "Lesser Health (+25)" },  
    [241] = { stats = { ITEM_MOD_HEALTH_SHORT = 35 }, name = "Health (+35)" }, 
    [242] = { stats = { ITEM_MOD_HEALTH_SHORT = 50 }, name = "Greater Health (+50)" }, 
    [243] = { stats = { ITEM_MOD_HEALTH_SHORT = 100 }, name = "Major Health (+100)" },
    [17] = { stats = { ITEM_MOD_MANA_SHORT = 30 }, name = "Minor Mana (+30)" },
    [18] = { stats = { ITEM_MOD_MANA_SHORT = 50 }, name = "Lesser Mana (+50)" },
    [244] = { stats = { ITEM_MOD_MANA_SHORT = 100 }, name = "Mana (+100)" },
    [39] = { stats = { ITEM_MOD_STATS_ALL_SHORT = 1 }, name = "Minor Stats (+1)" },
    [40] = { stats = { ITEM_MOD_STATS_ALL_SHORT = 2 }, name = "Lesser Stats (+2)" },
    [41] = { stats = { ITEM_MOD_STATS_ALL_SHORT = 3 }, name = "Stats (+3)" },
    [256] = { stats = { ITEM_MOD_STATS_ALL_SHORT = 4 }, name = "Greater Stats (+4)" },
    [245] = { stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 1 }, name = "Minor Defense (+1)" },
    [246] = { stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 2 }, name = "Lesser Defense (+2)" },
    [247] = { stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 3 }, name = "Defense (+3)" },
    [2503] = { stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 7 }, name = "Greater Defense (+7)" },
    [385] = { stats = { ITEM_MOD_STAMINA_SHORT = 1 }, name = "Minor Stamina (+1)" },
    [386] = { stats = { ITEM_MOD_STAMINA_SHORT = 3 }, name = "Lesser Stamina (+3)" },
    [387] = { stats = { ITEM_MOD_STAMINA_SHORT = 5 }, name = "Stamina (+5)" },
    [388] = { stats = { ITEM_MOD_STAMINA_SHORT = 7 }, name = "Greater Stamina (+7)" },
    [389] = { stats = { ITEM_MOD_STAMINA_SHORT = 9 }, name = "Superior Stamina (+9)" },
    [393] = { stats = { ITEM_MOD_AGILITY_SHORT = 1 }, name = "Minor Agility (+1)" },
    [394] = { stats = { ITEM_MOD_AGILITY_SHORT = 3 }, name = "Lesser Agility (+3)" },
    [395] = { stats = { ITEM_MOD_AGILITY_SHORT = 5 }, name = "Agility (+5)" },
    [396] = { stats = { ITEM_MOD_AGILITY_SHORT = 7 }, name = "Greater Agility (+7)" },
    [2564] = { stats = { ITEM_MOD_AGILITY_SHORT = 15 }, name = "Superior Agility (+15)" },
    [373] = { stats = { ITEM_MOD_STRENGTH_SHORT = 1 }, name = "Minor Strength (+1)" },
    [374] = { stats = { ITEM_MOD_STRENGTH_SHORT = 3 }, name = "Lesser Strength (+3)" },
    [375] = { stats = { ITEM_MOD_STRENGTH_SHORT = 5 }, name = "Strength (+5)" },
    [376] = { stats = { ITEM_MOD_STRENGTH_SHORT = 7 }, name = "Greater Strength (+7)" },
    [377] = { stats = { ITEM_MOD_STRENGTH_SHORT = 9 }, name = "Superior Strength (+9)" },
    [2563] = { stats = { ITEM_MOD_STRENGTH_SHORT = 15 }, name = "Strength (+15)" },
    [1128] = { stats = { ITEM_MOD_INTELLECT_SHORT = 3 }, name = "Lesser Intellect (+3)" },
    [1127] = { stats = { ITEM_MOD_INTELLECT_SHORT = 5 }, name = "Intellect (+5)" },
    [1126] = { stats = { ITEM_MOD_INTELLECT_SHORT = 7 }, name = "Greater Intellect (+7)" },
    [2565] = { stats = { ITEM_MOD_INTELLECT_SHORT = 22 }, name = "Mighty Intellect (+22)" },
    [249] = { stats = { ITEM_MOD_SPIRIT_SHORT = 3 }, name = "Lesser Spirit (+3)" },
    [250] = { stats = { ITEM_MOD_SPIRIT_SHORT = 5 }, name = "Spirit (+5)" },
    [256] = { stats = { ITEM_MOD_SPIRIT_SHORT = 7 }, name = "Greater Spirit (+7)" },
    [1147] = { stats = { ITEM_MOD_SPIRIT_SHORT = 9 }, name = "Superior Spirit (+9)" },
    [2566] = { stats = { ITEM_MOD_SPIRIT_SHORT = 20 }, name = "Mighty Spirit (+20)" },
    [911] = { stats = { MSC_RUN_SPEED = 8 }, name = "Minor Speed" },
    [2629] = { stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 4 }, name = "+4 Mp5" },
    [2586] = { stats = { ITEM_MOD_RANGED_ATTACK_POWER_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_HIT_RATING_SHORT = 1 }, name = "Biznicks Scope" },
    [2585] = { stats = { ITEM_MOD_ATTACK_POWER_SHORT = 28, ITEM_MOD_DODGE_RATING_SHORT = 1 }, name = "ZG (+28 AP / +1% Dodge)" },
    [2583] = { stats = { ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 7, ITEM_MOD_BLOCK_VALUE_SHORT = 15 }, name = "ZG Tank" },
    [2584] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 7 }, name = "ZG Heal/Def" },
    [2589] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_MANA_REGENERATION_SHORT = 4 }, name = "ZG Heal/Mp5" },
    [2587] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 18, ITEM_MOD_HIT_SPELL_RATING_SHORT = 1 }, name = "ZG (+18 SP / +1% Hit)" },
    [2588] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 18, ITEM_MOD_STAMINA_SHORT = 10 }, name = "ZG (+18 SP / +10 Stam)" },
    [2591] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 13, ITEM_MOD_INTELLECT_SHORT = 15 }, name = "+13 SP / +15 Int" },
    [2590] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_INTELLECT_SHORT = 10 }, name = "Heal/Int Ench" },
    [2543] = { stats = { ITEM_MOD_ATTACK_SPEED_SHORT = 1 }, name = "+1% Haste" }, 
    [2544] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 8 }, name = "+8 Healing" },
    [2545] = { stats = { ITEM_MOD_DODGE_RATING_SHORT = 1 }, name = "+1% Dodge" },
    [2488] = { stats = { ITEM_MOD_HEALTH_SHORT = 100 }, name = "+100 Health" },
    [2483] = { stats = { ITEM_MOD_STRENGTH_SHORT = 8 }, name = "+8 Strength" },
    [2484] = { stats = { ITEM_MOD_STAMINA_SHORT = 8 }, name = "+8 Stamina" },
    [2485] = { stats = { ITEM_MOD_AGILITY_SHORT = 8 }, name = "+8 Agility" },
    [2486] = { stats = { ITEM_MOD_INTELLECT_SHORT = 8 }, name = "+8 Intellect" },
    [2487] = { stats = { ITEM_MOD_SPIRIT_SHORT = 8 }, name = "+8 Spirit" },
}

-- 2. DYNAMIC SCANNER HELPER
local function GetTipLines(link)
    if not link then return {} end
    local lines = {}
    local tipName = "MSC_EnchantScanner_" .. math.random(100000)
    local tip = CreateFrame("GameTooltip", tipName, nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    tip:SetHyperlink(link)
    for i=2, tip:NumLines() do
        local left = _G[tipName.."TextLeft"..i]
        if left then 
            local text = left:GetText()
            -- Filter out system lines
            if text and text ~= "" and not text:find("Durability") and not text:find("Classes:") and not text:find("Requires") and not text:find("Set:") and not text:find("Equip:") and not text:find("Chance on hit:") then
                local cleanText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                lines[cleanText] = true
            end
        end
    end
    return lines
end

-- 3. GET STATS (Check Master List -> Then Scan)
function MSC.GetEnchantStats(slotId)
    local equipLink = GetInventoryItemLink("player", slotId)
    if not equipLink then return {} end
    
    local linkParts = { strsplit(":", equipLink) }
    local enchantID = tonumber(linkParts[3]) or 0
    if enchantID == 0 then return {} end
    
    -- STEP A: Check Master DB (Compatibility Mode)
    local entry = MSC.EnchantDB[enchantID]
    if entry then
        local backup = {}
        -- CHECK: Is it the New Format? ({ stats = {...}, name = "..." })
        if entry.stats then
            for k, v in pairs(entry.stats) do backup[k] = v end
        -- CHECK: Is it the Old Format? ({ Stat = 10, Stat2 = 5 })
        else
            for k, v in pairs(entry) do backup[k] = v end
        end
        backup.IS_PROJECTED = true
        return backup
    end
    
    -- STEP B: Run Smart Scanner (For everything else)
    local enchantedLines = GetTipLines(equipLink)
    linkParts[3] = 0
    local baseLink = table.concat(linkParts, ":")
    local baseLines = GetTipLines(baseLink)
    
    local enchantText = nil
    for text, _ in pairs(enchantedLines) do
        if not baseLines[text] then enchantText = text; break end
    end
    
    if enchantText and MSC.ParseTooltipLine then
        local statKey, statVal = MSC.ParseTooltipLine(enchantText)
        if statKey and statVal and statVal > 0 then
            return { [statKey] = statVal, IS_PROJECTED = true }
        end
    end
    return {}
end

-- 4. GET STRING (Check Master List -> Then Scan)
function MSC.GetEnchantString(slotId)
    local equipLink = GetInventoryItemLink("player", slotId)
    if not equipLink then return "" end
    
    local linkParts = { strsplit(":", equipLink) }
    local enchantID = tonumber(linkParts[3]) or 0
    if enchantID == 0 then return "" end
    
    -- Check Master DB
    local entry = MSC.EnchantDB[enchantID]
    if entry then
        if entry.name then return entry.name end
        return "Enchant #" .. enchantID -- Fallback if Old Format lacks a name
    end
    
    -- Check Smart Scanner
    local enchantedLines = GetTipLines(equipLink)
    linkParts[3] = 0
    local baseLink = table.concat(linkParts, ":")
    local baseLines = GetTipLines(baseLink)
    
    for text, _ in pairs(enchantedLines) do
        if not baseLines[text] then return text end
    end
    return ""
end