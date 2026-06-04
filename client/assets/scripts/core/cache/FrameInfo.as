package core.cache
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class FrameInfo
   {
      
      public var bitmap_bounds:Rectangle = null;
      
      public var bitmap_data:BitmapData = null;
      
      public var offset_x:Number = 0;
      
      public var offset_y:Number = 0;
      
      public function FrameInfo(param1:BitmapData, param2:Rectangle)
      {
         super();
         bitmap_data = param1;
         bitmap_bounds = param2;
      }
   }
}

