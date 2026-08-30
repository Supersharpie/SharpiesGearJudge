local _, MSC = ...

-- ============================================================================
-- DATA: PLACEHOLDERS (Prevents errors if files aren't loaded)
-- ============================================================================
MSC.PvPDB       = MSC.PvPDB or {}
MSC.WeaponDB    = MSC.WeaponDB or {}
MSC.TrinketDB   = MSC.TrinketDB or {}
MSC.RingDB      = MSC.RingDB or {}
MSC.ClassItemDB = MSC.ClassItemDB or {}
-- ============================================================================
--	DATA: ITEM SETS (MASTER COMPLETIONIST LIST)
-- ============================================================================
-- Format: [SetID] = { {ItemIDs} }

MSC.SetDefinitions = {
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
    
    -- ========================================================================
    -- [[ CLASSIC PVP (RANK 12-14) - LEVEL 60 ]]
    -- ========================================================================
    -- [[ WARRIOR ]]
    [384] = { {16477,16478,16479,16480,16483,16484} }, -- Field Marshal's Battlegear (Ally)
    [383] = { {16541,16542,16543,16544,16545,16548} }, -- Warlord's Battlegear (Horde)
    -- [[ PALADIN ]]
    [386] = { {16472,16473,16474,16475,16476,16471} }, -- Field Marshal's Aegis (Ally)
    -- [[ HUNTER ]]
    [388] = { {16462,16463,16464,16465,16466,16467,16468} }, -- Field Marshal's Pursuit (Ally)
    [387] = { {16518,16519,16520,16521,16522,16523,16524} }, -- Warlord's Pursuit (Horde)
    -- [[ ROGUE ]]
    [390] = { {16453,16454,16455,16456,16457,16459} }, -- Field Marshal's Vestments (Ally)
    [389] = { {16550,16551,16552,16554,16555,16558} }, -- Warlord's Vestments (Horde)
    -- [[ PRIEST ]]
    [392] = { {17602,17603,17604,17605,17607,17608} }, -- Field Marshal's Raiment (Ally)
    [391] = { {17618,17620,17622,17623,17624,17625} }, -- Warlord's Raiment (Horde)
    -- [[ SHAMAN ]]
    [393] = { {16573,16574,16577,16578,16579,16580} }, -- Warlord's Earthshaker (Horde)
    -- [[ MAGE ]]
    [395] = { {16437,16440,16441,16442,16443,16444} }, -- Field Marshal's Regalia (Ally)
    [394] = { {16533,16534,16535,16536,16539,16540} }, -- Warlord's Regalia (Horde)
    -- [[ WARLOCK ]]
    [397] = { {17578,17579,17580,17581,17583,17584} }, -- Field Marshal's Threads (Ally)
    [396] = { {17562,17564,17566,17567,17568,17569} }, -- Warlord's Threads (Horde)
    -- [[ DRUID ]]
    [399] = { {16446,16448,16449,16450,16451,16452} }, -- Field Marshal's Sanctuary (Ally)
    [398] = { {16559,16561,16562,16563,16564,16560} }, -- Warlord's Sanctuary (Horde)

    -- [[ RARE SETS (RANK 7-10) ]]
    [538] = { {23243,23244,23300,23301,23242,23245} }, -- Champion's Battlegear (Ally War)
    [543] = { {22872,22873,22886,22874,22875,22887} }, -- Legionnaire's Battlegear (Horde War)
    [537] = { {23259,23260,23302,23303,23261,23262} }, -- Champion's Vestments (Ally Rogue)
    [542] = { {22877,22878,22883,22881,22882,22885} }, -- Legionnaire's Vestments (Horde Rogue)

    -- [[ PVP / ARATHI BASIN ]]
    [467] = { {20057,20041,20048} }, -- Highlander's Resolution
    [469] = { {20055,20043,20050} }, -- Highlander's Determination
    [470] = { {20056,20044,20051} }, -- Highlander's Fortitude
    [471] = { {20059,20045,20052} }, -- Highlander's Purpose
    [483] = { {20158,20150,20154} }, -- Defiler's Determination
    [487] = { {20212,20204,20208} }, -- Defiler's Resolution
    [588] = { {28853,28855,28851,28852,28854} }, -- High Warlord (Plate)
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
    [524] = { [2]={score=25}, [4]={score=30}, [6]={score=40} }, -- Bonescythe
    [529] = { [2]={score=20}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} }, -- Plagueheart
    [526] = { [2]={score=20}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} }, -- Frostfire
    [523] = { [2]={score=25}, [4]={score=35} }, -- Dreadnaught
    [213] = { [3]={score=15}, [5]={score=20}, [8]={score=30} }, -- Bloodfang
    [212] = { [3]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=15}}, [5]={score=20} }, -- Nemesis
    [217] = { [3]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=15}}, [5]={score=20} }, -- Judgement
    [215] = { [3]={score=15}, [5]={stats={["ITEM_MOD_STAMINA_SHORT"]=10}} }, -- Dragonstalker
    [461] = { [2]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=50}} }, -- Twin Blades of Hakkari

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
}

