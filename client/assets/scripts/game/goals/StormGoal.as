package game.goals
{
   import caurina.transitions.Tweener;
   import core.Global;
   import core.goal.Goal;
   import game.SoundConsts;
   import game.logic.Engine;
   
   public class StormGoal extends Goal
   {
      
      private var _storm_bar:* = null;
      
      private var _waiting:Boolean = false;
      
      private var _show_messages:Boolean = true;
      
      private var engine:Engine = null;
      
      public var PAUSE:int = 1920;
      
      private var _storm_label:* = null;
      
      private var pause:int = 0;
      
      public function StormGoal(param1:*, param2:*, param3:int, param4:Boolean)
      {
         super();
         _show_messages = param4;
         PAUSE = param3;
         _storm_bar = param1;
         _storm_label = param2;
         _storm_label.stop();
         engine = Global.top.engine;
         pause = PAUSE;
         stormBar.setProgress(0);
      }
      
      override public function advance() : void
      {
         if(_waiting)
         {
            return;
         }
         if(pause > 0)
         {
            --pause;
            stormBar.setProgress(1 - pause / PAUSE);
            return;
         }
         setStormWaiting();
      }
      
      public function get isWaiting() : Boolean
      {
         return _waiting;
      }
      
      public function get stormLabel() : *
      {
         return _storm_label;
      }
      
      public function hideStormHatchArrows() : void
      {
         engine.levelMap.storm_hatch_arrows.visible = false;
      }
      
      public function increaseCharge(param1:int) : void
      {
         if(pause - param1 <= 0)
         {
            pause = 0;
         }
         else
         {
            pause -= param1;
         }
      }
      
      private function setStormWaiting() : void
      {
         _waiting = true;
         stormLabel.gotoAndStop("waiting_label");
         if(_show_messages)
         {
            engine.levelMap.storm_hatch_arrows.alpha = 1;
            engine.levelMap.storm_hatch_arrows.visible = true;
            Tweener.removeTweens(engine.levelMap.storm_hatch_arrows);
            engine.playWindowUI.logMessage("Storm attack is ready!");
         }
         engine.playSound(SoundConsts.storm_attack);
      }
      
      public function reset() : void
      {
         stormBar.setProgress(0);
         stormLabel.gotoAndStop("normal_label");
         _waiting = false;
         pause = PAUSE;
         if(_show_messages)
         {
            Tweener.addTween(engine.levelMap.storm_hatch_arrows,{
               "alpha":0,
               "time":2,
               "transition":"easeOutQuad",
               "onComplete":hideStormHatchArrows
            });
         }
      }
      
      public function get stormBar() : *
      {
         return _storm_bar;
      }
   }
}

