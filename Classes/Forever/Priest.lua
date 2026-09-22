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
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.2 },
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

    -- Smite (same convention fix as the Shadow/Wand brackets above)
    ["Leveling_Smite_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.2 },
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
    ["SPIRITUAL_HEALING"] = "Spiritual Healing", -- Holy t6, 3 ranks, +3%/rank universal healing done
    ["DARKNESS"]        = "Darkness", -- Shadow t6, 5 ranks, +2%/rank Shadow damage (Same as Classic)
    ["IMP_RENEW"]       = "Improved Renew", -- Holy t1, 3 ranks
    ["IMP_PWS"]         = "Improved Power Word: Shield", -- Discipline t2, 3 ranks
    ["MARTYRDOM"]       = "Martyrdom", -- Discipline t2, 2 ranks
    ["SILENT_RESOLVE"]  = "Silent Resolve", -- Discipline t2, 3 ranks, Holy threat reduction
    ["MEDITATION"]      = "Meditation", -- Discipline t3, 3 ranks, mana regen while casting
    ["INSPIRATION"]     = "Inspiration", -- Holy t3, 3 ranks
}

-- Leveling role marker talents (see MSC:GetLowLevelRole). Wand Specialization
-- (common Shadow leveling pick) and the Smite talents are deliberately not
-- markers.
Priest.LowLevelRoles = {
    Leveling_Healer = { "IMP_RENEW", "IMP_PWS", "MARTYRDOM", "SILENT_RESOLVE", "MEDITATION", "INSPIRATION" },
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
        local lowRole = (level > 10) and MSC:GetLowLevelRole(Priest.LowLevelRoles)
        if lowRole then
            role = lowRole
        elseif Rank("SHADOWFORM") == 0 and Rank("DIVINE_FURY") > 0 then
            role = "Leveling_Smite" -- Smite
        elseif Rank("SPIRIT_GUIDANCE") > 0 then
            role = "Leveling_Healer" -- Holy
        end
        
        -- Build Key
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

    -- [[ 1. Spiritual Guidance (Spirit -> Spell Power) ]]
    -- Confirmed max is "up to 5%" healing / "up to 1%" damage at 5/5, so
    -- per-rank is 1% / 0.2% -- was miscalibrated 5x too strong at 0.05/0.01
    local rSG = Rank("SPIRIT_GUIDANCE")
    if rSG > 0 and weights["ITEM_MOD_SPIRIT_SHORT"] then
        local healWeight = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or weights["ITEM_MOD_SPELL_POWER_SHORT"] or 0
        local dmgWeight = weights["ITEM_MOD_SPELL_DAMAGE_DONE_SHORT"] or weights["ITEM_MOD_SPELL_POWER_SHORT"] or 0
        weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] + (healWeight * (rSG * 0.01)) + (dmgWeight * (rSG * 0.002))
    end

    local rMent = Rank("MENTAL_STRENGTH")
    if rMent > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rMent * 0.03))
    end

    -- Shadowform (Shadow t7, 1 rank): doubles the crit damage bonus of Shadow
    -- spells (+100% crit damage bonus, i.e. 50% -> 100%, a flat 2x on Crit's value)
    if Rank("SHADOWFORM") > 0 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * 2.0
    end

    -- Spiritual Healing (Holy t6, 3 ranks): +3%/rank universal healing done
    local rSpiritHeal = Rank("SPIRITUAL_HEALING")
    if rSpiritHeal > 0 and weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
        weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rSpiritHeal * 0.03))
    end

    -- Darkness (Shadow t6, 5 ranks, Same as Classic): +2%/rank Shadow damage
    local rDark = Rank("DARKNESS")
    -- (the default Leveling_<band> profiles are the Shadow/Wand leveling weights)
    if rDark > 0 and (currentSpec:find("SHADOW") or currentSpec:match("^Leveling_%d")) and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
        weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rDark * 0.02))
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

    -- [[ 3. Shadow Hit Cap (16%) ]]
    if currentSpec:find("SHADOW") and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then
        -- FIX: Use GetPlayerStat via Shim (Returns Percent in Era)
        local gearHit = MSC:GetPlayerStat("SPELL_HIT") 
        local talentHit = Rank("SHADOW_FOCUS") * 1 -- 1% per rank in Forever
        local totalHit = gearHit + talentHit
        
        if totalHit >= 16 then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0 -- Cap reached
            table.insert(activeCaps, "Hit (16%)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Priest:GetWeaponBonus(itemLink, weights)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights)
end

-- =============================================================
-- REGISTER
-- =============================================================
Priest.Profiles = {}
for k, v in pairs(Priest.Weights) do Priest.Profiles[k] = v end
for k, v in pairs(Priest.LevelingWeights) do Priest.Profiles[k] = v end

MSC.RegisterModule("PRIEST", Priest)




