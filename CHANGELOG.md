## v1.5.1 - Bug Fix
* **Short Names fix for addons that wrap text in tooltips
* **Added fix for FeralAP
* **Updated Toc file
------------------------------------------------------------------------------------------------

## v1.5.0 - The "True Crit" Update
### 🧠 Intelligent Stat Derivation
* **Separated "Equip" vs "Stat" Crit:** The Judge now mathematically distinguishes between hard-coded crit (green text) and crit derived from attributes.
    * **Equip Crit:** Now labeled clearly as **"Equip Crit"** (e.g., from *Eye of Rend*).
    * **Derived Crit:** Now calculated dynamically based on your class and labeled by source, e.g., **"Crit (from Agi)"** or **"Spell Crit (from Int)"**.
* **Level-Based Interpolation:** The addon no longer uses static Level 60 conversion ratios. It now uses a "Sliding Matrix" to determine exactly how much Agility or Intellect you need for 1% Crit at your specific level (e.g., Level 20 vs Level 60).

### 🛠️ UI & Polish
* **Educational Tooltips:** The tooltip now explicitly teaches you *why* an item gives you crit. Instead of just seeing "+1% Crit", you will see:
    * `Stat Crit (from Int) | +0.6%`
* **Standardized Naming:** Updated `MSC.ShortNames` to centralize all stat labels.

### 🛡️ Critical Fixes
* **Crash Fix (`Scoring.lua`):** Fixed a Lua error (`attempt to index field 'StatToCritRatios'`) by adding the missing matrix to `Data_Tables.lua`.
* **Renaming Logic:** Removed the aggressive string replacement in `Core.lua` that was incorrectly labeling all crit as "Crit (from Agi)".
------------------------------------------------------------------------------------------------

## v1.4.0 - The "Smart Leveling" Update
### 🧠 Intelligent Leveling Matrix
* **Phase-Based Scoring:** The addon now recognizes that a Level 10 character needs different stats than a Level 58 character.
	* **Wand Meta Support:** For Warlocks, Priests (Levels 1-40), and Mages (Levels 1-20), the Judge now highly values "Wand DPS" (`Damage Per Second`). It recognizes that wands are your primary source of damage before you unlock efficient spells.   
    * **Lv 1-20 (Survival):** Prioritizes Stamina and raw stats (Str/Int) to help you survive early squishiness.
    * **Lv 21-40 (Power Spike):** Shifts focus to Spec-defining stats (e.g., Agility, Spell Power) as you unlock key talents.
    * **Lv 41-59 (Pre-Raid):** Shifts to "Endgame" weights (Hit Rating, Crit, Spell Damage) to prepare you for Level 60.
* **Dungeon Role Protection:** The Judge now detects if you are explicitly spec'd as a Tank (Protection) or Healer (Holy/Resto). It will **bypass** the generic leveling weights and give you full Dungeon Tank/Healer scores, ensuring you don't accidentally vendor your best tanking gear.

### 🛠️ UI & Polish
* **Lab Modernization:** The Judge's Lab (`/sgj`) now uses the clean, color-coded text style from the tooltips (Yellow Names, Green/Red Numbers).
* **"Resistance0" Fixed:** Fixed a Blizzard API quirk where Armor was sometimes displaying as "Resistance0 Name". It now correctly reads as "Armor".

