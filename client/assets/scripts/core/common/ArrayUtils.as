package core.common
{
   public class ArrayUtils
   {
      
      public function ArrayUtils()
      {
         super();
      }
      
      public static function shuffle(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(param1.length <= 1)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.length + 1)
         {
            exchangeElements(param1,(Math.random() - 0.001) * param1.length,(Math.random() - 0.001) * param1.length);
            _loc2_++;
         }
      }
      
      public static function exchangeElements(param1:Array, param2:int, param3:int) : void
      {
         var _loc4_:* = undefined;
         if(param2 == param3)
         {
            return;
         }
         _loc4_ = param1[param2];
         param1[param2] = param1[param3];
         param1[param3] = _loc4_;
      }
   }
}

