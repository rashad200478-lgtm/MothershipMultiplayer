package game.goals
{
   import core.Global;
   import core.goal.Goal;
   import flash.display.MovieClip;
   
   public class ButtonTicksGoal extends Goal
   {
      
      private var _paused:Boolean = false;
      
      private var _show_messages:Boolean = false;
      
      private var _type:String;
      
      private var _ready:Boolean = false;
      
      private var _tick_time:int = 0;
      
      private var _button_sprite:MovieClip = null;
      
      private var _ticks:int = 0;
      
      public function ButtonTicksGoal(param1:*, param2:String, param3:int, param4:Boolean = false)
      {
         super();
         _show_messages = param4;
         _button_sprite = param1;
         _type = param2;
         _tick_time = param3;
         _ready = true;
         hideFilling();
         setFilling(0);
      }
      
      override public function advance() : void
      {
         if(_ready || _paused)
         {
            return;
         }
         --_ticks;
         if(_ticks <= 0)
         {
            _ready = true;
            if(_show_messages)
            {
               Global.top.engine.playWindowUI.logMessage(_type + " is ready!");
            }
            hideFilling();
         }
         else
         {
            setFilling(1 - _ticks / _tick_time);
         }
      }
      
      private function showFilling() : void
      {
         _button_sprite.filling.visible = true;
      }
      
      private function hideFilling() : void
      {
         _button_sprite.filling.visible = false;
      }
      
      public function setReady() : void
      {
         if(!_ready)
         {
            _ticks = 0;
         }
      }
      
      public function get ready() : Boolean
      {
         return _ready;
      }
      
      public function reset() : void
      {
         _ticks = _tick_time;
         _ready = false;
         showFilling();
         setFilling(0);
      }
      
      public function get ticksRest() : int
      {
         return _ticks;
      }
      
      public function set paused(param1:Boolean) : void
      {
         _paused = param1;
      }
      
      public function get paused() : Boolean
      {
         return _paused;
      }
      
      private function setFilling(param1:Number) : void
      {
         _button_sprite.filling.gotoAndStop(int(param1 * 200));
      }
   }
}

