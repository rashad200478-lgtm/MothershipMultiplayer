package game.goals
{
   import core.Global;
   import core.goal.Goal;
   import game.StringConsts;
   import game.logic.Engine;
   
   public class GrandStormGoal extends Goal
   {
      
      private static var PAUSE:* = 75;
      
      private var engine:Engine = null;
      
      private var _enemy_send_index:int = 0;
      
      private var send_index:int = 0;
      
      private var _working:Boolean = false;
      
      private var pause:int = 0;
      
      private var _ticks:int = 0;
      
      public function GrandStormGoal()
      {
         super();
         engine = Global.top.engine;
      }
      
      override public function advance() : void
      {
         if(!_working)
         {
            return;
         }
         if(pause > 0)
         {
            --pause;
            return;
         }
         sendNext();
         pause = PAUSE;
      }
      
      private function getNextEnemyCard() : String
      {
         var _loc1_:String = null;
         _loc1_ = engine.enemyCards[_enemy_send_index];
         if(StringConsts.EMPTY == _loc1_)
         {
            _enemy_send_index = 0;
            _loc1_ = engine.enemyCards[_enemy_send_index];
         }
         ++_enemy_send_index;
         if(_enemy_send_index >= 4)
         {
            _enemy_send_index = 0;
         }
         return _loc1_;
      }
      
      private function sendNext() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         _loc1_ = getNextPlayersCard();
         _loc2_ = getNextEnemyCard();
         if(StringConsts.GRENADIER_DROID == _loc1_ && engine.cards.length != 1)
         {
            _loc1_ = getNextPlayersCard();
         }
         if(StringConsts.GRENADIER_DROID == _loc2_)
         {
            _loc2_ = getNextEnemyCard();
         }
         engine.gameBoard.sendFromAllHatches(_loc1_,false);
         engine.gameBoard.sendFromAllHatches(_loc2_,true);
         ++_ticks;
         if(_ticks >= 4)
         {
            engine.goalSystem.add(new FinalBalanceCheckingGoal());
            deactivate();
         }
      }
      
      public function get isWorking() : Boolean
      {
         return _working;
      }
      
      public function set working(param1:Boolean) : void
      {
         _working = param1;
         engine.playWindowUI.buttons.buttonSetGoal.setPaused(true);
         engine.playWindowUI.enemyButons.buttonSetGoal.setPaused(true);
         engine.playWindowUI.buttons.pauseSpecials();
         engine.playWindowUI.enemyButons.pauseSpecials();
         engine.stormGoal.deactivate();
         engine.enemyStormGoal.deactivate();
         engine.playWindowUI.game_menu.storm_label.gotoAndStop("grand_storm_label");
         engine.playWindowUI.game_menu.enemy_storm_label.gotoAndStop("grand_storm_label");
      }
      
      private function getNextPlayersCard() : String
      {
         var _loc1_:String = null;
         _loc1_ = engine.cards[send_index];
         if(StringConsts.EMPTY == _loc1_)
         {
            send_index = 0;
            _loc1_ = engine.cards[send_index];
         }
         ++send_index;
         if(send_index >= 4)
         {
            send_index = 0;
         }
         return _loc1_;
      }
   }
}

