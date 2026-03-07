# Sharpie's Gear Judge - Version History

## 🚀 v2.4.11

### 🐛 Minor Fixes
* **Localized various UI strings and meta gem "special" effects by switching literal text to MSC.L lookups in Database.lua and adding the missing localization keys in Localization.lua and deDE/esES/frFR/ptBR locale files.** 
* **Fixed an accidental Warrior:GetWeaponBonus block left inside Classes/TBC/Druid.lua (removed stray code and ensure Druid:GetWeaponBonus returns 0).**
* **Improved tooltip behavior in Interface.lua (use localized text for empty slots and alert lines, tidy tooltip show logic, and adjust trade-skill overlay handling).**
* **Added regex patterns for mana/health-per-5 to deDE.**

------------------------------------------------------------------------------------------------

## 🚀 v2.4.10

* **Add a modifiers table and AddMod helper to collect human-readable sources for rings.**
* **Instrument various class/talent/race branches to call AddMod.**
* **Record expertise/crit/hit/spell/expertise sources and a string note for Druid Survival of the Fittest cap reduction.**
* **Attach collected modifiers to ring objects (mods = modifiers[label]) and render them in the GameTooltip with source and formatted value.**
* **Refactored AddRing logic to explicitly mark and handle rating-based stats (isRating) and special cases (dodge, crit, spell crit, hunter ranged crit).** 
* **Recomputed currentDisplay and capRating for ratings using appropriate API calls or scaled values, and map rating shortfalls back to rating amounts for tooltips.** 
* **Also adjusted skill/cap calculations to include expertBonus and fix capRating computation for non-rating skills.** 
* **Removed earlier global CAP_HIT/EXP adjustments and cleaned up spell power handling.**

------------------------------------------------------------------------------------------------

## 🚀 v2.4.9

### 📺 UI & User Experience
* **Restructured ApplyRingArt to centralize texture selection and styling decisions into a single flow.** 
* **Introduced targetTexture and f.CurrentArt caching to avoid redundant texture resets and animation stutter, only stopping/starting animations when the art actually changes.** 
* **Reset rotation/pulse and applies Spin/Pulse degrees, durations and per-stat vertex colors (including Spell Power, Haste, Spell Hit and Crush Cap) in a clearer branch structure.**
* **Also renamed a local flag from isCustomCap to isSpellPower in GetClassRings and tightens the tooltip condition in UpdateLogic so the "Current Avoidance" line is shown only for rings marked as custom and with label "Crush Cap".**
* **These changes reduce visual glitches and correct when the crush-cap tooltip is displayed.**

### ⚖️ UI, Scoring & Evaluator Logic
* **Added a new equip pattern to capture phrasing like "attack power ... in cat" and map it to feral attack power.**  
* **Introduce an "ALL STATS EXPLODER" in ParseStatLine that detects "+X All Stats", extracts the numeric value, and distributes it into Strength, Agility, Stamina, Intellect and Spirit in the output table (then returns early to avoid double-parsing).** 
	**This ensures "+All Stats" bonuses are represented as the five individual attributes and improves parsing for cat-form attack power variants.** 
* **Compute a custom Spell Power value (max spell bonus across schools) and add a 'Spell Power' ring for casters, marking it as a custom cap/display.** 
* **Also apply melee and spell hit talent bonuses to the Hit Cap and Spell Hit displays.**

### ⚔️ Class Specific Highlights
* **Refactor TBC class scalers to use level-based CombatRatingScalars and percent-based caps with hysteresis.** 
* **Hit, spell-hit, expertise and defense caps are now computed from dynamic rating scalars per level, account for talent/racial percent reductions, and apply hysteresis buffers to avoid weight thrashing.** 
* **Weapon specialization bonuses (GetWeaponBonus) were updated to accept weights and scale racials/talent effects by relevant stat weights (AP/crit/etc.), and Evaluator:GetWeaponSpecBonus now forwards weights.** 
* **Miscellaneous class-specific tweaks align cap thresholds and pivot weights (stamina/armor/block) when caps are reached.**

### Minor Fixes
* **Fixed Expertise in RatingIndexMap and handle class talent bonuses for Paladin/Warrior.** 

------------------------------------------------------------------------------------------------

## 🚀 v2.4.8

