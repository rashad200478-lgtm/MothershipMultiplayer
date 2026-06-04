package
{
   import flash.display.MovieClip;
   import game.logic.EffectFactory;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol935")]
   public dynamic class StormTankImpact extends MovieClip
   {
      
      public function StormTankImpact()
      {
         super();
         addFrameScript(35,frame36);
      }
      
      internal function frame36() : *
      {
         stop();
         EffectFactory.effectFinished(this);
      }
   }
}

