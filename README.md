# Sharpie's Gear Judge (Classic Era, TBC Anniversary & WoW Forever)

**The Final Verdict on your gear.**

**Sharpie's Gear Judge (SGJ)** is a real-time **theorycrafting engine** and UI enhancement for **World of Warcraft: Classic Era**, the **TBC Anniversary Edition**, and **WoW: Forever**.

Unlike addons that give items static points (e.g. "Hit = 10 pts"), SGJ understands **context**. It knows if you are hit-capped, if a helm swap will break your Meta Gem, whether a quest reward beats what you're wearing, and in TBC it can **project** the best gems and enchants for an item before you equip it.

---

## 🗺️ WoW Forever Build Progress

We're re-measuring every leveling build and its stat weights on **real leveling gear** (quest rewards and dungeon gear, picked from the current items) in place of an older gear estimate. One class at a time; each part ships as soon as it's done.

| Class | Solo leveling | Dungeon leveling | PvP leveling | Raid (60) |
|---|---|---|---|---|
| Warrior | ✅ Done (3.4.1) | ✅ Done (3.4.4) | ✅ Done (3.4.7) | ⏸️ Waiting |
| Rogue | ✅ Done (3.4.1) | ✅ Done (3.4.4) | ⏳ Planned | ⏸️ Waiting |
| Hunter | ✅ Done (3.4.1) | ✅ Done (3.4.4) | ⏳ Planned | ⏸️ Waiting |
| Paladin | ✅ Done (3.4.2) | ✅ Done (3.4.4) | ✅ Done (3.4.5) | ⏸️ Waiting |
| Mage | ✅ Done (3.4.2) | ✅ Done (3.4.4) | ✅ Done (3.6.0) | ⏸️ Waiting |
| Warlock | ✅ Done (3.4.3) | ✅ Done (3.4.4) | ✅ Done (3.6.0) | ⏸️ Waiting |
| Priest | ✅ Done (3.4.3) | ✅ Done (3.4.4) | ✅ Done (3.4.7) | ⏸️ Waiting |
| Shaman | ✅ Done (3.4.3) | ✅ Done (3.4.4) | ⏳ Planned | ⏸️ Waiting |
| Druid | ✅ Done (3.4.2) | ✅ Done (3.4.4) | ✅ Done (3.5.0) | ⏸️ Waiting |

✅ done on real leveling gear · 🔄 in progress · ⏳ planned · ⏸️ waiting for level-60 gear and raid data. Builds not done yet still work: they use the earlier gear estimate.

## 🔥 What's New

> Covers Gear Judge and its plugins (Talents, Roster, Roadmap, Laboratory, XP). Plugin changes start with the plugin's name, and each heading lists the plugin versions released with it.
>
> **WoW Forever players:** Blizzard is still changing classes with hotfixes and patches, so builds, talent orders and weights change often too. Each update brings them in line with the latest changes, and some can be a step behind for a few days after a patch.

### 3.6.0 (Talents 1.4.2)

- **Spell Impact tab (new, WoW Forever):** Spell Impact has its own tab in the Gear Judge window (`/sgj spells`, or Spell Impact Options under Tooltip Visuals). It lists every main spell you know with your current gear (per cast, per second, per mana), compares any item you drag in, shift-click or hover, and holds the options: which rows to show, how many tooltip rows, target level (your level up to a boss), the most mana-efficient heal rank for downranking, extra targets for chain and area spells, and spell rank on or off.
- **Talents, Mage PvP leveling:** judged by total leveling time, questing plus world fights. Frost, Arcane and Fire quest single target and are 5-8% faster; new Frost and Arcane AoE PvP builds for players who pull packs.
- **Talents, Arcane: AoE Leveling:** a faster talent order (about 6%).
- **Mage PvP weights:** follow the solo weights again; the AoE PvP builds use the AoE weights.
- **Talents, Warlock PvP leveling:** judged by total leveling time, questing plus world fights. Affliction and Demonology take their solo talents and Destruction a new order: 8-12% faster.
- **Warlock PvP weights:** Affliction follows the solo weights again (small changes).

### 3.5.0 (Talents 1.4.1)

- **Spell Impact (new, WoW Forever, on by default):** item tooltips show how an item changes your main spells at the highest rank you know. Casters see damage per second and per mana (healers: healing), for example "Frostbolt DPS 152 > 158, DPM 1.42 > 1.47"; melee sees auto-attack damage per second and damage per use of the main abilities (Retribution, Enhancement and Feral get their melee abilities instead of spells). Now in yellow, with the item in green (better) or red (worse). Against a mob of your level, before talents.

- **Talents, fix:** Priest build notes show Dark Inspiration in your language instead of English.
- **Talents, Druid PvP leveling:** judged by total leveling time, questing plus world fights. Feral now fights in Cat Form and is about 10% faster; Balance about 4% and Restoration about 9%, all close to their solo builds.
- **Druid PvP weights:** Feral PvP uses Cat weights; the other Druid PvP weights follow the solo weights again.

### 3.4.7 (Talents 1.4.0, Roadmap 3.4.0)

