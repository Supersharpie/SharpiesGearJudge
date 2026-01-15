local addonName, MSC = ...

-- ============================================================================
-- 1. GLOBAL CONSTANTS & MAPS
-- ============================================================================
MSC.SlotMap = {
    ["INVTYPE_HEAD"]=1, ["INVTYPE_NECK"]=2, ["INVTYPE_SHOULDER"]=3, ["INVTYPE_BODY"]=4, 
    ["INVTYPE_CHEST"]=5, ["INVTYPE_ROBE"]=5, ["INVTYPE_WAIST"]=6, ["INVTYPE_LEGS"]=7, 
    ["INVTYPE_FEET"]=8, ["INVTYPE_WRIST"]=9, ["INVTYPE_HAND"]=10, ["INVTYPE_FINGER"]=11, 
    ["INVTYPE_TRINKET"]=13, ["INVTYPE_CLOAK"]=15, ["INVTYPE_WEAPON"]=16, ["INVTYPE_SHIELD"]=17, 
    ["INVTYPE_2HWEAPON"]=16, ["INVTYPE_WEAPONMAINHAND"]=16, ["INVTYPE_WEAPONOFFHAND"]=17, 
    ["INVTYPE_HOLDABLE"]=17, ["INVTYPE_RANGED"]=18, ["INVTYPE_THROWN"]=18, 
    ["INVTYPE_RANGEDRIGHT"]=18, ["INVTYPE_RELIC"]=18 
}

MSC.ShortNames = {
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = "Resilience",
    ["ITEM_MOD_HASTE_RATING_SHORT"]      = "Haste",
    ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= "Spell Haste",
    ["ITEM_MOD_EXPERTISE_RATING_SHORT"]  = "Expertise",
    ["ITEM_MOD_ARMOR_PENETRATION_SHORT"] = "Armor Pen",
    ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = "Armor Pen",
    ["ITEM_MOD_SPELL_PENETRATION_SHORT"] = "Spell Pen",
    ["ITEM_MOD_SPELL_PENETRATION_RATING_SHORT"] = "Spell Pen",
    ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]= "Feral AP",
    ["MSC_PVP_UTILITY"]                  = "PvP Utility",
    ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = "Expertise", 
    ["RESISTANCE0_NAME"]              = "Armor", 
    ["ITEM_MOD_ARMOR_SHORT"]          = "Armor",
    ["ITEM_MOD_AGILITY_SHORT"]        = "Agility",
    ["ITEM_MOD_STRENGTH_SHORT"]       = "Strength",
    ["ITEM_MOD_INTELLECT_SHORT"]      = "Intellect",
    ["ITEM_MOD_SPIRIT_SHORT"]         = "Spirit",
    ["ITEM_MOD_STAMINA_SHORT"]        = "Stamina",
    ["ITEM_MOD_HEALTH_SHORT"]         = "Health",
    ["ITEM_MOD_MANA_SHORT"]           = "Mana",
    ["ITEM_MOD_SPELL_POWER_SHORT"]    = "Spell Power",
    ["ITEM_MOD_HEALING_POWER_SHORT"]  = "Healing",
    ["ITEM_MOD_SPELL_HEALING_DONE"]   = "Healing", 
    ["ITEM_MOD_MANA_REGENERATION_SHORT"] = "Mp5",
    ["ITEM_MOD_POWER_REGEN0_SHORT"]   = "Mp5", 
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = "DPS",
    ["ITEM_MOD_ATTACK_POWER_SHORT"]      = "Attack Power",
    ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = "Ranged AP", 
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = "Feral AP",
    ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = "Hp5",
    ["ITEM_MOD_CRIT_RATING_SHORT"]       = "Crit",
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = "Spell Crit",
    ["ITEM_MOD_HIT_RATING_SHORT"]        = "Hit",
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]  = "Spell Hit",
    ["ITEM_MOD_CRIT_FROM_STATS_SHORT"]         = "Crit (from Agi)",
    ["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] = "Spell Crit (from Int)",
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = "Defense",
    ["ITEM_MOD_DODGE_RATING_SHORT"]      = "Dodge",
    ["ITEM_MOD_PARRY_RATING_SHORT"]      = "Parry",
    ["ITEM_MOD_BLOCK_RATING_SHORT"]      = "Block %",
    ["ITEM_MOD_BLOCK_VALUE_SHORT"]       = "Block Value",
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]     = "Shadow Dmg",
    ["ITEM_MOD_FIRE_DAMAGE_SHORT"]       = "Fire Dmg",
    ["ITEM_MOD_FROST_DAMAGE_SHORT"]      = "Frost Dmg",
    ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]     = "Arcane Dmg",
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"]     = "Nature Dmg",
    ["ITEM_MOD_HOLY_DAMAGE_SHORT"]       = "Holy Dmg",
    ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"] = "Shadow Res",
    ["ITEM_MOD_FIRE_RESISTANCE_SHORT"]   = "Fire Res",
    ["ITEM_MOD_FROST_RESISTANCE_SHORT"]  = "Frost Res",
    ["ITEM_MOD_NATURE_RESISTANCE_SHORT"] = "Nature Res",
    ["ITEM_MOD_ARCANE_RESISTANCE_SHORT"] = "Arcane Res",
    ["ITEM_MOD_ALL_RESISTANCE_SHORT"]    = "All Res",
    ["MSC_WEAPON_SPEED"]                 = "Speed",
    ["MSC_WEAPON_DPS"]                   = "Weapon DPS",
    ["MSC_WAND_DPS"]                     = "Wand DPS",
}

