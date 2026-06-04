package
{
   import game.logic.EffectFactory;
   import game.ui.Effect;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol355")]
   public dynamic class HatchExplosion extends Effect
   {
      
      public function HatchExplosion()
      {
         super();
         addFrameScript(15,frame16);
      }
      
      internal function frame16() : *
      {
         stop();
         EffectFactory.effectFinished(this);
      }
   }
}

