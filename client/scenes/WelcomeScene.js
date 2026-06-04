class WelcomeScene extends Phaser.Scene {
    constructor() {
        super({ key: 'WelcomeScene' });
    }

    preload() {
        this.load.image('welcomeBg', 'assets/sprites/welcome_screen/1.png');
    }

    create() {
        let cx = window.innerWidth / 2, cy = window.innerHeight / 2;

        let bg = this.add.image(cx, cy, 'welcomeBg').setOrigin(0.5).setDepth(0);
        bg.setScale(1.4);
        bg.setDisplaySize(window.innerWidth * 1.4, window.innerHeight * 1.4);

        let overlay = this.add.rectangle(cx, cy, window.innerWidth, window.innerHeight, 0x000000, 0.4).setDepth(1);

        let title = this.add.text(cx, cy - 60, 'MOTHERSHIP\nWARFARE', {
            fontFamily: 'Impact, sans-serif', fontSize: '80px', color: '#00ffff',
            align: 'center', stroke: '#003366', strokeThickness: 8,
            shadow: { offsetX: 0, offsetY: 0, color: '#00ffff', blur: 30, stroke: true, fill: true }
        }).setOrigin(0.5).setDepth(2).setAlpha(0);

        this.tweens.add({ targets: title, alpha: 1, duration: 2000, ease: 'Power2' });

        let prompt = this.add.text(cx, cy + 80, 'Click anywhere to start', {
            fontSize: '22px', color: '#aaaacc', fontFamily: 'Arial'
        }).setOrigin(0.5).setDepth(2).setAlpha(0);

        this.tweens.add({
            targets: prompt, alpha: 1, duration: 1000, delay: 2000,
            yoyo: true, repeat: -1
        });

        this.input.once('pointerdown', () => {
            this.cameras.main.fadeOut(500, 0, 0, 0);
            this.cameras.main.once('camerafadeoutcomplete', () => {
                this.scene.start('MenuScene');
            });
        });
    }
}