MSC.PrettyNames = {
   ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
}

-- =============================================================
-- TBC MANA REGEN FORMULA
-- =============================================================
MSC.BaseRegenTable = {
    [1]=0.034965, [2]=0.034191, [3]=0.033465, [4]=0.032526, [5]=0.031661,
    [6]=0.031076, [7]=0.030523, [8]=0.029994, [9]=0.029307, [10]=0.028661,
    [11]=0.027584, [12]=0.026215, [13]=0.025381, [14]=0.024300, [15]=0.023345,
    [16]=0.022748, [17]=0.021958, [18]=0.021386, [19]=0.020790, [20]=0.020121,
    [21]=0.019733, [22]=0.019155, [23]=0.018819, [24]=0.018316, [25]=0.017936,
    [26]=0.017576, [27]=0.017201, [28]=0.016919, [29]=0.016581, [30]=0.016233,
    [31]=0.015994, [32]=0.015707, [33]=0.015464, [34]=0.015204, [35]=0.014956,
    [36]=0.014744, [37]=0.014495, [38]=0.014302, [39]=0.014094, [40]=0.013895,
    [41]=0.013724, [42]=0.013522, [43]=0.013363, [44]=0.013175, [45]=0.012996,
    [46]=0.012853, [47]=0.012687, [48]=0.012539, [49]=0.012384, [50]=0.012233,
    [51]=0.012113, [52]=0.011973, [53]=0.011859, [54]=0.011714, [55]=0.011575,
    [56]=0.011473, [57]=0.011342, [58]=0.011245, [59]=0.011110, [60]=0.010999,
    [61]=0.010700, [62]=0.010522, [63]=0.010290, [64]=0.010119, [65]=0.009968,
    [66]=0.009808, [67]=0.009651, [68]=0.009553, [69]=0.009445, [70]=0.009327
}

