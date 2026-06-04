package game.logic
{
   import core.Global;
   import flash.display.*;
   
   public class Upgrades
   {
      
      public static const SPEED_BUILDING:String = "Speed Building";
      
      public static const ACCURACY:String = "Accuracy";
      
      public static const BALLISTICS:String = "Ballistics";
      
      public static const ARMOR_BOOST:String = "Armor Boost";
      
      public static const COUNTER_ATTACK:String = "Counter Attack";
      
      public static const FIRE_SUPPORT:String = "Fire Support";
      
      private var fire_support_level:int = 1;
      
      private var speed_uilding_cost:int = 0;
      
      private var accuracy_cost:int = 0;
      
      private var upgrades_cost_array:Array;
      
      private var ballistics_level:int = 1;
      
      private var counter_attack_cost:int = 0;
      
      private var speed_uilding_level:int = 1;
      
      private var ballistics_cost:int = 0;
      
      private var armor_boost_level:int = 1;
      
      private var armor_boost_cost:int = 0;
      
      private var fire_support_cost:int = 0;
      
      private var counter_attack_level:int = 1;
      
      private var upgrades_level_array:Array;
      
      private var _engine:Engine = null;
      
      private var accuracy_level:int = 1;
      
      public function Upgrades()
      {
         upgrades_cost_array = [speed_uilding_cost,accuracy_cost,ballistics_cost,armor_boost_cost,counter_attack_cost,fire_support_cost];
         upgrades_level_array = [speed_uilding_level,accuracy_level,ballistics_level,armor_boost_level,counter_attack_level,fire_support_level];
         super();
         _engine = Global.top.engine;
         upgrades_cost_array = getDefaultCosts();
      }
      
      public function armorBoostLevel() : int
      {
         return upgrades_level_array[3];
      }
      
      public function getUpgradeLevel() : Array
      {
         return upgrades_level_array;
      }
      
      public function droidFirepowerLevel() : int
      {
         return upgrades_level_array[2];
      }
      
      public function humanFirepowerLevel() : int
      {
         return upgrades_level_array[1];
      }
      
      public function set costArray(param1:Array) : void
      {
         upgrades_cost_array = param1;
      }
      
      public function get costArray() : Array
      {
         return upgrades_cost_array;
      }
      
      public function getUpgradeCreds() : String
      {
         var _loc1_:String = null;
         return _engine.creds.toString();
      }
      
      public function getUpgradeCost() : Array
      {
         return upgrades_cost_array;
      }
      
      public function get upgradeArray() : Array
      {
         return upgrades_level_array;
      }
      
      public function stormAttackChargeLevel() : int
      {
         return upgrades_level_array[4];
      }
      
      public function orbitalSupportSpeedLevel() : int
      {
         return upgrades_level_array[5];
      }
      
      public function speedBuildingLevel() : int
      {
         return upgrades_level_array[0];
      }
      
      public function set upgradeArray(param1:Array) : void
      {
         upgrades_level_array = param1;
      }
      
      public function getDefaultCosts() : Array
      {
         return [1100,400,1200,800,1800,2500];
      }
      
      public function buyUpgrade(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         if(_engine.creds >= upgrades_cost_array[param1])
         {
            _engine.creds -= upgrades_cost_array[param1];
            upgrades_cost_array[param1] += Math.round(1 * upgrades_cost_array[param1]);
            ++upgrades_level_array[param1];
            Global.top.saveLevels();
         }
      }
   }
}

