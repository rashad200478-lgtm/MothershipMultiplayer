package
{
   import game.ui.Vulture;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1136")]
   public dynamic class RedVulture extends Vulture
   {
      
      public function RedVulture()
      {
         super();
         addFrameScript(40,frame41,68,frame69,141,frame142);
      }
      
      internal function frame41() : *
      {
         inner.gotoAndPlay("landing");
      }
      
      internal function frame142() : *
      {
         stop();
         tripFinished();
      }
      
      internal function frame69() : *
      {
         stop();
         vehicleLanded();
      }
   }
}

