package game.units
{
   public class Weapon
   {
      
      public var recharge_time:int = 0;
      
      public var bullet_speed:int = 0;
      
      public var eyerange:int = 0;
      
      public var likelihood:Number = 0;
      
      public var damage:int = 0;
      
      public function Weapon()
      {
         super();
      }
      
      public function copyProperties(param1:Weapon) : void
      {
         eyerange = param1.eyerange;
         damage = param1.damage;
         recharge_time = param1.recharge_time;
         bullet_speed = param1.bullet_speed;
      }
   }
}

