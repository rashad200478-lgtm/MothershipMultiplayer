package
{
   import flash.display.MovieClip;
   import game.logic.EffectFactory;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol922")]
   public dynamic class MMImpact extends MovieClip
   {
      
      public function MMImpact()
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

