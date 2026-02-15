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
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = MSC.L["Resilience"],
    ["ITEM_MOD_HASTE_RATING_SHORT"]      = MSC.L["Haste"],
    ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= MSC.L["Spell Haste"],
    ["ITEM_MOD_EXPERTISE_RATING_SHORT"]  = MSC.L["Expertise"],
    ["ITEM_MOD_ARMOR_PENETRATION_SHORT"] = MSC.L["Armor Pen"],
    ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = MSC.L["Armor Pen"],
    ["ITEM_MOD_SPELL_PENETRATION_SHORT"] = MSC.L["Spell Pen"],
    ["ITEM_MOD_SPELL_PENETRATION_RATING_SHORT"] = MSC.L["Spell Pen"],
    ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]= MSC.L["Feral AP"],
    ["MSC_PVP_UTILITY"]                  = MSC.L["PvP Utility"],
    ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = MSC.L["Expertise"], 
    ["RESISTANCE0_NAME"]              = MSC.L["Armor"], 
    ["ITEM_MOD_ARMOR_SHORT"]          = MSC.L["Armor"],
    ["ITEM_MOD_AGILITY_SHORT"]        = MSC.L["Agility"],
    ["ITEM_MOD_STRENGTH_SHORT"]       = MSC.L["Strength"],
    ["ITEM_MOD_INTELLECT_SHORT"]      = MSC.L["Intellect"],
    ["ITEM_MOD_SPIRIT_SHORT"]         = MSC.L["Spirit"],
    ["ITEM_MOD_STAMINA_SHORT"]        = MSC.L["Stamina"],
    ["ITEM_MOD_HEALTH_SHORT"]         = MSC.L["Health"],
    ["ITEM_MOD_MANA_SHORT"]           = MSC.L["Mana"],
    ["ITEM_MOD_SPELL_POWER_SHORT"]    = MSC.L["Spell Power"],
    ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]  = MSC.L["Healing"],
    ["ITEM_MOD_SPELL_HEALING_DONE"]   = MSC.L["Healing"], 
    ["ITEM_MOD_MANA_REGENERATION_SHORT"] = MSC.L["Mp5"],
    ["ITEM_MOD_POWER_REGEN0_SHORT"]   = MSC.L["Mp5"], 
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = MSC.L["DPS"],
    ["ITEM_MOD_ATTACK_POWER_SHORT"]      = MSC.L["Attack Power"],
    ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = MSC.L["Ranged AP"], 
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = MSC.L["Feral AP"],
    ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = MSC.L["Hp5"],
    ["ITEM_MOD_CRIT_RATING_SHORT"]       = MSC.L["Crit"],
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = MSC.L["Spell Crit"],
    ["ITEM_MOD_HIT_RATING_SHORT"]        = MSC.L["Hit"],
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]  = MSC.L["Spell Hit"],
    ["ITEM_MOD_CRIT_FROM_STATS_SHORT"]         = MSC.L["Crit (from Agi)"],
    ["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] = MSC.L["Spell Crit (from Int)"],
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = MSC.L["Defense"],
    ["ITEM_MOD_DODGE_RATING_SHORT"]      = MSC.L["Dodge"],
    ["ITEM_MOD_PARRY_RATING_SHORT"]      = MSC.L["Parry"],
    ["ITEM_MOD_BLOCK_RATING_SHORT"]      = MSC.L["Block %"],
    ["ITEM_MOD_BLOCK_VALUE_SHORT"]       = MSC.L["Block Value"],
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]     = MSC.L["Shadow Dmg"],
    ["ITEM_MOD_FIRE_DAMAGE_SHORT"]       = MSC.L["Fire Dmg"],
    ["ITEM_MOD_FROST_DAMAGE_SHORT"]      = MSC.L["Frost Dmg"],
    ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]     = MSC.L["Arcane Dmg"],
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"]     = MSC.L["Nature Dmg"],
    ["ITEM_MOD_HOLY_DAMAGE_SHORT"]       = MSC.L["Holy Dmg"],
    ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"] = MSC.L["Shadow Res"],
    ["ITEM_MOD_FIRE_RESISTANCE_SHORT"]   = MSC.L["Fire Res"],
    ["ITEM_MOD_FROST_RESISTANCE_SHORT"]  = MSC.L["Frost Res"],
    ["ITEM_MOD_NATURE_RESISTANCE_SHORT"] = MSC.L["Nature Res"],
    ["ITEM_MOD_ARCANE_RESISTANCE_SHORT"] = MSC.L["Arcane Res"],
    ["ITEM_MOD_ALL_RESISTANCE_SHORT"]    = MSC.L["All Res"],
    ["MSC_WEAPON_SPEED"]                 = MSC.L["Speed"],
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = MSC.L["Weapon DPS"],
    ["MSC_WEAPON_DPS"]                   = MSC.L["Weapon DPS"],
    ["MSC_WAND_DPS"]                     = MSC.L["Wand DPS"],
}

