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

    -- The raid profiles come from the wowsims Forever sim (study/hunter2, 2026-10-03; NOTES.md there has the
    -- numbers), run with each build's own talents, so ApplyScalers' talent hooks skip them. Ranged Attack Power
    -- sits at 1.5; "+Attack Power" on items counts for both melee and ranged, so it carries the same weight.
    -- Beast Mastery: Raid (BM 35 / MM 16 with Summon Hawk, level-63 boss, raid buffs). Hawks on cooldown leave
    -- Beast Mastery short of mana, and Careful Aim turns all of your Intellect into Attack Power, so Intellect
    -- and Mp5 rank above Agility.
    ["BM_RAID"] = { ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=4.13, ["ITEM_MOD_INTELLECT_SHORT"]=5.94, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=14.6, ["ITEM_MOD_HIT_RATING_SHORT"]=32.3, ["ITEM_MOD_CRIT_RATING_SHORT"]=38.6, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=19.4, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    -- Marksmanship: Raid (Lethal Attacks, Mortal Shots, Sniper Shot). About 19% behind Beast Mastery in the sim.
    ["MM_RAID"] = { ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=4.07, ["ITEM_MOD_INTELLECT_SHORT"]=4.64, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=5.7, ["ITEM_MOD_HIT_RATING_SHORT"]=36.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=35.8, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=20.7, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    -- Survival: Raid (MM 15 / Survival 36, shooting; Lightning Reflexes makes Agility the best stat). About 23% behind Beast Mastery.
    ["SV_RAID"] = { ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=4.61, ["ITEM_MOD_INTELLECT_SHORT"]=4.29, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=5.6, ["ITEM_MOD_HIT_RATING_SHORT"]=37.3, ["ITEM_MOD_CRIT_RATING_SHORT"]=30.8, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=20.4, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },

    -- PvP, melee support and farming profiles (not modelled).
    ["PVP_MM_UTIL"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["PVP_SURV_TANK"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["MELEE_NIGHTFALL"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["SOLO_DME_TRIBUTE"] = { ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
}
-- Old names, kept so a saved profile choice still works.
Hunter.Weights["RAID_MM_STANDARD"] = Hunter.Weights["MM_RAID"]
Hunter.Weights["RAID_MM_STARTER"] = Hunter.Weights["MM_RAID"]
Hunter.Weights["RAID_SURV_DEEP"] = Hunter.Weights["SV_RAID"]
-- The sim-built profiles (talents already in): ApplyScalers' talent hooks skip these.
local SIM_PROFILES = { BM_RAID = true, MM_RAID = true, SV_RAID = true, RAID_MM_STANDARD = true, RAID_MM_STARTER = true, RAID_SURV_DEEP = true }

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
-- Filled at load from Classes/Forever/Curves/Hunter_Curves.lua (generated from
-- the study; don't edit it by hand) by Curves_Attach.lua: one row per role and level band,
-- blended by level in MSC:GetLevelingRow. Roles:
--   Leveling          Beast Mastery: Solo Leveling (ranged with the pet tanking, the default)
--   Leveling_Dungeon  Beast Mastery: Dungeon Leveling
--   Leveling_Melee    Survival: Melee Leveling
Hunter.LevelingWeights = {}

-- =============================================================
-- DISPLAY NAMES (match the Talents plugin's builds; translated in Locales/*.lua)
-- =============================================================
local L = MSC.L
local function Band(label, lo, hi) return L[label] .. " (" .. lo .. "-" .. hi .. ")" end
Hunter.PrettyNames = {
    ["BM_RAID"]          = L["Beast Mastery: Raid"],
    ["MM_RAID"]          = L["Marksmanship: Raid"],
    ["SV_RAID"]          = L["Survival: Raid"],
    ["RAID_MM_STANDARD"] = L["Marksmanship: Raid (old profile)"],
    ["RAID_MM_STARTER"]  = L["Marksmanship: Raid (old Surefooted profile)"],
    ["RAID_SURV_DEEP"]   = L["Survival: Raid (old profile)"],
    ["PVP_MM_UTIL"]      = "PvP: Marksmanship Utility",
    ["PVP_SURV_TANK"]    = "PvP: Survival Tank",
    ["MELEE_NIGHTFALL"]  = "Support: Nightfall (Melee)",
    ["SOLO_DME_TRIBUTE"] = "Farming: DM North Solo",

    ["Leveling_1_10"] = Band("Leveling", 1, 10),
}
-- One name per leveling role; each level band gets "(lo-hi)" added.
local ROLE_NAMES = {
    { "Leveling",         "Beast Mastery: Solo Leveling" },
    { "Leveling_Dungeon", "Beast Mastery: Dungeon Leveling" },
    { "Leveling_Melee",   "Survival: Melee Leveling" },
}
for _, r in ipairs(ROLE_NAMES) do
    for _, b in ipairs({ { 11, 20 }, { 21, 40 }, { 41, 51 }, { 52, 59 } }) do
        Hunter.PrettyNames[r[1] .. "_" .. b[1] .. "_" .. b[2]] = Band(r[2], b[1], b[2])
    end
end

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
    ["FEROCITY"]        = "Ferocity", -- BM t4, 5 ranks, +2% pet/hawk crit chance per rank
    ["FRENZY"]          = "Frenzy", -- BM t6, 5 ranks, pet: 20% chance of +30% attack speed for 8 s after a crit
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
    -- No markers (talents can't tell solo from group play): applies only when chosen, e.g. by a Talents plugin build.
    Leveling_Dungeon = {},
}

function Hunter:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")

    if level < 60 then
        if level < 10 then return "Leveling_1_10" end
        local suffix = (level <= 20 and "_11_20") or (level <= 40 and "_21_40") or (level <= 51 and "_41_51") or "_52_59"
        local role = MSC:GetLowLevelRole(Hunter.LowLevelRoles) or "Leveling"
        if Hunter.LevelingWeights[role .. suffix] then return role .. suffix end
        if level == 10 then return "Leveling_1_10" end
        return "Leveling" .. suffix
    end

    -- Endgame: the PvP / melee signatures first, then the tree with the most points.
    if Rank("SNIPER_SHOT") > 0 and Rank("DETERRENCE") > 0 then return "PVP_MM_UTIL" end
    if Rank("COUNTERATTACK") > 0 and Rank("LACERATING_STRIKES") == 0 then return "MELEE_NIGHTFALL" end
    local bm, mm, sv = MSC.GetTabPointsSpent(1), MSC.GetTabPointsSpent(2), MSC.GetTabPointsSpent(3)
    if bm >= mm and bm >= sv then return "BM_RAID" end
    if sv > mm then return "SV_RAID" end
    return "MM_RAID"
end

function Hunter:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    local specU = (currentSpec or ""):upper()
    local isMeleeRow = specU:find("MELEE") ~= nil
    local level = UnitLevel("player")
    -- The sim-built raid profiles already carry their talents: skip the talent hooks (sections up to the
    -- caps) for them; the RAP-crit covariance, hit cap and melee-weapon rules below still apply.
    local hooks = not SIM_PROFILES[currentSpec or ""]

    -- [[ 1. Lightning Reflexes (Agi Scaling) ]]
    -- Forever text: +2%/rank Agility (Classic was 3%)
    local rLR = Rank("LIGHTNING_REF")
    if hooks and rLR > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * (1 + (rLR * 0.02))
    end

    local rSurv = Rank("SURVIVALIST")
    if hooks and rSurv > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rSurv * 0.02))
    end

    -- Mortal Shots (MM t4, 5 ranks): crit damage bonus 2.0 -> 2.3 at 5/5;
    -- the ratio against the AP-equivalent lands near x1.25, so +5%/rank on
    -- Crit (and its Agility crit share). Ranged-only.
    local rMortal = Rank("MORTAL_SHOTS")
    if hooks and rMortal > 0 and not isMeleeRow then
        MSC.ScaleForeverMeleeCrit(weights, 1 + (rMortal * 0.05), level)
    end

    -- Pet-side Beast Mastery (Unleashed Fury, Ferocity, Frenzy): the leveling
    -- curves assume the pet adds ~30% of kill damage with no pet talents.
    -- Deep BM grows that share, which cuts what the hunter's own damage
    -- stats (RAP/AP/Agi/Crit/Hit/weapon DPS) are worth against everything
    -- else. Pet damage multiplier: Unleashed Fury +3%/rank, Ferocity +2%
    -- crit/rank (~+2% damage), Frenzy ~+0.7%/rank (20% proc of +30% speed for
    -- 8 s, only on pet crits). Total damage grows by 0.3*(M-1), so hunter keys
    -- x 1/(1 + 0.3*(M-1)): ~x0.95 at 40, ~x0.91 at 59 for the solo BM build.
    -- Endurance Training / Bestial Wrath are survival/burst only, not scored.
    -- Ranged leveling rows only; Lone Wolf hunters have no pet.
    if specU:find("LEVELING") and not isMeleeRow and Rank("LONE_WOLF") == 0 then
        local petMult = (1 + 0.03 * Rank("UNLEASHED_FURY")) * (1 + 0.02 * Rank("FEROCITY")) * (1 + 0.007 * Rank("FRENZY"))
        if petMult > 1 then
            MSC.ScaleForeverKeys(weights, MSC.ForeverMeleeDamageKeys, 1 / (1 + 0.3 * (petMult - 1)))
        end
    end

    -- Predator's Edge (New in Forever, Survival t4, 5 ranks): +30% crit
    -- damage at 5/5 on Savage Strikes abilities only (~60% of melee damage),
    -- so 1% crit is worth ~1.18x: +3.5%/rank. Melee-only. (Off-hand half is
    -- applied in section 3.)
    local rPredEdge = Rank("PREDATORS_EDGE")
    if hooks and rPredEdge > 0 and isMeleeRow then
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
    if hooks then MSC.ApplyForeverDamageMult(weights, dmgMult, MSC.ForeverManaKeys) end

    -- Bestial Discipline (BM t5, 2 ranks) and Rapid Recuperation (MM t5, 2
    -- ranks): regen while casting, worth +80% / +45% Spirit per rank (regen
    -- is only active ~23% of a kill cycle). Additive, total capped at the
    -- 2-rank Bestial Discipline equivalent (100% regen while casting).
    local regen = 0.8 * Rank("BESTIAL_DISCIPLINE") + 0.45 * Rank("RAPID_RECUPERATION")
    if regen > 1.6 then regen = 1.6 end
    if hooks and regen > 0 and weights["ITEM_MOD_SPIRIT_SHORT"] then
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
    if hooks then MSC.ScaleForeverKeys(weights, { "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_MANA_REGENERATION_SHORT" }, manaMult) end

    -- Careful Aim (MM t2, 5 ranks): Intellect also gives AP (+0.2/rank),
    -- added after the mana-cost scalers so it is not multiplied by them.
    local rAim = Rank("CAREFUL_AIM")
    if hooks and rAim > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] and (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 0) > 0 then
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (weights["ITEM_MOD_ATTACK_POWER_SHORT"] * (rAim * 0.20))
    end

    -- Lone Wolf (MM t3): no pet by design, so the rows' pet-tanking
    -- assumption no longer holds. Ranged rows only.
    local loneWolf = Rank("LONE_WOLF") > 0 and not isMeleeRow
    if hooks and loneWolf then
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
    local isMeleeSpec = spec:find("MELEE") or spec == "PVP_SURV_TANK"
    if not isMeleeSpec and weights["MSC_WEAPON_DPS_MELEE"] == nil and (weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] or 0) > 0 then
        weights["MSC_WEAPON_DPS_MELEE"] = weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] * (loneWolf and 0.30 or 0.15)
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Hunter:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
end

MSC.RegisterModule("HUNTER", Hunter)


