class MenuScene extends Phaser.Scene {
    constructor() {
        super({ key: 'MenuScene' });
        this._gameMode = null;
    }

    preload() {
        // Only load background images + menu UI assets here
        this.load.image('bg1', 'assets/images/background.webp');
        this.load.image('bg2', 'assets/images/625.png');
        this.load.svg('masterBases', 'assets/shapes/433.svg', { scale: 1 });
    }

    create() {
        let cx = window.innerWidth / 2, cy = window.innerHeight / 2;

        // --- Slideshow using preloaded background images ---
        let bg1 = this.add.image(cx, cy, 'bg1').setOrigin(0.5).setDepth(0);
        bg1.setDisplaySize(window.innerWidth, window.innerHeight);
        let bg2 = this.add.image(cx, cy, 'bg2').setOrigin(0.5).setDepth(0).setAlpha(0);
        bg2.setDisplaySize(window.innerWidth, window.innerHeight);

        // Crossfade slideshow: bg1 fades out while bg2 fades in simultaneously
        this.tweens.add({ targets: bg1, alpha: 0, duration: 1000, delay: 4000 });
        this.tweens.add({ targets: bg2, alpha: 1, duration: 1000, delay: 4000 });

        // Loading bar while game assets load
        let barBg = this.add.rectangle(cx, cy + 40, 400, 24, 0x222244, 0.8).setDepth(2);
        let barFill = this.add.rectangle(cx - 198, cy + 40, 0, 20, 0x00ffff, 0.9).setOrigin(0, 0.5).setDepth(3);
        let loadText = this.add.text(cx, cy + 80, 'Loading Mothership Warfare...', {
            fontSize: '18px', color: '#aaaacc', fontFamily: 'Arial'
        }).setOrigin(0.5).setDepth(2);

        // Title shown immediately
        let title = this.add.text(cx, cy - 120, 'MOTHERSHIP\nWARFARE', {
            fontFamily: 'Impact, sans-serif', fontSize: '72px', color: '#00ffff',
            align: 'center', stroke: '#003366', strokeThickness: 6,
            shadow: { offsetX: 0, offsetY: 0, color: '#00ffff', blur: 20, stroke: true, fill: true }
        }).setOrigin(0.5).setDepth(2).setAlpha(0);
        this.tweens.add({ targets: title, alpha: 1, duration: 1500 });

        // --- Queue ALL game assets for loading ---
        this.load.image('sky', 'assets/images/bg_sky.png');
        this.load.image('terrain', 'assets/images/bg_level1.png');
        this.load.svg('barBg', 'assets/shapes/bar_bg.svg');
        this.load.svg('barBlue', 'assets/shapes/bar_blue.svg');
        this.load.svg('barRed', 'assets/shapes/bar_red.svg');
        this.load.image('btn_bg', 'assets/images/btn_bg.png');
        this.load.image('btn_bg_hover', 'assets/images/btn_bg_hover.png');
        this.load.image('icon_infantry', 'assets/images/icon_infantry.png');
        this.load.image('icon_infantry_red', 'assets/sprites/DefineSprite_492/icon_infantry_red.png');
        this.load.image('marineBullet', 'assets/sprites/DefineSprite_913_MarineBullet/1.png');
        for (let i = 1; i <= 20; i++) {
            this.load.image(`inf_walk_${i}`, `assets/sprites/infantry_walk/${i}.png`);
            this.load.image(`inf_walk_red_${i}`, `assets/sprites/infantry_walk_red/${i}.png`);
        }
        for (let i = 1; i <= 21; i++) {
            this.load.image(`inf_shoot_${i}`, `assets/sprites/infantry_shoot/${i}.png`);
            this.load.image(`inf_shoot_red_${i}`, `assets/sprites/infantry_shoot_red/${i}.png`);
        }
        for (let i = 1; i <= 20; i++) {
            this.load.image(`bulletImpact_${i}`, `assets/sprites/DefineSprite_919_MarineBulletImpact/${i}.png`);
        }
        for (let i = 1; i <= 15; i++) {
            this.load.image(`inf_crouch_${i}`, `assets/sprites/infantry_crouch_shoot/${i}.png`);
            this.load.image(`inf_crouch_red_${i}`, `assets/sprites/infantry_crouch_shoot_red/${i}.png`);
        }
        this.load.audio('sfx_marine_shot', 'assets/sounds/1220_Sound_marine_shot.mp3');
        this.load.audio('sfx_mm_shot', 'assets/sounds/1219_Sound_mm_shot.mp3');
        this.load.audio('sfx_tank_shot', 'assets/sounds/1223_Sound_hit.mp3');
        this.load.audio('sfx_death_expl', 'assets/sounds/1213_Sound_marine_death_expl.mp3');
        this.load.audio('sfx_death_normal', 'assets/sounds/1214_Sound_marine_death.mp3');
        this.load.audio('sfx_tank_death', 'assets/sounds/1198_Sound_hit1.mp3');
        this.load.audio('sfx_mine_set', 'assets/sounds/1203_Sound_mine_set.mp3');
        this.load.audio('sfx_sniper_shoot', 'assets/sounds/sniper_Shoot.mp3');
        this.load.audio('sfx_trench_collapse', 'assets/sounds/trench_collapce.mp3');
        this.load.audio('sfx_trench_build', 'assets/sounds/bulding.mp3');
        for (let i = 1; i <= 111; i++) this.load.image(`inf_death_${i}`, `assets/sprites/infintry_death/${i}.png`);
        for (let i = 1; i <= 112; i++) this.load.image(`inf_death_red_${i}`, `assets/sprites/infintry_red_death/${i}.png`);
        for (let i = 1; i <= 126; i++) {
            this.load.image(`inf_death_2_${i}`, `assets/sprites/infintry_death_2/${i}.png`);
            this.load.image(`inf_death_red_2_${i}`, `assets/sprites/infintry_red_death_2/${i}.png`);
        }
        this.load.image('icon_missile', 'assets/images/icon_missle_man.png');
        this.load.image('icon_missile_red', 'assets/images/icon_missle_man_red.png');
        this.load.image('missileBullet', 'assets/sprites/DefineSprite_927_MMBullet/1.png');
        for (let i = 1; i <= 20; i++) {
            this.load.image(`mm_walk_${i}`, `assets/sprites/missle_man_walk/${i}.png`);
            this.load.image(`mm_walk_red_${i}`, `assets/sprites/missle_man_walk_red/${i}.png`);
        }
        for (let i = 1; i <= 21; i++) {
            this.load.image(`mm_shoot_${i}`, `assets/sprites/missle_man_shoot/${i}.png`);
            this.load.image(`mm_shoot_red_${i}`, `assets/sprites/missle_man_shoot_red/${i}.png`);
        }
        for (let i = 1; i <= 13; i++) {
            this.load.image(`mm_crouch_${i}`, `assets/sprites/missle_man_crouch_shoot/${i}.png`);
            this.load.image(`mm_crouch_red_${i}`, `assets/sprites/missle_man_crouch_shoot_red/${i}.png`);
        }
        for (let i = 1; i <= 31; i++) this.load.image(`mm_impact_${i}`, `assets/sprites/DefineSprite_922_MMImpact/${i}.png`);
        for (let i = 1; i <= 112; i++) this.load.image(`mm_death_${i}`, `assets/sprites/missle_man_death/${i}.png`);
        for (let i = 1; i <= 111; i++) this.load.image(`mm_death_red_${i}`, `assets/sprites/missle_man_death_red/${i}.png`);
        for (let i = 1; i <= 126; i++) {
            this.load.image(`mm_death_2_${i}`, `assets/sprites/missle_man_death_2/${i}.png`);
            this.load.image(`mm_death_red_2_${i}`, `assets/sprites/missle_man_death_red_2/${i}.png`);
        }
        this.load.image('icon_tank', 'assets/images/storm_tank.png');
        this.load.image('icon_tank_red', 'assets/images/storm_tank_red.png');
        this.load.image('tankBullet', 'assets/images/storm_tank_shoot.png');
        for (let i = 1; i <= 60; i++) {
            this.load.image(`tank_walk_${i}`, `assets/sprites/storm_tank_walk/${i}.png`);
            this.load.image(`tank_walk_red_${i}`, `assets/sprites/storm_tank_walk_red/luxa.org-color-changed-${i}.png`);
        }
        for (let i = 1; i <= 21; i++) {
            this.load.image(`tank_shoot_${i}`, `assets/sprites/storm_tank_shoot/${i}.png`);
            this.load.image(`tank_shoot_red_${i}`, `assets/sprites/storm_tank_shoot_red/luxa.org-color-changed-${i}.png`);
        }
        for (let i = 1; i <= 20; i++) {
            this.load.image(`tank_death_${i}`, `assets/sprites/storm_tank_death/${i}.png`);
            this.load.image(`tank_death_red_${i}`, `assets/sprites/storm_tank_death_red/luxa.org-color-changed-${i}.png`);
        }
        for (let i = 1; i <= 36; i++) this.load.image(`tank_impact_${i}`, `assets/sprites/DefineSprite_935_StormTankImpact/${i}.png`);
        this.load.image('icon_heavy_tank', 'assets/images/heavy_tank.png');
        this.load.image('icon_heavy_tank_red', 'assets/images/heavy_tank_red.png');
        for (let i = 1; i <= 60; i++) {
            this.load.image(`ht_walk_${i}`, `assets/sprites/heavy_tank_walk/${i}.png`);
            this.load.image(`ht_walk_red_${i}`, `assets/sprites/heavy_tank_red_walk/luxa.org-color-changed-${i}.png`);
        }
        for (let i = 1; i <= 21; i++) {
            this.load.image(`ht_shoot_${i}`, `assets/sprites/heavy_tank_shoot/${i}.png`);
            this.load.image(`ht_shoot_red_${i}`, `assets/sprites/heavy_tank_red_shoot/luxa.org-color-changed-${i}.png`);
        }
        for (let i = 1; i <= 19; i++) this.load.image(`ht_death_${i}`, `assets/sprites/heavy_tank_death/${i}.png`);
        this.load.image('icon_sniper', 'assets/images/sniper.png');
        this.load.image('icon_sniper_red', 'assets/images/sniper_red.png');
        for (let i = 1; i <= 20; i++) {
            this.load.image(`sn_walk_${i}`, `assets/sprites/sniper_walk/${i}.png`);
            this.load.image(`sn_walk_red_${i}`, `assets/sprites/sniper_red_walk/${i}.png`);
        }
        for (let i = 1; i <= 15; i++) {
            this.load.image(`sn_shoot_${i}`, `assets/sprites/sniper_shoot/${i}.png`);
            this.load.image(`sn_shoot_red_${i}`, `assets/sprites/sniper_red_shoot/${i}.png`);
        }
        for (let i = 1; i <= 21; i++) {
            this.load.image(`sn_crouch_${i}`, `assets/sprites/sniper_crouch/${i}.png`);
            this.load.image(`sn_crouch_red_${i}`, `assets/sprites/sniper_red_crouch/${i}.png`);
        }
        for (let i = 1; i <= 111; i++) this.load.image(`sn_death_1_${i}`, `assets/sprites/sniper_death_1/${i}.png`);
        for (let i = 1; i <= 112; i++) this.load.image(`sn_death_red_1_${i}`, `assets/sprites/sniper_red_death_1/${i}.png`);
        for (let i = 1; i <= 126; i++) {
            this.load.image(`sn_death_2_${i}`, `assets/sprites/sniper_death_2/${i}.png`);
            this.load.image(`sn_death_red_2_${i}`, `assets/sprites/sniper_red_death_2/${i}.png`);
        }
        this.load.image('icon_engineer', 'assets/images/enginer.png');
        this.load.image('icon_engineer_red', 'assets/images/enginer_red.png');
        for (let i = 1; i <= 20; i++) {
            this.load.image(`en_walk_${i}`, `assets/sprites/enginer_walk/${i}.png`);
            this.load.image(`en_walk_red_${i}`, `assets/sprites/enginer_red_walk/${i}.png`);
        }
        for (let i = 1; i <= 21; i++) {
            this.load.image(`en_crouch_${i}`, `assets/sprites/enginer_crouch/${i}.png`);
            this.load.image(`en_crouch_red_${i}`, `assets/sprites/enginer_crouch_red/${i}.png`);
        }
        for (let i = 1; i <= 15; i++) {
            this.load.image(`en_trench_${i}`, `assets/sprites/enginer_trech/${i}.png`);
            this.load.image(`en_trench_red_${i}`, `assets/sprites/enginer_red_trench/${i}.png`);
        }
        for (let i = 1; i <= 111; i++) this.load.image(`en_death_1_${i}`, `assets/sprites/enginer_death_1/${i}.png`);
        for (let i = 1; i <= 112; i++) this.load.image(`en_death_red_1_${i}`, `assets/sprites/enginer_death_red_1/${i}.png`);
        for (let i = 1; i <= 126; i++) {
            this.load.image(`en_death_2_${i}`, `assets/sprites/enginer_death_2/${i}.png`);
            this.load.image(`en_death_red_2_${i}`, `assets/sprites/enginer_death_red_2/${i}.png`);
        }
        this.load.image('icon_miner', 'assets/images/miner.png');
        this.load.image('icon_miner_red', 'assets/images/miner_red.png');
        for (let i = 1; i <= 20; i++) {
            this.load.image(`mn_walk_${i}`, `assets/sprites/miner_walk/${i}.png`);
            this.load.image(`mn_walk_red_${i}`, `assets/sprites/miner_walk_red/${i}.png`);
        }
        for (let i = 1; i <= 16; i++) {
            this.load.image(`mn_plant_${i}`, `assets/sprites/miner_planting/${i}.png`);
            this.load.image(`mn_plant_red_${i}`, `assets/sprites/miner_plant_red/${i}.png`);
        }
        for (let i = 1; i <= 18; i++) this.load.image(`mn_death_${i}`, `assets/sprites/miner_death/${i}.png`);
        this.load.image('trenchSprite', 'assets/images/trench.png');
        this.load.image('blueMine', 'assets/sprites/Blue_Mine/1.png');
        this.load.image('redMine', 'assets/sprites/Red_Mine/1.png');
        for (let i = 1; i <= 37; i++) this.load.image(`mineExplosion_${i}`, `assets/sprites/DefineSprite_371_MineExplosion/${i}.png`);
        this.load.image('spawnArrow', 'assets/sprites/spawn arrow/spawn arrow.png');

        // Start loading and handle progress
        this.load.on('progress', (v) => {
            barFill.width = 396 * v;
            loadText.setText(v < 1 ? `Loading... ${Math.floor(v * 100)}%` : 'Starting game...');
        });
        this.load.on('complete', () => {
            barBg.destroy(); barFill.destroy(); loadText.destroy();
            this.time.delayedCall(500, () => this.showMenu()); // brief pause after slideshow
        });
        this.load.start();
    }

