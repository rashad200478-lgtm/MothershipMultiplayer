package game.goals
{
   import core.goal.Goal;
   import game.*;
   import game.logic.*;
   import game.ui.*;
   import game.units.*;
   
   public class RoadViceVersaMoverGoal extends Goal
   {
      
      private var unit:Unit = null;
      
      private var engine:Engine = null;
      
      private var node:RoadPoint = null;
      
      private var road:RoadPath = null;
      
      private var road_enum:RoadGraph = null;
      
      private var simple_move:MoveSimpleGoal = null;
      
      public function RoadViceVersaMoverGoal(param1:Engine, param2:Unit, param3:RoadPath)
      {
         super();
         engine = param1;
         unit = param2;
         road = param3;
         gotoPrev();
      }
      
      override public function advance() : void
      {
         if(unit.currentState != Unit.WALKING)
         {
            return;
         }
         if(simple_move)
         {
            simple_move.advance();
            if(!simple_move.alive)
            {
               simple_move = null;
               gotoPrev();
            }
         }
      }
      
      public function reset() : void
      {
         if(simple_move)
         {
            simple_move.deactivate();
            simple_move = null;
         }
         gotoPrev();
         advance();
      }
      
      public function currentNode() : *
      {
         return node;
      }
      
      public function get simpleMoveGoal() : MoveSimpleGoal
      {
         return simple_move;
      }
      
      public function theRoad() : *
      {
         return road;
      }
      
      public function resetParams() : void
      {
         simple_move.resetParams();
      }
      
      public function gotoPrev() : void
      {
         var _loc1_:RoadPoint = null;
         if(!road_enum)
         {
            road_enum = new RoadGraph(road);
            _loc1_ = road_enum.getLast();
            unit.sprite.x = road.x + _loc1_.x;
            unit.sprite.y = road.y + _loc1_.y;
            if(unit.type == StringConsts.VULTURE)
            {
               unit.sprite.x += unit.sprite.width;
            }
         }
         node = road_enum.getPrev();
         if(node)
         {
            if(Boolean(simple_move) && simple_move.alive)
            {
               simple_move.deactivate();
               simple_move = null;
            }
            simple_move = new MoveSimpleGoal(engine,unit);
            simple_move.moveToXY(road.x + node.x,road.y + node.y);
         }
         else
         {
            engine.baseReached(unit,road);
            deactivate();
         }
      }
   }
}

