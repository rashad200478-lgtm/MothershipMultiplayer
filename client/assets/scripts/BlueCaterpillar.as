package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol946")]
   public dynamic class BlueCaterpillar extends MovieClip
   {
      
      public var hit_point:RoadPoint;
      
      public var shot_point:RoadPoint;
      
      public var inner_shooting:MovieClip;
      
      public var inner:BlueCaterpillarMoving;
      
      public var innerd:BlueCaterpilarDeath;
      
      public function BlueCaterpillar()
      {
         super();
         addFrameScript(0,frame1,1,frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         inner_shooting.stop();
      }
   }
}

