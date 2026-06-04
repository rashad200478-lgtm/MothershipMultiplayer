package game.units
{
   import core.Global;
   import core.common.ObjectList;
   import core.common.Position;
   import game.ui.RoadPath;
   
   public class UnitCamp extends ObjectList
   {
      
      public function UnitCamp()
      {
         super();
      }
      
      public static function distanceFromPosition(param1:*, param2:Unit) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc3_ = param2.sprite.x - param1.x;
         _loc4_ = param2.sprite.y - param1.y;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
      
      public function applyDamageNear(param1:Number, param2:*, param3:Number, param4:String = null) : void
      {
         var _loc5_:ObjectList = null;
         var _loc6_:int = 0;
         var _loc7_:Unit = null;
         var _loc8_:int = 0;
         _loc5_ = makeCopy();
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            if(_loc7_.isAlive && !_loc7_.coverForceField())
            {
               _loc8_ = distanceFromPosition(param2,_loc7_);
               if(_loc8_ <= param3)
               {
                  Global.top.engine.hitUnit(param1,_loc7_,param4);
               }
            }
            _loc6_++;
         }
      }
      
      public function aliveCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         _loc2_ = 0;
         while(_loc2_ < length)
         {
            if(this[_loc2_].isAlive)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getNearestUnit(param1:RoadPath, param2:Position, param3:int) : Unit
      {
         var _loc4_:Unit = null;
         var _loc5_:Unit = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = 9999999;
         _loc7_ = 0;
         while(_loc7_ < length)
         {
            _loc4_ = this[_loc7_];
            if(_loc4_.isAlive && _loc4_.life.getCurrentRoad() == param1)
            {
               _loc8_ = distanceFromPosition(param2,_loc4_);
               if(_loc8_ <= param3 && _loc8_ < _loc6_)
               {
                  _loc5_ = _loc4_;
                  _loc6_ = _loc8_;
               }
            }
            _loc7_++;
         }
         return _loc5_;
      }
      
      protected function isUnitInFront(param1:Unit, param2:Unit) : Boolean
      {
         if(param2.isEnemy)
         {
            if(param2.sprite.x > param1.sprite.x)
            {
               return true;
            }
         }
         else if(param2.sprite.x < param1.sprite.x)
         {
            return true;
         }
         return false;
      }
      
      public function getNearestForwardUnit(param1:RoadPath, param2:Unit, param3:int) : Unit
      {
         var _loc4_:Unit = null;
         var _loc5_:Unit = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = 9999999;
         _loc7_ = 0;
         while(_loc7_ < length)
         {
            _loc4_ = this[_loc7_];
            if(_loc4_.isAlive && _loc4_.life.getCurrentRoad() == param1 && isUnitInFront(_loc4_,param2))
            {
               _loc8_ = distanceFromPosition(param2.sprite,_loc4_);
               if(_loc8_ <= param3 && _loc8_ < _loc6_)
               {
                  _loc5_ = _loc4_;
                  _loc6_ = _loc8_;
               }
            }
            _loc7_++;
         }
         return _loc5_;
      }
      
      public function getNearUnits(param1:RoadPath, param2:Position = null, param3:Number = 0) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Unit = null;
         var _loc7_:int = 0;
         _loc4_ = new Array();
         _loc5_ = 0;
         _loc5_ = 0;
         while(_loc5_ < length)
         {
            _loc6_ = this[_loc5_];
            if(_loc6_.isAlive && _loc6_.life.getCurrentRoad() == param1)
            {
               if(param2)
               {
                  _loc7_ = distanceFromPosition(param2,_loc6_);
                  if(_loc7_ <= param3)
                  {
                     _loc4_.push(_loc6_);
                  }
               }
               else
               {
                  _loc4_.push(_loc6_);
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function applyDamage(param1:Number, param2:String = null) : void
      {
         var _loc3_:ObjectList = null;
         var _loc4_:int = 0;
         var _loc5_:Unit = null;
         _loc3_ = makeCopy();
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.isAlive && !_loc5_.coverForceField())
            {
               Global.top.engine.hitUnit(param1,_loc5_,param2);
            }
            _loc4_++;
         }
      }
   }
}

