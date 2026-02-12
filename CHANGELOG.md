# Sharpie's Gear Judge - Version History

## 🚀 v2.3.6

### CLASS SPECIFIC UPDATES: Warlocks
* **Stat weights across specs and leveling brackets.** 
	*Changes include adding mana regeneration as a tiebreaker, increasing generic Spell Power in many bracket
	*Refining Shadow/Fire priorities, adding Spell Penetration for PvP, and various stamina/intellect/haste/crit/hit tweaks to better reflect TBC priorities. 

### Key changes:
* **Fixed a missing newline/end in Helpers.lua and add commented debug Tooltip ID helpers.** 
* **Add robust Pawn import parsing and UI reload prompt, improve stat parsing, and harden scanner usage.** 
* **Bind string.sub, add PawnString to parse Pawn v1 strings into internal weight tables, update ImportAndSavePawnString to use the parser, save weights to DB/current session and show a reload popup.** 
* **Added StaticPopupDialogs entry for SGJ_RELOAD_REQUIRED to prompt ReloadUI after import.** 
* **Refined stat pattern regexes (prefix/suffix, ranges), improve cleaning (remove color tags, textures, non‑breaking spaces, normalize whitespace), accumulate fixed stats and better name cleanup.** 

------------------------------------------------------------------------------------------------

## 🚀 v2.3.5

### Multiple files updated to improve speed, robustness and memory usage:
* **Rework item override storage and proc handling, centralizing overrides and introducing a _AUTO_PROC format (plus notes).**
* **Improve evaluator logic: stricter off-hand dual-wield checks by class/level, correct cap/defense delta math, build context messages instead of mutating stats, and change EvaluateUpgrade's return signature to include contextMsg.** 
* **UI/tooltip updates: fix minimap anchoring, include _AUTO_PROC contributions in the score breakdown, and refactor Judge tooltip flow to use the new override/proc structure and evaluation behavior.** 
	*These changes centralize trinket/proc data, improve accuracy of upgrade math, and produce clearer tooltip context.*
* **Refactor projections and tooltip handling, add update throttling, and adjust EvaluateUpgrade returns.**
	*These changes aim to provide cleaner data for tooltips, avoid flicker/race conditions when item info arrives, and ensure projections/meta/gem displays are robust and correctly formatted.
* **Interface: reorganize Interface Options, add a "Show Only via Shift Key" (ShiftOnlyTooltip) toggle and hook to enable/disable it alongside tooltip display.**
* **add recursion/setting checks and a small throttle to avoid redundant recalculations, and respect the new ShiftOnlyTooltip and HideTooltips settings.**
* **add additional stat text mappings (e.g. "spell damage and healing", ranged attack power, spell penetration, all stats, magic resistance) to improve parsing of uncommon suffixes and variations.**
* **Data_Sets.lua: Initialize MSC.ItemSetMap in BuildDatabase and free MSC.SetDefinitions after database build to reduce memory.**
* **Dynamic_Engine.lua: Use addonName var, expose _G.MSC, and localize frequently used globals (API functions) for performance; cleaned comments and ensured existing dynamic/spec logic remains intact.**
* **Evaluator.lua: Localized common functions and WoW APIs, added string_find/local format aliases, fixed string usage in spec detection and formatting to avoid nil/crash paths.**
* **Helpers.lua: Large localization of Lua/WoW APIs (string/table/math functions), safe handling when MSC.Scanner is nil, switched string.match/call sites to localized string_match, replaced table.insert/math.* 
* **calls with localized variants, and other safety/consistency fixes (GetContainer wrapper, gem/enchant parsing, stat name cleaning).**
* **Interface.lua: Localized APIs and helpers, replaced global calls with locals, optimized bag scanning to only run when MSC.BagCacheDirty, adjusted UI text/format calls to use localized string_format, and multiple small UI/ring rendering fixes.**
* **Overall this changeset focuses on micro-optimizations (localizing functions), defensive checks to prevent crashes when subsystems are missing, and minor logic/formatting fixes.**
* **No functional algorithm changes beyond safety/efficiency improvements.**

------------------------------------------------------------------------------------------------

## 🚀 v2.3.4

### CLASS SPECIFIC UPDATES:
* **Replaced occurrences of ITEM_MOD_HEALING_POWER_SHORT with ITEM_MOD_SPELL_HEALING_DONE_SHORT across class weight/config files and relic definitions.** 
* **(ERA and TBC files: Druid, Paladin, Priest, Shaman, Hunter, Mage, Warlock, Warrior).**
* **Updated related Leveling/Bracket entries and relic/item stat maps to use the new stat token.** 
* **This is a token/terminology rename to align with the newer stat key and avoid scoring mismatches.**

