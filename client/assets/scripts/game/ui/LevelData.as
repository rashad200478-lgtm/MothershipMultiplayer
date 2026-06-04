package game.ui
{
   import flash.display.Sprite;
   
   public class LevelData extends Sprite
   {
      
      public var title:String;
      
      public var health:Number = 0;
      
      public var best_counteraction_likelihood:Number = 0;
      
      public var level_time:int = 0;
      
      public function LevelData()
      {
         super();
      }
   }
}

