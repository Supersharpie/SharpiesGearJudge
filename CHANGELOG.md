# Sharpie's Gear Judge - Version History

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