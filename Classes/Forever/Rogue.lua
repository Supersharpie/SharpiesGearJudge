local addonName, MSC = ...
local Rogue = {}
Rogue.Name = "ROGUE"

-- =============================================================
-- LEVEL-60 WEIGHTS
-- =============================================================
-- Hit and Crit are per 1%; the rest per point. Rogues get 1 Attack Power from
-- each point of Strength and Agility, and Agility also gives crit. The raid
-- profiles come from the wowsims Forever sim run from the Research folder
-- (study/rogue2, 2026-10-03; re-run 2026-10-08 from SharpiesGearJudge-SimStudio). The sim runs
-- each build's own talents (Lethality, Hack and Slash, Dual Wield
-- Specialization...), so ApplyScalers' talent hooks are for the leveling rows.
-- AP sits at 1.5 in the raid profiles.
Rogue.Weights = {
    ["Default"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },

    -- Combat: Raid (Combat swords with Sinister Strike, level-63 boss, raid buffs). Agility is worth about
    -- twice Attack Power (its crit), and Hit and Crit are close. Off-hand weapon DPS is worth a quarter of the main hand's.
    ["COMBAT_RAID"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.97, ["ITEM_MOD_STRENGTH_SHORT"]=1.65, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=36.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=34.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=17.0, ["MSC_WEAPON_DPS_OH"]=4.3, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    -- Combat: Raid (Daggers) (Backstab from behind). About 4% behind swords in the sim.
    ["COMBAT_DAGGERS"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.92, ["ITEM_MOD_STRENGTH_SHORT"]=1.65, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=36.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=33.1, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=15.8, ["MSC_WEAPON_DPS_OH"]=4.9, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    -- Assassination: Raid (Mutilate) (Assassination 31 / Combat 20, daggers). Mutilate hits with both hands, so the
    -- off-hand counts for more; Hit and Crit higher (Seal Fate combo points). About 10% behind Combat swords.
    ["ASSN_MUTILATE"] = { ["ITEM_MOD_AGILITY_SHORT"]=3.15, ["ITEM_MOD_STRENGTH_SHORT"]=1.65, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=39.4, ["ITEM_MOD_CRIT_RATING_SHORT"]=38.7, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=13.5, ["MSC_WEAPON_DPS_OH"]=6.1, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },

}
-- PvP profiles: copies of the PvE profile each build plays like; the PvP model (Helpers 5.10) adds
-- Stamina, armor and burst on top and keeps hit at the player-vs-player caps.
Rogue.Weights["PVP_HEMO"] = MSC.ForeverPvPFrom(Rogue.Weights["COMBAT_RAID"])        -- Hemorrhage with a sword or mace
Rogue.Weights["PVP_MACE"] = MSC.ForeverPvPFrom(Rogue.Weights["COMBAT_RAID"])        -- Mace Specialization stuns
Rogue.Weights["PVP_CB_DAGGER"] = MSC.ForeverPvPFrom(Rogue.Weights["COMBAT_DAGGERS"]) -- Cold Blood / Ambush daggers
-- Old names, kept so a saved profile choice still works.
Rogue.Weights["RAID_COMBAT_SWORDS"] = Rogue.Weights["COMBAT_RAID"]
Rogue.Weights["RAID_COMBAT_DAGGERS"] = Rogue.Weights["COMBAT_DAGGERS"]
Rogue.Weights["RAID_SEAL_FATE"] = Rogue.Weights["ASSN_MUTILATE"]

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
-- Filled at load from Classes/Forever/Curves/Rogue_Curves.lua (generated from
-- the study; don't edit it by hand) by Curves_Attach.lua: one row per role and level band,
-- blended by level in MSC:GetLevelingRow. Roles:
--   Leveling                Combat: Solo Leveling (swords/maces, the default)
--   Leveling_Dagger         Combat Daggers: Solo Leveling (Puncturing Wounds or Mutilate)
--   Leveling_DaggerDungeon  Combat: Dungeon Leveling (daggers, Backstab from behind)
--   Leveling_Hemo           Subtlety: Solo Leveling (Hemorrhage / Ghostly Strike)
Rogue.LevelingWeights = {}

-- =============================================================
-- DISPLAY NAMES (match the Talents plugin's builds; translated in Locales/*.lua)
-- =============================================================
local L = MSC.L
local function Band(label, lo, hi) return L[label] .. " (" .. lo .. "-" .. hi .. ")" end
Rogue.PrettyNames = {
    ["COMBAT_RAID"]         = L["Combat: Raid"],
    ["COMBAT_DAGGERS"]      = L["Combat: Raid (Daggers)"],
    ["ASSN_MUTILATE"]       = L["Assassination: Raid (Mutilate)"],
    ["RAID_COMBAT_SWORDS"]  = L["Combat: Raid (old profile)"],
    ["RAID_COMBAT_DAGGERS"] = L["Combat: Raid (Daggers, old profile)"],
    ["RAID_SEAL_FATE"]      = L["Assassination: Raid (old profile)"],
    ["PVP_MACE"]            = L["PvP: Mace Specialization"],
    ["PVP_HEMO"]            = L["PvP: Hemo Control"],
    ["PVP_CB_DAGGER"]       = L["PvP: Cold Blood Burst"],

    ["Leveling_1_10"] = Band("Leveling", 1, 10),
}
-- One name per leveling role; each level band gets "(lo-hi)" added.
local ROLE_NAMES = {
    { "Leveling",               "Combat: Solo Leveling" },
    { "Leveling_Dagger",        "Combat Daggers: Solo Leveling" },
    { "Leveling_DaggerDungeon", "Combat: Dungeon Leveling" },
    { "Leveling_Hemo",          "Subtlety: Solo Leveling" },
}
for _, r in ipairs(ROLE_NAMES) do
    for _, b in ipairs({ { 11, 20 }, { 21, 40 }, { 41, 51 }, { 52, 59 } }) do
        Rogue.PrettyNames[r[1] .. "_" .. b[1] .. "_" .. b[2]] = Band(r[2], b[1], b[2])
    end
end

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Rogue.Talents = { 
    ["SEAL_FATE"]       = "Seal Fate",
    ["COLD_BLOOD"]      = "Cold Blood",
    ["ADRENALINE_RUSH"] = "Adrenaline Rush",
    ["HACK_AND_SLASH"]  = "Hack and Slash",
    ["PUNCTURING_WOUNDS"]= "Puncturing Wounds",
    ["RIPOSTE"]         = "Riposte",
    ["HEMORRHAGE"]      = "Hemorrhage",
    ["PREPARATION"]     = "Preparation",
    ["LETHALITY"]       = "Lethality",
    ["PRECISION"]       = "Precision",
    ["WEAP_EXPERTISE"]  = "Weapon Expertise",
    ["MUTILATE"]        = "Mutilate",
    ["VENOM"]           = "Venom",
    ["THOUSAND_CUTS"]   = "Thousand Cuts",
    -- Leveling role markers (tiers 1-3, see Rogue.LowLevelRoles)
    ["IMP_SINISTER_STRIKE"] = "Improved Sinister Strike", -- Combat t1
    ["LIGHTNING_REFLEXES"]  = "Lightning Reflexes", -- Combat t1
    ["DEFLECTION"]          = "Deflection", -- Combat t2
    ["OPPORTUNITY"]         = "Opportunity", -- Subtlety t1, Backstab damage
    ["IMP_AMBUSH"]          = "Improved Ambush", -- Subtlety t2
    ["CAMOUFLAGE"]          = "Camouflage", -- Subtlety t1
    ["MASTER_OF_DECEPTION"] = "Master of Deception", -- Subtlety t1
    ["SETUP"]               = "Setup", -- Subtlety t2
    ["ELUSIVENESS"]         = "Elusiveness", -- Subtlety t2
    ["DIRTY_TRICKS"]        = "Dirty Tricks", -- Subtlety t2
    ["INITIATIVE"]          = "Initiative", -- Subtlety t3
    ["GHOSTLY_STRIKE"]      = "Ghostly Strike", -- Subtlety t3
    ["DW_SPEC"]             = "Dual Wield Specialization", -- Combat t4
    ["MALICE"]              = "Malice", -- Assassination t1
    ["RUTHLESSNESS"]        = "Ruthlessness", -- Assassination t2
    ["RELENTLESS_STRIKES"]  = "Relentless Strikes", -- Assassination t3
    ["MURDER"]              = "Murder", -- Assassination t2
    ["IMP_EVISCERATE"]      = "Improved Eviscerate", -- Combat t1
}

-- =============================================================
-- LOGIC
-- =============================================================
Rogue.ValidWeapons = {
    [0]=true,             -- 1H Axes (Forever: SkillRaceClassInfo gives Rogues Axes)
    [4]=true,             -- 1H Maces
    [7]=true,             -- 1H Swords
    [13]=true, [15]=true, -- Fists, Daggers
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Crossbow, Thrown
}

-- Leveling role marker talents (see MSC:GetLowLevelRole). "Leveling" is the
-- Combat (Swords/Maces) default. Assassination picks and generic Combat picks
-- (Improved Eviscerate, Precision, Endurance, Improved Sprint) mark nothing.
Rogue.LowLevelRoles = {
    Leveling        = { "IMP_SINISTER_STRIKE", "LIGHTNING_REFLEXES", "DEFLECTION", "RIPOSTE" },
    -- (Opportunity and Improved Ambush aren't markers: every Subtlety rogue
    -- takes them, which tied pure-Subtlety builds 3-3 and sent them to Combat.)
    Leveling_Dagger = { "PUNCTURING_WOUNDS", "MUTILATE" },
    Leveling_Hemo   = { "CAMOUFLAGE", "MASTER_OF_DECEPTION", "SETUP", "ELUSIVENESS", "DIRTY_TRICKS", "INITIATIVE", "GHOSTLY_STRIKE" },
    -- No markers (talents can't tell solo from group play): applies only when chosen, e.g. by a Talents plugin build.
    Leveling_DaggerDungeon = {},
}

function Rogue:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")

    if level < 60 then
        if level < 10 then return "Leveling_1_10" end
        local suffix = (level <= 20 and "_11_20") or (level <= 40 and "_21_40") or (level <= 51 and "_41_51") or "_52_59"

        -- A Talents plugin build names its role; it wins over the talent markers below.
        local forced = MSC.TalentBuildRole and MSC.TalentBuildRole.leveling
        if forced and (forced == "Leveling" or Rogue.LowLevelRoles[forced]) and Rogue.LevelingWeights[forced .. suffix] then
            return forced .. suffix
        end

        local role = "Leveling" -- Combat swords/maces
        local subPts = MSC.GetTabPointsSpent(3)
        local otherPts = MSC.GetTabPointsSpent(1) + MSC.GetTabPointsSpent(2)
        if Rank("HEMORRHAGE") > 0 then role = "Leveling_Hemo"
        elseif Rank("PUNCTURING_WOUNDS") > 0 or Rank("MUTILATE") > 0 then role = "Leveling_Dagger"
        -- Ghostly Strike, or mostly-Subtlety points, is a Hemo leveler
        elseif Rank("GHOSTLY_STRIKE") > 0 or (subPts >= 5 and subPts > otherPts) then role = "Leveling_Hemo"
        else role = MSC:GetLowLevelRole(Rogue.LowLevelRoles) or role
        end
        if Rogue.LevelingWeights[role .. suffix] then return role .. suffix end
        if level == 10 then return "Leveling_1_10" end
        return "Leveling" .. suffix
    end

    -- Endgame: the PvP signatures first, then the tree with the most points.
    if Rank("HEMORRHAGE") > 0 and Rank("PREPARATION") > 0 then return "PVP_HEMO" end
    if Rank("COLD_BLOOD") > 0 and Rank("PREPARATION") > 0 then return "PVP_CB_DAGGER" end
    local assn, combat = MSC.GetTabPointsSpent(1), MSC.GetTabPointsSpent(2)
    if Rank("MUTILATE") > 0 or Rank("SEAL_FATE") > 0 or assn > combat then return "ASSN_MUTILATE" end
    -- Combat: a dagger in the main hand (Backstab), otherwise swords/maces/fists
    local mh = GetInventoryItemLink("player", 16)
    if mh and select(7, GetItemInfoInstant(mh)) == 15 then return "COMBAT_DAGGERS" end
    return "COMBAT_RAID"
end

function Rogue:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    local spec = currentSpec or ""
    local isLeveling = spec:find("^Leveling") ~= nil
    local level = UnitLevel("player")

    -- Lethality (Assassination t3, 5 ranks): +4%/rank crit damage bonus on
    -- Sinister Strike/Gouge/Backstab/Mutilate/Ghostly Strike/Hemorrhage only.
    -- Melee crits already deal 2.0x, so 5/5 lifts that bonus from 1.00 to 1.20
    -- on those yellow hits alone (not white hits, Ambush, Eviscerate or
    -- poison). Leveling rows scale by how much of the damage those hits carry;
    -- the level-60 profiles come from the sim with Lethality in.
    local rLethal = Rank("LETHALITY")
    if rLethal > 0 and isLeveling then
        local perRank = 0.016
        if spec:find("^Leveling_Dagger") then perRank = 0.010
        elseif spec:find("^Leveling_Hemo") then perRank = 0.008 end
        MSC.ScaleForeverMeleeCrit(weights, 1 + (rLethal * perRank), level)
    end

    if isLeveling then
        -- Dual Wield Specialization (Combat t4, 5 ranks): +5% off-hand damage
        -- per rank; only the white part scales, poison does not (0.045/rank)
        local rDW = Rank("DW_SPEC")
        if rDW > 0 then
            MSC.ScaleForeverKeys(weights, { "MSC_WEAPON_DPS_OH" }, 1 + (rDW * 0.045))
        end

        -- Damage talents the Combat curve does not carry (or carries only
        -- as Improved Eviscerate). Each is a share-weighted damage gain; the
        -- net factor lowers the survival keys the same way a flat damage
        -- talent does (fights end sooner), and a player without the talents
        -- gets 1.0. Skipped for the Dagger/Hemo rows. Dual Wield
        -- Specialization's off-hand key is the hook above; this is only its
        -- overall damage gain (5%/rank on ~19% white off-hand damage, poison
        -- excluded = 0.009/rank). Malice: +1% crit/rank over ~1.2 crit-
        -- adjusted = 0.0085/rank. Ruthlessness: 20%/rank extra combo point
        -- is ~10% shorter cycle at 3/3 on the ~55% yellow share, scaled for
        -- short solo fights = 0.010/rank. Relentless Strikes: 25 energy per
        -- finisher (~90% at 4.5 CP), same scaling = 0.025. Murder: 2%/rank on
        -- ~35% Humanoid/Giant mobs = 0.007/rank. Improved Eviscerate (7%/rank
        -- on ~18% of damage = 0.0125/rank) is baked at 2.14 ranks (the
        -- study's 15%) from level 15, so it is un-baked:
        -- (1+k*rank)/(1+k*bakedRank(level)).
        if not spec:find("^Leveling_Dagger") and not spec:find("^Leveling_Hemo") then
            local bakedIE = MSC.ForeverLevelLerp({ { 10, 0 }, { 15, 2.14 } }, level)
            local dmg = (1 + 0.0125 * Rank("IMP_EVISCERATE")) / (1 + 0.0125 * bakedIE)
            dmg = dmg * (1 + 0.009 * Rank("DW_SPEC") + 0.0085 * Rank("MALICE")
                + 0.010 * Rank("RUTHLESSNESS") + 0.025 * Rank("RELENTLESS_STRIKES")
                + 0.007 * Rank("MURDER"))
            local armor = weights["ITEM_MOD_ARMOR_SHORT"]
            MSC.ApplyForeverDamageMult(weights, dmg)
            -- keep Armor out of the 0-0.02 band the engine treats as unscored
            if armor and armor >= 0.02 and weights["ITEM_MOD_ARMOR_SHORT"] < 0.02 then
                weights["ITEM_MOD_ARMOR_SHORT"] = 0.02
            end
        end

        -- Mutilate (Assassination t5): the off-hand lands a 75% yellow hit per
        -- cast, so off-hand weapon DPS is worth 1.5x and main hand 1.05x
        if spec:find("^Leveling_Dagger") and Rank("MUTILATE") > 0 then
            MSC.ScaleForeverKeys(weights, { "MSC_WEAPON_DPS_OH" }, 1.5)
            MSC.ScaleForeverKeys(weights, { "MSC_WEAPON_DPS_MELEE" }, 1.05)
        end
    end

    -- [[ 1. Yellow Hit Cap, tapered to the DW white cap ]]
    -- Hit % in percent with Precision counted once (MSC:GetForeverHitPercent);
    -- caps follow the level and slide to the raid caps from 50.
    MSC.ApplyForeverHitKnees(weights, "ITEM_MOD_HIT_RATING_SHORT", "MELEE", {
        { cap = MSC.GetForeverCapTarget("MELEE"), mult = 0.6 },
        { cap = MSC.GetForeverCapTarget("DW_WHITE"), mult = 0.05 },
    }, "Yellow Hit", activeCaps)

    -- [[ 2. Weapon Skill Cap (Removed in Forever) ]]

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

-- Hack and Slash (New in Forever, Combat t5, 5 ranks): per-weapon-type bonus.
-- Only the Dagger/Fist branch (+1%/rank Crit) converts cleanly into a score
-- value -- same math as the racial weapon-crit bonuses. The Axe/Sword
-- (extra-attack proc chance) and Mace (armor ignore) branches aren't scored
-- for the same reason Warrior's Weaponmaster's non-crit branches aren't.
-- The +1%/rank crit only helps that hand's swings: the main hand carries all
-- yellow hits plus its white swings (~75% of damage), the off hand only its
-- own white swings (~20%); 0.5 when the hand isn't known.
local function GetHackAndSlashCritBonus(itemLink, weights, slotId)
    local rHS = MSC:GetTalentRank("HACK_AND_SLASH")
    if rHS <= 0 or not itemLink or not weights then return 0 end

    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 or not subClassID then return 0 end
    if subClassID ~= 13 and subClassID ~= 15 then return 0 end -- Fist (13), Dagger (15)

    local slotFactor = (slotId == 16 and 0.75) or (slotId == 17 and 0.2) or 0.5
    -- Crit weight is already "per 1%" (see MSC.GetForeverWeaponRacialBonus)
    return rHS * (weights["ITEM_MOD_CRIT_RATING_SHORT"] or 0) * slotFactor -- +1%/rank Crit
end

-- Backstab and Ambush need a dagger in the main hand, and Ghostly Strike
-- (180%) and Hemorrhage (145%) hit much harder with one, but the weights
-- have no weapon-type term: without this a slightly faster sword outscores
-- the dagger. Flat AP-equivalent bonus for a main-hand dagger, by level.
local DAGGER_MAIN_HAND = {
    Leveling_Dagger = { { 15, 15 }, { 20, 20 }, { 25, 23 }, { 30, 26 }, { 35, 29 }, { 40, 32 }, { 45, 37 }, { 50, 42 }, { 55, 45 }, { 59, 48 } },
    Leveling_Hemo   = { { 17, 0 }, { 18, 27 }, { 20, 29 }, { 25, 28 }, { 30, 26 }, { 35, 28 }, { 40, 29 }, { 45, 33 }, { 50, 39 }, { 55, 42 }, { 59, 45 } },
}
local function GetDaggerMainHandBonus(itemLink, weights, slotId, specName)
    if slotId ~= 16 or not itemLink or not weights then return 0 end
    local spec = specName or MSC.CachedSpecKey or ""
    local points
    for prefix, pts in pairs(DAGGER_MAIN_HAND) do
        if spec:find("^" .. prefix) then points = pts end
    end
    if not points then return 0 end
    local _, _, _, _, _, classID, subClassID = GetItemInfoInstant(itemLink)
    if classID ~= 2 or subClassID ~= 15 then return 0 end
    local level = MSC.CtxLevel()
    local ap = points[#points][2]
    if level <= points[1][1] then ap = points[1][2]
    else
        for i = 1, #points - 1 do
            local a, b = points[i], points[i + 1]
            if level <= b[1] then ap = a[2] + (b[2] - a[2]) * (level - a[1]) / (b[1] - a[1]); break end
        end
    end
    return ap * (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 1)
end

-- Hack and Slash sword (extra-attack chance) and mace (armor ignore)
-- branches, Leveling rows only. D is total damage in AP units by level.
-- Sword: 1%/rank extra attack, worth 0.0105 x rank x D AP on the main hand.
-- Mace: 3%/rank armor ignore = gain(level) x 0.85 (non-poison share) x D x
-- rank/5. The off hand gets half of either.
local HS_TOTAL_DAMAGE = { { 30, 610 }, { 40, 930 }, { 59, 1590 } }
local HS_MACE_GAIN = { { 35, 0.046 }, { 40, 0.056 }, { 45, 0.063 } }
local function GetHackAndSlashProcBonus(itemLink, weights, slotId, specName)
    local rHS = MSC:GetTalentRank("HACK_AND_SLASH")
    if rHS <= 0 or not itemLink or not weights then return 0 end
    local spec = specName or MSC.CachedSpecKey or ""
    if not spec:find("^Leveling") then return 0 end
    if slotId ~= 16 and slotId ~= 17 then return 0 end

    local _, _, _, _, _, classID, subClassID = GetItemInfoInstant(itemLink)
    if classID ~= 2 or (subClassID ~= 7 and subClassID ~= 4) then return 0 end

    local level = MSC.CtxLevel()
    if level < 30 then return 0 end
    local D = MSC.ForeverLevelLerp(HS_TOTAL_DAMAGE, level)
    local ap
    if subClassID == 7 then
        ap = 0.0105 * rHS * D
    else
        ap = MSC.ForeverLevelLerp(HS_MACE_GAIN, level) * 0.85 * D * rHS / 5
    end
    if slotId == 17 then ap = ap * 0.5 end
    return ap * (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 1)
end

function Rogue:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
        + GetHackAndSlashCritBonus(itemLink, weights, slotId)
        + GetHackAndSlashProcBonus(itemLink, weights, slotId, specName)
        + GetDaggerMainHandBonus(itemLink, weights, slotId, specName)
end

MSC.RegisterModule("ROGUE", Rogue)


