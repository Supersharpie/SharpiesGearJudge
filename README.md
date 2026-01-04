# Sharpie's Gear Judge (TBC Edition)

**"The Final Verdict on your gear."**

Sharpie's Gear Judge (SGJ) is a lightweight, highly accurate gear scoring addon designed for **The Burning Crusade (Classic)**. It analyzes your stats, talents, and current gear to tell you exactly which item is an upgrade, removing the guesswork from loot decisions.

## Key Features

### 🧠 Dynamic Stat Weights
Unlike other addons that use static lists, SGJ adapts to YOU.
* **Talent Detection:** Automatically switches weights based on your spec (e.g., switching from Feral to Resto Druid).
* **Hit Cap Awareness:** Automatically reduces the value of Hit Rating if you are already at the Hit Cap.
* **Leveling Logic:** Uses different stat priorities for Level 20 vs Level 70.

### ⚖️ The Verdict (Tooltip Integration)
Hover over any item to see:
* **Sharpie's Verdict:** A clear "Upgrade" or "Downgrade" message with a score difference.
* **Projected Score:** Shows you the potential score of an item if you were to add the best gems and enchants.
* **Comparison:** Automatically compares against the correct slot (including 2H vs Dual Wield calculations).

### 🧪 The Laboratory
Want to compare two items that aren't equipped?
* Open the Lab via the Minimap button or `/sgj`.
* **Shift+Click** items from Chat or AtlasLoot directly into the Main Hand / Off Hand slots.
* See instant comparisons between setups (e.g., Staff vs Dagger + Offhand).

### 📜 The Receipt
Type `/sgj history` or click "Show Gear Receipt" in options.
* Shows a full breakdown of your current gear score.
* **Bag Scanner:** Alerts you if you have a better item sitting in your bags (Yellow Exclamation Mark).
* **Enchant Checker:** Alerts you if you are missing enchants (Red Alert Icon).
* **Math Breakdown:** Explains exactly *why* a stat is weighted the way it is.

### ⚔️ Conflict Manager
SGJ plays nice with others. It automatically detects if you are running **RestedXP**, **Zygor**, or **Pawn** and offers to disable their conflicting tooltip lines so your screen stays clean.

## Commands
* `/sgj` or `/judge` - Open the Laboratory.
* `/sgj config` - Open Settings (Profile selection, UI toggles).
* `/sgj history` - Open the History/Receipt frame.
* `/sgj save [Label]` - Snapshot your current gear set to history.

## Installation
1.  Download the latest release.
2.  Extract the `SharpiesGearJudge` folder to `Interface\AddOns\` in your WoW directory.
3.  Launch the game.

## Credits
* **Author:** SuperSharpie
* **Version:** 2.0.0 (TBC)