MSC.PrettyNames = {
    ["Leveling_1_20"]  = MSC.L["Starter (1-20)"],
    ["Leveling_21_40"] = MSC.L["Standard Leveling (21-40)"],
    ["Leveling_41_51"] = MSC.L["Standard Leveling (41-51)"],
    ["Leveling_52_59"] = MSC.L["Standard Leveling (52-59)"],
    ["Leveling_60_70"] = MSC.L["Standard Leveling (Outland)"],
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
    [2673] = { name = MSC.L["Mongoose"], stats = { ITEM_MOD_AGILITY_SHORT = 120, ITEM_MOD_HASTE_RATING_SHORT = 30 } }, 
    [2674] = { name = MSC.L["Sunfire"], stats = { ITEM_MOD_SPELL_POWER_SHORT = 50, ITEM_MOD_ARCANE_DAMAGE_SHORT = 50 } },
    [2675] = { name = MSC.L["Soulfrost"], stats = { ITEM_MOD_SPELL_POWER_SHORT = 54, ITEM_MOD_FROST_DAMAGE_SHORT = 54 } },
    [3225] = { name = MSC.L["Executioner"], stats = { ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT = 120 } }, 
    [2669] = { name = MSC.L["Major Spellpower"], stats = { ITEM_MOD_SPELL_POWER_SHORT = 40 } },
    [2642] = { name = MSC.L["Major Healing"], stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 81 } },
    [2671] = { name = MSC.L["Sunfire (Healing)"], stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 50 } },
    [2666] = { name = MSC.L["Major Intellect"], stats = { ITEM_MOD_INTELLECT_SHORT = 30 } },
    [2667] = { name = MSC.L["Savagery"], stats = { ITEM_MOD_ATTACK_POWER_SHORT = 70 } }, 
    [2668] = { name = MSC.L["Major Agility"], stats = { ITEM_MOD_AGILITY_SHORT = 20 } },
    [3222] = { name = MSC.L["Greater Agility (2H)"], stats = { ITEM_MOD_AGILITY_SHORT = 35 }, requires2H = true }, 
    [2672] = { name = MSC.L["Spell Surge"], stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 10 } },
    [2670] = { name = MSC.L["Potency"], stats = { ITEM_MOD_STRENGTH_SHORT = 20 } },
    [2621] = { name = MSC.L["Crusader"], stats = { ITEM_MOD_STRENGTH_SHORT = 60 } }, 

    -- [[ WEAPON: CLASSIC / LEVELING ]]
    [803]  = { name = MSC.L["Fiery Weapon"], stats = { ITEM_MOD_FIRE_DAMAGE_SHORT = 4 } }, 
    [1897] = { name = MSC.L["Weapon Dmg +5"], stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } }, 
    [2504] = { name = MSC.L["Spellpower +30"], stats = { ITEM_MOD_SPELL_POWER_SHORT = 30 } },
    [2505] = { name = MSC.L["Healing +55"], stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 55 } },
    [1900] = { name = MSC.L["Unholy Weapon"], stats = { ITEM_MOD_SHADOW_DAMAGE_SHORT = 4 } }, 
    [2563] = { name = MSC.L["Major Strength (+15)"], stats = { ITEM_MOD_STRENGTH_SHORT = 15 } },
    [1898] = { name = MSC.L["Lifestealing"], stats = { ITEM_MOD_SHADOW_DAMAGE_SHORT = 3 } },
    [943]  = { name = MSC.L["Lesser Striking (+3)"], stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1 } },
    [1894] = { name = MSC.L["Icy Chill"], stats = { ITEM_MOD_FROST_DAMAGE_SHORT = 4 } },
    [2564] = { name = MSC.L["Agility +15"], stats = { ITEM_MOD_AGILITY_SHORT = 15 } },
    [805]  = { name = MSC.L["Major Striking (+4)"], stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1.5 } },
    [1896] = { name = MSC.L["Superior Striking (+5)"], stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } },
    [963]  = { name = MSC.L["Greater Striking (+4)"], stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1.5 } },
    [249]  = { name = MSC.L["Striking (+3)"], stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1 } },
    [250]  = { name = MSC.L["Lesser Striking (+2)"], stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 0.7 } },
    [254]  = { name = MSC.L["Minor Striking (+1)"], stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 0.3 } },
    [912]  = { name = MSC.L["Demonslaying"], stats = { ITEM_MOD_ATTACK_POWER_SHORT = 5 } },
    [964]  = { name = MSC.L["Lesser Beastslayer"], stats = { ITEM_MOD_ATTACK_POWER_SHORT = 3 } },
    [33]   = { name = MSC.L["Minor Beastslayer"], stats = { ITEM_MOD_ATTACK_POWER_SHORT = 1 } },

    -- [[ SCOPES ]]
    [23766] = { slot = 18, isScope = true, stats = {ITEM_MOD_CRIT_RATING_SHORT=14, ITEM_MOD_DAMAGE_PER_SECOND_SHORT=3}, name = MSC.L["Adamantite Scope"] }, 
    [23764] = { slot = 18, isScope = true, stats = {ITEM_MOD_DAMAGE_PER_SECOND_SHORT=3}, name = MSC.L["Khorium Scope"] }, 
    [23765] = { slot = 18, isScope = true, stats = {ITEM_MOD_CRIT_RATING_SHORT=28}, name = MSC.L["Stabilized Eternium Scope"] },
    [10548] = { slot = 18, isScope = true, stats = {ITEM_MOD_DAMAGE_PER_SECOND_SHORT=2}, name = MSC.L["Sniper Scope"] }, 
    [33]    = { slot = 18, isScope = true, stats = {ITEM_MOD_DAMAGE_PER_SECOND_SHORT=1}, name = MSC.L["Accurate Scope"] },
    [664]   = { slot = 18, isScope = true, stats = {ITEM_MOD_DAMAGE_PER_SECOND_SHORT=0.5}, name = MSC.L["Standard Scope"] },
    [2523]  = { slot = 18, isScope = true, stats = {ITEM_MOD_HIT_RATING_SHORT=10}, name = MSC.L["Biznicks Accurascope"] },

    -- [[ SHIELD & SPIKES ]]
    [2655] = { name = MSC.L["Major Stamina"], slot = 17, isShield = true, stats = { ITEM_MOD_STAMINA_SHORT = 18 } },
    [2658] = { name = MSC.L["Intellect"], slot = 17, isShield = true, stats = { ITEM_MOD_INTELLECT_SHORT = 12 } },
    [2659] = { name = MSC.L["Shield Block"], slot = 17, isShield = true, stats = { ITEM_MOD_BLOCK_VALUE_SHORT = 15 } },
    [1071] = { name = MSC.L["Lesser Stamina"], slot = 17, isShield = true, stats = { ITEM_MOD_STAMINA_SHORT = 3 } }, 
    [1880] = { name = MSC.L["Greater Spirit"], slot = 17, isShield = true, stats = { ITEM_MOD_SPIRIT_SHORT = 9 } },
    [1881] = { name = MSC.L["Greater Stamina"], slot = 17, isShield = true, stats = { ITEM_MOD_STAMINA_SHORT = 7 } },
    [2748] = { name = MSC.L["Felsteel Shield Spike"], slot = 17, isShield = true, stats = { ITEM_MOD_BLOCK_VALUE_SHORT = 32 } }, 
    [2747] = { name = MSC.L["Thorium Shield Spike"], slot = 17, isShield = true, stats = { ITEM_MOD_BLOCK_VALUE_SHORT = 25 } },
    [2746] = { name = MSC.L["Mithril Shield Spike"], slot = 17, isShield = true, stats = { ITEM_MOD_BLOCK_VALUE_SHORT = 20 } },
    [2745] = { name = MSC.L["Iron Shield Spike"], slot = 17, isShield = true, stats = { ITEM_MOD_BLOCK_VALUE_SHORT = 15 } },

    -- [[ HEAD ]]
    [3012] = { name = MSC.L["Glyph of Power"], slot = 1, stats = { ITEM_MOD_SPELL_POWER_SHORT = 22, ITEM_MOD_HIT_SPELL_RATING_SHORT = 14 } },
    [3010] = { name = MSC.L["Glyph of Ferocity"], slot = 1, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 34, ITEM_MOD_HIT_RATING_SHORT = 16 } },
    [3013] = { name = MSC.L["Glyph of the Defender"], slot = 1, stats = { ITEM_MOD_DODGE_RATING_SHORT = 16, ITEM_MOD_BLOCK_VALUE_SHORT = 17 } },
    [3011] = { name = MSC.L["Glyph of Renewal"], slot = 1, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 35, ITEM_MOD_MANA_REGENERATION_SHORT = 7 } },
    [3003] = { name = MSC.L["Glyph of the Gladiator"], slot = 1, stats = { ITEM_MOD_STAMINA_SHORT = 18, ITEM_MOD_RESILIENCE_RATING_SHORT = 20 } },
    [3002] = { name = MSC.L["Glyph of the Outcast"], slot = 1, stats = { ITEM_MOD_STRENGTH_SHORT = 17, ITEM_MOD_INTELLECT_SHORT = 16 } },
    [2543] = { name = MSC.L["Lesser Arcanum (Agi)"], slot = 1, stats = { ITEM_MOD_AGILITY_SHORT = 8 } },
    [2544] = { name = MSC.L["Lesser Arcanum (Int)"], slot = 1, stats = { ITEM_MOD_INTELLECT_SHORT = 8 } },
    [2545] = { name = MSC.L["Lesser Arcanum (Str)"], slot = 1, stats = { ITEM_MOD_STRENGTH_SHORT = 8 } },
    [2588] = { name = MSC.L["Syncretist's Sigil"], slot = 1, stats = { ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_ATTACK_POWER_SHORT = 20 } },

    -- [[ SHOULDER ]]
    [3004] = { name = MSC.L["Greater Inscription of the Orb"], slot = 3, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15, ITEM_MOD_CRIT_RATING_SHORT = 12 } },
    [3007] = { name = MSC.L["Greater Inscription of Vengeance"], slot = 3, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30, ITEM_MOD_CRIT_RATING_SHORT = 10 } },
    [3009] = { name = MSC.L["Greater Inscription of the Knight"], slot = 3, stats = { ITEM_MOD_DODGE_RATING_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 15 } },
    [3005] = { name = MSC.L["Greater Inscription of the Oracle"], slot = 3, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 22, ITEM_MOD_MANA_REGENERATION_SHORT = 6 } },
    [2992] = { name = MSC.L["Inscription of the Orb"], slot = 3, stats = { ITEM_MOD_SPELL_POWER_SHORT = 12 } },
    [2998] = { name = MSC.L["Inscription of Vengeance"], slot = 3, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26 } },
    [2994] = { name = MSC.L["Inscription of the Knight"], slot = 3, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 13 } },
    [2993] = { name = MSC.L["Inscription of the Oracle"], slot = 3, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 5 } },
    [2721] = { name = MSC.L["Zandalar Signet of Mojo"], slot = 3, stats = { ITEM_MOD_SPELL_POWER_SHORT = 18 } },
    [2716] = { name = MSC.L["Zandalar Signet of Might"], slot = 3, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30 } },
    [2717] = { name = MSC.L["Zandalar Signet of Serenity"], slot = 3, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 33 } },
    -- [[ SHOULDER: ALDOR / SCRYER (EXALTED) ]]
    [2996] = { name = MSC.L["Greater Inscription of the Orb"], slot = 3, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15, ITEM_MOD_CRIT_RATING_SHORT = 12 } }, -- Aldor
    [2999] = { name = MSC.L["Greater Inscription of Vengeance"], slot = 3, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30, ITEM_MOD_CRIT_RATING_SHORT = 10 } }, -- Aldor
    [3000] = { name = MSC.L["Greater Inscription of the Knight"], slot = 3, stats = { ITEM_MOD_DODGE_RATING_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 15 } }, -- Aldor
    [2997] = { name = MSC.L["Greater Inscription of the Oracle"], slot = 3, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 22, ITEM_MOD_MANA_REGENERATION_SHORT = 6 } }, -- Aldor
    [3004] = { name = MSC.L["Greater Inscription of the Orb"], slot = 3, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15, ITEM_MOD_CRIT_RATING_SHORT = 12 } }, -- Scryer (Duplicate Stat, diff ID)
    [3007] = { name = MSC.L["Greater Inscription of Vengeance"], slot = 3, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30, ITEM_MOD_CRIT_RATING_SHORT = 10 } }, -- Scryer
    [3009] = { name = MSC.L["Greater Inscription of the Knight"], slot = 3, stats = { ITEM_MOD_DODGE_RATING_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 15 } }, -- Scryer
    [3005] = { name = MSC.L["Greater Inscription of the Oracle"], slot = 3, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 22, ITEM_MOD_MANA_REGENERATION_SHORT = 6 } }, -- Scryer

    -- [[ BACK ]]
    [2653] = { name = MSC.L["Greater Agility (+12)"], slot = 15, stats = { ITEM_MOD_AGILITY_SHORT = 12 } },
    [2662] = { name = MSC.L["Spell Penetration"], slot = 15, stats = { ITEM_MOD_SPELL_PENETRATION_SHORT = 20 } },
    [3296] = { name = MSC.L["Steelweave"], slot = 15, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 12 } },
    [3294] = { name = MSC.L["Major Armor"], slot = 15, stats = { ITEM_MOD_ARMOR_SHORT = 120 } },
    [849]  = { name = MSC.L["Lesser Agility (+3)"], slot = 15, stats = { ITEM_MOD_AGILITY_SHORT = 3 } }, 
    [2502] = { name = MSC.L["Greater Resistance"], slot = 15, stats = { ITEM_MOD_RESISTANCE_ALL_SHORT = 5 } },
    [1889] = { name = MSC.L["Superior Defense (+70)"], slot = 15, stats = { ITEM_MOD_ARMOR_SHORT = 70 } },
    [853]  = { name = MSC.L["Greater Defense (+50)"], slot = 15, stats = { ITEM_MOD_ARMOR_SHORT = 50 } },
    [13421] = { name = MSC.L["Minor Agility (+1)"], slot = 15, stats = { ITEM_MOD_AGILITY_SHORT = 1 } },
    [250]   = { name = MSC.L["Minor Agility (+1)"], slot = 15, stats = { ITEM_MOD_AGILITY_SHORT = 1 } },
    [2521] = { name = MSC.L["Subtlety (-2% Threat]"], slot = 15, stats = { MSC_THREAT_MOD = -2 } },
    [2622] = { name = MSC.L["Dodge (+1%)"], slot = 15, stats = { ITEM_MOD_DODGE_RATING_SHORT = 15 } },
    [3256] = { name = MSC.L["Major Resistance (+7)"], slot = 15, stats = { ITEM_MOD_RESISTANCE_ALL_SHORT = 7 } },
    -- [[ CLOAK: RESISTANCES ]]
    [2662] = { name = MSC.L["Spell Penetration"], slot = 15, stats = { ITEM_MOD_SPELL_PENETRATION_SHORT = 20 } },
    [2794] = { name = MSC.L["Greater Shadow Resistance"], slot = 15, stats = { ITEM_MOD_SHADOW_RESISTANCE_SHORT = 15 } },
    [2521] = { name = MSC.L["Subtlety"], slot = 15, stats = { MSC_THREAT_MOD = -2 } }, -- -2% Threat

    -- [[ CHEST ]]
    [2661] = { name = MSC.L["Exceptional Stats (+6)"], slot = 5, stats = { ITEM_MOD_AGILITY_SHORT=6, ITEM_MOD_STRENGTH_SHORT=6, ITEM_MOD_INTELLECT_SHORT=6, ITEM_MOD_STAMINA_SHORT=6 } },
    [2653] = { name = MSC.L["Major Health (+150)"], slot = 5, stats = { ITEM_MOD_HEALTH_SHORT = 150 } },
    [3297] = { name = MSC.L["Major Resilience"], slot = 5, stats = { ITEM_MOD_RESILIENCE_RATING_SHORT = 15 } },
    [2657] = { name = MSC.L["Restore Mana Prime"], slot = 5, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 6 } },
    [1891] = { name = MSC.L["Greater Stats (+4)"], slot = 5, stats = { ITEM_MOD_AGILITY_SHORT=4, ITEM_MOD_STRENGTH_SHORT=4, ITEM_MOD_INTELLECT_SHORT=4, ITEM_MOD_STAMINA_SHORT=4 } },
    [843]  = { name = MSC.L["Minor Stats (+1)"], slot = 5, stats = { ITEM_MOD_AGILITY_SHORT=1, ITEM_MOD_STRENGTH_SHORT=1, ITEM_MOD_INTELLECT_SHORT=1, ITEM_MOD_STAMINA_SHORT=1 } },
    [1892] = { name = MSC.L["Major Health (+100)"], slot = 5, stats = { ITEM_MOD_HEALTH_SHORT = 100 } },
    [866]  = { name = MSC.L["Stats (+3)"], slot = 5, stats = { ITEM_MOD_AGILITY_SHORT=3, ITEM_MOD_STRENGTH_SHORT=3, ITEM_MOD_INTELLECT_SHORT=3, ITEM_MOD_STAMINA_SHORT=3 } },
    [850]  = { name = MSC.L["Lesser Stats (+2)"], slot = 5, stats = { ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STRENGTH_SHORT=2, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_STAMINA_SHORT=2 } },
    [846]  = { name = MSC.L["Major Mana (+100)"], slot = 5, stats = { ITEM_MOD_MANA_SHORT = 100 } },
    [865]  = { name = MSC.L["Superior Health (+50)"], slot = 5, stats = { ITEM_MOD_HEALTH_SHORT = 50 } },
    [243]  = { name = MSC.L["Minor Health (+5)"], slot = 5, stats = { ITEM_MOD_HEALTH_SHORT = 5 } },
    [248]  = { name = MSC.L["Lesser Health (+15)"], slot = 5, stats = { ITEM_MOD_HEALTH_SHORT = 15 } },
    [255]  = { name = MSC.L["Health (+25)"], slot = 5, stats = { ITEM_MOD_HEALTH_SHORT = 25 } },
    [856]  = { name = MSC.L["Greater Health (+35)"], slot = 5, stats = { ITEM_MOD_HEALTH_SHORT = 35 } },
    [857]  = { name = MSC.L["Mana (+50)"], slot = 5, stats = { ITEM_MOD_MANA_SHORT = 50 } },
    [244]  = { name = MSC.L["Lesser Mana (+30)"], slot = 5, stats = { ITEM_MOD_MANA_SHORT = 30 } },

    -- [[ WRIST ]]
    [2647] = { name = MSC.L["Brawn (+12 Str)"], slot = 9, stats = { ITEM_MOD_STRENGTH_SHORT = 12 } }, 
    [2650] = { name = MSC.L["Spellpower (+15)"], slot = 9, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15 } }, 
    [2651] = { name = MSC.L["Major Healing (+30)"], slot = 9, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 30 } }, 
    [2649] = { name = MSC.L["Assault (+24 AP)"], slot = 9, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 24 } }, 
    [2646] = { name = MSC.L["Major Defense"], slot = 9, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 12 } },
    [2655] = { name = MSC.L["Fortitude (+12 Stam)"], slot = 9, stats = { ITEM_MOD_STAMINA_SHORT = 12 } }, 
    [1883] = { name = MSC.L["Intellect +7"], slot = 9, stats = { ITEM_MOD_INTELLECT_SHORT = 7 } },
    [1884] = { name = MSC.L["Spirit +9"], slot = 9, stats = { ITEM_MOD_SPIRIT_SHORT = 9 } },
    [905]  = { name = MSC.L["Minor Strength (+1)"], slot = 9, stats = { ITEM_MOD_STRENGTH_SHORT = 1 } },
    [1885] = { name = MSC.L["Superior Strength (+9)"], slot = 9, stats = { ITEM_MOD_STRENGTH_SHORT = 9 } },
    [1886] = { name = MSC.L["Superior Stamina (+9)"], slot = 9, stats = { ITEM_MOD_STAMINA_SHORT = 9 } },
    [1893] = { name = MSC.L["Mana Regen (+4mp5)"], slot = 9, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 4 } },
    [2508] = { name = MSC.L["Healing Power (+24)"], slot = 9, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 24 } },
    [2793] = { name = MSC.L["Major Strength (+12)"], slot = 9, stats = { ITEM_MOD_STRENGTH_SHORT = 12 } },
    [2794] = { name = MSC.L["Major Intellect (+12)"], slot = 9, stats = { ITEM_MOD_INTELLECT_SHORT = 12 } },
    [246]  = { name = MSC.L["Minor Spirit (+1)"], slot = 9, stats = { ITEM_MOD_SPIRIT_SHORT = 1 } },
    [256]  = { name = MSC.L["Lesser Spirit (+3)"], slot = 9, stats = { ITEM_MOD_SPIRIT_SHORT = 3 } },
    [262]  = { name = MSC.L["Spirit (+5)"], slot = 9, stats = { ITEM_MOD_SPIRIT_SHORT = 5 } },
    [852]  = { name = MSC.L["Greater Spirit (+7)"], slot = 9, stats = { ITEM_MOD_SPIRIT_SHORT = 7 } },
    [279]  = { name = MSC.L["Minor Stamina (+1)"], slot = 9, stats = { ITEM_MOD_STAMINA_SHORT = 1 } },
    [258]  = { name = MSC.L["Lesser Stamina (+3)"], slot = 9, stats = { ITEM_MOD_STAMINA_SHORT = 3 } },
    [265]  = { name = MSC.L["Stamina (+5)"], slot = 9, stats = { ITEM_MOD_STAMINA_SHORT = 5 } },
    [851]  = { name = MSC.L["Greater Stamina (+7)"], slot = 9, stats = { ITEM_MOD_STAMINA_SHORT = 7 } },
    [263]  = { name = MSC.L["Minor Agility (+1)"], slot = 9, stats = { ITEM_MOD_AGILITY_SHORT = 1 } },

    -- [[ HANDS ]]
    [2562] = { name = MSC.L["Superior Agility (+15)"], slot = 10, stats = { ITEM_MOD_AGILITY_SHORT = 15 } }, 
    [2937] = { name = MSC.L["Major Spellpower (+20)"], slot = 10, stats = { ITEM_MOD_SPELL_POWER_SHORT = 20 } }, 
    [2935] = { name = MSC.L["Major Healing (+35)"], slot = 10, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 35 } }, 
    [2648] = { name = MSC.L["Assault (+26 AP)"], slot = 10, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26 } }, 
    [2613] = { name = MSC.L["Threat (+Hit)"], slot = 10, stats = { ITEM_MOD_HIT_RATING_SHORT = 10 } }, 
    [3246] = { name = MSC.L["Blast (+Crit)"], slot = 10, stats = { ITEM_MOD_SPELL_CRIT_RATING_SHORT = 10 } },
    [1886] = { name = MSC.L["Agility +7"], slot = 10, stats = { ITEM_MOD_AGILITY_SHORT = 7 } },
    [1888] = { name = MSC.L["Greater Strength (+7)"], slot = 10, stats = { ITEM_MOD_STRENGTH_SHORT = 7 } },
    [2506] = { name = MSC.L["Greater Agility (Classic +7)"], slot = 10, stats = { ITEM_MOD_AGILITY_SHORT = 7 } },
    [847]  = { name = MSC.L["Agility (+5)"], slot = 10, stats = { ITEM_MOD_AGILITY_SHORT = 5 } },
    [930]  = { name = MSC.L["Riding Skill"], slot = 10, stats = { MSC_SPEED_BONUS = 2 } },
    [854]  = { name = MSC.L["Greater Strength (+7)"], slot = 10, stats = { ITEM_MOD_STRENGTH_SHORT = 7 } },
    [848]  = { name = MSC.L["Strength (+5)"], slot = 10, stats = { ITEM_MOD_STRENGTH_SHORT = 5 } },
    [2614] = { name = MSC.L["Shadow Power (+20)"], slot = 10, stats = { ITEM_MOD_SHADOW_DAMAGE_SHORT = 20 } },
    [2615] = { name = MSC.L["Frost Power (+20)"], slot = 10, stats = { ITEM_MOD_FROST_DAMAGE_SHORT = 20 } },
    [2616] = { name = MSC.L["Fire Power (+20)"], slot = 10, stats = { ITEM_MOD_FIRE_DAMAGE_SHORT = 20 } },
    [2617] = { name = MSC.L["Healing Power (+30)"], slot = 10, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 30 } }, 
    [3231] = { name = MSC.L["Precision (+15 Hit)"], slot = 10, stats = { ITEM_MOD_HIT_RATING_SHORT = 15 } },
    [3245] = { name = MSC.L["Spell Strike (+15 Hit)"], slot = 10, stats = { ITEM_MOD_HIT_SPELL_RATING_SHORT = 15 } },
   
   -- [[ GLOVES: UTILITY ]]
    [3220] = { name = MSC.L["Glove Reinforcements"], slot = 10, stats = { ITEM_MOD_ARMOR_SHORT = 240 } },

    -- [[ LEGS ]]
    [3154] = { name = MSC.L["Runic Spellthread"], slot = 7, stats = { ITEM_MOD_SPELL_POWER_SHORT = 35, ITEM_MOD_STAMINA_SHORT = 20 } },
    [3153] = { name = MSC.L["Golden Spellthread"], slot = 7, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 66, ITEM_MOD_STAMINA_SHORT = 20 } },
    [2953] = { name = MSC.L["Nethercobra Leg Armor"], slot = 7, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 50, ITEM_MOD_CRIT_RATING_SHORT = 12 } },
    [2952] = { name = MSC.L["Nethercleft Leg Armor"], slot = 7, stats = { ITEM_MOD_STAMINA_SHORT = 40, ITEM_MOD_AGILITY_SHORT = 12 } },
    [2741] = { name = MSC.L["Cobrahide Leg Armor"], slot = 7, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 40, ITEM_MOD_CRIT_RATING_SHORT = 10 } },
    [2427] = { name = MSC.L["Mystic Spellthread"], slot = 7, stats = { ITEM_MOD_SPELL_POWER_SHORT = 25, ITEM_MOD_STAMINA_SHORT = 15 } },
    [2743] = { name = MSC.L["Clefthide Leg Armor"], slot = 7, stats = { ITEM_MOD_STAMINA_SHORT = 30, ITEM_MOD_AGILITY_SHORT = 10 } },
    [2543] = { name = MSC.L["Lesser Arcanum (Agi)"], slot = 7, stats = { ITEM_MOD_AGILITY_SHORT = 8 } },
    [2544] = { name = MSC.L["Lesser Arcanum (Int)"], slot = 7, stats = { ITEM_MOD_INTELLECT_SHORT = 8 } },
    [2545] = { name = MSC.L["Lesser Arcanum (Str)"], slot = 7, stats = { ITEM_MOD_STRENGTH_SHORT = 8 } },
    [2588] = { name = MSC.L["Syncretist's Sigil"], slot = 7, stats = { ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_ATTACK_POWER_SHORT = 20 } }, 
    [1503] = { name = MSC.L["Lesser Arcanum of Rumination"], slot = 7, stats = { ITEM_MOD_MANA_SHORT = 150 } },
    [1504] = { name = MSC.L["Lesser Arcanum of Constitution"], slot = 7, stats = { ITEM_MOD_HEALTH_SHORT = 100 } },
    [3016] = { name = MSC.L["Clefthide Leg Armor"], slot = 7, stats = { ITEM_MOD_STAMINA_SHORT = 30, ITEM_MOD_AGILITY_SHORT = 10 } },

    -- [[ FEET ]]
    [2939] = { name = MSC.L["Boar's Speed"], slot = 8, stats = { ITEM_MOD_STAMINA_SHORT = 9, MSC_SPEED_BONUS = 8 } },
    [2656] = { name = MSC.L["Cat's Swiftness"], slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 6, MSC_SPEED_BONUS = 8 } },
    [3232] = { name = MSC.L["Surefooted"], slot = 8, stats = { ITEM_MOD_HIT_RATING_SHORT = 10, ITEM_MOD_CRIT_RATING_SHORT = 5 } }, 
    [2564] = { name = MSC.L["Agility +7"], slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 7 } },
    [911]  = { name = MSC.L["Minor Agility (+1]"], slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 1 } },
    [910]  = { name = MSC.L["Minor Speed"], slot = 8, stats = { MSC_SPEED_BONUS = 8 } },
    [859]  = { name = MSC.L["Spirit (+5]"], slot = 8, stats = { ITEM_MOD_SPIRIT_SHORT = 5 } },
    [860]  = { name = MSC.L["Lesser Spirit (+3]"], slot = 8, stats = { ITEM_MOD_SPIRIT_SHORT = 3 } },
    [273]  = { name = MSC.L["Minor Spirit (+1]"], slot = 8, stats = { ITEM_MOD_SPIRIT_SHORT = 1 } },
    [858]  = { name = MSC.L["Greater Stamina (+7]"], slot = 8, stats = { ITEM_MOD_STAMINA_SHORT = 7 } },
    [845]  = { name = MSC.L["Stamina (+5"], slot = 8, stats = { ITEM_MOD_STAMINA_SHORT = 5 } },
    [844]  = { name = MSC.L["Lesser Stamina (+3"], slot = 8, stats = { ITEM_MOD_STAMINA_SHORT = 3 } },
    [274]  = { name = MSC.L["Minor Stamina (+1"], slot = 8, stats = { ITEM_MOD_STAMINA_SHORT = 1 } },
    [849]  = { name = MSC.L["Agility (+5"], slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 5 } }, 
    [842]  = { name = MSC.L["Lesser Agility (+3"], slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 3 } },
    [2654] = { name = MSC.L["Fortitude (+12 Stam"], slot = 8, stats = { ITEM_MOD_STAMINA_SHORT = 12 } },
    [2657] = { name = MSC.L["Dexterity (+12 Agi"], slot = 8, stats = { ITEM_MOD_AGILITY_SHORT = 12 } },
    [2658] = { name = MSC.L["Surefooted (+5% Resist"], slot = 8, stats = { ITEM_MOD_HIT_RATING_SHORT = 10 } },

    -- [[ RINGS ]]
    [2931] = { name = MSC.L["Spellpower"], slot = 11, stats = { ITEM_MOD_SPELL_POWER_SHORT = 12 } }, 
    [2933] = { name = MSC.L["Healing Power"], slot = 11, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 20 } }, 
    [2934] = { name = MSC.L["Stats"], slot = 11, stats = { ITEM_MOD_AGILITY_SHORT=4, ITEM_MOD_STRENGTH_SHORT=4, ITEM_MOD_INTELLECT_SHORT=4, ITEM_MOD_STAMINA_SHORT=4 } }, 
    [2629] = { name = MSC.L["Striking"], slot = 11, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } },

    -- [[ MISSING LOW-LEVEL / TWINK ENCHANTS ]] --
    -- [[ GLOVES ]]
    -- Highly valued by twinks/levelers for the cheap Haste
    [931]  = { name = MSC.L["Minor Haste"], stats = { ITEM_MOD_HASTE_RATING_SHORT = 10 } }, -- ~1% Haste

    -- [[ WEAPON (CASTER / SPIRIT) ]]
    -- Great budget options for Level 40-60 casters
    [2443] = { name = MSC.L["Winter's Might (+7 SP"], stats = { ITEM_MOD_SPELL_POWER_SHORT = 7, ITEM_MOD_FROST_DAMAGE_SHORT = 7 } },
    [804]  = { name = MSC.L["Lesser Intellect (+6"], stats = { ITEM_MOD_INTELLECT_SHORT = 6 } },
    [2566] = { name = MSC.L["Major Intellect (+22"], stats = { ITEM_MOD_INTELLECT_SHORT = 22 } }, -- Classic Endgame
    [2565] = { name = MSC.L["Major Spirit (+20"], stats = { ITEM_MOD_SPIRIT_SHORT = 20 } },    -- Classic Endgame
    -- [[ 2H WEAPON ]]
    [1899] = { name = MSC.L["Impact (+5 Dmg"], stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1.4 }, requires2H = true },   
    -- [[ CHEST ]]
    [1951] = { name = MSC.L["Lesser Absorption"], stats = { MSC_EHP_MOD = 5 } }, -- (Abstracted value for proc)
    -- [[ SHOULDER: NAXXRAMAS / SAPPHIRON ]]
    [2613] = { name = MSC.L["Power of the Scourge"], slot = 3, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15, ITEM_MOD_HIT_SPELL_RATING_SHORT = 14 } }, -- Rockbiter is different ID
    [2611] = { name = MSC.L["Fortitude of the Scourge"], slot = 3, stats = { ITEM_MOD_STAMINA_SHORT = 16, ITEM_MOD_ARMOR_SHORT = 100 } },
    [2612] = { name = MSC.L["Might of the Scourge"], slot = 3, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26, ITEM_MOD_CRIT_RATING_SHORT = 14 } },
    [2610] = { name = MSC.L["Resilience of the Scourge"], slot = 3, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 13, ITEM_MOD_STAMINA_SHORT = 10 } },
    -- [[ LEGS: EPIC ]]
    [3154] = { name = MSC.L["Runic Spellthread"], slot = 7, stats = { ITEM_MOD_SPELL_POWER_SHORT = 35, ITEM_MOD_STAMINA_SHORT = 20 } },
    [3153] = { name = MSC.L["Golden Spellthread"], slot = 7, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 66, ITEM_MOD_STAMINA_SHORT = 20 } },
    [2953] = { name = MSC.L["Nethercobra Leg Armor"], slot = 7, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 50, ITEM_MOD_CRIT_RATING_SHORT = 12 } },
    [2952] = { name = MSC.L["Nethercleft Leg Armor"], slot = 7, stats = { ITEM_MOD_STAMINA_SHORT = 40, ITEM_MOD_AGILITY_SHORT = 12 } },
}

