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
   
   public class LaserBeamGoal extends Goal
   {
      
      private var sprite:Sprite = new Sprite();
      
      private var gip:int = 0;
      
      private var engine:Engine = null;
      
      private var hit_position:Point = null;
      
      private var bullet:* = null;
      
      private var shot_position:Point = null;
      
      private var _force_field_impact:Boolean = false;
      
      private var laser_ticks:int = 0;
      
      private var assaulter:Unit = null;
      
      private var subject:Unit = null;
      
      private var _force_fields:ObjectList = null;
      
      public function LaserBeamGoal(param1:Engine, param2:Unit, param3:Unit, param4:int)
      {
         super();
         engine = param1;
         assaulter = param2;
         subject = param3;
         laser_ticks = param4;
         calculateHitPosition();
         create(hit_position);
         _force_fields = engine.gameBoard.forceFields[subject.life.getCurrentRoad().index][1];
      }
      
      override public function advance() : void
      {
         var _loc1_:Number = NaN;
         if(!subject.isAlive)
         {
            deactivate();
            return;
         }
         if(laser_ticks > 0)
         {
            --laser_ticks;
            if(laser_ticks == 15)
            {
               EffectFactory.makeImpact(EffectFactory.CATERPILLAR_IMPACT,hit_position,0.3,engine.gameBoard.unitMaskLayer);
            }
            if(0 == laser_ticks)
            {
               if(false == _force_field_impact)
               {
                  engine.playSound(SoundConsts.caterpillar_hit);
                  engine.playSound(SoundConsts.explosion1);
                  _loc1_ = 1;
                  if(subject.type == StringConsts.SPECIALIST)
                  {
                     _loc1_ = 0.5;
                  }
                  engine.hitUnit(assaulter.weapon.damage * _loc1_,subject);
               }
               deactivate();
            }
         }
      }
      
      private function create(param1:Point) : void
      {
         hit_position.x = param1.x;
         hit_position.y = param1.y;
         bullet = UnitCreator.getBullet(assaulter.type,assaulter.isEnemy);
         sprite.addChild(bullet);
         determineShotPosition();
         sprite.x = shot_position.x;
         sprite.y = shot_position.y;
         calculateBeam();
         engine.gameBoard.bulletLayer.addChild(sprite);
      }
      
      private function calculateHitPosition() : void
      {
         hit_position = new Point(subject.sprite.x + subject.hit_point.x * subject.sprite.scaleX,subject.sprite.y + subject.hit_point.y * subject.sprite.scaleY);
      }
      
      private function cleanup() : void
      {
         sprite.removeChild(bullet);
         engine.gameBoard.bulletLayer.removeChild(sprite);
      }
      
      private function checkForceFields() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Point = null;
         if(engine.gameBoard.forceFields[subject.life.getCurrentRoad().index][0] <= 0)
         {
            return;
         }
         _loc1_ = subject.coverForceField();
         if(!_loc1_)
         {
            return;
         }
         if(!assaulter.isEnemy)
         {
            if(!_force_field_impact)
            {
               _force_field_impact = true;
               _loc2_ = getCenterOfForceField(_loc1_);
               cleanup();
               create(new Point(_loc2_.x - _loc1_.width / 2,_loc2_.y));
               return;
            }
         }
         else if(!_force_field_impact)
         {
            _force_field_impact = true;
            _loc2_ = getCenterOfForceField(_loc1_);
            cleanup();
            create(new Point(_loc2_.x + _loc1_.width / 2,_loc2_.y));
            return;
         }
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         if(sprite)
         {
            cleanup();
            assaulter = subject = null;
            sprite = null;
         }
      }
      
      private function calculateBeam() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc1_ = hit_position.x - shot_position.x;
         _loc2_ = hit_position.y - shot_position.y;
         gip = Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_);
         bullet.scaleX = gip / bullet.width * assaulter.sprite.scaleX;
         bullet.x = bullet.width / 2 * assaulter.sprite.scaleX;
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
      
      private function getCenterOfForceField(param1:MovieClip) : Point
      {
         var _loc2_:Point = null;
         _loc2_ = new Point(engine.levelMap.force_field_mask_layer.x + param1.x,engine.levelMap.force_field_mask_layer.y + param1.y);
         return new Point(_loc2_.x - engine.gameBoard.unitMaskLayer.x,_loc2_.y - engine.gameBoard.unitMaskLayer.y);
      }
   }
}

