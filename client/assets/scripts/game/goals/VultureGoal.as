package game.goals
{
   import core.goal.Goal;
   import game.StringConsts;
   import game.logic.Engine;
   import game.ui.RoadPath;
   import game.units.Unit;
   
   public class VultureGoal extends Goal
   {
      
      private static const LANDING_TICKS:int = 25;
      
      private static const LANDING_FORCES_COUNT:int = 3;
      
      private var unit:Unit = null;
      
      private var landing_ticks:int = 0;
      
      private var landing_forces_type:String;
      
      private var engine:Engine = null;
      
      private var road:RoadPath = null;
      
      private var LANDING_FORCES_TYPE:String = StringConsts.MARINE;
      
      public function VultureGoal(param1:Engine, param2:Unit, param3:RoadPath)
      {
         super();
         engine = param1;
         unit = param2;
         road = param3;
         landing_forces_type = LANDING_FORCES_TYPE;
         unit.sprite.y = road.y + road.points.values[0].y - unit.sprite.height / 1.2;
         if(unit.isEnemy)
         {
            unit.sprite.x = 1018;
         }
         else
         {
            unit.sprite.x = -324;
         }
         unit.sprite.setGoal(this);
         engine.levelMap.addChild(unit.sprite);
         unit.sprite.play();
      }
      
      override public function advance() : void
      {
         if(landing_ticks > 0)
         {
            --landing_ticks;
            if(0 == landing_ticks)
            {
               landForces();
               flyAway();
            }
         }
         if(unit.sprite.isFinished)
         {
            deactivate();
         }
      }
      
      public function vehicleLanded() : void
      {
         landing_ticks = LANDING_TICKS;
      }
      
      private function flyAway() : void
      {
         unit.sprite.gotoAndPlay("departure");
      }
      
      override public function deactivate() : void
      {
         if(!unit)
         {
            return;
         }
         engine.gameBoard.wipeUnit(unit);
         unit = null;
         super.deactivate();
      }
      
      private function landForces() : void
      {
         var _loc1_:Unit = null;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:MoveSimpleGoal = null;
         _loc1_ = null;
         _loc2_ = 0.37;
         _loc3_ = 0;
         while(_loc3_ < LANDING_FORCES_COUNT)
         {
            if(_loc3_ == 0)
            {
               _loc1_ = engine.gameBoard.createUnit(StringConsts.MISSILE_MAN,road.index,unit.isEnemy);
            }
            else
            {
               _loc1_ = engine.gameBoard.createUnit(landing_forces_type,road.index,unit.isEnemy);
            }
            if(null == _loc1_.life.getMover().currentNode())
            {
               if(_loc1_.isEnemy)
               {
                  _loc1_.life.getMover().gotoPrev();
               }
               else
               {
                  _loc1_.life.getMover().gotoNext();
               }
            }
            _loc4_ = _loc1_.life.getMover().simpleMoveGoal;
            _loc4_.moveOn(_loc2_);
            _loc2_ += 0.016;
            _loc3_++;
         }
      }
   }
}

