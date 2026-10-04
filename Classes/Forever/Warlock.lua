local addonName, MSC = ...
local Warlock = {}
Warlock.Name = "WARLOCK"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
-- NOTE: In Era Helpers.lua, 1.0 Rating = 1% Hit/Crit. 
-- We use standard keys so the Evaluator can match them.

Warlock.Weights = {
    ["Default"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.1, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0  },

    -- The raid profiles come from the wowsims Forever sim (study/warlock2, 2026-10-03; NOTES.md there has the numbers),
    -- run with each build's own talents and demon, so ApplyScalers' talent hooks skip them. Spell Power sits at 2.0;
    -- Hit and Crit per 1%. Most of the damage is Shadow. Stamina is a small Life Tap / safety term (the sim's three-
    -- minute fight never runs a warlock dry).
    -- Demonology: Raid (Demonic Pact 5/31/15: Succubus out with a sacrificed Imp's buff kept). About 19% ahead of Affliction.
    ["DEMO_PACT_RAID"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.78, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=0.22, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=14.1, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=15.6, ["ITEM_MOD_INTELLECT_SHORT"]=0.52, ["ITEM_MOD_SPIRIT_SHORT"]=0.32, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.44, ["ITEM_MOD_STAMINA_SHORT"]=0.3 },
    -- Affliction: Raid (Affliction 35 / Destruction 16, Succubus).
    ["AFF_RAID"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.72, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=0.28, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.6, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=14.6, ["ITEM_MOD_INTELLECT_SHORT"]=0.52, ["ITEM_MOD_SPIRIT_SHORT"]=0.24, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.48, ["ITEM_MOD_STAMINA_SHORT"]=0.3 },
    -- Destruction: Raid (DS/Ruin with Pandemic: the Imp sacrificed). About 28% behind Demonology.
    ["DESTRO_RAID"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.78, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=0.22, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=15.7, ["ITEM_MOD_INTELLECT_SHORT"]=0.48, ["ITEM_MOD_SPIRIT_SHORT"]=0.28, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.38, ["ITEM_MOD_STAMINA_SHORT"]=0.3 },
    -- Demonology: AoE Farming (Soul Link with Rain of Fire / Hellfire on 4-5 mob packs; a rough model). Hellfire burns you
    -- for as much as each enemy and Life Tap pays for the mana in health, so Stamina leads; Fire damage and mana stats next,
    -- Spell Power counts little (Hellfire and Rain of Fire take a small share of it).
    ["DEMO_FARM"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05 },

    -- PvP profiles (not modelled).
    ["PVP_NF_CONFLAG"] = {  ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["PVP_SOUL_LINK"] = {  ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["PVP_DEEP_DESTRO"] = {  ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_INTELLECT_SHORT"]=5.0  },
}
-- Old names, kept so a saved profile choice still works.
Warlock.Weights["PVE_MD_RUIN"] = Warlock.Weights["DEMO_PACT_RAID"]
Warlock.Weights["RAID_SM_RUIN"] = Warlock.Weights["AFF_RAID"]
Warlock.Weights["RAID_DS_RUIN"] = Warlock.Weights["DESTRO_RAID"]
-- The sim-built raid profiles (talents already in): ApplyScalers' talent hooks skip these.
local SIM_PROFILES = { DEMO_PACT_RAID = true, AFF_RAID = true, DESTRO_RAID = true, PVE_MD_RUIN = true, RAID_SM_RUIN = true, RAID_DS_RUIN = true }

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
-- Filled at load from Classes/Forever/Curves/Warlock_Curves.lua (generated from
-- the study; don't edit it by hand) by Curves_Attach.lua: one row per role and level band,
-- blended by level in MSC:GetLevelingRow. Roles:
--   Leveling          Affliction: Solo Leveling (DoTs + Voidwalker, the default)
--   Leveling_Dungeon  Affliction: Dungeon Leveling
--   Leveling_Demo     Demonology: Solo Leveling (Soul Link; also the AoE farming build's leveling)
--   Leveling_Fire     Destruction: Solo Leveling
Warlock.LevelingWeights = {}

-- =============================================================
-- DISPLAY NAMES (match the Talents plugin's builds; translated in Locales/*.lua)
-- =============================================================
local L = MSC.L
local function Band(label, lo, hi) return L[label] .. " (" .. lo .. "-" .. hi .. ")" end
Warlock.PrettyNames = {
    ["DEMO_PACT_RAID"] = L["Demonology: Raid"],
    ["AFF_RAID"]       = L["Affliction: Raid"],
    ["DESTRO_RAID"]    = L["Destruction: Raid"],
    ["DEMO_FARM"]      = L["Demonology: AoE Farming"],
    ["PVE_MD_RUIN"]    = L["Demonology: Raid (old profile)"],
    ["RAID_SM_RUIN"]   = L["Affliction: Raid (old profile)"],
    ["RAID_DS_RUIN"]   = L["Destruction: Raid (old profile)"],
    ["PVP_NF_CONFLAG"]  = "PvP: Nightfall / Conflagrate",
    ["PVP_SOUL_LINK"]   = "PvP: Soul Link (Tank)",
    ["PVP_DEEP_DESTRO"] = "PvP: Destruction (Conflag)",

    ["Leveling_1_10"] = Band("Leveling", 1, 10),
}
-- One name per leveling role; each level band gets "(lo-hi)" added.
local ROLE_NAMES = {
    { "Leveling",         "Affliction: Solo Leveling" },
    { "Leveling_Dungeon", "Affliction: Dungeon Leveling" },
    { "Leveling_Demo",    "Demonology: Solo Leveling" },
    { "Leveling_Fire",    "Destruction: Solo Leveling" },
}
for _, r in ipairs(ROLE_NAMES) do
    for _, b in ipairs({ { 11, 20 }, { 21, 40 }, { 41, 51 }, { 52, 59 } }) do
        Warlock.PrettyNames[r[1] .. "_" .. b[1] .. "_" .. b[2]] = Band(r[2], b[1], b[2])
    end
end

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Warlock.Talents = { 
    ["DEMONIC_SACRIFICE"] = "Demonic Sacrifice",
    ["SHADOW_MASTERY"]    = "Shadow Mastery",
    ["RUIN"]              = "Ruin",
    ["SOUL_LINK"]         = "Soul Link",
    ["CONFLAGRATE"]       = "Conflagrate",
    ["INCINERATE"]        = "Incinerate",
    ["DEMONIC_PACT"]      = "Demonic Pact",
    ["FEL_CONCENTRATION"] = "Fel Concentration",
    ["NIGHTFALL"]         = "Nightfall",
    ["INTENSITY"]         = "Intensity",
    ["MASTER_DEMON"]      = "Master Demonologist",
    ["SUPPRESSION"]       = "Suppression",
    ["DEMONIC_EMBRACE"]   = "Demonic Embrace",
    ["MALEDICTION"]       = "Malediction", -- New in Forever, Affliction t2, 5 ranks, +1%/rank periodic damage
    ["PANDEMIC"]          = "Pandemic", -- New in Forever, Affliction t3, 3 ranks, +33%/rank crit damage bonus on DoTs (now that DoTs crit)
    ["AGONIZING_FLAMES"]  = "Agonizing Flames", -- New in Forever, Destruction t4, 3 ranks, +3%/rank Destruction spell damage
    -- Leveling role markers (tiers 1-3, see Warlock.LowLevelRoles)
    ["IMP_CORRUPTION"]    = "Improved Corruption", -- Affliction t1
    ["SOUL_HARVESTING"]   = "Soul Harvest", -- Affliction t2 (renamed from Soul Harvesting in the 2 Oct patch)
    ["IMP_LIFE_TAP"]      = "Improved Life Tap", -- Affliction t1, 2 ranks, +10% mana per Life Tap per rank
    ["DEMONIC_KNOWLEDGE"] = "Demonic Knowledge", -- Demonology t5, 3 ranks, spell damage from the demon
    ["IMP_DRAINS"]        = "Improved Drains", -- Affliction t2
    ["IMP_BANE_AGONY"]    = "Improved Bane of Agony", -- Affliction t3
    ["AMPLIFY_CURSE"]     = "Amplify Curse", -- Affliction t3
    ["IMP_HEALTH_FUNNEL"] = "Improved Health Funnel", -- Demonology t1
    ["IMP_IMP"]           = "Improved Imp", -- Demonology t1
    ["UNHOLY_POWER"]      = "Unholy Power", -- Demonology t1
    ["DEMONIC_AEGIS"]     = "Demonic Aegis", -- Demonology t2
    ["IMP_VOIDWALKER"]    = "Improved Voidwalker", -- Demonology t2
    ["FEL_VITALITY"]      = "Fel Vitality", -- Demonology t2
    ["DEMONIC_ENERGIES"]  = "Demonic Energies", -- Demonology t2
    ["IMP_SAYAAD"]        = "Improved Sayaad", -- Demonology t3
    ["MASTER_SUMMONER"]   = "Master Summoner", -- Demonology t3
    ["DESTRUCTIVE_REACH"] = "Destructive Reach", -- Destruction t1
    ["IMP_SHADOW_BOLT"]   = "Improved Shadow Bolt", -- Destruction t1
    ["BANE"]              = "Bane", -- Destruction t1
    ["MOLTEN_SKIN"]       = "Molten Skin", -- Destruction t2
    ["CATACLYSM"]         = "Cataclysm", -- Destruction t2
    ["AFTERMATH"]         = "Aftermath", -- Destruction t2
    ["SHADOWBURN"]        = "Shadowburn", -- Destruction t3
}

-- =============================================================
-- LOGIC
-- =============================================================
Warlock.ValidWeapons = {
    [7]=true,             -- 1H Swords
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

-- Leveling role marker talents (see MSC:GetLowLevelRole): each tree's
-- tier 1-3 picks, so the tree with the most points wins. "Leveling" is the
-- Affliction default. Improved Life Tap marks nothing (every tree takes it).
Warlock.LowLevelRoles = {
    Leveling      = { "SUPPRESSION", "IMP_CORRUPTION", "MALEDICTION", "SOUL_HARVESTING", "IMP_DRAINS", "IMP_BANE_AGONY", "FEL_CONCENTRATION", "AMPLIFY_CURSE", "PANDEMIC" },
    Leveling_Demo = { "IMP_HEALTH_FUNNEL", "IMP_IMP", "DEMONIC_EMBRACE", "UNHOLY_POWER", "DEMONIC_AEGIS", "IMP_VOIDWALKER", "FEL_VITALITY", "DEMONIC_ENERGIES", "IMP_SAYAAD", "DEMONIC_SACRIFICE", "MASTER_SUMMONER" },
    Leveling_Fire = { "DESTRUCTIVE_REACH", "IMP_SHADOW_BOLT", "BANE", "MOLTEN_SKIN", "CATACLYSM", "AFTERMATH", "RUIN", "SHADOWBURN" },
    -- No markers (talents can't tell solo from group play): applies only when chosen, e.g. by a Talents plugin build.
    Leveling_Dungeon = {},
}

function Warlock:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")

    if level < 60 then
        if level < 10 then return "Leveling_1_10" end
        local suffix = (level <= 20 and "_11_20") or (level <= 40 and "_21_40") or (level <= 51 and "_41_51") or "_52_59"

        -- A Talents plugin build names its role; it wins over the talent checks below.
        local forced = MSC.TalentBuildRole and MSC.TalentBuildRole.leveling
        if forced and (forced == "Leveling" or Warlock.LowLevelRoles[forced]) and Warlock.LevelingWeights[forced .. suffix] then
            return forced .. suffix
        end

        local prefix = "Leveling" -- Affliction
        if Rank("INCINERATE") > 0 or Rank("CONFLAGRATE") > 0 then prefix = "Leveling_Fire"
        elseif Rank("SOUL_LINK") > 0 or Rank("MASTER_DEMON") > 0 then prefix = "Leveling_Demo"
        else
            prefix = MSC:GetLowLevelRole(Warlock.LowLevelRoles) or prefix
            if prefix == "Leveling_Dungeon" then prefix = "Leveling" end
        end
        if Warlock.LevelingWeights[prefix .. suffix] then return prefix .. suffix end
        if level == 10 then return "Leveling_1_10" end
        return "Leveling" .. suffix
    end

    -- Endgame: the AoE farming build (Soul Link with Molten Skin), Demonic Pact, then the tree with the most points.
    if Rank("SOUL_LINK") > 0 and Rank("MOLTEN_SKIN") >= 3 and Rank("DEMONIC_PACT") == 0 then return "DEMO_FARM" end
    if Rank("DEMONIC_PACT") > 0 then return "DEMO_PACT_RAID" end
    local aff, demo, destro = MSC.GetTabPointsSpent(1), MSC.GetTabPointsSpent(2), MSC.GetTabPointsSpent(3)
    if demo > aff and demo >= destro then return "DEMO_PACT_RAID" end
    if destro > aff then return "DESTRO_RAID" end
    return "AFF_RAID"
end

function Warlock:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    -- The sim-built raid profiles already carry their talents: the talent hooks skip them (the hit cap still applies).
    local hooks = not SIM_PROFILES[currentSpec or ""]

    -- [[ 1. Demonic Embrace (Stamina) ]]
    local rEmb = Rank("DEMONIC_EMBRACE")
    if hooks and rEmb > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03))
    end

    -- Ruin (Destruction t3, 5 ranks): "Increases the critical strike damage
    -- bonus of your Destruction spells by 20%" -- same phrasing/math as Mage's
    -- Arcane Mind/Ice Shards -- 1+rank*0.20, reaching 2.0x at 5/5 (matches
    -- real Classic Ruin's known doubling effect exactly). Shadow Bolt itself
    -- is a Destruction spell and the primary nuke for every non-Fire build
    -- too, and Ruin is a prerequisite for all 3 raid spec detections, so this
    -- applies unconditionally by rank rather than gating on spec name.
    local isLeveling = type(currentSpec) == "string" and currentSpec:find("^Leveling") ~= nil
    local rRuin = Rank("RUIN")
    if hooks and not isLeveling and rRuin > 0 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * (1 + (rRuin * 0.20))
    end

    -- Pandemic (New in Forever, Affliction t3, 3 ranks): same crit-damage-bonus
    -- phrasing, now extended to DoTs since Forever lets periodic damage crit --
    -- 1+rank*0.33, reaching ~2.0x at 3/3, consistent with every other
    -- crit-damage-bonus talent converging on a 2x cap at its own max rank
    local rPandemic = Rank("PANDEMIC")
    local rShadowMastery = Rank("SHADOW_MASTERY")
    local rMalediction = Rank("MALEDICTION")
    local rAgonizing = Rank("AGONIZING_FLAMES")

    if isLeveling then
        local level = UnitLevel("player")

        -- Leveling rows: Pandemic only touches DoT crits and Ruin only
        -- Destruction crits, so each applies to its share of the rotation's
        -- crit-able damage (Pandemic's dotShare rises with level as Corruption/
        -- Agony/Immolate ticks grow; Ruin's destroShare depends on the spec),
        -- and the two add into ONE multiplier instead of stacking to x2-4.
        local destroShare = 0.5 -- Leveling (Affliction)
        if currentSpec:find("^Leveling_Fire") then destroShare = 0.85
        elseif currentSpec:find("^Leveling_Demo") then destroShare = 0.3 end
        local dotShare = MSC.ForeverLevelLerp({ {15, 0.45}, {20, 0.50}, {25, 0.50}, {30, 0.55}, {35, 0.60}, {40, 0.60}, {45, 0.65}, {50, 0.70}, {59, 0.70} }, level)
        local critMult = 1 + (0.20 * rRuin * destroShare) + (0.33 * rPandemic * dotShare)
        MSC.ScaleForeverSpellCrit(weights, critMult, level)

        -- Malediction (+1% periodic, about 0.8 of Affliction damage), Shadow
        -- Mastery (+1% Shadow) and Agonizing Flames (+3% Destruction, Fire
        -- rows) raise everything expressed in spell damage -- Spell Power,
        -- school damage, hit and crit -- but not wand, Int, Spirit, Mp5 or Stamina.
        local dmgMult = (1 + 0.008 * rMalediction) * (1 + 0.01 * rShadowMastery)
        local dmgKeys = { "ITEM_MOD_SPELL_POWER_SHORT", "ITEM_MOD_SHADOW_DAMAGE_SHORT", "ITEM_MOD_HIT_SPELL_RATING_SHORT", "ITEM_MOD_SPELL_CRIT_RATING_SHORT" }
        if currentSpec:find("^Leveling_Fire") and rAgonizing > 0 then
            dmgMult = dmgMult * (1 + 0.03 * rAgonizing)
            dmgKeys[#dmgKeys + 1] = "ITEM_MOD_FIRE_DAMAGE_SHORT"
        end
        MSC.ScaleForeverKeys(weights, dmgKeys, dmgMult)

        -- Soul Harvest (Affliction t2, 2 ranks): the regen buff is
        -- conditional on a Drain Soul kill (level 10+), so about +6%/rank.
        local rSoulHarvest = Rank("SOUL_HARVESTING")
        if rSoulHarvest > 0 and level >= 10 then
            MSC.ScaleForeverKeys(weights, { "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_MANA_REGENERATION_SHORT" }, 1 + 0.06 * rSoulHarvest)
        end

        -- Improved Life Tap (Affliction t1, 2 ranks, +10% mana per Life Tap per
        -- rank): not baked in. Each HP tapped now returns more mana, so HP is
        -- better fuel (Stamina, Health, Hp5 about +3.5%/rank, the fuel share of
        -- their weight) and mana is cheaper (Int and flat +Mana about -4%/rank,
        -- the mana-derived share of Int). Spirit's Life Tap term is only about
        -- 0.05 SP of 3, so it is left alone. Level 27-29 of the solo build.
        local rLifeTap = Rank("IMP_LIFE_TAP")
        if rLifeTap > 0 then
            MSC.ScaleForeverKeys(weights, { "ITEM_MOD_STAMINA_SHORT", "ITEM_MOD_HEALTH_SHORT", "ITEM_MOD_HEALTH_REGENERATION_SHORT" }, 1 + 0.035 * rLifeTap)
            MSC.ScaleForeverKeys(weights, { "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_MANA_SHORT" }, 1 - 0.04 * rLifeTap)
        end

        -- Soul Link (Demonology t5, 1 rank: 30% of damage taken goes to the
        -- demon, +3% damage) and Demonic Knowledge (3 ranks): the Leveling_Demo
        -- keyframes bake in a mild Soul Link (Stamina/Health x0.95, Armor x0.93)
        -- and Demonic Knowledge as hit/crit x1.05, all reached at 30 and eased
        -- in from 25, so these use the un-bake pattern against what each
        -- keyframe baked: real / baked. Rows without those keyframes (Fire)
        -- bake nothing. Soul Link also lifts every damage-derived weight 3%.
        local rSoulLink = Rank("SOUL_LINK")
        local demoBake = 0
        if currentSpec:find("^Leveling_Demo") then
            demoBake = math.max(0, math.min(1, (level - 25) / 5))
        end
        if rSoulLink > 0 or demoBake > 0 then
            -- Soul Link takes 30% of the damage the HP/armor would have stopped:
            -- the safety share of Stamina (about 0.3 of its weight) falls 30%,
            -- armor (all safety) falls 30%.
            local stamFix = (1 - 0.09 * math.min(rSoulLink, 1)) / (1 - 0.05 * demoBake)
            MSC.ScaleForeverKeys(weights, { "ITEM_MOD_STAMINA_SHORT", "ITEM_MOD_HEALTH_SHORT" }, stamFix)
            local armorOld = weights["ITEM_MOD_ARMOR_SHORT"]
            if armorOld then
                -- never push a weight that sat above 0.02 into the useless band
                local armorNew = armorOld * (1 - 0.30 * math.min(rSoulLink, 1)) / (1 - 0.07 * demoBake)
                if armorOld >= 0.02 and armorNew < 0.02 then armorNew = 0.02 end
                weights["ITEM_MOD_ARMOR_SHORT"] = armorNew
            end
        end
        if rSoulLink > 0 then
            MSC.ScaleForeverKeys(weights, dmgKeys, 1.03)
        end
        local rDK = Rank("DEMONIC_KNOWLEDGE")
        if demoBake > 0 or rDK > 0 then
            -- 3 ranks give the baked x1.05 (+1.67% per rank)
            local dkFix = (1 + (0.05 / 3) * rDK) / (1 + 0.05 * demoBake)
            MSC.ScaleForeverKeys(weights, { "ITEM_MOD_HIT_SPELL_RATING_SHORT" }, dkFix)
            MSC.ScaleForeverSpellCrit(weights, dkFix, level)
        end

        -- Fel Vitality (Demonology t2, 3 ranks, +5% max mana/rank): scales the
        -- mana part of Int (about 0.85 of it) and flat +Mana.
        if currentSpec:find("^Leveling_Demo") then
            local rFelVit = Rank("FEL_VITALITY")
            if rFelVit > 0 then
                MSC.ScaleForeverKeys(weights, { "ITEM_MOD_MANA_SHORT" }, 1 + 0.05 * rFelVit)
                MSC.ScaleForeverKeys(weights, { "ITEM_MOD_INTELLECT_SHORT" }, 1 + 0.04 * rFelVit)
            end
        end
    elseif hooks then
        if rPandemic > 0 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * (1 + (rPandemic * 0.33))
        end

        -- Shadow Mastery (Affliction t6, 5 ranks): +1%/rank Shadow spell damage/drain
        if rShadowMastery > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rShadowMastery * 0.01))
        end

        -- Malediction (New in Forever, Affliction t2, 5 ranks): +1%/rank periodic
        -- (DoT) damage from all Warlock spells
        if rMalediction > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rMalediction * 0.01))
        end

        -- Agonizing Flames (New in Forever, Destruction t4, 3 ranks): +3%/rank
        -- damage on all Destruction spells (includes Shadow Bolt)
        if rAgonizing > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rAgonizing * 0.03))
        end
    end

    -- [[ 2. Hit Cap ]]
    -- Suppression is +1% hit on all spells in Forever, so it's already in the
    -- game's spell-hit number (MSC:GetForeverHitPercent). Target is the
    -- level's cap, sliding to the raid cap from 50.
    MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_SPELL_RATING_SHORT", "SPELL", 0.1, "Spell Hit", activeCaps)

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Warlock:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
end

MSC.RegisterModule("WARLOCK", Warlock)



