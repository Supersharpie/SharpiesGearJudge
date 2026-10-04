# Sharpie's Gear Judge - Version History

## 🚀 v3.1.2

### ✨ All Classes (Forever)
- **Level-60 Weights Rebuilt**: Every class's level-60 weights were worked out with its builds' own talents. DPS and tank profiles come from the wowsims Forever simulator (tanks from its tank mode: threat, damage taken and effective health); healer profiles from our healing model, since the simulator can't heal, in which healers downrank as they do in game; farming profiles from rough models. Talents the simulator or model already ran no longer adjust these profiles a second time; they still adjust the leveling weights. PvP and hybrid profiles are unchanged unless noted below.
- **Profiles Named After the Talent Builds**: Every class's profiles now carry the Talents plugin's build names (for example "Arms: Raid", "Holy: Dungeon Leveling"), so the profile list and the plugin agree. The names are translated for German, Spanish, French, Brazilian Portuguese and Russian. If you had picked an old profile by hand, it still works under its new name with "(old profile)" added.
- **Dungeon Leveling Profiles**: Most classes get Dungeon Leveling profiles beside their Solo ones. For damage dealers the tank takes the hits, so Stamina, armor and the other survival stats count for less than half their solo value. For healers, your rest between pulls is what slows the group, so healing and the mana stats lead and damage stats count for little. Each is used when you pick it (for example through a Talents plugin Dungeon Leveling build); otherwise you keep your solo profile.
- **Leveling Weights Follow More Talents**: Each class's leveling weights were checked level by level against the fastest solo leveling build for that class, and the talents those builds take that the weights ignored, or assumed too early, now adjust them (listed under each class).

### ⚔️ Warrior (Forever)
- **Level-60 Weights**:
	- **Arms: Raid** (was "PvP: Arms"): Hit is worth more than Crit until you reach the hit cap, since a miss also costs rage and Overpower procs need hits. Weapon DPS counts for more than before, because Mortal Strike and Overpower add weapon damage on top of your swing.
	- **Fury: Raid (Dual Wield)** and **Fury: Raid (Two-Hander)**: Crit now counts more than Hit, and an off-hand weapon's DPS is worth a third of the main hand's (was half).
	- **Protection: Raid** (was "Tank: Deep Protection"): dodge, parry and block were missing before and now lead with Defense and armor; Hit and Crit carry the threat. Against Stamina, armor is worth about 1.7 times its old value against boss hits.
	- **Protection: AoE Farming** (new): a Protection Warrior farms packs of level-60 mobs faster than Arms or Fury, because it takes a third of the damage and hardly needs to eat. Avoidance and block come first, then Crit and Strength. The raid Defense and crushing-blow targets don't apply to this profile.
	- Talents already in these profiles: Impale, Two-Handed Weapon Specialization, Bastion.
- **Profiles**: Arms: Raid, Protection: Raid and Protection: AoE Farming at 60; Arms and Protection Solo Leveling and Dungeon Leveling while leveling (dual wield keeps its own Fury: Dual Wield Leveling profile).
- **New Dungeon Leveling Profiles**:
	- **Arms: Dungeon Leveling**: Enrage and the damage-taken talents don't change your weights.
	- **Protection: Dungeon Leveling**: the healer's rest between pulls is what slows a group, so dodge, parry, Defense and armor are worth about twice their solo value. Your threat on the kill target holds once Defensive Stance is up.
- **Leveling**:
	- Deflection and Blood Craze (you take less damage, so Armor, Dodge, Parry, Spirit and Hp5 are worth a little less), Enrage, and Anger Management and Unbridled Wrath (more rage, so Arms values weapon speed more from 40) now adjust your weights.
	- From level 40, Crit is worth about 18% less and Agility about 15% less on the Arms leveling weights, after checking them against a model of Arms leveling that matches the simulator at 60.
	- Fixed: Arms leveling counted Unbridled Wrath as a 100% chance at 5/5 for its extra rage. It's 12% per rank (60% at 5/5), so its boost to weapon speed from 40 is about a third smaller.
- **Fixed: Spec at Level 60**: A level-60 Warrior is now scored by Shield Slam or the tree with the most points, then Mortal Strike or Bloodthirst. Before, any Warrior with Defiance and Bloodthirst, or Defiance and Improved Tactical Mastery, was scored as a tank, even a Fury or Arms DPS who had dipped into Protection; and a two-hander Fury Warrior without Improved Slam got the dual-wield weights. Fury now picks dual wield or two-hander from the weapon in your off-hand.

### 🛡️ Paladin (Forever)
- **Level-60 Weights**:
	- **Retribution: Raid**, from the simulator, run with the Retribution: Raid build and its seal-twisting rotation (Twist of Light: Seal of Righteousness before each swing, then Seal of Command, so every swing carries both seals). White hits count double that way, so Crit is worth more than three times its old value and Hit leads every stat; Spell Power and Intellect are worth about twice as much, Agility counts more, and Spell Hit is scored (with its own cap). Holy damage is scored for the first time; Weapon DPS keeps its value. Talents already in it: Divine Strength, Divine Intellect, Champion of the Light.
	- **Holy: Raid**, from the healing model: a Paladin healer is short of mana, so Intellect and Mp5 now count for more than +healing per point, and Spirit counts too. Crit was overrated, and Stamina (worth five times +healing before) no longer lets tank plate outrank healing gear.
	- **Protection: Raid**, from the simulator's tank mode, run with the Vanguard build. Dodge and parry (missing before) lead, with Defense and armor; block counts for less, since it only takes your Block Value off each big boss hit. Threat is about half Holy and half melee, so Spell Power, Hit and Crit count, and Attack Power, Strength and weapon damage little. A boss fight doesn't run a tank out of mana, so Intellect and Mp5 count for little.
	- **Protection: AoE Farming** (was "Farming: Protection AoE"), from a model of AoE farming at 60 (15-20 normal mobs with Consecration, Holy Shield and Retribution Aura, which now adds 10% of your spell power per hit). Spell Power is now the top stat, followed by block, dodge, parry, Defense and Stamina. Block Value, Intellect and Mp5 count for little when farming normal mobs, and the raid Defense and crushing-blow targets no longer apply to this profile.
- **Profiles**: Retribution: Raid, Holy: Raid, Protection: Raid and Protection: AoE Farming at 60; Retribution, Holy and Protection Solo Leveling and Dungeon Leveling while leveling.
- **New Dungeon Leveling Profiles**:
	- **Holy: Dungeon Leveling**: Intellect, Mp5 and Spirit lead; crit and damage stats count for little. The existing Holy leveling weights become Holy: Solo Leveling.
	- **Protection: Dungeon Leveling**: until about 40 your threat holds the group back, and a Paladin's threat is mostly Holy, so Spell Power is worth several times Attack Power; from 50 the healer's rest is the limit, so dodge, parry, block and Defense lead. Stamina stays where it was.
	- **Retribution: Dungeon Leveling**: Consecration on packs and Judgement of the Crusader on bosses; Crit and Agility count a little more than solo.
- **Leveling** (each leveling build was also run in the simulator at 60 in leveling-style fights, and the weights now meet those results at 59, fading in from 45; the simulator only runs at 60, so lower levels keep the earlier model):
	- **Retribution**: Crit is worth about 15% more and Hit about 8% more from level 20 (Judgement of the Crusader and Retribution Aura findings). From 45, Hit, Crit and Agility rise further (Judgement of Command rolls on the melee table, so melee hit and crit carry over to it) and Spell Hit is scored. Solo Spell Power counts about a quarter more by 59; dungeon Spell Power had been rated almost twice too high and now counts about 40% less.
	- **Protection**: Improved Seal of Fury (its mana return makes Intellect and Mp5 worth much less, about half from 25 to 35), Benediction and Holy Conduit, Reckoning (extra attacks on block), and Improved Righteous Fury and Iron Creed (less damage taken) now adjust your weights. From 45, Solo Leveling's Spell Power counts much more (about 2.7 times by 59: your Holy damage kills packs), block about half as much and Crit a third more; Dungeon Leveling's dodge, parry, block and Defense already matched the simulator, and its Spell Power counts about 40% less and Crit about twice as much.
	- **Holy**: crit is scaled down from level 30 so it meets the level-60 value.
- **Fixed: Spec at Level 60**: A level-60 Paladin's weights now follow the tree with the most points. Before, a Retribution Paladin without Repentance was scored with the Holy healer weights; a Retribution Paladin who took Holy Shock (a common Retribution 30 / Holy 21 build) was scored as the PvP Shockadin; and a Holy healer without Sacred Duty was also scored as the PvP Shockadin. The Shockadin weights now apply only to a Holy Paladin with Holy Shock and no healing talents.
- **Fixed: Retribution Switching to Healer Weights While Leveling**: Retribution builds take Divine Intellect and Reverence for mana from about 45, which switched them to the Holy healer leveling weights. The healer weights now start from talents only a healer takes: Healing Light, Spiritual Focus, Illumination, Divine Favor, Infusion of Light or Light's Vigil.

### 🗡️ Rogue (Forever)
- **Level-60 Weights**:
	- **Combat: Raid** (swords, was "Raid: Combat Swords"): Crit is worth about three times its old value and now sits level with Hit, and Agility counts a little more. An off-hand weapon's DPS is worth a quarter of the main hand's (was half).
	- **Combat: Raid (Daggers)** (was "Raid: Combat Daggers") and **Assassination: Raid (Mutilate)** (was "Raid: Seal Fate"): the same changes; Mutilate hits with both weapons, so its off-hand weapon counts for more.
	- Talents already in these profiles: Lethality.
- **Profiles**: Combat: Raid at 60; Combat: Solo Leveling and Combat: Dungeon Leveling while leveling (daggers and Subtlety keep their own Combat Daggers: Solo Leveling and Subtlety: Solo Leveling profiles).
- **New Dungeon Leveling Profile**: **Combat: Dungeon Leveling**, for daggers in a group, where you stand behind the mob and can Backstab.
- **Leveling**: Malice, Ruthlessness, Relentless Strikes and Murder now count as damage talents, and Combat Rogues without Improved Eviscerate no longer get credit for it.
- **Fixed: Spec at Level 60**: A level-60 Rogue is now scored by the tree with the most points and the weapon in your main hand. Before, any Rogue with Seal Fate got the Seal Fate weights, even a Combat Rogue who had taken it, and a Combat Rogue with daggers got the sword weights unless they had Puncturing Wounds. Combat now picks the dagger weights from a dagger in your main hand.

### 🏹 Hunter (Forever)
- **Level-60 Weights**:
	- **Beast Mastery: Raid** (new): the strongest Hunter spec in Forever, about 19% ahead of Marksmanship, mostly thanks to Summon Hawk. It runs short of mana, and Careful Aim turns your Intellect into Attack Power, so Intellect and Mp5 now rank above Agility.
	- **Marksmanship: Raid** (was "Raid: Marksmanship (Standard)" and "Raid: MM (Surefooted)") and **Survival: Raid** (was "Raid: Deep Survival"): Crit is worth about three times its old value and sits level with Hit; Intellect is worth several times more (mana and Careful Aim). Survival is now scored as the shooting build the simulator runs, with Agility first.
	- The PvP, Nightfall and Dire Maul profiles are unchanged.
