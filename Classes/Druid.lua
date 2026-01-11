local addonName, MSC = ...
local Druid = {}
Druid.Name = "DRUID"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Druid.Weights = {
    ["Default"] = {
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5 
    },
    ["BALANCE_BOOMKIN"] = {
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["MSC_SPELL_CRIT_PERCENT"]=10.0, ["MSC_SPELL_HIT_PERCENT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=1.0 
    },
    ["RESTO_ERA"] = {
        ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 -- Spirit is massive for Innervate/Regen
    },
    ["FERAL_CAT_DPS"] = {
        ["ITEM_MOD_STRENGTH_SHORT"]=2.4, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["MSC_CRIT_PERCENT"]=25.0, ["MSC_HIT_PERCENT"]=20.0, ["MSC_FERAL_AP"]=1.0
    },
    ["FERAL_BEAR_TANK"] = {
        ["ITEM_MOD_ARMOR_SHORT"]=0.1, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["MSC_DODGE_PERCENT"]=15.0, ["MSC_HIT_PERCENT"]=10.0, ["ITEM_MOD_DEFENSE_SKILL_SHORT"]=1.5 
    }
}

-- =============================================================
-- LEVELING WEIGHTS (Era Specific)
-- =============================================================
Druid.LevelingWeights = {
    ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5 },
    ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.4, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["MSC_HIT_PERCENT"]=12.0 },
    
    ["Leveling_Caster_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["MSC_SPELL_HIT_PERCENT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.5 }
}

-- =============================================================
-- ERA TALENTS (31-Point Tree)
-- =============================================================
Druid.Talents = { 
    ["MOONKIN_FORM"]="Moonkin Form", 
    ["NATURES_SWIFTNESS"]="Nature's Swiftness", 
    ["HEART_WILD"]="Heart of the Wild", 
    ["THICK_HIDE"]="Thick Hide",
    ["LEADER_PACK"]="Leader of the Pack",
    ["SWIFTMENDING"]="Swiftmend",
    ["INNATE_ENERVATION"]="Innervate", -- Vanilla check
    ["NATURES_GRACE"]="Nature's Grace"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Druid:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end

        if Rank("MOONKIN_FORM") > 0 then return "Leveling_Caster" .. suffix end
        if Rank("INNATE_ENERVATION") > 0 then return "Leveling_Healer" .. suffix end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("SWIFTMENDING") > 0 then return "RESTO_ERA" end
    if Rank("MOONKIN_FORM") > 0 then return "BALANCE_BOOMKIN" end
    if Rank("LEADER_PACK") > 0 then
        if Rank("THICK_HIDE") >= 3 then return "FERAL_BEAR_TANK" end
        return "FERAL_CAT_DPS"
    end
    
    return "Default"
end

function Druid:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {} 
    
    -- 1. Heart of the Wild (Flat Stat Scaling)
    -- This talent is iconic in Era for the 20% Intellect / 20% Strength bonus
    local rHotW = Rank("HEART_WILD")
    if rHotW > 0 then
        if weights["ITEM_MOD_INTELLECT_SHORT"] then 
            weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.04)) 
        end
        if weights["ITEM_MOD_STRENGTH_SHORT"] then
            weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rHotW * 0.04))
        end
    end

    -- 2. Covariance (Mana Regen / Healing Synergy)
    -- In Era, Spirit is much more valuable for Druids during Innervate
    if currentSpec:find("RESTO") or currentSpec:find("Healer") then
        local healPower = MSC.PlayerStats.HealingPower or 0
        if healPower > 500 then
             local hScaler = 1 + ((healPower - 500) / 5000)
             weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * hScaler
        end
    end

    -- 3. Caps (Hit Cap in Era is 9%)
    if weights["MSC_HIT_PERCENT"] then
        local currentHit = MSC.PlayerStats.Hit or 0
        if currentHit >= 9 then
            weights["MSC_HIT_PERCENT"] = 2.0 -- Drastic drop after 9%
            table.insert(activeCaps, "Hit (9%)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

-- =============================================================
-- FERAL ATTACK POWER (Era Specific)
-- =============================================================
function Druid:GetWeaponBonus(itemLink) 
    -- Logic to extract "Feral Attack Power" from Era staves/maces
    -- Vanilla items like "Atiesh" or "Maul of the Redeemed" have hidden FAP
    return 0 
end

-- =============================================================
-- IDOLS (Classic Era)
-- =============================================================
Druid.Relics = {
    [22398] = { ["MSC_FERAL_AP"] = 20 },      -- Idol of Brutality
    [22396] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 30 }, -- Idol of Health
    [23197] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 33 },   -- Idol of the Moon
}

MSC.RegisterModule("DRUID", Druid)