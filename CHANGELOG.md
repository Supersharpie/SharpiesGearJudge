# Sharpie's Gear Judge - Version History

## 🚀 v2.2.11 CHANGELOG

* ** Added talent detection and apply talent-based hit bonuses to melee/spell hit caps  and racial/weapon effects to hit, expertise, crit and defense caps used for UI rings.**
	*(including TBC-specific talents like Draenei Heroic Presence and Druid Survival of the Fittest), and performs a weapon/ranged check to grant racial expertise/crit where appropriate.
* ** Introduces GetTalentRank helper, computes meleeHitBonus and spellHitBonus for Mage, Warlock, Priest, Shaman, Druid, Rogue, Hunter, Paladin.**
* ** Handles TBC-specific talent differences, clamps caps to non-negative values, and then uses the adjusted caps when building rings.**
* ** Also adds smart expertise visibility logic, minor ring formatting cleanup.**

------------------------------------------------------------------------------------------------

## 🚀 v2.2.10

* ** Add spell power to Priest leveling/healer weights (ERA & TBC) and tidy formatting. (No idea how I could have forgot this >.<)**
* ** Overhaul minimap button: make it movable, draggable, save/restore position on login, ensure proper frame level. **
* ** Major enhancements to expand BaseStatMap and TermMap, add many green/white-text and TBC-era phrases, improve pattern databases, add functional pattern support. **
* ** Misc: minor parsing fixes and improved pattern priority/robustness for parsing item tooltips.**

------------------------------------------------------------------------------------------------

## 🚀 v2.2.9

###✨ Item Database
* **Rework proc and item data and add class-specific lookup.**
	* Classes/TBC/Druid.lua: remove manual Wolfshead Helm entry from Druid.Relics (wrong location) and update Idol of Terror to provide an Agility estimate with note.
	* Data_Sets.lua: reorganize and centralize ProcDB, add/clean many Classic & TBC proc entries (with notes, corrections and phase grouping), and merge TBC procs into the main ProcDB.
	* Database.lua: add and adjust several ItemOverrides (including reintroducing the Wolfshead override with notes), correct/replace various estimated stats (e.g. 30665 -> spirit estimate), remove duplicated entries, and tidy Darkmoon card and other trinket notes.
	* Helpers.lua: change GetRawItemStats lookup order to apply class-specific overrides (Relics/Totems/Idols/ItemOverrides) first and sum numeric stat values into finalStats before falling back to global Proc/Weapon/Trinket DBs.
* **These changes consolidate proc/item data, fix several stat and ID corrections, and ensure class-specific relics and item overrides are applied reliably when computing item stats.**

------------------------------------------------------------------------------------------------	

## 🚀 v2.2.8

### 🐛 Bug Fixes
	* Fixed Parser it was not scanning right side of tooltip missing weapon speed and causeing speed and weapon damages to fail calculations 
	* Paladin Ret stat weights adjusted
	* Add a few more On Chance items to database
	
------------------------------------------------------------------------------------------------	
	
## 🚀 v2.2.7 
* **Update to files to enable plug-in addons 
* **Class Backgrounds Returned

------------------------------------------------------------------------------------------------

## 🚀 v2.2.6

* ** This update itemization, specifically addressing items with "Use" effects, complex procs, and niche mechanics that the automatic scanner cannot naturally value.

#### Jewelcrafting Figurines 
* ** Added manual value overrides for the BoP Jewelcrafting trinkets. These rely on active "Use" effects.

### 🐛 Bug Fixes
* ** Fixed an issue where the "Chance to reduce mana cost" was ignored. It is now valued.
* ** Fix: Handle newline wrapping in tooltips; improve whitespace sanitization; expand TBC spell damage patterns.
* ** Fixed scoring for items with unique triggers or non-standard stat blocks.

------------------------------------------------------------------------------------------------

## 🚀 v2.2.5

###💎 Gem Database & Logic
* **Expanded Gem Library: Added full support for Tier 6/Sunwell gems (Crimson Spinel, Lionseye), Heroic Dungeon drops (Fire Opals), and "Ornate" PvP gems.