-- ============================================================================
-- 3. ENCHANT CANDIDATES (The Search Lists)
-- ============================================================================
-- These lists tell the evaluator which IDs to check for each slot.

MSC.EnchantCandidates = {
    -- [[ HEAD ]]
    [1] = { 3012, 3010, 3013, 3011, 3003, 3002, 2543, 2544, 2545, 2588 },
    -- [[ SHOULDER ]]
    [3] = { 
        2996, 2999, 3000, 2997, -- Aldor Exalted
        3004, 3007, 3009, 3005, -- Scryer Exalted
        2613, 2611, 2612, 2610, -- Naxxramas
        2992, 2998, 2994, 2993, 2721, 2716, 2717 -- Rares / ZG
    },
    -- [[ CHEST ]]
    [5] = { 2661, 2653, 3297, 2657, 1891, 1892, 843, 866, 850, 846, 865, 856 },
    -- [[ LEGS ]]
    [7] = { 3154, 3153, 2953, 2952, 2427, 2741, 2743, 3016, 2543, 2544, 2545, 1503, 1504 },
    -- [[ FEET ]]
    [8] = { 2939, 2656, 3232, 2564, 911, 910, 2654, 2657, 2658, 859, 860, 858, 845, 849 },
    -- [[ WRIST ]]
    [9] = { 2647, 2650, 2651, 2649, 2646, 2655, 1883, 1884, 905, 1885, 1886, 1893, 2508, 2793, 2794, 852, 851 },
    -- [[ HANDS ]]
    [10] = { 2562, 2937, 2935, 2648, 2613, 3246, 3220, 1886, 1888, 2506, 847, 930, 854, 848, 2614, 2615, 2616, 2617, 3231, 3245 },
    -- [[ RINGS ]]
    [11] = { 2931, 2933, 2934, 2629 },
    [12] = { 2931, 2933, 2934, 2629 },
    -- [[ BACK ]]
    [15] = { 2653, 2662, 3296, 3294, 2502, 2794, 849, 1889, 853, 250, 2521, 2622, 3256 },
    -- [[ WEAPON (MAIN/2H) ]]
    [16] = { 2673, 2674, 2675, 3225, 2669, 2642, 2671, 2666, 2667, 2668, 3222, 2621, 1897, 803, 1900, 2563, 1898, 2504, 2505, 943, 2672, 2670, 805, 1896, 963 },
    -- [[ OFFHAND / SHIELD ]]
    [17] = { 2655, 2658, 2659, 1071, 1880, 1881, 2748, 2747, 2746, 2745, 2673, 2674, 2675, 3225, 2669, 2642, 2666, 2668, 2621, 803 },
    -- [[ RANGED ]]
    [18] = { 23766, 23764, 23765, 10548, 33, 664, 2523 } 
}

-- LEVELING LIST (Includes cheaper/lower level options)
MSC.EnchantCandidates_Leveling = {
    [1] = {}, [3] = {}, 
    [5] = { 1891, 1892, 843, 850, 243, 248, 255, 2653 }, 
    [9] = { 2655, 1885, 1883, 1884, 905, 246, 256, 262, 279, 258, 265, 263 }, 
    [10] = { 2562, 1886, 1888, 847, 848, 930, 931 },
    [6] = {},
    [7] = { 2741, 2743, 2427 }, -- (Armor Kits usually)
    [8] = { 910, 2564, 911, 273, 845, 844, 274, 842 }, 
    [15] = { 849, 1889, 250 }, 
    [16] = { 2621, 803, 1900, 1898, 2504, 2505, 943, 1897, 2563, 1894, 2564, 249, 250, 254, 912, 964, 33, 2443, 804, 2566, 2565, 1899 },
    [17] = { 2621, 803, 1900, 1898, 2655, 1071, 2747, 2746, 2745 }, 
    [11] = {}, [12] = {},
    [18] = { 10548, 33, 664 } 
}

-- ============================================================================
-- 3. GEM DATABASE (TBC RARE QUALITY)
-- ============================================================================

