package game.ui
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import game.logic.Engine;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol631")]
   public class FinalClip extends MovieClip
   {
      
      private var engine:Engine = null;
      
      public function FinalClip(param1:Engine = null)
      {
         super();
         if(param1)
         {
            this.addEventListener(MouseEvent.MOUSE_DOWN,hereClickHandler);
         }
      }
      
      public function destroy() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_DOWN,hereClickHandler);
      }
      
      public function hereClickHandler(param1:MouseEvent) : void
      {
         if(this.parent)
         {
            this.removeEventListener(MouseEvent.MOUSE_DOWN,hereClickHandler);
            this.parent.removeChild(this);
         }
      }
      
      private function pandaClickHandler(param1:MouseEvent) : void
      {
      }
   }
}

