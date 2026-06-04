package core.goal
{
   public class GoalSystem extends Goal
   {
      
      private static const GOALS_CLEAN_PAUSE:uint = 10;
      
      public var goals:Array = [];
      
      private var counter:int = 0;
      
      private var active_count:int = 0;
      
      public function GoalSystem()
      {
         super();
      }
      
      override public function advance() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         active_count = 0;
         while(_loc1_ < goals.length)
         {
            if(goals[_loc1_].alive)
            {
               goals[_loc1_].advance();
               ++active_count;
            }
            _loc1_++;
         }
         if(!counter)
         {
            cleanGoals();
            counter = GOALS_CLEAN_PAUSE;
         }
         else
         {
            --counter;
         }
      }
      
      public function add(param1:IGoal) : void
      {
         goals.push(param1);
      }
      
      public function activeCount() : int
      {
         return active_count;
      }
      
      override public function deactivate() : void
      {
         deactivateChildren();
         super.deactivate();
      }
      
      private function cleanGoals() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < goals.length)
         {
            if(!goals[_loc1_].alive)
            {
               delete goals[_loc1_];
               goals.splice(_loc1_,1);
            }
            else
            {
               _loc1_++;
            }
         }
      }
      
      public function deactivateChildren() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < goals.length)
         {
            if(goals[_loc1_].alive)
            {
               goals[_loc1_].deactivate();
            }
            _loc1_++;
         }
         goals.length = 0;
      }
   }
}

