# Mothership Warfare Recreation

## Project Overview
This project is a modern, from-scratch recreation of the classic Flash game "Mothership Warfare."
The goal is to accurately translate the original ActionScript logic, unit behaviors, and game mechanics
into a modern web environment using Phaser 3 (Canvas) and vanilla JavaScript.

## Developer Profile
Rashad prefers calm, analytical, structured problem-solving. Break down complex legacy Flash logic
into clean, step-by-step modern implementations. No placeholders. No verbose explanations.
When providing code, match existing patterns and conventions seen in neighboring code.

## Current Progress

### Done
- **Assets:** All .swf files extracted via JPEXS. Sprites, backgrounds, SVGs, and sounds available.
- **Environment:** 3200px battlefield with 3-layer parallax (sky pinned, terrain scrolls, bases/units on top). Camera scroll with arrow keys / A,D; zoom with mouse wheel (1.0-2.0).
- **Bases:** Red (enemy) on LEFT ground, Blue (player) on RIGHT ground, rendered from 433.svg.
- **UI:** Health bars (Blue left, Red right), base portraits, economy bar (0-1000 credits, +10/sec), deploy buttons for 7 unit types per side.
- **Full OOP refactoring:** monolithic `game.js` deleted; replaced with `constants.js`, `Unit.js`, `GameScene.js`, `UIScene.js`, `main.js`
- **Heavy Tank (ht):** fully implemented — stats (HP 400, dmg 20, recharge 1800ms, eyeRange 680, cost 140), walk 60/shoot 21/death 19, damage table entries, all `=== 'st'` checks extended for `'ht'`
- **Sniper (sn):** HP 20, dmg 80, eyeRange 900, recharge 2000ms, speed 40, cost 120. Skip tank targets in nearest-enemy search. 2s first-shot delay. Red laser beam Graphics line during engagement.
- **Engineer (en):** HP 20, dmg 0, cost 40. Walk to nearest forward trench (800/1600/2400 X), play trench anim once then crouch loop. `_noWarp = true` (never warps). Skip engagement entirely.
- **Miner (mn):** HP 60, dmg 0, cost 100. Walk-plant cycle: 3s walk → 2s plant → repeat. Place mine (max 1 active). Mine damage 133, explosion animation (37 frames).
- **Trench system:** 3 trench positions on map. `trench.png` (666×375). 30% damage reduction for units behind trench. Blocks tank/miner crossing (stop at 25px). Mine tracking with Phaser distance detection.
- **Sniper laser:** Graphics line drawn each frame from barrel to locked target while engaged. Cleared and redrawn per frame.
- **Icon sizing:** Proportional fit within 55×55, hover scales up 10%.
- **Base stretching:** X-scale 1.4→1.8 (Y-scale stays 1.4), lane coordinates recalibrated by ×1.2857 ratio.
- **Formation direction bug fixed:** pUnits front = max X, eUnits front = min X.
- **Formation overflow queue:** units exceeding lane corridor bounds walk to `frontX ± 5` with smooth arrival detection.
- **Deploy buttons:** 7 per side (inf, mm, st, ht, sn, en, mn). Keyboard 1-7 for selection, Space/Enter deploy, W/S cycle lanes.
- **deselectAll():** clears tints for all 7 button pairs.

