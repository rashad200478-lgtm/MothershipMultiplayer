package core
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.ui.ContextMenu;
   
   public class Global
   {
      
      private static var _main:Sprite = null;
      
      private static var _top:* = null;
      
      public function Global()
      {
         super();
      }
      
      public static function hideMenu() : void
      {
         var _loc1_:ContextMenu = null;
         if(!isStarted())
         {
            throw new Error("Cannot retrieve the global stage instance (_main == null)");
         }
         _loc1_ = new ContextMenu();
         _loc1_.hideBuiltInItems();
         _main.contextMenu = _loc1_;
      }
      
      public static function get top() : *
      {
         return _top;
      }
      
      public static function get mainStage() : Stage
      {
         if(null == _main)
         {
            throw new Error("Cannot retrieve the global stage instance (_main == null)");
         }
         return _main.stage;
      }
      
      public static function isStarted() : Boolean
      {
         return _main != null;
      }
      
      public static function startup(param1:Sprite, param2:*) : void
      {
         _main = param1;
         _top = param2;
      }
      
      public static function getCurrentDomain() : String
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc1_ = _main.root.loaderInfo.loaderURL;
         _loc2_ = _loc1_.indexOf("://") + 3;
         _loc3_ = _loc1_.indexOf("/",_loc2_);
         _loc4_ = _loc1_.substring(_loc2_,_loc3_);
         _loc5_ = _loc4_.lastIndexOf(".") - 1;
         _loc6_ = _loc4_.lastIndexOf(".",_loc5_) + 1;
         return _loc4_.substring(_loc6_,_loc4_.length).toLocaleLowerCase();
      }
      
      public static function get mainClass() : Sprite
      {
         return _main;
      }
   }
}

