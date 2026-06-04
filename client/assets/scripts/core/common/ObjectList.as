package core.common
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public class ObjectList extends Proxy
   {
      
      private var objects:Array = [];
      
      public function ObjectList()
      {
         super();
      }
      
      public function shift() : *
      {
         return objects.shift();
      }
      
      public function makeCopy() : ObjectList
      {
         var _loc1_:ObjectList = null;
         _loc1_ = new ObjectList();
         _loc1_.objects = objects.concat();
         return _loc1_;
      }
      
      public function remove(param1:*) : void
      {
         var _loc2_:int = 0;
         _loc2_ = objects.indexOf(param1);
         if(_loc2_ >= 0)
         {
            delete objects[_loc2_];
            objects.splice(_loc2_,1);
         }
      }
      
      public function get length() : uint
      {
         return objects.length;
      }
      
      public function push(param1:*) : void
      {
         objects.push(param1);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return objects[param1];
      }
      
      public function clear() : void
      {
         if(Boolean(objects) && objects.length > 0)
         {
            objects.length = 0;
            objects = new Array();
         }
      }
      
      public function buildFromArray(param1:Array) : void
      {
         objects = param1.concat();
      }
      
      override flash_proxy function isAttribute(param1:*) : Boolean
      {
         return false;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         if(objects[param1] is Function)
         {
            return objects[param1].apply(null,rest);
         }
         return null;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         return param1 < objects.length ? int(param1 + 1) : 0;
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         objects[param1] = param2;
      }
      
      override flash_proxy function getDescendants(param1:*) : *
      {
         return null;
      }
      
      public function hasItem(param1:*) : Boolean
      {
         return objects.indexOf(param1) != -1;
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         return objects[param1 - 1];
      }
   }
}

