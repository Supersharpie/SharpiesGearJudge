# Sharpie's Gear Judge (v1.6.0)

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

### 🧾The Gear Receipt (Experimental)
Type `/sgjreceipt` (or click the button in options) to open your **Character Audit**.
* **Full Loadout Scan:** See a clean, zebra-striped list of every equipped item and its contribution to your power.
* **Combined Stats:** A dynamic summary box that adds up *all* your gear's stats.
* **Smart Filtering:** Automatically hides useless stats (e.g., hides Strength for Mages) and highlights your most important attributes in **Green**.

### 🧪 The Judge's Lab (`/sgj`)
A custom visual interface for advanced theorycrafting.
* **⚔️ 2H vs. Dual Wield Logic: The Lab automatically handles complex comparisons. If you drag a 2-Handed Staff into the slot, it compares it against the combined score of your currently equipped Main Hand + Off Hand.
* **🔎 Smart Gap Filling: If you only drag in a Main Hand weapon (e.g., a Sword) but you are currently dual-wielding, the Judge automatically assumes you will keep your current Off-Hand to give you a fair comparison.
* **📊 Stat Breakdown: Just like the tooltip, the Lab provides a detailed breakdown of exactly which stats you gain or lose in this hypothetical scenario (e.g., +14 Strength, -0.5% Crit).
* **🎨 Class-Themed UI: The window dynamically loads your class crest (Warrior, Paladin, etc.) for a customized look.


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
