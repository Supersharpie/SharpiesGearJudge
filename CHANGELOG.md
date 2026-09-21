# Sharpie's Gear Judge - Version History

## 🚀 v3.0.10

### 🐛 Bug Fixes
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
