package game.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import game.logic.Engine;
   import game.ui.controls.SpriteBar;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol758")]
   public class BalanceBar extends SpriteBar
   {
      
      private static const LEFT_POINT:Number = 0;
      
      private static const RIGHT_POINT:Number = 1;
      
      public var title_txt:TextField;
      
      private var range:Number = 0;
      
      private var chunk:Number = 0;
      
      public var grand_storm_bar:MovieClip;
      
      private var engine:Engine = null;
      
      private var _balance:Number = 0;
      
      public function BalanceBar()
      {
         super();
      }
      
      override public function resume() : void
      {
         super.resume();
         grandStormBar.resume();
      }
      
      public function setTitle(param1:String) : void
      {
         title_txt.text = param1;
      }
      
      public function get balance() : Number
      {
         return _balance;
      }
      
      public function addHealth(param1:Number) : void
      {
         if(_balance + param1 * chunk >= 1)
         {
            _balance = 1;
         }
         else
         {
            _balance += param1 * chunk;
         }
         update();
      }
      
      public function isFartherOfCenter() : Boolean
      {
         return _balance > (RIGHT_POINT - LEFT_POINT) / 2;
      }
      
      public function initialize(param1:Number) : void
      {
         chunk = (RIGHT_POINT - LEFT_POINT) / param1;
         _balance = (RIGHT_POINT - LEFT_POINT) / 2;
         setProgress(_balance);
      }
      
      public function get isLeftPointReached() : Boolean
      {
         return _balance <= LEFT_POINT;
      }
      
      public function subHealth(param1:Number) : void
      {
         if(_balance - param1 * chunk <= 0)
         {
            _balance = 0;
         }
         else
         {
            _balance -= param1 * chunk;
         }
         update();
      }
      
      private function update() : void
      {
         setProgressEasing(_balance);
      }
      
      public function get grandStormBar() : SpriteBar
      {
         return grand_storm_bar as SpriteBar;
      }
      
      public function get isRightPointReached() : Boolean
      {
         return _balance >= RIGHT_POINT;
      }
      
      override public function pause() : void
      {
         super.pause();
         grandStormBar.pause();
      }
   }
}

