# Sharpie's Gear Judge - Version History

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