- **Profiles**: Beast Mastery: Raid at 60; Beast Mastery: Solo Leveling and Beast Mastery: Dungeon Leveling while leveling (melee Hunters keep Survival: Melee Leveling).
- **New Dungeon Leveling Profile**: **Beast Mastery: Dungeon Leveling**.
- **Leveling**: Unleashed Fury, Ferocity and Frenzy make your pet a bigger share of your damage, so your own Agility, Attack Power, Crit and Hit are worth a little less (about 4% at 39, 9% at 59).
- **Fixed: Spec at Level 60**: A level-60 Hunter is now scored by the tree with the most points. Before, almost every Hunter got the Marksmanship weights, including Beast Mastery Hunters.

### 🔮 Mage (Forever)
- **Level-60 Weights**:
	- **Frost: Raid** (was "Raid: Frost (Winter's Chill)" and "Raid: Frost (Arcane Power)"): the strongest Mage spec in Forever. Crit is worth about four times its old value; in a three-minute raid fight a Frost Mage doesn't run out of mana, so Intellect counts for less (mostly its crit).
	- **Fire: Raid** (was "Raid: Deep Fire") and **Arcane: Raid** (new): Fireball's mana cost makes Intellect, Spirit and Mp5 count for Fire; Arcane spell damage is scored for Arcane.
	- **Frost: AoE Farming** (was "Farming: Frost AoE"), from a rough model of Blizzard pack farming at 60: Blizzard gets little from Spell Power next to its base damage, and drinking is a big part of each pull, so Crit, Intellect and Mp5 now count for a lot more against Spell Power.
	- Talents already in the raid profiles: Ice Shards, Piercing Ice, Fire Power, Arcane Mind.
- **Profiles**: Frost: Raid, Fire: Raid, Arcane: Raid and Frost: AoE Farming at 60; Frost: Solo Leveling, Frost: AoE Leveling, Frost: Dungeon Leveling and Fire: Solo Leveling while leveling.
- **New Dungeon Leveling Profile**: **Frost: Dungeon Leveling**: Blizzard and Cone of Cold on packs make Crit worth about a third to half more than solo.
- **Leveling**: Frost Channeling now lowers mana costs for single-target Frost Mages too, not only AoE Mages, so Intellect, Mana, Spirit and Mp5 are worth about 15% more at 3/3.
- **Fixed: Spec at Level 60**: A level-60 Mage is now scored by the tree with the most points (AoE farming builds and the PvP builds are still recognised by their talents). Before, a Fire Mage without Combustion and every Arcane Mage got the Frost raid weights, and a Frost Mage with Ice Barrier but no Winter's Chill got the PvP weights.

### ✝️ Priest (Forever)
- **Level-60 Weights**:
	- **Shadow: Raid** (was "DPS: Shadow (PvE)"), from the simulator, where Shadow does about 35-60% more damage than Smite. Hit is worth about a third less than before, Spirit and Mp5 no longer count (a raid fight never runs a Shadow Priest dry) and Intellect counts for less.
	- **Holy: Raid** (was "Healer: Deep Holy") and **Discipline: Raid** (was "Healer: Disc (Power Infusion)"), from the healing model; the two used to share one set of weights. Mp5 is now worth about four times its old value and Intellect over twice; Discipline values Crit far more (about four times), because its crits shield through Divine Aegis.
	- **Shadow: Multi-DoT Farming** (new), for Shadow Word: Pain and Devouring Plague on packs of 4-5 mobs. The pack hits you the whole time, so Stamina leads with the mana stats. From a rough model.
	- Talents already in these profiles: Shadowform, Darkness, Spiritual Guidance, Spiritual Healing, Mental Strength. The PvP and Power Weaving profiles are unchanged.
- **Profiles**: Shadow: Raid, Holy: Raid, Discipline: Raid and Shadow: Multi-DoT Farming at 60; Shadow: Solo Leveling, Shadow: Dungeon Leveling, Healer: Leveling, Healer: Dungeon Leveling and Smite: Solo Leveling while leveling.
- **New Dungeon Leveling Profiles**: **Shadow: Dungeon Leveling** and **Healer: Dungeon Leveling** (from the healing model, healing a tank through dungeon pulls).
- **Leveling**:
	- Shadow: Hit was rated nearly worthless from level 19 because Shadow Focus was counted against all spells; only Shadow spells are capped now, so Hit keeps value for the wand and Starshards. Also fixed: wand and Spirit values doubled at 36-39 for Shadow Priests without Shadowform, Wand Specialization ignored at 49+, and Spirit Tap and Meditation not adding together. Shadow Weaving, Improved Mind Blast and Improved Shadow Word: Pain now count.
	- Healers are found sooner: Divine Aegis and Prayer of Mending now also switch a leveling Priest to the healer weights, so a Discipline healer is recognised from Divine Aegis instead of keeping the Shadow weights until the 50s.
- **Fixed: Spec at Level 60**: A level-60 Priest is now scored by Shadowform, then Prayer of Mending (Holy) or Penance / Power Infusion (Discipline), then the tree with the most points. Before, a Shadow Priest with Shadowform but neither Shadow Weaving nor Blackout got the healer weights.

### 💀 Warlock (Forever)
- **Level-60 Weights**:
	- **Demonology: Raid** (was "Raid: Master Demonologist"): the Demonic Pact build, the strongest Warlock spec in Forever (about 19% ahead of Affliction).
	- **Affliction: Raid** (was "Raid: Affliction (SM/Ruin)") and **Destruction: Raid** (was "Raid: Destruction (DS/Ruin)").
	- For all three, Crit is worth about four times its old value and Hit about half (it was rated far above Crit); Shadow damage is scored separately from Fire, and Intellect and Stamina count for less (a three-minute raid fight never runs a Warlock dry). Talents already in them: Ruin, Pandemic, Shadow Mastery, Malediction, Agonizing Flames, Demonic Embrace. The PvP profiles are unchanged.
	- **Demonology: AoE Farming** (new), for Rain of Fire / Hellfire pack farming with Soul Link. Hellfire burns you for as much as each enemy and Life Tap pays for mana in health, so Stamina leads, then Fire damage and mana stats. From a rough model.
- **Profiles**: Demonology: Raid, Affliction: Raid, Destruction: Raid and Demonology: AoE Farming at 60; Affliction: Solo Leveling, Affliction: Dungeon Leveling, Demonology: Solo Leveling and Destruction: Solo Leveling while leveling.
- **New Dungeon Leveling Profile**: **Affliction: Dungeon Leveling**.
- **Leveling**: Improved Life Tap (Stamina worth more, Intellect less). Demonology leveling now counts Soul Link's real damage sharing (Armor and Stamina worth less) and its 3% damage, and only credits Demonic Knowledge for the ranks you have.
- **Fixed: Spec at Level 60**: A level-60 Warlock is now scored by Demonic Pact or the tree with the most points. Before, every raid profile required Ruin, so a deep Affliction or Demonology Warlock without Ruin fell back to the generic default weights, and any Soul Link Warlock without Demonic Pact got the PvP tank weights.

### ⚡ Shaman (Forever)
- **Level-60 Weights**:
	- **Enhancement: Raid** (was "DPS: Enhancement"), from the simulator: the two-hander build, the strongest Shaman spec in Forever. Hit is worth about twice its old value and Crit nearly four times, Intellect now counts (Mental Dexterity turns it into Attack Power, and the shocks need the mana), and so does Spell Power (Flame Shock, Earth Shock and Lightning Shield).
	- **Elemental: Raid** (was "DPS: Elemental (PvE)"), from the simulator. Elemental runs out of mana in Forever, so Hit is now worth about half its old value, and Intellect (about four times), Spirit and Mp5 count for more. Nature and Fire damage are scored separately.
	- **Restoration: Raid** (was "Healer: Deep Restoration"), from the healing model. Water Shield gives mana back on heal crits, so Crit is worth about half again its old value; Intellect and Mp5 about twice.
	- **Tank: AoE Farming** (new), for pack farming with a one-hander and shield: Rockbiter with Spirit Weapons, Fire Nova, Magma Totem and Lightning Shield on about 4 mobs. Stamina, avoidance and the mana stats lead. From a rough model. A level-60 Shaman tank (Anticipation with Spirit Weapons) now uses it.
	- Talents already in these profiles: Ancestral Knowledge, Toughness, Mental Dexterity, Mental Quickness, Elemental Fury, Concussion, Purification, Healing Way. The PvP, totem-support and hybrid profiles are unchanged.
- **Profiles**: Enhancement: Raid, Elemental: Raid, Restoration: Raid and Tank: AoE Farming at 60; Enhancement: Solo Leveling, Enhancement: Dungeon Leveling, Elemental: Leveling, Restoration: Leveling, Restoration: Dungeon Leveling and Tank: Dungeon Leveling while leveling.
- **New Dungeon Leveling Profiles**: **Enhancement: Dungeon Leveling** and **Restoration: Dungeon Leveling** (from the healing model, healing a tank through dungeon pulls).
- **Leveling**: Improved Stormstrike's mana regen while casting now raises Spirit for Enhancement, not only for Shaman tanks.
- **Fixed: Spec at Level 60**: Any Elemental Shaman with a point in Eye of the Storm was scored with the PvP weights; the best raid build takes two points of it to reach Elemental Fury. The PvP weights now need all three points. A Shaman without Lava Burst, Riptide, Rage of the Farseer or Stormstrike now gets the weights of the tree with the most points instead of the healer weights.
- **Fixed: Enhancement Switching to Elemental Weights While Leveling**: An Enhancement Shaman who took the Elemental shock talents (Convection, Call of Flame, Reverberation) was moved to the Elemental leveling weights. Stormstrike now keeps them on the Enhancement weights.

### 🐾 Druid (Forever)
- **Level-60 Weights**:
	- **Cat: Raid** (was "DPS: Feral Cat"), from the simulator. Agility now edges Strength (it was rated well below), Crit is worth more than twice its old value, and Intellect and Mp5 count (Shifting Power turns mana into Energy).
	- **Balance: Raid** (was "DPS: Balance (Boomkin)"), from the simulator. Starfire does most of the damage, so Arcane damage counts for most of Spell Power's value. Hit is worth about half its old value and Crit about half again more.
	- **Restoration: Raid** (was "Healer: Deep Restoration"), from the healing model. Most Druid healing comes from heal-over-time spells, which can't crit, so Crit is worth about half its old value; Spirit (it barely counted before) and Mp5 now lead.
	- **Bear: Raid** (was "Tank: Feral Bear"), from the simulator's tank mode. Agility, Strength and Crit now count (they were missing); Dodge, Hit and Defense count for less and Armor about a third more. Dire Bear Form multiplies your armor so much that the simulator stops counting more past about 5,000.
	- Talents already in these profiles: Heart of the Wild, Living Spirit, Vengeance, Moonfury, Genesis, Gift of Nature, Naturalist, Predatory Instincts, Savage Fury. The older healer and hybrid profiles are unchanged.