-- ============================================================================
-- 6. TBC SPECIFIC DATA (WRAPPED TO HIDE FROM ERA)
-- ============================================================================
if not MSC.IsEra then
    
    -- TBC ITEM SET DEFINITIONS
    local tbcSets = {
        -- CRAFTED (Tailoring/Leatherworking/Blacksmithing)
        [559] = { {24266, 24262} }, -- Spellstrike
        [571] = { {24264, 24261} }, -- Whitemend
        [572] = { {24267, 24263} }, -- Battlecast
        [619] = { {29525, 29527, 29526} }, -- Primalstrike
        [617] = { {29519, 29521, 29520} }, -- Netherstrike
        [618] = { {29522, 29523, 29524} }, -- Windhawk
        [552] = { {21848, 21847, 21846} }, -- Wrath of Spellfire
        [553] = { {21869, 21871, 21870} }, -- Shadow's Embrace
        [554] = { {21874, 21875, 21873} }, -- Primal Mooncloth
        [567] = { {23564, 23565, 23563, 23566, 23561, 23562, 23559, 23560} }, -- Khorium Ward (Tank)
        [568] = { {23554, 23555, 23556, 23553, 23551, 23552, 23550, 23549} }, -- Faith in Felsteel (Heal/Tank)
        [570] = { {23574, 23576, 23575, 23577, 23572, 23573, 23571, 23570} }, -- Burning Rage (Melee)

        -- DUNGEON SET 3 (Bold = Tank, Desolation = Melee, etc.)
        [650] = { {28275, 27801, 28228, 27474, 27874} }, -- Beast Lord (Hunter)
        [653] = { {28350, 27803, 28205, 27475, 27977} }, -- Bold Armor (Plate Tank)
        [660] = { {28192, 27713, 28401, 27528, 27936} }, -- Desolation (Plate DPS)
        [659] = { {28224, 27797, 28264, 27531, 27837} }, -- Wastewalker (Rogue/Druid)
        [658] = { {28193, 27796, 28191, 27465, 27907} }, -- Mana-Etched (Mage/Lock)
        [662] = { {28413, 27775, 28230, 27536, 27875} }, -- Hallowed (Priest Heal)
        [644] = { {28415, 27778, 28232, 27537, 27948} }, -- Oblivion (Warlock/Shadow Priest)
        [620] = { {28414, 27776, 28204, 27509, 27908} }, -- Assassination (Rogue)
        [630] = { {28349, 27802, 28231, 27510, 27909} }, -- Tidefury (Shaman)
        [647] = { {28278, 27738, 28229, 27508, 27838} }, -- Incanter's (Mage)
        [637] = { {28348, 27737, 28202, 27468, 27873} }, -- Moonglade (Druid)
        [661] = { {27712, 27910, 28194, 28226, 27489} }, -- Doomplate (Warrior)
        [623] = { {28285, 27739, 28203, 27535, 27839} }, -- Righteous (Paladin)

        -- TIER 4
        [655] = { {29021, 29023, 29019, 29020, 29022} }, -- Warbringer (DPS)
        [654] = { {29011, 29016, 29012, 29017, 29015} }, -- Warbringer (Tank)
        [624] = { {29061, 29064, 29062, 29065, 29063} }, -- Justicar (Tank)
        [625] = { {29068, 29070, 29066, 29067, 29069} }, -- Justicar (Heal)
        [626] = { {29073, 29075, 29071, 29072, 29074} }, -- Justicar (Ret)
        [651] = { {29081, 29084, 29082, 29085, 29083} }, -- Demon Stalker (Hunter)
        [621] = { {29044, 29047, 29045, 29048, 29046} }, -- Netherblade (Rogue)
        [640] = { {29098, 29100, 29096, 29097, 29099} }, -- Malorne (Feral)
        [638] = { {29086, 29089, 29087, 29090, 29088} }, -- Malorne (Boomkin)
        [641] = { {29093, 29095, 29091, 29092, 29094} }, -- Malorne (Resto)
        [631] = { {29033, 29034, 29035, 29036, 29037} }, -- Cyclone (Enh)
        [633] = { {29028, 29031, 29029, 29032, 29030} }, -- Cyclone (Ele)
        [632] = { {29038, 29039, 29040, 29041, 29042} }, -- Cyclone (Resto)
        [648] = { {29076, 29079, 29077, 29080, 29078} }, -- Aldor (Mage)
        [645] = { {28963, 28967, 28964, 28968, 28966} }, -- Voidheart (Warlock)
        [663] = { {29049, 29054, 29050, 29055, 29053} }, -- Incarnate (Shadow)
        [664] = { {29058, 29060, 29056, 29057, 29059} }, -- Incarnate (Heal)

        -- TIER 5
        [656] = { {30115, 30117, 30113, 30114, 30116} }, -- Destroyer (DPS)
        [657] = { {30120, 30122, 30118, 30119, 30121} }, -- Destroyer (Tank)
        [627] = { {30136, 30138, 30134, 30135, 30137} }, -- Crystalforge (Ret)
        [628] = { {30125, 30127, 30123, 30124, 30126} }, -- Crystalforge (Tank)
        [629] = { {30131, 30133, 30129, 30130, 30132} }, -- Crystalforge (Heal)
        [652] = { {30141, 30143, 30139, 30140, 30142} }, -- Rift Stalker
        [622] = { {30146, 30149, 30144, 30145, 30148} }, -- Deathmantle
        [602] = { {30228, 30230, 30222, 30223, 30229} }, -- Nordrassil (Resto)
        [642] = { {30216, 30217, 30219, 30220, 30221} }, -- Nordrassil (Feral)
        [643] = { {30231, 30232, 30233, 30234, 30235} }, -- Nordrassil (Balance)
        [649] = { {30206, 30210, 30196, 30205, 30207} }, -- Tirisfal (Mage)
        [646] = { {30212, 30215, 30214, 30211, 30213} }, -- Corruptor (Warlock)
        [665] = { {30152, 30154, 30150, 30151, 30153} }, -- Avatar (Heal)
        [666] = { {30161, 30163, 30159, 30160, 30162} }, -- Avatar (Shadow)
        [634] = { {30166, 30168, 30164, 30165, 30167} }, -- Cataclysm (Ele)
        [635] = { {30185, 30189, 30190, 30192, 30194} }, -- Cataclysm (Enh)
        [636] = { {30171, 30172, 30173, 30169, 30170} }, -- Cataclysm (Resto)

        -- TIER 6
        [672] = { {30972, 30979, 30975, 34441, 30969, 34560, 34543} }, -- Onslaught (DPS)
        [673] = { {30974, 30980, 30976, 34442, 30970, 34561, 34544} }, -- Onslaught (Tank)
        [679] = { {30987, 30998, 30991, 34433, 30985, 34564, 34529} }, -- Lightbringer (Heal)
        [681] = { {30988, 30996, 30992, 34432, 30983, 34565, 34530} }, -- Lightbringer (Ret)
        [680] = { {30990, 30995, 30997, 34431, 30989, 34566, 34528} }, -- Lightbringer (Tank)
        [669] = { {31003, 31006, 31004, 34443, 31001, 34549, 34570} }, -- Gronnstalker
        [668] = { {31027, 31030, 31028, 34448, 31026, 34558, 34575} }, -- Slayer
        [676] = { {31039, 31048, 31042, 34444, 31034, 34556, 34573} }, -- Thunderheart (Feral)
        [677] = { {31040, 31046, 31049, 34446, 31037, 34554, 34571} }, -- Thunderheart (Resto)
        [678] = { {31035, 31041, 31045, 34445, 31043, 34555, 34572} }, -- Thunderheart (Balance)
        [671] = { {31056, 31059, 31057, 34447, 31055, 34557, 34574} }, -- Tempest (Mage)
        [670] = { {31051, 31054, 31052, 34436, 31050, 34563, 34527} }, -- Malefic (Warlock)
        [675] = { {31063, 31069, 31066, 34435, 31060, 34559, 34526} }, -- Absolution (Heal)
        [674] = { {31061, 31064, 31065, 34434, 31067, 34562, 34525} }, -- Absolution (Shadow)
        [682] = { {31015, 31024, 31018, 34439, 31011, 34546, 34567} }, -- Skyshatter (Ele)
        [683] = { {31012, 31019, 31022, 34437, 31014, 34547, 34568} }, -- Skyshatter (Enh)
        [684] = { {31016, 31020, 31023, 34438, 31017, 34545, 34569} }, -- Skyshatter (Resto)

        -- LEGENDARY
        [699] = { {32837, 32838} }, -- Warglaives of Azzinoth

        -- ARENA S1 (Gladiator)
        [700] = { {28331,28334,28332,28335,28333} }, -- War
        [701] = { {28336,28339,28337,28340,28338} }, -- Lock
        [702] = { {28341,28344,28342,28345,28343} }, -- Rogue
        [703] = { {28346,28349,28347,28350,28348} }, -- Shaman (Ele)
        [704] = { {28351,28354,28352,28355,28353} }, -- Shaman (Res)
        [705] = { {28356,28359,28357,28360,28358} }, -- Shaman (Enh)
        [706] = { {28361,28364,28362,28365,28363} }, -- Mage
        [707] = { {28366,28369,28367,28370,28368} }, -- Priest (Heal)
        [708] = { {28371,28374,28372,28375,28373} }, -- Priest (Shadow)
        [709] = { {31580,31584,31581,31588,31582} }, -- Druid (Bal)
        [710] = { {31590,31594,31591,31598,31592} }, -- Druid (Feral)
        [711] = { {31600,31604,31601,31608,31602} }, -- Druid (Resto)
        [712] = { {31610,31614,31611,31618,31612} }, -- Paladin (Holy)
        [713] = { {31620,31624,31621,31628,31622} }, -- Paladin (Ret)
        [714] = { {31630,31634,31631,31638,31632} }, -- Hunter
        -- ARENA S2 (Merciless)
        [720] = { {31973,31976,31974,31977,31975} }, -- War
        [721] = { {31988,31996,31991,31997,31994} }, -- Lock
        [722] = { {31960,31965,31961,31966,31963} }, -- Rogue
        [723] = { {31998,32002,31999,32003,32000} }, -- Hunter
        [724] = { {31978,31986,31981,31987,31984} }, -- Shaman (Ele)
        [725] = { {31967,31971,31968,31972,31969} }, -- Shaman (Enh)
        [726] = { {32047,32051,32048,32052,32049} }, -- Mage
        [727] = { {32054,32058,32055,32059,32056} }, -- Priest (Shadow)
        [728] = { {32033,32037,32034,32038,32035} }, -- Priest (Heal)
        [729] = { {32040,32045,32041,32046,32043} }, -- Druid (Bal)
        [730] = { {32019,32024,32020,32025,32022} }, -- Druid (Feral)
        [731] = { {32012,32017,32013,32018,32015} }, -- Druid (Resto)
        [732] = { {32005,32010,32006,32011,32008} }, -- Paladin (Holy)
        [733] = { {32026,32031,32027,32032,32029} }, -- Paladin (Ret)
        [734] = { {32061,32065,32062,32066,32063} }, -- Shaman (Resto)

        -- ARENA S3 (Vengeful)
        [740] = { {33665,33668,33666,33669,33667} }, -- War
        [741] = { {33671,33674,33672,33675,33673} }, -- Lock
        [742] = { {33677,33680,33678,33681,33679} }, -- Rogue
        [743] = { {33683,33686,33684,33687,33685} }, -- Hunter
        [744] = { {33689,33692,33690,33693,33691} }, -- Shaman (Ele)
        [745] = { {33695,33698,33696,33699,33697} }, -- Shaman (Enh)
        [746] = { {33701,33704,33702,33705,33703} }, -- Mage
        [747] = { {33719,33722,33720,33723,33721} }, -- Priest (Shadow)
        [748] = { {33707,33710,33708,33711,33709} }, -- Priest (Heal)
        [749] = { {33713,33716,33714,33717,33715} }, -- Druid (Bal)
        [750] = { {33725,33728,33726,33729,33727} }, -- Druid (Feral)
        [751] = { {33731,33734,33732,33735,33733} }, -- Druid (Resto)
        [752] = { {33737,33740,33738,33741,33739} }, -- Paladin (Holy)
        [753] = { {33743,33746,33744,33747,33745} }, -- Paladin (Ret)
        [754] = { {33758,33761,33759,33762,33760} }, -- Shaman (Resto)

        -- ARENA S4 (Brutal Gladiator - Phase 5)
        [762] = { {35066,35067,35068,35069,35070} }, -- War
        [763] = { {35047,35048,35049,35050,35051} }, -- Rogue
        [764] = { {35032,35033,35034,35035,35036} }, -- Hunter
        [765] = { {35080,35081,35082,35083,35084} }, -- Paladin (Holy)
        [766] = { {35085,35086,35087,35088,35089} }, -- Paladin (Ret)
        [767] = { {35090,35091,35092,35093,35094} }, -- Paladin (Shock)
        [768] = { {35098,35099,35100,35101,35102} }, -- Shaman (Ele)
        [769] = { {35103,35104,35105,35106,35107} }, -- Shaman (Enh)
        [770] = { {35108,35109,35110,35111,35112} }, -- Shaman (Resto)
        [771] = { {35071,35072,35073,35074,35075} }, -- Mage
        [772] = { {35076,35077,35078,35079,35080} }, -- Priest (Heal)
        [773] = { {35129,35130,35131,35132,35133} }, -- Priest (Shadow)
        [774] = { {35118,35119,35120,35121,35122} }, -- Warlock
        [775] = { {35113,35114,35115,35116,35117} }, -- Druid (Bal)
        [776] = { {35124,35125,35126,35127,35128} }, -- Druid (Feral)
        [777] = { {35134,35135,35136,35137,35138} }, -- Druid (Resto)
		
		-- NICHE SETS
        [667] = { {32946, 32945} }, -- The Fists of Fury (Hyjal Trash Claws)
        [616] = { {31749, 31750} }, -- The Twin Stars (Mana Tombs Rings)
        [615] = { {28189, 27901} }, -- Latro's Flurry (D3 Swords)
		
		-- [[ LEVEL 70 HONOR SETS (RARE QUALITY) ]]
        -- These are the "Blue" PvP sets (Grand Marshal / High Warlord at Lvl 70)
        
        -- WARRIOR (Plate)
        [580] = { {28699, 28700, 28701, 28702, 28703} }, -- Alliance (GM)
        [581] = { {28853, 28854, 28855, 28856, 28857} }, -- Horde (HWL)
        
        -- ROGUE (Leather)
        [582] = { {28704, 28705, 28706, 28707, 28708} }, -- Alliance
        [583] = { {28858, 28859, 28860, 28861, 28862} }, -- Horde
        
        -- HUNTER (Chain)
        [584] = { {28694, 28695, 28696, 28697, 28698} }, -- Alliance
        [585] = { {28848, 28849, 28850, 28851, 28852} }, -- Horde
        
        -- MAGE/WARLOCK (Dreadweave)
        [586] = { {28684, 28685, 28686, 28687, 28688} }, -- Alliance
        [587] = { {28838, 28839, 28840, 28841, 28842} }, -- Horde
        
        -- MAGE/WARLOCK (Silk/Satin)
        [588] = { {28714, 28715, 28716, 28717, 28718} }, -- Alliance
        [589] = { {28868, 28869, 28870, 28871, 28872} }, -- Horde
        
        -- PRIEST (Mooncloth/Heal)
        [590] = { {28724, 28725, 28726, 28727, 28728} }, -- Alliance
        [591] = { {28878, 28879, 28880, 28881, 28882} }, -- Horde
        
        -- DRUID (Dragonhide/Feral)
        [592] = { {28689, 28690, 28691, 28692, 28693} }, -- Alliance
        [593] = { {28843, 28844, 28845, 28846, 28847} }, -- Horde
        
        -- DRUID (Kodohide/Resto)
        [594] = { {28709, 28710, 28711, 28712, 28713} }, -- Alliance
        [595] = { {28863, 28864, 28865, 28866, 28867} }, -- Horde
        
        -- SHAMAN (Mail/Enhance)
        [596] = { {28679, 28680, 28681, 28682, 28683} }, -- Alliance
        [597] = { {28833, 28834, 28835, 28836, 28837} }, -- Horde
        
        -- SHAMAN (Mail/Ele)
        [598] = { {28719, 28720, 28721, 28722, 28723} }, -- Alliance
        [599] = { {28873, 28874, 28875, 28876, 28877} }, -- Horde
        
        -- PALADIN (Plate/Ret)
        [600] = { {28729, 28730, 28731, 28732, 28733} }, -- Alliance
        [601] = { {28883, 28884, 28885, 28886, 28887} }, -- Horde
    }
    
    -- TBC SET BONUS SCORES
    local tbcScores = {
	-- CRAFTED
        [559] = { [2] = { stats = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 25 } } }, -- Spellstrike
        [571] = { [2] = { stats = { ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 35 } } }, -- Whitemend
        [619] = { [3] = { stats = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 40 } } }, -- Primalstrike
        [552] = { [3] = { stats = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 35 } } }, -- Spellfire (Fire/Arcane)
        [554] = { [3] = { stats = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 10 } } }, -- Primal Mooncloth
        [570] = { [2] = { score = 20 } }, -- Burning Rage

        -- DUNGEON SET 3
        [650] = { [2] = { score = 20 }, [4] = { stats = { ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 40 } } }, -- Beast Lord
        [653] = { [2] = { stats = { ["ITEM_MOD_STRENGTH_SHORT"] = 20 } }, [4] = { score = 40 } }, -- Bold
        [659] = { [2] = { stats = { ["ITEM_MOD_HIT_RATING_SHORT"] = 35 } }, [4] = { stats = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30 } } }, -- Wastewalker
        [658] = { [2] = { stats = { ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 35 } }, [4] = { stats = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 30 } } }, -- Mana-Etched
        [620] = { [2] = { score = 25 }, [4] = { stats = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 20 } } }, -- Assassination
        [624] = { [2] = { score=30 }, [4] = { stats={["ITEM_MOD_MANA_REGENERATION_SHORT"]=10} } }, -- Justicar Tank
        [660] = { [2] = { stats={["ITEM_MOD_HIT_RATING_SHORT"]=35} }, [4] = { stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=20} } }, -- Desolation
        [662] = { [2] = { stats={["ITEM_MOD_MANA_REGENERATION_SHORT"]=15} }, [4] = { score=35 } }, -- Hallowed
        [644] = { [2] = { stats={["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=35} }, [4] = { score=40 } }, -- Oblivion
        [630] = { [2] = { stats={["ITEM_MOD_MANA_REGENERATION_SHORT"]=15} }, [4] = { score=40 } }, -- Tidefury
        [647] = { [2] = { score=20 }, [4] = { stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25} } }, -- Incanter
        [637] = { [2] = { stats={["ITEM_MOD_MANA_REGENERATION_SHORT"]=15} }, [4] = { stats={["ITEM_MOD_SPELL_POWER_SHORT"]=20} } }, -- Moonglade

        -- TIER 4
        [655] = { [2] = { score=30 }, [4] = { score=45 } }, -- Warbringer DPS
        [654] = { [2] = { score=25 }, [4] = { score=50 } }, -- Warbringer Tank
        [625] = { [2] = { score=35 }, [4] = { score=50 } }, -- Justicar Heal
        [626] = { [2] = { score=25 }, [4] = { score=40 } }, -- Justicar Ret
        [651] = { [2] = { score=30 }, [4] = { score=60 } }, -- Demon Stalker
        [621] = { [2] = { score=80 }, [4] = { score=50 } }, -- Netherblade
        [645] = { [2] = { stats={["ITEM_MOD_SPELL_POWER_SHORT"]=35} }, [4] = { score=80 } }, -- Voidheart
        [648] = { [2] = { score=15 }, [4] = { stats={["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=35} } }, -- Aldor
        [640] = { [2] = { score=30 }, [4] = { stats={["ITEM_MOD_STRENGTH_SHORT"]=20} } }, -- Malorne Feral
        [638] = { [2] = { score=20 }, [4] = { score=40 } }, -- Malorne Balance
        [641] = { [2] = { stats={["ITEM_MOD_MANA_REGENERATION_SHORT"]=8} }, [4] = { score=45 } }, -- Malorne Resto
        [631] = { [2] = { stats={["ITEM_MOD_STRENGTH_SHORT"]=20} }, [4] = { score=50 } }, -- Cyclone Enh
        [633] = { [2] = { stats={["ITEM_MOD_MANA_REGENERATION_SHORT"]=8} }, [4] = { score=45 } }, -- Cyclone Ele
        [632] = { [2] = { score=25 }, [4] = { stats={["ITEM_MOD_SPELL_POWER_SHORT"]=40} } }, -- Cyclone Resto
        [663] = { [2] = { score=25 }, [4] = { score=40 } }, -- Incarnate Shadow
        [664] = { [2] = { score=25 }, [4] = { score=40 } }, -- Incarnate Heal

        -- TIER 5
        [652] = { [2] = { score=50 }, [4] = { stats={["ITEM_MOD_CRIT_RATING_SHORT"]=35} } }, -- Rift Stalker
        [622] = { [2] = { score=60 }, [4] = { score=40 } }, -- Deathmantle
        [649] = { [2] = { score=50 }, [4] = { stats={["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=70} } }, -- Tirisfal
        [646] = { [2] = { score=60 }, [4] = { score=55 } }, -- Corruptor
        [656] = { [2] = { score=40 }, [4] = { stats={["ITEM_MOD_HASTE_RATING_SHORT"]=50} } }, -- Destroyer DPS
        [657] = { [2] = { score=40 }, [4] = { score=60 } }, -- Destroyer Tank
        [627] = { [2] = { score=30 }, [4] = { score=50 } }, -- Crystalforge Ret
        [628] = { [2] = { score=40 }, [4] = { score=60 } }, -- Crystalforge Tank
        [642] = { [2] = { score=30 }, [4] = { score=50 } }, -- Nordrassil Feral
        [643] = { [2] = { score=25 }, [4] = { score=45 } }, -- Nordrassil Balance
        [602] = { [2] = { stats={["ITEM_MOD_MANA_REGENERATION_SHORT"]=10} }, [4] = { score=50 } }, -- Nordrassil Resto
        [629] = { [2] = { score=35 }, [4] = { score=50 } }, -- Crystalforge Heal
        [634] = { [2] = { score=25 }, [4] = { score=45 } }, -- Cataclysm Ele
        [635] = { [2] = { score=30 }, [4] = { score=50 } }, -- Cataclysm Enh
        [636] = { [2] = { stats={["ITEM_MOD_MANA_REGENERATION_SHORT"]=10} }, [4] = { score=50 } }, -- Cataclysm Resto
        [665] = { [2] = { score=25 }, [4] = { score=40 } }, -- Avatar Heal
        [666] = { [2] = { score=25 }, [4] = { score=40 } }, -- Avatar Shadow
        [617] = { [3] = { stats={["ITEM_MOD_AGILITY_SHORT"]=20} } }, -- Netherstrike
        [618] = { [3] = { stats={["ITEM_MOD_INTELLECT_SHORT"]=20} } }, -- Windhawk
        [623] = { [2] = { score=25 }, [4] = { score=40 } }, -- Righteous
        [661] = { [2] = { score=20 }, [4] = { score=35 } }, -- Doomplate
        [677] = { [2] = { score=40 }, [4] = { score=100 } }, -- Thunderheart Resto
        [678] = { [2] = { score=30 }, [4] = { score=90 } }, -- Thunderheart Balance
        [674] = { [2] = { score=40 }, [4] = { score=100 } }, -- Absolution Shadow
        [675] = { [2] = { score=35 }, [4] = { score=100 } }, -- Absolution Heal
        [682] = { [2] = { score=40 }, [4] = { score=90 } }, -- Skyshatter Ele
        [684] = { [2] = { stats={["ITEM_MOD_MANA_REGENERATION_SHORT"]=10} }, [4] = { score=85 } }, -- Skyshatter Resto
        [772] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=40}} }, -- S4 Priest Heal

        -- TIER 6
        [669] = { [2] = { score=40 }, [4] = { score=120 } }, -- Gronnstalker
        [668] = { [2] = { score=50 }, [4] = { score=100 } }, -- Slayer
        [672] = { [2] = { score=40 }, [4] = { score=80 } }, -- Onslaught DPS
        [673] = { [2] = { score=45 }, [4] = { score=110 } }, -- Onslaught Tank
        [670] = { [2] = { score=50 }, [4] = { score=130 } }, -- Malefic
        [671] = { [2] = { score=40 }, [4] = { score=125 } }, -- Tempest
        [681] = { [2] = { score=35 }, [4] = { score=120 } }, -- Lightbringer Ret
        [676] = { [2] = { score=50 }, [4] = { score=110 } }, -- Thunderheart Feral
        [683] = { [2] = { score=45 }, [4] = { score=90 } }, -- Skyshatter Enh

        -- LEGENDARY
        [699] = { [2] = { score=500 } }, -- Warglaives (Haste Proc)

        -- PVP ARENA S1-S4 (Resilience & Stat Boosts)
        -- General Rule: 2pc is Resilience, 4pc is Stat or Spec Specific
        [700] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=20}} },
        [703] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=10}} },
        [702] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_AGILITY_SHORT"]=15}} },
        [706] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} },
        [707] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} },
        [704] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=40}} },
        [714] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={score=20} },
		
		-- S2 (Merciless) - Approx Values
        [720] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={score=40} }, -- War
        [723] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=10}} }, -- Hunter
        [726] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=28}} }, -- Mage
        [730] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=15}} }, -- Feral

        -- S3 (Vengeful) - Approx Values
        [740] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={score=50} }, -- War
        [743] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=10}} }, -- Hunter
        [746] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=30}} }, -- Mage
        [750] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=15}} }, -- Feral

        -- S4 (Brutal) - High Values
        [762] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={score=60} }, -- War
        [764] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=15}} }, -- Hunter
        [771] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=35}} }, -- Mage
        [763] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=20}} }, -- Rogue
        [774] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=35}} }, -- Warlock
        [776] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=20}} }, -- Feral

        -- NICHE
        [667] = { [2] = { score = 40, note = MSC.L["Chance on hit: Haste"] } }, -- Fists of Fury
        [616] = { [2] = { stats = { ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15, ["ITEM_MOD_HIT_RATING_SHORT"]=15 } } }, -- Twin Stars
        [615] = { [2] = { stats = { ["ITEM_MOD_ATTACK_POWER_SHORT"]=30 } } }, -- Latro's Flurry
		
		-- LEVEL 70 HONOR SETS (GM / HWL)
        -- Warrior
        [580] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=20}} },
        [581] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_ATTACK_POWER_SHORT"]=20}} },
        -- Rogue
        [582] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_AGILITY_SHORT"]=15}} },
        [583] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_AGILITY_SHORT"]=15}} },
        -- Hunter
        [584] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_AGILITY_SHORT"]=15}} },
        [585] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_AGILITY_SHORT"]=15}} },
        -- Mage / Warlock (Dreadweave - Dmg)
        [586] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} },
        [587] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} },
        -- Priest / Mage (Silk - Dmg/Heal)
        [588] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} },
        [589] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_POWER_SHORT"]=25}} },
        -- Priest (Heal)
        [590] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=40}} },
        [591] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=40}} },
        -- Druid (Feral)
        [592] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=15}} },
        [593] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=15}} },
        -- Shaman (Enh)
        [596] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=15}} },
        [597] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=15}} },
        -- Paladin (Ret)
        [600] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=15}} },
        [601] = { [2]={stats={["ITEM_MOD_RESILIENCE_RATING_SHORT"]=35}}, [4]={stats={["ITEM_MOD_STRENGTH_SHORT"]=15}} },
    }    
    -- MERGE TBC DATA
    for id, data in pairs(tbcSets) do MSC.SetDefinitions[id] = data end
    for id, scores in pairs(tbcScores) do MSC.SetBonusScores[id] = scores end
