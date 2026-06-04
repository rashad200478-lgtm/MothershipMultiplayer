package game.goals
{
   import core.common.*;
   import core.goal.*;
   import game.*;
   import game.logic.*;
   import game.units.*;
   
   public class EnemyDetectorGoal extends Goal
   {
      
      private var check_back_units:Boolean = false;
      
      private var engine:Engine = null;
      
      private var owner:Unit = null;
      
      private var enemy_camp:UnitCamp = null;
      
      public function EnemyDetectorGoal(param1:Engine, param2:Unit)
      {
         super();
         owner = param2;
         engine = param1;
         enemy_camp = param2.enemy_unit ? engine.gameBoard.allyUnits : engine.gameBoard.enemyUnits;
      }
      
      public function checkBackUnits(param1:Boolean) : void
      {
         check_back_units = param1;
      }
      
      override public function advance() : void
      {
         var _loc1_:Unit = null;
         if(Unit.WALKING != owner.currentState)
         {
            return;
         }
         if(null != owner.life.getCurrentRoad())
         {
            _loc1_ = null;
            if(check_back_units)
            {
               _loc1_ = enemy_camp.getNearestUnit(owner.life.getCurrentRoad(),new Position(owner.sprite.x,owner.sprite.y),owner.weapon.eyerange);
            }
            else
            {
               _loc1_ = enemy_camp.getNearestForwardUnit(owner.life.getCurrentRoad(),owner,owner.weapon.eyerange);
            }
            if(_loc1_ != null)
            {
               owner.life.startAttack(_loc1_);
            }
         }
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
      }
   }
}

