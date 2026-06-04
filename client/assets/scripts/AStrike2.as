package
{
   import flash.display.MovieClip;
   import game.logic.EffectFactory;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol317")]
   public dynamic class AStrike2 extends MovieClip
   {
      
      public function AStrike2()
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

