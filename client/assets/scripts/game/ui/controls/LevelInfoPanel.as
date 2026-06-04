package game.ui.controls
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol41")]
   public class LevelInfoPanel extends MovieClip
   {
      
      public var resume_game_button:SimpleButton;
      
      public var title:TextField;
      
      public var desc:TextField;
      
      public var days_txt:TextField;
      
      public var play_button:SimpleButton;
      
      public var goal_amount_txt:TextField;
      
      public function LevelInfoPanel()
      {
         super();
      }
      
      public function showLevelInfo(param1:*) : void
      {
         if(!param1)
         {
         }
      }
   }
}

