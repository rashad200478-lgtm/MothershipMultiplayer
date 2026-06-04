package game.goals
{
   import core.Global;
   import core.ProcessManager;
   import core.goal.PausedGoal;
   import game.logic.Engine;
   
   public class FinalBalanceCheckingGoal extends PausedGoal
   {
      
      private var _scale_changed:Boolean = false;
      
      private var _smooth_pause:int = 90;
      
      private var _engine:Engine = null;
      
      public function FinalBalanceCheckingGoal()
      {
         super(5);
         _engine = Global.top.engine;
      }
      
      override public function advance() : void
      {
         super.advance();
         if(_scale_changed)
         {
            if(_smooth_pause > 0)
            {
               --_smooth_pause;
               if(0 == _smooth_pause)
               {
                  ProcessManager.instance.timeScale = 3;
               }
            }
         }
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         ProcessManager.instance.timeScale = 1;
      }
      
      override protected function pausedAdvance() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(_scale_changed)
         {
            return;
         }
         _loc1_ = _engine.gameBoard.enemyUnits.aliveCount();
         _loc2_ = _engine.gameBoard.allyUnits.aliveCount();
         if(_loc1_ == 0 && _loc2_ != 0 || _loc2_ == 0 && _loc1_ != 0)
         {
            _scale_changed = true;
         }
      }
   }
}

