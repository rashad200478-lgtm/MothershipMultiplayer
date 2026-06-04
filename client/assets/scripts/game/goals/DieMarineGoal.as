package game.goals
{
   import core.goal.*;
   import game.*;
   import game.logic.*;
   import game.units.*;
   
   public class DieMarineGoal extends Goal
   {
      
      public static const LEAVE_TICKS:int = 1700;
      
      public static const DISAPPEAR_TICKS:int = 40;
      
      public static const BLOOD_TICKS:int = 320;
      
      public static const FINAL_TICKS:int = 90;
      
      public static const DEATH_BY_BULLET:String = "bullet";
      
      public static const DEATH_BY_EXPLOSION:String = "explosion";
      
      private var unit:Unit = null;
      
      private var leave_ticks:int = 0;
      
      private var engine:Engine = null;
      
      private var final_ticks:int = 0;
      
      private var blood_ticks:int = 0;
      
      private var disappear_ticks:int = 0;
      
      public function DieMarineGoal(param1:Engine, param2:Unit, param3:String)
      {
         super();
         unit = param2;
         engine = param1;
         unit.destroy();
         unit.currentState = Unit.DYING;
         leave_ticks = LEAVE_TICKS;
         disappear_ticks = DISAPPEAR_TICKS;
         blood_ticks = BLOOD_TICKS;
         final_ticks = FINAL_TICKS;
         if(param3 == DEATH_BY_EXPLOSION)
         {
            unit.sprite.gotoAndStop("death_by_explosion");
            engine.playSound(SoundConsts.marine_death_expl);
         }
         else
         {
            unit.sprite.gotoAndStop("death_by_bullet");
            engine.playSound(SoundConsts.marine_death);
         }
         unit.moveSpriteToBackLayer();
         unit.life.deactivate();
      }
      
      override public function advance() : void
      {
         if(leave_ticks > 0)
         {
            --leave_ticks;
            if(0 == leave_ticks)
            {
               unit.sprite.inner.gotoAndPlay("disappearing");
            }
            return;
         }
         if(disappear_ticks > 0)
         {
            --disappear_ticks;
            return;
         }
         if(blood_ticks > 0)
         {
            --blood_ticks;
            return;
         }
         if(final_ticks > 0)
         {
            --final_ticks;
            unit.sprite.alpha = final_ticks / FINAL_TICKS;
            return;
         }
         deactivate();
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         engine.gameBoard.wipeUnit(unit);
      }
   }
}

