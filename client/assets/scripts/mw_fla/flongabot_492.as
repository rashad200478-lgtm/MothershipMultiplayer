package mw_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1252")]
   public dynamic class flongabot_492 extends MovieClip
   {
      
      public var fbHead:MovieClip;
      
      public function flongabot_492()
      {
         super();
         addFrameScript(0,frame1,75,frame76,88,frame89,99,frame100);
      }
      
      public function doEndFly() : *
      {
         this.gotoAndPlay("flying_end");
      }
      
      internal function frame76() : *
      {
         gotoAndPlay("normal");
      }
      
      internal function frame89() : *
      {
         gotoAndPlay("flying");
      }
      
      public function doNormal() : *
      {
         this.gotoAndPlay("normal");
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame100() : *
      {
         gotoAndPlay("normal");
      }
      
      public function doTurnhead() : *
      {
         this.fbHead.gotoAndPlay("turnhead");
      }
      
      public function doNormalHead() : *
      {
         this.fbHead.gotoAndPlay("normal");
      }
      
      public function doWink() : *
      {
         this.fbHead.gotoAndPlay("wink_start");
      }
      
      public function doFly() : *
      {
         this.gotoAndPlay("flying_start");
      }
   }
}

