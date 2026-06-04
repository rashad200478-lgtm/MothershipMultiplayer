package game.goals
{
   import core.Global;
   import core.goal.Goal;
   import game.logic.Engine;
   
   public class HelloMessagesGoal extends Goal
   {
      
      private var _engine:Engine = null;
      
      private var _messages:Array = [[0,"Greetings Commander"],[30,"Connection with space support established..."],[45,"Waiting for command..."]];
      
      private var _ticks:int = 0;
      
      private var _last_phase:Boolean = false;
      
      public function HelloMessagesGoal()
      {
         super();
         _engine = Global.top.engine;
         _engine.playWindowUI.buttons.buttonSetGoal.setPaused(true);
         _engine.playWindowUI.enemyButons.buttonSetGoal.setPaused(true);
      }
      
      override public function advance() : void
      {
         var _loc1_:int = 0;
         if(_last_phase)
         {
            --_ticks;
            if(_ticks % 30 == 0)
            {
               _engine.playWindowUI.logMessage("Battle starts in: " + (_ticks / 30).toString(),true);
            }
            if(0 == _ticks)
            {
               if(0 == _engine.lastLevelIndex && 0 == _engine.lastZone)
               {
                  _engine.playWindowUI.logMessage("HINT: Press SPACE or CONTROL in order to send a unit.");
               }
               else
               {
                  _engine.playWindowUI.logMessage("GO!");
               }
               unblockAll();
               deactivate();
            }
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < _messages.length)
         {
            if(_messages[_loc1_][0] == _ticks)
            {
               _engine.playWindowUI.logMessage(_messages[_loc1_][1]);
               if(_loc1_ == _messages.length - 1)
               {
                  _last_phase = true;
                  _ticks = 30 * 3 + 1;
               }
               break;
            }
            _loc1_++;
         }
         ++_ticks;
      }
      
      private function unblockAll() : void
      {
         _engine.playWindowUI.buttons.buttonSetGoal.setPaused(false);
         _engine.playWindowUI.enemyButons.buttonSetGoal.setPaused(false);
         _engine.playWindowUI.buttons.buttonSetGoal.setReadyAll();
         _engine.playWindowUI.enemyButons.buttonSetGoal.setReadyAll();
      }
   }
}