-- ============================================================================
-- 2. ENCHANTS
-- ============================================================================
MSC.EnchantDB = {
    -- [[ WEAPON: TBC ENDGAME ]]
    [2673] = { name = "Mongoose", stats = { ITEM_MOD_AGILITY_SHORT = 120, ITEM_MOD_HASTE_RATING_SHORT = 30 } }, 
    [2674] = { name = "Sunfire", stats = { ITEM_MOD_SPELL_POWER_SHORT = 50, ITEM_MOD_ARCANE_DAMAGE_SHORT = 50 } },
    [2675] = { name = "Soulfrost", stats = { ITEM_MOD_SPELL_POWER_SHORT = 54, ITEM_MOD_FROST_DAMAGE_SHORT = 54 } },
    [3225] = { name = "Executioner", stats = { ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT = 120 } }, 
    [2669] = { name = "Major Spellpower", stats = { ITEM_MOD_SPELL_POWER_SHORT = 40 } },
    [2642] = { name = "Major Healing", stats = { ITEM_MOD_HEALING_POWER_SHORT = 81 } },
    [2671] = { name = "Sunfire (Healing)", stats = { ITEM_MOD_HEALING_POWER_SHORT = 50 } },
    [2666] = { name = "Major Intellect", stats = { ITEM_MOD_INTELLECT_SHORT = 30 } },
    [2667] = { name = "Savagery", stats = { ITEM_MOD_ATTACK_POWER_SHORT = 70 } }, 
    [2668] = { name = "Major Agility", stats = { ITEM_MOD_AGILITY_SHORT = 20 } },
    [3222] = { name = "Greater Agility (2H)", stats = { ITEM_MOD_AGILITY_SHORT = 35 }, requires2H = true }, 

    -- [[ WEAPON: CLASSIC / LEVELING ]]
    [2621] = { name = "Crusader", stats = { ITEM_MOD_STRENGTH_SHORT = 60 } }, 
    [803]  = { name = "Fiery Weapon", stats = { ITEM_MOD_FIRE_DAMAGE_SHORT = 4 } }, 
    [1897] = { name = "Weapon Dmg +5", stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } }, 
    [2504] = { name = "Spellpower +30", stats = { ITEM_MOD_SPELL_POWER_SHORT = 30 } },
    [2505] = { name = "Healing +55", stats = { ITEM_MOD_HEALING_POWER_SHORT = 55 } },
    [1900] = { name = "Unholy Weapon", stats = { ITEM_MOD_SHADOW_DAMAGE_SHORT = 4 } }, 
    [2563] = { name = "Major Strength (+15)", stats = { ITEM_MOD_STRENGTH_SHORT = 15 } },
    [1898] = { name = "Lifestealing", stats = { ITEM_MOD_SHADOW_DAMAGE_SHORT = 3 } },
    [943]  = { name = "Lesser Striking", stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1 } },
    [1894] = { name = "Icy Chill", stats = { ITEM_MOD_FROST_DAMAGE_SHORT = 4 } },
    [2564] = { name = "Agility +15", stats = { ITEM_MOD_AGILITY_SHORT = 15 } },

    -- [[ SCOPES ]]
    [23766] = { slot = 18, isScope = true, stats = {ITEM_MOD_CRIT_RATING_SHORT=14, ITEM_MOD_DAMAGE_PER_SECOND_SHORT=3}, name = "Adamantite Scope" }, 
    [23764] = { slot = 18, isScope = true, stats = {ITEM_MOD_DAMAGE_PER_SECOND_SHORT=3}, name = "Khorium Scope" }, 
    [10548] = { slot = 18, isScope = true, stats = {ITEM_MOD_DAMAGE_PER_SECOND_SHORT=2}, name = "Sniper Scope" }, 

    -- [[ SHIELD & SPIKES ]]
    [2655] = { name = "Major Stamina", slot = 17, isShield = true, stats = { ITEM_MOD_STAMINA_SHORT = 18 } },
    [2658] = { name = "Intellect", slot = 17, isShield = true, stats = { ITEM_MOD_INTELLECT_SHORT = 12 } },
    [2659] = { name = "Shield Block", slot = 17, isShield = true, stats = { ITEM_MOD_BLOCK_VALUE_SHORT = 15 } },
    [1071] = { name = "Lesser Stamina", slot = 17, isShield = true, stats = { ITEM_MOD_STAMINA_SHORT = 3 } }, 
    [2748] = { name = "Felsteel Shield Spike", slot = 17, isShield = true, stats = { ITEM_MOD_BLOCK_VALUE_SHORT = 32 } }, 
    [2747] = { name = "Thorium Shield Spike", slot = 17, isShield = true, stats = { ITEM_MOD_BLOCK_VALUE_SHORT = 25 } },

    -- [[ HEAD (Glyphs - TBC Only) ]]
    [3012] = { name = "Glyph of Power (Sha'tar)", slot = 1, stats = { ITEM_MOD_SPELL_POWER_SHORT = 22, ITEM_MOD_HIT_SPELL_RATING_SHORT = 14 } },
    [3010] = { name = "Glyph of Ferocity (Cenarion)", slot = 1, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 34, ITEM_MOD_HIT_RATING_SHORT = 16 } },
    [3013] = { name = "Glyph of the Defender (Keepers)", slot = 1, stats = { ITEM_MOD_DODGE_RATING_SHORT = 16, ITEM_MOD_BLOCK_VALUE_SHORT = 17 } },
    [3011] = { name = "Glyph of Renewal (Honor Hold)", slot = 1, stats = { ITEM_MOD_HEALING_POWER_SHORT = 35, ITEM_MOD_MANA_REGENERATION_SHORT = 7 } },
    [3003] = { name = "Glyph of the Gladiator", slot = 1, stats = { ITEM_MOD_STAMINA_SHORT = 18, ITEM_MOD_RESILIENCE_RATING_SHORT = 20 } },

    -- [[ SHOULDER (Inscriptions - TBC Only) ]]
    [3004] = { name = "Greater Inscription of the Orb", slot = 3, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15, ITEM_MOD_CRIT_RATING_SHORT = 12 } },
    [3007] = { name = "Greater Inscription of Vengeance", slot = 3, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30, ITEM_MOD_CRIT_RATING_SHORT = 10 } },
    [3009] = { name = "Greater Inscription of the Knight", slot = 3, stats = { ITEM_MOD_DODGE_RATING_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 15 } },
    [3005] = { name = "Greater Inscription of the Oracle", slot = 3, stats = { ITEM_MOD_HEALING_POWER_SHORT = 22, ITEM_MOD_MANA_REGENERATION_SHORT = 6 } },
    [2992] = { name = "Inscription of the Orb", slot = 3, stats = { ITEM_MOD_SPELL_POWER_SHORT = 12 } },
    [2998] = { name = "Inscription of Vengeance", slot = 3, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26 } },

    -- [[ BACK ]]
    [2653] = { name = "Greater Agility (+12)", slot = 15, stats = { ITEM_MOD_AGILITY_SHORT = 12 } },
    [2662] = { name = "Spell Penetration", slot = 15, stats = { ITEM_MOD_SPELL_PENETRATION_SHORT = 20 } },
    [3296] = { name = "Steelweave", slot = 15, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 12 } },
    [3294] = { name = "Major Armor", slot = 15, stats = { ITEM_MOD_ARMOR_SHORT = 120 } },
    [849]  = { name = "Lesser Agility (+3)", slot = 15, stats = { ITEM_MOD_AGILITY_SHORT = 3 } }, 
    [2502] = { name = "Greater Resistance", slot = 15, stats = { ITEM_MOD_RESISTANCE_ALL_SHORT = 5 } },
    [1889] = { name = "Superior Defense (+70)", slot = 15, stats = { ITEM_MOD_ARMOR_SHORT = 70 } },

    -- [[ CHEST ]]
    [2661] = { name = "Exceptional Stats (+6)", slot = 5, stats = { ITEM_MOD_AGILITY_SHORT=6, ITEM_MOD_STRENGTH_SHORT=6, ITEM_MOD_INTELLECT_SHORT=6, ITEM_MOD_STAMINA_SHORT=6 } },
    [2653] = { name = "Major Health (+150)", slot = 5, stats = { ITEM_MOD_HEALTH_SHORT = 150 } },
    [3297] = { name = "Major Resilience", slot = 5, stats = { ITEM_MOD_RESILIENCE_RATING_SHORT = 15 } },
    [2657] = { name = "Restore Mana Prime", slot = 5, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 6 } },
    [1891] = { name = "Greater Stats (+4)", slot = 5, stats = { ITEM_MOD_AGILITY_SHORT=4, ITEM_MOD_STRENGTH_SHORT=4, ITEM_MOD_INTELLECT_SHORT=4, ITEM_MOD_STAMINA_SHORT=4 } },
    [843]  = { name = "Minor Stats (+1)", slot = 5, stats = { ITEM_MOD_AGILITY_SHORT=1, ITEM_MOD_STRENGTH_SHORT=1, ITEM_MOD_INTELLECT_SHORT=1, ITEM_MOD_STAMINA_SHORT=1 } },
    [1892] = { name = "Major Health (+100)", slot = 5, stats = { ITEM_MOD_HEALTH_SHORT = 100 } },

    -- [[ WRIST ]]
    [2647] = { name = "Brawn (+12 Str)", slot = 9, stats = { ITEM_MOD_STRENGTH_SHORT = 12 } }, 
    [2650] = { name = "Spellpower (+15)", slot = 9, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15 } }, 
    [2651] = { name = "Major Healing (+30)", slot = 9, stats = { ITEM_MOD_HEALING_POWER_SHORT = 30 } }, 
    [2649] = { name = "Assault (+24 AP)", slot = 9, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 24 } }, 
    [2646] = { name = "Major Defense", slot = 9, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 12 } },
    [2655] = { name = "Fortitude (+12 Stam)", slot = 9, stats = { ITEM_MOD_STAMINA_SHORT = 12 } }, 
    [1883] = { name = "Intellect +7", slot = 9, stats = { ITEM_MOD_INTELLECT_SHORT = 7 } },
    [1884] = { name = "Spirit +9", slot = 9, stats = { ITEM_MOD_SPIRIT_SHORT = 9 } },
    [905]  = { name = "Minor Strength (+1)", slot = 9, stats = { ITEM_MOD_STRENGTH_SHORT = 1 } },
    [1885] = { name = "Superior Strength (+9)", slot = 9, stats = { ITEM_MOD_STRENGTH_SHORT = 9 } },

    -- [[ HANDS ]]
    [2562] = { name = "Superior Agility (+15)", slot = 10, stats = { ITEM_MOD_AGILITY_SHORT = 15 } }, 
    [2937] = { name = "Major Spellpower (+20)", slot = 10, stats = { ITEM_MOD_SPELL_POWER_SHORT = 20 } }, 
    [2935] = { name = "Major Healing (+35)", slot = 10, stats = { ITEM_MOD_HEALING_POWER_SHORT = 35 } }, 
    [2648] = { name = "Assault (+26 AP)", slot = 10, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26 } }, 
    [2613] = { name = "Threat (+Hit)", slot = 10, stats = { ITEM_MOD_HIT_RATING_SHORT = 10 } }, 
    [3246] = { name = "Blast (+Crit)", slot = 10, stats = { ITEM_MOD_SPELL_CRIT_RATING_SHORT = 10 } },
    [1886] = { name = "Agility +7", slot = 10, stats = { ITEM_MOD_AGILITY_SHORT = 7 } },
    [1888] = { name = "Greater Strength (+7)", slot = 10, stats = { ITEM_MOD_STRENGTH_SHORT = 7 } },

    -- [[ LEGS ]]
    [3154] = { name = "Runic Spellthread", slot = 7, stats = { ITEM_MOD_SPELL_POWER_SHORT = 35, ITEM_MOD_STAMINA_SHORT = 20 } },
    [3153] = { name = "Golden Spellthread", slot = 7, stats = { ITEM_MOD_HEALING_POWER_SHORT = 66, ITEM_MOD_STAMINA_SHORT = 20 } },
    [2953] = { name = "Nethercobra Leg Armor", slot = 7, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 50, ITEM_MOD_CRIT_RATING_SHORT = 12 } },
    [2952] = { name = "Nethercleft Leg Armor", slot = 7, stats = { ITEM_MOD_STAMINA_SHORT = 40, ITEM_MOD_AGILITY_SHORT = 12 } },
    [2741] = { name = "Cobrahide Leg Armor (Cheap)", slot = 7, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 40, ITEM_MOD_CRIT_RATING_SHORT = 10 } },
    [2427] = { name = "Mystic Spellthread (Cheap)", slot = 7, stats = { ITEM_MOD_SPELL_POWER_SHORT = 25, ITEM_MOD_STAMINA_SHORT = 15 } },
    [2743] = { name = "Clefthide Leg Armor (Cheap)", slot = 7, stats = { ITEM_MOD_STAMINA_SHORT = 30, ITEM_MOD_AGILITY_SHORT = 10 } },

    -- [[ FEET ]]
    [2939] = { name = "Boar's Speed", slot = 8, stats = { ITEM_MOD_STAMINA_SHORT = 9, MSC_SPEED_BONUS = 8 } },
    [2656] = { name = "Cat's Swiftness", slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 6, MSC_SPEED_BONUS = 8 } },
    [3232] = { name = "Surefooted", slot = 8, stats = { ITEM_MOD_HIT_RATING_SHORT = 10, ITEM_MOD_CRIT_RATING_SHORT = 5 } }, 
    [2564] = { name = "Agility +7", slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 7 } },
    [911]  = { name = "Minor Agility (+1)", slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 1 } },
    [910]  = { name = "Minor Speed", slot = 8, stats = { MSC_SPEED_BONUS = 8 } },

    -- [[ RINGS ]]
    [2931] = { name = "Spellpower", slot = 11, stats = { ITEM_MOD_SPELL_POWER_SHORT = 12 } }, 
    [2933] = { name = "Healing Power", slot = 11, stats = { ITEM_MOD_HEALING_POWER_SHORT = 20 } }, 
    [2934] = { name = "Stats", slot = 11, stats = { ITEM_MOD_AGILITY_SHORT=4, ITEM_MOD_STRENGTH_SHORT=4, ITEM_MOD_INTELLECT_SHORT=4, ITEM_MOD_STAMINA_SHORT=4 } }, 
    [2629] = { name = "Striking", slot = 11, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } },
}

