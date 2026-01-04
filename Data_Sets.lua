local _, MSC = ...

-- ============================================================================
-- 4. DATA: ITEM SETS (MASTER COMPLETIONIST LIST)
-- ============================================================================
-- Format: [SetID] = { {ItemIDs} }
-- Includes: Leveling (15-60), Classic Endgame (60), TBC Leveling, TBC Endgame (70)

MSC.ItemSetMap = {} -- Populated by BuildDatabase() at the bottom

MSC.RawSetData = {
    -- ========================================================================
    -- [[ 1. LOW LEVEL / LEVELING SETS (15-50) ]]
    -- ========================================================================
    [161] = { {10399,10401,10403,10400,10402} }, -- Defias Leather (Deadmines)
    [162] = { {6473,10413,10412,10410,10411} }, -- Embrace of the Viper (WC)
    [163] = { {10328,10333,10331,10329,10330,10332} }, -- Chain of the Scarlet Crusade (SM)
    [221] = { {7953,7950,7951,7948,7949,7952} }, -- Garb of Thero-shan
    [522] = { {23257,23258,22879,22864,22880,22856} }, -- Champion's Guard (PvP Low Lvl)
    
    -- [[ CRAFTED LEVELING SETS (40-60) ]]
    [141] = { {15055,15053,15054} }, -- Volcanic Armor
    [142] = { {15058,15056,21278,15057} }, -- Stormshroud Armor
    [143] = { {15063,15062} }, -- Devilsaur Armor (Pre-Raid BiS Classic)
    [144] = { {15067,15066} }, -- Ironfeather Armor
    [489] = { {15051,15050,15052,16984} }, -- Black Dragon Mail
    [490] = { {15045,20296,15046} }, -- Green Dragon Mail
    [491] = { {15049,15048,20295} }, -- Blue Dragon Mail
    [520] = { {22302,22305,22301,22313,22304,22306,22303,22311} }, -- Ironweave Battlesuit

    -- ========================================================================
    -- [[ 2. CLASSIC DUNGEON SETS (Scholo/Strat/UBRS) ]]
    -- ========================================================================
    [121] = { {14637,14640,14636,14638,14641} }, -- Cadaverous Garb
    [122] = { {14633,14626,14629,14632,14631} }, -- Necropile Raiment
    [123] = { {14611,14615,14614,14612,14616} }, -- Bloodmail Regalia
    [124] = { {14624,14622,14620,14623,14621} }, -- Deathbone Guardian
    [81]  = { {13390,13388,13389,13391,13392} }, -- The Postmaster
    [41]  = { {12940,12939} }, -- Dal'Rend's Arms (Rogue/Warrior Starter)
    [65]  = { {13183,13218} }, -- Spider's Kiss

    -- [[ DUNGEON SET 1 (Tier 0) ]]
    [181] = { {16686,16689,16688,16683,16684,16685,16687,16682} }, -- Magister's (Mage)
    [182] = { {16693,16695,16690,16697,16692,16696,16694,16691} }, -- Devout (Priest)
    [183] = { {16698,16701,16700,16703,16705,16702,16699,16704} }, -- Dreadmist (Warlock)
    [184] = { {16707,16708,16721,16710,16712,16713,16709,16711} }, -- Shadowcraft (Rogue)
    [185] = { {16720,16718,16706,16714,16717,16716,16719,16715} }, -- Wildheart (Druid)
    [186] = { {16677,16679,16674,16681,16676,16680,16678,16675} }, -- Beaststalker (Hunter)
    [187] = { {16667,16669,16666,16671,16672,16673,16668,16670} }, -- The Elements (Shaman)
    [188] = { {16727,16729,16726,16722,16724,16723,16728,16725} }, -- Lightforge (Paladin)
    [189] = { {16731,16733,16730,16735,16737,16736,16732,16734} }, -- Valor (Warrior)

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

    -- ========================================================================
    -- [[ 3. CLASSIC RAIDS (MC / BWL / ZG / AQ / NAXX) ]]
    -- ========================================================================
    
    -- [[ ZUL'GURUB (ZG) ]]
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
    [474] = { {19577,19822,19824,19823,19951} }, -- Vindicator's (ZG War)
    [475] = { {19588,19825,19827,19826,19952} }, -- Freethinker's (ZG Pal)
    [476] = { {19609,19828,19830,19829,19956} }, -- Augur's (ZG Sham)
    [477] = { {19621,19831,19833,19832,19953} }, -- Predator's (ZG Hunt)
    [478] = { {19617,19835,19834,19836,19954} }, -- Madcap's (ZG Rogue)
    [479] = { {19613,19838,19840,19839,19955} }, -- Haruspex's (ZG Druid)
    [480] = { {19594,19841,19843,19842,19958} }, -- Confessor's (ZG Priest)
    [481] = { {19605,19849,20033,19848,19957} }, -- Demoniac's (ZG Lock)
    [482] = { {19601,19845,20034,19846,19959} }, -- Illusionist's (ZG Mage)

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

    -- [[ TIER 2 (BWL) ]]
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

    -- [[ PVP / ARATHI BASIN ]]
    [467] = { {20057,20041,20048} }, -- Highlander's Resolution
    [469] = { {20055,20043,20050} }, -- Highlander's Determination
    [470] = { {20056,20044,20051} }, -- Highlander's Fortitude
    [471] = { {20059,20045,20052} }, -- Highlander's Purpose
    [483] = { {20158,20150,20154} }, -- Defiler's Determination
    [487] = { {20212,20204,20208} }, -- Defiler's Resolution
    [383] = { {16542,16544,16541,16548,16543,16545} }, -- Warlord's Battlegear
    [588] = { {28853,28855,28851,28852,28854} }, -- High Warlord (Plate)

    -- ========================================================================
    -- [[ 4. TBC ERA (LEVEL 60-70) ]]
    -- ========================================================================
    [559] = { {24266, 24262} }, -- Spellstrike Infusion
    [571] = { {24264, 24261} }, -- Whitemend Wisdom
    [572] = { {24267, 24263} }, -- Battlecast Garb
    [619] = { {29525, 29527, 29526} }, -- Primalstrike (LW)
    [617] = { {29519, 29521, 29520} }, -- Netherstrike (LW)
    [618] = { {29522, 29523, 29524} }, -- Windhawk Armor (LW)
    [552] = { {21848, 21847, 21846} }, -- Wrath of Spellfire
    [553] = { {21869, 21871, 21870} }, -- Shadow's Embrace
    [554] = { {21874, 21875, 21873} }, -- Primal Mooncloth
    
    -- Dungeon Set 3 (D3)
    [650] = { {28275, 27801, 28228, 27474, 27874} }, -- Beast Lord
    [653] = { {28350, 27803, 28205, 27475, 27977} }, -- Bold Armor
    [660] = { {28192, 27713, 28401, 27528, 27936} }, -- Desolation
    [659] = { {28224, 27797, 28264, 27531, 27837} }, -- Wastewalker
    [658] = { {28193, 27796, 28191, 27465, 27907} }, -- Mana-Etched
    [662] = { {28413, 27775, 28230, 27536, 27875} }, -- Hallowed
    [644] = { {28415, 27778, 28232, 27537, 27948} }, -- Oblivion
    [620] = { {28414, 27776, 28204, 27509, 27908} }, -- Assassination
    [630] = { {28349, 27802, 28231, 27510, 27909} }, -- Tidefury
    [647] = { {28278, 27738, 28229, 27508, 27838} }, -- Incanter's
    [637] = { {28348, 27737, 28202, 27468, 27873} }, -- Moonglade

    -- TIER 4
    [655] = { {29021, 29023, 29019, 29020, 29022} }, -- Warbringer DPS
    [654] = { {29011, 29016, 29012, 29017, 29015} }, -- Warbringer Tank
    [624] = { {29061, 29064, 29062, 29065, 29063} }, -- Justicar Holy
    [625] = { {29068, 29070, 29066, 29067, 29069} }, -- Justicar Prot
    [626] = { {29073, 29075, 29071, 29072, 29074} }, -- Justicar Ret
    [651] = { {29081, 29084, 29082, 29085, 29083} }, -- Demon Stalker
    [621] = { {29044, 29047, 29045, 29048, 29046} }, -- Netherblade
    [640] = { {29098, 29100, 29096, 29097, 29099} }, -- Malorne Feral
    [638] = { {29086, 29089, 29087, 29090, 29088} }, -- Malorne Resto
    [639] = { {29093, 29095, 29091, 29092, 29094} }, -- Malorne Balance
    [633] = { {29040, 29043, 29038, 29039, 29042} }, -- Cyclone Enh
    [632] = { {29035, 29037, 29033, 29034, 29036} }, -- Cyclone Ele
    [631] = { {29028, 29031, 29029, 29032, 29030} }, -- Cyclone Resto
    [648] = { {29076, 29079, 29077, 29080, 29078} }, -- Aldor
    [645] = { {28963, 28967, 28964, 28968, 28966} }, -- Voidheart
    [663] = { {29049, 29054, 29050, 29055, 29053} }, -- Incarnate Holy
    [664] = { {29058, 29060, 29056, 29057, 29059} }, -- Incarnate Shadow

    -- TIER 5
    [656] = { {30115, 30117, 30113, 30114, 30116} }, -- Destroyer Tank
    [657] = { {30120, 30122, 30118, 30119, 30121} }, -- Destroyer DPS
    [627] = { {30136, 30138, 30134, 30135, 30137} }, -- Crystalforge Holy
    [628] = { {30125, 30127, 30123, 30124, 30126} }, -- Crystalforge Prot
    [629] = { {30131, 30133, 30129, 30130, 30132} }, -- Crystalforge Ret
    [652] = { {30141, 30143, 30139, 30140, 30142} }, -- Rift Stalker
    [622] = { {30146, 30149, 30144, 30145, 30148} }, -- Deathmantle
    [641] = { {30228, 30230, 30222, 30223, 30229} }, -- Nordrassil Feral
    [649] = { {30206, 30210, 30196, 30205, 30207} }, -- Tirisfal
    [646] = { {30212, 30215, 30214, 30211, 30213} }, -- Corruptor
    [665] = { {30152, 30154, 30150, 30151, 30153} }, -- Avatar Holy
    [666] = { {30161, 30163, 30159, 30160, 30162} }, -- Avatar Shadow
    [634] = { {30166, 30168, 30164, 30165, 30167} }, -- Cataclysm Resto

    -- TIER 6
    [672] = { {30972, 30979, 30975, 34441, 30969} }, -- Onslaught Tank
    [673] = { {30974, 30980, 30976, 34442, 30970} }, -- Onslaught DPS
    [679] = { {30987, 30998, 30991, 34433, 30985} }, -- Lightbringer Holy
    [681] = { {30988, 30996, 30992, 34432, 30983} }, -- Lightbringer Ret
    [669] = { {31003, 31006, 31004, 34443, 31001} }, -- Gronnstalker
    [668] = { {31027, 31030, 31028, 34448, 31026} }, -- Slayer's
    [676] = { {31039, 31048, 31042, 34444, 31034} }, -- Thunderheart Feral
    [671] = { {31056, 31059, 31057, 34447, 31055} }, -- Tempest
    [670] = { {31051, 31054, 31052, 34436, 31050} }, -- Malefic
    [675] = { {31063, 31069, 31066, 34435, 31060} }, -- Absolution Shadow
    [682] = { {31015, 31024, 31018, 34439, 31011} }, -- Skyshatter Enh

    -- LEGENDARY
    [699] = { {32837, 32838} }, -- Warglaives
}

-- ============================================================================
-- 5. SET BONUS SCORING
-- ============================================================================

MSC.SetBonusScores = {
    -- [[ LOW LEVEL / LEVELING ]]
    [161] = { [2]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=10}}, [5]={stats={["ITEM_MOD_STRENGTH_SHORT"]=10}} }, -- Defias
    [162] = { [2]={stats={["ITEM_MOD_NATURE_RESISTANCE_SHORT"]=7}}, [5]={stats={["ITEM_MOD_INTELLECT_SHORT"]=10}} }, -- Viper
    [163] = { [2]={stats={["ITEM_MOD_ARMOR_SHORT"]=10}}, [6]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=20}} }, -- Scarlet
    [143] = { [2]={stats={["ITEM_MOD_HIT_RATING_SHORT"]=32}} }, -- Devilsaur (2% Hit)
    [144] = { [2]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=20}} }, -- Ironfeather
    [421] = { [3]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=35}} }, -- Bloodvine
    [489] = { [2]={stats={["ITEM_MOD_HIT_RATING_SHORT"]=15}} }, -- Black Dragon Mail
    [123] = { [3]={stats={["ITEM_MOD_HIT_RATING_SHORT"]=10}} }, -- Bloodmail

    -- [[ DUNGEON SET 1 & 2 (Tier 0 / 0.5) ]]
    [184] = { [4]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=40}} }, -- Shadowcraft
    [181] = { [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=20}} }, -- Magister's
    [512] = { [4]={score=60}, [6]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=40}} }, -- Darkmantle

    -- [[ CLASSIC RAIDS ]]
    -- Tier 3 (Naxx)
    [524] = { [2]={score=25}, [4]={score=30}, [6]={score=40} }, -- Bonescythe
    [529] = { [2]={score=20}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} }, -- Plagueheart
    [526] = { [2]={score=20}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} }, -- Frostfire
    [523] = { [2]={score=25}, [4]={score=35} }, -- Dreadnaught
    -- Tier 2 (BWL)
    [213] = { [3]={score=15}, [5]={score=20}, [8]={score=30} }, -- Bloodfang
    [212] = { [3]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=15}}, [5]={score=20} }, -- Nemesis
    [217] = { [3]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=15}}, [5]={score=20} }, -- Judgement
    [215] = { [3]={score=15}, [5]={stats={["ITEM_MOD_STAMINA_SHORT"]=10}} }, -- Dragonstalker
    -- ZG
    [461] = { [2]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=50}} }, -- Twin Blades of Hakkari (Sword Skill + AP)

    -- [[ TBC CRAFTED ]]
    [559] = { [2] = { stats = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 25 } } }, -- Spellstrike
    [571] = { [2] = { stats = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 35 } } }, -- Whitemend
    [619] = { [3] = { stats = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 40 } } }, -- Primalstrike
    [552] = { [3] = { stats = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 35 } } }, -- Wrath of Spellfire
    [554] = { [3] = { stats = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 10 } } }, -- Primal Mooncloth

    -- [[ TBC DUNGEON SET 3 ]]
    [650] = { [2] = { score = 20 }, [4] = { stats = { ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 40 } } }, -- Beast Lord
    [653] = { [2] = { stats = { ["ITEM_MOD_STRENGTH_SHORT"] = 20 } }, [4] = { score = 40 } }, -- Bold Armor
    [659] = { [2] = { stats = { ["ITEM_MOD_HIT_RATING_SHORT"] = 35 } }, [4] = { stats = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30 } } }, -- Wastewalker
    [658] = { [2] = { stats = { ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 35 } }, [4] = { stats = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 30 } } }, -- Mana-Etched
    [620] = { [2] = { score = 25 }, [4] = { stats = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 20 } } }, -- Assassination

    -- [[ TIER 4 (TBC) ]]
    [624] = { [2] = { score=30 }, [4] = { stats={["ITEM_MOD_MANA_REGENERATION_SHORT"]=10} } }, -- Paladin Holy
    [625] = { [2] = { score=35 }, [4] = { score=50 } }, -- Paladin Prot
    [626] = { [2] = { score=25 }, [4] = { score=40 } }, -- Paladin Ret
    [655] = { [2] = { score=30 }, [4] = { score=45 } }, -- Warrior DPS
    [654] = { [2] = { score=25 }, [4] = { score=50 } }, -- Warrior Tank
    [651] = { [2] = { score=30 }, [4] = { score=60 } }, -- Hunter
    [621] = { [2] = { score=80 }, [4] = { score=50 } }, -- Rogue
    [645] = { [2] = { stats={["ITEM_MOD_SPELL_POWER_SHORT"]=35} }, [4] = { score=80 } }, -- Warlock
    [648] = { [2] = { score=15 }, [4] = { stats={["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=35} } }, -- Mage
    [640] = { [2] = { score=30 }, [4] = { stats={["ITEM_MOD_STRENGTH_SHORT"]=20} } }, -- Druid Feral
    [638] = { [2] = { score=20 }, [4] = { score=40 } }, -- Druid Resto
    [639] = { [2] = { stats={["ITEM_MOD_MANA_REGENERATION_SHORT"]=8} }, [4] = { score=45 } }, -- Druid Balance
    [633] = { [2] = { stats={["ITEM_MOD_STRENGTH_SHORT"]=20} }, [4] = { score=50 } }, -- Shaman Enh
    [632] = { [2] = { score=25 }, [4] = { stats={["ITEM_MOD_SPELL_POWER_SHORT"]=40} } }, -- Shaman Ele

    -- [[ TIER 5 (TBC) ]]
    [652] = { [2] = { score=50 }, [4] = { stats={["ITEM_MOD_CRIT_RATING_SHORT"]=35} } }, -- Hunter T5
    [622] = { [2] = { score=60 }, [4] = { score=40 } }, -- Rogue T5
    [649] = { [2] = { score=50 }, [4] = { stats={["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=70} } }, -- Mage T5
    [646] = { [2] = { score=60 }, [4] = { score=55 } }, -- Warlock T5

    -- [[ TIER 6 (TBC) ]]
    [669] = { [2] = { score=40 }, [4] = { score=120 } }, -- Hunter T6
    [668] = { [2] = { score=50 }, [4] = { score=100 } }, -- Rogue T6
    [672] = { [2] = { score=40 }, [4] = { score=80 } }, -- Warrior Tank T6
    [673] = { [2] = { score=45 }, [4] = { score=110 } }, -- Warrior DPS T6
    [670] = { [2] = { score=50 }, [4] = { score=130 } }, -- Warlock T6
    [671] = { [2] = { score=40 }, [4] = { score=125 } }, -- Mage T6
    [681] = { [2] = { score=35 }, [4] = { score=120 } }, -- Paladin Ret T6
    [676] = { [2] = { score=50 }, [4] = { score=110 } }, -- Druid Feral T6

    -- [[ LEGENDARY ]]
    [699] = { [2] = { score=500 } }, -- Warglaives
}

-- ============================================================================
-- 6. PROC DATA (TRINKETS & WEAPONS)
-- ============================================================================
MSC.ProcDB = {
    -- [[ TBC TRINKETS ]]
    [28830] = { ppm=1.0, val=325, dur=10, stat="ITEM_MOD_HASTE_RATING_SHORT" },     -- Dragonspine Trophy
    [29370] = { ppm=0.8, val=260, dur=10, stat="ITEM_MOD_ATTACK_POWER_SHORT" },      -- Icon of Unyielding Courage
    [27683] = { ppm=1.0, val=320, dur=6,  stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT" },-- Quagmirran's Eye
    [28034] = { ppm=1.2, val=300, dur=10, stat="ITEM_MOD_ATTACK_POWER_SHORT" },      -- Hourglass of the Unraveller
    [28223] = { ppm=1.5, val=320, dur=10, stat="ITEM_MOD_ATTACK_POWER_SHORT" },      -- Abacus of Violent Odds

    -- [[ CLASSIC TRINKETS (Still Viable) ]]
    [11815] = { score=20 }, -- Hand of Justice
    [23207] = { score=30 }, -- Mark of the Champion
    [19379] = { score=35 }, -- Neltharion's Tear
    [19406] = { score=35 }, -- Drake Fang Talisman

    -- [[ WEAPONS ]]
    [28438] = { score=50 }, -- Dragonmaw
    [28439] = { score=60 }, -- Dragonstrike
    [28767] = { score=40 }, -- The Decapitator
    [19019] = { score=30 }, -- Thunderfury
}

-- ============================================================================
-- 7. INITIALIZATION
-- ============================================================================
function MSC:BuildDatabase()
    for setID, data in pairs(MSC.RawSetData) do
        local itemIDs = data[1]
        for _, itemID in ipairs(itemIDs) do
            MSC.ItemSetMap[itemID] = setID
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

function MSC:GetProcData(id)
    return MSC.ProcDB[tonumber(id)]
end

-- Run initialization
MSC:BuildDatabase()