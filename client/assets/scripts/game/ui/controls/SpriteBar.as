package game.ui.controls
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   
   public class SpriteBar extends MovieClip
   {
      
      private var initial_scale:Number = 0;
      
      public var inner_bar:MovieClip = null;
      
      public function SpriteBar()
      {
         super();
         initial_scale = inner_bar.scaleX;
      }
      
      public function resume() : void
      {
         Tweener.resumeTweens(inner_bar);
      }
      
      public function setProgress(param1:Number) : void
      {
         inner_bar.scaleX = param1 * initial_scale;
      }
      
      public function setProgressEasing(param1:Number) : void
      {
         if(Tweener.isTweening(inner_bar))
         {
            Tweener.removeTweens(inner_bar);
         }
         Tweener.addTween(inner_bar,{
            "scaleX":param1 * initial_scale,
            "time":3
         });
      }
      
      public function pause() : void
      {
         Tweener.pauseTweens(inner_bar);
      }
   }
}

