# Sharpie's Gear Judge - Version History
Sharpie's Gear Judge - Version 1.10.0 (Classic Era Edition)
========================================================================

ARCHITECTURAL OVERHAUL:
- The "TBC Engine" (v3.0.0 Architecture) has been successfully backported to Classic Era.
- This brings the stability, modularity, and speed of the TBC version to Vanilla.

NEW FEATURES:
- Projected Enchants: The addon can now calculate the "Potential Score" of an item if it were properly enchanted, allowing for fair comparisons between un-enchanted upgrades and fully maxed current gear.
- The Laboratory: A new "Sim Interface" (accessible via /sgj lab) allows you to compare Main Hand + Off Hand combos against 2-Handed weapons side-by-side.
- Gear Receipt: Inspect any player to generate a detailed "Bill of Materials" showing their total score, missing enchants, and stat breakdown.

CLASSIC ERA SPECIFICS:
- Weapon Skill Logic: The scoring engine now heavily prioritizes Weapon Skill (e.g., +5 Swords) for Melee classes to account for Glancing Blow penalties on Level 63 bosses.
- Hit Cap Hysteresis: Updated Hit Cap logic to distinguishing between "Yellow Hit" (Abilities) and "White Hit" (Auto-attacks).
- Spell Parsing: The scanner now correctly differentiates between "Damage and Healing" (Spell Power) and "Healing Done" (Healing Power), which is critical for Era itemization.
- Percent Parsing: Fixed issues where "1% Crit" was being ignored or miscalculated by TBC-era rating scanners.

OPTIMIZATIONS:
- Consolidated Database: Merged ItemSets, Enchants, and Overrides into a single `Database.lua` for faster load times.
- Memory Recycling: Implemented table recycling in the Tooltip engine to prevent garbage collection stutters during raids.
- Stat Consolidation: Tooltips now intelligently group derived stats (e.g., "Health (from Stamina)") to reduce visual clutter.

REMOVED (TBC Clean-up):
- Removed Gem/Socket logic (Jewelcrafting does not exist in Era).
- Removed Resilience/Expertise Rating stats.
- Removed Meta Gem activation requirements.

## v1.9.1
* ** restored the correct UI_Lab file. I should properly delete the old one --( >*_*<)--
------------------------------------------------------------------------------------------------

## v1.9.0 - The "Engine Rebuild" Update
### 🏗️ Major Architecture Overhaul
* **Modular "Two-Brain" System:** Completely rewrote the addon's core logic into a professional modular architecture. The addon now features two distinct engines: a **Leveling Engine** (for growth) and a **Dynamic Engine** (for endgame), managed by a smart "Traffic Controller."
* **Database Consolidation:** All stat weights, pretty names, and enchant data have been moved to a centralized Data Warehouse (`Database.lua`), making the addon faster and easier to update.

### ⚔️ The Leveling Revolution
* **30+ New Profiles:** The addon now understands the nuance of leveling! It no longer treats a Level 25 Mage the same as a Level 59 Mage.
* **Smart Brackets:** Introduced specific weighting for leveling brackets (e.g., *Leveling 21-40* vs *Leveling 41-51*).
* **Pre-BiS Logic:** Added dedicated "Pre-BiS" logic for levels 52-59, helping you start collecting your endgame gear before you even hit 60.

### 🧠 Smarter Scoring & Math
* **"Green Item" Fix:** Implemented a **"Heavy Duty" Text Parser**. The Judge now correctly reads and scores "Random Enchantment" items (e.g., *"...of the Owl"* or *"...of the Eagle"*) that the standard WoW API often returns as empty.
* **Math Breakdown Upgrade:** The Math Window (`/sgj math`) now displays human-readable profile names (e.g., *"Leveling: Affliction (21-40)"*) instead of raw internal codes.
* **Manual Override:** Added a "Manual Mode" to the Minimap menu. You can now force the Judge to use a specific profile (e.g., forcing "Pre-BiS Farming" logic while still Level 58).

### 🛡️ Peacekeeper Module (Conflict Manager)
* **Addon Diplomacy:** Added a dedicated **Conflict Manager**. The Judge now detects active instances of *RestedXP*, *Zygor*, or *Pawn* and offers to auto-disable their conflicting tooltips to keep your interface clean.

