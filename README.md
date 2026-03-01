# Sharpie's Gear Judge (Era & TBC Anniversary Edition)

**The Final Verdict on your gear.**

**Sharpie's Gear Judge (SGJ)** is not just a stat calculator—it is a real-time **theorycrafting engine** and UI enhancement built for **World of Warcraft: Classic Era** and the **TBC Anniversary Edition**.

Unlike standard addons that assign static points to items (e.g., "Hit = 10 pts"), SGJ understands **context**. It knows if you are Hit Capped, it knows if equipping that helm will break your Meta Gem requirements, and it can simulate the best possible Gems and Enchants for an item before you even equip it.

## 🔥 What's New in Version 2.4+
* **Universal Upgrade Overlays:** Instantly spot upgrades with visual arrows directly on items in your **Bags, Quest Log, NPC Windows, Merchants, and Crafting Menus**.
* **Lightning-Fast Tooltips:** Rebuilt with a zero-delay synchronous injection engine. Tooltips calculate massive stat breakdowns instantly with no visual stuttering.
* **Third-Party Bag Integration:** Out-of-the-box overlay support for **ElvUI, Bagnon, and Baganator**.
* **Beautiful UI Customization:** New settings to compact standard Blizzard equip text, shorten stat names, and colorize tooltips for maximum readability.

---

## 🚀 Key Features

### 🧠 Dynamic "Cap Guardian" Engine
The Judge watches your stats in real-time.
* **Hit Cap Awareness:** If you are already Hit Capped, the addon dynamically reduces the value of Hit Rating on new items to prevent "fake upgrades."
* **Tank Defense Protocol:** For tanks, it enforces the **490 Defense Cap** (TBC) or **440 Skill** (Era). It applies massive score penalties if swapping an item would drop you below critical immunity thresholds.

### 🔮 Smart Projection (SimC-Lite)
* **Gem Simulator (TBC):** The addon doesn't just read the gems currently in an item. It simulates **Strategy A (Match Socket Colors)** vs. **Strategy B (Pure Stats)** and projects the highest possible score for that item, ensuring you don't trash a powerful off-color drop.
* **Enchant Projector:** Compares items as if they had the best possible enchant for your level and spec.
* **Meta Gem Enforcement:** Automatically detects if a gear swap will deactivate your Meta Gem and adjusts the score accordingly.

### 🔬 The Laboratory Plugin
Stop guessing if breaking your set bonus is worth it.
* **Virtual Paperdoll:** Drag and drop items from chat or your bags into **The Laboratory** to test loadouts without equipping them.
* **2H vs. Dual Wield:** Directly compare a Two-Handed Weapon against a Main Hand + Off-Hand combo side-by-side.

### 🧾 The Gear Receipt
An auditing tool for your character.
* **Bag Scanning:** Checks your inventory for items that score higher than what you currently have equipped.
* **Enchant Police:** Flags any equipped items that are missing enchants.
* **Multi-Spec Tracking:** Track your off-spec weights in the background. Tooltips will notify you if an item is a massive upgrade for your secondary spec.

---

## 💻 Slash Commands

* `/sgj` or `/judge` — Open the **Main Menu**.
* `/sgj config` — Open **Settings** (Gem modes, Enchant modes, UI Visuals).
* `/sgj import` — Open the **Pawn String Import** window.
* `/sgj simple` — Toggles shortened stat names in tooltips.
* `/sgj colors` — Toggles stat colorization in tooltips.

---

## ⚙️ Usage Guide

### 1. Auto-Spec Detection
SGJ automatically detects your class and spec to assign default stat weights (e.g., "Warrior: Fury" or "Mage: Frost").
* *Manual Override:* You can force a specific profile via **Settings** -> **Active Scoring Profile**.

### 2. Tooltip Integration
Simply hover over any item in the world.
* **Judge's Score:** The calculated power of the item.
* **Verdict:** Displays if the item is an **Upgrade** or **Downgrade**, including the % difference.
* **Context:** If an item pushes you over a cap, breaks a set bonus, or requires an off-hand, the tooltip will dynamically warn you.

### 3. Importing Custom Weights
Power user? You can import custom weights from **SimC** or **WowSims**.
1. Copy your Pawn string from the simulator.
2. Type `/sgj import` in-game.
3. Paste the string. The addon will create a new custom profile for you.

---

## 📥 Installation & Compatibility

This addon features a unified codebase that automatically detects your game client:
* **Classic Era (1.15.x):** Full support for Vanilla stat logic (Hit %, Defense Skill, Set Bonuses T0-T3).
* **The Burning Crusade (2.5.x / Anniversary):** Full support for Rating logic, Gems, Meta Gems, and TBC-specific caps.

1. Download the latest release.
2. Extract the `SharpiesGearJudge` folder.
3. Place it in your `_classic_era_/Interface/AddOns` (for Vanilla) or `_classic_/Interface/AddOns` (for TBC) folder.

---

## Credits
* **Author:** SuperSharpie
* **Version:** 2.4.5 (TBC Anniversary Ready)
* **GitHub:** [Supersharpie/SharpiesGearJudge](https://github.com/Supersharpie/SharpiesGearJudge)
* **Discord:** [Join the Theorycrafting Hub](https://discord.gg/yTSX8Us6WE)
* **Feedback:** Found a weight that feels off? Drop by the Discord or open an issue on GitHub!