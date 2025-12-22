# Sharpie's Gear Judge (v1.6.2)
# Sharpie's Gear Judge (v1.7.0)
**The Final Verdict on your Gear for WoW Classic Era**

Sharpie's Gear Judge takes the guesswork out of loot. It doesn't just look at one item; it looks at your entire loadout, your class, your spec, **your talents**, and **your exact level** to render a final verdict: **UPGRADE** or **DOWNGRADE**.

## 🌟 New in v1.7.0: The "Gear Consultant" Update
The Judge has graduated from a simple tooltip into a full-service consultant.
* **🕵️ Audit Mode (Inspect):** Target any player and click **"Judge Target"** to generate a full Gear Receipt for them using their class weights.
* **📜 Transaction History:** The addon now automatically takes a **Snapshot** of your score every time you **Level Up**. Track your power growth from Level 1 to 60!
* **📤 Export for Taxes:** Generate a text-based report of your gear and score to paste into Discord, Spreadsheets, or Class Sims.

---

# 🧠 The Dynamic Engine
The Judge thinks like a player. It calculates stat weights in **Real-Time** every time you hover over an item:
* **🚫 Hit Cap Awareness:** If you reach the Hit Cap (e.g., 9% for Melee), the addon instantly detects it and devalues Hit Rating on the next tooltip. No more wasted stats.
* **⚡ Talent Scaling:** The addon reads your Talent Tree. If you have **Divine Strength** (+10% Str) or **Heart of the Wild** (+20% Int), the addon automatically increases the score of items with those stats.
* **📉 Diminishing Returns:** Automatically adjusts weights as you approach caps, ensuring you never "overpay" for a stat you don't need.

# ⚖️ Key Features

### The Verdict Tooltip ⚔️ Context-Aware Scoring
Hover over any item to see an instant, intelligent comparison against your equipped gear.
* **Enchant Projection:** Toggle the ability to "virtually" move your current enchant onto new loot to see its true potential power.
* **Racial Synergy:** Automatically factors in racial weapon specializations (e.g., Humans with Swords/Maces, Orcs with Axes).
* **Speed Optimization:** Values weapon speeds correctly for your class (e.g., favoring slow Main Hands for Warriors and Rogues).
* **Smart Pairing:** If you compare a 2-Hander while dual-wielding, it automatically finds the best combination in your bags to calculate the *net* gain/loss.

### 📈 Dynamic Leveling Matrix
The addon evolves with you as you grow:
* **Levels 1-20:** Scores items based on **Survival & Regeneration**.
* **Levels 21-40:** Shifts focus to **Raw Power & Talents**.
* **Levels 41-59:** Prioritizes **Hit, Crit, & Pre-Raid Stats**.
* **Dungeon Smart:** If you are spec'd as a Tank or Healer, the addon automatically switches to "Dungeon Mode" weights so you can gear for your role, not just for solo questing.

### 🧾 The Gear Receipt
Type `/sgjreceipt` to open your **Character Audit**.
* **⚠️ Return Policy (Bag Scanning):** The Receipt scans your bags. If you have an item in your bag that is better than what you are wearing, a **Yellow Alert** icon will appear to warn you!
* **💸 Tax Collector (Enchant Check):** Detects unenchanted gear. If an item is missing an enchant, a **Red Alert** icon will flag it as a "Missed Opportunity."
* **🖨️ Print Receipt:** Broadcast your Gear Score and "MVP Item" to Party, Raid, or Guild chat with one click.

### 🧪 The Judge's Lab (`/sgj`)
A custom visual interface for advanced theorycrafting.
* **⚔️ 2H vs. Dual Wield Logic:** The Lab automatically handles complex comparisons.
* **🔎 Smart Gap Filling:** Drag items into empty slots to simulate loadouts.
* **📊 Stat Breakdown:** Provides a detailed list of exactly which stats you gain or lose (e.g., +14 Strength, -0.5% Crit).

### ⚙️ Configuration
* **Strict Mode:** Compare items exactly as they drop.
* **Potential Mode:** Compare items as if they were fully enchanted.
* **Profile:** Auto-detects your spec/level, or force specific modes (e.g., "Tank", "PvP") manually.
* **ElvUI Support:** Integrated skinning support.

---

### 🛠 Installation
1.  Extract the `SharpiesGearJudge` folder into your WoW AddOns directory:
    * `_classic_era_\Interface\AddOns\`
2.  Launch WoW Classic.

### 🎮 Commands
* `/sgj` or `/judge` - Open "The Judge's Lab".
* `/sgjreceipt` - Open the Gear Receipt (Audit).
* `/sgj history` - View your Level-Up history log.
* `/sgj options` - Open the Configuration Panel.
* **Minimap Button:**
    * **Left-Click:** Toggle Judge's Lab.
    * **Right-Click:** Open Settings.

### 📝 Credits
* Author: Supersharpie
* Version: 1.7.0