### 🔧 Technical Improvements
* **File Consolidation:** Merged `Scoring.lua`, `Enchants.lua`, and `TextParser.lua` into a single, unified `Helpers.lua` master toolbox. This reduces file loads and eliminates "nil value" errors caused by load order.
* **Wand Speed Logic:** Finalized the math for Wands—Speed is now deemed irrelevant for scoring (DPS is king), preventing false positives on "Fast" wands.

------------------------------------------------------------------------------------------------

## v1.8.5
* **New Name-Based Talent Scanner:** Completely replaced the old "index-based" system with a new smart scanner. The addon now detects talents by their English name, making it immune to internal ID shifts caused by Blizzard patches (like the recent Anniversary update).

### 🩸 Smarter Spec Detection
* **Strict Priority Logic:** The engine now correctly distinguishes between specific builds (e.g., Shockadin vs. Holy Raid vs. Deep Holy) based on key talent "anchors" (like Kings, Illumination, or Reckoning).
* **Dungeon Role Protection:** Fixed an issue where generic "Leveling" weights would overwrite your stats even if you were playing a dedicated Tank or Healer spec while below level 60.
* **Live Updates:** The "Auto-Detect" feature now updates instantly when you spend a talent point or open the config window—no more `/reload` required to see changes!

### 🪰 Bug Fixes & Polish
* **UI Display Fixed:** Resolved the issue where the dropdown would display raw codes like `Auto: Holy(Auto)` or `DEEP_PROT`. It now correctly displays user-friendly names like "Auto: Healer: Holy (Illumination)".
* **Naming Mismatch Resolved:** Fixed internal naming errors for Rogues, Warlocks, and Paladins that were preventing the correct stat weights from loading (e.g., `RAID_COMBAT_SWORDS` vs `PVE_COMBAT_SWORDS`).
* **Leveling Brackets:** Re-integrated polished leveling weights (`Leveling_1_20`, `21_40`, etc.) that automatically apply to pure DPS/Hybrid builds while leveling.

### 🧾 For Developers / Debugging
* **Added a new slash command:** `/sgjtalents`
* Prints your current talent tree points and validates which "Key Talents" the addon has successfully detected. Useful for verifying your build.

------------------------------------------------------------------------------------------------

## v1.8.2 - v1.8.3
* **Hotfix:** Small naming issue causing almost unnoticeable silent fail in game.
* **Fix:** `Equip:` stats name ordering. Trying to be "clever" with short patterns caused parser errors because "spells and effects" is a phrase used by both Healing gear and specific Shadow/Fire gear.
* **Context:** The inconsistent wording in Vanilla WoW (sometimes "Shadow damage" and sometimes "damage done by Shadow spells") is a classic parser trap. Parser was misreading "Shadow spells and effects" as generic "Healing Power".

------------------------------------------------------------------------------------------------

## v1.8.1
### 🧾Features & QoL:
* **Smart Spec Detection:** When inspecting a target, the addon now reads their talent tree to automatically detect their spec (e.g., "Holy" vs "Retribution") and applies the correct stat weights immediately.
* **Manual Set Saving:** Added a new "Save" bar to your own Gear Receipt window. You can now type a custom name (e.g., "Fire Res Set") and save a snapshot to your History without using slash commands.
* **Improved Window Titles:** The Receipt window now displays the detected spec next to the player's name (e.g., "Judge: PlayerName (Destruction)").

### 🪰 Bug Fixes:
* **Fixed Infinite Inspection Loop:** Resolved an issue where the Judge window would continuously refresh or flash empty slots due to server latency.
* **Fixed "0.0" Score Bug:** The window now properly waits for item data to be cached before calculating scores, preventing the "Zero Score" error on first inspect.
* **Fixed Lua Crash:** Added safety checks for nil/string values in the talent scanner to prevent crashes when receiving invalid server data.
* **UI Overlap Fix:** Adjusted the footer layout in the Receipt window to prevent the "Score" text from overlapping with the "Combined Stats" list.

------------------------------------------------------------------------------------------------

