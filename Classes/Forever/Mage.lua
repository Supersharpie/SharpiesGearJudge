local addonName, MSC = ...
local Mage = {}
Mage.Name = "MAGE"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
Mage.Weights = {
    ["Default"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_MANA_SHORT"]=0.02, ["ITEM_MOD_STAMINA_SHORT"]=0.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0  },

    -- The raid profiles come from the wowsims Forever sim (study/mage2, 2026-10-03; NOTES.md there has the numbers),
    -- run with each build's own talents, so ApplyScalers' talent hooks skip them. Spell Power sits at 2.0; Hit and
    -- Crit are per 1%. In a three-minute fight with raid buffs a Frost or Arcane mage doesn't run out of mana, so
    -- Intellect counts mostly for its crit.
    -- Frost: Raid (Frost with Ice Lance, Fingers of Frost and Winter's Chill; bosses can't be frozen).
    ["FROST_RAID"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=24.9, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.28 },
    -- Fire: Raid (Fire 35 / Frost 16). About 17% behind Frost in the sim; Fireball's mana cost makes Intellect, Spirit and Mp5 count.
    ["FIRE_RAID"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=18.3, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=19.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.98, ["ITEM_MOD_SPIRIT_SHORT"]=1.1, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.32 },
    -- Arcane: Raid (Arcane Blast and Arcane Missiles). About 6% behind Frost.
    ["ARCANE_RAID"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=1.82, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=0.18, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=14.6, ["ITEM_MOD_INTELLECT_SHORT"]=0.46, ["ITEM_MOD_SPIRIT_SHORT"]=0.24, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.38 },
    -- Frost: AoE Farming (Blizzard kiting packs at 60; study/mage2/farm.js, a rough model, tempered). Blizzard's spell
    -- power share is small next to its base damage and drinking is a big part of each pull, so Crit, Intellect and Mp5
    -- count for a lot against Spell Power; Stamina keeps you alive when a pull goes wrong.
    ["FROST_AOE"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_INTELLECT_SHORT"]=3.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.5 },

    -- PvP profiles (not modelled).
    ["POM_PYRO"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["ELEMENTAL"] = {  ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["FROST_PVP"] = {  ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0  },
}
-- Old names, kept so a saved profile choice still works.
Mage.Weights["FROST_WC"] = Mage.Weights["FROST_RAID"]
Mage.Weights["FROST_AP"] = Mage.Weights["FROST_RAID"]
-- The sim-built raid profiles (talents already in): ApplyScalers' talent hooks skip these.
local SIM_PROFILES = { FROST_RAID = true, FIRE_RAID = true, ARCANE_RAID = true, FROST_WC = true, FROST_AP = true }

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
-- Filled at load from Classes/Forever/Curves/Mage_Curves.lua (generated from
-- the study; don't edit it by hand) by Curves_Attach.lua: one row per role and level band,
-- blended by level in MSC:GetLevelingRow. Roles:
--   Leveling          Frost: Solo Leveling (single target, the default)
--   Leveling_AoE      Frost: AoE Leveling (Blizzard pack grinding)
--   Leveling_Dungeon  Frost: Dungeon Leveling
--   Leveling_Fire     Fire leveling (Ignite)
Mage.LevelingWeights = {}

-- =============================================================
-- DISPLAY NAMES (match the Talents plugin's builds; translated in Locales/*.lua)
-- =============================================================
local L = MSC.L
local function Band(label, lo, hi) return L[label] .. " (" .. lo .. "-" .. hi .. ")" end
Mage.PrettyNames = {
    ["FROST_RAID"]  = L["Frost: Raid"],
    ["FIRE_RAID"]   = L["Fire: Raid"],
    ["ARCANE_RAID"] = L["Arcane: Raid"],
    ["FROST_AOE"]   = L["Frost: AoE Farming"],
    ["FROST_WC"]    = L["Frost: Raid (old profile)"],
    ["FROST_AP"]    = L["Frost: Raid (old Arcane Power profile)"],
    ["POM_PYRO"]        = "PvP: PoM Pyro (3-Min Mage)",
    ["ELEMENTAL"]       = "PvP: Elemental (Shatter)",
    ["FROST_PVP"]       = "PvP: Deep Frost",

    ["Leveling_1_10"] = Band("Leveling", 1, 10),
}
-- One name per leveling role; each level band gets "(lo-hi)" added.
local ROLE_NAMES = {
    { "Leveling",         "Frost: Solo Leveling" },
    { "Leveling_AoE",     "Frost: AoE Leveling" },
    { "Leveling_Dungeon", "Frost: Dungeon Leveling" },
    { "Leveling_Fire",    "Fire: Solo Leveling" },
}
for _, r in ipairs(ROLE_NAMES) do
    for _, b in ipairs({ { 11, 20 }, { 21, 40 }, { 41, 51 }, { 52, 59 } }) do
        Mage.PrettyNames[r[1] .. "_" .. b[1] .. "_" .. b[2]] = Band(r[2], b[1], b[2])
    end
end

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Mage.Talents = { 
    ["ARCANE_POWER"]    = "Arcane Power",
    ["PRESENCE_OF_MIND"]= "Presence of Mind",
    ["COMBUSTION"]      = "Combustion",
    ["BLAST_WAVE"]      = "Blast Wave",
    ["PYROBLAST"]       = "Pyroblast",
    ["ICE_BARRIER"]     = "Ice Barrier",
    ["WINTERS_CHILL"]   = "Winter's Chill",
    ["IMP_BLIZZARD"]    = "Improved Blizzard",
    ["PERMAFROST"]      = "Permafrost",
    ["ARCANE_MIND"]     = "Arcane Mind",
    ["IGNITE"]          = "Ignite",
    ["ICE_SHARDS"]      = "Ice Shards",
    ["ELE_PRECISION"]   = "Elemental Precision",
    ["ARCANE_FOCUS"]    = "Arcane Focus",
    ["ARCANE_RESILIENCE"] = "Arcane Resilience", -- Arcane t2, 2 ranks, Armor += 25%/rank of Intellect -- was already referenced in ApplyScalers but missing here, so Rank() always returned 0
    ["WAND_SPEC"]       = "Wand Specialization", -- Arcane t1, 2 ranks, +13%/+25% wand damage
    ["ARCANE_MEDITATION"] = "Arcane Meditation", -- Arcane t4, 3 ranks, 17%/rank regen while casting
    ["FIRE_POWER"]      = "Fire Power", -- Fire t6, 5 ranks, +2%/rank Fire damage (Same as Classic)
    ["PIERCING_ICE"]    = "Piercing Ice", -- Frost t3, 3 ranks, +2%/rank Frost damage (Same as Classic)
    -- Leveling role markers (tiers 1-3, see Mage.LowLevelRoles)
    ["FROST_WARDING"]   = "Frost Warding", -- Frost t1
    ["IMP_FROSTBOLT"]   = "Improved Frostbolt", -- Frost t1
    ["IMP_FROST_NOVA"]  = "Improved Frost Nova", -- Frost t2
    ["FROSTBITE"]       = "Frostbite", -- Frost t2
    ["FROST_CHANNELING"] = "Frost Channeling", -- Frost t3
    ["ICE_LANCE"]       = "Ice Lance", -- Frost t3
    ["WAKE_OF_FIRE"]    = "Wake of Fire", -- Fire t1
    ["INCINERATION"]    = "Incineration", -- Fire t1
    ["IMP_FIREBALL"]    = "Improved Fireball", -- Fire t1
    ["FLAME_THROWING"]  = "Flame Throwing", -- Fire t2
    ["IMPACT"]          = "Impact", -- Fire t2
    ["BURNING_SOUL"]    = "Burning Soul", -- Fire t3
    ["IMP_FLAMESTRIKE"] = "Improved Flamestrike", -- Fire t3
}

-- =============================================================
-- LOGIC
-- =============================================================
Mage.ValidWeapons = {
    [7]=true,             -- 1H Swords
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

-- Leveling role marker talents (see MSC:GetLowLevelRole). "Leveling" is the
-- Frost default, so Frost picks are listed to outvote a stray Fire point.
-- Arcane and Elemental Precision (Fire+Frost hit) mark neither; AoE is
-- still detected by Improved Blizzard in GetSpec.
Mage.LowLevelRoles = {
    Leveling      = { "FROST_WARDING", "IMP_FROSTBOLT", "ICE_SHARDS", "PERMAFROST", "IMP_FROST_NOVA", "FROSTBITE", "PIERCING_ICE", "FROST_CHANNELING", "ICE_LANCE" },
    Leveling_Fire = { "WAKE_OF_FIRE", "INCINERATION", "IMP_FIREBALL", "IGNITE", "FLAME_THROWING", "IMPACT", "BURNING_SOUL", "IMP_FLAMESTRIKE", "PYROBLAST" },
    -- No markers: these apply only when chosen, e.g. by a Talents plugin build (AoE grinding is
    -- otherwise picked from Improved Blizzard in GetSpec).
    Leveling_AoE = {},
    Leveling_Dungeon = {},
}

function Mage:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")

    if level < 60 then
        if level < 10 then return "Leveling_1_10" end
        local suffix = (level <= 20 and "_11_20") or (level <= 40 and "_21_40") or (level <= 51 and "_41_51") or "_52_59"

        -- A Talents plugin build names its role; it wins over the talent checks below.
        local forced = MSC.TalentBuildRole and MSC.TalentBuildRole.leveling
        if forced and (forced == "Leveling" or Mage.LowLevelRoles[forced]) and Mage.LevelingWeights[forced .. suffix] then
            return forced .. suffix
        end

        local role = "Leveling"
        -- Improved Blizzard is tier 3 (first point at 20), so one point marks
        -- an AoE mage up to 21; from then on it takes 2.
        if Rank("IMP_BLIZZARD") >= ((level <= 21) and 1 or 2) then role = "Leveling_AoE"
        elseif Rank("IGNITE") >= 3 then role = "Leveling_Fire"
        else
            role = MSC:GetLowLevelRole(Mage.LowLevelRoles) or role
            if role == "Leveling_AoE" or role == "Leveling_Dungeon" then role = "Leveling" end
        end
        if Mage.LevelingWeights[role .. suffix] then return role .. suffix end
        if level == 10 then return "Leveling_1_10" end
        return "Leveling" .. suffix
    end

    -- Endgame: the PvP signatures first, then AoE farming, then the tree with the most points.
    if Rank("PRESENCE_OF_MIND") > 0 and Rank("PYROBLAST") > 0 and Rank("COMBUSTION") == 0 then return "POM_PYRO" end
    if Rank("BLAST_WAVE") > 0 and Rank("ICE_SHARDS") > 0 then return "ELEMENTAL" end
    if Rank("IMP_BLIZZARD") == 3 and Rank("PERMAFROST") > 0 then return "FROST_AOE" end
    local arcane, fire, frost = MSC.GetTabPointsSpent(1), MSC.GetTabPointsSpent(2), MSC.GetTabPointsSpent(3)
    if fire > frost and fire >= arcane then return "FIRE_RAID" end
    if arcane > frost then return "ARCANE_RAID" end
    return "FROST_RAID"
end

function Mage:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    -- The sim-built raid profiles already carry their talents: the talent hooks skip them
    -- (the Spell Power -> crit covariance and the hit cap below still apply).
    local hooks = not SIM_PROFILES[currentSpec or ""]

    -- [[ 1. Arcane Mind (+10% Int) ]]
    local rAR = Rank("ARCANE_RESILIENCE")
    if hooks and rAR > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] and (weights["ITEM_MOD_ARMOR_SHORT"] or 0) > 0 then
        -- Assume 25% per rank
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (weights["ITEM_MOD_ARMOR_SHORT"] * (rAR * 0.25))
    end
    
    -- Arcane Mind (Confirmed via wowforevertools.com/changes/mage): actually
    -- does BOTH effects, not just the crit one -- "Increases your Intellect
    -- by 2% and increases the critical strike damage bonus of your Arcane
    -- spells by 20%." The Intellect half applies regardless of spec; the
    -- crit-damage half is Arcane-spell-specific, so it stays gated to ARCANE
    -- (inert for the Fire/Frost profiles modeled today, ready for when an
    -- Arcane raid profile exists).
    local rAM = Rank("ARCANE_MIND")
    if hooks and rAM > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAM * 0.02))
    end
    if hooks and rAM > 0 and currentSpec:find("ARCANE") and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * (1 + (rAM * 0.20))
    end

    -- Ice Shards (Frost t2, 5 ranks, Same as Classic): same phrasing/math as
    -- Arcane Mind's crit half -- 1+rank*0.20, reaching 2.0x at 5/5 (matches
    -- real Classic Ice Shards' known doubling effect exactly). No spec-name
    -- gate: unlike Arcane Mind (no Arcane profile exists to even test against),
    -- ELEMENTAL/POM_PYRO are real hybrid specs that can carry Frost points
    -- without "FROST" appearing in the spec key, so rank alone is the signal.
    -- Leveling rows: Ice Shards only helps Frost spells, so Leveling_AoE
    -- (Arcane Explosion crits are not Frost) gets a 0.65 Frost share (5/5 =
    -- x1.65, not x2.0) and Fire rows skip it. Int carries its crit share via
    -- ScaleForeverSpellCrit. Endgame specs keep the flat 1 + 0.2r.
    local specUp = string.upper(currentSpec or "")
    local isLeveling = specUp:find("^LEVELING") ~= nil
    local isFireRow = specUp:find("FIRE") ~= nil
    local isAoERow = specUp:find("AOE") ~= nil
    local level = UnitLevel("player")
    local rIceShards = Rank("ICE_SHARDS")
    if hooks and rIceShards > 0 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        if not isLeveling then
            weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * (1 + (rIceShards * 0.20))
        elseif not isFireRow then
            MSC.ScaleForeverSpellCrit(weights, 1 + (rIceShards * 0.20 * (isAoERow and 0.65 or 1)), level)
        end
    end

    local rFirePower = Rank("FIRE_POWER")
    local rPiercingIce = Rank("PIERCING_ICE")
    if not isLeveling and hooks then
        -- Fire Power (Fire t6, 5 ranks, Same as Classic): +2%/rank Fire damage
        if rFirePower > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rFirePower * 0.02))
        end
        -- Piercing Ice (Frost t3, 3 ranks, Same as Classic): +2%/rank Frost damage
        if rPiercingIce > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rPiercingIce * 0.02))
        end
    elseif isLeveling then
        -- Leveling: a +2%/rank school-damage talent is a flat damage multiplier
        -- (the wand is untouched by it, so it is kept fixed). Piercing Ice is
        -- Frost-only: full on the Frost row, x0.72 share on AoE, skipped on Fire.
        -- Fire Power only applies to the Fire rows.
        local wandKeep = { "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" }
        if isFireRow then
            if rFirePower > 0 then
                MSC.ApplyForeverDamageMult(weights, 1 + (0.02 * rFirePower), wandKeep)
            end
        elseif rPiercingIce > 0 then
            MSC.ApplyForeverDamageMult(weights, 1 + (0.02 * rPiercingIce * (isAoERow and 0.72 or 1)), wandKeep)
        end
    end

    -- Improved Frostbolt (Frost t1, 5 ranks, -0.1s cast per rank): the
    -- leveling anchors assume 5/5 from 15, so fewer ranks slow the nuke and
    -- make wand DPS worth more.
    local rImpFrostbolt = Rank("IMP_FROSTBOLT")
    if isLeveling and not isFireRow and level >= 15 and weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] then
        local castBase = (level >= 26) and 3.0 or ((level >= 20) and 2.6 or 2.2)
        weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] * (castBase - 0.1 * rImpFrostbolt) / (castBase - 0.5)
    end

    -- Wand Specialization (Arcane t1, 2 ranks, +13% / +25% wand damage)
    local rWandSpec = Rank("WAND_SPEC")
    if isLeveling and rWandSpec > 0 and weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] then
        weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] * (({ 1.13, 1.25 })[math.min(rWandSpec, 2)])
    end

    -- Arcane Meditation (Arcane t4, 3 ranks, 17% regen while casting per rank):
    -- from 34 Mage Armor and Meditation stack to a 100% cap (half of players
    -- assumed on Mage Armor, baseline 1.425); below 34 it is additive.
    local rArcMed = Rank("ARCANE_MEDITATION")
    if isLeveling and rArcMed > 0 and weights["ITEM_MOD_SPIRIT_SHORT"] then
        local spiritMult
        if level >= 34 then
            spiritMult = (1 + 1.7 * (0.5 * math.min(1, 0.5 + 0.17 * rArcMed) + 0.5 * 0.17 * rArcMed)) / 1.425
        else
            spiritMult = 1 + 1.7 * 0.17 * rArcMed
        end
        weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * spiritMult
    end

    -- Frost Channeling (Frost t3, 3 ranks, -5% Frost mana cost per rank): about
    -- 70% of an AoE mage's mana goes to Frost spells, and about 85% of a Frost
    -- single-target mage's (Fire Blast is the rest). Not baked into any anchor;
    -- the solo Frost build has 3/3 by 39, worth about x1.15 on mana stats.
    -- Fire rows skip it (their mana goes to Fire spells).
    local rFrostChan = Rank("FROST_CHANNELING")
    local frostManaShare = isAoERow and 0.7 or (isFireRow and 0 or 0.85)
    if isLeveling and frostManaShare > 0 and rFrostChan > 0 then
        local fc = 1 / (1 - 0.05 * rFrostChan * frostManaShare)
        MSC.ScaleForeverKeys(weights, { "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_MANA_SHORT", "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_MANA_REGENERATION_SHORT" }, fc)
    end

    -- Never leave a weight in the dead zone (0, 0.02)
    if isLeveling then
        for k, v in pairs(weights) do
            if type(v) == "number" and v > 0 and v < 0.02 then weights[k] = 0 end
        end
    end

    -- [[ 2. Covariance (SP -> Crit) ]]
    if weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        -- FIX: Use MSC.SanitizeStat(GetSpellBonusDamage(2)) via shim ideally, but for now we shim via manual GetSpellBonusDamage call if needed
        -- Note: Era API returns number directly.
        local sp = MSC.SanitizeStat(GetSpellBonusDamage(3)) -- 3=Frost
        if sp > 400 then
            local spScaler = 1 + ((sp - 400) / 4000)
            weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * spScaler
        end
    end

    -- [[ 3. Hit Cap ]]
    -- Target is the level's cap, sliding to the raid cap from 50. Elemental
    -- Precision (Fire/Frost only) and Arcane Focus (Arcane only) aren't in the
    -- game's general spell-hit number, so they're added here; every leveling
    -- profile is Frost/Fire based.
    local talentHit = currentSpec:find("ARCANE") and Rank("ARCANE_FOCUS") or Rank("ELE_PRECISION")
    -- AoE grinding: about a quarter of the damage is Arcane Explosion, which
    -- Elemental Precision doesn't cover.
    if currentSpec:find("AoE") or currentSpec:find("AOE") then talentHit = talentHit * 0.75 end
    MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_SPELL_RATING_SHORT", "SPELL", 0.1, "Spell Hit", activeCaps, talentHit)
    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Mage:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
end

MSC.RegisterModule("MAGE", Mage)



