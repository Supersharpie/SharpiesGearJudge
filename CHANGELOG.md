# Changelog
## v2.0.1
* ** fixed broken codes leget left out a single (,)

## 🛡️ TBC Logic & Engine
* **"True Crit" System: Implemented a sliding level-based matrix to accurately calculate % Crit derived from Agility and Intellect for all classes from Level 1–70.
* **Racial Synergy 2.0: Tooltips now detect and display hidden racial bonuses (e.g., Human/Orc Expertise) with a dedicated "Matches Racial" line.
* **Gem Projection System: * Match Colors Mode: Virtually fills sockets to activate Socket Bonuses.
 * **Ignore Colors Mode: Stacks primary stats regardless of color for maximum throughput.
 * **Tier Awareness: Automatically projects Green-quality gems for levelers and Rare-quality gems for Level 70 raiders.
* **Budget Scaling: Suggests cost-effective Classic enchants for leveling and premium TBC enchants for endgame.

## 🎨 UI & Visual Polish
* **Gains & Losses Grouping: Completely redesigned the stat breakdown to visually group Gains (Green) and Losses (Red) for easier decision-making.
* **Active Stat Highlighting: Stats on currently equipped items are now highlighted in Gold to serve as a clear baseline.
* **Compact Tooltips: Merged primary stats and their derived bonuses (e.g., Stamina and Health) into single lines to reduce tooltip height.
* **Clean Baseline: Replaced bulky "Currently Equipped" headers with a subtle (Baseline) indicator.

## 🛠️ Improvements & Fixes
* **Color-Aware Parsing: The engine now checks text color codes to strictly ignore Gray (Inactive) set bonuses while correctly counting Green (Active) ones.
* **Double-Count Prevention: Fixed a critical bug where stats were being counted twice (once by API and once by text scanner).
* **Empty Slot Logic: Comparisons against empty Neck, Ring, and Trinket slots now correctly calculate gains against zero instead of failing.
---------------------------------------------------------------

## v2.0.0 - TBC Edition Release
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
