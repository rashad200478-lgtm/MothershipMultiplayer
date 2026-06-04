package game.logic
{
   import core.Global;
   import flash.geom.Point;
   import game.Consts;
   import game.goals.DieMarineGoal;
   
   public class EffectRoutines
   {
      
      public function EffectRoutines()
      {
         super();
      }
      
      public static function AddCrater(param1:*) : void
      {
         EffectFactory.addCraterFrom(param1);
      }
      
      public static function AddNukeCrater(param1:*) : void
      {
         var _loc2_:Crater = null;
         _loc2_ = EffectFactory.addCraterFrom(param1,1.2,1.2);
         _loc2_.y -= 50;
      }
      
      public static function AddMineCrater(param1:*) : void
      {
         EffectFactory.addCraterFrom(param1,0.2,0.5);
      }
      
      public static function doNuke() : void
      {
         var _loc1_:Engine = null;
         _loc1_ = Global.top.engine;
         EffectFactory.makeExplosion(EffectFactory.NUCLEAR_MISSILE,new Point(348,410),0.8,_loc1_.gameBoard);
         _loc1_.gameBoard.allyUnits.applyDamage(Consts.NUCLEAR_DAMAGE,DieMarineGoal.DEATH_BY_EXPLOSION);
         _loc1_.gameBoard.enemyUnits.applyDamage(Consts.NUCLEAR_DAMAGE,DieMarineGoal.DEATH_BY_EXPLOSION);
         _loc1_.gameBoard.mines.applyDamage(Consts.NUCLEAR_DAMAGE,DieMarineGoal.DEATH_BY_EXPLOSION);
      }
      
      public static function AddGrenadierCrater(param1:*) : void
      {
         EffectFactory.addCraterFrom(param1,0.35,0.8);
      }
   }
}

