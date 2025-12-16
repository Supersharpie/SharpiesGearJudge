# Sharpie's Gear Judge

**"The Final Verdict on Your Gear."**

**Sharpie's Gear Judge** is a professional-grade theorycrafting and stat comparison tool for World of Warcraft: Classic Era. It goes beyond simple tooltip numbers by analyzing your talent spec, racial bonuses, weapon speeds, and current enchants to tell you if an item is *actually* an upgrade.

## 🚀 New in v1.1.9
* **Smart Leveling Mode:** Automatically detects if you are Level 1-59 and adjusts stat weights for survival and efficiency. (e.g., It stops telling Holy Priests to wear `+Healing` gear while questing and prioritizes Spell Power/Stamina instead).
* **Phase 6 Ready:** Full support for multi-stat enchants from **Naxxramas**, **Zul'Gurub**, and **Dire Maul**.
* **Tanking Overhaul:** Integrated Threat vs. Survival logic for Warriors and Paladins, plus a dedicated "Bear Tank" mode for Druids.

---

## ⚖️ Key Features

### The Verdict Tooltip
Hover over any item to see an instant, intelligent comparison against your equipped gear.

* **Enchant Projection:** Toggle the ability to "virtually" move your current enchant onto new loot to see its true potential power. Now supports complex Phase 6 enchants (e.g., Falcon's Call).
* **Smart Partnering:**
    * **2H vs Dual Wield:** Automatically finds the best "Partner Item" in your bags to give you a fair comparison (e.g., comparing a Staff against your Main Hand + Best Bag Off-Hand).
    * **Context Awareness:** Explicitly tells you who the partner is (e.g., `*** BEST PAIR WITH: [Mallet of the Tides] ***`).
* **Racial Synergy:** Automatically factors in racial weapon specializations (e.g., Humans with Swords/Maces, Orcs with Axes).

### 🧠 Intelligent Logic
* **Auto-Spec Detection:** Detects your talent build to apply accurate stat weights (Holy, Protection, Retribution, etc.).
* **Leveling Awareness:**
    * **Levels 1-59:** Prioritizes Stamina, Spirit, and Burst stats for leveling efficiency.
    * **Level 60:** Automatically switches to strict "Raid Weights" (Hit Caps, Healing Power, Defense).
* **Hybrid Scanning:** Combines the official Game API with a custom Text Parser to catch "Green Text" stats that standard addons miss (e.g., "Equip: Restores 5 mana").

### 🧪 The Judge's Lab (`/sgj`)
A custom visual interface for advanced theorycrafting.

* **Drag & Drop:** Simulate gear sets by dragging items from your bags or loot windows directly into the Lab slots.
* **3-Way Comparison:** Compare a Main Hand + Off Hand pair directly against a Two-Hander.
* **Class Branded:** Features high-quality, class-specific background crests for a premium feel.

---

## ⚙️ Configuration

Type `/sgj options` to open the settings panel.

* **Comparison Mode:**
    * **Strict:** Compares items exactly as they exist (Good for "What do I equip right now?").
    * **Potential:** Simulates your current enchants on the new item (Good for "Is this worth keeping?").
* **Profile Selection:**
    * **Auto-Detect:** The recommended setting. Handles Leveling vs. Raiding automatically.
    * **Leveling / PvP:** Manually forces the Survival/Burst profile.
    * **Tanking:** (Druid Only) Manually forces Bear logic over Cat logic.

---

## 🛠 Installation

1. **Extract** the folder to your WoW Addons directory:
   `_classic_era_\Interface\AddOns\`
2. **Verify Folder Name:** The folder must be named exactly **`SharpiesGearJudge`** (No spaces).
3. **Textures:** Ensure your class `.tga` files are located in `SharpiesGearJudge\Textures\`.

---

## 💬 Commands

* `/sgj` or `/judge` — Open the **Judge's Lab**.
* `/sgj options` — Open the **Verdict Settings**.

---

## Author
**SuperSharpie**