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
-- comes from Agility alone (Strength contributes nothing to a ranged
-- Hunter). The ranged-weapon-damage bonus formula uses the same /14 divisor
-- as melee (RAP/14 x weapon speed), so Weapon DPS = 14x its AP-type weight
-- for both melee- and ranged-anchored profiles. Agility additionally carries
-- a Crit/Dodge premium on top of its 1:1 AP credit that Strength doesn't get.
Hunter.Weights = {
    ["Default"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["RAID_MM_STANDARD"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["RAID_MM_STARTER"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["RAID_SURV_DEEP"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["PVP_MM_UTIL"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["PVP_SURV_TANK"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["MELEE_NIGHTFALL"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["SOLO_DME_TRIBUTE"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Hunter.LevelingWeights = {
    -- Band ladder (Spirit/Mp5/Armor/Defense/school damage by level): see Warrior.lua's LevelingWeights.
    -- Strength/Agility/Weapon DPS corrected to the confirmed 1:1 Hunter
    -- melee-AP formula and 14:1 Weapon DPS:AP ratio (see comment above
    -- Hunter.Weights for the derivation).
    ["Leveling_1_10"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    ["Leveling_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    -- Brought up to match Leveling_1_10/11_20's convention (Hit/Crit/Attack
    -- Power were entirely absent -- zero weight, invisible to scoring; see
    -- Warrior.lua's leveling-bracket comment for the item-database evidence)
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.35, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.25 },

    -- Melee Hunter (same convention fix as above)
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
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Crossbow, Thrown
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
        return "Leveling" .. suffix
    end
    
    -- Fallback Talent Tab Scan
    local _, _, _, _, mmPoints = GetTalentTabInfo(2); mmPoints = mmPoints or 0
    
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

    -- [[ 1. Lightning Reflexes (Agi Scaling) ]]
    -- Confirmed +3%/rank Agility (Same as Classic) -- was miscalibrated at 0.02
    local rLR = Rank("LIGHTNING_REF")
    if rLR > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * (1 + (rLR * 0.03))
    end

    local rSurv = Rank("SURVIVALIST")
    if rSurv > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rSurv * 0.02))
    end

    local rAim = Rank("CAREFUL_AIM")
    if rAim > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] and (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 0) > 0 then
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (weights["ITEM_MOD_ATTACK_POWER_SHORT"] * (rAim * 0.20))
    end

    -- Mortal Shots (MM t4, 5 ranks): +6%/rank ranged crit damage bonus (base
    -- crit bonus is +50%; this raises it, e.g. 5/5 = +30% -> 80% bonus, a
    -- 1.6x multiplier on Crit's value). Ranged-only, so skip the melee spec.
    local rMortal = Rank("MORTAL_SHOTS")
    if rMortal > 0 and not currentSpec:upper():find("MELEE") and weights["ITEM_MOD_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rMortal * 0.12))
    end

    -- Predator's Edge (New in Forever, Survival t4, 5 ranks): +6%/rank melee
    -- crit damage bonus -- same math as Mortal Shots, but melee-only
    local rPredEdge = Rank("PREDATORS_EDGE")
    if rPredEdge > 0 and currentSpec:upper():find("MELEE") and weights["ITEM_MOD_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rPredEdge * 0.12))
    end

    -- Focused Fire (New in Forever, BM t2, 2 ranks): +1%/rank all damage
    -- while pet is active -- assumed active like other classes assume gear
    -- prerequisites (e.g. Bastion assuming a shield)
    local rFocused = Rank("FOCUSED_FIRE")
    if rFocused > 0 then
        if weights["ITEM_MOD_ATTACK_POWER_SHORT"] then
            weights["ITEM_MOD_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_ATTACK_POWER_SHORT"] * (1 + (rFocused * 0.01))
        end
        if weights["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] then
            weights["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] * (1 + (rFocused * 0.01))
        end
    end

    -- Ranged Weapon Specialization (Same as Classic, MM t6, 5 ranks): +1%/rank
    -- ranged weapon damage
    local rRangedSpec = Rank("RANGED_WPN_SPEC")
    if rRangedSpec > 0 and weights["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] then
        weights["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] * (1 + (rRangedSpec * 0.01))
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

    -- [[ 3. Hit Cap (9%) ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        -- FIX: Use Shim. Note: "HIT" generally returns melee/range combined in Vanilla API.
        local currentHit = MSC:GetPlayerStat("HIT")
        local talentHit = Rank("SUREFOOTED") -- 1% per rank in Era
        local totalHit = currentHit + talentHit

        if totalHit >= 9 then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0 -- Cap reached (keep relevant for PvP/higher level mobs)
            table.insert(activeCaps, "Hit (9%)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Hunter:GetWeaponBonus(itemLink, weights)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights)
end

MSC.RegisterModule("HUNTER", Hunter)


