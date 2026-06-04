package game.ui.controls
{
   import flash.display.MovieClip;
   import flash.filters.BitmapFilter;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import game.logic.Engine;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol32")]
   public class LevelButton extends MovieClip
   {
      
      public var filter_back:MovieClip;
      
      private var engine:Engine = null;
      
      public var green_back:MovieClip;
      
      private var level_id:int = 0;
      
      public var red_back:MovieClip;
      
      public var won_back:MovieClip;
      
      public function LevelButton()
      {
         super();
      }
      
      public function select(param1:Boolean) : void
      {
         var _loc2_:BitmapFilter = null;
         var _loc3_:Array = null;
         if(param1)
         {
            _loc2_ = getBitmapFilter();
            _loc3_ = new Array();
            _loc3_.push(_loc2_);
            filter_back.filters = _loc3_;
         }
         else
         {
            filter_back.filters = new Array();
         }
      }
      
      public function levelClosed() : void
      {
         clear();
         red_back.visible = true;
         won_back.visible = false;
         green_back.visible = false;
      }
      
      public function levelCurrent() : void
      {
         clear();
         green_back.visible = true;
         red_back.visible = false;
         won_back.visible = false;
         startAnimation();
      }
      
      public function levelWon() : void
      {
         clear();
         won_back.visible = true;
         red_back.visible = false;
         green_back.visible = false;
      }
      
      public function initialize(param1:Engine, param2:int) : void
      {
         engine = param1;
         level_id = param2;
         buttonMode = true;
         tabEnabled = false;
         mouseChildren = false;
      }
      
      public function clear() : void
      {
         stopAnimation();
      }
      
      public function stopAnimation() : void
      {
      }
      
      public function startAnimation() : void
      {
         stopAnimation();
      }
      
      public function get levelId() : int
      {
         return level_id;
      }
      
      private function getBitmapFilter() : BitmapFilter
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         _loc1_ = 9540095;
         _loc2_ = 1;
         _loc3_ = 35;
         _loc4_ = 35;
         _loc5_ = 3;
         _loc6_ = false;
         _loc7_ = false;
         _loc8_ = BitmapFilterQuality.HIGH;
         return new GlowFilter(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc8_,_loc6_,_loc7_);
      }
   }
}

