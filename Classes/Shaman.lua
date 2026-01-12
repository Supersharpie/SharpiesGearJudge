local addonName, MSC = ...
local Shaman = {}
Shaman.Name = "SHAMAN"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Shaman.Weights = {
        ["Default"] = {
			["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5 },
        ["ELE_PVE"] = {
			["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3 },
        ["ELE_PVP"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
        ["ENH_STORMSTRIKE"] = {
			["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=10.0 },
        ["RESTO_DEEP"] = {
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 },
        ["RESTO_TOTEM_SUPPORT"] = {
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=4.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=0.5 },
        ["HYBRID_ELE_RESTO"] = {
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 },
        ["HYBRID_ENH_RESTO"] = {
			["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=0.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
    }

-- =============================================================
-- LEVELING WEIGHTS (The "Front-Load" Era Meta)
-- =============================================================
Shaman.LevelingWeights = {
        ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_ARMOR_SHORT"]= 0.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2 },
        ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
        ["Leveling_Caster_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_CRIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        -- Tank Shaman
        ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0 },
        ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5, ["ITEM_MOD_DODGE_RATING_SHORT"]=5.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.2 },
        ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },
    }

-- =============================================================
-- DISPLAY NAMES (For Options Menu)
-- =============================================================
Shaman.PrettyNames = {
        -- Endgame
        ["ELE_PVE"]            = "DPS: Elemental (PvE)",
        ["ELE_PVP"]            = "PvP: Elemental (Burst)",
        ["RESTO_DEEP"]         = "Healer: Deep Restoration",
        ["RESTO_TOTEM_SUPPORT"]= "Healer: Totem Twisting",
        ["ENH_STORMSTRIKE"]    = "DPS: Enhancement",
        ["HYBRID_ELE_RESTO"]   = "Hybrid: Ele / Resto (NS)",
        ["HYBRID_ENH_RESTO"]   = "Hybrid: Enh / Resto (PvP)",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Enhancement (21-40)",
        ["Leveling_41_51"]      = "Leveling: Enhancement (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Enh (52-59)",
        
        ["Leveling_Caster_41_51"] = "Leveling: Elemental (41-51)",
        ["Leveling_Caster_52_59"] = "Leveling: Pre-BiS Ele (52-59)",
        
        ["Leveling_Tank_21_40"]   = "Leveling: Tank Shaman (21-40)",
        ["Leveling_Tank_41_51"]   = "Leveling: Tank Shaman (41-51)",
        ["Leveling_Tank_52_59"]   = "Leveling: Tank Shaman (52-59)",
        
        ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Resto (52-59)",
    }

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Shaman.Talents = { 
        ["ELEMENTAL_MASTERY"] = "Elemental Mastery",
        ["STORMSTRIKE"]       = "Stormstrike",
        ["MANA_TIDE"]         = "Mana Tide Totem",
        ["NATURES_SWIFTNESS"] = "Nature's Swiftness",
        ["LIGHTNING_MASTERY"] = "Lightning Mastery",
        ["FLURRY"]            = "Flurry",
        ["ENHANCING_TOTEMS"]  = "Enhancing Totems",
        ["EYE_OF_STORM"]      = "Eye of the Storm",
        ["ANCESTRAL_KNOW"]    = "Ancestral Knowledge",
        ["NATURE_GUIDANCE"]   = "Nature's Guidance",
        ["ELEMENTAL_FURY"]    = "Elemental Fury",
        ["SHIELD_SPEC"]       = "Shield Specialization",
        ["ANTICIPATION"]      = "Anticipation",
    }

-- =============================================================
-- LOGIC
-- =============================================================
function Shaman:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level < 60 then return "Leveling_21_40" end -- Simplified for Era leveling flow

    if Rank("ELEMENTAL_MASTERY") > 0 then 
        if Rank("EYE_OF_STORM") > 0 then return "ELE_PVP" end
        return "ELE_PVE" 
    end
    if Rank("MANA_TIDE") > 0 then return "RESTO_DEEP" end
    if Rank("STORMSTRIKE") > 0 then return "ENH_STORMSTRIKE" end
    if Rank("NATURES_SWIFTNESS") > 0 and Rank("LIGHTNING_MASTERY") > 0 then return "HYBRID_ELE_RESTO" end
    if Rank("NATURES_SWIFTNESS") > 0 and Rank("FLURRY") > 0 then return "HYBRID_ENH_RESTO" end
    if Rank("ENHANCING_TOTEMS") > 0 and Rank("TIDAL_MASTERY") > 0 then return "RESTO_TOTEM_SUPPORT" end
    return "RESTO_DEEP"
end

function Shaman:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Nature's Guidance (Physical & Spell Hit)
    local hitBonus = Rank("NATURE_GUIDANCE") -- 1% per rank
    
    -- Physical Hit Cap
    -- FIX: Changed MSC_HIT_PERCENT -> ITEM_MOD_HIT_RATING_SHORT
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        local gearHit = MSC.PlayerStats.Hit or 0
        if (gearHit + hitBonus) >= 9 then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0 
            table.insert(activeCaps, "Phys Hit (9%)")
        end
    end

    -- Spell Hit Cap
    -- FIX: Changed MSC_SPELL_HIT_PERCENT -> ITEM_MOD_HIT_SPELL_RATING_SHORT
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then
        local gearSpellHit = MSC.PlayerStats.SpellHit or 0
        if (gearSpellHit + hitBonus) >= 16 then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0
            table.insert(activeCaps, "Spell Hit (16%)")
        end
    end

    -- 2. Weapon Skill (Orc Racial)
    if weights["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] then
        local _, race = UnitRace("player")
        local skillBonus = (race == "Orc") and 5 or 0
        if skillBonus >= 5 then
            weights["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 5.0
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
	[23199] = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 33, estimate = true, replace = true }, -- Totem of the Storm
    [22395] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 65, estimate = true, replace = true }, -- Totem of Life
    [23200] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 40, estimate = true, replace = true }, -- Totem of Sustaining
    [22397] = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 20, estimate = true, replace = true }, -- Totem of Rage
    [20644] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2, estimate = true, replace = true }, -- Totem of Rebirth
}

MSC.RegisterModule("SHAMAN", Shaman)