- **Profiles**: Cat: Raid, Balance: Raid, Restoration: Raid and Bear: Raid at 60; Feral Cat: Solo Leveling, Cat: Dungeon Leveling, Bear: Dungeon Leveling, Balance: Leveling, Restoration: Leveling and Restoration: Dungeon Leveling while leveling.
- **New Dungeon Leveling Profiles**: **Cat: Dungeon Leveling** and **Restoration: Dungeon Leveling** (from the healing model, healing a tank through dungeon pulls).
- **Leveling**: Sharpened Claws, Leader of the Pack and Nature's Majesty (more crit makes Attack Power, Strength and Hit worth more), and Shredding Attacks and Rend and Tear (more damage) now adjust the Cat weights.
- **Fixed: Feral Switching to Balance or Healer Weights While Leveling**: A Cat Druid with Nature's Reach (hit for every form) was moved to the Balance leveling weights, and one who filled a tier with Nature's Focus to the healer weights. Nature's Reach no longer marks Balance, and Shifting Power keeps a Druid on the Cat weights.

### 🐛 Bug Fixes
- **Lua Error on Druid Idols (Forever)**: Looking at a Forever idol whose value depends on your spec, such as Windcharged Leaf, caused a Lua error (Helpers.lua:816, "bad argument to 'pairs'"). Fixed. Librams, idols and totems on Forever (and TBC) were also being counted twice when scored; they now count once, for your spec. Thanks to dasper for the report.
- **What's New Window on Era and TBC**: When an update only changes WoW Forever, the window now says so instead of opening with an empty list.

### 🛠️ For Testers
- **Leveling Weights Split Into One File per Class (Forever)**: The Forever leveling weights used to live in one file, `Classes/Forever/LevelingCurves.lua`. They're now split into one file per class in `Classes/Forever/Curves/` (`Warrior_Curves.lua` to `Druid_Curves.lua`), plus `Curves_Attach.lua`, which loads them. A change to one class's weights can no longer touch another class. The weights themselves are unchanged. If you copy files by hand instead of replacing the whole folder, delete the old `LevelingCurves.lua` and make sure the new `Curves` folder is there, or the leveling weights won't load.

---

## 🚀 v3.1.1

### ✨ Improvements
- **Support for the new Talents Plugin (Forever, still in development)**: Gear Judge can now take its leveling role and level-60 profile from a build chosen in the new Sharpie's Gear Judge [Talents] plugin. For example, picking a Protection tank build gives you the tank weights from your first talent point, before the build's marker talents would otherwise switch you over. Automatic detection is unchanged when no build is chosen, and a manually chosen profile still wins.
- **Forever Beta Patch (2 October) Talent Changes**:
	- Warrior: Crits from basic attacks now give 75% more rage, so every Warrior leveling profile values Crit about 15-16% higher and Agility about 7-13% higher (tanks least, since most of their Agility value is dodge and armor).
	- Warlock: Soul Harvesting was renamed Soul Harvest. Gear Judge now finds it again, so its mana regen bonus and the Affliction leveling profile see it.
	- Paladin: Holy Shield's +30% block chance (was 20%) now counts toward being uncrushable, and the Protection leveling weights from 40 rate Block Value about 27% higher and Intellect about 13% higher, since you block (and so get Shield Specialization mana) more often. Redoubt's smaller block bonus (4% per rank, was 6%) lowers the Block Value it adds. Champion of the Light now converts 20/40/60% of Intellect to spell damage (was counted at 11% per rank), so Retribution Intellect is worth more with it.
	- Druid: Tiger's Fury was removed, so the Howling Idol (Tiger's Fury cooldown) no longer scores. Bear Form crits now give 75% more rage, so Bear leveling weights value Crit about 17% higher and Agility about 7% higher (more rage means more Mauls). Cats who take the new Shifting Power talent (mana into Energy) now value Intellect and Mp5: Intellect goes from about 0.3 to 1.0 at level 30 and from 0.17 to about 0.55 at 59, and more with Natural Shapeshifter.

### 🐛 Bug Fixes
- **Forever Leveling Weights Now Load**: The Forever client loads the plain `SharpiesGearJudge.toc`, not the `_Forever` one, and that file didn't list the per-spec leveling curves from v3.1.0. Forever characters were still scored with the older level-band weights. The curves now load, along with every weight update since.

---

## 🚀 v3.1.0

### ✨ Improvements
- **Rebuilt Forever Leveling Weights for All 28 Specs**: Every Forever leveling spec now has its own weight curve, with keyframes every 5 levels from 10 to 59 (and at level 1 for each class's default spec). Weights blend level by level between keyframes, and keyframes also sit on the levels where something changes, such as Cat Form at 20 or a key talent tier. Each spec was worked out from what it can actually use at each level:
	- the talents it can reach by then, from Forever's current talent trees;
	- the spells and ranks it has learned;
	- the stats that actually drop on Forever gear at that level;
	- the Forever client's own per-level tables for crit per Agility, crit per Intellect, and mob health, damage and armor.

	Each curve was checked for math and game timing, then against every other class for consistency, and the review's findings were applied (one survival unit for tanks, one regen rule for melee, one Hp5 rule for tanks, one Agility model for casters, Flurry and healer regen talents handled the same way everywhere). Stats now rise, fall or drop off as they gain or lose value: a ranged Hunter's Crit is worth 2.4 at level 10 and 16.8 at 59, and a stat that stops mattering fades to zero instead of holding its early value. Profile names and the profile list are unchanged; each profile now shows the weights for your exact level.
- **Forever Leveling Weights Follow Your Talents (about 80 talent hooks)**: The curves are built for a typical build at each level; your actual talents now adjust them. Around 45 new talent hooks were added and 35 existing ones corrected, across all nine classes. A few examples:
	- Warrior: Deep Wounds, Dual Wield Specialization, Raging Blows, Shield Slam, Weaponmaster's mace and sword branches, and the Mortal Strike gate with the Spearing Strike, Bloodthrill and Improved Slam speed hooks for Arms builds that skip it.
	- Paladin: Vengeance, Two-Handed and One-Handed Weapon Specialization, Illumination, Reverence, Holy Shield, Redoubt, Shield Specialization's Block Value and mana side, and a Seal of Command hook for builds still on Seal of Righteousness at 20+.
	- Hunter: Efficiency, Resourcefulness, Bestial Discipline, Rapid Recuperation, Lone Wolf (petless builds value Stamina and melee more), Barrage, Deadly Aspects and Improved Tracking.
	- Rogue: Dual Wield Specialization, Mutilate, and Hack and Slash's sword and mace branches.
	- Priest: Meditation, Spirit Tap, Wand Specialization, Mind Flay, Divine Aegis, Penance and Prayer of Mending, and a restore for Priests who reach 40 without Shadowform.
	- Mage: Improved Frostbolt, Wand Specialization, Arcane Meditation and Frost Channeling.
	- Warlock: Soul Harvesting and Fel Vitality.
	- Shaman: Mindfulness, Improved Stormstrike, Spirit Weapons (no Parry value without it), and hooks that undo the baked Stormstrike, Shamanistic Focus and Flurry for builds that don't have them. Lava Burst's school split is reversed if you skipped it.
	- Druid: Natural Shapeshifter, Predatory Strikes (Cat and Bear), Savage Fury and Predatory Instincts now apply to Bears too, and Reflection follows your actual rank.

	Every crit talent now also moves the primary stat that carries crit (Agility for melee, Intellect for spells), using the client's crit-per-point tables for your class and level. Where a profile assumes a talent nearly everyone takes (Flurry for Enhancement and dual-wield Fury, Reflection, Reverence, Mindfulness, Shadowform), a hook now removes that assumption for players without it.
- **Forever Hit and Tank Caps Follow Your Level (Gear for Raiding)**: Hit caps now match what you're fighting. While leveling that's 5% melee/ranged and 3% spell hit against same-level mobs. From level 50 the targets slide toward the raid caps (9% hit, 16% spell hit), reaching them at 60, so you can gear toward raiding in your 50s. Tanks get the same slide toward 440 Defense, and shield tanks (Warriors, Paladins and Shamans) are checked for being uncrushable from 50 (102.4% avoidance and block, counting Shield Block or Holy Shield). A new **Gear for Raiding** option in Protocol (on by default) turns the slide off if you won't raid. `/sgj hitcheck` shows your hit, where it comes from, and your current targets.
- **Forever Relics Are Rated**: All 25 of Forever's new librams, idols and totems now score for the specs that use them. So do the 19 Classic relics Forever kept unchanged, such as Idol of Ferocity, Libram of Light, Totem of Life and Libram of Truth. For those, a bonus to one spell counts at that spell's share of the spec's healing or damage, so +83 to Flash of Light isn't treated as +83 to all healing. Their effects (percentages, mana savings, cooldowns) are converted into equivalent stats for your spec:
	- Mystic Mushroom counts as 5% of your Spirit.
	- Mark of Urs'endris counts as 4% of your item armor.
	- Polished Driftwood Icon counts as the Mp5 from letting 8% of your regen continue while casting.
	- Steadfast Libram counts as 30% of your shield's block value while Holy Shield is up.

	Effects a spec doesn't use count for nothing, such as Swiftmend idols for a Cat Druid. Small cooldown and duration effects use estimated values.
- **Gear Judge in the Game's AddOns Options**: Sharpie's Gear Judge now has a page under Game Menu > Options > AddOns. It lets you open the Gear Judge window or its settings, see What's New, and turn the minimap button back on, and it lists the chat commands. This helps anyone who has hidden the minimap button or doesn't know `/sgj`.
- **What's New Window After Updates**: The first time you log in after installing a new version, a small window shows a quick rundown of what changed and the Discord invite. The Discord is where to request features, report bugs and flag weights that feel off. The link sits in a box so you can copy it with Ctrl+C. The window appears once per version, a few seconds after login (never during combat). Reopen it any time with `/sgj whatsnew`.
- **Upgrade Arrows in Profession Windows**: Recipes that craft an upgrade for you get a green arrow on the recipe list and on the selected recipe's icon. On Forever this never worked: Forever uses the newer professions window (the same one for every profession, Enchanting included), which Gear Judge didn't know about. It is now supported. On Classic Era and TBC the existing arrows in the profession window now also appear in the separate Enchanting window, so enchanter-made wands and rods get one. Enchants themselves aren't items and get no arrow.
- **GudaBags Support**: Bag upgrade arrows now show in GudaBags (bags, bank and mail), in the top-left corner where GudaBags puts its own upgrade arrow. They follow **Show Bag Upgrade Arrows**, update when your gear, level or talents change, and are not drawn on other characters' cached bags.

### 🐛 Bug Fixes
- **Forever Hit Caps Didn't Work**: The old caps read a hit value without gear Hit Rating, added general hit talents (Precision, Surefooted, Suppression, Tidal Focus, Nature's Reach) on top of a number that already included them, compared raw rating against percent caps for Rogues, Warriors and Shamans, and gave an item full value for hit past the cap. Hit is now read correctly and valued on its real curve against your total after the swap: hit past the cap is discounted, and a swap that drops you below the cap is charged for what you lose. School-only talents are still added (Shadow Focus, Elemental Precision, Arcane Focus, and Holy Precision for Smite at 6% per rank, so 3/3 covers the leveling cap by itself). Forever Shamans use the single-weapon cap, since they can't dual-wield, and leveling Priests (Shadow and Smite) now have a hit cap too. With working caps, the temporary halving of caster Hit weights from level 30 is gone, so Hit gets its full value below the cap and no longer dips at 30.
- **Weapon Speed Weights Did Nothing on Forever**: A stat rename meant a weapon's speed never matched its weight. Speed now counts where a spec values it (slow two-handers for Arms Warriors and Retribution Paladins, Stormstrike Enhancement Shamans, and slower daggers for Dagger and Hemo Rogues). It only applies to the main hand; the off-hand and ranged slot use their own values, so a slow bow no longer inherits a melee preference.
- **Talent Hooks Were Wrong in the Same Few Ways**: Fixing the existing hooks turned up four patterns:
	- *Flat damage talents only boosted one stat.* Two-Handed Weapon Specialization, Bastion, Piercing Ice, Fire Power, Darkness, Moonfury, Genesis, Naturalist, Gift of Nature, Malediction, Shadow Mastery, Agonizing Flames, Savage Fury, Focused Fire and Ranged Weapon Specialization scaled Spell Power or Attack Power alone, so with the talent every other damage stat lost 5-20% of its value. They now raise the whole damage family together.
	- *Crit-bonus talents were worth 3-5x too much.* Lethality, Impale, Mortal Shots and Predator's Edge multiplied Crit as if every hit gained the bonus; they only affect yellow attacks or one ability family, so their multipliers are now 1.05-1.25x at max rank instead of 1.4-1.6x. Pandemic no longer boosts Shadow Bolt crits, Ruin no longer boosts DoT crits, and the two no longer multiply each other. Ice Shards no longer applies to Fire Mages and counts at Frost's 65% share for AoE Mages. Shadowform's x2 crit now applies only to the endgame Shadow profiles, since the leveling curve already includes it.
	- *Forever talent text is the rank-1 value.* Mental Dexterity (33% per rank, was read as 11%), Mental Quickness (15%, was 7.5%) and Spiritual Guidance (5%, was 1%) were under-counted 2-5x. Lightning Reflexes still used Classic's 3% per rank; Forever's is 2%.
	- *Healer multipliers tilted Healing against mana.* Healing Light, Spiritual Healing, Healing Way and Purification scaled only the Healing weight, over-valuing it against Intellect, Spirit, Mp5 and crit by up to 15%. They now keep the row's balance (Healing Way at Healing Wave's real share of your healing by level).
