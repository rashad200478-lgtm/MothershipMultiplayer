package core
{
   import core.goal.GoalSystem;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class ProcessManager
   {
      
      private static var _instance:ProcessManager = null;
      
      public static const TICKS_PER_SECOND:int = 30;
      
      public static const TICK_RATE:Number = 1 / TICKS_PER_SECOND;
      
      public static const TICK_RATE_MS:Number = 1000 / TICKS_PER_SECOND;
      
      public static const MAX_TICKS_PER_FRAME:int = 10;
      
      private var _started:Boolean = false;
      
      private var _schedule_events:Array = new Array();
      
      private var _elapsed:Number = 0;
      
      private var _last_time:Number = -1;
      
      private var _goal_system:GoalSystem = null;
      
      private var _ticked_objects:Array = new Array();
      
      private var _time_scale:Number = 1;
      
      public function ProcessManager()
      {
         super();
      }
      
      public static function get goalSystem() : GoalSystem
      {
         return instance._goal_system;
      }
      
      public static function get instance() : ProcessManager
      {
         if(null == _instance)
         {
            _instance = new ProcessManager();
         }
         return _instance;
      }
      
      private function _advance(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ScheduleObject = null;
         var _loc5_:ProcessObject = null;
         _elapsed += param1;
         _loc2_ = 0;
         while(_loc2_ < _schedule_events.length)
         {
            _loc4_ = _schedule_events[_loc2_];
            _loc4_.TimeRemaining -= param1;
            if(_loc4_.TimeRemaining <= 0)
            {
               _loc4_.Callback.apply(_loc4_.ThisObject,_loc4_.Arguments);
               _schedule_events.splice(_loc2_,1);
            }
            else
            {
               _loc2_++;
            }
         }
         _loc3_ = 0;
         while(_elapsed >= TICK_RATE_MS && _loc3_ < MAX_TICKS_PER_FRAME)
         {
            for each(_loc5_ in _ticked_objects)
            {
               _loc5_.Listener.advance();
            }
            _elapsed -= TICK_RATE_MS;
            _loc3_++;
         }
         if(_loc3_ >= MAX_TICKS_PER_FRAME)
         {
            _elapsed = 0;
         }
      }
      
      private function _addObject(param1:*, param2:Number, param3:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ProcessObject = null;
         if(!_started)
         {
            start();
         }
         _loc4_ = -1;
         _loc5_ = 0;
         while(_loc5_ < param3.length)
         {
            if(param3[_loc5_].Listener == param1)
            {
               return;
            }
            if(param3[_loc5_].Priority < param2)
            {
               _loc4_ = _loc5_;
               break;
            }
            _loc5_++;
         }
         _loc6_ = new ProcessObject();
         _loc6_.Listener = param1;
         _loc6_.Priority = param2;
         if(_loc4_ < 0 || _loc4_ >= param3.length)
         {
            param3.push(_loc6_);
         }
         else
         {
            param3.splice(_loc4_,0,_loc6_);
         }
      }
      
      public function stop() : void
      {
         if(!_started)
         {
            return;
         }
         removeTickedObject(_goal_system);
         _started = false;
         Global.mainStage.removeEventListener(Event.ENTER_FRAME,_onEnterFrame);
      }
      
      private function _onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc2_ = getTimer();
         if(_last_time < 0)
         {
            _last_time = _loc2_;
            return;
         }
         _loc3_ = (_loc2_ - _last_time) * _time_scale;
         _advance(_loc3_);
         _last_time = _loc2_;
      }
      
      public function schedule(param1:Number, param2:Object, param3:Function, ... rest) : void
      {
         var _loc5_:ScheduleObject = null;
         if(!_started)
         {
            start();
         }
         _loc5_ = new ScheduleObject();
         _loc5_.TimeRemaining = param1;
         _loc5_.ThisObject = param2;
         _loc5_.Callback = param3;
         _loc5_.Arguments = rest;
         _schedule_events.push(_loc5_);
      }
      
      private function _removeObject(param1:*, param2:Array) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_].Listener == param1)
            {
               param2.splice(_loc3_,1);
               return;
            }
            _loc3_++;
         }
      }
      
      public function addTickedObject(param1:*, param2:Number = 0) : void
      {
         _addObject(param1,param2,_ticked_objects);
      }
      
      public function start() : void
      {
         if(_started)
         {
            return;
         }
         _last_time = -1;
         _elapsed = 0;
         Global.mainStage.addEventListener(Event.ENTER_FRAME,_onEnterFrame);
         _started = true;
         if(!_goal_system)
         {
            _goal_system = new GoalSystem();
         }
         addTickedObject(_goal_system);
      }
      
      public function get tickedObjectCount() : int
      {
         return _ticked_objects.length;
      }
      
      public function get isRunning() : Boolean
      {
         return _started;
      }
      
      public function set timeScale(param1:Number) : void
      {
         _time_scale = param1;
      }
      
      public function get timeScale() : Number
      {
         return _time_scale;
      }
      
      public function removeTickedObject(param1:*) : void
      {
         _removeObject(param1,_ticked_objects);
      }
   }
}

class ScheduleObject
{
   
   public var Callback:Function = null;
   
   public var TimeRemaining:Number = 0;
   
   public var Arguments:Array = null;
   
   public var ThisObject:Object = null;
   
   public function ScheduleObject()
   {
      super();
   }
}

class ProcessObject
{
   
   public var Priority:Number = 0;
   
   public var Listener:* = null;
   
   public function ProcessObject()
   {
      super();
   }
}
