package game.goals
{
   import core.common.Position;
   import core.goal.Goal;
   import flash.geom.*;
   import game.*;
   import game.logic.*;
   import game.ui.*;
   import game.units.*;
   
   public class MoveSimpleGoal extends Goal
   {
      
      private var end_steps:int = 0;
      
      private var unit:Unit = null;
      
      private var engine:Engine = null;
      
      private var max_steps:Number = 0;
      
      private var dx:Number = 0;
      
      private var dy:Number = 0;
      
      private var target:Position = null;
      
      private var initial:Position = null;
      
      private var steps:Number = 0;
      
      public function MoveSimpleGoal(param1:Engine, param2:Unit)
      {
         super();
         engine = param1;
         unit = param2;
      }
      
      override public function advance() : void
      {
         if(steps < 1)
         {
            unit.sprite.x = target.x;
            unit.sprite.y = target.y;
            steps = 0;
         }
         else
         {
            ++end_steps;
            unit.sprite.x = initial.x + dx * end_steps;
            unit.sprite.y = initial.y + dy * end_steps;
            --steps;
         }
         if(steps <= 0)
         {
            deactivate();
         }
      }
      
      public function moveOn(param1:Number) : void
      {
         end_steps = max_steps * param1;
         steps = max_steps - end_steps;
         unit.sprite.x = initial.x + dx * end_steps;
         unit.sprite.y = initial.y + dy * end_steps;
      }
      
      public function moveTo(param1:Position) : void
      {
         moveToXY(param1.x,param1.y);
      }
      
      public function moveToXY(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         target = new Position(param1,param2);
         initial = new Position(unit.sprite.x,unit.sprite.y);
         _loc3_ = target.x - unit.sprite.x;
         _loc4_ = target.y - unit.sprite.y;
         max_steps = steps = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_) / unit.velocity;
         dx = _loc3_ / steps;
         dy = _loc4_ / steps;
         end_steps = 0;
      }
      
      public function resetParams() : void
      {
         moveToXY(target.x,target.y);
      }
   }
}

