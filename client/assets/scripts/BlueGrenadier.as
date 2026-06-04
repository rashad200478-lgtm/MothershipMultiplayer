package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol952")]
   public dynamic class BlueGrenadier extends MovieClip
   {
      
      public var hit_point:RoadPoint;
      
      public var inner:MovieClip;
      
      public function BlueGrenadier()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

