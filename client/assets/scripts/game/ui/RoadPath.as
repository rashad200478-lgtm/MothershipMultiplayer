package game.ui
{
   import core.common.Map;
   import flash.display.*;
   
   public dynamic class RoadPath extends MovieClip
   {
      
      public var points:Map = null;
      
      private var road_index:int = 0;
      
      public function RoadPath()
      {
         super();
      }
      
      public function isBackDirection() : Boolean
      {
         return points.values[0].x - points.values[1].x > 0;
      }
      
      public function initialize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         points = new Map();
         _loc1_ = numChildren;
         _loc2_ = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_ is RoadPoint)
            {
               points.add(_loc3_.name,_loc3_);
            }
            _loc2_++;
         }
      }
      
      public function set index(param1:int) : void
      {
         road_index = param1;
      }
      
      public function lastNode() : RoadPoint
      {
         return points.values[points.size() - 1];
      }
      
      public function firstNode() : RoadPoint
      {
         return points.values[0];
      }
      
      public function get index() : int
      {
         return road_index;
      }
   }
}

