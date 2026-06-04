package game.logic
{
   import caurina.transitions.Tweener;
   import core.Global;
   import core.common.ObjectList;
   import game.*;
   import game.ui.LevelData;
   
   public class LevelSelector
   {
      
      private static const _enemy_sets:Array = [[[StringConsts.MARINE],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]],[[StringConsts.MARINE,StringConsts.MISSILE_MAN],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]],[[StringConsts.MARINE,StringConsts.MISSILE_MAN],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID
      ,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]],[[StringConsts.MARINE,StringConsts.MISSILE_MAN,StringConsts.MINER_DROID],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]],[[StringConsts.MARINE,StringConsts.MISSILE_MAN,StringConsts.MINER_DROID,StringConsts.STORM_TANK],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID
      ,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]],[[StringConsts.MARINE,StringConsts.MISSILE_MAN,StringConsts.MINER_DROID,StringConsts.STORM_TANK],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]],[[StringConsts.MARINE,StringConsts.MISSILE_MAN,StringConsts.MINER_DROID,StringConsts.STORM_TANK,StringConsts.GRENADIER_DROID],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID
      ,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]],[[StringConsts.MARINE,StringConsts.MISSILE_MAN,StringConsts.MINER_DROID,StringConsts.STORM_TANK,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]],[[StringConsts.MARINE,StringConsts.MISSILE_MAN,StringConsts.MINER_DROID,StringConsts.STORM_TANK,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE],[StringConsts.MARINE,StringConsts
      .STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]],[[StringConsts.MARINE,StringConsts.MISSILE_MAN,StringConsts.MINER_DROID,StringConsts.STORM_TANK,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]],[[StringConsts.MARINE,StringConsts.MISSILE_MAN,StringConsts.MINER_DROID,StringConsts
      .STORM_TANK,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]],[[StringConsts.MARINE,StringConsts.MISSILE_MAN,StringConsts.MINER_DROID,StringConsts.STORM_TANK,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR],[StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts
      .GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.VULTURE,StringConsts.CATERPILLAR]]];
      
      private static const _enemy_specials:Array = [[[StringConsts.EMPTY],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]],[[StringConsts.EMPTY],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]],[[StringConsts.EMPTY],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]],[[StringConsts.EMPTY],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]],[[StringConsts.EMPTY],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts
      .NUCLEAR_MISSILE]],[[StringConsts.ARTILLERY_STRIKE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]],[[StringConsts.ARTILLERY_STRIKE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]],[[StringConsts.ARTILLERY_STRIKE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]],[[StringConsts.ARTILLERY_STRIKE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]],[[StringConsts.ARTILLERY_STRIKE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts
      .FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]],[[StringConsts.ARTILLERY_STRIKE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]],[[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE],[StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]]];
      
      public function LevelSelector()
      {
         super();
      }
      
      public static function checkUnitAvailability(param1:Array) : Boolean
      {
         var _loc2_:Engine = null;
         var _loc3_:ObjectList = null;
         var _loc4_:String = null;
         var _loc5_:NewFacility = null;
         var _loc6_:int = 0;
         _loc2_ = Global.top.engine;
         _loc3_ = Global.top.gameShop.getAvailableUnits();
         for each(_loc4_ in param1)
         {
            if(!_loc3_.hasItem(_loc4_))
            {
               _loc5_ = new NewFacility();
               _loc5_.card.slot_frame.gotoAndStop(_loc4_);
               _loc5_.x = 275.9;
               _loc5_.y = 285.6;
               _loc2_.playWindowUI.addChild(_loc5_);
               _loc5_.scaleX = _loc5_.scaleY = 0.01;
               Tweener.addTween(_loc5_,{
                  "scaleX":1,
                  "scaleY":1,
                  "time":1,
                  "transition":"linear"
               });
               _loc6_ = int(Global.top.gameShop.getBlockIndexByName(_loc4_));
               if(_loc6_ >= 0)
               {
                  Global.top.gameShop.arrayBlock[_loc6_] = 1;
                  Global.top.gameShop.updateBlock();
                  Global.top.gameShop.setDefaultCards();
                  Global.top.saveLevels();
               }
               return true;
            }
         }
         return false;
      }
      
      public static function getLevelUI(param1:int, param2:int) : *
      {
         var _loc3_:* = undefined;
         _loc3_ = null;
         _loc3_ = new ALlMapHolder();
         if(0 == param1 && 0 == param2)
         {
            (_loc3_.level_map as LevelData).health = 20;
         }
         else if(param2 == 0)
         {
            (_loc3_.level_map as LevelData).health = 30;
         }
         else if(param2 == 1)
         {
            (_loc3_.level_map as LevelData).health = 40;
         }
         else if(param2 == 2)
         {
            (_loc3_.level_map as LevelData).health = 50;
         }
         if(0 == param1 && 0 == param2)
         {
            (_loc3_.level_map as LevelData).level_time = 91;
         }
         else
         {
            (_loc3_.level_map as LevelData).level_time = 181;
         }
         (_loc3_.level_map as LevelData).title = Global.top.levelSelection.planetInfos[param1][param2][0] + ". Zone " + (param2 + 1).toString();
         (_loc3_.level_map as LevelData).best_counteraction_likelihood = bestCounteractionLikelihood(param1,param2);
         return _loc3_;
      }
      
      public static function levelCount() : int
      {
         return 12;
      }
      
      public static function get enemySpecials() : Array
      {
         return _enemy_specials;
      }
      
      public static function checkForNewUnits(param1:int, param2:int) : Boolean
      {
         if(param2 > 0)
         {
            return checkUnitAvailability([StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.VULTURE,StringConsts.CATERPILLAR,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST]) || checkWeaponAvailability([StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]);
         }
         switch(param1)
         {
            case 0:
               return checkUnitAvailability([StringConsts.MARINE,StringConsts.STORM_TANK]);
            case 1:
               return checkWeaponAvailability([StringConsts.ARTILLERY_STRIKE,StringConsts.EMPTY,StringConsts.EMPTY]);
            case 2:
               return checkUnitAvailability([StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID]);
            case 3:
               return checkUnitAvailability([StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN]);
            case 4:
               break;
            case 5:
               return checkUnitAvailability([StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.VULTURE]);
            case 6:
               return checkUnitAvailability([StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.VULTURE,StringConsts.CATERPILLAR]);
            case 7:
               return checkUnitAvailability([StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.VULTURE,StringConsts.CATERPILLAR,StringConsts.GRENADIER_DROID]);
            case 8:
               return checkUnitAvailability([StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.VULTURE,StringConsts.CATERPILLAR,StringConsts.GRENADIER_DROID]) || checkWeaponAvailability([StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.EMPTY]);
            case 9:
               return checkUnitAvailability([StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.VULTURE,StringConsts.CATERPILLAR,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST]);
            case 10:
               return checkUnitAvailability([StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.VULTURE,StringConsts.CATERPILLAR,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST]);
            case 11:
               return checkUnitAvailability([StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MINER_DROID,StringConsts.MISSILE_MAN,StringConsts.VULTURE,StringConsts.CATERPILLAR,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST]) || checkWeaponAvailability([StringConsts.ARTILLERY_STRIKE,StringConsts.FORCE_FIELD,StringConsts.NUCLEAR_MISSILE]);
         }
         return false;
      }
      
      public static function initializeAI(param1:AIThinker) : void
      {
         param1.level_complexity = bestCounteractionLikelihood(Global.top.engine.lastLevelIndex,Global.top.engine.lastZone);
         if(0 == Global.top.engine.lastZone)
         {
            if(Global.top.engine.lastLevelIndex == 0)
            {
               param1.setThinkingPause(2,0.8);
            }
         }
      }
      
      public static function get enemySets() : Array
      {
         return _enemy_sets;
      }
      
      public static function bestCounteractionLikelihood(param1:int, param2:int) : Number
      {
         switch(param2)
         {
            case 0:
               return 0.05 + 0.45 / 12 * param1;
            case 1:
               return 0.5 + 0.25 / 12 * param1;
            case 2:
               return 0.75 + 0.25 / 12 * param1;
            default:
               return 0.5;
         }
      }
      
      public static function checkWeaponAvailability(param1:Array) : Boolean
      {
         var _loc2_:Engine = null;
         var _loc3_:ObjectList = null;
         var _loc4_:String = null;
         var _loc5_:NewFacility = null;
         _loc2_ = Global.top.engine;
         _loc3_ = new ObjectList();
         _loc3_.buildFromArray(Global.top.gameShop.orbitalWeapons);
         for each(_loc4_ in param1)
         {
            if(_loc4_ != StringConsts.EMPTY && !_loc3_.hasItem(_loc4_))
            {
               _loc5_ = new NewFacility();
               _loc5_.card.slot_frame.gotoAndStop(_loc4_);
               _loc5_.x = 275.9;
               _loc5_.y = 285.6;
               _loc2_.playWindowUI.addChild(_loc5_);
               _loc5_.scaleX = _loc5_.scaleY = 0.01;
               Tweener.addTween(_loc5_,{
                  "scaleX":1,
                  "scaleY":1,
                  "time":1,
                  "transition":"linear"
               });
               Global.top.gameShop.setObritalWeapons(param1);
               Global.top.saveLevels();
               return true;
            }
         }
         return false;
      }
   }
}

