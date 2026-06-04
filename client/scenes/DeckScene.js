class DeckScene extends Phaser.Scene {
    constructor() {
        super({ key: 'DeckScene' });
    }

    create() {
        let cx = window.innerWidth / 2, cy = window.innerHeight / 2;
        let playerSide = this.registry.get('playerSide') || 'blue';
        let isBlue = playerSide === 'blue';
        let accentColor = isBlue ? 0x00ffff : 0xff8844;
        let accentStr = isBlue ? '#00ffff' : '#ff8844';
        let btnColor = isBlue ? 0x004488 : 0x552200;
        let btnHover = isBlue ? 0x0066aa : 0x774400;

        // Background
        this.add.rectangle(cx, cy, window.innerWidth, window.innerHeight, 0x0a0a1a).setDepth(0);

        // Animated stars
        for (let i = 0; i < 50; i++) {
            let star = this.add.rectangle(
                Math.random() * window.innerWidth, Math.random() * window.innerHeight,
                1 + Math.random() * 2, 1 + Math.random() * 2, 0xffffff, 0.3 + Math.random() * 0.5
            ).setDepth(0);
            this.tweens.add({ targets: star, alpha: 0.1, duration: 800 + Math.random() * 2000, yoyo: true, repeat: -1 });
        }

        // Title
        let title = this.add.text(cx, 35, 'BUILD YOUR DECK', {
            fontFamily: 'Impact', fontSize: '36px', color: accentStr,
            stroke: '#000000', strokeThickness: 5
        }).setOrigin(0.5).setDepth(2);

        let sideText = this.add.text(cx, 65, `You are ${isBlue ? 'BLUE' : 'RED'}`, {
            fontSize: '15px', color: '#aaaaaa', fontFamily: 'Arial'
        }).setOrigin(0.5).setDepth(2);

        // --- Stats Panel (left side) ---
        let panelX = 20, panelY = cy - 60, panelW = 200, panelH = 280;
        let panelBg = this.add.rectangle(panelX + panelW / 2, panelY + panelH / 2, panelW, panelH, 0x111122, 0.9)
            .setStrokeStyle(2, accentColor, 0.4).setDepth(5).setAlpha(0);
        let statName = this.add.text(panelX + panelW / 2, panelY + 20, '', {
            fontSize: '20px', color: accentStr, fontFamily: 'Impact'
        }).setOrigin(0.5).setDepth(6).setAlpha(0);
        let statLines = [];
        let lineY = panelY + 50;
        let labels = ['Cost', 'Damage', 'HP', 'Speed', 'Sight', 'Recharge', 'Special'];
        let vals = ['', '', '', '', '', '', ''];
        for (let i = 0; i < labels.length; i++) {
            let t = this.add.text(panelX + 12, lineY + i * 32, '', {
                fontSize: '13px', color: '#cccccc', fontFamily: 'Arial'
            }).setDepth(6).setAlpha(0);
            statLines.push(t);
        }

        let showStats = (unitType, unitName) => {
            if (!unitType) { panelBg.setAlpha(0); statName.setAlpha(0); statLines.forEach(s => s.setAlpha(0)); return; }
            let s = UNIT_STATS[unitType];
            let displayName = unitName.charAt(0).toUpperCase() + unitName.slice(1).replace('_', ' ');
            statName.setText(displayName);
            let cost = UNIT_COST[unitName] || 0;
            let dmgKey = 'inf->inf';
            let dmg = DAMAGE_TABLE[dmgKey] || s.dmg;
            let special = '';
            if (unitType === 'sn') special = 'Skips tank targets';
            else if (unitType === 'en') special = 'Builds trenches';
            else if (unitType === 'mn') special = 'Plants mines';
            else if (unitType === 'st') special = 'Armored vehicle';
            else if (unitType === 'ht') special = 'Heavy armor';
            else if (unitType === 'mm') special = 'Anti-armor';
            else special = 'Standard infantry';
            let infoLines = [
                `Cost: ${cost}`,
                `Damage: ${s.dmg}`,
                `HP: ${s.hp}`,
                `Speed: ${s.speed}px/s`,
                `Range: ${s.eyeRange}px`,
                `Recharge: ${s.recharge}ms`,
                special
            ];
            statLines.forEach((t, i) => { t.setText(infoLines[i] || '').setAlpha(1); });
            panelBg.setAlpha(1);
            statName.setAlpha(1);
        };
        let hideStats = () => { panelBg.setAlpha(0); statName.setAlpha(0); statLines.forEach(s => s.setAlpha(0)); };
        hideStats();

        // --- Card data ---
        let suffix = isBlue ? '' : '_red';
        let unitNames = ['infantry', 'missile', 'tank', 'heavy_tank', 'sniper', 'engineer', 'miner'];
        let unitKeys = unitNames.map(n => n + suffix);
        let unitTypes = unitNames.map(n => UNIT_TYPE_FROM_NAME[n + suffix]);
        let iconKeys = ['icon_infantry', 'icon_missile', 'icon_tank', 'icon_heavy_tank', 'icon_sniper', 'icon_engineer', 'icon_miner'];
        let displayNames = ['Infantry', 'Missile Man', 'Storm Tank', 'Heavy Tank', 'Sniper', 'Engineer', 'Miner'];

        // --- Deck slots (top row) ---
        let slotSize = 72;
        let totalW = 7 * slotSize + 6 * 10;
        let startX = cx - totalW / 2 + slotSize / 2;
        let slotY = cy - 85;
        let slots = [];
        let deck = [];
        let slotBgs = [];
        let slotIcons = [];
        let slotLabels = [];

        for (let i = 0; i < 7; i++) {
            let sx = startX + i * (slotSize + 10);
            let bg = this.add.rectangle(sx, slotY, slotSize, slotSize, 0x1a1a2e, 0.9)
                .setStrokeStyle(2, 0x444466).setDepth(2);
            let icon = this.add.image(sx, slotY, iconKeys[0]).setDepth(3).setAlpha(0);
            let label = this.add.text(sx, slotY + slotSize / 2 + 10, `${i + 1}`, {
                fontSize: '11px', color: '#555577', fontFamily: 'Arial'
            }).setOrigin(0.5).setDepth(2);
            bg.setInteractive({ useHandCursor: true });
            bg.on('pointerdown', () => {
                let idx = deck.indexOf(deck[i]);
                if (idx >= 0) {
                    deck.splice(idx, 1);
                    updateDeckUI();
                }
            });
            bg.on('pointerover', () => {
                if (deck[i]) {
                    let ut = UNIT_TYPE_FROM_NAME[deck[i]];
                    let dn = displayNames[unitKeys.indexOf(deck[i])] || deck[i];
                    showStats(ut, dn);
                }
            });
            bg.on('pointerout', hideStats);
            slots.push({ bg, icon, label, idx: i });
            slotBgs.push(bg);
            slotIcons.push(icon);
            slotLabels.push(label);
        }

        // --- Unit cards (middle) ---
        let cardY = cy + 50;
        let cardW = slotSize, cardH = slotSize + 30;
        let cards = [];
        let rarityColors = [0x44aaff, 0xff44aa, 0xffaa44, 0xaa44ff, 0x44ffaa, 0x888888, 0xff8844];

        for (let i = 0; i < 7; i++) {
            let cx2 = startX + i * (slotSize + 10);
            let cardBg = this.add.rectangle(cx2, cardY, cardW, cardH, 0x1a1a2e, 0.95)
                .setStrokeStyle(3, rarityColors[i], 0.7).setDepth(2);
            // Card highlight
            let glow = this.add.rectangle(cx2, cardY, cardW + 4, cardH + 4, rarityColors[i], 0.08).setDepth(1);

            // Icon
            let icon = this.add.image(cx2, cardY - 5, iconKeys[i]).setDepth(3);
            let maxDim = 52;
            if (iconKeys[i].includes('sniper')) { icon.setDisplaySize(55, 38); } else { icon.setScale(Math.min(maxDim / icon.width, maxDim / icon.height)); }

            // Cost badge (like elixir)
            let costVal = UNIT_COST[unitKeys[i]] || 0;
            let costBadge = this.add.circle(cx2 - cardW / 2 + 14, cardY - cardH / 2 + 14, 14, 0x000000, 0.8)
                .setStrokeStyle(2, isBlue ? 0x00ffff : 0xff8844).setDepth(4);
            let costText = this.add.text(cx2 - cardW / 2 + 14, cardY - cardH / 2 + 14, `${costVal}`, {
                fontSize: '14px', color: '#ffffff', fontFamily: 'Arial', fontStyle: 'bold'
            }).setOrigin(0.5).setDepth(5);

            // Name label
            this.add.text(cx2, cardY + cardH / 2 - 8, displayNames[i], {
                fontSize: '12px', color: '#cccccc', fontFamily: 'Arial'
            }).setOrigin(0.5).setDepth(3);

            // Interactive
            cardBg.setInteractive({ useHandCursor: true });
            cardBg.on('pointerdown', () => {
                if (deck.length >= 7) return;
                if (deck.includes(unitKeys[i])) return;
                deck.push(unitKeys[i]);
                updateDeckUI();
                hideStats();
            });
            cardBg.on('pointerover', () => {
                showStats(unitTypes[i], displayNames[i]);
                this.tweens.add({ targets: cardBg, scaleX: 1.05, scaleY: 1.05, duration: 100 });
                this.tweens.add({ targets: glow, alpha: 0.2, duration: 100 });
            });
            cardBg.on('pointerout', () => {
                hideStats();
                this.tweens.add({ targets: cardBg, scaleX: 1, scaleY: 1, duration: 100 });
                this.tweens.add({ targets: glow, alpha: 0.08, duration: 100 });
            });
            cards.push({ bg: cardBg, icon, unitKey: unitKeys[i], idx: i });
        }

        let updateDeckUI = () => {
            for (let i = 0; i < 7; i++) {
                if (i < deck.length) {
                    let cardIdx = unitKeys.indexOf(deck[i]);
                    let icoKey = iconKeys[cardIdx >= 0 ? cardIdx : 0];
                    slotIcons[i].setTexture(icoKey).setAlpha(1);
                    let md = 50;
                    if (icoKey.includes('sniper')) { slotIcons[i].setDisplaySize(55, 38); } else { slotIcons[i].setScale(Math.min(md / slotIcons[i].width, md / slotIcons[i].height)); }
                    slotBgs[i].setFillStyle(0x222244, 0.95);
                    slotBgs[i].setStrokeStyle(2, accentColor, 0.6);
                    slotLabels[i].setText(`${i + 1}`);
                } else {
                    slotIcons[i].setAlpha(0);
                    slotBgs[i].setFillStyle(0x1a1a2e, 0.9);
                    slotBgs[i].setStrokeStyle(2, 0x444466);
                    slotLabels[i].setText(`${i + 1}`);
                }
            }
            // Update ready button
            let filled = deck.length;
            readyText.setText(filled >= 7 ? 'READY' : `${filled}/7 Selected`);
            readyBtn.setFillStyle(filled >= 7 ? btnColor : 0x333333, filled >= 7 ? 0.9 : 0.6);
        };

        // Fill deck with all 7 by default
        unitKeys.forEach(k => deck.push(k));
        updateDeckUI();

        // --- Ready Button ---
        let readyBtn = this.add.rectangle(cx, cy + 170, 240, 50, btnColor, 0.9)
            .setStrokeStyle(2, accentColor).setDepth(3).setInteractive({ useHandCursor: true });
        let readyText = this.add.text(cx, cy + 170, '7/7 Selected', {
            fontSize: '20px', color: '#ffffff', fontFamily: 'Impact'
        }).setOrigin(0.5).setDepth(4);
        readyBtn.on('pointerover', () => { if (deck.length >= 7) readyBtn.setFillStyle(btnHover, 0.9); });
        readyBtn.on('pointerout', () => readyBtn.setFillStyle(deck.length >= 7 ? btnColor : 0x333333, deck.length >= 7 ? 0.9 : 0.6));
        readyBtn.on('pointerdown', () => {
            if (deck.length < 7) return;
            this.registry.set('playerDeck', deck);
            this.scene.start('GameScene');
        });

        updateDeckUI();
    }
}
