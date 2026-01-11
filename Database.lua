local _, MSC = ...

-- =============================================================
-- 1. GLOBAL CONSTANTS
-- =============================================================
MSC.SlotMap = {
    ["INVTYPE_HEAD"]=1, ["INVTYPE_NECK"]=2, ["INVTYPE_SHOULDER"]=3, ["INVTYPE_BODY"]=4, 
    ["INVTYPE_CHEST"]=5, ["INVTYPE_ROBE"]=5, ["INVTYPE_WAIST"]=6, ["INVTYPE_LEGS"]=7, 
    ["INVTYPE_FEET"]=8, ["INVTYPE_WRIST"]=9, ["INVTYPE_HAND"]=10, ["INVTYPE_FINGER"]=11, 
    ["INVTYPE_TRINKET"]=13, ["INVTYPE_CLOAK"]=15, ["INVTYPE_WEAPON"]=16, ["INVTYPE_SHIELD"]=17, 
    ["INVTYPE_2HWEAPON"]=16, ["INVTYPE_WEAPONMAINHAND"]=16, ["INVTYPE_WEAPONOFFHAND"]=17, 
    ["INVTYPE_HOLDABLE"]=17, ["INVTYPE_RANGED"]=18, ["INVTYPE_THROWN"]=18, 
    ["INVTYPE_RANGEDRIGHT"]=18, ["INVTYPE_RELIC"]=18 
}

