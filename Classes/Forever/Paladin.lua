local addonName, MSC = ...
local Paladin = {}
Paladin.Name = "PALADIN"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
Paladin.Weights = {
    -- Strength/Attack Power/Weapon DPS below are calibrated to real conversion
    -- math, not picked to "feel" right: 1 Strength = 2 Attack Power for a
    -- plate melee class (so Strength weight = 2x AP weight), and 14 Attack
    -- Power = 1 point of weapon DPS (bonus dmg/swing = AP/14*speed, so
    -- DPS = AP/14 once speed cancels out -- so DPS weight = 14x AP weight).
    -- Agility grants Paladins 0 Attack Power and only a very weak Crit
    -- conversion (~0.05%/point vs Crit Rating's ~1%/14), so it's subordinated
    -- to Strength/Crit here instead of matching their old, copied-from-a-
    -- melee-Agility-class magnitude.
    ["Default"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["HOLY_RAID"] = {  ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=10.0  },
    ["HOLY_DEEP"] = {  ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=10.0  },
    -- PROT_DEEP/PROT_AOE never weighted Strength or AP at all -- added at the
    -- same 2:1 ratio (2.5 instead of 2.2 to credit Strength's extra Block
    -- Value contribution for a shield-equipped Prot spec). Hit stays at 25.0
    -- unchanged -- its pre-cap front-loading is a deliberate threshold-based
    -- design, not part of this linear-conversion fix.
    -- Armor 0.075 (was 0.5): same raid armor math as Warrior's DEEP_PROT
    -- (see Warrior.lua).
    ["PROT_DEEP"] = {  ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.075, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0  },
    ["PROT_AOE"]  = {  ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.075, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0  },
    -- RET_STANDARD: AP sits at 1.5 here (not the 1.0 anchor), so Strength
    -- scales to 3.0 (2x) and Weapon DPS -- entirely missing before -- to 21.0
    -- (14x) to keep both ratios correct at this profile's own AP scale.
    ["RET_STANDARD"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=3.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["SHOCKADIN"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["RECK_BOMB"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=5.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
}

-- =============================================================
-- LEVELING LOGIC
-- =============================================================
Paladin.LevelingWeights = {
    -- Band ladder (Spirit/Mp5/Armor/Defense/school damage by level): see Warrior.lua's LevelingWeights.
    -- Strength/AP/Weapon DPS/Agility recalibrated to the real conversion math
    -- (2:1 Strength:AP, 14:1 DPS:AP, Agility subordinated -- see the Weights
    -- table comment above for the full derivation). Spirit/Intellect are left
    -- untouched on purpose: this file's own "Spirit is King" leveling
    -- philosophy (out-of-combat regen speed while soloing) is a deliberate
    -- design choice, not a math error, so it doesn't get the same treatment.
    -- Spirit still steps down at 41 and 52 with the band ladder (Warrior.lua's
    -- LevelingWeights), once mounts and longer fights cut solo downtime; Hit/
    -- Crit/Spell Power converge on RET_STANDARD by 52-59.
    ["Leveling_1_10"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.25, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=8.0, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["Leveling_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.25, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=8.0, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.25, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=8.0, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.25, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=4.0, ["ITEM_MOD_HIT_RATING_SHORT"]=9.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=5.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.75 },
    ["Leveling_Ret_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.25, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=17.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0 },

    -- Healer/Tank leveling brackets have no early-level sibling to copy, so
    -- these add the stats that were entirely absent (Spell Healing for the
    -- healer; Hit and Defense Skill for the tank) at the same value their own
    -- endgame profile (HOLY_RAID / PROT_DEEP) already uses.
    -- 11-20 healer/tank: same shape as the 52-59 brackets below. The tank adds
    -- Weapon DPS at half the DPS brackets' 14.0 (low-level threat comes almost
    -- entirely from weapon damage) and weights Defense low -- see Warrior.lua's
    -- Leveling_Tank_11_20 comment. The healer adds Mp5 at HOLY_RAID's
    -- Mp5:Healing ratio.
    ["Leveling_Healer_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.9, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_Tank_11_20"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.045, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=7.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },

    ["Leveling_Healer_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.9, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_Healer_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.9, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.9, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0 },
    ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=6.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.3, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.6, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.06, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.3, ["ITEM_MOD_ARMOR_SHORT"]=0.075, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.6, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.6, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Paladin.PrettyNames = {
    ["HOLY_RAID"]       = "Healer: Holy (Illumination)",
    ["HOLY_DEEP"]       = "Healer: Deep Holy (Buffs)",
    ["PROT_DEEP"]       = "Tank: Deep Protection",
    ["PROT_AOE"]        = "Farming: Protection AoE",
    ["RET_STANDARD"]    = "DPS: Retribution",
    ["SHOCKADIN"]       = "PvP: Shockadin (Burst)",
    ["RECK_BOMB"]       = "PvP: Reck-Bomb (One-Shot)",
    -- "RET_UTILITY" removed: GetSpec() used to route here but Paladin.Weights
    -- never defined a matching entry, so selecting it would have resolved to
    -- no weights at all. Folded into RET_STANDARD instead.

    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling (11-20)",
    ["Leveling_Tank_11_20"] = "Leveling: Prot Tank (11-20)",
    ["Leveling_Healer_11_20"] = "Leveling: Holy Healer (11-20)",
    ["Leveling_21_40"]      = "Leveling: Retribution (21-40)",
    ["Leveling_41_51"]      = "Leveling: Retribution (41-51)",
    ["Leveling_Ret_52_59"]  = "Leveling: Pre-BiS Ret (52-59)",
    ["Leveling_Tank_21_40"] = "Leveling: Prot Tank (21-40)",
    ["Leveling_Tank_41_51"] = "Leveling: Prot Tank (41-51)",
    ["Leveling_Tank_52_59"] = "Leveling: Pre-BiS Prot (52-59)",
    ["Leveling_Healer_21_40"] = "Leveling: Holy Healer (21-40)",
    ["Leveling_Healer_41_51"] = "Leveling: Holy Healer (41-51)",
    ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Holy (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Paladin.Talents = {
    ["DIVINE_STR"]      = "Divine Strength",
    ["DIVINE_INT"]      = "Divine Intellect",
    ["HOLY_SHOCK"]      = "Holy Shock",
    ["ILLUMINATION"]    = "Illumination",
    ["HOLY_SHIELD"]     = "Holy Shield",
    ["RECKONING"]       = "Reckoning",
    ["SACRED_DUTY"]     = "Sacred Duty",
    ["REPENTANCE"]      = "Repentance",
    ["VENGEANCE"]       = "Vengeance",
    ["TOUGHNESS"]       = "Toughness",
    ["CHAMPION_LIGHT"]  = "Champion of the Light",
    ["PRECISION"]       = "Precision", -- Protection t2, 3 ranks, +1%/rank Hit
    ["HEALING_LIGHT"]   = "Healing Light", -- Holy t2, 3 ranks, +4%/rank Holy Light/FoL/Holy Shock healing
    ["CRUSADE"]         = "Crusade", -- New in Forever, Retribution t4, 2 ranks, +1%/rank all damage dealt
    ["REDOUBT"]         = "Redoubt", -- Protection t1, 5 ranks, block chance after being hit
    ["ANTICIPATION"]    = "Anticipation", -- Protection t2, 5 ranks, +20 Defense Skill
    ["IMP_RIGHTEOUS_FURY"] = "Improved Righteous Fury", -- Protection t3, 3 ranks
    ["SHIELD_SPEC"]     = "Shield Specialization", -- Protection t3, 3 ranks
    ["SPIRITUAL_FOCUS"] = "Spiritual Focus", -- Holy t2, 2 ranks, pushback protection on heals
    ["REVERENCE"]       = "Reverence", -- New in Forever, Holy t3, 3 ranks, mana regen while casting
    -- "Improved Blessing of Might" doesn't exist anywhere in Forever's Paladin
    -- talent/ability list (confirmed via wowforevertools.com/changes/paladin,
    -- direct search, all status filters). Its only use was a GetSpec() branch
    -- for HOLY_DEEP, whose weights are already identical to HOLY_RAID's, so
    -- removing it doesn't change any actual scoring -- just drops an unreachable
    -- profile-name distinction.
}

-- =============================================================
-- LOGIC
-- =============================================================
Paladin.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes
    [4]=true, [5]=true,   -- 1H/2H Maces
    [7]=true, [8]=true,   -- 1H/2H Swords
    [6]=true              -- Polearms
}

-- Leveling role marker talents (see MSC:GetLowLevelRole). Divine Strength is
-- deliberately not a Holy marker -- it's the standard Ret leveling opener.
Paladin.LowLevelRoles = {
    Leveling_Tank   = { "TOUGHNESS", "REDOUBT", "ANTICIPATION", "IMP_RIGHTEOUS_FURY", "SHIELD_SPEC", "SACRED_DUTY" },
    Leveling_Healer = { "DIVINE_INT", "HEALING_LIGHT", "SPIRITUAL_FOCUS", "REVERENCE" },
}

function Paladin:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")

    -- Leveling Check First
    if level < 60 then
        if level <= 10 then return "Leveling_1_10" end
        local suffix = (level <= 20 and "_11_20") or (level <= 40 and "_21_40") or (level <= 51 and "_41_51") or "_52_59"

        local role = MSC:GetLowLevelRole(Paladin.LowLevelRoles)
        if role and Paladin.LevelingWeights[role .. suffix] then return role .. suffix end
        if suffix == "_52_59" then return "Leveling_Ret_52_59" end
        return "Leveling" .. suffix
    end

    -- Endgame Spec Detection
    if Rank("RECKONING") > 0 and Rank("VENGEANCE") > 0 then return "RECK_BOMB" end
    if Rank("REPENTANCE") > 0 then return "RET_STANDARD" end
    if Rank("HOLY_SHIELD") > 0 then return "PROT_DEEP" end
    if Rank("HOLY_SHOCK") > 0 and Rank("SACRED_DUTY") == 0 then return "SHOCKADIN" end
    if Rank("ILLUMINATION") > 0 and Rank("SACRED_DUTY") > 0 then return "HOLY_RAID" end
    return "HOLY_RAID"
end

function Paladin:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. Divine Strength (+10% Str) ]]
    local rStr = Rank("DIVINE_STR")
    if rStr > 0 and weights["ITEM_MOD_STRENGTH_SHORT"] then 
        weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02)) 
    end

    local rInt = Rank("DIVINE_INT")
    if rInt > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rInt * 0.02)) 
    end

    local rTough = Rank("TOUGHNESS")
    if rTough > 0 and weights["ITEM_MOD_ARMOR_SHORT"] then
        weights["ITEM_MOD_ARMOR_SHORT"] = weights["ITEM_MOD_ARMOR_SHORT"] * (1 + (rTough * 0.02))
    end

    local rSacred = Rank("SACRED_DUTY")
    if rSacred > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rSacred * 0.02))
    end

    local rChamp = Rank("CHAMPION_LIGHT")
    if rChamp > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] and (weights["ITEM_MOD_SPELL_POWER_SHORT"] or 0) > 0 then
        local spWeight = weights["ITEM_MOD_SPELL_POWER_SHORT"]
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (spWeight * (rChamp * 0.11))
    end

    -- Healing Light (Holy t2, 3 ranks): +4%/rank healing from Holy Light /
    -- Flash of Light / Holy Shock -- raises Spell Healing's value for Holy specs
    -- (endgame HOLY_* and the Leveling_Healer_* brackets)
    local rHealLight = Rank("HEALING_LIGHT")
    if rHealLight > 0 and (currentSpec:find("HOLY") or currentSpec:find("Healer")) and weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
        weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rHealLight * 0.04))
    end

    -- Crusade (New in Forever, Retribution t4, 2 ranks): +1%/rank all damage
    -- dealt, unconditional -- raises AP/SP for whichever the spec weights
    local rCrusade = Rank("CRUSADE")
    if rCrusade > 0 then
        if weights["ITEM_MOD_ATTACK_POWER_SHORT"] then
            weights["ITEM_MOD_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_ATTACK_POWER_SHORT"] * (1 + (rCrusade * 0.01))
        end
        if weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rCrusade * 0.01))
        end
    end

    -- [[ 2. Hit Cap (9%) ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        -- FIX: Use Shim
        local currentHit = MSC:GetPlayerStat("HIT")
        -- Precision (Protection t2, 3 ranks): +1%/rank Hit
        local totalHit = currentHit + Rank("PRECISION")
        if totalHit >= 9 then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0 -- Drop value but keep relevant for PvP
            table.insert(activeCaps, "Hit (9%)")
        end
    end
    
    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Paladin:GetWeaponBonus(itemLink, weights)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights)
end

function Paladin:GetRelicBonus(itemID, currentSpec)
    local bonus = {}
    if Paladin.Relics[itemID] then
        for k, v in pairs(Paladin.Relics[itemID]) do bonus[k] = v end
    end
    return bonus
end

-- =============================================================
-- LIBRAMS
-- Wiped for the beta (2026-09-21): these were real TBC Libram item IDs. TBC
-- content isn't part of Forever, so this starts blank and repopulates
-- organically with confirmed Forever Libram IDs, same as the ProcDB/TrinketDB
-- cleanup above.
-- =============================================================
Paladin.Relics = {}

-- Register Profiles for UI
Paladin.Profiles = {}
for k, v in pairs(Paladin.Weights) do Paladin.Profiles[k] = v end
for k, v in pairs(Paladin.LevelingWeights) do Paladin.Profiles[k] = v end

MSC.RegisterModule("PALADIN", Paladin)



