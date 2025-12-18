# Changelog

## [v2.0.0] - TBC Edition Release
### New Features
* **TBC Stat Engine:** Added support for Haste Rating, Expertise Rating, Armor Penetration, Resilience, and Feral Attack Power.
* **Gem Projection System:**
    * Added logic to virtually fill empty sockets in tooltips.
    * **Match Colors Mode:** Selects gems to activate Socket Bonuses.
    * **Ignore Colors Mode:** Stacks your primary stat regardless of socket color.
    * **Hybrid Gems:** Correctly handles Orange/Purple/Green gems for optimal matching.
* **Enchant Projection System:**
    * Can now simulate "Best in Slot" enchants on new items for fair comparison.
    * Added "Budget Mode" for players under Level 70 (suggests cheap/Classic enchants).
* **Socket Bonus Scanner:** Now detects and includes "Socket Bonus: +Stats" in item scoring.

### Improvements
* **Smart Leveling 1-70:** Updated all class weights to include Outland leveling brackets (58-69).
* **Class Updates:**
    * **Druid:** Added "Feral Attack Power" weapon logic.
    * **Shaman:** Updated Enhancement to prioritize Dual Wield stats after Level 40.
    * **Paladin:** Added spell power scaling for Protection/Retribution.
* **UI Overhaul:**
    * New Dropdown menus for Enchant and Gem logic configuration.
    * Tooltips now display exactly what is being projected (e.g., "(Projecting: 3 Rare Gems + Bonus)").

### Fixes
* Fixed an issue where "Compare Current Enchants" would fail on Legacy/Classic enchants.
* Fixed parsing for "Increases attack power by X" vs "Attack Power +X".