## v1.8.2
* ** small naming issue causing almost unnoticeable silent fail in game .
------------------------------------------------------------------------------------------------
  
## v1.8.1
### 🧾Features & QoL:
* **Smart Spec Detection: When inspecting a target, the addon now reads their talent tree to automatically detect their spec (e.g., "Holy" vs "Retribution") and applies the correct stat weights immediately.
* **Manual Set Saving: Added a new "Save" bar to your own Gear Receipt window. You can now type a custom name (e.g., "Fire Res Set") and save a snapshot to your History without using slash commands.
* **Improved Window Titles: The Receipt window now displays the detected spec next to the player's name (e.g., "Judge: PlayerName (Destruction)").

### 🪰 Bug Fixes:
* **Fixed Infinite Inspection Loop: Resolved an issue where the Judge window would continuously refresh or flash empty slots due to server latency.
* **Fixed "0.0" Score Bug: The window now properly waits for item data to be cached before calculating scores, preventing the "Zero Score" error on first inspect.
* **Fixed Lua Crash: Added safety checks for nil/string values in the talent scanner to prevent crashes when receiving invalid server data.
* **UI Overlap Fix: Adjusted the footer layout in the Receipt window to prevent the "Score" text from overlapping with the "Combined Stats" list.
------------------------------------------------------------------------------------------------

## v1.8.0 - The "Final Polish" Update
### 🔮 Trinket & Proc Estimator
* **Active Item Support:** The Judge now estimates the value of "On Use" or "Proc" effects!
* **Smart Display:** Scores based on estimates are now marked with a Tilde (**~**) to indicate they are approximations based on average combat uptime.
* **Hybrid Scoring:** Items with both passive stats and active effects (e.g., *Kiss of the Spider*) now display a split score: **"Base Score + ~Bonus Score"**.
* **Database Update:** Added definitions for major active trinkets including *Earthstrike*, *Diamond Flask*, *Jom Gabbar*, *Badge of the Swarmguard*, and more.

### 🗿 Relic & Totem Support
* **Database Update:** Added support for **Idols, Librams, and Totems**!
* **Smart Estimation:** Because relics affect specific spells (which generic scanners can't read), the Judge now assigns them an "Estimated Generic Score" (e.g., *Totem of the Storm* = ~33 Nature Dmg) so they are correctly valued in comparisons.

### 🩸 Dynamic Health Engine
* **Lifegiving Gem:** Now calculates its score based on **30% of your CURRENT Max Health** (15% Buff + 15% Heal), making it scale correctly with your gear level.
* **Lifestone:** Fixed an issue where the scanner ignored the "10 Health per 5 sec" effect. It is now correctly valued as a high-sustain item.

### 🛠️ Critical Fixes
* **History Log Separation:** Transaction History is now saved per **Character - Realm**. Your Alt's leveling snapshots will no longer overwrite or clutter your Main's history.
* **Crash Fix:** Fixed a Lua error where the addon attempted to perform arithmetic on internal flags (`estimate`, `replace`), causing the Receipt window to fail.
* **Database:** Fixed a typo (`MMSC` -> `MSC`) that prevented the Item Overrides database from loading.

------------------------------------------------------------------------------------------------

## v1.7.0 - The "Consultant" Update
### 🕵️ Audit Mode (Inspect)
* Added a **"Judge Target"** button to the Receipt. You can now inspect other players and generate a Gear Receipt for them!
* Automatically applies target-specific stat weights (e.g., inspecting a Rogue applies Rogue weights).

### 📜 Transaction History
* **Level Up Tracking:** The addon now automatically takes a "Snapshot" of your gear score every time you level up.
* **History Window:** Added a log to view your past scores and track your progression.

### 📤 Export & Share
* Added an **"Export"** button. Generates a formatted text string of your gear and score, perfect for pasting into Discord or spreadsheets.

### 🧾 UI Polish
* **Action Bar:** Moved buttons to a new dedicated footer row.
* **Smart Layout:** "Judge Target", "Export", and "Print" are now evenly spaced for a cleaner look.
------------------------------------------------------------------------------------------------


## v1.6.2 - The "Dynamic Engine" Update
### 🧠 Real-Time Stat Engine
* **Hit Cap Awareness:** The addon now monitors your Hit % in real-time. If you reach the hard cap (e.g., 9% for Melee, 16% for Spell), the addon instantly devalues Hit Rating to 0 on tooltips, ensuring you never waste stats.
* **Talent Scaling:** The Judge now reads your specific Talent Tree.
    * **Multipliers:** If you have talents like *Divine Strength* (+10% Str) or *Heart of the Wild* (+20% Int), the score of items with those stats is automatically increased to reflect their true value to *you*.
    * **Talent Hit:** Recognizes talents like *Precision* and *Elemental Precision* when calculating your distance from the Hit Cap.
* **Universal Scaling:** This engine works for **Leveling Profiles** too! A Level 14 Paladin with *Divine Strength* will see accurate, scaled weights just like a Level 60 raider.

## v1.6.1
* **Added: "Smart Capping" logic.
* **The addon now checks your character's current Hit % and Spell Hit % in real-time.

## v1.6.0 - The "Receipt & Reality" Update

### 🌟 New Experimental Feature: The Gear Receipt
* **Character Audit Window:** Added a new UI (`/sgjreceipt`) that displays a categorized list of all your equipped gear and their individual scores.
* **Combined Stat Summary:** The Receipt now mathematically sums up stats from all your gear and displays them in a clean grid.
* **Smart Filtering:** The summary automatically highlights your class's primary stats in **Green** and hides irrelevant stats (e.g., Agility is hidden for Warlocks, Strength is hidden for Mages).

* **Visual Overhaul:** Added class-colored borders, item icons, and zebra-striped rows for better readability.