* **Unified Detection: Consolidated Epic, PvP, and Leveling tables into master color lists (Red, Blue, Yellow) for automatic detection.
* **Dynamic Meta Requirements: Rewrote the scoring engine to handle multi-color gems accurately.
* **Purple: Counts as 1 Red + 1 Blue.
* **Orange: Counts as 1 Red + 1 Yellow.
* **Green: Counts as 1 Blue + 1 Yellow.
* **UI Update: The "Gem Suggestions" now correctly displays multi-color options for leveling slots.

###✨ Enchant & Item Database
* **High-End Enchant Support: Added Exalted Aldor/Scryer inscriptions, Naxxramas shoulder enchants, and T5/T6 leg armor (Nethercobra/Spellthread).
* **Relic & Trinket Overrides: Implemented manual stat overrides for items with unique effects:
* **Class Relics: Idols, Librams, and Totems now map specific spell bonuses (e.g., Starfire damage) to evaluated Spell Power/Block values.
* **Procs (PPM): Added scoring for major procs like Dragonspine Trophy, Tsunami Talisman, and Dragonstrike.
* **Special Items: Implemented valuation for Darkmoon Cards (Crusade/Blue Dragon) and Mark of the Champion.
* **Database Architecture: Split the database into modular files (Data_Weapons.lua, Data_Trinkets.lua, etc.) to improve maintainability and reduced memory footprint by filtering "high-value" vs "fluff" items.

### 🧠 Core Scoring & Logic
* **Projected vs. Raw: "Mode 3" now correctly applies best-in-slot enchants to currently equipped gear to prevent false upgrade flags on un-enchanted bag items.
* **Raw Mode Integrity: Fixed an issue where "Mode 1" would strip existing enchants during calculation.
* **Class Safety & Validation: Added IsItemUsable checks to bag scanning. The addon will no longer suggest weapons or off-hands your class/spec cannot equip (e.g., non-Enhancement Shamans are now restricted to Shields/Held Items).
* **Stat Detection (Parse.lua): Updated ClassifyLine to detect implicit stats (e.g., "Restores X mana") that lack the standard Equip: prefix.

###📜 New Feature: "Judge's Note" System
* **Manual Insights: Added a "Librarian" system to display tooltips for items that math alone cannot evaluate (e.g., "Phase 1 BiS").
* **Visual Enhancements: Implemented a high-quality color gradient system for notes:
* **Purple: Trinkets & Standard Class Notes.
* **Orange: Weapons.
* **Red/Pink: PvP Items.
* **Cyan: Class-specific Relics/Totems.

### 🐛 Bug Fixes
* ** Parsing: Fixed a newline bug where word-wrapping caused scanners to fail on long item descriptions.

------------------------------------------------------------------------------------------------

## v2.2.4 

### Core Engine Fixes
* **Silent Crash Fix: Updated MSC:GetTalentRank in Dynamic_Engine.lua to enforce a number return (tonumber(rank) or 0). This prevents the addon from crashing when the WoW API returns nil for talent data.
* **Optimization: Implemented a Talent Cache system. The addon now scans your 50+ talents once per session instead of every time you move the mouse, significantly reducing CPU lag.

### Scoring Logic
* **Hybrid Item Fix: Removed the "Poison Penalty" system which subtracted 10 points for having off-spec stats.
* **New "Bouncer" System: Implemented a Ratio Check, replacing the poison logic (good in theroy, bad for hybrid items) The addon now only rejects an item if the "Useless Stats" (Str/Agi) count is double the "Useful Stats" (Stam/Int).
* **Result: Hybrid items now score correctly, while pure trash items are still ignored.

------------------------------------------------------------------------------------------------

## v2.2.3

### New Features
* **Math Tooltips: Hovering over any stat bar now displays the exact equation used: Weight × Amount = Score.
* **Character vs. Gear: The tooltip now explicitly compares "Gear Contribution" (what the addon sees) vs. "Character Total" (what the game sees), making it easy to spot missing enchants or base stat discrepancies.

