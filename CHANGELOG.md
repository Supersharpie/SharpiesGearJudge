# Sharpie's Gear Judge - Version History

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
