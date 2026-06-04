package game.logic
{
   import core.common.ObjectList;
   import flash.display.*;
   import game.*;
   import game.goals.*;
   import game.ui.*;
   import game.units.*;
   
   public class GameBoard extends Sprite
   {
      
      private var road_layers:Array = [];
      
      private var _road_infos:Array = [];
      
      private var hatch_masks:Array = [];
      
      private var engine:Engine = null;
      
      private var roads:Array = [];
      
      private var layers:Array = [];
      
      private var ally_units:UnitCamp = new UnitCamp();
      
      private var _force_fields:Array = [];
      
      private var _send_all_counter:int = 0;
      
      private var _mines:UnitCamp = new UnitCamp();
      
      private var bullet_layer:Sprite = null;
      
      private var enemy_roads:Array = [];
      
      private var enemy_units:UnitCamp = new UnitCamp();
      
      public function GameBoard(param1:Engine)
      {
         super();
         engine = param1;
      }
      
      public function destroy() : void
      {
         engine.levelMap.removeChild(bullet_layer);
         bullet_layer = null;
      }
      
      public function sendFromAllHatches(param1:String, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(StringConsts.VULTURE == param1)
         {
            engine.playSound(SoundConsts.vulture);
         }
         else
         {
            engine.playSound(SoundConsts.doors_open);
         }
         if(param2)
         {
            engine.playWindowUI.logMessage("Enemy has sent Storm Attack of " + param1.replace("Droid","Robot") + "s");
         }
         else
         {
            _loc4_ = StringConsts.PHONETIC_ALPHABET[_send_all_counter];
            ++_send_all_counter;
            if(_send_all_counter >= StringConsts.PHONETIC_ALPHABET.length)
            {
               _send_all_counter = 0;
            }
            engine.playWindowUI.logMessage(param1.replace("Droid","Robot") + " " + _loc4_ + " Group Attack!");
         }
         _loc3_ = 0;
         while(_loc3_ < Hatches.ROAD_NUMBER)
         {
            createUnit(param1,_loc3_,param2,false);
            _loc3_++;
         }
      }
      
      public function create() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         _loc1_ = engine.levelMap;
         _loc2_ = 0;
         _loc3_ = int(_loc1_.numChildren);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc1_.getChildAt(_loc2_);
            if(_loc4_ is RoadPath)
            {
               _loc4_.initialize();
               _loc4_.visible = false;
               (_loc4_ as RoadPath).index = roads.length;
               roads.push(_loc4_);
               _force_fields.push([0,new ObjectList()]);
               _road_infos.push(new RoadInfo());
            }
            _loc2_++;
         }
         hatch_masks.push(engine.levelMap.hatch0_mask_layer);
         hatch_masks.push(engine.levelMap.hatch1_mask_layer);
         hatch_masks.push(engine.levelMap.hatch2_mask_layer);
         hatch_masks.push(engine.levelMap.hatch3_mask_layer);
         hatch_masks.push(engine.levelMap.hatch4_mask_layer);
         road_layers = [unitMaskLayer.masked_layer.road1,unitMaskLayer.masked_layer.road2,unitMaskLayer.masked_layer.road3,unitMaskLayer.masked_layer.road4,unitMaskLayer.masked_layer.road5];
         _loc1_.storm_hatch_arrows.visible = false;
         bullet_layer = new Sprite();
         engine.levelMap.addChild(bullet_layer);
      }
      
      public function get roadArray() : Array
      {
         return roads;
      }
      
      public function killUnit(param1:Unit, param2:String = null) : void
      {
         destroyUnit(param1);
         switch(param1.type)
         {
            case StringConsts.MARINE:
            case StringConsts.MISSILE_MAN:
            case StringConsts.SPECIALIST:
               engine.goalSystem.add(new DieMarineGoal(engine,param1,param2));
               break;
            case StringConsts.STORM_TANK:
            case StringConsts.CATERPILLAR:
               engine.goalSystem.add(new DieRobotGoal(engine,param1));
               break;
            case StringConsts.MINER_DROID:
               engine.goalSystem.add(new DieExplodeGoal(engine,param1));
               break;
            case StringConsts.GRENADIER_DROID:
            case StringConsts.MINE:
               engine.goalSystem.add(new DieGrenadierGoal(engine,param1));
         }
      }
      
      public function updateUnits() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         _loc1_ = 0;
         while(_loc1_ < ally_units.length)
         {
            ally_units[_loc1_].setPause(engine.gamePaused);
            _loc1_++;
         }
      }
      
      public function getRoadUnitLayer(param1:int) : *
      {
         return road_layers[param1];
      }
      
      public function get roadInfos() : Array
      {
         return _road_infos;
      }
      
      public function get allyUnits() : UnitCamp
      {
         return ally_units;
      }
      
      public function wipeUnit(param1:Unit) : void
      {
         if(param1.sprite.parent)
         {
            param1.sprite.parent.removeChild(param1.sprite);
         }
      }
      
      public function get bulletLayer() : Sprite
      {
         return bullet_layer;
      }
      
      public function get mines() : UnitCamp
      {
         return _mines;
      }
      
      public function getHatchMaskByRoad(param1:RoadPath) : Sprite
      {
         return hatch_masks[param1.index];
      }
      
      public function createUnit(param1:String, param2:int, param3:Boolean, param4:Boolean = true) : Unit
      {
         var _loc5_:Unit = null;
         var _loc6_:RoadPath = null;
         if(param4)
         {
            if(StringConsts.VULTURE == param1)
            {
               engine.playSound(SoundConsts.vulture);
            }
            else
            {
               engine.playSound(SoundConsts.doors_open);
            }
         }
         _loc5_ = UnitCreator.create(param1,param3);
         _loc6_ = null;
         if(param3)
         {
            _loc5_.sprite.scaleX = -1;
         }
         _loc6_ = roads[param2];
         if(StringConsts.VULTURE == param1)
         {
            engine.goalSystem.add(new VultureGoal(engine,_loc5_,_loc6_));
            return _loc5_;
         }
         getRoadUnitLayer(param2).front_layer.addChild(_loc5_.sprite);
         _loc5_.activate(engine);
         _loc5_.life.breathe();
         _loc5_.life.startMoving(_loc6_);
         _loc5_.life.addToInfos();
         if(param3)
         {
            enemy_units.push(_loc5_);
         }
         else
         {
            ally_units.push(_loc5_);
         }
         return _loc5_;
      }
      
      public function get unitMaskLayer() : MovieClip
      {
         return engine.levelMap.unit_mask_layer;
      }
      
      public function get specialTarget() : Sprite
      {
         return engine.levelMap.special_target;
      }
      
      public function get unitCard() : MovieClip
      {
         return engine.levelMap.unit_card_icon;
      }
      
      public function get forceFields() : Array
      {
         return _force_fields;
      }
      
      public function get enemyUnits() : UnitCamp
      {
         return enemy_units;
      }
      
      public function destroyUnit(param1:Unit) : void
      {
         param1.life.deactivate();
         if(param1.enemy_unit)
         {
            enemy_units.remove(param1);
         }
         else
         {
            ally_units.remove(param1);
         }
      }
   }
}

