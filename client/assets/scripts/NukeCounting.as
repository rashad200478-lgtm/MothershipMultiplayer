package
{
   import flash.display.MovieClip;
   import game.logic.EffectFactory;
   import game.logic.EffectRoutines;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol384")]
   public dynamic class NukeCounting extends MovieClip
   {
      
      public function NukeCounting()
      {
         super();
         addFrameScript(139,frame140);
      }
      
      internal function frame140() : *
      {
         stop();
         EffectRoutines.doNuke();
         EffectFactory.effectFinished(this);
      }
   }
}