MSC.EnchantCandidates = {
    [1] = { 3012, 3010, 3013, 3011, 3003 },
    [3] = { 3004, 3007, 3009, 3005, 2992, 2998 },
    [5] = { 2661, 2653, 3297, 2657, 1891, 843 },
    [7] = { 3154, 3153, 2953, 2952, 2427, 2741 },
    [8] = { 2939, 2656, 3232, 2564, 911 },
    [9] = { 2647, 2650, 2651, 2649, 2646, 2655, 1883, 1884, 905 },
    [10] = { 2562, 2937, 2935, 2648, 2613, 3246, 1886 },
    [11] = { 2931, 2933, 2934, 2629 },
    [12] = { 2931, 2933, 2934, 2629 },
    [15] = { 2653, 2662, 3296, 3294, 2502, 849 },
    [16] = { 2673, 2674, 2675, 3225, 2669, 2642, 2671, 2666, 2667, 2668, 3222, 2621, 1897, 803, 1900, 2563, 1898, 2504, 2505, 943 },
    [17] = { 2655, 2658, 2659, 1071, 2748, 2747, 2673, 2674, 2675, 3225, 2669, 2642, 2666, 2668, 2621, 803 },
    [18] = { 23766, 23764, 10548 } 
}

MSC.EnchantCandidates_Leveling = {
    [1] = {}, [3] = {}, 
    [5] = { 1891, 1892, 843, 2653 }, 
    [9] = { 2655, 1885, 1883, 1884, 905 }, 
    [10] = { 2562, 1886, 1888 }, 
    [6] = {},
    [7] = { 2741, 2743, 2427 }, 
    [8] = { 910, 2564, 911 }, 
    [15] = { 849, 1889 }, 
    [16] = { 2621, 803, 1900, 1898, 2504, 2505, 943, 1897, 2563, 1894, 2564 }, 
    [17] = { 2621, 803, 1900, 1898, 2655, 1071, 2747 }, 
    [11] = {}, [12] = {},
    [18] = { 10548 } 
}

