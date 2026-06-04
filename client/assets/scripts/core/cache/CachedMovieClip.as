package core.cache
{
   public class CachedMovieClip
   {
      
      private var _renderer:MovieClipRenderGoal = null;
      
      private var _already_cached:Boolean = false;
      
      private var _cached_frames:Array = null;
      
      public function CachedMovieClip()
      {
         super();
      }
      
      public function get renderer() : MovieClipRenderGoal
      {
         return _renderer;
      }
      
      public function set renderer(param1:MovieClipRenderGoal) : void
      {
         _renderer = param1;
      }
      
      public function set alreadyCached(param1:Boolean) : void
      {
         _already_cached = param1;
      }
      
      public function get cachedFrames() : Array
      {
         return _cached_frames;
      }
      
      public function get alreadyCached() : Boolean
      {
         return _already_cached;
      }
      
      public function set cachedFrames(param1:Array) : void
      {
         _cached_frames = param1;
      }
   }
}

