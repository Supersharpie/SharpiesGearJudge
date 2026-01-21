# Sharpie's Gear Judge - Version History

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

---

## v2.0.0 - The Burning Crusade Launch - IT NEVER WORKED :(
* **Full TBC Conversion:** Updated engine for Patch 2.5.5.
* **New Stats:** Added Resilience, Expertise, Armor Pen, and Spell Haste.
* **Socket Logic:** Added smart gem projection and socket bonus calculations.

## v1.9.0 - The Leveling Update
* **Leveling Profiles:** Introduced distinct stat weights for Level 1-20, 21-40, etc.
* **Green Item Fix:** Improved parsing for random enchantments ("...of the Whale").