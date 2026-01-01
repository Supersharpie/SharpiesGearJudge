# Sharpie's Gear Judge (v1.9.0)
### The Final Verdict on your Gear for WoW Classic Era

**Sharpie's Gear Judge** takes the guesswork out of loot. It doesn't just look at one item; it looks at your entire loadout, your class, your spec, **your talents**, and **your exact level** to render a final verdict: **UPGRADE** or **DOWNGRADE**.

---

## 🌟 New in v1.9.0: "The Engine Rebuild"
We have completely rewritten the core logic from a monolithic script into a professional, modular architecture. The Judge now has **Two Brains**:

1.  **The Leveling Engine:** A dedicated system for character growth. It understands that a Level 25 Mage needs different stats than a Level 59 Mage. It features **30+ new leveling profiles** and specific logic for **Pre-BiS farming** (Levels 52-59).
2.  **The Dynamic Engine:** A high-level traffic controller that takes over at Level 60 (or when you force it). It handles complex End-Game logic, Hit Caps, and Raid-Specific builds.

### Other v1.9.0 Highlights:
* **"Green Item" Fix:** A new **Heavy Duty Text Scanner** now correctly reads and scores "Random Enchantment" items (e.g., *"...of the Owl"* or *"...of the Eagle"*) that the standard WoW API often ignores.
* **Conflict Manager (The Peacekeeper):** The Judge now automatically detects conflicting tooltips from **RestedXP**, **Zygor**, and **Pawn**, offering to auto-disable them to keep your interface clean.
* **Manual Override:** You can now force the Judge to use a specific profile (e.g., force "Pre-BiS Farming" logic while still Level 58) via the Minimap menu.

---

## 🧠 The Dynamic Brain (Endgame)
The Judge thinks like a theorycrafter. It calculates stat weights in **Real-Time** every time you hover over an item:

* **🚫 Hit Cap Awareness:** If you reach the Hit Cap (e.g., 9% for Melee, 16% for Spells), the addon instantly detects it and devalues Hit Rating to **0.01** on the next tooltip. No more wasted stats.
* **⚡ Talent Scaling:** The addon reads your Talent Tree. If you have *Divine Strength* (+10% Str) or *Heart of the Wild* (+20% Int), the addon automatically increases the score of items with those stats to reflect their *true* value to you.
* **📉 Diminishing Returns:** Automatically adjusts weights as you approach caps, ensuring you never "overpay" for a stat you don't need.

## 📈 The Leveling Brain (Growth)
The addon evolves with you as you grow using **Smart Brackets**:

* **Levels 1-20:** Scores items based on Survival & Regeneration (Spirit/Stamina).
* **Levels 21-40:** Shifts focus to Raw Power & Talent scaling.
* **Levels 41-51:** Prioritizes efficiency and kill speed.
* **Levels 52-59 (Pre-BiS Mode):** Automatically switches to "Pre-Raid" weights (Hit/Crit) to help you farm your Level 60 gear before you even ding.
* **Dungeon Smart:** If you are spec'd as a Tank or Healer, the addon automatically switches to "Dungeon Mode" weights so you can gear for your role, not just for solo questing.

---

## ⚖️ Key Features

### ⚔️ The Verdict Tooltip (Context-Aware Scoring)
Hover over any item to see an instant, intelligent comparison against your equipped gear.
* **Enchant Projection:** Toggle "Potential Mode" to virtually apply your current enchant onto new loot to see if it's *actually* an upgrade once fully set up.
* **Active Item Estimator:** Estimates the average combat value of On-Use trinkets (e.g., *Earthstrike*, *Diamond Flask*) and marks them with a Tilde (**~**).
* **Smart Pairing:** If you compare a 2-Hander while dual-wielding, it automatically finds the best combination in your bags to calculate the **net** gain/loss.

### 🧾 The Gear Receipt (Audit)
Type `/sgjreceipt` to open your **Character Audit**.
* **⚠️ Return Policy (Bag Scanning):** The Receipt scans your bags. If you have an item in your bag that is better than what you are wearing, a **Yellow Alert** icon will appear to warn you!
* **💸 Tax Collector (Enchant Check):** Detects unenchanted gear. If an item is missing an enchant, a **Red Alert** icon will flag it as a "Missed Opportunity."
* **Export:** Generate a text string of your gear and score to paste into Discord or spreadsheets.

### 🧪 The Judge's Lab (/sgj)
A custom visual interface for advanced theorycrafting.
* **Gap Filling:** Drag items into empty slots to simulate future loadouts.
* **Math Breakdown:** Click "MATH MODE" to see exactly *why* the Judge gave a score. It breaks down your Talent Multipliers, Hit Cap status, and Profile logic in plain English.

---

## ⚙️ Configuration
* **Strict Mode:** Compare items exactly as they drop.
* **Potential Mode:** Compare items as if they were fully enchanted.
* **Profile:** Auto-detects your spec/level, or **Force Manual Mode** via the Minimap button (Right-Click).
* **Conflict Manager:** Auto-resolves tooltip overlaps with other addons.

## 🛠 Installation
1.  **Delete** any old `SharpiesGearJudge` folder from your AddOns directory (Critical for v1.9.0!).
2.  Extract the new folder into `_classic_era_\Interface\AddOns\`.
3.  Launch WoW Classic.

## 🎮 Commands
* `/sgj` or `/judge` - Open "The Judge's Lab".
* `/sgjreceipt` - Open the Gear Receipt (Audit).
* `/sgj history` - View your Level-Up history log.
* `/sgj options` - Open the Configuration Panel.

**Minimap Button:**
* **Left-Click:** Toggle Judge's Lab.
* **Right-Click:** Open Settings / Manual Override.

---
**Author:** Supersharpie  
**Version:** 1.9.0