    showMenu() {
        let cx = window.innerWidth / 2, cy = window.innerHeight / 2;

        // Dim backgrounds
        let dim = this.add.rectangle(cx, cy, window.innerWidth, window.innerHeight, 0x000000, 0.6).setDepth(1);

        // Stars
        for (let i = 0; i < 40; i++) {
            let star = this.add.rectangle(
                Math.random() * window.innerWidth,
                Math.random() * window.innerHeight,
                2, 2, 0xffffff, Math.random() * 0.6 + 0.2
            ).setDepth(1);
            this.tweens.add({
                targets: star, alpha: 0.1, duration: 1000 + Math.random() * 2000,
                yoyo: true, repeat: -1
            });
        }

        // Glow
        let glow = this.add.circle(cx, cy - 100, 200, 0x003366, 0.3).setDepth(1);
        this.tweens.add({ targets: glow, scaleX: 1.5, scaleY: 1.5, alpha: 0.1, duration: 2000, yoyo: true, repeat: -1 });

        let title = this.add.text(cx, cy - 120, 'MOTHERSHIP\nWARFARE', {
            fontFamily: 'Impact, sans-serif', fontSize: '72px', color: '#00ffff',
            align: 'center', stroke: '#003366', strokeThickness: 6,
            shadow: { offsetX: 0, offsetY: 0, color: '#00ffff', blur: 20, stroke: true, fill: true }
        }).setOrigin(0.5).setDepth(2).setAlpha(0);
        this.tweens.add({ targets: title, alpha: 1, duration: 1000, ease: 'Power2' });

        let subtitle = this.add.text(cx, cy - 20, 'Choose your path', {
            fontSize: '20px', color: '#6688aa', fontFamily: 'Arial'
        }).setOrigin(0.5).setDepth(2).setAlpha(0);
        this.tweens.add({ targets: subtitle, alpha: 1, duration: 1200, delay: 300 });

        // Single Player button
        let spBtn = this.add.rectangle(cx, cy + 60, 280, 55, 0x004488, 0.9)
            .setStrokeStyle(2, 0x00ffff).setDepth(3).setInteractive({ useHandCursor: true });
        let spText = this.add.text(cx, cy + 60, 'SINGLE PLAYER', {
            fontSize: '22px', color: '#ffffff', fontFamily: 'Impact'
        }).setOrigin(0.5).setDepth(4);
        [spBtn, spText].forEach(o => o.setAlpha(0));
        this.tweens.add({ targets: [spBtn, spText], alpha: 1, duration: 800, delay: 600 });

        spBtn.on('pointerover', () => { spBtn.setFillStyle(0x0066aa); spText.setColor('#00ffff'); });
        spBtn.on('pointerout', () => { spBtn.setFillStyle(0x004488, 0.9); spText.setColor('#ffffff'); });
        spBtn.on('pointerdown', () => {
            this.registry.set('gameMode', 'singlePlayer');
            this.registry.set('playerSide', 'blue');
            this.registry.set('playerDeck', ['infantry', 'missile', 'tank', 'heavy_tank', 'sniper', 'engineer', 'miner']);
            this.scene.start('GameScene');
        });

        // Multiplayer button
        let mpBtn = this.add.rectangle(cx, cy + 130, 280, 55, 0x442200, 0.9)
            .setStrokeStyle(2, 0xff8844).setDepth(3).setInteractive({ useHandCursor: true });
        let mpText = this.add.text(cx, cy + 130, 'MULTIPLAYER', {
            fontSize: '22px', color: '#ffffff', fontFamily: 'Impact'
        }).setOrigin(0.5).setDepth(4);
        [mpBtn, mpText].forEach(o => o.setAlpha(0));
        this.tweens.add({ targets: [mpBtn, mpText], alpha: 1, duration: 800, delay: 800 });

        mpBtn.on('pointerover', () => { mpBtn.setFillStyle(0x663300); mpText.setColor('#ff8844'); });
        mpBtn.on('pointerout', () => { mpBtn.setFillStyle(0x442200, 0.9); mpText.setColor('#ffffff'); });
        mpBtn.on('pointerdown', () => { this.showLobby(); });
    }

