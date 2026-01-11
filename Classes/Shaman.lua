local addonName, MSC = ...
local Shaman = {}
Shaman.Name = "SHAMAN"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Shaman.Weights = {
    ["Default"] = {
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 
    },
    ["ELE_ERA"] = {
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.9, ["MSC_SPELL_CRIT_PERCENT"]=12.0, ["MSC_SPELL_HIT_PERCENT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.6 
    },
    ["ENH_2H"] = {
        ["MSC_WEAPON_SKILL"]=35.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["MSC_CRIT_PERCENT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["MSC_HIT_PERCENT"]=15.0 
    },
    ["RESTO_ERA"] = {
        ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=4.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["MSC_SPELL_CRIT_PERCENT"]=8.0 
    }
}

-- =============================================================
-- LEVELING WEIGHTS (The "Front-Load" Era Meta)
-- =============================================================
Shaman.LevelingWeights = {
    ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
    ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
    ["Leveling_41_60"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["MSC_CRIT_PERCENT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 }
}

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Shaman.Talents = { 
    ["ELE_MASTERY"]    = "Elemental Mastery", 
    ["MANA_TIDE"]      = "Mana Tide Totem", 
    ["STORMSTRIKE"]    = "Stormstrike", 
    ["NATURE_GUIDE"]   = "Nature's Guidance", -- 3% Hit
    ["THIDAL_MASTERY"] = "Tidal Mastery",   -- 5% Crit (Ele/Resto)
    ["TWO_HANDED"]     = "Two-Handed Axes and Maces",
    ["FLURRY"]         = "Flurry"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Shaman:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level < 60 then return "Leveling_21_40" end -- Simplified for Era leveling flow

    -- Endgame Spec Logic
    if Rank("ELE_MASTERY") > 0 then return "ELE_ERA" end
    if Rank("MANA_TIDE") > 0 then return "RESTO_ERA" end
    if Rank("STORMSTRIKE") > 0 then return "ENH_2H" end
    
    return "Default"
end

function Shaman:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Nature's Guidance (Physical & Spell Hit)
    local hitBonus = Rank("NATURE_GUIDE") -- 1% per rank in Era
    
    -- Physical Hit Cap (9% for 2H in Era)
    if weights["MSC_HIT_PERCENT"] then
        local gearHit = MSC.PlayerStats.Hit or 0
        if (gearHit + hitBonus) >= 9 then
            weights["MSC_HIT_PERCENT"] = 2.0 -- Low value after cap
            table.insert(activeCaps, "Phys Hit (9%)")
        end
    end

    -- Spell Hit Cap (16% for Caster)
    if weights["MSC_SPELL_HIT_PERCENT"] then
        local gearSpellHit = MSC.PlayerStats.SpellHit or 0
        if (gearSpellHit + hitBonus) >= 16 then
            weights["MSC_SPELL_HIT_PERCENT"] = 1.0
            table.insert(activeCaps, "Spell Hit (16%)")
        end
    end

    -- 2. Weapon Skill (Orc Racial + Combat)
    if weights["MSC_WEAPON_SKILL"] then
        local _, race = UnitRace("player")
        local skillBonus = (race == "Orc") and 5 or 0
        -- Note: Shamans don't have +Skill talents in Era, unlike Rogues/Warriors
        if skillBonus >= 5 then
            weights["MSC_WEAPON_SKILL"] = 5.0
            table.insert(activeCaps, "Skill (+5)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Shaman:GetWeaponBonus(itemLink)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- Racial: Orc (Axes)
    if race == "Orc" and (subClassID == 0 or subClassID == 1) then 
        bonus = bonus + 50 
    end
    
    return bonus
end

-- =============================================================
-- CLASS SPECIFIC ITEMS (ERA TOTEMS)
-- =============================================================
Shaman.Relics = {
    [22395] = { ITEM_MOD_SPELL_POWER_SHORT = 30 }, -- Totem of Iskar (Era)
    [23200] = { ITEM_MOD_MANA_REGENERATION_SHORT = 4 }, -- Totem of Sustaining
    [22394] = { ITEM_MOD_HEALING_POWER_SHORT = 80 }, -- Totem of Rebirth
}

MSC.RegisterModule("SHAMAN", Shaman)