### Key changes:
**Rename and centralize item set definitions and add a fast itemID->setID builder; improve set bonus calculation, talent/cache handling, and upgrade evaluation.**
* **Data_Sets.lua: renamed MSC.ItemSetMap -> MSC.SetDefinitions and added MSC:BuildDatabase() to flatten SetDefinitions into an itemID->setID lookup (MSC.ItemSetMap).**
* **Database.lua: removed the older BuildDatabase implementation in favor of the centralized builder in Data_Sets.lua.**
* **Dynamic_Engine.lua: cleaned set bonus calculator, ensure UpdateSetBonusScores runs after weights load, and improved recalc behavior.**
* **Evaluator.lua: improved meta gem color counting, switched to flat itemID->setID lookups, surfaced set counts from GetTotalCharacterScore, applied set bonus stats/score correctly,**
	*and added logic to subtract inactive meta gem value; beefed up main/offhand usability and dual-wield rules; added detection for set completion/breaking during EvaluateUpgrade; fixed cap/delta math for hit/defense checks.
* **Helpers.lua: added ImportAndSavePawnString to parse and persist Pawn strings into SavedVariables and load them into the active weight DB; refined scoring logic for off-hand DPS/speed and bouncer/resilience logic;
	*simplified GetItemSetID to attempt GetItemInfo first and fallback to tooltip scanning for set name.**
* **Interface.lua: UI/Settings tweaks, load/save for custom Pawn weights, import UI wired to new import helper, initialization on ADDON_LOADED to inject saved custom weights, and assorted tooltip/skin/positioning refinements.**
* **Judge.lua: tooltip upgrade output now reports set bonus gains/breaks for main- and off-spec checks and includes set count diffs when evaluating upgrades.**
* **Parse.lua: improved scanner classification (set lines, procs, sockets, equip lines) and item object metadata.

### Why: unify set data source, provide a fast lookup for set membership, make set bonus scoring reactive to weight changes, and improve correctness and UX when presenting upgrade/set impacts across specs. Saved custom Pawn profiles are now persisted and shown in the settings UI.

------------------------------------------------------------------------------------------------

## 🚀 v2.3.3

### 🐛 Bug Fixes - Pushing to fix AP, SP and Healing power

------------------------------------------------------------------------------------------------
## 🚀 v2.3.2

###💎 Gem 
* **Reorganize Database.lua gem definitions into phase-specific groups and move several gem entries into appropriate phase buckets.**
* **Fix multiple leveling gem IDs, adjust EMPTY_SOCKET_META to use the phase meta set, add a nil-guard to AddTo(), and update how gem option lists are populated.** 
* **Overall these changes prepare the gem database for phased content and correct several ID/stat mappings.**
* **Also update prismatic/meta population logic and make a small change to primary stat scalars at the end of the file.**

### CLASS SPECIFIC UPDATES: Druids
* **Adjust Druid stat weights and leveling brackets, add new talent support and scaling logic.** 
	*Key changes: tweak primary weights (haste, crit, agility, stamina, etc.) and add small "poison protection" fallbacks for hybrid gear; 
	*bump DPS/regen/hp5 for leveling and rebalance Feral (Cat/Bear) priorities including more Strength and Feral AP for early leveling; buff caster Spirit/MP5 and tweak Boomkin MP5 scaling.
* **Added Dreamstate (Int -> MP5) and Predatory Instincts (crit damage scaling), a mana-safety penalty for spell haste when max mana is low, and an expertise cap softening for Feral.** 
* **Update Relics to include a dynamic Raven Goddess idol entry listing all relevant stats.**

### 🐛 Bug Fixes
* **Adjust DAMAGE parsing to respect pat.valIdx when choosing which capture (m1 or m2) contains the actual damage value, and only compute an average when the pattern indicates a range.** 
* **This handles cases like "Blasts X for Y" where the second capture is the real value. Adds a brief comment and minor whitespace cleanup.**
* **Update both TBC.toc and Vanilla.toc to move SGJ_Settings from the global SavedVariables list to SavedVariablesPerCharacter, while keeping SGJ_History as a global SavedVariable.**
* **This ensures user settings are stored per-character instead of shared across characters.**
* **On ADDON_LOADED, set MSC.ManualSpec from SGJ_Settings.Mode so the engine reflects the saved Mode (AUTO/MANUAL).**
* **Rework Scanner pattern tables to be more robust**

