package game.logic
{
   import core.Global;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import game.ui.RoadPath;
   
   public class SpecialTargeting
   {
      
      private static const MOTION_LENGTH:int = 50;
      
      private static const MOVE_CHUNK:int = 5;
      
      private var engine:Engine = null;
      
      private var _enabled:Boolean = false;
      
      private var target:* = null;
      
      private var _current_type:String;
      
      private var road_offsets:Array;
      
      private var _unit_card_icon:MovieClip = null;
      
      private var _target_offsets:Array;
      
      private var road_gap:Number = 0;
      
      private var _unit_send_action:Boolean = false;
      
      private var _y_offset:int = 0;
      
      public function SpecialTargeting()
      {
         var _loc1_:* = undefined;
         var _loc2_:Number = NaN;
         engine = null;
         _enabled = false;
         target = null;
         _unit_card_icon = null;
         _y_offset = 0;
         road_offsets = [];
         road_gap = 0;
         _target_offsets = [];
         _unit_send_action = false;
         super();
         engine = Global.top.engine;
         target = engine.gameBoard.specialTarget;
         _unit_card_icon = engine.gameBoard.unitCard;
         target.visible = false;
         _unit_card_icon.visible = false;
         _target_offsets = [[target.x + -295.1,target.x + 249.8],[target.x + -284.1,target.x + 243.8],[target.x + -265.1,target.x + 225.8],[target.x + -256.2,target.x + 215.8],[target.x + -241.1,target.x + 203.8]];
         for each(_loc1_ in engine.gameBoard.roadArray)
         {
            road_offsets.push(_loc1_.y + (_loc1_ as RoadPath).firstNode().y);
            _loc2_ = Math.abs(road_offsets[0] - road_offsets[1]);
            if(_loc2_ > road_gap)
            {
               road_gap = _loc2_;
            }
         }
      }
      
      public function enable(param1:String, param2:Boolean = false) : void
      {
         _enabled = true;
         _unit_send_action = param2;
         _current_type = param1;
         if(!_unit_send_action)
         {
            target.visible = true;
         }
         else
         {
            _unit_card_icon.visible = true;
            _unit_card_icon.gotoAndStop("blue_" + param1);
            _unit_card_icon.x = engine.levelMap.mouseX + _unit_card_icon.width + 1;
            _unit_card_icon.y = engine.levelMap.mouseY + _unit_card_icon.height + 1;
            _unit_card_icon.cacheAsBitmap = true;
            _unit_card_icon.startDrag();
         }
         _y_offset = 0;
         update();
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function get isUnitSendAction() : Boolean
      {
         return _unit_send_action;
      }
      
      public function moveLeft() : void
      {
         if(_y_offset - MOVE_CHUNK < 0)
         {
            _y_offset = 0;
         }
         else
         {
            _y_offset -= MOVE_CHUNK;
         }
         update();
      }
      
      public function moveRight() : void
      {
         if(_y_offset + MOVE_CHUNK > MOTION_LENGTH - 1)
         {
            _y_offset = MOTION_LENGTH - 1;
         }
         else
         {
            _y_offset += MOVE_CHUNK;
         }
         update();
      }
      
      private function roadOffset() : int
      {
         return 1 + engine.hatches.roadIndex * MOTION_LENGTH;
      }
      
      public function interpolatePoint(param1:Point) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc7_:Number = NaN;
         _loc2_ = 0;
         _loc3_ = -1;
         _loc4_ = 9999999;
         _loc2_ = 0;
         while(_loc2_ < road_offsets.length)
         {
            _loc5_ = Number(road_offsets[_loc2_]);
            if(Math.abs(_loc5_ - param1.y) < _loc4_)
            {
               _loc4_ = Math.abs(_loc5_ - param1.y);
               _loc3_ = _loc2_;
            }
            _loc2_++;
         }
         engine.hatches.setIndex(_loc3_);
         if(!_unit_send_action)
         {
            _loc6_ = _target_offsets[_loc3_];
            if(param1.x < _loc6_[0])
            {
               _y_offset = 0;
            }
            else if(param1.x > _loc6_[1])
            {
               _y_offset = MOTION_LENGTH - 1;
            }
            else
            {
               _loc7_ = (param1.x - _loc6_[0]) / (_loc6_[1] - _loc6_[0]);
               _y_offset = MOTION_LENGTH * _loc7_;
            }
         }
         update();
      }
      
      public function getRangeFor(param1:int) : Array
      {
         return _target_offsets[param1];
      }
      
      public function disable() : void
      {
         _enabled = false;
         _unit_send_action = false;
         target.visible = false;
         _unit_card_icon.visible = false;
      }
      
      public function update() : void
      {
         if(!target.visible)
         {
            return;
         }
         target.gotoAndStop(roadOffset() + _y_offset);
      }
      
      public function getDropPoint() : Point
      {
         return new Point(target.x + target.target_circle.x,target.y + target.target_circle.y);
      }
      
      public function get currentType() : String
      {
         return _current_type;
      }
   }
}

