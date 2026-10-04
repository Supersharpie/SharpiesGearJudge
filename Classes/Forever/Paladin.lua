local addonName, MSC = ...
local Paladin = {}
Paladin.Name = "PALADIN"

-- =============================================================
-- LEVEL-60 WEIGHTS
-- =============================================================
-- Hit, Crit, Dodge, Parry and Block weights are per 1%; Defense per skill
-- point; the rest per point. Within a profile, Strength = 2x Attack Power and
-- Weapon DPS = 14x Attack Power (bonus damage per swing is AP / 14 x speed).
-- The model-built profiles come from the Research folder (study/ret_build,
-- 2026-10-03; NOTES.md there has the numbers behind each one).
Paladin.Weights = {
    -- Fallback before a spec is known.
    ["Default"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },

    -- Retribution: Raid (Ret 33 / Holy 18 with Twist of Light, pre-raid gear) from the wowsims Forever simulator (study/paladin3,
    -- 2026-10-03), 70% raid boss / 30% dungeon boss, Attack Power 1.5. The rotation seal-twists: Seal of Righteousness up before
    -- each swing, then Seal of Command, so every swing carries both seals (Twist of Light's Echo). That makes white hits count
    -- double, so Hit and Crit lead. Built with the build's talents (Divine Strength, Divine Intellect, Champion of the Light):
    -- ApplyScalers' talent hooks skip this profile.
    ["RET_STANDARD"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=67.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=51.6, ["ITEM_MOD_STRENGTH_SHORT"]=3.58, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.78, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=3.45, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=3.45, ["ITEM_MOD_INTELLECT_SHORT"]=3.07, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.09, ["ITEM_MOD_SPIRIT_SHORT"]=0.35, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=5.6, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },

    -- Holy: Raid (pre-raid healer, raid buffs, long / potion / burst fights). Downranking allowed: Forever
    -- gives every rank the full coefficient (a mild cut is assumed for ranks 10+ levels below you). A
    -- Paladin healer runs short of mana before casting time, so Intellect and Mp5 rank above +healing.
    ["HOLY_RAID"] = {  ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=17.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=2.6, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.3, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=0.5  },

    -- Protection: Raid (Vanguard talents, level-63 boss) from the wowsims Forever simulator's tank mode (study/paladin3,
    -- 2026-10-04), as the Warrior's and Druid's raid tanks: threat 35% / damage taken 35% / effective health 30%, Stamina 3.0.
    -- Dodge and Parry lead; Block only takes Block Value off each big boss hit, so it and Block Value count for less.
    -- Threat is half Holy (Spell Power) and half melee (Hit, Crit). A 3-minute boss never runs a tank dry, so Intellect and
    -- Mp5 keep only a small floor for longer fights.
    ["PROT_DEEP"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=29.5, ["ITEM_MOD_PARRY_RATING_SHORT"]=30.5, ["ITEM_MOD_BLOCK_RATING_SHORT"]=13.8, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=5.0, ["ITEM_MOD_ARMOR_SHORT"]=0.22, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.79, ["ITEM_MOD_AGILITY_SHORT"]=2.62, ["ITEM_MOD_STRENGTH_SHORT"]=0.78, ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.34, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.43, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.43, ["ITEM_MOD_HIT_RATING_SHORT"]=16.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=4.1, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.8, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.6, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.3, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },

    -- Protection: AoE Farming (15-20 normal mobs at 55-57, some Undead; Consecration, Holy Shield and
    -- Retribution Aura at 30 + 10% of spell power per hit taken). Spell Power drives the damage; Block,
    -- Dodge, Parry, Defense and Stamina set the pack size; Block Value and mana barely matter. Scaled to
    -- Spell Power = 3.0.
    ["PROT_AOE"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=3.0, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=3.0, ["ITEM_MOD_STAMINA_SHORT"]=1.65, ["ITEM_MOD_BLOCK_RATING_SHORT"]=58.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=29.5, ["ITEM_MOD_PARRY_RATING_SHORT"]=29.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=7.4, ["ITEM_MOD_HIT_RATING_SHORT"]=18.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=2.6, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.2, ["ITEM_MOD_STRENGTH_SHORT"]=0.47, ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.23, ["ITEM_MOD_ARMOR_SHORT"]=0.16, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.3, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=0.5  },

    -- PvP profiles (not modelled).
    ["SHOCKADIN"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["RECK_BOMB"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=5.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
}
-- Old name for Holy: Raid, kept so a saved profile choice still works.
Paladin.Weights["HOLY_DEEP"] = Paladin.Weights["HOLY_RAID"]
-- The simulator-built level-60 profiles (talents already in): ApplyScalers' talent hooks skip these.
local SIM_PROFILES = { RET_STANDARD = true, PROT_DEEP = true }

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
-- Filled at load from Classes/Forever/Curves/Paladin_Curves.lua (generated from
-- the study; don't edit it by hand) by Curves_Attach.lua: one row per role and level band,
-- blended by level in MSC:GetLevelingRow. Roles:
--   Leveling                Retribution: Solo Leveling (the default)
--   Leveling_RetDungeon     Retribution: Dungeon Leveling
--   Leveling_Tank           Protection: Solo Leveling
--   Leveling_TankDungeon    Protection: Dungeon Leveling
--   Leveling_Healer         Holy: Solo Leveling
--   Leveling_HealerDungeon  Holy: Dungeon Leveling
Paladin.LevelingWeights = {}

-- The Retribution chain is named Leveling_Ret at 52-59 (see MSC:GetLevelingRow's blend).
Paladin.LevelingNext = { ["Leveling_41_51"] = "Leveling_Ret_52_59" }

-- =============================================================
-- DISPLAY NAMES (match the Talents plugin's builds; translated in Locales/*.lua)
-- =============================================================
local L = MSC.L
local function Band(label, lo, hi) return L[label] .. " (" .. lo .. "-" .. hi .. ")" end
Paladin.PrettyNames = {
    ["RET_STANDARD"] = L["Retribution: Raid"],
    ["HOLY_RAID"]    = L["Holy: Raid"],
    ["HOLY_DEEP"]    = L["Holy: Raid (old profile)"],
    ["PROT_DEEP"]    = L["Protection: Raid"],
    ["PROT_AOE"]     = L["Protection: AoE Farming"],
    ["SHOCKADIN"]    = L["PvP: Shockadin (Burst)"],
    ["RECK_BOMB"]    = L["PvP: Reck-Bomb (One-Shot)"],

    ["Leveling_1_10"] = Band("Leveling", 1, 10),
}
-- One name per leveling role; each level band gets "(lo-hi)" added.
local ROLE_NAMES = {
    { "Leveling",               "Retribution: Solo Leveling" },
    { "Leveling_RetDungeon",    "Retribution: Dungeon Leveling" },
    { "Leveling_Tank",          "Protection: Solo Leveling" },
    { "Leveling_TankDungeon",   "Protection: Dungeon Leveling" },
    { "Leveling_Healer",        "Holy: Solo Leveling" },
    { "Leveling_HealerDungeon", "Holy: Dungeon Leveling" },
}
for _, r in ipairs(ROLE_NAMES) do
    for _, b in ipairs({ { 11, 20 }, { 21, 40 }, { 41, 51 }, { 52, 59 } }) do
        -- The Retribution chain's 52-59 row is named Leveling_Ret (see LevelingNext above)
        local role = (r[1] == "Leveling" and b[1] == 52) and "Leveling_Ret" or r[1]
        Paladin.PrettyNames[role .. "_" .. b[1] .. "_" .. b[2]] = Band(r[2], b[1], b[2])
    end
end

-- =============================================================
-- TALENTS (keys used by GetSpec and ApplyScalers -> Forever talent names)
-- =============================================================
Paladin.Talents = {
    -- Holy
    ["DIVINE_STR"]         = "Divine Strength",         -- t1, +2%/rank Strength
    ["DIVINE_INT"]         = "Divine Intellect",        -- t1, +2%/rank Intellect
    ["HEALING_LIGHT"]      = "Healing Light",           -- t2, +4%/rank Holy Light / Flash of Light / Holy Shock healing
    ["SPIRITUAL_FOCUS"]    = "Spiritual Focus",         -- t2, pushback protection
    ["REVERENCE"]          = "Reverence",               -- t3, 10%/rank mana regeneration while casting
    ["ILLUMINATION"]       = "Illumination",            -- t4, mana back on heal crits
    ["DIVINE_FAVOR"]       = "Divine Favor",            -- t4
    ["INFUSION_LIGHT"]     = "Infusion of Light",       -- t4
    ["HOLY_SHOCK"]         = "Holy Shock",              -- t5
    ["LIGHTS_VIGIL"]       = "Light's Vigil",           -- t7 (level 40)
    -- Protection
    ["TOUGHNESS"]          = "Toughness",               -- t1, +2%/rank armor from items
    ["REDOUBT"]            = "Redoubt",                 -- t1, block chance after being hit
    ["PRECISION"]          = "Precision",               -- t2, +1%/rank hit
    ["ANTICIPATION"]       = "Anticipation",            -- t2, +4/rank Defense
    ["IMP_SEAL_OF_FURY"]   = "Improved Seal of Fury",   -- t3, mana when the Seal of Fury absorb is used up
    ["IMP_RIGHTEOUS_FURY"] = "Improved Righteous Fury", -- t3, -2%/rank damage taken
    ["SHIELD_SPEC"]        = "Shield Specialization",   -- t3, Block Value and mana on block
    ["SACRED_DUTY"]        = "Sacred Duty",             -- t3, +2%/rank Stamina
    ["ONE_HAND_SPEC"]      = "One-Handed Weapon Specialization", -- t4, +3%/rank one-handed damage
    ["RECKONING"]          = "Reckoning",               -- t5, extra attacks after blocks
    ["IRON_CREED"]         = "Iron Creed",              -- t6, -2%/rank damage taken for 6 s after Holy Strike
    ["HOLY_SHIELD"]        = "Holy Shield",             -- t7 (level 40)
    -- Retribution
    ["BENEDICTION"]        = "Benediction",             -- t1, -2%/rank mana on instant spells
    ["HOLY_CONDUIT"]       = "Holy Conduit",            -- t2, -20%/rank Consecration / Holy Wrath / Exorcism / Hammer of Wrath mana
    ["SEAL_OF_COMMAND"]    = "Seal of Command",         -- t3 (level 20)
    ["REPENTANCE"]         = "Repentance",              -- t5
    ["TWOH_SPEC"]          = "Two-Handed Weapon Specialization", -- t5, +2%/rank two-handed damage
    ["VENGEANCE"]          = "Vengeance",               -- t5
    ["CHAMPION_LIGHT"]     = "Champion of the Light",   -- t6, spell damage from 20%/rank of Intellect
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

-- Leveling roles picked from talents (MSC:GetLowLevelRole). Divine Strength,
-- Divine Intellect and Reverence aren't Holy markers: Retribution builds take
-- them too. The Dungeon roles have no markers (talents can't tell solo from
-- group play), so they apply only when chosen, e.g. by a Talents plugin build.
Paladin.LowLevelRoles = {
    Leveling_Tank          = { "TOUGHNESS", "REDOUBT", "ANTICIPATION", "IMP_RIGHTEOUS_FURY", "SHIELD_SPEC", "SACRED_DUTY" },
    Leveling_Healer        = { "HEALING_LIGHT", "SPIRITUAL_FOCUS", "ILLUMINATION", "DIVINE_FAVOR", "INFUSION_LIGHT", "LIGHTS_VIGIL" },
    Leveling_RetDungeon    = {},
    Leveling_TankDungeon   = {},
    Leveling_HealerDungeon = {},
}

function Paladin:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")

    -- Leveling Check First
    if level < 60 then
        -- Level 10 has its first talent point, so let roles apply from 10.
        if level < 10 then return "Leveling_1_10" end
        local suffix = (level <= 20 and "_11_20") or (level <= 40 and "_21_40") or (level <= 51 and "_41_51") or "_52_59"

        local role = MSC:GetLowLevelRole(Paladin.LowLevelRoles)
        if role and Paladin.LevelingWeights[role .. suffix] then return role .. suffix end
        if level == 10 then return "Leveling_1_10" end
        if suffix == "_52_59" then return "Leveling_Ret_52_59" end
        return "Leveling" .. suffix
    end

    -- Endgame Spec Detection. Forever builds mix trees (a Ret 30 / Holy 21
    -- takes Holy Shock; Holy healers often skip Sacred Duty), so after the two
    -- signature talents the tree with the most points decides.
    if Rank("RECKONING") > 0 and Rank("VENGEANCE") > 0 then return "RECK_BOMB" end
    if Rank("HOLY_SHIELD") > 0 then return "PROT_DEEP" end
    local holy, prot, ret = MSC.GetTabPointsSpent(1), MSC.GetTabPointsSpent(2), MSC.GetTabPointsSpent(3)
    if ret > holy and ret >= prot then return "RET_STANDARD" end
    if prot > holy and prot > ret then return "PROT_DEEP" end
    -- Holy: a healer with any healing talent; Holy Shock without them is the PvP Shockadin.
    if Rank("HOLY_SHOCK") > 0 and Rank("ILLUMINATION") == 0 and Rank("LIGHTS_VIGIL") == 0
        and Rank("HEALING_LIGHT") == 0 and Rank("DIVINE_FAVOR") == 0 then return "SHOCKADIN" end
    return "HOLY_RAID"
end

function Paladin:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    -- The simulator-built profiles already carry their talents: the talent hooks skip them (the hit cap still applies).
    local hooks = not SIM_PROFILES[currentSpec or ""]

    -- [[ 1. Divine Strength (+10% Str) ]]
    local rStr = Rank("DIVINE_STR")
    if hooks and rStr > 0 and weights["ITEM_MOD_STRENGTH_SHORT"] then
        weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02))
    end

    local rInt = Rank("DIVINE_INT")
    if hooks and rInt > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rInt * 0.02))
    end

    local rTough = Rank("TOUGHNESS")
    if hooks and rTough > 0 and weights["ITEM_MOD_ARMOR_SHORT"] then
        weights["ITEM_MOD_ARMOR_SHORT"] = weights["ITEM_MOD_ARMOR_SHORT"] * (1 + (rTough * 0.02))
    end

    local rSacred = Rank("SACRED_DUTY")
    if hooks and rSacred > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rSacred * 0.02))
    end

    -- Champion of the Light (Ret t6, 3 ranks): spell damage from 20/40/60% of
    -- Intellect (Forever patch of 2 Oct; was 33/66/100%), damage only.
    local rChamp = Rank("CHAMPION_LIGHT")
    if hooks and rChamp > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] and (weights["ITEM_MOD_SPELL_POWER_SHORT"] or 0) > 0 then
        local spWeight = weights["ITEM_MOD_SPELL_POWER_SHORT"]
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (spWeight * (rChamp * 0.20))
    end

    -- Healing Light (Holy t2, 3 ranks): +4%/rank healing from Holy Light /
    -- Flash of Light / Holy Shock -- raises Spell Healing's value for Holy specs
    -- (endgame HOLY_* and the Leveling_Healer_* brackets)
    local rHealLight = Rank("HEALING_LIGHT")
    if rHealLight > 0 and (currentSpec:find("HOLY") or currentSpec:find("Healer")) and weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
        weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rHealLight * 0.04))
    end

    -- [[ 1b. Leveling talent hooks ]]
    -- The study curves (Solo Leveling rows) bake few talents, so these hooks add
    -- the ones the player has. The Retribution and Protection Dungeon Leveling
    -- curves come from models run with their build's talents, so the hooks for
    -- talents those models already include are skipped there (modelRow).
    -- (The Holy Dungeon curve was built for these hooks, so they apply to it.)
    local level = UnitLevel("player")
    local isLeveling = currentSpec:find("^Leveling") ~= nil
    local isHealerRow = currentSpec:find("^Leveling_Healer") ~= nil
    local isTankRow = currentSpec:find("^Leveling_Tank") ~= nil
    local isRetRow = isLeveling and not isHealerRow and not isTankRow
    local modelRow = currentSpec:find("^Leveling_TankDungeon") ~= nil or currentSpec:find("^Leveling_RetDungeon") ~= nil

    -- Multiply a key when present; a weight left in (0, 0.02) is zeroed.
    local function Mul(k, m)
        local v = weights[k]
        if not v or m == 1 then return end
        v = v * m
        if v > 0 and v < 0.02 then v = 0 end
        weights[k] = v
    end
    local function MulAll(keys, m) for _, k in ipairs(keys) do Mul(k, m) end end

    if isRetRow then
        -- Seal of Command (Ret t3, level 20): without it the player stays on
        -- Seal of Righteousness, whose Holy damage is worth more than the
        -- anchor's Seal of Command model, and procs no longer crit.
        if level >= 20 and Rank("SEAL_OF_COMMAND") == 0 then
            MulAll({ "ITEM_MOD_SPELL_POWER_SHORT", "ITEM_MOD_SPELL_DAMAGE_DONE_SHORT", "ITEM_MOD_HOLY_DAMAGE_SHORT" }, 1.25)
            Mul("ITEM_MOD_CRIT_RATING_SHORT", 0.95)
            Mul("ITEM_MOD_AGILITY_SHORT", 0.96)
            Mul("ITEM_MOD_HIT_RATING_SHORT", 0.98)
        end

        -- Vengeance (Ret t5, level 30): +1%/rank damage per stack for 30 s after
        -- a crit, about +2.25% average per rank. A crit also starts the buff, so
        -- crit gains a further 2%/rank; Agility gets the crit part by its share.
        local rVeng = Rank("VENGEANCE")
        if rVeng > 0 and level >= 30 and not modelRow then
            local dmg = 1 + 0.0225 * rVeng
            MulAll({ "ITEM_MOD_ATTACK_POWER_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
                     "MSC_WEAPON_DPS_MELEE", "ITEM_MOD_SPELL_POWER_SHORT", "ITEM_MOD_SPELL_DAMAGE_DONE_SHORT",
                     "ITEM_MOD_HOLY_DAMAGE_SHORT", "MSC_WEAPON_SPEED" }, dmg)
            Mul("ITEM_MOD_CRIT_RATING_SHORT", dmg * (1 + 0.02 * rVeng))
            local critShare = (level >= 45) and 0.90 or 0.85
            Mul("ITEM_MOD_AGILITY_SHORT", 1 + 0.0225 * rVeng + 0.02 * rVeng * critShare)
        end

        -- Two-Handed Weapon Specialization (Ret t5, level 30): +2%/rank damage
        -- with a two-hander, about 1.3%/rank of total damage.
        local rTwoH = Rank("TWOH_SPEC")
        if rTwoH > 0 and not modelRow then
            local link = GetInventoryItemLink("player", 16)
            local equipLoc = link and select(9, GetItemInfo(link))
            if equipLoc == "INVTYPE_2HWEAPON" then
                MulAll({ "ITEM_MOD_ATTACK_POWER_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
                         "MSC_WEAPON_DPS_MELEE", "MSC_WEAPON_SPEED" }, 1 + 0.013 * rTwoH)
            end
        end
    end

    if isHealerRow then
        -- Healing Light also raises the value of mana, regen and crit equally
        -- with healing power: scale their group-side share to match.
        local rHL = Rank("HEALING_LIGHT")
        if rHL > 0 then
            MulAll({ "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_MANA_REGENERATION_SHORT",
                     "ITEM_MOD_SPELL_CRIT_RATING_SHORT" }, 1 + 0.032 * rHL)
        end

        -- Illumination (Holy t4, 5 ranks), relative to the ranks baked into the
        -- anchors: 0 at 20, 1 at 25, 5 from 30.
        local bIll = MSC.ForeverLevelLerp({ {20, 0}, {25, 1}, {30, 5} }, level)
        local rIll = Rank("ILLUMINATION")
        Mul("ITEM_MOD_SPELL_CRIT_RATING_SHORT", (0.61 + 0.39 * rIll / 5) / (0.61 + 0.39 * bIll / 5))
        Mul("ITEM_MOD_INTELLECT_SHORT", (0.91 + 0.09 * rIll / 5) / (0.91 + 0.09 * bIll / 5))

        -- Reverence (Holy t3, 3 ranks): Spirit regenerates in combat only through
        -- it. Baked ranks: 0 at 15, 1 at 20, 3 from 25. Intellect's mana part is
        -- worth about 4% more per missing rank from 40.
        local bRev = MSC.ForeverLevelLerp({ {15, 0}, {20, 1}, {25, 3} }, level)
        local rRev = Rank("REVERENCE")
        Mul("ITEM_MOD_SPIRIT_SHORT", (0.30 + 0.07 * rRev) / (0.30 + 0.07 * bRev))
        if level >= 40 then Mul("ITEM_MOD_INTELLECT_SHORT", 1 + 0.04 * (bRev - rRev)) end
    end

    if isTankRow then
        -- Shield Specialization (Prot t3, 3 ranks): anchors bake rank 1 at 20 and
        -- rank 3 from 25; scale by the real rank. Block Value is the absorb part,
        -- Intellect and Mp5 the mana-proc part. The block-rating part is handled
        -- in section 2b.
        local rSS = Rank("SHIELD_SPEC")
        if level >= 20 then
            Mul("ITEM_MOD_BLOCK_VALUE_SHORT", (1 + 0.10 * rSS) / 1.3)
            local intLow, intHigh = 0.74 + 0.086 * rSS, 0.66 + 0.113 * rSS
            Mul("ITEM_MOD_INTELLECT_SHORT", MSC.ForeverLevelLerp({ {35, intLow}, {40, intHigh} }, level))
            if level >= 25 and level <= 35 then
                Mul("ITEM_MOD_MANA_REGENERATION_SHORT", 1.2 - 0.067 * rSS)
            end
        end

        -- Holy Shield (Prot t7, level 40): without it Block Value is worth far
        -- less and mana use is lower. The rows bake its +30% block (2 Oct
        -- patch; average block 0.05 -> 0.14), so without it BV x0.05/0.14
        -- (with a little BV kept for Redoubt/gear block) and Int x0.55.
        if level >= 40 and Rank("HOLY_SHIELD") == 0 then
            Mul("ITEM_MOD_BLOCK_VALUE_SHORT", 0.33)
            Mul("ITEM_MOD_INTELLECT_SHORT", 0.55)
            MulAll({ "ITEM_MOD_DODGE_RATING_SHORT", "ITEM_MOD_PARRY_RATING_SHORT", "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
                     "ITEM_MOD_BLOCK_RATING_SHORT" }, 0.94)
        end

        -- Redoubt (Prot t1, 5 ranks): +1.56% block chance per rank on average
        -- (its proc gives 4%/rank since the 2 Oct patch, was 6%), against a
        -- baked average block of 0.05 below 40 and 0.14 from 40 (Holy Shield).
        local rRed = Rank("REDOUBT")
        if rRed > 0 and not modelRow then
            Mul("ITEM_MOD_BLOCK_VALUE_SHORT", 1 + ((level >= 40) and 0.11 or 0.31) * rRed)
        end

        -- One-Handed Weapon Specialization (Prot t4, level 25): +3%/rank 1H
        -- damage on the physical share of tank damage.
        local rOneH = Rank("ONE_HAND_SPEC")
        if rOneH > 0 and not modelRow then
            local per = MSC.ForeverLevelLerp({ {40, 0.017}, {45, 0.012} }, level)
            MulAll({ "ITEM_MOD_ATTACK_POWER_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
                     "MSC_WEAPON_DPS_MELEE" }, 1 + per * rOneH)
        end

        -- Improved Seal of Fury (Prot t3, 1 rank; not baked): about 78 mana each
        -- time the Seal of Fury absorb is used up (assumed ~1 per 17 s of
        -- fighting, i.e. ~4.5 mana/s), which covers much of a pull's mana.
        -- From the study model re-run with that income: Intellect x0.48 at 25-35
        -- (x0.70 at 20), x0.88-0.91 from 40 where Shield Specialization's
        -- proc already carries most of it; Mp5 x0.8 -> 0.67 at 25-35, back to
        -- x1 from 40. Without Holy Shield the 25-35 values stay (mana use is
        -- the same shape as before 40).
        if Rank("IMP_SEAL_OF_FURY") > 0 and level >= 20 and not modelRow then
            local noHS = Rank("HOLY_SHIELD") == 0
            if noHS and level >= 35 then
                Mul("ITEM_MOD_INTELLECT_SHORT", 0.50)
                Mul("ITEM_MOD_MANA_REGENERATION_SHORT", 0.70)
            else
                Mul("ITEM_MOD_INTELLECT_SHORT", MSC.ForeverLevelLerp({ {20, 0.70}, {25, 0.48}, {35, 0.50}, {40, 0.88}, {45, 0.89}, {59, 0.91} }, level))
                Mul("ITEM_MOD_MANA_REGENERATION_SHORT", MSC.ForeverLevelLerp({ {20, 0.90}, {25, 0.79}, {35, 0.67}, {40, 1.0} }, level))
            end
        end

        -- Benediction (Ret t1, 5 ranks, -2%/rank mana on instant spells) and
        -- Holy Conduit (Ret t2, 2 ranks, -20%/rank on Consecration/Hammer of
        -- Wrath): the rows bake neither. Re-running the study model, 5 ranks of
        -- Benediction cut Intellect and Spirit by 6% (1.2%/rank) and Holy
        -- Conduit's 2 ranks by a further ~2.5% (1.2%/rank); Mp5 is unchanged,
        -- since rest time is paid per mana either way.
        local rMana = Rank("BENEDICTION") + Rank("HOLY_CONDUIT")
        if rMana > 0 and level >= 15 and not modelRow then
            MulAll({ "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_SPIRIT_SHORT" }, 1 - 0.012 * rMana)
        end

        -- Reckoning (Prot t5, 5 ranks, not baked): 8%/rank chance of an extra
        -- attack after a block (the 20%-after-crit part is rare on a tank).
        -- Extra swings per swing = rank x 0.08 x blocks per mob hit x 1.5; at
        -- ~0.6 of damage from swings and Seal of Fury procs, the physical
        -- family gains about 0.07 x rank x block chance. Average block chance:
        -- 5% base, +9% Holy Shield uptime (from 40, 30% patch value), +1.56%
        -- per Redoubt rank (matching that hook).
        local rRk = Rank("RECKONING")
        if rRk > 0 and not modelRow then
            local avgBlock = 0.05 + ((level >= 40 and Rank("HOLY_SHIELD") > 0) and 0.09 or 0) + 0.0156 * Rank("REDOUBT")
            local rk = 1 + 0.07 * rRk * avgBlock
            MulAll({ "ITEM_MOD_ATTACK_POWER_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
                     "MSC_WEAPON_DPS_MELEE", "ITEM_MOD_HIT_RATING_SHORT" }, rk)
            MSC.ScaleForeverMeleeCrit(weights, rk, level)
        end

        -- Improved Righteous Fury (Prot t3, 3 ranks): -2%/rank damage taken
        -- while Righteous Fury is up; Iron Creed (Prot t6, 5 ranks): -2%/rank
        -- for 6 s after Holy Strike (10 s cooldown, 60% uptime = 1.2%/rank).
        -- The rows price no damage reduction, so the safety stats (Stamina,
        -- armor, avoidance, Block Value, Defense) rise by 1/(1 - reduction),
        -- done through the shared damage-multiplier helper.
        local dmgTaken = (1 - 0.02 * Rank("IMP_RIGHTEOUS_FURY")) * (1 - 0.012 * Rank("IRON_CREED"))
        if dmgTaken < 1 and not modelRow then MSC.ApplyForeverDamageMult(weights, dmgTaken) end
    end

    -- [[ 2. Hit Cap ]]
    -- Hit % includes Precision once (MSC:GetForeverHitPercent); the target is
    -- the level's cap, sliding to the raid cap from 50. Past it Hit keeps 10%
    -- of its value, the same as every other class.
    MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_RATING_SHORT", "MELEE", 0.1, "Hit", activeCaps)
    MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_SPELL_RATING_SHORT", "SPELL", 0.1, "Spell Hit", activeCaps)

    -- [[ 2b. Block for leveling tanks: Shield Specialization ]]
    -- Client data: only rank 3 of Shield Specialization makes blocks restore
    -- 6% of max mana, at a 100% chance (once per 3 sec). The talent text's
    -- "33%" is a third per rank. The leveling tank rows priced block as its
    -- survival value (about 0.6 x Dodge, like other tanks) plus a mana part
    -- hedged to two-thirds for that "33%". So with 3/3 the mana part counts in
    -- full (x1.5), and without rank 3 block is worth its survival value only.
    if currentSpec:find("^Leveling_Tank") and not currentSpec:find("^Leveling_TankDungeon") then
        local block = weights["ITEM_MOD_BLOCK_RATING_SHORT"]
        local dodge = weights["ITEM_MOD_DODGE_RATING_SHORT"] or 0
        if block and block > 0 and dodge > 0 then
            local survival = math.min(block, 0.6 * dodge)
            if Rank("SHIELD_SPEC") >= 3 then
                weights["ITEM_MOD_BLOCK_RATING_SHORT"] = survival + (block - survival) * 1.5
            else
                weights["ITEM_MOD_BLOCK_RATING_SHORT"] = survival
            end
        end
    end

    -- [[ 3. Tank caps: defense toward 440, uncrushable (from 50) ]]
    -- Not for PROT_AOE: farming normal mobs at or below your level has no Defense target or crushing blows.
    if (currentSpec:find("PROT") and currentSpec ~= "PROT_AOE") or currentSpec:find("Tank") then
        MSC.ApplyForeverDefenseTarget(weights, activeCaps)
        -- Holy Shield (talent): +30% block chance while active (2 Oct patch, was 20%)
        MSC.ApplyForeverUncrushable(weights, (Rank("HOLY_SHIELD") > 0) and 30 or 0, activeCaps)
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Paladin:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
end