if MSC.IsTBC or MSC.IsWrath then
    local GEMS = {
   -- ========================================================================
   -- [[ PHASE 1: LAUNCH (RARE, PVP, & HEROIC) ]]
   -- ========================================================================
   PRISMATIC_P1 = {
        { id=22460, stat="ITEM_MOD_RESISTANCE_ALL_SHORT", val=4, name=MSC.L["Void Sphere"], colorType="PRISMATIC" },
    },
    
    RED_P1 = {
        { id=24027, stat="ITEM_MOD_STRENGTH_SHORT", val=8, name=MSC.L["Bold Living Ruby"], colorType="RED" },
        { id=24028, stat="ITEM_MOD_AGILITY_SHORT", val=8, name=MSC.L["Delicate Living Ruby"], colorType="RED" },
        { id=24030, stat="ITEM_MOD_SPELL_POWER_SHORT", val=9, name=MSC.L["Runed Living Ruby"], colorType="RED" },
        { id=24031, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=16, name=MSC.L["Bright Living Ruby"], colorType="RED" },
        { id=24032, stat="ITEM_MOD_DODGE_RATING_SHORT", val=8, name=MSC.L["Subtle Living Ruby"], colorType="RED" },
        { id=24033, stat="ITEM_MOD_PARRY_RATING_SHORT", val=8, name=MSC.L["Flashing Living Ruby"], colorType="RED" },
        { id=24035, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=18, name=MSC.L["Teardrop Living Ruby"], colorType="RED" },
        -- PvP / Ornate
        { id=28118, stat="ITEM_MOD_SPELL_POWER_SHORT", val=12, name=MSC.L["Runed Ornate Ruby"], colorType="RED" },
        { id=28362, stat="ITEM_MOD_STRENGTH_SHORT", val=10, name=MSC.L["Bold Ornate Ruby"], colorType="RED" },
    },

    BLUE_P1 = {
        { id=24053, stat="ITEM_MOD_STAMINA_SHORT", val=12, name=MSC.L["Solid Star of Elune"], colorType="BLUE" }, 
        { id=24054, stat="ITEM_MOD_SPIRIT_SHORT", val=8, name=MSC.L["Sparkling Star of Elune"], colorType="BLUE" },
        { id=24056, stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=3, name=MSC.L["Lustrous Star of Elune"], colorType="BLUE" },
        { id=24057, stat="ITEM_MOD_SPELL_PENETRATION_SHORT", val=10, name=MSC.L["Stormy Star of Elune"], colorType="BLUE" },
        -- Misc
        { id=34831, stat="ITEM_MOD_STAMINA_SHORT", val=15, name=MSC.L["Eye of the Sea"], colorType="BLUE" },
    },

    YELLOW_P1 = {
        { id=24047, stat="ITEM_MOD_HIT_RATING_SHORT", val=8, name=MSC.L["Rigid Dawnstone"], colorType="YELLOW" },
        { id=24048, stat="ITEM_MOD_CRIT_RATING_SHORT", val=8, name=MSC.L["Smooth Dawnstone"], colorType="YELLOW" },
        { id=24050, stat="ITEM_MOD_INTELLECT_SHORT", val=8, name=MSC.L["Brilliant Dawnstone"], colorType="YELLOW" },
        { id=24051, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=8, name=MSC.L["Thick Dawnstone"], colorType="YELLOW" },
        { id=24052, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=8, name=MSC.L["Mystic Dawnstone"], colorType="YELLOW" },
        { id=24053, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=8, name=MSC.L["Gleaming Dawnstone"], colorType="YELLOW" },
        { id=24061, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=8, name=MSC.L["Great Dawnstone"], colorType="YELLOW" },
        -- PvP / Ornate
        { id=28119, stat="ITEM_MOD_CRIT_RATING_SHORT", val=10, name=MSC.L["Smooth Ornate Dawnstone"], colorType="YELLOW" },
    },

    ORANGE_P1 = {
        { id=24058, stat="ITEM_MOD_STRENGTH_SHORT", val=4, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=4, name=MSC.L["Inscribed Noble Topaz"], colorType="ORANGE" },
        { id=24060, stat="ITEM_MOD_STRENGTH_SHORT", val=4, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=4, name=MSC.L["Etched Noble Topaz"], colorType="ORANGE" },
        { id=24059, stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val2=4, name=MSC.L["Potent Noble Topaz"], colorType="ORANGE" },
        { id=24062, stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, stat2="ITEM_MOD_HIT_SPELL_RATING_SHORT", val2=4, name=MSC.L["Veiled Noble Topaz"], colorType="ORANGE" },
        { id=24061, stat="ITEM_MOD_AGILITY_SHORT", val=4, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=4, name=MSC.L["Glinting Noble Topaz"], colorType="ORANGE" },
        { id=24065, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=9, stat2="ITEM_MOD_INTELLECT_SHORT", val2=4, name=MSC.L["Luminous Noble Topaz"], colorType="ORANGE" },
        -- PvP / Ornate
        { id=28363, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=5, name=MSC.L["Inscribed Ornate Topaz"], colorType="ORANGE" },
    },

    PURPLE_P1 = {
        { id=24063, stat="ITEM_MOD_STRENGTH_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Sovereign Nightseye"], colorType="PURPLE" },
        { id=24064, stat="ITEM_MOD_AGILITY_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Shifting Nightseye"], colorType="PURPLE" },
        { id=24065, stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Glowing Nightseye"], colorType="PURPLE" },
        { id=24066, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=9, stat2="ITEM_MOD_SPIRIT_SHORT", val2=4, name=MSC.L["Purified Nightseye"], colorType="PURPLE" },
        { id=24067, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=9, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Royal Nightseye"], colorType="PURPLE" },
        { id=24068, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=8, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Balanced Nightseye"], colorType="PURPLE" },
        -- PvP / Ornate
        { id=32836, stat="ITEM_MOD_SPELL_POWER_SHORT", val=11, stat2="ITEM_MOD_SPIRIT_SHORT", val2=5, name=MSC.L["Purified Shadow Pearl"], colorType="PURPLE" },
        { id=35707, stat="ITEM_MOD_DODGE_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Regal Nightseye"], colorType="PURPLE" },
    },

    GREEN_P1 = {
        { id=24069, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Enduring Talasite"], colorType="GREEN" },
        { id=24070, stat="ITEM_MOD_INTELLECT_SHORT", val=4, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name=MSC.L["Dazzling Talasite"], colorType="GREEN" },
        { id=24071, stat="ITEM_MOD_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Jagged Talasite"], colorType="GREEN" },
        { id=24072, stat="ITEM_MOD_HIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Vivid Talasite"], colorType="GREEN" },
        -- Misc
        { id=33782, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Steady Talasite"], colorType="GREEN" },
    },

    META_P1 = {
        { id=32409, stat="ITEM_MOD_AGILITY_SHORT", val=12, name=MSC.L["Relentless Earthstorm"], isMeta=true, colorType="META" }, 
        { id=34220, stat="ITEM_MOD_CRIT_RATING_SHORT", val=12, name=MSC.L["Chaotic Skyfire"], isMeta=true, colorType="META" }, 
        { id=25893, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=0, name=MSC.L["Mystical Skyfire"], isMeta=true, colorType="META" }, 
        { id=25896, stat="ITEM_MOD_STAMINA_SHORT", val=18, name=MSC.L["Powerful Earthstorm"], isMeta=true, colorType="META" }, 
        { id=25899, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=24, name=MSC.L["Brutal Earthstorm"], isMeta=true, colorType="META" }, 
        { id=25901, stat="ITEM_MOD_INTELLECT_SHORT", val=12, name=MSC.L["Insightful Earthstorm"], isMeta=true, colorType="META" }, 
        { id=25890, stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=3, name=MSC.L["Destructive Skyfire"], isMeta=true, colorType="META" }, 
        { id=25894, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=12, name=MSC.L["Swift Starfire"], isMeta=true, colorType="META" }, 
        { id=25897, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=26, name=MSC.L["Bracing Earthstorm"], isMeta=true, colorType="META" }, 
    },

   -- ========================================================================
   -- [[ PHASE 3: HYJAL / BLACK TEMPLE (EPIC DROPS) ]]
   -- ========================================================================
    RED_P3 = {
        { id=32193, stat="ITEM_MOD_STRENGTH_SHORT", val=10, name=MSC.L["Bold Crimson Spinel"], colorType="RED" },
        { id=32194, stat="ITEM_MOD_AGILITY_SHORT", val=10, name=MSC.L["Delicate Crimson Spinel"], colorType="RED" },
        { id=32196, stat="ITEM_MOD_SPELL_POWER_SHORT", val=12, name=MSC.L["Runed Crimson Spinel"], colorType="RED" },
        { id=32195, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=22, name=MSC.L["Teardrop Crimson Spinel"], colorType="RED" },
    },
    BLUE_P3 = {
        { id=32200, stat="ITEM_MOD_STAMINA_SHORT", val=15, name=MSC.L["Solid Empyrean Sapphire"], colorType="BLUE" },
        { id=32201, stat="ITEM_MOD_SPIRIT_SHORT", val=10, name=MSC.L["Sparkling Empyrean Sapphire"], colorType="BLUE" },
        { id=35318, stat="ITEM_MOD_SPELL_PENETRATION_SHORT", val=13, name=MSC.L["Stormy Empyrean Sapphire"], colorType="BLUE" },
    },
    YELLOW_P3 = {
        { id=32204, stat="ITEM_MOD_INTELLECT_SHORT", val=10, name=MSC.L["Brilliant Lionseye"], colorType="YELLOW" },
        { id=32205, stat="ITEM_MOD_CRIT_RATING_SHORT", val=10, name=MSC.L["Smooth Lionseye"], colorType="YELLOW" },
        { id=32206, stat="ITEM_MOD_HIT_RATING_SHORT", val=10, name=MSC.L["Rigid Lionseye"], colorType="YELLOW" },
        { id=32208, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=10, name=MSC.L["Thick Lionseye"], colorType="YELLOW" },
        { id=32209, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=10, name=MSC.L["Mystic Lionseye"], colorType="YELLOW" },
        { id=32210, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=10, name=MSC.L["Great Lionseye"], colorType="YELLOW" },
    },
    ORANGE_P3 = {
        { id=32217, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=5, name=MSC.L["Inscribed Pyrestone"], colorType="ORANGE" },
        { id=32218, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val2=5, name=MSC.L["Potent Pyrestone"], colorType="ORANGE" },
        { id=32219, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_INTELLECT_SHORT", val2=5, name=MSC.L["Luminous Pyrestone"], colorType="ORANGE" },
        { id=32220, stat="ITEM_MOD_AGILITY_SHORT", val=5, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=5, name=MSC.L["Glinting Pyrestone"], colorType="ORANGE" },
        { id=32221, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_HIT_SPELL_RATING_SHORT", val2=5, name=MSC.L["Veiled Pyrestone"], colorType="ORANGE" },
        { id=32222, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=5, name=MSC.L["Wicked Pyrestone"], colorType="ORANGE" },
    },
    PURPLE_P3 = {
        { id=32211, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name=MSC.L["Sovereign Shadowsong Amethyst"], colorType="PURPLE" },
        { id=32212, stat="ITEM_MOD_AGILITY_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name=MSC.L["Shifting Shadowsong Amethyst"], colorType="PURPLE" },
        { id=32215, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name=MSC.L["Glowing Shadowsong Amethyst"], colorType="PURPLE" },
        { id=32216, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_SPIRIT_SHORT", val2=5, name=MSC.L["Royal Shadowsong Amethyst"], colorType="PURPLE" },
        { id=37503, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name=MSC.L["Purified Shadowsong Amethyst"], colorType="PURPLE" },
    },
    GREEN_P3 = {
        { id=32223, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name=MSC.L["Enduring Seaspray Emerald"], colorType="GREEN" },
        { id=32226, stat="ITEM_MOD_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name=MSC.L["Jagged Seaspray Emerald"], colorType="GREEN" },
    },

   -- ========================================================================
   -- [[ PHASE 5: SUNWELL (JC UNIQUES, HASTE/ARP, & NEW METAS) ]]
   -- ========================================================================
    RED_P5 = {
        -- Jewelcrafter Unique (BoP)
        { id=33131, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=24, name=MSC.L["Crimson Sun"], colorType="RED", unique=true },
        { id=33133, stat="ITEM_MOD_SPELL_POWER_SHORT", val=14, name=MSC.L["Don Julio's Heart"], colorType="RED", unique=true },
        { id=33134, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=26, name=MSC.L["Kailee's Rose"], colorType="RED", unique=true },
        { id=33130, stat="ITEM_MOD_STRENGTH_SHORT", val=12, name=MSC.L["Don Amancio's Heart"], colorType="RED", unique=true },
        { id=33132, stat="ITEM_MOD_AGILITY_SHORT", val=12, name=MSC.L["Delicate Fire Ruby"], colorType="RED", unique=true },
    },
    BLUE_P5 = {
        -- Jewelcrafter Unique (BoP)
        { id=33135, stat="ITEM_MOD_STAMINA_SHORT", val=18, name=MSC.L["Falling Star"], colorType="BLUE", unique=true },
        { id=33137, stat="ITEM_MOD_SPIRIT_SHORT", val=12, name=MSC.L["Sparkling Falling Star"], colorType="BLUE", unique=true },
        { id=33136, stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=6, name=MSC.L["Lustrous Falling Star"], colorType="BLUE", unique=true },
        { id=33145, stat="ITEM_MOD_SPELL_PENETRATION_SHORT", val=15, name=MSC.L["Stormy Falling Star"], colorType="BLUE", unique=true },
    },
    YELLOW_P5 = {
        -- Jewelcrafter Unique (BoP)
        { id=33140, stat="ITEM_MOD_CRIT_RATING_SHORT", val=12, name=MSC.L["Blood of Amber"], colorType="YELLOW", unique=true },
        { id=33143, stat="ITEM_MOD_CRIT_RATING_SHORT", val=12, name=MSC.L["Stone of Blades"], colorType="YELLOW", unique=true },
        { id=33139, stat="ITEM_MOD_INTELLECT_SHORT", val=12, name=MSC.L["Brilliant Bladestone"], colorType="YELLOW", unique=true },
        { id=33141, stat="ITEM_MOD_HIT_RATING_SHORT", val=12, name=MSC.L["Great Bladestone"], colorType="YELLOW", unique=true },
        { id=33142, stat="ITEM_MOD_HIT_RATING_SHORT", val=12, name=MSC.L["Rigid Bladestone"], colorType="YELLOW", unique=true },
        { id=33138, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=12, name=MSC.L["Mystic Bladestone"], colorType="YELLOW", unique=true },
        { id=33144, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=12, name=MSC.L["Facet of Eternity"], colorType="YELLOW", unique=true },
        -- Haste
        { id=35761, stat="ITEM_MOD_HASTE_RATING_SHORT", val=10, name=MSC.L["Quick Lionseye"], colorType="YELLOW" },
    },
    ORANGE_P5 = {
        -- Haste
        { id=35760, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_HASTE_RATING_SHORT", val2=5, name=MSC.L["Reckless Pyrestone"], colorType="ORANGE" },
        -- Heroic Dungeon Epics (Unique-Equipped)
        { id=30547, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_INTELLECT_SHORT", val2=5, name=MSC.L["Luminous Fire Opal"], colorType="ORANGE" },
        { id=30556, stat="ITEM_MOD_AGILITY_SHORT", val=5, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=4, name=MSC.L["Glinting Fire Opal"], colorType="ORANGE" },
        { id=30559, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=4, name=MSC.L["Etched Fire Opal"], colorType="ORANGE" },
        { id=30564, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_HIT_SPELL_RATING_SHORT", val2=5, name=MSC.L["Shining Fire Opal"], colorType="ORANGE" },
        { id=30582, stat="ITEM_MOD_AGILITY_SHORT", val=5, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=4, name=MSC.L["Deadly Fire Opal"], colorType="ORANGE" },
        { id=30588, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val2=4, name=MSC.L["Potent Fire Opal"], colorType="ORANGE" },
        { id=30593, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val2=4, name=MSC.L["Iridescent Fire Opal"], colorType="ORANGE" },
        { id=30604, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_RESILIENCE_RATING_SHORT", val2=4, name=MSC.L["Resplendent Fire Opal"], colorType="ORANGE" },
    },
    PURPLE_P5 = {
        -- Heroic Dungeon Epics (Unique-Equipped)
        { id=30546, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Sovereign Tanzanite"], colorType="PURPLE" },
        { id=30549, stat="ITEM_MOD_AGILITY_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Shifting Tanzanite"], colorType="PURPLE" },
        { id=30555, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Glowing Tanzanite"], colorType="PURPLE" },
        { id=30574, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Brutal Tanzanite"], colorType="PURPLE" },
        { id=30600, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_SPIRIT_SHORT", val2=4, name=MSC.L["Fluorescent Tanzanite"], colorType="PURPLE" },
        { id=30603, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name=MSC.L["Royal Tanzanite"], colorType="PURPLE" },
    },
    GREEN_P5 = {
        -- Haste
        { id=35758, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name=MSC.L["Steady Seaspray Emerald"], colorType="GREEN" },
        { id=35759, stat="ITEM_MOD_HASTE_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name=MSC.L["Forceful Seaspray Emerald"], colorType="GREEN" },
        -- Heroic Dungeon Epics (Unique-Equipped)
        { id=30550, stat="ITEM_MOD_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name=MSC.L["Sundered Chrysoprase"], colorType="GREEN" },
        { id=30602, stat="ITEM_MOD_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Jagged Chrysoprase"], colorType="GREEN" },
        { id=30605, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name=MSC.L["Vivid Chrysoprase"], colorType="GREEN" },
        { id=30606, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=5, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name=MSC.L["Lambent Chrysoprase"], colorType="GREEN" },
    },
    META_P5 = {
        { id=35501, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=12, name=MSC.L["Eternal Earthstorm"], isMeta=true, colorType="META" }, 
    },

    -- [[ 2. LEVELING (UNCOMMON / GREEN QUALITY) ]]
    -- [[ FIXED IDS (Range 23094 - 23121) ]]
    LEVELING_RED = {
        { id=23095, stat="ITEM_MOD_STRENGTH_SHORT", val=6, name=MSC.L["Bold Blood Garnet"], colorType="RED" },
        { id=23096, stat="ITEM_MOD_AGILITY_SHORT", val=6, name=MSC.L["Delicate Blood Garnet"], colorType="RED" },
        { id=23097, stat="ITEM_MOD_SPELL_POWER_SHORT", val=7, name=MSC.L["Runed Blood Garnet"], colorType="RED" },
        -- Bright Blood Garnet is ID 28595, outside the block
        { id=28595, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=12, name=MSC.L["Bright Blood Garnet"], colorType="RED" }, 
        { id=23094, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=14, name=MSC.L["Teardrop Blood Garnet"], colorType="RED" },
    },

    LEVELING_BLUE = {
        { id=23118, stat="ITEM_MOD_STAMINA_SHORT", val=9, name=MSC.L["Solid Azure Moonstone"], colorType="BLUE" }, -- Fixed
        { id=23119, stat="ITEM_MOD_SPIRIT_SHORT", val=6, name=MSC.L["Sparkling Azure Moonstone"], colorType="BLUE" }, -- Fixed
        { id=23121, stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=2, name=MSC.L["Lustrous Azure Moonstone"], colorType="BLUE" }, -- Fixed
        { id=23120, stat="ITEM_MOD_SPELL_PENETRATION_SHORT", val=8, name=MSC.L["Stormy Azure Moonstone"], colorType="BLUE" }, -- Fixed
    },

    LEVELING_YELLOW = {
        { id=23116, stat="ITEM_MOD_HIT_RATING_SHORT", val=6, name=MSC.L["Rigid Golden Draenite"], colorType="YELLOW" }, -- Fixed
        { id=23112, stat="ITEM_MOD_CRIT_RATING_SHORT", val=6, name=MSC.L["Smooth Golden Draenite"], colorType="YELLOW" }, -- Smooth is often Base? No, 23112 is base in some lists. Let's use 23112 if verified or closest match.
        { id=23113, stat="ITEM_MOD_INTELLECT_SHORT", val=6, name=MSC.L["Brilliant Golden Draenite"], colorType="YELLOW" }, -- Fixed
        { id=23115, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=6, name=MSC.L["Thick Golden Draenite"], colorType="YELLOW" }, -- Fixed
        { id=23114, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=6, name=MSC.L["Gleaming Golden Draenite"], colorType="YELLOW" }, -- Fixed
    },

    LEVELING_ORANGE = {
        { id=23098, stat="ITEM_MOD_STRENGTH_SHORT", val=3, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=3, name=MSC.L["Inscribed Flame Spessarite"], colorType="ORANGE" }, -- Fixed
        { id=23100, stat="ITEM_MOD_AGILITY_SHORT", val=3, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=3, name=MSC.L["Glinting Flame Spessarite"], colorType="ORANGE" }, -- Fixed
        { id=23101, stat="ITEM_MOD_SPELL_POWER_SHORT", val=4, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val2=3, name=MSC.L["Potent Flame Spessarite"], colorType="ORANGE" }, -- Fixed
        { id=23102, stat="ITEM_MOD_SPELL_POWER_SHORT", val=4, stat2="ITEM_MOD_HIT_SPELL_RATING_SHORT", val2=3, name=MSC.L["Veiled Flame Spessarite"], colorType="ORANGE" }, -- Fixed
        { id=23099, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=7, stat2="ITEM_MOD_INTELLECT_SHORT", val2=3, name=MSC.L["Luminous Flame Spessarite"], colorType="ORANGE" }, -- Fixed
    },

    LEVELING_PURPLE = {
        { id=23111, stat="ITEM_MOD_STRENGTH_SHORT", val=3, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name=MSC.L["Sovereign Shadow Draenite"], colorType="PURPLE" }, -- Fixed
        { id=23110, stat="ITEM_MOD_AGILITY_SHORT", val=3, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name=MSC.L["Shifting Shadow Draenite"], colorType="PURPLE" }, -- Fixed
        { id=23108, stat="ITEM_MOD_SPELL_POWER_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name=MSC.L["Glowing Shadow Draenite"], colorType="PURPLE" }, -- Fixed
        { id=23109, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=7, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name=MSC.L["Royal Shadow Draenite"], colorType="PURPLE" }, -- Fixed
        -- Purified/Balanced don't exist in the Launch Uncommon set (added later or Rare only)
    },

    LEVELING_GREEN = {
        { id=23105, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=3, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name=MSC.L["Enduring Deep Peridot"], colorType="GREEN" }, -- Fixed
        { id=23106, stat="ITEM_MOD_INTELLECT_SHORT", val=3, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=1, name=MSC.L["Dazzling Deep Peridot"], colorType="GREEN" }, -- Fixed
        { id=23104, stat="ITEM_MOD_CRIT_RATING_SHORT", val=3, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name=MSC.L["Jagged Deep Peridot"], colorType="GREEN" }, -- Fixed
        { id=23103, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=3, stat2="ITEM_MOD_SPELL_PENETRATION_SHORT", val2=4, name=MSC.L["Radiant Deep Peridot"], colorType="GREEN" }, -- Fixed
    }
}

-- [[ CONSTRUCT OPTIONS PROGRAMMATICALLY (TBC ONLY) ]]
    MSC.GemOptions = {
        EMPTY_SOCKET_RED = {},
        EMPTY_SOCKET_YELLOW = {},
        EMPTY_SOCKET_BLUE = {},
        EMPTY_SOCKET_META = {},
        PRISMATIC_GEMS = {} 
    }

    MSC.GemOptions_Leveling = {
        EMPTY_SOCKET_RED = {},
        EMPTY_SOCKET_YELLOW = {},
        EMPTY_SOCKET_BLUE = {},
        EMPTY_SOCKET_META = GEMS.META_P1, 
        PRISMATIC_GEMS = {} 
    }

    local function AddTo(targetList, sourceList)
        if not sourceList then return end
        for _, gem in ipairs(sourceList) do table.insert(targetList, gem) end
    end

    -- 1. POPULATE RED SOCKETS
    AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.RED_P1)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.RED_P3)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.RED_P5)
    
    AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.ORANGE_P1)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.ORANGE_P3)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.ORANGE_P5)
    
    AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.PURPLE_P1)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.PURPLE_P3)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.PURPLE_P5)
    
    AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.PRISMATIC_P1)

    -- 2. POPULATE YELLOW SOCKETS
    AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.YELLOW_P1)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.YELLOW_P3)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.YELLOW_P5)
    
    AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.ORANGE_P1)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.ORANGE_P3)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.ORANGE_P5)
    
    AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.GREEN_P1)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.GREEN_P3)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.GREEN_P5)
    
    AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.PRISMATIC_P1)

    -- 3. POPULATE BLUE SOCKETS
    AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.BLUE_P1)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.BLUE_P3)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.BLUE_P5)
    
    AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.PURPLE_P1)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.PURPLE_P3)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.PURPLE_P5)
    
    AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.GREEN_P1)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.GREEN_P3)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.GREEN_P5)
    
    AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.PRISMATIC_P1)
    
    -- 4. META & PRISMATIC
    AddTo(MSC.GemOptions.EMPTY_SOCKET_META, GEMS.META_P1)
    -- AddTo(MSC.GemOptions.EMPTY_SOCKET_META, GEMS.META_P5)
    
    AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.PRISMATIC_P1)
    
    -- POPULATE LEVELING (Green Gems)
    -- Fixed: Now includes Orange/Purple/Green for leveling sockets
    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_RED, GEMS.LEVELING_RED)
    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_RED, GEMS.LEVELING_ORANGE)
    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_RED, GEMS.LEVELING_PURPLE)

    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_YELLOW, GEMS.LEVELING_YELLOW)
    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_YELLOW, GEMS.LEVELING_ORANGE)
    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_YELLOW, GEMS.LEVELING_GREEN)

    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_BLUE, GEMS.LEVELING_BLUE)
    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_BLUE, GEMS.LEVELING_PURPLE)
    AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_BLUE, GEMS.LEVELING_GREEN)

    -- Prismatic Lists
    -- (Prismatic sockets accept all colors, but usually we just check the pure stats)
    -- AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.RED_P1)
    -- AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.BLUE_P1)
    -- AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.YELLOW_P1)
    -- AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.ORANGE_P1) 
    -- AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.PURPLE_P1)
    -- AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.GREEN_P1)

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
MSC.ItemOverrides = MSC.ItemOverrides or {}
MSC.TrinketDB = MSC.TrinketDB or {}