-- =============================================================
-- 2. ENCHANTS (Vanilla / Era)
-- =============================================================
MSC.EnchantDB = {
    -- [[ WEAPON ]]
    [2621] = { name = "Crusader", stats = { ITEM_MOD_STRENGTH_SHORT = 60, ITEM_MOD_HEALING_POWER_SHORT = -10 } }, -- Pseudo-stat for str proc
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
    [2565] = { name = "Intellect +22", stats = { ITEM_MOD_INTELLECT_SHORT = 22 } }, -- 2H Only
    [2566] = { name = "Spirit +20", stats = { ITEM_MOD_SPIRIT_SHORT = 20 } }, -- 2H Only

    -- [[ ZUL'GURUB (Head/Legs/Shoulder) ]]
    [2603] = { name = "Might of the Scourge", stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26, MSC_CRIT_PERCENT = 1 } }, 
    [2604] = { name = "Power of the Scourge", stats = { ITEM_MOD_SPELL_POWER_SHORT = 15, MSC_SPELL_CRIT_PERCENT = 1 } }, 
    [2605] = { name = "Resilience of the Scourge", stats = { ITEM_MOD_HEALING_POWER_SHORT = 31, ITEM_MOD_MANA_REGENERATION_SHORT = 5 } }, 
    [2606] = { name = "Fortitude of the Scourge", stats = { ITEM_MOD_STAMINA_SHORT = 16, ITEM_MOD_ARMOR_SHORT = 100 } },
    [2583] = { name = "ZG Tank", stats = { ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 7, ITEM_MOD_BLOCK_VALUE_SHORT = 15 } },
    [2584] = { name = "ZG Heal/Def", stats = { ITEM_MOD_HEALING_POWER_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 7 } },
    [2587] = { name = "ZG Spell/Hit", stats = { ITEM_MOD_SPELL_POWER_SHORT = 18, MSC_SPELL_HIT_PERCENT = 1 } },
    [2588] = { name = "ZG Spell/Stam", stats = { ITEM_MOD_SPELL_POWER_SHORT = 18, ITEM_MOD_STAMINA_SHORT = 10 } },
    [2585] = { name = "ZG AP/Dodge", stats = { ITEM_MOD_ATTACK_POWER_SHORT = 28, MSC_DODGE_PERCENT = 1 } },
    [2586] = { name = "Biznicks Scope", isScope = true, stats = { ITEM_MOD_HIT_RATING_SHORT = 3 } }, -- Era: 3% Hit

    -- [[ LIBRAMS (Head/Legs) ]]
    [2284] = { name = "Arcanum of Focus (+8 SP)", stats = { ITEM_MOD_SPELL_POWER_SHORT = 8 } },
    [2283] = { name = "Arcanum of Protection (1% Dodge)", stats = { MSC_DODGE_PERCENT = 1 } },
    [2285] = { name = "Arcanum of Rapidity (1% Haste)", stats = { MSC_ATTACK_SPEED_PERCENT = 1 } },
    [2543] = { name = "+1% Haste", stats = { MSC_ATTACK_SPEED_PERCENT = 1 } }, 
    [2544] = { name = "+8 Healing", stats = { ITEM_MOD_HEALING_POWER_SHORT = 8 } },
    [2545] = { name = "+1% Dodge", stats = { MSC_DODGE_PERCENT = 1 } },
    [2488] = { name = "+100 Health", stats = { ITEM_MOD_HEALTH_SHORT = 100 } },
    [2483] = { name = "+8 Strength", stats = { ITEM_MOD_STRENGTH_SHORT = 8 } },
    [2484] = { name = "+8 Stamina", stats = { ITEM_MOD_STAMINA_SHORT = 8 } },
    [2485] = { name = "+8 Agility", stats = { ITEM_MOD_AGILITY_SHORT = 8 } },
    [2486] = { name = "+8 Intellect", stats = { ITEM_MOD_INTELLECT_SHORT = 8 } },
    [2487] = { name = "+8 Spirit", stats = { ITEM_MOD_SPIRIT_SHORT = 8 } },

    -- [[ STANDARD SLOTS ]]
    [2653] = { name = "Major Health (+150)", stats = { ITEM_MOD_HEALTH_SHORT = 150 } },
    [1891] = { name = "Greater Stats (+4)", stats = { ITEM_MOD_STATS_ALL_SHORT = 4 } },
    [1883] = { name = "Intellect +7", stats = { ITEM_MOD_INTELLECT_SHORT = 7 } },
    [1884] = { name = "Spirit +9", stats = { ITEM_MOD_SPIRIT_SHORT = 9 } },
    [1885] = { name = "Superior Strength (+9)", stats = { ITEM_MOD_STRENGTH_SHORT = 9 } },
    [2562] = { name = "Superior Agility (+15)", stats = { ITEM_MOD_AGILITY_SHORT = 15 } }, 
    [1886] = { name = "Agility +7", stats = { ITEM_MOD_AGILITY_SHORT = 7 } },
    [1888] = { name = "Greater Strength (+7)", stats = { ITEM_MOD_STRENGTH_SHORT = 7 } },
    [2939] = { name = "Boar's Speed", stats = { ITEM_MOD_STAMINA_SHORT = 9, MSC_SPEED_BONUS = 8 } },
    [911]  = { name = "Minor Agility (+1)", stats = { ITEM_MOD_AGILITY_SHORT = 1 } },
    [910]  = { name = "Minor Speed", stats = { MSC_SPEED_BONUS = 8 } },
    [2502] = { name = "Greater Resistance", stats = { ITEM_MOD_RESISTANCE_ALL_SHORT = 5 } },
    [849]  = { name = "Lesser Agility (+3)", stats = { ITEM_MOD_AGILITY_SHORT = 3 } },
}

-- =============================================================
-- 3. CANDIDATE LISTS (THE MISSING LINK!)
-- =============================================================
-- This table tells Helpers.lua which enchants go in which slot.
MSC.EnchantCandidates = {
    -- HEAD (1) & LEGS (7)
    [1] = { 2603, 2604, 2605, 2606, 2284, 2283, 2285, 2543, 2544, 2545, 2488, 2483, 2484, 2485, 2486, 2487 },
    [7] = { 2603, 2604, 2605, 2606, 2284, 2283, 2285, 2543, 2544, 2545, 2488, 2483, 2484, 2485, 2486, 2487 },

    -- SHOULDERS (3) - ZG
    [3] = { 2583, 2584, 2587, 2588, 2585 },

    -- BACK (15)
    [15] = { 2502, 849 },

    -- CHEST (5)
    [5] = { 2653, 1891 },

    -- WRIST (9)
    [9] = { 1885, 1883, 1884 },

    -- HANDS (10)
    [10] = { 2562, 1888, 1886 },

    -- FEET (8)
    [8] = { 2939, 910, 911 },

    -- WEAPON (16) & OFFHAND (17)
    [16] = { 2621, 2504, 2505, 2563, 2564, 1897, 1898, 1900, 1894, 803, 2565, 2566 },
    [17] = { 2621, 2504, 2505, 2563, 2564, 1897, 1898, 1900, 1894, 803 }, -- (No 2H enchants on OH)

    -- RANGED (18)
    [18] = { 2586 }
}

-- For Era, we can just reuse the main list for leveling, or filter it later.
MSC.EnchantCandidates_Leveling = MSC.EnchantCandidates

-- =============================================================
-- 4. ITEM OVERRIDES (Classic Era Specifics)
-- =============================================================
MSC.ItemOverrides = {
    -- [[ TRINKETS ]]
    [11815] = { ITEM_MOD_ATTACK_POWER_SHORT = 22, estimate = true }, -- Hand of Justice
    [19406] = { ITEM_MOD_ATTACK_POWER_SHORT = 86, estimate = true, replace = true }, -- DFT
    [13965] = { ITEM_MOD_CRIT_RATING_SHORT = 2, estimate = true, replace = true }, -- Blackhand's Breadth (Era: 1.0 = 1%)
    [19991] = { ITEM_MOD_ATTACK_POWER_SHORT = 39, estimate = true, replace = true }, -- Devilsaur Eye
    [19120] = { ITEM_MOD_ATTACK_POWER_SHORT = 35, estimate = true, replace = true }, -- Rune of the Guard Captain
    
    -- [[ PROCS ]]
    [19949] = { ITEM_MOD_ATTACK_POWER_SHORT = 34, estimate = true, replace = true }, -- ZHG
    [23570] = { ITEM_MOD_ATTACK_POWER_SHORT = 65, estimate = true, replace = true }, -- Jom Gabbar
    [21180] = { ITEM_MOD_ATTACK_POWER_SHORT = 47, estimate = true, replace = true }, -- Earthstrike
    [21670] = { ITEM_MOD_ATTACK_POWER_SHORT = 60, estimate = true, replace = true }, -- Swarmguard
    [20130] = { ITEM_MOD_STRENGTH_SHORT = 60, estimate = true, replace = true },     -- Diamond Flask

    -- [[ CASTER ]]
    [19379] = { ITEM_MOD_SPELL_POWER_SHORT = 70, estimate = true, replace = true }, -- Tear
    [12930] = { ITEM_MOD_SPELL_POWER_SHORT = 29, estimate = true, replace = true }, -- Briarwood
    [18820] = { ITEM_MOD_SPELL_POWER_SHORT = 39, estimate = true, replace = true }, -- ToEP
    [19339] = { ITEM_MOD_SPELL_POWER_SHORT = 45, estimate = true, replace = true }, -- MQG
    [19950] = { ITEM_MOD_SPELL_POWER_SHORT = 34, estimate = true, replace = true }, -- ZHC
    
    -- [[ HEALER ]]
    [19395] = { ITEM_MOD_HEALING_POWER_SHORT = 102, estimate = true, replace = true }, -- Rejuv Gem
    [17064] = { ITEM_MOD_HEALING_POWER_SHORT = 64, estimate = true, replace = true },  -- Shard of the Scale
    [23047] = { ITEM_MOD_HEALING_POWER_SHORT = 135, estimate = true, replace = true }, -- Eye of the Dead
    [19288] = { ITEM_MOD_HEALING_POWER_SHORT = 70, estimate = true, replace = true },  -- Blue Dragon

    -- [[ TANK ]]
    [19431] = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 25, ITEM_MOD_STAMINA_SHORT = 30, estimate = true, replace = true }, -- Styleen's
    [13966] = { ITEM_MOD_ARMOR_SHORT = 450, MSC_DODGE_PERCENT = 1, estimate = true, replace = true }, -- Mark of Tyranny
    [23040] = { ITEM_MOD_BLOCK_VALUE_SHORT = 60, ITEM_MOD_ARMOR_SHORT = 300, estimate = true, replace = true }, -- Glyph of Deflection
}

