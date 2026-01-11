# Sharpie's Gear Judge (Anniversary Edition)

**"The Final Verdict on your gear."**

Sharpie's Gear Judge (SGJ) is a highly advanced, lightweight gear scoring addon designed for **World of Warcraft: The Burning Crusade (Anniversary / Classic)**. 

Unlike standard "BiS Lists" or heavy simulation addons, SGJ analyzes your **current** talents, level, and race to generate a dynamic "Score" for every item in the game. It tells you exactly what is an upgrade *right now*, removing the guesswork from loot decisions.

## ✨ Key Features

### 🧠 Dynamic "Plugin" Architecture
SGJ uses a modern **Core + Plugin** system. It detects your class on login and loads a specialized mathematical model tailored specifically for you.
* **Covariance:** The addon understands stat synergy. As your Attack Power grows, the value of Crit Rating rises to match it.
* **Cap Guardian:** It knows your Hit, Defense, and Expertise caps. If you are over the cap, it lowers the value of that stat. If you are under, it raises it.
* **Hysteresis:** Includes "Anti-Loop" logic to prevent the addon from telling you to break your caps.

### ⚖️ The Verdict (Tooltip)
Hover over any item to see:
* **Sharpie's Verdict:** A clear `Upgrade` or `Downgrade` message with a precise score difference.
* **Smart Projection:** The score includes the potential value of the **Best Gems** and **Best Enchants** available to you, so you can compare an unenchanted drop against your fully geared main piece fairly.
* **Proc Valuation:** "Use" and "Proc" effects (like *Dragonspine Trophy* or *Bloodlust Brooch*) are mathematically converted into passive stats for accurate scoring.

### 📜 The Ledger (History)
Type `/sgj history` to open your Gear Receipt.
* **Full Breakdown:** See exactly how your score is calculated.
* **Bag Scanner:** A **Yellow Exclamation Mark (!)** appears on slots where you have a better item sitting in your bags.
* **Enchant Alert:** A **Red Alert Icon** warns you if you are missing an enchant or gem.

### ⚔️ Hybrid Class Support
SGJ fully supports complex hybrid mechanics:
* **Druids:** Correctly parses "Feral Attack Power" on weapons.
* **Warriors:** Enforces 2H priority for Arms and DW priority for Fury.
* **Paladins/Shamans:** Scores Relics, Totems, and Librams based on their specific spell bonuses.

## 🛠️ Installation & Usage

1.  Download the latest release.
2.  Extract `SharpiesGearJudge` to your `Interface\AddOns\` folder.
3.  **Login and Play!** No setup required. The Judge automatically detects your spec.

**Commands:**
* `/sgj` - Open the Laboratory (Compare items manually).
* `/sgj config` - Open Settings (Toggle Minimap button, Auto-Sell junk).
* `/sgj history` - Open the Ledger.

## 🤝 Compatibility
* **Conflict Manager:** SGJ automatically detects other tooltip addons (Pawn, Zygor, RXP) and can disable their scoring lines to keep your tooltips clean.
* **TBC Phase 5:** Fully updated for Sunwell Plateau itemization.

## Credits
* **Author:** SuperSharpie
* **Version:** 2.1.0 (TBC)
* **GitHub:** [Supersharpie/SharpiesGearJudge](https://github.com/Supersharpie/SharpiesGearJudge)
* **Feedback:** Found a weight that feels off? Open an issue on GitHub!
* **Discord:** https://discord.gg/yTSX8Us6WE