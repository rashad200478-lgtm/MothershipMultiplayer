package game.goals
{
   import core.goal.Goal;
   import game.logic.Engine;
   import game.units.Unit;
   
   public class MineGoal extends Goal
   {
      
      private var mine_unit:Unit = null;
      
      private var engine:Engine = null;
      
      private var enemy_detector:EnemyDetectorGoal = null;
      
      public function MineGoal(param1:Engine, param2:Unit)
      {
         super();
         engine = param1;
         mine_unit = param2;
         engine.gameBoard.mines.push(mine_unit);
      }
      
      override public function advance() : void
      {
      }
      
      override public function deactivate() : void
      {
         if(mine_unit)
         {
            engine.gameBoard.mines.remove(mine_unit);
            mine_unit = null;
         }
         super.deactivate();
      }
   }
}

