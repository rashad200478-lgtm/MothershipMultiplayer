package game.goals
{
   import core.common.Position;
   import core.goal.*;
   import flash.geom.Point;
   import game.*;
   import game.logic.*;
   import game.units.*;
   
   public class DieGrenadierGoal extends Goal
   {
      
      public static const FINAL_TICKS:int = 55;
      
      private var unit:Unit = null;
      
      private var final_ticks:int = 0;
      
      private var engine:Engine = null;
      
      public function DieGrenadierGoal(param1:Engine, param2:Unit)
      {
         super();
         unit = param2;
         engine = param1;
         unit.destroy();
         unit.currentState = Unit.DYING;
         final_ticks = FINAL_TICKS;
         if(StringConsts.GRENADIER_DROID == unit.type)
         {
            EffectFactory.makeExplosion(EffectFactory.GRENADIER_DEATH,new Point(unit.sprite.x,unit.sprite.y),0.4,unit.sprite.parent);
            engine.playSound(SoundConsts.explosion);
         }
         else
         {
            EffectFactory.makeExplosion(EffectFactory.MINE_EXPLOSION,new Point(unit.sprite.x,unit.sprite.y),0.2,unit.sprite.parent);
            engine.playSound(SoundConsts.victory);
         }
         engine.gameBoard.wipeUnit(unit);
         checkNearTargets();
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
      
      private function checkNearTargets() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Unit = null;
         _loc1_ = engine.gameBoard.allyUnits.getNearUnits(unit.life.getCurrentRoad(),new Position(unit.sprite.x,unit.sprite.y),unit.weapon.eyerange * 1.1);
         _loc2_ = engine.gameBoard.enemyUnits.getNearUnits(unit.life.getCurrentRoad(),new Position(unit.sprite.x,unit.sprite.y),unit.weapon.eyerange * 1.1);
         _loc2_ = _loc2_.concat(_loc1_);
         if(unit.type != StringConsts.MINE)
         {
            _loc4_ = engine.gameBoard.mines.getNearUnits(unit.life.getCurrentRoad(),new Position(unit.sprite.x,unit.sprite.y),unit.weapon.eyerange * 2);
            _loc2_ = _loc2_.concat(_loc4_);
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc3_];
            if(!_loc5_.coverForceField())
            {
               engine.hitUnit(unit.weapon.damage,_loc5_,DieMarineGoal.DEATH_BY_EXPLOSION);
            }
            _loc3_++;
         }
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         engine.gameBoard.wipeUnit(unit);
      }
   }
}

