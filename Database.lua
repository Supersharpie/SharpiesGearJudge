local _, MSC = ...

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
    ["ITEM_MOD_CRIT_FROM_STATS_SHORT"]        = "Crit (from Agi)",
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

    -- [[ WEAPON: CLASSIC / LEVELING (Cheap) ]]
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
    [1] = {}, [3] = {}, -- No low level head/shoulder enchants
    [5] = { 1891, 1892, 843, 2653 }, -- Greater Stats +4, Major Health, Minor Stats
    [9] = { 2655, 1885, 1883, 1884, 905 }, -- Fortitude, Superior Str, Int, Spirit
    [10] = { 2562, 1886, 1888 }, -- Agi +15, Agi +7, Str +7
    [6] = {},
    [7] = { 2741, 2743, 2427 }, -- Cobrahide, Clefthide (Req Lvl 60, good for Outland leveling)
    [8] = { 910, 2564, 911 }, -- Minor Speed, Agi +7
    [15] = { 849, 1889 }, -- Lesser Agi, Armor
    [16] = { 2621, 803, 1900, 1898, 2504, 2505, 943, 1897, 2563, 1894, 2564 }, -- Crusader, Fiery, etc
    [17] = { 2621, 803, 1900, 1898, 2655, 1071, 2747 }, -- Shield: Crusader (rare), Spikes
    [11] = {}, [12] = {},
    [18] = { 10548 } -- Sniper Scope
}
-- ============================================================================
-- 3. GEM DATABASE (TBC RARE QUALITY)
-- ============================================================================
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
    -- Leveling Hybrid gems omitted for brevity, usually Primary colors are prioritized during leveling
    
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

-- [[ CONSTRUCT OPTIONS PROGRAMMATICALLY ]]
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
    EMPTY_SOCKET_META = GEMS.META, -- Still use meta gems for leveling helms
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

-- POPULATE LEVELING (Green Gems - Simplified logic for leveling)
-- We allow Primary colors to fit their slots, and we allow them to cross-fit if user is "Casual"
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

