package game.ui
{
   import core.Global;
   import core.ProcessManager;
   import core.goal.*;
   import fl.managers.FocusManager;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.BitmapFilter;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.media.*;
   import flash.text.*;
   import game.SoundConsts;
   import game.goals.MapGoal;
   import game.logic.Engine;
   import game.logic.LevelSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol872")]
   public class LevelSelection extends Sprite
   {
      
      public static const LEVEL_CLOSED:int = 0;
      
      public static const LEVEL_OPENED:int = 1;
      
      public static const LEVEL_WON:int = 2;
      
      private var zone_array:Array;
      
      public var options_dialog:MovieClip;
      
      public var map_goal:MapGoal = null;
      
      private var planet_infos:Array = [[["Volcano",200],["Volcano",1100],["Volcano",3300]],[["Ariola",300],["Ariola",1045],["Ariola",4100]],[["Kasheta",375],["Kasheta",1250],["Kasheta",4900]],[["Rhandaran",450],["Rhandaran",1400],["Rhandaran",5100]],[["Xelacia",600],["Xelacia",1560],["Xelacia",5125]],[["Acturus",550],["Acturus",1640],["Acturus",5410]],[["Betazedd",580],["Betazedd",1780],["Betazedd",5960]],[["Yohada",670],["Yohada",1890],["Yohada",6070]],[["Arcad",750],["Arcad",1950],["Arcad",6300]],[["Grazerit",800],["Grazerit",2100],["Grazerit",6900]],[["Zakdern",930],["Zakdern",2400],["Zakdern",7800]],[["Kespryt",1000],["Kespryt",2800],["Kespryt",9000]]];
      
      public var planets_nebula:MovieClip;
      
      private var color_matrix:Array = null;
      
      public var planets_star:MovieClip;
      
      private var conquered_percents:int = 0;
      
      private var music_sound:Sound = null;
      
      public var conquered_bar:MovieClip;
      
      public var main_menu_button:SimpleButton;
      
      public var flonga_button:SimpleButton;
      
      public var planets_back:MovieClip;
      
      private var goal_system:GoalSystem = null;
      
      private var number_zone:int = -1;
      
      public var conquered_txt:TextField;
      
      public var music_channel:SoundChannel = null;
      
      private var _current_glow_clip:* = null;
      
      private var revenue_creds:int = 0;
      
      public var planets_back_star:MovieClip;
      
      private var number_planet:int = -1;
      
      private var _engine:Engine = null;
      
      public var play_next_button:SimpleButton;
      
      private var level:LevelSelection = null;
      
      private var level_array:Array = [[LEVEL_OPENED,LEVEL_CLOSED,LEVEL_CLOSED],[LEVEL_CLOSED,LEVEL_CLOSED,LEVEL_CLOSED],[LEVEL_CLOSED,LEVEL_CLOSED,LEVEL_CLOSED],[LEVEL_CLOSED,LEVEL_CLOSED,LEVEL_CLOSED],[LEVEL_CLOSED,LEVEL_CLOSED,LEVEL_CLOSED],[LEVEL_CLOSED,LEVEL_CLOSED,LEVEL_CLOSED],[LEVEL_CLOSED,LEVEL_CLOSED,LEVEL_CLOSED],[LEVEL_CLOSED,LEVEL_CLOSED,LEVEL_CLOSED],[LEVEL_CLOSED,LEVEL_CLOSED,LEVEL_CLOSED],[LEVEL_CLOSED,LEVEL_CLOSED,LEVEL_CLOSED],[LEVEL_CLOSED,LEVEL_CLOSED,LEVEL_CLOSED],[LEVEL_CLOSED,LEVEL_CLOSED,LEVEL_CLOSED]];
      
      public var planet_data:MovieClip;
      
      public var options_button:SimpleButton;
      
      private var pm:ProcessManager = null;
      
      public function LevelSelection()
      {
         super();
         _engine = Global.top.engine;
         color_matrix = new Array();
         color_matrix = color_matrix.concat([0,0,0,0,0]);
         color_matrix = color_matrix.concat([1,0,0,0,0]);
         color_matrix = color_matrix.concat([0,0,0,0,0]);
         color_matrix = color_matrix.concat([0,0,0,1,0]);
         main_menu_button.tabEnabled = false;
         options_button.tabEnabled = false;
         play_next_button.tabEnabled = false;
      }
      
      public static function translate(param1:int, param2:int) : LevelZone
      {
         var _loc3_:LevelZone = null;
         var _loc4_:int = 0;
         _loc3_ = new LevelZone();
         _loc4_ = param1 + param2 * 12;
         _loc3_.level = int(_loc4_ / 3);
         _loc3_.zone = _loc4_ % 3;
         return _loc3_;
      }
      
      public static function translateBack(param1:int, param2:int) : LevelZone
      {
         var _loc3_:LevelZone = null;
         var _loc4_:int = 0;
         _loc3_ = new LevelZone();
         _loc4_ = param1 * 3 + param2;
         _loc3_.level = _loc4_ % 12;
         _loc3_.zone = int(_loc4_ / 12);
         return _loc3_;
      }
      
      public function destroy() : void
      {
         stopMusic();
         main_menu_button.removeEventListener(MouseEvent.MOUSE_DOWN,mainMenuClickHanler);
         play_next_button.removeEventListener(MouseEvent.MOUSE_DOWN,playNextClickHanler);
         options_button.removeEventListener(MouseEvent.MOUSE_DOWN,optionsDialogClickHanler);
         options_dialog.close_button.removeEventListener(MouseEvent.MOUSE_DOWN,optionsDialogClose);
         options_dialog.music_on_button.removeEventListener(MouseEvent.MOUSE_DOWN,musicOnHandler);
         options_dialog.music_off_button.removeEventListener(MouseEvent.MOUSE_DOWN,musicOffHandler);
         options_dialog.reset_saved_button.removeEventListener(MouseEvent.MOUSE_DOWN,resetSavedHandler);
         options_dialog.main_menu_button.removeEventListener(MouseEvent.MOUSE_DOWN,optionsMainMenuButtonHandler);
         options_dialog.low_quality_button.removeEventListener(MouseEvent.MOUSE_DOWN,qualityButtonHandler);
         options_dialog.medium_quality_button.removeEventListener(MouseEvent.MOUSE_DOWN,qualityButtonHandler);
         options_dialog.high_quality_button.removeEventListener(MouseEvent.MOUSE_DOWN,qualityButtonHandler);
         map_goal.deactivate();
      }
      
      private function getNextLevelAndZone() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = 0;
            while(_loc2_ < levelArray.length)
            {
               if(levelArray[_loc2_][_loc1_] == LEVEL_OPENED)
               {
                  return [_loc2_,_loc1_];
               }
               _loc2_++;
            }
            _loc1_++;
         }
         return null;
      }
      
      private function autoSendOffHandler(param1:MouseEvent) : void
      {
         var _loc2_:FocusManager = null;
         Global.top.engine.playSound(SoundConsts.click);
         _engine.autoSend = true;
         updateControls();
         _loc2_ = new FocusManager(Global.mainStage);
         _loc2_.setFocus(Global.mainStage);
      }
      
      private function FnPlanetShow3(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         _loc2_ = null;
         _loc3_ = 0;
         while(_loc3_ < level_array.length)
         {
            if(planets_back.getPlanetsArray()[_loc3_].button_one == param1.currentTarget)
            {
               number_planet = _loc3_;
               number_zone = 1;
               _loc2_ = planets_back.getPlanetsArray()[_loc3_].button_one;
            }
            if(planets_back.getPlanetsArray()[_loc3_].button_two == param1.currentTarget)
            {
               number_planet = _loc3_;
               number_zone = 2;
               _loc2_ = planets_back.getPlanetsArray()[_loc3_].button_two;
            }
            if(planets_back.getPlanetsArray()[_loc3_].button_three == param1.currentTarget)
            {
               number_planet = _loc3_;
               number_zone = 3;
               _loc2_ = planets_back.getPlanetsArray()[_loc3_].button_three;
            }
            _loc3_++;
         }
         showPlanetInfoOver(number_planet,number_zone,_loc2_);
      }
      
      private function optionsDialogClose(param1:Event) : void
      {
         Global.top.engine.playSound(SoundConsts.click);
         options_dialog.visible = false;
         options_dialog.close_button.removeEventListener(MouseEvent.MOUSE_DOWN,optionsDialogClose);
         options_dialog.music_on_button.removeEventListener(MouseEvent.MOUSE_DOWN,musicOnHandler);
         options_dialog.music_off_button.removeEventListener(MouseEvent.MOUSE_DOWN,musicOffHandler);
         options_dialog.reset_saved_button.removeEventListener(MouseEvent.MOUSE_DOWN,resetSavedHandler);
         options_dialog.main_menu_button.removeEventListener(MouseEvent.MOUSE_DOWN,optionsMainMenuButtonHandler);
      }
      
      public function levelFinished(param1:int, param2:int) : void
      {
         if(0 == param2)
         {
            if(0 == param1)
            {
               checkAndOpen([1,0],[2,0]);
            }
            else if(1 == param1)
            {
               checkAndOpen([2,0],[3,0]);
            }
            else if(2 == param1)
            {
               checkAndOpen([3,0],[4,0],[5,0]);
            }
            else if(3 == param1)
            {
               checkAndOpen([4,0],[5,0],[6,0]);
            }
            else if(4 == param1)
            {
               checkAndOpen([6,0],[7,0]);
            }
            else if(5 == param1)
            {
               checkAndOpen([6,0],[7,0]);
            }
            else if(6 == param1)
            {
               checkAndOpen([7,0],[8,0],[9,0]);
            }
            else if(7 == param1)
            {
               checkAndOpen([7,0],[8,0],[9,0]);
            }
            else if(8 == param1)
            {
               checkAndOpen([9,0],[10,0],[11,0]);
            }
            else if(9 == param1)
            {
               checkAndOpen([9,0],[10,0],[11,0],[0,1],[1,1]);
            }
            else if(10 == param1)
            {
               checkAndOpen([9,0],[10,0],[11,0],[0,1],[1,1]);
            }
            else if(11 == param1)
            {
               checkAndOpen([0,1],[1,1],[2,1],[3,1]);
            }
         }
         else if(1 == param2)
         {
            if(0 == param1)
            {
               checkAndOpen([0,1],[1,1],[2,1],[3,1]);
            }
            else if(1 == param1)
            {
               checkAndOpen([4,1],[1,1],[2,1],[3,1]);
            }
            else if(2 == param1)
            {
               checkAndOpen([3,1],[4,1],[5,1]);
            }
            else if(3 == param1)
            {
               checkAndOpen([4,1],[5,1],[6,1],[7,1]);
            }
            else if(4 == param1)
            {
               checkAndOpen([6,1],[7,1]);
            }
            else if(5 == param1)
            {
               checkAndOpen([6,1],[7,1]);
            }
            else if(6 == param1)
            {
               checkAndOpen([7,1],[8,1],[9,1]);
            }
            else if(7 == param1)
            {
               checkAndOpen([7,1],[8,1],[9,1]);
            }
            else if(8 == param1)
            {
               checkAndOpen([9,1],[10,1],[11,1]);
            }
            else if(9 == param1)
            {
               checkAndOpen([9,1],[10,1],[11,1],[0,2],[1,2]);
            }
            else if(10 == param1)
            {
               checkAndOpen([9,1],[10,1],[11,1],[0,2],[1,2]);
            }
            else if(11 == param1)
            {
               checkAndOpen([0,2],[1,2],[2,2],[3,2]);
            }
         }
         else if(2 == param2)
         {
            if(0 == param1)
            {
               checkAndOpen([0,2],[1,2],[2,2],[3,2]);
            }
            else if(1 == param1)
            {
               checkAndOpen([4,2],[1,2],[2,2],[3,2]);
            }
            else if(2 == param1)
            {
               checkAndOpen([3,2],[4,2],[5,2]);
            }
            else if(3 == param1)
            {
               checkAndOpen([4,2],[5,2],[6,2]);
            }
            else if(4 == param1)
            {
               checkAndOpen([6,2],[7,2]);
            }
            else if(5 == param1)
            {
               checkAndOpen([6,2],[7,2]);
            }
            else if(6 == param1)
            {
               checkAndOpen([7,2],[8,2],[9,2]);
            }
            else if(7 == param1)
            {
               checkAndOpen([7,2],[8,2],[9,2]);
            }
            else if(8 == param1)
            {
               checkAndOpen([9,2],[10,2],[11,2]);
            }
            else if(9 == param1)
            {
               checkAndOpen([9,2],[10,2],[11,2]);
            }
            else if(10 == param1)
            {
               checkAndOpen([9,2],[10,2],[11,2]);
            }
            else if(11 == param1)
            {
            }
         }
         levelArray[param1][param2] = LEVEL_WON;
         updateLevels();
      }
      
      private function setQuality(param1:*) : void
      {
         switch(param1)
         {
            case options_dialog.low_quality_button:
               Global.mainStage.quality = "low";
               removeFilters(options_dialog.medium_quality_button);
               removeFilters(options_dialog.high_quality_button);
               applyFilter(options_dialog.low_quality_button);
               break;
            case options_dialog.medium_quality_button:
               Global.mainStage.quality = "medium";
               removeFilters(options_dialog.low_quality_button);
               removeFilters(options_dialog.high_quality_button);
               applyFilter(options_dialog.medium_quality_button);
               break;
            case options_dialog.high_quality_button:
               Global.mainStage.quality = "high";
               removeFilters(options_dialog.low_quality_button);
               removeFilters(options_dialog.medium_quality_button);
               applyFilter(options_dialog.high_quality_button);
         }
      }
      
      private function playNextClickHanler(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         _loc2_ = getNextLevelAndZone();
         if(_loc2_)
         {
            playLevel(_loc2_[0],_loc2_[1]);
         }
         else
         {
            playLevel(0,0);
         }
      }
      
      private function resumeGameButtonHandler(param1:MouseEvent) : void
      {
         visible = false;
         stopMusic();
         optionsDialogClose(null);
         Global.top.resumeGameHandler(null);
      }
      
      private function autoSendOnHandler(param1:MouseEvent) : void
      {
         var _loc2_:FocusManager = null;
         Global.top.engine.playSound(SoundConsts.click);
         _engine.autoSend = false;
         updateControls();
         _loc2_ = new FocusManager(Global.mainStage);
         _loc2_.setFocus(Global.mainStage);
      }
      
      public function clear() : void
      {
      }
      
      public function set levelArray(param1:Array) : void
      {
         level_array = param1;
      }
      
      public function applyFilter(param1:DisplayObject) : void
      {
         var _loc2_:ColorMatrixFilter = null;
         var _loc3_:Array = null;
         _loc2_ = new ColorMatrixFilter(color_matrix);
         _loc3_ = new Array();
         _loc3_.push(_loc2_);
         param1.filters = _loc3_;
      }
      
      private function checkAndOpen(... rest) : void
      {
         var _loc2_:Array = null;
         for each(_loc2_ in rest)
         {
            if(levelArray[_loc2_[0]][_loc2_[1]] != LEVEL_WON)
            {
               levelArray[_loc2_[0]][_loc2_[1]] = LEVEL_OPENED;
            }
         }
      }
      
      private function updateControls() : void
      {
         options_dialog.music_on_button.visible = !_engine.musicOff;
         options_dialog.music_off_button.visible = _engine.musicOff;
         options_dialog.auto_send_on_button.visible = _engine.autoSend;
         options_dialog.auto_send_off_button.visible = !_engine.autoSend;
      }
      
      public function playLevel(param1:int, param2:int) : void
      {
         Global.top.engine.playSound(SoundConsts.click);
         visible = false;
         stopMusic();
         if(param1 < LevelSelector.levelCount())
         {
            _engine.playLevel(param1,param2);
         }
         else
         {
            _engine.playLevel(0,0);
         }
      }
      
      private function showPlanetInfoOver(param1:int, param2:int, param3:*) : void
      {
         var _loc4_:BitmapFilter = null;
         var _loc5_:Array = null;
         removeGlowClip();
         _loc4_ = getGlowFilter();
         _loc5_ = new Array();
         _loc5_.push(_loc4_);
         param3.filters = _loc5_;
         _current_glow_clip = param3;
         if(param2)
         {
            param2--;
         }
      }
      
      public function get planetInfos() : Array
      {
         return planet_infos;
      }
      
      public function removeFilters(param1:DisplayObject) : void
      {
         var _loc2_:Array = null;
         _loc2_ = new Array();
         param1.filters = _loc2_;
      }
      
      private function musicOffHandler(param1:Event) : void
      {
         var _loc2_:FocusManager = null;
         _engine.musicOff = false;
         updateControls();
         playMusic();
         Global.top.playMusic();
         Global.top.engine.playSound(SoundConsts.click);
         _loc2_ = new FocusManager(Global.mainStage);
         _loc2_.setFocus(Global.mainStage);
      }
      
      public function setConqueredRate(param1:int) : void
      {
         conquered_percents = param1;
         conquered_bar.scaleX = 0.01 * conquered_percents;
         conquered_txt.text = conquered_percents + "%";
      }
      
      private function qualityButtonHandler(param1:MouseEvent) : void
      {
         Global.top.engine.playSound(SoundConsts.click);
         setQuality(param1.currentTarget);
      }
      
      private function zoneAttackButtonHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:LevelZone = null;
         _loc2_ = 0;
         while(_loc2_ < planets_back.panels.length)
         {
            if(planets_back.panels[_loc2_].zone1.attack_button == param1.currentTarget)
            {
               number_planet = _loc2_;
               number_zone = 0;
            }
            if(planets_back.panels[_loc2_].zone2.attack_button == param1.currentTarget)
            {
               number_planet = _loc2_;
               number_zone = 1;
            }
            if(planets_back.panels[_loc2_].zone3.attack_button == param1.currentTarget)
            {
               number_planet = _loc2_;
               number_zone = 2;
            }
            _loc2_++;
         }
         _loc3_ = translateBack(number_planet,number_zone);
         playLevel(_loc3_.level,_loc3_.zone);
      }
      
      public function show() : void
      {
         updateLevels();
         Global.top.saveLevels();
         playMusic();
         options_dialog.sound_control.setEngine(_engine,this);
         if(Global.top.engine.playWindowUI != null)
         {
            options_dialog.resume_button.visible = true;
         }
         else
         {
            options_dialog.resume_button.visible = false;
         }
         visible = true;
         showDefaultInfo();
         calcConquered();
      }
      
      private function mainMenuClickHanler(param1:Event) : void
      {
         Global.top.engine.playSound(SoundConsts.click);
         visible = false;
         stopMusic();
         Global.top.showWelcome();
         optionsDialogClose(null);
      }
      
      public function get levelArray() : Array
      {
         return level_array;
      }
      
      private function removeGlowClip() : void
      {
         if(_current_glow_clip)
         {
            _current_glow_clip.filters = new Array();
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
      
      private function showDefaultInfo() : void
      {
         var _loc1_:Array = null;
         var _loc2_:* = undefined;
         _loc1_ = getNextLevelAndZone();
         if(_loc1_)
         {
            _loc2_ = null;
            switch(_loc1_[1])
            {
               case 0:
                  _loc2_ = planets_back.getPlanetsArray()[_loc1_[0]].button_one;
                  break;
               case 1:
                  _loc2_ = planets_back.getPlanetsArray()[_loc1_[0]].button_two;
                  break;
               case 2:
                  _loc2_ = planets_back.getPlanetsArray()[_loc1_[0]].button_three;
            }
            showPlanetInfoOver(_loc1_[0],_loc1_[1],_loc2_);
         }
      }
      
      public function playMusic() : void
      {
         var _loc1_:SoundTransform = null;
         stopMusic();
         if(!_engine.volumeOff && !_engine.musicOff && Boolean(music_sound))
         {
            _loc1_ = new SoundTransform();
            _loc1_.volume = _engine.volume;
            music_channel = music_sound.play(0,99999,_loc1_);
         }
      }
      
      public function setRevenue(param1:int) : void
      {
      }
      
      private function getGlowFilter() : BitmapFilter
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         _loc1_ = 3394815;
         _loc2_ = 0.8;
         _loc3_ = 35;
         _loc4_ = 35;
         _loc5_ = 2;
         _loc6_ = false;
         _loc7_ = false;
         _loc8_ = BitmapFilterQuality.LOW;
         return new GlowFilter(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc8_,_loc6_,_loc7_);
      }
      
      private function calcConquered() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = 0;
         _loc2_ = 0;
         while(_loc2_ < levelArray.length)
         {
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               if(levelArray[_loc2_][_loc4_] == LEVEL_WON)
               {
                  _loc1_++;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         _loc3_ = _loc1_ * 100 / (levelArray.length * 3) + 0.5;
         setConqueredRate(_loc3_);
      }
      
      private function getXPanel(param1:LevelZone) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = null;
         switch(param1.zone)
         {
            case 0:
               _loc2_ = planets_back.panels[param1.level].zone1;
               break;
            case 1:
               _loc2_ = planets_back.panels[param1.level].zone2;
               break;
            case 2:
               _loc2_ = planets_back.panels[param1.level].zone3;
         }
         return _loc2_;
      }
      
      private function FnPlanetShow3_OUT(param1:MouseEvent) : void
      {
         removeGlowClip();
         showDefaultInfo();
      }
      
      public function initialize() : void
      {
         options_dialog.visible = false;
         options_dialog.close_button.addEventListener(MouseEvent.MOUSE_DOWN,optionsDialogClose);
         options_dialog.close_button.tabEnabled = false;
         cacheAsBitmap = true;
         main_menu_button.addEventListener(MouseEvent.MOUSE_DOWN,mainMenuClickHanler);
         play_next_button.addEventListener(MouseEvent.MOUSE_DOWN,playNextClickHanler);
         options_button.addEventListener(MouseEvent.MOUSE_DOWN,optionsDialogClickHanler);
         options_dialog.reset_saved_button.addEventListener(MouseEvent.MOUSE_DOWN,resetSavedHandler);
         options_dialog.reset_saved_button.tabEnabled = false;
         options_dialog.main_menu_button.addEventListener(MouseEvent.MOUSE_DOWN,optionsMainMenuButtonHandler);
         options_dialog.main_menu_button.tabEnabled = false;
         options_dialog.resume_button.addEventListener(MouseEvent.MOUSE_DOWN,resumeGameButtonHandler);
         options_dialog.resume_button.tabEnabled = false;
         options_dialog.music_on_button.addEventListener(MouseEvent.MOUSE_DOWN,musicOnHandler);
         options_dialog.music_off_button.addEventListener(MouseEvent.MOUSE_DOWN,musicOffHandler);
         options_dialog.music_on_button.tabEnabled = false;
         options_dialog.music_off_button.tabEnabled = false;
         options_dialog.auto_send_on_button.addEventListener(MouseEvent.MOUSE_DOWN,autoSendOnHandler);
         options_dialog.auto_send_off_button.addEventListener(MouseEvent.MOUSE_DOWN,autoSendOffHandler);
         options_dialog.low_quality_button.addEventListener(MouseEvent.MOUSE_DOWN,qualityButtonHandler);
         options_dialog.medium_quality_button.addEventListener(MouseEvent.MOUSE_DOWN,qualityButtonHandler);
         options_dialog.high_quality_button.addEventListener(MouseEvent.MOUSE_DOWN,qualityButtonHandler);
         flonga_button.addEventListener(MouseEvent.MOUSE_DOWN,GameStage.sponsorClick);
         options_dialog.auto_send_on_button.tabEnabled = false;
         options_dialog.auto_send_off_button.tabEnabled = false;
         options_dialog.low_quality_button.tabEnabled = false;
         options_dialog.medium_quality_button.tabEnabled = false;
         options_dialog.high_quality_button.tabEnabled = false;
         flonga_button.tabEnabled = false;
         level = this;
         level.planets_back.x = -(level.planets_back.width - 700) / 2;
         level.planets_back_star.x = -(level.planets_back_star.width - 700) / 2;
         level.planets_star.x = -(level.planets_back_star.width - 700) / 2;
         level.planets_nebula.x = -(level.planets_back_star.width - 700) / 2;
         map_goal = new MapGoal(level);
         ProcessManager.goalSystem.add(map_goal);
         updateLevels();
         calcConquered();
         options_dialog.sound_control.setEngine(_engine,this);
         updateControls();
         cacheAsBitmap = true;
         setQuality(options_dialog.high_quality_button);
      }
      
      public function updateLevels() : void
      {
         var _loc1_:int = 0;
         var _loc2_:LevelZone = null;
         var _loc3_:* = undefined;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         destroyLevel();
         setRevenue(_engine.creds);
         _loc1_ = 0;
         _loc1_ = 0;
         while(_loc1_ < level_array.length)
         {
            planets_back.getIconArray()[_loc1_].gotoAndStop("inactive_state");
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < level_array.length)
         {
            _loc2_ = null;
            _loc3_ = null;
            _loc4_ = false;
            _loc5_ = 0;
            while(_loc5_ < 3)
            {
               _loc2_ = translate(_loc1_,_loc5_);
               _loc3_ = getXPanel(_loc2_);
               _loc3_.dif_txt.text = planet_infos[_loc1_][_loc5_][1].toString();
               _loc3_.treasure_txt.text = int(LevelSelector.bestCounteractionLikelihood(_loc1_,_loc5_) * 100) + "%";
               if(level_array[_loc1_][_loc5_] == LEVEL_OPENED)
               {
                  _loc4_ = true;
                  planets_back.getIconArray()[_loc2_.level].gotoAndStop("active_state");
                  updatePlanet(_loc2_.level,_loc2_.zone,2,true,1);
               }
               if(level_array[_loc1_][_loc5_] == LEVEL_CLOSED)
               {
                  updatePlanet(_loc2_.level,_loc2_.zone,1,false,1);
               }
               if(level_array[_loc1_][_loc5_] == LEVEL_WON)
               {
                  updatePlanet(_loc2_.level,_loc2_.zone,3,true,0.5);
               }
               _loc5_++;
            }
            _loc1_++;
         }
      }
      
      public function optionsDialogClickHanler(param1:Event) : void
      {
         Global.top.engine.playSound(SoundConsts.click);
         updateControls();
         options_dialog.visible = true;
         options_dialog.close_button.addEventListener(MouseEvent.MOUSE_DOWN,optionsDialogClose);
         options_dialog.music_on_button.addEventListener(MouseEvent.MOUSE_DOWN,musicOnHandler);
         options_dialog.music_off_button.addEventListener(MouseEvent.MOUSE_DOWN,musicOffHandler);
         options_dialog.reset_saved_button.addEventListener(MouseEvent.MOUSE_DOWN,resetSavedHandler);
         options_dialog.main_menu_button.addEventListener(MouseEvent.MOUSE_DOWN,optionsMainMenuButtonHandler);
      }
      
      public function destroyLevel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < level_array.length)
         {
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               if(_loc2_ == 0)
               {
                  planets_back.getPlanetsArray()[_loc1_].button_one.removeEventListener(MouseEvent.MOUSE_DOWN,FnPlanetSelect);
                  planets_back.getPlanetsArray()[_loc1_].button_one.removeEventListener(MouseEvent.MOUSE_OVER,FnPlanetShow3);
                  planets_back.getPlanetsArray()[_loc1_].button_one.removeEventListener(MouseEvent.MOUSE_OUT,FnPlanetShow3_OUT);
                  planets_back.panels[_loc1_].zone1.attack_button.removeEventListener(MouseEvent.MOUSE_DOWN,zoneAttackButtonHandler);
                  planets_back.getPlanetsArray()[_loc1_].button_one.listener_added = false;
                  planets_back.getPlanetsArray()[_loc1_].button_one.buttonMode = true;
                  planets_back.getPlanetsArray()[_loc1_].button_one.tabEnabled = false;
                  planets_back.getPlanetsArray()[_loc1_].button_one.mouseChildren = false;
               }
               if(_loc2_ == 1)
               {
                  planets_back.getPlanetsArray()[_loc1_].button_two.removeEventListener(MouseEvent.MOUSE_DOWN,FnPlanetSelect);
                  planets_back.getPlanetsArray()[_loc1_].button_two.removeEventListener(MouseEvent.MOUSE_OVER,FnPlanetShow3);
                  planets_back.getPlanetsArray()[_loc1_].button_two.removeEventListener(MouseEvent.MOUSE_OUT,FnPlanetShow3_OUT);
                  planets_back.panels[_loc1_].zone2.attack_button.removeEventListener(MouseEvent.MOUSE_DOWN,zoneAttackButtonHandler);
                  planets_back.getPlanetsArray()[_loc1_].button_two.listener_added = false;
                  planets_back.getPlanetsArray()[_loc1_].button_two.buttonMode = true;
                  planets_back.getPlanetsArray()[_loc1_].button_two.tabEnabled = false;
                  planets_back.getPlanetsArray()[_loc1_].button_two.mouseChildren = false;
               }
               if(_loc2_ == 2)
               {
                  planets_back.getPlanetsArray()[_loc1_].button_three.removeEventListener(MouseEvent.MOUSE_DOWN,FnPlanetSelect);
                  planets_back.getPlanetsArray()[_loc1_].button_three.removeEventListener(MouseEvent.MOUSE_OVER,FnPlanetShow3);
                  planets_back.getPlanetsArray()[_loc1_].button_three.removeEventListener(MouseEvent.MOUSE_OUT,FnPlanetShow3_OUT);
                  planets_back.panels[_loc1_].zone2.attack_button.removeEventListener(MouseEvent.MOUSE_DOWN,zoneAttackButtonHandler);
                  planets_back.getPlanetsArray()[_loc1_].button_three.listener_added = false;
                  planets_back.getPlanetsArray()[_loc1_].button_three.buttonMode = true;
                  planets_back.getPlanetsArray()[_loc1_].button_three.tabEnabled = false;
                  planets_back.getPlanetsArray()[_loc1_].button_three.mouseChildren = false;
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function resetSavedHandler(param1:Event) : void
      {
         Global.top.engine.playSound(SoundConsts.click);
         Global.top.resetSaved();
         updateLevels();
      }
      
      private function updatePlanet(param1:int, param2:int, param3:int, param4:Boolean, param5:Number) : void
      {
         if(param2 == 0)
         {
            planets_back.getPlanetsArray()[param1].button_one.gotoAndStop(param3);
            if(!planets_back.getPlanetsArray()[param1].button_one.listener_added)
            {
               planets_back.getPlanetsArray()[param1].button_one.addEventListener(MouseEvent.MOUSE_DOWN,FnPlanetSelect);
               planets_back.getPlanetsArray()[param1].button_one.addEventListener(MouseEvent.MOUSE_OVER,FnPlanetShow3);
               planets_back.getPlanetsArray()[param1].button_one.addEventListener(MouseEvent.MOUSE_OUT,FnPlanetShow3_OUT);
               planets_back.panels[param1].zone1.attack_button.addEventListener(MouseEvent.MOUSE_DOWN,zoneAttackButtonHandler);
               planets_back.getPlanetsArray()[param1].button_one.listener_added = true;
            }
            planets_back.panels[param1].zone1.attack_button.visible = param4;
            planets_back.panels[param1].zone1.attack_button.alpha = param5;
         }
         if(param2 == 1)
         {
            planets_back.getPlanetsArray()[param1].button_two.gotoAndStop(param3);
            if(!planets_back.getPlanetsArray()[param1].button_two.listener_added)
            {
               planets_back.getPlanetsArray()[param1].button_two.addEventListener(MouseEvent.MOUSE_DOWN,FnPlanetSelect);
               planets_back.getPlanetsArray()[param1].button_two.addEventListener(MouseEvent.MOUSE_OVER,FnPlanetShow3);
               planets_back.getPlanetsArray()[param1].button_two.addEventListener(MouseEvent.MOUSE_OUT,FnPlanetShow3_OUT);
               planets_back.panels[param1].zone2.attack_button.addEventListener(MouseEvent.MOUSE_DOWN,zoneAttackButtonHandler);
               planets_back.getPlanetsArray()[param1].button_two.listener_added = true;
            }
            planets_back.panels[param1].zone2.attack_button.visible = param4;
            planets_back.panels[param1].zone2.attack_button.alpha = param5;
         }
         if(param2 == 2)
         {
            planets_back.getPlanetsArray()[param1].button_three.gotoAndStop(param3);
            if(!planets_back.getPlanetsArray()[param1].button_three.listener_added)
            {
               planets_back.getPlanetsArray()[param1].button_three.addEventListener(MouseEvent.MOUSE_DOWN,FnPlanetSelect);
               planets_back.getPlanetsArray()[param1].button_three.addEventListener(MouseEvent.MOUSE_OVER,FnPlanetShow3);
               planets_back.getPlanetsArray()[param1].button_three.addEventListener(MouseEvent.MOUSE_OUT,FnPlanetShow3_OUT);
               planets_back.panels[param1].zone3.attack_button.addEventListener(MouseEvent.MOUSE_DOWN,zoneAttackButtonHandler);
               planets_back.getPlanetsArray()[param1].button_three.listener_added = true;
            }
            planets_back.panels[param1].zone3.attack_button.visible = param4;
            planets_back.panels[param1].zone3.attack_button.alpha = param5;
         }
      }
      
      private function FnPlanetSelect(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:LevelZone = null;
         _loc2_ = 0;
         while(_loc2_ < level_array.length)
         {
            if(planets_back.getPlanetsArray()[_loc2_].button_one == param1.currentTarget)
            {
               number_planet = _loc2_;
               number_zone = 0;
            }
            if(planets_back.getPlanetsArray()[_loc2_].button_two == param1.currentTarget)
            {
               number_planet = _loc2_;
               number_zone = 1;
            }
            if(planets_back.getPlanetsArray()[_loc2_].button_three == param1.currentTarget)
            {
               number_planet = _loc2_;
               number_zone = 2;
            }
            _loc2_++;
         }
         _loc3_ = translateBack(number_planet,number_zone);
         if(level_array[_loc3_.level][_loc3_.zone] == LEVEL_OPENED)
         {
            playLevel(_loc3_.level,_loc3_.zone);
         }
      }
      
      private function musicOnHandler(param1:Event) : void
      {
         var _loc2_:FocusManager = null;
         _engine.musicOff = true;
         updateControls();
         playMusic();
         Global.top.stopMusic();
         _loc2_ = new FocusManager(Global.mainStage);
         _loc2_.setFocus(Global.mainStage);
      }
      
      private function optionsMainMenuButtonHandler(param1:MouseEvent) : void
      {
         mainMenuClickHanler(null);
      }
   }
}

class LevelZone
{
   
   public var level:int = 0;
   
   public var zone:int = 0;
   
   public function LevelZone()
   {
      super();
   }
}
