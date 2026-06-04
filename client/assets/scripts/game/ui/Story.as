package game.ui
{
   import core.Global;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import game.SoundConsts;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol904")]
   public class Story extends MovieClip
   {
      
      public var next_button:SimpleButton;
      
      private var _shown:Boolean = false;
      
      public function Story()
      {
         super();
         addFrameScript(224,frame225);
         next_button.tabEnabled = false;
         next_button.addEventListener(MouseEvent.MOUSE_DOWN,nextButtonHandler);
      }
      
      public function get shown() : Boolean
      {
         return _shown;
      }
      
      internal function frame225() : *
      {
         stop();
      }
      
      private function nextButtonHandler(param1:MouseEvent) : void
      {
         next_button.removeEventListener(MouseEvent.MOUSE_DOWN,nextButtonHandler);
         Global.top.story = null;
         this.parent.removeChild(this);
         Global.top.engine.playSound(SoundConsts.click);
         Global.top.instructions.show();
      }
      
      public function show() : void
      {
         visible = true;
         _shown = true;
         gotoAndPlay(1);
      }
   }
}

