package
{
   import flash.display.MovieClip;
   import game.logic.EffectFactory;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol346")]
   public dynamic class GrandStormMessage extends MovieClip
   {
      
      public function GrandStormMessage()
      {
         super();
         addFrameScript(89,frame90);
      }
      
      internal function frame90() : *
      {
         stop();
         EffectFactory.effectFinished(this);
      }
   }
}