### Core Engine Updates (Parser)
* **"Bulletproof" Stat Parsing: Completely rewrote Parse.lua to use a fuzzy-matching, case-insensitive engine.
* **Suffix Items Fixed: Random enchant items (e.g., ...of the Bear, ...of the Whale) are now correctly scored, fixing the issue where they previously showed 0.0.
* **Format Agnostic: Now correctly reads all variations of stat text, including +10 Strength, Strength +10, 10 Strength, and Strength 10.
* **Edge Case Support: Added explicit support for "Feral Attack Power" (e.g., Earthwarden) and Classic Era long-form text ("Increases damage and healing done by...").

### Bug Fixes & Polish
* **Live Refresh: Fixed an issue where the interface wouldn't update immediately after changing gear or logging in. The addon now forces a recalculation on PLAYER_ENTERING_WORLD and PLAYER_EQUIPMENT_CHANGED.

------------------------------------------------------------------------------------------------

## V2.2.2 Weapon Thunderdome

### Core Engine
* **Fixed Manual Profile Selection: Updated Dynamic_Engine.lua to correctly route manual dropdown selections through the dynamic calculation engine. This fixes the issue where selecting a specific profile (e.g., "Leveling 60-70") would return empty results or only "Off-Hand DPS".
* **Added Preview Clamping: Implemented logic to clamp leveling progress to 0% or 100% when manually previewing a bracket outside the player's current level. This prevents "Negative Stat Weights" from breaking the display when a low-level character previews endgame weights.

### Class Modules (Warrior, Mage, Rogue, etc.)
* **Robust Weight Interpolation: Rewrote GetDynamicWeights across all classes to merge Start and End table keys. This prevents stats from disappearing during leveling if they were missing from one side of the bracket definition.
* **Pretty Name Translator: Added a reverse-lookup mechanism to GetDynamicWeights that translates human-readable dropdown names (e.g., "Standard Leveling (21-40)") back to internal code keys (e.g., Leveling_2H_21_40), resolving the "Silent Nil" error.
* **Data Integrity: Fixed missing commas and key mismatches in the LevelingBrackets data tables for Warrior (and applied standardization to other classes) to ensure smooth transitions between level ranges.

### The Dashboard
* **Tab 1: The Laboratory: Renamed - "Weapon Thunderdome"
* **New Feature: The 6-Way Thunderdome
* **Dual-Column Layout: The Laboratory is now split into Set 1 (Left) and Set 2 (Right), allowing for side-by-side comparison of two completely different loadouts.
* **3-Option Blocks: Each Set now contains three distinct configuration blocks:
	* *Option A: Two-Hander
	* *Option B: Main Hand + Shield/Off-Hand
	* *Option C: Dual Wield (Main Hand + One-Hander)
	* *Winner Detection: The addon calculates scores for all 6 blocks simultaneously. The block with the highest score lights up with a Green "WINNER" Border, while losing blocks are dimmed.

------------------------------------------------------------------------------------------------

## V2.2.1 🖥️UI + Dynamic Leveling

* **This update introduces a fundamental shift in how the addon handles features and UI, moving toward a modular Plugin Engine and a more responsive dashboard.
* **Major Features
* **Dynamic Plugin Engine: Implemented a new tab registry system (MSC.RegisteredTabs), allowing for cleaner code and easier expansion of addon features.
	* *The Laboratory - (Still Experimenting) New Plugin not yet released.
* **Dynamic Sidebar: The sidebar now renders buttons based on registered plugins, complete with improved hover effects and tooltips.

### CORE ENGINE
* **Standardized Module Architecture: All class modules have been refactored to use unified template.
* **Dynamic Leveling Brackets: Replaced static leveling lists with a Start/End interpolation system. The addon now calculates the exact value of a stat based on your specific level within a bracket (e.g., Strength value now climbs smoothly from level 21 to 40 instead of jumping at the finish line).
* **New Math Engine: Implemented GetDynamicWeights in all modules. This function handles the real-time math for leveling interpolation and spec fallbacks.
* **Data Integrity (Safety Copy): Added a "Safety Copy" protocol to ApplyScalers. The engine now creates a local instance of your weights before applying caps or talents, ensuring the master database is never accidentally corrupted by temporary buffs.
* **TBC Spirit Helper: Integrated MSC:GetSpiritValueInMP5 to handle the complex Intellect/Spirit relationship for Priests, Druids, and Shamans.