-- ============================================================================
-- 3. GEM DATABASE (TBC RARE QUALITY)
-- ============================================================================

if MSC.IsTBC or MSC.IsWrath then
    local GEMS = {
    -- [[ 1. ENDGAME (RARE / BLUE QUALITY) ]]
    RED = {
        { id=24027, stat="ITEM_MOD_STRENGTH_SHORT", val=8, name="Bold Living Ruby", colorType="RED" },
        { id=24028, stat="ITEM_MOD_AGILITY_SHORT", val=8, name="Delicate Living Ruby", colorType="RED" },
        { id=24030, stat="ITEM_MOD_SPELL_POWER_SHORT", val=9, name="Runed Living Ruby", colorType="RED" },
        { id=24031, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=16, name="Bright Living Ruby", colorType="RED" },
        { id=24032, stat="ITEM_MOD_DODGE_RATING_SHORT", val=8, name="Subtle Living Ruby", colorType="RED" },
        { id=24033, stat="ITEM_MOD_PARRY_RATING_SHORT", val=8, name="Flashing Living Ruby", colorType="RED" },
        { id=24035, stat="ITEM_MOD_HEALING_POWER_SHORT", val=18, name="Teardrop Living Ruby", colorType="RED" },
    },
    BLUE = {
        { id=24053, stat="ITEM_MOD_STAMINA_SHORT", val=12, name="Solid Star of Elune", colorType="BLUE" }, 
        { id=24054, stat="ITEM_MOD_SPIRIT_SHORT", val=8, name="Sparkling Star of Elune", colorType="BLUE" },
        { id=24056, stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=3, name="Lustrous Star of Elune", colorType="BLUE" },
        { id=24057, stat="ITEM_MOD_SPELL_PENETRATION_SHORT", val=10, name="Stormy Star of Elune", colorType="BLUE" },
    },
    YELLOW = {
        { id=24047, stat="ITEM_MOD_HIT_RATING_SHORT", val=8, name="Rigid Dawnstone", colorType="YELLOW" },
        { id=24048, stat="ITEM_MOD_CRIT_RATING_SHORT", val=8, name="Smooth Dawnstone", colorType="YELLOW" },
        { id=24050, stat="ITEM_MOD_INTELLECT_SHORT", val=8, name="Brilliant Dawnstone", colorType="YELLOW" },
        { id=24051, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=8, name="Thick Dawnstone", colorType="YELLOW" },
        { id=24052, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=8, name="Mystic Dawnstone", colorType="YELLOW" },
        { id=24053, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=8, name="Gleaming Dawnstone", colorType="YELLOW" },
        { id=24061, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=8, name="Great Dawnstone", colorType="YELLOW" },
    },
    ORANGE = {
        { id=24058, stat="ITEM_MOD_STRENGTH_SHORT", val=4, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=4, name="Inscribed Noble Topaz", colorType="ORANGE" },
        { id=24060, stat="ITEM_MOD_STRENGTH_SHORT", val=4, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=4, name="Etched Noble Topaz", colorType="ORANGE" },
        { id=24059, stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val2=4, name="Potent Noble Topaz", colorType="ORANGE" },
        { id=24062, stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, stat2="ITEM_MOD_HIT_SPELL_RATING_SHORT", val2=4, name="Veiled Noble Topaz", colorType="ORANGE" },
        { id=24061, stat="ITEM_MOD_AGILITY_SHORT", val=4, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=4, name="Glinting Noble Topaz", colorType="ORANGE" },
        { id=24065, stat="ITEM_MOD_HEALING_POWER_SHORT", val=9, stat2="ITEM_MOD_INTELLECT_SHORT", val2=4, name="Luminous Noble Topaz", colorType="ORANGE" },
    },
    PURPLE = {
        { id=24063, stat="ITEM_MOD_STRENGTH_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Sovereign Nightseye", colorType="PURPLE" },
        { id=24064, stat="ITEM_MOD_AGILITY_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Shifting Nightseye", colorType="PURPLE" },
        { id=24065, stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Glowing Nightseye", colorType="PURPLE" },
        { id=24066, stat="ITEM_MOD_HEALING_POWER_SHORT", val=9, stat2="ITEM_MOD_SPIRIT_SHORT", val2=4, name="Purified Nightseye", colorType="PURPLE" },
        { id=24067, stat="ITEM_MOD_HEALING_POWER_SHORT", val=9, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Royal Nightseye", colorType="PURPLE" },
        { id=24068, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=8, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Balanced Nightseye", colorType="PURPLE" },
    },
    GREEN = {
        { id=24069, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Enduring Talasite", colorType="GREEN" },
        { id=24070, stat="ITEM_MOD_INTELLECT_SHORT", val=4, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Dazzling Talasite", colorType="GREEN" },
        { id=24071, stat="ITEM_MOD_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Jagged Talasite", colorType="GREEN" },
        { id=24072, stat="ITEM_MOD_HIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Vivid Talasite", colorType="GREEN" },
    },
    
    -- [[ 2. LEVELING (UNCOMMON / GREEN QUALITY) ]]
    LEVELING_RED = {
        { id=23095, stat="ITEM_MOD_STRENGTH_SHORT", val=6, name="Bold Blood Garnet", colorType="RED" },
        { id=23096, stat="ITEM_MOD_AGILITY_SHORT", val=6, name="Delicate Blood Garnet", colorType="RED" },
        { id=23097, stat="ITEM_MOD_SPELL_POWER_SHORT", val=7, name="Runed Blood Garnet", colorType="RED" },
        { id=23098, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=12, name="Bright Blood Garnet", colorType="RED" },
        { id=23101, stat="ITEM_MOD_HEALING_POWER_SHORT", val=14, name="Teardrop Blood Garnet", colorType="RED" },
    },
    LEVELING_BLUE = {
        { id=23114, stat="ITEM_MOD_STAMINA_SHORT", val=9, name="Solid Azure Moonstone", colorType="BLUE" },
        { id=23115, stat="ITEM_MOD_SPIRIT_SHORT", val=6, name="Sparkling Azure Moonstone", colorType="BLUE" },
        { id=23116, stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=2, name="Lustrous Azure Moonstone", colorType="BLUE" },
    },
    LEVELING_YELLOW = {
        { id=23103, stat="ITEM_MOD_HIT_RATING_SHORT", val=6, name="Rigid Golden Draenite", colorType="YELLOW" },
        { id=23104, stat="ITEM_MOD_CRIT_RATING_SHORT", val=6, name="Smooth Golden Draenite", colorType="YELLOW" },
        { id=23105, stat="ITEM_MOD_INTELLECT_SHORT", val=6, name="Brilliant Golden Draenite", colorType="YELLOW" },
        { id=23106, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=6, name="Thick Golden Draenite", colorType="YELLOW" },
        { id=23112, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=6, name="Great Golden Draenite", colorType="YELLOW" },
    },
    
    META = {
        { id=32409, stat="ITEM_MOD_AGILITY_SHORT", val=12, name="Relentless Earthstorm", isMeta=true, colorType="META" }, 
        { id=34220, stat="ITEM_MOD_CRIT_RATING_SHORT", val=12, name="Chaotic Skyfire", isMeta=true, colorType="META" }, 
        { id=25893, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=0, name="Mystical Skyfire", isMeta=true, colorType="META" }, 
        { id=25896, stat="ITEM_MOD_STAMINA_SHORT", val=18, name="Powerful Earthstorm", isMeta=true, colorType="META" }, 
        { id=25899, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=24, name="Brutal Earthstorm", isMeta=true, colorType="META" }, 
        { id=25901, stat="ITEM_MOD_INTELLECT_SHORT", val=12, name="Insightful Earthstorm", isMeta=true, colorType="META" }, 
        { id=25890, stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=3, name="Destructive Skyfire", isMeta=true, colorType="META" }, 
        { id=25894, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=12, name="Swift Starfire", isMeta=true, colorType="META" }, 
    }
}

    -- [[ CONSTRUCT OPTIONS PROGRAMMATICALLY (TBC ONLY) ]]
    MSC.GemOptions = {
        EMPTY_SOCKET_RED = {},
        EMPTY_SOCKET_YELLOW = {},
        EMPTY_SOCKET_BLUE = {},
        EMPTY_SOCKET_META = GEMS.META,
        PRISMATIC_GEMS = {} 
    }

    MSC.GemOptions_Leveling = {
        EMPTY_SOCKET_RED = {},
        EMPTY_SOCKET_YELLOW = {},
        EMPTY_SOCKET_BLUE = {},
        EMPTY_SOCKET_META = GEMS.META, 
        PRISMATIC_GEMS = {} 
    }

    local function AddTo(targetList, sourceList)
        for _, gem in ipairs(sourceList) do table.insert(targetList, gem) end
    end

    -- POPULATE ENDGAME (Blue Gems)
    AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.RED)
    AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.ORANGE)
    AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.PURPLE)

    AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.YELLOW)
    AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.ORANGE)
    AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.GREEN)

    AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.BLUE)
    AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.PURPLE)
    AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.GREEN)

    -- POPULATE LEVELING (Green Gems)
    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_RED, GEMS.LEVELING_RED)
    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_YELLOW, GEMS.LEVELING_YELLOW)
    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_BLUE, GEMS.LEVELING_BLUE)

    -- Prismatic Lists
    AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.RED)
    AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.BLUE)
    AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.YELLOW)

    AddTo(MSC.GemOptions_Leveling.PRISMATIC_GEMS, GEMS.LEVELING_RED)
    AddTo(MSC.GemOptions_Leveling.PRISMATIC_GEMS, GEMS.LEVELING_BLUE)
    AddTo(MSC.GemOptions_Leveling.PRISMATIC_GEMS, GEMS.LEVELING_YELLOW)

