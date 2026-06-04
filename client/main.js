const config = {
    type: Phaser.AUTO,
    width: window.innerWidth,
    height: window.innerHeight,
    fps: { target: 60, forceSetTimeOut: true },
    pixelArt: false,
    physics: {
        default: 'arcade',
        arcade: { debug: false }
    },
    backgroundColor: '#000000',
    parent: 'game-container',
    scale: {
        mode: Phaser.Scale.RESIZE,
        autoCenter: Phaser.Scale.CENTER_BOTH
    },
    scene: [WelcomeScene, MenuScene, DeckScene, GameScene, UIScene]
};

const game = new Phaser.Game(config);
