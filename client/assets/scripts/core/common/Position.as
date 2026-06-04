package core.common
{
   public final class Position
   {
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public function Position(param1:Number = 0, param2:Number = 0)
      {
         super();
         set(param1,param2);
      }
      
      public function copy(param1:Position) : void
      {
         x = param1.x;
         y = param1.y;
      }
      
      public function set(param1:Number, param2:Number) : void
      {
         x = param1;
         y = param2;
      }
      
      public function isEqualXY(param1:Number, param2:Number) : Boolean
      {
         return x == param1 && y == param2;
      }
      
      public function isEqual(param1:Position) : Boolean
      {
         return x == param1.x && y == param1.y;
      }
   }
}

