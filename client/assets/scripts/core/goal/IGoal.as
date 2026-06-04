package core.goal
{
   public interface IGoal
   {
      
      function advance() : void;
      
      function deactivate() : void;
      
      function get alive() : Boolean;
   }
}

