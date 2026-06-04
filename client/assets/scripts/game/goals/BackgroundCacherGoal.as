package game.goals
{
   import core.cache.CachedBitmapGoal;
   import core.common.ObjectList;
   import core.goal.Goal;
   import flash.display.Sprite;
   import flash.geom.Point;
   import game.StringConsts;
   import game.logic.EffectFactory;
   import game.logic.Engine;
   
   public class BackgroundCacherGoal extends Goal
   {
      
      private static const MAX_DELAY:int = 50;
      
      private var delay:int = 0;
      
      private var _engine:Engine = null;
      
      private var _hidden_layer:Sprite = null;
      
      private var _cache_sequence:ObjectList;
      
      public function BackgroundCacherGoal(param1:Engine)
      {
         var _loc2_:String = null;
         _engine = null;
         _hidden_layer = null;
         _cache_sequence = new ObjectList();
         delay = 0;
         super();
         _engine = param1;
         _hidden_layer = new Sprite();
         _engine.gameBoard.addChild(_hidden_layer);
         _hidden_layer.visible = false;
         for each(_loc2_ in _engine.cards)
         {
            if(StringConsts.CATERPILLAR == _loc2_)
            {
               addTest(BLUE_CATERPILLAR_DEATH);
               addTest(CATERPILLAR_IMPACT);
            }
            else if(StringConsts.STORM_TANK == _loc2_)
            {
               addTest(BLUE_STORM_TANK_DEATH);
               addTest(STORM_TANK_IMPACT);
            }
            else if(StringConsts.MISSILE_MAN == _loc2_)
            {
               addTest(MM_IMPACT);
            }
            else if(StringConsts.SPECIALIST == _loc2_)
            {
               addTest(SF_IMPACT);
            }
            else if(StringConsts.GRENADIER_DROID == _loc2_)
            {
               addTest(GRENADIER_DEATH);
            }
            else if(StringConsts.MINER_DROID == _loc2_)
            {
               addTest(MINER_EXPLOSION);
               addTest(MINE_EXPLOSION);
            }
         }
         for each(_loc2_ in _engine.enemyCards)
         {
            if(StringConsts.CATERPILLAR == _loc2_)
            {
               addTest(RED_CATERPILLAR_DEATH);
               addTest(CATERPILLAR_IMPACT);
            }
            else if(StringConsts.STORM_TANK == _loc2_)
            {
               addTest(RED_STORM_TANK_DEATH);
               addTest(STORM_TANK_IMPACT);
            }
            else if(StringConsts.MISSILE_MAN == _loc2_)
            {
               addTest(MM_IMPACT);
            }
            else if(StringConsts.SPECIALIST == _loc2_)
            {
               addTest(SF_IMPACT);
            }
            else if(StringConsts.GRENADIER_DROID == _loc2_)
            {
               addTest(GRENADIER_DEATH);
            }
            else if(StringConsts.MINER_DROID == _loc2_)
            {
               addTest(MINER_EXPLOSION);
               addTest(MINE_EXPLOSION);
            }
         }
         for each(_loc2_ in _engine.specials)
         {
            if(StringConsts.ARTILLERY_STRIKE == _loc2_)
            {
               addTest(ASTRIKE_DROP1);
               addTest(ASTRIKE_DROP2);
               addTest(ASTRIKE_DROP3);
            }
         }
         for each(_loc2_ in _engine.enemySpecials)
         {
            if(StringConsts.ARTILLERY_STRIKE == _loc2_)
            {
               addTest(ASTRIKE_DROP1);
               addTest(ASTRIKE_DROP2);
               addTest(ASTRIKE_DROP3);
            }
         }
      }
      
      private static function RED_STORM_TANK_DEATH(param1:*) : *
      {
         return EffectFactory.makeDeath(EffectFactory.RED_STORM_TANK_DEATH,new Point(200,300),62.3 / 1308.2,19.5 / 409.9,param1);
      }
      
      private static function STORM_TANK_IMPACT(param1:*) : *
      {
         return EffectFactory.makeImpact(EffectFactory.STORM_TANK_IMPACT,new Point(200,300),0.25,param1);
      }
      
      private static function MINE_EXPLOSION(param1:*) : *
      {
         return EffectFactory.makeExplosion(EffectFactory.MINE_EXPLOSION,new Point(200,300),0.2,param1);
      }
      
      private static function MM_IMPACT(param1:*) : *
      {
         return EffectFactory.makeImpact(EffectFactory.MM_IMPACT,new Point(200,300),0.25,param1);
      }
      
      private static function SF_IMPACT(param1:*) : *
      {
         return EffectFactory.makeImpact(EffectFactory.SF_IMPACT,new Point(200,300),0.25,param1);
      }
      
      private static function RED_CATERPILLAR_DEATH(param1:*) : *
      {
         return EffectFactory.makeDeath(EffectFactory.RED_CATERPILLAR_DEATH,new Point(200,300),98.4 / 655.7,34.2 / 228,param1);
      }
      
      private static function MINER_EXPLOSION(param1:*) : *
      {
         return EffectFactory.makeDeath(EffectFactory.MINER_EXPLOSION,new Point(200,300),1,1,param1);
      }
      
      private static function ASTRIKE_DROP1(param1:*) : *
      {
         var _loc2_:* = undefined;
         return EffectFactory.makeExplosion(EffectFactory.ASTRIKE_DROP,new Point(200,300),0.5,param1,1);
      }
      
      private static function ASTRIKE_DROP2(param1:*) : *
      {
         var _loc2_:* = undefined;
         return EffectFactory.makeExplosion(EffectFactory.ASTRIKE_DROP,new Point(200,300),0.5,param1,2);
      }
      
      private static function CATERPILLAR_IMPACT(param1:*) : *
      {
         return EffectFactory.makeImpact(EffectFactory.CATERPILLAR_IMPACT,new Point(200,300),0.3,param1);
      }
      
      private static function BLUE_STORM_TANK_DEATH(param1:*) : *
      {
         return EffectFactory.makeDeath(EffectFactory.BLUE_STORM_TANK_DEATH,new Point(200,300),-62.1 / 1135.6,19.9 / 364.6,param1);
      }
      
      private static function GRENADIER_DEATH(param1:*) : *
      {
         return EffectFactory.makeExplosion(EffectFactory.GRENADIER_DEATH,new Point(200,300),0.4,param1);
      }
      
      private static function BLUE_CATERPILLAR_DEATH(param1:*) : *
      {
         return EffectFactory.makeDeath(EffectFactory.BLUE_CATERPILLAR_DEATH,new Point(200,300),-98.4 / 655.7,34.2 / 228,param1);
      }
      
      private static function ASTRIKE_DROP3(param1:*) : *
      {
         var _loc2_:* = undefined;
         return EffectFactory.makeExplosion(EffectFactory.ASTRIKE_DROP,new Point(200,300),0.5,param1,3);
      }
      
      override public function advance() : void
      {
         if(delay > 0)
         {
            --delay;
            return;
         }
         if(0 == _cache_sequence.length)
         {
            deactivate();
            return;
         }
         runNextTest();
      }
      
      private function addTest(param1:Function) : void
      {
         if(!_cache_sequence.hasItem(param1))
         {
            _cache_sequence.push(param1);
         }
      }
      
      public function get hiddenLayer() : Sprite
      {
         return _hidden_layer;
      }
      
      private function runNextTest() : void
      {
         var _loc1_:Function = null;
         var _loc2_:* = undefined;
         _loc1_ = _cache_sequence.shift();
         _loc2_ = _loc1_(_hidden_layer);
         if(_loc2_)
         {
            if(_loc2_ is CachedBitmapGoal)
            {
               _loc2_.clearAssignedRoutines();
            }
            else
            {
               if(!_loc2_.params)
               {
                  _loc2_.params = new Object();
               }
               _loc2_.params.skipCrater = true;
            }
         }
         if(Boolean(_loc2_) && Boolean(_loc2_ is Object) && Boolean(_loc2_.hasOwnProperty("totalFrames")))
         {
            delay = _loc2_.totalFrames;
         }
         else
         {
            delay = MAX_DELAY;
         }
      }
   }
}