## v1.8.0 - The "Final Polish" Update
### 🔮 Trinket & Proc Estimator
* **Active Item Support:** The Judge now estimates the value of "On Use" or "Proc" effects!
* **Smart Display:** Scores based on estimates are now marked with a Tilde (**~**) to indicate they are approximations based on average combat uptime.
* **Hybrid Scoring:** Items with both passive stats and active effects (e.g., *Kiss of the Spider*) now display a split score: **"Base Score + ~Bonus Score"**.
* **Database Update:** Added definitions for major active trinkets including *Earthstrike*, *Diamond Flask*, *Jom Gabbar*, *Badge of the Swarmguard*, and more.

### 🗿 Relic & Totem Support
* **Database Update:** Added support for **Idols, Librams, and Totems**!
* **Smart Estimation:** Because relics affect specific spells (which generic scanners can't read), the Judge now assigns them an "Estimated Generic Score" (e.g., *Totem of the Storm* = ~33 Nature Dmg) so they are correctly valued in comparisons.

### 🩸 Dynamic Health Engine
* **Lifegiving Gem:** Now calculates its score based on **30% of your CURRENT Max Health** (15% Buff + 15% Heal), making it scale correctly with your gear level.
* **Lifestone:** Fixed an issue where the scanner ignored the "10 Health per 5 sec" effect. It is now correctly valued as a high-sustain item.

### 🛠️ Critical Fixes
* **History Log Separation:** Transaction History is now saved per **Character - Realm**. Your Alt's leveling snapshots will no longer overwrite or clutter your Main's history.
* **Crash Fix:** Fixed a Lua error where the addon attempted to perform arithmetic on internal flags (`estimate`, `replace`), causing the Receipt window to fail.
* **Database:** Fixed a typo (`MMSC` -> `MSC`) that prevented the Item Overrides database from loading.

------------------------------------------------------------------------------------------------

## v1.7.0 - The "Consultant" Update
### 🕵️ Audit Mode (Inspect)
* Added a **"Judge Target"** button to the Receipt. You can now inspect other players and generate a Gear Receipt for them!
* Automatically applies target-specific stat weights (e.g., inspecting a Rogue applies Rogue weights).

### 📜 Transaction History
* **Level Up Tracking:** The addon now automatically takes a "Snapshot" of your gear score every time you level up.
* **History Window:** Added a log to view your past scores and track your progression.

### 📤 Export & Share
* Added an **"Export"** button. Generates a formatted text string of your gear and score, perfect for pasting into Discord or spreadsheets.

### 🧾 UI Polish
* **Action Bar:** Moved buttons to a new dedicated footer row.
* **Smart Layout:** "Judge Target", "Export", and "Print" are now evenly spaced for a cleaner look.

------------------------------------------------------------------------------------------------

## v1.6.2 - The "Dynamic Engine" Update
### 🧠 Real-Time Stat Engine
* **Hit Cap Awareness:** The addon now monitors your Hit % in real-time. If you reach the hard cap (e.g., 9% for Melee, 16% for Spell), the addon instantly devalues Hit Rating to 0 on tooltips, ensuring you never waste stats.
* **Talent Scaling:** The Judge now reads your specific Talent Tree.
    * **Multipliers:** If you have talents like *Divine Strength* (+10% Str) or *Heart of the Wild* (+20% Int), the score of items with those stats is automatically increased to reflect their true value to *you*.
    * **Talent Hit:** Recognizes talents like *Precision* and *Elemental Precision* when calculating your distance from the Hit Cap.
* **Universal Scaling:** This engine works for **Leveling Profiles** too! A Level 14 Paladin with *Divine Strength* will see accurate, scaled weights just like a Level 60 raider.

## v1.6.1
* **Added: "Smart Capping" logic.**
* The addon now checks your character's current Hit % and Spell Hit % in real-time.

## v1.6.0 - The "Receipt & Reality" Update
### 🌟 New Experimental Feature: The Gear Receipt
* **Character Audit Window:** Added a new UI (`/sgjreceipt`) that displays a categorized list of all your equipped gear and their individual scores.
* **Combined Stat Summary:** The Receipt now mathematically sums up stats from all your gear and displays them in a clean grid.
* **Smart Filtering:** The summary automatically highlights your class's primary stats in **Green** and hides irrelevant stats (e.g., Agility is hidden for Warlocks, Strength is hidden for Mages).
* **Visual Overhaul:** Added class-colored borders, item icons, and zebra-striped rows for better readability.