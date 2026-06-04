package game.ui
{
   import core.Global;
   import flash.display.MovieClip;
   import game.StringConsts;
   import game.goals.ButtonSetGoal;
   import game.goals.ButtonTicksGoal;
   import game.logic.Engine;
   
   public class GameButtons
   {
      
      private var engine:Engine = null;
      
      private var _is_enemy:Boolean = false;
      
      private var _all:Array = [];
      
      private var _button_index:int = 0;
      
      private var buttons_holder:MovieClip = null;
      
      private var _units:Array = [];
      
      private var _prefix:String;
      
      private var _specials:Array = [];
      
      private var _button_set_goal:ButtonSetGoal = null;
      
      public function GameButtons(param1:*, param2:Boolean)
      {
         super();
         engine = Global.top.engine;
         buttons_holder = param1;
         _is_enemy = param2;
         _prefix = _is_enemy ? "red_" : "blue_";
         initialize();
      }
      
      public function getButtonByType(param1:String) : *
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in _all)
         {
            if(_loc2_.unit_type == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function updateSelection() : void
      {
         var _loc1_:String = null;
         _all[_button_index].unit_icon.button_back.gotoAndStop("highlighted_state");
         _loc1_ = _all[_button_index].unit_type;
         buttons_holder.screen_txt.text = _loc1_.replace("Droid","Robot");
      }
      
      public function get buttonSetGoal() : ButtonSetGoal
      {
         return _button_set_goal;
      }
      
      private function initialize() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:ButtonTicksGoal = null;
         _units = [buttons_holder.button1,buttons_holder.button2,buttons_holder.button3,buttons_holder.button4];
         _button_set_goal = new ButtonSetGoal();
         _loc1_ = _is_enemy ? engine.enemyCards : engine.cards;
         _loc2_ = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(StringConsts.EMPTY == _loc1_[_loc2_])
            {
               _units[_loc2_].unit_icon.gotoAndStop("empty_slot_label");
               _units[_loc2_].filling.stop();
               _units[_loc2_].filling.visible = false;
               _units[_loc2_].unit_type = StringConsts.EMPTY;
            }
            else
            {
               _units[_loc2_].unit_icon.gotoAndStop(_prefix + _loc1_[_loc2_]);
               _units[_loc2_].filling.stop();
               _units[_loc2_].unit_type = _loc1_[_loc2_];
               _units[_loc2_].is_enemy = _is_enemy;
               _units[_loc2_].is_special = false;
               _units[_loc2_].buttons_holder = this;
               _button_set_goal.addButton(_units[_loc2_],_loc1_[_loc2_],engine.unitTicks(_loc1_[_loc2_],_is_enemy),false);
            }
            _loc2_++;
         }
         engine.goalSystem.add(_button_set_goal);
         _button_set_goal.resetAll();
         _loc3_ = _is_enemy ? engine.enemySpecials : engine.specials;
         _specials = [buttons_holder.special_button1,buttons_holder.special_button2,buttons_holder.special_button3];
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(StringConsts.EMPTY == _loc3_[_loc2_])
            {
               _specials[_loc2_].unit_icon.gotoAndStop("empty_slot_label");
               _specials[_loc2_].filling.stop();
               _specials[_loc2_].filling.visible = false;
               _specials[_loc2_].unit_type = StringConsts.EMPTY;
            }
            else
            {
               _specials[_loc2_].unit_icon.gotoAndStop(_prefix + _loc3_[_loc2_]);
               _specials[_loc2_].filling.stop();
               _specials[_loc2_].unit_type = _loc3_[_loc2_];
               _specials[_loc2_].is_enemy = _is_enemy;
               _specials[_loc2_].is_special = true;
               _specials[_loc2_].buttons_holder = this;
               _loc4_ = new ButtonTicksGoal(_specials[_loc2_],_loc3_[_loc2_],engine.specialTicks(_loc3_[_loc2_],_is_enemy),true);
               engine.goalSystem.add(_loc4_);
               _loc4_.reset();
               _specials[_loc2_].ticks_goal = _loc4_;
            }
            _loc2_++;
         }
         _all = _units.concat(_specials);
         updateSelection();
      }
      
      public function getCurrentButton() : *
      {
         return _all[_button_index];
      }
      
      public function moveSelectionRight() : void
      {
         _all[_button_index].unit_icon.button_back.gotoAndStop("normal_state");
         ++_button_index;
         if(_button_index >= _all.length)
         {
            _button_index = 0;
         }
         if(_all[_button_index].unit_type == StringConsts.EMPTY)
         {
            moveSelectionRight();
            return;
         }
         updateSelection();
      }
      
      public function get all() : Array
      {
         return _all;
      }
      
      public function get units() : Array
      {
         return _units;
      }
      
      public function pauseSpecials() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _specials.length)
         {
            if(_specials[_loc1_].ticks_goal)
            {
               _specials[_loc1_].ticks_goal.paused = true;
            }
            _loc1_++;
         }
      }
      
      public function moveSelectionLeft() : void
      {
         _all[_button_index].unit_icon.button_back.gotoAndStop("normal_state");
         --_button_index;
         if(_button_index < 0)
         {
            _button_index = _all.length - 1;
         }
         if(_all[_button_index].unit_type == StringConsts.EMPTY)
         {
            moveSelectionLeft();
            return;
         }
         updateSelection();
      }
      
      public function setButtonIndexOn(param1:*) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _all.length)
         {
            if(_all[_loc2_] == param1)
            {
               _all[_button_index].unit_icon.button_back.gotoAndStop("normal_state");
               _button_index = _loc2_;
            }
            _loc2_++;
         }
         updateSelection();
      }
   }
}

