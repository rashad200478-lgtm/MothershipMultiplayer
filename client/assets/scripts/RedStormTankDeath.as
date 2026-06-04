package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol404")]
   public dynamic class RedStormTankDeath extends MovieClip
   {
      
      public function RedStormTankDeath()
      {
         super();
         addFrameScript(18,frame19);
      }
      
      internal function frame19() : *
      {
         stop();
         cacheAsBitmap = true;
      }
   }
}

