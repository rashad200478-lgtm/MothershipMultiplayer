package game.goals
{
   import core.goal.Goal;
   import game.*;
   import game.logic.*;
   import game.ui.*;
   import game.units.*;
   
   public class MinePlacingGoal extends Goal
   {
      
      private var pause_ticks:int = 200;
      
      private var PLACING_TICKS:int = 16;
      
      protected var unit:Unit = null;
      
      protected var engine:Engine = null;
      
      private var placing_ticks:int = 0;
      
      public function MinePlacingGoal(param1:Engine, param2:Unit)
      {
         super();
         engine = param1;
         unit = param2;
      }
      
      override public function advance() : void
      {
         if(pause_ticks > 0)
         {
            --pause_ticks;
            return;
         }
         if(placing_ticks > 0)
         {
            --placing_ticks;
            if(0 == placing_ticks)
            {
               PLACING_TICKS = unit.sprite.inner.totalFrames;
               placeMine();
               resetState();
            }
            return;
         }
         startPlacingMine();
      }
      
      protected function placeMine() : void
      {
         var _loc1_:Unit = null;
         var _loc2_:* = undefined;
         var _loc3_:MineGoal = null;
         _loc1_ = UnitCreator.create(StringConsts.MINE,unit.isEnemy);
         _loc1_.sprite.alpha = 0.75;
         _loc1_.sprite.x = unit.sprite.x + unit.sprite.shot_point.x * unit.sprite.scaleX;
         _loc1_.sprite.y = unit.sprite.y + unit.sprite.shot_point.y * unit.sprite.scaleX;
         engine.gameBoard.unitMaskLayer.addChild(_loc1_.sprite);
         _loc1_.activate(engine);
         _loc1_.life.breathe();
         _loc2_ = new IndicateRoadGoal(unit.life.getCurrentRoad());
         _loc1_.life.setMover(_loc2_);
         _loc1_.currentState = Unit.WALKING;
         _loc3_ = new MineGoal(engine,_loc1_);
         _loc1_.life.add(_loc3_);
         engine.playSound(SoundConsts.mine_set);
      }
      
      private function startPlacingMine() : void
      {
         unit.currentState = Unit.ATTACK;
         unit.sprite.gotoAndStop("attack");
         placing_ticks = PLACING_TICKS;
      }
      
      private function resetState() : void
      {
         unit.currentState = Unit.WALKING;
         unit.sprite.gotoAndStop("walking");
         pause_ticks = unit.weapon.recharge_time;
      }
   }
}

