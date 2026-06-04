class GameScene extends Phaser.Scene {
    constructor() {
        super({ key: 'GameScene' });
        this.debugMode = true;
    }

    create() {
        let centerY = window.innerHeight / 2;
        let offset = centerY - 300;
        this.lanes = [
            { enemyX: 255, enemyY: 250 + offset, playerX: TERRAIN_W - 255, playerY: 250 + offset },
            { enemyX: 220, enemyY: 320 + offset, playerX: TERRAIN_W - 220, playerY: 320 + offset },
            { enemyX: 180, enemyY: 383 + offset, playerX: TERRAIN_W - 180, playerY: 383 + offset },
            { enemyX: 140, enemyY: 466 + offset, playerX: TERRAIN_W - 140, playerY: 466 + offset },
            { enemyX: 105, enemyY: 535 + offset, playerX: TERRAIN_W - 105, playerY: 535 + offset }
        ];

        this.laneBounds = [];
        for (let i = 0; i < 5; i++) {
            let top = i === 0 ? -Infinity : (this.lanes[i - 1].enemyY + this.lanes[i].enemyY) / 2;
            let bottom = i === 4 ? Infinity : (this.lanes[i].enemyY + this.lanes[i + 1].enemyY) / 2;
            this.laneBounds.push({ top, bottom });
        }

        // --- ANIMATIONS ---
        let walkFrames = [];
        for (let i = 1; i <= 20; i++) walkFrames.push({ key: `inf_walk_${i}` });
        this.anims.create({ key: 'infantry_walk_anim', frames: walkFrames, frameRate: 20, repeat: -1 });
        let walkRedFrames = [];
        for (let i = 1; i <= 20; i++) walkRedFrames.push({ key: `inf_walk_red_${i}` });
        this.anims.create({ key: 'infantry_walk_red_anim', frames: walkRedFrames, frameRate: 20, repeat: -1 });
        let shootFrames = [];
        for (let i = 1; i <= 21; i++) shootFrames.push({ key: `inf_shoot_${i}` });
        this.anims.create({ key: 'infantry_shoot_anim', frames: shootFrames, frameRate: 21, repeat: 0 });
        let shootRedFrames = [];
        for (let i = 1; i <= 21; i++) shootRedFrames.push({ key: `inf_shoot_red_${i}` });
        this.anims.create({ key: 'infantry_shoot_red_anim', frames: shootRedFrames, frameRate: 21, repeat: 0 });
        let crouchFrames = [];
        for (let i = 1; i <= 15; i++) crouchFrames.push({ key: `inf_crouch_${i}` });
        this.anims.create({ key: 'infantry_crouch_anim', frames: crouchFrames, frameRate: 10, repeat: -1 });
        let crouchRedFrames = [];
        for (let i = 1; i <= 15; i++) crouchRedFrames.push({ key: `inf_crouch_red_${i}` });
        this.anims.create({ key: 'infantry_crouch_red_anim', frames: crouchRedFrames, frameRate: 10, repeat: -1 });
        let impactFrames = [];
        for (let i = 1; i <= 20; i++) impactFrames.push({ key: `bulletImpact_${i}` });
        this.anims.create({ key: 'bullet_impact_anim', frames: impactFrames, frameRate: 20, repeat: 0 });
        let deathFrames = [];
        for (let i = 1; i <= 111; i++) deathFrames.push({ key: `inf_death_${i}` });
        this.anims.create({ key: 'infantry_death_anim', frames: deathFrames, frameRate: 15, repeat: 0 });
        let deathRedFrames = [];
        for (let i = 1; i <= 112; i++) deathRedFrames.push({ key: `inf_death_red_${i}` });
        this.anims.create({ key: 'infantry_death_red_anim', frames: deathRedFrames, frameRate: 15, repeat: 0 });
        let death2Frames = [];
        for (let i = 1; i <= 126; i++) death2Frames.push({ key: `inf_death_2_${i}` });
        this.anims.create({ key: 'infantry_death_2_anim', frames: death2Frames, frameRate: 15, repeat: 0 });
        let death2RedFrames = [];
        for (let i = 1; i <= 126; i++) death2RedFrames.push({ key: `inf_death_red_2_${i}` });
        this.anims.create({ key: 'infantry_death_2_red_anim', frames: death2RedFrames, frameRate: 15, repeat: 0 });
        let mmWalkFrames = [];
        for (let i = 1; i <= 20; i++) mmWalkFrames.push({ key: `mm_walk_${i}` });
        this.anims.create({ key: 'missile_walk_anim', frames: mmWalkFrames, frameRate: 20, repeat: -1 });
        let mmWalkRedFrames = [];
        for (let i = 1; i <= 20; i++) mmWalkRedFrames.push({ key: `mm_walk_red_${i}` });
        this.anims.create({ key: 'missile_walk_red_anim', frames: mmWalkRedFrames, frameRate: 20, repeat: -1 });
        let mmShootFrames = [];
        for (let i = 1; i <= 21; i++) mmShootFrames.push({ key: `mm_shoot_${i}` });
        this.anims.create({ key: 'missile_shoot_anim', frames: mmShootFrames, frameRate: 21, repeat: 0 });
        let mmShootRedFrames = [];
        for (let i = 1; i <= 21; i++) mmShootRedFrames.push({ key: `mm_shoot_red_${i}` });
        this.anims.create({ key: 'missile_shoot_red_anim', frames: mmShootRedFrames, frameRate: 21, repeat: 0 });
        let mmCrouchFrames = [];
        for (let i = 1; i <= 13; i++) mmCrouchFrames.push({ key: `mm_crouch_${i}` });
        this.anims.create({ key: 'missile_crouch_anim', frames: mmCrouchFrames, frameRate: 15, repeat: -1 });
        let mmCrouchRedFrames = [];
        for (let i = 1; i <= 13; i++) mmCrouchRedFrames.push({ key: `mm_crouch_red_${i}` });
        this.anims.create({ key: 'missile_crouch_red_anim', frames: mmCrouchRedFrames, frameRate: 15, repeat: -1 });
        let mmDeathFrames = [];
        for (let i = 1; i <= 112; i++) mmDeathFrames.push({ key: `mm_death_${i}` });
        this.anims.create({ key: 'missile_death_anim', frames: mmDeathFrames, frameRate: 15, repeat: 0 });
        let mmDeathRedFrames = [];
        for (let i = 1; i <= 111; i++) mmDeathRedFrames.push({ key: `mm_death_red_${i}` });
        this.anims.create({ key: 'missile_death_red_anim', frames: mmDeathRedFrames, frameRate: 15, repeat: 0 });
        let mmDeath2Frames = [];
        for (let i = 1; i <= 126; i++) mmDeath2Frames.push({ key: `mm_death_2_${i}` });
        this.anims.create({ key: 'missile_death_2_anim', frames: mmDeath2Frames, frameRate: 15, repeat: 0 });
        let mmDeathRed2Frames = [];
        for (let i = 1; i <= 126; i++) mmDeathRed2Frames.push({ key: `mm_death_red_2_${i}` });
        this.anims.create({ key: 'missile_death_2_red_anim', frames: mmDeathRed2Frames, frameRate: 15, repeat: 0 });
        let mmImpactFrames = [];
        for (let i = 1; i <= 31; i++) mmImpactFrames.push({ key: `mm_impact_${i}` });
        this.anims.create({ key: 'missile_impact_anim', frames: mmImpactFrames, frameRate: 20, repeat: 0 });
        let tankWalkFrames = [];
        for (let i = 1; i <= 60; i++) tankWalkFrames.push({ key: `tank_walk_${i}` });
        this.anims.create({ key: 'tank_walk_anim', frames: tankWalkFrames, frameRate: 10, repeat: -1 });
        let tankWalkRedFrames = [];
        for (let i = 1; i <= 60; i++) tankWalkRedFrames.push({ key: `tank_walk_red_${i}` });
        this.anims.create({ key: 'tank_walk_red_anim', frames: tankWalkRedFrames, frameRate: 10, repeat: -1 });
        let tankShootFrames = [];
        for (let i = 1; i <= 21; i++) tankShootFrames.push({ key: `tank_shoot_${i}` });
        this.anims.create({ key: 'tank_shoot_anim', frames: tankShootFrames, frameRate: 21, repeat: 0 });
        let tankShootRedFrames = [];
        for (let i = 1; i <= 21; i++) tankShootRedFrames.push({ key: `tank_shoot_red_${i}` });
        this.anims.create({ key: 'tank_shoot_red_anim', frames: tankShootRedFrames, frameRate: 21, repeat: 0 });
        let tankDeathFrames = [];
        for (let i = 1; i <= 20; i++) tankDeathFrames.push({ key: `tank_death_${i}` });
        this.anims.create({ key: 'tank_death_anim', frames: tankDeathFrames, frameRate: 15, repeat: 0 });
        let tankDeathRedFrames = [];
        for (let i = 1; i <= 20; i++) tankDeathRedFrames.push({ key: `tank_death_red_${i}` });
        this.anims.create({ key: 'tank_death_red_anim', frames: tankDeathRedFrames, frameRate: 15, repeat: 0 });
        let tankImpactFrames = [];
        for (let i = 1; i <= 36; i++) tankImpactFrames.push({ key: `tank_impact_${i}` });
        this.anims.create({ key: 'tank_impact_anim', frames: tankImpactFrames, frameRate: 20, repeat: 0 });
        let htWalkFrames = [];
        for (let i = 1; i <= 60; i++) htWalkFrames.push({ key: `ht_walk_${i}` });
        this.anims.create({ key: 'heavyTank_walk_anim', frames: htWalkFrames, frameRate: 10, repeat: -1 });
        let htWalkRedFrames = [];
        for (let i = 1; i <= 60; i++) htWalkRedFrames.push({ key: `ht_walk_red_${i}` });
        this.anims.create({ key: 'heavyTank_walk_red_anim', frames: htWalkRedFrames, frameRate: 10, repeat: -1 });
        let htShootFrames = [];
        for (let i = 1; i <= 21; i++) htShootFrames.push({ key: `ht_shoot_${i}` });
        this.anims.create({ key: 'heavyTank_shoot_anim', frames: htShootFrames, frameRate: 21, repeat: 0 });
        let htShootRedFrames = [];
        for (let i = 1; i <= 21; i++) htShootRedFrames.push({ key: `ht_shoot_red_${i}` });
        this.anims.create({ key: 'heavyTank_shoot_red_anim', frames: htShootRedFrames, frameRate: 21, repeat: 0 });
        let htDeathFrames = [];
        for (let i = 1; i <= 19; i++) htDeathFrames.push({ key: `ht_death_${i}` });
        this.anims.create({ key: 'heavyTank_death_anim', frames: htDeathFrames, frameRate: 15, repeat: 0 });
        let htDeathRedFrames = [];
        for (let i = 1; i <= 19; i++) htDeathRedFrames.push({ key: `ht_death_${i}` });
        this.anims.create({ key: 'heavyTank_death_red_anim', frames: htDeathRedFrames, frameRate: 15, repeat: 0 });

        // --- Sniper Animations ---
        let snWalkFrames = [];
        for (let i = 1; i <= 20; i++) snWalkFrames.push({ key: `sn_walk_${i}` });
        this.anims.create({ key: 'sniper_walk_anim', frames: snWalkFrames, frameRate: 20, repeat: -1 });
        let snWalkRedFrames = [];
        for (let i = 1; i <= 20; i++) snWalkRedFrames.push({ key: `sn_walk_red_${i}` });
        this.anims.create({ key: 'sniper_walk_red_anim', frames: snWalkRedFrames, frameRate: 20, repeat: -1 });
        let snShootFrames = [];
        for (let i = 1; i <= 15; i++) snShootFrames.push({ key: `sn_shoot_${i}` });
        this.anims.create({ key: 'sniper_shoot_anim', frames: snShootFrames, frameRate: 15, repeat: 0 });
        let snShootRedFrames = [];
        for (let i = 1; i <= 15; i++) snShootRedFrames.push({ key: `sn_shoot_red_${i}` });
        this.anims.create({ key: 'sniper_shoot_red_anim', frames: snShootRedFrames, frameRate: 15, repeat: 0 });
        let snCrouchFrames = [];
        for (let i = 1; i <= 21; i++) snCrouchFrames.push({ key: `sn_crouch_${i}` });
        this.anims.create({ key: 'sniper_crouch_anim', frames: snCrouchFrames, frameRate: 10, repeat: 0 });
        let snCrouchRedFrames = [];
        for (let i = 1; i <= 21; i++) snCrouchRedFrames.push({ key: `sn_crouch_red_${i}` });
        this.anims.create({ key: 'sniper_crouch_red_anim', frames: snCrouchRedFrames, frameRate: 10, repeat: 0 });
        let snDeath1Frames = [];
        for (let i = 1; i <= 111; i++) snDeath1Frames.push({ key: `sn_death_1_${i}` });
        this.anims.create({ key: 'sniper_death_1_anim', frames: snDeath1Frames, frameRate: 15, repeat: 0 });
        let snDeathRed1Frames = [];
        for (let i = 1; i <= 112; i++) snDeathRed1Frames.push({ key: `sn_death_red_1_${i}` });
        this.anims.create({ key: 'sniper_death_1_red_anim', frames: snDeathRed1Frames, frameRate: 15, repeat: 0 });
        let snDeath2Frames = [];
        for (let i = 1; i <= 126; i++) snDeath2Frames.push({ key: `sn_death_2_${i}` });
        this.anims.create({ key: 'sniper_death_2_anim', frames: snDeath2Frames, frameRate: 15, repeat: 0 });
        let snDeathRed2Frames = [];
        for (let i = 1; i <= 126; i++) snDeathRed2Frames.push({ key: `sn_death_red_2_${i}` });
        this.anims.create({ key: 'sniper_death_2_red_anim', frames: snDeathRed2Frames, frameRate: 15, repeat: 0 });

        // --- Engineer Animations ---
        let enWalkFrames = [];
        for (let i = 1; i <= 20; i++) enWalkFrames.push({ key: `en_walk_${i}` });
        this.anims.create({ key: 'engineer_walk_anim', frames: enWalkFrames, frameRate: 20, repeat: -1 });
        let enWalkRedFrames = [];
        for (let i = 1; i <= 20; i++) enWalkRedFrames.push({ key: `en_walk_red_${i}` });
        this.anims.create({ key: 'engineer_walk_red_anim', frames: enWalkRedFrames, frameRate: 20, repeat: -1 });
        let enCrouchFrames = [];
        for (let i = 1; i <= 21; i++) enCrouchFrames.push({ key: `en_crouch_${i}` });
        this.anims.create({ key: 'engineer_crouch_anim', frames: enCrouchFrames, frameRate: 10, repeat: 0 });
        let enCrouchRedFrames = [];
        for (let i = 1; i <= 21; i++) enCrouchRedFrames.push({ key: `en_crouch_red_${i}` });
        this.anims.create({ key: 'engineer_crouch_red_anim', frames: enCrouchRedFrames, frameRate: 10, repeat: 0 });
        let enTrenchFrames = [];
        for (let i = 1; i <= 15; i++) enTrenchFrames.push({ key: `en_trench_${i}` });
        this.anims.create({ key: 'engineer_trench_anim', frames: enTrenchFrames, frameRate: 15, repeat: 0 });
        let enTrenchRedFrames = [];
        for (let i = 1; i <= 15; i++) enTrenchRedFrames.push({ key: `en_trench_red_${i}` });
        this.anims.create({ key: 'engineer_trench_red_anim', frames: enTrenchRedFrames, frameRate: 15, repeat: 0 });
        let enDeath1Frames = [];
        for (let i = 1; i <= 111; i++) enDeath1Frames.push({ key: `en_death_1_${i}` });
        this.anims.create({ key: 'engineer_death_1_anim', frames: enDeath1Frames, frameRate: 15, repeat: 0 });
        let enDeathRed1Frames = [];
        for (let i = 1; i <= 112; i++) enDeathRed1Frames.push({ key: `en_death_red_1_${i}` });
        this.anims.create({ key: 'engineer_death_1_red_anim', frames: enDeathRed1Frames, frameRate: 15, repeat: 0 });
        let enDeath2Frames = [];
        for (let i = 1; i <= 126; i++) enDeath2Frames.push({ key: `en_death_2_${i}` });
        this.anims.create({ key: 'engineer_death_2_anim', frames: enDeath2Frames, frameRate: 15, repeat: 0 });
        let enDeathRed2Frames = [];
        for (let i = 1; i <= 126; i++) enDeathRed2Frames.push({ key: `en_death_red_2_${i}` });
        this.anims.create({ key: 'engineer_death_2_red_anim', frames: enDeathRed2Frames, frameRate: 15, repeat: 0 });

        // --- Miner Animations ---
        let mnWalkFrames = [];
        for (let i = 1; i <= 20; i++) mnWalkFrames.push({ key: `mn_walk_${i}` });
        this.anims.create({ key: 'miner_walk_anim', frames: mnWalkFrames, frameRate: 20, repeat: -1 });
        let mnWalkRedFrames = [];
        for (let i = 1; i <= 20; i++) mnWalkRedFrames.push({ key: `mn_walk_red_${i}` });
        this.anims.create({ key: 'miner_walk_red_anim', frames: mnWalkRedFrames, frameRate: 20, repeat: -1 });
        let mnPlantFrames = [];
        for (let i = 1; i <= 16; i++) mnPlantFrames.push({ key: `mn_plant_${i}` });
        this.anims.create({ key: 'miner_plant_anim', frames: mnPlantFrames, frameRate: 8, repeat: 0 });
        let mnPlantRedFrames = [];
        for (let i = 1; i <= 16; i++) mnPlantRedFrames.push({ key: `mn_plant_red_${i}` });
        this.anims.create({ key: 'miner_plant_red_anim', frames: mnPlantRedFrames, frameRate: 8, repeat: 0 });
        let mnDeathFrames = [];
        for (let i = 1; i <= 18; i++) mnDeathFrames.push({ key: `mn_death_${i}` });
        this.anims.create({ key: 'miner_death_anim', frames: mnDeathFrames, frameRate: 15, repeat: 0 });

        // --- Mine Explosion Animation ---
        let mineExplosionFrames = [];
        for (let i = 1; i <= 37; i++) mineExplosionFrames.push({ key: `mineExplosion_${i}` });
        this.anims.create({ key: 'mine_explosion_anim', frames: mineExplosionFrames, frameRate: 20, repeat: 0 });

        this.pUnits = this.physics.add.group();
        this.eUnits = this.physics.add.group();
        this.bulletGroup = this.physics.add.group();
        this.selectedLane = 0;

        // --- ENVIRONMENT ---
        let sky = this.add.image(0, centerY, 'sky').setOrigin(0, 0.5).setScrollFactor(0);
        sky.setDisplaySize(window.innerWidth, window.innerHeight);
        let terrain = this.add.image(0, centerY, 'terrain').setOrigin(0, 0.5);
        terrain.setDisplaySize(TERRAIN_W, 600);
        this.cameras.main.setBounds(0, 0, TERRAIN_W, window.innerHeight);
        this.physics.world.setBounds(0, 0, TERRAIN_W, window.innerHeight);
        let baseDistance = 900;
        let leftBase = this.add.image(baseDistance, centerY + 80, 'masterBases');
        leftBase.setCrop(leftBase.width / 2, 0, leftBase.width / 2, leftBase.height);
        leftBase.setScale(-1.8, 1.4);
        let rightBase = this.add.image(TERRAIN_W - baseDistance, centerY + 80, 'masterBases');
        rightBase.setCrop(0, 0, rightBase.width / 2, rightBase.height);
        rightBase.setScale(-1.8, 1.4);

        // --- DOOR ZONES + SPAWN ARROWS ---
        let debugGraphics = this.add.graphics();
        if (this.debugMode) {
            debugGraphics.lineStyle(2, 0x00ff00, 0.5);
        }
        let doorMarkers = this.add.graphics();
        doorMarkers.lineStyle(2, 0x00ffff, 0.8);
        this.doorZones = [];
        this.spawnArrows = [];
        let gameScene = this;

        for (let i = 0; i < 5; i++) {
            let lane = this.lanes[i];
            if (this.debugMode) {
                debugGraphics.strokeLineShape(new Phaser.Geom.Line(lane.enemyX, lane.enemyY, lane.playerX, lane.playerY));
                debugGraphics.fillStyle(0x00ff00, 0.8);
                debugGraphics.fillCircle(lane.enemyX, lane.enemyY, 5);
                debugGraphics.fillCircle(lane.playerX, lane.playerY, 5);
            }
            [-1, 1].forEach(side => {
                let x = side === -1 ? lane.enemyX + 130 : lane.playerX - 130;
                let y = side === -1 ? lane.enemyY : lane.playerY;
                doorMarkers.strokeLineShape(new Phaser.Geom.Line(x - 8, y, x + 8, y));
                doorMarkers.strokeLineShape(new Phaser.Geom.Line(x, y - 8, x, y + 8));
            });

            let pDoorZone = this.add.rectangle(lane.enemyX, lane.enemyY, 28, 20, 0x00ffcc, 0.4);
            pDoorZone.setInteractive(new Phaser.Geom.Rectangle(-14, -10, 28, 20), Phaser.Geom.Rectangle.Contains);
            pDoorZone.setData('laneIdx', i);
            pDoorZone.on('pointerdown', function() { gameScene.handleDoorClick(this.getData('laneIdx'), false); });
            let eDoorZone = this.add.rectangle(lane.playerX, lane.playerY, 28, 20, 0xff4444, 0.3).setDepth(1);
            eDoorZone.setInteractive(new Phaser.Geom.Rectangle(-14, -10, 28, 20), Phaser.Geom.Rectangle.Contains);
            eDoorZone.setData('laneIdx', i);
            eDoorZone.on('pointerdown', function() { gameScene.handleDoorClick(this.getData('laneIdx'), true); });
            this.doorZones.push({ player: pDoorZone, enemy: eDoorZone });

            let eArrow = this.add.image(lane.enemyX + 130, lane.enemyY, 'spawnArrow').setDepth(5).setAlpha(0).setScale(1.5).setOrigin(0, 0.5);
            let pArrow = this.add.image(lane.playerX - 130, lane.playerY, 'spawnArrow').setDepth(5).setAlpha(0).setScale(1.5).setFlipX(true).setOrigin(1, 0.5);
            this.spawnArrows.push(eArrow, pArrow);
        }

        // Highlight initial lane 0
        if (this.doorZones[0]) {
            if (this.doorZones[0].player) { this.doorZones[0].player.fillColor = 0x00ffff; this.doorZones[0].player.fillAlpha = 0.8; }
            if (this.doorZones[0].enemy) { this.doorZones[0].enemy.fillColor = 0x00ffff; this.doorZones[0].enemy.fillAlpha = 0.8; }
        }

        // --- CAMERA CONTROLS ---
        this.cursors = this.input.keyboard.createCursorKeys();
        this.keys = this.input.keyboard.addKeys('A,D');
        this.input.on('wheel', (pointer, gameObjects, deltaX, deltaY, deltaZ) => {
            let cam = this.cameras.main;
            let newZoom = cam.zoom - (deltaY * 0.001);
            cam.zoom = Phaser.Math.Clamp(newZoom, 1.0, 2.0);
        });

        // --- Trench positions (per-lane, built by engineer) ---
        this.trenchPositions = [{ x: 800 }, { x: 1600 }, { x: 2400 }];
        this.trenches = []; // each: { x, y, laneIndex, hp, maxHp, active, sprite }
        this._trenchMarker = this.add.text(0, 0, '!', {
            fontSize: '40px', color: '#ffff00', fontFamily: 'Arial',
            stroke: '#000000', strokeThickness: 4
        }).setOrigin(0.5).setDepth(10).setAlpha(0);

        // --- Command selection ---
        this.selectedUnit = null;
        this._selectedUnits = [];
        this._shiftKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SHIFT);
        this._nextUnitId = 1;
        this.input.on('pointerdown', (ptr, gameObjects) => {
            if (ptr.leftButtonDown() && gameObjects.length === 0) this.clearSelection();
        });

        // Command keyboard shortcuts
        this.input.keyboard.on('keydown-H', () => this.cmdHold());
        this.input.keyboard.on('keydown-F', () => this.cmdFallback());
        this.input.keyboard.on('keydown-J', () => this.cmdJump());
        this.input.keyboard.on('keydown-B', () => this.cmdBuildTrench());
        this.input.keyboard.on('keydown-D', () => this.cmdDestroyTrench());
        this.input.keyboard.on('keydown-ESC', () => this.clearSelection());

        // --- Mine tracking ---
        this.mines = [];
        this._tanksInLane = [0, 0, 0, 0, 0];

        // AI economy and deployment
        this.aiCredits = 200;
        this.aiDeployTimer = 0;

        // Multiplayer networking
        this.network = null;
        let gameMode = this.registry.get('gameMode') || 'singlePlayer';
        if (gameMode === 'multiplayer') {
            this.network = new NetworkManager(this);
            let roomId = this.registry.get('roomCode');
            let isHost = this.registry.get('playerSide') === 'blue';
            this.network.connect(roomId, isHost);
            // Listen for game events from opponent
            let scene = this;
            this.network.onGameEvent = function(eventName, data) {
                scene.handleNetworkEvent(eventName, data);
            };
        }

        // Launch UI overlay scene after assets are ready
        this.scene.launch('UIScene');
    }

    handleDoorClick(laneIndex, isEnemyDoor) {
        let armedUnit = this.registry.get('armedUnit');
        if (!armedUnit) return;
        let isRed = UNIT_IS_RED[armedUnit];
        // LEFT door = blue only; RIGHT door = red only
        if (isRed !== isEnemyDoor) return;
        let unitType = UNIT_TYPE_FROM_NAME[armedUnit];
        let cost = UNIT_COST[armedUnit];
        let stats = UNIT_STATS[unitType];

        // Use separate credit pools: aiCredits for AI (single-player red), player credits otherwise
        let gameMode = this.registry.get('gameMode') || 'singlePlayer';
        let useAiCredits = isEnemyDoor && gameMode !== 'multiplayer';
        let credits = useAiCredits ? this.aiCredits : this.registry.get('credits');

        if (credits < cost) {
            let doorZone = this.doorZones[laneIndex][isEnemyDoor ? 'enemy' : 'player'];
            doorZone.fillAlpha = 0.8;
            doorZone.fillColor = useAiCredits ? 0xff0000 : 0xff0000;
            this.time.delayedCall(200, () => {
                if (!doorZone.active) return;
                doorZone.fillColor = 0x00ffcc;
                doorZone.fillAlpha = 0.4;
            });
            return;
        }

        // Per-lane limits
        let lane = this.lanes[laneIndex];
        let spawnX = isEnemyDoor ? lane.playerX : lane.enemyX;

        if (unitType === 'st' || unitType === 'ht' || unitType === 'mn') {
            let hasTrench = this.trenches.some(t => t.active && t.laneIndex === laneIndex);
            let limit = hasTrench ? 1 : 2;
            let currentCount = (this._tanksInLane[laneIndex] || 0);
            if (currentCount >= limit) return;
            this._tanksInLane[laneIndex] = (this._tanksInLane[laneIndex] || 0) + 1;
        }

        if (useAiCredits) {
            this.aiCredits = credits - cost;
        } else {
            this.registry.set('credits', credits - cost);
        }

        let spawnY = isEnemyDoor ? lane.playerY : lane.enemyY;
        let targetX = isEnemyDoor ? lane.enemyX : lane.playerX;
        let warpX = targetX;
        let targetY = isEnemyDoor ? lane.enemyY : lane.playerY;
        let group = isEnemyDoor ? this.eUnits : this.pUnits;

        let texKey = unitType === 'inf' ? `inf_walk_${isRed ? 'red_' : ''}1`
                   : unitType === 'mm' ? `mm_walk_${isRed ? 'red_' : ''}1`
                   : unitType === 'ht' ? `ht_walk_${isRed ? 'red_' : ''}1`
                   : unitType === 'sn' ? `sn_walk_${isRed ? 'red_' : ''}1`
                   : unitType === 'en' ? `en_walk_${isRed ? 'red_' : ''}1`
                   : unitType === 'mn' ? `mn_walk_${isRed ? 'red_' : ''}1`
                   : `tank_walk_${isRed ? 'red_' : ''}1`;

        // Engineer override: set target to nearest forward trench
        if (unitType === 'en') {
            let orderedPositions = isRed ? [2400, 1600, 800] : [800, 1600, 2400];
            let trenchTarget = null;
            for (let pos of orderedPositions) {
                let alreadyBuilt = this.trenches.some(t => t.active && t.laneIndex === laneIndex && Math.abs(t.x - pos) < 50);
                if (!alreadyBuilt) { trenchTarget = pos; break; }
            }
            if (trenchTarget !== null) targetX = trenchTarget;
        }

        let unitId = this._nextUnitId++;
        let soldier = new Unit(this, spawnX, spawnY, texKey, {
            unitType, isRed, laneIndex, unitId,
            warpX: warpX, targetX: targetX, spawnX: spawnX
        });
        group.add(soldier);

        let isTank = unitType === 'st' || unitType === 'ht';
        let flipLikeTank = isTank || unitType === 'mn';
        if (isEnemyDoor) {
            soldier.setFlipX(!flipLikeTank);
        } else {
            soldier.setFlipX(flipLikeTank);
        }

        // Engineer never warps — set immediately
        if (unitType === 'en') soldier._noWarp = true;

        // Non-tank/non-specialist units hold at friendly trench if available
        if (!isTank && unitType !== 'en' && unitType !== 'mn') {
            let friendlyTrench = this.trenches.find(t => t.active && t.ownerIsRed === isRed && t.laneIndex === laneIndex && (t._occCount || 0) < 3);
            if (friendlyTrench) {
                let trenchStopX = isRed ? friendlyTrench.x + 30 : friendlyTrench.x - 30;
                soldier.targetX = trenchStopX;
                soldier._trenchHold = true;
                this.physics.moveTo(soldier, trenchStopX, soldier.y, UNIT_STATS[unitType].speed);
                soldier.play(soldier.getWalkAnim());
            }
        }

        if (!soldier._trenchHold) {
            soldier.play(soldier.getWalkAnim());
            this.physics.moveTo(soldier, targetX, targetY, UNIT_STATS[unitType].speed);
        }

        // Multiplayer: send deploy event to opponent
        if (this.network && this.network.connected) {
            let isLocallyControlled = isEnemyDoor ? (gameMode === 'multiplayer' && !isRed) : (gameMode !== 'multiplayer' || isRed === false);
            if (isLocallyControlled) {
                this.network.sendGameEvent('unitDeploy', {
                    unitId: unitId, unitType: unitType, isRed: isRed,
                    laneIndex: laneIndex, spawnX: spawnX, targetX: soldier.targetX, targetY: targetY,
                    warpX: warpX, x: spawnX, y: spawnY, texKey: texKey,
                    isTank: isTank, flipLikeTank: flipLikeTank,
                    _trenchHold: soldier._trenchHold || false, isEnemyDoor: isEnemyDoor
                });
            }
        }

        // Click to select
        soldier.setInteractive();
        soldier.on('pointerdown', (ptr) => {
            ptr.event.stopPropagation();
            this.selectUnit(soldier);
        });
    }

    cycleLane(direction) {
        let armedUnit = this.registry.get('armedUnit');
        if (!armedUnit) return;
        this.selectedLane = (this.selectedLane + direction + 5) % 5;
        this.updateSpawnArrows();
        this.doorZones.forEach((z, i) => {
            if (z.player) { z.player.fillColor = i === this.selectedLane ? 0x00ffff : 0x00ffcc; z.player.fillAlpha = i === this.selectedLane ? 0.8 : 0.4; }
            if (z.enemy) { z.enemy.fillColor = i === this.selectedLane ? 0x00ffff : 0x00ffcc; z.enemy.fillAlpha = i === this.selectedLane ? 0.8 : 0.4; }
        });
    }

    deployAtNearestLane() {
        let armedUnit = this.registry.get('armedUnit');
        if (!armedUnit) return;
        let isRed = UNIT_IS_RED[armedUnit];
        let zone = this.doorZones[this.selectedLane][isRed ? 'enemy' : 'player'];
        if (zone) zone.emit('pointerdown');
    }

    updateSpawnArrows() {
        let armedUnit = this.registry.get('armedUnit');
        let show = armedUnit !== null;
        let isRed = show ? UNIT_IS_RED[armedUnit] : false;
        this.spawnArrows.forEach((a, idx) => {
            let laneIdx = Math.floor(idx / 2);
            let isRightSide = idx % 2 === 1;
            if (!show || laneIdx !== this.selectedLane || isRed !== isRightSide) {
                a.setAlpha(0);
            } else if (a.alpha === 0) {
                a.setAlpha(1);
                a.setScale(0.01);
                this.tweens.add({ targets: a, scaleX: 1.5, scaleY: 1.5, duration: 300, ease: 'Back.easeOut' });
            }
        });
        this.updateTrenchMarker();
    }

    updateTrenchMarker() {
        let armedUnit = this.registry.get('armedUnit');
        let show = armedUnit !== null && (armedUnit === 'engineer' || armedUnit === 'engineer_red');
        if (!show) {
            this._trenchMarker.setAlpha(0);
            return;
        }
        let isRed = UNIT_IS_RED[armedUnit];
        let orderedPositions = isRed ? [2400, 1600, 800] : [800, 1600, 2400];
        let nextX = null;
        for (let pos of orderedPositions) {
            let alreadyBuilt = this.trenches.some(t => t.active && t.laneIndex === this.selectedLane && Math.abs(t.x - pos) < 10);
            if (!alreadyBuilt) { nextX = pos; break; }
        }
        if (nextX === null) { this._trenchMarker.setAlpha(0); return; }
        let lane = this.lanes[this.selectedLane];
        let laneY = isRed ? lane.enemyY : lane.playerY;
        this._trenchMarker.setPosition(nextX, laneY - 100);
        if (this._trenchMarker.alpha === 0) {
            this._trenchMarker.setAlpha(1);
            this._trenchMarker.setScale(0.01);
            this.tweens.add({ targets: this._trenchMarker, scaleX: 1, scaleY: 1, duration: 300, ease: 'Back.easeOut' });
        }
    }

    selectUnit(unit) {
        if (this._shiftKey.isDown) {
            let idx = this._selectedUnits.indexOf(unit);
            if (idx >= 0) {
                this._selectedUnits.splice(idx, 1);
                unit.clearTint();
            } else {
                this._selectedUnits.push(unit);
                unit.setTint(0xffff66);
            }
            this.selectedUnit = unit;
            this.registry.set('selectedUnit', unit);
        } else {
            this.clearSelection();
            this.selectedUnit = unit;
            this._selectedUnits.push(unit);
            unit.setTint(0xffff66);
            this.registry.set('selectedUnit', unit);
        }
    }

    selectTrench(trench) {
        this.clearSelection();
        this.selectedUnit = trench;
        this.registry.set('selectedUnit', { isTrench: true, trench: trench });
        // Highlight all units inside this specific trench
        let allUnits = [this.pUnits, this.eUnits];
        allUnits.forEach(group => {
            if (!group) return;
            group.getChildren().forEach(u => {
                if (u._trenchArrived && u.laneIndex === trench.laneIndex) {
                    let ft = this.trenches.find(t => t.active && t.ownerIsRed === u.isRed && t.laneIndex === u.laneIndex && Math.abs(t.x - trench.x) < 50);
                    if (ft && u._trenchArrived && Math.abs(u.x - trench.x) <= 50) {
                        this._selectedUnits.push(u);
                        u.setTint(0xffff66);
                    }
                }
            });
        });
    }

    clearSelection() {
        this._selectedUnits.forEach(u => { if (u.clearTint) u.clearTint(); });
        this._selectedUnits = [];
        this.selectedUnit = null;
        this.registry.set('selectedUnit', null);
    }

    cmdHold() {
        if (this._selectedUnits.length === 0) return;
        this._selectedUnits.forEach(u => { if (u.hold) u.hold(); });
        if (this.network && this.network.connected) {
            this._selectedUnits.forEach(u => {
                this.network.sendGameEvent('cmdHold', { unitId: u._unitId });
            });
        }
        this.clearSelection();
    }

    cmdFallback() {
        if (this._selectedUnits.length === 0) return;
        this._selectedUnits.forEach(u => { if (u.fallback) u.fallback(); });
        if (this.network && this.network.connected) {
            this._selectedUnits.forEach(u => {
                this.network.sendGameEvent('cmdFallback', { unitId: u._unitId });
            });
        }
        this.clearSelection();
    }

    cmdJump() {
        if (this._selectedUnits.length === 0) return;
        this._selectedUnits.forEach(u => { if (u.jump) u.jump(); });
        if (this.network && this.network.connected) {
            this._selectedUnits.forEach(u => {
                this.network.sendGameEvent('cmdJump', { unitId: u._unitId });
            });
        }
        this.clearSelection();
    }

    cmdBuildTrench() {
        let sel = this.selectedUnit;
        // Case 1: Selected unit is an engineer ready to build
        if (sel && sel._enReadyToBuild) {
            let credits = this.registry.get('credits') || 0;
            if (credits < 40) return;
            this.registry.set('credits', credits - 40);
            this.buildTrenchAt(sel.targetX, sel.laneIndex, sel.y, sel.isRed, sel);
            if (this.network && this.network.connected) {
                this.network.sendGameEvent('trenchBuild', { trenchX: sel.targetX, laneIndex: sel.laneIndex, trenchY: sel.y, isRed: sel.isRed });
            }
            return;
        }
        // Case 2: Selected trench — find nearest engineer ready to build
        let reg = this.registry.get('selectedUnit');
        if (!reg || !reg.isTrench) return;
        let trench = reg.trench;
        let engineer = null;
        let minDist = Infinity;
        [this.pUnits, this.eUnits].forEach(g => {
            if (!g) return;
            g.getChildren().forEach(s => {
                if (s.unitType === 'en' && !s.isWarpingOut && !s._dying && s._enReadyToBuild) {
                    let d = Math.abs(s.x - trench.x);
                    if (d < minDist) { minDist = d; engineer = s; }
                }
            });
        });
        if (engineer) {
            let credits = this.registry.get('credits') || 0;
            if (credits < 40) return;
            this.registry.set('credits', credits - 40);
            this.buildTrenchAt(trench.x, trench.laneIndex, engineer.y, engineer.isRed, engineer);
            if (this.network && this.network.connected) {
                this.network.sendGameEvent('trenchBuild', { trenchX: trench.x, laneIndex: trench.laneIndex, trenchY: engineer.y, isRed: engineer.isRed });
            }
        }
    }

    getTrenchMaxHp(trenchX, isRed) {
        let posIdx = [800, 1600, 2400].indexOf(trenchX);
        if (posIdx === -1) return 1200;
        let pcts = isRed ? [0.75, 0.50, 0.25] : [0.25, 0.50, 0.75];
        return Math.round(1200 * pcts[posIdx]);
    }

    buildTrenchAt(trenchX, laneIndex, trenchY, isRed, engineer) {
        // Remove any destroyed trench at this position first
        this.trenches = this.trenches.filter(t => 
            !(Math.abs(t.x - trenchX) < 50 && t.laneIndex === laneIndex) || t.active
        );
        let maxHp = this.getTrenchMaxHp(trenchX, isRed);
        let trench = {
            x: trenchX, y: trenchY, laneIndex, ownerIsRed: isRed,
            hp: maxHp, maxHp: maxHp, active: false, sprite: null,
            _building: false, _occCount: 0
        };
        this.trenches.push(trench);
        if (engineer) {
            engineer._enBuilt = false;
            engineer._enReadyToBuild = false;
            engineer.play(engineer.getTrenchAnim());
        }
        this.sound.play('sfx_trench_build', { volume: 0.5 });
        if (!trench.sprite) {
            trench.sprite = this.add.image(trench.x, trench.y, 'trenchSprite').setOrigin(0.5).setDepth(2);
            trench.sprite.setDisplaySize(35, 60);
            trench.sprite.setAlpha(0);
            trench.sprite.setInteractive();
            trench.sprite.on('pointerdown', (ptr) => {
                ptr.event.stopPropagation();
                this.selectTrench(trench);
            });
            trench.active = true;
        }
        trench._building = true;
        this.tweens.add({
            targets: trench.sprite,
            alpha: 0.9,
            duration: 4000,
            onComplete: () => {
                trench._building = false;
            }
        });
        if (engineer) {
            engineer.once('animationcomplete', () => {
                let orderedPositions = engineer.isRed ? [2400, 1600, 800] : [800, 1600, 2400];
                let nextPos = null;
                for (let pos of orderedPositions) {
                    let alreadyBuilt = this.trenches.some(t => t.active && t.laneIndex === engineer.laneIndex && Math.abs(t.x - pos) < 50);
                    if (!alreadyBuilt) { nextPos = pos; break; }
                }
                if (nextPos !== null) {
                    engineer._enCrouchStarted = false;
                    engineer.targetX = nextPos;
                    engineer.body.moves = true;
                    this.physics.moveTo(engineer, nextPos, engineer.y, UNIT_STATS.en.speed);
                    engineer.play(engineer.getWalkAnim());
                } else {
                    engineer.play(engineer.getCrouchAnim());
                }
            });
        }
        this.clearSelection();
    }

    cmdDestroyTrench() {
        let sel = this.registry.get('selectedUnit');
        if (!sel || !sel.isTrench) return;
        let trench = sel.trench;
        if (trench.active && trench.sprite) {
            if (this.network && this.network.connected) {
                this.network.sendGameEvent('trenchDestroy', { trenchX: trench.x, laneIndex: trench.laneIndex });
            }
            this.tweens.add({
                targets: trench.sprite,
                alpha: 0,
                duration: 500,
                onComplete: () => {
                    trench.active = false;
                    trench.hp = 0;
                    trench.sprite.destroy();
                    trench.sprite = null;
                    this.sound.play('sfx_trench_collapse', { volume: 0.5 });
                    this.clearSelection();
                }
            });
        }
    }

    // --- Multiplayer event handling ---
    handleNetworkEvent(eventName, data) {
        if (eventName === 'unitDeploy') {
            this.createRemoteUnit(data);
        } else if (eventName === 'cmdHold') {
            let unit = this.findUnitById(data.unitId);
            if (unit && unit.hold) unit.hold();
        } else if (eventName === 'cmdFallback') {
            let unit = this.findUnitById(data.unitId);
            if (unit && unit.fallback) unit.fallback();
        } else if (eventName === 'cmdJump') {
            let unit = this.findUnitById(data.unitId);
            if (unit && unit.jump) unit.jump();
        } else if (eventName === 'trenchBuild') {
            this.buildTrenchAt(data.trenchX, data.laneIndex, data.trenchY, data.isRed, null);
        } else if (eventName === 'trenchDestroy') {
            let trench = this.trenches.find(t => t.active && t.laneIndex === data.laneIndex && Math.abs(t.x - data.trenchX) < 50);
            if (trench) {
                trench.active = false;
                if (trench.sprite) { trench.sprite.destroy(); trench.sprite = null; }
                if (trench.hpBarBg) { trench.hpBarBg.destroy(); trench.hpBarBg = null; }
                if (trench.hpBarFill) { trench.hpBarFill.destroy(); trench.hpBarFill = null; }
                this.clearSelection();
            }
        }
    }

    findUnitById(unitId) {
        let result = null;
        [this.pUnits, this.eUnits].forEach(g => {
            if (!g) return;
            g.getChildren().forEach(u => {
                if (u._unitId === unitId) result = u;
            });
        });
        return result;
    }

    createRemoteUnit(data) {
        // Guard against double-creation (if state sync already created this unit)
        let existing = this.findUnitById(data.unitId);
        if (existing) {
            existing.x = data.x;
            existing.y = data.y;
            existing.health = UNIT_STATS[data.unitType].hp;
            return;
        }
        let group = data.isRed ? this.eUnits : this.pUnits;
        let soldier = new Unit(this, data.x, data.y, data.texKey, {
            unitType: data.unitType, isRed: data.isRed, laneIndex: data.laneIndex,
            unitId: data.unitId,
            warpX: data.warpX, targetX: data.targetX, spawnX: data.spawnX
        });
        group.add(soldier);
        soldier.setAlpha(1);
        // Flip direction
        if (data.isEnemyDoor) {
            soldier.setFlipX(!data.flipLikeTank);
        } else {
            soldier.setFlipX(data.flipLikeTank);
        }
        if (data.unitType === 'en') soldier._noWarp = true;
        if (data._trenchHold) {
            soldier._trenchHold = true;
            soldier.targetX = data.targetX;
        }
        // Click to select (only selectable if it's the local player's side)
        let gameMode = this.registry.get('gameMode');
        let playerSide = this.registry.get('playerSide');
        let isLocalUnit = (playerSide === 'blue' && !data.isRed) || (playerSide === 'red' && data.isRed);
        if (isLocalUnit) {
            soldier.setInteractive();
            let scene = this;
            soldier.on('pointerdown', function(ptr) {
                ptr.event.stopPropagation();
                scene.selectUnit(this);
            });
        }
        if (!data._trenchHold) {
            soldier.play(soldier.getWalkAnim());
            this.physics.moveTo(soldier, data.targetX, data.targetY, UNIT_STATS[data.unitType].speed);
        }
    }

    fireBullet(shooter, defender) {
        if (!shooter || !defender || !shooter.active || !defender.active) return;
        let dir = shooter.isRed ? -1 : 1;
        let isMM = shooter.unitType === 'mm';
        let isTankShooter = shooter.unitType === 'st' || shooter.unitType === 'ht';
        let isSniper = shooter.unitType === 'sn';
        let bulletTex = isTankShooter ? 'tankBullet' : (isMM ? 'missileBullet' : 'marineBullet');
        let impactAnim = isTankShooter ? 'tank_impact_anim' : (isMM ? 'missile_impact_anim' : 'bullet_impact_anim');
        let offX = isTankShooter ? 52 : (isSniper ? 36 : 24);
        let offY = isTankShooter ? -18 : -10;

        if (isSniper) this.sound.play('sfx_sniper_shoot', { volume: 0.5 });

        let bullet = this.add.image(shooter.x + dir * offX, shooter.y + offY, bulletTex);
        bullet.setDisplaySize(8, 6);
        this.bulletGroup.add(bullet);

        this.tweens.add({
            targets: bullet,
            x: defender.x,
            y: defender.y,
            duration: BULLET_DUR,
            onComplete: () => {
                let impact = this.add.sprite(bullet.x, bullet.y,
                    isTankShooter ? 'tank_impact_1' : (isMM ? 'mm_impact_1' : 'bulletImpact_1'));
                impact.setDisplaySize(32, 32);
                impact.play(impactAnim);
                impact.on('animationcomplete', () => impact.destroy());

                let us = shooter.unitType, ud = defender.unitType;
                let key = us + '->' + ud;
                let dmg = DAMAGE_TABLE[key] || shooter.damage;

                // 30% trench damage reduction if defender is behind a trench in same lane
                let behindTrench = false;
                this.trenches.forEach(t => {
                    if (!t.active || t.laneIndex !== defender.laneIndex) return;
                    let minX = Math.min(shooter.x, defender.x);
                    let maxX = Math.max(shooter.x, defender.x);
                    if (t.x > minX && t.x < maxX) behindTrench = true;
                });
                if (behindTrench) dmg = Math.round(dmg * 0.8);

                defender.health -= dmg;

                defender.revealHPBar();
                defender.updateHPBarColor();

                if (defender.health <= 0 && !defender._dying) {
                    defender.die(shooter.unitType);
                }
                bullet.destroy();
            }
        });
    }

    update() {
        const speed = 10;
        const cam = this.cameras.main;
        if (this.cursors.left.isDown || this.keys.A.isDown) cam.scrollX -= speed;
        if (this.cursors.right.isDown || this.keys.D.isDown) cam.scrollX += speed;

        // Spawn arrow visibility
        this.updateSpawnArrows();

        // --- Pre-warp morph + warp check (enemy, move RIGHT) ---
        if (this.eUnits) {
            this.eUnits.getChildren().forEach(s => {
                if (s.isWarpingOut) return;
                s.checkMorphOut();
                s.checkWarp();
            });
        }

        // --- Pre-warp morph + warp check (player, move LEFT) ---
        if (this.pUnits) {
            this.pUnits.getChildren().forEach(s => {
                if (s.isWarpingOut) return;
                s.checkMorphOut();
                s.checkWarp();
            });
        }

        // --- Spawn fade ---
        [this.eUnits, this.pUnits].forEach(group => {
            if (group) group.getChildren().forEach(s => s.checkSpawnFade());
        });

        // --- HP bar positions ---
        [this.eUnits, this.pUnits].forEach(group => {
            if (group) group.getChildren().forEach(s => s.updateHPBarPos());
        });

        // --- Non-combatant update (sniper/engineer/miner) ---
        [this.pUnits, this.eUnits].forEach((group, gi) => {
            if (!group) return;
            group.getChildren().forEach(s => {
                if (s.isWarpingOut || s._dying) return;

                // Sniper non-engagement handling — will drop through to normal engagement loop
                // (sniper has eyeRange=900 so it CAN engage; tank-skip logic is in nearest-enemy search below)

                // Engineer: walk to trench, stop, crouch, wait for build command
                if (s.unitType === 'en') {
                    if (s._enBuilt) {
                        // Engineer stays at trench after building
                        return;
                    }
                    let distToTrench = Math.abs(s.x - s.targetX);
                    if (distToTrench <= 30) {
                        s.body.setVelocity(0, 0);
                        s.body.moves = false;
                        s._enReadyToBuild = true;
                        if (!s._enCrouchStarted) {
                            s._enCrouchStarted = true;
                            let crouchKey = s.getCrouchAnim();
                            s.play(crouchKey);
                            s.once('animationcomplete', () => {
                                if (s._enReadyToBuild) s.stop();
                            });
                        }
                    }
                }

                // Miner: walk-plant cycle using Phaser timers
                    if (s.unitType === 'mn') {
                    if (!s._mnCycleState) {
                        s._mnCycleState = 'walking';
                        let _scene = this;
                        let startWalk = () => {
                            if (s._dying || s.isWarpingOut) return;
                            s._mnCycleState = 'walking';
                            s.body.moves = true;
                            s.play(s.getWalkAnim());
                            _scene.physics.moveTo(s, s.warpX, s.y, UNIT_STATS.mn.speed);
                            s._mnWalkTimer = _scene.time.delayedCall(3000, () => {
                                if (s._dying || s.isWarpingOut) return;
                                s._mnCycleState = 'planting';
                                s.body.setVelocity(0, 0);
                                s.body.moves = false;
                                s.play(s.getPlantAnim());
                                _scene.time.delayedCall(2000, () => {
                                    if (s._dying || s.isWarpingOut) return;
                                    let mineTex = s.isRed ? 'redMine' : 'blueMine';
                                    let mine = _scene.add.image(s.x, s.y + 15, mineTex).setDepth(5).setDisplaySize(20, 16);
                                    mine._mineOwner = s;
                                    mine._mineIsRed = s.isRed;
                                    _scene.mines.push(mine);
                                    s._activeMine = mine;
                                    _scene.sound.play('sfx_mine_set', { volume: 0.5 });
                                    startWalk();
                                });
                            });
                        };
                        startWalk();
                    }
                    if (s._mnCycleState === 'planting' && s.body && s.body.moves) {
                        s.body.setVelocity(0, 0);
                        s.body.moves = false;
                    }
                }

                // Infantry: always check for friendly trench ahead
                let combatTypes = ['inf', 'mm', 'st', 'ht', 'sn'];
                if (combatTypes.includes(s.unitType) && !s._trenchHold && !s._trenchArrived && !s._trenchPassed && !s._fallback && s.body && s.body.moves && !s.isEngaging) {
                    let friendlyTrench = this.trenches.find(t => t.active && t.ownerIsRed === s.isRed && t.laneIndex === s.laneIndex);
                    if (friendlyTrench) {
                        let trenchStopX = s.isRed ? friendlyTrench.x + 30 : friendlyTrench.x - 30;
                        let passed = s.isRed ? (s.x < friendlyTrench.x) : (s.x > friendlyTrench.x);
                        if (!passed) {
                            s._trenchHold = true;
                            s.targetX = trenchStopX;
                            this.physics.moveTo(s, trenchStopX, s.y, UNIT_STATS[s.unitType].speed);
                        }
                    }
                }

                // Trench hold: arrival check (first 3 hold, rest pass)
                if (s._trenchHold && !s.isEngaging && !s._fallback && s.body && s.body.moves) {
                    let friendlyTrench = this.trenches.find(t => t.active && t.ownerIsRed === s.isRed && t.laneIndex === s.laneIndex);
                    if (!friendlyTrench) {
                        s._trenchHold = false;
                        s._trenchArrived = false;
                        s._trenchPassed = false;
                        this.physics.moveTo(s, s.warpX, s.y, UNIT_STATS[s.unitType].speed);
                        s.play(s.getWalkAnim());
                        return;
                    }
                    let trenchStopX = s.isRed ? friendlyTrench.x + 30 : friendlyTrench.x - 30;
                    if (Math.abs(s.x - trenchStopX) <= 5) {
                        if ((friendlyTrench._occCount || 0) >= 3) {
                            // Trench full — pass through
                            s._trenchHold = false;
                            s._trenchArrived = true;
                            s._trenchPassed = true;
                            s.body.moves = true;
                            this.physics.moveTo(s, s.warpX, s.y, UNIT_STATS[s.unitType].speed);
                            s.play(s.getWalkAnim());
                            return;
                        }
                        if (!s._trenchArrived) {
                            s._trenchArrived = true;
                            friendlyTrench._occCount = (friendlyTrench._occCount || 0) + 1;
                            let bounds = this.laneBounds[s.laneIndex];
                            let spreadY = friendlyTrench.y + (friendlyTrench._occCount - 1) * 20 - 40;
                            spreadY = Phaser.Math.Clamp(spreadY, bounds.top, bounds.bottom);
                            s.y = spreadY;
                        }
                        s.body.setVelocity(0, 0);
                        s.body.moves = false;
                        let pfx = s.getAnimPrefix();
                        let sfx = s.getAnimSuffix();
                        if (s.unitType === 'sn') {
                            s.play(`${pfx}_crouch${sfx}`);
                            s.once('animationcomplete', () => {
                                if (s._trenchHold) { s.play(`${pfx}_shoot${sfx}`); }
                            });
                        } else {
                            s.play(`${pfx}_shoot${sfx}`);
                            s.once('animationcomplete', () => {
                                if (s._trenchHold) { s.play(`${pfx}_crouch${sfx}`); }
                            });
                        }
                    }
                }

                // Trench crossing block + unblock
                let isBlocked = s.unitType === 'st' || s.unitType === 'ht' || s.unitType === 'mn';
                if (isBlocked) {
                    let anyBlocking = false;
                    this.trenches.forEach(trench => {
                        if (!trench.active || trench.laneIndex !== s.laneIndex) return;
                        let dist = Math.abs(s.x - trench.x);
                        if (dist <= 25) {
                            anyBlocking = true;
                            if (s.body && s.body.moves) {
                                s.body.setVelocity(0, 0);
                                s.body.moves = false;
                            }
                            if (s.isRed && s.x > trench.x && s.x < trench.x + 50) {
                                s.x = trench.x + 25;
                            } else if (!s.isRed && s.x < trench.x && s.x > trench.x - 50) {
                                s.x = trench.x - 25;
                            }
                        }
                    });
                    // Unblock if no active trench is nearby (trench was destroyed)
                    if (!anyBlocking && s.body && !s.body.moves && !s._hold && !s.isEngaging && s._mnCycleState !== 'planting') {
                        s.body.moves = true;
                        if (s.unitType === 'mn' && s._mnCycleState !== 'planting') {
                            this.physics.moveTo(s, s.warpX, s.y, UNIT_STATS.mn.speed);
                            s.play(s.getWalkAnim());
                        } else {
                            this.physics.moveTo(s, s.warpX, s.y, UNIT_STATS[s.unitType].speed);
                            s.play(s.getWalkAnim());
                        }
                    }
                }
            });
        });

        // --- Presence check for mines (per-unit, more reliable) ---
        let triggeredMines = [];
        let triggerUnit = null;
        [this.eUnits, this.pUnits].forEach(group => {
            if (!group) return;
            group.getChildren().forEach(u => {
                if (u.isWarpingOut || u._dying) return;
                for (let mi = 0; mi < this.mines.length; mi++) {
                    let mine = this.mines[mi];
                    if (!mine.active) continue;
                    // Skip friendly mines (mines damage the opposing side)
                    let mineIsRed = mine._mineIsRed === true;
                    let unitIsRed = u.isRed === true;
                    if (mineIsRed === unitIsRed) continue;
                    let dist = Phaser.Math.Distance.Between(u.x, u.y, mine.x, mine.y);
                    if (dist < 30) {
                        triggeredMines.push(mi);
                        triggerUnit = u;
                        break;
                    }
                }
            });
        });
        // Process triggered mines after collection
        let processed = new Set();
        for (let mi of triggeredMines) {
            if (processed.has(mi)) continue;
            processed.add(mi);
            let mine = this.mines[mi];
            if (!mine || !mine.active) continue;
            let explosion = this.add.sprite(mine.x, mine.y, 'mineExplosion_1').setDepth(10);
            explosion.setDisplaySize(64, 64);
            explosion.play('mine_explosion_anim');
            explosion.on('animationcomplete', () => explosion.destroy());
            // Damage all nearby units
            [this.eUnits, this.pUnits].forEach(g => {
                if (!g) return;
                g.getChildren().forEach(u => {
                    if (u.isWarpingOut || u._dying) return;
                    let dist = Phaser.Math.Distance.Between(u.x, u.y, mine.x, mine.y);
                    if (dist < 40) {
                        u.health -= 133;
                        u.revealHPBar();
                        u.updateHPBarColor();
                        if (u.health <= 0 && !u._dying) u.die('mine');
                    }
                });
            });
            let owner = mine._mineOwner;
            if (owner && owner._activeMine === mine) owner._activeMine = null;
            mine.destroy();
            this.mines.splice(this.mines.indexOf(mine), 1);
        }

        // --- Trench collapse check ---
        this.trenches.forEach(trench => {
            if (trench.active && trench.hp <= 0) {
                trench.active = false;
                if (trench.sprite) { trench.sprite.destroy(); trench.sprite = null; }
                this.sound.play('sfx_trench_collapse', { volume: 0.5 });
            }
        });

        // --- Engagement ---
        if (this.eUnits && this.pUnits) {
            let anyEngaged = false;
            let pendingShots = [];

            // Player units (blue, move LEFT)
            this.pUnits.getChildren().forEach(pSoldier => {
                if (pSoldier.isWarpingOut) return;
                if (pSoldier._fallback) return;
                if (pSoldier.unitType === 'en' || pSoldier.unitType === 'mn') return;

                if (pSoldier.engagedEnemy) {
                    pSoldier._targetTrench = null;
                    pSoldier._trenchAnimStarted = false;
                    let target = pSoldier.engagedEnemy;
                    if (pSoldier._queuing) {
                        if (!pSoldier.body.moves) {
                            pSoldier._queuing = false;
                            pSoldier._formationBack = true;
                        } else {
                            let arrived = pSoldier.x >= pSoldier._queueX;
                            if (arrived) {
                                pSoldier._queuing = false;
                                pSoldier.body.setVelocity(0, 0);
                                pSoldier.body.moves = false;
                                pSoldier.shootAnimDone = true;
                                pSoldier.lastFireTime = this.time.now;
                                let pfx = pSoldier.getAnimPrefix();
                                let sfx = pSoldier.getAnimSuffix();
                                pSoldier.play(`${pfx}_crouch${sfx}`);
                                if (pSoldier.unitType === 'inf' && (!this.sfxMarineShot || !this.sfxMarineShot.isPlaying)) {
                                    this.sfxMarineShot = this.sound.add('sfx_marine_shot', { loop: true, volume: 0.4 });
                                    this.sfxMarineShot.play();
                                }
                            }
                            return;
                        }
                    }
                    if (target.isWarpingOut || !target.active) {
                        pSoldier.engagedEnemy = null;
                        pSoldier.isEngaging = false;
                        pSoldier._formationBack = false;
                        pSoldier._queuing = false;
                        pSoldier.shootAnimDone = true;
                        let nextTarget = null;
                        let nextDist = Infinity;
                        this.eUnits.getChildren().forEach(eS => {
                            if (eS.isWarpingOut) return;
                            if (pSoldier.laneIndex !== eS.laneIndex) return;
                            if (pSoldier.unitType === 'sn' && (eS.unitType === 'st' || eS.unitType === 'ht' || eS.unitType === 'mn')) return;
                            let d = Math.abs(pSoldier.x - eS.x);
                            if (d <= pSoldier.eyeRange && d < nextDist) { nextDist = d; nextTarget = eS; }
                        });
                        if (nextTarget) {
                            pSoldier.engagedEnemy = nextTarget;
                            pSoldier.isEngaging = true;
                            pSoldier.lastFireTime = this.time.now;
                            pSoldier.shootAnimDone = false;
                            if (pSoldier.morphTimer) { pSoldier.morphTimer.remove(false); pSoldier.morphTimer = null; pSoldier.setAlpha(1); }
                            let pfx = pSoldier.getAnimPrefix();
                            let sfx = pSoldier.getAnimSuffix();
                            pSoldier.play(`${pfx}_shoot${sfx}`);
                            if (pSoldier.unitType !== 'sn') pendingShots.push({ shooter: pSoldier, target: nextTarget });
                            let isTank = pSoldier.unitType === 'st' || pSoldier.unitType === 'ht';
                            if (isTank) this.sound.play('sfx_tank_shot', { volume: 0.5 });
                            else if (pSoldier.unitType === 'mm') this.sound.play('sfx_mm_shot', { volume: 0.5 });
                            pSoldier.once('animationcomplete', () => {
                                pSoldier.shootAnimDone = true;
                                if (!isTank) {
                                    pSoldier.play(`${pfx}_crouch${sfx}`);
                                    if (pSoldier.unitType === 'inf' && (!this.sfxMarineShot || !this.sfxMarineShot.isPlaying)) {
                                        this.sfxMarineShot = this.sound.add('sfx_marine_shot', { loop: true, volume: 0.4 });
                                        this.sfxMarineShot.play();
                                    }
                                }
                            });
                        } else if (!pSoldier._hold) {
                            pSoldier.body.moves = true;
                            pSoldier.play(pSoldier.getWalkAnim());
                            this.physics.moveTo(pSoldier, pSoldier.targetX, pSoldier.y, 80);
                        } else {
                            pSoldier.body.setVelocity(0, 0);
                            pSoldier.body.moves = false;
                        }
                    } else {
                        anyEngaged = true;
                        let now = this.time.now;
                        if (pSoldier.shootAnimDone && now - pSoldier.lastFireTime >= pSoldier.rechargeMs) {
                            pSoldier.lastFireTime = now;
                            pendingShots.push({ shooter: pSoldier, target });
                            let isTank = pSoldier.unitType === 'st' || pSoldier.unitType === 'ht';
                            if (isTank) {
                                pSoldier.shootAnimDone = false;
                                let pfx = pSoldier.getAnimPrefix();
                                let sfx = pSoldier.getAnimSuffix();
                                pSoldier.play(`${pfx}_shoot${sfx}`);
                                pSoldier.once('animationcomplete', () => { pSoldier.shootAnimDone = true; });
                                this.sound.play('sfx_tank_shot', { volume: 0.5 });
                            } else if (pSoldier.unitType === 'mm') {
                                this.sound.play('sfx_mm_shot', { volume: 0.5 });
                            }
                        }
                    }
                    return;
                }

                let nearest = null;
                let nearestDist = Infinity;
                this.eUnits.getChildren().forEach(eSoldier => {
                    if (eSoldier.isWarpingOut) return;
                    if (pSoldier.laneIndex !== eSoldier.laneIndex) return;
                    // Sniper skips tank and miner targets
                    if (pSoldier.unitType === 'sn' && (eSoldier.unitType === 'st' || eSoldier.unitType === 'ht' || eSoldier.unitType === 'mn')) return;
                    let dist = Math.abs(pSoldier.x - eSoldier.x);
                    if (dist <= pSoldier.eyeRange && dist < nearestDist) {
                        nearestDist = dist;
                        nearest = eSoldier;
                    }
                });
                if (!nearest) {
                    // Check for enemy trench to attack (combat units only)
                    if (pSoldier.unitType !== 'en' && pSoldier.unitType !== 'mn') {
                        let trenchTarget = this.trenches.find(t => t.active && t.ownerIsRed && t.laneIndex === pSoldier.laneIndex && Math.abs(pSoldier.x - t.x) <= pSoldier.eyeRange);
                        if (trenchTarget) {
                            pSoldier._targetTrench = trenchTarget;
                            pSoldier.body.setVelocity(0, 0);
                            pSoldier.body.moves = false;
                            return;
                        }
                    }
                    // No enemy and no trench — unit keeps walking (already moving)
                    return;
                }
                pSoldier._targetTrench = null;
                pSoldier._trenchAnimStarted = false;

                anyEngaged = true;
                pSoldier.engagedEnemy = nearest;
                pSoldier.isEngaging = true;
                pSoldier.lastFireTime = this.time.now;
                if (pSoldier.morphTimer) { pSoldier.morphTimer.remove(false); pSoldier.morphTimer = null; pSoldier.setAlpha(1); }

                let _frontX = null;
                let _backCount = 0;
                this.pUnits.getChildren().forEach(f => {
                    if (f !== pSoldier && f.isEngaging && f.engagedEnemy === nearest && f.eyeRange === pSoldier.eyeRange) {
                        if (!f._formationBack && (_frontX === null || f.x > _frontX)) _frontX = f.x;
                        if (f._formationBack) _backCount++;
                    }
                });
                if (_frontX !== null) {
                    let bounds = this.laneBounds[pSoldier.laneIndex];
                    let proposedY = pSoldier.y + _backCount * 3;
                    if (proposedY >= bounds.top && proposedY <= bounds.bottom) {
                        pSoldier.body.setVelocity(0, 0);
                        pSoldier.body.setAcceleration(0, 0);
                        pSoldier.body.moves = false;
                        pSoldier.x = _frontX - FORM_OFFSET;
                        pSoldier.y = proposedY;
                        pSoldier._formationBack = true;
                    } else {
                        pSoldier._queuing = true;
                        pSoldier._queueX = _frontX - 5;
                        pSoldier._formationBack = true;
                        this.physics.moveTo(pSoldier, pSoldier._queueX, pSoldier.y, UNIT_STATS[pSoldier.unitType].speed);
                        return;
                    }
                } else {
                    pSoldier.body.setVelocity(0, 0);
                    pSoldier.body.setAcceleration(0, 0);
                    pSoldier.body.moves = false;
                }

                let pfx = pSoldier.getAnimPrefix();
                let sfx = pSoldier.getAnimSuffix();
                pSoldier.shootAnimDone = false;
                pSoldier.play(`${pfx}_shoot${sfx}`);
                if (pSoldier.unitType === 'sn') pSoldier.lastFireTime = this.time.now;
                else pendingShots.push({ shooter: pSoldier, target: nearest });
                let isTank = pSoldier.unitType === 'st' || pSoldier.unitType === 'ht';
                if (isTank) this.sound.play('sfx_tank_shot', { volume: 0.5 });
                else if (pSoldier.unitType === 'mm') this.sound.play('sfx_mm_shot', { volume: 0.5 });
                pSoldier.once('animationcomplete', () => {
                    pSoldier.shootAnimDone = true;
                    if (!isTank) {
                        pSoldier.play(`${pfx}_crouch${sfx}`);
                        if (pSoldier.unitType === 'inf' && (!this.sfxMarineShot || !this.sfxMarineShot.isPlaying)) {
                            this.sfxMarineShot = this.sound.add('sfx_marine_shot', { loop: true, volume: 0.4 });
                            this.sfxMarineShot.play();
                        }
                    }
                });
            });

            // Enemy units (red, move RIGHT)
            this.eUnits.getChildren().forEach(eSoldier => {
                if (eSoldier.isWarpingOut) return;
                if (eSoldier._fallback) return;
                if (eSoldier.unitType === 'en' || eSoldier.unitType === 'mn') return;

                if (eSoldier.engagedEnemy) {
                    eSoldier._targetTrench = null;
                    eSoldier._trenchAnimStarted = false;
                    let target = eSoldier.engagedEnemy;
                    if (eSoldier._queuing) {
                        if (!eSoldier.body.moves) {
                            eSoldier._queuing = false;
                            eSoldier._formationBack = true;
                        } else {
                            let arrived = eSoldier.x <= eSoldier._queueX;
                            if (arrived) {
                                eSoldier._queuing = false;
                                eSoldier.body.setVelocity(0, 0);
                                eSoldier.body.moves = false;
                                eSoldier.shootAnimDone = true;
                                eSoldier.lastFireTime = this.time.now;
                                let pfx = eSoldier.getAnimPrefix();
                                let sfx = eSoldier.getAnimSuffix();
                                eSoldier.play(`${pfx}_crouch${sfx}`);
                                if (eSoldier.unitType === 'inf' && (!this.sfxMarineShot || !this.sfxMarineShot.isPlaying)) {
                                    this.sfxMarineShot = this.sound.add('sfx_marine_shot', { loop: true, volume: 0.4 });
                                    this.sfxMarineShot.play();
                                }
                            }
                            return;
                        }
                    }
                    if (target.isWarpingOut || !target.active) {
                        eSoldier.engagedEnemy = null;
                        eSoldier.isEngaging = false;
                        eSoldier._formationBack = false;
                        eSoldier._queuing = false;
                        eSoldier.shootAnimDone = true;
                        let nextTarget = null;
                        let nextDist = Infinity;
                        this.pUnits.getChildren().forEach(pS => {
                            if (pS.isWarpingOut) return;
                            if (eSoldier.laneIndex !== pS.laneIndex) return;
                            if (eSoldier.unitType === 'sn' && (pS.unitType === 'st' || pS.unitType === 'ht' || pS.unitType === 'mn')) return;
                            let d = Math.abs(eSoldier.x - pS.x);
                            if (d <= eSoldier.eyeRange && d < nextDist) { nextDist = d; nextTarget = pS; }
                        });
                        if (nextTarget) {
                            eSoldier.engagedEnemy = nextTarget;
                            eSoldier.isEngaging = true;
                            eSoldier.lastFireTime = this.time.now;
                            if (eSoldier.morphTimer) { eSoldier.morphTimer.remove(false); eSoldier.morphTimer = null; eSoldier.setAlpha(1); }
                            eSoldier.shootAnimDone = false;
                            let pfx = eSoldier.getAnimPrefix();
                            let sfx = eSoldier.getAnimSuffix();
                            eSoldier.play(`${pfx}_shoot${sfx}`);
                            if (eSoldier.unitType !== 'sn') pendingShots.push({ shooter: eSoldier, target: nextTarget });
                            let isTank = eSoldier.unitType === 'st' || eSoldier.unitType === 'ht';
                            if (isTank) this.sound.play('sfx_tank_shot', { volume: 0.5 });
                            else if (eSoldier.unitType === 'mm') this.sound.play('sfx_mm_shot', { volume: 0.5 });
                            eSoldier.once('animationcomplete', () => {
                                eSoldier.shootAnimDone = true;
                                if (!isTank) {
                                    eSoldier.play(`${pfx}_crouch${sfx}`);
                                    if (eSoldier.unitType === 'inf' && (!this.sfxMarineShot || !this.sfxMarineShot.isPlaying)) {
                                        this.sfxMarineShot = this.sound.add('sfx_marine_shot', { loop: true, volume: 0.4 });
                                        this.sfxMarineShot.play();
                                    }
                                }
                            });
                        } else if (!eSoldier._hold) {
                            eSoldier.body.moves = true;
                            eSoldier.play(eSoldier.getWalkAnim());
                            this.physics.moveTo(eSoldier, eSoldier.targetX, eSoldier.y, 80);
                        } else {
                            eSoldier.body.setVelocity(0, 0);
                            eSoldier.body.moves = false;
                        }
                    } else {
                        anyEngaged = true;
                        let now = this.time.now;
                        if (eSoldier.shootAnimDone && now - eSoldier.lastFireTime >= eSoldier.rechargeMs) {
                            eSoldier.lastFireTime = now;
                            pendingShots.push({ shooter: eSoldier, target });
                            let isTank = eSoldier.unitType === 'st' || eSoldier.unitType === 'ht';
                            if (isTank) {
                                eSoldier.shootAnimDone = false;
                                let pfx = eSoldier.getAnimPrefix();
                                let sfx = eSoldier.getAnimSuffix();
                                eSoldier.play(`${pfx}_shoot${sfx}`);
                                eSoldier.once('animationcomplete', () => { eSoldier.shootAnimDone = true; });
                                this.sound.play('sfx_tank_shot', { volume: 0.5 });
                            } else if (eSoldier.unitType === 'mm') {
                                this.sound.play('sfx_mm_shot', { volume: 0.5 });
                            }
                        }
                    }
                    return;
                }

                let nearest = null;
                let nearestDist = Infinity;
                this.pUnits.getChildren().forEach(pSoldier => {
                    if (pSoldier.isWarpingOut) return;
                    if (eSoldier.laneIndex !== pSoldier.laneIndex) return;
                    if (eSoldier.unitType === 'sn' && (pSoldier.unitType === 'st' || pSoldier.unitType === 'ht' || pSoldier.unitType === 'mn')) return;
                    let dist = Math.abs(eSoldier.x - pSoldier.x);
                    if (dist <= eSoldier.eyeRange && dist < nearestDist) {
                        nearestDist = dist;
                        nearest = pSoldier;
                    }
                });
                if (!nearest) {
                    // Check for player trench to attack (combat units only)
                    if (eSoldier.unitType !== 'en' && eSoldier.unitType !== 'mn') {
                        if (eSoldier._targetTrench) return;
                        let trenchTarget = this.trenches.find(t => t.active && !t.ownerIsRed && t.laneIndex === eSoldier.laneIndex && Math.abs(eSoldier.x - t.x) <= eSoldier.eyeRange);
                        if (trenchTarget) {
                            eSoldier._targetTrench = trenchTarget;
                            eSoldier.body.setVelocity(0, 0);
                            eSoldier.body.moves = false;
                            return;
                        }
                    }
                    // No enemy and no trench — unit keeps walking (already moving)
                    return;
                }
                eSoldier._targetTrench = null;
                eSoldier._trenchAnimStarted = false;

                anyEngaged = true;
                eSoldier.engagedEnemy = nearest;
                eSoldier.isEngaging = true;
                eSoldier.lastFireTime = this.time.now;
                if (eSoldier.morphTimer) { eSoldier.morphTimer.remove(false); eSoldier.morphTimer = null; eSoldier.setAlpha(1); }

                let _frontX = null;
                let _backCount = 0;
                this.eUnits.getChildren().forEach(f => {
                    if (f !== eSoldier && f.isEngaging && f.engagedEnemy === nearest && f.eyeRange === eSoldier.eyeRange) {
                        if (!f._formationBack && (_frontX === null || f.x < _frontX)) _frontX = f.x;
                        if (f._formationBack) _backCount++;
                    }
                });
                if (_frontX !== null) {
                    let bounds = this.laneBounds[eSoldier.laneIndex];
                    let proposedY = eSoldier.y + _backCount * 3;
                    if (proposedY >= bounds.top && proposedY <= bounds.bottom) {
                        eSoldier.body.setVelocity(0, 0);
                        eSoldier.body.setAcceleration(0, 0);
                        eSoldier.body.moves = false;
                        eSoldier.x = _frontX + FORM_OFFSET;
                        eSoldier.y = proposedY;
                        eSoldier._formationBack = true;
                    } else {
                        eSoldier._queuing = true;
                        eSoldier._queueX = _frontX + 5;
                        eSoldier._formationBack = true;
                        this.physics.moveTo(eSoldier, eSoldier._queueX, eSoldier.y, UNIT_STATS[eSoldier.unitType].speed);
                        return;
                    }
                } else {
                    eSoldier.body.setVelocity(0, 0);
                    eSoldier.body.setAcceleration(0, 0);
                    eSoldier.body.moves = false;
                }

                let pfx = eSoldier.getAnimPrefix();
                let sfx = eSoldier.getAnimSuffix();
                eSoldier.shootAnimDone = false;
                eSoldier.play(`${pfx}_shoot${sfx}`);
                if (eSoldier.unitType === 'sn') eSoldier.lastFireTime = this.time.now;
                else pendingShots.push({ shooter: eSoldier, target: nearest });
                let isTank = eSoldier.unitType === 'st' || eSoldier.unitType === 'ht';
                if (isTank) this.sound.play('sfx_tank_shot', { volume: 0.5 });
                else if (eSoldier.unitType === 'mm') this.sound.play('sfx_mm_shot', { volume: 0.5 });
                eSoldier.once('animationcomplete', () => {
                    eSoldier.shootAnimDone = true;
                    if (!isTank) {
                        eSoldier.play(`${pfx}_crouch${sfx}`);
                        if (eSoldier.unitType === 'inf' && (!this.sfxMarineShot || !this.sfxMarineShot.isPlaying)) {
                            this.sfxMarineShot = this.sound.add('sfx_marine_shot', { loop: true, volume: 0.4 });
                            this.sfxMarineShot.play();
                        }
                    }
                });
            });

            // Sniper laser beam
            if (this._sniperLaser) this._sniperLaser.clear();
            [this.pUnits, this.eUnits].forEach(group => {
                if (!group) return;
                group.getChildren().forEach(s => {
                    if (s.unitType !== 'sn' || !s.isEngaging || !s.engagedEnemy || s._dying) return;
                    if (!this._sniperLaser) this._sniperLaser = this.add.graphics();
                    this._sniperLaser.lineStyle(2, 0xff0000, 0.6);
                    let barrelX = s.x + (s.isRed ? -24 : 24);
                    this._sniperLaser.beginPath();
                    this._sniperLaser.moveTo(barrelX, s.y - 5);
                    this._sniperLaser.lineTo(s.engagedEnemy.x, s.engagedEnemy.y);
                    this._sniperLaser.strokePath();
                });
            });

            pendingShots.forEach(s => this.fireBullet(s.shooter, s.target));

            // --- Trench attacks (units fire at enemy trenches) ---
            [this.pUnits, this.eUnits].forEach(group => {
                if (!group) return;
                group.getChildren().forEach(s => {
                    if (!s._targetTrench || s._dying || s.isWarpingOut) return;
                    // If enemies are in range, stop trench attack — engagement loop will handle
                    let enemyGrp = s.isRed ? this.pUnits : this.eUnits;
                    if (enemyGrp) {
                        let hasEnemy = false;
                        enemyGrp.getChildren().forEach(e => {
                            if (!e.active || e.isWarpingOut || e._dying) return;
                            if (e.laneIndex !== s.laneIndex) return;
                            if (s.unitType === 'sn' && (e.unitType === 'st' || e.unitType === 'ht' || e.unitType === 'mn')) return;
                            if (Math.abs(s.x - e.x) <= s.eyeRange) hasEnemy = true;
                        });
                        if (hasEnemy) {
                            s._targetTrench = null;
                            s._trenchAnimStarted = false;
                            s.isEngaging = false;
                            s.body.moves = true;
                            this.physics.moveTo(s, s.targetX, s.y, UNIT_STATS[s.unitType].speed);
                            s.play(s.getWalkAnim());
                            return;
                        }
                    }
                    let trench = s._targetTrench;
                    if (!trench.active) {
                        s._targetTrench = null;
                            s._trenchAnimStarted = false;
                        s.isEngaging = false;
                        s.body.moves = true;
                        this.physics.moveTo(s, s.targetX, s.y, UNIT_STATS[s.unitType].speed);
                        s.play(s.getWalkAnim());
                        return;
                    }
                    if (trench._building) return;
                    let now = this.time.now;
                    if (s.shootAnimDone && now - s.lastFireTime >= s.rechargeMs) {
                        s.lastFireTime = now;
                        if (!s._trenchAnimStarted) {
                            s._trenchAnimStarted = true;
                            s.shootAnimDone = false;
                            let pfx2 = s.getAnimPrefix();
                            let sfx2 = s.getAnimSuffix();
                            if (s.unitType === 'sn') {
                                s.play(`${pfx2}_crouch${sfx2}`);
                                s.once('animationcomplete', () => {
                                    s.shootAnimDone = true;
                                    if (s._targetTrench) s.play(`${pfx2}_shoot${sfx2}`);
                                });
                            } else {
                                s.play(`${pfx2}_shoot${sfx2}`);
                                s.once('animationcomplete', () => {
                                    s.shootAnimDone = true;
                                    if (s._targetTrench) s.play(`${pfx2}_crouch${sfx2}`);
                                });
                            }
                        } else {
                            s.shootAnimDone = true;
                        }
                        let isTank = s.unitType === 'st' || s.unitType === 'ht';
                        if (isTank) {
                            this.sound.play('sfx_tank_shot', { volume: 0.5 });
                        } else if (s.unitType === 'mm') {
                            this.sound.play('sfx_mm_shot', { volume: 0.5 });
                        } else if (s.unitType === 'inf') {
                            this.sound.play('sfx_marine_shot', { volume: 0.3 });
                        } else if (s.unitType === 'sn') {
                            this.sound.play('sfx_sniper_shoot', { volume: 0.5 });
                        }
                        let tDmg = 5;
                        if (s.unitType === 'mm') tDmg = 8;
                        else if (s.unitType === 'st' || s.unitType === 'ht') tDmg = 12;
                        else if (s.unitType === 'sn') tDmg = 15;
                        // Show trench health bar
                        if (!trench.hpBarBg) {
                            trench.hpBarBg = this.add.rectangle(trench.x, trench.y - 40, 50, 6, 0x222222).setDepth(20);
                            trench.hpBarFill = this.add.rectangle(trench.x, trench.y - 40, 48, 5, 0x00ff00).setDepth(21);
                        }
                        let hpRatio = Math.max(0, trench.hp / trench.maxHp);
                        trench.hpBarFill.width = 48 * hpRatio;
                        trench.hpBarFill.fillColor = hpRatio > 0.6 ? 0x00ff00 : (hpRatio > 0.3 ? 0xffff00 : 0xff0000);
                        trench.hp -= tDmg;
                        if (trench.hp <= 0) {
                            trench.active = false;
                            if (trench.sprite) { trench.sprite.destroy(); trench.sprite = null; }
                            if (trench.hpBarBg) { trench.hpBarBg.destroy(); trench.hpBarBg = null; }
                            if (trench.hpBarFill) { trench.hpBarFill.destroy(); trench.hpBarFill = null; }
                            this.sound.play('sfx_trench_collapse', { volume: 0.5 });
                            s._targetTrench = null;
                            s._trenchAnimStarted = false;
                            s.isEngaging = false;
                            s.body.moves = true;
                            this.physics.moveTo(s, s.targetX, s.y, UNIT_STATS[s.unitType].speed);
                            s.play(s.getWalkAnim());
                        }
                    }
                });
            });

            if (!anyEngaged && this.sfxMarineShot && this.sfxMarineShot.isPlaying) {
                this.sfxMarineShot.stop();
            }
        }

        // Network: send state to opponent
        if (this.network && this.network.connected && this.game.loop.frame % 3 === 0) {
            this.network.sendState();
        }

        // AI: economy + deployment (single-player only)
        let gameMode = this.registry.get('gameMode') || 'singlePlayer';
        if (gameMode !== 'multiplayer') {
            this.aiCredits += CREDITS_PER_SEC * (this.game.loop.delta / 1000);
            this.aiCredits = Math.min(this.aiCredits, MAX_CREDITS);
            this.registry.set('aiCredits', this.aiCredits);
            this.aiDeployTimer += this.game.loop.delta;
            if (this.aiDeployTimer >= 3000 && this.aiCredits >= 20) {
                this.aiDeployTimer = 0;
                let unitTypes = ['infantry_red', 'missile_red', 'tank_red', 'heavy_tank_red', 'sniper_red', 'engineer_red', 'miner_red'];
                let costs = [20, 50, 80, 140, 120, 40, 100];
                let affordable = [];
                unitTypes.forEach((name, i) => {
                    if (this.aiCredits >= costs[i]) affordable.push(name);
                });
                if (affordable.length > 0) {
                    let chosen = affordable[Math.floor(Math.random() * affordable.length)];
                    let laneIdx = Math.floor(Math.random() * 5);
                    this.registry.set('armedUnit', chosen);
                    this.handleDoorClick(laneIdx, true);
                    this.registry.set('armedUnit', null);
                }
            }
        }
    }
}
