package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol309")]
   public dynamic class LoadingMC extends MovieClip
   {
      
      public var loaded_txt:TextField;
      
      public var error_txt:TextField;
      
      public var progress_mc:MovieClip;
      
      public function LoadingMC()
      {
         super();
      }
   }
}

