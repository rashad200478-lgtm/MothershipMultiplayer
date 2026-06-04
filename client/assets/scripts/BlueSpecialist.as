package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1173")]
   public dynamic class BlueSpecialist extends MovieClip
   {
      
      public var hit_point:RoadPoint;
      
      public var shot_point:RoadPoint;
      
      public var inner:MovieClip;
      
      public function BlueSpecialist()
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

