package game.logic
{
   import caurina.transitions.Tweener;
   import core.*;
   import core.common.ArrayUtils;
   import core.goal.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.Timer;
   import game.*;
   import game.goals.ArtilleryStrikeGoal;
   import game.goals.AutoSendCheckGoal;
   import game.goals.BackgroundCacherGoal;
   import game.goals.ForceFieldGoal;
   import game.goals.GrandStormGoal;
   import game.goals.HelloMessagesGoal;
   import game.goals.RandomArtilleryStrike;
   import game.goals.ScenarioGoal;
   import game.goals.StormGoal;
   import game.ui.*;
   import game.units.*;
   
   public class Engine
   {
      
      private var _lost:int = 0;
      
      private var game_events:GameEvents = null;
      
      public var musicOff:Boolean = false;
      
      public var volume:Number = 1;
      
      private var _grand_storm_goal:GrandStormGoal = null;
      
      private var _enemy_storm_goal:StormGoal = null;
      
      private var level_map:* = null;
      
      private var game_finished:Boolean = false;
      
      private var _enemy_cards:Array = [StringConsts.MARINE,StringConsts.EMPTY,StringConsts.EMPTY,StringConsts.EMPTY];
      
      private var paused:Boolean = false;
      
      private var _specials:Array = [StringConsts.ARTILLERY_STRIKE,StringConsts.EMPTY,StringConsts.EMPTY];
      
      private var _storm_goal:StormGoal = null;
      
      private var _last_zone:int = 0;
      
      private var game_board:GameBoard = null;
      
      private var scenario_goal:ScenarioGoal = null;
      
      private var _cards:Array = [StringConsts.MARINE,StringConsts.EMPTY,StringConsts.EMPTY,StringConsts.EMPTY];
      
      private var vd_timer:Timer = null;
      
      private var music_sound:Sound = null;
      
      private var _map_holder:* = null;
      
      private var score:int = 0;
      
      private var _auto_send:Boolean = false;
      
      private var last_level:int = 0;
      
      private var special_targeting:SpecialTargeting = null;
      
      private var _hatches:Hatches = null;
      
      private var ui_holder:Sprite = null;
      
      private var _astrike_drop_count:int = 10;
      
      private var _enemy_specials:Array = [StringConsts.EMPTY,StringConsts.EMPTY,StringConsts.EMPTY];
      
      private var _kills:int = 0;
      
      private var goal_system:GoalSystem = null;
      
      private var _creds:int = 0;
      
      private var music_channel:SoundChannel = null;
      
      public var volumeOff:Boolean = false;
      
      private var play_window_ui:PlayWindowUI = null;
      
      public function Engine()
      {
         super();
      }
      
      private function destroyUI() : void
      {
         play_window_ui.destroy();
         ui_holder.removeChild(play_window_ui);
         play_window_ui = null;
         ui_holder.removeChild(game_board);
         game_board.destroy();
         game_board = null;
         Tweener.removeAllTweens();
         ui_holder.removeChild(_map_holder);
         Global.top.playHolder.removeChild(ui_holder);
         ui_holder = null;
         _map_holder = null;
         level_map = null;
      }
      
      public function victory() : void
      {
         var _loc1_:VictoryMessage = null;
         var _loc2_:* = undefined;
         var _loc3_:LevelSelection = null;
         if(game_finished)
         {
            return;
         }
         ProcessManager.instance.timeScale = 1;
         game_finished = true;
         playWindowUI.logMessage("The enemy mothership is defeated. VICTORY!");
         playWindowUI.buttons.buttonSetGoal.setPaused(true);
         playWindowUI.enemyButons.buttonSetGoal.setPaused(true);
         gameBoard.enemyUnits.applyDamage(99999);
         _loc1_ = new VictoryMessage();
         _loc1_.x = 244.4;
         _loc1_.y = 104.4;
         _loc1_.kills_txt.text = _kills.toString();
         _loc2_ = LevelSelection.translate(lastLevelIndex,lastZone);
         _loc1_.money_earned_txt.text = Global.top.levelSelection.planetInfos[lastLevelIndex][lastZone][1].toString();
         _loc1_.conquered_txt.text = Global.top.levelSelection.planetInfos[_loc2_.level][_loc2_.zone][0];
         creds += Global.top.levelSelection.planetInfos[lastLevelIndex][lastZone][1];
         playWindowUI.addChild(_loc1_);
         Global.top.allKills += _kills;
         _loc3_ = null;
         _loc3_ = Global.top.levelSelection;
         _loc3_.levelFinished(lastLevelIndex,lastZone);
         _loc3_.updateLevels();
         Global.top.saveLevels();
         if(LevelSelector.checkForNewUnits(lastLevelIndex,lastZone))
         {
            vd_timer = new Timer(5000,1);
         }
         else
         {
            vd_timer = new Timer(3500,1);
         }
         playSound(SoundConsts.victory_sound);
         vd_timer.addEventListener(TimerEvent.TIMER,victoryHandler);
         vd_timer.start();
      }
      
      public function get gameBoard() : GameBoard
      {
         return game_board;
      }
      
      public function get events() : GameEvents
      {
         return game_events;
      }
      
      public function get goalSystem() : GoalSystem
      {
         return goal_system;
      }
      
      public function get mapHolder() : *
      {
         return _map_holder;
      }
      
      public function clearAll() : void
      {
         if(!game_events)
         {
            return;
         }
         stopMusic();
         music_sound = null;
         _kills = 0;
         _lost = 0;
         _hatches = null;
         game_events.unregister();
         game_events = null;
         score = 0;
         scenario_goal.deactivate();
         scenario_goal = null;
         goal_system.deactivate();
         ProcessManager.instance.removeTickedObject(goal_system);
         goal_system = null;
         destroyUI();
         EffectFactory.cleanPool();
         special_targeting = null;
         paused = false;
         game_finished = false;
      }
      
      public function get levelMap() : *
      {
         return level_map;
      }
      
      private function stormGoalTicks(param1:Boolean) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc2_ = 1500;
         _loc3_ = 0;
         _loc4_ = 0;
         if(param1)
         {
            _loc4_ = UnitCreator.enemyStormAttackChargeLevel(lastLevelIndex,lastZone);
         }
         else
         {
            _loc4_ = Number(Global.top.upgrades.stormAttackChargeLevel());
         }
         _loc3_ = 1 - (_loc4_ - 1) * 0.1;
         if(_loc3_ < 0.4)
         {
            _loc3_ = 0.4;
         }
         return int(_loc2_ * _loc3_);
      }
      
      public function playSound(param1:int) : void
      {
         switch(param1)
         {
            case SoundConsts.victory:
               playSoundData(new Sound_victory());
               break;
            case SoundConsts.defeat:
               playSoundData(new Sound_defeat());
               break;
            case SoundConsts.camera:
               playSoundData(new Sound_camera());
               break;
            case SoundConsts.doors_open:
               playSoundData(new Sound_doors_open());
               break;
            case SoundConsts.click:
               playSoundData(new Sound_click());
               break;
            case SoundConsts.pause:
            case SoundConsts.unpause:
               break;
            case SoundConsts.final_attack:
               playSoundData(new Sound_final_attack());
               break;
            case SoundConsts.menu_appear:
               playSoundData(new Sound_menu_appear());
               break;
            case SoundConsts.mine_set:
               playSoundData(new Sound_mine_set());
               break;
            case SoundConsts.vulture:
               playSoundData(new Sound_vulture());
               break;
            case SoundConsts.artillery_strike:
               playSoundData(new Sound_artillery_strike());
               break;
            case SoundConsts.caterpillar_hit:
               playSoundData(new Sound_caterpillar_hit());
               break;
            case SoundConsts.explosion:
               playSoundData(new Sound_explosion());
               break;
            case SoundConsts.explosion1:
               playSoundData(new Sound_explosion1());
               break;
            case SoundConsts.hit:
               playSoundData(new Sound_hit());
               break;
            case SoundConsts.hit3:
               playSoundData(new Sound_hit3());
               break;
            case SoundConsts.marine_shot:
               playSoundData(new Sound_marine_shot());
               break;
            case SoundConsts.mm_shot:
               playSoundData(new Sound_mm_shot());
               break;
            case SoundConsts.specialist_attack:
               playSoundData(new Sound_specialist_attack());
               break;
            case SoundConsts.storm_attack:
               playSoundData(new Sound_storm_attack());
               break;
            case SoundConsts.storm_tank_shot:
               playSoundData(new Sound_storm_tank_shot());
               break;
            case SoundConsts.caterpillar_death:
               playSoundData(new Sound_caterpillar_death());
               break;
            case SoundConsts.marine_death:
               playSoundData(new Sound_marine_death());
               break;
            case SoundConsts.marine_death_expl:
               playSoundData(new Sound_marine_death_expl());
               break;
            case SoundConsts.victory_sound:
               playSoundData(new Sound_victory_music());
               break;
            case SoundConsts.hit1:
               playSoundData(new Sound_hit1());
               break;
            case SoundConsts.nuclear_counting:
               playSoundData(new Sound_nuclear_counting());
               break;
            case SoundConsts.stun:
               playSoundData(new Sound_stun());
               break;
            case SoundConsts.door_reach:
               playSoundData(new Sound_door_reach());
         }
      }
      
      public function baseReached(param1:Unit, param2:RoadPath) : void
      {
         var _loc3_:Point = null;
         _loc3_ = null;
         if(param1.isEnemy)
         {
            _loc3_ = new Point(param2.x + param2.firstNode().x,param2.y + param2.firstNode().y);
            playWindowUI.balanceBar.subHealth(param1.death_cost);
         }
         else
         {
            _loc3_ = new Point(param2.x + param2.lastNode().x,param2.y + param2.lastNode().y);
            playWindowUI.balanceBar.addHealth(param1.death_cost);
         }
         playSound(SoundConsts.door_reach);
         playWindowUI.updateShipIcons();
         gameBoard.destroyUnit(param1);
         gameBoard.wipeUnit(param1);
         if(param1.isEnemy)
         {
            enemyStormGoal.increaseCharge(enemyStormGoal.PAUSE / 30);
            EffectFactory.makeExplosion(EffectFactory.HATCH_EXPLOSION_ENEMY,_loc3_,0.7,gameBoard.getHatchMaskByRoad(param2));
         }
         else
         {
            stormGoal.increaseCharge(stormGoal.PAUSE / 30);
            EffectFactory.makeExplosion(EffectFactory.HATCH_EXPLOSION,_loc3_,0.7,gameBoard.getHatchMaskByRoad(param2));
         }
      }
      
      public function stopMusic() : void
      {
         if(music_channel)
         {
            music_channel.stop();
            music_channel = null;
         }
      }
      
      public function specialTicks(param1:String, param2:Boolean) : int
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc3_ = 1500;
         _loc4_ = 1;
         _loc5_ = 0;
         if(param2)
         {
            _loc5_ = UnitCreator.enemySpecialTicksMultiplier(lastLevelIndex,lastZone);
         }
         else
         {
            _loc5_ = Number(Global.top.upgrades.orbitalSupportSpeedLevel());
         }
         _loc4_ = 1 - (_loc5_ - 1) * 0.05;
         if(_loc4_ < 0)
         {
            _loc4_ = 0.1;
         }
         switch(param1)
         {
            case StringConsts.ARTILLERY_STRIKE:
               _loc3_ = 1750;
               break;
            case StringConsts.NUCLEAR_MISSILE:
               _loc3_ = 4000;
               break;
            case StringConsts.FORCE_FIELD:
               _loc3_ = 1100;
         }
         return int(_loc3_ * _loc4_);
      }
      
      public function get astrikeDropCount() : int
      {
         return _astrike_drop_count;
      }
      
      public function showUI() : void
      {
         ui_holder.visible = levelMap.visible = playWindowUI.visible = true;
      }
      
      public function unitTicks(param1:String, param2:Boolean) : int
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc3_ = 500;
         _loc4_ = 0;
         _loc5_ = 0;
         if(param2)
         {
            _loc5_ = UnitCreator.enemySpeedBuildingMultiplier(lastLevelIndex,lastZone);
         }
         else
         {
            _loc5_ = Number(Global.top.upgrades.speedBuildingLevel());
         }
         _loc4_ = 1 - (_loc5_ - 1) * 0.05;
         if(_loc4_ < 0.2)
         {
            _loc4_ = 0.2;
         }
         switch(param1)
         {
            case StringConsts.MARINE:
               _loc3_ = 150;
               break;
            case StringConsts.MISSILE_MAN:
               _loc3_ = 200;
               break;
            case StringConsts.SPECIALIST:
               _loc3_ = 250;
               break;
            case StringConsts.VULTURE:
               _loc3_ = 890;
               break;
            case StringConsts.STORM_TANK:
               _loc3_ = 375;
               break;
            case StringConsts.CATERPILLAR:
               _loc3_ = 1200;
               break;
            case StringConsts.MINER_DROID:
               _loc3_ = 500;
               break;
            case StringConsts.GRENADIER_DROID:
               _loc3_ = 400;
         }
         return int(_loc3_ * _loc4_);
      }
      
      public function specialButtonPressed(param1:MovieClip) : void
      {
         if(!param1.ticks_goal.ready || specialTargeting.enabled && specialTargeting.currentType == param1.unit_type)
         {
            return;
         }
         switch(param1.unit_type)
         {
            case StringConsts.NUCLEAR_MISSILE:
               if(specialTargeting.enabled)
               {
                  specialTargeting.disable();
               }
               makeSpecialEffect(StringConsts.NUCLEAR_MISSILE);
               param1.ticks_goal.reset();
               break;
            case StringConsts.ARTILLERY_STRIKE:
            case StringConsts.FORCE_FIELD:
               special_targeting.enable(param1.unit_type);
               playWindowUI.logMessage("Select target spot to perform " + param1.unit_type);
         }
      }
      
      public function playMusic() : void
      {
         var _loc1_:SoundTransform = null;
         stopMusic();
         if(!volumeOff && !musicOff && Boolean(music_sound))
         {
            _loc1_ = new SoundTransform();
            _loc1_.volume = volume;
            music_channel = music_sound.play(0,999,_loc1_);
         }
      }
      
      public function hideUI() : void
      {
         ui_holder.visible = levelMap.visible = playWindowUI.visible = false;
      }
      
      private function get uniqueLevelIndex() : int
      {
         return lastLevelIndex + lastZone * 12;
      }
      
      public function makeSpecialEffect(param1:String) : void
      {
         switch(param1)
         {
            case StringConsts.NUCLEAR_MISSILE:
               EffectFactory.makeExplosion(EffectFactory.NUCLEAR_MISSILE_COUNTING,new Point(348,150),0.8,gameBoard);
               break;
            case StringConsts.ARTILLERY_STRIKE:
               goalSystem.add(new ArtilleryStrikeGoal(hatches.roadIndex,specialTargeting.getDropPoint(),_astrike_drop_count));
               playWindowUI.buttons.getButtonByType(StringConsts.ARTILLERY_STRIKE).ticks_goal.reset();
               break;
            case StringConsts.FORCE_FIELD:
               goalSystem.add(new ForceFieldGoal(specialTargeting.getDropPoint(),hatches.roadIndex));
               playWindowUI.buttons.getButtonByType(StringConsts.FORCE_FIELD).ticks_goal.reset();
         }
      }
      
      public function get lastZone() : int
      {
         return _last_zone;
      }
      
      public function get cards() : Array
      {
         return _cards;
      }
      
      public function addScore(param1:int) : void
      {
         score += param1;
      }
      
      public function unitButtonPressed(param1:MovieClip) : void
      {
         if(!param1.ticks_goal.ready)
         {
            return;
         }
         if(specialTargeting.enabled)
         {
            specialTargeting.disable();
         }
         if(stormGoal.isWaiting)
         {
            gameBoard.sendFromAllHatches(param1.unit_type,param1.is_enemy);
            stormGoal.reset();
         }
         else
         {
            gameBoard.createUnit(param1.unit_type,hatches.roadIndex,param1.is_enemy);
         }
         levelMap.hatch_arrows.alpha = 0.1;
         Tweener.addTween(levelMap.hatch_arrows,{
            "alpha":1,
            "time":2,
            "transition":"linear"
         });
         playWindowUI.buttons.buttonSetGoal.resetAll();
      }
      
      private function startRandomStrikes() : void
      {
         if(lastLevelIndex == 2 && lastZone == 0)
         {
            goalSystem.add(new RandomArtilleryStrike());
            playWindowUI.logMessage("Look sharp! We are under bombardment...");
         }
      }
      
      private function setPlayersEquipment() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         _loc1_ = Global.top.gameShop.orbitalWeapons;
         _loc2_ = Global.top.gameShop.getEquipment();
         _loc3_ = 0;
         _loc3_ = 0;
         while(_loc3_ < _specials.length)
         {
            _specials[_loc3_] = StringConsts.EMPTY;
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            _specials[_loc3_] = _loc1_[_loc3_];
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _cards.length)
         {
            _cards[_loc3_] = StringConsts.EMPTY;
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _cards[_loc3_] = _loc2_[_loc3_];
            _loc3_++;
         }
      }
      
      public function set gameScore(param1:int) : void
      {
         score = param1;
      }
      
      public function get enemySpecials() : Array
      {
         return _enemy_specials;
      }
      
      public function get gameFinished() : Boolean
      {
         return game_finished;
      }
      
      public function playSoundData(param1:Sound) : void
      {
         var _loc2_:SoundTransform = null;
         if(volumeOff)
         {
            return;
         }
         _loc2_ = new SoundTransform();
         _loc2_.volume = volume;
         param1.play(0,0,_loc2_);
      }
      
      private function defeatHandler(param1:TimerEvent) : void
      {
         game_finished = true;
         vd_timer.stop();
         vd_timer.removeEventListener(TimerEvent.TIMER,defeatHandler);
         vd_timer = null;
         if(!paused)
         {
            pause();
            playWindowUI.pause_mc.visible = false;
         }
         clearAll();
         Global.top.showGameShop();
      }
      
      public function get stormGoal() : StormGoal
      {
         return _storm_goal;
      }
      
      public function set autoSend(param1:Boolean) : void
      {
         _auto_send = param1;
      }
      
      public function playLevel(param1:int, param2:int) : void
      {
         var _loc3_:HelloMessagesGoal = null;
         clearAll();
         Global.top.stopMusic();
         last_level = param1;
         _last_zone = param2;
         setPlayersEquipment();
         setEnemyEquipment();
         game_events = new GameEvents(this);
         goal_system = new GoalSystem();
         constructUI(param1,param2);
         _hatches = new Hatches(levelMap.hatch_arrows);
         playWindowUI.update();
         ProcessManager.instance.addTickedObject(goal_system);
         _loc3_ = new HelloMessagesGoal();
         goalSystem.add(_loc3_);
         scenario_goal = new ScenarioGoal(this);
         goalSystem.add(scenario_goal);
         scenario_goal.setLevelTime(levelMap.level_time);
         special_targeting = new SpecialTargeting();
         _storm_goal = new StormGoal(playWindowUI.stormBar,playWindowUI.game_menu.storm_label,stormGoalTicks(false),true);
         goalSystem.add(_storm_goal);
         _enemy_storm_goal = new StormGoal(playWindowUI.enemyStormBar,playWindowUI.game_menu.enemy_storm_label,stormGoalTicks(true),false);
         goalSystem.add(_enemy_storm_goal);
         _grand_storm_goal = new GrandStormGoal();
         goalSystem.add(_grand_storm_goal);
         goalSystem.add(new BackgroundCacherGoal(this));
         goalSystem.add(new AutoSendCheckGoal());
         if(0 == lastLevelIndex && 0 == lastZone)
         {
         }
         switch(param1)
         {
            case 0:
               music_sound = new Sound_WindLoop();
               break;
            case 1:
               music_sound = new Sound_ArcticWind();
               break;
            case 2:
               music_sound = new Sound_WindLoop();
               break;
            case 3:
               music_sound = new Sound_ArcticWind();
               break;
            case 4:
               music_sound = new Sound_WindLoop();
               break;
            case 5:
               music_sound = new Sound_ArcticWind();
               break;
            case 6:
               music_sound = new Sound_WindLoop();
               break;
            case 7:
               music_sound = new Sound_ArcticWind();
               break;
            case 8:
               music_sound = new Sound_WindLoop();
               break;
            case 9:
               music_sound = new Sound_ArcticWind();
               break;
            case 10:
               music_sound = new Sound_WindLoop();
               break;
            case 11:
               music_sound = new Sound_ArcticWind();
         }
         playMusic();
         game_events.register();
      }
      
      private function constructUI(param1:int, param2:int) : void
      {
         var _loc3_:* = undefined;
         ui_holder = new Sprite();
         Global.top.playHolder.addChild(ui_holder);
         _map_holder = LevelSelector.getLevelUI(param1,param2);
         level_map = _map_holder.level_map;
         _loc3_ = LevelSelection.translate(lastLevelIndex,lastZone);
         level_map.level_back.gotoAndStop(_loc3_.level + 1);
         level_map.hatch_arrows.stop();
         _map_holder.x = 350;
         _map_holder.y = 262;
         _map_holder.scaleX = 700 / _map_holder.width;
         _map_holder.scaleY = 525 / _map_holder.height;
         Tweener.addTween(_map_holder,{
            "scaleX":1,
            "scaleY":1,
            "time":3,
            "delay":2,
            "transition":"easeOutQuad",
            "onStart":playSound,
            "onStartParams":[SoundConsts.camera],
            "onComplete":startRandomStrikes
         });
         ui_holder.addChild(_map_holder);
         game_board = new GameBoard(this);
         ui_holder.addChild(game_board);
         game_board.create();
         play_window_ui = new PlayWindowUI();
         play_window_ui.initialize(this);
         ui_holder.addChild(play_window_ui);
         playWindowUI.balanceBar.setTitle(level_map.title);
      }
      
      public function get enemyCards() : Array
      {
         return _enemy_cards;
      }
      
      public function finalVictory() : void
      {
         var _loc1_:FinalClip = null;
         _loc1_ = new FinalClip(this);
         Global.top.playHolder.addChild(_loc1_);
      }
      
      public function hitUnit(param1:int, param2:Unit, param3:String = null) : void
      {
         var _loc4_:int = 0;
         if(!param2.isAlive)
         {
            return;
         }
         _loc4_ = param1 - param2.armor;
         if(_loc4_ <= 0)
         {
            _loc4_ = 1;
         }
         param2.health -= _loc4_;
         param2.updateBar();
         if(!param2.isAlive)
         {
            if(!param2.isEnemy)
            {
               ++_kills;
            }
            else
            {
               ++_lost;
            }
            gameBoard.killUnit(param2,param3);
         }
      }
      
      public function get gamePaused() : Boolean
      {
         return paused;
      }
      
      public function get scenarioGoal() : ScenarioGoal
      {
         return scenario_goal;
      }
      
      public function get gameScore() : int
      {
         return score;
      }
      
      public function get playUI() : PlayWindowUI
      {
         return play_window_ui;
      }
      
      public function set creds(param1:int) : void
      {
         _creds = param1;
      }
      
      public function get autoSend() : Boolean
      {
         return _auto_send;
      }
      
      public function get playWindowUI() : PlayWindowUI
      {
         return play_window_ui;
      }
      
      public function get specials() : Array
      {
         return _specials;
      }
      
      private function victoryHandler(param1:TimerEvent) : void
      {
         vd_timer.stop();
         vd_timer.removeEventListener(TimerEvent.TIMER,victoryHandler);
         vd_timer = null;
         game_finished = true;
         if(!paused)
         {
            pause();
            playWindowUI.pause_mc.visible = false;
         }
         if(11 == lastLevelIndex && 2 == lastZone)
         {
            finalVictory();
         }
         clearAll();
         Global.top.showGameShop();
      }
      
      public function get lastLevelIndex() : int
      {
         return last_level;
      }
      
      public function get creds() : int
      {
         return _creds;
      }
      
      public function gameOver() : void
      {
         var _loc1_:DefeatMessage = null;
         if(game_finished)
         {
            return;
         }
         ProcessManager.instance.timeScale = 1;
         game_finished = true;
         playWindowUI.logMessage("Our mothership has been destroyed.");
         _loc1_ = new DefeatMessage();
         _loc1_.x = 244.4;
         _loc1_.y = 104.4;
         _loc1_.kills_txt.text = _kills.toString();
         _loc1_.lost_txt.text = _lost.toString();
         playWindowUI.addChild(_loc1_);
         Global.top.allKills += _kills;
         Global.top.saveLevels();
         playSound(SoundConsts.defeat);
         vd_timer = new Timer(3500,1);
         vd_timer.addEventListener(TimerEvent.TIMER,defeatHandler);
         vd_timer.start();
      }
      
      public function get hatches() : Hatches
      {
         return _hatches;
      }
      
      private function setEnemyEquipment() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = LevelSelector.enemySpecials[lastLevelIndex][lastZone];
         _loc2_ = LevelSelector.enemySets[lastLevelIndex][lastZone].concat();
         _loc3_ = 0;
         _loc3_ = 0;
         while(_loc3_ < _enemy_specials.length)
         {
            _enemy_specials[_loc3_] = StringConsts.EMPTY;
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            _enemy_specials[_loc3_] = _loc1_[_loc3_];
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _enemy_cards.length)
         {
            _enemy_cards[_loc3_] = StringConsts.EMPTY;
            _loc3_++;
         }
         ArrayUtils.shuffle(_loc2_);
         _loc4_ = Math.min(_enemy_cards.length,_loc2_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _enemy_cards[_loc3_] = _loc2_[_loc3_];
            _loc3_++;
         }
      }
      
      public function get enemyStormGoal() : StormGoal
      {
         return _enemy_storm_goal;
      }
      
      public function pause() : void
      {
         if(!paused)
         {
            stopMusic();
            playSound(SoundConsts.pause);
            playWindowUI.pause_mc.visible = true;
            playWindowUI.pause_mc.gotoAndPlay("pause");
            ProcessManager.instance.removeTickedObject(goalSystem);
            playWindowUI.balanceBar.pause();
            game_events.unregister();
            Tweener.pauseTweens(_map_holder);
            Tweener.pauseTweens(levelMap.hatch_arrows);
            Tweener.addTween(_map_holder,{
               "scaleX":700 / _map_holder.width,
               "scaleY":525 / _map_holder.height,
               "time":2,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(playWindowUI.game_menu,{
               "alpha":0,
               "time":1,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(playWindowUI.menu_button,{
               "alpha":0,
               "time":1,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(playWindowUI.pause_button,{
               "alpha":0,
               "time":1,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(playWindowUI.end_mission_button,{
               "alpha":0,
               "time":1,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(playWindowUI.help_button,{
               "alpha":0,
               "time":1,
               "transition":"easeOutQuad"
            });
         }
         else
         {
            playWindowUI.pause_mc.stop();
            playWindowUI.pause_mc.visible = false;
            playSound(SoundConsts.unpause);
            playMusic();
            playWindowUI.balanceBar.resume();
            ProcessManager.instance.addTickedObject(goalSystem);
            game_events.register();
            Tweener.resumeTweens(_map_holder);
            Tweener.resumeTweens(levelMap.hatch_arrows);
            Tweener.addTween(_map_holder,{
               "scaleX":1,
               "scaleY":1,
               "time":2,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(playWindowUI.game_menu,{
               "alpha":1,
               "time":1,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(playWindowUI.menu_button,{
               "alpha":1,
               "time":1,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(playWindowUI.pause_button,{
               "alpha":1,
               "time":1,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(playWindowUI.end_mission_button,{
               "alpha":1,
               "time":1,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(playWindowUI.help_button,{
               "alpha":1,
               "time":1,
               "transition":"easeOutQuad"
            });
         }
         paused = !paused;
         EffectFactory.setPause(paused);
         gameBoard.updateUnits();
      }
      
      public function get grandStormGoal() : GrandStormGoal
      {
         return _grand_storm_goal;
      }
      
      public function get specialTargeting() : SpecialTargeting
      {
         return special_targeting;
      }
   }
}