-- ============================================================================
-- 4. ITEM OVERRIDES (Manual Stats for "Use" & "Proc" Items)
-- These are GLOBAL items (Trinkets, Weapons, PvP). 
-- Class-specific Relics (Librams/Totems) live in their own Class.lua files.
-- ============================================================================
MSC.ItemOverrides = {
    -- [[ GLOBAL TRINKETS (Classic / Leveling) ]]
    -- Burst of Knowledge (Mana Cost Reduction -> Int/SP value)
    [11811] = { ITEM_MOD_SPELL_POWER_SHORT = 12, ITEM_MOD_INTELLECT_SHORT = 5, estimate = true },

    -- Hand of Justice (Chance on hit: Extra Attack). 
    -- Value depends on swing timer, but ~22 AP is a fair static average.
    [11815] = { ITEM_MOD_ATTACK_POWER_SHORT = 22, estimate = true }, 

    -- Moroes' Lucky Pocket Watch (38 Dodge + 300 Dodge Use @ 8% uptime)
    [28528] = { ITEM_MOD_DODGE_RATING_SHORT = 63 },

    -- Figurine of the Colossus (Parser often misses "Shield Block Rating")
    [27529] = { ITEM_MOD_BLOCK_RATING_SHORT = 32, ITEM_MOD_STAMINA_SHORT = 20 },

    -- Dabiri's Enigma (30 Def + 125 Block Use @ 16% uptime)
    [30300] = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 30, ITEM_MOD_BLOCK_RATING_SHORT = 21 },
    
    -- [[ DARKMOON CARDS ]]
    -- Darkmoon Card: Madness (51 Stam + Random Buffs)
    [31856] = { ITEM_MOD_STAMINA_SHORT = 51, ITEM_MOD_ATTACK_POWER_SHORT = 70, estimate = true },

    -- Darkmoon Card: Vengeance (51 Stam + 10% chance for Holy Dmg)
    -- FIX: Mapped to STRENGTH (Safe) instead of SP. Warriors/Tanks love Strength.
    [31858] = { ITEM_MOD_STAMINA_SHORT = 51, ITEM_MOD_STRENGTH_SHORT = 25, estimate = true },

    -- [[ WEAPONS ]]
    -- Ironfoe (Chance on hit: Extra Attacks). 
    [11684] = { ITEM_MOD_ATTACK_POWER_SHORT = 30, estimate = true },
    
    -- [[ TBC PHASE 1: PHYSICAL DPS ]]
    -- Bloodlust Brooch (Use: 278 AP for 20s, 2m CD) -> ~46 AP
    [29383] = { ITEM_MOD_ATTACK_POWER_SHORT = 46, estimate = true },

    -- Abacus of Violent Odds (Use: 260 Haste for 10s, 2m CD) -> ~21 Haste
    [28288] = { ITEM_MOD_HASTE_RATING_SHORT = 21, estimate = true },

    -- Hourglass of the Unraveller (Proc: 300 AP for 10s, ~50s uptime) -> ~60 AP
    [28034] = { ITEM_MOD_ATTACK_POWER_SHORT = 60, estimate = true },

    -- Dragonspine Trophy (Proc: 325 Haste for 10s) -> ~45 Haste
    [28830] = { ITEM_MOD_HASTE_RATING_SHORT = 45, estimate = true },

    -- Romulo's Poison Vial (Proc: Arcane DMG) 
    -- FIX: Mapped to AP (Safe) instead of Hit. (35 Hit * 1.8 = ~65 AP)
    [28579] = { ITEM_MOD_ATTACK_POWER_SHORT = 65, estimate = true },

    -- Bladefist's Breadth (Use: 200 AP for 15s, 90s CD) -> ~33 AP
    [28041] = { ITEM_MOD_ATTACK_POWER_SHORT = 33, estimate = true },

    -- Terokkar Tablet of Precision (Use: 85 Hit)
    -- FIX: Mapped to CRIT (Safe). Temporary Hit rating should not count toward cap.
    [25844] = { ITEM_MOD_CRIT_RATING_SHORT = 22, estimate = true },

    -- Starkiller's Bauble (Use: 260 AP for 15s, 2m CD) -> ~32 AP
    [32780] = { ITEM_MOD_ATTACK_POWER_SHORT = 32, estimate = true },

    -- [[ TBC PHASE 1: CASTER DPS ]]
    -- Icon of the Silver Crescent (Use: 155 SP for 20s, 2m CD) -> ~26 SP
    [29370] = { ITEM_MOD_SPELL_POWER_SHORT = 26, estimate = true },

    -- Quagmirran's Eye (Proc: 320 Haste for 6s) -> ~35 Haste
    [27683] = { ITEM_MOD_HASTE_RATING_SHORT = 35, estimate = true },

    -- Scryer's Bloodgem (Use: 150 SP for 15s, 90s CD) -> ~25 SP
    [29132] = { ITEM_MOD_SPELL_POWER_SHORT = 25, estimate = true },

    -- Xiri's Gift (Use: 150 SP for 15s, 90s CD) -> ~25 SP
    [29179] = { ITEM_MOD_SPELL_POWER_SHORT = 25, estimate = true },

    -- Lightning Capacitor (Proc: Bolt) -> ~45 SP (Simulated equivalence)
    [28785] = { ITEM_MOD_SPELL_POWER_SHORT = 45, estimate = true },

    -- Shiffar's Nexus-Horn (Proc: 225 SP for 10s) -> ~40 Spell Power
    [28418] = { ITEM_MOD_SPELL_POWER_SHORT = 40, estimate = true },

    -- Eye of Magtheridon (Proc: 170 SP on Resist) -> ~20 SP (Low uptime)
    [28789] = { ITEM_MOD_SPELL_POWER_SHORT = 20, estimate = true },

    -- [[ TBC PHASE 2: TIER 5 TRINKETS ]]
    -- Tsunami Talisman (Proc: 340 AP for 10s) -> ~60 AP
    [30627] = { ITEM_MOD_ATTACK_POWER_SHORT = 60, estimate = true },

    -- The Skull of Gul'dan (Use: 175 Haste for 20s, 2m CD) -> ~29 Haste
    [32483] = { ITEM_MOD_HASTE_RATING_SHORT = 29, estimate = true },

    -- Sextant of Unstable Currents (Proc: 190 SP for 15s) -> ~40 SP
    [30626] = { ITEM_MOD_SPELL_POWER_SHORT = 40, estimate = true },
    
    -- Spyglass of the Hidden Fleet (Use: 320 AP for 20s) -> ~53 AP
    [30621] = { ITEM_MOD_ATTACK_POWER_SHORT = 53, estimate = true },

    -- Warp-Spring Coil (Proc: 1000 Armor Pen) -> ~200 ArP Rating
    [30450] = { ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT = 200, estimate = true },

    -- Tome of Fiery Redemption (Use: 290 SP) -> ~48 SP
    [30665] = { ITEM_MOD_SPELL_POWER_SHORT = 48, estimate = true },

    -- Void Star Talisman (Pet Buffs) -> ~30 SP
    [30448] = { ITEM_MOD_SPELL_POWER_SHORT = 30, estimate = true },

    -- Solarian's Sapphire (Party Buff) -> ~70 AP
    [30446] = { ITEM_MOD_ATTACK_POWER_SHORT = 70, estimate = true },

    -- [[ TBC HEALER TRINKETS ]]
    -- Essence of the Martyr (Use: 297 Heal) -> ~50 Heal
    [29376] = { ITEM_MOD_HEALING_SHORT = 50, estimate = true },

    -- Lower City Prayerbook (Use: 220 Heal) -> ~55 Heal
    [30841] = { ITEM_MOD_HEALING_SHORT = 55, estimate = true },

    -- Ribbon of Sacrifice (Use: 73 Heal) -> ~9 Heal
    [28590] = { ITEM_MOD_HEALING_SHORT = 9, estimate = true },

    -- Bangle of Endless Blessings (Proc: Mana Regen) -> ~45 Mp5
    [28370] = { ITEM_MOD_MANA_REGENERATION_SHORT = 45, estimate = true },
    
    -- Pendant of the Violet Eye (Use: 1000 Mana) -> ~41 Mp5
    [28727] = { ITEM_MOD_MANA_REGENERATION_SHORT = 41, estimate = true },

    -- [[ TANKING UTILITY ]]
    -- Gnomeregan Auto-Blocker 600 (Use: 59 BV) -> ~10 BV
    [29387] = { ITEM_MOD_BLOCK_VALUE_SHORT = 10, estimate = true },

    -- Mark of Defiance (Use: 128 Block Rating) -> ~21 Block Rating
    [27928] = { ITEM_MOD_BLOCK_RATING_SHORT = 21, estimate = true },
    
    -- Argussian Compass (Use: Absorb) -> ~15 Stamina
    [27922] = { ITEM_MOD_STAMINA_SHORT = 15, estimate = true },

    -- [[ WEAPON PROCS ]]
    -- Dragonmaw / Dragonstrike (Proc: Haste)
    [28438] = { ITEM_MOD_HASTE_RATING_SHORT = 25, estimate = true }, 
    [28439] = { ITEM_MOD_HASTE_RATING_SHORT = 40, estimate = true }, 

    -- Deep Thunder / Stormherald (Proc: Stun) -> PvP Value
    [28441] = { ITEM_MOD_CRIT_RATING_SHORT = 30, estimate = true }, 
    [28442] = { ITEM_MOD_CRIT_RATING_SHORT = 45, estimate = true }, 

    -- Twinblade of the Phoenix (Proc: AP) -> ~40 AP
    [29993] = { ITEM_MOD_ATTACK_POWER_SHORT = 40, estimate = true },

    -- [[ TBC PHASE 3: BT / HYJAL ]]
    -- Madness of the Betrayer (Proc: 300 ArP) -> ~60 ArP
    [32505] = { ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT = 60, estimate = true },

    -- Ashtongue Talisman of Lethality (Rogue)
    [32492] = { ITEM_MOD_ATTACK_POWER_SHORT = 200, estimate = true },

    -- Ashtongue Talisman of Valor (Warrior)
    [32485] = { ITEM_MOD_ATTACK_POWER_SHORT = 55, estimate = true },

    -- Ashtongue Talisman of Vision (Shaman)
    [32491] = { ITEM_MOD_ATTACK_POWER_SHORT = 80, ITEM_MOD_SPELL_POWER_SHORT = 40, estimate = true },

    -- Ashtongue Talisman of Swiftness (Mage)
    [32488] = { ITEM_MOD_HASTE_RATING_SHORT = 40, estimate = true },

    -- Ashtongue Talisman of Insight (Priest)
    [32490] = { ITEM_MOD_SPELL_POWER_SHORT = 45, ITEM_MOD_HEALING_SHORT = 45, estimate = true },

    -- Ashtongue Talisman of Equilibrium (Druid)
    [32486] = { ITEM_MOD_STRENGTH_SHORT = 40, ITEM_MOD_SPELL_POWER_SHORT = 40, ITEM_MOD_HEALING_SHORT = 40, estimate = true },

    -- Memento of Tyrande (Proc: Mp5)
    [32496] = { ITEM_MOD_MANA_REGENERATION_SHORT = 45, estimate = true },

    -- Shadowmoon Insignia (Use: Health) -> ~29 Stam
    [32501] = { ITEM_MOD_STAMINA_SHORT = 29, estimate = true },

    -- Commendation of Kael'thas (Use: Stam, Proc: Dodge) -> ~25 Dodge
    [32500] = { ITEM_MOD_DODGE_RATING_SHORT = 25, estimate = true },

    -- [[ TBC PHASE 4: ZUL'AMAN ]]
    -- Berserker's Call (Use: 360 AP) -> ~60 AP
    [33830] = { ITEM_MOD_ATTACK_POWER_SHORT = 60, estimate = true },

    -- Hex Shrunken Head (Use: 211 SP) -> ~35 SP
    [33829] = { ITEM_MOD_SPELL_POWER_SHORT = 35, estimate = true },

    -- Ancient Aqir Artifact (Use: Armor) -> ~333 Armor
    [33831] = { ITEM_MOD_ARMOR_SHORT = 333, estimate = true },

    -- Tome of Diabolic Remedy (Use: Heal) -> ~49 Heal
    [33828] = { ITEM_MOD_HEALING_SHORT = 49, estimate = true },

    -- [[ TBC PHASE 5: SUNWELL ]]
    -- Blackened Naaru Sliver (Use: AP) -> ~130 AP
    [34427] = { ITEM_MOD_ATTACK_POWER_SHORT = 130, estimate = true },

    -- Shard of Contempt (Proc: 230 AP) -> ~100 AP
    [34472] = { ITEM_MOD_ATTACK_POWER_SHORT = 100, estimate = true },

    -- Figurine - Shadowsong Panther (Use: AP) -> ~53 AP
    [35702] = { ITEM_MOD_ATTACK_POWER_SHORT = 53, estimate = true },
    
    -- Shattered Sun Pendants (Procs)
    [34678] = { ITEM_MOD_ATTACK_POWER_SHORT = 35, estimate = true },
    [34679] = { ITEM_MOD_ATTACK_POWER_SHORT = 35, estimate = true },

    -- Timbal's Focusing Crystal (Proc: Shadow Dmg) -> ~45 SP
    [34470] = { ITEM_MOD_SPELL_POWER_SHORT = 45, estimate = true },

    -- Shifting Naaru Sliver (Use: SP) -> ~53 SP
    [34429] = { ITEM_MOD_SPELL_POWER_SHORT = 53, estimate = true },

    -- Shattered Sun Pendant of Acumen
    [34664] = { ITEM_MOD_SPELL_POWER_SHORT = 20, estimate = true },

    -- Vial of the Sunwell (Proc: Heal) -> ~70 Heal
    [34471] = { ITEM_MOD_HEALING_SHORT = 70, estimate = true },
    
    -- Figurine - Seaspray Albatross (Mana) -> ~55 Mp5
    [35703] = { ITEM_MOD_MANA_REGENERATION_SHORT = 55, estimate = true },

    -- Commendation of Kael'thas (MgT) (Proc: Dodge) -> ~25 Dodge
    [34473] = { ITEM_MOD_DODGE_RATING_SHORT = 25, estimate = true },

    -- Figurine - Empyrean Tortoise (Use: Health) -> ~29 Stam
    [35700] = { ITEM_MOD_STAMINA_SHORT = 29, estimate = true },

    -- [[ PVP UTILITY (Medallions / Insignias) ]]
    -- Level 60 Insignias
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
    
    -- TBC Rare Medallions (20 Resil + Utility)
    [28234] = { MSC_PVP_UTILITY = 80, estimate = true }, -- Horde
    [28235] = { MSC_PVP_UTILITY = 80, estimate = true }, -- Alliance
    
    -- TBC Epic Medallions (40 Resil + Utility)
    [37864] = { MSC_PVP_UTILITY = 100, estimate = true }, -- Horde (Vindicator)
    [37865] = { MSC_PVP_UTILITY = 100, estimate = true }, -- Alliance (Vindicator)
}

-- ============================================================================
-- 5. INITIALIZATION
-- ============================================================================
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

function MSC:GetItemSetID(itemID)
    if not itemID then return nil end
    return MSC.ItemSetMap[tonumber(itemID)]
end

function MSC:GetSetBonusDefinition(setID, count)
    if MSC.SetBonusScores[setID] and MSC.SetBonusScores[setID][count] then
        return MSC.SetBonusScores[setID][count]
    end
    return nil
end

-- ============================================================================
-- 6. ITEM SETS & PROCS
-- ============================================================================
MSC.ItemSetMap = {} 
MSC.RawSetData = {
    -- [[ 1. LOW LEVEL / LEVELING SETS (15-50) ]]
    [161] = { {10399,10401,10403,10400,10402} }, -- Defias Leather
    [162] = { {6473,10413,10412,10410,10411} }, -- Embrace of the Viper
    [163] = { {10328,10333,10331,10329,10330,10332} }, -- Chain of the Scarlet Crusade
    [221] = { {7953,7950,7951,7948,7949,7952} }, -- Garb of Thero-shan
    [522] = { {23257,23258,22879,22864,22880,22856} }, -- Champion's Guard
    
    -- [[ CRAFTED LEVELING SETS (40-60) ]]
    [141] = { {15055,15053,15054} }, -- Volcanic Armor
    [142] = { {15058,15056,21278,15057} }, -- Stormshroud Armor
    [143] = { {15063,15062} }, -- Devilsaur Armor
    [144] = { {15067,15066} }, -- Ironfeather Armor
    [489] = { {15051,15050,15052,16984} }, -- Black Dragon Mail
    [490] = { {15045,20296,15046} }, -- Green Dragon Mail
    [491] = { {15049,15048,20295} }, -- Blue Dragon Mail
    [520] = { {22302,22305,22301,22313,22304,22306,22303,22311} }, -- Ironweave Battlesuit

    -- [[ CLASSIC DUNGEON SETS ]]
    [121] = { {14637,14640,14636,14638,14641} }, -- Cadaverous Garb
    [122] = { {14633,14626,14629,14632,14631} }, -- Necropile Raiment
    [123] = { {14611,14615,14614,14612,14616} }, -- Bloodmail Regalia
    [124] = { {14624,14622,14620,14623,14621} }, -- Deathbone Guardian
    [81]  = { {13390,13388,13389,13391,13392} }, -- The Postmaster
    [41]  = { {12940,12939} }, -- Dal'Rend's Arms
    [65]  = { {13183,13218} }, -- Spider's Kiss

    -- [[ DUNGEON SET 1 (Tier 0) ]]
    [181] = { {16686,16689,16688,16683,16684,16685,16687,16682} }, -- Magister's
    [182] = { {16693,16695,16690,16697,16692,16696,16694,16691} }, -- Devout
    [183] = { {16698,16701,16700,16703,16705,16702,16699,16704} }, -- Dreadmist
    [184] = { {16707,16708,16721,16710,16712,16713,16709,16711} }, -- Shadowcraft
    [185] = { {16720,16718,16706,16714,16717,16716,16719,16715} }, -- Wildheart
    [186] = { {16677,16679,16674,16681,16676,16680,16678,16675} }, -- Beaststalker
    [187] = { {16667,16669,16666,16671,16672,16673,16668,16670} }, -- The Elements
    [188] = { {16727,16729,16726,16722,16724,16723,16728,16725} }, -- Lightforge
    [189] = { {16731,16733,16730,16735,16737,16736,16732,16734} }, -- Valor

    -- [[ DUNGEON SET 2 (Tier 0.5) ]]
    [511] = { {21999,22001,21997,21996,21998,21994,22000,21995} }, -- Heroism
    [512] = { {22005,22008,22009,22004,22006,22002,22007,22003} }, -- Darkmantle
    [513] = { {22109,22112,22113,22108,22110,22106,22111,22107} }, -- Feralheart
    [514] = { {22080,22082,22083,22079,22081,22078,22085,22084} }, -- Virtuous
    [515] = { {22013,22016,22060,22011,22015,22010,22017,22061} }, -- Beastmaster
    [516] = { {22091,22093,22089,22088,22090,22086,22092,22087} }, -- Soulforge
    [517] = { {22065,22068,22069,22063,22066,22062,22067,22064} }, -- Sorcerer's
    [518] = { {22074,22073,22075,22071,22077,22070,22072,22076} }, -- Deathmist
    [519] = { {22097,22101,22102,22095,22099,22098,22100,22096} }, -- Five Thunders

    -- [[ CLASSIC RAIDS ]]
    -- ZG
    [461] = { {19865,19866} }, -- Twin Blades of Hakkari
    [462] = { {19893,19905} }, -- Zanzil's
    [463] = { {19896,19910} }, -- Primal Blessing
    [464] = { {19912,19873} }, -- Overlord's Resolution
    [465] = { {19920,19863} }, -- Prayer of the Primal
    [466] = { {19925,19898} }, -- Major Mojo
    [421] = { {19682,19683,19684} }, -- Bloodvine Garb
    [441] = { {19685,19687,19686} }, -- Primal Batskin
    [442] = { {19689,19688} }, -- Blood Tiger
    [443] = { {19691,19690,19692} }, -- Bloodsoul
    [444] = { {19695,19693,19694} }, -- Darksoul
    [474] = { {19577,19822,19824,19823,19951} }, -- Vindicator's
    [475] = { {19588,19825,19827,19826,19952} }, -- Freethinker's
    [476] = { {19609,19828,19830,19829,19956} }, -- Augur's
    [477] = { {19621,19831,19833,19832,19953} }, -- Predator's
    [478] = { {19617,19835,19834,19836,19954} }, -- Madcap's
    [479] = { {19613,19838,19840,19839,19955} }, -- Haruspex's
    [480] = { {19594,19841,19843,19842,19958} }, -- Confessor's
    [481] = { {19605,19849,20033,19848,19957} }, -- Demoniac's
    [482] = { {19601,19845,20034,19846,19959} }, -- Illusionist's

    -- TIER 1 (MC)
    [201] = { {16795,16797,16798,16799,16801,16802,16796,16800} }, -- Arcanist
    [202] = { {16813,16816,16815,16819,16812,16817,16814,16811} }, -- Prophecy
    [203] = { {16808,16807,16809,16804,16805,16806,16810,16803} }, -- Felheart
    [204] = { {16821,16823,16820,16825,16826,16827,16822,16824} }, -- Nightslayer
    [205] = { {16834,16836,16833,16830,16831,16828,16835,16829} }, -- Cenarion
    [206] = { {16846,16848,16845,16850,16852,16851,16847,16849} }, -- Giantstalker
    [207] = { {16842,16844,16841,16840,16839,16838,16843,16837} }, -- Earthfury
    [208] = { {16854,16856,16853,16857,16860,16858,16855,16859} }, -- Lawbringer
    [209] = { {16866,16868,16865,16861,16863,16864,16867,16862} }, -- Might

    -- TIER 2 (BWL)
    [210] = { {16914,16917,16916,16918,16913,16818,16915,16912} }, -- Netherwind
    [211] = { {16921,16924,16923,16926,16920,16925,16922,16919} }, -- Transcendence
    [212] = { {16929,16932,16931,16934,16928,16933,16930,16927} }, -- Nemesis
    [213] = { {16908,16832,16905,16911,16907,16910,16909,16906} }, -- Bloodfang
    [214] = { {16900,16902,16897,16904,16899,16903,16901,16898} }, -- Stormrage
    [215] = { {16939,16937,16942,16935,16940,16936,16938,16941} }, -- Dragonstalker
    [216] = { {16947,16945,16950,16943,16948,16944,16946,16949} }, -- Ten Storms
    [217] = { {16955,16953,16958,16951,16956,16952,16954,16957} }, -- Judgement
    [218] = { {16963,16961,16966,16959,16964,16960,16962,16965} }, -- Wrath

    -- TIER 3 (Naxx)
    [523] = { {22418,22419,22416,22423,22421,22422,22417,22420,23059} }, -- Dreadnaught
    [524] = { {22478,22479,22476,22483,22481,22482,22477,22480,23060} }, -- Bonescythe
    [525] = { {22514,22515,22512,22519,22517,22518,22513,22516,23061} }, -- Faith
    [526] = { {22498,22499,22496,22503,22501,22502,22497,22500,23062} }, -- Frostfire
    [527] = { {22466,22467,22464,22471,22469,22470,22465,22468,23065} }, -- Earthshatterer
    [528] = { {22428,22429,22425,22424,22426,22431,22427,22430,23066} }, -- Redemption
    [529] = { {22506,22507,22504,22511,22509,22510,22505,22508,23063} }, -- Plagueheart
    [530] = { {22438,22439,22436,22443,22441,22442,22437,22440,23067} }, -- Cryptstalker
    [521] = { {22490,22491,22488,22495,22493,22494,22489,22492,23064} }, -- Dreamwalker
    
    -- [[ CLASSIC PVP (RANK 12-14) ]]
    [383] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=40}} }, -- Horde
    [384] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=40}} }, -- Ally
    [389] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=40}} }, -- Horde
    [390] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=40}} }, -- Ally
    [387] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=40}} }, -- Horde
    [388] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=40}} }, -- Ally
    [394] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=23}} }, -- Horde Mage
    [395] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=23}} }, -- Ally Mage
    [396] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=23}} }, -- Horde Lock
    [397] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=23}} }, -- Ally Lock
    [386] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=23}} }, -- Ally Paladin
    [393] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=23}} }, -- Horde Shaman
    [398] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=23}} }, -- Horde Druid
    [399] = { [2]={stats={["ITEM_MOD_STAMINA_SHORT"]=20}}, [6]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=23}} }, -- Ally Druid
    
    -- Gladiator (S1)
    [700] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=20}} }, -- War
    [703] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=10}} }, -- Rogue
    [702] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_AGILITY_SHORT"]=15}} }, -- Hunter
    [706] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} }, -- Mage
    [707] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} }, -- Warlock
    [704] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_HEALING_POWER_SHORT"]=40}} }, -- Priest Holy

    -- Merciless (S2)
    [720] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={score=40} }, -- War (Intercept duration/AP)
    [723] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=10}} }, -- Rogue
    [726] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=28}} }, -- Mage
    [727] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=28}} }, -- Warlock
    [729] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=15}} }, -- Druid Feral

    -- Vengeful (S3)
    [740] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={score=50} }, -- War
    [743] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=10}} }, -- Rogue
    [746] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=30}} }, -- Mage
    [747] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=30}} }, -- Warlock
    [755] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=20}} }, -- Paladin Tank
}

-- Initialize Set Map
MSC:BuildDatabase()