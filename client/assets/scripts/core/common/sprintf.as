package core.common
{
   public function sprintf(param1:String, ... rest) : String
   {
      var _loc3_:String = null;
      var _loc4_:int = 0;
      var _loc5_:int = 0;
      var _loc6_:String = null;
      var _loc7_:* = undefined;
      var _loc8_:String = null;
      var _loc9_:Boolean = false;
      var _loc10_:Boolean = false;
      var _loc11_:Boolean = false;
      var _loc12_:Boolean = false;
      var _loc13_:Boolean = false;
      var _loc14_:Boolean = false;
      var _loc15_:Boolean = false;
      var _loc16_:String = null;
      var _loc17_:String = null;
      var _loc18_:Boolean = false;
      var _loc19_:Boolean = false;
      _loc3_ = "";
      _loc4_ = param1.length;
      _loc5_ = 0;
      while(_loc5_ < _loc4_)
      {
         _loc6_ = param1.charAt(_loc5_);
         if(_loc6_ == "%")
         {
            _loc9_ = false;
            _loc10_ = false;
            _loc11_ = false;
            _loc12_ = false;
            _loc13_ = false;
            _loc14_ = false;
            _loc15_ = false;
            _loc16_ = "";
            _loc17_ = "";
            _loc6_ = param1.charAt(++_loc5_);
            while(_loc6_ != "d" && _loc6_ != "i" && _loc6_ != "o" && _loc6_ != "u" && _loc6_ != "x" && _loc6_ != "X" && _loc6_ != "f" && _loc6_ != "F" && _loc6_ != "c" && _loc6_ != "s" && _loc6_ != "%")
            {
               if(!_loc10_)
               {
                  if(!_loc11_ && _loc6_ == "#")
                  {
                     _loc11_ = true;
                  }
                  else if(!_loc12_ && _loc6_ == "0")
                  {
                     _loc12_ = true;
                  }
                  else if(!_loc13_ && _loc6_ == "-")
                  {
                     _loc13_ = true;
                  }
                  else if(!_loc14_ && _loc6_ == " ")
                  {
                     _loc14_ = true;
                  }
                  else if(!_loc15_ && _loc6_ == "+")
                  {
                     _loc15_ = true;
                  }
                  else
                  {
                     _loc10_ = true;
                  }
               }
               if(!_loc9_ && _loc6_ == ".")
               {
                  _loc10_ = true;
                  _loc9_ = true;
                  _loc6_ = param1.charAt(++_loc5_);
               }
               else
               {
                  if(_loc10_)
                  {
                     if(!_loc9_)
                     {
                        _loc16_ += _loc6_;
                     }
                     else
                     {
                        _loc17_ += _loc6_;
                     }
                  }
                  _loc6_ = param1.charAt(++_loc5_);
               }
            }
            switch(_loc6_)
            {
               case "d":
               case "i":
                  _loc7_ = rest.shift();
                  _loc8_ = String(Math.abs(int(_loc7_)));
                  if(_loc17_ != "")
                  {
                     _loc8_ = leftPad(_loc8_,int(_loc17_),"0");
                  }
                  if(int(_loc7_) < 0)
                  {
                     _loc8_ = "-" + _loc8_;
                  }
                  else if(_loc15_ && int(_loc7_) >= 0)
                  {
                     _loc8_ = "+" + _loc8_;
                  }
                  if(_loc16_ != "")
                  {
                     if(_loc13_)
                     {
                        _loc8_ = rightPad(_loc8_,int(_loc16_));
                     }
                     else if(_loc12_ && _loc17_ == "")
                     {
                        _loc8_ = leftPad(_loc8_,int(_loc16_),"0");
                     }
                     else
                     {
                        _loc8_ = leftPad(_loc8_,int(_loc16_));
                     }
                  }
                  _loc3_ += _loc8_;
                  break;
               case "o":
                  _loc7_ = rest.shift();
                  _loc8_ = uint(_loc7_).toString(8);
                  if(_loc11_ && _loc8_ != "0")
                  {
                     _loc8_ = "0" + _loc8_;
                  }
                  if(_loc17_ != "")
                  {
                     _loc8_ = leftPad(_loc8_,int(_loc17_),"0");
                  }
                  if(_loc16_ != "")
                  {
                     if(_loc13_)
                     {
                        _loc8_ = rightPad(_loc8_,int(_loc16_));
                     }
                     else if(_loc12_ && _loc17_ == "")
                     {
                        _loc8_ = leftPad(_loc8_,int(_loc16_),"0");
                     }
                     else
                     {
                        _loc8_ = leftPad(_loc8_,int(_loc16_));
                     }
                  }
                  _loc3_ += _loc8_;
                  break;
               case "u":
                  _loc7_ = rest.shift();
                  _loc8_ = uint(_loc7_).toString(10);
                  if(_loc17_ != "")
                  {
                     _loc8_ = leftPad(_loc8_,int(_loc17_),"0");
                  }
                  if(_loc16_ != "")
                  {
                     if(_loc13_)
                     {
                        _loc8_ = rightPad(_loc8_,int(_loc16_));
                     }
                     else if(_loc12_ && _loc17_ == "")
                     {
                        _loc8_ = leftPad(_loc8_,int(_loc16_),"0");
                     }
                     else
                     {
                        _loc8_ = leftPad(_loc8_,int(_loc16_));
                     }
                  }
                  _loc3_ += _loc8_;
                  break;
               case "X":
                  _loc18_ = true;
               case "x":
                  _loc7_ = rest.shift();
                  _loc8_ = uint(_loc7_).toString(16);
                  if(_loc17_ != "")
                  {
                     _loc8_ = leftPad(_loc8_,int(_loc17_),"0");
                  }
                  _loc19_ = _loc11_ && uint(_loc7_) != 0;
                  if(_loc16_ != "" && !_loc13_ && _loc12_ && _loc17_ == "")
                  {
                     _loc8_ = leftPad(_loc8_,_loc19_ ? int(int(_loc16_) - 2) : int(_loc16_),"0");
                  }
                  if(_loc19_)
                  {
                     _loc8_ = "0x" + _loc8_;
                  }
                  if(_loc16_ != "")
                  {
                     if(_loc13_)
                     {
                        _loc8_ = rightPad(_loc8_,int(_loc16_));
                     }
                     else
                     {
                        _loc8_ = leftPad(_loc8_,int(_loc16_));
                     }
                  }
                  if(_loc18_)
                  {
                     _loc8_ = _loc8_.toUpperCase();
                  }
                  _loc3_ += _loc8_;
                  break;
               case "f":
               case "F":
                  _loc7_ = rest.shift();
                  _loc8_ = Math.abs(Number(_loc7_)).toFixed(_loc17_ != "" ? int(_loc17_) : 6);
                  if(int(_loc7_) < 0)
                  {
                     _loc8_ = "-" + _loc8_;
                  }
                  else if(_loc15_ && int(_loc7_) >= 0)
                  {
                     _loc8_ = "+" + _loc8_;
                  }
                  if(_loc11_ && _loc8_.indexOf(".") == -1)
                  {
                     _loc8_ += ".";
                  }
                  if(_loc16_ != "")
                  {
                     if(_loc13_)
                     {
                        _loc8_ = rightPad(_loc8_,int(_loc16_));
                     }
                     else if(_loc12_ && _loc17_ == "")
                     {
                        _loc8_ = leftPad(_loc8_,int(_loc16_),"0");
                     }
                     else
                     {
                        _loc8_ = leftPad(_loc8_,int(_loc16_));
                     }
                  }
                  _loc3_ += _loc8_;
                  break;
               case "c":
                  _loc7_ = rest.shift();
                  _loc8_ = String.fromCharCode(int(_loc7_));
                  if(_loc16_ != "")
                  {
                     if(_loc13_)
                     {
                        _loc8_ = rightPad(_loc8_,int(_loc16_));
                     }
                     else
                     {
                        _loc8_ = leftPad(_loc8_,int(_loc16_));
                     }
                  }
                  _loc3_ += _loc8_;
                  break;
               case "s":
                  _loc7_ = rest.shift();
                  _loc8_ = String(_loc7_);
                  if(_loc17_ != "")
                  {
                     _loc8_ = _loc8_.substring(0,int(_loc17_));
                  }
                  if(_loc16_ != "")
                  {
                     if(_loc13_)
                     {
                        _loc8_ = rightPad(_loc8_,int(_loc16_));
                     }
                     else
                     {
                        _loc8_ = leftPad(_loc8_,int(_loc16_));
                     }
                  }
                  _loc3_ += _loc8_;
                  break;
               case "%":
                  _loc3_ += "%";
            }
         }
         else
         {
            _loc3_ += _loc6_;
         }
         _loc5_++;
      }
      return _loc3_;
   }
}

function leftPad(param1:String, param2:int, param3:String = " "):String
{
   var _loc4_:String = null;
   if(param1.length < param2)
   {
      _loc4_ = "";
      while(_loc4_.length + param1.length < param2)
      {
         _loc4_ += param3;
      }
      return _loc4_ + param1;
   }
   return param1;
}
function rightPad(param1:String, param2:int, param3:String = " "):String
{
   while(param1.length < param2)
   {
      param1 += param3;
   }
   return param1;
}