-- This function feeds BOTH the Math Engine and the Tooltip Notes!
local function AddOverrides(db)
    for itemID, data in pairs(db) do
        data.estimate = true -- Forces the addon to apply our math!
        MSC.ItemOverrides[itemID] = data
        MSC.TrinketDB[itemID] = data
    end
end

AddOverrides({
    -- [[ JEWELCRAFTING FIGURINES ]]
    [24126] = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 32, _AUTO_PROC = { stat="ITEM_MOD_DODGE_RATING_SHORT", val=21 }, note = MSC.L["Use: 21 Avg Dodge (based on uptime)"] },
    [24124] = { ITEM_MOD_INTELLECT_SHORT = 14, _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=15 }, note = MSC.L["Use: Mana restore avg to ~15 mp5"] },
    [24125] = { ITEM_MOD_INTELLECT_SHORT = 33, _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=25 }, note = MSC.L["Use: 25 Avg SP (based on uptime)"] },
    [24128] = { ITEM_MOD_STAMINA_SHORT = 18, _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=55 }, note = MSC.L["Use: 55 Avg AP (based on uptime)"] },
    [24129] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=60 }, note = MSC.L["Use: 60 Avg AP + Pet Heal utility"] },
    [24127] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=45 }, note = MSC.L["Use: 45 Avg AP + Pet Heal utility"] },
    [24123] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=34 }, note = MSC.L["Use: ~34 Avg SP"] },
    [35702] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=46 }, note = MSC.L["Use: 46 Avg AP (Defensive)"] },
    [35700] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=46 }, note = MSC.L["Use: ~23 mp5"] },
    [35693] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=46 }, note = MSC.L["Use: 80 Avg AP"] },
    [35694] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=46 }, note = MSC.L["Use: Avg Summon Dmg"] },
    [25829] = { ITEM_MOD_INTELLECT_SHORT = 25, _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=21 }, note = MSC.L["Use: 21 Avg SP"] },

    -- [[ QUEST REWARDS - PRE-RAID ]]
    [28041] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=33.3 }, note = MSC.L["Use: 33 Avg AP"] },
    [28040] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=20 }, note = MSC.L["Use: 20 Avg SP"] },
    [30300] = { _AUTO_PROC = { stat="ITEM_MOD_ARMOR_SHORT", val=150 }, note = MSC.L["Use: 150 Avg Armor"] },
    [25620] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=33.3 }, note = MSC.L["Use: 33 Avg SP"] }, -- Ancient Crystal Talisman
    [25619] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=33.3 }, note = MSC.L["Use: 33 Avg AP"] }, -- Ancient War Talisman
    [29370] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=22.5 }, note = MSC.L["Use: 22.5 Avg AP"] }, -- Terokkar Tablet Precision
    [29376] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=150 }, note = MSC.L["Use: HP valued flat"] },
    [29776] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=33.3 }, note = MSC.L["Use: 33 Avg SP"] }, -- Core of Ar'kelos
    [30340] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=33.3 }, note = MSC.L["Use: 33 Avg AP"] }, -- Starkiller's
    [30348] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=23 }, note = MSC.L["Use: 23 Avg SP"] }, -- Heavenly Inspiration
    [25633] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=29 }, note = MSC.L["Use: 29 Avg AP"] }, -- Uniting Charm (Fixed: AP)
    [25634] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=43 }, note = MSC.L["Use: 43 Avg HSP"] }, -- Ocarina (Fixed: Added Healing Version)
    [25628] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=30 }, note = MSC.L["Use: 30 Avg AP"] },
    [32658] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=200 }, note = MSC.L["Use: HP valued flat"] },
    [30351] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=12 }, note = MSC.L["Use: ~12 mp5"] },
    [30345] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=14 }, note = MSC.L["Use: ~14 Avg SP"] },
    [25937] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10 }, note = MSC.L["Use: 10 Avg AP (3.3% Uptime)"] },
    [27924] = { _AUTO_PROC = { stat="ITEM_MOD_STAMINA_SHORT", val=15 }, note = MSC.L["Use: Heal Valued as flat Stam"] },
    [29179] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=25 }, note = MSC.L["Use: 25 Avg SP"] },
    [29180] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=39 }, note = MSC.L["Use: 39 Avg HSP"] },

    -- [[ BADGE OF JUSTICE / REPUTATION ]]
    [29384] = { ITEM_MOD_ATTACK_POWER_SHORT = 72, _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=46.3 }, note = MSC.L["Use: 46 Avg AP"] },
    [29305] = { ITEM_MOD_SPELL_POWER_SHORT = 43, _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=25.8 }, note = MSC.L["Use: 26 Avg SP"] },
    [38287] = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 35, _AUTO_PROC = { stat="ITEM_MOD_DODGE_RATING_SHORT", val=20 }, note = MSC.L["Use: 20 Avg Dodge"] },
    [29181] = { _AUTO_PROC = { stat="ITEM_MOD_DODGE_RATING_SHORT", val=20 }, note = MSC.L["Use: Aggro reduction utility"] },
    [32654] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=35 }, note = MSC.L["Use: Heal"] },
    [30841] = { _AUTO_PROC = { stat="ITEM_MOD_AGILITY_SHORT", val=46.6 }, note = MSC.L["Use: 46.6 Avg Agi"] },
    [32864] = { ITEM_MOD_STAMINA_SHORT = 45, note = MSC.L["Proc: ~100 Avg Dodge (High Uptime)"] },

    -- [[ DUNGEON DROPS ]]
    [27891] = { _AUTO_PROC = { stat="ITEM_MOD_ARMOR_SHORT", val=216 }, note = MSC.L["Use: 216 Avg Armor"] },
    [28121] = { _AUTO_PROC = { stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", val=100 }, note = MSC.L["Use: 600 ArP (Avg 100)"] },
    [24390] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=22 }, note = MSC.L["Use: 22 Avg SP"] },
    [27416] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=25 }, note = MSC.L["Use: 25 Avg SP"] },
    [26055] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=16.6 }, note = MSC.L["Use: 16.6 Avg SP"] },
    [25786] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=16.6 }, note = MSC.L["Use: 16.6 Avg SP"] },
    [25936] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=25 }, note = MSC.L["Use: 25 Avg SP"] },
    [24376] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=100 }, note = MSC.L["Use: Absorb valued as Health"] },
    [27529] = { _AUTO_PROC = { stat="ITEM_MOD_BLOCK_VALUE_SHORT", val=15 }, note = MSC.L["Use: Heal avg to 15 BV"] },
    [27683] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=38 }, note = MSC.L["Proc: 38 Avg Haste"] },
    [28034] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=50 }, note = MSC.L["Proc: 50 Avg AP"] },
    [28288] = { _AUTO_PROC = { stat="ITEM_MOD_HASTE_RATING_SHORT", val=21.6 }, note = MSC.L["Use: 21 Avg Haste"] },
    [28726] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=38 }, note = MSC.L["Proc: 38 Avg Haste"] },
    [28370] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=15 }, note = MSC.L["Proc: ~15 mp5"] },
    [31617] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=58 }, note = MSC.L["Proc: 300 AP (Internal CD)"] },
    [28240] = { ITEM_MOD_STAMINA_SHORT = 45, note = MSC.L["Use: Absorb valued as Stam"] },
    [27770] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=19 }, note = MSC.L["Proc: ~19 Avg SP"] },
    [30542] = { _AUTO_PROC = { stat="ITEM_MOD_AGILITY_SHORT", val=14 }, note = MSC.L["Use: 14 Avg Agi"] },
    [28190] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=26.6 }, note = MSC.L["Proc: 160 Haste (15% spell proc) = ~26 Avg"] },

    -- [[ RAID DROPS: T4 (KARA/GRUUL/MAG) ]]
    [29383] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=25 }, note = MSC.L["Use: 25 Avg SP"] },
    [28727] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=21 }, note = MSC.L["Proc: ~21 mp5"] },
    [28579] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=65 }, note = MSC.L["Proc: ~65 Avg AP"] },
    [28830] = { ITEM_MOD_ATTACK_POWER_SHORT = 40, _AUTO_PROC = { stat="ITEM_MOD_HASTE_RATING_SHORT", val=108 }, note = MSC.L["Proc: 108 Avg Haste"] },
    [29132] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=49.5 }, note = MSC.L["Use: 49.5 Avg HSP"] },
    [28789] = { ITEM_MOD_SPELL_POWER_SHORT = 54, _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=28 }, note = MSC.L["Use: 170 SP"] },
    [28528] = { ITEM_MOD_DODGE_RATING_SHORT = 38, _AUTO_PROC = { stat="ITEM_MOD_DODGE_RATING_SHORT", val=50 }, note = MSC.L["Use: 300 Dodge"] },
    [28590] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 73, _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=22 }, note = MSC.L["Use: 22 Avg mp5"] },
    [28823] = { ITEM_MOD_MANA_REGENERATION_SHORT = 45, note = MSC.L["Proc: Chance to reduce mana cost avg to 45 mp5"] },
    [28766] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=55 }, note = MSC.L["Proc: Lightning Capacitor Dmg avg to 55 SP"] },

    -- [[ RAID DROPS: T5 (SSC/TK) ]]
    [29923] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=30 }, note = MSC.L["Proc: Rage/Energy gain avg to 30 AP"] },
    [30726] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=53 }, note = MSC.L["Use: 53 Avg AP"] },
    [30627] = { ITEM_MOD_CRIT_RATING_SHORT = 38, _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=68 }, note = MSC.L["Proc: 340 AP (10s duration)"] },
    [30665] = { _AUTO_PROC = { stat="ITEM_MOD_SPIRIT_SHORT", val=50 }, note = MSC.L["Use: 300 Spirit"] },
    [30620] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=22 }, note = MSC.L["Use: 130 SP"] },
    [30629] = { _AUTO_PROC = { stat="ITEM_MOD_DODGE_RATING_SHORT", val=40 }, note = MSC.L["Use: 145 Dodge"] },
    [30448] = { ITEM_MOD_STAMINA_SHORT = 57, _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=43 }, note = MSC.L["Proc: 130 SP"] },

    -- [[ RAID DROPS: T6 / ZA / SUNWELL ]]
    [32483] = { ITEM_MOD_SPELL_HASTE_RATING_SHORT = 25, ITEM_MOD_SPELL_POWER_SHORT = 54, _AUTO_PROC = { stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=29 }, note = MSC.L["Use: 175 Haste"] },
    [34429] = { ITEM_MOD_SPELL_POWER_SHORT = 54, _AUTO_PROC = { stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=53 }, note = MSC.L["Use: 320 Haste (Decaying)"] },
    [33829] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=35 }, note = MSC.L["Use: 211 SP"] },
    [33831] = { ITEM_MOD_ATTACK_POWER_SHORT = 90, _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=60 }, note = MSC.L["Use: 360 AP"] },
    [33830] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=43 }, note = MSC.L["Use: 260 Haste"] },
    [32694] = { ITEM_MOD_DODGE_RATING_SHORT = 40, note = MSC.L["Use: 1750 HP"] },
    [34428] = { ITEM_MOD_SPELL_POWER_SHORT = 54, _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=32 }, note = MSC.L["Use: 2000 Armor (Valued as defensive)"] },
    [34471] = { ITEM_MOD_STAMINA_SHORT = 57, note = MSC.L["Proc: 152 Dodge"] },
    [34430] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 119, _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=25 }, note = MSC.L["Use: Sustain"] },
    [34050] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=23 }, note = MSC.L["Use: ~23 Avg SP"] },
    [34579] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=22 }, note = MSC.L["Proc: ~22 Avg SP"] },
    [33828] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=49 }, note = MSC.L["Proc: Heal Stacks avg to 49 Heal"] },
    [34473] = { ITEM_MOD_STAMINA_SHORT = 57, _AUTO_PROC = { stat="ITEM_MOD_DODGE_RATING_SHORT", val=25 }, note = MSC.L["Proc: 152 Dodge for 10s (Low rate) = ~25 Avg"] },

    -- [[ LEGACY / CLASSIC ]]
    [11811] = { ITEM_MOD_SPELL_POWER_SHORT = 12, ITEM_MOD_INTELLECT_SHORT = 5, note = MSC.L["Passive: Resistances not valued"] },
    [11815] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=22 }, note = MSC.L["Proc: 1.33% Proc @ 70 (Nerfed in TBC)"] },
    [18820] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=29.1 }, note = MSC.L["Use: 29 Avg SP"] },
    [19950] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=34 }, note = MSC.L["Use: Decaying stacks avg to ~34 SP"] },
    [23035] = { ITEM_MOD_HIT_RATING_SHORT = 12.6, _AUTO_PROC = { stat="ITEM_MOD_HASTE_RATING_SHORT", val=16.6 }, note = MSC.L["Use: 16.6 Avg Haste"] },
    [23041] = { ITEM_MOD_ATTACK_POWER_SHORT = 64, _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=43.3 }, note = MSC.L["Use: 43 Avg AP"] },
    [22954] = { ITEM_MOD_CRIT_RATING_SHORT = 14, _AUTO_PROC = { stat="ITEM_MOD_HASTE_RATING_SHORT", val=33.3 }, note = MSC.L["Use: 33 Avg Haste"] },
    [21670] = { _AUTO_PROC = { stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", val=140 }, note = MSC.L["Proc: ArP"] },
    [19379] = { ITEM_MOD_SPELL_POWER_SHORT = 44, ITEM_MOD_SPELL_HIT_RATING_SHORT = 25.2, note = MSC.L["Passive: 25.2 Hit"] },
    [23046] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=21 }, note = MSC.L["Use: 130 SP"] },
    [23047] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=25 }, note = MSC.L["Use: 450 Heal (Decaying)"] },
    [23042] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=20 }, note = MSC.L["Use: 260 Def"] },
    [23040] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=20 }, note = MSC.L["Use: 235 Block"] },
    [23570] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=43 }, note = MSC.L["Use: AP (Stacking)"] },
    [21579] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=28 }, note = MSC.L["Proc: Dmg"] },
    [23558] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=100 }, note = MSC.L["Use: Absorb"] },
    [21647] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=75 }, note = MSC.L["Use: Threat Drop"] },
    [21625] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=15 }, note = MSC.L["Use: Heal/Shield"] },
    [21180] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=60 }, note = MSC.L["Use: 280 AP"] },
    [19339] = { _AUTO_PROC = { stat="ITEM_MOD_HASTE_RATING_SHORT", val=55 }, note = MSC.L["Use: 330 Haste"] },
    [19340] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=10 }, note = MSC.L["Use: Mana"] },
    [19341] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=30 }, note = MSC.L["Use: 1500 HP"] },
    [19342] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=20 }, note = MSC.L["Use: Poison Dmg"] },
    [19343] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=23 }, note = MSC.L["Use: 250 SP"] },
    [19344] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=30 }, note = MSC.L["Use: 250 SP (Hunter)"] },
    [19345] = { _AUTO_PROC = { stat="ITEM_MOD_DODGE_RATING_SHORT", val=20 }, note = MSC.L["Use: Heal"] },
    [13965] = { ITEM_MOD_CRIT_RATING_SHORT = 28, note = MSC.L["Passive: 2% Legacy Crit converts to 28 Rating"] },
    [13968] = { ITEM_MOD_SPELL_CRIT_RATING_SHORT = 28, note = MSC.L["Passive: 2% Legacy Spell Crit converts to 28 Rating"] },
    [19120] = { ITEM_MOD_ATTACK_POWER_SHORT = 15, note = MSC.L["Passive: Weighted average vs Undead/Demon"] },
    [13209] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10 }, note = MSC.L["Proc: Cannon dmg avg to ~10 AP"] },
    [17774] = { _AUTO_PROC = { stat="ITEM_MOD_ALL_STATS_SHORT", val=8.3 }, note = MSC.L["Proc: 25 Stats with ~33% uptime"] },
    [11810] = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 10, _AUTO_PROC = { stat="ITEM_MOD_STAMINA_SHORT", val=10 }, note = MSC.L["Proc: Dmg reduction value avg to Stam"] },
    [12930] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=15 }, note = MSC.L["Passive: 29 SP"] },
    [22678] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=12 }, note = MSC.L["Use: Dmg/Heal"] },

    -- [[ DARKMOON / SPECIAL ]]
    [31856] = { ITEM_MOD_ATTACK_POWER_SHORT = 120, ITEM_MOD_SPELL_POWER_SHORT = 80, note = MSC.L["Passive: Max Stacks (120 AP / 80 SP)"] },
    [31858] = { ITEM_MOD_STAMINA_SHORT = 51, _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10 }, note = MSC.L["Proc: Holy Dmg avg to ~10 AP"] },
    [31857] = { ITEM_MOD_STAMINA_SHORT = 51, note = MSC.L["Passive: 51 Stamina Base"] },
    [19288] = { ITEM_MOD_MANA_REGENERATION_SHORT = 60, note = MSC.L["Proc: 100% Regen (Blue Dragon) avg to 60mp5"] },
    [19491] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=20 }, note = MSC.L["Use: SP"] },

    -- [[ UTILITY / ENGINEERING / BREWFEST ]]
    [24096] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=36.6 }, note = MSC.L["Use: 36.6 Avg AP"] },
    [24460] = { _AUTO_PROC = { stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=24 }, note = MSC.L["Use: Health valued as Defense"] },
    [28134] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=23 }, note = MSC.L["Use: ~23 Avg SP"] },
    [32770] = { ITEM_MOD_STAMINA_SHORT = 35, _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=100 }, note = MSC.L["Use: 1000 HP (Shared CD)"] },
    [32771] = { ITEM_MOD_CRIT_RATING_SHORT = 24, _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=30 }, note = MSC.L["Use: 30 Avg AP"] },
    [23836] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10 }, note = MSC.L["Use: Stun/Dmg utility"] },
    [23835] = { _AUTO_PROC = { stat="ITEM_MOD_HASTE_RATING_SHORT", val=20 }, note = MSC.L["Use: Haste"] },
    [32695] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=30 }, note = MSC.L["Use: HP"] },
    [37220] = { _AUTO_PROC = { stat="ITEM_MOD_BLOCK_VALUE_SHORT", val=20 }, note = MSC.L["Use: Avg 20 BV"] },
    [37128] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=30 }, note = MSC.L["Use: 30 Avg AP"] },
    [37127] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=45 }, note = MSC.L["Use: 265 Heal"] },
    [37129] = { _AUTO_PROC = { stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=30 }, note = MSC.L["Use: Shield"] },
    [37195] = { _AUTO_PROC = { stat="ITEM_MOD_BLOCK_VALUE_SHORT", val=20 }, note = MSC.L["Use: Block value avg to 20"] },
    [10645] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=50 }, note = MSC.L["Use: Dmg"] },
    [10725] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=50 }, note = MSC.L["Use: Pet"] },
    [10577] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=50 }, note = MSC.L["Use: Poly"] },

    -- [[ WEAPONS & CHAMPION ]]
    [11684] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=30 }, note = MSC.L["Proc: Extra Swing value avg to 30 AP"] },
    [9449]  = { _AUTO_PROC = { stat="ITEM_MOD_HASTE_RATING_SHORT", val=150 }, note = MSC.L["Use: 50% Haste - Burst Value"] },
    [8345]  = { _AUTO_PROC = { stat="ITEM_MOD_FERAL_ATTACK_POWER_SHORT", val=80 }, note = MSC.L["Powershift: Energy Refund valued as 80 AP"] },
    [23207] = { ITEM_MOD_SPELL_POWER_SHORT = 85, note = MSC.L["Passive: 85 SP vs Demon/Undead"] },
    [23206] = { ITEM_MOD_ATTACK_POWER_SHORT = 150, note = MSC.L["Passive: 150 AP vs Demon/Undead"] },
})

