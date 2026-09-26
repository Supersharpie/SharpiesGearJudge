local addonName, MSC = ...
local Warrior = {}
Warrior.Name = "WARRIOR"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
-- Strength/Attack Power/Weapon DPS/Agility calibrated to real conversion math
-- (see Paladin.lua for the full derivation): 1 Strength = 2 Attack Power for
-- a plate melee class, 14 Attack Power = 1 point of weapon DPS, and Warriors
-- get 0 Attack Power from Agility (only Crit/Dodge/Armor), so it's
-- subordinated rather than matching Strength's magnitude.
Warrior.Weights = {
    ["Default"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["FURY_2H"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=3.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["FURY_DW"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=3.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["ARMS_MS"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=3.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    -- DEEP_PROT/FURY_PROT/ARMS_PROT never weighted Attack Power at all --
    -- added at the 2:1 ratio (2.5 to credit Strength's Block Value bonus for
    -- a shield-equipped tank). ARMS_PROT's Strength/Agility were still on the
    -- old 15.0/10.0 scale (the same flaw Default had) -- fixed to match.
    -- Armor 0.075 (was 0.5): the parser counts full base armor, and at raid
    -- health one armor point is only ~4-6% of a Stamina point (armor math in
    -- the band-ladder comment in LevelingWeights) -- 0.5 let shields and
    -- plate chests win on armor alone.
    ["DEEP_PROT"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.075, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["FURY_PROT"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.075, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["ARMS_PROT"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.8, ["ITEM_MOD_PARRY_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
}

-- =============================================================
-- LEVELING WEIGHTS (The Spirit Meta)
-- =============================================================
Warrior.LevelingWeights = {
    -- [[ BAND LADDER -- every Forever class's leveling brackets follow this ]]
    -- Weights step down at thresholds instead of sliding toward the raid
    -- profiles: 40 brings mounts and deep talents, and Hit/Crit gear only
    -- starts dropping at 41 (none below that in Forever's item data).
    --   * Spirit: full value through 40, halved at 41-51, about a quarter at
    --     52-59. Priest/Mage taper slower; healers keep theirs (every Forever
    --     healer has a spirit-while-casting talent).
    --   * Mp5: worth the Spirit it replaces -- 1 Mp5 = 1.6 Spirit for Priest/
    --     Mage, 2 for other casters; hybrids use their Spirit weight.
    --   * Armor: the parser counts an item's full base armor, and by the
    --     armor formula (A / (A + 400 + 85 x mob level)) one point is only
    --     ~2-4% of a Stamina point for a tank: 0.045 / 0.05 / 0.06 / 0.075 at
    --     Stamina 2.0 for 11-20 / 21-40 / 41-51 / 52-59 (bears, with Bear
    --     Form's armor bonus: 0.08 / 0.1 / 0.17 / 0.19). Non-tanks get 0.025 x
    --     their Stamina weight.
    --   * Defense (tanks; 1 rating = 1 skill in Forever): ~0.18% less damage
    --     per point vs 10 HP per Stamina, so it climbs with the health pool --
    --     0.25 / 0.5 / 1.0 / 1.6 at Stamina 2.0, still under Stamina until the
    --     raid profiles.
    --   * Tank Weapon DPS tapers as talents take over threat.
    --   * School spell damage ("+X Frost Spell Damage") = Spell Power x the
    --     share of the spec's damage from that school.
    --   * Casters' Spell Hit/Crit rise at 41+ (40/25, then 45/30 at Spell
    --     Power 15) so hit/crit gear can compete with Spell Power gear.

    -- Standard Arms/2H Fury
    ["Leveling_1_10"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=5.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=5.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    -- Brought up to match Leveling_1_10/11_20's convention (was compressed to
    -- an Era-leveling scale assuming secondary stats don't itemize until
    -- mid-20s+; confirmed via foreverchanges.pro's item database that Forever
    -- already itemizes Attack Power, Spell Power, Defense Rating, and school
    -- damage on req-level 21-22 rares, so that assumption doesn't hold here).
    -- Strength/Weapon DPS/Agility further corrected to the confirmed
    -- Strength:AP (2:1) and Weapon DPS:AP (14:1) conversion math -- see the
    -- comment above Warrior.Weights for the derivation.
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },

    -- Dual Wield Fury Leveling (same convention fix as above)
    ["Leveling_DW_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_DW_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_DW_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },

    -- Tank Leveling: Stamina/Agility/Armor/Spirit already matched DEEP_PROT's
    -- own convention (that raid profile keeps them compressed too -- only
    -- Hit/Weapon Skill/Defense sit high there), so those are untouched. Hit
    -- and Defense Skill were entirely absent (zero weight, invisible to
    -- scoring) and Weapon Skill was still on the old compressed scale --
    -- added/raised to match DEEP_PROT's own values for those three. Attack
    -- Power was completely unweighted (mirrors DEEP_PROT's own pre-fix gap)
    -- -- added at 1.0, with Strength raised to 2.5 for the 2:1 ratio plus a
    -- small Block Value credit, matching DEEP_PROT's endgame convention.
    -- Armor, Defense, Weapon DPS and Block Value follow the band ladder above.
    -- 11-20 tank: same shape as Leveling_Tank_21_40, plus Weapon DPS at half
    -- the DPS brackets' 14.0 (low-level threat comes almost entirely from
    -- weapon damage). Defense Rating converts 1:1 into Defense (Forever's flat
    -- rating, see Database_Forever) but is weighted low: each point is ~0.04%
    -- each of dodge/parry/block/miss/crit taken (~0.2% less damage), while 1
    -- Stamina is ~1.5-2% more health on a 500-700 HP tank -- about 8x more.
    ["Leveling_Tank_11_20"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.045, ["ITEM_MOD_SPIRIT_SHORT"]=0.2, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=7.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=0.2, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.3 },
    ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.06, ["ITEM_MOD_SPIRIT_SHORT"]=0.1, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0 },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.075, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.6, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Warrior.PrettyNames = {
    ["FURY_DW"]         = "Raid: Fury (Dual Wield)",
    ["FURY_2H"]         = "Raid: Fury (2H Slam)",
    ["ARMS_MS"]         = "PvP: Arms (Mortal Strike)",
    ["DEEP_PROT"]       = "Tank: Deep Protection",
    ["FURY_PROT"]       = "Tank: Fury-Prot (Threat)",
    ["ARMS_PROT"]       = "Tank: Arms (Dungeon Hybrid)",
    
    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling (11-20)",
    ["Leveling_21_40"]      = "Leveling: Arms/Fury (21-40)",
    ["Leveling_41_51"]      = "Leveling: Arms/Fury (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Fury (52-59)",
    
    ["Leveling_DW_21_40"]   = "Leveling: Dual Wield (21-40)",
    ["Leveling_DW_41_51"]   = "Leveling: Dual Wield (41-51)",
    ["Leveling_DW_52_59"]   = "Leveling: Dual Wield (52-59)",
    
    ["Leveling_Tank_11_20"] = "Leveling: Tank (11-20)",
    ["Leveling_Tank_21_40"] = "Leveling: Tank (21-40)",
    ["Leveling_Tank_41_51"] = "Leveling: Tank (41-51)",
    ["Leveling_Tank_52_59"] = "Leveling: Tank (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Warrior.Talents = { 
    ["MORTAL_STRIKE"]    = "Mortal Strike",
    ["BLOODTHIRST"]      = "Bloodthirst",
    ["SHIELD_SLAM"]      = "Shield Slam",
    ["DEFIANCE"]         = "Defiance",
    ["IMP_SLAM"]         = "Improved Slam",
    ["DW_SPEC"]          = "Dual Wield Specialization",
    ["TACTICAL_MASTERY"] = "Improved Tactical Mastery", -- Renamed in Forever
    ["CRUELTY"]          = "Cruelty",
    ["FLURRY"]           = "Flurry",
    ["IMPALE"]           = "Impale",
    ["TOUGHNESS"]        = "Toughness",
    ["PRECISION"]        = "Precision", -- New in Forever (Fury t5, 3 ranks, +1%/rank Hit)
    ["BASTION"]          = "Bastion", -- New in Forever (Prot t5 since the 2026-09-24 beta build, swapped with Focused Rage; 5 ranks, +2%/rank damage w/ shield)
    ["WEAPONMASTER"]     = "Weaponmaster", -- New in Forever (Arms t5, 5 ranks, per-weapon-type bonus)
    ["TWOH_SPEC"]        = "Two-Handed Weapon Specialization", -- Changed from Classic (Arms t4, 3 ranks, +1%/rank 2H melee damage)
    ["SHIELD_SPEC"]      = "Shield Specialization", -- Prot t1, 5 ranks, +5% Block, Rage on block
    ["ANTICIPATION"]     = "Anticipation", -- Prot t1, 5 ranks, +20 Defense Skill
    ["MASTER_OF_DEFENSE"] = "Master of Defense", -- New in Forever, Prot t3, 2 ranks, Rage on Dodge/Parry with a shield
    ["IMP_REVENGE"]      = "Improved Revenge", -- Prot t3, 3 ranks
    ["LAST_STAND"]       = "Last Stand", -- Prot t3, 1 rank
    -- "Vitality" is the only one of the three actually gone -- confirmed 0/126
    -- matches on wowforevertools.com/changes/warrior even with every status
    -- filter (New/Changed/Same as Classic) enabled. Impale and Toughness are
    -- both present and unchanged from Classic (verified the same way after
    -- initially missing them: the site's default view hides "Same as Classic"
    -- talents, so absence from the default 90-of-126 list doesn't mean gone).
    -- No confirmed Forever replacement covers Vitality's old Stamina+Strength
    -- scaling role, so that ApplyScalers hook stays removed.
}

-- =============================================================
-- LOGIC
-- =============================================================
Warrior.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes
    [4]=true, [5]=true,   -- 1H/2H Maces
    [7]=true, [8]=true,   -- 1H/2H Swords
    [6]=true,             -- Polearms
    [10]=true,            -- Staves
    [13]=true, [15]=true, -- Fists, Daggers
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Crossbow, Thrown
}

Warrior.EndgameTabMap = { [1] = "ARMS_MS", [2] = "FURY_DW", [3] = "DEEP_PROT" }

-- Leveling role marker talents (see MSC:GetLowLevelRole)
Warrior.LowLevelRoles = {
    Leveling_Tank = { "SHIELD_SPEC", "ANTICIPATION", "MASTER_OF_DEFENSE", "IMP_REVENGE", "DEFIANCE", "LAST_STAND" },
}

function Warrior:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("SHIELD_SLAM") > 0 then return "DEEP_PROT", "high" end
        if Rank("BLOODTHIRST") > 0 and Rank("DEFIANCE") > 0 then return "FURY_PROT", "high" end
        if Rank("TACTICAL_MASTERY") > 0 and Rank("DEFIANCE") > 0 then return "ARMS_PROT", "high" end
        if Rank("BLOODTHIRST") > 0 and Rank("IMP_SLAM") > 0 then return "FURY_2H", "high" end
        if Rank("BLOODTHIRST") > 0 then return "FURY_DW", "high" end
        if Rank("MORTAL_STRIKE") > 0 then return "ARMS_MS", "high" end
        local fallback, conf = MSC:GetDominantTalentTree(Warrior.EndgameTabMap, 5)
        if fallback then return fallback, conf end
        return "FURY_DW", "ambiguous"
    end

    -- [[ 2. LEVELING SPEC DETECTION ]]
    -- Fix: Match the strings to the LevelingWeights table exactly
    local suffix = ""
    if level <= 10 then suffix = "_1_10"
        elseif level <= 20 then suffix = "_11_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    else suffix = "_52_59" end

    -- Determine Role based on Talents
    local role = "Leveling" -- Default to 2H/Arms style
    if Rank("SHIELD_SLAM") > 0 or Rank("DEFIANCE") > 0 then 
        role = "Leveling_Tank"
    elseif Rank("DW_SPEC") > 0 or Rank("BLOODTHIRST") > 0 then
        role = "Leveling_DW"
    elseif level > 10 then
        role = MSC:GetLowLevelRole(Warrior.LowLevelRoles) or role
    end

    -- Construct Key (e.g., "Leveling_DW_21_40")
    local specificKey = role .. suffix
    
    -- Check if it exists, otherwise fall back to generic
    if Warrior.LevelingWeights[specificKey] then return specificKey, "high" end
    if Warrior.LevelingWeights["Leveling" .. suffix] then return "Leveling" .. suffix, "high" end
    
    return "Leveling_1_20", "low"
end

function Warrior:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- Toughness: confirmed unchanged from Classic (+2%/rank Armor from items)
    local rTough = Rank("TOUGHNESS")
    if rTough > 0 and weights["ITEM_MOD_ARMOR_SHORT"] then
        weights["ITEM_MOD_ARMOR_SHORT"] = weights["ITEM_MOD_ARMOR_SHORT"] * (1 + (rTough * 0.02))
    end

    -- Impale (Arms t4, 2 ranks, Same as Classic): +10%/rank crit damage bonus
    -- on all abilities -- same math family as Ruin/Vengeance/Arcane Mind, but
    -- only 2 ranks so it tops out at 1.2x rather than doubling
    local rImpale = Rank("IMPALE")
    if rImpale > 0 and weights["ITEM_MOD_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rImpale * 0.10))
    end

    -- Bastion (New in Forever, Prot t5, 5 ranks): +2%/rank damage while a
    -- shield is equipped. Every Protection profile requires a shield, so it's
    -- safe to apply unconditionally for PROT specs rather than checking gear.
    -- None of DEEP_PROT/FURY_PROT/ARMS_PROT weight Attack Power at all -- they
    -- use Strength as their damage proxy -- so this scales Strength instead.
    local rBastion = Rank("BASTION")
    if rBastion > 0 and (currentSpec:find("PROT") or currentSpec:find("Tank")) and weights["ITEM_MOD_STRENGTH_SHORT"] then
        weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rBastion * 0.02))
    end

    -- Two-Handed Weapon Specialization (Changed from Classic, Arms t4, 3
    -- ranks): +1%/rank 2H melee damage -- only the pure 2H specs (not DW)
    -- weight Attack Power at all among the non-tank profiles.
    local rTwoH = Rank("TWOH_SPEC")
    if rTwoH > 0 and not currentSpec:find("DW") and not currentSpec:find("PROT") and not currentSpec:find("Tank") and weights["ITEM_MOD_ATTACK_POWER_SHORT"] then
        weights["ITEM_MOD_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_ATTACK_POWER_SHORT"] * (1 + (rTwoH * 0.01))
    end

    -- [[ 1. HIT CAP (Using Shim) ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        local currentHit = MSC:GetPlayerStat("HIT")
        -- Precision (New in Forever, Fury t5, 3 ranks): +1%/rank Hit
        local totalHit = currentHit + Rank("PRECISION")
        local yellowCap = 9

        if currentSpec:find("DW") then
            -- Dual wield: Hit keeps expanding the white-swing crit cap up to 28%
            local newWeight, capped = MSC.ApplyForeverDualWieldHitTaper(weights["ITEM_MOD_HIT_RATING_SHORT"], totalHit, yellowCap, 28)
            if capped then
                weights["ITEM_MOD_HIT_RATING_SHORT"] = newWeight
                table.insert(activeCaps, "Yellow Hit ("..yellowCap.."%)")
            end
        elseif totalHit >= yellowCap then
            -- 2H/tank: single-wield white swings see no benefit past the yellow cap
            weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * 0.1
            table.insert(activeCaps, "Yellow Hit ("..yellowCap.."%)")
        end
    end

    -- [[ 2. WEAPON SKILL CAP (Removed in Forever) ]]

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

-- Weaponmaster (New in Forever, Arms t5, 5 ranks): per-weapon-type bonus.
-- Only the Axe/Polearm branch (+1%/rank Crit) converts cleanly into a score
-- value -- same math as the racial weapon-crit bonuses below. The Mace/Staff
-- (armor ignore) and Sword (extra-attack proc chance) branches aren't scored:
-- turning either into a score value would need target armor or weapon speed
-- data this addon doesn't track anywhere.
local function GetWeaponmasterCritBonus(itemLink, weights)
    local rWM = MSC:GetTalentRank("WEAPONMASTER")
    if rWM <= 0 or not itemLink or not weights then return 0 end

    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 or not subClassID then return 0 end
    if subClassID ~= 0 and subClassID ~= 1 and subClassID ~= 6 then return 0 end -- Axes (0/1), Polearms (6)

    -- Crit weight is already "per 1%" (see MSC.GetForeverWeaponRacialBonus)
    return rWM * (weights["ITEM_MOD_CRIT_RATING_SHORT"] or 0) -- +1%/rank Crit
end

function Warrior:GetWeaponBonus(itemLink, weights)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights) + GetWeaponmasterCritBonus(itemLink, weights)
end

-- =============================================================
-- REGISTER
-- =============================================================
Warrior.Profiles = {}
for k, v in pairs(Warrior.Weights) do Warrior.Profiles[k] = v end
for k, v in pairs(Warrior.LevelingWeights) do Warrior.Profiles[k] = v end

MSC.RegisterModule("WARRIOR", Warrior)