else
    -- [[ VANILLA FALLBACK (Empty Tables) ]]
    MSC.GemOptions = {
        EMPTY_SOCKET_RED = {}, EMPTY_SOCKET_YELLOW = {}, EMPTY_SOCKET_BLUE = {},
        EMPTY_SOCKET_META = {}, PRISMATIC_GEMS = {}
    }
    MSC.GemOptions_Leveling = {
        EMPTY_SOCKET_RED = {}, EMPTY_SOCKET_YELLOW = {}, EMPTY_SOCKET_BLUE = {},
        EMPTY_SOCKET_META = {}, PRISMATIC_GEMS = {}
    }
end

-- ============================================================================
-- 4. ITEM OVERRIDES (Manual Stats for "Use" & "Proc" Items)
-- ============================================================================
MSC.ItemOverrides = {
    -- [[ GLOBAL TRINKETS (Classic / Leveling) ]]
    [11811] = { ITEM_MOD_SPELL_POWER_SHORT = 12, ITEM_MOD_INTELLECT_SHORT = 5, estimate = true },
    [11815] = { ITEM_MOD_ATTACK_POWER_SHORT = 22, estimate = true }, 
    [28528] = { ITEM_MOD_DODGE_RATING_SHORT = 63 },
    [27529] = { ITEM_MOD_BLOCK_RATING_SHORT = 32, ITEM_MOD_STAMINA_SHORT = 20 },
    [30300] = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 30, ITEM_MOD_BLOCK_RATING_SHORT = 21 },
    
    -- [[ DARKMOON CARDS ]]
    [31856] = { ITEM_MOD_STAMINA_SHORT = 51, ITEM_MOD_ATTACK_POWER_SHORT = 70, estimate = true },
    [31858] = { ITEM_MOD_STAMINA_SHORT = 51, ITEM_MOD_STRENGTH_SHORT = 25, estimate = true },

    -- [[ WEAPONS ]]
    [11684] = { ITEM_MOD_ATTACK_POWER_SHORT = 30, estimate = true },
    
    -- [[ TBC PHASE 1 ]]
    [29383] = { ITEM_MOD_ATTACK_POWER_SHORT = 46, estimate = true },
    [28288] = { ITEM_MOD_HASTE_RATING_SHORT = 21, estimate = true },
    [28034] = { ITEM_MOD_ATTACK_POWER_SHORT = 60, estimate = true },
    [28830] = { ITEM_MOD_HASTE_RATING_SHORT = 45, estimate = true },
    [28579] = { ITEM_MOD_ATTACK_POWER_SHORT = 65, estimate = true },
    [28041] = { ITEM_MOD_ATTACK_POWER_SHORT = 33, estimate = true },
    [25844] = { ITEM_MOD_CRIT_RATING_SHORT = 22, estimate = true },
    [32780] = { ITEM_MOD_ATTACK_POWER_SHORT = 32, estimate = true },
    [29370] = { ITEM_MOD_SPELL_POWER_SHORT = 26, estimate = true },
    [27683] = { ITEM_MOD_HASTE_RATING_SHORT = 35, estimate = true },
    [29132] = { ITEM_MOD_SPELL_POWER_SHORT = 25, estimate = true },
    [29179] = { ITEM_MOD_SPELL_POWER_SHORT = 25, estimate = true },
    [28785] = { ITEM_MOD_SPELL_POWER_SHORT = 45, estimate = true },
    [28418] = { ITEM_MOD_SPELL_POWER_SHORT = 40, estimate = true },
    [28789] = { ITEM_MOD_SPELL_POWER_SHORT = 20, estimate = true },

    -- [[ TBC PHASE 2 ]]
    [30627] = { ITEM_MOD_ATTACK_POWER_SHORT = 60, estimate = true },
    [32483] = { ITEM_MOD_HASTE_RATING_SHORT = 29, estimate = true },
    [30626] = { ITEM_MOD_SPELL_POWER_SHORT = 40, estimate = true },
    [30621] = { ITEM_MOD_ATTACK_POWER_SHORT = 53, estimate = true },
    [30450] = { ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT = 200, estimate = true },
    [30665] = { ITEM_MOD_SPELL_POWER_SHORT = 48, estimate = true },
    [30448] = { ITEM_MOD_SPELL_POWER_SHORT = 30, estimate = true },
    [30446] = { ITEM_MOD_ATTACK_POWER_SHORT = 70, estimate = true },
    [29376] = { ITEM_MOD_HEALING_SHORT = 50, estimate = true },
    [30841] = { ITEM_MOD_HEALING_SHORT = 55, estimate = true },
    [28590] = { ITEM_MOD_HEALING_SHORT = 9, estimate = true },
    [28370] = { ITEM_MOD_MANA_REGENERATION_SHORT = 45, estimate = true },
    [28727] = { ITEM_MOD_MANA_REGENERATION_SHORT = 41, estimate = true },
    [29387] = { ITEM_MOD_BLOCK_VALUE_SHORT = 10, estimate = true },
    [27928] = { ITEM_MOD_BLOCK_RATING_SHORT = 21, estimate = true },
    [27922] = { ITEM_MOD_STAMINA_SHORT = 15, estimate = true },
    [28438] = { ITEM_MOD_HASTE_RATING_SHORT = 25, estimate = true }, 
    [28439] = { ITEM_MOD_HASTE_RATING_SHORT = 40, estimate = true }, 
    [28441] = { ITEM_MOD_CRIT_RATING_SHORT = 30, estimate = true }, 
    [28442] = { ITEM_MOD_CRIT_RATING_SHORT = 45, estimate = true }, 
    [29993] = { ITEM_MOD_ATTACK_POWER_SHORT = 40, estimate = true },

    -- [[ TBC PHASE 3 ]]
    [32505] = { ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT = 60, estimate = true },
    [32492] = { ITEM_MOD_ATTACK_POWER_SHORT = 200, estimate = true },
    [32485] = { ITEM_MOD_ATTACK_POWER_SHORT = 55, estimate = true },
    [32491] = { ITEM_MOD_ATTACK_POWER_SHORT = 80, ITEM_MOD_SPELL_POWER_SHORT = 40, estimate = true },
    [32488] = { ITEM_MOD_HASTE_RATING_SHORT = 40, estimate = true },
    [32490] = { ITEM_MOD_SPELL_POWER_SHORT = 45, ITEM_MOD_HEALING_SHORT = 45, estimate = true },
    [32486] = { ITEM_MOD_STRENGTH_SHORT = 40, ITEM_MOD_SPELL_POWER_SHORT = 40, ITEM_MOD_HEALING_SHORT = 40, estimate = true },
    [32496] = { ITEM_MOD_MANA_REGENERATION_SHORT = 45, estimate = true },
    [32501] = { ITEM_MOD_STAMINA_SHORT = 29, estimate = true },
    [32500] = { ITEM_MOD_DODGE_RATING_SHORT = 25, estimate = true },

    -- [[ TBC PHASE 4 ]]
    [33830] = { ITEM_MOD_ATTACK_POWER_SHORT = 60, estimate = true },
    [33829] = { ITEM_MOD_SPELL_POWER_SHORT = 35, estimate = true },
    [33831] = { ITEM_MOD_ARMOR_SHORT = 333, estimate = true },
    [33828] = { ITEM_MOD_HEALING_SHORT = 49, estimate = true },

    -- [[ TBC PHASE 5 ]]
    [34427] = { ITEM_MOD_ATTACK_POWER_SHORT = 130, estimate = true },
    [34472] = { ITEM_MOD_ATTACK_POWER_SHORT = 100, estimate = true },
    [35702] = { ITEM_MOD_ATTACK_POWER_SHORT = 53, estimate = true },
    [34678] = { ITEM_MOD_ATTACK_POWER_SHORT = 35, estimate = true },
    [34679] = { ITEM_MOD_ATTACK_POWER_SHORT = 35, estimate = true },
    [34470] = { ITEM_MOD_SPELL_POWER_SHORT = 45, estimate = true },
    [34429] = { ITEM_MOD_SPELL_POWER_SHORT = 53, estimate = true },
    [34664] = { ITEM_MOD_SPELL_POWER_SHORT = 20, estimate = true },
    [34471] = { ITEM_MOD_HEALING_SHORT = 70, estimate = true },
    [35703] = { ITEM_MOD_MANA_REGENERATION_SHORT = 55, estimate = true },
    [34473] = { ITEM_MOD_DODGE_RATING_SHORT = 25, estimate = true },
    [35700] = { ITEM_MOD_STAMINA_SHORT = 29, estimate = true },

    -- [[ PVP UTILITY ]]
    [18854] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18856] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18849] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18851] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18852] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18853] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18850] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18846] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18834] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18845] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18841] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18839] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18832] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18835] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18837] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [18838] = { MSC_PVP_UTILITY = 60, estimate = true }, 
    [28234] = { MSC_PVP_UTILITY = 80, estimate = true }, 
    [28235] = { MSC_PVP_UTILITY = 80, estimate = true }, 
    [37864] = { MSC_PVP_UTILITY = 100, estimate = true }, 
    [37865] = { MSC_PVP_UTILITY = 100, estimate = true }, 
}

-- ============================================================================
-- 5. INITIALIZATION STRUCTURE
-- ============================================================================
-- We define these here, but they are used by the Data_Sets file
MSC.ItemSetMap = {} 
MSC.RawSetData = {}

function MSC:BuildDatabase()
    for setID, data in pairs(MSC.RawSetData) do
        local itemIDs = data[1] or data 
        if type(itemIDs) == "table" then
            for _, itemID in ipairs(itemIDs) do
                MSC.ItemSetMap[itemID] = setID
            end
        end
    end
end

function MSC:GetSetBonusDefinition(setID, count)
    if MSC.SetBonusScores[setID] and MSC.SetBonusScores[setID][count] then
        return MSC.SetBonusScores[setID][count]
    end
    return nil
end