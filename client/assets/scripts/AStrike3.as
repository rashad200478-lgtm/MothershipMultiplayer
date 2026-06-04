package
{
   import flash.display.MovieClip;
   import game.logic.EffectFactory;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol318")]
   public dynamic class AStrike3 extends MovieClip
   {
      
      public function AStrike3()
      {
         super();
         addFrameScript(5,frame6,40,frame41);
      }
      
      internal function frame6() : *
      {
         EffectFactory.addCraterFrom(this);
      }
      
      internal function frame41() : *
      {
         stop();
         EffectFactory.effectFinished(this);
      }
   }
}

