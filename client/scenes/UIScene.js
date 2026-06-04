class UIScene extends Phaser.Scene {
    constructor() {
        super({ key: 'UIScene' });
    }

    create() {
        this.registry.set('armedUnit', null);

        let gameMode = this.registry.get('gameMode') || 'singlePlayer';
        let isMultiplayer = gameMode === 'multiplayer';

        let halfWidth = window.innerWidth / 2;
        let uiOffset = 196;
        let barWidth = halfWidth - uiOffset;

        // BLUE UI (left side)
        this.add.image(uiOffset + barWidth, 0, 'barBlue').setDisplaySize(barWidth, 100).setOrigin(1, 0).setScrollFactor(0);
        this.add.rectangle(uiOffset / 2, 55, uiOffset, 110, 0x4a6a8a).setScrollFactor(0);
        let pUIBase = this.add.image(uiOffset / 2, 45, 'masterBases').setScrollFactor(0);
        pUIBase.setCrop(0, 0, pUIBase.width / 2, pUIBase.height);
        pUIBase.setScale(0.21, 0.21);
        this.add.rectangle(uiOffset / 2, 100, uiOffset, 25, 0x222222).setScrollFactor(0);
        this.add.text(uiOffset / 2, 100, 'Storm Attack', { fontSize: '14px', color: '#ffffff' }).setOrigin(0.5).setScrollFactor(0);
        this.add.text(uiOffset + 10, 20, 'Acturus. Zone 1', { fontFamily: 'Impact', fontSize: '32px', color: '#ffffff', stroke: '#000000', strokeThickness: 4 }).setOrigin(0, 0).setScrollFactor(0);

        // RED UI (right side, decorative — AI controlled)
        let rightUiOffset = window.innerWidth - uiOffset;
        this.add.image(rightUiOffset, 0, 'barRed').setDisplaySize(barWidth, 100).setOrigin(0, 0).setScrollFactor(0);
        this.add.rectangle(window.innerWidth - uiOffset / 2, 55, uiOffset, 110, 0x8a4a4a).setScrollFactor(0);
        let eUIBase = this.add.image(window.innerWidth - uiOffset / 2, 45, 'masterBases').setScrollFactor(0);
        eUIBase.setCrop(eUIBase.width / 2, 0, eUIBase.width / 2, eUIBase.height);
        eUIBase.setScale(0.21, 0.21);
        this.add.rectangle(window.innerWidth - uiOffset / 2, 100, uiOffset, 25, 0x222222).setScrollFactor(0);
        this.add.text(window.innerWidth - uiOffset / 2, 100, 'Storm Attack', { fontSize: '14px', color: '#ffffff' }).setOrigin(0.5).setScrollFactor(0);
        this.add.text(window.innerWidth - uiOffset - 10, 20, 'Enemy Sector', { fontFamily: 'Impact', fontSize: '32px', color: '#ffffff', stroke: '#000000', strokeThickness: 4 }).setOrigin(1, 0).setScrollFactor(0);

        // Deploy buttons
        let btnSize = 70;
        let btnY = 100;

        const createDeployButton = (x, y, iconKey, tintColor, unitName) => {
            let bg = this.add.image(x, y, 'btn_bg').setOrigin(0, 0).setDisplaySize(btnSize, btnSize).setScrollFactor(0);
            let icon = this.add.image(x + btnSize / 2, y + btnSize / 2, iconKey).setOrigin(0.5).setScrollFactor(0);
            let maxDim = 60;
            let scale = Math.min(maxDim / icon.width, maxDim / icon.height);
            if (iconKey.includes('sniper')) {
                icon.setDisplaySize(60, 43);
                scale = icon.scaleX;
            } else {
                icon.setScale(scale);
            }
            bg.setInteractive({ useHandCursor: true });
            bg.on('pointerover', () => {
                bg.setTexture('btn_bg_hover');
                this.tweens.add({ targets: icon, scaleX: scale * 1.1, scaleY: scale * 1.1, duration: 100 });
            });
            bg.on('pointerout', () => {
                bg.setTexture('btn_bg');
                this.tweens.add({ targets: icon, scaleX: scale, scaleY: scale, duration: 100 });
            });
            bg.on('pointerdown', () => { bg.setTint(0xaaaaaa); });
            bg.on('pointerup', () => {
                let current = this.registry.get('armedUnit');
                if (current === unitName) {
                    this.deselectAll();
                } else {
                    this.deselectAll();
                    this.registry.set('armedUnit', unitName);
                    bg.setTint(tintColor);
                    this.scene.get('GameScene').updateSpawnArrows();
                }
            });
            return bg;
        };

        const createGrayedButton = (x, y, iconKey) => {
            let bg = this.add.image(x, y, 'btn_bg').setOrigin(0, 0).setDisplaySize(btnSize, btnSize).setScrollFactor(0).setAlpha(0.35);
            let icon = this.add.image(x + btnSize / 2, y + btnSize / 2, iconKey).setOrigin(0.5).setScrollFactor(0).setAlpha(0.5);
            let maxDim = 60;
            let scale = Math.min(maxDim / icon.width, maxDim / icon.height);
            if (iconKey.includes('sniper')) { icon.setDisplaySize(60, 43); } else { icon.setScale(scale); }
            return bg;
        };

        // Determine which side the local player controls
        let localSide = isMultiplayer ? (this.registry.get('playerSide') || 'blue') : 'blue';
        let isLocalBlue = localSide === 'blue';

        // Read deck for the LOCAL player (set by MenuScene/DeckScene)
        let playerDeck = this.registry.get('playerDeck') || ['infantry', 'missile', 'tank', 'heavy_tank', 'sniper', 'engineer', 'miner'];
        let defaultBlueNames = ['infantry', 'missile', 'tank', 'heavy_tank', 'sniper', 'engineer', 'miner'];
        let defaultRedNames = ['infantry_red', 'missile_red', 'tank_red', 'heavy_tank_red', 'sniper_red', 'engineer_red', 'miner_red'];
        let allIconKeys = ['icon_infantry', 'icon_missile', 'icon_tank', 'icon_heavy_tank', 'icon_sniper', 'icon_engineer', 'icon_miner'];
        let redIconKeys = ['icon_infantry_red', 'icon_missile_red', 'icon_tank_red', 'icon_heavy_tank_red', 'icon_sniper_red', 'icon_engineer_red', 'icon_miner_red'];

        // Blue deploy buttons (left side) — use blue deck if local is blue, else show all 7 grayed
        let blueBtnStartX = uiOffset;
        let blueInteractive = !isMultiplayer || isLocalBlue;
        let blueDeck = blueInteractive ? playerDeck : defaultBlueNames;
        for (let i = 0; i < 7; i++) {
            let bx = blueBtnStartX + i * btnSize;
            let unitName = blueDeck[i];
            let iconKey = allIconKeys[defaultBlueNames.indexOf(unitName === 'infantry_red' ? 'infantry' : unitName.replace(/_red$/, ''))];
            if (!iconKey) iconKey = allIconKeys[i];
            if (blueInteractive) {
                this['blue' + ['BtnBg', 'MMBg', 'TankBg', 'HTBg', 'SNBg', 'ENBg', 'MNBg'][i]] = createDeployButton(bx, btnY, iconKey, 0x00ffcc, unitName);
            } else {
                let bg = this.add.image(bx, btnY, 'btn_bg').setOrigin(0, 0).setDisplaySize(btnSize, btnSize).setScrollFactor(0).setAlpha(0.35);
                let icon = this.add.image(bx + btnSize / 2, btnY + btnSize / 2, iconKey).setOrigin(0.5).setScrollFactor(0).setAlpha(0.5);
                let maxDim = 60;
                let scale = Math.min(maxDim / icon.width, maxDim / icon.height);
                if (iconKey.includes('sniper')) { icon.setDisplaySize(60, 43); } else { icon.setScale(scale); }
                this['blue' + ['BtnBg', 'MMBg', 'TankBg', 'HTBg', 'SNBg', 'ENBg', 'MNBg'][i]] = bg;
            }
        }

        // Red deploy buttons (right side) — use red deck if local is red, else show all 7 grayed
        let redBtnStartX = window.innerWidth - uiOffset - btnSize * 7;
        let redInteractive = isMultiplayer && !isLocalBlue;
        let redDeck = redInteractive ? playerDeck : defaultRedNames;
        for (let i = 0; i < 7; i++) {
            let bx = redBtnStartX + i * btnSize;
            let unitName = redDeck[i];
            let iconKey = redIconKeys[defaultRedNames.indexOf(unitName)];
            if (iconKey === undefined) iconKey = redIconKeys[i];
            if (redInteractive) {
                this['red' + ['BtnBg', 'MMBg', 'TankBg', 'HTBg', 'SNBg', 'ENBg', 'MNBg'][i]] = createDeployButton(bx, btnY, iconKey, 0xff4444, unitName);
            } else {
                this['red' + ['BtnBg', 'MMBg', 'TankBg', 'HTBg', 'SNBg', 'ENBg', 'MNBg'][i]] = createGrayedButton(bx, btnY, iconKey);
            }
        }

        // Player economy bar (bottom center)
        this.barW = 800;
        let barH = 50;
        let barX = window.innerWidth / 2;
        let barY = window.innerHeight - 40;

        let ecoBg = this.add.graphics().setScrollFactor(0);
        ecoBg.fillStyle(0x050f1a, 0.95);
        ecoBg.lineStyle(3, 0x00ffff, 1);
        ecoBg.beginPath();
        ecoBg.moveTo(barX - this.barW / 2 - 25, barY + barH / 2);
        ecoBg.lineTo(barX - this.barW / 2 + 25, barY - barH / 2);
        ecoBg.lineTo(barX + this.barW / 2 - 25, barY - barH / 2);
        ecoBg.lineTo(barX + this.barW / 2 + 25, barY + barH / 2);
        ecoBg.closePath();
        ecoBg.fillPath();
        ecoBg.strokePath();

        this.creditFill = this.add.rectangle(barX - this.barW / 2 + 30, barY, 0, barH - 18, 0x00ffff, 0.8).setOrigin(0, 0.5).setScrollFactor(0);
        this.creditsText = this.add.text(barX, barY, 'CREDITS: 0 / 1000', {
            fontFamily: 'Impact, sans-serif',
            fontSize: '32px',
            letterSpacing: 2,
            color: '#ffffff',
            shadow: { offsetX: 0, offsetY: 0, color: '#00ffff', blur: 12, stroke: true, fill: true }
        }).setOrigin(0.5).setScrollFactor(0);

        // Player credits registry listener
        this.registry.events.on('changedata-credits', (parent, value) => {
            this.updateEconomyUI(value);
        });
        this.registry.set('credits', 0);

        // Player credits timer
        this.time.addEvent({
            delay: 1000, loop: true,
            callback: () => {
                let credits = this.registry.get('credits');
                if (credits < MAX_CREDITS) {
                    this.registry.set('credits', credits + CREDITS_PER_SEC);
                }
            }
        });

        if (!isMultiplayer) {
            // AI economy bar (single-player only — top-right, below red portrait)
            let aiBarW = 120;
            let aiBarH = 16;
            let aiBarX = window.innerWidth - uiOffset + 15;
            let aiBarY = 128;
            let aiEcoBg = this.add.graphics().setScrollFactor(0);
            aiEcoBg.fillStyle(0x222222, 0.8);
            aiEcoBg.fillRect(aiBarX, aiBarY - aiBarH / 2, aiBarW, aiBarH);
            aiEcoBg.lineStyle(1, 0xff4444, 0.8);
            aiEcoBg.strokeRect(aiBarX, aiBarY - aiBarH / 2, aiBarW, aiBarH);
            this.aiCreditFill = this.add.rectangle(aiBarX + 2, aiBarY, 0, aiBarH - 4, 0xff4444, 0.7).setOrigin(0, 0.5).setScrollFactor(0);
            this.aiCreditsText = this.add.text(aiBarX + aiBarW / 2, aiBarY, 'AI', {
                fontSize: '10px', color: '#ffffff', fontFamily: 'Arial'
            }).setOrigin(0.5).setScrollFactor(0);

            this.registry.events.on('changedata-aiCredits', (parent, value) => {
                this.updateAiEconomyUI(value);
            });
            this.registry.set('aiCredits', 200);
        }

        // --- Command panel ---
        this.cmdPanelY = window.innerHeight - 140;
        this.cmdPanelVisible = false;
        this.cmdButtons = [];
        let cmdData = [
            { label: 'Hold [H]', key: 'H', method: 'cmdHold', combat: true },
            { label: 'Fallback [F]', key: 'F', method: 'cmdFallback', combat: true },
            { label: 'Jump [J]', key: 'J', method: 'cmdJump', combat: true },
            { label: 'Build [B]', key: 'B', method: 'cmdBuildTrench', trench: true },
            { label: 'Destroy [D]', key: 'D', method: 'cmdDestroyTrench', trench: true }
        ];
        let btnW = 100, btnH = 36, gap = 6;
        let totalW = cmdData.length * btnW + (cmdData.length - 1) * gap;
        let startX = window.innerWidth / 2 - totalW / 2;
        cmdData.forEach((d, i) => {
            let bx = startX + i * (btnW + gap);
            let bg = this.add.rectangle(bx, this.cmdPanelY, btnW, btnH, 0x333333, 0.9)
                .setStrokeStyle(1, 0x888888).setScrollFactor(0).setAlpha(0);
            let label = this.add.text(bx, this.cmdPanelY, d.label, {
                fontSize: '12px', color: '#ffffff', fontFamily: 'Arial'
            }).setOrigin(0.5).setScrollFactor(0).setAlpha(0);
            bg.setInteractive({ useHandCursor: true });
            bg.on('pointerover', () => bg.setFillStyle(0x555555));
            bg.on('pointerout', () => bg.setFillStyle(0x333333, 0.9));
            bg.on('pointerdown', () => {
                this.scene.get('GameScene')[d.method]();
                this.updateCommandPanel(null);
            });
            bg._cmdKey = d.key;
            bg._cmdMethod = d.method;
            bg._combat = d.combat;
            bg._trench = d.trench;
            this.cmdButtons.push({ bg, label, data: d });
        });

        this.registry.events.on('changedata-selectedUnit', (parent, value) => {
            this.updateCommandPanel(value);
        });

        // Keyboard shortcuts (based on player side)
        let unitKeyMap = {
            'ONE': 0, 'TWO': 1, 'THREE': 2, 'FOUR': 3,
            'FIVE': 4, 'SIX': 5, 'SEVEN': 6
        };
        let blueUnitKeys = ['infantry', 'missile', 'tank', 'heavy_tank', 'sniper', 'engineer', 'miner'];
        let redUnitKeys = ['infantry_red', 'missile_red', 'tank_red', 'heavy_tank_red', 'sniper_red', 'engineer_red', 'miner_red'];
        let unitKeys = isLocalBlue ? blueUnitKeys : redUnitKeys;
        let btnBgs = isLocalBlue
            ? [this.blueBtnBg, this.blueMMBg, this.blueTankBg, this.blueHTBg, this.blueSNBg, this.blueENBg, this.blueMNBg]
            : [this.redBtnBg, this.redMMBg, this.redTankBg, this.redHTBg, this.redSNBg, this.redENBg, this.redMNBg];
        let tintColor = isLocalBlue ? 0x00ffcc : 0xff4444;
        Object.keys(unitKeyMap).forEach(keyName => {
            this.input.keyboard.on('keydown-' + keyName, () => {
                let idx = unitKeyMap[keyName];
                let unitName = unitKeys[idx];
                let current = this.registry.get('armedUnit');
                if (current === unitName) { this.deselectAll(); } else { this.deselectAll(); this.registry.set('armedUnit', unitName); if (btnBgs[idx]) btnBgs[idx].setTint(tintColor); this.scene.get('GameScene').updateSpawnArrows(); }
            });
        });
        this.input.keyboard.on('keydown-SPACE', () => { this.scene.get('GameScene').deployAtNearestLane(); });
        this.input.keyboard.on('keydown-ENTER', () => { this.scene.get('GameScene').deployAtNearestLane(); });
        this.input.keyboard.on('keydown-W', () => { this.scene.get('GameScene').cycleLane(-1); });
        this.input.keyboard.on('keydown-S', () => { this.scene.get('GameScene').cycleLane(1); });
        this.input.keyboard.on('keydown-UP', () => { this.scene.get('GameScene').cycleLane(-1); });
        this.input.keyboard.on('keydown-DOWN', () => { this.scene.get('GameScene').cycleLane(1); });
    }

    deselectAll() {
        this.registry.set('armedUnit', null);
        let blueBgs = [this.blueBtnBg, this.blueMMBg, this.blueTankBg, this.blueHTBg, this.blueSNBg, this.blueENBg, this.blueMNBg];
        let redBgs = [this.redBtnBg, this.redMMBg, this.redTankBg, this.redHTBg, this.redSNBg, this.redENBg, this.redMNBg];
        blueBgs.forEach(b => { if (b && b.clearTint) b.clearTint(); });
        redBgs.forEach(b => { if (b && b.clearTint) b.clearTint(); });
        this.scene.get('GameScene').updateSpawnArrows();
    }

    updateEconomyUI(credits) {
        this.creditsText.setText('CREDITS: ' + credits + ' / 1000');
        this.creditFill.width = (this.barW - 60) * (credits / MAX_CREDITS);
    }

    updateAiEconomyUI(credits) {
        this.aiCreditsText.setText('AI: ' + Math.floor(credits));
        this.aiCreditFill.width = (120 - 4) * (credits / MAX_CREDITS);
    }

    updateCommandPanel(sel) {
        let show = sel !== null && sel !== undefined;
        this.cmdButtons.forEach(btn => {
            let visible = false;
            if (show) {
                if (sel.isTrench) {
                    visible = btn.data.trench;
                } else if (sel.unitType) {
                    let combat = sel.unitType !== 'en' && sel.unitType !== 'mn';
                    if (btn.data.combat && combat) visible = true;
                    if (btn.data.combat && btn.data.label.startsWith('Jump') && sel.unitType === 'en') visible = true;
                    if (btn.data.trench && sel._enReadyToBuild && btn.data.label.startsWith('Build')) visible = true;
                }
            }
            if (visible) {
                btn.bg.setAlpha(1);
                btn.label.setAlpha(1);
            } else {
                btn.bg.setAlpha(0);
                btn.label.setAlpha(0);
            }
        });
    }
}