### Session 06-03-2026 — Bug Fix Round 2
- **Sniper icon proportional scaling:** Removed `setDisplaySize(82, 55)` distortion. Snipers now use `setDisplaySize(60, 43)` — same pixel dimensions for both colors.
- **Miner plant state guard:** Added `s._mnState !== 'plant'` to trench unblock condition. Prevents unblock code from overriding plant animation with walk when no trench blocks the miner.
- **Trench stacking:** Units now spread vertically when arriving at a trench. Max 3 per trench. Positioned at `trench.y + (count-1)*20 - 40`, clamped to lane bounds.
- **Sniper unit size:** Blue `setDisplaySize(86, 60)` (+23% width). Red `setDisplaySize(101, 62)` (+23% width, -14% height).
- **Trench damage reduction:** Changed from 30% to 20% (multiply dmg by 0.8).
- **Trench stance animation:** inf/mm play shoot once → crouch loop; sn play crouch once → shoot loop. Applied to both trench arrival and trench attack.
- **Engineer multi-build:** After building a trench, walks to next buildable position. Jump sends to next position (not warpX). All 3 positions per lane buildable.
- **Miner one mine at a time:** Re-added `_activeMine` guard. New miners skip existing mines (300px ahead check). Removed 30s auto-despawn — mines persist until detonated.
- **Combat unit 1 per lane:** st/ht/mn combined share a single lane slot.
- **Multi-select:** Shift+click to add/remove units. Batch commands (Hold/Fallback/Jump) apply to all selected.
- **Trench highlight:** Clicking a trench tints all units currently inside it.
- **Trench capacity 5→3:** Max 3 units per trench. All `_occCount` checks use 3.
- **Engineer Jump:** Added Jump button to command panel for engineers. Jump walks to next buildable trench, or warpX when all built.

### Session 06-03-2026 — Full Trench System Overhaul (continued)
- **Tank shoot-once root cause fixed:** Trench unblock code (`!anyBlocking && !s.body.moves && !s._hold`) overrode engagement's `body.moves = false` every frame, causing tanks to walk after one shot. Added `&& !s.isEngaging` guard at GameScene.js:1028.
- **Queue arrival instant shot fixed:** `lastFireTime = 0` changed to `this.time.now` — prevented a single frame of free shot when the queue position arrived.
- **Miner unlimited mines fixed:** Added `_activeMine` check before mine placement — miner resumes walk cycle instead of placing a second mine while one still exists.
- **Build order fixed:** Was `isRed ? [800,1600,2400] : [2400,1600,800]` (farthest-from-spawn first). Changed to `isRed ? [2400,1600,800] : [800,1600,2400]` (nearest-to-spawn first).
- **Engineer `warpX` separated:** `warpX` now saved before engineer override so `jump()` sends engineer to enemy door (not back to trench). Fixes engineer can't jump.
- **Engineer crouch changed to `repeat: 0`:** No longer loops infinitely. `_enCrouchStarted` flag prevents re-adding `once(animationcomplete)` listeners every frame. Plays crouch once, `stop()` locks last frame.
- **Engagement null-guard:** When `nearest === null` (no enemy in range), unit no longer sets `isEngaging=true`/`body.moves=false`/plays shoot. Now simply `return;` — unit keeps walking. Fixes non-en/mn units freezing at spawn.
- **Command panel restricted:** `updateCommandPanel` now shows combat buttons (Hold/Fallback/Jump) only for combat unit types (`inf/mm/st/ht/sn`). En/mn get no combat buttons.
- **`hold()`/`fallback()` guards:** Added `if (unitType === 'en' || unitType === 'mn') return;` to prevent attempting missing crouch animations.
- **`jump()` improved:** Decrements `trench._occCount` before leaving, clears `_trenchHold`/`_trenchArrived`, sets `targetX = warpX` (final destination). Allows units to leave trench and walk toward enemy.
- **Trench `_building` guard:** Units cannot damage a trench while it's being built (4s fade-in). Prevents "one-shotting" during construction.
- **Miner walk time accumulation:** Removed `s.body.moves` check from `_mnWalkTime += delta`. Miner accumulates walk time even when blocked by trench, enabling plant cycles at blocked positions.
- **Flip direction unchanged:** Original `isEnemyDoor ? !flipLikeTank : flipLikeTank` confirmed correct for infantry facing RIGHT / tanks facing LEFT by default.

## Tech Stack
- **Frontend:** Phaser 3.60 (Canvas), vanilla JavaScript, HTML5
- **Backend (future Phase 2):** Node.js, Express, Socket.io
- **Assets:** Extracted Flash .swf visuals (PNG sprites, SVGs, MP3 sounds)
- **Game Loop:** Phaser preload > create > update

## Key Mechanics