- **Talents, Learn Next:** a button in the build panel picks your build's next talents, one for each unspent point. Click Apply Changes in the talent window to keep them.
- **Roadmap, Zone Quests:** a new small window (`/sgjq`, the Zone Quests button in Roadmap, or an optional minimap button) lists every quest you can pick up in the zone you're in, for your class, race and level. Done quests and ones that need earlier quests, reputation or a profession are left out; gray quests and ones opening within 2 levels are dimmed at the bottom. Hover for objectives, click to set a waypoint to the giver (TomTom, or the game's map pin that DaylightUI follows). Needs the free QuestieDB addon.
- **Talents, Warrior PvP leveling:** builds are now judged by total leveling time, questing plus the world fights you run into. Arms is about 7% faster, Fury and Protection about 3%; all three are now close to their solo builds.
- **Warrior PvP weights:** with PvP weights on, Warrior leveling weights follow the solo weights again, now with Expertise.
- **Talents, Priest PvP leveling:** judged the same way. Shadow now takes the solo Shadow talents, and Discipline and Holy nearly theirs: 9-13% faster.
- **Priest PvP weights:** with PvP weights on, Priest leveling weights follow the solo weights again.

### 3.4.6 (Talents 1.3.8)

- **Talents, dungeon builds:** all 35 dungeon, tank and healer builds re-checked on the new leveling gear. Druid and Shaman Restoration heal a little more (Swiftmend at 29; Totemic Focus and Mana Tide earlier), and Hunter Survival shooting and Warlock Affliction got tiny reshuffles late; the rest keep theirs.
- **Dungeon healer weights:** Druid and Shaman Restoration follow their new orders. Druid spell crit counts up to a quarter less around 40; Shaman MP5, Spirit and Intellect 5-15% less at 20-30.
- **Fixed, score breakdown window:** weapon DPS was shown at the wrong weight (a Hunter's melee weapon at the ranged Weapon DPS weight). Each line now matches the tooltip, which was already right.
- **Fixed, French Compact Equip Text:** school damage showed as Spell Power. With Shorten Stat Names off, school damage now shows its full name ("+34 Shadow Damage").

### 3.4.5 (Talents 1.3.7, Roadmap 3.3.1, Roster 1.1.3, Laboratory 3.1.3, XP 1.1.7)

- **Talents, Paladin PvP leveling:** builds are now judged by total leveling time, questing plus the world fights you run into. Retribution is about 10% faster, Holy (quests like Retribution, fights with Holy Shock) about 12% and Protection about 7%.
- **Talents, solo leveling builds:** re-checked now that the models count expertise, then all nine classes again on new leveling gear (latest Forever item changes). Warrior, Paladin, Rogue, Hunter, Druid Feral and Shaman Enhancement builds got slightly faster orders (up to 1%), then Mage, Warlock, Priest Discipline, Druid Balance, Shaman Elemental and Rogue Assassination (0.1% or less); the rest keep theirs.
- **Solo leveling weights:** melee specs now get their Expertise value from the leveling models. Protection Paladin values Stamina and Intellect less at 20-40, Retribution values Intellect and MP5 less at 19-30.
- **Solo leveling weights, new leveling gear:** every class rebuilt on gear picked with the 11-16/11-17 item changes, counting attack power and spell damage against one creature type and parry at 15 per 1%. Mage AoE Intellect counts about a quarter less at 20-33, Priest healer MP5 20-35% more at 15-30, Priest wand damage 15-30% less early.
- **Roadmap, new dungeons:** The Drowned City, Krol'dok Stronghold, Alcaz Prison and Blackmaw Hold are on the leaderboard, with the drops players have seen so far.
- **Roadmap, quest rewards:** 243 new quest rewards, most at levels 30-60, including Mount Hyjal, Riverglades and the quests for the five new Forever dungeons.
- **Fixed, non-English clients:** French stats with an apostrophe ("Dégâts d’ombre") and stat names with some accented, Korean or Chinese letters scored nothing; they count again.
- **Fixed, Shockadin:** Spell Power items no longer score half again too high.
- **Fixed, Expertise:** expertise items counted as Weapon Skill and scored close to nothing. Now 10 Expertise Rating is 1% fewer dodges and parries, valued like hit (tanks twice), with its own cap (about 50 rating, 65 vs raid bosses).
- **Fixed, Parry Rating:** Forever's rate is 15 Parry Rating per 1% (it was read as 20), so Parry items scored 25% too low for tanks.
- **Fixed, percent hit and crit:** items worded "Improves your chance to hit by 2%" or "... critical strike by 1%" scored a tenth of their hit and crit (Blackhand's Breadth's crit not at all). They now count in full, as do Classic lines Forever reworded ("Attack Power against Undead", "with melee attacks") and old weapon skill lines ("Increased Daggers +4").
- **Fixed, non-English "Equip:" lines:** on German, French, Spanish, Portuguese, Russian, Korean and Chinese clients most Classic "Equip:" lines (percent stats, mana per 5, school spell damage, block value, weapon skill) read nothing or the wrong stat; French school damage counted as Spell Power. All 8 languages now read every stat line like English.
- **Fixed, lines that only look like stats:** class ability bonuses, pet lines, "Spell Damage received is reduced" and death effects no longer count as Spell Power, Holy damage, Healing or mana per 5.
- **Fixed, XP Bar:** the stat weight warning no longer calls stats you already value "now valued" on WoW Forever, its numbers are rounded, and the level's gear score gain counts only item changes.

### 3.4.4 (Talents 1.3.6)

- **Dungeon tanks:** every tank is now measured in its own tank gear, with deaths and damage on other mobs in a pack matched to real Forever logs. The Paladin tank note says when to cast Consecration.
- **Talents, Warlock dungeon builds:** re-searched with a mana budget in groups (Life Tap between pulls, eaten back). Affliction and Destruction take Improved Life Tap and Cataclysm early for about 5% more damage.
- **Dungeon weights from the group models:** mana stats for Mage, Warlock, Shadow Priest, Hunters and Cat, and the Bear and Shaman tank weights, are now priced by the group models like the other classes'.
- **Talents, Mage dungeon builds:** re-checked in real leveling gear. All three keep their orders.
- **Separate dungeon weights:** Fury dual wield, the Rogue sword builds, Bear and the Shaman tank now have their own dungeon weights, so solo, PvP and farming weights stay as they were.
- **Talents, Hunter dungeon builds:** re-searched in real leveling gear. Beast Mastery and Survival got slightly faster orders; Marksmanship keeps its own.
- **Talents, Rogue dungeon builds:** re-searched in real leveling gear. Assassination and Combat with swords and Subtlety with daggers got slightly faster orders; the rest keep theirs.
- **Talents, Warrior dungeon builds:** re-searched in real leveling gear. Protection takes 16 points in Arms and gets Shield Slam at 49, about 2.5% faster; Arms and Fury keep their orders. The notes add Battle Shout.
- **Warrior dungeon weights:** measured on real leveling gear with Battle Shout. Protection tanks value block, dodge and Defense more from 40, and hit less.
- **Talents, Priest dungeon builds:** re-searched in real leveling gear with Divine Spirit. Discipline heals about 3% more; Shadow and Holy keep their orders.
- **Priest dungeon weights:** measured on real leveling gear with Fortitude and Divine Spirit. Healers value Spirit and Mp5 a little less.
- **Talents, Shaman dungeon builds:** re-searched in real leveling gear. Enhancement takes Improved Stormstrike at 30 for about 4% more damage, Restoration heals about 2% more, and Elemental keeps its order. The tank build now ends at 30. The notes name your totems.
- **Shaman dungeon weights:** measured on real leveling gear with your own totems. Enhancement values Mp5 and Spirit more in the 20s.
- **Talents, Druid dungeon builds:** re-searched in real leveling gear. Restoration takes Swiftmend at 40 (was 52) for about 1% more healing, and Bear got a slightly faster order; Cat and Balance keep theirs. The notes add Mark of the Wild, and Tiger's Fury for Cat.
- **Druid dungeon weights:** measured on real leveling gear with Mark of the Wild. Restoration healers value Intellect, crit and Mp5 more around 40.
- **Talents, Paladin dungeon builds:** re-searched in real leveling gear. Protection takes Retribution talents after 30 for about 3% more pulls per hour; Retribution and Holy keep their orders. Every note says which blessing to keep on yourself.
- **Paladin dungeon weights:** measured on real leveling gear with your own blessing. Protection tanks value Stamina, block and spell power more, and mana stats much less from 30.

### 3.4.3 (Talents 1.3.5, XP 1.1.6)

- **Talents, Shaman:** solo builds re-searched in quest-reward gear. All three got a little faster, and Elemental and Restoration are now only 4% and 8% behind Enhancement.
- **Shaman weights:** measured on real leveling gear, with Windfury Totem procs from Stormstrike. Casters value Spirit and Mp5 more, Enhancement values Intellect less.
- **Talents, Priest:** solo builds re-searched in quest-reward gear with Fortitude and Divine Spirit. Shadow stays the fastest, Discipline and Holy got a little faster, and Shadow without Shadowform is much faster (25% behind Shadow, was 41%).
- **Priest weights:** measured on real leveling gear with Fortitude and Divine Spirit. Spirit and Mp5 count for more, Stamina for less.
- **Talents, Warlock:** solo builds re-searched in quest-reward gear. Demonology stays the fastest, Affliction and Destruction got a little faster, and every build says which weapon stone to use when.
- **Warlock weights:** measured on real leveling gear with the best weapon stone at each level. Affliction values Spirit, Mp5 and health regen more.
- **XP Bar:** the session (time, XP per hour, kills and quests) now carries on through a `/reload`.

### 3.4.2 (Talents 1.3.4)

- **Talents, Paladin:** solo builds re-searched in quest-reward gear. Retribution to Protection at 40 is now the fastest Paladin solo build, and every build says which blessing to use.
- **Paladin weights:** measured on real leveling gear, with each build's best blessing (solo Protection had none). Judgement of Command is a melee attack again.
- **Talents, Druid:** solo builds re-searched in quest-reward gear. Feral stays the fastest; the notes add Mark of the Wild and Tiger's Fury.
- **Druid weights:** measured on real leveling gear. Cat and Bear now hit with the weapon you hold, as they do in Forever.
- **Talents, Mage:** solo builds re-checked in quest-reward gear; the talent orders stay and Frost AoE stays the fastest.
- **Mage weights:** measured on real leveling gear with Arcane Intellect up. Single-target Mages value Spirit and Mp5 much more.
- **Tooltip:** Gains and Losses now show weapon DPS for every spec (Feral Druids and others left it off the list; it was always in the score).

### 3.4.1 (Talents 1.3.3)

- **Talents, Warrior:** solo builds re-searched in quest-reward gear. Protection is now the fastest Warrior solo build; Arms takes Mortal Strike at 41.
- **Warrior weights:** measured on real leveling gear (quest rewards, and quest plus dungeon gear). Arms values Spirit about half as much.
- **Talents, Rogue:** solo builds re-searched in quest-reward gear. Subtlety with swords is now the fastest Rogue solo build, level with Combat maces.
- **Rogue weights:** measured on real leveling gear. Spirit and health regen count for about half as much.
- **Talents, Hunter:** solo builds re-searched in quest-reward gear. Marksmanship stays the fastest; Beast Mastery takes Summon Hawk at 33.
- **Hunter weights:** measured on real leveling gear, melee Hunters on their own gear set. Spirit and Intellect count for less.

### 3.4.0 (Talents 1.3.2, Roster 1.1.2)

- **Equip Best Upgrade:** a keybind (Key Bindings > AddOns) and `/sgj equip` put on the biggest upgrade in your bags, one item per press. Bind-on-Equip items ask first. Handy on a controller.
- **Fix:** no more "addon forbidden" error with the controller UI when turning in quests.
- **Roster:** a deleted and remade character no longer shows twice with "needs login", and a bag copy of an item you're wearing lists who it upgrades.
- **Talents, Paladin:** Retribution and Holy PvP leveling get new talent orders after the November 11 hotfix (Judgement can't be dodged or parried). Holy PvP leveling now takes Protection from 44.
- **Talents, Mage:** small changes to Frost AoE and Arcane PvP leveling.
- **Talents, all classes:** every solo leveling build re-searched after the Spirit fix. 13 got faster, up to 1%: Beast Mastery takes Summon Hawk and Bestial Wrath, Fury two-hander takes Protection after 40, Frost AoE gets Improved Blizzard at 21. The "% slower" notes match the current models.
- **Leveling weights, all classes:** Spirit's regen counts only after 5 seconds without casting, so casters, Hunters and healers value it 30-50% less, and Warriors and Rogues more. Dungeon weights follow live logs: survival stats count up to twice as much at 55-60, and healer and tank weights follow the healing and damage of real pulls.
- **Paladin, Mage and Shaman weights:** Judgement lands more often, Mages cast Frost Nova at rank 1, and Windfury Totem can proc 0.1 s after its last proc. Paladin Protection solo values Intellect and Stamina up to 30% less at levels 30-40.

### 3.3.3 (Roadmap 3.3.0, Talents 1.3.1)

- **Roadmap:** with the free QuestieDB addon installed, the quest list shows which rewards need earlier quests or reputation first, and names the quest to start with.
- **Talents, Hunter:** new talent orders after the November 10 hotfixes (mana costs, a stronger Hawk, pet health). Beast Mastery dungeon and PvP leveling now build around Summon Hawk, and Survival dungeon no longer takes Lone Wolf.
- **Talents, Paladin:** Protection solo notes say how many mobs to pull with tank gear.
- **Hunter weights:** leveling weights follow the new costs and talent orders. Spirit is worth about 20% less: its mana regen now starts 5 seconds after each fight.
- **Talents, Mage:** small talent order changes for Arcane and Fire dungeon and Arcane PvP leveling after the November 9 Arcane Concentration change.
- **Mage weights:** Arcane leveling values Intellect up to 50% more at levels 25-33.
- **Talents, Druid:** new Cat dungeon and Restoration dungeon talent orders, and small changes to Feral solo and Feral PvP leveling.
- **Druid weights:** Rake, Rip, Lacerate and Pounce can crit in WoW Forever and now count that way: Cat Crit is worth up to 50% more and Agility up to 20% more.
- **Talents, Warlock:** new talent orders for Destruction solo and the two Drain Life solo builds after the November 10 hotfixes.
- **Warlock weights:** Affliction leveling values Spirit and Mp5 up to 22% more at levels 10-15 and spell Hit up to 17% less at 45-50.
- **Talents, Shaman:** new Enhancement solo, dungeon and PvP leveling talent orders after the November 10 hotfixes.
- **Enhancement Shaman weights:** Windfury Totem now counts beside Windfury Weapon. Crit is worth up to 13% more at levels 35-50 solo and up to 28% more in dungeons, where Hit is worth up to 22% more and Intellect about 25% less.
- **Fix:** some Rogue builds are recognized correctly again after the latest WoW Forever update.
- **Talents, translations:** build steps show every talent name in your game's language (54 were still in English).
- **License:** from 3.3.3 the stat weights are under CC BY 4.0, free to use in other addons with credit. The code stays MIT.

### 3.3.2 (Roster 1.1.1)

- **Fix:** Gear Judge's lines on auction house tooltips no longer blink on and off.
- **Fix:** negative stats on items (for example -3 Stamina) are no longer ignored.
- **Roster:** its upgrade lines on auction house tooltips no longer blink either.

### 3.3.1 (Roster 1.1.0)

- **Fix (WoW Forever):** spell power shown as an Equip: line (for example on Heavy Woolen Gloves) no longer counts as nothing when the item is read before that line loads.
- **Roster:** the Roster grid shows each character's gold, and the total across all your characters.

### 3.3.0 (Talents 1.3.0)

- **Talents:** every leveling build in the build list shows its model number at your level (kills per hour, dungeon DPS, healing covered, tank pulls per hour or duel score).
- **Minimap button:** reopens the window on the page you used last; right-click it to jump straight to any page.
- **Talents, Warrior:** Fury PvP leveling takes Blood Craze, Gore Drinker and Improved Intercept earlier, for about 4% more duel strength from the mid 40s.
- **Talents, Warrior:** Builds that don't dual-wield no longer take off-hand talents; Fury two-hander solo and Arms dungeon level a little faster.
- **Talents, Hunter:** Melee Beast Mastery builds drop ranged-only talents (Beast Mastery melee dungeon about 1.4% faster), and most leveling builds are re-ordered.
- **Talents, Shaman:** Enhancement dungeon and solo leveling take Tidal Focus earlier, for slightly faster leveling.
- **Talents, Mage:** Arcane AoE takes Permafrost at 35 for about 3% faster leveling, and Arcane solo takes Incineration and Ignite in place of its late Frost talents.
- **Talents, Warlock:** Builds no longer take talents for a pet they don't use, and Demonology PvP leveling is about 1% stronger in duels.
- **Talents, Priest:** Discipline dungeon takes Holy Specialization earlier for about 0.6% more healing, and Discipline PvP leveling is about 0.8% stronger in duels.
- **Talents, Druid:** Bear builds no longer take caster-only talents, and Restoration dungeon takes Improved Rejuvenation and Improved Regrowth earlier.
- **Talents, Paladin:** Protection solo leveling takes Divine Strength and Holy talents late in place of Iron Creed and Shieldsworn, for about 1% faster leveling.
- **Talents, Paladin:** Retribution solo leveling takes Champion of the Light and Unsealed Wrath earlier, for a slightly faster climb to 60.

### 3.2.14

- **Hunter:** your Hit now also counts for your pet, your pet uses Bite and Claw, and hawks hit as hard as combat logs show. Bestial Discipline no longer overrates Spirit. New solo, Beast Mastery and PvP leveling talent orders.
- **Rogue:** Deadly Poison now grows with Attack Power on every tick, as combat logs show. New Assassination talent orders and small changes for Combat and Subtlety.
- **Shaman:** mana now varies from pull to pull in the models. Faster dungeon and PvP leveling talent orders, and Elemental PvP leveling is back.
- **Warlock:** mana now varies from pull to pull in the models, and the Voidwalker has more health. Faster talent orders for Demonology Drain Life solo and Affliction and Destruction PvP leveling.
- **Talents:** the build picker beside the talent window now matches the Builds page, with stage tabs, Solo, Dungeon and PvP tags, how much slower each build is, and your active build marked. The panel is on again for everyone.
- **Fixed:** scrolling the mouse wheel over the character model in the Gear Judge and Roadmap windows no longer causes an error.

### 3.2.13

- **Roadmap and Roster:** small upgrades count now, the same as on the tooltip.
- **Talents:** PvP leveling orders updated for Paladin, Warrior, Mage, Druid, Priest and Rogue.
- **Protection Paladin:** Hammer of the Righteous now counts. New leveling and dungeon tank orders and weights.
- **Warrior:** Unbridled Wrath now gives rage on Heroic Strike, each Cleave target and weapon specials. The Arms and Fury PvP leveling builds are back.

### 3.2.12

- **Feral Druid weights:** solo leveling rebuilt. Hit, Crit and Stamina count for more at levels 20-40.
- **Druid Talents:** Feral and Balance solo orders updated, and the % slower tags corrected.
- **Frost Mage weights:** solo leveling rebuilt. Crit, Hit, Intellect and Spirit count for less at levels 45-50.
- **Mage Talents:** solo and dungeon orders updated.
- **Priest weights:** solo leveling rebuilt. Mp5 and Spirit count for a little less at levels 10-35.
- **Priest Talents:** Shadow and Discipline solo orders updated, and the no-Shadowform % slower tag corrected.
- **Buffs:** rebuilt from the November 7 client. The Hyjal flasks count as 30 Stamina, not 60.

### 3.2.11

- **Profession arrows in DaylightUI:** recipes that craft an upgrade get the green arrow in DaylightUI's profession window.
- **Enhancement Shaman weights:** rebuilt for leveling. At levels 15-24 Spirit counts for a bit less, Intellect and Stamina for more. Levels 1-9 no longer jump about 6x at level 10.
- **Paladin weights:** solo leveling rebuilt with Hammer of Wrath from level 44. Retribution levels 1-9 no longer jump about 4x at level 10, and Mp5 no longer drops to 0 around level 44.
- **Shockadin:** the Paladin profile Holy: Solo Leveling is now named Shockadin: Solo Leveling.
- **Holy Paladin dungeons:** Talents order adjusted slightly at levels 15-17.

### 3.2.10

- **Loot upgrade alerts:** an item you loot or receive that's an upgrade pops up a small alert with the gain. Click it to equip.
- **Bag arrows on by default:** green and red arrows now show on bag items without turning them on (untick **Show Bag Upgrade Arrows** to hide them).
- **Quest rewards in DaylightUI:** upgrade and downgrade arrows on quest rewards in DaylightUI's NPC window.
- **Bag arrows on small upgrades:** arrows now show on every item the tooltip calls an upgrade or downgrade, small ones included.

### 3.2.9

- **November 4 hotfix (WoW Forever):** Elemental and Restoration Shaman leveling weights rebuilt for the 2-second Chain Lightning.

### 3.2.8

- **Launch weights (WoW Forever):** leveling and dungeon weights for every class follow Blizzard's launch notes, and dungeon mana is paced like a real group (short drinks between pulls, a full drink only when you run dry).
- **Weights that follow your gear:** on WoW Forever, leveling weights shift with quest-reward vs. best-for-your-level gear, and level-60 weights with pre-raid vs. Tier 1; on Classic Era, raid weights for most DPS specs follow your raid tier. `/sgj gearpoint` shows where you are.
- **Hit cap everywhere:** bag arrows and the Roster plugin value hit around your cap the same way tooltips do.
- **Profile from your talents (WoW Forever):** your profile comes from the shipped build closest to your talents, read by spell so renamed talents still count.
- **Launch class and racial changes (WoW Forever):** Hunter, Mage, Warlock and Paladin changes, and Stat Logic follows the new racials.
- **Healer gear fix:** healing, spell power and Mp5 on your gear are no longer missed right after login.

---

## 🚀 Key Features

### ⚔️ Built for WoW Forever

- **Level-60 weights for every class**, worked out with each build's own talents: damage and tank profiles from the wowsims Forever simulator, healer profiles from a healing model in which healers downrank as they do in game.
- **Profiles that match how you play:** Raid, Solo Leveling, Dungeon Leveling, PvP Leveling, AoE Farming and PvP, named after the builds in the Talents plugin (for example "Arms: Raid", "Holy: Dungeon Leveling").
- **Leveling weights level by level** for every Forever spec, from 10 to 59, built from the talents, spells and gear stats each spec actually has at that level. Your actual talents adjust them, and so does your gear (`/sgj gearpoint`).
- **Hit and defense targets follow your level.** While leveling that's 5% hit (4% spell hit) against same-level mobs. With **Gear for Raiding** on, the targets slide toward the raid caps (9% hit, 17% spell hit, 440 Defense, uncrushable) from level 50.
- **Gear for PvP:** Stamina, armor and burst count for more, and hit stays at the player-vs-player caps. The first time a realm looks like a PvP realm, Gear Judge offers to turn it on.
- **Relics are rated**, and new race/class combinations are supported.

### 🧠 Dynamic "Cap Guardian" Engine

The Judge watches your stats in real time and penalizes gear that would drop you below a critical threshold.

1. **Weight scalers (proactive):** hit and defense weights shrink as you approach your caps, so every item is scored with your current needs in mind.
2. **Cap Guardian (reactive):** if you're at or above a cap and a swap would drop you below it, the item gets a score penalty and a tooltip warning.

- **Tank defense:** 490 at 70 on TBC, 440 at 60 on Era, and on Forever a slide to 440 from level 50 (with Gear for Raiding on). Only applies when your profile weights defense.
- **Judged without buffs:** caps and thresholds read your gear and talents, not the food, elixirs or party buffs you happen to have on.
- **Buff Assumptions (all versions):** turn on **Assume Raid Buffed** or **Assume World Buffed** to credit the buffs you'd have in a group, raid or with world buffs.
- **Hybrid live preview:** tooltips answer *"if I swap this piece, where does my hit land?"* without you equipping it.

### 🔮 Smart Projection (SimC-Lite)

- **Gem simulator (TBC):** three strategies — **The Skeptic** (empty sockets = 0), **The Casual** (respect socket colors), **The Pro** (min-max, off-color gems included).
- **Gem quality tier (TBC):** project sockets with Common, Uncommon, Rare or Epic gems.
- **Enchant projector:** compare items as if they had the best enchant for your level and spec. Your worn item shows which enchant that is.
- **Meta gem enforcement (TBC):** detects when a swap would turn off your Meta Gem.
- **Progression-aware gem pool:** on TBC progression servers, projected gems follow the **Content Phase** set in Roadmap.

### 📊 Tooltip Verdicts

Hover any item: world drops, vendor goods, quest rewards, dungeon loot or AH listings.

- **Judge's Score** for your active spec (and any tracked off-specs).
- **Item Score:** the item's own score in its slot, and the score of what you wear there.
- **Spell Impact (WoW Forever, on by default):** how the item changes your main spells at the highest rank you know, now vs. with the item. Casters see damage per second and per mana (healers: healing), melee sees auto-attack damage per second and damage per use of its main abilities. Turn it off under **Tooltip Visuals**.
- **Upgrade / Downgrade verdict** with the score difference. One-handers for dual wielders are judged in the hand where they gain the most.
- **Other spec (Dual Specialization):** an extra line when an item upgrades the spec you're not in.
- **Context warnings:** cap breaks, set bonus loss, meta deactivation, missing enchants, off-hand requirements and more.
- **Shift-only mode:** show verdicts only while holding **Shift**.

### 🎒 Bag, Loot, Quest & Profession Overlays

Turn the bag and loot arrows and the loot alerts on or off in **Protocol → Interface Options**.

- **Bag upgrade arrows** (**on** by default): green and red arrows on bag items. Works with Blizzard bags, **Bagnon**, **ElvUI**, **GudaBags**, **DaylightUI** (bags and bank, WoW Forever) and **XLoot**. Baganator: the arrow is a **Sharpie's Gear Judge** widget in Baganator's *Icons* tab, and SGJ can also be picked under *Upgrade detection* for the `upgrade` search.
- **Fast bag arrows** (on when bag arrows are enabled): quick single-slot scoring, with a full check for set pieces and weapons.
- **Loot roll arrows** (**off** by default): highlights the best upgrade on group loot popups.
- **Loot upgrade alerts** (**on** by default): when an item you loot or receive is an upgrade, a small alert shows it with the gain. Click it to equip (out of combat), right-click to close.
- **Equip Best Upgrade:** a keybind (Key Bindings > AddOns > Sharpie's Gear Judge) or `/sgj equip` puts on the biggest upgrade in your bags, one item per press (out of combat). Bind-on-Equip items show the game's bind confirmation first. Works in a macro, so it can go on a controller button.
- **Quest reward overlays:** marks the best choice among quest rewards, in the game's quest window and in **DaylightUI**'s NPC window (WoW Forever).
- **Profession arrows** (always on): recipes that craft an upgrade for you get a green arrow, in Forever's professions window (**DaylightUI**'s too) and in the Classic profession and Enchanting windows (Era, TBC).

### 🧾 The Gear Receipt

Your equipped gear at a glance (`/sgj` → **Receipt**).

- **Left:** your profile, total score and alerts ("2 missing enchants", "1 better item in your bags"). Click an alert to flash the slots it refers to.
- **Middle:** your character with each slot's score beside it. Click a slot for its score breakdown.
- **Right:** your weighted stat totals.

### ⚔️ Weapon Thunderdome (built-in)

A core `/sgj` tab: compare six weapon setups (two-hander, one-hand + off-hand, dual wield) side by side without equipping anything, with the winner and a ranking of every setup. This is **not** the full Laboratory paperdoll.

### 📐 Stat Logic

Your active profile, your cap rings (hit, defense and the like, picked for your role) and every stat weight. Hover a bar for the explanation and the math behind it.

### 🔬 The Laboratory Plugin

*(Separate addon: **SharpiesGearJudge_Laboratory**)*

- Build and compare full gear sets without owning the items: drag items from chat or bags onto a virtual paperdoll.

### 🗺️ The Roadmap Plugin

*(Separate addon: **SharpiesGearJudge_Roadmap**)*

- Ranks dungeons and quest zones by the upgrades they hold for your character, with each dungeon's boss loot and quest rewards, and a quest list per zone showing each quest's best reward for you.
- **Zone Quests (WoW Forever, needs QuestieDB):** `/sgjq` lists every quest you can pick up in the zone you're in, for your class, race and level. Click one for a waypoint to the quest giver.
- **Content Phase** dropdown (TBC progression) sets which projected gems are available. Without Roadmap, the phase setting exists but has no in-core UI.

### 📋 The Roster Plugin

*(Separate addon: **SharpiesGearJudge_Roster**)*

- **Alt upgrades on tooltips:** hover a tradeable item to see which of your other characters it upgrades, and by how much.
- **Roster grid:** a tab with one column per character and each slot's item and score, so you can see who needs gear most.
- **BoE Finder:** lists the tradeable items your characters hold (bags, bank and mail) that upgrade another of your characters, and who to send them to.

### 🌳 The Talents Plugin

*(Separate addon: **SharpiesGearJudge_Talents** — WoW: Forever only)*

- Talent build guide from level 10 to 60: the next talent glows in the talent window, a side panel shows your progress, and off-build points are flagged.
- Builds for every class, sorted by **Max Level**, **Leveling** (Solo / Dungeon), **Farming** or **PvP** and by role.
- **Learn Next:** a button in the panel picks your build's next talents, one for each unspent point. Click **Apply Changes** in the talent window to keep them.
- **Dual Specialization:** from level 40 each spec keeps its own build.
- Gear Judge's weights follow the chosen build: its leveling profile while you level, its level-60 profile at 60.
- **Browse every build online:** [Forever Class Builds](https://sharpiesgearjudge.web.app) lists each class's builds with their talent order by level and the leveling stat weights Gear Judge uses. It's updated as builds change, so it can be a little ahead of the latest release.

### 📈 The XP Plugin

*(Separate addon: **SharpiesGearJudge_XP**)*

- Experience bar with rested XP and quest turn-in projection, upgrades waiting in your bags, a level-up gear alert and a warning before your leveling weights change.

### 👥 Off-Specs & Dual Specialization

- **Off-specs:** tick the profiles a character also plays in **Protocol → Off-Specs** (saved per character), and tooltips show an *(off-spec)* upgrade line for each.
- Off-spec upgrades are judged against the **best gear you own** for that profile: what you wear, your bags, and your bank as seen on your last visit. A Feral Druid sees whether a healing drop beats the healing set in the bank, not the cat gear it's wearing.
- Leveling profiles follow your level, and each profile is scored with the talents you last played it with.
- **Dual Specialization (WoW Forever, Season of Discovery, TBC Anniversary):** each spec keeps its own scoring profile (and Gear for PvP on Forever).

---

## 💻 Slash Commands

| Command                 | Action                                                              |
| ----------------------- | ------------------------------------------------------------------- |
| `/sgj` or `/judge`      | Open or close the Gear Judge window                                 |
| `/sgj config`           | Open the settings (**Protocol**). `/sgj options` works too.         |
| `/sgj import`           | Import weights (Pawn strings, Sixty Upgrades)                       |
| `/sgj simple`           | Toggle shortened stat names in tooltips                             |
| `/sgj colors`           | Toggle stat colors in tooltips                                      |
| `/sgj whatsnew`         | Show the What's New window again                                    |
| `/sgj equip`            | Equip the biggest upgrade in your bags (one item per use)           |
| `/sgj pvp`              | Toggle **Gear for PvP** (WoW Forever)                               |
| `/sgj jc`               | Toggle Jewelcrafter gem evaluation (TBC)                            |
| `/sgj hitcheck`         | Show your hit, where it comes from, and your targets (WoW Forever)  |
| `/sgj gearpoint`        | Show where your gear sits between pre-raid and Tier 1 (WoW Forever) |
| `/sgj talents`          | Show the talents Gear Judge reads and the profile it picks          |
| `/sgj dualspec`         | Show what Gear Judge reads for each spec                            |
| `/sgj realm`            | Show what the PvP realm check reads                                 |
| `/sgjsave`              | Reload the UI to save addon data to disk                            |
| `/sgjwipe`              | Reset all Gear Judge settings to their defaults                     |

Gear Judge also has a page under **Game Menu → Options → AddOns** to open the window or its settings, see What's New and bring back the minimap button.

---

## ⚙️ Settings Guide (Protocol)

Open **Protocol** from the Gear Judge window or with `/sgj config`.

### Interface Options

- **Hide Minimap Button** — Remove the minimap icon.
- **Hide Tooltip Verdict** — Disable SGJ lines on item tooltips.
- **Show Only via Shift Key** — Verdicts appear only while holding Shift.
- **Mute Error Sounds** — Stop the error sound when clicking invalid items.
- **Disable Conflict Check** — Stop the chat warning about Pawn/Zygor.
- **Show Bag Upgrade Arrows** — **On by default.** Green/red arrows on bag items.
- **Fast Bag Arrows** — On by default; only applies when bag arrows are enabled.
- **Show Loot Roll Arrows** — **Off by default.** Arrows on group loot frames.
- **Show Loot Upgrade Alerts** — **On by default.** An alert when an item you loot or receive is an upgrade.

### Tooltip Visuals

- **Compact Equip Text** · **Shorten Stat Names** · **Colorize Stats**

### Comparison Logic

- **Enchant Mode** — Off (Raw Stats) / Current Only / Project Best.
- **Gemming Logic** (TBC) — The Skeptic / The Casual / The Pro.
- **Gem Quality** (TBC) — Common / Uncommon / Rare / Epic tier used when projecting empty sockets.
- **Shield Tanks: No Two-Handers** — On by default. With a shield tank profile, two-handers are never shown as upgrades.

### Buff Assumptions (all versions)

Gear is always judged without the buffs you happen to have on. These add the ones you'd have in a group or raid.

- **Assume Raid Buffed** with a **Raid Buff Preset** — Off / Full Raid / 5-Player Group (Era, Forever) or Off / 25-Man Full / 10-Man Minimal (TBC).
- **Assume World Buffed** with a **World Buff Preset** — Off / Full World Buffed / DM Tribute Only.
- **Assume Consumables** — Assume temporary weapon buffs like Sharpening Stones or Weightstones.
- **Gear for Raiding** (WoW Forever, on by default) — From level 50, value hit and tank defense toward raid caps. Turn off if you won't raid. Greyed out while Gear for PvP is on.
- **Gear for PvP** (WoW Forever, off by default) — Score gear for fighting other players. Saved for each spec.
- **Show Other Spec on Tooltips** — With Dual Specialization, also show upgrades for your other spec.

Your own racials are always applied.

### Character Profile

- **Active Scoring Profile** — **Auto-Detect** picks a profile from your talents. It does not pick imported Pawn profiles. Hybrid builds may show an "uncertain" note in Stat Logic, so pick one by hand if needed.
- **Delete Custom Profile** — Remove a profile you imported.

### Off-Specs

- Tick the profiles this character also plays. Tooltips show an upgrade line for each, judged against the best gear you own for it (worn, bags, bank).

---

## 📥 Importing Custom Weights

Import **Pawn strings** (from SimC or WowSims) or **Sixty Upgrades** exports:

1. Copy your Pawn string or Sixty Upgrades export.
2. Type `/sgj import` in game (or use **Import Pawn String** in Protocol).
3. Paste and confirm. SGJ creates a custom profile you can select in Protocol.

---

## 📥 Installation & Compatibility

One download for every client. SGJ detects which game you're running:

| Client                      | Support                                                                                      |
| --------------------------- | -------------------------------------------------------------------------------------------- |
| **Classic Era (1.15.x)**    | Hit %, Defense skill, T0–T3 sets, vanilla proc logic                                         |
| **TBC Anniversary (2.5.x)** | Combat ratings, gems, meta gems, TBC sets, progression gem phases                            |
| **WoW: Forever**            | Sim-built weights, level-by-level leveling weights, PvP weights, relics and class combinations |

### Install

Install with the CurseForge app, or extract the `SharpiesGearJudge` folder into your game's `Interface/AddOns` folder:

- `_classic_era_/Interface/AddOns` — Classic Era
- `_anniversary_/Interface/AddOns` — TBC Anniversary
- `_forever_/Interface/AddOns` — WoW: Forever

### Optional plugins

- **SharpiesGearJudge_Laboratory** — Virtual paperdoll / loadout testing.
- **SharpiesGearJudge_Roadmap** — Zone and dungeon loot rankings, and Content Phase control.
- **SharpiesGearJudge_Roster** — Alt upgrades on tooltips, a grid of every character's gear scores, and the BoE Finder.
- **SharpiesGearJudge_Talents** — Talent build guide for WoW: Forever, linked to Gear Judge's weights.
- **SharpiesGearJudge_XP** — Gear-aware experience bar.

### Supported bag addons

Blizzard default bags, **Bagnon**, **ElvUI Bags**, **Baganator**, **GudaBags**, **DaylightUI Bags**, **XLoot** (loot rolls).

### Localization

English, plus German (**deDE**), Spanish (**esES**, **esMX**), French (**frFR**), Brazilian Portuguese (**ptBR**), Russian (**ruRU**), Korean (**koKR**) and Traditional Chinese (**zhTW**). In Korean and Traditional Chinese the interface is translated, but some profile names and TBC gem and enchant names still show in English.

---

## 🏗️ How It Works (Brief)

```
Item tooltip / bag link
    → Parsers/Parse.lua (scan stats, procs, sockets, set headers)
    → Helpers.lua (raw stats, ProcDB, gem/enchant projection)
    → Evaluator.lua (character score, upgrade delta, cap guardian)
    → Judge.lua / Interface.lua (draw tooltip verdict or bag arrow)
```

Set bonuses, meta requirements, weapon specialization, and raid-buff-adjusted caps are applied in the scoring engine — not as flat per-stat multipliers on individual items.

---

## 📜 License

- **Code:** MIT License.
- **Stat weights** (from 3.3.3): [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). You can use them in your own addon, as long as you credit Sharpie's Gear Judge by Supersharpie and link back to it or to the [builds site](https://sharpiesgearjudge.web.app).
- See [LICENSE](LICENSE) for which files that covers. Earlier versions stay MIT.

## Credits

- **Author:** SuperSharpie
- **Version:** 3.6.0 (Classic Era, TBC Anniversary & WoW Forever)
- **GitHub:** [Supersharpie/SharpiesGearJudge](https://github.com/Supersharpie/SharpiesGearJudge)
- **Discord:** [Join the Theorycrafting Hub](https://discord.gg/aYmhmtGxYs)
- **Feedback:** Found a weight that feels off? Drop by the Discord or open an issue on GitHub!

For detailed version history, see [CHANGELOG.md](CHANGELOG.md).