### INTERFACE & UI
* **Bug Fix (Crash): Fixed a critical "nil value" error when clicking the Export Data button. The function ShowHistory is now properly defined.
* **Bug Fix (Crash): Fixed a potential crash when opening the Import Pawn String window.
* **Frame Strata Optimization: Tool windows (Import/Export) now use the DIALOG strata, ensuring they appear on top of the main dashboard rather than behind it.
* **Dynamic Logic View: The Stat Logic tab now displays live, interpolated stat weights, showing users exactly how the math scales as they level.
* **Receipt Tab Overhaul: Standardized the Receipt view to use the new dynamic engine for both the player and inspected targets.
* **Class Art Engine: Restored class-specific backgrounds with a new dark-tinted overlay for better text readability.

### CLASS SPECIFIC UPDATES 
* **Paladin: Added dynamic Haste scaling for Seal of Blood (Horde) vs. Seal of Command (Alliance) meta.
* **Warlock: Introduced Life Tap Synergy. Stamina weight now dynamically increases as your Spell Power grows, reflecting the increased mana-conversion efficiency.
* **Shaman: Implemented a dual-hit cap system. Enhancement correctly tracks Melee Hit (6), while Elemental tracks Spell Hit (8) with Totem of Wrath detection.
* **Hunter: Fixed a core bug where Hunters were tracking Melee Hit instead of Ranged Hit.
* **Druid: Added Crit Immunity detection for Bears. The addon will now pivot stat weight from Defense/Resilience to Stamina/Armor automatically once you are safely "un-crittable."
* **Rogue: Optimized Armor Penetration scaling; as you stack more ArPen, its weight value increases to reflect the non-linear benefit of the stat in TBC.

------------------------------------------------------------------------------------------------

## V2.2.0🖥️ UI Overhaul: The Dashboard
* **The Main Dashboard: Completely replaced the old options menu with a modern 4-Tab Interface (/sgj).
* **Tab 1: (not active yet )The Laboratory: Added a new drag-and-drop simulator. You can now drag items from chat or bags into a "Virtual Paperdoll" to compare them against your equipped gear without binding them.
* **Tab 2: The Receipt: The "Ledger" is now a full visual character sheet.
* **Tab 3: Stat Logic: Added visual progress bars for critical caps (Hit Rating, Defense) and bar charts for your current stat weights.
* **Tab 4: Protocol: Centralized settings, SimC/Pawn Import, and Data Export into a single configuration tab.

### **New Features**
* **"Hybrid Display" for Ratings:** Tooltips now intelligently display both the Rating *and* the calculated Percentage for your specific level.
    * *Example:* Instead of just `+14 Crit Rating`, you will now see `+14 Crit Rating (0.64%)`.
    * This uses a new, high-precision "Truth Table" containing exact scalar values for every level from 1 to 70.
* **Classic Era Compatibility:** Restored full support for Vanilla phrasing ("Improves your chance to..."), ensuring Level 60 raid gear scans correctly on the Anniversary server.
* **Net Gain Calculation:** The "Gains" list in the tooltip now strictly displays the mathematical difference between your equipped item and the new item, eliminating confusion about total stats versus upgrade stats.

