package game.goals
{
   import core.goal.GoalSystem;
   
   public class ButtonSetGoal extends GoalSystem
   {
      
      public function ButtonSetGoal()
      {
         super();
      }
      
      override public function advance() : void
      {
         super.advance();
      }
      
      public function addButton(param1:*, param2:String, param3:int, param4:Boolean) : void
      {
         var _loc5_:ButtonTicksGoal = null;
         _loc5_ = new ButtonTicksGoal(param1,param2,param3);
         add(_loc5_);
         param1.ticks_goal = _loc5_;
      }
      
      public function resetAll() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < goals.length)
         {
            goals[_loc1_].reset();
            _loc1_++;
         }
      }
      
      public function setPaused(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < goals.length)
         {
            goals[_loc2_].paused = param1;
            _loc2_++;
         }
      }
      
      public function setReadyAll() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < goals.length)
         {
            goals[_loc1_].setReady();
            _loc1_++;
         }
      }
   }
}

