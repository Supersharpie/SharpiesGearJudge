# Sharpie's Gear Judge (Classic Era)

**The Final Verdict on your gear.**

Sharpie's Gear Judge is a lightweight, intelligent gear analyzer for World of Warcraft: Classic Era. Unlike heavy addons that require manual simulation, the Judge lives in your tooltip and provides instant, context-aware advice.

## 🚀 Key Features

### 🧠 Smart Leveling Logic
The Judge grows with you.
* **Under Level 60:** It prioritizes **Stamina, Spirit, and Efficiency**. It knows you are questing and need to survive.
* **At Level 60:** It automatically switches to **Raid Weights** (Hit Rating, Crit, Spell Power) to maximize your output.

### 🔮 Project Mode (Enchant Simulation)
Don't be fooled by an unenchanted drop.
* The Judge can "Project" your current enchant onto the new item.
* *Example:* If your current gloves have +7 Agility, the Judge calculates the score of the new gloves *as if they also had +7 Agility*.

### ⚖️ The Verdict UI
Clean, "RatingBuster-style" tooltips.
* Calculates **Derived Stats** (e.g., converts Stamina to Health, Strength to AP) based on your Class.
* Shows clear `(+20)` or `(-5)` differences.
* Filters out useless stats (Rogues won't see Mana; Mages won't see Attack Power).

### 🛡️ Conflict Manager
Plays nice with others.
* Detects **RestedXP**, **Zygor**, and **Pawn**.
* If found, it politely offers to disable *only* their conflicting gear arrows, keeping your leveling guides intact.

### 💍 Smart Slot Comparison
* **Dual Wield:** Automatically finds the best Offhand in your bags to compare 2H vs. 1H+OH.
* **Rings/Trinkets:** Automatically compares new items against your *weakest* equipped slot.

## 🛠️ Commands

* `/sgj` - Open the Judge's Lab (Drag & Drop comparison).
* `/sgj config` - Open the Settings Menu.
* `/sgj debug` - View the exact stat weights currently being applied to your character.

## 📦 Installation

1.  Download the **SharpiesGearJudge** folder.
2.  Place it in `\World of Warcraft\_classic_era_\Interface\AddOns\`.
3.  Log in and check your tooltips!

## ❤️ Credits
Created by **SuperSharpie**.