-- [[ PVP UTILITY OVERRIDES ]]
local function AddPvPTrinkets()
    local pvpIDs = {18854, 18856, 18849, 18851, 18852, 18853, 18850, 18846, 18834, 18845, 18841, 18839, 18832, 18835, 18837, 18838}
    for _, id in ipairs(pvpIDs) do
        -- Wrap the note here:
        MSC.ItemOverrides[id] = { MSC_PVP_UTILITY = 60, estimate = true, note = MSC.L["CC Break (Rank 1)"] }
        MSC.TrinketDB[id] = MSC.ItemOverrides[id]
    end
    
    -- Wrap the note here:
    local r2 = { MSC_PVP_UTILITY = 80, estimate = true, note = MSC.L["CC Break (Rank 2)"] }
    MSC.ItemOverrides[28234] = r2; MSC.TrinketDB[28234] = r2
    MSC.ItemOverrides[28235] = r2; MSC.TrinketDB[28235] = r2
    
    -- Wrap the note here:
    local r3 = { MSC_PVP_UTILITY = 100, estimate = true, note = MSC.L["CC Break (Rank 3)"] }
    MSC.ItemOverrides[37864] = r3; MSC.TrinketDB[37864] = r3
    MSC.ItemOverrides[37865] = r3; MSC.TrinketDB[37865] = r3
end
AddPvPTrinkets()


-- ============================================================================
-- 5. INITIALIZATION STRUCTURE
-- ============================================================================
if MSC.ProcDB then
    for itemID, procData in pairs(MSC.ProcDB) do
        if not MSC.ItemOverrides[itemID] then
            local newEntry = {
                _AUTO_PROC = {
                    stat = procData.stat,
                    val = procData.val,
                    ppm = procData.ppm,
                    dur = procData.dur
                },
                note = procData.note or MSC.L["Proc Estimate"]
            }
            
            for k, v in pairs(procData) do
                if k ~= "ppm" and k ~= "val" and k ~= "dur" and k ~= "stat" and k ~= "note" and k ~= "score" then
                    newEntry[k] = v
                end
            end

            if procData._AUTO_PROC then
                newEntry = procData
            end
            newEntry.estimate = true
            MSC.ItemOverrides[itemID] = newEntry
            MSC.TrinketDB[itemID] = newEntry
        end
    end
end

-- We define these here, but Data_Sets.lua populates them.
if not MSC.ItemSetMap then MSC.ItemSetMap = {} end
MSC.SetNameToID = {}
MSC.RawSetData = {} -- Deprecated, but kept to prevent nil errors if referenced elsewhere

function MSC:GetSetBonusDefinition(setID, count)
    if MSC.SetBonusScores and MSC.SetBonusScores[setID] and MSC.SetBonusScores[setID][count] then
        return MSC.SetBonusScores[setID][count]
    end
    return nil
end

-- ============================================================================
-- 6. SCALAR TABLES (The Truth Data)
-- ============================================================================

-- [[ 1. COMBAT RATINGS ]]
-- Amount of Rating needed for 1% Stat (or 1 Skill) at a given level.
-- Order: { WepS, Def, Dodge, Parry, Block, Hit, Crit, Haste, SpellHit, SpellCrit, SpellHaste, Resil }
MSC.CombatRatingScalars = {
    [70] = { 3.94, 2.37, 18.92, 31.54, 7.88, 15.77, 22.08, 15.77, 12.62, 22.08, 15.77, 39.42 },
    [69] = { 3.73, 2.24, 17.89, 29.82, 7.45, 14.91, 20.87, 14.91, 11.93, 20.87, 14.91, 37.27 },
    [68] = { 3.53, 2.12, 16.97, 28.28, 7.07, 14.14, 19.79, 14.14, 11.31, 19.79, 14.14, 35.34 },
    [67] = { 3.36, 2.02, 16.13, 26.89, 6.72, 13.44, 18.82, 13.44, 10.75, 18.82, 13.44, 33.61 },
    [66] = { 3.20, 1.92, 15.38, 25.63, 6.41, 12.81, 17.94, 12.81, 10.25, 17.94, 12.81, 32.03 },
    [65] = { 3.06, 1.84, 14.69, 24.48, 6.12, 12.24, 17.13, 12.24, 9.79,  17.13, 12.24, 30.60 },
    [64] = { 2.93, 1.76, 14.06, 23.43, 5.86, 11.71, 16.40, 11.71, 9.37,  16.40, 11.71, 29.29 },
    [63] = { 2.81, 1.68, 13.48, 22.47, 5.62, 11.23, 15.73, 11.23, 8.99,  15.73, 11.23, 28.08 },
    [62] = { 2.70, 1.62, 12.95, 21.58, 5.39, 10.79, 15.11, 10.79, 8.63,  15.11, 10.79, 26.97 },
    [61] = { 2.59, 1.56, 12.46, 20.76, 5.19, 10.38, 14.53, 10.38, 8.30,  14.53, 10.38, 25.95 },
    [60] = { 2.50, 1.50, 12.00, 20.00, 5.00, 10.00, 14.00, 10.00, 8.00,  14.00, 10.00, 25.00 },
    [59] = { 2.45, 1.47, 11.77, 19.62, 4.90, 9.81,  13.73, 9.81,  7.85,  13.73, 9.81,  24.52 },
    [58] = { 2.40, 1.44, 11.54, 19.23, 4.81, 9.62,  13.46, 9.62,  7.69,  13.46, 9.62,  24.04 },
    [57] = { 2.36, 1.41, 11.31, 18.85, 4.71, 9.42,  13.19, 9.42,  7.54,  13.19, 9.42,  23.56 },
    [56] = { 2.31, 1.38, 11.08, 18.46, 4.62, 9.23,  12.92, 9.23,  7.38,  12.92, 9.23,  23.08 },
    [55] = { 2.26, 1.36, 10.85, 18.08, 4.52, 9.04,  12.65, 9.04,  7.23,  12.65, 9.04,  22.60 },
    [54] = { 2.21, 1.33, 10.62, 17.69, 4.42, 8.85,  12.38, 8.85,  7.08,  12.38, 8.85,  22.12 },
    [53] = { 2.16, 1.30, 10.38, 17.31, 4.33, 8.65,  12.12, 8.65,  6.92,  12.12, 8.65,  21.63 },
    [52] = { 2.12, 1.27, 10.15, 16.92, 4.23, 8.46,  11.85, 8.46,  6.77,  11.85, 8.46,  21.15 },
    [51] = { 2.07, 1.24, 9.92,  16.54, 4.13, 8.27,  11.58, 8.27,  6.62,  11.58, 8.27,  20.67 },
    [50] = { 2.02, 1.21, 9.69,  16.15, 4.04, 8.08,  11.31, 8.08,  6.46,  11.31, 8.08,  20.19 },
    [49] = { 1.97, 1.18, 9.46,  15.77, 3.94, 7.88,  11.04, 7.88,  6.31,  11.04, 7.88,  19.71 },
    [48] = { 1.92, 1.15, 9.23,  15.38, 3.85, 7.69,  10.77, 7.69,  6.15,  10.77, 7.69,  19.23 },
    [47] = { 1.88, 1.13, 9.00,  15.00, 3.75, 7.50,  10.50, 7.50,  6.00,  10.50, 7.50,  18.75 },
    [46] = { 1.83, 1.10, 8.77,  14.62, 3.65, 7.31,  10.23, 7.31,  5.85,  10.23, 7.31,  18.27 },
    [45] = { 1.78, 1.07, 8.54,  14.23, 3.56, 7.12,  9.96,  7.12,  5.69,  9.96,  7.12,  17.79 },
    [44] = { 1.73, 1.04, 8.31,  13.85, 3.46, 6.92,  9.69,  6.92,  5.54,  9.69,  6.92,  17.31 },
    [43] = { 1.68, 1.01, 8.08,  13.46, 3.37, 6.73,  9.42,  6.73,  5.38,  9.42,  6.73,  16.83 },
    [42] = { 1.63, 0.98, 7.85,  13.08, 3.27, 6.54,  9.15,  6.54,  5.23,  9.15,  6.54,  16.35 },
    [41] = { 1.59, 0.95, 7.62,  12.69, 3.17, 6.35,  8.88,  6.35,  5.08,  8.88,  6.35,  15.87 },
    [40] = { 1.54, 0.92, 7.38,  12.31, 3.08, 6.15,  8.62,  6.15,  4.92,  8.62,  6.15,  15.38 },
    [39] = { 1.49, 0.89, 7.15,  11.92, 2.98, 5.96,  8.35,  5.96,  4.77,  8.35,  5.96,  14.90 },
    [38] = { 1.44, 0.87, 6.92,  11.54, 2.88, 5.77,  8.08,  5.77,  4.62,  8.08,  5.77,  14.42 },
    [37] = { 1.39, 0.84, 6.69,  11.15, 2.79, 5.58,  7.81,  5.58,  4.46,  7.81,  5.58,  13.94 },
    [36] = { 1.35, 0.81, 6.46,  10.77, 2.69, 5.38,  7.54,  5.38,  4.31,  7.54,  5.38,  13.46 },
    [35] = { 1.30, 0.78, 6.23,  10.38, 2.60, 5.19,  7.27,  5.19,  4.15,  7.27,  5.19,  12.98 },
    [34] = { 1.25, 0.75, 6.00,  10.00, 2.50, 5.00,  7.00,  5.00,  4.00,  7.00,  5.00,  12.50 },
    [33] = { 1.20, 0.72, 5.77,  9.62,  2.40, 4.81,  6.73,  4.81,  3.85,  6.73,  4.81,  12.02 },
    [32] = { 1.15, 0.69, 5.54,  9.23,  2.31, 4.62,  6.46,  4.62,  3.69,  6.46,  4.62,  11.54 },
    [31] = { 1.11, 0.66, 5.31,  8.85,  2.21, 4.42,  6.19,  4.42,  3.54,  6.19,  4.42,  11.06 },
    [30] = { 1.06, 0.63, 5.08,  8.46,  2.12, 4.23,  5.92,  4.23,  3.38,  5.92,  4.23,  10.58 },
    [29] = { 1.01, 0.61, 4.85,  8.08,  2.02, 4.04,  5.65,  4.04,  3.23,  5.65,  4.04,  10.10 },
    [28] = { 0.96, 0.58, 4.62,  7.69,  1.92, 3.85,  5.38,  3.85,  3.08,  5.38,  3.85,  9.62 },
    [27] = { 0.91, 0.55, 4.38,  7.31,  1.83, 3.65,  5.12,  3.65,  2.92,  5.12,  3.65,  9.13 },
    [26] = { 0.87, 0.52, 4.15,  6.92,  1.73, 3.46,  4.85,  3.46,  2.77,  4.85,  3.46,  8.65 },
    [25] = { 0.82, 0.49, 3.92,  6.54,  1.63, 3.27,  4.58,  3.27,  2.62,  4.58,  3.27,  8.17 },
    [24] = { 0.77, 0.46, 3.69,  6.15,  1.54, 3.08,  4.31,  3.08,  2.46,  4.31,  3.08,  7.69 },
    [23] = { 0.72, 0.43, 3.46,  5.77,  1.44, 2.88,  4.04,  2.88,  2.31,  4.04,  2.88,  7.21 },
    [22] = { 0.67, 0.40, 3.23,  5.38,  1.35, 2.69,  3.77,  2.69,  2.15,  3.77,  2.69,  6.73 },
    [21] = { 0.63, 0.38, 3.00,  5.00,  1.25, 2.50,  3.50,  2.50,  2.00,  3.50,  2.50,  6.25 },
    [20] = { 0.58, 0.35, 2.77,  4.62,  1.15, 2.31,  3.23,  2.31,  1.85,  3.23,  2.31,  5.77 },
    [19] = { 0.53, 0.32, 2.54,  4.23,  1.06, 2.12,  2.96,  2.12,  1.69,  2.96,  2.12,  5.29 },
    [18] = { 0.48, 0.29, 2.31,  3.85,  0.96, 1.92,  2.69,  1.92,  1.54,  2.69,  1.92,  4.81 },
    [17] = { 0.43, 0.26, 2.08,  3.46,  0.87, 1.73,  2.42,  1.73,  1.38,  2.42,  1.73,  4.33 },
    [16] = { 0.38, 0.23, 1.85,  3.08,  0.77, 1.54,  2.15,  1.54,  1.23,  2.15,  1.54,  3.85 },
    [15] = { 0.34, 0.20, 1.62,  2.69,  0.67, 1.35,  1.88,  1.35,  1.08,  1.88,  1.35,  3.37 },
    [14] = { 0.29, 0.17, 1.38,  2.31,  0.58, 1.15,  1.62,  1.15,  0.92,  1.62,  1.15,  2.88 },
    [13] = { 0.24, 0.14, 1.15,  1.92,  0.48, 0.96,  1.35,  0.96,  0.77,  1.35,  0.96,  2.40 },
    [12] = { 0.19, 0.12, 0.92,  1.54,  0.38, 0.77,  1.08,  0.77,  0.62,  1.08,  0.77,  1.92 },
    [11] = { 0.14, 0.09, 0.69,  1.15,  0.29, 0.58,  0.81,  0.58,  0.46,  0.81,  0.58,  1.44 },
    [10] = { 0.10, 0.06, 0.46,  0.77,  0.19, 0.38,  0.54,  0.38,  0.31,  0.54,  0.38,  0.96 },
     [9] = { 0.05, 0.03, 0.23,  0.38,  0.10, 0.19,  0.27,  0.19,  0.15,  0.27,  0.19,  0.48 },
     [8] = { 0.00, 0.00, 0.00,  0.00,  0.00, 0.00,  0.00,  0.00,  0.00,  0.00,  0.00,  0.00 },
}

