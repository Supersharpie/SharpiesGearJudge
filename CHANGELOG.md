# Changelog

## v1.1.0 — The "Total Power" Update
* **New Feature: Enchant Projection:** Added a setting to "virtually" apply current enchants to unequipped loot during comparison.
* **New Feature: Racial Synergy:** The Judge now recognizes and rewards racial weapon specializations (+50 score weight).
* **New Feature: Speed Optimization:** Implemented hidden scoring for weapon speeds (Slow MH/Fast OH) tailored to each melee class.
* **GUI Update:** * Expanded the Options menu to include dual enchant-toggles.
    * Widened the Lab window to 360px for better artwork aspect ratio.
    * Added high-visibility (lowered alpha) cyan borders to item slots.
* **Refactor:** Optimized `Utils.lua` to handle complex multi-stat scanning in a single pass.

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

## v0.9 (Beta)
* Added Bag Scanning logic to automatically pair 1H/OH items during comparison.
* Added "Verdict" logic to tooltips (Green/Red text for upgrades/downgrades).
* Implemented stat weight database for all Classic classes.

## v0.5 (Alpha)
* Initial project setup.
* Basic `GetItemStats` logic.