### Engagement Flow
Walk > Enter eyeRange of enemy > Lock to nearest enemy (sniper skips tanks) > Stop > Shoot anim (once) > Crouch anim (looping, 10fps) > Fire bullet every rechargeMs at locked target only > Impact anim on hit > If target dies: resume walking

### Spawn / Warp Flow
Click door > Deduct credits > Spawn invisible at door > Walk > Fade in over 400ms (position-based at 100px) > Walk to target at speed > At 130px from target: morph (0.5 alpha, -0.14 every 300ms, 5 steps) > Reach warpX: instant destroy

### Engineer Flow
Spawn at door > Walk to trench X (build order enforced) > Stop at 30px > Play crouch (lock last frame) > Click engineer > Build (40cr) > Play trench anim > Trench fades in (4s) > Crouch loop (never warps, stays at trench)

### Miner Flow
Spawn at door > Walk 3s > Stop > Plant 2s > Place mine (if none active) > Walk 3s > Repeat until warp

### Trench System
Trench at X=800/1600/2400. Blocks tank/miner crossing at ±25px. 30% damage reduction applied in fireBullet when defender is behind a trench (trench X between shooter and defender).
- HP scales by position: 75%/50%/25% from base (using `getTrenchMaxHp`).
- Built-in-order enforced (engineer walks to nearest buildable position).
- Hold: units walk to friendly trench (max 5 per trench), crouch, engage enemies, return.
- Trench attack: combat units target enemy trench when no enemy in range, with shoot anim + sound, `lastFireTime=0` for immediate first shot.
- Both blue and red can build trenches.

## Animation Reference

| Animation | Frames | Frame Rate | Repeat |
|-----------|--------|-----------|--------|
| Walk (inf/sn/en/mn) | 20 | 20 fps | Infinite |
| Shoot (inf/mm/st/ht) | 21 | 21 fps | Once |
| Shoot (sn) | 15 | 21 fps | Once |
| Crouch (inf) | 15 | 10 fps | Infinite |
| Crouch (mm) | 13 | 15 fps | Infinite |
| Crouch (sn) | 21 | 10 fps | Infinite |
| Crouch (en) | 21 | 10 fps | Once + stop lock |
| Bullet Impact | 20 | 20 fps | Once |
| Tank/MM Impact | 36/31 | 20 fps | Once |
| Death (blue/red inf) | 111/112 | 15 fps | Once |
| Death_2 (tank kill inf) | 126 | 15 fps | Once |
| Death (blue/red mm) | 112/111 | 15 fps | Once |
| Death_2 (tank kill mm) | 126 | 15 fps | Once |
| Tank walk | 60 | 10 fps | Infinite |
| Tank shoot | 21 | 21 fps | Once |
| Tank death | 20 | 7.5fps (ts 0.5) | Once + 3s hold |
| Heavy Tank walk | 60 | 10 fps | Infinite |
| Heavy Tank shoot | 21 | 21 fps | Once |
| Heavy Tank death | 19 | 15 fps | Once |
| Sniper/Eng death_1 (blue/red) | 111/112 | 15 fps | Once |
| Sniper/Eng death_2 (tank kill) | 126 | 15 fps | Once |
| Miner death | 18 | 15 fps | Once |
| Engineer trench | 15 | 15 fps | Once |
| Miner plant | 16 | 8 fps | Once |
| Mine explosion | 37 | 20 fps | Once |

## Session Constants

| Parameter | Value |
|-----------|-------|
| Unit speed | 80 px/s (sniper 40) |
| Spawn fade dist / dur | 100 px / 400 ms |
| Pre-warp morph dist | 130 px |
| Morph alpha/step/delay/repeat | 0.5 / 0.14 / 300ms / 4 |
| Warp-out | instant destroy |
| Credits gain | +10/s, max 1000 |
| Infantry cost | 20 |
| Missile Man cost | 50 |
| Storm Tank cost | 80 |
| Heavy Tank cost | 140 |
| Sniper cost | 120 |
| Engineer cost | 40 |
| Miner cost | 100 |
| Mine damage | 133 |
| Mine lifetime | 30s |
| Trench positions | 800, 1600, 2400 |

