package
{
   import game.ui.Vulture;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1131")]
   public dynamic class BlueVulture extends Vulture
   {
      
      public function BlueVulture()
      {
         super();
         addFrameScript(38,frame39,68,frame69,141,frame142);
      }
      
      internal function frame39() : *
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

