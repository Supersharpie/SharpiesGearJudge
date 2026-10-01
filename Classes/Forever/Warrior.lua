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
    -- Each row is the weights at the START of its band; MSC:GetLevelingRow
    -- (Dynamic_Engine) slides them level by level toward the next band's row,
    -- TBC-style, and a role's last band (52-59) holds flat. Rows don't slide
    -- toward the raid profiles, which use different scales. Hit/Crit gear
    -- only starts dropping at 41 (none below that in Forever's item data).
    -- The value per band below is where that slide reaches at the band start.
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
    ["Leveling_21_40"] = { ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=5.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },

    -- Dual Wield Fury Leveling (same convention fix as above). 11-20 matches
    -- the 2H 11-20 row; Warriors learn Dual Wield at 20.
    ["Leveling_DW_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=5.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_DW_21_40"] = { ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=5.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
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
    
    ["Leveling_DW_11_20"]   = "Leveling: Dual Wield (11-20)",
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
    ["DEEP_WOUNDS"]      = "Deep Wounds", -- Arms t3, 3 ranks, bleed from weapon damage
    ["SPEARING_STRIKE"]  = "Spearing Strike", -- Arms t4, 1 rank
    ["BLOODTHRILL"]      = "Bloodthrill", -- Arms t5, 5 ranks (Overpower on hit)
    ["RAGING_BLOWS"]     = "Raging Blows", -- Fury t4, 1 rank (Whirlwind off-hand)
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
    elseif level >= 10 then
        role = MSC:GetLowLevelRole(Warrior.LowLevelRoles) or role
        -- No low-tier talent marks dual wield (Fury's tier 1-3 picks suit a
        -- 2H too), so check for a weapon in the off-hand instead. Equipment
        -- changes clear the cached spec (Dynamic_Engine's talentTracker).
        if role == "Leveling" then
            local offhand = GetInventoryItemLink("player", 17)
            local classID = offhand and select(6, GetItemInfoInstant(offhand))
            if classID == 2 then role = "Leveling_DW" end
        end
    end

    -- Construct Key (e.g., "Leveling_DW_21_40")
    -- Level 10 brings the first talent point: a role it marks uses that
    -- role's 11-20 row (the 1-10 band only has the default row).
    if level == 10 and role ~= "Leveling" then suffix = "_11_20" end
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

    local level = UnitLevel("player")
    local isLeveling = currentSpec:find("^Leveling") ~= nil
    local isDW = currentSpec:find("DW") ~= nil
    local isTank = (currentSpec:find("PROT") or currentSpec:find("Tank")) ~= nil
    local isLevelingTwoH = isLeveling and not isDW and not isTank
    local touched = {}
    local function Touch(k) if weights[k] then touched[k] = true end end
    local function Mul(k, m) if weights[k] then weights[k] = weights[k] * m; touched[k] = true end end
    local function Add(k, v) if weights[k] then weights[k] = weights[k] + v; touched[k] = true end end

    -- Deep Wounds (Arms t3, minLevel 20, 3 ranks): the bleed is 0.2 x rank of
    -- average WEAPON damage (no AP), so crit gets x(1 + 0.12 x rank) at all
    -- levels (Agility's crit share follows) and weapon DPS x(1 + 0.013 x rank).
    -- Leveling rows only; 2H Fury shares the profile, so it is not baked in.
    local rDeepWounds = Rank("DEEP_WOUNDS")
    if rDeepWounds > 0 and isLeveling then
        Touch("ITEM_MOD_CRIT_RATING_SHORT")
        MSC.ScaleForeverMeleeCrit(weights, 1 + 0.12 * rDeepWounds, level)
        Mul("MSC_WEAPON_DPS_MELEE", 1 + 0.013 * rDeepWounds)
    end

    -- Impale (Arms t4, 2 ranks, Same as Classic): raises the crit bonus of
    -- yellow attacks only. Leveling: x(1 + c x rank), c = 0.025 at 25-37,
    -- 0.035 at 38-47, 0.04 at 48+ (Agility's crit share follows). Endgame
    -- specs keep the old +10%/rank on all abilities.
    local rImpale = Rank("IMPALE")
    if rImpale > 0 and weights["ITEM_MOD_CRIT_RATING_SHORT"] then
        Touch("ITEM_MOD_CRIT_RATING_SHORT")
        if isLeveling then
            local c = (level >= 48 and 0.04) or (level >= 38 and 0.035) or 0.025
            MSC.ScaleForeverMeleeCrit(weights, 1 + c * rImpale, level)
        else
            weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rImpale * 0.10))
        end
    end

    -- Bastion (New in Forever, Prot t5, 5 ranks): +2%/rank damage while a
    -- shield is equipped. Every Protection profile requires a shield, so it is
    -- applied unconditionally for PROT/Tank specs. A flat damage multiplier:
    -- the safety keys (Stamina, Armor, Block...) divide by it so the whole
    -- damage family rises together and the 2:1 Strength:AP ratio holds.
    local rBastion = Rank("BASTION")
    if rBastion > 0 and isTank then
        MSC.ApplyForeverDamageMult(weights, 1 + rBastion * 0.02)
    end

    -- Two-Handed Weapon Specialization (Changed from Classic, Arms t4, 3
    -- ranks): +1%/rank 2H melee damage, a flat multiplier -- only the pure 2H
    -- specs (not DW, not tank) apply.
    local rTwoH = Rank("TWOH_SPEC")
    if rTwoH > 0 and not isDW and not isTank then
        MSC.ApplyForeverDamageMult(weights, 1 + rTwoH * 0.01)
    end

    -- Mortal Strike speed gate (Arms t7, level 40, 1 rank): the 40-59 anchors
    -- assume Mortal Strike. Without it weapon speed is worth ~1/3 (Overpower +
    -- Slam 0.06/s against 0.18/s with MS). Leveling 2H rows only.
    local noMS2H = isLevelingTwoH and Rank("MORTAL_STRIKE") == 0
    if noMS2H and level >= 40 then
        Mul("MSC_WEAPON_SPEED", 0.33)
    end

    -- Speed hooks below only apply while Mortal Strike is missing (with it the
    -- anchors already cover them). D = typical 2H weapon DPS by level (0 below 25).
    if noMS2H and weights["MSC_WEAPON_SPEED"] then
        local D = 0
        if level >= 25 then
            D = MSC.ForeverLevelLerp({ {25, 19}, {30, 22.8}, {35, 27.3}, {39, 31.7} }, level)
        end

        -- Spearing Strike (Arms t4, level 25, 1 rank): 40% weapon damage about
        -- every 20 s, +0.22 x D.
        if Rank("SPEARING_STRIKE") > 0 then Add("MSC_WEAPON_SPEED", 0.22 * D) end

        -- Bloodthrill (Arms t5, level 30, 5 ranks): +4%/rank Overpower chance
        -- on hit, +0.09 x D per rank.
        local rBT = Rank("BLOODTHRILL")
        if rBT > 0 then Add("MSC_WEAPON_SPEED", 0.09 * D * rBT) end

        -- Improved Slam (Arms t6, level 35, 2 ranks): shorter Slam cooldown,
        -- +0.05 x D per rank.
        local rIS = Rank("IMP_SLAM")
        if rIS > 0 then Add("MSC_WEAPON_SPEED", 0.05 * D * rIS) end
    end

    -- Dual Wield Specialization (Fury t4, minLevel 25, 5 ranks): +5%/rank
    -- off-hand damage. Dual-wield leveling rows only.
    local rDWSpec = Rank("DW_SPEC")
    if rDWSpec > 0 and isLeveling and isDW then
        Mul("MSC_WEAPON_DPS_OH", 1 + 0.05 * rDWSpec)
    end

    -- Flurry (Fury t4, 5 ranks): the DW rows bake 5/5 as melee crit x1.25,
    -- ramped one rank per level from 35 to 40. Undo the baked part a player
    -- does not have (an Arms/Prot hybrid on the DW row, or 35-39 with fewer
    -- ranks). Scaling crit also moves Agility's crit share.
    local rFlurry = Rank("FLURRY")
    if isLeveling and isDW and level >= 36 and rFlurry < 5 then
        local baked = 1 + 0.05 * math.min(5, math.max(0, level - 35))
        MSC.ScaleForeverMeleeCrit(weights, (1 + 0.05 * rFlurry) / baked, level)
    end

    -- Raging Blows (Fury t4, level 25, 1 rank; effective from 36): Whirlwind
    -- strikes with the off-hand, so off-hand speed is worth something:
    -- 0 at 36, 3 at 40, 5.5 at 45-50, 6.5 at 59. DW leveling rows only.
    if Rank("RAGING_BLOWS") > 0 and isLeveling and isDW and level >= 36 and weights["MSC_OH_WEAPON_SPEED"] ~= nil then
        weights["MSC_OH_WEAPON_SPEED"] = MSC.ForeverLevelLerp({ {36, 0}, {40, 3}, {45, 5.5}, {50, 5.5}, {59, 6.5} }, level)
        touched["MSC_OH_WEAPON_SPEED"] = true
    end

    -- Shield Slam (Prot t7, level 40, 1 rank): each Block Value point adds 1
    -- damage to a Slam about every 7 s = +2.2 AP (Strength +0.11), and Slam
    -- is ~half of tank damage so crit and hit are worth x1.6 against AP.
    -- Leveling tank rows only (DEEP_PROT already bakes it in).
    if Rank("SHIELD_SLAM") > 0 and isLeveling and isTank then
        Add("ITEM_MOD_BLOCK_VALUE_SHORT", 2.2)
        Add("ITEM_MOD_STRENGTH_SHORT", 0.11)
        Touch("ITEM_MOD_CRIT_RATING_SHORT")
        MSC.ScaleForeverMeleeCrit(weights, 1.6, level)
        Mul("ITEM_MOD_HIT_RATING_SHORT", 1.6)
    end

    -- Keep talent-touched weights out of the (0, 0.02) "useless" band.
    for k in pairs(touched) do
        local v = weights[k]
        if v and v > 0 and v < 0.02 then weights[k] = 0 end
    end

    -- [[ 1. HIT CAP ]]
    -- Hit % comes from MSC:GetForeverHitPercent (gear rating + talents such
    -- as Precision, counted once); the target is the level's cap, sliding to
    -- the raid cap from 50 (MSC.ForeverCaps).
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        if currentSpec:find("DW") then
            -- Dual wield: past the yellow cap Hit keeps cutting white-swing
            -- misses (60% value) up to the DW white cap, then 5%
            MSC.ApplyForeverHitKnees(weights, "ITEM_MOD_HIT_RATING_SHORT", "MELEE", {
                { cap = MSC.GetForeverCapTarget("MELEE"), mult = 0.6 },
                { cap = MSC.GetForeverCapTarget("DW_WHITE"), mult = 0.05 },
            }, "Yellow Hit", activeCaps)
        else
            -- 2H/tank: single-wield white swings see no benefit past the yellow cap
            MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_RATING_SHORT", "MELEE", 0.1, "Yellow Hit", activeCaps)
        end
    end

    -- [[ 1b. TANK CAPS: defense toward 440, uncrushable (from 50) ]]
    if currentSpec:find("PROT") or currentSpec:find("Tank") then
        MSC.ApplyForeverDefenseTarget(weights, activeCaps)
        -- Shield Block (learned at 16): +75% block chance for 2 attacks
        MSC.ApplyForeverUncrushable(weights, 75, activeCaps)
        -- Tanks hold a shield, so an off-hand weapon's DPS is worth nothing
        -- (without this it counted at half the main-hand weight).
        weights["MSC_WEAPON_DPS_OH"] = 0
    end

    -- [[ 2. WEAPON SKILL CAP (Removed in Forever) ]]

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

-- Weaponmaster (New in Forever, Arms t5, 5 ranks): per-weapon-type bonus.
--   Axe/Polearm: +1%/rank Crit (same math as the racial weapon-crit bonuses).
--   Mace/Staff: 3%/rank armor ignored = rank x 0.011 x damage base.
--   Sword: rank x 0.007 x damage base (extra-attack proc chance).
-- Damage base is (AP + Battle Shout + 14 x weapon DPS) in AP equivalents; the
-- total-damage figure isn't available here, so it is approximated from the
-- item's own DPS and the player's current Attack Power (Battle Shout is part
-- of UnitAttackPower while active, so it is not added separately).
local function GetWeaponmasterBonus(itemLink, weights)
    local rWM = MSC:GetTalentRank("WEAPONMASTER")
    if rWM <= 0 or not itemLink or not weights then return 0 end

    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 or not subClassID then return 0 end

    if subClassID == 0 or subClassID == 1 or subClassID == 6 then -- Axes (0/1), Polearms (6)
        -- Crit weight is already "per 1%" (see MSC.GetForeverWeaponRacialBonus)
        return rWM * (weights["ITEM_MOD_CRIT_RATING_SHORT"] or 0) -- +1%/rank Crit
    end

    local perRank
    if subClassID == 4 or subClassID == 5 or subClassID == 10 then perRank = 0.011 -- Maces, Staves
    elseif subClassID == 7 or subClassID == 8 then perRank = 0.007 -- Swords
    else return 0 end

    local dps = 0
    local getStats = (C_Item and C_Item.GetItemStats) or GetItemStats
    if getStats then
        local stats = getStats(itemLink)
        dps = (stats and stats["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]) or 0
    end
    local ap = 0
    if UnitAttackPower then
        local base, pos, neg = UnitAttackPower("player")
        ap = (base or 0) + (pos or 0) + (neg or 0)
    end
    local apWeight = weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 1
    return rWM * perRank * (ap + 14 * dps) * apWeight
end

function Warrior:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink) + GetWeaponmasterBonus(itemLink, weights)
end

-- =============================================================
-- REGISTER
-- =============================================================
Warrior.Profiles = {}
for k, v in pairs(Warrior.Weights) do Warrior.Profiles[k] = v end
for k, v in pairs(Warrior.LevelingWeights) do Warrior.Profiles[k] = v end

MSC.RegisterModule("WARRIOR", Warrior)