## In-Game Unit Stats (current implementation)

| Unit Type | Speed | Health | Eye Range | Base Damage | Recharge | Cost |
|-----------|-------|--------|-----------|-------------|----------|------|
| Marine | 80px/s | 50 | 550 | 5 | 733ms | 20 |
| Missile Man | 80px/s | 80 | 780 | 15 | 1667ms | 50 |
| Storm Tank | 80px/s | 240 | 650 | 20 | 1500ms | 80 |
| Heavy Tank | 80px/s | 400 | 680 | 20 | 1800ms | 140 |
| Sniper | 40px/s | 20 | 900 | 80 | 2000ms | 120 |
| Engineer | 80px/s | 20 | 0 | 0 | 0ms | 40 |
| Miner | 80px/s | 60 | 0 | 0 | 0ms | 100 |

### Cross-Type Damage Table

| Attacker → Defender | Damage | Shots to Kill |
|---|---|---|
| Infantry → Infantry | 5 | 10 |
| Infantry → MM | 14 | 6 |
| Infantry → Tank | 2 | 120 |
| Infantry → Heavy Tank | 1 | 400 |
| Infantry → Sniper | 5 | 4 |
| Infantry → Engineer | 5 | 4 |
| Infantry → Miner | 4 | 15 |
| MM → Infantry | 3 | 17 |
| MM → MM | 15 | 6 |
| MM → Tank | 40 | 6 |
| MM → Heavy Tank | 20 | 20 |
| MM → Sniper | 3 | 7 |
| MM → Miner | 10 | 6 |
| Tank (st/ht) → Infantry | 17/25 | 3/2 |
| Tank (st/ht) → MM | 9/10 | 9/8 |
| Tank (st/ht) → Tank | 20 | 12 (st) / 20 (ht) |
| Tank (st/ht) → Heavy Tank | 10 | 40 |
| Tank (st/ht) → Sniper | 10/20 | 2/1 |
| Tank (st/ht) → Engineer | 20 | 1 |
| Tank (st/ht) → Miner | 12/20 | 5/3 |
| Sniper → Infantry | 50 | 1 |
| Sniper → MM | 80 | 1 |
| Sniper → Engineer | 20 | 1 |
| Sniper → Sniper | 20 | 1 |
| Mine → any | 133 | 1 (inf/mm/sn/en), 2 (st), 3 (ht) |

## Key Decisions

