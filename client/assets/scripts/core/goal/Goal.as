package core.goal
{
   public class Goal implements IGoal
   {
      
      protected var active:Boolean = true;
      
      public function Goal()
      {
         super();
      }
      
      public function advance() : void
      {
      }
      
      public function deactivate() : void
      {
         active = false;
      }
      
      public function get alive() : Boolean
      {
         return active;
      }
   }
}

