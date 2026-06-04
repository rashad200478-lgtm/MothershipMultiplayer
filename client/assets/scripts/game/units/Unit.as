package game.units
{
   import core.Global;
   import core.common.ObjectList;
   import core.common.Position;
   import flash.display.*;
   import game.*;
   import game.goals.LifeGoal;
   import game.logic.*;
   import game.ui.*;
   
   public final class Unit
   {
      
      public static const WALKING:int = 1;
      
      public static const ATTACK:int = 2;
      
      public static const DYING:int = 3;
      
      public static const WAITING:int = 4;
      
      public static const SITTING:int = 5;
      
      public var description:String;
      
      public var shot_point:Position = null;
      
      public var full_health:int = 100;
      
      private var bar:Shape = null;
      
      private var last_frontier:int = -1;
      
      public var weapon:Weapon = null;
      
      public var upgrade_level:int = 0;
      
      public var build_steps:int = 300;
      
      public var armor:uint = 1;
      
      public var type:String;
      
      public var sitting_ticks:int = 0;
      
      public var sprite:* = null;
      
      private var current_state:int = 0;
      
      private var sprite_width:int = 0;
      
      public var peaceful:Boolean = false;
      
      public var death_cost:int = 1;
      
      public var enemy_unit:Boolean = false;
      
      public var health:int = 0;
      
      public var velocity:Number = 5;
      
      public var hit_point:Position = null;
      
      public var life:LifeGoal = null;
      
      public function Unit(param1:String, param2:Boolean)
      {
         super();
         type = param1;
         enemy_unit = param2;
      }
      
      public function updateBar() : void
      {
         var sqcount:* = undefined;
         var hpercent:* = undefined;
         var frontier:* = undefined;
         var diameter:* = undefined;
         var rsize:* = undefined;
         var startx:* = undefined;
         var i:* = undefined;
         createUIElements();
         if(!isAlive)
         {
            bar.visible = false;
         }
         if(!sprite_width)
         {
            sprite_width = sprite.width;
         }
         with(bar)
         {
            sqcount = 6;
            hpercent = health * 100 / full_health;
            frontier = hpercent * sqcount / 100;
            if(frontier != last_frontier)
            {
               last_frontier = frontier;
               diameter = Math.max(sprite_width,sprite.height) + 8;
               graphics.clear();
               rsize = 4;
               startx = -rsize * sqcount / 2 + sprite_width / 2;
               graphics.lineStyle(1,0,0.5);
               i = 0;
               i = 0;
               while(i < sqcount)
               {
                  if(i < frontier)
                  {
                     if(isEnemy)
                     {
                        graphics.beginFill(16711680);
                     }
                     else
                     {
                        graphics.beginFill(65280);
                     }
                  }
                  graphics.drawRect(startx,-rsize,rsize,rsize);
                  if(i < frontier)
                  {
                     graphics.endFill();
                  }
                  startx += rsize;
                  ++i;
               }
            }
         }
      }
      
      public function moveSpriteToBackLayer() : void
      {
         sprite.parent.removeChild(sprite);
         Global.top.engine.gameBoard.getRoadUnitLayer(life.getCurrentRoad().index).back_layer.addChild(sprite);
      }
      
      public function get isPeaceful() : Boolean
      {
         return peaceful;
      }
      
      public function get currentState() : int
      {
         return current_state;
      }
      
      public function setWeapon(param1:Weapon) : void
      {
         weapon = param1;
         if(life)
         {
            life.resetWeapon();
         }
      }
      
      public function set currentState(param1:int) : void
      {
         current_state = param1;
      }
      
      public function setPause(param1:Boolean) : void
      {
         if(Boolean(sprite) && Boolean(sprite.inner))
         {
            if(param1)
            {
               sprite.inner.stop();
            }
            else
            {
               sprite.inner.play();
            }
         }
      }
      
      public function setSprite(param1:*) : void
      {
         if(!param1)
         {
            return;
         }
         sprite = param1;
         if(sprite.shot_point)
         {
            shot_point = new Position(sprite.shot_point.x,sprite.shot_point.y);
            sprite.shot_point.visible = false;
         }
         if(sprite.hit_point)
         {
            hit_point = new Position(sprite.hit_point.x,sprite.hit_point.y);
            sprite.hit_point.visible = false;
         }
      }
      
      private function createUIElements() : void
      {
         if(bar)
         {
            return;
         }
         bar = new Shape();
         sprite.addChild(bar);
         bar.x -= sprite.width / 2;
         bar.y -= sprite.height * 1.1;
         switch(type)
         {
            case StringConsts.MARINE:
            case StringConsts.MISSILE_MAN:
            case StringConsts.SPECIALIST:
            case StringConsts.STORM_TANK:
               bar.y = -40;
               break;
            case StringConsts.MINER_DROID:
               bar.y = -32;
               break;
            case StringConsts.CATERPILLAR:
               bar.y = -30;
         }
      }
      
      public function get isAlive() : Boolean
      {
         return health > 0;
      }
      
      public function hasSameRoad(param1:RoadPath) : Boolean
      {
         return life.getCurrentRoad() == param1;
      }
      
      public function coverForceField() : *
      {
         var _loc1_:Engine = null;
         var _loc2_:ObjectList = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         _loc1_ = Global.top.engine;
         if(_loc1_.gameBoard.forceFields[life.getCurrentRoad().index][0] > 0)
         {
            _loc2_ = _loc1_.gameBoard.forceFields[life.getCurrentRoad().index][1];
            _loc3_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_].forceField as MovieClip;
               if(_loc1_.gameBoard.unitMaskLayer.x + sprite.x > _loc4_.x - _loc4_.width / 2 && _loc1_.gameBoard.unitMaskLayer.x + sprite.x < _loc4_.x + _loc4_.width / 2)
               {
                  return _loc4_;
               }
               _loc3_++;
            }
         }
         return null;
      }
      
      public function getSynergy() : int
      {
         if(full_health < 0)
         {
            trace("ALARM!!!");
         }
         return full_health;
      }
      
      public function activate(param1:Engine) : void
      {
         health = full_health;
         life = new LifeGoal(param1,this);
         param1.goalSystem.add(life);
      }
      
      public function destroy() : void
      {
         health = 0;
      }
      
      public function get isEnemy() : Boolean
      {
         return enemy_unit;
      }
   }
}

