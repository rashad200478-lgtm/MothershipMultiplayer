package game.goals
{
   import core.Global;
   import core.goal.Goal;
   import game.logic.AIThinker;
   import game.logic.Engine;
   
   public class AISelectButtonGoal extends Goal
   {
      
      private static const PAUSE:int = 5;
      
      private var _direction:Boolean = false;
      
      private var _thinker:AIThinker = null;
      
      private var _engine:Engine = null;
      
      private var _button_type:String;
      
      private var _method:Function = null;
      
      private var _pause:int = 0;
      
      private var _args:Array = null;
      
      public function AISelectButtonGoal(param1:String, param2:AIThinker, param3:Function, ... rest)
      {
         super();
         _engine = Global.top.engine;
         _button_type = param1;
         _thinker = param2;
         _method = param3;
         _args = rest;
         _direction = Math.random() > 0.5 ? true : false;
      }
      
      override public function advance() : void
      {
         if(_pause > 0)
         {
            --_pause;
            if(_pause == 0)
            {
               nextStep();
            }
            return;
         }
         _pause = PAUSE;
      }
      
      private function nextStep() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = _engine.playWindowUI.enemyButons.getCurrentButton();
         if(_loc1_.unit_type == _button_type)
         {
            makeTheCall();
            deactivate();
            return;
         }
         if(_direction)
         {
            _engine.playWindowUI.enemyButons.moveSelectionLeft();
         }
         else
         {
            _engine.playWindowUI.enemyButons.moveSelectionRight();
         }
      }
      
      private function makeTheCall() : void
      {
         _method.apply(_thinker,_args);
      }
   }
}

