package
{
   import flash.display.MovieClip;
   import game.logic.EffectFactory;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol909")]
   public dynamic class CaterpillarImpact extends MovieClip
   {
      
      public function CaterpillarImpact()
      {
         super();
         addFrameScript(45,frame46);
      }
      
      internal function frame46() : *
      {
         stop();
         EffectFactory.effectFinished(this);
      }
   }
}