    showLobby() {
        let cx = window.innerWidth / 2, cy = window.innerHeight / 2;
        this.children.removeAll(true);

        for (let i = 0; i < 40; i++) {
            this.add.rectangle(
                Math.random() * window.innerWidth,
                Math.random() * window.innerHeight,
                2, 2, 0xffffff, Math.random() * 0.6 + 0.2
            ).setDepth(0);
        }

        this.add.text(cx, cy - 120, 'MULTIPLAYER LOBBY', {
            fontFamily: 'Impact', fontSize: '48px', color: '#ff8844',
            stroke: '#331100', strokeThickness: 4
        }).setOrigin(0.5).setDepth(1);

        let hostBtn = this.add.rectangle(cx - 160, cy, 240, 50, 0x004488, 0.9)
            .setStrokeStyle(2, 0x00ffff).setDepth(2).setInteractive({ useHandCursor: true });
        this.add.text(cx - 160, cy, 'HOST GAME', {
            fontSize: '20px', color: '#ffffff', fontFamily: 'Impact'
        }).setOrigin(0.5).setDepth(3);
        hostBtn.on('pointerover', () => hostBtn.setFillStyle(0x0066aa));
        hostBtn.on('pointerout', () => hostBtn.setFillStyle(0x004488, 0.9));
        hostBtn.on('pointerdown', () => {
            let code = this.generateRoomCode();
            // Show the code before transitioning
            hostBtn.disableInteractive();
            joinBtn.disableInteractive();
            backBtn.disableInteractive();
            let codeText = this.add.text(cx, cy + 80, 'Room Code: ' + code, {
                fontSize: '36px', color: '#00ffff', fontFamily: 'Impact',
                stroke: '#003366', strokeThickness: 4
            }).setOrigin(0.5).setDepth(5);
            let shareText = this.add.text(cx, cy + 115, 'Share this code with your friend', {
                fontSize: '16px', color: '#aaaacc', fontFamily: 'Arial'
            }).setOrigin(0.5).setDepth(5);
            let readyBtn = this.add.rectangle(cx, cy + 170, 200, 44, 0x004488, 0.9)
                .setStrokeStyle(2, 0x00ffff).setDepth(5).setInteractive({ useHandCursor: true });
            let readyLabel = this.add.text(cx, cy + 170, 'READY', {
                fontSize: '20px', color: '#ffffff', fontFamily: 'Impact'
            }).setOrigin(0.5).setDepth(6);
            readyBtn.on('pointerover', () => readyBtn.setFillStyle(0x0066aa));
            readyBtn.on('pointerout', () => readyBtn.setFillStyle(0x004488, 0.9));
            readyBtn.on('pointerdown', () => { this.startDeck('blue', code); });
        });

        let joinBtn = this.add.rectangle(cx + 160, cy, 240, 50, 0x442200, 0.9)
            .setStrokeStyle(2, 0xff8844).setDepth(2).setInteractive({ useHandCursor: true });
        this.add.text(cx + 160, cy, 'JOIN GAME', {
            fontSize: '20px', color: '#ffffff', fontFamily: 'Impact'
        }).setOrigin(0.5).setDepth(3);
        joinBtn.on('pointerover', () => joinBtn.setFillStyle(0x663300));
        joinBtn.on('pointerout', () => joinBtn.setFillStyle(0x442200, 0.9));
        joinBtn.on('pointerdown', () => {
            let code = prompt('Enter 6-character room code:');
            if (code && code.length >= 3) this.startDeck('red', code.toUpperCase());
        });

        let backBtn = this.add.text(cx, cy + 120, 'Back', {
            fontSize: '18px', color: '#888888', fontFamily: 'Arial'
        }).setOrigin(0.5).setDepth(2).setInteractive({ useHandCursor: true });
        backBtn.on('pointerdown', () => { this.scene.restart(); });
        backBtn.on('pointerover', () => backBtn.setColor('#ffffff'));
        backBtn.on('pointerout', () => backBtn.setColor('#888888'));
    }

    startDeck(side, roomCode) {
        this.registry.set('gameMode', 'multiplayer');
        this.registry.set('playerSide', side);
        this.registry.set('roomCode', roomCode || this.generateRoomCode());
        this.scene.start('DeckScene');
    }

    generateRoomCode() {
        let chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
        let code = '';
        for (let i = 0; i < 6; i++) code += chars[Math.floor(Math.random() * chars.length)];
        return code;
    }
}
