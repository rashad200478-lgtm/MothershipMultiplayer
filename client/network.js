class NetworkManager {
    constructor(gameScene) {
        this.gameScene = gameScene;
        this.socket = null;
        this.connected = false;
        this.isHost = false;
        this.roomId = null;
        this.onGameEvent = null;
    }

    connect(roomId, isHost) {
        this.roomId = roomId;
        this.isHost = isHost;
        let url = window.location.origin;
        this.socket = io(url);
        let nm = this;
        let side = this.gameScene.registry.get('playerSide') || (isHost ? 'blue' : 'red');
        this.socket.on('connect', () => {
            this.connected = true;
            console.log('[Network] Connected as', side);
            this.socket.emit('joinGame', { roomId: roomId, side: side });
        });
        this.socket.on('assignedSide', (side) => {
            this.gameScene.registry.set('playerSide', side);
            console.log('[Network] Assigned side:', side);
        });
        this.socket.on('opponentJoined', (side) => {
            console.log('[Network] Opponent joined as', side);
        });
        this.socket.on('remoteState', (state) => {
            this.applyRemoteState(state);
        });
        this.socket.on('gameEvent', (data) => {
            if (this.onGameEvent) this.onGameEvent(data.eventName, data.payload);
        });
        this.socket.on('opponentDisconnected', () => {
            console.log('[Network] Opponent disconnected');
        });
        this.socket.on('disconnect', () => {
            this.connected = false;
            console.log('[Network] Disconnected');
        });
    }

    sendState() {
        if (!this.connected) return;
        this.socket.emit('gameState', {
            roomId: this.roomId,
            state: this.serialize()
        });
    }

    sendGameEvent(eventName, payload) {
        if (!this.connected) return;
        this.socket.emit('gameEvent', {
            roomId: this.roomId,
            eventName: eventName,
            payload: payload
        });
    }

    isLocallyControlled(u) {
        let scene = this.gameScene;
        let gameMode = scene.registry.get('gameMode') || 'singlePlayer';
        if (gameMode !== 'multiplayer') return false;
        let localSide = scene.registry.get('playerSide') || 'blue';
        let isLocalBlue = localSide === 'blue';
        return isLocalBlue ? !u.isRed : u.isRed;
    }

    serialize() {
        let scene = this.gameScene;
        let state = {
            units: [],
            trenches: [],
            mines: [],
            credits: scene.registry.get('credits')
        };
        // Only send locally-controlled units
        let allGroups = [scene.pUnits, scene.eUnits];
        allGroups.forEach(group => {
            if (!group) return;
            group.getChildren().forEach(u => {
                if (!this.isLocallyControlled(u)) return;
                state.units.push({
                    unitId: u._unitId, x: u.x, y: u.y,
                    unitType: u.unitType, isRed: u.isRed,
                    laneIndex: u.laneIndex, health: u.health, maxHealth: u.maxHealth,
                    warpX: u.warpX, targetX: u.targetX, spawnX: u.spawnX,
                    alpha: u.alpha,
                    isEngaging: u.isEngaging, _trenchHold: u._trenchHold,
                    _trenchArrived: u._trenchArrived, _dying: u._dying,
                    isWarpingOut: u.isWarpingOut, _hold: u._hold
                });
            });
        });
        scene.trenches.forEach(t => {
            state.trenches.push({
                x: t.x, y: t.y, laneIndex: t.laneIndex, ownerIsRed: t.ownerIsRed,
                hp: t.hp, maxHp: t.maxHp, active: t.active, _occCount: t._occCount
            });
        });
        scene.mines.forEach(m => {
            state.mines.push({ x: m.x, y: m.y, _mineIsRed: m._mineIsRed });
        });
        return state;
    }

    applyRemoteState(state) {
        let scene = this.gameScene;
        if (!scene || !state) return;
        let gameMode = scene.registry.get('gameMode') || 'singlePlayer';
        if (gameMode !== 'multiplayer') return;

        let localSide = scene.registry.get('playerSide') || 'blue';
        let isLocalBlue = localSide === 'blue';
        // Opponent's side is the opposite of local side
        let oppIsRed = isLocalBlue;

        // --- Sync units ---
        let oppGroup = oppIsRed ? scene.eUnits : scene.pUnits;
        let receivedIds = [];

        state.units.forEach(du => {
            if (du._dying || du.isWarpingOut) {
                // Mark for death/destroy locally
                let existing = scene.findUnitById(du.unitId);
                if (existing && !existing._dying && !existing.isWarpingOut) {
                    existing.die(du.unitType);
                }
                return;
            }
            receivedIds.push(du.unitId);
            let existing = scene.findUnitById(du.unitId);
            if (existing) {
                // Update existing unit position/HP/state
                existing.x = du.x;
                existing.y = du.y;
                existing.health = du.health;
                if (du.maxHealth) existing.maxHealth = du.maxHealth;
                existing.setAlpha(du.alpha);
            } else {
                // Create new remote unit
                let texKey = du.unitType === 'inf' ? `inf_walk_${du.isRed ? 'red_' : ''}1`
                    : du.unitType === 'mm' ? `mm_walk_${du.isRed ? 'red_' : ''}1`
                    : du.unitType === 'ht' ? `ht_walk_${du.isRed ? 'red_' : ''}1`
                    : du.unitType === 'sn' ? `sn_walk_${du.isRed ? 'red_' : ''}1`
                    : du.unitType === 'en' ? `en_walk_${du.isRed ? 'red_' : ''}1`
                    : du.unitType === 'mn' ? `mn_walk_${du.isRed ? 'red_' : ''}1`
                    : `tank_walk_${du.isRed ? 'red_' : ''}1`;
                let lane = scene.lanes[du.laneIndex];
                let targetY = du.isRed ? lane.enemyY : lane.playerY;
                let isTank = du.unitType === 'st' || du.unitType === 'ht';
                let flipLikeTank = isTank || du.unitType === 'mn';
                let soldier = new Unit(scene, du.x, du.y, texKey, {
                    unitType: du.unitType, isRed: du.isRed,
                    laneIndex: du.laneIndex, unitId: du.unitId,
                    warpX: du.warpX, targetX: du.targetX, spawnX: du.spawnX
                });
                oppGroup.add(soldier);
                soldier.setAlpha(du.alpha);
                soldier.setFlipX(du.isRed ? !flipLikeTank : flipLikeTank);
                if (du.unitType === 'en') soldier._noWarp = true;
                if (du._trenchHold) soldier._trenchHold = true;
                if (du._trenchArrived) soldier._trenchArrived = true;
                if (du._hold) soldier._hold = true;
                if (!du._trenchHold && !du._hold && !du.isEngaging) {
                    soldier.play(soldier.getWalkAnim());
                    scene.physics.moveTo(soldier, du.targetX, targetY, UNIT_STATS[du.unitType].speed);
                }
            }
        });

        // Destroy opponent units not in received state
        if (oppGroup) {
            oppGroup.getChildren().forEach(u => {
                if (u._unitId > 0 && receivedIds.indexOf(u._unitId) === -1 && !u._dying && !u.isWarpingOut) {
                    u.die('unknown');
                }
            });
        }

        // --- Sync trenches ---
        if (state.trenches) {
            state.trenches.forEach(td => {
                let localTrench = scene.trenches.find(t => t.laneIndex === td.laneIndex && Math.abs(t.x - td.x) < 50);
                if (td.active) {
                    if (!localTrench) {
                        // Create trench locally
                        let trench = {
                            x: td.x, y: td.y, laneIndex: td.laneIndex,
                            ownerIsRed: td.ownerIsRed, hp: td.hp, maxHp: td.maxHp,
                            active: true, sprite: null, _building: false, _occCount: td._occCount || 0
                        };
                        if (!trench.sprite) {
                            trench.sprite = scene.add.image(trench.x, trench.y, 'trenchSprite').setOrigin(0.5).setDepth(2);
                            trench.sprite.setDisplaySize(35, 60);
                            trench.sprite.setAlpha(0.9);
                            trench.sprite.setInteractive();
                            trench.sprite.on('pointerdown', (ptr) => {
                                ptr.event.stopPropagation();
                                scene.selectTrench(trench);
                            });
                        }
                        scene.trenches.push(trench);
                    } else {
                        localTrench.hp = td.hp;
                        localTrench.maxHp = td.maxHp;
                        localTrench._occCount = td._occCount || 0;
                        localTrench.active = true;
                    }
                } else {
                    if (localTrench) {
                        localTrench.active = false;
                        if (localTrench.sprite) { localTrench.sprite.destroy(); localTrench.sprite = null; }
                        if (localTrench.hpBarBg) { localTrench.hpBarBg.destroy(); localTrench.hpBarBg = null; }
                        if (localTrench.hpBarFill) { localTrench.hpBarFill.destroy(); localTrench.hpBarFill = null; }
                    }
                }
            });
        }

        // --- Sync mines ---
        if (state.mines) {
            // Remove local mines not in state
            for (let mi = scene.mines.length - 1; mi >= 0; mi--) {
                let lm = scene.mines[mi];
                let found = state.mines.some(sm => Math.abs(sm.x - lm.x) < 20 && Math.abs(sm.y - lm.y) < 20 && sm._mineIsRed === lm._mineIsRed);
                if (!found) {
                    lm.destroy();
                    scene.mines.splice(mi, 1);
                }
            }
            // Add new mines
            state.mines.forEach(sm => {
                let found = scene.mines.some(lm => Math.abs(sm.x - lm.x) < 20 && Math.abs(sm.y - lm.y) < 20 && sm._mineIsRed === lm._mineIsRed);
                if (!found) {
                    let mineTex = sm._mineIsRed ? 'redMine' : 'blueMine';
                    let mine = scene.add.image(sm.x, sm.y, mineTex).setDepth(5).setDisplaySize(20, 16);
                    mine._mineOwner = null;
                    mine._mineIsRed = sm._mineIsRed;
                    scene.mines.push(mine);
                }
            });
        }
    }
}
