package game.goals
{
   import caurina.transitions.Tweener;
   import core.Global;
   import core.common.sprintf;
   import core.goal.Goal;
   import flash.geom.Point;
   import game.SoundConsts;
   import game.logic.AIThinker;
   import game.logic.EffectFactory;
   import game.logic.Engine;
   import game.logic.LevelSelector;
   
   public class ScenarioGoal extends Goal
   {
      
      private static var frame_rate:int = 0;
      
      private var engine:Engine = null;
      
      private var _ai_thinking_pause:int = 0;
      
      private var grand_went:Boolean = false;
      
      private var level_time:int = 0;
      
      private var _think_pause:int = 0;
      
      private var _ai_thinker:AIThinker = null;
      
      private var time_spent:int = 0;
      
      public function ScenarioGoal(param1:Engine)
      {
         super();
         frame_rate = Global.mainStage.frameRate;
         engine = param1;
         _ai_thinker = new AIThinker();
         LevelSelector.initializeAI(_ai_thinker);
      }
      
      public function get grandWent() : Boolean
      {
         return grand_went;
      }
      
      override public function advance() : void
      {
         if(engine.gameFinished)
         {
            return;
         }
         ++time_spent;
         if(grand_went && !engine.grandStormGoal.alive && engine.gameBoard.allyUnits.aliveCount() == 0 && engine.gameBoard.enemyUnits.aliveCount() == 0)
         {
            calculateVictoryByBalance();
            return;
         }
         if(isGoalFailed())
         {
            engine.gameOver();
            return;
         }
         if(isGoalDone())
         {
            engine.victory();
            return;
         }
         if(level_time <= 0)
         {
            if(!grand_went)
            {
               grandStorm();
            }
         }
         else
         {
            --level_time;
            engine.playWindowUI.balanceBar.grandStormBar.setProgress((engine.levelMap.level_time - level_time / frame_rate) / engine.levelMap.level_time);
            updateCountdown();
         }
         if(_think_pause > 0)
         {
            --_think_pause;
            if(_think_pause != 0)
            {
               return;
            }
            _think_pause = frame_rate;
         }
         if(_ai_thinking_pause > 0)
         {
            --_ai_thinking_pause;
            return;
         }
         if(!grand_went)
         {
            _ai_thinker.think();
            _ai_thinking_pause = frame_rate;
         }
      }
      
      private function calculateVictoryByBalance() : void
      {
         if(engine.playWindowUI.balanceBar.isFartherOfCenter())
         {
            engine.victory();
         }
         else
         {
            engine.gameOver();
         }
      }
      
      public function get timeSpent() : int
      {
         return time_spent / frame_rate;
      }
      
      public function setLevelTime(param1:int) : void
      {
         level_time = param1 * frame_rate;
         updateCountdown();
      }
      
      public function get levelTime() : int
      {
         return level_time;
      }
      
      private function updateCountdown() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = level_time / frame_rate / 60;
         _loc2_ = int(level_time / frame_rate) % 60;
         _loc3_ = level_time % 10;
         engine.playWindowUI.countdown_txt.text = sprintf("%02d:%02d:%02d",_loc1_,_loc2_,_loc3_);
      }
      
      public function isGoalFailed() : Boolean
      {
         return engine.playWindowUI.balanceBar.isLeftPointReached;
      }
      
      private function grandStorm() : void
      {
         engine.playSound(SoundConsts.final_attack);
         grand_went = true;
         engine.grandStormGoal.working = true;
         Tweener.addTween(engine.playWindowUI.countdown_txt,{
            "alpha":0,
            "time":1,
            "transition":"easeOutQuad"
         });
         EffectFactory.makeExplosion(EffectFactory.GRAND_STORM,new Point(343,155),1,engine.playWindowUI);
      }
      
      public function isGoalDone() : Boolean
      {
         return engine.playWindowUI.balanceBar.isRightPointReached;
      }
   }
}

