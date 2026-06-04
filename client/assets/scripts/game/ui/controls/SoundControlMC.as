package game.ui.controls
{
   import core.Global;
   import fl.controls.Slider;
   import fl.events.SliderEvent;
   import fl.managers.FocusManager;
   import flash.display.*;
   import flash.media.SoundTransform;
   import flash.text.*;
   import game.logic.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol861")]
   public class SoundControlMC extends MovieClip
   {
      
      private var sound_slider:Slider = null;
      
      private var parent_ls:* = null;
      
      public var engine:Engine = null;
      
      public function SoundControlMC()
      {
         super();
         sound_slider = new Slider();
         sound_slider.liveDragging = true;
         sound_slider.setSize(100,0);
         sound_slider.maximum = 100;
         sound_slider.minimum = 0;
         sound_slider.tickInterval = 5;
         sound_slider.addEventListener(SliderEvent.CHANGE,musicChange);
         sound_slider.x = 60;
         sound_slider.y = -10;
         addChild(sound_slider);
         tabEnabled = false;
         sound_slider.value = 100;
      }
      
      public function destroy() : void
      {
         sound_slider.removeEventListener(SliderEvent.CHANGE,musicChange);
         removeChild(sound_slider);
         sound_slider = null;
      }
      
      private function musicChange(param1:SliderEvent) : void
      {
         var _loc2_:FocusManager = null;
         var _loc3_:SoundTransform = null;
         engine.volume = sound_slider.value / 100;
         if(Global.top.music_channel)
         {
            _loc3_ = Global.top.music_channel.soundTransform;
            _loc3_.volume = engine.volume;
            Global.top.music_channel.soundTransform = _loc3_;
         }
         _loc2_ = new FocusManager(Global.mainStage);
         _loc2_.setFocus(Global.mainStage);
      }
      
      public function setEngine(param1:Engine, param2:*) : void
      {
         engine = param1;
         parent_ls = param2;
         sound_slider.value = engine.volume * 100;
      }
   }
}

