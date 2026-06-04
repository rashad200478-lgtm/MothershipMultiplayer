package game.ui
{
   import flash.display.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol268")]
   public class PlanetsBackground extends MovieClip
   {
      
      public var icon_7:MovieClip;
      
      public var icon_8:MovieClip;
      
      public var arcad:MovieClip;
      
      public var icon_6:MovieClip;
      
      public var grazerit:MovieClip;
      
      private var planets_array:Array;
      
      private var icon_array:Array;
      
      public var icon_9:MovieClip;
      
      private var _panels:Array = [];
      
      public var icon_1:MovieClip;
      
      public var icon_2:MovieClip;
      
      public var yohada:MovieClip;
      
      public var xelacia:MovieClip;
      
      public var kespryt:MovieClip;
      
      public var rhandaran:MovieClip;
      
      public var kasheta:MovieClip;
      
      public var zakdern:MovieClip;
      
      public var icon_11:MovieClip;
      
      public var icon_12:MovieClip;
      
      public var vulcano:MovieClip;
      
      public var acturus:MovieClip;
      
      public var all_panels:MovieClip;
      
      public var ariola:MovieClip;
      
      public var icon_10:MovieClip;
      
      public var betazedd:MovieClip;
      
      public var icon_3:MovieClip;
      
      public var icon_4:MovieClip;
      
      public var icon_5:MovieClip;
      
      public function PlanetsBackground()
      {
         super();
         planets_array = [vulcano,ariola,kasheta,rhandaran,xelacia,acturus,betazedd,yohada,arcad,grazerit,zakdern,kespryt];
         icon_array = [icon_1,icon_2,icon_3,icon_4,icon_5,icon_6,icon_7,icon_8,icon_9,icon_10,icon_11,icon_12];
         _panels = [all_panels.planet_panel1,all_panels.planet_panel2,all_panels.planet_panel3,all_panels.planet_panel4,all_panels.planet_panel5,all_panels.planet_panel6,all_panels.planet_panel7,all_panels.planet_panel8,all_panels.planet_panel9,all_panels.planet_panel10,all_panels.planet_panel11,all_panels.planet_panel12];
      }
      
      public function get panels() : Array
      {
         return _panels;
      }
      
      public function getIconArray() : Array
      {
         return icon_array;
      }
      
      public function getPlanetsArray() : Array
      {
         return planets_array;
      }
   }
}

