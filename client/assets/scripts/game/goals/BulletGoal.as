package game.goals
{
   import core.common.ObjectList;
   import core.goal.Goal;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import game.*;
   import game.logic.*;
   import game.units.*;
   
   public class BulletGoal extends Goal
   {
      
      private var sprite:Sprite;
      
      private var fly_away_mode:Boolean = false;
      
      private var gip:int = 0;
      
      private var engine:Engine = null;
      
      private var explosion_ticks:int = 0;
      
      private var hit_position:Point = null;
      
      private var bullet:* = null;
      
      private var shot_position:Point = null;
      
      private var _assauler_is_under_field:Boolean = false;
      
      private var assaulter:Unit = null;
      
      private var subject:Unit = null;
      
      private var _force_fields:ObjectList = null;
      
      private var _kill_type:String;
      
      public function BulletGoal(param1:Engine, param2:Unit, param3:Unit)
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         engine = null;
         assaulter = null;
         subject = null;
         bullet = null;
         gip = 0;
         hit_position = null;
         shot_position = null;
         sprite = new Sprite();
         explosion_ticks = 0;
         fly_away_mode = false;
         _force_fields = null;
         _assauler_is_under_field = false;
         super();
         engine = param1;
         assaulter = param2;
         subject = param3;
         _kill_type = DieMarineGoal.DEATH_BY_BULLET;
         switch(assaulter.type)
         {
            case StringConsts.CATERPILLAR:
            case StringConsts.STORM_TANK:
            case StringConsts.GRENADIER_DROID:
            case StringConsts.MINER_DROID:
               _kill_type = DieMarineGoal.DEATH_BY_EXPLOSION;
         }
         switch(assaulter.type)
         {
            case StringConsts.MARINE:
               engine.playSound(SoundConsts.hit1);
               break;
            case StringConsts.MISSILE_MAN:
               engine.playSound(SoundConsts.mm_shot);
               break;
            case StringConsts.SPECIALIST:
               engine.playSound(SoundConsts.specialist_attack);
               break;
            case StringConsts.STORM_TANK:
               engine.playSound(SoundConsts.hit1);
         }
         bullet = UnitCreator.getBullet(assaulter.type,assaulter.isEnemy);
         sprite.addChild(bullet);
         bullet.x -= bullet.width / 2;
         bullet.y -= bullet.height / 2;
         hit_position = new Point(subject.sprite.x + subject.hit_point.x * subject.sprite.scaleX,subject.sprite.y + subject.hit_point.y * subject.sprite.scaleY);
         determineShotPosition();
         sprite.x = shot_position.x;
         sprite.y = shot_position.y;
         sprite.rotation = Math.atan2(hit_position.y - shot_position.y,hit_position.x - shot_position.x) / Math.PI * 180 - 90;
         _loc4_ = hit_position.x - shot_position.x;
         _loc5_ = hit_position.y - shot_position.y;
         gip = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
         engine.gameBoard.bulletLayer.addChild(sprite);
         _force_fields = engine.gameBoard.forceFields[subject.life.getCurrentRoad().index][1];
      }
      
      override public function advance() : void
      {
         var _loc1_:Number = NaN;
         if(fly_away_mode)
         {
            bullet.y += assaulter.weapon.bullet_speed;
            checkForceField();
            if(bullet.y > Consts.ScreenWidth)
            {
               deactivate();
            }
            return;
         }
         gip -= assaulter.weapon.bullet_speed;
         if(gip <= 0)
         {
            if(!subject.isAlive)
            {
               fly_away_mode = true;
            }
            else
            {
               bullet.y += assaulter.weapon.bullet_speed + gip;
               _loc1_ = 1;
               if(assaulter.type == StringConsts.MISSILE_MAN)
               {
                  if(subject.type == StringConsts.STORM_TANK || StringConsts.MINER_DROID == subject.type)
                  {
                     _loc1_ = 1.5;
                  }
                  else if(StringConsts.GRENADIER_DROID == subject.type)
                  {
                     _loc1_ = 1.5;
                  }
                  else if(subject.type == StringConsts.MARINE || subject.type == StringConsts.SPECIALIST)
                  {
                     _loc1_ = 0.5;
                  }
                  else if(StringConsts.MISSILE_MAN == subject.type)
                  {
                     _loc1_ = 0.82;
                  }
               }
               else if(assaulter.type == StringConsts.STORM_TANK)
               {
                  if(subject.type == StringConsts.MISSILE_MAN)
                  {
                     _loc1_ = 0.7;
                  }
                  else if(subject.type == StringConsts.GRENADIER_DROID || subject.type == StringConsts.MARINE)
                  {
                     _loc1_ = 1.25;
                  }
               }
               else if(assaulter.type == StringConsts.SPECIALIST)
               {
                  if(StringConsts.CATERPILLAR == subject.type)
                  {
                     _loc1_ = 1.35;
                  }
                  else
                  {
                     _loc1_ = 0.6;
                  }
               }
               else if(assaulter.type == StringConsts.MARINE)
               {
                  if(StringConsts.MISSILE_MAN == subject.type)
                  {
                     _loc1_ = 1.25;
                  }
                  else if(StringConsts.STORM_TANK == subject.type)
                  {
                     _loc1_ = 0.9;
                  }
               }
               switch(assaulter.type)
               {
                  case StringConsts.MARINE:
                     engine.playSound(SoundConsts.marine_shot);
                     break;
                  case StringConsts.MISSILE_MAN:
                     engine.playSound(SoundConsts.explosion1);
                     break;
                  case StringConsts.STORM_TANK:
                     engine.playSound(SoundConsts.hit);
               }
               engine.hitUnit(assaulter.weapon.damage * _loc1_,subject,_kill_type);
               setToExplosion();
            }
         }
         else
         {
            bullet.y += assaulter.weapon.bullet_speed;
            checkForceField();
         }
      }
      
      public function setToFlyAway() : void
      {
         fly_away_mode = true;
      }
      
      private function setToExplosion() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         bullet.visible = false;
         _loc1_ = EffectFactory.MARINE_IMPACT;
         _loc2_ = 1;
         switch(assaulter.type)
         {
            case StringConsts.MISSILE_MAN:
               _loc1_ = EffectFactory.MM_IMPACT;
               _loc2_ = 0.25;
               break;
            case StringConsts.SPECIALIST:
               _loc1_ = EffectFactory.SF_IMPACT;
               _loc2_ = 0.25;
               break;
            case StringConsts.STORM_TANK:
               _loc1_ = EffectFactory.STORM_TANK_IMPACT;
               _loc2_ = 0.25;
         }
         if(gip <= 0)
         {
            EffectFactory.makeImpact(_loc1_,hit_position,_loc2_,engine.gameBoard.unitMaskLayer);
         }
         else
         {
            _loc3_ = sprite.localToGlobal(new Point(bullet.x,bullet.y));
            _loc4_ = engine.gameBoard.unitMaskLayer.globalToLocal(_loc3_);
            EffectFactory.makeImpact(_loc1_,_loc4_,_loc2_,engine.gameBoard.unitMaskLayer);
         }
         deactivate();
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         if(sprite)
         {
            sprite.removeChild(bullet);
            engine.gameBoard.bulletLayer.removeChild(sprite);
            assaulter = subject = null;
            sprite = null;
         }
      }
      
      private function determineShotPosition() : void
      {
         shot_position = new Point();
         var _loc1_:String = assaulter.type;
         switch(0)
         {
         }
         shot_position.x = assaulter.sprite.x + assaulter.shot_point.x * assaulter.sprite.scaleX;
         shot_position.y = assaulter.sprite.y + assaulter.shot_point.y * assaulter.sprite.scaleY;
      }
      
      private function checkForceField() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         if(engine.gameBoard.forceFields[subject.life.getCurrentRoad().index][0] <= 0)
         {
            return;
         }
         _loc1_ = 0;
         _loc1_ = 0;
         while(_loc1_ < _force_fields.length)
         {
            _loc2_ = _force_fields[_loc1_].forceField as MovieClip;
            if(assaulter.coverForceField() != _loc2_ && _loc2_.hitTestObject(bullet))
            {
               fly_away_mode = false;
               setToExplosion();
               return;
            }
            _loc1_++;
         }
      }
   }
}

