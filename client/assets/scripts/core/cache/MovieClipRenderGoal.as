package core.cache
{
   import core.goal.Goal;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class MovieClipRenderGoal extends Goal
   {
      
      public static const HAS_PARENT:int = 0;
      
      public static const TOTAL_FRAMES:int = 1;
      
      private var _cache:CachedMovieClip = null;
      
      private var _frames:Array = new Array();
      
      private var _final_params:Object = null;
      
      private var _final_condition:int = 0;
      
      private var _cache_id:String;
      
      private var _overhead_x:int = 0;
      
      private var _clip_bounds:Rectangle = null;
      
      private var _sprite:* = null;
      
      private var _overhead_y:int = 0;
      
      public function MovieClipRenderGoal(param1:*, param2:String, param3:int = 0, param4:int = 0)
      {
         super();
         _sprite = param1;
         _cache_id = param2;
         _overhead_x = param3;
         _overhead_y = param4;
         _cache = new CachedMovieClip();
         _cache.renderer = this;
         MovieClipCache.saveCached(_cache_id,_cache);
         checkClipBounds();
      }
      
      public static function cleanScaffolds(param1:*) : void
      {
         if(param1.clip_bounds)
         {
            param1.removeChild(param1.clip_bounds);
            param1.clip_bounds = null;
         }
      }
      
      override public function advance() : void
      {
         var _loc1_:FrameInfo = null;
         if(!isFinalCondition())
         {
            if(_sprite.currentFrame < _frames.length + 1)
            {
               return;
            }
            _loc1_ = snapClip(_sprite);
            if(_loc1_)
            {
               _frames.push(_loc1_);
            }
         }
         else
         {
            _cache.cachedFrames = _frames;
            _cache.renderer = null;
            _cache.alreadyCached = true;
            deactivate();
         }
      }
      
      private function isFinalCondition() : Boolean
      {
         if(HAS_PARENT == _final_condition)
         {
            return _sprite.parent == null;
         }
         if(TOTAL_FRAMES == _final_condition)
         {
            return _frames.length >= _final_params.total_frames;
         }
         return true;
      }
      
      public function setFinalCondition(param1:int, param2:Object = null) : void
      {
         _final_condition = param1;
         switch(param1)
         {
            case HAS_PARENT:
               break;
            case TOTAL_FRAMES:
               _final_params = new Object();
               if(!param2)
               {
                  _final_params.total_frames = _sprite.totalFrames;
               }
               else
               {
                  _final_params.total_frames = param2.totalFrames;
               }
         }
      }
      
      public function get frames() : Array
      {
         return _frames;
      }
      
      private function checkClipBounds() : void
      {
         if(_sprite.clip_bounds)
         {
            _clip_bounds = new Rectangle(_sprite.clip_bounds.x,_sprite.clip_bounds.y,_sprite.clip_bounds.width,_sprite.clip_bounds.height);
            cleanScaffolds(_sprite);
         }
      }
      
      public function snapClip(param1:*) : FrameInfo
      {
         var _loc2_:Rectangle = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Matrix = null;
         var _loc5_:FrameInfo = null;
         _loc2_ = null;
         if(_clip_bounds)
         {
            _loc2_ = _clip_bounds.clone();
         }
         else
         {
            _loc2_ = param1.getBounds(param1);
            if(_loc2_.width == 0 || _loc2_.height == 0)
            {
               return null;
            }
         }
         _loc2_.x *= Math.abs(param1.scaleX);
         _loc2_.y *= Math.abs(param1.scaleY);
         _loc2_.width *= Math.abs(param1.scaleX);
         _loc2_.height *= Math.abs(param1.scaleY);
         _loc2_.x -= _overhead_x;
         _loc2_.y -= _overhead_x;
         _loc2_.width += _overhead_x * 2;
         _loc2_.height += _overhead_y * 2;
         _loc3_ = new BitmapData(int(_loc2_.width + 1),int(_loc2_.height + 1),true,0);
         _loc4_ = new Matrix();
         _loc4_.scale(param1.scaleX,param1.scaleY);
         _loc4_.rotate(param1.rotation * (Math.PI / 180));
         _loc4_.translate(-_loc2_.x,-_loc2_.y);
         _loc3_.draw(param1,_loc4_,null,BlendMode.NORMAL);
         _loc5_ = new FrameInfo(_loc3_,_loc2_);
         _loc5_.offset_x = -_loc2_.x;
         _loc5_.offset_y = -_loc2_.y;
         return _loc5_;
      }
   }
}

