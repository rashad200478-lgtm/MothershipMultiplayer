package game.goals
{
   import game.*;
   import game.logic.*;
   import game.ui.*;
   import game.units.*;
   
   public class AttackMarineGoal extends AttackGoal
   {
      
      private var sitting_ticks:int = 0;
      
      private var ready_for_attack:Boolean = false;
      
      private var recharging_ticks:int = 0;
      
      protected var attack_finish_ticks:int = 0;
      
      public function AttackMarineGoal(param1:Engine, param2:Unit)
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
         if(!ready_for_attack)
         {
            if(sitting_ticks > 0)
            {
               --sitting_ticks;
               if(0 != sitting_ticks)
               {
                  return;
               }
               ready_for_attack = true;
            }
         }
         else
         {
            doAttack();
            recharging_ticks = unit.weapon.recharge_time;
         }
      }
      
      override public function setTarget(param1:Unit) : void
      {
         super.setTarget(param1);
         if(unit.sitting_ticks > 0)
         {
            if(!ready_for_attack && sitting_ticks == 0)
            {
               sitting_ticks = unit.sitting_ticks;
               unit.sprite.gotoAndStop("attack");
            }
         }
         else
         {
            if(!ready_for_attack)
            {
               unit.sprite.gotoAndStop("attack");
            }
            ready_for_attack = true;
         }
      }
      
      private function doAttack() : void
      {
         if(unit.sitting_ticks > 0)
         {
            if(!unit.sprite.inner.shooting_inner)
            {
               return;
            }
            unit.sprite.inner.shooting_inner.gotoAndPlay("shot");
            attack_finish_ticks = unit.sprite.inner.totalFrames - 1;
         }
         else
         {
            unit.sprite.inner.gotoAndPlay("shot");
            attack_finish_ticks = unit.sprite.inner.totalFrames - 1;
         }
         runBullet();
      }
      
      private function stopAttack() : void
      {
         unit.currentState = Unit.WALKING;
         unit.sprite.gotoAndStop("walking");
         ready_for_attack = false;
         sitting_ticks = 0;
         attack_target = null;
      }
   }
}