* **Added Crush Cap logic for Protection Paladins and Warriors (tiered safe/soft/under cap behavior) and pivot weights toward EHP when safely capped.** 
* **Expose a new "Crush Cap" ring in the stat rings, renamed "Def Cap" -> "Current Defense", improved cap math to use player level-based base defense, account for talents (Druid Survival of the Fittest, Paladin Holy Shield / Warrior Shield Block) and compute display/tooltip appropriately.** 
* **Update ApplyRingArt visuals: texture/color tweaks, allow special coloring for Crush Cap, change energy tint and ring spacings, enable hiding Blizzard countdown numbers on cooldown frames.** 
* **Parser enhancements: strip "Socket Bonus:" prefix so lines like "+4 Strength" are scanned, add dual-stat splitter to parse lines with "and" into two sub-lines, and other small enchant parsing refinements.** 
* **Overall improves tank cap visibility, UI clarity, and item parsing.**

------------------------------------------------------------------------------------------------

## 🚀 v2.4.7 

### Several reliability and parsing fixes:
* **These changes improve robustness around quest reward link detection, reduce tooltip flicker/delay for uncached items, and enhance stat parsing coverage for named and hybrid enchants.**
* **Interface.lua:** 
	**Prevent permanent button lockouts by using a local seenButtons table instead of mutating button.SGJ_Seen; brute-force quest link lookup via GetQuestLogItemLink then fallback to GetQuestItemLink to avoid fragile frame state assumptions; suppress default cooldown text by setting noCooldownCount and noOCC on created cooldown frames.**
* **Judge.lua: BIG THANKS to  BlastTyrant for the fix**
	**Reorder and tighten tooltip evaluation: validate equippable/usable items early, defer evaluation until GetItemInfo is available (using C_Timer.After) to avoid flicker for uncached items, and keep duplicate-score guard.**
	**Sets MSC.IsCalculating only after gatekeepers pass.**
* **Parse.lua:** 
	**Expand stat map with mana/health regen entries.**
	**Added patterns for split enchants, and add an early intercept in ParseStatLine to handle named procs, flat enchants and hybrid/split enchants before numeric parsing.**
### Minor Fixes

* **Add a ListsAreDifferent helper and adjust weapon-set detection so off-hand combining only occurs when actively combining 1H items (avoid forcing dual-list for 2H swaps).** 
* **Move/reuse StableSort and re-sort lists after the weapon logic. Update tooltip display to only show separate item and combined (off-hand) lists when they differ, otherwise present a single concise gains/losses listing and use clearer labels.** 
* **Minor whitespace/newline cleanup.**

------------------------------------------------------------------------------------------------

## 🚀 v2.4.6

* **Register additional quest events and consolidate quest overlay logic into a single MSC.UpdateAllQuestOverlays handler.** 
* **Add short C_Timer delays to ensure item links are populated before evaluation and defer TradeSkill updates similarly.**
* **Replace previous separate UpdateQuestAccept/UpdateQuest/UpdateQuestLog implementations with a unified scanner that aggressively collects quest-related buttons, avoids double-caching, anchors overlay frames to item icons, and sets frame levels to prevent UI clipping.** 
* **Add backward-compatible aliases for the old overlay functions. Improve TradeSkill caching by forcing tooltip population when needed. Refactor tooltip handling to detect relics, adjust healing/damage parsing, run visual beautification earlier, and simplify quest tooltip triggering.** 
* **Expand and reorganize parsing patterns (Parse.lua) to support hybrid heal/damage, resources (MP5/HP5), additional stat phrasings and Era/TBC compatibility.** 
* **Overall changes improve reliability of overlays, reduce false caching, and broaden text parsing coverage.**

------------------------------------------------------------------------------------------------

## 🚀 v2.4.0 - v2.4.5

###🌍 Multi-Language & Localization
* **International Support: Introduced a full localization framework (MSC.L). Added support and placeholders for DE, ES, FR, BR, and RU.**
* **Spanish Refinement: Extensive fixes for esES, translating technical terms like "Capped" to "Límite" and normalizing abbreviations (e.g., "Prom.").**
* **Hardcoded String Removal: Systematically replaced English strings in the ConflictManager, Database, and Class modules with locale keys.**

###🚀 Performance & Caching
* **Aggressive Caching: Added MSC.EvaluationCache to store upgrade results, preventing redundant calculations.**
* **Implemented MSC.UsableCache and MSC.SlotCache to short-circuit item usability and equipment slot checks.**
* **Introduced WeaponBagCache to replace expensive frequent bag scans with event-driven updates.**
* **Event Debouncing: Added a 0.5s debounce to cache wipes for GET_ITEM_INFO_RECEIVED to prevent UI stutter during heavy data loading.**
* **Gating & Filtering: Quest overlays now use GetItemInfoInstant to early-filter non-equippable items before running the heavy scoring engine.**

