package core.common
{
   import flash.events.KeyboardEvent;
   
   public class KeyboardKeys
   {
      
      private static var keys:Object = new Object();
      
      private static var initialized:Boolean = false;
      
      public static const W_KEY:int = 87;
      
      public static const w_KEY:int = 119;
      
      public static const A_KEY:int = 65;
      
      public static const a_KEY:int = 97;
      
      public static const S_KEY:int = 83;
      
      public static const s_KEY:int = 115;
      
      public static const D_KEY:int = 68;
      
      public static const d_KEY:int = 100;
      
      public function KeyboardKeys()
      {
         super();
      }
      
      private static function keyPressed(param1:KeyboardEvent) : void
      {
         keys[param1.keyCode] = true;
      }
      
      public static function init(param1:*) : void
      {
         param1.addEventListener(KeyboardEvent.KEY_DOWN,keyPressed);
         param1.addEventListener(KeyboardEvent.KEY_UP,keyReleased);
         initialized = true;
      }
      
      public static function stop(param1:*) : void
      {
         param1.removeEventListener(KeyboardEvent.KEY_DOWN,keyPressed);
         param1.removeEventListener(KeyboardEvent.KEY_UP,keyReleased);
         initialized = false;
      }
      
      public static function isDown(param1:uint) : Boolean
      {
         if(!initialized)
         {
            return false;
         }
         if(Boolean(param1 in keys))
         {
            return keys[param1];
         }
         return false;
      }
      
      private static function keyReleased(param1:KeyboardEvent) : void
      {
         keys[param1.keyCode] = false;
      }
   }
}

