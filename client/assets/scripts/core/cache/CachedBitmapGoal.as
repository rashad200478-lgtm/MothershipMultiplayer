package core.cache
{
   import core.Global;
   import core.goal.IGoal;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   
   public class CachedBitmapGoal extends Bitmap implements IGoal
   {
      
      private var _assigned_routines:Array = [];
      
      private var _stop_at_end:Boolean = false;
      
      private var _do_update:Boolean = true;
      
      private var _active:Boolean = true;
      
      private var _clip_position:Point = null;
      
      private var _frame_number:int = 0;
      
      private var _frames:Array = null;
      
      private var _clone:Boolean = false;
      
      public function CachedBitmapGoal(param1:Array, param2:Point, param3:Boolean)
      {
         super();
         _frames = param1;
         _clone = param3;
         _clip_position = param2.clone();
         if(_frames.length > 0)
         {
            update();
            _assigned_routines.length = _frames.length;
         }
         else
         {
            deactivate();
         }
      }
      
      public static function draw(param1:CachedMovieClip, param2:Point, param3:DisplayObjectContainer, param4:Boolean = true) : CachedBitmapGoal
      {
         var _loc5_:CachedBitmapGoal = null;
         _loc5_ = new CachedBitmapGoal(param1.cachedFrames,param2,param4);
         param3.addChild(_loc5_);
         Global.top.engine.goalSystem.add(_loc5_);
         return _loc5_;
      }
      
      public function assignRoutine(param1:int, param2:Function) : void
      {
         _assigned_routines[param1] = param2;
      }
      
      public function clearAssignedRoutines() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _assigned_routines.length)
         {
            _assigned_routines[_loc1_] = null;
            _loc1_++;
         }
      }
      
      public function advance() : void
      {
         if(!_do_update)
         {
            return;
         }
         update();
         if(_assigned_routines[_frame_number] != null)
         {
            _assigned_routines[_frame_number](_clip_position);
         }
         ++_frame_number;
         if(_frame_number >= _frames.length)
         {
            if(!_stop_at_end)
            {
               deactivate();
            }
            else
            {
               _do_update = false;
            }
         }
      }
      
      public function setStopAtEnd(param1:Boolean = true) : void
      {
         _stop_at_end = param1;
      }
      
      private function update() : void
      {
         var _loc1_:BitmapData = null;
         x = _clip_position.x - _frames[_frame_number].offset_x;
         y = _clip_position.y - _frames[_frame_number].offset_y;
         _loc1_ = null;
         if(_clone)
         {
            _loc1_ = _frames[_frame_number].bitmap_data.clone();
         }
         else
         {
            _loc1_ = _frames[_frame_number].bitmap_data;
         }
         bitmapData = _loc1_;
      }
      
      public function deactivate() : void
      {
         _active = false;
         if(_frames)
         {
            _frames = null;
            if(this.parent)
            {
               this.parent.removeChild(this);
            }
            if(_clone)
            {
               bitmapData.dispose();
            }
         }
      }
      
      public function get alive() : Boolean
      {
         return _active;
      }
   }
}

