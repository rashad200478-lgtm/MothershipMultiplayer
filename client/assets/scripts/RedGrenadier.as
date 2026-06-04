package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol954")]
   public dynamic class RedGrenadier extends MovieClip
   {
      
      public var hit_point:RoadPoint;
      
      public var inner:MovieClip;
      
      public function RedGrenadier()
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

