package
{
   import game.ui.CaterpillarMoving;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol69")]
   public dynamic class CaterpilarMoving extends CaterpillarMoving
   {
      
      public function CaterpilarMoving()
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

