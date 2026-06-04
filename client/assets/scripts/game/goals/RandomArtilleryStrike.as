package game.goals
{
   import core.Global;
   import core.goal.Goal;
   import flash.geom.Point;
   import game.logic.Engine;
   
   public class RandomArtilleryStrike extends Goal
   {
      
      private var _engine:Engine = null;
      
      private var _pause:int = 0;
      
      private var PAUSE_NEAR:int = 9 * 30;
      
      public function RandomArtilleryStrike()
      {
         super();
         _engine = Global.top.engine;
      }
      
      override public function advance() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Point = null;
         if(_pause > 0)
         {
            --_pause;
            return;
         }
         _loc1_ = 5 * (Math.random() - 0.01);
         _loc2_ = new Point(85 + Math.random() * 490,250 + Math.random() * 200);
         _engine.goalSystem.add(new ArtilleryStrikeGoal(_loc1_,_loc2_,1));
         _pause = PAUSE_NEAR / 2 + PAUSE_NEAR * Math.random() - PAUSE_NEAR * Math.random();
      }
   }
}

