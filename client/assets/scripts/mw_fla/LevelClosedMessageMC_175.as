package mw_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol737")]
   public dynamic class LevelClosedMessageMC_175 extends MovieClip
   {
      
      public var msg:TextField;
      
      public function LevelClosedMessageMC_175()
      {
         super();
         addFrameScript(0,frame1,69,frame70);
      }
      
      internal function frame70() : *
      {
         visible = false;
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

