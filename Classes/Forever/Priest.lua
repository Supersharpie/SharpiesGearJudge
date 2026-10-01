local addonName, MSC = ...
local Priest = {}
Priest.Name = "PRIEST"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
Priest.Weights = {
    ["Default"] = {  ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0  },
    -- Healer Spell Crit: 1% crit is worth ~2.4 Healing (a crit heal adds 50%)
    -- -- 4.8 at Healing 2, 48 at Healing 20 (the old 0.8 / 10 made it 0.4-0.5).
    ["HOLY_DEEP"] = {  ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=4.8  },
    ["DISC_PI_SUPPORT"] = {  ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=4.8  },
    ["SHADOW_PVE"] = {  ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0  },
    ["SHADOW_PVP"] = {  ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["HYBRID_POWER_WEAVING"] = {  ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0  },
}

-- =============================================================
-- LEVELING WEIGHTS (Spirit is King)
-- =============================================================
Priest.LevelingWeights = {
    -- Band ladder (Spirit/Mp5/Armor/Defense/school damage by level): see Warrior.lua's LevelingWeights.
    -- Shadow/Wand. Stamina (on ~40-60% of 1-20 items) was entirely absent
    -- here -- added at the 21-40 bracket's own value.
    ["Leveling_1_10"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=7.5, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=7.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.2 },
    ["Leveling_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=7.5, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=7.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.2 },
    -- Brought up to match Leveling_1_10/11_20's convention (Spell Hit/Crit
    -- were entirely absent -- zero weight, invisible to scoring; see
    -- Warrior.lua's leveling-bracket comment for the item-database evidence)
    ["Leveling_21_40"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.2 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=40.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.4 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=45.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.6 },

    -- Healer: also had no Spell Healing weighted at all (a healer profile
    -- with zero credit for healing power), and no Hit -- correctly omitted
    -- here since heals can't miss, matching HOLY_DEEP's own convention.
    -- 11-20 uses the same shape plus Mp5 at HOLY_DEEP's Mp5:Healing ratio.
    ["Leveling_Healer_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8 },
    ["Leveling_Healer_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8 },
    ["Leveling_Healer_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=4.8 },
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=4.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2 },

    -- Smite (same convention fix as the Shadow/Wand brackets above). 11-20:
    -- the Shadow/Wand 11-20 row with all school damage moved to Holy.
    ["Leveling_Smite_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.2 },
    ["Leveling_Smite_21_40"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.2 },
    ["Leveling_Smite_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=40.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.4 },
    ["Leveling_Smite_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=45.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.6 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Priest.PrettyNames = {
    ["HOLY_DEEP"]          = "Healer: Deep Holy",
    ["DISC_PI_SUPPORT"]    = "Healer: Disc (Power Infusion)",
    ["SHADOW_PVE"]         = "DPS: Shadow (PvE)",
    ["SHADOW_PVP"]         = "PvP: Shadow (Blackout)",
    ["HYBRID_POWER_WEAVING"] = "Support: Power Weaving",
    
    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling (11-20)",
    ["Leveling_21_40"]      = "Leveling: Shadow/Wand (21-40)",
    ["Leveling_41_51"]      = "Leveling: Shadow (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Shadow (52-59)",
    
    ["Leveling_Smite_11_20"] = "Leveling: Smite/Holy (11-20)",
    ["Leveling_Smite_21_40"] = "Leveling: Smite/Holy (21-40)",
    ["Leveling_Smite_41_51"] = "Leveling: Smite/Holy (41-51)",
    ["Leveling_Smite_52_59"] = "Leveling: Smite/Holy (52-59)",
    
    ["Leveling_Healer_11_20"] = "Leveling: Healer (11-20)",
    ["Leveling_Healer_21_40"] = "Leveling: Healer (21-40)",
    ["Leveling_Healer_41_51"] = "Leveling: Healer (41-51)",
    ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Healer (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Priest.Talents = { 
    ["SHADOWFORM"]      = "Shadowform",
    ["POWER_INFUSION"]  = "Power Infusion",
    ["SPIRIT_GUIDANCE"] = "Spiritual Guidance",
    ["SHADOW_WEAVING"]  = "Shadow Weaving",
    ["BLACKOUT"]        = "Blackout",
    ["WAND_SPEC"]       = "Wand Specialization",
    ["SPIRIT_TAP"]      = "Spirit Tap",
    ["MENTAL_STRENGTH"] = "Mental Strength",
    ["DIVINE_FURY"]     = "Divine Fury",
    ["SHADOW_FOCUS"]    = "Shadow Focus",
    ["HOLY_PRECISION"]  = "Holy Precision", -- Discipline t2, 3 ranks, +6%/rank hit with Holy spells (client: 18 at 3/3)
    ["SPIRITUAL_HEALING"] = "Spiritual Healing", -- Holy t6, 3 ranks, +3%/rank universal healing done
    ["DARKNESS"]        = "Darkness", -- Shadow t6, 5 ranks, +2%/rank Shadow damage (Same as Classic)
    ["IMP_RENEW"]       = "Improved Renew", -- Holy t1, 3 ranks
    ["IMP_PWS"]         = "Improved Power Word: Shield", -- Discipline t2, 3 ranks
    ["MARTYRDOM"]       = "Martyrdom", -- Discipline t2, 2 ranks
    ["SILENT_RESOLVE"]  = "Silent Resolve", -- Discipline t2, 3 ranks, Holy threat reduction
    ["MEDITATION"]      = "Meditation", -- Discipline t3, 3 ranks, mana regen while casting
    ["INSPIRATION"]     = "Inspiration", -- Holy t3, 3 ranks
    ["MIND_FLAY"]       = "Mind Flay", -- Shadow t3 (L20), 1 rank
    ["DIVINE_AEGIS"]    = "Divine Aegis", -- Discipline t6, 3 ranks, crit heals shield
    ["PENANCE"]         = "Penance", -- Discipline t5 (L30), 1 rank
    ["PRAYER_OF_MENDING"] = "Prayer of Mending", -- Holy t7 (L40), 1 rank
}

-- Leveling role marker talents (see MSC:GetLowLevelRole). Wand Specialization
-- (common Shadow leveling pick) and the Smite talents are deliberately not
-- markers. Discipline's Meditation, Improved Power Word: Shield, Martyrdom and
-- Silent Resolve were dropped as markers: Discipline wand levelers take them
-- too, and one point flipped them to the healer profile (no wand DPS, no hit).
Priest.LowLevelRoles = {
    Leveling_Healer = { "IMP_RENEW", "INSPIRATION" },
}

-- =============================================================
-- LOGIC
-- =============================================================
Priest.ValidWeapons = {
    [4]=true,             -- 1H Maces
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

function Priest:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        -- Find Level Range Suffix
        local suffix = ""
        if level <= 10 then suffix = "_1_10"
        elseif level <= 20 then suffix = "_11_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end

        -- Determine Role
        local role = "Leveling" -- Default Shadow/Wand
        -- Healer markers are checked before Smite: Divine Fury also speeds up
        -- Heal/Greater Heal, so healers take it too
        local lowRole = (level >= 10) and MSC:GetLowLevelRole(Priest.LowLevelRoles)
        if lowRole then
            role = lowRole
        elseif Rank("SHADOWFORM") == 0 and Rank("DIVINE_FURY") > 0 then
            role = "Leveling_Smite" -- Smite
        elseif Rank("SPIRIT_GUIDANCE") > 0 then
            role = "Leveling_Healer" -- Holy
        end
        
        -- Build Key
        -- Level 10 brings the first talent point: a role it marks uses that
        -- role's 11-20 row (the 1-10 band only has the default row).
        if level == 10 and role ~= "Leveling" then suffix = "_11_20" end
        local key = role .. suffix
        
        -- Fallback: If Smite/Healer key doesn't exist for this level, revert to default
        if Priest.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("SHADOWFORM") > 0 and Rank("SHADOW_WEAVING") > 0 then return "SHADOW_PVE" end
    if Rank("SHADOWFORM") > 0 and Rank("BLACKOUT") > 0 then return "SHADOW_PVP" end
    if Rank("POWER_INFUSION") > 0 and Rank("SHADOW_WEAVING") > 0 then return "HYBRID_POWER_WEAVING" end
    if Rank("POWER_INFUSION") > 0 then return "DISC_PI_SUPPORT" end
    if Rank("SPIRIT_GUIDANCE") > 0 then return "HOLY_DEEP" end
    return "HOLY_DEEP"
end

function Priest:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    local level = UnitLevel("player")
    local isLeveling = currentSpec:match("^Leveling") ~= nil
    local isHealerRow = currentSpec:match("^Leveling_Healer") ~= nil
    local isSmiteRow = currentSpec:match("^Leveling_Smite") ~= nil
    local isDefaultRow = currentSpec:match("^Leveling_%d") ~= nil -- Shadow/Wand
    local function Scale(key, mult)
        if weights[key] and mult ~= 1 then weights[key] = weights[key] * mult end
    end

    -- [[ Default Leveling (Shadow/Wand) talent hooks ]]
    if isDefaultRow then
        local rMF = Rank("MIND_FLAY")
        local rSF = Rank("SHADOWFORM")

        -- No-Shadowform restore: the 40+ rows bake Shadowform in, so a Disc/wand
        -- build without it gets the factors back (ramped in from 35 to 40)
        if level >= 36 and rSF == 0 then
            local p = (level >= 40) and 1 or ((level - 35) / 5)
            local function F(f) return f ^ p end
            Scale("ITEM_MOD_DAMAGE_PER_SECOND_SHORT", F(3.3))
            Scale("ITEM_MOD_INTELLECT_SHORT", F(1.47))
            Scale("ITEM_MOD_MANA_SHORT", F(1.6))
            Scale("ITEM_MOD_SPIRIT_SHORT", F(2.0))
            Scale("ITEM_MOD_MANA_REGENERATION_SHORT", F(1.1))
            Scale("ITEM_MOD_HIT_SPELL_RATING_SHORT", F(1.14))
            Scale("ITEM_MOD_STAMINA_SHORT", F(1.14))
            Scale("ITEM_MOD_HEALTH_SHORT", F(1.14))
            Scale("ITEM_MOD_HEALTH_REGENERATION_SHORT", F(1.14))
            Scale("ITEM_MOD_DODGE_RATING_SHORT", F(1.14))
            Scale("ITEM_MOD_ARMOR_SHORT", F(1.18))
            MSC.ScaleForeverSpellCrit(weights, F(0.72), level)
        end

        -- Mind Flay ramp (28-39): the wand gives way to Mind Flay. Applied once,
        -- never stacked with Wand Specialization
        local mindFlayFired = false
        if rMF > 0 and level >= 28 and level < 40 then
            mindFlayFired = true
            Scale("ITEM_MOD_DAMAGE_PER_SECOND_SHORT", MSC.ForeverLevelLerp({ {35, 0.6}, {40, 1.0} }, level))
            Scale("ITEM_MOD_SPIRIT_SHORT", MSC.ForeverLevelLerp({ {35, 0.75}, {40, 1.0} }, level))
        end

        -- Wand Specialization (Discipline t1, 2 ranks): wand damage 13% / 25%
        local rWand = Rank("WAND_SPEC")
        if rWand > 0 and not mindFlayFired and (rMF == 0 or rSF == 0) then
            Scale("ITEM_MOD_DAMAGE_PER_SECOND_SHORT", ({ 1.13, 1.25 })[math.min(rWand, 2)])
        end

        -- Spirit Tap (Shadow t1, 5 ranks) and Meditation (Discipline t3, 3 ranks)
        -- come from different trees; if both are taken the larger one applies
        local tapMult = 1 + 0.16 * Rank("SPIRIT_TAP")
        local medMult = 1 + ((rMF > 0) and 0.18 or 0.12) * Rank("MEDITATION")
        Scale("ITEM_MOD_SPIRIT_SHORT", math.max(tapMult, medMult))
    end

    -- [[ Healer: Meditation, Divine Aegis, Penance, Prayer of Mending ]]
    if isHealerRow then
        -- Meditation (Discipline t3, 3 ranks): Spirit regen while casting, so Spirit
        -- gains and Intellect/Mana lose value
        local rMedH = Rank("MEDITATION")
        if rMedH > 0 and level >= 20 then
            Scale("ITEM_MOD_SPIRIT_SHORT", 1 + 0.144 * rMedH)
            local k = MSC.ForeverLevelLerp({ {25, 0}, {30, 0.032}, {40, 0.051}, {50, 0.078}, {59, 0.085} }, level)
            local m = 1 - k * rMedH
            Scale("ITEM_MOD_INTELLECT_SHORT", m)
            Scale("ITEM_MOD_MANA_SHORT", m)
        end

        -- Divine Aegis (Discipline t6, 3 ranks): crit heals shield
        local rAegis = Rank("DIVINE_AEGIS")
        if rAegis > 0 then
            MSC.ScaleForeverSpellCrit(weights, 1 + 0.10 * rAegis, level)
        end

        -- Penance (Discipline t5, L30) and Prayer of Mending (Holy t7, L40) cover
        -- part of the mana demand at a fraction of the cost
        local manaMult = 1
        if Rank("PENANCE") > 0 and level >= 30 then manaMult = manaMult * ((level >= 40) and 0.85 or 0.90) end
        if Rank("PRAYER_OF_MENDING") > 0 and level >= 40 then manaMult = manaMult * 0.90 end
        Scale("ITEM_MOD_INTELLECT_SHORT", manaMult)
        Scale("ITEM_MOD_MANA_SHORT", manaMult)

        -- Wand Specialization (Discipline t1, 2 ranks, 12.5% per rank)
        Scale("ITEM_MOD_DAMAGE_PER_SECOND_SHORT", 1 + 0.125 * Rank("WAND_SPEC"))
    end

    -- [[ Smite: Meditation, Wand Specialization ]]
    if isSmiteRow then
        Scale("ITEM_MOD_SPIRIT_SHORT", 1 + 0.11 * Rank("MEDITATION"))
        Scale("ITEM_MOD_DAMAGE_PER_SECOND_SHORT", 1 + 0.13 * Rank("WAND_SPEC"))
    end

    -- [[ 1. Spiritual Guidance (Spirit -> Spell Power) ]]
    -- Holy t5, 5 ranks: the text (healing up to 5% of Spirit, damage up to 1%) is
    -- the rank-1 value, so per rank it is 5% healing / 1.6% damage (Smite rows:
    -- damage 1% of Spirit, healing only when the row carries a healing weight)
    local rSG = Rank("SPIRIT_GUIDANCE")
    if rSG > 0 and weights["ITEM_MOD_SPIRIT_SHORT"] then
        local spWeight = weights["ITEM_MOD_SPELL_POWER_SHORT"] or 0
        if isSmiteRow then
            local healWeight = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0
            weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] + (healWeight * (rSG * 0.05)) + (spWeight * (rSG * 0.01))
        else
            local healWeight = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or spWeight
            local dmgWeight = weights["ITEM_MOD_SPELL_DAMAGE_DONE_SHORT"] or spWeight
            weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] + (healWeight * (rSG * 0.05)) + (dmgWeight * (rSG * 0.016))
        end
    end

    local rMent = Rank("MENTAL_STRENGTH")
    if rMent > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rMent * 0.03))
    end

    -- Shadowform (Shadow t7, 1 rank): doubles the crit damage bonus of Shadow
    -- spells (+100% crit damage bonus, i.e. 50% -> 100%, a flat 2x on Crit's value)
    -- Leveling rows already build Shadowform's crit bonus into their 40-59
    -- keyframes (LevelingCurves.lua), so only the endgame profiles get it here.
    if Rank("SHADOWFORM") > 0 and not currentSpec:match("^Leveling") and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * 2.0
    end

    -- Spiritual Healing (Holy t6, 3 ranks): +3%/rank universal healing done
    local rSpiritHeal = Rank("SPIRITUAL_HEALING")
    if rSpiritHeal > 0 then
        if isHealerRow then
            -- A healing multiplier also scales Int/Mp5/Spirit/crit per mana, so the
            -- row keeps Healing and the solo-only stats are divided instead
            local inv = 1 / (1 + 0.03 * rSpiritHeal * 0.6)
            Scale("ITEM_MOD_SPELL_DAMAGE_DONE_SHORT", inv)
            Scale("ITEM_MOD_SPELL_POWER_SHORT", inv)
            Scale("ITEM_MOD_DAMAGE_PER_SECOND_SHORT", inv)
            Scale("ITEM_MOD_HIT_SPELL_RATING_SHORT", inv)
            Scale("ITEM_MOD_SHADOW_DAMAGE_SHORT", inv)
            Scale("ITEM_MOD_ARCANE_DAMAGE_SHORT", inv)
        elseif weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
            weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rSpiritHeal * 0.03))
        end
    end

    -- Darkness (Shadow t6, 5 ranks, Same as Classic): +2%/rank Shadow damage
    local rDark = Rank("DARKNESS")
    if rDark > 0 then
        if isDefaultRow then
            -- (the default Leveling_<band> profiles are the Shadow/Wand leveling weights)
            -- Shadow damage is ~0.65 of the kill, the rest of the gain is hit/crit value
            local dm = 1 + (rDark * 0.02 * 0.65)
            Scale("ITEM_MOD_SPELL_POWER_SHORT", dm)
            Scale("ITEM_MOD_SHADOW_DAMAGE_SHORT", dm)
            local cm = 1 + (rDark * 0.02 * 0.35)
            Scale("ITEM_MOD_SPELL_CRIT_RATING_SHORT", cm)
            Scale("ITEM_MOD_HIT_SPELL_RATING_SHORT", cm)
        elseif currentSpec:find("SHADOW") and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rDark * 0.02))
        end
    end

    -- Leveling rows: no weight lingers in (0, 0.02)
    if isLeveling then
        for k, v in pairs(weights) do
            if type(v) == "number" and v > 0 and v < 0.02 then weights[k] = 0 end
        end
    end

    -- [[ 2. Covariance (Mana Regen / Healing Power Synergy) ]]
    if currentSpec:find("HOLY") or currentSpec:find("DISC") then
        -- FIX: Use GetPlayerStat via Shim (This usually returns bonus healing)
        local healPower = MSC.SanitizeStat(GetSpellBonusHealing()) -- Vanilla API for Healing
        
        if healPower > 600 then
            local hScaler = 1 + ((healPower - 600) / 6000)
            weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * hScaler
        end
    end

    -- [[ 3. Spell Hit Cap ]]
    -- Every damage profile (Shadow and Smite leveling included, not only the
    -- endgame SHADOW ones). Target is the level's cap, sliding to the raid
    -- cap from 50. Shadow Focus (1%/rank, Shadow only) is added for Shadow
    -- profiles and Holy Precision (6%/rank, Holy only; 18% at 3/3 covers any
    -- leveling cap on its own) for Smite, since the
    -- game's general spell-hit number includes neither.
    local isShadow = currentSpec:find("SHADOW") or currentSpec:match("^Leveling_%d")
    local talentHit = (isShadow and Rank("SHADOW_FOCUS")) or (currentSpec:find("Smite") and Rank("HOLY_PRECISION") * 6) or 0
    MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_SPELL_RATING_SHORT", "SPELL", 0.1, "Spell Hit", activeCaps, talentHit)

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Priest:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
end

-- =============================================================
-- REGISTER
-- =============================================================
Priest.Profiles = {}
for k, v in pairs(Priest.Weights) do Priest.Profiles[k] = v end
for k, v in pairs(Priest.LevelingWeights) do Priest.Profiles[k] = v end

MSC.RegisterModule("PRIEST", Priest)




