package game.goals
{
   import core.ProcessManager;
   import game.*;
   import game.logic.*;
   import game.ui.*;
   import game.units.*;
   
   public class AttackCaterpillarGoal extends AttackGoal
   {
      
      private var inner_was:* = null;
      
      private var ready_ticks:int = 0;
      
      private var recharging_ticks:int = 0;
      
      private var ready_for_attack:Boolean = false;
      
      public function AttackCaterpillarGoal(param1:Engine, param2:Unit)
      {
         super(param1,param2);
      }
      
      override public function advance() : void
      {
         if(recharging_ticks > 0)
         {
            --recharging_ticks;
            return;
         }
         if(unit.currentState != Unit.ATTACK)
         {
            return;
         }
         if(StringConsts.WALKING == unit.sprite.currentLabel)
         {
            if(!unit.sprite.inner)
            {
               return;
            }
            if(!unit.sprite.inner.stopMoving)
            {
               unit.sprite.inner.stopMoving = true;
            }
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
            if(!unit.sprite.inner.currentlyStopped)
            {
               return;
            }
            ready_for_attack = true;
            unit.sprite.gotoAndStop("attack");
            recharging_ticks = 1 + ProcessManager.instance.timeScale;
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
      }
      
      private function doAttack() : void
      {
         if(unit.sprite.inner_shooting)
         {
            unit.sprite.inner_shooting.gotoAndPlay("shot");
         }
         runBullet();
      }
      
      private function stopAttack() : void
      {
         unit.currentState = Unit.WALKING;
         unit.sprite.gotoAndStop("walking");
         ready_for_attack = false;
         attack_target = null;
      }
      
      override protected function runBullet() : void
      {
         var _loc1_:LaserBeamGoal = null;
         attack_target.updateBar();
         _loc1_ = new LaserBeamGoal(engine,unit,attack_target,30);
         engine.goalSystem.add(_loc1_);
      }
   }
}

