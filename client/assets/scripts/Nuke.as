package
{
   import flash.display.MovieClip;
   import game.logic.EffectFactory;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol22")]
   public dynamic class Nuke extends MovieClip
   {
      
      public var c:Crater;
      
      public function Nuke()
      {
         super();
         addFrameScript(28,frame29,157,frame158);
      }
      
      internal function frame158() : *
      {
         stop();
         EffectFactory.effectFinished(this);
      }
      
      internal function frame29() : *
      {
         c = EffectFactory.addCraterFrom(this,1.2,1.5);
         c.y -= 50;
      }
   }
}

