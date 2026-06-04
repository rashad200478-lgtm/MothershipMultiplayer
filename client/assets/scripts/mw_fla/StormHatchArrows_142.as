package mw_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol612")]
   public dynamic class StormHatchArrows_142 extends MovieClip
   {
      
      public var hatch_arrow3:MovieClip;
      
      public var hatch_arrow5:MovieClip;
      
      public var hatch_arrow1:MovieClip;
      
      public var hatch_arrow4:MovieClip;
      
      public var hatch_arrow2:MovieClip;
      
      public function StormHatchArrows_142()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      internal function frame1() : *
      {
         stop();
         hatch_arrow1.gotoAndStop(1);
         hatch_arrow2.gotoAndStop(2);
         hatch_arrow3.gotoAndStop(3);
         hatch_arrow4.gotoAndStop(4);
         hatch_arrow5.gotoAndStop(5);
      }
   }
}