MSC.RatingIndexMap = {
    ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 1,
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2,
    ["ITEM_MOD_DODGE_RATING_SHORT"] = 3,
    ["ITEM_MOD_PARRY_RATING_SHORT"] = 4,
    ["ITEM_MOD_BLOCK_RATING_SHORT"] = 5,
    ["ITEM_MOD_HIT_RATING_SHORT"] = 6,
    ["ITEM_MOD_CRIT_RATING_SHORT"] = 7,
    ["ITEM_MOD_HASTE_RATING_SHORT"] = 8,
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 9,
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 10,
    ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 11,
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 12,
}

-- [[ 2. PRIMARY STATS (Agi/Int -> Crit) ]]
-- Amount of Agility/Intellect needed for 1% Crit
MSC.PrimaryStatScalars = {
    AGI = {
        [1] = { WARRIOR=4.00, PALADIN=4.60, HUNTER=3.52, ROGUE=2.23, PRIEST=11.00, SHAMAN=6.01, MAGE=12.97, WARLOCK=6.67, DRUID=4.95 },
        [2] = { WARRIOR=4.20, PALADIN=4.83, HUNTER=3.53, ROGUE=2.33, PRIEST=11.00, SHAMAN=6.01, MAGE=12.97, WARLOCK=6.67, DRUID=4.95 },
        [3] = { WARRIOR=4.20, PALADIN=4.83, HUNTER=3.69, ROGUE=2.43, PRIEST=11.00, SHAMAN=6.32, MAGE=12.97, WARLOCK=7.00, DRUID=5.20 },
        [4] = { WARRIOR=4.40, PALADIN=5.06, HUNTER=3.95, ROGUE=2.62, PRIEST=11.56, SHAMAN=6.32, MAGE=13.61, WARLOCK=7.00, DRUID=5.20 },
        [5] = { WARRIOR=4.60, PALADIN=5.06, HUNTER=4.12, ROGUE=2.72, PRIEST=11.56, SHAMAN=6.62, MAGE=13.61, WARLOCK=7.00, DRUID=5.45 },
        [6] = { WARRIOR=4.80, PALADIN=5.29, HUNTER=4.28, ROGUE=2.82, PRIEST=11.56, SHAMAN=6.62, MAGE=13.61, WARLOCK=7.33, DRUID=5.45 },
        [7] = { WARRIOR=4.80, PALADIN=5.29, HUNTER=4.44, ROGUE=3.01, PRIEST=11.56, SHAMAN=6.62, MAGE=13.61, WARLOCK=7.33, DRUID=5.69 },
        [8] = { WARRIOR=5.00, PALADIN=5.52, HUNTER=4.61, ROGUE=3.11, PRIEST=12.11, SHAMAN=6.92, MAGE=13.61, WARLOCK=7.33, DRUID=5.69 },
        [9] = { WARRIOR=5.20, PALADIN=5.52, HUNTER=4.88, ROGUE=3.21, PRIEST=12.11, SHAMAN=6.92, MAGE=13.61, WARLOCK=7.67, DRUID=5.94 },
        [10] = { WARRIOR=5.20, PALADIN=5.75, HUNTER=5.04, ROGUE=3.40, PRIEST=12.11, SHAMAN=7.22, MAGE=14.27, WARLOCK=7.67, DRUID=6.44 },
        [11] = { WARRIOR=5.40, PALADIN=5.75, HUNTER=5.41, ROGUE=3.79, PRIEST=12.11, SHAMAN=7.22, MAGE=14.27, WARLOCK=8.00, DRUID=6.68 },
        [12] = { WARRIOR=5.60, PALADIN=5.98, HUNTER=5.99, ROGUE=4.18, PRIEST=12.66, SHAMAN=7.52, MAGE=14.27, WARLOCK=8.00, DRUID=6.68 },
        [13] = { WARRIOR=6.00, PALADIN=6.44, HUNTER=6.46, ROGUE=4.66, PRIEST=12.66, SHAMAN=7.52, MAGE=14.27, WARLOCK=8.00, DRUID=6.93 },
        [14] = { WARRIOR=6.20, PALADIN=6.44, HUNTER=6.94, ROGUE=5.05, PRIEST=12.66, SHAMAN=7.82, MAGE=14.27, WARLOCK=8.33, DRUID=6.93 },
        [15] = { WARRIOR=6.40, PALADIN=6.90, HUNTER=7.52, ROGUE=5.63, PRIEST=12.66, SHAMAN=8.12, MAGE=14.90, WARLOCK=8.67, DRUID=7.43 },
        [16] = { WARRIOR=6.60, PALADIN=6.90, HUNTER=7.89, ROGUE=6.02, PRIEST=13.21, SHAMAN=8.42, MAGE=14.90, WARLOCK=9.00, DRUID=7.43 },
        [17] = { WARRIOR=6.80, PALADIN=7.13, HUNTER=8.38, ROGUE=6.41, PRIEST=13.21, SHAMAN=8.42, MAGE=14.90, WARLOCK=9.00, DRUID=7.67 },
        [18] = { WARRIOR=7.20, PALADIN=7.59, HUNTER=8.95, ROGUE=6.90, PRIEST=13.21, SHAMAN=8.72, MAGE=14.90, WARLOCK=9.00, DRUID=7.92 },
        [19] = { WARRIOR=7.40, PALADIN=7.59, HUNTER=9.43, ROGUE=7.38, PRIEST=13.76, SHAMAN=8.72, MAGE=14.90, WARLOCK=9.34, DRUID=7.92 },
        [20] = { WARRIOR=7.80, PALADIN=8.05, HUNTER=10.02, ROGUE=7.87, PRIEST=13.76, SHAMAN=9.32, MAGE=15.55, WARLOCK=9.67, DRUID=8.91 },
        [21] = { WARRIOR=7.80, PALADIN=8.28, HUNTER=10.40, ROGUE=8.35, PRIEST=13.76, SHAMAN=9.32, MAGE=15.55, WARLOCK=10.00, DRUID=8.91 },
        [22] = { WARRIOR=8.00, PALADIN=8.28, HUNTER=10.99, ROGUE=8.74, PRIEST=13.76, SHAMAN=9.62, MAGE=15.55, WARLOCK=10.00, DRUID=9.16 },
        [23] = { WARRIOR=8.40, PALADIN=8.74, HUNTER=11.47, ROGUE=9.23, PRIEST=14.31, SHAMAN=9.62, MAGE=15.55, WARLOCK=10.33, DRUID=9.41 },
        [24] = { WARRIOR=8.60, PALADIN=8.97, HUNTER=12.06, ROGUE=9.62, PRIEST=14.31, SHAMAN=9.92, MAGE=16.21, WARLOCK=10.33, DRUID=9.41 },
        [25] = { WARRIOR=9.00, PALADIN=9.20, HUNTER=12.55, ROGUE=10.20, PRIEST=14.31, SHAMAN=10.22, MAGE=16.21, WARLOCK=11.00, DRUID=9.90 },
        [26] = { WARRIOR=9.20, PALADIN=9.43, HUNTER=13.04, ROGUE=10.68, PRIEST=14.86, SHAMAN=10.53, MAGE=16.21, WARLOCK=11.00, DRUID=9.90 },
        [27] = { WARRIOR=9.40, PALADIN=9.66, HUNTER=13.62, ROGUE=11.07, PRIEST=14.86, SHAMAN=10.53, MAGE=16.21, WARLOCK=11.00, DRUID=10.15 },
        [28] = { WARRIOR=9.80, PALADIN=9.89, HUNTER=14.10, ROGUE=11.56, PRIEST=14.86, SHAMAN=10.82, MAGE=16.21, WARLOCK=11.34, DRUID=10.40 },
        [29] = { WARRIOR=10.00, PALADIN=10.12, HUNTER=14.71, ROGUE=12.05, PRIEST=15.41, SHAMAN=10.82, MAGE=16.86, WARLOCK=11.34, DRUID=10.40 },
        [30] = { WARRIOR=10.40, PALADIN=10.58, HUNTER=15.29, ROGUE=12.63, PRIEST=15.41, SHAMAN=11.43, MAGE=16.86, WARLOCK=12.00, DRUID=11.39 },
        [31] = { WARRIOR=10.60, PALADIN=10.81, HUNTER=15.70, ROGUE=13.02, PRIEST=15.41, SHAMAN=11.43, MAGE=16.86, WARLOCK=12.00, DRUID=11.64 },
        [32] = { WARRIOR=10.80, PALADIN=10.81, HUNTER=16.29, ROGUE=13.50, PRIEST=15.95, SHAMAN=11.72, MAGE=16.86, WARLOCK=12.33, DRUID=11.64 },
        [33] = { WARRIOR=11.20, PALADIN=11.27, HUNTER=16.89, ROGUE=13.99, PRIEST=15.95, SHAMAN=12.03, MAGE=17.51, WARLOCK=12.33, DRUID=11.89 },
        [34] = { WARRIOR=11.40, PALADIN=11.49, HUNTER=17.39, ROGUE=14.47, PRIEST=15.95, SHAMAN=12.03, MAGE=17.51, WARLOCK=12.67, DRUID=12.14 },
        [35] = { WARRIOR=11.81, PALADIN=11.96, HUNTER=17.99, ROGUE=15.06, PRIEST=16.50, SHAMAN=12.63, MAGE=17.51, WARLOCK=13.00, DRUID=12.38 },
        [36] = { WARRIOR=12.00, PALADIN=12.20, HUNTER=18.48, ROGUE=15.55, PRIEST=16.50, SHAMAN=12.94, MAGE=18.15, WARLOCK=13.33, DRUID=12.63 },
        [37] = { WARRIOR=12.20, PALADIN=12.20, HUNTER=19.08, ROGUE=15.92, PRIEST=16.50, SHAMAN=12.94, MAGE=18.15, WARLOCK=13.66, DRUID=12.87 },
        [38] = { WARRIOR=12.59, PALADIN=12.64, HUNTER=19.69, ROGUE=16.42, PRIEST=17.06, SHAMAN=13.23, MAGE=18.15, WARLOCK=13.66, DRUID=12.87 },
        [39] = { WARRIOR=12.80, PALADIN=12.89, HUNTER=20.28, ROGUE=16.89, PRIEST=17.06, SHAMAN=13.23, MAGE=18.15, WARLOCK=14.01, DRUID=13.12 },
        [40] = { WARRIOR=13.19, PALADIN=13.33, HUNTER=20.79, ROGUE=17.48, PRIEST=17.06, SHAMAN=13.83, MAGE=18.80, WARLOCK=14.33, DRUID=14.10 },
        [41] = { WARRIOR=13.61, PALADIN=13.57, HUNTER=21.28, ROGUE=17.99, PRIEST=17.61, SHAMAN=14.14, MAGE=18.80, WARLOCK=14.66, DRUID=14.37 },
        [42] = { WARRIOR=13.79, PALADIN=13.57, HUNTER=21.88, ROGUE=18.45, PRIEST=17.61, SHAMAN=14.14, MAGE=18.80, WARLOCK=14.66, DRUID=14.37 },
        [43] = { WARRIOR=14.20, PALADIN=14.03, HUNTER=22.52, ROGUE=18.94, PRIEST=18.15, SHAMAN=14.43, MAGE=18.80, WARLOCK=14.99, DRUID=14.60 },
        [44] = { WARRIOR=14.41, PALADIN=14.27, HUNTER=23.09, ROGUE=19.53, PRIEST=18.15, SHAMAN=14.73, MAGE=19.46, WARLOCK=14.99, DRUID=14.86 },
        [45] = { WARRIOR=14.79, PALADIN=14.73, HUNTER=23.75, ROGUE=20.12, PRIEST=18.15, SHAMAN=15.04, MAGE=19.46, WARLOCK=15.67, DRUID=15.36 },
        [46] = { WARRIOR=14.99, PALADIN=14.95, HUNTER=24.21, ROGUE=20.58, PRIEST=18.73, SHAMAN=15.34, MAGE=19.46, WARLOCK=16.00, DRUID=15.60 },
        [47] = { WARRIOR=15.41, PALADIN=15.17, HUNTER=24.88, ROGUE=21.10, PRIEST=18.73, SHAMAN=15.65, MAGE=20.08, WARLOCK=16.00, DRUID=15.60 },
        [48] = { WARRIOR=15.80, PALADIN=15.65, HUNTER=25.58, ROGUE=21.55, PRIEST=19.27, SHAMAN=15.95, MAGE=20.08, WARLOCK=16.34, DRUID=15.85 },
        [49] = { WARRIOR=16.00, PALADIN=15.87, HUNTER=26.18, ROGUE=22.03, PRIEST=19.27, SHAMAN=15.95, MAGE=20.08, WARLOCK=16.67, DRUID=16.10 },
        [50] = { WARRIOR=16.39, PALADIN=16.34, HUNTER=26.81, ROGUE=22.73, PRIEST=19.27, SHAMAN=16.53, MAGE=20.75, WARLOCK=17.01, DRUID=17.09 },
        [51] = { WARRIOR=16.81, PALADIN=16.56, HUNTER=27.32, ROGUE=23.20, PRIEST=19.80, SHAMAN=16.84, MAGE=20.75, WARLOCK=17.33, DRUID=17.33 },
        [52] = { WARRIOR=17.01, PALADIN=16.78, HUNTER=27.93, ROGUE=23.70, PRIEST=19.80, SHAMAN=17.15, MAGE=20.75, WARLOCK=17.33, DRUID=17.57 },
        [53] = { WARRIOR=17.39, PALADIN=17.24, HUNTER=28.57, ROGUE=24.27, PRIEST=20.37, SHAMAN=17.15, MAGE=21.41, WARLOCK=17.67, DRUID=17.83 },
        [54] = { WARRIOR=17.79, PALADIN=17.48, HUNTER=29.33, ROGUE=24.75, PRIEST=20.37, SHAMAN=17.45, MAGE=21.41, WARLOCK=17.99, DRUID=17.83 },
        [55] = { WARRIOR=18.21, PALADIN=17.95, HUNTER=29.94, ROGUE=25.38, PRIEST=20.92, SHAMAN=18.05, MAGE=21.41, WARLOCK=18.35, DRUID=18.32 },
        [56] = { WARRIOR=18.42, PALADIN=18.18, HUNTER=30.49, ROGUE=25.91, PRIEST=20.92, SHAMAN=18.35, MAGE=22.03, WARLOCK=18.66, DRUID=18.55 },
        [57] = { WARRIOR=18.80, PALADIN=18.38, HUNTER=31.15, ROGUE=26.46, PRIEST=21.46, SHAMAN=18.66, MAGE=22.03, WARLOCK=19.01, DRUID=18.83 },
        [58] = { WARRIOR=19.19, PALADIN=18.87, HUNTER=31.85, ROGUE=27.03, PRIEST=21.46, SHAMAN=18.66, MAGE=22.03, WARLOCK=19.34, DRUID=19.05 },
        [59] = { WARRIOR=19.61, PALADIN=19.08, HUNTER=32.57, ROGUE=27.47, PRIEST=22.03, SHAMAN=18.94, MAGE=22.68, WARLOCK=19.34, DRUID=19.31 },
        [60] = { WARRIOR=20.00, PALADIN=19.53, HUNTER=33.22, ROGUE=28.17, PRIEST=22.03, SHAMAN=19.53, MAGE=22.68, WARLOCK=20.00, DRUID=20.28 },
        [61] = { WARRIOR=21.32, PALADIN=20.37, HUNTER=33.67, ROGUE=29.94, PRIEST=22.57, SHAMAN=20.16, MAGE=22.99, WARLOCK=20.66, DRUID=20.92 },
        [62] = { WARRIOR=22.62, PALADIN=20.70, HUNTER=34.48, ROGUE=31.06, PRIEST=22.52, SHAMAN=20.58, MAGE=23.15, WARLOCK=20.79, DRUID=21.19 },
        [63] = { WARRIOR=23.92, PALADIN=21.19, HUNTER=35.21, ROGUE=32.57, PRIEST=22.68, SHAMAN=21.28, MAGE=23.58, WARLOCK=21.28, DRUID=21.93 },
        [64] = { WARRIOR=25.19, PALADIN=21.93, HUNTER=35.84, ROGUE=33.78, PRIEST=23.09, SHAMAN=21.93, MAGE=23.64, WARLOCK=21.98, DRUID=22.37 },
        [65] = { WARRIOR=26.53, PALADIN=22.42, HUNTER=36.63, ROGUE=34.97, PRIEST=23.47, SHAMAN=22.27, MAGE=23.70, WARLOCK=22.32, DRUID=22.83 },
        [66] = { WARRIOR=27.78, PALADIN=22.88, HUNTER=37.04, ROGUE=36.23, PRIEST=23.87, SHAMAN=22.88, MAGE=24.33, WARLOCK=22.99, DRUID=23.26 },
        [67] = { WARRIOR=29.07, PALADIN=23.53, HUNTER=37.88, ROGUE=37.31, PRIEST=24.15, SHAMAN=23.42, MAGE=24.27, WARLOCK=22.94, DRUID=23.58 },
        [68] = { WARRIOR=30.40, PALADIN=24.04, HUNTER=38.61, ROGUE=38.17, PRIEST=24.27, SHAMAN=23.98, MAGE=24.51, WARLOCK=23.58, DRUID=24.27 },
        [69] = { WARRIOR=31.75, PALADIN=24.51, HUNTER=39.37, ROGUE=39.06, PRIEST=24.39, SHAMAN=24.51, MAGE=24.75, WARLOCK=24.15, DRUID=24.63 },
        [70] = { WARRIOR=33.00, PALADIN=25.00, HUNTER=40.00, ROGUE=40.00, PRIEST=25.00, SHAMAN=25.00, MAGE=25.00, WARLOCK=24.69, DRUID=25.00 },
    },
        INT = {
        [1] = { PALADIN=12.02, HUNTER=14.31, PRIEST=5.85, SHAMAN=7.50, MAGE=6.11, WARLOCK=6.67, DRUID=6.99 },
        [2] = { PALADIN=12.61, HUNTER=15.02, PRIEST=6.11, SHAMAN=7.86, MAGE=6.35, WARLOCK=6.97, DRUID=7.30 },
        [3] = { PALADIN=12.61, HUNTER=15.02, PRIEST=6.38, SHAMAN=8.22, MAGE=6.60, WARLOCK=7.27, DRUID=7.62 },
        [4] = { PALADIN=13.21, HUNTER=15.75, PRIEST=6.64, SHAMAN=8.22, MAGE=7.09, WARLOCK=7.58, DRUID=7.94 },
        [5] = { PALADIN=13.21, HUNTER=15.75, PRIEST=7.17, SHAMAN=8.58, MAGE=7.33, WARLOCK=7.88, DRUID=8.26 },
        [6] = { PALADIN=13.81, HUNTER=16.45, PRIEST=7.44, SHAMAN=8.93, MAGE=7.58, WARLOCK=8.18, DRUID=8.58 },
        [7] = { PALADIN=14.41, HUNTER=16.45, PRIEST=7.71, SHAMAN=9.29, MAGE=7.82, WARLOCK=8.48, DRUID=8.90 },
        [8] = { PALADIN=14.41, HUNTER=17.15, PRIEST=7.97, SHAMAN=9.64, MAGE=8.06, WARLOCK=8.79, DRUID=8.90 },
        [9] = { PALADIN=15.02, HUNTER=17.15, PRIEST=8.24, SHAMAN=10.00, MAGE=8.55, WARLOCK=9.09, DRUID=9.21 },
        [10] = { PALADIN=15.02, HUNTER=17.89, PRIEST=8.77, SHAMAN=10.00, MAGE=8.80, WARLOCK=9.39, DRUID=10.16 },
        [11] = { PALADIN=15.63, HUNTER=17.89, PRIEST=9.57, SHAMAN=10.72, MAGE=9.53, WARLOCK=10.30, DRUID=10.80 },
        [12] = { PALADIN=16.23, HUNTER=18.59, PRIEST=10.63, SHAMAN=11.43, MAGE=10.75, WARLOCK=11.21, DRUID=11.75 },
        [13] = { PALADIN=16.84, HUNTER=20.04, PRIEST=11.43, SHAMAN=12.50, MAGE=11.48, WARLOCK=12.12, DRUID=12.39 },
        [14] = { PALADIN=17.42, HUNTER=20.04, PRIEST=12.76, SHAMAN=13.23, MAGE=13.68, WARLOCK=13.04, DRUID=13.33 },
        [15] = { PALADIN=18.62, HUNTER=21.46, PRIEST=13.81, SHAMAN=14.29, MAGE=14.90, WARLOCK=13.95, DRUID=14.62 },
        [16] = { PALADIN=18.62, HUNTER=21.46, PRIEST=14.62, SHAMAN=15.02, MAGE=15.65, WARLOCK=14.53, DRUID=15.24 },
        [17] = { PALADIN=19.23, HUNTER=22.17, PRIEST=15.95, SHAMAN=15.72, MAGE=16.61, WARLOCK=15.75, DRUID=16.21 },
        [18] = { PALADIN=20.41, HUNTER=23.58, PRIEST=16.75, SHAMAN=16.78, MAGE=17.61, WARLOCK=16.67, DRUID=16.84 },
        [19] = { PALADIN=20.41, HUNTER=23.58, PRIEST=17.79, SHAMAN=17.51, MAGE=18.59, WARLOCK=17.57, DRUID=17.79 },
        [20] = { PALADIN=21.65, HUNTER=25.06, PRIEST=19.12, SHAMAN=18.59, MAGE=19.80, WARLOCK=18.48, DRUID=19.38 },
        [21] = { PALADIN=22.22, HUNTER=25.77, PRIEST=19.92, SHAMAN=19.31, MAGE=20.53, WARLOCK=19.38, DRUID=20.00 },
        [22] = { PALADIN=22.83, HUNTER=25.77, PRIEST=21.28, SHAMAN=20.00, MAGE=21.74, WARLOCK=20.28, DRUID=20.96 },
        [23] = { PALADIN=23.42, HUNTER=27.17, PRIEST=22.08, SHAMAN=21.10, MAGE=22.47, WARLOCK=21.23, DRUID=21.60 },
        [24] = { PALADIN=24.04, HUNTER=27.93, PRIEST=23.36, SHAMAN=21.79, MAGE=23.70, WARLOCK=22.42, DRUID=22.88 },
        [25] = { PALADIN=25.25, HUNTER=28.57, PRIEST=24.45, SHAMAN=22.88, MAGE=24.69, WARLOCK=23.31, DRUID=23.81 },
        [26] = { PALADIN=25.84, HUNTER=29.33, PRIEST=25.51, SHAMAN=23.58, MAGE=25.64, WARLOCK=23.92, DRUID=24.45 },
        [27] = { PALADIN=25.84, HUNTER=30.03, PRIEST=26.60, SHAMAN=24.27, MAGE=26.88, WARLOCK=25.13, DRUID=25.38 },
        [28] = { PALADIN=27.03, HUNTER=30.77, PRIEST=27.62, SHAMAN=25.38, MAGE=29.59, WARLOCK=26.04, DRUID=26.04 },
        [29] = { PALADIN=27.62, HUNTER=31.45, PRIEST=28.74, SHAMAN=26.11, MAGE=30.77, WARLOCK=27.25, DRUID=27.32 },
        [30] = { PALADIN=28.82, HUNTER=32.89, PRIEST=30.03, SHAMAN=27.17, MAGE=32.05, WARLOCK=28.17, DRUID=28.90 },
        [31] = { PALADIN=29.41, HUNTER=33.67, PRIEST=31.06, SHAMAN=28.25, MAGE=32.79, WARLOCK=28.82, DRUID=29.50 },
        [32] = { PALADIN=30.03, HUNTER=33.67, PRIEST=32.15, SHAMAN=28.90, MAGE=34.01, WARLOCK=30.03, DRUID=30.77 },
        [33] = { PALADIN=30.67, HUNTER=35.09, PRIEST=33.22, SHAMAN=30.03, MAGE=34.97, WARLOCK=30.86, DRUID=31.45 },
        [34] = { PALADIN=31.25, HUNTER=35.71, PRIEST=34.60, SHAMAN=30.77, MAGE=35.97, WARLOCK=32.15, DRUID=32.36 },
        [35] = { PALADIN=32.47, HUNTER=37.17, PRIEST=35.59, SHAMAN=31.85, MAGE=37.17, WARLOCK=33.00, DRUID=33.67 },
        [36] = { PALADIN=33.00, HUNTER=37.88, PRIEST=36.63, SHAMAN=32.89, MAGE=38.17, WARLOCK=33.90, DRUID=34.25 },
        [37] = { PALADIN=33.67, HUNTER=37.88, PRIEST=38.02, SHAMAN=33.56, MAGE=39.37, WARLOCK=35.21, DRUID=35.21 },
        [38] = { PALADIN=34.84, HUNTER=39.37, PRIEST=39.06, SHAMAN=34.60, MAGE=40.32, WARLOCK=36.10, DRUID=36.23 },
        [39] = { PALADIN=35.46, HUNTER=40.00, PRIEST=40.16, SHAMAN=35.34, MAGE=41.49, WARLOCK=37.31, DRUID=37.17 },
        [40] = { PALADIN=36.63, HUNTER=41.49, PRIEST=41.49, SHAMAN=36.76, MAGE=42.55, WARLOCK=38.17, DRUID=39.06 },
        [41] = { PALADIN=37.31, HUNTER=42.19, PRIEST=42.55, SHAMAN=37.45, MAGE=43.48, WARLOCK=39.06, DRUID=39.68 },
        [42] = { PALADIN=37.88, HUNTER=42.19, PRIEST=43.86, SHAMAN=38.17, MAGE=46.51, WARLOCK=40.32, DRUID=40.98 },
        [43] = { PALADIN=39.06, HUNTER=43.67, PRIEST=44.84, SHAMAN=39.37, MAGE=47.39, WARLOCK=41.15, DRUID=41.67 },
        [44] = { PALADIN=39.06, HUNTER=44.44, PRIEST=46.30, SHAMAN=40.32, MAGE=48.54, WARLOCK=42.37, DRUID=42.92 },
        [45] = { PALADIN=40.32, HUNTER=45.87, PRIEST=47.62, SHAMAN=41.49, MAGE=49.75, WARLOCK=43.67, DRUID=43.86 },
        [46] = { PALADIN=40.82, HUNTER=46.51, PRIEST=48.54, SHAMAN=42.55, MAGE=50.76, WARLOCK=44.64, DRUID=44.84 },
        [47] = { PALADIN=42.02, HUNTER=47.17, PRIEST=50.00, SHAMAN=43.29, MAGE=52.08, WARLOCK=45.45, DRUID=45.66 },
        [48] = { PALADIN=43.29, HUNTER=48.54, PRIEST=51.02, SHAMAN=44.25, MAGE=53.19, WARLOCK=46.73, DRUID=46.73 },
        [49] = { PALADIN=43.86, HUNTER=49.26, PRIEST=52.36, SHAMAN=45.45, MAGE=54.35, WARLOCK=47.85, DRUID=47.85 },
        [50] = { PALADIN=45.05, HUNTER=50.76, PRIEST=53.76, SHAMAN=46.51, MAGE=55.87, WARLOCK=49.02, DRUID=49.50 },
        [51] = { PALADIN=45.66, HUNTER=51.55, PRIEST=54.64, SHAMAN=47.62, MAGE=56.82, WARLOCK=50.00, DRUID=50.51 },
        [52] = { PALADIN=46.30, HUNTER=52.08, PRIEST=56.18, SHAMAN=48.31, MAGE=57.80, WARLOCK=51.28, DRUID=51.81 },
        [53] = { PALADIN=47.39, HUNTER=53.76, PRIEST=57.14, SHAMAN=49.75, MAGE=58.82, WARLOCK=52.36, DRUID=52.36 },
        [54] = { PALADIN=48.08, HUNTER=54.35, PRIEST=58.48, SHAMAN=50.25, MAGE=60.24, WARLOCK=53.76, DRUID=53.76 },
        [55] = { PALADIN=49.26, HUNTER=55.87, PRIEST=60.24, SHAMAN=51.81, MAGE=61.73, WARLOCK=54.95, DRUID=54.95 },
        [56] = { PALADIN=49.75, HUNTER=56.50, PRIEST=60.98, SHAMAN=52.63, MAGE=64.94, WARLOCK=55.87, DRUID=55.87 },
        [57] = { PALADIN=50.51, HUNTER=57.14, PRIEST=62.50, SHAMAN=53.48, MAGE=66.23, WARLOCK=56.82, DRUID=56.82 },
        [58] = { PALADIN=52.36, HUNTER=58.82, PRIEST=63.69, SHAMAN=54.95, MAGE=67.11, WARLOCK=58.14, DRUID=57.80 },
        [59] = { PALADIN=52.91, HUNTER=59.52, PRIEST=64.94, SHAMAN=55.87, MAGE=68.49, WARLOCK=59.52, DRUID=59.17 },
        [60] = { PALADIN=54.05, HUNTER=60.98, PRIEST=66.23, SHAMAN=57.14, MAGE=69.93, WARLOCK=60.61, DRUID=60.98 },
        [61] = { PALADIN=63.69, HUNTER=63.69, PRIEST=67.57, SHAMAN=60.98, MAGE=69.93, WARLOCK=62.89, DRUID=61.73 },
        [62] = { PALADIN=65.36, HUNTER=64.94, PRIEST=68.97, SHAMAN=62.89, MAGE=69.93, WARLOCK=64.94, DRUID=63.69 },
        [63] = { PALADIN=67.57, HUNTER=66.67, PRIEST=69.93, SHAMAN=65.79, MAGE=69.93, WARLOCK=67.57, DRUID=66.67 },
        [64] = { PALADIN=69.93, HUNTER=69.44, PRIEST=71.94, SHAMAN=68.03, MAGE=70.42, WARLOCK=69.93, DRUID=68.49 },
        [65] = { PALADIN=71.43, HUNTER=70.92, PRIEST=72.99, SHAMAN=70.42, MAGE=70.42, WARLOCK=72.46, DRUID=70.42 },
        [66] = { PALADIN=73.53, HUNTER=72.99, PRIEST=74.63, SHAMAN=72.46, MAGE=72.46, WARLOCK=74.07, DRUID=72.99 },
        [67] = { PALADIN=75.19, HUNTER=75.19, PRIEST=75.76, SHAMAN=74.63, MAGE=75.19, WARLOCK=76.92, DRUID=75.19 },
        [68] = { PALADIN=76.34, HUNTER=76.92, PRIEST=76.92, SHAMAN=76.34, MAGE=76.34, WARLOCK=78.74, DRUID=76.34 },
        [69] = { PALADIN=78.13, HUNTER=78.13, PRIEST=78.74, SHAMAN=78.13, MAGE=78.13, WARLOCK=80.00, DRUID=78.13 },
        [70] = { PALADIN=80.00, HUNTER=80.00, PRIEST=80.00, SHAMAN=80.00, MAGE=80.00, WARLOCK=81.97, DRUID=80.00 },
    }
}