package core.cache
{
   import flash.utils.Dictionary;
   
   public class MovieClipCache
   {
      
      private static var _cache:Dictionary = new Dictionary();
      
      public function MovieClipCache()
      {
         super();
      }
      
      public static function getCached(param1:String) : CachedMovieClip
      {
         return _cache[param1];
      }
      
      public static function saveCached(param1:String, param2:CachedMovieClip) : void
      {
         _cache[param1] = param2;
      }
   }
}

