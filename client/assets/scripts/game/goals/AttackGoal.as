package game.goals
{
   import core.goal.Goal;
   import game.logic.Engine;
   import game.units.Unit;
   
   public class AttackGoal extends Goal
   {
      
      private var sitting_ticks:int = 0;
      
      protected var unit:Unit = null;
      
      protected var engine:Engine = null;
      
      private var ready_for_attack:Boolean = false;
      
      private var recharging_ticks:int = 0;
      
      protected var attack_target:Unit = null;
      
      public function AttackGoal(param1:Engine, param2:Unit)
      {
         super();
         engine = param1;
         unit = param2;
      }
      
      public function setTarget(param1:Unit) : void
      {
         unit.currentState = Unit.ATTACK;
         attack_target = param1;
      }
      
      protected function runBullet() : void
      {
         var _loc1_:BulletGoal = null;
         _loc1_ = new BulletGoal(engine,unit,attack_target);
         engine.goalSystem.add(_loc1_);
      }
      
      protected function hasAnotherTarget() : Boolean
      {
         unit.currentState = Unit.WALKING;
         unit.life.enemyDetector.advance();
         if(Unit.ATTACK == unit.currentState)
         {
            return true;
         }
         unit.currentState = Unit.ATTACK;
         return false;
      }
   }
}

