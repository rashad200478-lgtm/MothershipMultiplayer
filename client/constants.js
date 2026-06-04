const TERRAIN_W = 3200;

const UNIT_STATS = {
    inf: { hp: 50, dmg: 5, eyeRange: 550, recharge: 733, cost: 20, displayW: 48, displayH: 48, speed: 80 },
    mm: { hp: 80, dmg: 15, eyeRange: 780, recharge: 1667, cost: 50, displayW: 48, displayH: 48, speed: 80 },
    st: { hp: 240, dmg: 20, eyeRange: 650, recharge: 1500, cost: 80, displayW: 128, displayH: 64, speed: 80 },
    ht: { hp: 400, dmg: 20, eyeRange: 680, recharge: 1800, cost: 140, displayW: 128, displayH: 64, speed: 80 },
    sn: { hp: 20, dmg: 80, eyeRange: 900, recharge: 2000, cost: 120, displayW: 70, displayH: 60, speed: 40 },
    en: { hp: 20, dmg: 0, eyeRange: 0, recharge: 0, cost: 40, displayW: 48, displayH: 48, speed: 80 },
    mn: { hp: 60, dmg: 0, eyeRange: 0, recharge: 0, cost: 100, displayW: 48, displayH: 48, speed: 50 }
};

const DAMAGE_TABLE = {
    'inf->inf': 5, 'inf->mm': 14, 'inf->st': 2, 'inf->ht': 1, 'inf->sn': 5, 'inf->en': 5, 'inf->mn': 4,
    'mm->inf': 3, 'mm->mm': 15, 'mm->st': 40, 'mm->ht': 20, 'mm->sn': 3, 'mm->en': 10, 'mm->mn': 10,
    'st->inf': 17, 'st->mm': 9, 'st->st': 20, 'st->ht': 10, 'st->sn': 10, 'st->en': 20, 'st->mn': 12,
    'ht->inf': 25, 'ht->mm': 10, 'ht->st': 20, 'ht->ht': 20, 'ht->sn': 20, 'ht->en': 20, 'ht->mn': 20,
    'sn->inf': 50, 'sn->mm': 80, 'sn->st': 0, 'sn->ht': 0, 'sn->sn': 20, 'sn->en': 20, 'sn->mn': 80,
    'en->inf': 0, 'en->mm': 0, 'en->st': 0, 'en->ht': 0, 'en->sn': 0, 'en->en': 0, 'en->mn': 0,
    'mn->inf': 0, 'mn->mm': 0, 'mn->st': 0, 'mn->ht': 0, 'mn->sn': 0, 'mn->en': 0, 'mn->mn': 0
};

const MAX_CREDITS = 1000;
const CREDITS_PER_SEC = 10;
const SPAWN_FADE_DIST = 100;
const SPAWN_FADE_DUR = 400;
const MORPH_DIST = 130;
const MORPH_ALPHA0 = 0.5;
const MORPH_STEP = 0.14;
const MORPH_DELAY = 300;
const MORPH_REPEAT = 4;
const FORM_OFFSET = 48;
const BULLET_DUR = 300;
const TANK_DEATH_WAIT = 3000;

const UNIT_COST = {
    infantry: 20, infantry_red: 20,
    missile: 50, missile_red: 50,
    tank: 80, tank_red: 80,
    heavy_tank: 140, heavy_tank_red: 140,
    sniper: 120, sniper_red: 120,
    engineer: 40, engineer_red: 40,
    miner: 100, miner_red: 100
};

const UNIT_TYPE_FROM_NAME = {
    infantry: 'inf', infantry_red: 'inf',
    missile: 'mm', missile_red: 'mm',
    tank: 'st', tank_red: 'st',
    heavy_tank: 'ht', heavy_tank_red: 'ht',
    sniper: 'sn', sniper_red: 'sn',
    engineer: 'en', engineer_red: 'en',
    miner: 'mn', miner_red: 'mn'
};

const UNIT_IS_RED = {
    infantry: false, infantry_red: true,
    missile: false, missile_red: true,
    tank: false, tank_red: true,
    heavy_tank: false, heavy_tank_red: true,
    sniper: false, sniper_red: true,
    engineer: false, engineer_red: true,
    miner: false, miner_red: true
};

const ANIM_CFG = {
    inf: {
        walkFrames: 20, walkFps: 20,
        shootFrames: 21, shootFps: 21,
        crouchFrames: 15, crouchFps: 10,
        deathFrames: 111, deathFps: 15,
        death2Frames: 126,
        redDeathFrames: 112, redDeath2Frames: 126
    },
    mm: {
        walkFrames: 20, walkFps: 20,
        shootFrames: 21, shootFps: 21,
        crouchFrames: 13, crouchFps: 15,
        deathFrames: 112, deathFps: 15,
        death2Frames: 126,
        redDeathFrames: 111, redDeath2Frames: 126
    },
    st: {
        walkFrames: 60, walkFps: 10,
        shootFrames: 21, shootFps: 21,
        deathFrames: 20, deathFps: 15,
        impactFrames: 36, impactFps: 20
    },
    ht: {
        walkFrames: 60, walkFps: 10,
        shootFrames: 21, shootFps: 21,
        deathFrames: 19, deathFps: 15,
        impactFrames: 36, impactFps: 20
    },
    sn: {
        walkFrames: 20, walkFps: 20,
        crouchFrames: 21, crouchFps: 10,
        shootFrames: 15, shootFps: 21,
        death1Frames: 111, death2Frames: 126,
        redDeath1Frames: 112, redDeath2Frames: 126
    },
    en: {
        walkFrames: 20, walkFps: 20,
        crouchFrames: 21, crouchFps: 10,
        trenchFrames: 15, trenchFps: 15,
        death1Frames: 111, death2Frames: 126,
        redDeath1Frames: 112, redDeath2Frames: 126
    },
    mn: {
        walkFrames: 20, walkFps: 20,
        plantFrames: 16, plantFps: 8,
        deathFrames: 18, deathFps: 15
    }
};
