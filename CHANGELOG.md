# Sharpie's Gear Judge - Version History

## 🚀 v2.3.1 CHANGELOG

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