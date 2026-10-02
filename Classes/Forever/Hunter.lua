local addonName, MSC = ...
local Hunter = {}
Hunter.Name = "HUNTER"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
-- Strength/Attack Power/Ranged Attack Power/Weapon DPS/Agility calibrated to
-- real conversion math (see Paladin.lua for the base derivation). Hunter's
-- own formula differs from Warrior/Paladin's: melee Attack Power = 1x
-- Strength + 1x Agility (not Strength-only 2:1), and Ranged Attack Power
-- comes from Agility alone at 2 RAP per point, as in original Classic
-- (Strength contributes nothing to a ranged Hunter). Confirmed in the
-- Forever client's ChrClasses table (build 1.60.1.70009): Hunter
-- RangedAttackPowerPerAgility=2, AttackPowerPerAgility=1,
-- AttackPowerPerStrength=1. The ranged-weapon-damage bonus formula uses the same
-- /14 divisor as melee (RAP/14 x weapon speed), so Weapon DPS = 14x its
-- AP-type weight for both melee- and ranged-anchored profiles. Agility
-- additionally carries a Crit/Dodge premium on top of its AP credit that
-- Strength doesn't get: ranged profiles = 2 (RAP) + premium, melee profiles
-- (Survival/Nightfall/Leveling_Melee) = 1 (melee AP) + premium.
Hunter.Weights = {
    ["Default"] = { ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["RAID_MM_STANDARD"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=3.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["RAID_MM_STARTER"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=3.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["RAID_SURV_DEEP"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["PVP_MM_UTIL"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["PVP_SURV_TANK"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["MELEE_NIGHTFALL"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["SOLO_DME_TRIBUTE"] = { ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Hunter.LevelingWeights = {
    -- Band ladder (Spirit/Mp5/Armor/Defense/school damage by level): see Warrior.lua's LevelingWeights.
    -- Agility/Weapon DPS follow the Hunter AP formula and 14:1 Weapon DPS:AP
    -- ratio (see comment above Hunter.Weights for the derivation). The ranged
    -- rows carry no Strength (it only adds melee AP); the melee rows keep it
    -- at 1.0 (1 melee AP per Strength).
    ["Leveling_1_10"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    ["Leveling_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    -- Brought up to match Leveling_1_10/11_20's convention (Hit/Crit/Attack
    -- Power were entirely absent -- zero weight, invisible to scoring; see
    -- Warrior.lua's leveling-bracket comment for the item-database evidence)
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.35, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.25 },

    -- Melee Hunter (same convention fix as above). 11-20 is the same shape
    -- as 21-40 (the ranged 11-20/21-40 rows match too).
    ["Leveling_Melee_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_Melee_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_Melee_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_Melee_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Hunter.PrettyNames = {
    ["RAID_MM_STANDARD"] = "Raid: Marksmanship (Standard)",
    ["RAID_MM_STARTER"]  = "Raid: MM (Surefooted)",
    ["RAID_SURV_DEEP"]   = "Raid: Deep Survival (Agi)",
    ["PVP_MM_UTIL"]      = "PvP: Marksmanship Utility",
    ["PVP_SURV_TANK"]    = "PvP: Survival Tank",
    ["MELEE_NIGHTFALL"]  = "Support: Nightfall (Melee)",
    ["SOLO_DME_TRIBUTE"] = "Farming: DM North Solo",
    
    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling (11-20)",
    ["Leveling_21_40"]      = "Leveling: Beast Mastery (21-40)",
    ["Leveling_41_51"]      = "Leveling: Beast Mastery (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Hunter (52-59)",
    
    ["Leveling_Melee_11_20"] = "Leveling: Melee/Survival (11-20)",
    ["Leveling_Melee_21_40"] = "Leveling: Melee/Survival (21-40)",
    ["Leveling_Melee_41_51"] = "Leveling: Melee/Survival (41-51)",
    ["Leveling_Melee_52_59"] = "Leveling: Melee/Survival (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Hunter.Talents = { 
    ["BESTIAL_WRATH"]   = "Bestial Wrath",
    ["UNLEASHED_FURY"]  = "Unleashed Fury",
    ["TRUESHOT_AURA"]   = "Trueshot Aura",
    ["SNIPER_SHOT"]     = "Sniper Shot",
    ["LACERATING_STRIKES"]= "Lacerating Strikes",
    ["COUNTERATTACK"]   = "Counterattack",
    ["DETERRENCE"]      = "Deterrence",
    ["SUREFOOTED"]      = "Surefooted",
    ["LIGHTNING_REF"]   = "Lightning Reflexes",
    ["MORTAL_SHOTS"]    = "Mortal Shots",
    ["SURVIVALIST"]     = "Survivalist",
    ["CAREFUL_AIM"]     = "Careful Aim",
    ["PREDATORS_EDGE"]  = "Predator's Edge", -- New in Forever (Survival t4, 5 ranks, +6%/rank melee crit damage bonus)
    ["FOCUSED_FIRE"]    = "Focused Fire", -- New in Forever (BM t2, 2 ranks, +1%/rank all damage while pet active)
    ["RANGED_WPN_SPEC"] = "Ranged Weapon Specialization", -- Same as Classic (MM t6, 5 ranks, +1%/rank ranged weapon damage)
    ["BARRAGE"]         = "Barrage", -- MM t5, 3 ranks, +3%/rank Multi-Shot/Aimed Shot/Volley damage
    ["DEADLY_ASPECTS"]  = "Deadly Aspects", -- BM t1, 5 ranks, 2%/rank chance of +30% attack speed
    ["IMP_TRACKING"]    = "Improved Tracking", -- Survival t1, 5 ranks, +1%/rank damage vs tracked type
    ["BESTIAL_DISCIPLINE"] = "Bestial Discipline", -- BM t5, 2 ranks, +25%/rank regen while casting
    ["RAPID_RECUPERATION"] = "Rapid Recuperation", -- MM t5, 2 ranks
    ["EFFICIENCY"]      = "Efficiency", -- MM t2, 5 ranks, -3%/rank mana cost
    ["RESOURCEFULNESS"] = "Resourcefulness", -- Survival t5, 2 ranks, -30%/rank trap/melee ability mana cost
    ["LONE_WOLF"]       = "Lone Wolf", -- MM t3, 1 rank, +20% damage without a pet
    -- Leveling role markers (tiers 1-3, see Hunter.LowLevelRoles)
    ["SAVAGE_STRIKES"]  = "Savage Strikes", -- Survival t2, 2 ranks, +2% melee ability crit
    ["IMP_WING_CLIP"]   = "Improved Wing Clip", -- Survival t2, 3 ranks
    ["DEFLECTION"]      = "Deflection", -- Survival t1, 5 ranks, +1% Parry per rank (2 Oct patch, was 2%)
    ["HAWK_EYE"]        = "Hawk Eye", -- MM t1, 3 ranks, +2 yd ranged weapon range
    ["IMP_CONC_SHOT"]   = "Improved Concussive Shot", -- MM t1, 5 ranks
    ["IMP_STINGS"]      = "Improved Stings", -- MM t2, 3 ranks
    ["IMP_ARCANE_SHOT"] = "Improved Arcane Shot", -- MM t3, 5 ranks
    ["RAPID_KILLING"]   = "Rapid Killing", -- MM t3, 2 ranks
    -- "Aimed Shot" and "Wyvern Sting" removed: both are confirmed base
    -- abilities in Forever (level-gated, no talent rank), not talents --
    -- GetTalentRank on either always returned 0. Both were already unused
    -- elsewhere in this file, so no behavior change.
}

-- =============================================================
-- LOGIC
-- =============================================================
Hunter.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes
    [7]=true, [8]=true,   -- 1H/2H Swords
    [6]=true,             -- Polearms
    [10]=true,            -- Staves
    [13]=true, [15]=true, -- Fists, Daggers
    [2]=true, [3]=true, [18]=true, -- Bow, Gun, Crossbow
    [16]=true,                     -- Thrown: equippable, but see StatsOnlyWeapons
}

-- Hunters can equip a thrown weapon but can't Auto Shot or use shots with
-- it, so it's scored on its stats only (e.g. an Agility thrown weapon as a
-- ranged-slot stat stick); its DPS counts for nothing.
Hunter.StatsOnlyWeapons = { [16] = true }

-- Leveling role marker talents (see MSC:GetLowLevelRole). "Leveling" is the
-- ranged default; its markers are ranged-only Marksmanship picks, so a Hunter
-- who mixes trees goes melee only when melee picks outnumber them. Beast
-- Mastery and generic picks (Lethal Attacks, Efficiency) mark neither.
Hunter.LowLevelRoles = {
    Leveling       = { "HAWK_EYE", "IMP_CONC_SHOT", "IMP_STINGS", "IMP_ARCANE_SHOT", "RAPID_KILLING" },
    Leveling_Melee = { "DEFLECTION", "SAVAGE_STRIKES", "IMP_WING_CLIP", "COUNTERATTACK", "PREDATORS_EDGE", "LACERATING_STRIKES" },
}

function Hunter:GetSpec()
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

        local role = (level >= 10) and MSC:GetLowLevelRole(Hunter.LowLevelRoles) or "Leveling"
        -- Level 10 brings the first talent point: a role it marks uses that
        -- role's 11-20 row (the 1-10 band only has the default row).
        if level == 10 and role ~= "Leveling" then suffix = "_11_20" end
        local key = role .. suffix
        if Hunter.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end
    
    -- Fallback Talent Tab Scan
    local mmPoints = MSC.GetTabPointsSpent(2)
    
    -- Endgame
    if Rank("LACERATING_STRIKES") > 0 then return "RAID_SURV_DEEP" end
    if Rank("SNIPER_SHOT") > 0 and Rank("UNLEASHED_FURY") > 0 then return "RAID_MM_STANDARD" end
    if Rank("SNIPER_SHOT") > 0 and Rank("SUREFOOTED") > 0 then return "RAID_MM_STARTER" end
    if Rank("SNIPER_SHOT") > 0 and Rank("DETERRENCE") > 0 then return "PVP_MM_UTIL" end
    if Rank("COUNTERATTACK") > 0 then return "MELEE_NIGHTFALL" end
    if mmPoints >= 30 then return "RAID_MM_STANDARD" end
    return "RAID_MM_STANDARD"
end

function Hunter:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    local specU = (currentSpec or ""):upper()
    local isMeleeRow = specU:find("MELEE") ~= nil
    local level = UnitLevel("player")

    -- [[ 1. Lightning Reflexes (Agi Scaling) ]]
    -- Forever text: +2%/rank Agility (Classic was 3%)
    local rLR = Rank("LIGHTNING_REF")
    if rLR > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * (1 + (rLR * 0.02))
    end

    local rSurv = Rank("SURVIVALIST")
    if rSurv > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rSurv * 0.02))
    end

    -- Mortal Shots (MM t4, 5 ranks): crit damage bonus 2.0 -> 2.3 at 5/5;
    -- the ratio against the AP-equivalent lands near x1.25, so +5%/rank on
    -- Crit (and its Agility crit share). Ranged-only.
    local rMortal = Rank("MORTAL_SHOTS")
    if rMortal > 0 and not isMeleeRow then
        MSC.ScaleForeverMeleeCrit(weights, 1 + (rMortal * 0.05), level)
    end

    -- Predator's Edge (New in Forever, Survival t4, 5 ranks): +30% crit
    -- damage at 5/5 on Savage Strikes abilities only (~60% of melee damage),
    -- so 1% crit is worth ~1.18x: +3.5%/rank. Melee-only. (Off-hand half is
    -- applied in section 3.)
    local rPredEdge = Rank("PREDATORS_EDGE")
    if rPredEdge > 0 and isMeleeRow then
        MSC.ScaleForeverMeleeCrit(weights, 1 + (rPredEdge * 0.035), level)
    end

    -- Damage-percent family: each talent multiplies total damage, applied
    -- once as a product by dividing the non-damage stats (Stamina/Health/
    -- Armor/Dodge/etc. plus the mana keys).
    --   Ranged Weapon Specialization (MM t6, 1%/rank, ranged)
    --   Focused Fire (BM t2, 1%/rank, pet out)
    --   Barrage (MM t5, 3 ranks of 3% on Multi/Aimed/Volley, ~1%/rank of total, ranged)
    --   Deadly Aspects (BM t1, ~1.4%/rank ranged, ~1.2%/rank melee)
    --   Improved Tracking (Survival t1, 1%/rank vs the tracked type)
    local dmgMult = 1
    dmgMult = dmgMult * (1 + Rank("FOCUSED_FIRE") * 0.01)
    dmgMult = dmgMult * (1 + Rank("IMP_TRACKING") * 0.01)
    if isMeleeRow then
        dmgMult = dmgMult * (1 + Rank("DEADLY_ASPECTS") * 0.012)
    else
        dmgMult = dmgMult * (1 + Rank("RANGED_WPN_SPEC") * 0.01)
        dmgMult = dmgMult * (1 + Rank("BARRAGE") * 0.01)
        dmgMult = dmgMult * (1 + Rank("DEADLY_ASPECTS") * 0.014)
    end
    MSC.ApplyForeverDamageMult(weights, dmgMult, MSC.ForeverManaKeys)

    -- Bestial Discipline (BM t5, 2 ranks) and Rapid Recuperation (MM t5, 2
    -- ranks): regen while casting, worth +80% / +45% Spirit per rank (regen
    -- is only active ~23% of a kill cycle). Additive, total capped at the
    -- 2-rank Bestial Discipline equivalent (100% regen while casting).
    local regen = 0.8 * Rank("BESTIAL_DISCIPLINE") + 0.45 * Rank("RAPID_RECUPERATION")
    if regen > 1.6 then regen = 1.6 end
    if regen > 0 and weights["ITEM_MOD_SPIRIT_SHORT"] then
        weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * (1 + regen)
    end

    -- Efficiency (MM t2, 5 ranks): -3% mana cost per rank. Resourcefulness
    -- (Survival t5, 2 ranks, melee): -30% per rank on trap and melee
    -- abilities, capped at 1.6. Multiplicative, combined cap 1.8. Applied
    -- to the mana keys BEFORE Careful Aim adds its AP-based Intellect.
    local rEff = Rank("EFFICIENCY")
    local manaMult = 1
    if rEff > 0 then manaMult = 1 / (1 - 0.03 * rEff) end
    local rRes = Rank("RESOURCEFULNESS")
    if isMeleeRow and rRes > 0 then
        -- 2 ranks; clamp so a bad rank read can never drive the divisor negative
        rRes = math.min(rRes, 2)
        manaMult = manaMult * math.min(1.6, 1 / (1 - 0.30 * rRes))
    end
    if manaMult > 1.8 then manaMult = 1.8 end
    MSC.ScaleForeverKeys(weights, { "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_MANA_REGENERATION_SHORT" }, manaMult)

    -- Careful Aim (MM t2, 5 ranks): Intellect also gives AP (+0.2/rank),
    -- added after the mana-cost scalers so it is not multiplied by them.
    local rAim = Rank("CAREFUL_AIM")
    if rAim > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] and (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 0) > 0 then
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (weights["ITEM_MOD_ATTACK_POWER_SHORT"] * (rAim * 0.20))
    end

    -- Lone Wolf (MM t3): no pet by design, so the rows' pet-tanking
    -- assumption no longer holds. Ranged rows only.
    local loneWolf = Rank("LONE_WOLF") > 0 and not isMeleeRow
    if loneWolf then
        MSC.ScaleForeverKeys(weights, { "ITEM_MOD_STAMINA_SHORT", "ITEM_MOD_HEALTH_SHORT" }, 1.5)
        MSC.ScaleForeverKeys(weights, { "ITEM_MOD_STRENGTH_SHORT" }, 2)
    end

    -- Keep tiny survival weights from lingering: zero anything in (0, 0.02),
    -- except Armor which holds its floor.
    for k, v in pairs(weights) do
        if type(v) == "number" and v > 0 and v < 0.02 then
            weights[k] = (k == "ITEM_MOD_ARMOR_SHORT") and 0.02 or 0
        end
    end

    -- [[ 2. Covariance (Crit scales with RAP) ]]
    if weights["ITEM_MOD_CRIT_RATING_SHORT"] then
        local rawBase, rawPos, rawNeg = UnitRangedAttackPower("player")
        local base = MSC.SanitizeStat(rawBase)
        local pos = MSC.SanitizeStat(rawPos)
        local neg = MSC.SanitizeStat(rawNeg)
        local totalRAP = base + pos + neg
        if totalRAP > 1500 then
            local rapScaler = 1 + ((totalRAP - 1500) / 10000)
            if rapScaler > 1.2 then rapScaler = 1.2 end
            weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * rapScaler
        end
    end

    -- [[ 3. Hit Cap ]]
    -- Ranged hit for ranged profiles, melee hit for melee ones (Surefooted
    -- is included once by MSC:GetForeverHitPercent). Target is the level's
    -- cap, sliding to the raid cap from 50; past it Hit keeps 10% of its value.
    local hitKind = (currentSpec or ""):upper():find("MELEE") and "MELEE" or "RANGED"
    -- Hunters learn Dual Wield at 20; a melee Hunter with a weapon in the
    -- off-hand uses the dual-wield curve (60% past the yellow cap up to the
    -- white cap), like Rogues and DW Warriors.
    local offhand = GetInventoryItemLink("player", 17)
    local dualWielding = hitKind == "MELEE" and offhand and select(6, GetItemInfoInstant(offhand)) == 2
    if dualWielding then
        MSC.ApplyForeverHitKnees(weights, "ITEM_MOD_HIT_RATING_SHORT", "MELEE", {
            { cap = MSC.GetForeverCapTarget("MELEE"), mult = 0.6 },
            { cap = MSC.GetForeverCapTarget("DW_WHITE"), mult = 0.05 },
        }, "Yellow Hit", activeCaps)
    else
        MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_RATING_SHORT", hitKind, 0.1, "Hit", activeCaps)
    end

    -- Predator's Edge also adds 10%/rank off-hand damage (client: +50% at
    -- 5/5). Off-hand DPS normally counts at half the main-hand weight.
    local rEdge = Rank("PREDATORS_EDGE")
    if hitKind == "MELEE" and rEdge > 0 and (weights["MSC_WEAPON_DPS_MELEE"] or 0) > 0 then
        weights["MSC_WEAPON_DPS_OH"] = weights["MSC_WEAPON_DPS_MELEE"] * 0.5 * (1 + 0.1 * rEdge)
    end

    -- [[ 4. Melee Weapon = Stat Stick ]]
    -- Weapon DPS weight is calibrated for the ranged slot. A ranged Hunter
    -- only swings the melee weapon for the odd Raptor Strike / Wing Clip, so
    -- its DPS is worth a fraction of that; its stats still count in full.
    -- Melee-anchored profiles (Melee/Nightfall, and the AP-weighted Survival
    -- profiles built around Lacerating Strikes) keep full melee DPS. The
    -- leveling curves set their own melee-slot DPS, so only fill it in when
    -- a profile leaves it out.
    local spec = (currentSpec or ""):upper()
    local isMeleeSpec = spec:find("MELEE") or spec == "RAID_SURV_DEEP" or spec == "PVP_SURV_TANK"
    if not isMeleeSpec and weights["MSC_WEAPON_DPS_MELEE"] == nil and (weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] or 0) > 0 then
        weights["MSC_WEAPON_DPS_MELEE"] = weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] * (loneWolf and 0.30 or 0.15)
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Hunter:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
end

MSC.RegisterModule("HUNTER", Hunter)


