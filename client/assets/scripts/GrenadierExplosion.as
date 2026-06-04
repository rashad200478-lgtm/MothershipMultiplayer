package
{
   import flash.display.MovieClip;
   import game.logic.EffectFactory;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol352")]
   public dynamic class GrenadierExplosion extends MovieClip
   {
      
      public function GrenadierExplosion()
      {
         super();
         addFrameScript(4,frame5,49,frame50);
      }
      
      internal function frame5() : *
      {
         EffectFactory.addCraterFrom(this,0.35,0.8);
      }
      
      internal function frame50() : *
      {
         stop();
         EffectFactory.effectFinished(this);
      }
   }
}