end

-- =============================================================
-- PROC DATABASE (Dynamic PPM / Cooldown Logic)
-- Scoring lookup: ProcDB -> WeaponDB -> TrinketDB in Helpers.GetRawItemStats.
-- Set data and static set scores live in SetDefinitions / SetBonusScores above.
-- =============================================================
MSC.ProcDB = {
    -- [[ CLASSIC / ERA ]]

    [19379] = { score=35, note = MSC.L["Classic Caster BiS"] }, -- Nelth's Tear
    [19406] = { score=35, note = MSC.L["Classic Physical BiS"] }, -- Drake Fang Talisman
    [19019] = { score=30, note = MSC.L["Legendary Threat Generation"] }, -- Thunderfury
    [871]   = { score=40, note = MSC.L["Classic Top Tier (Prot Pally)"] }, -- Flurry Axe
    [7717]  = { ppm=1.0, val=15, stat="MSC_WEAPON_DPS", note = MSC.L["Chance to Trigger Bladestorm"] },

    -- [[ ERA TRINKETS: DROPS & QUESTS ]]
    [21670] = { ppm=1.0, val=200, dur=15, stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", note = MSC.L["Armor Penetration Proc"] }, -- Badge of the Swarmguard
    [22954] = { ppm=0.5, val=200, dur=15, stat="ITEM_MOD_HASTE_RATING_SHORT", note = MSC.L["Haste Use Effect"] }, -- Kiss of the Spider
    [23041] = { score=50, note = MSC.L["Attack Power Use Effect"] }, -- Slayer's Crest
    [23570] = { score=45, note = MSC.L["Ramping Attack Power"] }, -- Jom Gabbar
    [19339] = { ppm=0.5, val=330, dur=20, stat="ITEM_MOD_HASTE_RATING_SHORT", note = MSC.L["Haste Use Effect (Mage Only)"] }, -- MQG
    [21625] = { score=40, note = MSC.L["Heals Grant Shield"] }, -- Scarab Brooch
    [23047] = { score=60, note = MSC.L["Healing/Damage Charge System"] }, -- Eye of the Dead
    [18820] = { score=30, note = MSC.L["Spell Power Use Effect"] }, -- TOEP
    [23046] = { score=55, note = MSC.L["Spell Power Use Effect"] }, -- Restrained Essence
    [19341] = { score=40, note = MSC.L["Health Use Effect"] }, -- Lifegiving Gem
    [21180] = { score=45, note = MSC.L["Attack Power Use Effect"] }, -- Earthstrike
    [18469] = { score=35, note = MSC.L["Decreasing Spell Power/Damage"] }, -- Zandalarian Hero Charm
    [20130] = { score=100, note = MSC.L["High Regen Scaling (Warrior)"] }, -- Diamond Flask

    -- [[ ERA TRINKETS: UTILITY & ENGINEERING ]]
    [10725] = { score=15, note = MSC.L["Summons Battle Chicken (Haste Buff)"] },
    [16022] = { score=10, note = MSC.L["Summons Dragonling (Fire Vuln.)"] },
    [10645] = { score=10, note = MSC.L["Burst Damage (Life Cost)"] },
    [2820]  = { score=5,  note = MSC.L["Run Speed Use Effect"] },
    [11905] = { score=10, note = MSC.L["Ranged Damage/Stun/Daze"] },
	
}

if not MSC.IsEra then
    local tbcProcs = {
	-- Extra Attacks & Weapon Procs
    [11684] = { ppm=1.0, val=0, stat="ITEM_MOD_MELEE_ATTACK_POWER_SHORT", note = MSC.L["Chance on hit: 2 Extra Attacks"] }, -- Ironfoe
    [11815] = { ppm=1.0, val=0, stat="ITEM_MOD_MELEE_ATTACK_POWER_SHORT", note = MSC.L["Chance on hit: 1 Extra Attack (2s CD)"] }, -- Hand of Justice

    -- Damage Procs (Val is the Raw Damage)
    [12805] = { ppm=1.0, val=60, stat="MSC_WEAPON_DPS", note = MSC.L["Chance on hit: 60 Avg Fire Dmg"] }, -- Orb of Fire
    [19289] = { ppm=1.0, val=250, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 250 Nature Dmg Proc"] }, -- DMC: Maelstrom
    [28579] = { ppm=1.0, val=277, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 277 Nature Poison Dmg Proc"] }, -- Romulo's Poison Vial
    [34470] = { ppm=4.0, val=380, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Equip: 380 Avg Dmg on DoT tick (15s CD)"] }, -- Timbal's Focusing Crystal
    [28785] = { ppm=24.0, val=750, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Equip: 750 Avg Dmg every 3 Crits (2.5s CD)"] }, -- The Lightning Capacitor

    -- Struck in Combat / Defensive Procs
    [11302] = { score=20, note = MSC.L["Equip: 2% Chance on Struck for Holy Shield"] }, -- Uther's Strength
    [11810] = { ppm=0.3, val=25, stat="ITEM_MOD_BLOCK_VALUE_SHORT", note = MSC.L["Equip: 1% Chance on Struck for -25 Dmg Taken"] }, -- Force of Will
    [14557] = { ppm=0.3, val=250, stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", note = MSC.L["Equip: 1% Chance on Struck for 250 Party Armor"] }, -- Lion Horn of Stormwind
    [17774] = { ppm=0.5, val=25, stat="ITEM_MOD_ALL_STATS", note = MSC.L["Equip: 2% Chance on Struck for +25 All Stats"] }, -- Mark of the Chosen
    [34473] = { ppm=2.0, val=152, stat="ITEM_MOD_DODGE_RATING_SHORT", note = MSC.L["Equip: 152 Dodge at <35% HP (30s CD)"] }, -- Commendation of Kael'thas
    [185986]= { ppm=0.5, val=350, stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", note = MSC.L["Equip: 2% Chance on Struck for 350 Armor"] }, -- Communal Stone

    -- Healing & Mana Procs / Darkmoon Cards
    [19287] = { ppm=1.0, val=150, stat="ITEM_MOD_HEALTH_REGENERATION_SHORT", note = MSC.L["Equip: 150 Avg Heal on melee"] }, -- DMC: Heroism
    [19288] = { score=50, note = MSC.L["Equip: 100% Mana Regen while casting (15s)"] }, -- DMC: Blue Dragon
    [19290] = { score=20, note = MSC.L["Chance to Self-Resurrect"] }, -- DMC: Twisting Nether
    [27896] = { ppm=0.5, val=260, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 260 Mana on Struck"] }, -- Alembic of Infernal Power
    [27922] = { ppm=3.5, val=150, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 150 Avg Mana (17s CD)"] }, -- Mark of Defiance
    [27924] = { ppm=3.5, val=150, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 150 Avg Mana (17s CD)"] }, -- Mark of Defiance
    [27926] = { ppm=2.4, val=150, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 150 Avg Mana (25s CD)"] }, -- Mark of Vindication
    [27927] = { ppm=2.4, val=150, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 150 Avg Mana (25s CD)"] }, -- Mark of Vindication
    [28823] = { ppm=1.0, val=450, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 2% Chance on Heal for Free Cast (450 Mana)"] }, -- Eye of Gruul
    [30619] = { ppm=4.0, val=500, stat="ITEM_MOD_HEALTH_REGENERATION_SHORT", note = MSC.L["Equip: 500 HoT (15s CD)"] }, -- Fel Reaver's Piston
    [30663] = { ppm=1.5, val=335, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 335 Mana (40s CD)"] }, -- Fathom-Brooch
    [32496] = { ppm=1.2, val=76, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 76 mp5 proc (50s CD)"] }, -- Memento of Tyrande

    -- Stat Procs (Val is the Full Stat Amount)
    [27683] = { ppm=1.33, val=320, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", note = MSC.L["Equip: 320 Haste (45s CD)"] }, -- Quagmirran's Eye
    [28370] = { score=40, note = MSC.L["Equip: Mana Regen Proc (50s CD)"] }, -- Bangle of Endless Blessings (Complex Regen % Formula)
    [28034] = { ppm=1.2, val=300, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 300 AP (50s CD)"] }, -- Hourglass of the Unraveller
    [28190] = { ppm=1.33, val=320, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", note = MSC.L["Equip: 320 Haste (45s CD)"] }, -- Scarab of the Infinite Cycle
    [28418] = { ppm=1.33, val=225, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Equip: 225 SP (45s CD)"] }, -- Shiffar's Nexus-Horn
    [30450] = { ppm=2.0, val=1000, stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", note = MSC.L["Equip: 1000 ArP (30s CD)"] }, -- Warp-Spring Coil
    [30447] = { ppm=1.33, val=290, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Equip: 290 SP (45s CD)"] }, -- Tome of Fiery Redemption
    [28830] = { ppm=3.0, val=325, stat="ITEM_MOD_HASTE_RATING_SHORT", note = MSC.L["Equip: 325 Haste (20s CD)"] }, -- Dragonspine Trophy
    [30626] = { ppm=1.33, val=190, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Equip: 190 SP (45s CD)"] }, -- Sextant of Unstable Currents
    [30627] = { ppm=1.33, val=340, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 340 AP (45s CD)"] }, -- Tsunami Talisman
    [32505] = { ppm=1.0, val=300, stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", note = MSC.L["Equip: 300 ArP (~20% Uptime)"] }, -- Madness of the Betrayer
    [34427] = { ppm=1.33, val=440, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: Stacking AP Proc (440 Max / 45s CD)"] }, -- Blackened Naaru Sliver
    [34472] = { ppm=1.33, val=230, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 230 AP (45s CD)"] }, -- Shard of Contempt

    -- Stacking High-Uptime Procs (Assumes Max Stacks Reached Quickly)
    [31856] = { ppm=10.0, val=120, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 120 Max AP / 80 Max SP (Stacking)"] }, -- DMC: Crusade
    [31857] = { ppm=10.0, val=50, stat="ITEM_MOD_CRIT_RATING_SHORT", note = MSC.L["Equip: Stacking Crit"] }, -- DMC: Wrath

    -- Conditional & On-Kill Stats (Score Assigned instead of PPM)
    [13209] = { score=40, note = MSC.L["Equip: 81 AP (vs Undead)"] }, -- Seal of the Dawn
    [31859] = { score=20, note = MSC.L["Equip: Random Stat Buff on Kill"] }, -- DMC: Madness
    [32770] = { score=30, note = MSC.L["Equip: 140 Max AP (Requires Killingblows)"] }, -- Skyguard Silver Cross
    [32771] = { score=30, note = MSC.L["Equip: 80 Max SP (Requires Killingblows)"] }, -- Airman's Ribbon of Gallantry

    -- Ashtongue Talismans (Flat Score Assigned for Class Procs)
    [32485] = { score=40, note = MSC.L["Equip: Warrior Proc (Heal + 55 Str)"] },
    [32486] = { score=40, note = MSC.L["Equip: Druid Proc (Str / SP / Heal)"] },
    [32487] = { score=40, note = MSC.L["Equip: Hunter Proc (275 AP)"] },
    [32488] = { score=40, note = MSC.L["Equip: Mage Proc (145 Haste)"] },
    [32489] = { score=40, note = MSC.L["Equip: Paladin Proc (Heal / Dmg)"] },
    [32490] = { score=40, note = MSC.L["Equip: Priest Proc (220 SP / Heal)"] },
    [32491] = { score=40, note = MSC.L["Equip: Shaman Proc (Mana / 275 AP)"] },
    [32492] = { score=40, note = MSC.L["Equip: Rogue Proc (145 Crit)"] },
    [32493] = { score=40, note = MSC.L["Equip: Warlock Proc (220 SP)"] },
    [30664] = { score=30, note = MSC.L["Equip: Druid Blessing (3% Proc)"] },

	-- Crafted Weapons (Haste Procs are Melee Haste)
	[28437] = { ppm=1.0, val=212, dur=10, stat="ITEM_MOD_HASTE_RATING_SHORT" }, -- Dragonmaw
	[28438] = { ppm=1.0, val=212, dur=10, stat="ITEM_MOD_HASTE_RATING_SHORT" }, -- Dragonstrike
	[28439] = { ppm=1.0, val=212, dur=10, stat="ITEM_MOD_HASTE_RATING_SHORT" }, -- Dragonstrike
	[28429] = { ppm=1.0, val=100, dur=10, stat="ITEM_MOD_STRENGTH_SHORT" },     -- Lionheart Champ
	[28430] = { ppm=1.0, val=100, dur=10, stat="ITEM_MOD_STRENGTH_SHORT" },     -- Lionheart Exec

 }
    -- Merge TBC Procs into Main Table
    for k, v in pairs(tbcProcs) do MSC.ProcDB[k] = v end
end
-- ============================================================================
--  DATABASE BUILDER (Flattening ItemID Lookup Map)
-- ============================================================================

function MSC:BuildDatabase()
    MSC.ItemSetMap = {}
    if not MSC.SetDefinitions then return end

    local collisions = {}
    local seenItems = {}
    local definedSets = {}

    for setID, itemList in pairs(MSC.SetDefinitions) do
        definedSets[setID] = true
        for _, entry in ipairs(itemList) do
            if type(entry) == "table" then
                for _, itemID in ipairs(entry) do
                    if seenItems[itemID] and seenItems[itemID] ~= setID then
                        collisions[itemID] = { seenItems[itemID], setID }
                    else
                        seenItems[itemID] = setID
                    end
                    MSC.ItemSetMap[itemID] = setID
                end
            else
                if seenItems[entry] and seenItems[entry] ~= setID then
                    collisions[entry] = { seenItems[entry], setID }
                else
                    seenItems[entry] = setID
                end
                MSC.ItemSetMap[entry] = setID
            end
        end
    end

    if MSC.Debug then
        for itemID, sets in pairs(collisions) do
            print(string.format("|cffff0000SGJ|r Item %d mapped to sets %d and %d", itemID, sets[1], sets[2]))
        end
        if MSC.SetBonusScores then
            for setID, _ in pairs(definedSets) do
                if not MSC.SetBonusScores[setID] then
                    print(string.format("|cffff8800SGJ|r Set %d has no SetBonusScores entry", setID))
                end
            end
        end
    end

    MSC.SetDefinitions = nil
end