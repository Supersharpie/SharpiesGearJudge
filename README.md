Sharpie's Gear Judge (v2.0.0 - TBC Edition)
The Final Verdict on your Gear for WoW: Burning Crusade
Sharpie's Gear Judge takes the guesswork out of loot. It doesn't just look at stats; it Simulates your character. It calculates Set Bonuses, estimates Proc rates, projects Gem combinations, and checks your Talent Tree to render a final verdict: UPGRADE or DOWNGRADE.

🚀 New in v2.0.0: "The Simulator Update"
We have completely replaced the old math engine with a State-Based Simulator. The Judge now understands context:

Set Bonus Awareness: The Judge knows that breaking your 2-Piece Tier 4 bonus might lose you DPS, even if the new item has more raw stats. It calculates the net change of gaining/losing set bonuses in real-time.

Proc Calculation: "Chance on hit" is no longer a mystery. The Judge uses a "Static Stat Equivalent" (SSE) formula to convert procs (like Dragonspine Trophy or Mongoose) into hard score values.

Smart Caching: A new Zero-Lag caching system reads item data once and remembers it, allowing for instant comparisons even with complex tooltips.

TBC Exclusive Features:
💎 Gem Projection: Hover over an empty socketed item? The Judge simulates filling it with the best available gems for your level to show you its true potential score.

🔮 Enchant Simulation: Comparing a clean item vs. your enchanted gear? The Judge can virtually apply your preferred enchant to the new item to make the comparison fair.

Contextual Stats: Full support for Haste, Armor Penetration, Expertise, and Resilience.

🧠 The Dynamic Brain (Endgame)
The Judge thinks like a theorycrafter. It recalculates stat weights in Real-Time:

🚫 Hit Cap Awareness: If you reach the Hit Cap (9% Melee / 16% Spell), the addon instantly detects it and devalues Hit Rating to 0.01 on the next tooltip. No more wasted stats.

⚡ Talent Scaling: The addon reads your Talent Tree. If you have Combat Potency (Rogue) or Divine Strength (Paladin), the addon multiplies the value of relevant stats to reflect their true power.

📉 Diminishing Returns: Automatically adjusts weights as you approach soft caps.

📈 The Leveling Brain (Growth)
The addon evolves with you as you journey to Level 70:

Levels 1-58 (Azeroth): Standard leveling weights prioritizing efficiency and sustain.

Levels 58-69 (Outland): Switches to "TBC Leveling" profiles, prioritizing Stamina and Questing power.

Level 70 (Endgame): Activates the Simulator Engine for Raid/Heroic/Arena optimization.

Dungeon Smart: If you spec Tank or Healer, the addon automatically switches to role-specific weights.

⚖️ Key Features
⚔️ The Verdict Tooltip
Hover over any item to see an instant, intelligent comparison against your equipped gear.

Upgrade/Downgrade: Shows the exact score difference (e.g., *** UPGRADE (+24.5) ***).

Breakdown: Shows exactly why it's better (e.g., +15 Stamina, -10 Intellect, Set Bonus: +40).

Smart Pairing: If comparing a 2-Hander while Dual-Wielding, it simulates removing your Off-Hand to calculate the Net Change.

🧾 The Gear Receipt (Audit)
Type /sgjreceipt (or use the Minimap button) to open your Character Audit.

⚠️ Bag Scanning: Scans your bags for upgrades you might have missed. If a better item is hiding in your bag, a Yellow Alert icon appears.

💸 Tax Collector: Detects missing Enchants or Gems. A Red Alert icon flags missed opportunities.

Export: Generate a text string of your gear and score to paste into Discord.

🧪 The Judge's Lab
A custom visual interface for manual theorycrafting.

Gap Filling: Drag items into the Lab to simulate future loadouts or compare specific pairings (e.g., "Staff X" vs "Main Hand Y + Off Hand Z").

Math Breakdown: Click "MATH MODE" to see the raw data. It breaks down your Talent Multipliers, Hit Cap status, and EP (Equivalence Points) in plain English.

⚙️ Configuration
Projection Mode: Choose how the Judge handles empty sockets (Ignore, Match Color, or Smart Match).

Profile: Auto-detects your spec/level, or Force Manual Mode via the Minimap button (Right-Click).

Minimap Button: Toggle the Lab (Left-Click) or Settings (Right-Click).

🛠 Installation
Delete any old SharpiesGearJudge folder from your AddOns directory (Critical for v2.0!).

Extract the new folder into _classic_\Interface\AddOns\.

Launch WoW Burning Crusade Classic.

🎮 Commands
/sgj or /judge - Open "The Judge's Lab".

/sgj options - Open the Configuration Panel.

/sgj receipt - Open the Gear Audit.

/sgj save <name> - Save a snapshot of your current gear score to history.

Author: Supersharpie Version: 2.0.0 (TBC Edition)