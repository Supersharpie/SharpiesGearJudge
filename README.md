# Sharpie's Gear Judge (v1.5.3)
**The Final Verdict on your Gear for WoW Classic Era**

Sharpie's Gear Judge takes the guesswork out of loot. It doesn't just look at one item; it looks at your entire loadout, your class, your spec, and **your exact level** to render a final verdict: **UPGRADE** or **DOWNGRADE**.

⚠️ Note on Stat Caps This addon uses Linear Scoring. It prioritizes stat accumulation based on their general value to your spec. It does not currently dynamically adjust values if you reach hard caps (e.g., Hit Cap), so keep an eye on your total stats! 

# ⚖️ Key Features

### The Verdict Tooltip ⚔️ Context-Aware Scoring
Hover over any item to see an instant, intelligent comparison against your equipped gear.
* **Enchant Projection:** Toggle the ability to "virtually" move your current enchant onto new loot to see its true potential power.
* **Racial Synergy:** Automatically factors in racial weapon specializations (e.g., Humans with Swords/Maces, Orcs with Axes).
* **Speed Optimization:** Values weapon speeds correctly for your class (e.g., favoring slow Main Hands for Warriors and Rogues).
* **Smart Pairing:** If you compare a 2-Hander while dual-wielding, it automatically finds the best combination in your bags to calculate the *net* gain/loss.
* **Weapon Proficiency:** Knows your class! Won't tell a Priest to equip a Sword.

### 🧠 Dynamic Leveling Matrix
The addon evolves with you as you grow:
* **Levels 1-20:** Scores items based on **Survival & Regeneration**.
* **Levels 21-40:** Shifts focus to **Raw Power & Talents**.
* **Levels 41-59:** Prioritizes **Hit, Crit, & Pre-Raid Stats**.
* **Dungeon Smart:** If you are spec'd as a Tank or Healer, the addon automatically switches to "Dungeon Mode" weights so you can gear for your role, not just for solo questing.
* **Auto-Spec Detection:** Detects your talent build to apply accurate stat weights (Holy, Protection, Retribution, etc.).

### ⚖️ The Judge's Lab
* Type `/sgj` to open the visual Drag-and-Drop laboratory.
* Test hypothetical loadouts by dragging items from the shop, dungeon journal, or other players into the slots to compare against your current gear.

### 🧪 The Judge's Lab (`/sgj`)
A custom visual interface for advanced theorycrafting.

* **Drag & Drop:** Simulate gear sets by dragging items from your bags or loot windows directly into the Lab slots.
* **3-Way Comparison:** Compare a Main Hand + Off Hand pair directly against a Two-Hander.


### ⚙️ Configuration
* **Strict Mode:** Compare items exactly as they drop.
* **Potential Mode:** Compare items as if they were fully enchanted.
* **Profile:** Auto-detects your spec/level, or force specific modes (e.g., "Tank", "PvP") manually via the settings menu.
* **ElvUI Support:** Integrated skinning support that matches your UI while preserving custom high-visibility slot borders.

### ⚡ Lightning Fast UI
* **Clean, colored text aligned for easy information.
* **Derived Stats:** Shows the *real* value of stats (e.g., converts "10 Intellect" into "150 Mana + 0.16% Crit").
* **Conflict Manager:** Automatically detects other addons (RestedXP, Pawn, Zygor) and offers to disable their conflicting tooltips.
* **Class Branded:** Features high-quality, class-specific background crests for a premium feel.

### 🛠 Installation
1.  Extract the `SharpiesGearJudge` folder into your WoW AddOns directory:
    * `_classic_era_\Interface\AddOns\`
2.  Launch WoW Classic.

### 🎮 Commands
* `/sgj` or `/judge` - Open "The Judge's Lab" (Visual Comparison).
* `/sgj options` - Open the Configuration Panel.
* **Minimap Button:**
    * **Left-Click:** Toggle Judge's Lab.
    * **Right-Click:** Open Settings.

### 📝 Credits
* Author: SuperSharpie
* Version: 1.5.2