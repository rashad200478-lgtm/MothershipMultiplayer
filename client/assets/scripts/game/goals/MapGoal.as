package game.goals
{
   import core.goal.GoalSystem;
   import fl.transitions.Tween;
   import fl.transitions.easing.None;
   import game.ui.LevelSelection;
   
   public class MapGoal extends GoalSystem
   {
      
      private var level:LevelSelection = null;
      
      private var star_x:Number;
      
      private var planet_x:Number;
      
      private var TweenOutX0:Tween = null;
      
      private var TweenOutX1:Tween = null;
      
      private var TweenOutX2:Tween = null;
      
      private var TweenOutX3:Tween = null;
      
      private var map_speed:Number = 5;
      
      private var nebula_x:Number;
      
      public function MapGoal(param1:LevelSelection)
      {
         super();
         level = param1;
      }
      
      override public function advance() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(!level.visible)
         {
            return;
         }
         _loc1_ = -1467;
         _loc2_ = -(level.mouseX - 100) * (level.planets_back.width - 700) / 500;
         if(level.mouseX < 100)
         {
            _loc2_ = 0;
         }
         if(level.mouseX > 600)
         {
            _loc2_ = _loc1_;
         }
         TweenOutX1 = new Tween(level.planets_back,"x",None.easeOut,level.planets_back.x,_loc2_,15,false);
         TweenOutX0 = new Tween(level.planets_back_star,"x",None.easeOut,level.planets_back_star.x,_loc2_,12,false);
         _loc3_ = -(level.mouseX - 100) * (level.planets_back.width - 700) / 500;
         if(level.mouseX < 100)
         {
            _loc3_ = 0;
         }
         if(level.mouseX > 600)
         {
            _loc3_ = _loc1_;
         }
         TweenOutX2 = new Tween(level.planets_star,"x",None.easeOut,level.planets_star.x,_loc3_,18,false);
         _loc4_ = -(level.mouseX - 100) * (level.planets_back.width - 700) / 500;
         if(level.mouseX < 100)
         {
            _loc4_ = 0;
         }
         if(level.mouseX > 600)
         {
            _loc4_ = _loc1_;
         }
         TweenOutX3 = new Tween(level.planets_nebula,"x",None.easeOut,level.planets_nebula.x,_loc4_,21,false);
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
      }
   }
}

