package game.goals
{
   import core.goal.Goal;
   import game.ui.RoadPath;
   
   public class IndicateRoadGoal extends Goal
   {
      
      private var road:RoadPath = null;
      
      public function IndicateRoadGoal(param1:RoadPath)
      {
         super();
         road = param1;
      }
      
      public function theRoad() : *
      {
         return road;
      }
   }
}