###🎨 UI Enhancements & Overlays
* **Global Overlays: Added upgrade icons (arrows/indicators) to Merchant, Trade Skill, Quest Log, and Quest Accept frames.**
* **Compatibility: Added hooks for major third-party addons, including TSM (Crafting), ElvUI, Bagnon, and Baganator.**
* **Visual Polish:
	**Added "Compact Equip" and "Simplify Stats" settings to shorten tooltip length.**
	**Introduced "Colorize Stats" to highlight specific attributes within item tooltips.**
	**Added a LibDataBroker (LDB) launcher for compatibility with Titan Panel and similar bars.**

###⚖️ Scoring & Evaluator Logic
* **Relic System Overhaul: Standardized how Idols, Librams, and Totems are parsed. Added GetRelicBonus API to handle dynamic items like the Idol of the Raven Goddess.**
* **Warlock Spec Detection: Deepened endgame spec detection by checking specific talent combinations for more accurate weight scaling.**
* **Pawn Import 2.0: Improved the Pawn string parser to handle negative values and regex-based stat mapping more robustly. Added a UI for assigning a "Base Spec" to imported profiles.**
* **On-Use Detection: Added IsValuableOnUseTrinket to better identify and score offensive cooldown-based items.**

###🐛 Critical Bug Fixes
* **TSM Loop Fix: Removed the C_Timer.After(0) delay in the tooltip path to fix "flickering" and infinite loops caused by TSM's redraw behavior.**
* **Triple Dipping: Fixed a math error where "Chance on Hit" trinkets were triple-counting certain stat contributions.**
* **Weapon Swapping: Corrected a logic error in weapon-set-swap detection by switching from targetSlotID to the more reliable slotId.**
* **Talent Race Condition: Moved custom weight loading to PLAYER_LOGIN to ensure settings are fully available before the first UI draw.**

------------------------------------------------------------------------------------------------

## 🚀 v2.2.8 - v2.3.7

###🛠 Core Engine & Performance
* **Initialization Overhaul: Moved to a "Pending Module" registration system. The addon now uses PLAYER_LOGIN and ForceInit to detect class modules, wiring up profiles only when needed to save memory.**
* **Micro-Optimizations: Extensive localization of Lua and WoW APIs across all files to reduce global lookups.**
* **Memory Management: Implemented database flattening for item sets and automated "garbage collection" of temporary tables after database builds.**
* **Update Throttling: Replaced old OnUpdate logic with a C_Timer based debounce system (RequestUpdate) to handle UI refreshes efficiently during bag/event changes.**

###🔍 Parser & Data Accuracy
* **Parse.lua Overhaul: Expanded TermMap and EquipPatterns to support Era/TBC phrasings (e.g., "spell damage and healing," ranged AP, elemental resistances). Improved right-side tooltip scanning to fix missing weapon speed/damage data.**
* **Item Overrides & Procs: Centralized the ProcDB and AddOverrides tables. Introduced _AUTO_PROC for more accurate valuation of trinkets and procs with detailed internal notes.**
* **Pawn Integration: Added a robust Pawn v1 string parser, allowing users to import external weight scales directly into the addon's DB with an automatic UI reload prompt.**

###⚖️ Evaluator & Mechanics
* **Dynamic Caps: Added talent and racial detection (e.g., Heroic Presence, Survival of the Fittest) to dynamically adjust hit, expertise, and defense caps for the UI rings.**
* **Set Bonus Logic: Rewrote the item set system to use a fast itemID->setID lookup. The evaluator now accurately calculates set bonus gains or breaks when comparing gear.**
* **Stat Refinements: Improved dual-wield/off-hand logic, added meta gem color counting, and fixed cap/delta math for hit and defense checks.**

###📺 UI & User Experience
* **Multi-Spec Tracking: Introduced the ability to track secondary profiles simultaneously, showing upgrade deltas for off-specs in the item tooltips.**
* **Quest Overlays: Added QUEST_COMPLETE handling to visually mark the best upgrade choice among quest rewards.**
* **Tooltip Improvements: Added a "Shift Key Only" toggle, fixed minimap anchoring/draggability, and refined the score breakdown to include proc contributions.**
* **Settings: Transitioned SGJ_Settings to SavedVariablesPerCharacter to allow for unique setups on different alts.**

###⚔️ Class Specific Highlights
* **Warlocks: Added TBC-specific weights, mana regeneration tiebreakers, and PvP spell penetration caps.**
* **Druids: Integrated Dreamstate/Predatory Instincts logic, Feral AP scaling, and expertise cap softening. Added a dynamic "Raven Goddess" idol entry.**
* **Paladins/Priests: Corrected missing spell power weights for leveling/healing and adjusted Retribution priorities.**