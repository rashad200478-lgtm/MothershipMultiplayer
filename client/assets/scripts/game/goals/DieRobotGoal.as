package game.goals
{
   import core.cache.CachedBitmapGoal;
   import core.goal.*;
   import flash.geom.Point;
   import game.*;
   import game.logic.*;
   import game.units.*;
   
   public class DieRobotGoal extends Goal
   {
      
      public static const LEAVE_TICKS:int = 1700;
      
      public static const FINAL_TICKS:int = 90;
      
      private var unit:Unit = null;
      
      private var final_ticks:int = 0;
      
      private var leave_ticks:int = 0;
      
      private var engine:Engine = null;
      
      private var _clip:* = null;
      
      public function DieRobotGoal(param1:Engine, param2:Unit)
      {
         super();
         unit = param2;
         engine = param1;
         unit.destroy();
         unit.currentState = Unit.DYING;
         leave_ticks = LEAVE_TICKS;
         final_ticks = FINAL_TICKS;
         unit.moveSpriteToBackLayer();
         if(StringConsts.CATERPILLAR == unit.type)
         {
            if(unit.isEnemy)
            {
               _clip = EffectFactory.makeDeath(EffectFactory.RED_CATERPILLAR_DEATH,new Point(unit.sprite.x - 3.5,unit.sprite.y - 8.9),98.4 / 655.7,34.2 / 228,unit.sprite.parent);
            }
            else
            {
               _clip = EffectFactory.makeDeath(EffectFactory.BLUE_CATERPILLAR_DEATH,new Point(unit.sprite.x - 2.5,unit.sprite.y - 8.8),-98.4 / 655.7,34.2 / 228,unit.sprite.parent);
            }
            engine.gameBoard.wipeUnit(unit);
            engine.playSound(SoundConsts.caterpillar_death);
         }
         else if(StringConsts.STORM_TANK == unit.type)
         {
            if(unit.isEnemy)
            {
               _clip = EffectFactory.makeDeath(EffectFactory.RED_STORM_TANK_DEATH,new Point(unit.sprite.x - 1.1,unit.sprite.y - 14.9),62.3 / 1308.2,19.5 / 409.9,unit.sprite.parent);
            }
            else
            {
               _clip = EffectFactory.makeDeath(EffectFactory.BLUE_STORM_TANK_DEATH,new Point(unit.sprite.x + 3.9,unit.sprite.y - 15.1),-62.1 / 1135.6,19.9 / 364.6,unit.sprite.parent);
            }
            engine.gameBoard.wipeUnit(unit);
            engine.playSound(SoundConsts.explosion);
         }
         else
         {
            unit.sprite.gotoAndStop("death");
            _clip = unit.sprite;
         }
         if(_clip is CachedBitmapGoal)
         {
            (_clip as CachedBitmapGoal).setStopAtEnd();
         }
         unit.life.deactivate();
      }
      
      override public function advance() : void
      {
         if(leave_ticks > 0)
         {
            --leave_ticks;
            return;
         }
         if(final_ticks > 0)
         {
            --final_ticks;
            _clip.alpha = final_ticks / FINAL_TICKS;
            return;
         }
         deactivate();
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         if(_clip is CachedBitmapGoal)
         {
            _clip.deactivate();
         }
         else
         {
            EffectFactory.effectFinished(_clip);
         }
         engine.gameBoard.wipeUnit(unit);
      }
   }
}

