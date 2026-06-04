package game.goals
{
   import core.Global;
   import core.goal.Goal;
   import flash.geom.Point;
   import game.SoundConsts;
   import game.logic.Engine;
   
   public class ForceFieldGoal extends Goal
   {
      
      private static const TICKS:int = 600;
      
      private var field_point:Point = null;
      
      private var _force_field:* = null;
      
      private var engine:Engine = null;
      
      private var _road_index:int = 0;
      
      private var ticks:int = TICKS;
      
      public function ForceFieldGoal(param1:Point, param2:int, param3:Boolean = false)
      {
         super();
         engine = Global.top.engine;
         field_point = param1.clone();
         _road_index = param2;
         if(param3)
         {
            _force_field = new RedForceField();
         }
         else
         {
            _force_field = new ForceField();
         }
         _force_field.x = field_point.x;
         _force_field.y = field_point.y;
         _force_field.scaleX = 1.25;
         engine.levelMap.force_field_mask_layer.addChild(_force_field);
         engine.gameBoard.forceFields[param2][0] += 1;
         engine.gameBoard.forceFields[param2][1].push(this);
         engine.playSound(SoundConsts.stun);
      }
      
      override public function advance() : void
      {
         if(ticks > 0)
         {
            --ticks;
            return;
         }
         deactivate();
      }
      
      override public function deactivate() : void
      {
         if(!_force_field)
         {
            return;
         }
         engine.gameBoard.forceFields[_road_index][0] = engine.gameBoard.forceFields[_road_index][0] - 1;
         engine.gameBoard.forceFields[_road_index][1].remove(this);
         engine.levelMap.force_field_mask_layer.removeChild(_force_field);
         _force_field = null;
      }
      
      public function get forceField() : *
      {
         return _force_field;
      }
   }
}

