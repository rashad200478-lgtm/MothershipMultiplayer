class WelcomeScene extends Phaser.Scene {
    constructor() {
        super({ key: 'WelcomeScene' });
    }

    preload() {
        for (let i = 1; i <= 300; i++) {
            this.load.image('ws_' + i, 'assets/sprites/welcome_screen/' + i + '.png');
        }
    }

    create() {
        let cx = window.innerWidth / 2, cy = window.innerHeight / 2;
        this.cameras.main.setBackgroundColor('#000000');

        let frames = [];
        for (let i = 1; i <= 300; i++) {
            frames.push({ key: 'ws_' + i });
        }
        this.anims.create({ key: 'welcome_anim', frames: frames, frameRate: 24, repeat: 0 });

        let sprite = this.add.sprite(cx, cy, 'ws_1').setOrigin(0.5);
        let sx = (window.innerWidth * 0.95) / sprite.width;
        let sy = (window.innerHeight * 0.95) / sprite.height;
        sprite.setScale(Math.min(sx, sy));

        sprite.play('welcome_anim');

        sprite.once('animationcomplete', () => {
            sprite.destroy();
            let title = this.add.text(cx, cy - 60, 'MOTHERSHIP\nWARFARE', {
                fontFamily: 'Impact, sans-serif', fontSize: '80px', color: '#00ffff',
                align: 'center', stroke: '#003366', strokeThickness: 8,
                shadow: { offsetX: 0, offsetY: 0, color: '#00ffff', blur: 30, stroke: true, fill: true }
            }).setOrigin(0.5).setDepth(2).setAlpha(0);

            this.tweens.add({ targets: title, alpha: 1, duration: 2000, ease: 'Power2' });

            this.time.delayedCall(2500, () => {
                let prompt = this.add.text(cx, cy + 90, 'Click anywhere to start', {
                    fontSize: '22px', color: '#aaaacc', fontFamily: 'Arial'
                }).setOrigin(0.5).setDepth(2).setAlpha(0);

                this.tweens.add({
                    targets: prompt, alpha: 1, duration: 800,
                    yoyo: true, repeat: -1
                });

                this.input.once('pointerdown', () => {
                    this.cameras.main.fadeOut(500, 0, 0, 0);
                    this.cameras.main.once('camerafadeoutcomplete', () => {
                        this.scene.start('MenuScene');
                    });
                });
            });
        });
    }
}
