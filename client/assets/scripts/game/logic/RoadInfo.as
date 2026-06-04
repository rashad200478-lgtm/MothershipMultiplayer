package game.logic
{
   import game.units.Unit;
   
   public class RoadInfo
   {
      
      public var player_synergy:int = 0;
      
      public var closest_unit:Unit = null;
      
      public var player_units:int = 0;
      
      public var enemy_synergy:int = 0;
      
      public var enemy_units:int = 0;
      
      public function RoadInfo()
      {
         super();
      }
   }
}

