package
{
   import flash.display.MovieClip;
   import game.logic.EffectFactory;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol931")]
   public dynamic class SFImpact extends MovieClip
   {
      
      public function SFImpact()
      {
         super();
         addFrameScript(30,frame31);
      }
      
      internal function frame31() : *
      {
         stop();
         EffectFactory.effectFinished(this);
      }
   }
}