- **Profile Detection Fixes**: Several builds landed on the wrong leveling or endgame profile:
	- Forever's talent window is now the trait-based one, and Gear Judge was reading talents the old way, so a talent point could go unnoticed (one point in Redoubt left a Paladin on the Retribution profile). Talents are now read from the trait tree, which also feeds every talent-based weight adjustment. `/sgj talents` lists what Gear Judge reads, the points in each tree and the profile it picks.
	- A single filler point in Anticipation (or Spirit Weapons on the way to Rage of the Farseer) switched an Enhancement Shaman to the tank profile; tank now needs Anticipation plus a second point, Toughness 3+, Spirit Weapons, or level 24 or lower.
	- Careful Aim marked Hunters as ranged, though melee Hunters take it too.
	- One point in Meditation, Improved Power Word: Shield, Martyrdom or Silent Resolve made a Priest a healer (no wand or hit value); only Improved Renew and Inspiration mark a healer now.
	- Opportunity and Improved Ambush counted toward the Dagger profile, so a pure Subtlety Rogue fell back to Combat (slow swords); Ghostly Strike or mostly-Subtlety talents now pick Hemo, and Mutilate picks Daggers.
	- Improved Blizzard needed 2 points to mark an AoE Mage, but a level-20 Mage can only have 1; one point now counts up to level 21.
	- Talent roles now apply from level 10, when the first talent point arrives, for every class (only Paladins did before). A level-10 character with a Protection, Restoration, Fire, Subtlety or other role point now gets that role's 11-20 weights instead of the default 1-10 row.
	- The default Druid profile follows your level for form bonuses: Bear Form from 10 to 19 and Cat Form from 20 (level 20 used to keep the Bear Stamina bonus).
	- At 60, any Warlock with Demonic Pact was scored with the PvP Soul Link profile. Pact is a damage build, so it now gets the Master Demonologist raid profile with that talent and the Demonic Sacrifice raid profile otherwise; Soul Link without Pact still gets the PvP profile.
- **Weapon Scoring Fixes**:
	- *Dagger Rogues were shown swords as upgrades.* Backstab and Ambush need a main-hand dagger, and Ghostly Strike and Hemorrhage hit much harder with one, but nothing in the weights told a dagger from a sword. Dagger and Hemo Rogues now get a main-hand dagger bonus (about 20 AP-worth at 20, rising to 45-48 at 59), and Hack and Slash's dagger/fist crit counts at each hand's real share (75% main hand, 20% off hand) instead of fully on both.
	- *Weapon racials counted twice when dual wielding.* A Human with two swords, a Dwarf with two maces or an Orc with two axes had the racial valued on both weapons; it now counts once, on whichever hand provides it.
	- *Shield tanks were shown weapons that replace the shield.* Off-hand weapon DPS now counts for nothing on Protection Warrior profiles, and a two-hander is never shown as an upgrade for Protection Warriors, Protection Paladins or Shaman tanks (all versions), since it would take away the shield that Shield Block, Shield Slam, Holy Shield and block stats need. The tooltip says "(Tank: needs a shield)". If you're already using a two-hander, two-handers still compare normally.
	- *Melee Hunters.* Dual-wielding Hunters (from 20) now use the dual-wield hit curve when a weapon is in the off-hand, and Predator's Edge's off-hand damage raises the value of off-hand weapons.
	- *Staves and daggers scored as wands.* From level 10, Forever Priest, Mage and Warlock leveling profiles give melee-slot weapon DPS no value, so a high-DPS staff with no caster stats no longer looks like an upgrade.
	- *Hunters scored thrown weapons like bows.* Hunters can't Auto Shot with a thrown weapon, so it is now rated on its stats only.
	- *Weapon lists.* Shamans no longer rate polearms (a "shields" entry actually meant polearms, on every version; two-handed axes and maces are still rated). Forever Rogues can now rate one-handed axes, and Druids can rate polearms on Forever and TBC.
- **Curve Corrections From the Review**:
	- *Paladin tank Block follows Shield Specialization.* On Forever only rank 3 makes every block restore 6% of max mana (the "33%" is a third per rank). With 3/3, Block Rating keeps the mana part in full; without it, blocks only stop damage and Block is valued like other tanks' (about 0.6x Dodge).
	- *Bear Druids over-valued Hp5* at about three times the other tanks; a Bear-talented Druid is a tank, so it now uses the same rule (Hp5 = 0.25 x Stamina).
	- *Level 10-19 Druids under-valued Armor.* Every Druid fights in Bear Form from 10 until Cat Form at 20, and Bear Form multiplies item armor, so Armor is now 0.04-0.047 over those levels (was 0.035).
- **Healer Spell Power Under-Scored in Tooltips**: Spell Power's healing half only counted in the full-character score, so tooltips and upgrade arrows under-valued Spell Power items for healer profiles. It now counts everywhere (all game versions).
- **Relics Never Counted, and Were Offered to the Wrong Classes**: A relic's bonus was only shown as a tooltip note and never added to its score, so every libram, idol and totem scored close to nothing in every version; relic bonuses now count, so TBC's existing relic values apply too. Many relics have no "Classes:" line, so a Warrior could be told a Libram was usable; librams are now only for Paladins, idols for Druids and totems for Shamans.
- **`/sgj options` Did Nothing**: It called a settings window that no longer exists. It now opens the Gear Judge window on its Protocol (settings) page.
- **Overlapping Text in the Protocol Settings**: The "Assume Consumables" checkbox sat on top of the "Character Profile" heading. The heading now starts below the checkbox.

---

## 🚀 v3.0.18

### ✨ Improvements
- **Forever Spec Profiles Start at Level 11**: Most classes had only one leveling profile until 21, and the split profiles relied on deep talents a level 11-20 character can't reach. Every Forever class now splits by spec from level 11, reading the tier 1-3 talents you've picked (from Forever's current talent trees). New 11-20 profiles:
	- **Hunter**: Melee/Survival. Hunters with more melee picks (Deflection, Savage Strikes, Improved Wing Clip) than ranged Marksmanship picks now get the melee profile. The melee profiles were never chosen automatically at any level before; this fixes 21-59 too.
	- **Mage**: Fire and AoE Grinding. Fire is chosen when you have more Fire points than Frost points. Improved Blizzard still picks AoE.
	- **Warlock**: Destruction and Demonology, chosen by whichever tree has the most tier 1-3 points.
	- **Rogue**: Daggers (Puncturing Wounds, Opportunity, Improved Ambush) and Hemo (Subtlety picks).
	- **Warrior**: Dual Wield, chosen when a weapon is in your off-hand, since no early Fury talent tells dual wield from two-handed.
	- **Priest**: Smite/Holy (Divine Fury).

	Rogue Daggers/Hemo and Warrior Dual Wield use the same stat weights as their default profiles for now, so only the profile name changes.
- **Forever Leveling Weights Change Smoothly With Level**: Like TBC, Forever's leveling weights now slide level by level instead of jumping at 21, 41 and 52. Each band's weights are where you start that band, and they blend toward the next band's as you level (e.g. a Warrior's Spirit eases from 2.0 at 11 to 1.0 at 21). The 52-59 profiles hold steady. Weights update when you level up.
	Some 21-40 profiles had simply left out a stat that 11-20 uses, which would have dropped it early: Wand DPS for Priest, Mage and Warlock, and Health Regen for Arms/Fury Warriors. Those now start 21-40 at their 11-20 value and fade out by 41, so level-20 characters keep valuing wands and Health Regen.

### 🐛 Bug Fixes
- **Forever Hunters Undervalued Agility**: Hunters get 2 Ranged Attack Power per point of Agility on Forever (as in original Classic), but the ranged Hunter profiles counted 1. Agility is now worth 1 point more in every ranged Forever Hunter profile (3.0, or 3.5 for the Marksmanship raid profiles), so a melee weapon with Attack Power and Stamina no longer beats one with the same amount of Agility. Melee profiles (Survival, Nightfall and the melee leveling profiles) are unchanged, since melee attack power still gets 1 per Agility.
- **Strength No Longer Counts for Ranged Forever Hunters**: Strength only adds melee attack power, so it's no longer weighted in the ranged Hunter profiles (Default, PvP Marksmanship, Farming and the ranged leveling profiles). The melee profiles still value it.
- **Hunter Ranged AP Row**: The tooltip's Ranged AP change counted Strength and only 1 per Agility. It now shows 2 per Agility on Era/Forever (1 in TBC) and ignores Strength.

