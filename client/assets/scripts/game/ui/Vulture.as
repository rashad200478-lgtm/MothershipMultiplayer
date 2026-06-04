package game.ui
{
   import flash.display.MovieClip;
   import game.goals.VultureGoal;
   
   public class Vulture extends MovieClip
   {
      
      private var assigned_goal:VultureGoal = null;
      
      public var inner:MovieClip;
      
      private var _finished:Boolean = false;
      
      public function Vulture()
      {
         super();
      }
      
      protected function vehicleLanded() : void
      {
         assigned_goal.vehicleLanded();
      }
      
      public function setGoal(param1:VultureGoal) : void
      {
         assigned_goal = param1;
      }
      
      protected function tripFinished() : void
      {
         _finished = true;
      }
      
      public function get isFinished() : Boolean
      {
         return _finished;
      }
   }
}