-- =============================================================
-- 5. ITEM SETS
-- =============================================================
MSC.ItemSetMap = {} 
MSC.RawSetData = {
    -- [[ TIER 0 (Dungeon 1) ]]
    [181] = { {16686,16689,16688,16683,16684,16685,16687,16682} }, -- Magister's
    [182] = { {16693,16695,16690,16697,16692,16696,16694,16691} }, -- Devout
    [183] = { {16698,16701,16700,16703,16705,16702,16699,16704} }, -- Dreadmist
    [184] = { {16707,16708,16721,16710,16712,16713,16709,16711} }, -- Shadowcraft
    [185] = { {16720,16718,16706,16714,16717,16716,16719,16715} }, -- Wildheart
    [186] = { {16677,16679,16674,16681,16676,16680,16678,16675} }, -- Beaststalker
    [187] = { {16667,16669,16666,16671,16672,16673,16668,16670} }, -- The Elements
    [188] = { {16727,16729,16726,16722,16724,16723,16728,16725} }, -- Lightforge
    [189] = { {16731,16733,16730,16735,16737,16736,16732,16734} }, -- Valor

    -- [[ TIER 1 (Molten Core) ]]
    [201] = { {16795,16797,16798,16799,16801,16802,16796,16800} }, -- Arcanist
    [202] = { {16813,16816,16815,16819,16812,16817,16814,16811} }, -- Prophecy
    [203] = { {16808,16807,16809,16804,16805,16806,16810,16803} }, -- Felheart
    [204] = { {16821,16823,16820,16825,16826,16827,16822,16824} }, -- Nightslayer
    [205] = { {16834,16836,16833,16830,16831,16828,16835,16829} }, -- Cenarion
    [206] = { {16846,16848,16845,16850,16852,16851,16847,16849} }, -- Giantstalker
    [207] = { {16842,16844,16841,16840,16839,16838,16843,16837} }, -- Earthfury
    [208] = { {16854,16856,16853,16857,16860,16858,16855,16859} }, -- Lawbringer
    [209] = { {16866,16868,16865,16861,16863,16864,16867,16862} }, -- Might

    -- [[ TIER 2 (BWL/Ony) ]]
    [210] = { {16914,16917,16916,16918,16913,16818,16915,16912} }, -- Netherwind
    [211] = { {16921,16924,16923,16926,16920,16925,16922,16919} }, -- Transcendence
    [212] = { {16929,16932,16931,16934,16928,16933,16930,16927} }, -- Nemesis
    [213] = { {16908,16832,16905,16911,16907,16910,16909,16906} }, -- Bloodfang
    [214] = { {16900,16902,16897,16904,16899,16903,16901,16898} }, -- Stormrage
    [215] = { {16939,16937,16942,16935,16940,16936,16938,16941} }, -- Dragonstalker
    [216] = { {16947,16945,16950,16943,16948,16944,16946,16949} }, -- Ten Storms
    [217] = { {16955,16953,16958,16951,16956,16952,16954,16957} }, -- Judgement
    [218] = { {16963,16961,16966,16959,16964,16960,16962,16965} }, -- Wrath

    -- [[ TIER 3 (Naxxramas) ]]
    [523] = { {22418,22419,22416,22423,22421,22422,22417,22420,23059} }, -- Dreadnaught
    [524] = { {22478,22479,22476,22483,22481,22482,22477,22480,23060} }, -- Bonescythe
    [525] = { {22514,22515,22512,22519,22517,22518,22513,22516,23061} }, -- Faith
    [526] = { {22498,22499,22496,22503,22501,22502,22497,22500,23062} }, -- Frostfire
    [527] = { {22466,22467,22464,22471,22469,22470,22465,22468,23065} }, -- Earthshatterer
    [528] = { {22428,22429,22425,22424,22426,22431,22427,22430,23066} }, -- Redemption
    [529] = { {22506,22507,22504,22511,22509,22510,22505,22508,23063} }, -- Plagueheart
    [530] = { {22438,22439,22436,22443,22441,22442,22437,22440,23067} }, -- Cryptstalker
    [521] = { {22490,22491,22488,22495,22493,22494,22489,22492,23064} }, -- Dreamwalker
}

-- =============================================================
-- 6. INITIALIZATION
-- =============================================================
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
    local id = tonumber(itemID)
    if not id then 
        id = tonumber(itemID:match("item:(%d+)"))
    end
    return MSC.ItemSetMap[id]
end

MSC:BuildDatabase()