function Paladin:GetRelicBonus(itemID, currentSpec)
    return MSC.GetForeverRelicBonus(Paladin.Relics, itemID, currentSpec)
end

-- =============================================================
-- LIBRAMS
-- =============================================================
-- Forever and unchanged Classic librams as equivalent stats per spec
-- (MSC.GetForeverRelicBonus). role: "melee" (Retribution), "tank", "healer".
-- Small cooldown/damage effects are estimates for the spec that uses them.
Paladin.Relics = {
    -- Tenets of the Silver Hand: +1% damage vs Undead. About a quarter of
    -- leveling kills are Undead, and weapon damage is about 2x AP-worth for
    -- a leveling Ret: ~0.25% of damage = 0.0075 x AP.
    [249397] = function(role, ctx) return (role ~= "healer") and { ITEM_MOD_ATTACK_POWER_SHORT = 0.0075 * ctx.ap } or {} end,
    -- Libram of Invocation: Seal mana cost -5% (a Seal every ~30 sec)
    [249442] = function(role) return { ITEM_MOD_MANA_REGENERATION_SHORT = (role == "healer") and 0.3 or 0.7 } end,
    -- Sentinel's Libram: Swift Judgement cooldown -10 sec
    [272434] = function(role) return (role == "melee") and { ITEM_MOD_ATTACK_POWER_SHORT = 6 } or {} end,
    -- Libram of Law: Judgement damage +4% (~10% of a Ret's damage; half
    -- that value as threat for a tank)
    [272435] = function(role, ctx)
        if role == "melee" then return { ITEM_MOD_ATTACK_POWER_SHORT = 0.012 * ctx.ap } end
        if role == "tank" then return { ITEM_MOD_ATTACK_POWER_SHORT = 0.006 * ctx.ap } end
        return {}
    end,
    -- Libram of Economy: Holy Light mana cost -5%
    [272436] = function(role) return { ITEM_MOD_MANA_REGENERATION_SHORT = (role == "healer") and 10 or 1 } end,
    -- Steadfast Libram: shield Block Value +30% while Holy Shield is up (~80%)
    [279247] = function(role, ctx)
        if role ~= "tank" or MSC:GetTalentRank("HOLY_SHIELD") <= 0 then return {} end
        return { ITEM_MOD_BLOCK_VALUE_SHORT = 0.24 * ctx.shieldBlock }
    end,
    -- Libram of Infusion: Holy Shock crit +6%
    [279248] = function(role)
        if MSC:GetTalentRank("HOLY_SHOCK") <= 0 then return {} end
        if role == "healer" then return { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 12 } end
        return { ITEM_MOD_SPELL_POWER_SHORT = 10 }
    end,

    -- Unchanged Classic librams (Wowhead Classic data). Single-spell bonuses
    -- count at that spell's share of the spec's healing/damage/mana use.
    -- Libram of Truth: Devotion Aura +55 armor (tanks run it; others often don't)
    [22400] = function(role) return { ITEM_MOD_ARMOR_SHORT = (role == "tank") and 55 or 25 } end,
    -- Libram of Hope: Seal spells cost 20 less (a Seal every ~30 sec)
    [22401] = function(role) return { ITEM_MOD_MANA_REGENERATION_SHORT = (role == "healer") and 1 or 3.3 } end,
    -- Libram of Grace: Cleanse costs 25 less
    [22402] = function(role) return { ITEM_MOD_MANA_REGENERATION_SHORT = (role == "healer") and 1 or 0.3 } end,
    -- Libram of Light: Flash of Light heals up to 83 more (~60% of healing)
    [23006] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 50 } or {} end,
    -- Libram of Divinity (both IDs): Flash of Light heals up to 53 more
    [23201] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 32 } or {} end,
    [23202] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 32 } or {} end,
    -- Libram of Fervor: Seal of the Crusader +48 AP and Judgement of the
    -- Crusader +33 Holy damage (only while running that Seal)
    [23203] = function(role)
        if role == "melee" then return { ITEM_MOD_ATTACK_POWER_SHORT = 30 } end
        if role == "tank" then return { ITEM_MOD_ATTACK_POWER_SHORT = 10 } end
        return {}
    end,
}

-- Profiles for the UI (leveling rows are listed from LevelingWeights once the curves load)
Paladin.Profiles = {}
for k, v in pairs(Paladin.Weights) do Paladin.Profiles[k] = v end

MSC.RegisterModule("PALADIN", Paladin)