---

## 🚀 v3.0.17

### 🐛 Bug Fixes
- **Forever Talent Error (`Dynamic_Engine.lua:134: attempt to call a nil value`)**: Forever's client removed the Classic talent APIs (`GetNumTalents` and the tab/index forms of `GetTalentInfo`/`GetTalentTabInfo`), so spec detection threw an error on every tooltip. Talent reads now use `C_SpecializationInfo` when the old APIs are missing (talent cache, hit/crit talent bonuses, Hunter tree-point check). 
	The talent-tree point fallback used by Warrior, Paladin, Shaman and Druid spec detection also called a function that doesn't exist (`GetNumTalentPoints`) and now reads tree points correctly on every client.
- **Hardened Against Further Blizzard API Removals**: Forever keeps moving old global functions into newer namespaces, so the remaining unguarded uses were fixed before they could break. `GetItemStats` (gem/socket math) and `EquipItemByName` now fall back to their `C_Item` versions. Reading the addon version no longer calls `GetAddOnMetadata` without checking that it exists. 
	The Lab's link hooks (`HandleModifiedItemClick`, `ChatEdit_InsertLink`, `DressUpItemLink`) and the trade-skill overlay hooks are only attached when the Blizzard function exists. If one of the Lab link hooks had gone missing, the rest of the interface file would have failed to load.

---

## 🚀 v3.0.16

### ✨ Improvements
- **Minimap Button Works With Minimap Managers**: The minimap button is now a standard LibDBIcon button (LibStub, CallbackHandler, LibDataBroker and LibDBIcon are now embedded), so **Leatrix Plus** *Combine addon buttons* and other minimap-button collectors pick it up. It also follows square minimap shapes. Your saved button position carries over, and **Hide Minimap Button** still works.

### 🐛 Bug Fixes
- **Hunter Melee Weapons Are Stat Sticks**: Weapon DPS was weighted the same in the melee slot as on the bow/gun, so a ranged Hunter was told a higher-DPS 2H beat one with more Agility/Stamina. Ranged Hunter profiles (Era, TBC, Forever) now value melee-slot weapon DPS at 15% of the ranged value; the weapon's stats still count in full. Melee profiles (Melee/Nightfall, and Forever's melee Survival profiles) are unchanged.

---

## 🚀 v3.0.15

### 🐛 Bug Fixes
- **Baganator Upgrade Arrows**: SGJ hooked `Baganator.ItemButtonUtil.UpdateItemButton`, which doesn't exist, so Baganator bags never showed an arrow. SGJ now uses Baganator's public API instead. A **Sharpie's Gear Judge** icon widget (Baganator *Icons* tab, placed top-right by default) draws SGJ's green/red arrow. **Sharpie's Gear Judge** is also listed under Baganator's *Upgrade detection* option, which drives the `upgrade` search keyword and categories. 
Both work whether or not **Show Bag Upgrade Arrows** is on, since Baganator's own settings are the opt-in. Results are cached per item and refreshed on level-up, talent/spec changes, equipment changes, and when **Fast Bag Arrows** is toggled.

---

## 🚀 v3.0.14

### 🐛 Bug Fixes
- **Bag Upgrade Arrows Blizzard Bags and Bagnon** Tooltips showed the right verdict, but no arrow was drawn.
	Each bag frame's `OnShow`/`UpdateItems` is now hooked. Buttons are read through `EnumerateValidItems()`/`GetBagID()`, and the combined backpack uses the same path instead of its own scanner.
	Bagnon: Bagnon 10+ (the BagBrother core) removed `Bagnon.ItemSlot`, so SGJ's hook never attached. It now hooks `Item`/`ContainerItem:Update`, reads the link from `button.info.hyperlink`, evaluates on the next frame, and rescans the live inventory grid when the bag opens. Items from other characters (cached view) aren't judged.
	Every bag integration (Blizzard, Bagnon, ElvUI) now shares one scoring function and one arrow renderer. The arrow sits on a raised child frame so the button's own layers can't cover it. Toggling **Show Bag Upgrade Arrows** or **Fast Bag Arrows** now updates open bags right away.

---

## 🚀 v3.0.13

### 🐛 Bug Fixes
- **Talent Names Matched Loosely**: Talent lookups needed the name to match exactly, so one spelling difference silently turned a talent off. The September 24 beta notes spell it "Rage of the Far Seer" while the addon (and wowforevertools) used "Rage of the Farseer". If the client uses the spaced version, Enhancement Shamans at 60 would never be detected. Lookups now ignore case and spaces.

### ⚔️ WoW: Forever Beta Build (September 24)
- **Shaman**: Elemental Fury and Elemental Alacrity swapped tiers (Fury is now tier 6, Alacrity tier 3). Fury's crit-damage scaling is unchanged. Alacrity now also counts as a leveling Elemental marker, since Fury isn't available until the mid-30s anymore.

---

## 🚀 v3.0.12

### 🐛 Bug Fixes
- **Error When Hovering Units/Objects in the World**: The tooltip hook fires for every tooltip type, and the line-beautifier ran before the item check, so it read world-cursor tooltips too. That text is a protected "secret" value on this client, and comparing it threw "attempt to compare local 'text' (a secret string value...)". 
	The beautifier now skips any tooltip that isn't for an item, and `ClassifyLine` ignores secret strings. Follow-up: the same error still fired from stance-bar tooltips, because `issecretvalue` isn't available on this client (so the secret check never tripped) and spell/stance tooltips carry a hyperlink the item check accepted. 
	Secret detection now falls back to `canaccessvalue` or a protected compare, and the tooltip item lookup only accepts actual item links.
- **False "Proc Not Yet Modeled" on Bind-on-Equip Items**: "Binds when equipped" contains the word "equip", so the item scanner read it as an Equip effect it couldn't score and flagged every BoE item with the "Proc not yet modeled" note. Binding lines are now skipped.

---

## 🚀 v3.0.11

### ⚔️ WoW: Forever Class Talent Audit (All 9 Classes)
- **Full Talent-vs-Mechanic Cross-Reference**: Went through every Forever class's `Talents`/`GetSpec`/`ApplyScalers` against the confirmed datamined talent changes at wowforevertools.com/changes/`<class>`, scoped specifically to talents that affect how gear and talents interact (stat scaling, damage-bonus multipliers, weapon-type bonuses) rather than pure rotation/proc talents.
	Learned partway through that the site's default view only shows New/Changed talents and hides "Same as Classic" ones — had to explicitly toggle that filter on before concluding a talent was actually removed, after initially misjudging Warrior's Toughness and Impale as gone when only Vitality actually was.
