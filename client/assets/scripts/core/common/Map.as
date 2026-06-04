package core.common
{
   public class Map
   {
      
      public var values:Array = new Array();
      
      protected var index_:int = 0;
      
      public var keys:Array = new Array();
      
      public function Map()
      {
         super();
      }
      
      public function add(param1:Object, param2:*) : void
      {
         index_ = 0;
         find(param1);
         keys.splice(index_,0,param1);
         values.splice(index_,0,param2);
      }
      
      public function empty() : Boolean
      {
         return keys.length == 0;
      }
      
      public function shift() : *
      {
         var _loc1_:* = undefined;
         _loc1_ = values.shift();
         keys.shift();
         return _loc1_;
      }
      
      public function remove(param1:Object) : void
      {
         if(find(param1))
         {
            keys.splice(index_,1);
            values.splice(index_,1);
         }
      }
      
      public function size() : int
      {
         return keys.length;
      }
      
      public function pop() : *
      {
         var _loc1_:* = undefined;
         _loc1_ = values.pop();
         keys.pop();
         return _loc1_;
      }
      
      public function get(param1:Object) : *
      {
         if(!find(param1))
         {
            return null;
         }
         return values[index_];
      }
      
      public function getout(param1:Object) : *
      {
         var _loc2_:* = undefined;
         if(!find(param1))
         {
            return null;
         }
         _loc2_ = values[index_];
         values.splice(index_,1);
         keys.splice(index_,1);
         return _loc2_;
      }
      
      public function find(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = 0;
         _loc3_ = keys.length - 1;
         while(_loc2_ <= _loc3_)
         {
            index_ = _loc2_ + _loc3_ >> 1;
            if(param1 < keys[index_])
            {
               _loc3_ = index_ - 1;
            }
            else
            {
               if(param1 <= keys[index_])
               {
                  return true;
               }
               _loc2_ = index_ + 1;
            }
         }
         index_ = _loc2_;
         return false;
      }
      
      public function clear() : void
      {
         keys.length = 0;
         values.length = 0;
         index_ = 0;
      }
   }
}

