package game.logic
{
   import core.Global;
   import core.cache.CachedBitmapGoal;
   import core.cache.CachedMovieClip;
   import core.cache.MovieClipCache;
   import core.cache.MovieClipRenderGoal;
   import core.common.ObjectList;
   import core.goal.IGoal;
   import flash.geom.Point;
   import game.SoundConsts;
   
   public class EffectFactory
   {
      
      public static const MINE_EXPLOSION:int = 1;
      
      public static const HATCH_EXPLOSION:int = 2;
      
      public static const HATCH_EXPLOSION_ENEMY:int = 17;
      
      public static const ASTRIKE_DROP:int = 3;
      
      public static const NUCLEAR_MISSILE:int = 5;
      
      public static const GRENADIER_DEATH:int = 10;
      
      public static const MARINE_IMPACT:int = 4;
      
      public static const MM_IMPACT:int = 6;
      
      public static const SF_IMPACT:int = 7;
      
      public static const STORM_TANK_IMPACT:int = 8;
      
      public static const CATERPILLAR_IMPACT:int = 9;
      
      public static const BLUE_CATERPILLAR_DEATH:int = 11;
      
      public static const RED_CATERPILLAR_DEATH:int = 12;
      
      public static const MINER_EXPLOSION:int = 14;
      
      public static const BLUE_STORM_TANK_DEATH:int = 15;
      
      public static const RED_STORM_TANK_DEATH:int = 16;
      
      public static const NUCLEAR_MISSILE_COUNTING:int = 18;
      
      public static const GRAND_STORM:int = 19;
      
      private static var pool:ObjectList = new ObjectList();
      
      public function EffectFactory()
      {
         super();
      }
      
      public static function setPause(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in pool)
         {
            if(param1)
            {
               _loc2_.stop();
            }
            else
            {
               _loc2_.play();
            }
         }
      }
      
      private static function cacheHelper(param1:String, param2:Point, param3:Number, param4:Number, param5:*, param6:Function, param7:Function = null, param8:Function = null, param9:int = 0, param10:int = 0) : *
      {
         var _loc11_:CachedMovieClip = null;
         var _loc12_:* = undefined;
         var _loc13_:CachedBitmapGoal = null;
         var _loc14_:MovieClipRenderGoal = null;
         _loc11_ = null;
         _loc12_ = null;
         _loc11_ = MovieClipCache.getCached(param1);
         if((Boolean(_loc11_)) && _loc11_.alreadyCached)
         {
            _loc13_ = CachedBitmapGoal.draw(_loc11_,param2,param5);
            if(Boolean(param7))
            {
               param7(_loc13_);
            }
            return _loc13_;
         }
         _loc12_ = param6();
         if(!_loc11_)
         {
            _loc14_ = new MovieClipRenderGoal(_loc12_,param1,param9,param10);
            if(Boolean(param8))
            {
               param8(_loc14_,_loc12_);
            }
            Global.top.engine.goalSystem.add(_loc14_);
         }
         else
         {
            MovieClipRenderGoal.cleanScaffolds(_loc12_);
         }
         createEffect(_loc12_,param2,param3,param4,param5);
         return _loc12_;
      }
      
      public static function cleanPool() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in pool)
         {
            if(_loc1_ is IGoal)
            {
               _loc1_.deactivate();
            }
            else
            {
               _loc1_.stop();
            }
         }
         pool.clear();
      }
      
      public static function makeExplosion(param1:int, param2:Point, param3:Number = 1, param4:* = null, param5:int = 0) : *
      {
         var cache_id:String = null;
         var cached:CachedMovieClip = null;
         var clip:* = undefined;
         var rand_value:Number = NaN;
         var cbg:CachedBitmapGoal = null;
         var type:int = param1;
         var point:Point = param2;
         var scale_factor:Number = param3;
         var layer:* = param4;
         var res:int = param5;
         if(null == layer)
         {
            layer = Global.top.engine.gameBoard;
         }
         cached = null;
         clip = null;
         switch(type)
         {
            case GRENADIER_DEATH:
               return cacheHelper("GRENADIER_DEATH",point,scale_factor,scale_factor,layer,function():*
               {
                  return new GrenadierExplosion();
               },function(param1:*):*
               {
                  param1.assignRoutine(5,EffectRoutines.AddGrenadierCrater);
               },null,30,30);
            case MINE_EXPLOSION:
               return cacheHelper("MINE_EXPLOSION",point,scale_factor,scale_factor,layer,function():*
               {
                  return new MineExplosion();
               },function(param1:*):*
               {
                  param1.assignRoutine(3,EffectRoutines.AddMineCrater);
               },null,30,30);
            case HATCH_EXPLOSION:
               return cacheHelper("HATCH_EXPLOSION",point,scale_factor,scale_factor,layer,function():*
               {
                  return new HatchExplosion();
               },null,null,40,15);
            case HATCH_EXPLOSION_ENEMY:
               return cacheHelper("HATCH_EXPLOSION_ENEMY",point,scale_factor,scale_factor,layer,function():*
               {
                  return new HatchExplosion();
               },null,null,50,15);
            case ASTRIKE_DROP:
               rand_value = Math.random();
               cache_id = ASTRIKE_DROP.toString();
               if(res != 0)
               {
                  if(1 == res)
                  {
                     cache_id += "1";
                  }
                  else if(2 == res)
                  {
                     cache_id += "2";
                  }
                  else if(3 == res)
                  {
                     cache_id += "3";
                  }
               }
               else
               {
                  if(rand_value <= 0.33)
                  {
                     cache_id += "1";
                  }
                  else if(rand_value <= 0.66)
                  {
                     cache_id += "2";
                  }
                  else
                  {
                     cache_id += "3";
                  }
                  Global.top.engine.playSound(SoundConsts.artillery_strike);
               }
               cached = MovieClipCache.getCached(cache_id);
               if(Boolean(cached) && cached.alreadyCached)
               {
                  cbg = CachedBitmapGoal.draw(cached,point,layer);
                  cbg.assignRoutine(6,EffectRoutines.AddCrater);
                  return cbg;
               }
               if(res != 0)
               {
                  if(1 == res)
                  {
                     clip = new AStrike1();
                  }
                  else if(2 == res)
                  {
                     clip = new AStrike2();
                  }
                  else if(3 == res)
                  {
                     clip = new AStrike3();
                  }
               }
               else if(rand_value <= 0.33)
               {
                  clip = new AStrike1();
               }
               else if(rand_value <= 0.66)
               {
                  clip = new AStrike2();
               }
               else
               {
                  clip = new AStrike3();
               }
               if(!cached)
               {
                  Global.top.engine.goalSystem.add(new MovieClipRenderGoal(clip,cache_id,40,30));
               }
               else
               {
                  MovieClipRenderGoal.cleanScaffolds(clip);
               }
               createEffect(clip,point,scale_factor,scale_factor,layer);
               return clip;
               break;
            case NUCLEAR_MISSILE:
               Global.top.engine.playSound(SoundConsts.artillery_strike);
               Global.top.engine.playSound(SoundConsts.explosion);
               Global.top.engine.playSound(SoundConsts.explosion1);
               Global.top.engine.playSound(SoundConsts.hit1);
               Global.top.engine.playSound(SoundConsts.hit1);
               Global.top.engine.playSound(SoundConsts.hit1);
               Global.top.engine.playSound(SoundConsts.hit1);
               Global.top.engine.playSound(SoundConsts.hit1);
               Global.top.engine.playSound(SoundConsts.hit1);
               createEffect(new Nuke(),point,scale_factor,scale_factor,layer);
               break;
            case NUCLEAR_MISSILE_COUNTING:
               Global.top.engine.playSound(SoundConsts.nuclear_counting);
               createEffect(new NukeCounting(),point,scale_factor,scale_factor,layer);
               break;
            case GRAND_STORM:
               createEffect(new GrandStormMessage(),point,scale_factor,scale_factor,layer);
         }
         return null;
      }
      
      public static function addCraterFrom(param1:*, param2:Number = 0.3, param3:Number = 0.5) : Crater
      {
         var _loc4_:Engine = null;
         var _loc5_:Crater = null;
         if(Boolean(param1.hasOwnProperty("params")) && Boolean(param1.params.skipCrater))
         {
            return null;
         }
         _loc4_ = Global.top.engine;
         _loc5_ = new Crater();
         _loc5_.x = param1.x;
         _loc5_.y = param1.y;
         _loc5_.scaleX = _loc5_.scaleY = param2;
         _loc5_.alpha = param3;
         _loc4_.gameBoard.unitMaskLayer.masked_layer.crater_layer.addChild(_loc5_);
         _loc4_.gameBoard.unitMaskLayer.masked_layer.crater_layer.cacheAsBitmap = true;
         return _loc5_;
      }
      
      public static function makeDeath(param1:int, param2:Point, param3:Number = 1, param4:Number = 1, param5:* = null) : *
      {
         var type:int = param1;
         var point:Point = param2;
         var scale_x:Number = param3;
         var scale_y:Number = param4;
         var layer:* = param5;
         if(null == layer)
         {
            layer = Global.top.engine.gameBoard;
         }
         switch(type)
         {
            case BLUE_CATERPILLAR_DEATH:
               return cacheHelper("BLUE_CATERPILLAR_DEATH",point,scale_x,scale_y,layer,function():*
               {
                  return new BlueCaterpilarDeath();
               },null,function(param1:*, param2:*):*
               {
                  param1.setFinalCondition(MovieClipRenderGoal.TOTAL_FRAMES,{"totalFrames":param2.totalFrames});
               },30,20);
            case RED_CATERPILLAR_DEATH:
               return cacheHelper("RED_CATERPILLAR_DEATH",point,scale_x,scale_y,layer,function():*
               {
                  return new RedCaterpilarDeath();
               },null,function(param1:*, param2:*):*
               {
                  param1.setFinalCondition(MovieClipRenderGoal.TOTAL_FRAMES,{"totalFrames":param2.totalFrames});
               },20,30);
            case BLUE_STORM_TANK_DEATH:
               return cacheHelper("BLUE_STORM_TANK_DEATH",point,scale_x,scale_y,layer,function():*
               {
                  return new BlueStormTankDeath();
               },null,function(param1:*, param2:*):*
               {
                  param1.setFinalCondition(MovieClipRenderGoal.TOTAL_FRAMES,{"totalFrames":param2.totalFrames});
               },25,20);
            case RED_STORM_TANK_DEATH:
               return cacheHelper("RED_STORM_TANK_DEATH",point,scale_x,scale_y,layer,function():*
               {
                  return new RedStormTankDeath();
               },null,function(param1:*, param2:*):*
               {
                  param1.setFinalCondition(MovieClipRenderGoal.TOTAL_FRAMES,{"totalFrames":param2.totalFrames});
               },25,20);
            case MINER_EXPLOSION:
               return cacheHelper("MINER_EXPLOSION",point,scale_x,scale_y,layer,function():*
               {
                  return new MinerExplosion();
               },null,function(param1:*, param2:*):*
               {
                  param1.setFinalCondition(MovieClipRenderGoal.TOTAL_FRAMES,{"totalFrames":17});
               },40,40);
            default:
               return null;
         }
      }
      
      public static function effectFinished(param1:*) : void
      {
         param1.parent.removeChild(param1);
         pool.remove(param1);
      }
      
      private static function createEffect(param1:*, param2:Point, param3:Number, param4:Number, param5:*) : void
      {
         param1.x = param2.x;
         param1.y = param2.y;
         param1.scaleX = param3;
         param1.scaleY = param4;
         param5.addChild(param1);
         param1.play();
         pool.push(param1);
      }
      
      public static function makeImpact(param1:int, param2:Point, param3:Number = 1, param4:* = null) : void
      {
         var type:int = param1;
         var point:Point = param2;
         var scale_factor:Number = param3;
         var layer:* = param4;
         if(null == layer)
         {
            layer = Global.top.engine.gameBoard;
         }
         switch(type)
         {
            case MARINE_IMPACT:
               cacheHelper("MARINE_IMPACT",point,scale_factor,scale_factor,layer,function():*
               {
                  return new MarineBulletImpact();
               },null,null,5,5);
               break;
            case MM_IMPACT:
               cacheHelper("MM_IMPACT",point,scale_factor,scale_factor,layer,function():*
               {
                  return new MMImpact();
               },null,null,20,20);
               break;
            case SF_IMPACT:
               cacheHelper("SF_IMPACT",point,scale_factor,scale_factor,layer,function():*
               {
                  return new SFImpact();
               },null,null,5,5);
               break;
            case STORM_TANK_IMPACT:
               cacheHelper("STORM_TANK_IMPACT",point,scale_factor,scale_factor,layer,function():*
               {
                  return new StormTankImpact();
               },null,null,35,25);
               break;
            case CATERPILLAR_IMPACT:
               cacheHelper("CATERPILLAR_IMPACT",point,scale_factor,scale_factor,layer,function():*
               {
                  return new CaterpillarImpact();
               },null,null,40,30);
         }
      }
   }
}

