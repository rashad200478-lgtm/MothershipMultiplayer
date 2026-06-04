package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1127")]
   public dynamic class RedMissileMan extends MovieClip
   {
      
      public var hit_point:RoadPoint;
      
      public var shot_point:RoadPoint;
      
      public var inner:MovieClip;
      
      public function RedMissileMan()
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

