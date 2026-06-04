package
{
   import game.logic.EffectFactory;
   import game.logic.EffectRoutines;
   import game.ui.Effect;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol371")]
   public dynamic class MineExplosion extends Effect
   {
      
      public function MineExplosion()
      {
         super();
         addFrameScript(2,frame3,36,frame37);
      }
      
      internal function frame3() : *
      {
         EffectRoutines.AddMineCrater(this);
      }
      
      internal function frame37() : *
      {
         stop();
         EffectFactory.effectFinished(this);
      }
   }
}

