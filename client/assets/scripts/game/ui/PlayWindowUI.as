package game.ui
{
   import core.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.*;
   import game.logic.*;
   import game.ui.controls.SpriteBar;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol818")]
   public class PlayWindowUI extends Sprite
   {
      
      public var menu_button:SimpleButton;
      
      public var end_mission_button:SimpleButton;
      
      private var engine:Engine = null;
      
      public var countdown_txt:TextField;
      
      private var _buttons:GameButtons = null;
      
      public var pause_mc:MovieClip;
      
      public var game_menu:MovieClip;
      
      public var pause_button:SimpleButton;
      
      private var _enemy_butons:GameButtons = null;
      
      public var help_button:SimpleButton;
      
      public function PlayWindowUI()
      {
         super();
         menu_button.tabEnabled = false;
         pause_button.tabEnabled = false;
         end_mission_button.tabEnabled = false;
         help_button.tabEnabled = false;
      }
      
      public function get enemyButons() : GameButtons
      {
         return _enemy_butons;
      }
      
      public function get enemyStormBar() : SpriteBar
      {
         return game_menu.enemy_storm_bar as SpriteBar;
      }
      
      public function logMessage(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         if(param1.length == 0)
         {
            return;
         }
         if(param2)
         {
            _loc3_ = game_menu.message_box.text;
            _loc4_ = _loc3_.lastIndexOf("\r");
            if(_loc4_ > 0)
            {
               _loc5_ = _loc3_.lastIndexOf("\r",_loc4_ - 1);
               if(_loc5_ < 0)
               {
                  _loc5_ = 0;
               }
               else
               {
                  _loc5_++;
               }
               _loc6_ = _loc3_.substr(0,_loc5_) + param1 + "\r";
               game_menu.message_box.text = _loc6_;
               return;
            }
         }
         game_menu.message_box.text += param1 + "\r";
         game_menu.message_box.scrollV += 1;
      }
      
      private function uimenuClickHandler(param1:MouseEvent) : void
      {
         if(engine.gameFinished)
         {
            return;
         }
         engine.playSound(SoundConsts.click);
         engine.pause();
         engine.hideUI();
         Global.top.showWelcome();
      }
      
      public function get stormBar() : SpriteBar
      {
         return game_menu.storm_bar as SpriteBar;
      }
      
      public function updateShipIcons() : void
      {
         var _loc1_:int = 0;
         if(balanceBar.balance == 0.5)
         {
            game_menu.red_ship_icon.gotoAndStop(1);
            game_menu.blue_ship_icon.gotoAndStop(1);
            return;
         }
         _loc1_ = 0;
         if(balanceBar.balance < 0.5)
         {
            _loc1_ = 5 - int(balanceBar.balance * 5 / 0.5);
            game_menu.blue_ship_icon.gotoAndStop(_loc1_);
            game_menu.red_ship_icon.gotoAndStop(1);
         }
         else if(balanceBar.balance > 0.5)
         {
            _loc1_ = 5 - int((1 - balanceBar.balance) * 5 / 0.5);
            game_menu.red_ship_icon.gotoAndStop(_loc1_);
            game_menu.blue_ship_icon.gotoAndStop(1);
         }
      }
      
      private function endMissionClickHandler(param1:MouseEvent) : void
      {
         if(engine.gameFinished)
         {
            return;
         }
         Global.top.engine.playSound(SoundConsts.click);
         engine.gameOver();
      }
      
      private function helpClickHandler(param1:MouseEvent) : void
      {
         if(engine.gameFinished)
         {
            return;
         }
         engine.playSound(SoundConsts.click);
         engine.pause();
         engine.hideUI();
         Global.top.showWelcome();
         Global.top.instructions.show();
      }
      
      public function initialize(param1:Engine) : void
      {
         engine = param1;
         pause_mc.addEventListener(MouseEvent.MOUSE_DOWN,unpauseHandler);
         menu_button.addEventListener(MouseEvent.MOUSE_DOWN,uimenuClickHandler);
         pause_button.addEventListener(MouseEvent.MOUSE_DOWN,uipauseClickHandler);
         end_mission_button.addEventListener(MouseEvent.MOUSE_DOWN,endMissionClickHandler);
         help_button.addEventListener(MouseEvent.MOUSE_DOWN,helpClickHandler);
         pause_mc.stop();
         pause_mc.visible = false;
         balanceBar.initialize(engine.levelMap.health);
         _buttons = new GameButtons(game_menu.player_buttons,false);
         _enemy_butons = new GameButtons(game_menu.ai_buttons,true);
         game_menu.blue_ship_icon.stop();
         game_menu.red_ship_icon.stop();
      }
      
      public function get balanceBar() : BalanceBar
      {
         return game_menu.balance_bar as BalanceBar;
      }
      
      private function unpauseHandler(param1:MouseEvent) : void
      {
         engine.pause();
         param1.stopPropagation();
      }
      
      public function get buttons() : GameButtons
      {
         return _buttons;
      }
      
      public function update() : void
      {
      }
      
      private function uipauseClickHandler(param1:MouseEvent) : void
      {
         if(engine.gameFinished)
         {
            return;
         }
         engine.playSound(SoundConsts.click);
         engine.pause();
      }
      
      public function destroy() : void
      {
         pause_mc.removeEventListener(MouseEvent.MOUSE_DOWN,unpauseHandler);
         menu_button.removeEventListener(MouseEvent.MOUSE_DOWN,uimenuClickHandler);
         pause_button.removeEventListener(MouseEvent.MOUSE_DOWN,uipauseClickHandler);
         end_mission_button.removeEventListener(MouseEvent.MOUSE_DOWN,endMissionClickHandler);
         help_button.removeEventListener(MouseEvent.MOUSE_DOWN,helpClickHandler);
      }
   }
}

