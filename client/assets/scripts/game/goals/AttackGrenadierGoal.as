package game.goals
{
   import game.logic.Engine;
   import game.units.Unit;
   
   public class AttackGrenadierGoal extends AttackRobotGoal
   {
      
      public function AttackGrenadierGoal(param1:Engine, param2:Unit)
      {
         super(param1,param2);
      }
      
      override public function setTarget(param1:Unit) : void
      {
         ready_for_attack = true;
         super.setTarget(param1);
         recharging_ticks = unit.weapon.recharge_time;
      }
      
      override protected function doAttack() : void
      {
         engine.gameBoard.killUnit(unit);
         deactivate();
      }
   }
}

