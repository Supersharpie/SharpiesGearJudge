# Sharpie's Gear Judge - Version History

## v2.2.3 Changelog

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