# Sharpie's Gear Judge - Changelog

v1.2.0 - v1.3.0
========================================
NEW FEATURES:
- Smart Leveling Logic: The Judge now detects if you are under Level 60. It automatically switches to a "Leveling Profile" (High Stamina/Efficiency) to keep you alive, then switches to "Raid Mode" (Hit Cap/Crit) automatically at max level.
- Naxxramas & ZG Ready: Added support for "Multi-Stat" Enchants, including Sapphiron Shoulder Enchants and ZG Idols in "Project Mode."
- RatingBuster-Style UI: Completely redesigned the tooltip. Stats are now clean, yellow-aligned text with derived stats (Health, Mana, AP) calculated automatically based on your class.
- Smart Ring & Trinket Logic: When hovering over a Ring or Trinket, the Judge now compares it against your WEAKEST equipped slot (instead of always Slot 1).
- Conflict Manager: Detects if RestedXP, Zygor, or Pawn are active. Offers a one-click popup to disable their conflicting "Gear Arrows" without breaking their other features.

FIXES & IMPROVEMENTS:
- Fixed a crash related to the "Smart Partner Finder" (nil value error).
- Updated Interface version to 11508 (Phase 6).
- Added a debug command (/sgj debug) to verify active stat weights.
- Refined Warlock and Mage leveling weights to prioritize survival/uptime.

## [v1.1.9] - 2025-12-16
### 🛡️ Stat Weight Overhaul (Raid, PvP & Leveling)
* **Tanking Logic Update:**
    * **Integrated Tanking:** Warriors and Paladins now have sophisticated Threat/Survival logic built directly into their "Protection" spec profile. No need to toggle a separate mode.
    * **Feral Druids:** Added a dedicated **"Tanking"** mode to the dropdown menu, allowing Druids to manually switch between Cat (DPS) and Bear (Tank) logic.
* **PvP / Solo Mode:** Renamed the "Hybrid" option to **"Leveling / PvP"**. This profile is now tuned to prioritize Stamina (Survival) and Burst Stats (Crit/Agility) for open-world efficiency and battlegrounds.
* **Hit Rating Audit:** Fixed a critical issue where Enhancement Shamans, Hunters, Mages, and Warlocks were missing **Hit Rating** in their default profiles. The addon now correctly values Hit as a top-tier stat for raiding.
* **Healer Tuning:**
    * **Holy Paladin:** Now correctly prioritizes **Crit Rating** (Illumination talent) over MP5.
    * **Priest/Shaman:** Added weight to Crit Rating for Armor Buff procs (Inspiration/Ancestral Healing).

### 🔮 Phase 6 Enchant Support
* **Multi-Stat Support:** Upgraded the enchant database to support complex enchants that add multiple stats at once (e.g., +24 AP and +1% Hit).
* **New Enchants Added:**
    * **Naxxramas (Sapphiron):** Added all Shoulder enchants (Might/Power/Fortitude/Resilience of the Scourge).
    * **Zul'Gurub:** Added all Head/Leg Idols (Falcon's Call, etc.) and Exalted Shoulder enchants.
    * **Dire Maul:** Added Libram enchants (Focus, Rapidity, Protection).

### 🧠 Smart Leveling Logic
* **Auto-Switching:** The addon now intelligently detects if you are leveling (Level 1-59) versus Raiding (Level 60).
    * **Healer Protection:** If you are leveling as a Healing spec (Holy/Resto), the addon automatically forces the **"Leveling / PvP"** profile so you see Spell Damage/Stamina stats instead of useless +Healing.
    * **DPS Survival:** Added Stamina weights to all DPS profiles for sub-60 players to ensure survivability while leveling.
    * **Seamless Transition:** Upon reaching Level 60, the addon automatically switches to the strict "Raid Weights" for your spec.

### 🛠️ UI & Fixes
* **Minimap Button:** Fixed the button to correctly toggle the window **Open/Closed** (previously only opened it).
* **Dropdown Menu:** Updated to reflect the new "Leveling / PvP" and "Tanking" options dynamically based on your class.
* **Smart Partnering:** Improved the "Best Pair" detection to ensure off-hands are correctly suggested for Main Hand weapons.

------------------------------------------------------------------------------------------------

## [v1.1.8] - 2025-12-15
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

### ✨ New Features (v1.1.7+)
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