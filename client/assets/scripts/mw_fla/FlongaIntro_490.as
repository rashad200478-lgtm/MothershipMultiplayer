package mw_fla
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1260")]
   public dynamic class FlongaIntro_490 extends MovieClip
   {
      
      public var inner:MovieClip;
      
      public var flobot:MovieClip;
      
      public function FlongaIntro_490()
      {
         super();
         addFrameScript(0,frame1,29,frame30,62,frame63,72,frame73,92,frame93,200,frame201,299,frame300);
      }
      
      internal function frame73() : *
      {
         flobot.doTurnhead();
      }
      
      internal function frame201() : *
      {
         flobot.doWink();
      }
      
      internal function frame93() : *
      {
         flobot.doWink();
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame30() : *
      {
         flobot.doFly();
      }
      
      internal function frame300() : *
      {
         stop();
         GameStage.itself.flongaFinished();
      }
      
      internal function frame63() : *
      {
         flobot.doEndFly();
      }
   }
}