- **Warrior**: Removed dead `VITALITY` (confirmed removed). Restored `IMPALE`/`TOUGHNESS` (confirmed still real). Added `PRECISION`, `BASTION`, `WEAPONMASTER`, `TWOH_SPEC` and wired their scaling (Toughness->Armor, Bastion->Strength for Prot and leveling tank profiles, Two-Handed Weapon Spec->Attack Power outside DW/Prot/tank profiles, Impale->Crit damage bonus, Precision into the hit-cap calc). Added a `GetWeaponmasterCritBonus` helper (Axe/Polearm) mirroring the existing racial weapon-crit-bonus pattern.
- **Paladin**: Added `PRECISION`, `HEALING_LIGHT`, `CRUSADE` and wired their scaling (Healing Light covers the Holy raid profiles and the leveling healer brackets). Removed dead `IMP_MIGHT` ("Improved Blessing of Might" doesn't exist) and its orphaned `HOLY_DEEP`/`RET_UTILITY` spec branches (folded into `RET_STANDARD`).
- **Hunter**: Removed `AIMED_SHOT`/`WYVERN_STING` (confirmed base abilities, not talents). Added `PREDATORS_EDGE`, `FOCUSED_FIRE`, `RANGED_WPN_SPEC`. Fixed Lightning Reflexes' coefficient (0.02 -> 0.03). Wired Mortal Shots/Predator's Edge crit-damage-bonus scaling, gated by melee vs. ranged spec detection (case-insensitive, so the `Leveling_Melee_*` profiles get Predator's Edge rather than Mortal Shots).
- **Rogue**: Wired Lethality's crit scaling (was defined but never applied). Added a `GetHackAndSlashCritBonus` helper (Dagger/Fist) mirroring the racial weapon-crit-bonus pattern.
- **Priest**: Added `SPIRITUAL_HEALING`, `DARKNESS` (Darkness also covers the Shadow leveling brackets). Fixed Spiritual Guidance's scaling coefficients (were 5x too strong). Wired Shadowform's crit-doubling, which had never been implemented despite existing as a talent entry.
- **Shaman**: Added `CONCUSSION`, `PURIFICATION`, `HEALING_WAY`. Wired Elemental Fury's damage-bonus scaling, gated to Elemental specs (including the leveling Elemental brackets); Purification and Healing Way likewise reach the leveling healer brackets.
- **Mage**: Fixed a pre-existing dead-code reference (`ARCANE_RESILIENCE` talent key was checked but never defined). Restored Arcane Mind's Intellect scaling alongside its crit-bonus scaling after catching that an earlier pass this session had dropped it. Wired Ice Shards, Fire Power, and Piercing Ice, rank-gated only (not spec-name-gated, since a text match on "FROST"/"FIRE" would incorrectly exclude real hybrid specs like Elemental or Pyroblast-Molten).
- **Warlock**: Wired Ruin's damage-bonus scaling — this was completely unwired despite being the talent whose rank-detection all three raid specs depend on. Wired Shadow Mastery. Added `MALEDICTION`, `PANDEMIC`, `AGONIZING_FLAMES` and their scaling.
- **Druid**: Wired Vengeance's damage-bonus scaling — the original gap that kicked off this whole audit. Added `MOONFURY`, `GENESIS`, `GIFT_OF_NATURE`, `PREDATORY_INSTINCTS`, `SAVAGE_FURY`, `NATURALIST` and their scaling (Predatory Instincts/Savage Fury gated to Cat weights — `FERAL_CAT_DPS` and the 21+ leveling brackets — since Bear tank doesn't weight Attack Power in this addon's model). Heart of the Wild's Stamina bonus now reaches the leveling Bear profiles and its Strength bonus the leveling Cat profiles.
- **Crit-Damage-Bonus Talent Math, Standardized**: Cross-validated across 7 independently-worded talents (Arcane Mind, Ice Shards, Ruin, Elemental Fury, Vengeance, Pandemic, Impale, Mortal Shots/Predator's Edge) that "increases the critical strike damage bonus of X by Y%" means a *relative* multiplier on the base 50% crit bonus (`1 + rank*Y`), not a flat percentage-point addition — confirmed because every one of these independently converges to a sane value at its own max rank under this reading (several land exactly on 2.0x).

### 🛡️ New: Tank & Healer Leveling Profiles
- **Role Profiles for Every Leveling Band**: Healers had no leveling profile between 20 and 52 in any class, Paladin tanks had none below 52, and no class had a tank profile below 21 — all of them were scored with DPS weights. Added 11-20 tank profiles (Warrior, Paladin, Shaman, Druid Bear), 11-20 healer profiles (Paladin, Priest, Shaman, Druid), and filled the 21-51 gaps: Paladin Tank/Healer, Druid/Shaman/Priest Healer, plus Balance and Elemental caster brackets that previously fell back to melee weights (Balance was only detected through Moonkin Form at 40).
- **Talent-Marker Role Detection (Levels 11-59)**: Counting points per tree misfires, because common DPS leveling picks sit inside the tank/healer trees (Paladin Divine Strength in Holy, Druid Furor in Restoration, Priest Wand Specialization in Discipline). Each class now lists "marker" talents only that role takes — e.g. Anticipation, Redoubt, Healing Light, Improved Renew, Improved Wrath, Convection — checked against Forever's own talent data (wowforevertools.com). The role holding the most marker points wins; ties fall back to DPS. Levels 1-10 are unchanged.
	Shamans have only one unambiguous tank talent in reach (Anticipation, tier 3), so a tank Shaman is auto-detected from level 19 — pick the profile manually before that.
- **Low-Level Bear Druids Got No Verdicts**: 3+ ranks of Thick Hide routed to a `Leveling_Bear_11_20` profile that didn't exist, leaving empty weights and silencing every tooltip. `Druid:GetSpec` now falls back to the DPS bracket like the other classes do.

### ⚖️ Leveling Weight Ladder (All 9 Classes)
- **Band Ladder Instead of Copy-Paste**: Most classes used one identical table from level 1 (or 21) through 59 — all 11 Rogue profiles were the same. Confirmed via real datamined item data (foreverchanges.pro) that Forever's itemization differs from Era's: Spell Power appears from level 1, Defense Rating in every band, and Hit/Crit gear only starts dropping at 41. Leveling weights now step down at those thresholds; the rules are documented in `Warrior.lua`'s `LevelingWeights`:
	- **Armor was ~10x overweighted**: the parser counts an item's full base armor, so tank profiles at 0.5-1.5 let a level-15 shield (~530 armor) score like ~130 Stamina. By the armor formula one armor point is only ~2-4% of a Stamina point for a tank. Tanks now use 0.045-0.075 (bears 0.08-0.19 for Bear Form's armor bonus); non-tanks use 0.025 x their Stamina weight — which also fixes Shaman leveling, where a mail chest could win on armor alone.
	- **Defense**: 0.25 / 0.5 / 1.0 / 1.6 against Stamina 2.0 for 11-20 / 21-40 / 41-51 / 52-59. A Defense point is worth about the same at every level while Stamina's value shrinks as health pools grow, so Defense climbs to just under Stamina by 52-59.
	- **Spirit** is full value through 40, halved at 41-51, and about a quarter at 52-59. Priests and Mages taper slower; healers keep theirs, since every Forever healer has a spirit-while-casting talent (Reverence, Meditation, Mindfulness, Reflection).
	- **Mp5** is weighted for every mana user, worth the Spirit it replaces.
	- **School Spell Damage** ("+X Frost Spell Damage" and the like) was worth 0 to every leveling caster. It's now valued at Spell Power x the share of the spec's damage from that school.
	- **Tank Weapon DPS** tapers as talents take over threat; Paladin keeps more, because Forever's Holy Strike does 40% weapon damage. Block Value arrives with Shield Slam (40+).
	- **Caster Spell Hit/Crit** rise at 41+ (Hit 40 / Crit 25, then 45 / 30 at Spell Power 15). At 20 / 12, 1% Hit was worth 1.3 Spell Power and 1% Crit 0.8, so hit/crit gear always lost to Spell Power gear.
	- **Healer Spell Crit** at 41+ values 1% crit at ~2.4 Healing (a crit heal adds 50%) — it was ~0.5.
- **Class-Specific**: Priest 1-20 gained Stamina (on ~40-60% of low-level items, previously ignored). Druid 11-20 uses Bear Form weights (Forever teaches Bear Form at 10 but Cat Form not until 20). Retribution gains Spell Power (Exorcism, Seal of Command, Consecration) and converges on `RET_STANDARD`'s Hit/Crit by 52-59. Hunters weight Ranged Attack Power; Enhancement weights Spell Power for shocks and Lightning Bolt.
- **Note**: The Forever beta is capped at level 20, so bands above 20 haven't been tested in game yet.

### 🧮 Primary Stat Conversion Math Audit (All 9 Classes)
- **Strength : Attack Power, Weapon DPS : Attack Power, and Agility, Verified Against Real Conversion Formulas**: Rather than inherited or eyeballed numbers, checked the actual mathematical ratio between each primary stat and its derived combat stat:
	- **Strength : Attack Power at 2:1** for plate melee classes (Warrior, Paladin) and Druids (in every form) — several profiles had this as skewed as 15:1, which let a couple points of flat Strength outscore a chunk of direct Attack Power that granted far more actual damage.
	- **Weapon DPS : Attack Power at 14:1** (derived from the classic bonus-damage formula, `AP/14 x weapon speed`, where weapon speed cancels out once expressed as DPS) — applied to melee and ranged weapon-damage stats alike. Several raid Fury/Arms/Marksmanship/Combat/Enhancement profiles had *zero* Weapon DPS weight at all, despite it being one of the two primary damage stats any weapon carries. Druid Cat and Bear forms are the exception: form attacks use the form's own damage, not the weapon's, so those profiles weight Feral Attack Power instead.
	- **Agility, subordinated per-class** to its real mechanical contribution instead of matching Strength's old inflated scale: 0 Attack Power for Warrior/Paladin (Crit/Dodge/Armor only), 1:1 melee Attack Power for Rogue/Hunter/Enhancement Shaman. Druids get Agility Attack Power only in Cat Form (Forever's "+12 plus Agility", 1 AP per Agility — not the "double-rate" conversion previously assumed), so Cat is Strength 2.0 / Agility 1.4 and caster-form levels 1-10 are Strength 2.0 / Agility 1.0.
	- Priest/Mage/Warlock needed no changes here — they never weighted Strength/Agility in the first place.
	- Caught and re-fixed 3 Shaman profiles (`ELE_PVE`, `ENH_STORMSTRIKE`, `RESTO_DEEP`) still carrying an old hedge-era Crit value that an earlier pass believed it had already corrected but hadn't actually landed in the file.

### 🏰 Endgame Profile Corrections
- **Crit "Uncertainty Hedge" Removed**: Found a systematic pattern where most classes' raid profiles had Crit weighted far below their own file's established baseline (e.g. `1.2` instead of `12.0`) — a leftover hedge from before anyone knew how Forever's crit math would actually work. Melee profiles are restored to their file's `12.0` convention. Caster and healer crit are now scaled to each profile's own anchor stat, since raid profiles don't all share one scale (some anchor Spell Power at 2, others at 15):
	- **Casters**: 1% crit = 2 Spell Power before talents like Ruin or Ice Shards — 4.0 on the Spell Power 2 raid profiles (`FIRE_RAID`, `FROST_AP`, `FROST_WC`, `RAID_DS_RUIN`, `RAID_SM_RUIN` still carried the old 1.5), 30 on the Spell Power 15 raid profiles (`PVE_MD_RUIN`, `ELE_PVE`, `BALANCE_BOOMKIN`).
	- **Healers**: 1% crit = ~2.4 Healing (a crit heal adds 50%) — 4.8 at Healing 2 (Priest `HOLY_DEEP`/`DISC_PI_SUPPORT`), 48 at Healing 20 (every Healing-20 healer profile). Paladin Holy (Illumination) and Shaman `RESTO_DEEP` already valued crit higher and keep their values.
- **Raid Caster Hit**: The Spell Power 15 raid profiles (`PVE_MD_RUIN`, `ELE_PVE`, `BALANCE_BOOMKIN`) valued 1% Spell Hit at ~1.5 Spell Power; now 187.5, matching the Spell Power 2 raid profiles' 1% Hit = 12.5 Spell Power.
- **Raid Tank Armor**: `DEEP_PROT`, `FURY_PROT`, `PROT_DEEP` and `PROT_AOE` 0.5 -> 0.075; `FERAL_BEAR_TANK` 0.2 -> 0.1 (its Stamina weight is 1.0). Same armor math as the leveling ladder — shields and plate chests were winning raid verdicts on armor alone.

### 🧮 Forever Combat Ratings
- **Rating Stats Were Scored as Flat Percentages**: Confirmed against real datamined Forever items (foreverchanges.pro — e.g. `Stillwind String`'s "+10 Hit Rating", `Dawn Armor`'s "+14 Critical Strike Rating") that Forever gear grants raw Combat Ratings, the same TBC/Retail-style itemization as everywhere else in modern WoW, not flat Vanilla percentages.
	`MSC.GetItemScore` was multiplying every class's Hit/Crit/Weapon Skill/Defense/Dodge/Parry weight directly against that *raw* rating number, even though those weights were calibrated as "value per 1% (or per 1 skill point)". Fixed centrally in `Helpers.lua`: `GetItemScore` now runs any raw rating stat through `GetRatingPercent()` before applying the weight, so every existing weight keeps its intended meaning — no class file needed to be touched for this fix.
- **Rating Table Rebuilt With Forever's Flat Rates**: Confirmed from 600+ Classic-to-Forever item conversions in foreverchanges.pro's datamine (client 1.60.1) that Forever converts ratings at flat, level-independent rates: every Classic "+1% hit" became +10 Hit Rating, "+1% crit" +14 Critical Strike Rating, "+1% dodge" +12 Dodge Rating, and "+N Defense" became +N Defense Rating — identically from required level 17 through 90.
	`Database_Forever.lua`'s `CombatRatingScalars` had copied TBC's per-level curve, which would have overvalued every rating below level 60 (Defense ~4x at level 17) and misvalued Defense even at 60 (1.5 instead of 1.0). The rebuilt table also removes a divide-by-zero at level 8.
- **Weapon Crit Bonuses Match**: Because weights are now "per 1%", the Human/Dwarf/Orc weapon racials, Warrior Weaponmaster and Rogue Hack and Slash no longer multiply by "rating per 1%" — each +N% crit bonus is worth exactly what the equivalent Critical Strike Rating on an item scores.

### 🐛 Bug Fixes: Forever Item Parsing
- **Mana/Health Regeneration Were Ignored**: Forever prints mp5 as "+X Mana Regeneration" and hp5 as "+X Health Regeneration". The parser only knew Classic's "mana per 5 sec." wording, so both were silently skipped.
- **Spell Damage Was Credited as Healing**: Forever items carry three separate spell stats: "+X Spell Power" (damage and healing), "+X Healing", and "+X Spell Damage" (damage only — Classic healing gear was split into +Healing plus a third as +Spell Damage, e.g. Holy Shroud's +33 Healing / +11 Spell Damage). Spell Damage was read as Spell Power, which healers then counted as healing. It's now its own damage-only stat, valued at each profile's Spell Power weight; Spell Power still gives healers full credit.
- **Removed Two "1/3 of Healing" Guesses**: Both the parser and `GetItemScore` inferred a hidden third of spell damage on healing items. Forever prints it explicitly (and 77 healing items carry none), so it was being double-counted.
- **Feral Attack Power**: Forever's "+X Attack Power in Cat, Bear, and Dire Bear forms only" now parses as Feral Attack Power instead of being skipped.

### ✨ New Feature: Proc Detection Note
- **"Proc Not Yet Modeled" Tooltip Line**: When the item scanner detects raw proc/on-use text on an item but no curated database entry exists for it yet, the tooltip now shows a dim "Proc not yet modeled (score reflects stats only)" note, so it's clear the score is stats-only rather than silently missing the proc's value.

### 🔧 Weapon Skill / Expertise Handling
- **Expertise Folded into Weapon Skill (Forever Only)**: Added a `StatAliases` entry mapping `ITEM_MOD_EXPERTISE_RATING_SHORT` to `ITEM_MOD_WEAPON_SKILL_RATING_SHORT`, isolated to Forever's own copy of that table (TBC's is untouched). A safety net since Expertise's actual presence in Forever's itemization isn't yet confirmed, while Weapon Skill's is.

---

## 🚀 v3.0.10

### 🐛 Bug Fixes
- **Non-Healers Getting Phantom Score from +Healing Gear**: `Helpers.lua`'s "Forever Bonus Spell Power from Healing" conversion (1/3 of a `+Healing` stat credited as Spell Power) was gated only on "does this profile weight Spell Power" — which is true for basically every caster DPS profile too (Mage, Warlock, Shadow Priest), not just healers. A Mage comparing a hybrid heal/damage item against a symmetric one saw a large invisible score swing from the healing portion alone, never reflected in the tooltip's visible Gains/Losses list (which works off raw stat categories, not this converted pool) — surfaced as a Staff of Westfall (48 heal/16 dmg) scoring far above a Golemheart Stave (18/18) on a Mage. Fixed by gating on whether *that specific profile* already weights Spell Healing itself (`weights["...HEALING..."] > 0`), not class — a class-level check would have still wrongly included Shadow Priest, whose `SHADOW_PVE`/`SHADOW_PVP` profiles correctly carry no healing weight despite being the Priest class.
- **Tooltip Verdicts Went Completely Silent (No Errors)**: The entire tooltip verdict system stopped drawing on some client builds, with zero Lua errors — not even the base "Judge's Score" line, on any item. 
	Root cause: `TooltipManager.lua` gated its legacy `GameTooltip`/`ItemRefTooltip`/`ShoppingTooltip` `OnTooltipSetItem` hooks behind `if not TooltipDataProcessor then`, trusting that table's mere existence as proof the modern `TooltipDataProcessor.AddTooltipPostCall` path would actually fire. 
	On at least one client build it exists as a table (with real functions on it) but the registered callback never actually gets invoked by the tooltip pipeline — confirmed by adding a temporary debug print inside it that never fired, while manually calling `MSC.EvaluateAndDrawTooltip(GameTooltip)` directly worked fine. 
	So the "modern" branch got taken, found to be non-functional, and the legacy fallback that would have worked was never registered because we assumed we didn't need it. Also tried registering under `TooltipDataProcessor.AllTypes` instead of `Enum.TooltipDataType.Item` first (in case the enum value didn't line up with what this client's dispatcher actually tags item tooltips with) — didn't help either, confirming the whole `AddTooltipPostCall` path is non-functional here, not just misregistered. 
	Fix: register the legacy `OnTooltipSetItem` hooks (in both `Judge.lua` and `TooltipManager.lua`) unconditionally, regardless of whether `TooltipDataProcessor` exists. `EvaluateAndDrawTooltip`'s own duplicate-guard makes it safe for both mechanisms to fire on clients where both actually work.
- **Relic Bonus Tooltip Note Missing for Forever Druid/Paladin/Shaman**: `Judge.lua`'s "Judge's Notes" tooltip line for Idols/Librams/Totems only reads through `MSC.CurrentClass:GetRelicBonus(itemID, specName)`, which was never implemented for any Forever class even though their `.Relics` data tables existed. 
	Scoring itself was already correct (a separate mechanism in `Helpers.lua` applies `.Relics` stats directly during item scanning), but the tooltip note was silently absent. Added the missing `GetRelicBonus` to Druid, Paladin, and Shaman.

### 🧹 Data Cleanup
- **Removed TBC-Only Item Data from Forever's Database**: `Database_Forever.lua` had a ~140-entry `AddOverrides()` block of unconditional item proc/trinket data that was almost entirely real TBC raid and dungeon content (Bloodlust Brooch, Dragonspine Trophy, "Jewelcrafting Figurines (Phase 5 IDs)", etc.) — content that can't exist in Forever since TBC isn't part of it. 
	Also removed the Rank 2/3 PvP trinket entries (explicitly TBC Level 70 Medallions and WotLK Titan-Forged variants), keeping only the genuine Vanilla-era Rank 1 insignias. Also emptied the Druid/Paladin/Shaman `.Relics` tables (Idols/Librams/Totems are a TBC-introduced item type with no Vanilla equivalent, so every entry in them was TBC-only regardless of specific ID). 
	All of this starts blank and repopulates organically with confirmed Forever item IDs going forward, matching the same approach already used for the Roadmap plugin's item database in v3.0.4. `Data_Sets_Forever.lua`'s `ProcDB` was audited too and found already correctly scoped — its Classic/Era section is untouched and its TBC-specific section was already dead code behind an `if not MSC.IsVanillaRules` guard that never executes on Forever.

---
## 🚀 v3.0.9

### 🐛 Bug Fixes
- **Secondary/Tracked Specs Never Appeared in Tooltips**: `Judge.lua`'s tracked-spec tooltip line checked `if tdelta > 0.01` instead of the actual variable `tDelta` (declared two lines above). 
	Since Lua is case-sensitive, this silently referenced an undefined global (`nil`), and since the whole block runs inside an `xpcall` that only prints on `MSC.Debug`, every tracked-spec evaluation was throwing and getting swallowed silently — secondary specs enabled in Settings never showed an upgrade line in tooltips, with no visible error. Fixed the typo.
- **Forever Weapon Racials Not Scored on Gear Comparisons**: Human's Sword Specialization (+2% Crit), Dwarf's Mace Specialization (+1%), and Orc's Axe Specialization (+1%) were only ever credited in the character-sheet cap-guardian display — every Forever class's `GetWeaponBonus(itemLink, weights)` (the hook actually used when scoring/comparing candidate weapons) was a stub returning `0`. 
	Added a shared `MSC.GetForeverWeaponRacialBonus()` in `Helpers.lua` and wired it into all 9 Forever class modules, so weapon-type racials now actually affect upgrade scoring, not just the current-gear display. Also fixed Orc's Axe Specialization being hardcoded as +2% Crit in that display logic — confirmed via wowforevertools.com and Warcraft Tavern's Forever coverage that it's +1%, matching Dwarf.

### ✨ New Features
- **`/sgjscalar` Now Dumps Equipped Gear and a Full Stat Sheet**: Previously only printed primary stats, a handful of derived combat stats, and any found Combat Ratings. 
	Now also lists every equipped item by slot, plus Defense Skill, Armor, Dodge/Parry/Block%, Ranged AP, Spell Power, and Healing Power — all wrapped in the existing `MSC.SanitizeStat()` protocol to match this addon's established defense against tainted-value crashes.

---
## 🚀 v3.0.8

### 🐛 Bug Fixes
- **Combat Lockdown "Secret Number" Crash (Part 2)**: Wrapped unprotected calls to `UnitRangedAttackPower`, `UnitAttackPower`, `UnitDefense`, and `UnitPowerMax` inside the `MSC.SanitizeStat()` protocol across all class profiles and the main engine. Resolves fatal Lua taint crashes when the 11.5 engine obfuscates combat stats dynamically during encounters.
- **Druid Early-Game Stat Math**: Injected Weapon DPS weights into the `Leveling_1_10` and `Leveling_11_20` Feral Druid profiles. Previously, because Feral Druids ignore weapon DPS in Cat/Bear forms, early-game caster weapons with no primary stats were evaluating as `0.0` sidegrades before the Druid actually unlocked their shapeshifting forms.
- **Blank `/sgj` Window on Era & TBC Anniversary**: Fixed a fatal Lua error where `Interface.lua` called `NineSliceUtil.ApplyLayoutByName(..., "TooltipDefaultDarkLayout")` to skin the Weapon Thunderdome and Receipt panels. 
	That API only exists on the modern retail/WoW: Forever engine — on Era and TBC Anniversary it doesn't exist, so the call threw immediately during `MSC.InitLabView`, aborting the rest of window construction before the sidebar buttons or any tab content were ever created. 
	This left the main window rendering as an empty shell (title bar and close button only, no tabs, no content). Added `MSC.ApplyPanelSkin()`, which tries the modern NineSlice skin first and falls back to a plain Classic-safe tooltip backdrop when it's unavailable.
- **Bag Upgrade Arrows Never Appeared on Default Bags**: The only trigger for `MSC.UpdateBagOverlays` on the standard Blizzard bag frames was a `hooksecurefunc("ContainerFrame_Update", ...)`, guarded by `if ContainerFrame_Update then`. 
	That global no longer exists on the modern 11.x-derived engine TBC Anniversary and Forever now share, so the guard silently failed and the hook never attached — bag arrows had no trigger at all, even with the setting enabled, while tooltip verdicts kept working fine since they use a separate, still-valid hook. Replaced with a `BAG_UPDATE_DELAYED` / `PLAYER_EQUIPMENT_CHANGED` event listener that scans all visible `ContainerFrame` windows directly, which fires reliably across all three clients.

---

## 🚀 v3.0.7

### 🐛 Bug Fixes
- **Secret String Taint Crash**: Resolved a fatal Lua error in Judge.lua triggered during LOOT_OPENED. The 11.5 engine occasionally returns tainted <secret string> objects for UnitGUID('target'). Wrapped the dataminer's GUID parsers in a secure pcall execution block to safely ignore tainted data without crashing the client.

---
## 🚀 v3.0.6

### ✨ New Features - Mainly for testing purpose - (https://discord.gg/aYmhmtGxYs) if you wanna add to the fun
- **In-Game Combat Rating miner**: Built a dynamic /sgjscalar command designed specifically for WoW: Forever theorycrafting. Instead of fighting with hidden curves, simply equip gear with any Combat Rating (Hit, Crit, Haste, Expertise, Mastery, etc.) and type /sgjscalar. The addon will dynamically query the server API and mathematically deduce the exact rating conversion scalar (e.g., 14 rating = 1%) for your specific level.
- **Copy-Pasteable Export UI**: Modified the /sgjscalar command to render its output into a massive, copy-pasteable UI window (identical to /sgjminer) instead of vomiting text into the chat log. This allows for frictionless data logging to Discord or spreadsheets.
- **Comprehensive Character Snapshotting**: The /sgjscalar export now includes your Class, Race, Level, Total Attack Power, Total Max Health, Mana Regen (split into Not Casting vs Casting), and Energy/Focus Regen to give a 100% complete snapshot of your character.
- **Leveling Spec Splicing**: Spliced the massive Leveling_1_20 stat-weight band directly down the middle. Created a dedicated Leveling_1_10 profile and a Leveling_11_20 profile across all 9 class modules to dynamically route priorities and account for WoW: Forever's drastically boosted early-game spell power itemization.
- **Blizzard Item Budgets Databased**: Extracted and securely injected the official 11.5 engine ScalingStatValues (Item Budget) table directly into Database_Forever.lua. 

### 🐛 Bug Fixes
- **Regex Fix**: Cleaned up the routing syntax inside GetSpec() across all class modules after an automated script injected literal newline strings into the code while splitting the leveling bands.


## 🚀 v3.0.5

### ✨ New Features
- **Group Loot Side-Panel**: Completely overhauled the Group Loot frames! Instead of tiny up/down icons, the addon now attaches a sleek, rich tooltip directly to the side of the loot roll frame. It displays a clear "Recommended Roll: NEED" or "GREED/PASS" verdict, the mathematical percentage upgrade, and the exact equipped item link it's being compared against.
- **Rested XP UI Updates**: Upgraded the SharpiesGearJudge_XP plugin's visual tracking. The bar now draws a classic, translucent blue "tail" extending outward to show exactly where your rested XP ends. Also added exact Rested XP data directly into the tooltip when hovering.

### 🐛 Bug Fixes
- **Empty Slot Tooltip Clarity**: Fixed a confusing mathematical edge case where comparing an upgrade against an empty slot would display +0.0% in the tooltip. It now correctly identifies empty slot upgrades as (New).
- **Combat Lockdown "Secret Number" Crash**: Swept all class modules (Druid, Mage, Priest, etc.) and wrapped internal calls to GetSpellBonusDamage, GetSpellBonusHealing, GetCombatRating, and UnitDefense inside the addon's MSC.SanitizeStat safety protocol. This resolves a fatal Lua crash triggered when the 11.5 engine locked down combat APIs and injected un-mathable <secret number> objects instead of integers.
- **UnitBuff API Polyfill**: Fixed a fatal UI crash in the Laboratory rings caused by the modern 11.5 engine removing the UnitBuff global API. Implemented a robust fallback using AuraUtil.FindAuraByName and C_UnitAuras.
- **Missing Stat Descriptions**: Added descriptive text for SPELL_HIT, ATTACK_POWER, and DAMAGE_PER_SECOND to the stat logic breakdown.
- **Receipt Window Layout Overhaul**: Completely remodeled the Receipt UI tab. Removed the restrictive semi-transparent dark panels, boosted the window opacity for a clean "floating HUD" look, and rearranged WEAPONS into a space-efficient vertical 3rd column. The Capstone Score is now vastly enlarged and dynamically positioned next to the stat totals.
- **LabBlocks Overlap**: Corrected Y-offset math inside the Laboratory color bars to prevent the title and sub-text from colliding.

---

## 🚀 v3.0.4

### 🔧 Beta Client & API Crash Fixes
- **SavedVariables Beta Bypass**: Added a temporary hardcode override in Init.lua to guarantee essential settings (like Bag Arrows) load properly while the WoW 11.5 beta client's file I/O is broken.
- **UnitBuff Polyfill**: Fixed a fatal UI crash when calculating Spell Crit stats. Replaced the deleted global UnitBuff API with modern AuraUtil.FindAuraByName and C_UnitAuras fallbacks.
- **Roadmap MouseIsOver Crash**: Fixed a nil crash on the Roadmap interactive popup. Converted the deprecated global MouseIsOver() function to the modern rame:IsMouseOver() method.

### 🗺️ Data & Roadmap Updates
- **Data Export UI**: Added the /sgjminer export slash command. This opens an in-game UI frame that automatically serializes your discovered drops into raw Lua strings, allowing testers to cleanly Ctrl+C copy the data without navigating corrupted WTF folders.
- **Pure Dynamic Roadmap**: Completely wiped the legacy Vanilla item and quest databases (D1_Items_Forever.lua and D5_Quests_Forever.lua) for the beta. The Roadmap will now start as a blank slate and populate 100% organically based only on real-time dataminer discoveries, eliminating false positives from old expansions.

---

## 🚀 v3.0.3

### ⚔️ WoW: Forever Class Talent Overhauls
- **All 9 Classes Updated**: Completely rewrote the auto-detect routing (GetSpec) and dynamic stat scalers (ApplyScalers) for Warrior, Paladin, Hunter, Rogue, Priest, Shaman, Mage, Warlock, and Druid to accurately reflect the official WoW: Forever talent trees.
- Capstone talents, hybrid scaling multipliers (e.g. Spirit to Spell Damage, Attack Power to Intellect), and deep-tree spec detection have been fully natively integrated.

### 🐛 Bug Fixes & Minor Adjustments
- **SavedVariables Corruption Fix**: Removed legacy SavedVariablesPerCharacter tags from all .toc files. This completely bypasses a critical WoW Forever Beta bug (introduced in build 69913) that was corrupting WTF folders and preventing UI settings from saving.
- **Roadmap Modernization**: Repaired Roadmap UnitDefense crashes and TBC feature leaks caused by the new modern 11.0 hybrid engine.
- **Profession API Lua Errors**: Bridged deprecated Global APIs (GetNumSkillLines, GetNumTradeSkills) that were completely removed in the WoW: Forever (11.5) hybrid engine. Polyfilled the TradeSkillFrame scanners to silently failover, preventing severe Lua errors when opening the crafting windows.

---

## 🚀 v3.0.2

### ⚔️ WoW: Forever Stat Meta Overhaul
- **Unified Hit & Crit System**: Updated the math engine to dynamically unify physical and magical hit/crit values. Items with Hit now properly evaluate for hybrid classes (e.g., Spell Hit evaluating perfectly for physical builds, and vice-versa).
- **Healer Stat Conversion (1/3 Ratio)**: Programmed the core logic engine to natively convert 33.3% of +Healing gear into +Spell Damage to match Forever's new hybrid leveling rules for healers.
- **Removed Gemming UI**: Disabled Jewelcrafting/Gemming options from the interface menus when running on the Forever/Era engine (since the game uses Vanilla rules).
- **BlizzCon 2026 Expertise Overhaul**: Systematically re-weighted all 9 classes in the Classes/Forever folder to align with the official Kris Zierhut BlizzCon 2026 presentation:
  - **Expertise Stacking**: Injected the new Expertise stat behind Hit Cap for all physical and tank profiles.
  - **Weapon Skill Item Caps**: Restored Weapon Skill support to accommodate items that still carry skill.
  - **Racial Skill Deactivation**: Disabled all hardcoded Vanilla racial weapon skill bonuses (e.g., Human Swords, Orc Axes) for Forever.
  - **DoT Crit Scaling**: Significantly buffed Crit weights across DoT-heavy specs (Affliction Warlock, Shadow Priest) now that periodic damage can natively critically strike.

---

## 🚀 v3.0.1

### 🐛 Bug Fixes & Engine Ports (11.5)
- **11.5 Engine Taint Resolution**: Completely resolved secure environment math crashes on item hover in the WoW: Forever client. Built a new mathematical sanitization wrapper for all live-stat API calls to prevent 11.5 taint propagation.
- **Legacy API Bridges**: Bridged several deleted global APIs for the 11.5 client. Created polyfills to gracefully bridge 	ooltip:GetItem() and GetNumTalentTabs to their modern 11.0 TooltipUtil equivalents.
- **Enhanced Backpack (One-Bag) Support**: Re-engineered the bag evaluation scanner to natively support the modern 11.5 "Combined Backpack". Upgrade arrows now dynamically spawn correctly across the combined inventory.
- **Classic Bag (Separated) Array Fix**: Updated standard bag iteration to support the modern ContainerFrameX.Items array format, repairing bag arrows for players who prefer the "Classic" interface preset.

---

## 🚀 v3.0.0

### ⭐ Features & Updates
- **WoW: Forever Support**:
  - **Modern Engine UI**: The addon UI has been updated to run flawlessly on the modern retail engine used in the WoW: Forever beta.
  - **Database Split**: Safely isolated datasets, sets, and profiles into a dedicated _Forever branch. This guarantees the Classic Era and TBC versions remain 100% untouched.
  - **Weapon Racials Overhaul**: Purged old Classic Era weapon skill calculations (e.g., +5 swords) across the board for all Forever class profiles.
  - **Dynamic Math Engine**: Successfully implemented and wired up new dynamic racial values across all 9 classes (e.g., +2% Crit for Humans with Swords, +1% Crit for Dwarves with Maces).
  - **Future-Proofing Architecture**: Decoupled the MSC.IsEra flag from WoW: Forever. Created a new shared MSC.IsVanillaRules flag across the entire math engine, ensuring that WoW: Forever can safely share underlying Classic mechanics for now, but can be effortlessly decoupled later if its mechanics diverge from Era.

---

## 🚀 SharpiesGearJudge:Collection (v2.2.8 - v2.6.5)

### 🛠️ Core Engine & Performance
- **Initialization Overhaul**: Moved to a "Pending Module" registration system. The addon now uses PLAYER_LOGIN and ForceInit to detect class modules, wiring up profiles only when needed to save memory.
- **Micro-Optimizations**: Extensive localization of Lua and WoW APIs across all files to reduce global lookups.
- **Update Throttling**: Replaced old OnUpdate logic with a C_Timer based debounce system to handle UI refreshes efficiently during bag/event changes.

### 🔍 Parser & Data Accuracy
- **Parse.lua Overhaul**: Expanded TermMap and EquipPatterns to support Era/TBC phrasings. Improved right-side tooltip scanning to fix missing weapon speed/damage data.
- **Pawn Integration**: Added a robust Pawn v1 string parser, allowing users to import external weight scales directly into the addon's DB.

### ⚖️ Evaluator & Mechanics
- **Dynamic Caps**: Added talent and racial detection to dynamically adjust hit, expertise, and defense caps for the UI rings.
- **Set Bonus Logic**: Rewrote the item set system to use a fast itemID->setID lookup. The evaluator now accurately calculates set bonus gains or breaks when comparing gear.

### 📺 UI & User Experience
- **Multi-Spec Tracking**: Introduced the ability to track secondary profiles simultaneously, showing upgrade deltas for off-specs in the item tooltips.
- **Quest Overlays**: Added QUEST_COMPLETE handling to visually mark the best upgrade choice among quest rewards.
- **Tooltip Improvements**: Added a "Shift Key Only" toggle, fixed minimap anchoring/draggability, and refined the score breakdown to include proc contributions.
