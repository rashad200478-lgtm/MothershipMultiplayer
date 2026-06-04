package
{
   import flash.display.MovieClip;
   import game.logic.EffectFactory;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol919")]
   public dynamic class MarineBulletImpact extends MovieClip
   {
      
      public function MarineBulletImpact()
      {
         super();
         addFrameScript(19,frame20);
      }
      
      internal function frame20() : *
      {
         stop();
         EffectFactory.effectFinished(this);
      }
   }
}

