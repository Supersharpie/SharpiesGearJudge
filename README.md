# Sharpie's Gear Judge (Era & TBC Edition)

🚀 New Plugins Now Available!
Expand your gear judging capabilities with our two newest plugins, designed to help you plan your progression and master your theorycrafting.

###📍 [Roadmap Plugin]
Take the guesswork out of your gear progression.
* **Upgrade Leaderboard: Automatically generates a prioritized list of dungeons based on which ones offer the most significant upgrades for your current set.
* **Chain Mode: Simulate entire gear acquisition paths to see how your stats evolve as you pick up pieces over time.
* **Progression Planning: Perfect for mapping out your journey through TBC Anniversary content.

###🧪 [Laboratory Plugin (The Lab)]
The ultimate sandbox for theorycrafters.
* **Dual-Set Comparator: Side-by-side gear comparison to see exactly how different setups impact your performance.
* **Easy Importing: Seamlessly import builds from SeventyUpgrades, SimC, and other popular formats.
* **Theorycrafting Suite: Test "what-if" scenarios without needing to commit to gems or enchants in-game first.

**The Final Verdict on your gear.**

**Sharpie's Gear Judge (SGJ)** is not just a stat calculator—it is a real-time **theorycrafting engine** built for **World of Warcraft: Classic Era** and **The Burning Crusade**.

Unlike standard addons that assign static points to items (e.g., "Hit = 10 pts"), SGJ understands **context**. It knows if you are Hit Capped, it knows if equipping that helm will break your Meta Gem requirements, and it can simulate the best possible Gems and Enchants for an item before you even equip it.

## 🚀 Key Features

### 🧠 Dynamic "Cap Guardian" Engine
The Judge watches your stats in real-time.
* **Hit Cap Awareness:** If you are already Hit Capped, the addon dynamically reduces the value of Hit Rating on new items to prevent "fake upgrades."
* **Tank Defense Protocol:** For tanks, it enforces the **490 Defense Cap** (TBC) or **440 Skill** (Era). It applies massive score penalties if swapping an item would drop you below critical immunity thresholds.

### 🔬 The Laboratory
Stop guessing if breaking your set bonus is worth it.
* **Virtual Paperdoll:** Drag and drop items from chat or your bags into **The Laboratory** to test loadouts without equipping them.
* **2H vs. Dual Wield:** Directly compare a Two-Handed Weapon against a Main Hand + Off-Hand combo side-by-side.

### 🔮 Smart Projection (SimC-Lite)
* **Gem Simulator (TBC):** The addon doesn't just read the gems currently in an item. It simulates **Strategy A (Match Socket Colors)** vs. **Strategy B (Pure Stats)** and projects the highest possible score for that item, ensuring you don't trash a powerful off-color item.
* **Enchant Projector:** Compares items as if they had the best possible enchant for your level and spec.

### 🧾 The Gear Receipt
An auditing tool for your character.
* **Bag Scanning:** Checks your inventory for items that score higher than what you currently have equipped.
* **Enchant Police:** Flags any equipped items that are missing enchants.
* **PVP Tax:** Identifies items with "wasted" PvP stats (Resilience) when you are using a PvE profile.

### ⚖️ Transparent Math
* **No Black Boxes:** The **"Stat Logic"** window breaks down exactly how your score was calculated (e.g., *"20 Agility = 0.8% Crit = 15.2 Points"*).
* **Meta Gem Enforcement:** Automatically detects if a gear swap will deactivate your Meta Gem and adjusts the score accordingly.

---

## 🎮 Supported Versions

This addon features a unified codebase that automatically detects your game client:

* **Classic Era (1.15.x):** Full support for Vanilla stat logic (Hit %, Defense Skill, Set Bonuses T0-T3).
* **Burning Crusade Classic (2.5.x):** Full support for Rating logic, Gems, Meta Gems, and TBC-specific caps.

---

## 💻 Slash Commands

* `/sgj` or `/judge` — Open the **Main Menu**.
* `/sgj config` — Open **Settings** (Gem modes, Enchant modes, Minimap toggle).
* `/sgj import` — Open the **Pawn String Import** window.

---

## ⚙️ Usage Guide

### 1. Auto-Spec Detection
SGJ automatically detects your class and spec to assign default stat weights (e.g., "Warrior: Fury" or "Mage: Frost").
* *Manual Override:* You can force a specific profile via **Settings** -> **Scoring Profile**.

### 2. Tooltip Integration
Simply hover over any item.
* **Judge's Score:** The calculated power of the item.
* **Verdict:** Displays if the item is an **Upgrade** or **Downgrade**, including the % difference.
* **Context:** If an item pushes you over a cap (e.g., Hit Cap), the tooltip will tag it: `(Cap 0.5% Over)`.

### 3. Importing Custom Weights
Power user? You can import custom weights from **SimC** or **WowSims**.
1. Copy your Pawn string from the simulator.
2. Type `/sgj import` in-game.
3. Paste the string. The addon will create a new `[Import]` profile for you.

---

## 📥 Installation

1. Download the latest release.
2. Extract the `SharpiesGearJudge` folder.
3. Place it in your `World of Warcraft/_classic_era_/Interface/AddOns` (for Vanilla) or `_classic_/Interface/AddOns` (for TBC) folder.

---

## Credits
* **Author:** SuperSharpie
* **Version:** 2.1.1 (TBC)
* **GitHub:** [Supersharpie/SharpiesGearJudge](https://github.com/Supersharpie/SharpiesGearJudge)
* **Feedback:** Found a weight that feels off? Open an issue on GitHub!
* **Discord:** https://discord.gg/yTSX8Us6WEEnough
