package game.goals
{
   import core.Global;
   import core.goal.PausedGoal;
   import game.logic.Engine;
   
   public class AutoSendCheckGoal extends PausedGoal
   {
      
      private var _engine:Engine = null;
      
      public function AutoSendCheckGoal()
      {
         super(6);
         _engine = Global.top.engine;
      }
      
      override protected function pausedAdvance() : void
      {
         if(!_engine.autoSend)
         {
            return;
         }
         _engine.events.sendUnitAction(true);
      }
   }
}

