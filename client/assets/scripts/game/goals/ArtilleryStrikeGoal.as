package game.goals
{
   import core.Global;
   import core.goal.Goal;
   import flash.geom.Point;
   import game.Consts;
   import game.logic.EffectFactory;
   import game.logic.Engine;
   
   public class ArtilleryStrikeGoal extends Goal
   {
      
      private static const DROP_PAUSE:int = 15;
      
      private var drop_point:Point = null;
      
      private var _engine:Engine = null;
      
      private var _road_index:int = 0;
      
      private var pause:int = 0;
      
      private var drop_count:int = 0;
      
      public function ArtilleryStrikeGoal(param1:int, param2:Point, param3:int)
      {
         super();
         _road_index = param1;
         drop_point = param2;
         drop_count = param3;
         _engine = Global.top.engine;
      }
      
      override public function advance() : void
      {
         var _loc1_:Point = null;
         if(pause > 0)
         {
            --pause;
            return;
         }
         --drop_count;
         _loc1_ = new Point(drop_point.x + Math.random() * 120 - 50,drop_point.y + Math.random() * 30 - 15);
         EffectFactory.makeExplosion(EffectFactory.ASTRIKE_DROP,_loc1_,0.5,_engine.gameBoard.getRoadUnitLayer(_road_index));
         applyDamage(_loc1_);
         pause = DROP_PAUSE;
         if(0 == drop_count)
         {
            deactivate();
         }
      }
      
      private function applyDamage(param1:Point) : void
      {
         var _loc2_:Engine = null;
         _loc2_ = Global.top.engine;
         _loc2_.gameBoard.enemyUnits.applyDamageNear(Consts.ARTILLERY_DAMAGE,param1,Consts.ARTILLERY_RANGE,DieMarineGoal.DEATH_BY_EXPLOSION);
         _loc2_.gameBoard.allyUnits.applyDamageNear(Consts.ARTILLERY_DAMAGE,param1,Consts.ARTILLERY_RANGE,DieMarineGoal.DEATH_BY_EXPLOSION);
         _loc2_.gameBoard.mines.applyDamageNear(Consts.ARTILLERY_DAMAGE,param1,Consts.ARTILLERY_RANGE,DieMarineGoal.DEATH_BY_EXPLOSION);
      }
   }
}

