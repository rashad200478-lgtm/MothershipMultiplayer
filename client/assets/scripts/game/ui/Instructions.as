package game.ui
{
   import core.Global;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import game.SoundConsts;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol751")]
   public class Instructions extends MovieClip
   {
      
      public var options_button:SimpleButton;
      
      public var resume_button:SimpleButton;
      
      public var start_game_button:SimpleButton;
      
      public function Instructions()
      {
         super();
         start_game_button.addEventListener(MouseEvent.MOUSE_DOWN,startButtonHandler);
         resume_button.addEventListener(MouseEvent.MOUSE_DOWN,resumeButtonHandler);
         options_button.addEventListener(MouseEvent.MOUSE_DOWN,optionsButtonHandler);
         resume_button.tabEnabled = false;
         options_button.tabEnabled = false;
         start_game_button.tabEnabled = false;
         resume_button.visible = false;
         options_button.visible = false;
      }
      
      private function startButtonHandler(param1:MouseEvent) : void
      {
         visible = false;
         Global.top.startGameHandler(null);
         param1.stopPropagation();
      }
      
      private function resumeButtonHandler(param1:MouseEvent) : void
      {
         visible = false;
         Global.top.resumeGameHandler(null);
      }
      
      private function nextButtonHandler(param1:MouseEvent) : void
      {
         Global.top.engine.playSound(SoundConsts.click);
         visible = false;
      }
      
      private function optionsButtonHandler(param1:MouseEvent) : void
      {
         visible = false;
         Global.top.optionsHandler(null);
      }
      
      public function show() : void
      {
         visible = true;
         if(Global.top.engine.playWindowUI != null)
         {
            start_game_button.visible = false;
            resume_button.visible = true;
            options_button.visible = true;
         }
         else
         {
            start_game_button.visible = true;
            resume_button.visible = false;
            options_button.visible = false;
         }
      }
   }
}

