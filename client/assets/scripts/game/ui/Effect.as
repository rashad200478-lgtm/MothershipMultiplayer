package game.ui
{
   import flash.display.MovieClip;
   
   public class Effect extends MovieClip
   {
      
      private var parent_layer:* = null;
      
      public function Effect()
      {
         super();
      }
      
      public function set parentLayer(param1:*) : void
      {
         parent_layer = param1;
      }
      
      public function get parentLayer() : *
      {
         return parent_layer;
      }
   }
}

