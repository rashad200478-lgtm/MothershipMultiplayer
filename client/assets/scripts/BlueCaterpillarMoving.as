package
{
   import game.ui.CaterpillarMoving;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol65")]
   public dynamic class BlueCaterpillarMoving extends CaterpillarMoving
   {
      
      public function BlueCaterpillarMoving()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      internal function frame1() : *
      {
         if(stopMoving)
         {
            stop();
            currentlyStopped = true;
         }
      }
   }
}

