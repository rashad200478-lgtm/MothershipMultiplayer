package game.ui
{
   import core.*;
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.text.*;
   import flash.utils.Timer;
   import game.*;
   import game.logic.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol898")]
   public class Statistics extends Sprite
   {
      
      public var time_txt:TextField;
      
      public var stat_caption:MovieClip;
      
      public var monsters_txt:TextField;
      
      public var bonus:int = 0;
      
      public var score_txt:TextField;
      
      private var engine:Engine = null;
      
      public var bonus_txt:TextField;
      
      private var level_won:Boolean = false;
      
      public var final_victory:MovieClip;
      
      private var music_sound:Sound = null;
      
      private var times:int = 0;
      
      private var score:int = 0;
      
      private var counterTimer:Timer = null;
      
      public var main_menu_button:SimpleButton;
      
      public var continue_button:SimpleButton;
      
      public var monsters:int = 0;
      
      public var music_channel:SoundChannel = null;
      
      public function Statistics()
      {
         super();
      }
      
      public function victory() : void
      {
         level_won = true;
         stat_caption.innerc.stat_title.text = "Well Done!";
         continue_button.visible = true;
      }
      
      private function counter(param1:*, param2:int) : int
      {
         var _loc3_:int = 0;
         if(param2 > 0)
         {
            _loc3_ = param2 > 30 ? int(param2 / 30) : param2;
            param1.text = (int(param1.text) + _loc3_).toString();
            return _loc3_;
         }
         return 0;
      }
      
      public function setEngine(param1:Engine) : void
      {
         engine = param1;
         main_menu_button.addEventListener(MouseEvent.MOUSE_DOWN,mainMenu);
         continue_button.addEventListener(MouseEvent.MOUSE_DOWN,continueButtonHandler);
      }
      
      public function start() : void
      {
         playMusic();
         monsters_txt.text = "0";
         time_txt.text = "0";
         bonus_txt.text = "0";
         score_txt.text = "0";
         score = engine.gameScore;
         counterTimer = new Timer(30,0);
         counterTimer.addEventListener(TimerEvent.TIMER,counterTick);
         counterTimer.start();
      }
      
      private function replayHandler(param1:MouseEvent) : void
      {
         visible = false;
         engine.playSound(SoundConsts.click);
         engine.playLevel(engine.lastLevelIndex,engine.lastZone);
      }
      
      private function submitScore(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = engine.gameScore;
         engine.gameScore = 0;
      }
      
      public function stopMusic() : void
      {
         if(music_channel)
         {
            music_channel.stop();
            music_channel = null;
         }
      }
      
      public function defeat() : void
      {
         level_won = false;
         stat_caption.innerc.stat_title.text = "Failed. Try Again!";
      }
      
      private function continueButtonHandler(param1:MouseEvent) : void
      {
         visible = false;
         engine.playSound(SoundConsts.click);
         engine.clearAll();
         if(level_won && engine.lastLevelIndex >= LevelSelector.levelCount() - 1)
         {
            Global.top.showWelcome();
         }
         else if(level_won)
         {
            engine.playLevel(engine.lastLevelIndex + 1,engine.lastZone);
         }
         else
         {
            engine.playLevel(engine.lastLevelIndex,engine.lastZone);
         }
         param1.stopPropagation();
      }
      
      public function playMusic() : void
      {
         var _loc1_:SoundTransform = null;
         stopMusic();
         if(!engine.volumeOff && !engine.musicOff && Boolean(music_sound))
         {
            _loc1_ = new SoundTransform();
            _loc1_.volume = engine.volume;
            music_channel = music_sound.play(0,1,_loc1_);
         }
      }
      
      private function mainMenu(param1:MouseEvent) : void
      {
         visible = false;
         engine.playSound(SoundConsts.click);
         engine.clearAll();
         Global.top.showWelcome();
      }
      
      private function counterTick(param1:TimerEvent) : void
      {
         monsters -= counter(monsters_txt,monsters);
         bonus -= counter(bonus_txt,bonus);
         score -= counter(score_txt,score);
         times -= counter(time_txt,times);
         if(times + monsters + bonus + score == 0)
         {
            counterTimer.stop();
            counterTimer.removeEventListener(TimerEvent.TIMER,counterTick);
            counterTimer = null;
         }
      }
      
      public function destroy() : void
      {
         if(counterTimer)
         {
            counterTimer.stop();
            counterTimer.removeEventListener(TimerEvent.TIMER,counterTick);
            counterTimer = null;
         }
         stopMusic();
         continue_button.removeEventListener(MouseEvent.MOUSE_DOWN,continueButtonHandler);
         main_menu_button.removeEventListener(MouseEvent.MOUSE_DOWN,mainMenu);
      }
   }
}

