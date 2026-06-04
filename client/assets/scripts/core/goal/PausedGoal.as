package core.goal
{
   public class PausedGoal extends Goal
   {
      
      private var PAUSE:int = 5;
      
      private var _pause:int = 0;
      
      public function PausedGoal(param1:int)
      {
         super();
         PAUSE = param1;
      }
      
      override public function advance() : void
      {
         if(_pause > 0)
         {
            --_pause;
            return;
         }
         pausedAdvance();
         _pause = PAUSE;
      }
      
      protected function pausedAdvance() : void
      {
      }
   }
}

