package game.ui
{
   import flash.display.MovieClip;
   
   public class CaterpillarMoving extends MovieClip
   {
      
      private var stop_moving:Boolean = false;
      
      private var currently_stopped:Boolean = false;
      
      public function CaterpillarMoving()
      {
         super();
      }
      
      public function get currentlyStopped() : Boolean
      {
         return currently_stopped;
      }
      
      public function set currentlyStopped(param1:Boolean) : void
      {
         currently_stopped = param1;
      }
      
      public function set stopMoving(param1:Boolean) : void
      {
         stop_moving = param1;
      }
      
      public function get stopMoving() : Boolean
      {
         return stop_moving;
      }
   }
}

