package game.logic
{
   import game.ui.RoadPath;
   
   public class RoadGraph
   {
      
      private var road:RoadPath = null;
      
      private var vice_versa_counter:int = 0;
      
      private var counter:int = 0;
      
      public function RoadGraph(param1:RoadPath)
      {
         super();
         road = param1;
      }
      
      public function lookAnyNext() : RoadPoint
      {
         if(counter >= road.points.size())
         {
            return road.points.values[road.points.size() - 1];
         }
         return road.points.values[counter];
      }
      
      public function getNext() : RoadPoint
      {
         if(counter + 1 >= road.points.size())
         {
            return null;
         }
         ++counter;
         return road.points.values[counter];
      }
      
      public function getLast() : RoadPoint
      {
         vice_versa_counter = road.points.size() - 1;
         return road.lastNode();
      }
      
      public function getPrev() : RoadPoint
      {
         if(vice_versa_counter - 1 < 0)
         {
            return null;
         }
         --vice_versa_counter;
         return road.points.values[vice_versa_counter];
      }
      
      public function getFirst() : RoadPoint
      {
         counter = 0;
         return road.firstNode();
      }
   }
}

