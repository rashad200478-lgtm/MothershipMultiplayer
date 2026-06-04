package game.goals
{
   import core.goal.*;
   import game.*;
   import game.logic.*;
   import game.ui.RoadPath;
   import game.units.*;
   
   public class LifeGoal extends GoalSystem
   {
      
      private var engine:Engine = null;
      
      private var mover_goal:* = null;
      
      private var enemy_detector:EnemyDetectorGoal = null;
      
      private var attack_goal:* = null;
      
      private var owner:Unit = null;
      
      public function LifeGoal(param1:Engine, param2:Unit)
      {
         super();
         owner = param2;
         engine = param1;
      }
      
      public function getCurrentRoad() : RoadPath
      {
         if(!mover_goal)
         {
            return null;
         }
         return mover_goal.theRoad();
      }
      
      public function breathe() : void
      {
         if(!owner.isPeaceful)
         {
            enemy_detector = new EnemyDetectorGoal(engine,owner);
            add(enemy_detector);
         }
         switch(owner.type)
         {
            case StringConsts.MARINE:
            case StringConsts.MISSILE_MAN:
            case StringConsts.SPECIALIST:
               attack_goal = new AttackMarineGoal(engine,owner);
               break;
            case StringConsts.CATERPILLAR:
               attack_goal = new AttackCaterpillarGoal(engine,owner);
               break;
            case StringConsts.GRENADIER_DROID:
            case StringConsts.MINE:
               attack_goal = new AttackGrenadierGoal(engine,owner);
               enemy_detector.checkBackUnits(true);
               break;
            case StringConsts.MINER_DROID:
               attack_goal = new MinePlacingGoal(engine,owner);
               break;
            default:
               attack_goal = new AttackRobotGoal(engine,owner);
         }
         add(attack_goal);
      }
      
      public function startAttack(param1:Unit) : void
      {
         attack_goal.setTarget(param1);
      }
      
      public function get isAttacking() : Boolean
      {
         return owner.currentState == Unit.ATTACK;
      }
      
      public function resetWeapon() : void
      {
      }
      
      public function startMoving(param1:RoadPath) : void
      {
         if(owner.isEnemy)
         {
            mover_goal = new RoadViceVersaMoverGoal(engine,owner,param1);
         }
         else
         {
            mover_goal = new RoadMoverGoal(engine,owner,param1);
         }
         add(mover_goal);
         owner.currentState = Unit.WALKING;
      }
      
      public function getMover() : *
      {
         return mover_goal;
      }
      
      public function get attackGoal() : AttackGoal
      {
         return attack_goal;
      }
      
      public function get enemyDetector() : EnemyDetectorGoal
      {
         return enemy_detector;
      }
      
      public function addToInfos() : void
      {
         var _loc1_:RoadInfo = null;
         _loc1_ = engine.gameBoard.roadInfos[getCurrentRoad().index];
         if(owner.isEnemy)
         {
            ++_loc1_.enemy_units;
            _loc1_.enemy_synergy += owner.getSynergy();
         }
         else
         {
            ++_loc1_.player_units;
            _loc1_.player_synergy += owner.getSynergy();
         }
      }
      
      override public function deactivate() : void
      {
         var _loc1_:RoadInfo = null;
         if(owner)
         {
            _loc1_ = engine.gameBoard.roadInfos[getCurrentRoad().index];
            if(owner.isEnemy)
            {
               --_loc1_.enemy_units;
               _loc1_.enemy_synergy -= owner.getSynergy();
            }
            else
            {
               --_loc1_.player_units;
               _loc1_.player_synergy -= owner.getSynergy();
            }
            owner = null;
         }
         super.deactivate();
      }
      
      public function setMover(param1:*) : void
      {
         mover_goal = param1;
      }
   }
}