1. **Spawn fade is position-based** — no delayed call, eliminates desync.
2. **Morph uses stepped fade** via `time.addEvent`, not a tween.
3. **Warp at door is instant destroy** — no fade-out.
4. **No distance-based disengagement** — prevents formation-offset engage loop.
5. **Same-type formation offset only** — offset 48px between same `eyeRange` units.
6. **Morphing soldiers can engage** without canceling morph; timer continues.
7. **HP bars destroyed instantly on death** — not in animationcomplete.
8. **No physics colliders between friendlies** — overlapping passes through.
9. **First shot fires immediately** — no wait on animcomplete.
10. **Tank death uses standard Phaser animation** (timeScale 0.5) + 3s hold.
11. **Sniper skips tank targets** in nearest-enemy search (not zero-damage entries).
12. **Engineer/miner don't fight** — eyeRange: 0, recharge: 0.
13. **Miner single mine at a time** — `_activeMine` ref checked before placement.
14. **Engineer never warps** — `_noWarp = true`, stays at trench as crouching builder.
15. **Trench damage reduction** applied in fireBullet by checking trench X between shooter/defender.
16. **Red engineer anim folders are inconsistent** — some use prefix (`enginer_red_walk`), suffix (`enginer_crouch_red`), and mixed (`enginer_death_red_1`). Each folder tracked explicitly in preload.
17. **Engineer build now requires click + Build button** — no longer auto-builds. Engineer crouches, waits for user command.
18. **Trench hold prevents morph** — `_trenchHold` flag checked in `checkMorphOut()` to prevent units fading at trench.
19. **Per-lane limits** — `_tanksInLane[5]` and `_minersInLane[5]` arrays track deploy counts per lane.
20. **Fallback walks to trench behind** — if no trench behind, unit stays in place (doesn't walk to door).
21. **Trench attacks have visual/sound feedback** — shoot animation and sound play when firing at enemy trenches.
22. **Sniper icons uniform** — both colors use `setDisplaySize(60, 43)` to match regardless of source image dimensions.
23. **Sniper unit size** — blue: `displaySize(86, 60)`, red: `displaySize(101, 62)`. Width +23% for both, red height -14% to match blue.
24. **Trench capacity 3** — max 3 units per trench, spread at `trench.y + (count-1)*20 - 40`.
25. **Trench damage reduction 20%** — `dmg * 0.8` when defender behind trench.
26. **Trench stance animation** — inf/mm: shoot once → crouch loop; sn: crouch once → shoot loop.
27. **Engineer multi-build** — after building a trench, walks to next buildable position. Jump sends to next position (not warpX). All 3 positions per lane buildable.
28. **Miner one mine at a time** — plants only when `_activeMine` is null. New miners skip existing mines (300px check ahead). Mines persist until detonated (no timeout).
29. **Combat unit one per lane** — max 1 combined st/ht/mn per lane.
30. **Multi-select** — Shift+click to add/remove from selection. Batch commands (Hold/Fallback/Jump) apply to all selected units.
31. **Trench click highlight** — clicking a trench tints all units inside it.

### Session 06-04-2026 — MenuScene + Miner Timer Rewrite + Dual Economy Bars

#### Miner Rewrite (GameScene.js:988-1033)
- **Phaser timer-based cycle:** Replaced `this.game.loop.delta` accumulation with `this.time.delayedCall(3000)` for walk phase and `this.time.delayedCall(2000)` for plant phase. `_mnCycleState` tracks `'walking'` / `'planting'`. `_activeMine.active` guard checks if mine sprite still exists — if destroyed, nullifies reference and proceeds to plant new mine. Old `_mnWalkTime` / `_mnState` references removed.

#### Red UI Restored (UIScene.js)
- Restored red deploy buttons (7), red base portrait, red health bar, "Enemy Sector" text — all at 35% alpha with no interactivity via `createRedDeployButton()`. Blue buttons remain fully interactive.

#### Dual Economy Bars
- Player economy bar: cyan, bottom-center (`window.innerHeight - 40`). AI economy bar: red, small, top-right below red portrait. AI credits emitted to registry via `'changedata-aiCredits'` from GameScene update loop.

#### MenuScene (new file)
- First scene loaded; preloads ALL game assets with progress bar → shows "MOTHERSHIP WARFARE" title + Single Player / Multiplayer buttons. Animated starfield background, glow effects. Multiplayer lobby has Host/Join with DOM room code input (6-char uppercase). Game assets available to GameScene/UIScene via Phaser cache.

#### Scene Chain
- `main.js`: `scene: [MenuScene, GameScene, UIScene]`. MenuScene starts first, loads all assets, then transitions via `this.scene.start('GameScene')`.
- GameScene.preload() removed entirely. GameScene no longer `active: true` — started by MenuScene.

#### Bug Fixes (continued)
- **Miner 300px avoidance removed:** Reverted to simple `_activeMine` guard only.
- **Engineer rebuild fixed:** `buildTrenchAt()` filters destroyed trenches before creating new ones.
- **Morph + invisible firing fixed:** Morph timer skips alpha decrease while engaging. All 4 engagement points cancel morph timer and restore alpha to 1.
- **Missing damage entries added:** Complete 49-entry matrix.
- **Trench block position branches swapped:** Red → `trench.x + 25`, Blue → `trench.x - 25`.
- **Deploy limits changed:** Max 2 st/ht/mn per lane default, drops to 1 if trench exists.

#### Trench System
- **Trench queue system:** Unit waits at full trench with `_trenchQ` flag, scans for open slot, gives up 50px past.
- **Enemy switch safety:** Trench attack scans for enemies before firing.

#### Multiplayer Stubs
- `client/network.js`: NetworkManager class (WebSocket connect, serialization, state application)
- `server/index.js`: Express + Socket.io, room management, side assignment

### Session 06-04-2026 (continued) — Miner Unlimited Mines + Economy Separation + MP Hardening

#### Miner Bug Fix (GameScene.js)
- **Removed `_activeMine` guard**: Miner now plants a mine every walk-plant cycle regardless of whether previous mines still exist. Original Flash behavior — miners lay continuous minefields. `_activeMine` still set on each new mine (for explosion cleanup in mine loop) but no longer blocks planting.

#### Economy Separation
- **UIScene**: `isMultiplayer` flag from `registry.get('gameMode')`. AI economy bar (red, top-right) and `aiCredits` listener only created in single-player mode. Player credits timer and bar always present.
- **GameScene**: AI deployment section guarded behind `gameMode !== 'multiplayer'`. No AI units spawn in multiplayer.

#### Multiplayer 1v1 Hardening
- **playerSide-aware deploy**: Host (`playerSide=blue`) sees interactive blue buttons + grayed red buttons. Joiner (`playerSide=red`) sees interactive red buttons + grayed blue buttons. `localSide` controls which `armedUnit` names are used by keyboard 1-7 shortcuts.
- **Keyboard shortcuts refactored**: Dynamic mapping — uses `blueUnitKeys` or `redUnitKeys` based on `isLocalBlue`. `deselectAll()` iterates both blue and red button arrays.
- **Red button interactivity**: `createRedDeployButton()` now accepts `unitName` and creates interactive buttons when `isMultiplayer && !isLocalBlue`.
- **Blue button interactivity**: When joiner is red, blue buttons created grayed via static `add.image`.

#### Site Readiness
- **Server hardening** (`server/index.js`): `path.resolve(__dirname, '..', 'client')` for reliable static serving. `process.env.PORT || 3000` for flexible deployment. Catch-all `app.get('*')` fallback to index.html for SPA routing.
- **Socket.io client**: `index.html` includes `socket.io.min.js` CDN. NetworkManager rewritten to use `io(url)` instead of raw WebSocket.
- **`http` dependency removed**: Built-in module — not needed in `package.json`.
- **Root `package.json`**: `npm start` → `node server/index.js`.
- **MenuScene DOM removed**: `this.add.dom()` replaced with `prompt()` for room code — avoids Phaser DOM plugin requirement.

#### NetworkManager Rewrite (client/network.js)
- Uses Socket.io client (`io()` from CDN). Events: `joinGame`, `assignedSide`, `opponentJoined`, `remoteState`, `opponentDisconnected`. Host generates room code via `generateRoomCode()`. State serialization every 3 frames (`frame % 3 === 0`).

## Key Debug / Dev Notes
- All red variants use `{n}.png` naming (no luxa prefix) except storm/heavy tank.
- `enginer_trech` folder is a typo of "trench" — keep the actual folder name.
- Unit type strings: `'inf'`, `'mm'`, `'st'`, `'ht'`, `'sn'`, `'en'`, `'mn'`
- Animation key pattern: `${prefix}_${action}_anim` / `${prefix}_${action}_red_anim`
- Prefixes: infantry, missile, tank, heavyTank, sniper, engineer, miner
- Door side: LEFT door = blue spawn, RIGHT door = red spawn
- Blue units walk RIGHT, red units walk LEFT
- pUnits front = max X, eUnits front = min X
- `enginer_crouch_red` uses suffix `_red` not prefix `enginer_red_` like others
- Miner death has only 1 animation (18 frames) for both colors
- `_tanksInLane[]` tracks combined st/ht/mn count per lane (max 2 default, 1 if trench exists)
- `doorZones[]`: player door is `z.player` (left side, blue), enemy door is `z.enemy` (right side, red AI)
- AI deploys every 3s with independent credit pool (`this.aiCredits`)
