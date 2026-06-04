package game.ui
{
   import core.*;
   import flash.display.*;
   import flash.events.*;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.SharedObject;
   import flash.text.*;
   import game.*;
   import game.logic.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1238")]
   public dynamic class WelcomeScreen extends MovieClip
   {
      
      public var music_channel:SoundChannel = null;
      
      public var options_button:SimpleButton;
      
      private var play_holder:* = null;
      
      private var _upgrades:Upgrades = null;
      
      private var _all_kills:int = 0;
      
      private const _game_version:int = 30;
      
      private var music_sound:Sound = null;
      
      public var engine:Engine = null;
      
      private var level_selection:LevelSelection = null;
      
      private var _available_units:Array = [];
      
      public var resume_button:SimpleButton;
      
      private var _game_shop:GameShop = null;
      
      public var flonga_button:SimpleButton;
      
      private var _instructions:Instructions = null;
      
      public var start_game_button:SimpleButton;
      
      private var _available_weapons:Array = [];
      
      private var _story:Story = null;
      
      public function WelcomeScreen()
      {
         super();
         start_game_button.tabEnabled = false;
         options_button.tabEnabled = false;
         resume_button.tabEnabled = false;
         flonga_button.tabEnabled = false;
      }
      
      public function get playHolder() : Sprite
      {
         return play_holder;
      }
      
      public function loadLevels() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = SharedObject.getLocal("mothership_wars_" + _game_version.toString(),"/");
         if(_loc1_.data.levels)
         {
            level_selection.levelArray = _loc1_.data.levels;
            allKills = _loc1_.data.kills;
            engine.creds = _loc1_.data.creds;
            if(_loc1_.data.arrayBlock)
            {
               gameShop.arrayBlock = _loc1_.data.arrayBlock;
            }
            if(_loc1_.data.orbitalWeapons)
            {
               gameShop.setObritalWeapons(_loc1_.data.orbitalWeapons);
            }
            if(_loc1_.data.upgrades)
            {
               _upgrades.upgradeArray = _loc1_.data.upgrades;
               _upgrades.costArray = _loc1_.data.upgradeCosts;
               gameShop.updateView();
            }
         }
      }
      
      private function updateView() : void
      {
         if(engine.playWindowUI != null)
         {
            resume_button.visible = true;
         }
         else
         {
            resume_button.visible = false;
         }
      }
      
      private function createShop() : void
      {
         _upgrades = new Upgrades();
         _game_shop = new GameShop();
         _game_shop.visible = false;
         play_holder.addChild(_game_shop);
         _game_shop.Create();
         _game_shop.setUpgrades(_upgrades);
         _game_shop.arrayBlock = [1,0,0,0,0,0,0,0];
         _game_shop.setDefaultCards();
      }
      
      public function showGameShop() : void
      {
         playMusic();
         gameShop.show();
      }
      
      public function stopMusic() : void
      {
         if(music_channel)
         {
            music_channel.stop();
            music_channel = null;
         }
      }
      
      public function startGameHandler(param1:MouseEvent) : void
      {
         engine.playSound(SoundConsts.click);
         if(_story)
         {
            _story.show();
         }
         else
         {
            showGameShop();
         }
      }
      
      public function saveLevels() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = SharedObject.getLocal("mothership_wars_" + _game_version.toString(),"/");
         _loc1_.data.levels = level_selection.levelArray;
         _loc1_.data.creds = engine.creds;
         _loc1_.data.kills = allKills;
         _loc1_.data.arrayBlock = gameShop.arrayBlock;
         _loc1_.data.orbitalWeapons = gameShop.orbitalWeapons;
         _loc1_.data.upgrades = _upgrades.upgradeArray;
         _loc1_.data.upgradeCosts = _upgrades.costArray;
         _loc1_.flush();
      }
      
      public function playMusic() : void
      {
         var _loc1_:SoundTransform = null;
         if(music_channel)
         {
            return;
         }
         stopMusic();
         if(!engine.volumeOff && Boolean(music_sound))
         {
            _loc1_ = new SoundTransform();
            _loc1_.volume = engine.volume;
            music_channel = music_sound.play(0,99999,_loc1_);
         }
      }
      
      private function createStory() : void
      {
         _story = new Story();
         playHolder.addChild(_story);
         _story.visible = false;
      }
      
      public function get levelSelection() : LevelSelection
      {
         return level_selection;
      }
      
      public function resetSaved() : void
      {
         level_selection.levelArray = [[LevelSelection.LEVEL_OPENED,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED],[LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED],[LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED],[LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED],[LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED],[LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED],[LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED],[LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED],[LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED],[LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED],[LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED],[LevelSelection.LEVEL_CLOSED
         ,LevelSelection.LEVEL_CLOSED,LevelSelection.LEVEL_CLOSED]];
         engine.creds = 0;
         allKills = 0;
         gameShop.arrayBlock = [1,0,0,0,0,0,0,0];
         gameShop.setObritalWeapons([StringConsts.EMPTY,StringConsts.EMPTY,StringConsts.EMPTY]);
         _upgrades.upgradeArray = [1,1,1,1,1,1];
         _upgrades.costArray = _upgrades.getDefaultCosts();
         gameShop.updateView();
         saveLevels();
      }
      
      public function set allKills(param1:int) : void
      {
         _all_kills = param1;
      }
      
      public function initialize() : void
      {
         ProcessManager.instance.start();
         start_game_button.addEventListener(MouseEvent.MOUSE_DOWN,startGameHandler);
         resume_button.addEventListener(MouseEvent.MOUSE_DOWN,resumeGameHandler);
         options_button.addEventListener(MouseEvent.MOUSE_DOWN,optionsHandler);
         flonga_button.addEventListener(MouseEvent.MOUSE_DOWN,GameStage.sponsorClick);
         play_holder = new Sprite();
         addChild(play_holder);
         engine = new Engine();
         createStory();
         createShop();
         _instructions = new Instructions();
         playHolder.addChild(_instructions);
         _instructions.visible = false;
         level_selection = new LevelSelection();
         level_selection.initialize();
         level_selection.visible = false;
         play_holder.addChild(level_selection);
         loadLevels();
         level_selection.updateLevels();
         updateView();
         music_sound = new Sound_levels_music();
      }
      
      public function resumeGameHandler(param1:MouseEvent) : void
      {
         engine.playSound(SoundConsts.click);
         stopMusic();
         engine.showUI();
         engine.pause();
         if(param1)
         {
            param1.stopPropagation();
         }
      }
      
      public function clear() : void
      {
         if(engine)
         {
            stopMusic();
            level_selection.destroy();
            play_holder.removeChild(level_selection);
            removeChild(play_holder);
            engine.clearAll();
            start_game_button.removeEventListener(MouseEvent.MOUSE_DOWN,startGameHandler);
            resume_button.removeEventListener(MouseEvent.MOUSE_DOWN,resumeGameHandler);
            options_button.removeEventListener(MouseEvent.MOUSE_DOWN,optionsHandler);
            engine = null;
         }
      }
      
      public function get instructions() : Instructions
      {
         return _instructions;
      }
      
      public function get allKills() : int
      {
         return _all_kills;
      }
      
      public function get gameShop() : GameShop
      {
         return _game_shop;
      }
      
      public function optionsHandler(param1:MouseEvent) : void
      {
         Global.top.engine.playSound(SoundConsts.click);
         showLevelSelection();
         levelSelection.optionsDialogClickHanler(null);
      }
      
      public function get upgrades() : Upgrades
      {
         return _upgrades;
      }
      
      public function showLevelSelection() : void
      {
         if(!level_selection)
         {
            return;
         }
         playMusic();
         level_selection.show();
      }
      
      public function showWelcome() : void
      {
         visible = true;
         level_selection.visible = false;
         _game_shop.visible = false;
         updateView();
      }
      
      public function set story(param1:Story) : void
      {
         _story = param1;
      }
   }
}