------------------------------------------------------------------------------------------------


## 🚀 v2.3.0

###✨ New Feature Multi-Spec Tracking
* **Enhance settings UI and add multi-spec tracking.**
	*Added dropdown/checkbox tooltip handling, organize left/right columns, and build a scrollable list of secondary profiles for tracking. 
* **Initialize display positive upgrade deltas for tracked off-specs in item tooltips. **

### 🐛 Bug Fixes
* **Warlock: Add spell penetration and Malediction handling and caps. Also implemented PVP spell penetration cap/hysteresis and minor formatting fixes.**
* **Parse: Improve stat/equip parsing and TBC percent handling.** 
* **Adjusts BaseStat/Term maps (adds mapping for "magical resistances" -> spell penetration)**
* **Relaxed and extends stat/equip patterns (unanchors DPS/speed/range, handles era "up to" spell power/healing, "decreases" patterns)** 
* **Adds TBC percent-to-rating conversion logic for common stats and normalizes several phrase variants to improve detection of stats and procs.**

------------------------------------------------------------------------------------------------

## 🚀 v2.2.12 CHANGELOG

* **Add a safety check to ensure SGJ_Settings.MinimapPos is a table before using it to SetPoint.** 
* **If the saved data is invalid, clear the setting, reset the minimap to a sane default (CENTER on Minimap at -60,-60) and clear anchors first.**
* **Keeps existing UpdateMinimapPosition() behavior.**
* **This prevents errors from malformed saved coordinates and preserves valid saved positions.**

------------------------------------------------------------------------------------------------

## 🚀 v2.2.11

* ** Added talent detection and apply talent-based hit bonuses to melee/spell hit caps  and racial/weapon effects to hit, expertise, crit and defense caps used for UI rings.**
	*(including TBC-specific talents like Draenei Heroic Presence and Druid Survival of the Fittest), and performs a weapon/ranged check to grant racial expertise/crit where appropriate.
* ** Introduces GetTalentRank helper, computes meleeHitBonus and spellHitBonus for Mage, Warlock, Priest, Shaman, Druid, Rogue, Hunter, Paladin.**
* ** Handles TBC-specific talent differences, clamps caps to non-negative values, and then uses the adjusted caps when building rings.**
* ** Also adds smart expertise visibility logic, minor ring formatting cleanup.**

------------------------------------------------------------------------------------------------

## 🚀 v2.2.10

* ** Add spell power to Priest leveling/healer weights (ERA & TBC) and tidy formatting. (No idea how I could have forgot this >.<)**
* ** Overhaul minimap button: make it movable, draggable, save/restore position on login, ensure proper frame level. **
* ** Major enhancements to expand BaseStatMap and TermMap, add many green/white-text and TBC-era phrases, improve pattern databases, add functional pattern support. **
* ** Misc: minor parsing fixes and improved pattern priority/robustness for parsing item tooltips.**

------------------------------------------------------------------------------------------------

## 🚀 v2.2.9

###✨ Item Database
* **Rework proc and item data and add class-specific lookup.**
	* Classes/TBC/Druid.lua: remove manual Wolfshead Helm entry from Druid.Relics (wrong location) and update Idol of Terror to provide an Agility estimate with note.
	* Data_Sets.lua: reorganize and centralize ProcDB, add/clean many Classic & TBC proc entries (with notes, corrections and phase grouping), and merge TBC procs into the main ProcDB.
	* Database.lua: add and adjust several ItemOverrides (including reintroducing the Wolfshead override with notes), correct/replace various estimated stats (e.g. 30665 -> spirit estimate), remove duplicated entries, and tidy Darkmoon card and other trinket notes.
	* Helpers.lua: change GetRawItemStats lookup order to apply class-specific overrides (Relics/Totems/Idols/ItemOverrides) first and sum numeric stat values into finalStats before falling back to global Proc/Weapon/Trinket DBs.
* **These changes consolidate proc/item data, fix several stat and ID corrections, and ensure class-specific relics and item overrides are applied reliably when computing item stats.**

------------------------------------------------------------------------------------------------	

## 🚀 v2.2.8

### 🐛 Bug Fixes
	* Fixed Parser it was not scanning right side of tooltip missing weapon speed and causeing speed and weapon damages to fail calculations 
	* Paladin Ret stat weights adjusted
	* Add a few more On Chance items to database