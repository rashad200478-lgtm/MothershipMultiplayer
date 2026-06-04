package game.goals
{
   import core.cache.CachedBitmapGoal;
   import core.goal.*;
   import flash.geom.Point;
   import game.*;
   import game.logic.*;
   import game.units.*;
   
   public class DieExplodeGoal extends Goal
   {
      
      public static const FINAL_TICKS:int = 50;
      
      private var unit:Unit = null;
      
      private var final_ticks:int = 0;
      
      private var engine:Engine = null;
      
      private var _clip:* = null;
      
      public function DieExplodeGoal(param1:Engine, param2:Unit)
      {
         super();
         unit = param2;
         engine = param1;
         unit.destroy();
         unit.currentState = Unit.DYING;
         final_ticks = FINAL_TICKS;
         if(StringConsts.MINER_DROID == unit.type)
         {
            _clip = EffectFactory.makeDeath(EffectFactory.MINER_EXPLOSION,new Point(unit.sprite.x - 7.3,unit.sprite.y - 15.2),1,1,unit.sprite.parent);
            engine.gameBoard.wipeUnit(unit);
            engine.playSound(SoundConsts.victory);
         }
         else
         {
            unit.sprite.gotoAndStop("death");
            _clip = unit.sprite;
         }
         unit.life.deactivate();
      }
      
      override public function advance() : void
      {
         if(final_ticks > 0)
         {
            --final_ticks;
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

