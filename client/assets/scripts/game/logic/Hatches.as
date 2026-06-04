package game.logic
{
   import flash.display.MovieClip;
   
   public class Hatches
   {
      
      public static const ROAD_NUMBER:int = 5;
      
      private var _arrows:MovieClip = null;
      
      private var _road_index:int = 0;
      
      public function Hatches(param1:*)
      {
         super();
         _arrows = param1;
      }
      
      private function updateArrow() : void
      {
         _arrows.gotoAndStop(1 + _road_index);
      }
      
      public function get roadIndex() : int
      {
         return _road_index;
      }
      
      public function moveUp() : void
      {
         ++_road_index;
         if(_road_index >= ROAD_NUMBER)
         {
            _road_index = 0;
         }
         updateArrow();
      }
      
      public function setIndex(param1:int) : void
      {
         _road_index = param1;
         if(_road_index < 0)
         {
            _road_index = ROAD_NUMBER - 1;
         }
         if(_road_index >= ROAD_NUMBER)
         {
            _road_index = 0;
         }
         updateArrow();
      }
      
      public function moveDown() : void
      {
         --_road_index;
         if(_road_index < 0)
         {
            _road_index = ROAD_NUMBER - 1;
         }
         updateArrow();
      }
   }
}

