# Sharpie's Gear Judge - Version History

---

## 🚀 v3.0.6

### ✨ New Features - Mainly for testing purpose - (https://discord.gg/aYmhmtGxYs) if you wanna add to the fun
- **In-Game Combat Rating miner**: Built a dynamic /sgjscalar command designed specifically for WoW: Forever theorycrafting. Instead of fighting with hidden curves, simply equip gear with any Combat Rating (Hit, Crit, Haste, Expertise, Mastery, etc.) and type /sgjscalar. The addon will dynamically query the server API and mathematically deduce the exact rating conversion scalar (e.g., 14 rating = 1%) for your specific level.
- **Copy-Pasteable Export UI**: Modified the /sgjscalar command to render its output into a massive, copy-pasteable UI window (identical to /sgjminer) instead of vomiting text into the chat log. This allows for frictionless data logging to Discord or spreadsheets.
- **Comprehensive Character Snapshotting**: The /sgjscalar export now includes your Class, Race, Level, Total Attack Power, Total Max Health, Mana Regen (split into Not Casting vs Casting), and Energy/Focus Regen to give a 100% complete snapshot of your character.
- **Leveling Spec Splicing**: Spliced the massive Leveling_1_20 stat-weight band directly down the middle. Created a dedicated Leveling_1_10 profile and a Leveling_11_20 profile across all 9 class modules to dynamically route priorities and account for WoW: Forever's drastically boosted early-game spell power itemization.

### 🐛 Bug Fixes
- **Regex Fix**: Cleaned up the routing syntax inside GetSpec() across all class modules after an automated script injected literal newline strings into the code while splitting the leveling bands.

---

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
