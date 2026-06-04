class Unit extends Phaser.Physics.Arcade.Sprite {
    constructor(scene, x, y, texture, config) {
        super(scene, x, y, texture);
        scene.add.existing(this);
        scene.physics.add.existing(this);

        this.unitType = config.unitType;
        this.isRed = config.isRed;
        this.laneIndex = config.laneIndex;
        this.warpX = config.warpX;
        this.targetX = config.targetX;
        this.spawnX = config.spawnX;
        this._unitId = config.unitId !== undefined ? config.unitId : -1;
        this.isEngaging = false;
        this.engagedEnemy = null;
        this.morphOutStarted = false;
        this.spawnFadeStarted = false;
        this._dying = false;
        this.isWarpingOut = false;
        this.lastFireTime = 0;
        this.shootAnimDone = true;
        this.morphTimer = null;
        this._hold = false;
        this._fallback = false;

        let stats = UNIT_STATS[config.unitType];
        this.health = stats.hp;
        this.maxHealth = stats.hp;
        this.eyeRange = stats.eyeRange;
        this.damage = stats.dmg;
        this.rechargeMs = stats.recharge;

        this.hpBarRevealed = false;
        this.hpBarBg = scene.add.rectangle(x, y - 34, 40, 5, 0x222222).setDepth(10).setAlpha(0);
        this.hpBarFill = scene.add.rectangle(x, y - 34, 38, 4, 0x00ff00).setDepth(11).setAlpha(0);

        this.setDisplaySize(stats.displayW, stats.displayH);
        if (this.unitType === 'ht') this.setScale(this.scaleX * 1.15, this.scaleY * 1.15);
        if (this.unitType === 'sn') this.setDisplaySize(86, 60);
        if (this.unitType === 'sn' && this.isRed) this.setDisplaySize(101, 62);
        this.setAlpha(0);
    }

    getAnimPrefix() {
        return this.unitType === 'st' ? 'tank' : (this.unitType === 'ht' ? 'heavyTank' : (this.unitType === 'mm' ? 'missile' : (this.unitType === 'sn' ? 'sniper' : (this.unitType === 'en' ? 'engineer' : (this.unitType === 'mn' ? 'miner' : 'infantry')))));
    }

    getAnimSuffix() {
        return this.isRed ? '_red_anim' : '_anim';
    }

    getWalkAnim() { return this.getAnimPrefix() + '_walk' + this.getAnimSuffix(); }
    getShootAnim() { return this.getAnimPrefix() + '_shoot' + this.getAnimSuffix(); }
    getCrouchAnim() { return this.getAnimPrefix() + '_crouch' + this.getAnimSuffix(); }
    getDeathAnim() { return this.getAnimPrefix() + '_death' + this.getAnimSuffix(); }
    getDeath2Anim() { return this.getAnimPrefix() + '_death_2' + this.getAnimSuffix(); }
    getTrenchAnim() { return this.getAnimPrefix() + '_trench' + this.getAnimSuffix(); }
    getPlantAnim() { return this.getAnimPrefix() + '_plant' + this.getAnimSuffix(); }

    updateHPBarPos() {
        if (this.hpBarBg && this.hpBarBg.active) {
            this.hpBarBg.x = this.x; this.hpBarBg.y = this.y - 34;
        }
        if (this.hpBarFill && this.hpBarFill.active) {
            this.hpBarFill.x = this.x; this.hpBarFill.y = this.y - 34;
        }
    }

    revealHPBar() {
        if (!this.hpBarRevealed) {
            this.hpBarRevealed = true;
            if (this.hpBarBg) this.hpBarBg.setAlpha(1);
            if (this.hpBarFill) this.hpBarFill.setAlpha(1);
        }
    }

    updateHPBarColor() {
        let ratio = Math.max(0, this.health / this.maxHealth);
        if (this.hpBarFill) {
            this.hpBarFill.width = 38 * ratio;
            this.hpBarFill.fillColor = ratio > 0.6 ? 0x00ff00 : (ratio > 0.3 ? 0xffff00 : 0xff0000);
        }
    }

    checkSpawnFade() {
        if (this.isWarpingOut || this.spawnFadeStarted || !this.spawnX) return;
        if (Math.abs(this.x - this.spawnX) >= SPAWN_FADE_DIST) {
            this.spawnFadeStarted = true;
            this.scene.tweens.add({ targets: this, alpha: 1, duration: SPAWN_FADE_DUR });
        }
    }

    checkMorphOut() {
        if (this.morphOutStarted || this.isEngaging || !this.targetX || this._noWarp || this._trenchHold) return;
        let dist = Math.abs(this.x - this.targetX);
        if (dist <= MORPH_DIST) {
            this.morphOutStarted = true;
            this.alpha = MORPH_ALPHA0;
            let stepCount = 0;
            this.morphTimer = this.scene.time.addEvent({
                delay: MORPH_DELAY, repeat: MORPH_REPEAT,
                callback: () => {
                    if (this.isEngaging) return;
                    stepCount++;
                    this.alpha = Math.max(0, MORPH_ALPHA0 - stepCount * MORPH_STEP);
                }
            });
        }
    }

    checkWarp() {
        if (this.isWarpingOut || this._noWarp) return;
        let reached = this.isRed ? (this.x <= this.warpX) : (this.x >= this.warpX);
        if (reached) {
            this.isWarpingOut = true;
            if (this.morphTimer) this.morphTimer.remove(false);
            if (this.hpBarBg) { this.hpBarBg.destroy(); this.hpBarBg = null; }
            if (this.hpBarFill) { this.hpBarFill.destroy(); this.hpBarFill = null; }
            this.destroy();
        }
    }

    die(shooterUnitType) {
        if (this._dying) return;
        this._dying = true;
        this.isWarpingOut = true;
        this.isEngaging = false;
        this.engagedEnemy = null;
        if (this.hpBarBg) { this.hpBarBg.destroy(); this.hpBarBg = null; }
        if (this.hpBarFill) { this.hpBarFill.destroy(); this.hpBarFill = null; }
        this.body.setVelocity(0, 0);
        this.body.moves = false;
        this.body.setAcceleration(0, 0);

        // Per-lane cleanup (st/ht/mn share the same counter)
        if (this.scene._tanksInLane && (this.unitType === 'st' || this.unitType === 'ht' || this.unitType === 'mn')) {
            this.scene._tanksInLane[this.laneIndex] = Math.max(0, (this.scene._tanksInLane[this.laneIndex] || 0) - 1);
        }
        if (this._trenchHold && this._trenchArrived) {
            let trench = (this.scene.trenches || []).find(t => t.active && t.ownerIsRed === this.isRed && t.laneIndex === this.laneIndex);
            if (trench) trench._occCount = Math.max(0, (trench._occCount || 0) - 1);
        }

        let scene = this.scene;
        let isTank = this.unitType === 'st' || this.unitType === 'ht';
        let shooterIsTank = shooterUnitType === 'st' || shooterUnitType === 'ht';
        if (this.unitType === 'mn') {
            scene.sound.play(shooterUnitType === 'mine' || shooterIsTank ? 'sfx_death_expl' : 'sfx_death_normal', { volume: 0.5 });
        } else if (isTank) {
            scene.sound.play('sfx_tank_death', { volume: 0.5 });
        } else if (shooterIsTank || shooterUnitType === 'mine') {
            scene.sound.play('sfx_death_expl', { volume: 0.5 });
        } else {
            scene.sound.play('sfx_death_normal', { volume: 0.5 });
        }

        if (isTank) {
            let deathKey = this.unitType === 'ht'
                ? (this.isRed ? 'heavyTank_death_red_anim' : 'heavyTank_death_anim')
                : (this.isRed ? 'tank_death_red_anim' : 'tank_death_anim');
            this.play(deathKey);
            this.anims.timeScale = 0.5;
            this.once('animationcomplete', () => {
                scene.time.addEvent({
                    delay: TANK_DEATH_WAIT,
                    callback: () => { if (this && this.active) this.destroy(); }
                });
            });
        } else {
            let isMM = this.unitType === 'mm';
            let isSniper = this.unitType === 'sn';
            let isEngineer = this.unitType === 'en';
            let isMiner = this.unitType === 'mn';
            let deathKey;
            if (isMiner) {
                deathKey = 'miner_death_anim';
            } else if (isSniper || isEngineer) {
                let prefix = isSniper ? 'sniper' : 'engineer';
                deathKey = this.isRed
                    ? (shooterIsTank ? `${prefix}_death_2_red_anim` : `${prefix}_death_1_red_anim`)
                    : (shooterIsTank ? `${prefix}_death_2_anim` : `${prefix}_death_1_anim`);
            } else {
                deathKey = this.isRed
                    ? (isMM ? (shooterIsTank ? 'missile_death_2_red_anim' : 'missile_death_red_anim')
                           : (shooterIsTank ? 'infantry_death_2_red_anim' : 'infantry_death_red_anim'))
                    : (isMM ? (shooterIsTank ? 'missile_death_2_anim' : 'missile_death_anim')
                           : (shooterIsTank ? 'infantry_death_2_anim' : 'infantry_death_anim'));
            }
            this.play(deathKey);
            this.once('animationcomplete', () => { if (this && this.active) this.destroy(); });
        }
    }

    hold() {
        if (this.unitType === 'en' || this.unitType === 'mn') return;
        this._hold = true;
        this._fallback = false;
        if (this.body && this.body.moves) {
            this.body.setVelocity(0, 0);
            this.body.moves = false;
        }
        if (!this.isEngaging) {
            this.play(this.getShootAnim());
            this.once('animationcomplete', () => { if (this._hold) this.stop(); });
        }
    }

    fallback() {
        if (this.unitType === 'en' || this.unitType === 'mn') return;
        this._fallback = true;
        this._hold = false;
        if (this.engagedEnemy) {
            this.engagedEnemy = null;
            this.isEngaging = false;
        }
        // Find nearest friendly trench behind this unit
        let scene = this.scene;
        let targetTrench = null;
        let minDist = Infinity;
        (scene.trenches || []).forEach(t => {
            if (!t.active || t.ownerIsRed !== this.isRed || t.laneIndex !== this.laneIndex) return;
            let isBehind = this.isRed ? (t.x < this.x) : (t.x > this.x);
            if (!isBehind) return;
            let d = Math.abs(t.x - this.x);
            if (d < minDist) { minDist = d; targetTrench = t; }
        });
        if (targetTrench) {
            this._trenchHold = true;
            this._trenchArrived = false;
            this._hold = false;
            let trenchStopX = this.isRed ? targetTrench.x + 30 : targetTrench.x - 30;
            this.targetX = trenchStopX;
            this.body.moves = true;
            scene.physics.moveTo(this, trenchStopX, this.y, UNIT_STATS[this.unitType].speed);
            this.play(this.getWalkAnim());
        } else {
            // No trench behind — stay in place
            if (this.body) { this.body.setVelocity(0, 0); this.body.moves = false; }
            this.play(this.getShootAnim());
            this.once('animationcomplete', () => { if (this._fallback) this.stop(); });
        }
    }

    jump() {
        this._hold = false;
        this._fallback = false;
        if (this._trenchQ) { this._trenchQ = false; }
        if (this._trenchHold && this._trenchArrived) {
            let ft = this.scene.trenches.find(t => t.active && t.ownerIsRed === this.isRed && t.laneIndex === this.laneIndex && t.x === this.targetX);
            if (ft) ft._occCount = Math.max(0, (ft._occCount || 1) - 1);
        }
        this._trenchHold = false;
        this._trenchArrived = false;
        this._trenchPassed = false;
        if (this.engagedEnemy) {
            this.engagedEnemy = null;
            this.isEngaging = false;
        }
        if (this.unitType === 'en') {
            let scene = this.scene;
            let orderedPositions = this.isRed ? [2400, 1600, 800] : [800, 1600, 2400];
            let nextPos = null;
            for (let pos of orderedPositions) {
                let alreadyBuilt = (scene.trenches || []).some(t => t.active && t.laneIndex === this.laneIndex && Math.abs(t.x - pos) < 50);
                if (!alreadyBuilt) { nextPos = pos; break; }
            }
            if (nextPos !== null) {
                this.targetX = nextPos;
                this._noWarp = true;
                this._enReadyToBuild = false;
                this._enBuilt = false;
                this._enCrouchStarted = false;
                this.body.moves = true;
                scene.physics.moveTo(this, nextPos, this.y, UNIT_STATS.en.speed);
                this.play(this.getWalkAnim());
                return;
            }
        }
        this._noWarp = false;
        this.targetX = this.warpX;
        this.body.moves = true;
        this.scene.physics.moveTo(this, this.targetX, this.y, UNIT_STATS[this.unitType].speed);
        this.play(this.getWalkAnim());
    }

    destroy(fromScene) {
        if (this.hpBarBg) { this.hpBarBg.destroy(); this.hpBarBg = null; }
        if (this.hpBarFill) { this.hpBarFill.destroy(); this.hpBarFill = null; }
        super.destroy(fromScene);
    }
}