### **Bug Fixes**
* **Fixed "Double Dip" Visuals:** Resolved a visual issue where derived stats (e.g., Crit from Agility) appeared to be counted twice in the tooltip list. The math was always correct, but the display is now cleaner.
* **Fixed Feral Attack Power:** The scanner now correctly identifies "Attack Power in Cat/Bear forms" (e.g., *Ursol's Claw*). These items no longer show false high scores for Warriors, Rogues, or Hunters.
* **Fixed Weapon DPS Scanning:** Adjusted patterns to correctly read "Damage Per Second" regardless of capitalization (Title Case vs. Lowercase), fixing issues with items like *Destiny*.
* **Fixed Shield Scanning:** The scanner now properly reads "Block Value" from the white text at the top of shields, which was previously being ignored.

### **Database Updates**
* **Proc Weapon Overrides:** Added manual stat estimates for dozens of "Chance on Hit" items that scanners cannot read.
    * *Added/Updated:* Destiny, Ironfoe, Thrash Blade, The Untamed Blade, Bonereaver's Edge, Spinal Reaper, Thunderfury, and more.
* **Trinket Overrides:** Added scoring logic for complex TBC and Classic trinkets, including *Tsunami Talisman*, *Dragonspine Trophy*, and *Hand of Justice*.
* **Terminology Update:** Renamed UI labels from "Crit/Hit" to "Crit Rating/Hit Rating" to better align with TBC standards.

------------------------------------------------------------------------------------------------

## v2.1.0 - The "Anniversary" Update (Core + Plugins)
**Major Architecture Overhaul & TBC Readiness**

### 🏗️ The "Core + Plugin" Architecture
* **Modular Class Design:** The addon has been completely restructured. The massive `Database.lua` has been split into individual Class Modules (`Classes/Warrior.lua`, `Classes/Mage.lua`, etc.).
* **Memory Efficiency:** The addon now only loads the math logic for *your* specific class, significantly reducing memory usage.
* **Extensibility:** This structure allows for easier updates to specific classes without breaking the entire addon.

### ⚔️ TBC Phase 1–5 Complete
* **Sunwell Ready:** Added support for Phase 5 items, including **Shattered Sun Pendants**, **Sunwell Badge Gear**, and the new **Epic Gems**.
* **Trinket Overrides:** Added manual proc valuations for over 100+ TBC trinkets (e.g., *Dragonspine Trophy*, *Shard of Contempt*, *Blackened Naaru Sliver*). "Use" and "Proc" effects are now converted into passive stat averages for scoring.
* **Relic Support:** Added specific stat mappings for **Idols, Librams, and Totems**. Items like *Idol of the Raven Goddess* or *Totem of the Void* now display correct scores instead of "0".

### 🧠 Math 2.0: "Smart Scaling"
* **Covariance Logic:** The Judge now understands synergy.
    * *Example:* If your Attack Power is high, the value of Crit Rating automatically increases.
    * *Example:* If your Spell Power is high, the value of Haste Rating increases.
* **Hysteresis (Anti-Loop):** Fixed the "Equip/Unequip" loop bug. The addon now uses a "Buffer Zone" (15 rating) before telling you to drop Hit/Defense below the cap, ensuring you don't accidentally uncap yourself.
* **Poison Protection:** Added a safety net (0.02 weight) to off-stats (e.g., Strength on a Mage item) to prevent them from showing a negative score due to internal penalties.

### 🛡️ Spec-Specific Logic
* **Warrior:** Added "Anti-Dual Wield" logic for Arms. The addon now explicitly sets Offhand DPS value to zero for Arms Warriors to enforce 2H dominance.
* **Druid:** Fixed parsing for **"Feral Attack Power"**. The Judge now correctly distinguishes between generic AP and the massive Feral AP found on staves.
* **Paladin/Shaman:** Added racial checks for Weapon Expertise (Human/Orc) and Hit (Draenei).
* **Hunter:** Fixed Hit Cap logic to use **Ranged Hit** instead of Melee Hit.

### 📜 UI & Tooltips
* **The Ledger:** The "Receipt" window has been polished to show a cleaner breakdown of Active Stats vs. Capped Stats.
* **Gem Projection:** Fixed a bug where the "Smart Gem" auditor would sometimes suggest Unique gems you already had equipped.

------------------------------------------------------------------------------------------------

## v2.0.0 - The Burning Crusade Launch - IT NEVER WORKED :(
* **Full TBC Conversion:** Updated engine for Patch 2.5.5.
* **New Stats:** Added Resilience, Expertise, Armor Pen, and Spell Haste.
* **Socket Logic:** Added smart gem projection and socket bonus calculations.

## v1.9.0 - The Leveling Update
* **Leveling Profiles:** Introduced distinct stat weights for Level 1-20, 21-40, etc.

* **Green Item Fix:** Improved parsing for random enchantments ("...of the Whale").