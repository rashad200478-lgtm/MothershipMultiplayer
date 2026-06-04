package
{
   import core.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.*;
   import flash.system.Security;
   import flash.ui.*;
   
   public class GameStage extends MovieClip
   {
      
      public static var itself:* = null;
      
      public var flonga_clip:MovieClip;
      
      public var loadingMC:MovieClip;
      
      public var welcome_screen:MovieClip;
      
      public function GameStage()
      {
         super();
         addFrameScript(0,frame1,4,frame5);
         Security.allowDomain("*");
         itself = this;
      }
      
      public static function sponsorClick(param1:MouseEvent) : void
      {
         var urlRequest:URLRequest = null;
         var evt:MouseEvent = param1;
         try
         {
            urlRequest = new URLRequest("http://www.flonga.com/");
            navigateToURL(urlRequest,"_blank");
         }
         catch(e:Error)
         {
         }
      }
      
      public function progressUpdate(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Math.round(this.loaderInfo.bytesLoaded / this.loaderInfo.bytesTotal * 100);
         if(loadingMC is MovieClip)
         {
            loadingMC.progress_mc.gotoAndStop(_loc2_);
            loadingMC.loaded_txt.text = "The game is loading... " + _loc2_.toString() + "%";
         }
         if(this.loaderInfo.bytesLoaded == this.loaderInfo.bytesTotal)
         {
            loadingMC.removeEventListener(Event.ENTER_FRAME,progressUpdate);
            loadingMC.progress_mc.stop();
            loadingMC.progress_mc.visible = false;
            removeChild(loadingMC);
            loadingMC = null;
            gotoAndStop(5);
         }
      }
      
      private function handleUnload(param1:Event) : void
      {
         root.loaderInfo.removeEventListener(Event.UNLOAD,handleUnload);
         Global.top.clear();
      }
      
      public function flongaFinished() : void
      {
         if(!flonga_clip)
         {
            return;
         }
         flonga_clip.stop();
         flonga_clip.visible = false;
         this.removeChild(flonga_clip);
         flonga_clip.stop();
         flonga_clip = null;
         welcome_screen.playMusic();
      }
      
      internal function frame1() : *
      {
         loadingMC.addEventListener(Event.ENTER_FRAME,progressUpdate);
         stop();
      }
      
      public function initAll() : void
      {
         if(Global.isStarted())
         {
            return;
         }
         Global.startup(this,welcome_screen);
         Global.hideMenu();
         Global.top.initialize();
         root.loaderInfo.addEventListener(Event.UNLOAD,handleUnload);
      }
      
      internal function frame5() : *
      {
         flonga_clip.addEventListener(MouseEvent.MOUSE_DOWN,sponsorClick);
         flonga_clip.tabEnabled = false;
         this.initAll();
         stop();
      }
   }
}

