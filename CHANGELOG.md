# Sharpie's Gear Judge (TBC Edition) - Version History

## v2.0.0-TBC - The Burning Crusade Launch
### 🚀 Welcome to Outland
* **Full TBC Conversion:** The entire engine has been updated for Patch 2.4.3 (The Burning Crusade).
* **New Stats:** Added support for **Resilience**, **Expertise**, **Armor Penetration**, **Spell Haste**, and **Socket Bonuses**.
* **Level Cap Increase:** Leveling profiles now extend to Level 70.

### 💎 Gem & Socket Logic
* **Smart Projection:** The addon now automatically calculates the best gems for your sockets.
* **Socket Bonuses:** It intelligently decides whether to match socket colors for the bonus or ignore them for raw stats, depending on which yields a higher score.
* **Meta Gems:** Accounts for Meta Gem stat values in total scores.

### 🔮 Enchant Comparisons
* **Projected Enchants:** Tooltips now show a "Potential Score" that includes the best possible enchant for that item, allowing for fair comparisons between an unenchanted upgrade and your current enchanted gear.
* **Comparison Logic:** Fixed 2H vs Dual Wield comparisons to account for the total value of Main Hand + Off Hand vs Two-Hander.

### 📜 The Receipt 2.0
* **True Scoring:** The Receipt window now uses the full simulation engine. It correctly calculates **Tier Set Bonuses** (T4/T5/T6) and active **Trinket Procs**.
* **Bag Scanner:** A yellow exclamation mark (!) now appears next to slots where you have a better item sitting in your bags. Hovering over it shows the exact score gain (e.g., "+15.2").
* **Missing Enchants:** A red alert icon appears next to items that are missing an enchant.

### 🧠 Engine Updates
* **Dynamic Hit Caps:** Updated Hit Caps for TBC values (142 rating for Melee, 202 for Casters).
* **Talent Recognition:** Added support for all 41-point TBC talents (e.g., *Mangle*, *Circle of Healing*, *Unstable Affliction*) to auto-detect specs.
* **Proc Estimations:** Added PPM data for TBC trinkets like *Dragonspine Trophy* and *Quagmirran's Eye*.

------------------------------------------------------------------------------------------------

## v1.9.1 - Classic ERA
* **Hotfix:** Restored the correct `UI_Lab` file to fix a display error in the Laboratory.

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