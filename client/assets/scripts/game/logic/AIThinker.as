package game.logic
{
   import core.Global;
   import core.common.Map;
   import flash.geom.Point;
   import game.StringConsts;
   import game.goals.AISelectButtonGoal;
   import game.goals.ArtilleryStrikeGoal;
   import game.goals.ForceFieldGoal;
   import game.units.Unit;
   
   public class AIThinker
   {
      
      private var _buttons:Map;
      
      private var _selection_button_goal:AISelectButtonGoal = null;
      
      private var _level_complexity:Number = 0;
      
      private var _wait_for_target_unit:Unit = null;
      
      private var PAUSE:int = 0;
      
      private var _wait_times:int = 0;
      
      private var _engine:Engine = null;
      
      private var _wait_for_road:int = 0;
      
      private var _wait_for_send_type:String;
      
      private var _pause_likelihood:Number = 0;
      
      private var _specials:Map;
      
      private var _pause:int = 0;
      
      public function AIThinker()
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         _engine = null;
         _buttons = new Map();
         _specials = new Map();
         _selection_button_goal = null;
         PAUSE = 0;
         _pause = 0;
         _pause_likelihood = 0;
         _level_complexity = 0;
         _wait_times = 0;
         _wait_for_target_unit = null;
         _wait_for_road = 0;
         super();
         _engine = Global.top.engine;
         for each(_loc1_ in _engine.enemyCards)
         {
            if(_loc1_ != StringConsts.EMPTY)
            {
               _buttons.add(_loc1_,_engine.playWindowUI.enemyButons.getButtonByType(_loc1_));
               if(StringConsts.MINER_DROID == _loc1_)
               {
                  _wait_times = 5;
                  _wait_for_send_type = StringConsts.MINER_DROID;
                  _wait_for_target_unit = null;
                  _wait_for_road = anyRoad();
               }
            }
         }
         for each(_loc2_ in _engine.enemySpecials)
         {
            if(_loc2_ != StringConsts.EMPTY)
            {
               _specials.add(_loc2_,_engine.playWindowUI.enemyButons.getButtonByType(_loc2_));
            }
         }
      }
      
      private function doAStrike(param1:int, param2:Point, param3:int) : void
      {
         _engine.goalSystem.add(new ArtilleryStrikeGoal(param1,param2,param3));
         _engine.playWindowUI.enemyButons.getButtonByType(StringConsts.ARTILLERY_STRIKE).ticks_goal.reset();
      }
      
      private function dropFFStrike() : void
      {
         var _loc1_:Unit = null;
         var _loc2_:Point = null;
         if(_engine.gameBoard.enemyUnits.length == 0 || Boolean(_selection_button_goal) && Boolean(_selection_button_goal.alive))
         {
            return;
         }
         _loc1_ = getStrongestAttackingUnit();
         if(_loc1_)
         {
            _loc2_ = new Point(_loc1_.sprite.x,_loc1_.sprite.y);
            _selection_button_goal = new AISelectButtonGoal(StringConsts.FORCE_FIELD,this,doFF,_loc2_,_loc1_.life.getCurrentRoad().index);
            _engine.goalSystem.add(_selection_button_goal);
         }
      }
      
      public function think() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         if(Boolean(_selection_button_goal) && _selection_button_goal.alive)
         {
            return;
         }
         if(PAUSE > 0)
         {
            if(_pause > 0)
            {
               --_pause;
               return;
            }
         }
         checkSpecials();
         if(Boolean(_selection_button_goal) && _selection_button_goal.alive)
         {
            return;
         }
         if(_wait_times > 0)
         {
            if(!(Boolean(_wait_for_target_unit) && !_wait_for_target_unit.isAlive))
            {
               --_wait_times;
               if(0 == _wait_times)
               {
                  _wait_for_target_unit = null;
                  _selection_button_goal = new AISelectButtonGoal(_wait_for_send_type,this,createUnit,_wait_for_send_type,_wait_for_road);
                  _engine.goalSystem.add(_selection_button_goal);
               }
               return;
            }
            _wait_for_target_unit = null;
            _wait_times = 0;
         }
         _loc1_ = Math.random();
         _loc2_ = 0;
         if(_loc1_ > _level_complexity / 2)
         {
            _loc2_ = weakestRoad();
         }
         else
         {
            _loc2_ = getMaxSynergyGapRoad();
         }
         sendUnit(_loc2_);
         if(PAUSE > 0)
         {
            if(Math.random() < _pause_likelihood)
            {
               _pause = PAUSE - Math.random() * PAUSE / 2 + 1;
            }
         }
      }
      
      private function doFF(param1:*, param2:int) : void
      {
         _engine.goalSystem.add(new ForceFieldGoal(param1,param2,true));
         _engine.playWindowUI.enemyButons.getButtonByType(StringConsts.FORCE_FIELD).ticks_goal.reset();
      }
      
      private function doNuke() : void
      {
         _engine.playWindowUI.enemyButons.getButtonByType(StringConsts.NUCLEAR_MISSILE).ticks_goal.reset();
         _engine.makeSpecialEffect(StringConsts.NUCLEAR_MISSILE);
      }
      
      public function set level_complexity(param1:Number) : void
      {
         _level_complexity = param1;
         if(Global.top.engine.lastLevelIndex > 0 || Global.top.engine.lastZone > 0)
         {
            if(_level_complexity < 0.4)
            {
               _level_complexity = 0.4;
            }
         }
      }
      
      private function weakestRoad() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = anyRoad();
         _loc2_ = 99999999;
         _loc3_ = 0;
         while(_loc3_ < _engine.gameBoard.roadInfos.length)
         {
            _loc4_ = (_engine.gameBoard.roadInfos[_loc3_] as RoadInfo).player_synergy;
            if(_loc4_ > 0 && _loc4_ < _loc2_)
            {
               _loc1_ = _loc3_;
               _loc2_ = _loc4_;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function sendUnit(param1:int) : void
      {
         var _loc2_:Unit = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc6_:* = undefined;
         _loc2_ = getFarthestUnit(param1);
         _loc4_ = false;
         _loc5_ = Math.random();
         if(Boolean(_loc2_) && _loc5_ <= _level_complexity)
         {
            _loc3_ = findBestResitance(_loc2_.type);
         }
         else
         {
            _loc3_ = anyCard();
            _loc4_ = true;
         }
         _loc6_ = _buttons.get(_loc3_);
         if(_loc6_)
         {
            if(_loc6_.ticks_goal.ready)
            {
               _selection_button_goal = new AISelectButtonGoal(_loc3_,this,createUnit,_loc3_,param1);
               _engine.goalSystem.add(_selection_button_goal);
            }
            else if(_loc4_ && Boolean(_loc2_))
            {
               _wait_times = _loc6_.ticks_goal.ticksRest / Global.mainStage.frameRate;
               _wait_for_send_type = _loc3_;
               _wait_for_target_unit = _loc2_;
               _wait_for_road = param1;
            }
         }
      }
      
      private function dropNukeLogic() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(_engine.gameBoard.allyUnits.length == 0 || Boolean(_selection_button_goal) && Boolean(_selection_button_goal.alive))
         {
            return;
         }
         _loc1_ = 0;
         _loc2_ = 0;
         _loc3_ = 0;
         while(_loc3_ < _engine.gameBoard.roadInfos.length)
         {
            _loc1_ += (_engine.gameBoard.roadInfos[_loc3_] as RoadInfo).player_synergy;
            _loc2_ += (_engine.gameBoard.roadInfos[_loc3_] as RoadInfo).enemy_synergy;
            _loc3_++;
         }
         _loc4_ = _engine.playWindowUI.balanceBar.balance > 0.5 && 5 - int((1 - _engine.playWindowUI.balanceBar.balance) * 5 / 0.5) > 3;
         if(_loc1_ > _loc2_ * 1.2 || _loc4_)
         {
            _selection_button_goal = new AISelectButtonGoal(StringConsts.NUCLEAR_MISSILE,this,doNuke);
            _engine.goalSystem.add(_selection_button_goal);
         }
      }
      
      private function checkMinerLogic(param1:int) : String
      {
         var _loc2_:Unit = null;
         if((_engine.gameBoard.roadInfos[param1] as RoadInfo).player_synergy > 0)
         {
            _loc2_ = getFarthestUnit(param1);
            if(_loc2_)
            {
               return findBestResitance(_loc2_.type);
            }
         }
         return StringConsts.MINER_DROID;
      }
      
      private function anyCard() : String
      {
         var _loc1_:int = 0;
         _loc1_ = int((Math.random() - 0.01) * _buttons.size());
         return _buttons.values[_loc1_].unit_type;
      }
      
      public function setThinkingPause(param1:int, param2:Number) : void
      {
         PAUSE = param1;
         _pause = 0;
         _pause_likelihood = param2;
      }
      
      private function getStrongestAttackingUnit() : Unit
      {
         var _loc1_:Number = NaN;
         var _loc2_:Unit = null;
         var _loc3_:int = 0;
         var _loc4_:Unit = null;
         var _loc5_:Array = null;
         _loc1_ = 0;
         _loc2_ = null;
         _loc3_ = 0;
         while(_loc3_ < _engine.gameBoard.enemyUnits.length)
         {
            _loc4_ = _engine.gameBoard.enemyUnits[_loc3_];
            _loc5_ = _engine.specialTargeting.getRangeFor(_loc4_.life.getCurrentRoad().index);
            if(_loc4_.life.isAttacking)
            {
               if(!(Boolean(_loc5_) && (_loc4_.sprite.x < _loc5_[0] || _loc4_.sprite.x > _loc5_[1])))
               {
                  if(_loc4_.health < _loc4_.full_health && _loc4_.full_health > _loc1_)
                  {
                     _loc1_ = _loc4_.full_health;
                     _loc2_ = _loc4_;
                  }
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function createUnit(param1:String, param2:int) : void
      {
         if(_engine.enemyStormGoal.isWaiting)
         {
            _engine.gameBoard.sendFromAllHatches(param1,true);
            _engine.enemyStormGoal.reset();
         }
         else
         {
            _engine.gameBoard.createUnit(param1,param2,true);
         }
         _engine.playWindowUI.enemyButons.buttonSetGoal.resetAll();
      }
      
      private function dropArtilleryStrike() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Unit = null;
         if(_engine.gameBoard.allyUnits.length == 0 || Boolean(_selection_button_goal) && Boolean(_selection_button_goal.alive))
         {
            return;
         }
         _loc1_ = getMaxSynergyGapRoad();
         _loc2_ = getFarthestUnit(_loc1_,_engine.specialTargeting.getRangeFor(_loc1_));
         if(_loc2_)
         {
            _selection_button_goal = new AISelectButtonGoal(StringConsts.ARTILLERY_STRIKE,this,doAStrike,_loc1_,new Point(_loc2_.sprite.x,_loc2_.sprite.y),_engine.astrikeDropCount);
            _engine.goalSystem.add(_selection_button_goal);
         }
      }
      
      private function checkSpecials() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = null;
         _loc1_ = _specials.get(StringConsts.ARTILLERY_STRIKE);
         if((Boolean(_loc1_)) && Boolean(_loc1_.ticks_goal.ready))
         {
            dropArtilleryStrike();
         }
         _loc1_ = _specials.get(StringConsts.FORCE_FIELD);
         if((Boolean(_loc1_)) && Boolean(_loc1_.ticks_goal.ready))
         {
            dropFFStrike();
         }
         _loc1_ = _specials.get(StringConsts.NUCLEAR_MISSILE);
         if((Boolean(_loc1_)) && Boolean(_loc1_.ticks_goal.ready))
         {
            dropNukeLogic();
         }
      }
      
      public function get level_complexity() : Number
      {
         return _level_complexity;
      }
      
      private function findBestResitance(param1:String) : String
      {
         var _loc2_:* = undefined;
         _loc2_ = null;
         if(StringConsts.MARINE == param1)
         {
            _loc2_ = _buttons.get(StringConsts.STORM_TANK);
            if(_loc2_)
            {
               return _loc2_.unit_type;
            }
         }
         if(StringConsts.MISSILE_MAN == param1)
         {
            _loc2_ = _buttons.get(StringConsts.MARINE);
            if(_loc2_)
            {
               return _loc2_.unit_type;
            }
         }
         if(StringConsts.SPECIALIST == param1)
         {
            _loc2_ = _buttons.get(StringConsts.STORM_TANK);
            if(_loc2_)
            {
               return _loc2_.unit_type;
            }
         }
         if(StringConsts.STORM_TANK == param1)
         {
            _loc2_ = _buttons.get(StringConsts.MISSILE_MAN);
            if(_loc2_)
            {
               return _loc2_.unit_type;
            }
         }
         if(StringConsts.VULTURE == param1)
         {
            _loc2_ = _buttons.get(StringConsts.STORM_TANK);
            if(_loc2_)
            {
               return _loc2_.unit_type;
            }
         }
         if(StringConsts.CATERPILLAR == param1)
         {
            _loc2_ = _buttons.get(StringConsts.SPECIALIST);
            if(_loc2_)
            {
               return _loc2_.unit_type;
            }
         }
         if(StringConsts.GRENADIER_DROID == param1)
         {
            _loc2_ = _buttons.get(StringConsts.SPECIALIST);
            if(_loc2_)
            {
               return _loc2_.unit_type;
            }
         }
         if(StringConsts.MINER_DROID == param1)
         {
            _loc2_ = _buttons.get(StringConsts.MISSILE_MAN);
            if(_loc2_)
            {
               return _loc2_.unit_type;
            }
            _loc2_ = _buttons.get(StringConsts.VULTURE);
            if(_loc2_)
            {
               return _loc2_.unit_type;
            }
            _loc2_ = _buttons.get(StringConsts.MARINE);
            if(_loc2_)
            {
               return _loc2_.unit_type;
            }
            _loc2_ = _buttons.get(StringConsts.STORM_TANK);
            if(_loc2_)
            {
               return _loc2_.unit_type;
            }
         }
         if(Math.random() < 0.25 && (Boolean(_loc2_ = _buttons.get(StringConsts.CATERPILLAR))))
         {
            return _loc2_.unit_type;
         }
         if(Math.random() < 0.5 && (Boolean(_loc2_ = _buttons.get(StringConsts.VULTURE))))
         {
            return _loc2_.unit_type;
         }
         if(Math.random() < 0.75 && (Boolean(_loc2_ = _buttons.get(StringConsts.MARINE))))
         {
            return _loc2_.unit_type;
         }
         if(Math.random() < 0.85 && (Boolean(_loc2_ = _buttons.get(StringConsts.GRENADIER_DROID))))
         {
            return _loc2_.unit_type;
         }
         return anyCard();
      }
      
      private function anyRoad() : int
      {
         return (Math.random() - 0.01) * 5;
      }
      
      private function getFarthestUnit(param1:int, param2:Array = null) : Unit
      {
         var _loc3_:Number = NaN;
         var _loc4_:Unit = null;
         var _loc5_:int = 0;
         var _loc6_:Unit = null;
         _loc3_ = 0;
         _loc4_ = null;
         _loc5_ = 0;
         while(_loc5_ < _engine.gameBoard.allyUnits.length)
         {
            _loc6_ = _engine.gameBoard.allyUnits[_loc5_];
            if(_loc6_.life.getCurrentRoad().index == param1)
            {
               if(!(Boolean(param2) && (_loc6_.sprite.x < param2[0] || _loc6_.sprite.x > param2[1])))
               {
                  if(_loc6_.sprite.x > _loc3_)
                  {
                     _loc3_ = Number(_loc6_.sprite.x);
                     _loc4_ = _loc6_;
                  }
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function getMaxSynergyGapRoad() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = (Math.random() - 0.01) * 5;
         _loc2_ = -1;
         _loc3_ = 0;
         while(_loc3_ < _engine.gameBoard.roadInfos.length)
         {
            _loc4_ = (_engine.gameBoard.roadInfos[_loc3_] as RoadInfo).player_synergy - (_engine.gameBoard.roadInfos[_loc3_] as RoadInfo).enemy_synergy;
            if(_loc4_ > _loc2_)
            {
               _loc1_ = _loc3_;
               _loc2_ = _loc4_;
            }
            _loc3_++;
         }
         return _loc1_;
      }
   }
}

