package game.units
{
   import core.Global;
   import game.StringConsts;
   import game.logic.Engine;
   
   public class UnitCreator
   {
      
      public function UnitCreator()
      {
         super();
      }
      
      public static function enemySpeedBuildingMultiplier(param1:int, param2:int) : Number
      {
         switch(param2)
         {
            case 0:
               if(param1 >= 6)
               {
                  return 2;
               }
               if(param1 >= 10)
               {
                  return 3;
               }
               break;
            case 1:
               return 3;
            case 2:
               if(param1 > 10)
               {
                  return 5;
               }
               return 4;
         }
         return 1;
      }
      
      public static function enemySpecialTicksMultiplier(param1:int, param2:int) : Number
      {
         switch(param2)
         {
            case 0:
               return 1;
            case 1:
               if(param1 > 8)
               {
                  return 3;
               }
               return 2;
               break;
            case 2:
               if(param1 >= 11)
               {
                  return 5;
               }
               if(param1 > 6)
               {
                  return 4;
               }
               return 3;
               break;
            default:
               return 1;
         }
      }
      
      public static function enemyStormAttackChargeLevel(param1:int, param2:int) : Number
      {
         switch(param2)
         {
            case 0:
               return 1;
            case 1:
               if(param1 >= 11)
               {
                  return 3;
               }
               return 2;
               break;
            case 2:
               if(param1 > 10)
               {
                  return 4;
               }
               return 3;
               break;
            default:
               return 1;
         }
      }
      
      private static function enemyArmorBoostLevel() : int
      {
         var _loc1_:Engine = null;
         _loc1_ = Global.top.engine;
         if(_loc1_.lastZone == 0)
         {
            if(_loc1_.lastLevelIndex >= 11)
            {
               return 4;
            }
            if(_loc1_.lastLevelIndex >= 5)
            {
               return 3;
            }
            if(_loc1_.lastLevelIndex > 1)
            {
               return 2;
            }
            return 1;
         }
         if(_loc1_.lastZone == 1)
         {
            if(_loc1_.lastLevelIndex >= 10)
            {
               return 6;
            }
            if(_loc1_.lastLevelIndex >= 6)
            {
               return 5;
            }
            return 4;
         }
         if(_loc1_.lastLevelIndex >= 10)
         {
            return 7;
         }
         return 6;
      }
      
      private static function enemyDroidFirepowerLevel() : int
      {
         var _loc1_:Engine = null;
         _loc1_ = Global.top.engine;
         if(_loc1_.lastZone == 0)
         {
            if(_loc1_.lastLevelIndex > 7)
            {
               return 3;
            }
            if(_loc1_.lastLevelIndex >= 6)
            {
               return 2;
            }
            if(_loc1_.lastLevelIndex > 0)
            {
               return 1;
            }
            return 1;
         }
         if(_loc1_.lastZone == 1)
         {
            if(_loc1_.lastLevelIndex >= 5)
            {
               return 5;
            }
            return 4;
         }
         if(_loc1_.lastLevelIndex > 10)
         {
            return 8;
         }
         if(_loc1_.lastLevelIndex > 8)
         {
            return 7;
         }
         if(_loc1_.lastLevelIndex > 4)
         {
            return 6;
         }
         return 5;
      }
      
      private static function enemyHumanFirepowerLevel() : int
      {
         var _loc1_:Engine = null;
         _loc1_ = Global.top.engine;
         if(_loc1_.lastZone == 0)
         {
            if(_loc1_.lastLevelIndex >= 7)
            {
               return 3;
            }
            if(_loc1_.lastLevelIndex == 6)
            {
               return 2;
            }
            if(_loc1_.lastLevelIndex > 0)
            {
               return 1;
            }
            return 0;
         }
         if(1 == _loc1_.lastZone)
         {
            if(_loc1_.lastLevelIndex >= 5)
            {
               return 4;
            }
            return 3;
         }
         if(_loc1_.lastLevelIndex >= 11)
         {
            return 10;
         }
         if(_loc1_.lastLevelIndex >= 10)
         {
            return 8;
         }
         return 7;
      }
      
      public static function create(param1:String, param2:Boolean, param3:Boolean = false) : Unit
      {
         var _loc4_:Unit = null;
         var _loc5_:* = undefined;
         var _loc6_:Weapon = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         _loc4_ = new Unit(param1,param2);
         _loc5_ = null;
         _loc6_ = new Weapon();
         _loc7_ = int(Global.top.upgrades.humanFirepowerLevel());
         _loc8_ = Global.top.upgrades.droidFirepowerLevel() - 1;
         _loc9_ = int(Global.top.upgrades.armorBoostLevel());
         _loc10_ = enemyHumanFirepowerLevel();
         _loc11_ = enemyDroidFirepowerLevel() - 1;
         _loc12_ = enemyArmorBoostLevel();
         switch(param1)
         {
            case StringConsts.MARINE:
               _loc4_.velocity = 1;
               _loc4_.full_health = 50;
               _loc4_.enemy_unit = param2;
               _loc4_.sitting_ticks = 22;
               _loc6_.eyerange = 300;
               _loc6_.damage = 7;
               _loc6_.likelihood = 0.25;
               _loc6_.recharge_time = 22;
               _loc6_.bullet_speed = 40;
               _loc4_.setWeapon(_loc6_);
               if(param2)
               {
                  _loc4_.armor += _loc12_;
                  _loc6_.damage += 2 * _loc10_;
                  if(!param3)
                  {
                     _loc5_ = new RedMarine();
                  }
               }
               else
               {
                  _loc4_.armor += _loc9_;
                  _loc6_.damage += 2 * _loc7_;
                  if(!param3)
                  {
                     _loc5_ = new BlueMarine();
                  }
               }
               _loc4_.setSprite(_loc5_);
               break;
            case StringConsts.MISSILE_MAN:
               _loc4_.velocity = 1;
               _loc4_.full_health = 80;
               _loc4_.enemy_unit = param2;
               _loc4_.sitting_ticks = 22;
               _loc6_.eyerange = 400;
               _loc6_.damage = 15;
               _loc6_.likelihood = 0.25;
               _loc6_.recharge_time = 50;
               _loc6_.bullet_speed = 40;
               _loc4_.setWeapon(_loc6_);
               if(param2)
               {
                  _loc4_.armor += _loc12_;
                  _loc6_.damage += 2 * _loc10_;
                  if(!param3)
                  {
                     _loc5_ = new RedMissileMan();
                  }
               }
               else
               {
                  _loc4_.armor += _loc9_;
                  _loc6_.damage += 2 * _loc7_;
                  if(!param3)
                  {
                     _loc5_ = new BlueMissileMan();
                  }
               }
               _loc4_.setSprite(_loc5_);
               break;
            case StringConsts.SPECIALIST:
               _loc4_.velocity = 0.6;
               _loc4_.full_health = 64;
               _loc4_.enemy_unit = param2;
               _loc4_.armor = 3;
               _loc4_.sitting_ticks = 22;
               _loc6_.eyerange = 350;
               _loc6_.damage = 24;
               _loc6_.likelihood = 0.25;
               _loc6_.recharge_time = 30;
               _loc6_.bullet_speed = 50;
               _loc4_.setWeapon(_loc6_);
               if(param2)
               {
                  _loc4_.armor += _loc12_;
                  _loc6_.damage += 2 * _loc10_;
                  if(!param3)
                  {
                     _loc5_ = new RedSpecialist();
                  }
               }
               else
               {
                  _loc4_.armor += _loc9_;
                  _loc6_.damage += 2 * _loc7_;
                  if(!param3)
                  {
                     _loc5_ = new BlueSpecialist();
                  }
               }
               _loc4_.setSprite(_loc5_);
               break;
            case StringConsts.STORM_TANK:
               _loc4_.velocity = 0.8;
               _loc4_.full_health = 240;
               _loc4_.enemy_unit = param2;
               _loc4_.armor = 2;
               _loc6_.eyerange = 325;
               _loc6_.damage = 20;
               _loc6_.likelihood = 0.75;
               _loc6_.recharge_time = 48;
               _loc6_.bullet_speed = 70;
               _loc4_.setWeapon(_loc6_);
               if(param2)
               {
                  _loc4_.armor += _loc12_;
                  _loc6_.damage += 2 * _loc11_;
                  if(!param3)
                  {
                     _loc5_ = new RedStormTank();
                  }
               }
               else
               {
                  _loc4_.armor += _loc9_;
                  _loc6_.damage += 2 * _loc8_;
                  if(!param3)
                  {
                     _loc5_ = new BlueStormTank();
                  }
               }
               _loc4_.setSprite(_loc5_);
               break;
            case StringConsts.MINER_DROID:
               _loc4_.velocity = 0.6;
               _loc4_.full_health = 100;
               _loc4_.enemy_unit = param2;
               _loc4_.armor = 1;
               _loc4_.peaceful = true;
               _loc6_.eyerange = 100;
               _loc6_.damage = 200;
               _loc6_.likelihood = 0.75;
               _loc6_.recharge_time = 80;
               _loc6_.bullet_speed = 190;
               _loc4_.setWeapon(_loc6_);
               if(param2)
               {
                  _loc4_.armor += _loc12_;
                  _loc6_.damage += 2 * _loc11_;
                  if(!param3)
                  {
                     _loc5_ = new RedMinerDroid();
                  }
               }
               else
               {
                  _loc4_.armor += _loc9_;
                  _loc6_.damage += 2 * _loc8_;
                  if(!param3)
                  {
                     _loc5_ = new BlueMinerDroid();
                  }
               }
               _loc4_.setSprite(_loc5_);
               break;
            case StringConsts.MINE:
               _loc4_.velocity = 1;
               _loc4_.full_health = 50;
               _loc4_.enemy_unit = param2;
               _loc6_.eyerange = 50;
               _loc6_.damage = 250;
               _loc6_.likelihood = 1;
               _loc6_.recharge_time = 1;
               _loc6_.bullet_speed = 1;
               _loc4_.setWeapon(_loc6_);
               if(param2)
               {
                  if(!param3)
                  {
                     _loc5_ = new RedMine();
                  }
               }
               else if(!param3)
               {
                  _loc5_ = new BlueMine();
               }
               _loc4_.setSprite(_loc5_);
               break;
            case StringConsts.GRENADIER_DROID:
               _loc4_.velocity = 0.75;
               _loc4_.full_health = 250;
               _loc4_.enemy_unit = param2;
               _loc4_.armor = 2;
               _loc6_.eyerange = 100;
               _loc6_.damage = 500;
               _loc6_.likelihood = 0.75;
               _loc6_.recharge_time = 90;
               _loc6_.bullet_speed = 190;
               _loc4_.setWeapon(_loc6_);
               if(param2)
               {
                  _loc4_.armor += _loc12_;
                  _loc6_.damage += 2 * _loc11_;
                  if(!param3)
                  {
                     _loc5_ = new RedGrenadier();
                  }
               }
               else
               {
                  _loc4_.armor += _loc9_;
                  _loc6_.damage += 2 * _loc8_;
                  if(!param3)
                  {
                     _loc5_ = new BlueGrenadier();
                  }
               }
               _loc4_.setSprite(_loc5_);
               break;
            case StringConsts.CATERPILLAR:
               _loc4_.velocity = 0.34;
               _loc4_.full_health = 500;
               _loc4_.enemy_unit = param2;
               _loc4_.armor = 4;
               _loc6_.eyerange = 350;
               _loc6_.damage = 75;
               _loc6_.likelihood = 0.75;
               _loc6_.recharge_time = 130;
               _loc6_.bullet_speed = 190;
               _loc4_.setWeapon(_loc6_);
               if(param2)
               {
                  _loc4_.armor += _loc12_;
                  _loc6_.damage += 2 * _loc11_;
                  if(!param3)
                  {
                     _loc5_ = new RedCaterpillar();
                  }
               }
               else
               {
                  _loc4_.armor += _loc9_;
                  _loc6_.damage += 2 * _loc8_;
                  if(!param3)
                  {
                     _loc5_ = new BlueCaterpillar();
                  }
               }
               _loc4_.setSprite(_loc5_);
               break;
            case StringConsts.VULTURE:
               _loc4_.velocity = 4.6;
               _loc4_.full_health = 120;
               _loc4_.enemy_unit = param2;
               _loc4_.peaceful = true;
               _loc6_.eyerange = 100;
               _loc6_.damage = 0;
               _loc6_.likelihood = 0;
               _loc4_.setWeapon(_loc6_);
               if(param2)
               {
                  if(!param3)
                  {
                     _loc5_ = new RedVulture();
                  }
               }
               else if(!param3)
               {
                  _loc5_ = new BlueVulture();
               }
               _loc4_.setSprite(_loc5_);
         }
         if(_loc4_.type != StringConsts.GRENADIER_DROID && _loc4_.type != StringConsts.MINE)
         {
            _loc4_.weapon.eyerange += Math.random() * 55;
         }
         if(_loc12_ > 0)
         {
            _loc4_.armor += _loc12_;
         }
         return _loc4_;
      }
      
      public static function getBullet(param1:String, param2:Boolean) : *
      {
         switch(param1)
         {
            case StringConsts.MARINE:
               return new MarineBullet();
            case StringConsts.SPECIALIST:
               return new SFBullet();
            case StringConsts.MISSILE_MAN:
               return new MMBullet();
            case StringConsts.CATERPILLAR:
               if(!param2)
               {
                  return new LaserBeam();
               }
               return new RedLaserBeam();
               break;
            case StringConsts.STORM_TANK:
               return new StormTankBullet();
            default:
               return new MarineBullet();
         }
      }
   }
}

