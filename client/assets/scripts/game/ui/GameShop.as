package game.ui
{
   import core.Global;
   import core.common.ObjectList;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import game.SoundConsts;
   import game.StringConsts;
   import game.logic.Upgrades;
   import game.units.Unit;
   import game.units.UnitCreator;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol738")]
   public class GameShop extends MovieClip
   {
      
      private var _dragging_card:int = -1;
      
      public var card_slot1:MovieClip;
      
      public var card_slot2:MovieClip;
      
      public var card_slot3:MovieClip;
      
      public var card_slot4:MovieClip;
      
      public var card_slot6:MovieClip;
      
      public var card_slot8:MovieClip;
      
      public var kills_txt:TextField;
      
      public var card_slot5:MovieClip;
      
      public var accuracy_buy_button:SimpleButton;
      
      public var creds_txt:TextField;
      
      public var card_slot7:MovieClip;
      
      public var fire_support_buy_button:SimpleButton;
      
      public var slot_frame:MovieClip;
      
      private var upgrades_info:Upgrades = null;
      
      public var speed_building_cost_txt:TextField;
      
      private var buy_button_array:Array;
      
      public var level_msg:MovieClip;
      
      public var fire_support_cost_txt:TextField;
      
      private var current_equipment:Array = [-1,-1,-1,-1];
      
      public var speed_building_level_txt:TextField;
      
      private var card_slot_array_name:Array;
      
      public var next_battle_button:SimpleButton;
      
      public var armo_boost_cost_txt:TextField;
      
      public var armo_boost_buy_button:SimpleButton;
      
      private var number_orbital_card_slot:int = -1;
      
      public var main_menu_button:SimpleButton;
      
      public var flongabot_button:SimpleButton;
      
      private var duplicate_slot_array:Array = null;
      
      private var _dragging_duplicate:MovieClip = new MovieClip();
      
      public var ballistics_level_txt:TextField;
      
      private var flag_buy_button_load:* = 0;
      
      private var level_txt_array:Array;
      
      public var counter_attack_cost_txt:TextField;
      
      private var slot_array:Array;
      
      private var flag_delite:* = 0;
      
      public var armo_boost_level_txt:TextField;
      
      public var fire_support_level_txt:TextField;
      
      public var units_screen_txt:TextField;
      
      public var orbital_slot1:MovieClip;
      
      public var orbital_slot2:MovieClip;
      
      public var orbital_slot3:MovieClip;
      
      private var array_block:Array = [0,0,0,0,0,0,0,0];
      
      private var number_orbital_slot:int = -1;
      
      private var orbital_slot_array:Array;
      
      public var ballistics_buy_button:SimpleButton;
      
      private var card_slot_array:Array;
      
      public var accuracy_level_txt:TextField;
      
      public var accuracy_cost_txt:TextField;
      
      public var upgrades_screen_txt:TextField;
      
      public var ballistics_cost_txt:TextField;
      
      public var speed_building_buy_button:SimpleButton;
      
      private var number_buy_button:* = -1;
      
      private var orbital_block:Array = [StringConsts.EMPTY,StringConsts.EMPTY,StringConsts.EMPTY];
      
      private var array_orbital_equipmen:Array = [-1,-1,-1];
      
      private var flag_load:* = 0;
      
      public var counter_attack_buy_button:SimpleButton;
      
      public var counter_attack_level_txt:TextField;
      
      public var slot1:MovieClip;
      
      public var slot2:MovieClip;
      
      public var slot3:MovieClip;
      
      private var cost_txt_array:Array;
      
      public var slot4:MovieClip;
      
      public function GameShop()
      {
         super();
         flongabot_button.addEventListener(MouseEvent.MOUSE_DOWN,GameStage.sponsorClick);
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         flongabot_button.removeEventListener(MouseEvent.MOUSE_DOWN,GameStage.sponsorClick);
         _loc1_ = 0;
         while(_loc1_ < card_slot_array.length)
         {
            card_slot_array[_loc1_].removeEventListener(MouseEvent.MOUSE_DOWN,cardClickHandler);
            card_slot_array[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,onCardOverHandler);
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < slot_array.length)
         {
            slot_array[_loc2_].removeEventListener(MouseEvent.MOUSE_DOWN,slotClickHandler);
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < buy_button_array.length)
         {
            buy_button_array[_loc3_].removeEventListener(MouseEvent.MOUSE_DOWN,FnBuyButton);
            _loc3_++;
         }
         main_menu_button.removeEventListener(MouseEvent.MOUSE_DOWN,FnMain);
         next_battle_button.removeEventListener(MouseEvent.MOUSE_DOWN,FnNext);
         removeEventListener(MouseEvent.MOUSE_DOWN,shopClickHandler);
      }
      
      private function FnNext(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         Global.top.engine.playSound(SoundConsts.click);
         Global.top.engine.playSound(SoundConsts.menu_appear);
         _loc2_ = getEquipment();
         if(0 == _loc2_.length)
         {
            showMessage("You must be equipped with at least one unit type.");
            return;
         }
         Global.top.showLevelSelection();
      }
      
      private function cardInSlotClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(param1.currentTarget.currently_in_slot >= 0)
         {
            _loc2_ = int(param1.currentTarget.currently_in_slot);
            removeCardFromEquipment(_loc2_);
            if(_dragging_card >= 0)
            {
               setCardIntoSlot(_loc2_);
            }
         }
      }
      
      public function get orbitalWeapons() : Array
      {
         return orbital_block;
      }
      
      public function setUpgrades(param1:Upgrades) : void
      {
         upgrades_info = param1;
         param1.buyUpgrade(number_buy_button);
         updateView();
      }
      
      private function onWeaponCardOverHandler(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.slot_frame.currentLabel)
         {
            case "locked_state":
               units_screen_txt.text = "This weapon is locked. Advance through levels to unlock it.";
               break;
            case StringConsts.ARTILLERY_STRIKE:
               units_screen_txt.text = "Orbital artillery strike.\n10 bombs fall near the specified spot. It may not be very accurate.";
               break;
            case StringConsts.NUCLEAR_MISSILE:
               units_screen_txt.text = "Nuclear rocket strike.\nDamages heavily all the units on the battlefield.";
               break;
            case StringConsts.FORCE_FIELD:
               units_screen_txt.text = "Force Field.\nDefenses units that are inside the field. It does not work with Caterpillars.";
         }
      }
      
      private function showMessage(param1:String) : void
      {
         level_msg.msg.text = param1;
         level_msg.visible = true;
         level_msg.play();
      }
      
      private function stopDragCard() : void
      {
         if(_dragging_card >= 0)
         {
            _dragging_duplicate.stopDrag();
            removeChild(_dragging_duplicate);
            _dragging_card = -1;
         }
      }
      
      public function getOrbitalEquipment() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         _loc1_ = new Array();
         _loc2_ = 0;
         while(_loc2_ < array_orbital_equipmen.length)
         {
            _loc1_[_loc2_] = array_orbital_equipmen[_loc2_];
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc1_[_loc3_] == -1)
            {
               _loc1_.splice(_loc3_,1);
               _loc3_--;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function Create1() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         addEventListener(MouseEvent.MOUSE_DOWN,shopClickHandler);
         card_slot_array = [card_slot1,card_slot2,card_slot3,card_slot4,card_slot5,card_slot6,card_slot7,card_slot8];
         card_slot_array_name = [StringConsts.MARINE,StringConsts.STORM_TANK,StringConsts.MISSILE_MAN,StringConsts.VULTURE,StringConsts.MINER_DROID,StringConsts.GRENADIER_DROID,StringConsts.SPECIALIST,StringConsts.CATERPILLAR];
         slot_array = [slot1,slot2,slot3,slot4];
         duplicate_slot_array = new Array();
         duplicate_slot_array.length = slot_array.length;
         orbital_slot_array = [orbital_slot1,orbital_slot2,orbital_slot3];
         level_txt_array = [speed_building_level_txt,accuracy_level_txt,ballistics_level_txt,armo_boost_level_txt,counter_attack_level_txt,fire_support_level_txt];
         cost_txt_array = [speed_building_cost_txt,accuracy_cost_txt,ballistics_cost_txt,armo_boost_cost_txt,counter_attack_cost_txt,fire_support_cost_txt];
         buy_button_array = [speed_building_buy_button,accuracy_buy_button,ballistics_buy_button,armo_boost_buy_button,fire_support_buy_button,counter_attack_buy_button];
         if(flag_load == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < card_slot_array.length)
            {
               card_slot_array[_loc1_].addEventListener(MouseEvent.MOUSE_DOWN,cardClickHandler);
               card_slot_array[_loc1_].addEventListener(MouseEvent.MOUSE_OVER,onCardOverHandler);
               card_slot_array[_loc1_].slot_frame.gotoAndStop(_loc1_ + 1);
               _loc1_++;
            }
            _loc2_ = 0;
            while(_loc2_ < slot_array.length)
            {
               slot_array[_loc2_].addEventListener(MouseEvent.MOUSE_DOWN,slotClickHandler);
               slot_array[_loc2_].addEventListener(MouseEvent.MOUSE_OVER,onSlotOverHandler);
               slot_array[_loc2_].slot_frame.gotoAndStop(15);
               _loc2_++;
            }
            _loc3_ = 0;
            while(_loc3_ < orbital_slot_array.length)
            {
               orbital_slot_array[_loc3_].addEventListener(MouseEvent.MOUSE_OVER,onWeaponCardOverHandler);
               _loc3_++;
            }
            _loc4_ = 0;
            while(_loc4_ < buy_button_array.length)
            {
               buy_button_array[_loc4_].addEventListener(MouseEvent.MOUSE_DOWN,FnBuyButton);
               buy_button_array[_loc4_].addEventListener(MouseEvent.MOUSE_OVER,onBuyButtonOverHandler);
               _loc4_++;
            }
            main_menu_button.addEventListener(MouseEvent.MOUSE_DOWN,FnMain);
            next_battle_button.addEventListener(MouseEvent.MOUSE_DOWN,FnNext);
         }
         flag_load = 1;
         updateBlock();
         setDefaultCards();
         updateWeapons();
         level_msg.visible = false;
      }
      
      private function shopClickHandler(param1:MouseEvent) : void
      {
         if(_dragging_card >= 0)
         {
            stopDragCard();
         }
      }
      
      private function FnMain(param1:MouseEvent) : void
      {
         Global.top.engine.playSound(SoundConsts.click);
         Global.top.showWelcome();
      }
      
      private function updateWeapons() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < orbital_slot_array.length)
         {
            if(orbital_block[_loc1_] != StringConsts.EMPTY)
            {
               orbital_slot_array[_loc1_].slot_frame.gotoAndStop(orbital_block[_loc1_]);
               orbital_slot_array[_loc1_].alpha = 1;
            }
            else
            {
               orbital_slot_array[_loc1_].slot_frame.gotoAndStop("locked_state");
               orbital_slot_array[_loc1_].alpha = 0.5;
            }
            _loc1_++;
         }
      }
      
      private function onCardOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:Unit = null;
         if(param1.currentTarget.slot_frame)
         {
            _loc2_ = null;
            switch(param1.currentTarget.slot_frame.currentFrame)
            {
               case 1:
                  _loc2_ = UnitCreator.create(StringConsts.MARINE,false,true);
                  units_screen_txt.text = "Marine. Most cheap and weak unit. Best against Missile Man and Grenadier Robot.\n" + "Attack: " + _loc2_.weapon.damage.toString() + "\nArmor: " + _loc2_.armor.toString();
                  break;
               case 2:
                  _loc2_ = UnitCreator.create(StringConsts.STORM_TANK,false,true);
                  units_screen_txt.text = "Storm Tank. Best against Marine, Specialist, Grenadier and Miner robots. Strong collateral damage.\n" + "Attack: " + _loc2_.weapon.damage.toString() + "\nArmor: " + _loc2_.armor.toString();
                  break;
               case 3:
                  _loc2_ = UnitCreator.create(StringConsts.MISSILE_MAN,false,true);
                  units_screen_txt.text = "Missile Man. Long range attacking unit. Best against Storm Tank, Miner and Grenadier.\n" + "Attack: " + _loc2_.weapon.damage.toString() + "\nArmor: " + _loc2_.armor.toString();
                  break;
               case 4:
                  units_screen_txt.text = "Vulture.\nThis is a landing transport. It carries 2 Marines and 1 Missile Man to the center of the road.";
                  break;
               case 5:
                  units_screen_txt.text = "Miner Robot.\nThis unit moves along the road and mines it. The mines explode automatically near enemy units.";
                  break;
               case 6:
                  units_screen_txt.text = "Grenadier Robot.\nThis unit explodes heavily near enemy units or after being destroyed. Needs some time to be activated.";
                  break;
               case 7:
                  _loc2_ = UnitCreator.create(StringConsts.CATERPILLAR,false,true);
                  units_screen_txt.text = "Specialist. Special Forces trained to deal with the most dangerous enemies like Caterpillar.\n" + "Attack: " + _loc2_.weapon.damage.toString() + "\nArmor: " + _loc2_.armor.toString();
                  break;
               case 8:
                  _loc2_ = UnitCreator.create(StringConsts.CATERPILLAR,false,true);
                  units_screen_txt.text = "Caterpillar. Most heavy and strong unit. It has ability to pierce the Force Fields. Best against all except Specialist.\n" + "Attack: " + _loc2_.weapon.damage.toString() + "\nArmor: " + _loc2_.armor.toString();
                  break;
               case 17:
                  units_screen_txt.text = "This unit is locked. Advance through more levels to unlock it.";
            }
         }
      }
      
      private function startDragCard(param1:int) : void
      {
         var _loc2_:Class = null;
         stopDragCard();
         if(card_slot_array[param1].alpha == 1)
         {
            _dragging_card = param1;
            _loc2_ = Object(card_slot_array[_dragging_card].slot_frame).constructor;
            _dragging_duplicate = new _loc2_();
            _dragging_duplicate.gotoAndStop(_dragging_card + 1);
            _dragging_duplicate.x = mouseX + 5;
            _dragging_duplicate.y = mouseY + 5;
            _dragging_duplicate.scaleX = _dragging_duplicate.scaleY = card_slot_array[0].scaleX;
            addChild(_dragging_duplicate);
            _dragging_duplicate.startDrag();
         }
      }
      
      public function show() : void
      {
         visible = true;
         updateView();
      }
      
      public function setObritalWeapons(param1:Array) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            orbital_block[_loc2_] = param1[_loc2_];
            _loc2_++;
         }
         updateWeapons();
      }
      
      public function updateView() : void
      {
         var _loc1_:int = 0;
         upgrades_info.getUpgradeLevel();
         upgrades_info.getUpgradeCost();
         creds_txt.text = Global.top.engine.creds.toString();
         kills_txt.text = Global.top.allKills.toString();
         _loc1_ = 0;
         while(_loc1_ < upgrades_info.getUpgradeLevel().length)
         {
            level_txt_array[_loc1_].text = upgrades_info.getUpgradeLevel()[_loc1_];
            cost_txt_array[_loc1_].text = upgrades_info.getUpgradeCost()[_loc1_];
            if(upgrades_info.getUpgradeCost()[_loc1_] <= upgrades_info.getUpgradeCreds())
            {
               buy_button_array[_loc1_].alpha = 1;
            }
            else
            {
               buy_button_array[_loc1_].alpha = 0.25;
            }
            _loc1_++;
         }
      }
      
      public function Create() : void
      {
         Create1();
         updateBlock();
         setDefaultCards();
      }
      
      private function onSlotOverHandler(param1:MouseEvent) : void
      {
         units_screen_txt.text = "Place units here you want to use in the next battle.";
      }
      
      public function getAvailableUnits() : ObjectList
      {
         var _loc1_:ObjectList = null;
         var _loc2_:int = 0;
         _loc1_ = new ObjectList();
         _loc2_ = 0;
         while(_loc2_ < array_block.length)
         {
            if(array_block[_loc2_] != 0)
            {
               _loc1_.push(card_slot_array_name[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getEquipment() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         _loc1_ = new Array();
         _loc2_ = 0;
         while(_loc2_ < current_equipment.length)
         {
            if(current_equipment[_loc2_] != -1)
            {
               _loc1_.push(current_equipment[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function setDefaultCards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < current_equipment.length)
         {
            if(current_equipment[_loc1_] == -1)
            {
               _loc2_ = 0;
               while(_loc2_ < card_slot_array.length)
               {
                  if(card_slot_array[_loc2_].alpha == 1)
                  {
                     startDragCard(_loc2_);
                     setCardIntoSlot(_loc1_);
                     break;
                  }
                  _loc2_++;
               }
            }
            _loc1_++;
         }
      }
      
      private function setCardIntoSlot(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         _loc2_ = param1;
         if(current_equipment[_loc2_] != -1)
         {
            removeCardFromEquipment(_loc2_);
         }
         if(_dragging_card < 0)
         {
            return;
         }
         if(card_slot_array[_dragging_card].alpha == 1)
         {
            current_equipment[_loc2_] = card_slot_array_name[_dragging_card];
            _loc3_ = Object(card_slot_array[_dragging_card].slot_frame).constructor;
            _loc4_ = new _loc3_();
            _loc4_.gotoAndStop(_dragging_card + 1);
            _loc4_.currently_in_slot = _loc2_;
            _loc4_.parent_card_slot_number = _dragging_card;
            _loc4_.scaleX = slot_array[_loc2_].scaleX;
            _loc4_.scaleY = slot_array[_loc2_].scaleY;
            addChild(_loc4_);
            _loc4_.x = slot_array[_loc2_].x;
            _loc4_.y = slot_array[_loc2_].y;
            card_slot_array[_dragging_card].alpha = 0.5;
            _loc4_.addEventListener(MouseEvent.MOUSE_DOWN,cardInSlotClickHandler);
            duplicate_slot_array[_loc2_] = _loc4_;
            stopDragCard();
         }
      }
      
      public function updateBlock() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         stopDragCard();
         _loc1_ = current_equipment.concat();
         _loc2_ = 0;
         while(_loc2_ < duplicate_slot_array.length)
         {
            if(duplicate_slot_array[_loc2_] != null)
            {
               removeCardFromEquipment(_loc2_);
            }
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < array_block.length)
         {
            if(array_block[_loc3_] == 0)
            {
               card_slot_array[_loc3_].alpha = 0.5;
            }
            if(array_block[_loc3_] == 1)
            {
               card_slot_array[_loc3_].alpha = 1;
            }
            _loc3_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc1_.length)
         {
            if(_loc1_[_loc4_] != -1)
            {
               _loc5_ = getBlockIndexByName(_loc1_[_loc4_]);
               if(array_block[_loc5_])
               {
                  startDragCard(_loc5_);
                  setCardIntoSlot(_loc4_);
               }
            }
            _loc4_++;
         }
         updateIcons();
      }
      
      private function FnBuyButton(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         Global.top.engine.playSound(SoundConsts.click);
         number_buy_button = -1;
         _loc2_ = 0;
         while(_loc2_ < buy_button_array.length)
         {
            if(buy_button_array[_loc2_] == param1.currentTarget)
            {
               number_buy_button = _loc2_;
            }
            _loc2_++;
         }
         setUpgrades(upgrades_info);
      }
      
      public function set arrayBlock(param1:Array) : void
      {
         array_block = param1;
         updateBlock();
         setDefaultCards();
      }
      
      public function getBlockIndexByName(param1:String) : int
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < card_slot_array_name.length)
         {
            if(card_slot_array_name[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function get arrayBlock() : Array
      {
         return array_block;
      }
      
      private function slotClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         Global.top.engine.playSound(SoundConsts.click);
         _loc2_ = 0;
         while(_loc2_ < slot_array.length)
         {
            if(slot_array[_loc2_] == param1.currentTarget)
            {
               setCardIntoSlot(_loc2_);
               break;
            }
            _loc2_++;
         }
         param1.stopPropagation();
      }
      
      private function removeCardFromEquipment(param1:int) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = duplicate_slot_array[param1];
         removeChild(_loc2_);
         _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,cardInSlotClickHandler);
         card_slot_array[_loc2_.parent_card_slot_number].alpha = 1;
         duplicate_slot_array[param1] = null;
         current_equipment[param1] = -1;
      }
      
      private function updateIcons() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < card_slot_array.length)
         {
            if(0 == array_block[_loc1_])
            {
               card_slot_array[_loc1_].slot_frame.gotoAndStop("locked_state");
            }
            else
            {
               card_slot_array[_loc1_].slot_frame.gotoAndStop(_loc1_ + 1);
            }
            _loc1_++;
         }
      }
      
      private function cardClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         Global.top.engine.playSound(SoundConsts.click);
         _loc2_ = 0;
         while(_loc2_ < card_slot_array.length)
         {
            if(card_slot_array[_loc2_] == param1.currentTarget)
            {
               startDragCard(_loc2_);
               number_orbital_card_slot = -1;
               break;
            }
            _loc2_++;
         }
         param1.stopPropagation();
      }
      
      private function onBuyButtonOverHandler(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case speed_building_buy_button:
               upgrades_screen_txt.text = "Increase the speed of unit building.";
               break;
            case accuracy_buy_button:
               upgrades_screen_txt.text = "Increase the firepower of human units (increases attack). ";
               break;
            case ballistics_buy_button:
               upgrades_screen_txt.text = "Increase the firepower of robots (increases attack or explosion damage).";
               break;
            case armo_boost_buy_button:
               upgrades_screen_txt.text = "Boost the armor value of all units.";
               break;
            case fire_support_buy_button:
               upgrades_screen_txt.text = "Increase the speed of the Storm Attack preparing. ";
               break;
            case counter_attack_buy_button:
               upgrades_screen_txt.text = "Increase the speed of the Orbital Support recharging.";
         }
      }
      
      private function FnDestroy() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < card_slot_array.length)
         {
            card_slot_array[_loc1_].removeEventListener(MouseEvent.MOUSE_DOWN,cardClickHandler);
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < slot_array.length)
         {
            slot_array[_loc2_].removeEventListener(MouseEvent.MOUSE_DOWN,slotClickHandler);
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < buy_button_array.length)
         {
            buy_button_array[_loc3_].removeEventListener(MouseEvent.MOUSE_DOWN,FnBuyButton);
            _loc3_++;
         }
         main_menu_button.removeEventListener(MouseEvent.MOUSE_DOWN,FnMain);
         next_battle_button.removeEventListener(MouseEvent.MOUSE_DOWN,FnNext);
         flag_load = 0;
      }
   }
}

