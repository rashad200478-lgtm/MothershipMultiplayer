package game.logic
{
   import core.*;
   import core.common.KeyboardKeys;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import game.*;
   
   public class GameEvents
   {
      
      private var engine:Engine = null;
      
      public function GameEvents(param1:Engine)
      {
         super();
         engine = param1;
      }
      
      public function register() : void
      {
         var _loc1_:int = 0;
         Global.mainStage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
         Global.mainStage.addEventListener(Event.DEACTIVATE,focusOutHandler);
         Global.mainStage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         Global.mainStage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
         Global.mainStage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         _loc1_ = 0;
         _loc1_ = 0;
         while(_loc1_ < engine.playWindowUI.buttons.all.length)
         {
            engine.playWindowUI.buttons.all[_loc1_].addEventListener(MouseEvent.MOUSE_DOWN,unitButtonDownHanlder);
            engine.playWindowUI.buttons.all[_loc1_].addEventListener(MouseEvent.MOUSE_OVER,unitButtonOverHanlder);
            engine.playWindowUI.buttons.all[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,unitButtonOutHanlder);
            _loc1_++;
         }
      }
      
      private function unitButtonDownHanlder(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(!_loc2_.unit_type && _loc2_.unit_type == StringConsts.EMPTY)
         {
            return;
         }
         if(engine.specialTargeting.enabled && engine.specialTargeting.currentType != _loc2_.unit_type)
         {
            engine.specialTargeting.disable();
         }
         if(_loc2_.is_special)
         {
            engine.specialButtonPressed(_loc2_);
         }
         else
         {
            if(engine.scenarioGoal.grandWent)
            {
               return;
            }
            if(engine.stormGoal.isWaiting)
            {
               engine.unitButtonPressed(_loc2_);
            }
            else if(_loc2_.ticks_goal.ready)
            {
               engine.specialTargeting.enable(_loc2_.unit_type,true);
            }
         }
         param1.stopPropagation();
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         if(engine.specialTargeting.enabled)
         {
            if(engine.specialTargeting.isUnitSendAction)
            {
               engine.unitButtonPressed(engine.playWindowUI.buttons.getButtonByType(engine.specialTargeting.currentType));
            }
            else
            {
               engine.makeSpecialEffect(engine.specialTargeting.currentType);
            }
            engine.specialTargeting.disable();
         }
      }
      
      private function unitButtonOverHanlder(param1:MouseEvent) : void
      {
         if(param1.currentTarget.buttons_holder)
         {
            param1.currentTarget.buttons_holder.setButtonIndexOn(param1.currentTarget);
         }
      }
      
      private function unitButtonOutHanlder(param1:MouseEvent) : void
      {
         engine.playWindowUI.buttons.updateSelection();
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         if(engine.specialTargeting.enabled)
         {
            engine.specialTargeting.interpolatePoint(new Point(engine.levelMap.mouseX,engine.levelMap.mouseY));
         }
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SPACE || param1.keyCode == Keyboard.CONTROL)
         {
            if(engine.specialTargeting.enabled)
            {
               if(engine.specialTargeting.isUnitSendAction)
               {
                  sendUnitAction();
               }
               else
               {
                  engine.makeSpecialEffect(engine.specialTargeting.currentType);
                  engine.specialTargeting.disable();
               }
            }
            else
            {
               sendUnitAction();
            }
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            if(engine.specialTargeting.enabled)
            {
               engine.specialTargeting.disable();
            }
         }
         if(param1.keyCode == Keyboard.NUMPAD_0)
         {
         }
         if(Keyboard.DOWN == param1.keyCode || KeyboardKeys.S_KEY == param1.keyCode || KeyboardKeys.s_KEY == param1.keyCode)
         {
            engine.hatches.moveDown();
            engine.specialTargeting.update();
         }
         if(Keyboard.UP == param1.keyCode || KeyboardKeys.W_KEY == param1.keyCode || KeyboardKeys.w_KEY == param1.keyCode)
         {
            engine.hatches.moveUp();
            engine.specialTargeting.update();
         }
         if(Keyboard.LEFT == param1.keyCode || KeyboardKeys.A_KEY == param1.keyCode || KeyboardKeys.a_KEY == param1.keyCode)
         {
            if(engine.specialTargeting.enabled && engine.specialTargeting.isUnitSendAction)
            {
               engine.specialTargeting.disable();
            }
            if(engine.specialTargeting.enabled)
            {
               engine.specialTargeting.moveLeft();
            }
            else
            {
               engine.playWindowUI.buttons.moveSelectionLeft();
            }
         }
         if(Keyboard.RIGHT == param1.keyCode || KeyboardKeys.D_KEY == param1.keyCode || KeyboardKeys.d_KEY == param1.keyCode)
         {
            if(engine.specialTargeting.enabled && engine.specialTargeting.isUnitSendAction)
            {
               engine.specialTargeting.disable();
            }
            if(engine.specialTargeting.enabled)
            {
               engine.specialTargeting.moveRight();
            }
            else
            {
               engine.playWindowUI.buttons.moveSelectionRight();
            }
         }
      }
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
      }
      
      public function sendUnitAction(param1:Boolean = false) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = engine.playWindowUI.buttons.getCurrentButton();
         if(_loc2_.is_special)
         {
            if(param1)
            {
               return;
            }
            engine.specialButtonPressed(_loc2_);
         }
         else
         {
            if(engine.scenarioGoal.grandWent)
            {
               return;
            }
            engine.unitButtonPressed(_loc2_);
         }
      }
      
      private function focusOutHandler(param1:Event) : void
      {
      }
      
      public function unregister() : void
      {
         var _loc1_:int = 0;
         Global.mainStage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
         Global.mainStage.removeEventListener(Event.DEACTIVATE,focusOutHandler);
         Global.mainStage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         Global.mainStage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
         Global.mainStage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         _loc1_ = 0;
         _loc1_ = 0;
         while(_loc1_ < engine.playWindowUI.buttons.all.length)
         {
            engine.playWindowUI.buttons.all[_loc1_].removeEventListener(MouseEvent.MOUSE_DOWN,unitButtonDownHanlder);
            engine.playWindowUI.buttons.all[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,unitButtonOverHanlder);
            engine.playWindowUI.buttons.all[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,unitButtonOutHanlder);
            _loc1_++;
         }
      }
   }
}

