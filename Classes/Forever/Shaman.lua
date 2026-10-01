local addonName, MSC = ...
local Shaman = {}
Shaman.Name = "SHAMAN"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
-- Strength/Attack Power/Weapon DPS/Agility calibrated to real conversion
-- math (see Paladin.lua for the base derivation). Enhancement Shaman uses
-- the same 1x Strength + 1x Agility melee-AP formula as Rogue/Hunter (not
-- Warrior/Paladin's Strength-only 2:1), so both are weighted near AP's own
-- value, with Agility carrying an added Crit/Dodge premium. Weapon DPS =
-- 14x AP's weight. Also restoring ELE_PVE/ENH_STORMSTRIKE/RESTO_DEEP's Spell
-- Crit (and ELE_PVE's Spell Power) to match their own sibling profiles --
-- these still carried the old "unknown crit math" hedge values that a prior
-- pass intended to fix but never actually landed in this file.
Shaman.Weights = {
    ["Default"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    -- ELE_PVE: Spell Hit 187.5 / Spell Crit 30 at Spell Power 15 -- 1% Hit =
    -- 12.5 Spell Power (the raid standard) and 1% Crit = 2 Spell Power before
    -- Elemental Fury.
    ["ELE_PVE"] = {  ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=187.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0  },
    ["ELE_PVP"] = {  ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["ENH_STORMSTRIKE"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["RESTO_DEEP"] = {  ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8  },
    -- Healer Spell Crit 48 at Healing 20: 1% crit is worth ~2.4 Healing.
    ["RESTO_TOTEM_SUPPORT"] = {  ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0, ["ITEM_MOD_SPIRIT_SHORT"]=5.0  },
    ["HYBRID_ELE_RESTO"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["HYBRID_ENH_RESTO"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=5.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Shaman.LevelingWeights = {
    -- Band ladder (Spirit/Mp5/Armor/Defense/school damage by level): see Warrior.lua's LevelingWeights.
    -- Strength/Agility/Weapon DPS corrected to the confirmed 1:1 Shaman
    -- melee-AP formula and 14:1 Weapon DPS:AP ratio (see comment above
    -- Shaman.Weights for the derivation).
    ["Leveling_1_10"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.7, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },
    ["Leveling_11_20"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.7, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },
    -- Brought up to match Leveling_1_10/11_20's convention (Hit/Crit/Attack
    -- Power were entirely absent -- zero weight, invisible to scoring; see
    -- Warrior.lua's leveling-bracket comment for the item-database evidence)
    ["Leveling_21_40"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.7, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },
    ["Leveling_41_51"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.7, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.25 },
    ["Leveling_52_59"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.1, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.7, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.1 },

    -- Caster/Healer: matched to ELE_PVP / RESTO_DEEP's own conventions (Spell
    -- Hit/Crit/Healing were absent or negligible -- a healer profile with no
    -- Spell Healing weight at all is a clear-cut gap regardless of scale).
    -- 11-20 healer adds Mp5 at RESTO_DEEP's Mp5:Healing ratio.
    ["Leveling_Healer_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0 },
    ["Leveling_Caster_11_20"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0 },
    ["Leveling_Caster_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0 },
    ["Leveling_Caster_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.75, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=40.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0 },
    ["Leveling_Caster_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=45.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    ["Leveling_Healer_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0 },
    ["Leveling_Healer_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=4.8 },
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=4.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5 },

    -- Tank Shaman (no endgame tank profile exists to copy from -- added Hit
    -- and raised Weapon Skill to match the class's general DPS convention,
    -- since both were absent/low). Armor, Defense and Weapon DPS follow the
    -- band ladder in Warrior.lua's LevelingWeights; Intellect covers Earth
    -- Shock threat and self-heals.
    -- 11-20 adds Weapon DPS at half the DPS brackets' 14.0, since low-level
    -- threat comes almost entirely from weapon damage, and a low Defense
    -- weight (see Warrior.lua's Leveling_Tank_11_20 comment).
    ["Leveling_Tank_11_20"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.045, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=7.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
    ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.5 },
    ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.06, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.075, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.6 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Shaman.PrettyNames = {
    ["ELE_PVE"]             = "DPS: Elemental (PvE)",
    ["ELE_PVP"]             = "PvP: Elemental (Burst)",
    ["RESTO_DEEP"]          = "Healer: Deep Restoration",
    ["RESTO_TOTEM_SUPPORT"] = "Healer: Totem Twisting",
    ["ENH_STORMSTRIKE"]     = "DPS: Enhancement",
    ["HYBRID_ELE_RESTO"]    = "Hybrid: Ele / Resto (NS)",
    ["HYBRID_ENH_RESTO"]    = "Hybrid: Enh / Resto (PvP)",
    
    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling (11-20)",
    ["Leveling_21_40"]      = "Leveling: Enhancement (21-40)",
    ["Leveling_41_51"]      = "Leveling: Enhancement (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Enh (52-59)",
    
    ["Leveling_Caster_11_20"] = "Leveling: Elemental (11-20)",
    ["Leveling_Caster_21_40"] = "Leveling: Elemental (21-40)",
    ["Leveling_Caster_41_51"] = "Leveling: Elemental (41-51)",
    ["Leveling_Caster_52_59"] = "Leveling: Elemental (52-59)",
    ["Leveling_Healer_11_20"] = "Leveling: Resto Dungeon (11-20)",
    ["Leveling_Healer_21_40"] = "Leveling: Resto Dungeon (21-40)",
    ["Leveling_Healer_41_51"] = "Leveling: Resto Dungeon (41-51)",
    ["Leveling_Healer_52_59"] = "Leveling: Resto Dungeon (52-59)",

    ["Leveling_Tank_11_20"]   = "Leveling: Tank Shaman (11-20)",
    ["Leveling_Tank_21_40"]   = "Leveling: Tank Shaman (21-40)",
    ["Leveling_Tank_41_51"]   = "Leveling: Tank Shaman (41-51)",
    ["Leveling_Tank_52_59"]   = "Leveling: Tank Shaman (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Shaman.Talents = { 
    ["LAVA_BURST"]        = "Lava Burst",
    ["STORMSTRIKE"]       = "Stormstrike",
    ["RIPTIDE"]           = "Riptide",
    ["NATURES_SWIFTNESS"] = "Nature's Swiftness",
    ["ELEMENTAL_ALACRITY"]= "Elemental Alacrity", -- Elemental t3 (swapped with Elemental Fury, beta 2026-09-24)
    ["FLURRY"]            = "Flurry",
    ["RESTORATIVE_TOTEMS"]= "Restorative Totems",
    ["EYE_OF_STORM"]      = "Eye of the Storm",
    ["ANCESTRAL_KNOW"]    = "Ancestral Knowledge",
    ["TIDAL_FOCUS"]       = "Tidal Focus",
    ["ELEMENTAL_FURY"]    = "Elemental Fury", -- Elemental t6 (was t3 before the 2026-09-24 beta build)
    ["SPIRIT_WEAPONS"]    = "Spirit Weapons",
    ["ANTICIPATION"]      = "Anticipation",
    ["TIDAL_MASTERY"]     = "Tidal Mastery",
    ["TOUGHNESS"]         = "Toughness",
    ["MENTAL_DEXTERITY"]  = "Mental Dexterity",
    ["MENTAL_QUICKNESS"]  = "Mental Quickness",
    ["RAGE_FARSEER"]      = "Rage of the Farseer",
    ["WATER_SHIELD"]      = "Water Shield",
    ["CONCUSSION"]        = "Concussion", -- Elemental t1, 5 ranks, +1%/rank Lightning Bolt/Chain Lightning/Earth Shock damage
    ["PURIFICATION"]      = "Purification", -- Restoration t6, 5 ranks, +2%/rank universal healing (Same as Classic)
    ["HEALING_WAY"]       = "Healing Way", -- Restoration t5, 3 ranks, +8%/rank Healing Wave healing
    ["IMP_HEALING_WAVE"]  = "Improved Healing Wave", -- Restoration t1, 5 ranks
    ["MINDFULNESS"]       = "Mindfulness", -- New in Forever, Restoration t2, 3 ranks, mana regen while casting
    ["ANCESTRAL_HEALING"] = "Ancestral Healing", -- Restoration t3, 3 ranks
    ["HEALING_FOCUS"]     = "Healing Focus", -- Restoration t3, 3 ranks
    ["CONVECTION"]        = "Convection", -- Elemental t1, 5 ranks
    ["CALL_OF_FLAME"]     = "Call of Flame", -- Elemental t2, 3 ranks
    ["REVERBERATION"]     = "Reverberation", -- Elemental t2, 5 ranks
    ["ELEMENTAL_FOCUS"]   = "Elemental Focus", -- Elemental t3, 1 rank
    ["SHAMANISTIC_FOCUS"] = "Shamanistic Focus", -- Enhancement t3, 1 rank, shock and Lightning Shield mana -45%
    ["IMPROVED_STORMSTRIKE"] = "Improved Stormstrike", -- Enhancement t5, 2 ranks (minLevel 30), new in Forever
}

-- Leveling role marker talents (see MSC:GetLowLevelRole). Anticipation (Enh
-- t3, +6% Dodge) is the only unambiguous tank talent (Toughness and Spirit
-- Weapons are Enhancement DPS picks too), so a tank Shaman is auto-detected
-- from level 20 (tier 3) -- pick the profile manually before that. Tank
-- detection lives in GetSpec (Anticipation plus a guard against a single
-- filler point), so the marker list here is empty.
Shaman.LowLevelRoles = {
    Leveling_Tank   = {},
    Leveling_Healer = { "IMP_HEALING_WAVE", "TIDAL_MASTERY", "MINDFULNESS", "TIDAL_FOCUS", "ANCESTRAL_HEALING", "HEALING_FOCUS", "WATER_SHIELD" },
    Leveling_Caster = { "CONVECTION", "CONCUSSION", "CALL_OF_FLAME", "REVERBERATION", "ELEMENTAL_FOCUS", "ELEMENTAL_ALACRITY", "ELEMENTAL_FURY" },
}

-- =============================================================
-- LOGIC
-- =============================================================
Shaman.ValidWeapons = {
    -- Per the Forever client's SkillRaceClassInfo table: 2H axes and maces
    -- are Shaman skills (the old talent is gone, the skills are not);
    -- polearms are not. Shields are armor, so they never pass through this
    -- list (weapon subclass 6 is Polearms).
    [0]=true, [1]=true,   -- 1H/2H Axes
    [4]=true, [5]=true,   -- 1H/2H Maces
    [10]=true,            -- Staves
    [13]=true, [15]=true, -- Fists, Daggers
}

function Shaman:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        local suffix = ""
        if level <= 10 then suffix = "_1_10"
        elseif level <= 20 then suffix = "_11_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end
        
        -- Detect Roles
        local role = "Leveling" -- Default Enh
        -- Tank needs Anticipation (a lone filler point is only believable
        -- below 25), backed by a second point, Toughness 3+ or Spirit Weapons.
        local rAnti = Rank("ANTICIPATION")
        local isTank = rAnti >= 1 and (level <= 24 or rAnti >= 2 or Rank("TOUGHNESS") >= 3 or Rank("SPIRIT_WEAPONS") > 0)
        if isTank then role = "Leveling_Tank"
        elseif Rank("ELEMENTAL_FURY") > 0 then role = "Leveling_Caster"
        elseif Rank("WATER_SHIELD") > 0 then role = "Leveling_Healer"
        elseif level >= 10 then role = MSC:GetLowLevelRole(Shaman.LowLevelRoles) or role
        end
        
        -- Level 10 brings the first talent point: a role it marks uses that
        -- role's 11-20 row (the 1-10 band only has the default row).
        if level == 10 and role ~= "Leveling" then suffix = "_11_20" end
        local key = role .. suffix
        if Shaman.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("LAVA_BURST") > 0 then 
        if Rank("EYE_OF_STORM") > 0 then return "ELE_PVP" end
        return "ELE_PVE" 
    end
    if Rank("RIPTIDE") > 0 then return "RESTO_DEEP" end
    if Rank("RAGE_FARSEER") > 0 then return "ENH_STORMSTRIKE" end
    if Rank("NATURES_SWIFTNESS") > 0 and Rank("ELEMENTAL_ALACRITY") > 0 then return "HYBRID_ELE_RESTO" end
    if Rank("NATURES_SWIFTNESS") > 0 and Rank("FLURRY") > 0 then return "HYBRID_ENH_RESTO" end
    if Rank("RESTORATIVE_TOTEMS") > 0 and Rank("TIDAL_MASTERY") > 0 then return "RESTO_TOTEM_SUPPORT" end
    return "RESTO_DEEP"
end

function Shaman:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    local level = UnitLevel("player") or 1
    local isTank   = currentSpec:find("Leveling_Tank") ~= nil
    local isCaster = currentSpec:find("Leveling_Caster") ~= nil
    local isHealer = currentSpec:find("Leveling_Healer") ~= nil
    local isEnh    = currentSpec:find("^Leveling") ~= nil and not (isTank or isCaster or isHealer)
    local Lerp = MSC.ForeverLevelLerp
    local Scale = MSC.ScaleForeverKeys
    local INT, SPI, MP5 = "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_MANA_REGENERATION_SHORT"
    local SPELLDMG = { "ITEM_MOD_SPELL_POWER_SHORT", "ITEM_MOD_SPELL_DAMAGE_DONE_SHORT", "ITEM_MOD_NATURE_DAMAGE_SHORT", "ITEM_MOD_FIRE_DAMAGE_SHORT" }

    -- [[ 0. Enhancement/Tank rows bake Stormstrike, Shamanistic Focus and Flurry ]]
    -- Rows assume the talents that the anchors were built with; these undo them
    -- when the point is missing (factors from the per-level model).
    if isEnh or isTank then
        if Rank("STORMSTRIKE") == 0 then
            if isEnh and level >= 25 then
                Scale(weights, { INT }, Lerp({ {25,0.53}, {30,0.56}, {35,0.56}, {40,0.60}, {45,0.63}, {50,0.64}, {55,0.62}, {59,0.61} }, level))
                Scale(weights, { SPI }, 0.77)
                Scale(weights, { MP5 }, 0.85)
                Scale(weights, SPELLDMG, 1.22)
                MSC.ScaleForeverMeleeCrit(weights, 1.13, level)
                Scale(weights, { "ITEM_MOD_HIT_RATING_SHORT" }, 1.07)
                if weights["MSC_WEAPON_SPEED"] then weights["MSC_WEAPON_SPEED"] = 0 end
            elseif isTank then
                if weights["MSC_WEAPON_SPEED"] then weights["MSC_WEAPON_SPEED"] = 0 end
                Scale(weights, { "ITEM_MOD_SPELL_POWER_SHORT" }, 1.18)
                MSC.ScaleForeverMeleeCrit(weights, 1.06, level)
                Scale(weights, { "ITEM_MOD_HIT_RATING_SHORT" }, 1.07)
                Scale(weights, { INT }, Lerp({ {25,0.45}, {35,0.48}, {40,0.76}, {59,0.83} }, level))
                Scale(weights, { SPI }, Lerp({ {25,0.70}, {35,0.72}, {40,0.86}, {59,0.88} }, level))
                Scale(weights, { MP5 }, Lerp({ {35,0.80}, {40,1.07} }, level))
            end
        end

        if Rank("SHAMANISTIC_FOCUS") == 0 then
            if isEnh and level >= 20 then
                Scale(weights, { INT }, Lerp({ {20,1.31}, {25,1.20}, {30,1.23}, {59,1.31} }, level))
                Scale(weights, { SPI }, Lerp({ {20,1.07}, {59,1.14} }, level))
            elseif isTank and level >= 23 then
                Scale(weights, { INT }, Lerp({ {25,1.22}, {40,1.25}, {45,1.27}, {59,1.30} }, level))
                Scale(weights, { SPI }, Lerp({ {25,1.10}, {59,1.15} }, level))
                Scale(weights, { MP5 }, 0.97)
            end
        end

        -- Flurry: rows bake 5/5 (generic crit x1.29 at 30 falling to x1.24
        -- from 45 as geared crit rises; ramped one rank per level 26-30).
        -- Undo the baked part the player lacks. Scaling melee crit also
        -- moves Agility's crit share, so no separate Agility factor.
        local rFlurry = Rank("FLURRY")
        if isEnh and level >= 26 and rFlurry < 5 then
            local full = Lerp({ {30, 1.29}, {45, 1.24} }, level)
            local baked = 1 + (full - 1) * math.min(1, math.max(0, (level - 25) / 5))
            MSC.ScaleForeverMeleeCrit(weights, (1 + 0.05 * rFlurry) / baked, level)
            if rFlurry == 0 and weights["MSC_WEAPON_SPEED"] then
                weights["MSC_WEAPON_SPEED"] = weights["MSC_WEAPON_SPEED"] * 0.95
            end
        end

        for _, k in ipairs({ INT, SPI, MP5, "MSC_WEAPON_SPEED" }) do
            if weights[k] and weights[k] > 0 and weights[k] < 0.02 then weights[k] = 0 end
        end
    end

    local rAK = Rank("ANCESTRAL_KNOW")
    if rAK > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAK * 0.02))
    end

    local rTough = Rank("TOUGHNESS")
    if rTough > 0 then
        Scale(weights, { "ITEM_MOD_STAMINA_SHORT", "ITEM_MOD_HEALTH_SHORT" }, 1 + (rTough * 0.02))
    end

    local rMD = Rank("MENTAL_DEXTERITY")
    if rMD > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] and (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 0) > 0 then
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (weights["ITEM_MOD_ATTACK_POWER_SHORT"] * (rMD * 0.33))
    end

    -- Mental Quickness: the Forever text is the rank-1 value (15% of Intellect
    -- per rank). Healer rows count healing plus the damage half.
    local rMQ = Rank("MENTAL_QUICKNESS")
    if rMQ > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then
        local spWeight
        if isHealer then
            spWeight = (weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0) + (weights["ITEM_MOD_SPELL_POWER_SHORT"] or 0)
        else
            spWeight = weights["ITEM_MOD_SPELL_POWER_SHORT"] or weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or weights["ITEM_MOD_SPELL_DAMAGE_DONE_SHORT"] or 0
        end
        if spWeight > 0 then
            weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (spWeight * (rMQ * 0.15))
        end
    end

    -- Elemental Fury (Elemental t6 since the 2026-09-24 beta build, 5 ranks): same phrasing/math as Mage's
    -- Arcane Mind -- relative growth of the crit damage bonus, 1+rank*0.20,
    -- reaching 2.0x at 5/5 (matches real Classic Elemental Fury exactly)
    local rEleFury = Rank("ELEMENTAL_FURY")
    if rEleFury > 0 and (currentSpec:find("ELE") or currentSpec:find("Caster")) and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * (1 + (rEleFury * 0.20))
    end

    -- Concussion (Elemental t1, 5 ranks): +1%/rank Lightning Bolt/Chain
    -- Lightning/Earth Shock damage -- the core Elemental rotation
    local rConcussion = Rank("CONCUSSION")
    -- Leveling_Caster rows skip it: a flat x1.05 on SP wrongly devalues the
    -- mana stats and hit/crit next to Spell Power (the modelled shift is <1%).
    local rConcussion = Rank("CONCUSSION")
    if rConcussion > 0 and not isCaster and (currentSpec:find("ELE") or currentSpec:find("Caster")) and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
        weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rConcussion * 0.01))
    end

    -- Mindfulness (Restoration t2, 3 ranks): 17% of mana regen continues
    -- while casting per rank, which lifts Spirit only (Mp5 already works in
    -- combat): x1.63 at 3/3.
    local rMind = Rank("MINDFULNESS")
    if isCaster and rMind > 0 and weights["ITEM_MOD_SPIRIT_SHORT"] then
        weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * (1 + (0.21 * rMind))
    end
    -- Healer rows bake Mindfulness into Spirit (1 rank at 15, 3/3 from 20,
    -- x1.143 per rank). Rescale to the rank actually held, so a healer
    -- without it is not credited the baked regen (same relative form as
    -- the Druid Reflection and Paladin Reverence hooks).
    if isHealer and weights["ITEM_MOD_SPIRIT_SHORT"] then
        local bMind = Lerp({ {10, 0}, {15, 1}, {20, 3} }, level)
        if rMind ~= bMind then
            Scale(weights, { "ITEM_MOD_SPIRIT_SHORT" }, (1 + 0.143 * rMind) / (1 + 0.143 * bMind))
        end
    end

    -- Lava Burst (Elemental t7): rows from 40 assume it; without it the
    -- school split falls back to the level-35 one.
    if isCaster and level >= 40 and Rank("LAVA_BURST") == 0 then
        Scale(weights, { "ITEM_MOD_NATURE_DAMAGE_SHORT" }, 1.36)
        Scale(weights, { "ITEM_MOD_FIRE_DAMAGE_SHORT" }, 0.44)
    end

    -- Purification (Restoration t6, 5 ranks, Same as Classic): +2%/rank
    -- universal healing done
    local rPurify = Rank("PURIFICATION")
    -- Healing Way (Restoration t5, 3 ranks): +8%/rank Healing Wave healing --
    -- the dominant Resto heal, so treated like a broad healing-done scaler
    local rHealWay = Rank("HEALING_WAY")
    if isHealer then
        -- Leveling healer rows: one group-side factor m. Healing Way only
        -- lifts Healing Wave (share sHW of healing done), so healing power
        -- gains the full m while Int, Spirit, Mp5 and crit gain their shares.
        if rPurify > 0 or rHealWay > 0 then
            local sHW = (level < 20) and 1.0 or ((level <= 35) and 0.68 or 0.33)
            local m = (1 + 0.02 * rPurify) * (1 + 0.08 * rHealWay * sHW)
            Scale(weights, { "ITEM_MOD_SPELL_HEALING_DONE_SHORT" }, m)
            Scale(weights, { INT }, 1 + 0.40 * (m - 1))
            Scale(weights, { SPI }, 1 + 0.85 * (m - 1))
            Scale(weights, { MP5 }, 1 + 0.82 * (m - 1))
            MSC.ScaleForeverSpellCrit(weights, 1 + 0.65 * (m - 1), level)
        end
    else
        if rPurify > 0 and currentSpec:find("RESTO") and weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
            weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rPurify * 0.02))
        end
        if rHealWay > 0 and currentSpec:find("RESTO") and weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
            weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rHealWay * 0.08))
        end
    end

    -- [[ 1. Hit Caps ]]
    -- Forever Shamans have no Dual Wield, so melee uses the single-weapon cap.
    -- Tidal Focus (+1% hit, all attacks) is already in the game's hit numbers
    -- read by MSC:GetForeverHitPercent, so it isn't added again. Targets are
    -- the level's caps, sliding to the raid caps from 50.
    MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_RATING_SHORT", "MELEE", 0.1, "Phys Hit", activeCaps)
    MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_SPELL_RATING_SHORT", "SPELL", 0.1, "Spell Hit", activeCaps)

    -- [[ 1a. Healer: spell hit (rows carry no Hit weight) ]]
    -- Full value while 1% or more short of the spell cap, fractional inside
    -- the last 1%. Total hit already counts Tidal Focus through the game's
    -- spell hit modifier; the rank is only added if the modifier reads 0.
    if isHealer then
        local total, _, mod = MSC:GetForeverHitPercent("SPELL")
        if (mod or 0) == 0 then total = total + Rank("TIDAL_FOCUS") end
        local cap = MSC.GetForeverCapTarget("SPELL", level) or 4
        local hitBase = Lerp({ {10,1.8}, {15,2.9}, {20,5.1}, {30,5.2}, {35,6.5}, {40,8.7}, {45,8.9}, {50,11.7}, {55,13.5}, {59,14.9} }, level)
        local hitW = hitBase * math.min(1, math.max(0, cap - total))
        if hitW < 0.02 then hitW = 0 end
        weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = hitW
    end

    -- [[ 1b. Tank: defense toward 440, uncrushable (from 50) ]]
    -- Shield tanks like Warriors and Paladins, but with no active block
    -- ability, so only passive block counts toward uncrushable.
    if currentSpec:find("Tank") then
        MSC.ApplyForeverDefenseTarget(weights, activeCaps)
        MSC.ApplyForeverUncrushable(weights, 0, activeCaps)

        -- Spirit Weapons (Enhancement t5): without it a Shaman cannot parry.
        if Rank("SPIRIT_WEAPONS") == 0 and weights["ITEM_MOD_PARRY_RATING_SHORT"] then
            weights["ITEM_MOD_PARRY_RATING_SHORT"] = 0
        end

        -- Improved Stormstrike (Enhancement t5, 2 ranks): 50% per rank (the
        -- client spell holds the max-rank 100%) that Stormstrike's cooldown
        -- resets on a dodge or parry, and that Stormstrike grants 50% mana
        -- regen while casting for 15 sec. The table is the value of a 50%
        -- reset chance per 1% avoidance; at 2/2 the chance doubles.
        local rImpSS = Rank("IMPROVED_STORMSTRIKE")
        if rImpSS > 0 and level >= 30 then
            -- Stormstrike about every 8 sec against a 15 sec buff.
            local uptime = 1 - (1 - 0.5 * math.min(rImpSS, 2)) ^ 1.9
            Scale(weights, { "ITEM_MOD_SPIRIT_SHORT" }, 1 + 0.62 * uptime)
            local add = math.min(rImpSS, 2) * Lerp({ {30,1.9}, {35,2.3}, {40,2.5}, {45,3.2}, {50,3.3}, {55,3.7}, {59,4.0} }, level)
            for _, k in ipairs({ "ITEM_MOD_DODGE_RATING_SHORT", "ITEM_MOD_PARRY_RATING_SHORT" }) do
                if weights[k] and (k ~= "ITEM_MOD_PARRY_RATING_SHORT" or Rank("SPIRIT_WEAPONS") > 0) then
                    weights[k] = weights[k] + add
                end
            end
        end
    end

    -- [[ 2. Weapon Skill Cap (Removed in Forever) ]]
    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Shaman:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
end

function Shaman:GetRelicBonus(itemID, currentSpec)
    return MSC.GetForeverRelicBonus(Shaman.Relics, itemID, currentSpec)
end

-- =============================================================
-- TOTEMS
-- Wiped for the beta (2026-09-21): these were real TBC Totem item IDs. TBC
-- content isn't part of Forever, so this starts blank and repopulates
-- organically with confirmed Forever Totem IDs, same as the ProcDB/TrinketDB
-- cleanup above.
-- =============================================================
-- Forever totems as equivalent stats per spec (MSC.GetForeverRelicBonus).
-- role: "melee" (Enhancement), "tank", "caster" (Elemental), "healer".
-- castShare = the part of a fight spent casting (Elemental/Resto ~0.7,
-- Enhancement/tank ~0.3). Small effects are estimates.
local function ShamanCastShare(role) return (role == "caster" or role == "healer") and 0.7 or 0.3 end
Shaman.Relics = {
    -- Windcarved Effigy: Lightning Bolt costs 5 less. An Elemental leveler
    -- casts about one Lightning Bolt every 6 sec of play: ~4 Mp5.
    [263412] = function(role) return { ITEM_MOD_MANA_REGENERATION_SHORT = (role == "caster") and 4 or 0.8 } end,
    -- Firestorm Totem: totem mana cost -5%
    [263436] = function() return { ITEM_MOD_MANA_REGENERATION_SHORT = 0.5 } end,
    -- Polished Driftwood Icon: 8% of mana regen continues while casting
    [249398] = function(role, ctx)
        return { ITEM_MOD_MANA_REGENERATION_SHORT = 0.08 * ctx.spiritRegen5 * ShamanCastShare(role) }
    end,
    -- Totem of Ancestral Protection: Grounding Totem cooldown -1 sec (PvP)
    [249443] = function() return {} end,
    -- Tidal Totem: Healing Wave mana cost -5%
    [272431] = function(role) return (role == "healer") and { ITEM_MOD_MANA_REGENERATION_SHORT = 8 } or {} end,
    -- Totem of the Storm: Lightning Bolt can trigger Maelstrom Weapon (50% chance)
    [272432] = function(role)
        if role == "caster" then return { ITEM_MOD_SPELL_POWER_SHORT = 8 } end
        if role == "melee" then return { ITEM_MOD_ATTACK_POWER_SHORT = 8 } end
        return {}
    end,
    -- Burning Totem: Flame Shock +3 sec
    [272433] = function(role)
        if role == "caster" then return { ITEM_MOD_SPELL_POWER_SHORT = 5 } end
        if role == "melee" or role == "tank" then return { ITEM_MOD_ATTACK_POWER_SHORT = 5 } end
        return {}
    end,
    -- Totem of Urgency: Lesser Healing Wave crit +4%
    [279249] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 12 } or {} end,

    -- Unchanged Classic totems (Wowhead Classic data). Single-spell bonuses
    -- count at that spell's share of the spec's healing/damage/mana use.
    -- Totem of Rebirth: Reincarnation cooldown -10 min (no score value)
    [22345] = function() return {} end,
    -- Totem of Rage: Earth/Flame/Frost Shock deal up to 30 more (~25% of an
    -- Enhancement Shaman's spell damage, ~20% of an Elemental's)
    [22395] = function(role)
        if role == "caster" then return { ITEM_MOD_SPELL_POWER_SHORT = 6 } end
        if role == "melee" or role == "tank" then return { ITEM_MOD_SPELL_POWER_SHORT = 7.5 } end
        return {}
    end,
    -- Totem of Life: Lesser Healing Wave heals up to 80 more (~50% of healing)
    [22396] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 40 } or {} end,
    -- Totem of Flowing Water: up to 10 mana back per Lesser Healing Wave
    [23005] = function(role) return (role == "healer") and { ITEM_MOD_MANA_REGENERATION_SHORT = 4 } or {} end,
    -- Totem of the Storm (Classic): Lightning Bolt and Chain Lightning deal up
    -- to 33 more (~60% of Elemental damage)
    [23199] = function(role)
        if role == "caster" then return { ITEM_MOD_SPELL_POWER_SHORT = 20 } end
        if role == "melee" then return { ITEM_MOD_SPELL_POWER_SHORT = 5 } end
        return {}
    end,
    -- Totem of Sustaining: Lesser Healing Wave heals up to 53 more
    [23200] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 26 } or {} end,
}

MSC.RegisterModule("SHAMAN", Shaman)