### 🛡️ Critical Fixes (from v1.3.3)
* **Double-Count Fixed:** Fixed a bug where stats found in the "green text" were being added to the base stats, resulting in double values (e.g., 55 AP instead of 28).
* **MP5 & Weapon Skill:** "Restores X Mana" and "Increased Daggers +5" are now correctly parsed and scored.
* **Classic Weapon Skill:** "Increased [Weapon] +X" stats (Edgemaster's, Racials) are now properly valued as high-tier stats.
------------------------------------------------------------------------------------------------

## v1.3.2 -
* ** Fixed file naming mix up (>.<)
------------------------------------------------------------------------------------------------

## v1.3.1 - Critical Fixes & Logic Hardening
### 🛡️ Critical Bug Fixes
* **"Phantom Stat" Fix (Double-Counting):** Fixed a major bug where the addon would count stats twice (once from the game database + once from reading the green text), causing items to show double their actual values (e.g., 55 AP instead of 28). The math is now verified 100% accurate.
* **MP5 Parsing Fix:** Fixed an issue where "Restores X mana per 5 sec" was being ignored on certain gear (like Grand Marshal weapons), causing Healer scores to be lower than they should be.
* **Lab Crash Fix:** Fixed a Lua error ("arithmetic on boolean") that occurred when dragging items into the Judge's Lab 2-Hander slot.
* **Minimap Toggle:** The minimap button now correctly toggles the window **Open AND Closed** (previously it would only open it).

### 🧠 Logic Hardening
* **Weapon Proficiency Enforcement:** Implemented strict class checks. The addon now knows that Mages cannot use Axes and Rogues cannot use 2H Swords, preventing invalid "Upgrades" from being suggested.
* **"On Use" Exploit Fix:** The calculator now strictly ignores temporary stats from "Use:" and "Chance on hit:" effects, preventing trinkets from showing artificially high scores.
* **Weapon Skill Weights:** Added "Weapon Skill" to the scoring database. Racial bonuses (+5 Skill) now correctly contribute to your item score instead of being worth zero.
* **"Double-Dip" Prevention:** Fixed a logic error in "Potential Mode" where the addon would try to project a virtual enchant onto an item that already had a real enchant.

### 🛠️ UI Restoration
* **Judge's Lab Restored:** The visual Drag-and-Drop window (`/sgj`) is fully functional again with correct background art and comparison logic.
* **ElvUI Compatibility:** Added safe skinning checks to prevent errors for users running ElvUI skins.

------------------------------------------------------------------------------------------------

## v1.3.0
- Smart Leveling Logic: The Judge now detects if you are under Level 60. It automatically switches to a "Leveling Profile" (High Stamina/Efficiency) to keep you alive, then switches to "Raid Mode" (Hit Cap/Crit) automatically at max level.
- Naxxramas & ZG Ready: Added support for "Multi-Stat" Enchants, including Sapphiron Shoulder Enchants and ZG Idols in "Project Mode."
- RatingBuster-Style UI: Completely redesigned the tooltip. Stats are now clean, yellow-aligned text with derived stats (Health, Mana, AP) calculated automatically based on your class.
- Smart Ring & Trinket Logic: When hovering over a Ring or Trinket, the Judge now compares it against your WEAKEST equipped slot (instead of always Slot 1).
- Conflict Manager: Detects if RestedXP, Zygor, or Pawn are active. Offers a one-click popup to disable their conflicting "Gear Arrows" without breaking their other features.
------------------------------------------------------------------------------------------------

## v1.2.0 
### 🛡️ Stat Weight Overhaul (Raid, PvP & Leveling)
* **Tanking Logic Update:** Warriors and Paladins now have sophisticated Threat/Survival logic built directly into their "Protection" spec profile.
* **PvP / Solo Mode:** Renamed "Hybrid" to "Leveling / PvP". Tuned for Stamina (Survival) and Burst.
* **Hit Rating Audit:** Fixed missing Hit Rating weights for Casters and Hunters.
* **Healer Tuning:** Paladins now prioritize Crit (Illumination), Priests/Shamans prioritize Crit (Armor Buffs).

### 🔮 Phase 6 Enchant Support
* **Multi-Stat Support:** Database now handles complex enchants (e.g., ZG Idols, Naxx Shoulder Enchants).
------------------------------------------------------------------------------------------------

## v1.1.8 
### 🧠 Smart Context & Partnering
* **"Gap Filling" Logic:** The addon now intelligently handles comparisons when slots are empty or when cross-comparing weapon types.
    * **2-Hander vs Dual Wield:** If you wield a 2H and hover over a 1H weapon, the addon automatically finds the **Best Available Off-Hand** (Equipped or Bag) to show you the *true* difference.
    * **Empty Slot Filling:** If you are missing an item in a slot (e.g., Off-Hand), the addon will automatically simulate the best item from your bags to prevent "unfair" comparisons against nothing.
* **Context-Aware Tooltips:**
    * **`*** CURRENT BEST ***`**: Now displays when an item in your bag is mathematically superior to what you have equipped.
    * **`*** BEST PAIR WITH: [Item] ***`**: Explicitly tells you which partner item was used to calculate the score (e.g., confirming your new Sword pairs best with your existing Shield).
    * **`*** EQUIPPED WITH: [Item] ***`**: Confirms the partner item for your currently equipped gear.

### 🛡️ Critical Fixes
* **Hybrid Stat Detection:** Implemented a new "Trust but Verify" system.
    * Uses the official Game API for standard stats (Stamina, Int, etc.) to ensure 100% accuracy.
    * Uses a custom **Text Scanner** for Classic Era quirks (Green Text, "Equip:" effects, and "Reversed" stats like `Spell Damage +30`).
* **Enchant Double-Dip Fix:** Fixed a bug where "Project Mode" would accidentally add stats to an item that already had an enchant. It now checks for existing enchants before projecting.
* **Minimap Button:** Fixed the button behavior so it correctly toggles the window **Open/Closed** instead of just opening it.
------------------------------------------------------------------------------------------------

## v1.1.7 - New Features
* **Enchant Projection 2.0:** Replaced the old API scan with a robust **Enchant ID Database** for instant, accurate projection of Classic enchants (+30 Spell Power, Crusader, etc.).
* **New Configuration Panel:** Modern settings menu with radio buttons for "Strict" vs "Potential" modes and manual Spec selection.
------------------------------------------------------------------------------------------------

## v1.1.0 — The "Total Power" Update
* **New Feature: Enchant Projection:** Added a setting to "virtually" apply current enchants to unequipped loot during comparison.
* **New Feature: Racial Synergy:** The Judge now recognizes and rewards racial weapon specializations (+50 score weight).
* **New Feature: Speed Optimization:** Implemented hidden scoring for weapon speeds (Slow MH/Fast OH) tailored to each melee class.
* **GUI Update:** * Expanded the Options menu to include dual enchant-toggles.
    * Widened the Lab window to 360px for better artwork aspect ratio.
    * Added high-visibility (lowered alpha) cyan borders to item slots.
* **Refactor:** Optimized `Utils.lua` to handle complex multi-stat scanning in a single pass.
------------------------------------------------------------------------------------------------

## v1.0.0 - The "Judge" Update (Official Release)
* **Rebrand:** Officially renamed addon to **Sharpie's Gear Judge**.
* **New Feature: The Judge's Lab**
    * Added a visual window (`/sgj`) for comparing weapons.
    * Implemented Drag-and-Drop functionality for item slots.
    * Added visual "Empty Slot" backgrounds and active state borders.
* **Visual Overhaul:**
    * Added dynamic Class Crest backgrounds (loads `Paladin.tga`, `Warrior.tga`, etc. based on player class).
    * Widened the frame to 360px to preserve aspect ratio of background art.
    * Added subtle cyan borders to item slots for better visibility against dark backgrounds.
* **Code Refactor:**
    * Split `UI.lua` into `UI_Menus.lua` and `UI_Lab.lua` for better performance and organization.
    * Moved shared functions to `Utils.lua`.
* **Compatibility:**
    * Fixed a major conflict with **ElvUI** where skinning would delete custom borders.
    * Added a "Safe Skinning" method to support ElvUI users without breaking the addon's look.
------------------------------------------------------------------------------------------------

## v0.9 (Beta)
* Added Bag Scanning logic to automatically pair 1H/OH items during comparison.
* Added "Verdict" logic to tooltips (Green/Red text for upgrades/downgrades).
* Implemented stat weight database for all Classic classes.
------------------------------------------------------------------------------------------------

## v0.5 (Alpha)
* Initial project setup.
* Basic `GetItemStats` logic.