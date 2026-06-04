package game.goals
{
   import core.ProcessManager;
   import game.*;
   import game.logic.*;
   import game.ui.*;
   import game.units.*;
   
   public class AttackRobotGoal extends AttackGoal
   {
      
      protected var ready_for_attack:Boolean = false;
      
      protected var recharging_ticks:int = 0;
      
      protected var attack_finish_ticks:int = 0;
      
      public function AttackRobotGoal(param1:Engine, param2:Unit)
      {
         super(param1,param2);
      }
      
      override public function advance() : void
      {
         if(attack_finish_ticks > 0)
         {
            --attack_finish_ticks;
            if(attack_finish_ticks == 0)
            {
               if(Boolean(attack_target) && false == attack_target.isAlive)
               {
                  if(!hasAnotherTarget())
                  {
                     stopAttack();
                  }
                  return;
               }
            }
         }
         if(recharging_ticks > 0)
         {
            --recharging_ticks;
            return;
         }
         if(unit.currentState != Unit.ATTACK)
         {
            return;
         }
         if(Boolean(attack_target) && false == attack_target.isAlive)
         {
            if(!hasAnotherTarget())
            {
               stopAttack();
            }
            return;
         }
         doAttack();
         recharging_ticks = unit.weapon.recharge_time;
      }
      
      override public function setTarget(param1:Unit) : void
      {
         super.setTarget(param1);
         if(!ready_for_attack)
         {
            unit.sprite.gotoAndStop("attack");
            recharging_ticks += 3 + ProcessManager.instance.timeScale;
         }
         ready_for_attack = true;
      }
      
      protected function doAttack() : void
      {
         if(unit.sprite.inner)
         {
            unit.sprite.inner.gotoAndPlay("shot");
            attack_finish_ticks = unit.sprite.inner.totalFrames - 1;
         }
         else
         {
            attack_finish_ticks = 10;
         }
         runBullet();
      }
      
      protected function stopAttack() : void
      {
         unit.currentState = Unit.WALKING;
         unit.sprite.gotoAndStop("walking");
         attack_target = null;
         ready_for_attack = false;
      }
   }
}

